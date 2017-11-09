local _layer
local _priority = -132
local _data

-- 名字不要重复
QuizChooseOwner = QuizChooseOwner or {}
ccb["QuizChooseOwner"] = QuizChooseOwner

local function closeItemClick()
    popUpCloseAction(QuizChooseOwner, "infoBg", _layer )
end
QuizChooseOwner["closeItemClick"] = closeItemClick

local function betFunc(price, bType, choose)
    local function callback(url, rtnData)
        for k,v in pairs(rtnData.info.frontPage[Activity_Quiz]) do
            loginActivityData.activitys[Activity_Quiz][k] = v
        end
        if getQuizMainLayer() then
            getQuizMainLayer():refreshData()
        end
        if getQuizLayer() then
            getQuizLayer():refreshData()
        end
        getMainLayer():getParent():addChild(createQuizResultLayer(loginActivityData.activitys[Activity_Quiz][_data.key], choose, bType, _priority - 2), 206)
        closeItemClick()
    end
    doActionFun("QUIZ_BET", {_data.key, choose, bType, price}, callback)
end

local function goldItemClick(tag)
    local choose = "draw"
    if tag < 3 then
        choose = "team"..tag
    end
    getMainLayer():getParent():addChild(createQuizBetLayer(_data, "gold", betFunc, choose, _priority - 2), 206)
end
QuizChooseOwner["goldItemClick"] = goldItemClick

local function silverItemClick(tag)    
    local choose = "draw"
    if tag < 3 then
        choose = "team"..tag
    end
    getMainLayer():getParent():addChild(createQuizBetLayer(_data, "silver", betFunc, choose, _priority - 2), 206)
end
QuizChooseOwner["silverItemClick"] = silverItemClick

local function _refreshData()
    for i=0,1 do
        local title = tolua.cast(QuizChooseOwner["title"..i], "CCLabelTTF")
        title:setString(_data.title)
    end
    for i=1,2 do
        local team = tolua.cast(QuizChooseOwner["team"..i], "CCSprite")
        team:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("%s.png", _data["team"..i].code)))
        local name = tolua.cast(QuizChooseOwner["name"..i], "CCLabelTTF")
        name:setString(_data["team"..i].name)
        local gains = tolua.cast(QuizChooseOwner["gains"..i], "CCLabelTTF")
        gains:setString(_data["team"..i].odds)
    end
    local draw = _data.draw
    if draw and draw ~= "" then
        local gains3 = tolua.cast(QuizChooseOwner["gains3"], "CCLabelTTF")
        gains3:setString(draw.odds)
    else
        local layer3 = tolua.cast(QuizChooseOwner["layer3"], "CCLayer")
        layer3:setVisible(false)
        local menu3 = tolua.cast(QuizChooseOwner["menu3"], "CCMenu")
        menu3:setVisible(false)
    end
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/QuizChooseView.ccbi", proxy, true, "QuizChooseOwner")
    _layer = tolua.cast(node,"CCLayer")

    _refreshData()
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(QuizChooseOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction(QuizChooseOwner, "infoBg", _layer)
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
    local menu = tolua.cast(QuizChooseOwner["menu"], "CCMenu")
    menu:setTouchPriority(_priority - 2)
    for i=1,3 do
        local menu = tolua.cast(QuizChooseOwner["menu"..i], "CCMenu")
        menu:setTouchPriority(_priority - 2)
    end
end

function getQuizChooseLayer()
	return _layer
end

function createQuizChooseLayer(data, priority)
    _data = data
    _priority = (priority ~= nil) and priority or -132
    _init()

    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)

        popUpUiAction(QuizChooseOwner, "infoBg")
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