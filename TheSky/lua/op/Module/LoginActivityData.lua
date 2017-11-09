-- 用户数据缓存

-- 登录活动名字
Activity_conLoginOne = "conLoginOne"                   -- 限制领奖次数的登陆奖励
Activity_conLogin = "conLogin"                         -- 连续登陆(不限制领奖次数的登陆奖励)
Activity_notConLogin = "notConLogin"                   -- 非连续登陆奖励
Activity_addConLogin = "addConLogin"                   -- 累计登陆奖励
Activity_Exchange1 = "rewardExchange_0"                 -- 兑换活动
Activity_Exchange2 = "rewardExchange_1" 
Activity_Exchange3 = "rewardExchange_2" 
Activity_Rebate1 = "costRefund"  -- 充值返利
Activity_Rebate2 = "costReward" -- 消费返道具
Activity_Rebate3 = "consumeRefund" -- 消费返金币
Activity_Rebate4 = "specificChangeReward" -- 单笔充值返利
Activity_Quiz = "guessWinLoseDraw" -- 有奖竞猜

Activity_LevelUp = "giftForLevel" -- 开服冲级王
Activity_Arena = "rankForArena" -- 竞技争霸赛

Activity_JigsawPuzzle = "jigsawPuzzle" -- 拼图游戏活动
Activity_FanLi = "prepayReward"  -- 返利
Activity_Gamble = "yaoyaoHappy"  -- 摇摇乐 老虎机
Activity_DoubleDrop = "stageDropDouble"  -- 摇摇乐 老虎机
IsFreeFestival = nil --春节活动
FreeFestivalUid = nil --春节活动id
IsRankOpen = nil --春节排行榜开启

loginActivityData = {
    activitys = {}
}

function loginActivityData:getAllActivity()
    local retArr = {}
    if not loginActivityData.activitys then
        return retArr
    end
    for k,v in pairs(loginActivityData.activitys) do
        if k == "prepayReward" then
            for pk,pv in pairs(v) do
                local tempArray = {}
                tempArray["activetyName"] = pk
                tempArray["content"] = deepcopy(pv)
                if not tempArray["content"].sort or tempArray["content"].sort == "" then
                    tempArray["content"].sort = 0
                end
                table.insert(retArr, tempArray)
            end
        else
            local tempArray = {}
            tempArray["activetyName"] = k
            tempArray["content"] = deepcopy(v)
            if not tempArray["content"].sort or tempArray["content"].sort == "" then
                tempArray["content"].sort = 0
            end
            table.insert(retArr,tempArray)
        end
    end
    local function sortFun( a,b )
        if tonumber(a.content.sort) < tonumber(b.content.sort) then
            return true
        end
        return false
    end
    table.sort( retArr,sortFun )
    return retArr
end

-- 获得活动数目   
function loginActivityData:getActivityCount( )
    return #loginActivityData:getAllActivity(  )
end

-- 获得兑换活动的所有数据
function loginActivityData:getExchangeData( activityName )
    if loginActivityData.activitys then
        if loginActivityData.activitys[activityName] then
            local exchangeData = loginActivityData.activitys[activityName]
            local retData = {}
            if exchangeData.name then
                retData["name"] = exchangeData.name
            end
            if exchangeData.sort then
                retData["sort"] = exchangeData.sort
            end
            local content = {}
            if exchangeData.activities then
                for k,v in pairs(exchangeData.activities) do
                    local itemContent = {}
                    itemContent["uid"] = k
                    itemContent["goldNotEnough"] = false
                    itemContent["itemNotEnough"] = false
                    itemContent["shadowNotEnough"] = false
                    itemContent["heroNotEnough"] = false
                    local disExchange = 0
                    for i=0,2 do
                        local itemId
                        if v.pay[tostring(i)] then
                            itemId = v.pay[tostring(i)].itemId
                            itemContent[tostring(i)] = userdata:getExchangeResource(itemId)
                            itemContent[tostring(i)].needCount = v.pay[tostring(i)].amount
                            if itemContent[tostring(i)].count < itemContent[tostring(i)].needCount then
                                disExchange = disExchange + 1
                                if itemId == "gold" then
                                    itemContent["goldNotEnough"] = true
                                end
                                if havePrefix(itemId, "shadow") then
                                    itemContent["shadowNotEnough"] = true
                                    if not itemContent["shadowName"] then
                                        itemContent["shadowName"] = itemContent[tostring(i)].name
                                    end
                                end

                                if havePrefix(itemId, "hero") then
                                    itemContent["heroNotEnough"] = true
                                    if not itemContent["heroName"] then
                                        itemContent["heroName"] = itemContent[tostring(i)].name
                                    end
                                end

                                if havePrefix(itemId, "weapon_") or havePrefix(itemId, "belt_") or havePrefix(itemId, "armor_") or havePrefix(itemId, "item") or havePrefix(itemId, "book") or havePrefix(itemId, "chapter") or havePrefix(itemId, "stuff") then
                                    itemContent["itemNotEnough"] = true
                                    if not itemContent["notEnoughName"] then
                                        itemContent["notEnoughName"] = itemContent[tostring(i)].name
                                        itemContent["notEnoughId"] = itemId
                                    end
                                end

                            end
                        else
                            itemContent[tostring(i)] = nil
                        end
                        
                    end
                    for key,value in pairs(v.gain) do
                        itemContent["gain"] = userdata:getExchangeResource(value.itemId)
                        itemContent["gain"]["needCount"] = value.amount
                        
                    end
                    itemContent["sort"] = v.sort
                    itemContent["limitNum"] = v.limitNum
                    itemContent["limitType"] = v.limitType
                    itemContent["numbers"] = v.numbers
                    if (disExchange > 0) then
                        itemContent["canExchange"] = false
                    elseif itemContent.limitNum  == itemContent.numbers then
                        itemContent["canExchange"] = false
                    else
                        itemContent["canExchange"] = true
                    end
                    table.insert(content, itemContent)
                    local function sortFun( a,b )
                        return a.sort < b.sort 
                    end
                    table.sort( content,sortFun )
                end
            end
            retData["content"] = content
            return retData
        end
    end
    return {}
