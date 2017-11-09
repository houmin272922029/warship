racingBattleData = {
    logTime = nil,
    logs = {},
    index = 1
}

function racingBattleData:insertLog(logs)
    if not racingBattleData.logs then
        racingBattleData.logs = {}
    end
    if not logs or type(logs) ~= "table" or getMyTableCount(logs) <= 0 then
        return
    end
    for k,v in pairs(logs) do
        table.insert(racingBattleData.logs, v)
    end
    local function sortFun(a, b)
        return a.time < b.time 
    end
    table.sort( racingBattleData.logs, sortFun )
end

function racingBattleData:popLog()
    local logs = {}
    if not racingBattleData.logs or getMyTableCount(racingBattleData.logs) == 0 then
        return logs
    end
    print("getMyTableCount(racingBattleData.logs) =", getMyTableCount(racingBattleData.logs))
    if getMyTableCount(racingBattleData.logs) <= 4 then
        racingBattleData.index = 1
    end

    for i=racingBattleData.index,racingBattleData.index + 3 do
        if racingBattleData.logs[i] then
            local log = deepcopy(racingBattleData.logs[i])
            if log then
                table.insert(logs, log)
            end
        end
    end
    racingBattleData.index = math.min(racingBattleData.index + 1,getMyTableCount(racingBattleData.logs) - 3)

    return logs
end

--重置缓存数据
function racingBattleData:resetAllData()
    racingBattleData.logTime = nil
    racingBattleData.logs = {}
    racingBattleData.index = 1
end