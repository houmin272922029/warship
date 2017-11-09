uninhabitedData = {
    data = nil,
}

-- 当前状态 0未训练1训练中2训练结束
function uninhabitedData:getState()
    local aggress = uninhabitedData.data.aggress or {}
    local exercise = aggress.exercise or {}
    return exercise.isExing or 0
end

function uninhabitedData:getCurBlood()
    local aggress = uninhabitedData.data.aggress or {}
    local exercise = aggress.exercise or {}
    return exercise.curBlood or 0
end

-- 开始训练的次数和花费
function uninhabitedData:getStartCost()
    local aggress = uninhabitedData.data.aggress or {}
    local exercise = aggress.exercise or {}
    local exTimes = exercise.exTimes or 0
    local max = table.getTableCount(ConfigureStorage.aggress_bloodunfree)
    return exTimes, ConfigureStorage.aggress_bloodunfree[tostring(math.min(exTimes + 1, max))].num
end

-- 免费开始训练次数
function uninhabitedData:getStartFreeCount() 
    local count = 0
    for i = 1, table.getTableCount(ConfigureStorage.aggress_bloodunfree) do
        local num = ConfigureStorage.aggress_bloodunfree[tostring(i)].num
        if num == 0 then
            count = count + 1
        else
            return count
        end
    end
    return count
end

-- 加强训练花费
function uninhabitedData:getEnhanceCost()
    local aggress = uninhabitedData.data.aggress or {}
    local exercise = aggress.exercise or {}
    return exercise.enhanceCost or 0
end

--重置缓存数据
function uninhabitedData:resetAllData()
    uninhabitedData.data = nil
end