end

function loginActivityData:getExchangeName( activityName )
    if loginActivityData.activitys then
        if loginActivityData.activitys[activityName] then
            local exchangeData = deepcopy(loginActivityData.activitys[activityName]) 
            return exchangeData.name
        end
    end
    return "我去名字"
end

function loginActivityData:getExchangeTime( activityName )
    if loginActivityData.activitys then
        if loginActivityData.activitys[activityName] then
            local exchangeData = deepcopy(loginActivityData.activitys[activityName]) 
            local beginTime = exchangeData.activityOpenTime
            local endTime = exchangeData.activityEndTime
            return endTime - userdata.loginTime
        end
    end
    return 3000
end

-- 更新兑换活动的数据
function loginActivityData:updateExchangeData( dic )
    
end
-- 更新活动数据
-- dic  活动数据

function loginActivityData:updataActiveDataByKeyAndDic( dic )
    loginActivityData.activitys = dic
end

-- 获得排好序的所有活动的id（也是名字）
-- 返回排好序的数组结构的活动名字
function loginActivityData:getActivityName(  )
    local retArr = {}
    for k,v in pairs(loginActivityData.activitys) do
        local data = deepcopy(v)
        data.name = k
        table.insert(retArr, data.name)
    end

    return retArr
end

function loginActivityData:getActivityReward( theKey)
    local retArr = {}
    for k,v in pairs(loginActivityData.activitys[theKey].reward) do
        local data = deepcopy(v)
        data.name = k
        table.insert(retArr, data.name)
    end

    return retArr
end

-- 获得所有奖品的名称
function loginActivityData:getActivityRewardName( theKey ,succDays)
    local retArr = {}
    local rewardArr = loginActivityData.activitys[theKey].reward

    for k,v in pairs(rewardArr[tostring(succDays)].reward) do
        table.insert(retArr, k)
    end

    return retArr
end

-- 活动活动开始时间
function loginActivityData:getActivityOpenTime( theKey )
    return loginActivityData.activitys[theKey].activityOpenTime
end

-- 活动活动关闭时间
function loginActivityData:getActivityEndTime( theKey )
    return loginActivityData.activitys[theKey].activityEndTime
end

-- 获得所有活动排序
function loginActivityData:getAllActivitySort( )
    local retArr = {}
    local rewardArr = loginActivityData:getAllActivity( )

    for k,v in pairs(rewardArr) do
        table.insert(retArr, tonumber(v.sort))
    end

    return retArr
end

-- 获取充值返利的时间
function loginActivityData:getPurchaseRebateTimer()
    local dic = loginActivityData.activitys[Activity_Rebate1]
    if not dic or userdata.loginTime >= dic.activityEndTime then
        return 0
    end
    return dic.activityEndTime - userdata.loginTime
end



