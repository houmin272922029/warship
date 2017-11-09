local _layer
local _page = 1
local _totalPage = 1

-- 名字不要重复
WWIslandOwner = WWIslandOwner or {}
ccb["WWIslandOwner"] = WWIslandOwner

local function refreshTime()
    local moveCD = tolua.cast(WWIslandOwner["moveCD"], "CCLabelTTF")
    local settle = worldwardata:getSettleCD()
    moveCD:setString(DateUtil:second2hms(settle))
    
    local moveItem = tolua.cast(WWIslandOwner["moveItem"], "CCMenuItem")
    moveItem:setVisible(worldwardata:bCanSettle())

    local scout = tolua.cast(WWIslandOwner["scout"], "CCLabelTTF")
    local scoutCD = worldwardata:getScoutCD(worldwardata.island.islandId)
    scout:setString(DateUtil:second2hms(scoutCD))

    local scoutItem = tolua.cast(WWIslandOwner["scoutItem"], "CCMenuItem")
    scoutItem:setVisible(scoutCD == 0)

    for i=1,9 do
        local proBg = tolua.cast(WWIslandOwner["proBg"..i], "CCSprite")
        local durability0 = tolua.cast(WWIslandOwner[string.format("durability_%d_0", i)], "CCLabelTTF")
        local durability1 = tolua.cast(WWIslandOwner[string.format("durability_%d_1", i)], "CCLabelTTF")
        if scoutCD == 0 then
            proBg:setVisible(false)
            durability0:setVisible(false)
            durability1:setVisible(false)
        else
            local dic = nil
            if worldwardata.island.members then
                dic = worldwardata.island.members[tostring(i - 1)]
            end
            proBg:setVisible(dic ~= nil and dic ~= "")
            durability0:setVisible(dic ~= nil and dic ~= "")
            durability1:setVisible(dic ~= nil and dic ~= "")
        end
    end
end

