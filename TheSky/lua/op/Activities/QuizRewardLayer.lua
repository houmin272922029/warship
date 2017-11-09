local _layer
local _priority = -132
local _data

-- 名字不要重复
QuizRewardOwner = QuizRewardOwner or {}
ccb["QuizRewardOwner"] = QuizRewardOwner

local function closeItemClick()
    popUpCloseAction(QuizRewardOwner, "infoBg", _layer )
end
QuizRewardOwner["closeItemClick"] = closeItemClick

--[[
        新增客服要求 添加我的竞猜按钮； 
        ’我的竞猜‘按钮回调；
  ]]
local function historyItemClick()
    getMainLayer():getParent():addChild(createQuizListLayer(_data, _priority - 2), 206) 
end
QuizRewardOwner["historyItemClick"] = historyItemClick

local function refreshTime()
    local timerLabel = tolua.cast(QuizRewardOwner["timerLabel"], "CCLabelTTF")
    local timer = loginActivityData:getQuizRewardTime(_data.key)
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
        local title = tolua.cast(QuizRewardOwner["title"..i], "CCLabelTTF")
        title:setString(_data.title)
    end
    local winner = _data.result.winner
    local team = tolua.cast(QuizRewardOwner["team"], "CCSprite")
    local name = tolua.cast(QuizRewardOwner["name"], "CCLabelTTF")
    local winTips0 = tolua.cast(QuizRewardOwner["winTips0"], "CCLabelTTF")
    local winTips1 = tolua.cast(QuizRewardOwner["winTips1"], "CCLabelTTF")
    local drawTips0 = tolua.cast(QuizRewardOwner["drawTips0"], "CCLabelTTF")
    local drawTips1 = tolua.cast(QuizRewardOwner["drawTips1"], "CCLabelTTF")
    if winner == "draw" then
        team:setVisible(false)
        name:setVisible(false)
        winTips0:setVisible(false)
        winTips1:setVisible(false)
        drawTips0:setVisible(true)
        drawTips1:setVisible(true)
    else
        team:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("%s.png", _data[winner].code)))
        name:setString(_data[winner].name)
    end
    local failTips = tolua.cast(QuizRewardOwner["failTips"], "CCLabelTTF")
    local light = tolua.cast(QuizRewardOwner["light"], "CCSprite")
    local rewardIcon = tolua.cast(QuizRewardOwner["rewardIcon"], "CCSprite")
    local flag = (_data.guessLogs ~= nil and _data.guessLogs ~= "" and _data.guessLogs[winner] ~= "")
    failTips:setVisible(not flag)
    light:setVisible(flag)
    rewardIcon:setVisible(flag)
    local rewardItem = tolua.cast(QuizRewardOwner["rewardItem"], "CCMenuItem")
    local rewardText = tolua.cast(QuizRewardOwner["rewardText"], "CCSprite")
    rewardItem:setVisible(flag and not (_data.rewardFlag ~= nil and _data.rewardFlag ~= "" and _data.rewardFlag == true))
    rewardText:setVisible(flag and not (_data.rewardFlag ~= nil and _data.rewardFlag ~= "" and _data.rewardFlag == true))
    --label 信息为奖励已领取
    local rewardBeGot = tolua.cast(QuizRewardOwner["rewardBeGot"], "CCLabelTTF")
    rewardBeGot:setVisible(flag and (_data.rewardFlag ~= nil and _data.rewardFlag ~= "" and _data.rewardFlag == true))
end

--[[
        新增bug修改 解决初次点击无反应的情况；
        点击”领奖“按钮，弹出窗口，显示物品列表。窗口内有"确定"按钮，点击"确定"按钮，窗口消失，"领奖"按钮隐藏，显示lebel "奖励已领取"；
  ]]
local function rewardItemClick()
    local function callback(url, rtnData)
        for k,v in pairs(rtnData.info.frontPage[Activity_Quiz]) do
            loginActivityData.activitys[Activity_Quiz][k] = v
        end
        local array = {}
        for k,v in pairs(rtnData.info.gain) do
            table.insert(array, {itemId = k, count = v})
        end
        if getQuizMainLayer() then
            getQuizMainLayer():refreshData()
        end
        if  #array > 0  then
            getMainLayer():getParent():addChild(createMultiItemLayer(array, _priority - 2), 204)
            closeItemClick()
        end
        
    end
    doActionFun("QUIZ_REWARD", {_data.key}, callback)
end
QuizRewardOwner["rewardItemClick"] = rewardItemClick

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/QuizRewardView.ccbi", proxy, true,"QuizRewardOwner")
    _layer = tolua.cast(node,"CCLayer")

    _refreshData()

    local light = tolua.cast(QuizRewardOwner["light"], "CCSprite")
    light:runAction(CCRepeatForever:create(CCRotateBy:create(15, -360)))
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(QuizRewardOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction(QuizRewardOwner, "infoBg", _layer)
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
    local menu = tolua.cast(QuizRewardOwner["menu"], "CCMenu")
    menu:setTouchPriority(_priority - 2)
end

function getQuizRewardLayer()
	return _layer
end

function createQuizRewardLayer(data, priority)
    _data = data
    _priority = (priority ~= nil) and priority or -132
    _init()

    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)

        addObserver(NOTI_TICK, refreshTime)

        popUpUiAction(QuizRewardOwner, "infoBg")
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