-- 获取充值返利的数据
function loginActivityData:getPurchaseRebateData()
    local array = {}
    local dic = loginActivityData.activitys[Activity_Rebate1]
    for k,v in pairs(dic.reward) do
        local value = deepcopy(v)
        value.key = k
        table.insert(array, value)
    end
    local function sortFun(a, b)
        return a.goldLimit < b.goldLimit 
    end
    table.sort(array, sortFun)
    return array
end

-- 获取消费返道具的时间
function loginActivityData:getExpenseRebateTimer()
    local dic = loginActivityData.activitys[Activity_Rebate2]
    if not dic or userdata.loginTime >= dic.activityEndTime then
        return 0
    end
    return dic.activityEndTime - userdata.loginTime
end

-- 获取消费返道具的数据
function loginActivityData:getExpenseRebateData()
    local array = {}
    local dic = loginActivityData.activitys[Activity_Rebate2]
    for k,v in pairs(dic.reward) do
        local value = deepcopy(v)
        value.key = k
        table.insert(array, value)
    end
    local function sortFun(a, b)
        return a.goldLimit < b.goldLimit 
    end
    table.sort(array, sortFun)
    return array
end

-- 根据索引获取返金币活动的日期:mm.dd
function loginActivityData:getRebateDateWithIndex(index)
    -- body
    local dic = loginActivityData.activitys[Activity_Rebate3]
    local openTime = DateUtil:beginDay(dic.activityOpenTime)
    return DateUtil:formatMMDDTime(openTime + index * 3600 * 24)
end

-- 获取消费返金币的数据
function loginActivityData:getExpenseRebateGoldData()
    -- body
    local array = {}
    local dic = loginActivityData.activitys[Activity_Rebate3]
    for i=0, table.getTableCount(dic.rewardRecord.dailyRecord) do
        local dic = deepcopy(dic.rewardRecord.dailyRecord[tostring(i)])
        table.insert(array, dic)
    end
    return array
end

-- 获取单笔充值返道具的时间
function loginActivityData:getPurchaseSingleRebateTimer()
    local dic = loginActivityData.activitys[Activity_Rebate4]
    if not dic or userdata.loginTime >= dic.activityEndTime then
        return 0
    end
    return dic.activityEndTime - userdata.loginTime
end


-- 获取消费返金币的数据
function loginActivityData:getPurchaseSingleRebateData()
    -- body
    local array = {}
    local dic = loginActivityData.activitys[Activity_Rebate4]
    for k,v in pairs(dic.reward) do
        local value = deepcopy(v)
        value.key = k
        local itemArr = {}
        for id,cnt in pairs(v.reward) do
            local item = {itemId = id, count = cnt}
            table.insert(itemArr, item)
        end
        value.reward = itemArr
        table.insert(array, value)
    end
    local function sortFun(a, b)
        return a.goldLimit < b.goldLimit 
    end
    table.sort(array, sortFun)
    return array
end

-- 获取单笔充值可领奖次数
function loginActivityData:getPurchaseSingleCanTake()
    local count = 0
    local dic = loginActivityData.activitys[Activity_Rebate4]
    for k,v in pairs(dic.reward) do
        count = count + v.canTake - v.status
    end
    return count
end

-- 获取竞猜数据
function loginActivityData:getQuizData()
    local array = {}
    local dic = loginActivityData.activitys[Activity_Quiz]
    for k,v in pairs(dic) do
        if havePrefix(k, "guess_") then
            local value = deepcopy(v)
            if userdata.loginTime >= v.guessBeginTime and userdata.loginTime < v.guessEndTime then
                value.state = 2
            elseif userdata.loginTime >= v.rewardBeginTime then
                value.state = 3
            else
                value.state = 1
            end
            value.key = k
            table.insert(array, value)
        end
    end
    local function sortFun(a, b)
        return a.state > b.state 
    end
    table.sort(array, sortFun)
    return array
end


-- function loginActivityData:getXXXData()
--     -- body
-- end

function loginActivityData:getQuizGuessTime(key)
    local dic = loginActivityData.activitys[Activity_Quiz][key]
    return math.max(0, dic.guessEndTime - userdata.loginTime)
end


function loginActivityData:getQuizRewardTime(key)
    local dic = loginActivityData.activitys[Activity_Quiz][key]
    return math.max(0, dic.rewardEndTime - userdata.loginTime)
end

function loginActivityData:getQuizDataByKey(key)
    local dic = deepcopy(loginActivityData.activitys[Activity_Quiz][key])
    if userdata.loginTime >= dic.guessBeginTime and userdata.loginTime < dic.guessEndTime then
            dic.state = 2
    elseif userdata.loginTime >= dic.rewardBeginTime then
        dic.state = 3
    else
        dic.state = 1
    end
    dic.key = key
    return dic
