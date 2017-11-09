worldwardata = {
    playerData = nil,
    islandData = nil, -- 海岛总览
    countryRank = nil,
    island = nil, -- 海岛详情
    scoreRank = nil, -- 战绩排行榜
    leaderInfo = nil, -- 官职
    yesterdayRank = nil, -- 昨日阵营排行
}

-- 刷新国战数据
function worldwardata:fromDic(dic)
    if not dic then
        return
    end
    if dic.playerData and type(dic.playerData) == "table" then
        worldwardata.playerData = dic.playerData
    end
    if dic.islandData and type(dic.islandData) == "table" then
        worldwardata.islandData = dic.islandData
    end
    if dic.countryRank and type(dic.countryRank) == "table" then
        worldwardata.countryRank = dic.countryRank
    end
    if dic.island and type(dic.island) == "table" then
        worldwardata.island = dic.island
    end
    if dic.scoreRank and type(dic.scoreRank) == "table" then
        worldwardata.scoreRank = dic.scoreRank
    end
    if dic.leaderInfo and type(dic.leaderInfo) == "table" then
        worldwardata.leaderInfo = dic.leaderInfo
    end
    if dic.yesterdayRank and type(dic.yesterdayRank) == "table" then
        worldwardata.yesterdayRank = dic.yesterdayRank
    end
end

function worldwardata:resetAllData()
    worldwardata.playerData = nil
    worldwardata.islandData = nil
    worldwardata.countryRank = nil
    worldwardata.island = nil
    worldwardata.scoreRank = nil
    worldwardata.leaderInfo = nil
    worldwardata.yesterdayRank = nil
end

-- 获得推荐阵营
function worldwardata:getRecommendGroup()
    if not worldwardata.countryRank then
        return 1
    end
    return tonumber(string.split(worldwardata.countryRank["2"], "_")[2])
end

-- 获取占领岛屿数量
function worldwardata:getCaptureCount()
    local count = 0
    for k,v in pairs(worldwardata.islandData) do
        if v.countryId == worldwardata.playerData.countryId then
            count = count + 1
        end
    end
    return count
end

-- 岛屿名字
function worldwardata:getIslandName(islandId)
    return ConfigureStorage.WWIsland[islandId].name
end

-- 迁徙cd
function worldwardata:getSettleCD()
    local lastTime = worldwardata.playerData.changeIslandLastTime or 0
    local cd = lastTime + ConfigureStorage.WWCDTime.changeIsland - userdata.loginTime
    return math.max(0, cd)
end

-- 侦察剩余时间
function worldwardata:getScoutCD(islandId)
    local lastTime = worldwardata.playerData.scoutData[islandId] or 0
    local cd = lastTime + ConfigureStorage.WWCDTime.scoutIsland - userdata.loginTime
    return math.max(0, cd)
end

-- 热血剩余时间
function worldwardata:getBloodCD()
    local endTime = worldwardata.playerData.bloodBuffEndtime or 0
    local cd = endTime - userdata.loginTime
    return math.max(0, cd)
end

-- 更换阵营cd时间
function worldwardata:getChangeGroupCD()
    local lastTime = worldwardata.playerData.changeCountryLastTime or 0
    local cd = lastTime + ConfigureStorage.WWCDTime.changeCountry - userdata.loginTime
    return math.max(0, cd)
end

-- a与b岛是否连接
function worldwardata:bLink(a, b)
    local conf = ConfigureStorage.WWIsland[a]
    for k,v in pairs(conf.link) do
        if v == b then
            return true
        end
    end
    return false
end

-- 获取实验室数据
function worldwardata:getScienceData()
    local data = worldwardata.playerData.scienceData
    local skills = data.skills
    local array = {}
    for i=0, table.getTableCount(skills) - 1 do
        local dic = skills[tostring(i)]
        local scienceId = ConfigureStorage.WWScienceId[dic.key + 1].scienceId
        local conf = deepcopy(ConfigureStorage.WWScience[scienceId])
        conf.status = dic.status
        table.insert(array, conf)
    end
    return array
end

-- 当前岛屿可否迁徙
function worldwardata:bCanSettle()
    -- 该岛不是基地
    local conf = ConfigureStorage.WWIsland[worldwardata.island.islandId]
    local flag = tonumber(conf.type) ~= 1
    -- 该岛屿是我方或中立，并且不在此岛上
    flag = flag and (worldwardata.island.country == worldwardata.playerData.countryId or 
        not worldwardata.island.country or worldwardata.island.country == "") 
        and worldwardata.island.islandId ~= worldwardata.playerData.islandId
    -- 查询此岛是否连接
    return flag and worldwardata:bLink(worldwardata.island.islandId, worldwardata.playerData.islandId) 
