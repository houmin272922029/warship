local _guessingWinLayer
local _award = {}
local _message = nil

UnionFingerGuessingWinLayerOwner = UnionFingerGuessingWinLayerOwner or {}
ccb["UnionFingerGuessingWinLayerOwner"] = UnionFingerGuessingWinLayerOwner

local function closeItemClick( )

    _guessingWinLayer:removeFromParentAndCleanup(true)
end
UnionFingerGuessingWinLayerOwner["closeItemClick"] = closeItemClick

local function _setData()
    UnionFingerGuessingWinLayerOwner["winTipLabel"]:setString(_message)

    local awards = _award.items
    for k,v in pairs(awards) do
        local itemConfig = ConfigureStorage.item[k]
        local itemFrame = UnionFingerGuessingWinLayerOwner["awardItemFrame"]
        local sp = CCSprite:create("ccbResources/icons/"..itemConfig.icon..".png")
        if sp then
            itemFrame:addChild(sp, 1, 10) 
            sp:setScale(0.36)
            sp:setPosition(itemFrame:getContentSize().width / 2, itemFrame:getContentSize().height / 2)
        end
        itemFrame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("frame_"..itemConfig.rank..".png"))
        UnionFingerGuessingWinLayerOwner["awardItemName"]:setString(itemConfig.name)
        UnionFingerGuessingWinLayerOwner["awardItemDespLabel"]:setString(itemConfig.desp)
        UnionFingerGuessingWinLayerOwner["awardItemAmountLabel"]:setString(v)
    end
end

local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/UnionFingerGuessingWin.ccbi", proxy, true, "UnionFingerGuessingWinLayerOwner")
    _guessingWinLayer = tolua.cast(node, "CCLayer")
end

local function onTouchBegan(x, y)
    local menu = tolua.cast(UnionFingerGuessingWinLayerOwner["menu"], "CCMenu")
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

function createUnionFingerGuessingWinLayer( award,message )
    _init()
    _award = award
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


    _guessingWinLayer:registerScriptHandler(_layerEventHandler)
    _guessingWinLayer:registerScriptTouchHandler(onTouch ,false ,-134 ,true )
    _guessingWinLayer:setTouchEnabled(true)

    return _guessingWinLayer
end