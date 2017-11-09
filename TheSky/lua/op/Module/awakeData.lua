--
-- Author: tw-c-057
-- Date: 2015-07-21 17:20:46
-- houmin

awakedata = {
	data = {},             --接收网络请求过来的数据
	isTaskSuccess = nil,   --是否任务完成
    heros = {},            --传递觉醒的英雄
}

task_enum = {
    challenge_loot = 1, --挑战掉落
    challenge_count = 2,--挑战次数
    collection = 3,     --收集物品
    sing = 4,           --对歌
    drink = 5,          --饮酒
    decompose = 6,      --分解
    kiss = 7,           --亲吻人鱼
}

function awakedata:fromDic(dic)
    awakedata.data = dic
end

--重置用户数据
function awakedata:resetAllData()
    awakedata.data = {}
    awakedata.isTaskSuccess = nil
    awakedata.heros = {}
end

function awakedata:isFinishTask()
	-- 任务ID == 配置号
	local taskid = awakedata.data.currTaskId
    -- 配置
    local itemsConfig
    -- 获得正在觉醒的伙伴
    local hero = herodata:getHero(herodata.heroes[awakedata.data.currWakeHero])
    if hero and hero.rank == 4 then
        itemsConfig = ConfigureStorage.awave_goldmission
    else
        itemsConfig = ConfigureStorage.bluemission
    end
    -- 任务类型
    local currHeroTaskType
    if taskid then
        currHeroTaskType = itemsConfig[tostring(taskid)]["type"]
    end
    if awakedata.data.wakeRecord then
        -- 玩家身上的物品
        local datas = awakedata.data.wakeRecord[tostring(taskid)].data
        PrintTable(datas)
        function isFinishTimes()
            if itemsConfig[tostring(taskid)].times and datas.taskCount then
                local times = itemsConfig[tostring(taskid)].times
                awakedata.isTaskSuccess = datas.taskCount >= times and true or false
            end
        end

        if currHeroTaskType == task_enum.challenge_loot or currHeroTaskType == task_enum.collection then
            local dic = {}
            local specialloot
            for k,v in pairs(datas) do
                dic[v.itemId] = v.taskCount
            end

            if itemsConfig[tostring(taskid)].specialloot then
                specialloot = itemsConfig[tostring(taskid)].specialloot
                local flag = false
                for k,v in pairs(specialloot) do
                    if not dic or not dic[k] or dic[k] < v.demand then
                        flag = false
                        break
                    end
                    flag = true
                end
                awakedata.isTaskSuccess = flag
            else
                specialloot = itemsConfig[tostring(taskid)].collect
                local flag = false
                for k,v in pairs(specialloot) do
                    if not dic or not dic[k] or dic[k] < v then
                        flag = false
                        break
                    end
                    flag = true
                end
                awakedata.isTaskSuccess = flag
            end
        elseif currHeroTaskType == task_enum.decompose then
            isFinishTimes()
        elseif currHeroTaskType == task_enum.drink then
            isFinishTimes()
        elseif currHeroTaskType == task_enum.kiss then
            isFinishTimes()
        elseif currHeroTaskType == task_enum.sing then
            isFinishTimes()
        elseif currHeroTaskType == task_enum.challenge_count then
            local times = tonumber(itemsConfig[tostring(taskid)].times)
            local flag = false
                for k,v in pairs(datas) do
                    if not datas or not times or datas[k] < times then
                        flag = false
                        break
                    end
                    flag = true
                end
            awakedata.isTaskSuccess = flag
        end
    end
end
-- 前往相应的关卡
function awakedata:goTaskChallenge()
    if getAwakeSecondLayer() then
        getAwakeSecondLayer():close()
    end
    -- 任务ID
    local taskid = awakedata.data.currTaskId
    -- 关卡信息
    local changeConf
    local stageId
    -- 获得正在觉醒的伙伴
    local hero = herodata:getHero(herodata.heroes[awakedata.data.currWakeHero])
    if hero and hero.rank == 4 then
        changeConf = ConfigureStorage.awave_goldmission[tostring(taskid)]["function"]
        stageId = ConfigureStorage.awave_goldmission[tostring(taskid)].stageID
    else
        changeConf = ConfigureStorage.bluemission[tostring(taskid)]["function"]
        stageId = ConfigureStorage.bluemission[tostring(taskid)].stageID
    end
    if changeConf == "ptstage" then
        if storydata:checkRecord(stageId) then
            getMainLayer():goToSail(stageId, STAGE_MODE.NOR)
        end
    elseif changeConf == "Elitestage" then
        if elitedata:checkRecord(stageId) then
            getMainLayer():goToSail(stageId, STAGE_MODE.ELITE)
        end
    elseif changeConf == "Gspot" then
        getMainLayer():gotoAdventure()
        getAdventureLayer():showMarine()
        -- local function onEnterCallBack( url,rtnData )
        --     if rtnData["code"] == 200 then
        --         marineBranchData.huntTratherData = rtnData.info.huntingTreasure
        --         getMainLayer():gotoMarineBranchLayer(  )
        --     end
        -- end
        -- doActionFun("RETRIEVE_HUNTINFO",{},onEnterCallBack)
    elseif changeConf == "devil" then
        getAdventureLayer():showBoss()
    elseif changeConf == "haze" then
        getAdventureLayer():showHaze()
    elseif changeConf == "risk" then
        getAdventureLayer():showAdventure( )
    elseif changeConf == "sing" then
        if not getMainLayer() then
            CCDirector:sharedDirector():replaceScene(mainSceneFun())
        end
        runtimeCache.dailyPageNum = Daily_Wish
        getMainLayer():gotoDaily()
    elseif changeConf == "drink" then
        if not getMainLayer() then
            CCDirector:sharedDirector():replaceScene(mainSceneFun())
        end
        runtimeCache.dailyPageNum = Daily_DrinkWine
        getMainLayer():gotoDaily()
    elseif changeConf == "decompose" then
        if not getMainLayer() then
            CCDirector:sharedDirector():replaceScene(mainSceneFun())
        end
        runtimeCache.dailyPageNum = Daily_Compose
        getMainLayer():gotoDaily()
    elseif changeConf == "kiss" then
        if not getMainLayer() then
            CCDirector:sharedDirector():replaceScene(mainSceneFun())
        end
        runtimeCache.dailyPageNum = Daily_Worship
        getMainLayer():gotoDaily()
    elseif changeConf == "collection" then
        local function havaExpcardConfirmAction()
        end
        local function havaExpcardCancelAction()
        end
        getMainLayer():addChild(createSimpleConfirCardLayer(HLNSLocalizedString("adventure.awake.GotoTaskDec"),
                HLNSLocalizedString("adventure.awake.GotoTask")))
        SimpleConfirmCard.confirmMenuCallBackFun = havaExpcardConfirmAction
        SimpleConfirmCard.cancelMenuCallBackFun = havaExpcardCancelAction
    end
