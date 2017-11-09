local _layer
local _priority
local _type

local BUY_TYPE = {
    DUR = 1,
    DURMAX = 2,
}

WWBuyDurabilityOwner = WWBuyDurabilityOwner or {}
ccb["WWBuyDurabilityOwner"] = WWBuyDurabilityOwner

-- 关闭
local function closeItemClick()
    popUpCloseAction(WWBuyDurabilityOwner, "infoBg", _layer)
end
WWBuyDurabilityOwner["closeItemClick"] = closeItemClick


local function buyItemClick()
    local function buyCallback(url, rtnData)
        worldwardata:fromDic(rtnData.info)
        postNotification(NOTI_WW_REFRESH, nil)
    end
    if _type == BUY_TYPE.DUR then
        doActionFun("WW_BUY_DUR", {}, buyCallback)
    else
        doActionFun("WW_BUY_DURLEVEL", {}, buyCallback)
    end
    closeItemClick()
end
WWBuyDurabilityOwner["buyItemClick"] = buyItemClick

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(WWBuyDurabilityOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction(WWBuyDurabilityOwner, "infoBg", _layer)
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
    local menu = tolua.cast(WWBuyDurabilityOwner["menu"], "CCMenu")
    menu:setHandlerPriority(_priority - 1)
end

local function refresh()
    local title = tolua.cast(WWBuyDurabilityOwner["title"], "CCLabelTTF")
    title:setString(HLNSLocalizedString("ww.durability.title.".._type))

    local goldLabel = tolua.cast(WWBuyDurabilityOwner["gold"], "CCLabelTTF")
    local content = tolua.cast(WWBuyDurabilityOwner["content"], "CCLabelTTF")
    local gold = 0
    local recover = 0

    local nowLabel = tolua.cast(WWBuyDurabilityOwner["nowLabel"], "CCLabelTTF")
    nowLabel:setString(string.format("%d/%d", worldwardata.playerData.durability, worldwardata:getDurabilityMax(worldwardata.playerData.durabilityLevel)))
    local nextLabel = tolua.cast(WWBuyDurabilityOwner["nextLabel"], "CCLabelTTF")

    if _type == BUY_TYPE.DUR then
        local count = worldwardata.playerData.durabilityBuyCount
        if not count or count == "" then
            count = 0
        end
        gold = ConfigureStorage.WWDurableRecover[tostring(count + 1)].gold
        recover = 10
        
        nextLabel:setString(string.format("%d/%d", worldwardata.playerData.durability + recover, 
            worldwardata:getDurabilityMax(worldwardata.playerData.durabilityLevel)))
    else
        local nowLevel = ConfigureStorage.WWDurable[worldwardata.playerData.durabilityLevel + 1]
        local nextLevel =  ConfigureStorage.WWDurable[worldwardata.playerData.durabilityLevel + 2]
        gold = nextLevel.gold
        recover = nextLevel.durable - nowLevel.durable

        local durMax = worldwardata:getDurabilityMax(worldwardata.playerData.durabilityLevel) + recover
        local dur = worldwardata.playerData.durability
        nextLabel:setString(string.format("%d/%d", dur, durMax))
    end
    goldLabel:setString(gold)
    content:setString(HLNSLocalizedString("ww.durability.content.".._type, recover))
end

local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/WWBuyDurability.ccbi", proxy, true, "WWBuyDurabilityOwner")
    _layer = tolua.cast(node, "CCLayer")

    refresh()
end

function createWWBuyDurabilityLayer( bMax, priority )
    _type = bMax and BUY_TYPE.DURMAX or BUY_TYPE.DUR
    _priority = (priority ~= nil) and priority or -132

    _init()

    local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
    _layer:runAction(seq)

    local function _onEnter()
        popUpUiAction(WWBuyDurabilityOwner, "infoBg")
    end

    local function _onExit()
        _priority = -132
        _type = BUY_TYPE.DUR
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