local function refresh()
    local function setString(key, str)
        local label = tolua.cast(WWIslandOwner[key], "CCLabelTTF")
        label:setString(str)
    end
    setString("name", userdata.name)
    setString("level", string.format("LV:%d", userdata.level))
    setString("durability", string.format("%d/%d", worldwardata.playerData.durability, worldwardata:getDurabilityMax(worldwardata.playerData.durabilityLevel)))
    setString("brave", worldwardata.playerData.courage)
    setString("islandName", worldwardata:getIslandName(worldwardata.island.islandId))

    local badge = tolua.cast(WWIslandOwner["badge"], "CCSprite")
    if worldwardata.island.country and worldwardata.island.country ~= "" then
        local index = tonumber(string.split(worldwardata.island.country, "_")[2])
        setString("groupName", HLNSLocalizedString(string.format("ww.group.%d", index)))
        local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("badge_%d.png", index))
        badge:setDisplayFrame(frame)
        badge:setVisible(true)
    else
        setString("groupName", HLNSLocalizedString("ww.island.empty"))
        badge:setVisible(false)
    end

    local pageLabel = tolua.cast(WWIslandOwner["page"], "CCLabelTTF")

    _page = worldwardata.island.pageNow
    _totalPage = worldwardata.island.pageAll

    pageLabel:setString(string.format("%d/%d", _page, _totalPage))

    local vip = tolua.cast(WWIslandOwner["vip"], "CCSprite")
    vip:setVisible(true)
    vip:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("VIP_%d.png", vipdata:getVipLevel())))
    for i=1,9 do
        local color = worldwardata.island.country == worldwardata.playerData.countryId and ccc3(255, 255, 255) or ccc3(255, 0 , 0)
        local info = tolua.cast(WWIslandOwner["info"..i], "CCSprite")
        local ship = tolua.cast(WWIslandOwner["ship"..i], "CCSprite")
        local job = tolua.cast(WWIslandOwner["job"..i], "CCSprite")
        local dic = nil
        if worldwardata.island.members then
            dic = worldwardata.island.members[tostring(i - 1)]
        end
        info:setVisible(dic ~= nil and dic ~= "")
        ship:setVisible(dic ~= nil and dic ~= "")
        job:setVisible(false)
        if dic and dic ~= "" then
            color = dic.id == userdata.userId and ccc3(255, 255, 0) or color
            local name = tolua.cast(WWIslandOwner["name"..i], "CCLabelTTF")
            name:setString(dic.name)
            name:setColor(color)
            local level = tolua.cast(WWIslandOwner["level"..i], "CCLabelTTF")
            level:setString(string.format("LV:%d", dic.level))
            level:setColor(color)
            local vip = tolua.cast(WWIslandOwner["vip"..i], "CCSprite")
            vip:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("VIP_%d.png", dic.vip)))
            for j=0,1 do
                local durability = tolua.cast(WWIslandOwner[string.format("durability_%d_%d", i, j)], "CCLabelTTF")
                durability:setString(string.format("%d/%d", dic.durability, worldwardata:getDurabilityMax(dic.durabilityLevel)))
            end

            local proBg = tolua.cast(WWIslandOwner["proBg"..i], "CCSprite")
            local progress = proBg:getChildByTag(101)
            if progress then
                progress:removeFromParentAndCleanup(true)
                progress = nil
            end
            progress = CCProgressTimer:create(CCSprite:create("images/d_pro.png"))
            progress:setType(kCCProgressTimerTypeBar)
            progress:setMidpoint(CCPointMake(0, 0))
            progress:setBarChangeRate(CCPointMake(1, 0))
            progress:setPosition(proBg:getContentSize().width / 2, proBg:getContentSize().height / 2)
            proBg:addChild(progress, 0, 101)
            progress:setPercentage(dic.durability / worldwardata:getDurabilityMax(dic.durabilityLevel) * 100)
            ship:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(worldwardata:getShipIcon(dic.durabilityLevel, worldwardata.island.country)))

            if dic.leaderKey and dic.leaderKey ~= "" then
                local jlv = ConfigureStorage.WWJob[dic.leaderKey + 1].level
                job:setVisible(true)
                job:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("job%d.png", jlv)))
            else
                job:setVisible(false)
            end
        end
    end
    
    local exploreItem = tolua.cast(WWIslandOwner["exploreItem"], "CCMenuItem")
    local conf = ConfigureStorage.WWIsland[worldwardata.island.islandId]
    exploreItem:setVisible(tonumber(conf.type) ~= 1 and worldwardata.island.islandId == worldwardata.playerData.islandId)

    local dispatchItem = tolua.cast(WWIslandOwner["dispatchItem"], "CCMenuItem")
    local leaderKey = worldwardata.playerData.leaderKey
    if worldwardata.island.country == worldwardata.playerData.countryId and worldwardata.island.islandId == worldwardata.playerData.islandId
     and leaderKey and leaderKey ~= "" then
        dispatchItem:setVisible(true)
    else
        dispatchItem:setVisible(false)
    end

    refreshTime()
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/WWIslandView.ccbi", proxy, true,"WWIslandOwner")
    _layer = tolua.cast(node,"CCLayer")

    refresh()
end

local function scoutItemClick()
    local function cardConfirmAction()
        local function scoutCallback(url, rtnData)
            local data = rtnData.info
            local dic = {["playerData"] = data.playerData, ["island"] = data.islandData}
            worldwardata:fromDic(dic)
            refresh()
        end
        doActionFun("WW_SCOUT", {string.format(worldwardata.island.islandId)}, scoutCallback)
    end
    local function cardCancelAction()
        
    end
    local text = HLNSLocalizedString("ww.island.scout.tips", ConfigureStorage.WWItemUse.scout.cost)
    getMainLayer():getParent():addChild(createSimpleConfirCardLayer(text), 100)
    SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
    SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction
end
WWIslandOwner["scoutItemClick"] = scoutItemClick

local function moveItemClick()
    local function settleCallback(url, rtnData)
        local data = rtnData.info
        local dic = {["playerData"] = data.playerData, ["island"] = data.islandData}
        worldwardata:fromDic(dic)
        refresh()
    end
    local settle = worldwardata:getSettleCD()
    if settle == 0 then
        doActionFun("WW_SETTLE", {string.format(worldwardata.island.islandId)}, settleCallback)
    else
        getMainLayer():getParent():addChild(createWWUseItemLayer(1, -133))
    end
end
WWIslandOwner["moveItemClick"] = moveItemClick

local function backItemClick()
    getMainLayer():gotoWorldWar()
end
WWIslandOwner["backItemClick"] = backItemClick

local function exploreItemClick()
    getMainLayer():getParent():addChild(createWWExploreLayer(-133))
end
WWIslandOwner["exploreItemClick"] = exploreItemClick


