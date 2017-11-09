-- 用户数据缓存
veiledSeaData = {
    data = {}, -- 数据
    myBest = {}, --包括玩家最好成绩
    yesterdayBest = {}, --昨日最强
    allBest = {}, --史上最强
}

veiledSeaDataFlag = {
    home = 0,
    selectEnemy = 1,
    challenge = 2,
    reward = 3,
    lose = 4,
    other = 5, --打爆了
}

function veiledSeaData:fromDic(dic)
    if dic then
        if dic["seaMist"] then
            veiledSeaData.data = dic["seaMist"]
        end
        if dic["myBest"] then
            veiledSeaData.myBest = dic["myBest"]
        end
        if dic["yesterdayBest"] then
            veiledSeaData.yesterdayBest = dic["yesterdayBest"]
        end
        if dic["allBest"] then
            veiledSeaData.allBest = dic["allBest"]
        end
    end
end

function veiledSeaData:seaMistDataFromDic(dic)
    if dic then
        veiledSeaData.data = dic
    end
end
function veiledSeaData:getBossId()
    local bossInfo = veiledSeaData.data.bossOptions
    local bossArray = {}
    for k,v in pairs(bossInfo) do
        table.insert(bossArray,v)
    end
    return bossArray
end

function veiledSeaData:dailyFreeCount()
    local eysFreeCount = ConfigureStorage.SeaMiEyes[1].dailyfree
    return eysFreeCount - veiledSeaData.data.playCount > 0 and eysFreeCount - veiledSeaData.data.playCount or 0
end

--重置用户数据
function veiledSeaData:resetAllData()
    veiledSeaData.data = {}
end

-- loot数据
function veiledSeaData:getRewardData()
    local array = {}
    -- 特殊掉落放第一位
    table.insert(array, veiledSeaData.data.bossReward.special["0"])
    for i=0,3 do
        table.insert(array, veiledSeaData.data.bossReward.normal[tostring(i)])
    end
    return array
end


