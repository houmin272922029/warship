-- 用户数据缓存

-- 日常活动名字
Daily_EatDumpling = "eatDumpling"           -- 吃饭
Daily_Wish = "wish"                         -- 布鲁克的吟唱（许愿）
Daily_Worship = "worship"                   -- 人鱼公主
Daily_Alcohol = "alcohol"                   -- 饮酒
Daily_GuessGame = "guessGame"               -- 猜拳
Daily_Robin = "robin"                       -- 罗宾的花牌
Daily_FantasyTeam = "fantasyTeam"           -- 梦幻海贼团
Daily_Treasure = "treasure"                 -- 幸运卡牌（龙脉探宝）
Daily_GoldenBell = "goldenBell"             -- 黄金钟
Daily_Qingjiao = "qingjiaoTreasure"                         -- 青椒的宝藏
Daily_YUEKA = "yueka"                       -- 月卡
Daily_InstructHeroG = "instructHeroG"       -- 点拨（群体）
Daily_InstructHeroS = "instructHeroS"       -- 点拨（单体）
Daily_LevelUpReward = "upgradeAward"        -- 升级奖励
Daily_PurchaseAward = "refund"              -- 充值返利
Daily_Invite = "invite"                     -- 邀请码
Daily_QingjiaoTresure = "qingjiaoTreasure"  -- 青椒的宝藏
Daily_SecretShop = "secretShop"             --神秘商店
Daily_LuckyReward = "luckyReward"             -- 幸运转盘
Daily_LuckyRank = "luckyRank"             -- 幸运转盘排行
Daily_LuckyShop = "luckyShop"               -- 幸运转盘商店
Daily_DailySignIn = "signIn"             -- 每日签到  新增 记得修改名称
Daily_DrinkWine = "drinkData"             -- zoro饮酒
Daily_Compose = "compose" 
dailyData = {
    daily = {},
}

