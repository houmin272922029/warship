local _aniLayer
local _parent

HotBalloonAniOwner2 = HotBalloonAniOwner2 or {}
ccb["HotBalloonAniOwner2"] = HotBalloonAniOwner2

local function _init()

    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/HotBalloonAnimation2.ccbi",proxy, true,"HotBalloonAniOwner2")
    _aniLayer = tolua.cast(node,"CCLayer")
    _parent:addChild(_aniLayer,300)
end

-- 结束，移除这一层
function removeHotBalloonAnimation2()
    if _aniLayer then
        _aniLayer:stopAllActions()
        _aniLayer:removeAllChildrenWithCleanup(true)
        _aniLayer:removeFromParentAndCleanup(true)
        _aniLayer = nil
    end
end


local function onTurnWhite()
    local whiteLayer = CCLayerColor:create(ccc4(255, 255, 255, 0))
    _aniLayer:getParent():addChild(whiteLayer)
    local array = CCArray:create()
    array:addObject(CCFadeIn:create(0.25))
    local function invisibleBalckLayer()
        _aniLayer:setVisible(false)
    end
    array:addObject(CCCallFunc:create(invisibleBalckLayer))
    array:addObject(CCDelayTime:create(0.5))
    array:addObject(CCFadeOut:create(0.25))
    local function removeWhiteLayer() 
        whiteLayer:removeFromParentAndCleanup(true)
        print("removeWhiteLayer")
        removeHotBalloonAnimation2()
        
        postNotification(NOTI_HOTBALLOON_ANI_END, nil)
    end
    array:addObject(CCCallFunc:create(removeWhiteLayer))
    whiteLayer:runAction(CCSequence:create(array))
end
HotBalloonAniOwner2["onTurnWhite"] = onTurnWhite

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

local function onEnterResultAni()
    -- _aniLayer:registerScriptTouchHandler(onTouch ,false ,-130 ,true )
    -- _aniLayer:setTouchEnabled(true)
    HotBalloonAniOwner2["blackLayer"]:setVisible(true)
end
HotBalloonAniOwner2["onEnterResultAni"] = onEnterResultAni

function getHotBalloonLayer2(  )
    return _aniLayer
end

function palyHotBalloonAnimationOnNode2(node)
    _parent = node
    
    _init()

     local function _onEnter()
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