end
-- 获取关卡的名字
function awakedata:getChallengeNameItem(itemId)
    local name
    if havePrefix(itemId, "stage_") then
        name = ConfigureStorage.stageConfig[itemId].stageName
    elseif havePrefix(itemId, "spot_") then
        name = ConfigureStorage.Gspot[itemId].nsname
    elseif havePrefix(itemId, "elitestage_") then
        name = ConfigureStorage.eliteStage[itemId].stageName
    end
    return name
end

-- 蓝升紫获得现阶段的任务数
function awakedata:getTaskNum()
    local index = 0
    -- 任务ID
    local taskid = awakedata.data.currTaskId
    -- 关卡信息
    local changeConf
    -- 获得正在觉醒的伙伴
    local hero = herodata:getHero(herodata.heroes[awakedata.data.currWakeHero])
    if hero and hero.rank == 4 then
        changeConf = ConfigureStorage.awave_goldmission
    else
        changeConf = ConfigureStorage.bluemission
    end
    -- 阶段
    local stage
    if changeConf[tostring(taskid)].stage then
        stage = changeConf[tostring(taskid)].stage
    end
    local confNum = 0
    for k,v in pairs(changeConf) do
        confNum = confNum + 1
    end
    for i=1,confNum do
        if tonumber(changeConf[tostring(i)].stage) == tonumber(stage) then
            index = index + 1
        end
    end
    return index
end
-- 蓝卡升紫获得当前第几个任务
function awakedata:getTaskNowNum()
    local index = 0
    -- 任务ID
    local taskid = awakedata.data.currTaskId
    -- 关卡信息
    local changeConf
    local hero = herodata:getHero(herodata.heroes[awakedata.data.currWakeHero])
    if hero and hero.rank == 4 then --如果觉醒则更换配置
        changeConf = ConfigureStorage.awave_goldmission
    else
        changeConf = ConfigureStorage.bluemission
    end
    -- 阶段
    local stage = changeConf[tostring(taskid)].stage
    if changeConf[tostring(taskid)].stage == 1 then
        index = taskid
    elseif tonumber(changeConf[tostring(taskid)].stage) > 1 then
        -- 当前taskid前去上个阶段最后以个taskid、
        index = 0
        local confNum = 0
        for k,v in pairs(changeConf) do
            confNum = confNum + 1
        end
        local perNum = 0
        for i=1,confNum do
            if changeConf[tostring(i)].stage and stage then
                if tonumber(changeConf[tostring(i)].stage) < tonumber(stage) then
                    perNum = perNum + 1
                end
            end
        end
        index = taskid - perNum
    end
    return index
end

-- 紫升金阶段任务总数
function awakedata:getTaskPurpleNum()
    local index = 0
    -- 任务ID
    local taskid = awakedata.data.currTaskId
    -- 关卡信息
    local changeConf = ConfigureStorage.awave_goldmission
    local awave_Onornot = ConfigureStorage.awave_Onornot
    local heroId = herodata:getHeroIdByUId(awakedata.data.currWakeHero)
    -- 阶段
    local stage = changeConf[tostring(taskid)].stage

    for i=1,table.getTableCount(changeConf) do
        if changeConf[tostring(i)] and changeConf[tostring(i)].heroID and awave_Onornot[changeConf[tostring(i)].heroID] and awave_Onornot[changeConf[tostring(i)].heroID].onornot == 1 then
            if changeConf[tostring(i)].heroID == heroId and tonumber(changeConf[tostring(i)].stage) == tonumber(stage) then
                index = index + 1
            end
        end
    end
    return index
end

-- 奖励物品数量
function awakedata:getRewardCount()
    local index = 0
    -- 任务ID
    local taskid = awakedata.data.currTaskId
    -- 关卡信息
    local changeConf
    local hero = herodata:getHero(herodata.heroes[awakedata.data.currWakeHero])
    if hero and hero.rank == 4 then --如果觉醒则更换配置
        changeConf = ConfigureStorage.awave_goldmission
    else
        changeConf = ConfigureStorage.bluemission
    end
    if changeConf[tostring(taskid)].reward then
        for k,v in pairs(changeConf[tostring(taskid)].reward) do
            index = index + 1
        end
    end
    return index
end

-- 收集物品数量
function awakedata:getColleCount()
    local index = 0
    -- 需要的物品信息
    local datas = awakedata.data.wakeRecord[tostring(taskid)].data
    for k,v in pairs(datas) do
        index = index + 1
    end
    return index 
end



