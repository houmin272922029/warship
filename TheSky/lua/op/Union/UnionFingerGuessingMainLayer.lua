local _guessingLayer
local _unionMainView
local _currentArena = {}
local _guessingResult = {}
local _award = {}
local _beginTime
local _endTime
local _currentTime
local _guessEnabled = false
local _hasGuessed = false

UnionFingerGuessingLayerOwner = UnionFingerGuessingLayerOwner or {}
ccb["UnionFingerGuessingLayerOwner"] = UnionFingerGuessingLayerOwner


local function _updateTimer()
    _currentTime = userdata.loginTime
    local leftTime = 0

    -- 等待下次擂台开放
    if _beginTime > _currentTime then
        _guessEnabled = false
        -- 还有多长时间开始
        leftTime = _beginTime - _currentTime
    else
        _guessEnabled = true
        leftTime = _endTime - _currentTime
    end
    -- 时间到，开放猜拳按钮
    if leftTime <= 0 then
        _guessEnabled = true
        _hasGuessed = false
        leftTime = 0
        _guessingLayer:_requestGuessingData()
    end

    for i=1,3 do
        if _guessEnabled then
            UnionFingerGuessingLayerOwner["fingerBtn"..i]:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn7_0.png"))
        else
            UnionFingerGuessingLayerOwner["fingerBtn"..i]:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn7_2.png"))
        end
    end
    UnionFingerGuessingLayerOwner["cdTimer"]:setString(DateUtil:second2ms(leftTime))
end


local function _showGuessingResult()
    if _guessingResult.status == 2 or _guessingResult.status == 3 then
        -- 自己赢了，或者没有人挑战
        _unionMainView:addChild(createUnionFingerGuessingWinLayer(_award,_guessingResult.messagesToClient))
    elseif _guessingResult.status == 1 or _guessingResult.status == 4 then
        -- 输了，或者平了
        _unionMainView:addChild(createUnionFingerGuessingNoWinLayer(_guessingResult.status,_guessingResult.messagesToClient))
    end
end

local function _showNews(messages)
    -- body

    if messages and type(messages) == "table" then
        for i=1,3 do
            if not messages[tostring(i-1)] then
                break
            end

            local time = messages[tostring(i-1)].time
            local message = messages[tostring(i-1)].message
            if time and message and message ~= "" then
                UnionFingerGuessingLayerOwner["news"..i]:setString(message)
                local timeGap = userdata.loginTime - time
                local dayGap,hourGap,minutesGap = DateUtil:secondGetdhms(timeGap)
                local timeString = ""
                if dayGap > 0 then
                    timeString = HLNSLocalizedString("union.information.daysbefore",dayGap)
                elseif
                    hourGap > 0 then
                    timeString = HLNSLocalizedString("union.information.hoursbefore",hourGap)
                elseif
                    minutesGap > 0 then
                    timeString = HLNSLocalizedString("union.information.minutesbefore",minutesGap)
                else
                    timeString = HLNSLocalizedString("union.information.justbefore")
                end
                UnionFingerGuessingLayerOwner["newsTime"..i]:setString(timeString)
            end
        end
    end
end

local function backBtnClicked( )
    _unionMainView:gotoShowInner()
end
UnionFingerGuessingLayerOwner["backBtnClicked"] = backBtnClicked

local function _guessingCallBack(url,rtnData)
    if rtnData.code == 200 then
        -- 赢了几次
        local guessedTimes = rtnData.info.count
        local guessedTimesMax = ConfigureStorage.leagueFingerGuessing.countMax
        UnionFingerGuessingLayerOwner["guessingTimes"]:setString(guessedTimes.."/"..guessedTimesMax)

        -- 抢到擂台，挑战别人，可能输可能赢，可能平局
        -- 挑战成功，获得的奖励
        if rtnData.info.gain and type(rtnData.info.gain) == "table" then                  
            _award = rtnData.info.gain
        end
        if rtnData.info.lastData and type(rtnData.info.lastData) == "table" then
            _guessingResult = rtnData.info.lastData
            if _guessingResult.status == 4 then
                _hasGuessed = false
            else
                _hasGuessed = true
            end
            _showGuessingResult()
        end

        if rtnData.info.messages and type(rtnData.info.messages) == "table"  then
            _showNews(rtnData.info.messages)
        end

        
        -- 抢到擂台，自己在台上
        if rtnData.info.nextData and rtnData.info.nextData.left and rtnData.info.nextData.left.playerId == userdata.userId then
            _hasGuessed = true
            -- 开始守擂
            ShowText(HLNSLocalizedString("union.waitForChallenge"))
        else
            ShowText(HLNSLocalizedString("union.didNotGetArena"))
        end
        
        _currentArena = rtnData.info.nextData

        -- 等待下一次擂台开放时间
        _beginTime = _currentArena.beginTime
        _endTime = _currentArena.endTime
        if _beginTime > _currentTime then
            _guessEnabled = false
            for i=1,3 do
                UnionFingerGuessingLayerOwner["fingerBtn"..i]:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn7_2.png"))
            end
        end
    end
