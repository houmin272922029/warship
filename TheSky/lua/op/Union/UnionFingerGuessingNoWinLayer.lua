local _guessingNoWinLayer
local _message = nil
local _status = status

UnionFingerGuessingNoWinLayerOwner = UnionFingerGuessingNoWinLayerOwner or {}
ccb["UnionFingerGuessingNoWinLayerOwner"] = UnionFingerGuessingNoWinLayerOwner

local function closeItemClick( )

    _guessingNoWinLayer:removeFromParentAndCleanup(true)

end
UnionFingerGuessingNoWinLayerOwner["closeItemClick"] = closeItemClick

local function _setData()
    if _status == 1 then 
        UnionFingerGuessingNoWinLayerOwner["loseTip"]:setString(HLNSLocalizedString("请再接再厉"))
        UnionFingerGuessingNoWinLayerOwner["confirmText"]:setVisible(false)
        UnionFingerGuessingNoWinLayerOwner["titleLabel"]:setString(HLNSLocalizedString("你输了"))
    else      
        UnionFingerGuessingNoWinLayerOwner["loseTip"]:setString(HLNSLocalizedString("请再次出拳"))
        UnionFingerGuessingNoWinLayerOwner["closeText"]:setVisible(false)
        UnionFingerGuessingNoWinLayerOwner["titleLabel"]:setString(HLNSLocalizedString("平手了"))
    end

    UnionFingerGuessingNoWinLayerOwner["resultTip"]:setString(_message)
end

local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/UnionFingerGuessingNoWin.ccbi", proxy, true, "UnionFingerGuessingNoWinLayerOwner")
    _guessingNoWinLayer = tolua.cast(node, "CCLayer")
end

local function onTouchBegan(x, y)
    local menu = tolua.cast(UnionFingerGuessingNoWinLayerOwner["menu"], "CCMenu")
    menu:setHandlerPriority( -135 )
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

function createUnionFingerGuessingNoWinLayer( status,message )
    _init()
    _status = status
    _message = message
    _setData()

    local function _onEnter()

    end

    local function _onExit()
        print("onExit")
        _guessingWinLayer = nil
    end

    --onEnter onExit
    local function _layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        end
    end


    _guessingNoWinLayer:registerScriptHandler(_layerEventHandler)
    _guessingNoWinLayer:registerScriptTouchHandler(onTouch ,false ,-134 ,true )
    _guessingNoWinLayer:setTouchEnabled(true)

    return _guessingNoWinLayer
end