-- 获得日常活动中的状态是否要在主页的下方“日常”按钮上加上效果以做提示
-- 赵艳秋：在每个活动数据的table中加了一个shouldShine的状态变量
-- 返回值：true/false
function dailyData:getDailyStatus()
    local returnStatus = false
    -- 吃鸡活动可以吃了，则返回true
    local _data = dailyData:getEatData()
    if _data then
        if (_data.status1 == 1 and _data.eatDumplingStatus["0"] == 0) or (_data.status2 == 1 and _data.eatDumplingStatus["1"] == 0) then
            -- 中午开饭时间到了,并且没吃
            dailyData.daily[Daily_EatDumpling].shouldShine = true
            returnStatus = true
        else
            dailyData.daily[Daily_EatDumpling].shouldShine = false
        end 
    end

    -- 赵艳秋

    -- 布鲁克的吟唱
    _data = dailyData:getBluckSingData()
    if _data then
        if _data.wishNumbers < _data.freeTime then
            dailyData.daily[Daily_Wish].shouldShine = true
            returnStatus = true
        else
            dailyData.daily[Daily_Wish].shouldShine = false
        end
    end

    -- 亲吻美人鱼
    _data = dailyData:getMermanData()
    if _data then
        if _data.worshiped == 0 then
            -- 还没有亲吻过
            dailyData.daily[Daily_Worship].shouldShine = true
            returnStatus = true
        else
            dailyData.daily[Daily_Worship].shouldShine = false
        end
    end

    -- 罗宾的花牌
    _data = dailyData:getRobinData()
    if _data then
        if _data.takeReward == 0 then
            -- 还没有翻过牌
            dailyData.daily[Daily_Robin].shouldShine = true
            returnStatus = true
        else
            dailyData.daily[Daily_Robin].shouldShine = false
        end
    end

    -- 幸运卡牌
    _data = dailyData:getTreasureData()
    if _data then
        if _data.times > 0 then
            dailyData.daily[Daily_Treasure].shouldShine = true
            returnStatus = true
        else
            dailyData.daily[Daily_Treasure].shouldShine = false
        end
    end

    -- 梦想海贼团
    _data = dailyData:getFantasyTeamData()
    if _data then
        dailyData.daily[Daily_FantasyTeam].shouldShine = false
        -- 紫色英雄的数量
        local heroCount = getMyTableCount(herodata:getHeroUIdArrByRank( 4 ))

        for i=4,1,-1 do
            if ConfigureStorage.Dreamgift[i].amount <= heroCount then
                if _data.fantasyTeamState[tostring(i)] ~= 2 then
                    -- 没有领过
                    dailyData.daily[Daily_FantasyTeam].shouldShine = true
                    returnStatus = true
                    break                   
                end
            end
        end
    end

    -- 升级奖励
    _data = dailyData:getUpdateAwardData()
    if _data then
        dailyData.daily[Daily_LevelUpReward].shouldShine = false
        for i=0,3 do
            local v = _data[tostring(i)]
            if v.isCondition == 1 and v.isGet == 0 then
                dailyData.daily[Daily_LevelUpReward].shouldShine = true
                returnStatus = true
                break
            end
        end
    end

    -- 邀请码
    _data = dailyData:getInviteData()
    if _data and _data.invatationList then
        dailyData.daily[Daily_Invite].shouldShine = false
        for k,v in pairs(_data.invatationList) do
            if v.canTake ==1 and v.taken == 0 then
                dailyData.daily[Daily_Invite].shouldShine = true
                returnStatus = true
                break
            end
        end
    end

    -- 青椒的宝藏
    _data = dailyData:getQingjiaoTreasureData()
    if _data then
        if _data.freeTimes > 0 then
            -- 有免费的抽奖次数
            dailyData.daily[Daily_QingjiaoTresure].shouldShine = true
            returnStatus = true
        else
            dailyData.daily[Daily_QingjiaoTresure].shouldShine = false
        end
    end

    -- 充值返利
    if dailyData:havaRefoundAwardActive() then
        local canRefund = dailyData.daily[Daily_PurchaseAward].canRefund ~= 0
        if canRefund then
            dailyData.daily[Daily_PurchaseAward].shouldShine = true
            returnStatus = true
        else
            dailyData.daily[Daily_PurchaseAward].shouldShine = false
        end
    end

    -- 神秘商店
    _data = dailyData:getMysteryShopData()
    if _data then
        if runtimeCache.isSecretShopRefresh then
            dailyData.daily[Daily_SecretShop].shouldShine = true
            returnStatus = true
        else
            dailyData.daily[Daily_SecretShop].shouldShine = false
        end
    end

    -- 每日签到
    _data = dailyData:getMySignInData()
    if _data then
        local month = _data.month
        local dic = ConfigureStorage[string.format("HZ_SignIn_reward_%d", month)]
        local signInRecord = _data.signInRecord

        local getRewardCount = getMyTableCount(_data.signInRecord) -- 已经签到的次数
        local supplCount  -- 可补签的次数

        local tday = true
        if _data.tday == "" then
            tday = false
        end          

        if not tday then  --  今天没签
            supplCount = _data.day - getRewardCount - 1
        else
            supplCount = _data.day - getRewardCount
        end
        if tday and supplCount == 0 then
            dailyData.daily[Daily_DailySignIn].shouldShine = false
            returnStatus = false
        else
            dailyData.daily[Daily_DailySignIn].shouldShine = true
            returnStatus = true
        end
    end
    --饮酒
    _data = dailyData:getDrinkWineData()  --
    if _data then
        if _data.drinkCount < 3 then
            dailyData.daily[Daily_DrinkWine].shouldShine = true
            returnStatus = true
        else
            dailyData.daily[Daily_DrinkWine].shouldShine = false
        end
    end

    return returnStatus
end

-- 得到布鲁克的吟唱英雄的期望
function dailyData:getWishHeroIDbyId( heroID )
    local sing = deepcopy(ConfigureStorage.sing)
    if sing[heroID] then
        return sing[heroID]["expect"]["hero"]
    else
        return nil
    end
end

-- 得到活动结束时间
function dailyData:getBellEndTime(  )
    local endTime = dailyData.daily.goldenBell.activityEndTime
    -- print("时间",endTime,userdata.loginTime,endTime - userdata.loginTime)
    return DateUtil:second2dhms(endTime - userdata.loginTime)
end

-- 得到青椒宝藏活动结束时间
function dailyData:getQingjiaoEndTime( endTime )
    -- local endTime = dailyData.daily.goldenBell.activityEndTime
    -- print("时间",endTime,userdata.loginTime,endTime - userdata.loginTime)
    return DateUtil:second2dhms(endTime - userdata.loginTime)
end
-- 卡牌信息
function dailyData:getQingjiaoConf(  )
    -- body
    return ConfigureStorage.qjType
end
function dailyData:getQingjiaoDegree(  )
    -- body
    return ConfigureStorage.qjDegree["1"].max
end
-- 得到下一次敲钟需要金币数
function dailyData:getNextClickGold(  )
    local clickBellTimes = dailyData.daily.goldenBell.times
    if clickBellTimes then
        if clickBellTimes and clickBellTimes >= 8 then
            return 0
        else
            return ConfigureStorage.GoldenBell[tostring(clickBellTimes + 1)].demand
        end
    else
        return 0
    end
end

