local _aniLayer
local _parent

HotBalloonAniOwner = HotBalloonAniOwner or {}
ccb["HotBalloonAniOwner"] = HotBalloonAniOwner

local function btnClick()
    postNotification(NOTI_SHAKE_PHONE, nil)
end
HotBalloonAniOwner["btnClick"] = btnClick

local function _init()

    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/HotBalloonAnimation.ccbi",proxy, true,"HotBalloonAniOwner")
    _aniLayer = tolua.cast(node,"CCLayer")
    _parent:addChild(_aniLayer,300)

    local btnTop = tolua.cast(HotBalloonAniOwner["btnTop"], "CCMenuItem")
    local btnBottom = tolua.cast(HotBalloonAniOwner["btnBottom"], "CCMenuItem")
    btnBottom:setOpacity(0)
    btnTop:setOpacity(0)

end

-- 结束，移除这一层
function removeHotBalloonAnimation()
    if _aniLayer then
        _aniLayer:stopAllActions()
        _aniLayer:removeAllChildrenWithCleanup(true)
        _aniLayer:removeFromParentAndCleanup(true)
        _aniLayer = nil
    end
end



local function onTouchBegan(x, y)
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
    local menuBottom = tolua.cast(HotBalloonAniOwner["menuBottom"], "CCMenu")
    menuBottom:setTouchPriority(-132)
    local menuTop = tolua.cast(HotBalloonAniOwner["menuTop"], "CCMenu")
    menuTop:setTouchPriority(-132)
end

function getHotBalloonLayer()
    return _aniLayer
end

function palyHotBalloonAnimationOnNode(node)
    _parent = node
    
    _init()

    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _aniLayer:runAction(seq)
    end

    local function _onExit()
        print("hot onExit")
        _aniLayer = nil
        _parent = nil
    end

    --onEnter onExit
    local function _layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        end
    end

    _aniLayer:registerScriptHandler(_layerEventHandler)
end