local function getIslandDataCallback(url, rtnData)
    local data = rtnData.info
    local dic = {["playerData"] = data.playerData, ["island"] = data.islandData}
    worldwardata:fromDic(dic)
    refresh()
end

local function llItemClick()
    if _page == 1 then
        return
    end 
    doActionFun("WW_GET_ISLANDDATA", {worldwardata.island.islandId, 1}, getIslandDataCallback)
end
WWIslandOwner["llItemClick"] = llItemClick

local function lItemClick()
    if _page == 1 then
        return
    end
    doActionFun("WW_GET_ISLANDDATA", {worldwardata.island.islandId, _page - 1}, getIslandDataCallback)
end
WWIslandOwner["lItemClick"] = lItemClick

local function rItemClick()
    if _page == _totalPage then
        return
    end
    doActionFun("WW_GET_ISLANDDATA", {worldwardata.island.islandId, _page + 1}, getIslandDataCallback)
end
WWIslandOwner["rItemClick"] = rItemClick

local function rrItemClick()
    if _page == _totalPage then
        return
    end
    doActionFun("WW_GET_ISLANDDATA", {worldwardata.island.islandId, _totalPage}, getIslandDataCallback)
end
WWIslandOwner["rrItemClick"] = rrItemClick

local function dockItemClick(tag)

    local dic = nil
    if worldwardata.island.members then
        dic = worldwardata.island.members[tostring(tag - 1)]
    end
    if dic then
        local index = dic.islandIndex
        local function getPlayerDataCallback(url, rtnData)
            local data = rtnData.info
            local flag = worldwardata.island.country == worldwardata.playerData.countryId -- 是否拥有该岛屿
            if flag then
                getMainLayer():getParent():addChild(createWWInfoFriendLayer(data, -133))
            else
                getMainLayer():getParent():addChild(createWWInfoEnemyLayer(data, index, -133))
            end
        end
        doActionFun("WW_GET_PLAYERDATA", {worldwardata.island.islandId, index}, getPlayerDataCallback)
    end
end
WWIslandOwner["dockItemClick"] = dockItemClick

local function addDurabilityClick()
    local dur = worldwardata.playerData.durability
    local durMax = worldwardata:getDurabilityMax(worldwardata.playerData.durabilityLevel)
    if dur < durMax then
        local count = worldwardata.playerData.durabilityBuyCount
        if not count or count == "" then
            count = 0
        end
        if not ConfigureStorage.WWDurableRecover[tostring(count + 1)] then
            ShowText(HLNSLocalizedString("ww.text.4"))
            return
        end
    else
        local nextLevel =  ConfigureStorage.WWDurable[worldwardata.playerData.durabilityLevel + 2]
        if not nextLevel then
            ShowText(HLNSLocalizedString("ww.text.5"))
            return
        end
        if nextLevel.vip > vipdata:getVipLevel() then
            ShowText(HLNSLocalizedString("ww.text.6", nextLevel.vip))
            return
        end
    end
    getMainLayer():getParent():addChild(createWWBuyDurabilityLayer(dur >= durMax, -133))
end
WWIslandOwner["addDurabilityClick"] = addDurabilityClick

local function dispatchItemClick()
    local function callback(url, rtnData)
        local array = {}
        for k,v in pairs(rtnData.info.islandData.members) do
            table.insert(array, v)
        end
        local function sortFun(a, b)
            return a.score > b.score 
        end
        table.sort(array, sortFun)
        getMainLayer():getParent():addChild(createWWDistributeLayer(array, -133))
    end
    doActionFun("WW_GET_MEMBERS_BASE", {}, callback)
end
WWIslandOwner["dispatchItemClick"] = dispatchItemClick

-- 该方法名字每个文件不要重复
function getWWIslandLayer()
	return _layer
end

function createWWIslandLayer()
    _init()

    local function _onEnter()
        addObserver(NOTI_TICK, refreshTime)
        addObserver(NOTI_WW_REFRESH, refresh)
    end

    local function _onExit()
        removeObserver(NOTI_TICK, refreshTime)
        removeObserver(NOTI_WW_REFRESH, refresh)
        _layer = nil
    end

    --onEnter onExit
    local function _layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        end
    end

    local function onTouch(eventType, x, y)
        if eventType == "began" then   
            return onTouchBegan(x, y)
        elseif eventType == "moved" then
        elseif eventType == "ended" then
        end
    end
    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end