end



-- 获取开服冲级王的时间
function loginActivityData:getActivityOfLevelUpTimer()
    local dic = loginActivityData.activitys[Activity_LevelUp]
    if not dic or userdata.loginTime >= dic.activityEndTime then
        return 0
    end
    return dic.activityEndTime - userdata.loginTime
end

--活动 开服冲级王
-- 获得开服冲级王数据
function loginActivityData:getActivityOfLevelUpData()
    local dic = loginActivityData.activitys[Activity_LevelUp]
    local array = {}
    for k,v in pairs(dic.peifang) do
        local content = {}
        content.uid = dic.uid
        content.key = k
        content.isGet = v.isGet or false
        content.level = v.level
        content.reward = {}
        for itemId,count in pairs(v.reward) do
            local reward = {["itemId"] = itemId, ["count"] = count}
            table.insert(content.reward, reward)
        end
        table.insert(array, content)
    end
    local function sortFun(a, b)
        return a.level < b.level 
    end
    table.sort( array, sortFun )
    return array
end


--活动 竞技争霸赛
-- 获得竞技争霸赛数据
function loginActivityData:getActivityOfArenaCompetitionData()
    local dic = loginActivityData.activitys[Activity_Arena]
    local array = {}
    local reward = (not dic.reward or dic.reward ~= "") and dic.reward or false
    for k,v in pairs(dic.rankItems) do
        local content = {}
        content.uid = dic.uid
        content.ranking = dic.ranking
        content.key = k
        content.reward = reward
        content.activityOpenDay = dic.activityOpenDay
        content.activityEndDay = dic.activityEndDay
        content.rewardEndDay = dic.rewardEndDay
        content.items = {}
        for j,value in pairs(v.items) do
            local item = {["itemId"] = value.itemId, ["amount"] = value.amount}
            table.insert(content.items, item)
        end
        content.rank = {}
        content.rank.from = v.rank.from
        -- .from = v.rank.from
        content.rank.to =  v.rank.to
        table.insert(array, content)
    end
    local function sortFun( a,b )
        -- body
        return a.rank.from < b.rank.from
    end
    table.sort( array, sortFun )
    return array
end

-- 获取拼图游戏的时间
function loginActivityData:getActivityOfJigsawPuzzleTimer()
    local dic = loginActivityData.activitys[Activity_JigsawPuzzle]
    if not dic or userdata.loginTime >= dic.activityEndDay then
        return 0
    end
    return dic.activityEndDay - userdata.loginTime
end

-- 获取摇摇乐游戏的时间
function loginActivityData:getActivityOfGambleTimer()
    local dic = loginActivityData.activitys[Activity_Gamble]
    if not dic or userdata.loginTime >= dic.activityEndTime then
        return 0
    end
    return dic.activityEndTime - userdata.loginTime
end

-- 获取摇摇乐游戏的时间
function loginActivityData:isDoubleDropOpen()
    if not loginActivityData.activitys then
        return false
    end
    local dic = loginActivityData.activitys[Activity_DoubleDrop]
    if not dic or userdata.loginTime <= dic.activityOpenTime or userdata.loginTime >= dic.activityEndTime or dic.isOpen ~= 1 then
        return false
    end
    if not dic.difficulty then
        return false
    end
    for i,v in pairs(dic.difficulty) do
        print(i,v)
        if stageMode == STAGE_MODE.NOR then
            if v == "normal" then
                return true
            end
        elseif stageMode == STAGE_MODE.ELITE then
            if v == "elite" then
                return true
            end
        end
    end
    return false
end

-- --活动 拼图游戏
-- -- 获得拼图游戏数据
-- function loginActivityData:getActivityOfJigsawPuzzleData()
--     local dic = loginActivityData.activitys[Activity_JigsawPuzzle]
--     local array = {}
--     local reward = (not dic.reward or dic.reward ~= "") and dic.reward or false
--     for k,v in pairs(dic.reward) do
--         local content = {}
--         content.uid = dic.uid
--         -- content.ranking = dic.ranking
--         -- content.key = k
--         content.reward = reward
--         content.activityOpenDay = dic.activityOpenDay
--         content.activityEndDay = dic.activityEndDay
--         content.rewardEndDay = dic.rewardEndDay
--         content.items = {}
--         for j,value in pairs(v) do
--             local item = {["itemId"] = value.itemId, ["amount"] = value.amount}
--             table.insert(content.items, item)
--         end
--         table.insert(array, content)
--     end
--     return array
-- end