-- 得到下一次敲钟投入产出
function dailyData:getGoldenTipsProb()
    local clickBellTimes = dailyData.daily.goldenBell.times
    if clickBellTimes then
        if clickBellTimes and clickBellTimes >= 8 then
            return 0, 0, 0
        else
            local conf = ConfigureStorage.GoldenBell[tostring(clickBellTimes + 1)]
            local need = conf.demand
            local range = string.split(conf.range, "-")
            return need, math.floor(need * tonumber(range[1])), math.floor(need * tonumber(range[2]))
        end
    else
        return 0, 0, 0
    end
end

-- 获取神秘商店距离下次刷新的时间 renzhan newadd
function dailyData:getMysteryShopRefreshTimer()
    local dic = dailyData.daily[Daily_SecretShop]
    if not dic or userdata.loginTime >= dic.lastFlushTime + dic.interval then
        return 0
    end
    return dic.interval - (userdata.loginTime - dic.lastFlushTime)
end

-- 获得吃饭活动的用于UI显示的数据
function dailyData:getEatData()
    local data = dailyData:getDailyDataByName(Daily_EatDumpling)
    if data == nil then
        return nil
    end 
    data.status1 = 0        -- 当前时间是否在第一顿饭的时间内  0：时间没到 1：时间到了 2：时间过了
    data.status2 = 0        -- 当前时间是否在第二顿饭的时间内  0：时间没到 1：时间到了 2：时间过了
    if userdata.loginTime > data.time["0"]["start"] and userdata.loginTime < data.time["0"]["end"] then
        data.status1 = 1
    elseif userdata.loginTime >= data.time["0"]["end"] then
        data.status1 = 2
    end 
    if userdata.loginTime > data.time["1"]["start"] and userdata.loginTime < data.time["1"]["end"] then
        data.status2 = 1
    elseif userdata.loginTime >= data.time["1"]["end"] then
        data.status2 = 2
    end 
    return data
end

-- 更新吃饭活动的缓存数据
function dailyData:updateEatData(data)
    dailyData.daily[Daily_EatDumpling] = data
end

-- 获得梦想海贼团的数据
function dailyData:getFantasyTeamData()
    return dailyData:getDailyDataByName(Daily_FantasyTeam)
end

-- 更新梦想海贼王数据
function dailyData:updateFantasyTeamData(data)
    dailyData.daily[Daily_FantasyTeam] = data
end

-- 得到梦想海贼团活动结束时间
function dailyData:getFantasyTeamEndTime(  )
    local data = dailyData:getFantasyTeamData()
    local tiemDur = data.activityEndTime - userdata.loginTime
    return DateUtil:second2dhms(tiemDur)
end

-- 获得布鲁克的吟唱的数据
function dailyData:getBluckSingData()
    return dailyData:getDailyDataByName(Daily_Wish)
end

-- 跟新布鲁克的信息
function dailyData:updateBluckSingData( count )
    dailyData.daily[Daily_Wish].wishNumbers = count
end

-- 获取邀请码页面数据
function dailyData:getInviteData()
    return dailyData:getDailyDataByName(Daily_Invite)
end

function dailyData:updateInviteData(data)
    dailyData.daily[Daily_Invite] = data
end

-- 获得人鱼活动的用于UI显示的数据
function dailyData:getMermanData()
    return dailyData:getDailyDataByName(Daily_Worship)
end

-- 获得罗宾的花牌的用于UI显示的数据
function dailyData:getRobinData()
    return dailyData:getDailyDataByName(Daily_Robin)
end

-- 获得升级奖励的数据
function dailyData:getUpdateAwardData()
    return dailyData:getDailyDataByName(Daily_LevelUpReward)
end

-- 获得青椒宝藏的数据
function dailyData:getQingjiaoTreasureData()
    return dailyData:getDailyDataByName(Daily_QingjiaoTresure)
end

-- 获得青椒宝藏的数据
function dailyData:updateQingjiaoTreasureData(data)
    dailyData.daily[Daily_QingjiaoTresure] = data
end

-- 更新升级奖励数据
function dailyData:updateLevelUpAwardData(data)
    dailyData.daily[Daily_LevelUpReward] = data
end

-- 更新人与活动的用于UI显示的数据
function dailyData:updateMermanData(data)
    dailyData.daily[Daily_Worship] = data
end 

-- 更新幸运卡牌的用于UI显示的数据
function dailyData:getTreasureData()
    return dailyData:getDailyDataByName(Daily_Treasure)
end 

function dailyData:updateTreasureData(data)
    if not dailyData.daily[Daily_Treasure] then
        dailyData.daily[Daily_Treasure] = {}
    end
    for k,v in pairs(data) do
        dailyData.daily[Daily_Treasure][k] = v
    end