end

function worldwardata:getDurabilityMax(level)
    return ConfigureStorage.WWDurable[level + 1].durable
end

-- 获取战舰图标
function worldwardata:getShipIcon(level, campId)
    return string.format("%s_%d.png",ConfigureStorage.WWDurable[level + 1].icon, tonumber(string.split(campId, "_")[2]))
end

-- 获取总页码
function worldwardata:getPageMax()
    local members = worldwardata.island.members
    if not members then
        return 1
    end
    local max = 0
    for k,v in pairs(members) do
        if v and v ~= "" then
            max = math.max(tonumber(k), max)
        end
    end
    local count = max + 1 -- 索引从0开始排的, 这里表示已经占了多少个坑
    return count % 9 == 0 and math.floor(count / 9) or math.floor(count / 9) + 1
end

-- 获取自己所在页码
function worldwardata:getSelfPage()
    local members = worldwardata.island.members
    if not members then
        return 1
    end
    local index = 1
    for k,v in pairs(members) do
        if v and v ~= "" and v.id == userdata.userId then
            index = tonumber(k) + 1
            break
        end
    end
    return index % 9 == 0 and math.floor(index / 9) or math.floor(index / 9) + 1
end

-- 实验室是否能开启新格子
function worldwardata:bCanOpen()
    local conf = ConfigureStorage.WWScienceOpen
    local count = table.getTableCount(worldwardata.playerData.scienceData.skills)
    return count < table.getTableCount(conf)
end

-- 开通需要的配置
function worldwardata:getOpenConf()
    local conf = ConfigureStorage.WWScienceOpen
    local count = table.getTableCount(worldwardata.playerData.scienceData.skills)
    return conf[tostring(count + 1)]
end

-- 剩余重置次数
function worldwardata:getResetCountLeft()
    local total = ConfigureStorage.WWDefault.scienceResetCount
    local count = worldwardata.playerData.scienceData.resetCount
    return math.max(total - count, 0)
end

-- 获得战绩榜
function worldwardata:getScoreRank()
    local array = {}
    for i=0, table.getTableCount(worldwardata.scoreRank) - 1 do
        local dic = worldwardata.scoreRank[tostring(i)]
        table.insert(array, dic)
    end
    return array
end

-- 获取腐蚀药剂
function worldwardata:getDamageItem()
    local array = {}
    for i=1,5 do
        local itemId = ConfigureStorage.WWItemUse[string.format("Damage_%02d", i)].itemId
        local count = wareHouseData:getItemCountById(itemId)
        if count > 0 then
            local conf = wareHouseData:getItemConfig(itemId)
            conf.itemId = itemId
            conf.count = count
            table.insert(array, conf)
        end
    end
    return array
end

-- 功能是否开放
function worldwardata:bOpen()
    if ConfigureStorage.levelOpen["countryBattle"] then
        return userdata.level >= ConfigureStorage.levelOpen["countryBattle"].level
    end
    return false
end

function worldwardata:openLevel()
    if ConfigureStorage.levelOpen["countryBattle"] then
        return ConfigureStorage.levelOpen["countryBattle"].level
    end
    return nil
end

-- 获得总战绩当前档次[min, max]
function worldwardata:getAllScoreMinMax()
    local min = 0
    local max = nil
    local get = (worldwardata.playerData.scoreRewardRecordAll ~= nil and type(worldwardata.playerData.scoreRewardRecordAll) == "table") 
        and table.getTableCount(worldwardata.playerData.scoreRewardRecordAll) or 0 -- 已领取过的最大state
    if get > 0 then
        min = ConfigureStorage.WWTotalTask[get].record
    end
    local conf = ConfigureStorage.WWTotalTask[get + 1]
    if not conf then
        return min, max
    end
    max = conf.record
    return min, max
end

function worldwardata:getAllScoreReward()
    local get = (worldwardata.playerData.scoreRewardRecordAll ~= nil and type(worldwardata.playerData.scoreRewardRecordAll) == "table") 
        and table.getTableCount(worldwardata.playerData.scoreRewardRecordAll) or 0 -- 已领取过的最大state
    local conf = ConfigureStorage.WWTotalTask[get + 1]
    local array = {}
    for k,v in pairs(conf.reward) do
        local dic = {["itemId"] = k, ["count"] = v}
        table.insert(array, dic)
    end
    return array
end



