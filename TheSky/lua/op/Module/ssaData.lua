-- 跨服战用户数据缓存
ssaData = {
    data = {}, -- 数据
    beginTime, --开启时间
    endTime, --结束时间
    servers = {}, --服务器列表
}

ssaDataFlag = {
    home = 1,
    ThirtyTwoRanking = 2, --从身价过亿称号晋升至32新星
    RankingTime = 3, -- 32超新星晋级之路
    RankingEnd = 4, -- 非begin阶段 挑战统一界面(排位赛结束，稍后将公布32强名单)
    FourKing = 5, -- 四皇争霸赛
    enterPoint = 6, -- 积分赛
    Worship = 7, -- 膜拜
    pointRace = 8, --积分赛
    pointRaceRanking = 9,-- 排位晋级赛
}

function ssaData:fromDic(dic)
    if dic then
        if dic["data"] then
            ssaData.data = dic["data"]
        end
        if dic["servers"] then
            ssaData.servers = dic["servers"]
        end
    end
end

--重置用户数据
function ssaData:resetAllData()
    ssaData.data = {}
end

-- loot数据
function ssaData:getRewardData()
    local array = {}
    -- 特殊掉落放第一位
    table.insert(array, ssaData.data.bossReward.special["0"])
    for i=0,3 do
        table.insert(array, ssaData.data.bossReward.normal[tostring(i)])
    end
    return array
end


