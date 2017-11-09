local _layer
local _priority
local _islandId
local _data
local _shopData

WWExplorePopupOwner = WWExplorePopupOwner or {}
ccb["WWExplorePopupOwner"] = WWExplorePopupOwner


-- 关闭
local function closeItemClick()
    popUpCloseAction(WWExplorePopupOwner, "infoBg", _layer)
end
WWExplorePopupOwner["closeItemClick"] = closeItemClick


local function refreshTime()
    if _shopData then
        for i=1,8 do
            local dic = _shopData[i]
            if dic then
                local cd = math.max(0, dic.endTime - userdata.loginTime)
                local time = tolua.cast(WWExplorePopupOwner["time"..i], "CCLabelTTF")
                time:setString(DateUtil:second2hms(cd))
            end
        end
    end
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(WWExplorePopupOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction(WWExplorePopupOwner, "infoBg", _layer)
        return true
    end
    return true
end

local function onTouch(eventType, x, y)
    if eventType == "began" then   
        return onTouchBegan(x, y)
    end
end

-- 修改 按钮优先级
local function setMenuPriority()
    for i=1,8 do
        local menu = tolua.cast(WWExplorePopupOwner["menu"..i], "CCMenu")
        menu:setHandlerPriority(_priority - 1)
    end
    local menu = tolua.cast(WWExplorePopupOwner["menu"], "CCMenu")
    menu:setHandlerPriority(_priority - 1)
end

local function refresh()
    _islandId = worldwardata.playerData.islandId
    local title = tolua.cast(WWExplorePopupOwner["title"], "CCLabelTTF")
    title:setString(worldwardata:getIslandName(_islandId))

    local exploreData = worldwardata.playerData.exploreData
    if exploreData and exploreData[_islandId] then
        _data = exploreData[_islandId]
    else
        _data = nil
    end
    local max = ConfigureStorage.WWIsland[_islandId].treasure2
    local count = max
    local goldCost = 0
    local buyCount = 0
    if _data and _data.count then
        count = math.max(_data.count, 0)
    end
    if _data and _data.buyCount then
        buyCount = _data.buyCount
    end
    if ConfigureStorage.WWExplore[tostring(buyCount + 1)] then
        goldCost = ConfigureStorage.WWExplore[tostring(buyCount + 1)].gold
    else
        goldCost = ConfigureStorage.WWExplore[tostring(table.getTableCount(ConfigureStorage.WWExplore))].gold
    end
    local countLabel = tolua.cast(WWExplorePopupOwner["count"], "CCLabelTTF")
    countLabel:setString(string.format("%d/%d", count, max))
    countLabel:setVisible(true)

    local itemCount = wareHouseData:getItemCountById("itemcamp_008")

    local goldIcon = tolua.cast(WWExplorePopupOwner["goldIcon"], "CCSprite")
    local goldLabel = tolua.cast(WWExplorePopupOwner["gold"], "CCLabelTTF")
    local cursorIcon = tolua.cast(WWExplorePopupOwner["cursorIcon"], "CCSprite")
    local cursorLabel = tolua.cast(WWExplorePopupOwner["cursor"], "CCLabelTTF")
    goldIcon:setVisible(count <= 0 and itemCount <= 0)
    goldLabel:setVisible(count <= 0 and itemCount <= 0)
    goldLabel:setString(goldCost)
    cursorIcon:setVisible(count <= 0 and itemCount > 0)
    cursorLabel:setVisible(count <= 0 and itemCount > 0)
    
    local function getShopData()
        local array = {} 
        if not _data or not _data.shops then
            return array
        end
        for k,v in pairs(_data.shops) do
            local dic = deepcopy(v)
            dic.sid = k
            table.insert(array, dic)
        end
        local function sortFun(a, b)
            return a.endTime < b.endTime 
        end
        table.sort(array, sortFun)
        return array
    end
    _shopData = getShopData()
    for i=1,8 do
        local dic = _shopData[i]
        local shop = tolua.cast(WWExplorePopupOwner["shop"..i], "CCLayer")
        local menu = tolua.cast(WWExplorePopupOwner["menu"..i], "CCMenu")
        if dic then
            shop:setVisible(true)
            menu:setVisible(true)
            local shopItem = tolua.cast(WWExplorePopupOwner["shopItem"..i], "CCMenuItem")
            local shopId = dic.shopId
            local conf = ConfigureStorage.WWShopCfg[shopId]
            shopItem:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("%s_0.png", conf.icon)))
            shopItem:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("%s_1.png", conf.icon)))
            shopItem:setTag(i)
            local name = tolua.cast(WWExplorePopupOwner["name"..i], "CCLabelTTF")
            name:setString(conf.name)
        else
            shop:setVisible(false)
            menu:setVisible(false)
        end
    end
    refreshTime()
end

local function shopItemClick(tag)
    local dic = _shopData[tag]
    local cd = math.max(0, dic.endTime - userdata.loginTime)
    if cd == 0 then
        ShowText(HLNSLocalizedString("ww.shop.close"))
        return  
    end
    getMainLayer():getParent():addChild(createWWShopLayer(dic, _priority - 2))
end
WWExplorePopupOwner["shopItemClick"] = shopItemClick

local function exploreItemClick()
    local function callback(url, rtnData)
        worldwardata:fromDic(rtnData.info)
        userdata:showGainText(rtnData.info.gain)
        postNotification(NOTI_WW_REFRESH, nil)
    end
    doActionFun("WW_EXPLORE", {}, callback)
end
WWExplorePopupOwner["exploreItemClick"] = exploreItemClick

local function helpItemClick()
    local array = {}
    for i,v in ipairs(ConfigureStorage.WWHelp2) do
        table.insert(array, v.desp)
    end
    getMainLayer():getParent():addChild(createCommonHelpLayer(array, _priority - 2))
end
WWExplorePopupOwner["helpItemClick"] = helpItemClick


local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/WWExplorePopup.ccbi", proxy, true, "WWExplorePopupOwner")
    _layer = tolua.cast(node, "CCLayer")

    refresh()
end

function createWWExploreLayer(priority)
    _priority = (priority ~= nil) and priority or -132

    _init()

    local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
    _layer:runAction(seq)

    local function _onEnter()
        addObserver(NOTI_TICK, refreshTime)
        addObserver(NOTI_WW_REFRESH, refresh)
        popUpUiAction(WWExplorePopupOwner, "infoBg")
    end

    local function _onExit()
        removeObserver(NOTI_TICK, refreshTime)
        removeObserver(NOTI_WW_REFRESH, refresh)
        _priority = -132
        _layer = nil
        _islandId = nil
        _data = nil
        _shopData = nil
    end

    --onEnter onExit
    local function _layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        end
    end

    _layer:registerScriptTouchHandler(onTouch, false, _priority, true)
    _layer:setTouchEnabled(true)
    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end