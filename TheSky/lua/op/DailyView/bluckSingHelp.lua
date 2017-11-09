local _layer = nil
local _priority = -160

DailyBluckSingHelpOwner = DailyBluckSingHelpOwner or {}
ccb["DailyBluckSingHelpOwner"] = DailyBluckSingHelpOwner

local function closeItemClick()
    _layer:removeFromParentAndCleanup(true)
end
DailyBluckSingHelpOwner["closeItemClick"] = closeItemClick

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(DailyBluckSingHelpOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        _layer:removeFromParentAndCleanup(true)
        return true
    end
    return true
end

local function onTouchEnded(x, y)

end

local function onTouch(eventType, x, y)
    if eventType == "began" then   
        return onTouchBegan(x, y)
    elseif eventType == "moved" then
    else
        return onTouchEnded(x, y)
    end
end

local function setMenuPriority()
    local menu = tolua.cast(DailyBluckSingHelpOwner["closeMenu"], "CCMenu")
    menu:setHandlerPriority(_priority - 1)
end


function createBluckSingHelp()   
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/DailyBluckSingHelp.ccbi",proxy,true,"DailyBluckSingHelpOwner")
    _layer = tolua.cast(node,"CCLayer")

    _priority = (priority ~= nil) and priority or -160

    local function _bgLayerOnEnter()
         local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
    end

    local function _bgLayerOnExit()
        _layer = nil
        _priority = -160
    end

    --onEnter onExit
    local function layerEventHandler(eventType)
        if eventType == "enter" then
            if _bgLayerOnEnter then _bgLayerOnEnter() end
        elseif eventType == "exit" then
            if _bgLayerOnExit then _bgLayerOnExit() end
        end
    end

    _layer:registerScriptTouchHandler(onTouch ,false ,_priority ,true )
    _layer:setTouchEnabled(true)
    _layer:registerScriptHandler(layerEventHandler)
    
    return _layer
end



