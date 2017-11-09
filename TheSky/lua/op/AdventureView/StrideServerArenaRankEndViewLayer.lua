local _layer
local _data
-- ·名字不要重复
StrideServerArenaRankEndViewOwner = StrideServerArenaRankEndViewOwner or {}
ccb["StrideServerArenaRankEndViewOwner"] = StrideServerArenaRankEndViewOwner

-- 战报
local function castBtnTaped()
    runtimeCache.SSAState = ssaDataFlag.home
    getMainLayer():gotoSSABattleLogs()
end
StrideServerArenaRankEndViewOwner["castBtnTaped"] = castBtnTaped


--返回按钮
local function onAutoClick()
    runtimeCache.SSAState = ssaDataFlag.home
    getMainLayer():gotoAdventure()
end
StrideServerArenaRankEndViewOwner["onAutoClick"] = onAutoClick


-- 积分榜按钮
local function rankNoticeClicked()
    local function Callback(url, rtnData)
        local data = rtnData.info
        getMainLayer():getParent():addChild(createSSARankNoticeViewLayer(data , -132))
    end
    doActionFun("CROSSSERVERBATTLE_LOOKRANKINFO", {}, Callback)
end
StrideServerArenaRankEndViewOwner["rankNoticeClicked"] = rankNoticeClicked

local function refreshTimeLabel()
    local openTime = tolua.cast(StrideServerArenaRankEndViewOwner["openTime"], "CCLabelTTF")
    local timer = ssaData.data.nextTime - userdata.loginTime
    if timer < 0 then
        timer = 0
    end
    openTime:setString(HLNSLocalizedString("SSA.openTime", DateUtil:second2hms(timer))) 
end

local function _refreshData()
    -- body 
    _data = ssaData.data
    local Ranking = tolua.cast(StrideServerArenaRankEndViewOwner["Ranking"], "CCLabelTTF")
    Ranking:setString(ConfigureStorage.crossDual_score[tonumber(_data.rankId) + 1].name) 
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/StrideServerArenaRankEndView.ccbi",proxy, true,"StrideServerArenaRankEndViewOwner")
    _layer = tolua.cast(node,"CCLayer")
    _refreshData()
end

-- 该方法名字每个文件不要重复
function getStrideServerArenaRankEndViewLayer()
    return _layer
end

function createStrideServerArenaRankEndViewLayer()
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