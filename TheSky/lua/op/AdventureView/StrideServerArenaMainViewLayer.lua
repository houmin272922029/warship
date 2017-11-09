local _layer
local _data
-- ·名字不要重复
StrideServerArenaMainViewOwner = StrideServerArenaMainViewOwner or {}
ccb["StrideServerArenaMainViewOwner"] = StrideServerArenaMainViewOwner

--奖励
local function rewardBtnTaped()
    if _data then
        if _data.reward then
            -- 存在奖励 红色点显示
            getMainLayer():getParent():addChild(createSSARewardLayer(-135), 100)
        else
            -- 不存在， 
            local desc = ConfigureStorage.crossDual_BGdesp
            local  function getMyDescription()
                -- body
                local temp = {}
                    for k,v in pairs(desc) do
                        table.insert(temp, v.BGdesp)
                    end
                    return temp
                end
            description = getMyDescription()
            local contentLayer = MainSceneOwner["contentLayer"]
            getMainLayer():getParent():addChild(createCommonHelpLayer(description, -132))
        end
    else
         -- 不存在， 
        local desc = ConfigureStorage.crossDual_BGdesp
        local  function getMyDescription()
            -- body
            local temp = {}
                for k,v in pairs(desc) do
                    table.insert(temp, v.BGdesp)
                end
                return temp
            end
        description = getMyDescription()
        local contentLayer = MainSceneOwner["contentLayer"]
        getMainLayer():getParent():addChild(createCommonHelpLayer(description, -132))
    end
end
StrideServerArenaMainViewOwner["rewardBtnTaped"] = rewardBtnTaped

--详情
local function descBtnTaped()
   --弹出帮助界面
    local desc = ConfigureStorage.crossDual_help
    print("xiangqing")
    local  function getMyDescription()
        -- body
        local temp = {}
            for k,v in pairs(desc) do
                table.insert(temp, v.desp)
            end
            return temp
        end
    description = getMyDescription()
    local contentLayer = MainSceneOwner["contentLayer"]
    getMainLayer():getParent():addChild(createCommonHelpLayer(description, -132))
end
StrideServerArenaMainViewOwner["descBtnTaped"] = descBtnTaped

local function beginCallback(url, rtnData)
    getAdventureLayer():enterSSA()
    ssaData.data = rtnData.info
    print("beginCallback-----------")
    PrintTable(ssaData.data)
    if ssaData.data.timeStatus == "begin" then  --排位赛结束，等待阶段
        print("ssaData.data.rankId" , ssaData.data.rankId)
        if tonumber(ssaData.data.rankId) == 0 then -- 32 晋升之路  新增修改 不存在晋升之路UI 转而进入积分排位赛
            -- runtimeCache.SSAState = ssaDataFlag.RankingTime
            -- getStrideServerArenaLayer():changeState()  
            runtimeCache.SSAState = ssaDataFlag.pointRace
            getMainLayer():gotoPointsRace()  
        else
            if ssaData.data.data.expNow < ConfigureStorage.crossDual_score[tonumber(ssaData.data.rankId) + 1].scoreNeed then
                -- 进入排位赛
                runtimeCache.SSAState = ssaDataFlag.pointRace
                getStrideServerArenaLayer():changeState()
            else
                -- if tonumber(ssaData.data.rankId) == 1 then
                    -- 32 新星 界面
                --     runtimeCache.SSAState = ssaDataFlag.ThirtyTwoRanking
                --     getStrideServerArenaLayer():changeState() 
                --     -- runtimeCache.SSAState = ssaDataFlag.pointRace
                --     -- getStrideServerArenaLayer():changeState()
                -- else
                runtimeCache.SSAState = ssaDataFlag.pointRaceRanking
                getStrideServerArenaLayer():changeState()  
                -- end
            end    
        end
    elseif ssaData.data.timeStatus == "auditionsEnd" then -- 统一进入跨服大对决页面(排位赛已经截止)
        runtimeCache.SSAState = ssaDataFlag.RankingEnd
        print("等待阶段")
        getStrideServerArenaLayer():changeState() 
    elseif ssaData.data.timeStatus == "worshipBegin" then
        print("膜拜阶段") 
        runtimeCache.SSAState = ssaDataFlag.Worship
        getStrideServerArenaLayer():changeState()
    else
        --显示四皇争夺战 UI SSAFourKingContendViewOwner
        print("四皇争夺战")
        runtimeCache.SSAState = ssaDataFlag.FourKing
        getStrideServerArenaLayer():changeState()
    end
end

--进入 积分赛、晋级赛
local function onEnterBtnTaped()
    doActionFun("CROSSSERVERBATTLE_BEGIN", {}, beginCallback)
end
StrideServerArenaMainViewOwner["onEnterBtnTaped"] = onEnterBtnTaped

--参赛服务器列表查看
local function serverListBtnTaped()
    if not _data or not _data.servers then
        return
    end
    runtimeCache.SSAState = ssaDataFlag.home
    runtimeCache.dailyPageNum = Daily_Worship
    getMainLayer():getParent():addChild(createSSAServerListViewLayer(_data.servers), 100)
end
StrideServerArenaMainViewOwner["serverListBtnTaped"] = serverListBtnTaped

--阵容 调用己方阵容接口 --TeamViewCellOwner
local function castBtnTaped()
    
    runtimeCache.SSAState = ssaDataFlag.home
    getMainLayer():gotoTeam() 
end
StrideServerArenaMainViewOwner["castBtnTaped"] = castBtnTaped

local function _refreshData()
    _data = ssaData.data
    if _data.beginTime and _data.endTime then
        local timeLimit = tolua.cast(StrideServerArenaMainViewOwner["timeLimit"], "CCLabelTTF")
        timeLimit:setString(HLNSLocalizedString("SSA.timeStart" ).. string.sub(_data.beginTime, 1, -10))
        local timeEnd = tolua.cast(StrideServerArenaMainViewOwner["timeEnd"], "CCLabelTTF")
        timeEnd:setString(HLNSLocalizedString("SSA.timeEnd") .. string.sub(_data.endTime, 1, -10))
    end
    if _data.reward then
        -- 存在奖励 红色点显示
        local redDot = tolua.cast(StrideServerArenaMainViewOwner["redDot"], "CCSprite")
        redDot:setVisible(true)
    end
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/StrideServerArenaMainView.ccbi",proxy, true,"StrideServerArenaMainViewOwner")
    _layer = tolua.cast(node,"CCLayer")
end

-- 该方法名字每个文件不要重复
function geStrideServerArenaMainViewLayer()
    return _layer
end

function createStrideServerArenaMainViewLayer()
    _init()

    function _layer:refreshData()
        _refreshData()
    end

    local function _onEnter()
        -- runtimeCache.SSAState = runtimeCache.SSAState or ssaDataFlag.home
        -- _changeStrideServerArenaState(runtimeCache.SSAState) 
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