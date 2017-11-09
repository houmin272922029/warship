local _layer
local _data
-- ·名字不要重复
StrideServerArenaRankingViewOwner = StrideServerArenaRankingViewOwner or {}
ccb["StrideServerArenaRankingViewOwner"] = StrideServerArenaRankingViewOwner

--阵容 调用己方阵容接口 --TeamViewCellOwner
local function castBtnTaped()
    print("castBtnTaped")
    if getMainLayer() then
        runtimeCache.equipFromeTeam = 0
        getMainLayer():gotoTeam()
    end
end
StrideServerArenaRankingViewOwner["castBtnTaped"] = castBtnTaped


--返回
local function backBtnClicked()
    print("back")
    runtimeCache.SSAState = ssaDataFlag.home
    getMainLayer():gotoAdventure()
end
StrideServerArenaRankingViewOwner["backBtnClicked"] = backBtnClicked


local function _refreshData()
    -- body 
    _data = ssaData.data
    local Ranking = tolua.cast(StrideServerArenaRankingViewOwner["Ranking"], "CCLabelTTF")
    Ranking:setString(ConfigureStorage.crossDual_score[tonumber(_data.rankId) + 1].name) 
 
end

--刷新时间显示函数
local function refreshTimeLabel()
    local timeEnd = tolua.cast(StrideServerArenaRankingViewOwner["timeEnd"], "CCLabelTTF")
    local timer = _data.nextTime - userdata.loginTime
    if timer == 0 then
        -- 进入排位结束阶段 ssaDataFlag.RankingEnd 
        runtimeCache.SSAState = ssaDataFlag.RankingEnd
        getStrideServerArenaLayer():changeState()
        -- getLoginActivityLayer():closeView()
    end
    local day, hour, min, sec = DateUtil:secondGetdhms(timer)
    if day > 0 then
        timeEnd:setString(HLNSLocalizedString("timer.tips.1", day, hour, min, sec))
    elseif hour > 0 then
        timeEnd:setString(HLNSLocalizedString("timer.tips.2", hour, min, sec))
    else
        timeEnd:setString(HLNSLocalizedString("timer.tips.3", min, sec))
    end
end


-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/StrideServerArenaRankingView.ccbi",proxy, true,"StrideServerArenaRankingViewOwner")
    _layer = tolua.cast(node,"CCLayer")
    _refreshData()
    refreshTimeLabel()
end

-- 该方法名字每个文件不要重复
function getStrideServerArenaRankingViewLayer()
    return _layer
end

function createStrideServerArenaRankingViewLayer()
    _init()
   local function _onEnter()
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