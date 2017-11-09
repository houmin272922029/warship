local _layer
local _priority
local _type

local USE_TYPE = {
    SPEEDUP = 1,
    BRAVE = 2,
    EYES = 3,
}

WWUseItemOwner = WWUseItemOwner or {}
ccb["WWUseItemOwner"] = WWUseItemOwner

-- 关闭
local function closeItemClick()
    popUpCloseAction(WWUseItemOwner, "infoBg", _layer)
end
WWUseItemOwner["closeItemClick"] = closeItemClick

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(WWUseItemOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction(WWUseItemOwner, "infoBg", _layer)
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
    local menu = tolua.cast(WWUseItemOwner["menu"], "CCMenu")
    menu:setHandlerPriority(_priority - 1)
end

local function refresh()
    local content = tolua.cast(WWUseItemOwner["content"], "CCLabelTTF")
    content:setString(HLNSLocalizedString("ww.useitem.".._type))

    local itemId
    local cost = 0
    if _type == USE_TYPE.SPEEDUP then
        itemId = "itemcamp_007"
        cost = ConfigureStorage.WWItemUse.Migrate.cost
    elseif _type == USE_TYPE.BRAVE then
        itemId = "itemcamp_001"
        local buyCount = worldwardata.playerData.courageBuyCount
        local max = table.getTableCount(ConfigureStorage.WWBrave)
        if buyCount >= max then
            cost = ConfigureStorage.WWBrave[tostring(max)].gold
        else
            cost = ConfigureStorage.WWBrave[tostring(buyCount + 1)].gold
        end
        local discount = 1
        if worldwardata.yesterdayRank and type(worldwardata.yesterdayRank) == "table" then
            for i=0,2 do
                local dic = worldwardata.yesterdayRank[tostring(i)]
                if dic and dic.countryId == worldwardata.playerData.countryId then
                    discount = ConfigureStorage.WWReward[i + 1].Courage or 1
                    break
                end
            end
        end
        cost = math.floor(cost * discount)
    elseif _type == USE_TYPE.EYES then
        -- 无眠之眼
        itemId = "item_021"
        cost = ConfigureStorage.SeaMiEyes[1].cost
    end
    local resDic = userdata:getExchangeResource(itemId)
    PrintTable(resDic)
    local frame = tolua.cast(WWUseItemOwner["frame"], "CCSprite")
    frame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", resDic.rank)))
    local icon = tolua.cast(WWUseItemOwner["icon"], "CCSprite")
    local texture = CCTextureCache:sharedTextureCache():addImage(resDic.icon)
    if texture then
        icon:setVisible(true)
        icon:setTexture(texture)
    end
    local countLabel = tolua.cast(WWUseItemOwner["count"], "CCLabelTTF")
    local count = wareHouseData:getItemCountById(itemId)
    countLabel:setString(count)
    local gold = tolua.cast(WWUseItemOwner["gold"], "CCLabelTTF")
    local goldIcon = tolua.cast(WWUseItemOwner["goldIcon"], "CCSprite")
    if count > 0 then
        goldIcon:setVisible(false)
        gold:setVisible(false)
    else
        gold:setVisible(true)
        goldIcon:setVisible(true)
        gold:setString(cost)
    end
end

local function useItemClick()
    if _type == USE_TYPE.SPEEDUP then
        local function callback(url, rtnData)
            local data = rtnData.info
            local dic = {["playerData"] = data.playerData, ["island"] = data.islandData}
            worldwardata:fromDic(dic)
            postNotification(NOTI_WW_REFRESH, nil)
            closeItemClick()
        end
        doActionFun("WW_SETTLE", {string.format(worldwardata.island.islandId)}, callback)
    elseif _type == USE_TYPE.BRAVE then
        local function callback(url, rtnData)
            worldwardata:fromDic(rtnData.info)
            postNotification(NOTI_WW_REFRESH, nil)
            closeItemClick()
        end
        doActionFun("WW_BUY_BRAVE", {}, callback)
    elseif _type == USE_TYPE.EYES then
        local function callback(url, rtnData)
            veiledSeaData:seaMistDataFromDic(rtnData["info"]["seaMist"])
            runtimeCache.veiledSeaState = veiledSeaData.data.flag
            showVeiledSea()
            closeItemClick()
        end
        doActionFun("SEALMIST_BEGIN", {}, callback)
    end
end
WWUseItemOwner["useItemClick"] = useItemClick

local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/WWUseItem.ccbi", proxy, true, "WWUseItemOwner")
    _layer = tolua.cast(node, "CCLayer")

    refresh()
end

function createWWUseItemLayer(type, priority)
    _type = type
    _priority = (priority ~= nil) and priority or -132

    _init()

    local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
    _layer:runAction(seq)

    local function _onEnter()
        popUpUiAction(WWUseItemOwner, "infoBg")
    end

    local function _onExit()
        _priority = -132
        _type = USE_TYPE.SPEEDUP
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

    _layer:registerScriptTouchHandler(onTouch, false, _priority, true)
    _layer:setTouchEnabled(true)
    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end