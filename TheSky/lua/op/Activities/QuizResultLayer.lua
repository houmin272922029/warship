local _layer
local _priority = -132
local _data
local _key
local _bType

-- 名字不要重复
QuizResultOwner = QuizResultOwner or {}
ccb["QuizResultOwner"] = QuizResultOwner

local function closeItemClick()
    popUpCloseAction(QuizResultOwner, "infoBg", _layer )
end
QuizResultOwner["closeItemClick"] = closeItemClick

local function _refreshData()
    local name = tolua.cast(QuizResultOwner["name"], "CCLabelTTF")
    if _key == "draw" then
        name:setString(HLNSLocalizedString("quiz.draw"))
    else
        name:setString(_data[_key].name)
    end
    local bet = tolua.cast(QuizResultOwner["bet"], "CCLabelTTF")
    bet:setString(_data.guessLogs[_key][_bType])
    local gains = tolua.cast(QuizResultOwner["gains"], "CCLabelTTF")
    gains:setString(math.floor(_data.guessLogs[_key][_bType] * _data[_key].odds))
    for i=1,2 do
        local icon = tolua.cast(QuizResultOwner["icon"..i], "CCSprite")
        if _bType == "gold" then
            icon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("gold.png"))
        else
            icon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("berry.png"))
        end
    end
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/QuizResultView.ccbi", proxy, true,"QuizResultOwner")
    _layer = tolua.cast(node,"CCLayer")
    _refreshData()
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(QuizResultOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction(QuizResultOwner, "infoBg", _layer)
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
    local menu = tolua.cast(QuizResultOwner["menu"], "CCMenu")
    menu:setTouchPriority(_priority - 2)
end

function getQuizResultLayer()
	return _layer
end

function createQuizResultLayer(data, key, bType, priority)
    _data = data
    _bType = bType
    _key = key
    _priority = (priority ~= nil) and priority or -132
    _init()

    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)

        popUpUiAction(QuizResultOwner, "infoBg")
    end

    local function _onExit()
        _layer = nil
        _priority = nil
        _data = nil
    end

    --onEnter onExit
    local function _layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        end
    end


    _layer:registerScriptTouchHandler(onTouch ,false , _priority ,true )
    _layer:setTouchEnabled(true)
    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end