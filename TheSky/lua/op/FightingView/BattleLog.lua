-- 数据结构
fightAction = {
    action = nil,
    result = {},
}

BattleLog = {
    logs = {},
    offset = 1,
    animationLogs = {},
}

-- 是否存在下一条
function BattleLog:hasNext()
    -- body
    return BattleLog.offset <= #BattleLog.animationLogs
end

-- 添加新日志
function BattleLog:addLog(action, log)
    -- body
    local fa = {}
    fa.action = action
    fa.result = {}
    if (type(log) == "table" and #log > 0) or type(log) == "number" or type(log) == "string" then
        table.insert(fa.result, log)
    end
    table.insert(BattleLog.logs, fa)
end

-- 追加日志
function BattleLog:appendLog(log)
    -- body
    local fa = BattleLog.logs[#BattleLog.logs]
    table.insert(fa.result, log)
end

-- 获取全部日志
function BattleLog:readAllLogs()
    -- body
    BattleLog.offset = #BattleLog.animationLogs + 1
    return BattleLog.animationLogs
end

-- 索引获取日志信息
function BattleLog:readLogWithIndex(index)
    -- body
    BattleLog.offset = index
    return BattleLog.animationLogs[BattleLog.offset]
end

-- 索引获取日志类别
function BattleLog:readLogActionWithIndex(index)  
    -- body
    BattleLog.offset = index
    return BattleLog.animationLogs[BattleLog.offset].action
end

-- 加载日志信息
function BattleLog:loadLogsWithArray(array)
    -- body
    BattleLog.logs = {}
    for i,v in ipairs(array) do
        local fa = {}
        fa.action = v["action"]
        fa.result = v["result"]
        table.insert(BattleLog.logs, fa)
    end
end

-- 游标清零
function BattleLog:reset()
    -- body
    BattleLog.offset = 1
end

-- 获取下一条log的action
function BattleLog:checkNextAction()
    -- body
    return BattleLog.animationLogs[BattleLog.offset].action
end

-- 获取下一条log
function BattleLog:nextLog()
    if BattleLog:hasNext() then
        local fa = BattleLog.animationLogs[BattleLog.offset]
        BattleLog.offset = BattleLog.offset + 1
        return fa
    end
    return nil
end

-- 生成动画log
function BattleLog:convertAnimationLogs()
    -- body
    BattleLog.animationLogs = {}
    -- BattleLog.logs = readJsonFileStr("onepiece")
    if BattleLog.logs then
        BattleLog.animationLogs = deepcopy(BattleLog.logs)
    end
end


function BattleLog:clearLogs()
    -- body
    BattleLog.logs = {}
    BattleLog.animationLogs = {}
    BattleLog.offset = 1
end

function BattleLog:getJson()
    --PrintTable(BattleLog.logs)
end



