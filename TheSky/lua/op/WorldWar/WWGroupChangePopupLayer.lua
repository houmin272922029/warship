local _layer
local _priority
local _campId

WWGroupChangePopupOwner = WWGroupChangePopupOwner or {}
ccb["WWGroupChangePopupOwner"] = WWGroupChangePopupOwner


-- 关闭
local function closeItemClick()
    popUpCloseAction(WWGroupChangePopupOwner, "infoBg", _layer)
end
WWGroupChangePopupOwner["closeItemClick"] = closeItemClick

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(WWGroupChangePopupOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction(WWGroupChangePopupOwner, "infoBg", _layer)
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
    local menu = tolua.cast(WWGroupChangePopupOwner["menu"], "CCMenu")
    menu:setHandlerPriority(_priority - 1)
end

local function refresh()
    local tips1 = tolua.cast(WWGroupChangePopupOwner["tips1"], "CCLabelTTF")
    local now = tonumber(string.split(worldwardata.playerData.countryId, "_")[2])
    local change = tonumber(string.split(_campId, "_")[2])
    tips1:setString(HLNSLocalizedString("ww.group.change.popup.tips.1", HLNSLocalizedString("ww.group."..now), HLNSLocalizedString("ww.group."..change)))

    local tips2 = tolua.cast(WWGroupChangePopupOwner["tips2"], "CCLabelTTF")

    local rank = worldwardata.yesterdayRank["0"].countryId
    if worldwardata.playerData.countryId == rank then
        -- 强阵营免费
        tips2:setString(HLNSLocalizedString("ww.group.change.popup.tips.3"))
    else
        -- 消耗
        local itemId = ConfigureStorage.WWItemUse.Change.itemId 
        local amount = ConfigureStorage.WWItemUse.Change.amount
        local gold = ConfigureStorage.WWItemUse.Change.cost
        local str
        if wareHouseData:getItemCountById(itemId) >= amount then
            local resDic = userdata:getExchangeResource(itemId)
            str = string.format("%s×%d", resDic.name, amount)
        else
            str = HLNSLocalizedString("gain.gold", gold)
        end
        tips2:setString(HLNSLocalizedString("ww.group.change.popup.tips.2", str))
    end

    local badge = tolua.cast(WWGroupChangePopupOwner["badge"], "CCSprite")
    local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("badge_%d.png", change))
    badge:setDisplayFrame(frame)
    local name = tolua.cast(WWGroupChangePopupOwner["name"], "CCLabelTTF")
    name:setString(HLNSLocalizedString("ww.group."..change))
end

local function confirmItemClick()
    local function callback(url, rtnData)
        worldwardata:fromDic(rtnData.info)
        postNotification(NOTI_WW_REFRESH, nil)
        closeItemClick()
    end
    doActionFun("WW_CHANGE_GROUP", {_campId}, callback)
end
WWGroupChangePopupOwner["confirmItemClick"] = confirmItemClick

local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/WWGroupChangePopup.ccbi", proxy, true, "WWGroupChangePopupOwner")
    _layer = tolua.cast(node, "CCLayer")

    refresh()
end

function createWWGroupChangePopupLayer(campId, priority)
    _campId = campId
    _priority = (priority ~= nil) and priority or -132

    _init()

    local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
    _layer:runAction(seq)

    local function _onEnter()
        popUpUiAction(WWGroupChangePopupOwner, "infoBg")
    end

    local function _onExit()
        _priority = -132
        _campId = nil
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