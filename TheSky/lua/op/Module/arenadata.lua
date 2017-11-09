-- 用户数据缓存

arenadata = {
    records = {}
}

-- 获得兑换道具配置
function arenadata:getExchangeAward()
    return deepcopy(ConfigureStorage.exchange)
end

-- 获得进入排名奖励
function arenadata:getRecordAward()
    local array = {}
    for k,v in pairs(arenadata.records) do
        local dic = deepcopy(ConfigureStorage.records[v.key])
        dic.state = v.state
        table.insert(array, dic)
    end
    local function sortFun(a, b)
        return a.params[1] > b.params[1]
    end
    table.sort(array, sortFun)
    return array
end

function arenadata:resetAllData()
    arenadata.records = {}
end