end

-- 获得神秘商店数据 renzhan newAdd
function dailyData:getMysteryShopData()
    return dailyData:getDailyDataByName(Daily_SecretShop)
end

-- -- 更新神秘商店数据 renzhan newAdd
function dailyData:updateMysteryShopAwardData(data)
    if data then
        if table.getTableCount(data) == 0 then
            dailyData.daily[Daily_SecretShop] = nil
            return
        end
        data.sort = 1
        dailyData.daily[Daily_SecretShop] = data
    end 
end

-- 删除神秘商店数据
function dailyData:deleteMysteryShopData()
    -- postNotification(NOTI_DAILY_REFRESH, nil)
    dailyData.daily[Daily_SecretShop] = nil
end

-- 获得神秘商店所有兑换的商品信息  renzhan newAdd
function dailyData:getMysteryShopAwardData()
    local itemsArray = {}
    if dailyData.daily[Daily_SecretShop] then
        for k,v in pairs(dailyData.daily[Daily_SecretShop].items) do
            table.insert(itemsArray, v)
        end
    end
    return itemsArray
end


-- 获得每日签到数据 
function dailyData:getMySignInData()
    local data = dailyData:getDailyDataByName(Daily_DailySignIn)
    if data == nil then
        return nil
    end 
    return data
end

-- 更新每日签到数据 
function dailyData:updateMySignInData(data)
    if data then
        if table.getTableCount(data) == 0 then
            dailyData.daily[Daily_DailySignIn] = nil
            return
        end
        data.sort = 3
        dailyData.daily[Daily_DailySignIn] = data
    end 
end

-- 删除每日签到数据
function dailyData:deleteSignInData()
    dailyData.daily[Daily_DailySignIn] = nil
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

-- 获得zero饮酒数据   lsf 
function dailyData:getDrinkWineData()
    local data = dailyData:getDailyDataByName(Daily_DrinkWine)
    if data == nil then
        return nil
    end 
    return data
end


-- 更新zero饮酒数据 
function dailyData:updateMyDrinkWineData(data)
    if data then
        if table.getTableCount(data) == 0 then
            dailyData.daily[Daily_DailyDrinkWine] = nil
            return
        end
        dailyData.daily[Daily_DrinkWine] = data
    end 
end

-- 删除zero饮酒数据
function dailyData:deleteDrinkWineData()
    dailyData.daily[Daily_DailyDrinkWine] = nil
end




-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 


-- 获得日常活动个数
function dailyData:getDailyCount()
    return table.getTableCount(dailyData.daily)
end

-- 获得排好序的所有活动的id（也是名字）
-- 返回排好序的数组结构的活动名字
function dailyData:getAllDailyData(  )
    local retArr = {}
    for k,v in pairs(dailyData.daily) do
        local data = deepcopy(v)
        local names = string.split(k, "_")
        data.name = names[1]
        if #names > 1 then
            data.id = names[2]
        end
        table.insert(retArr, data)
    end
    local function sortFun(a, b)
        if type(a.sort) == "number" and type(b.sort) == "number" then
            return a.sort < b.sort
        end
    end
    table.sort( retArr, sortFun )

    return retArr
end

-- 获得日常某个活动的数据
-- 参数：活动名称
function dailyData:getDailyDataByName( name )
    if nil == name then 
        return nil
    end 
    return deepcopy(dailyData.daily[name])
end

--重置日常活动数据
function dailyData:resetAllData()
    dailyData.daily = {}
end

-- 群体点拨成功
function dailyData:getGroupInstructSucc(instructId)
    dailyData.daily["instructHeroG_"..instructId] = nil
end

-- 获得单体点拨的数据
function dailyData:getSingleInstructInfo()
    local array = {} 
    for id,v in pairs(dailyData.daily["instructHeroS"]) do
        if id ~= "sort" then
            local dic = deepcopy(v)
            dic.id = id
            table.insert(array, dic)
        end
    end
    return array
end

function dailyData:getSingleHeroId(instructId)
    return dailyData.daily["instructHeroS"][instructId].heroId
end

function dailyData:getSingleInstructSucc(instructId)
    dailyData.daily["instructHeroS"][instructId] = nil
    if table.getTableCount(dailyData.daily["instructHeroS"]) == 1 and dailyData.daily["instructHeroS"].sort then
        dailyData.daily["instructHeroS"] = nil
    end
end

