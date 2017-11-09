local _layer
local _tableView
local unionShopData
local _data

unionRacingBattleViewOwner = unionRacingBattleViewOwner or {}
ccb["unionRacingBattleViewOwner"] = unionRacingBattleViewOwner

-- 战斗开始 （ok）
local function battleBtnClicked()    
    -- 判断当前状态 、来判断是否能点击
    if _data then
        if _data.remainTime.period == "before" then
            ShowText(HLNSLocalizedString("union.racingBattle.TimeOut"))
        else
            getUnionMainLayer():gotoRacingBattleStart()
        end
    end
end
unionRacingBattleViewOwner["battleBtnClicked"] = battleBtnClicked

-- 详情
local function helpItemClicked()    
    print("详情")
    local desc = ConfigureStorage.CSRB_leaguemessage
    PrintTable(desc)
    local  function getMyDescription()
        -- body
        local temp = {}
            if desc then
                for i=1,getMyTableCount(desc) do
                    table.insert(temp, desc[tostring(i)].nr)
                end
            end
            return temp
        end
    description = getMyDescription()
    local contentLayer = MainSceneOwner["contentLayer"]
    getMainLayer():getParent():addChild(createCommonHelpLayer(description, -132))
end
unionRacingBattleViewOwner["helpItemClicked"] = helpItemClicked

-- 参赛服务器 
local function serverListBtnClicked()
    getUnionMainLayer():gotoRacingBattleServerList()
end
unionRacingBattleViewOwner["serverListBtnClicked"] = serverListBtnClicked

-- 查看奖励
local function lookRewardBtnClicked()    
    print("查看奖励")
    getUnionMainLayer():gotoRacingBattleReward()
end
unionRacingBattleViewOwner["lookRewardBtnClicked"] = lookRewardBtnClicked

-- 战绩 
local function recordBtnClicked()
    print("战绩")
    if _data then
        if _data.remainTime.period == "before" then
            ShowText(HLNSLocalizedString("union.racingBattle.RecordOut"))
        else
            getUnionMainLayer():gotoRacingBattleRecord()
        end
    end
    
end
unionRacingBattleViewOwner["recordBtnClicked"] = recordBtnClicked

-- 关闭
local function closeItemClick()
    getUnionMainLayer():gotoShowInner()
end
unionRacingBattleViewOwner["closeItemClick"] = closeItemClick

--刷新时间显示函数
local function refreshTimeLabel()
    local timerLabel = tolua.cast(unionRacingBattleViewOwner["timerLabel"], "CCLabelTTF")
    if _data then
        local timer = _data.remainTime.nextTime - userdata.loginTime
        if timer < 0 then
            timer = 0
        end
        local day, hour, min, sec = DateUtil:secondGetdhms(timer)
        if day > 0 then
            timerLabel:setString(HLNSLocalizedString("timer.tips.1", day, hour, min, sec))
        elseif hour > 0 then
            timerLabel:setString(HLNSLocalizedString("timer.tips.2", hour, min, sec))
        else
            timerLabel:setString(HLNSLocalizedString("timer.tips.3", min, sec))
        end
    end
end


local function refresh()
    -- 显示相应的数据信息 ownerRaceCount timeEnd  unionRaceCount
    if _data then
        local ownerRaceCount = tolua.cast(unionRacingBattleViewOwner["ownerRaceCount"] , "CCLabelTTF")
        ownerRaceCount:setString(_data.myMarks.personMark)

        local unionRaceCount = tolua.cast(unionRacingBattleViewOwner["unionRaceCount"] , "CCLabelTTF")
        unionRaceCount:setString(_data.myMarks.leagueMark)

        local timeEndLable = tolua.cast(unionRacingBattleViewOwner["timeEndLable"] , "CCLabelTTF")
        print("_data.remainTime.period = " , _data.remainTime.period)
        PrintTable(_data.remainTime)
        if _data.remainTime.period == "before" then  -- 提醒超哥、 period 后面有个空格
            print("before ---------------")
            timeEndLable:setString(HLNSLocalizedString("union.racingBattle.timeBefore"))
        else
            timeEndLable:setString(HLNSLocalizedString("union.racingBattle.timeEnd"))
        end
        local redDot = tolua.cast(unionRacingBattleViewOwner["redDot"] , "CCSprite")

        --  时间函数
        refreshTimeLabel()
        if _data.isAward == 0 then
            redDot:setVisible(false)
        elseif _data.isAward ~= 0 and _data.myMarks.personMark == 0 then
            redDot:setVisible(false)
        else
            redDot:setVisible(true)
        end
    end
end

local function getUnionRacingBattleDataCallBack( url,rtnData )
    _data = rtnData.info
    PrintTable(_data)
    refresh()
end

local function getUnionRacingBattleData()
    doActionFun("CROSSSERVERRACEBATTLE_GETMAININFO",{},getUnionRacingBattleDataCallBack)
end

local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/unionRacingBattleView.ccbi",proxy, true,"unionRacingBattleViewOwner")
    _layer = tolua.cast(node,"CCLayer")
end

local function setMenuPriority()
    local menu = tolua.cast(unionRacingBattleViewOwner["menu"], "CCMenu")
    menu:setHandlerPriority(-130)
end

function getUnionRacingBattleViewLayer()
	return _layer
end

function createUnionRacingBattleViewLayer( )
    _init()
    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
        getUnionRacingBattleData()
        addObserver(NOTI_TICK, refreshTimeLabel)
    end

    local function _onExit()
        removeObserver(NOTI_TICK, refreshTimeLabel)
        _layer = nil
    end

    --onEnter onExit
    local function _layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        end
    end

    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end