end


local function fingerBtnClicked(tag)
    if not _guessEnabled then
        ShowText(HLNSLocalizedString("union.waitForCD"))
        return
    end
    
    if _hasGuessed then
        ShowText(HLNSLocalizedString("union.haveGuessedFinger"))
    else
        -- 没出过拳，抢资源，可能守擂，可能挑战，可能没抢到
        doActionFun("UNION_GUESSING_URL",{tag},_guessingCallBack)
    end
end
UnionFingerGuessingLayerOwner["fingerBtnClicked"] = fingerBtnClicked

local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/UnionFingerGuessingMain.ccbi", proxy, true, "UnionFingerGuessingLayerOwner")
    _guessingLayer = tolua.cast(node, "CCLayer")
    local guessedTimesMax = ConfigureStorage.leagueFingerGuessing.countMax
    UnionFingerGuessingLayerOwner["timesTitle"]:setString(HLNSLocalizedString("union.timesTitle",guessedTimesMax))

    local rulesLabel = tolua.cast(UnionFingerGuessingLayerOwner["rulesLabel"],"CCLabelTTF")
    rulesLabel:setVisible(true)
    rulesLabel:setString(HLNSLocalizedString("每天7点~23点开启活动，每一小时进行一次结算，擂主会获得一个随机大礼包！"))
end

local function _requestGuessingDataCallBack(url,rtnData)
    if rtnData.code == 200 then
        -- 赢了几次
        local guessedTimes = rtnData.info.count
        local guessedTimesMax = ConfigureStorage.leagueFingerGuessing.countMax
        UnionFingerGuessingLayerOwner["guessingTimes"]:setString(guessedTimes.."/"..guessedTimesMax)



        -- 上一轮输赢情况，被挑战的结果
        -- ，如果是赢的，应该获得的奖励
        if rtnData.info.gain and type(rtnData.info.gain) == "table" then                  
            _award = rtnData.info.gain
        end
        -- 上次是擂主，被动挑战，显示上次猜拳的结果，输赢；或者无人挑战，你赢了
        if rtnData.info.lastData and type(rtnData.info.lastData) == "table" then                  
            _guessingResult = rtnData.info.lastData
            _showGuessingResult()
        end

        if rtnData.info.messages and type(rtnData.info.messages) == "table"  then
            _showNews(rtnData.info.messages)
        end



        -- 当前擂台数据，或者下一次擂台的数据，取决于beginTime
        _currentArena = rtnData.info.thisData
        _beginTime = _currentArena.beginTime
        _endTime = _currentArena.endTime
        _currentTime = userdata.loginTime
        -- 擂台开放时间比当前时间还晚，说明当前时间段的擂台已结束，要等待下一次开放
        if _beginTime > _currentTime then
            
            _guessEnabled = false
            for i=1,3 do
                UnionFingerGuessingLayerOwner["fingerBtn"..i]:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn7_2.png"))
            end
        else
            -- 已开放
            -- 已经出过拳了
            if _currentArena.left and _currentArena.left.playerId and _currentArena.left.playerId == userdata.userId then
                _hasGuessed = true
            end
        end
        -- 至下次开放时间的倒计时
        addObserver(NOTI_UNION_FINGER_TIMER, _updateTimer)
    end
end

function createUnionFingerGuessingLayer( unionMainView )
    _init()

    _unionMainView = unionMainView

    function _guessingLayer:_requestGuessingData()
        doActionFun("QUERY_UNION_GUESSING_URL",{},_requestGuessingDataCallBack)
        UnionFingerGuessingLayerOwner["posterLabel"]:setString(ConfigureStorage.leagueDescription["fingerGuess"]["desp"])
    end

    local function _onEnter()
        _guessingLayer:_requestGuessingData()
        _guessEnabled = true
        _hasGuessed = false

    end

    local function _onExit()
        print("onExit")
        _guessingLayer = nil
        removeObserver(NOTI_UNION_FINGER_TIMER, _updateTimer)
    end

    --onEnter onExit
    local function _layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        end
    end


    _guessingLayer:registerScriptHandler(_layerEventHandler)

    return _guessingLayer
end