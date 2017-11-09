bossdata = {
	lastBoss = {},
	thisBoss = {},
    logTime = nil,
    logs = {},
    hasCheckedFirst = false,
    hasCheckedSecond = false,
}

function bossdata:getLastRank()
	local array = {}
	if bossdata.lastBoss.rank and type(bossdata.lastBoss.rank) == "table" then
        for k,v in pairs(bossdata.lastBoss.rank) do
        	table.insert(array, v)
        end
    end
    local function sortFun(a, b)
    	return a.rank < b.rank
    end
    table.sort( array, sortFun )
    return array
end

function bossdata:insertLog(logs)
    if not bossdata.logs then
        bossdata.logs = {}
    end
    if not logs or table.getTableCount(logs) <= 0 then
        return
    end
    for k,v in pairs(logs) do
        table.insert(bossdata.logs, v)
    end
    local function sortFun(a, b)
        return a.time < b.time 
    end
    table.sort( bossdata.logs, sortFun )
end

function bossdata:popLog()
    if not bossdata.logs or #bossdata.logs == 0 then
        return nil
    end
    local log = deepcopy(bossdata.logs[1])
    table.remove(bossdata.logs, 1)
    return log
end

-- 获取上次排行信息
function bossdata:getRank()
    local array = {}
    for k,v in pairs(bossdata.lastBoss.rank) do
        local dic = deepcopy(v)
        dic["type"] = 1
        table.insert(array, dic)
    end
    local function sortFun(a, b)
        return a.rank < b.rank 
    end
    table.sort(array, sortFun)
    if bossdata.lastBoss.finalKiller then
        local dic = deepcopy(bossdata.lastBoss.finalKiller)
        dic["type"] = 0 -- 击杀
        table.insert(array, 1, dic)
    end
    return array
end

-- 恶魔谷boss是否开战
-- 返回值：true/false
function bossdata:bBossFight()
    -- boss战
    if userdata.level < ConfigureStorage.levelOpen.boss.level then
        return 0
    end
    local begin = DateUtil:beginDay(userdata.loginTime)
    if userdata.loginTime >= begin + 3600 * 12.5 and userdata.loginTime < begin + 3600 * 13 then
        return 1
    elseif userdata.loginTime >= begin + 3600 * 20.5 and userdata.loginTime < begin + 3600 * 21 then
        return 2
    else
        return 0
    end
end

-- 下一次可挑战的时间
function bossdata:nextTime()
    -- if not bossdata.thisBoss or not bossdata.thisBoss.beginTime then
    --     return -1
    -- end
    -- return math.max(0, bossdata.thisBoss.beginTime - userdata.loginTime)
    local begin = DateUtil:beginDay(userdata.loginTime)
    local ts = begin + 3600 * 12.5 - userdata.loginTime
    if ts > 0 then
        return ts
    else
        ts = begin + 3600 * 18.5 - userdata.loginTime
        if ts > 0 then
            return ts
        else
            ts = begin + 3600 * 12.5 + 3600 * 24 - userdata.loginTime
            return ts
        end
    end
    return -1
end

--重置缓存数据
function bossdata:resetAllData()
	bossdata.lastBoss = {}
	bossdata.thisBoss = {}
    bossdata.logTime = nil
    bossdata.logs = {}
    hasCheckedFirst = false
    hasCheckedSecond = false
end