-- 获得活动所在页面
-- hint： 群体点拨活动需要传入整个key(instructHeroG_xxxxxx)
function dailyData:getDailyPage(name)
    local data = dailyData:getAllDailyData()
    local page = 0
    local names = string.split(name, "_")
    for i,v in ipairs(data) do
        if #names > 1 then
            if v.name == names[1] and v.id == names[2] then
                page = i - 1
                break
            end
        else
            if v.name == name then
                page = i - 1
                break
            end
        end
    end
    return page
end

-- 跳转到页码
function dailyData:gotoPage(goto)
    print(goto)
    if not goto then
        return 0
    end
    local data = dailyData:getAllDailyData()
    local page = 0
    for i,v in ipairs(data) do
        if (goto == "song" and v.name == Daily_Wish) or (goto == "twisterdfate" and v.name == Daily_Treasure) then
            -- TODO 还差一个无风带
            page = i - 1
            break
        end
    end
    return page
end

function dailyData:updateTreasure(dic)
    if dic.newPosition then
        dailyData.daily[Daily_Treasure].position = dic.newPosition
    end
    if dic.position then
        dailyData.daily[Daily_Treasure].position = dic.position
    end
    if dic.map then
        dailyData.daily[Daily_Treasure].map = dic.map
    end
    if dic.times then
        dailyData.daily[Daily_Treasure].times = dic.times
    end
end

function dailyData:getTreasureAward()
    local array = {}
    for k,v in pairs(ConfigureStorage.rollingTable) do
        if v.itemId == "x3" or string.find(v.itemId, "dice") then
        elseif not table.ContainsObject(array, v.itemId) then
            table.insert(array, v.itemId)
        end
    end
    return array
end

function dailyData:getTreasureAwardByDic(dic)
    local array = {}
    for k,v in pairs(dic) do
        local dic = ConfigureStorage.rollingTable[tostring(k)]
        if dic.itemId == "x3" or string.find(dic.itemId, "dice") then
        else
            array[dic.itemId] = dic.amount * v
        end
    end
    return array
end

-- 获得充值返利活动充值阶段剩余时间
function dailyData:getPurchaseAwardTime()
    return math.max(dailyData.daily[Daily_PurchaseAward].activityOpenTime + dailyData.daily[Daily_PurchaseAward].chargeDuration  - userdata.loginTime, 0)
    -- return 0
end


-- 是否有充值返利活动
function dailyData:havaRefoundAwardActive(  )
    if dailyData.daily[Daily_PurchaseAward] then
        return true 
    else
        return false
    end
end

function dailyData:getPAStage()
    local range = ConfigureStorage.rebate[dailyData.daily[Daily_PurchaseAward].phaseId + 1].range
    local stage = 1
    for i,v in ipairs(range) do
        stage = i
        if dailyData.daily[Daily_PurchaseAward].goldCharge < v then
            break
        end
    end
    return stage
end

function dailyData:getPARange()
    local range = ConfigureStorage.rebate[dailyData.daily[Daily_PurchaseAward].phaseId + 1].range
    local stage = dailyData:getPAStage()
    local min = 0
    if stage > 1 then
        min = range[stage - 1]
    end
    local max = range[stage]
    return min,max
end

function dailyData:getPAConfig()
    return deepcopy(ConfigureStorage.rebate[dailyData.daily[Daily_PurchaseAward].phaseId + 1])
end

--获取邀请码礼包数据
function dailyData:getInviteRewardData()
    return deepcopy(ConfigureStorage.invitationAward)
end

function dailyData:getMonthCardConf( )
    -- body
    return deepcopy(ConfigureStorage.monthCardShop)
end

function dailyData:deleteMonthCardData( )
    -- body
    dailyData.daily[Daily_YUEKA] = nil
end

-- 刷新神秘商店数据
function dailyData:getsecretShopData( )
    local function getInfoCallBack(url, rtnData)

    end
    doActionNoLoadingFun("DAILY_GET_SECRETSHOP", {}, getInfoCallBack)
end

-- 幸运转盘关闭时间
function dailyData:getLuckyRewardCloseTime()
    return math.max(0, dailyData.daily[Daily_LuckyReward].endTime - userdata.loginTime)
end

-- 幸运排行榜时间
function dailyData:getLuckyRankTime()
    if userdata.loginTime < dailyData.daily[Daily_LuckyRank].endTime then
        return math.max(0, dailyData.daily[Daily_LuckyRank].endTime - userdata.loginTime)
    else
        return math.max(0, dailyData.daily[Daily_LuckyRank].rankEndTime - userdata.loginTime)
    end
end

-- 幸运排行榜时间段
function dailyData:getLuckyRankState()
    return userdata.loginTime < dailyData.daily[Daily_LuckyRank].endTime and 1 or 2
end


