local _layer


-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/StrideServerArenaMainView.ccbi",proxy, true,"StrideServerArenaMainViewOwner")
    _layer = tolua.cast(node,"CCLayer")
end

-- 该方法名字每个文件不要重复
function getStrideServerArenaLayer()
    return _layer
end

local function _changeStrideServerArenaState(state)
    _layer:removeAllChildrenWithCleanup(true)
    if state == ssaDataFlag.home then
        _layer:addChild(createStrideServerArenaMainViewLayer()) --main
    elseif state == ssaDataFlag.ThirtyTwoRanking then -- 从身价过亿称号晋升至32新星 (32新星晋升之路)
        _layer:addChild(createStrideServerArenaThirtyTwoRankingLayer()) 
    elseif state == ssaDataFlag.RankingTime then --  所处32超新星，排位赛正在进行中(在规定时间内保持称号，否则会被打下来)  
        _layer:addChild(createStrideServerArenaRankingViewLayer()) 
    elseif state == ssaDataFlag.RankingEnd then -- 非begin阶段 挑战统一界面(排位赛结束，稍后将公布32强名单)
        _layer:addChild(createStrideServerArenaRankEndViewLayer())
    elseif state == ssaDataFlag.Worship then -- 膜拜
        getAdventureLayer():enterSSA()
        getMainLayer():gotoSSAWorship()
    elseif state == ssaDataFlag.FourKing then -- 四皇争霸
        getAdventureLayer():enterSSA()
        getMainLayer():gotoSSAFourKing() 
    elseif state == ssaDataFlag.pointRace then -- 积分赛
        getAdventureLayer():enterSSA()
        getMainLayer():gotoPointsRace() 
    elseif state == ssaDataFlag.pointRaceRanking then -- 排位晋级赛
        getAdventureLayer():enterSSA()
        getMainLayer():gotoPointsRaceRanking()    
    end
end

local function beginCallback(url, rtnData)
    ssaData.data = rtnData["info"]
    geStrideServerArenaMainViewLayer():refreshData()
end

function createStrideServerArenaLayer()
    _init()

    function _layer:changeState()
        _changeStrideServerArenaState(runtimeCache.SSAState)
    end

    function _layer:refreshLayer()
        if runtimeCache.SSAState == ssaDataFlag.home then
            doActionFun("CROSSSERVERBATTLE_GETMAININFO",{}, beginCallback)
        end
    end
    
    local function _onEnter()
        print("onEnter", runtimeCache.SSAState, ssaDataFlag.home)
        runtimeCache.SSAState = runtimeCache.SSAState or ssaDataFlag.home
        _changeStrideServerArenaState(runtimeCache.SSAState) 
    end

    local function _onExit()
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