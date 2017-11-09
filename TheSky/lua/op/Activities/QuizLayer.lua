local _layer
local _priority = -132
local _data

-- 名字不要重复
QuizOwner = QuizOwner or {}
ccb["QuizOwner"] = QuizOwner

local function closeItemClick()
    popUpCloseAction(QuizOwner, "infoBg", _layer )
end
QuizOwner["closeItemClick"] = closeItemClick

local function quizItemClick()
    getMainLayer():getParent():addChild(createQuizChooseLayer(_data, _priority - 2), 206)
end
QuizOwner["quizItemClick"] = quizItemClick

local function historyItemClick()
    getMainLayer():getParent():addChild(createQuizListLayer(_data, _priority - 2), 206) 
end
QuizOwner["historyItemClick"] = historyItemClick


local function refreshTime()
    local timerLabel = tolua.cast(QuizOwner["timerLabel"], "CCLabelTTF")
    local timer = loginActivityData:getQuizGuessTime(_data.key)
    local day, hour, min, sec = DateUtil:secondGetdhms(timer)
    if day > 0 then
        timerLabel:setString(HLNSLocalizedString("timer.tips.1", day, hour, min, sec))
    elseif hour > 0 then
        timerLabel:setString(HLNSLocalizedString("timer.tips.2", hour, min, sec))
    else
        timerLabel:setString(HLNSLocalizedString("timer.tips.3", min, sec))
    end
end

local function _refreshData()
    refreshTime()
    for i=0,1 do
        local title = tolua.cast(QuizOwner["title"..i], "CCLabelTTF")
        title:setString(_data.title)
    end
    local tips = tolua.cast(QuizOwner["tips"], "CCLabelTTF")
    tips:setString(_data.desp)
    for i=1,2 do
        local team = tolua.cast(QuizOwner["team"..i], "CCSprite")
        team:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("%s.png", _data["team"..i].code)))
        local name = tolua.cast(QuizOwner["name"..i], "CCLabelTTF")
        name:setString(_data["team"..i].name)
        local gains = tolua.cast(QuizOwner["gains"..i], "CCLabelTTF")
        gains:setString(_data["team"..i].odds)
    end
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/QuizView.ccbi", proxy, true,"QuizOwner")
    _layer = tolua.cast(node,"CCLayer")

    _refreshData()
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(QuizOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction(QuizOwner, "infoBg", _layer)
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
    local menu = tolua.cast(QuizOwner["menu"], "CCMenu")
    menu:setTouchPriority(_priority - 2)
end

function getQuizLayer()
	return _layer
end

function createQuizLayer(data, priority)
    _data = data
    _priority = (priority ~= nil) and priority or -132
    _init()

    function _layer:refreshData()
        _data = loginActivityData:getQuizDataByKey(_data.key)
    end

    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)

        addObserver(NOTI_TICK, refreshTime)

        popUpUiAction(QuizOwner, "infoBg")
    end

    local function _onExit()
        removeObserver(NOTI_TICK, refreshTime)
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