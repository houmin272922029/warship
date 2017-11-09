-- 用户数据缓存

elitedata = {
    record = nil,
    currentStage = "elitestage_0001_01",
}

--重置用户数据
function elitedata:resetAllData()
    elitedata.record = nil
    elitedata.currentStage = "elitestage_0001_01"
end

-- 大关卡是否解锁
function elitedata:bigStageUnlock(bigStage)
    local conf = ConfigureStorage.elitePage[bigStage]
    local goon = conf.goon
    local needLv = conf.needLv
    local bigIndex = tonumber(string.sub(storydata.record, 7, 8))
    return userdata.level >= needLv and string.format("stage_%02d", bigIndex) > goon
end

-- 检查大关卡是否解锁
function elitedata:checkBigStage(bigStage)
    local conf = ConfigureStorage.elitePage[bigStage]
    local goon = conf.goon
    local needLv = conf.needLv
    local bigIndex = tonumber(string.sub(storydata.record, 7, 8))
    if userdata.level < needLv then
        ShowText(HLNSLocalizedString("stage.elite.lock.lv", needLv))
        return false
    elseif string.format("stage_%02d", bigIndex) <= goon then
        ShowText(HLNSLocalizedString("stage.elite.lock.stage", ConfigureStorage.pageConfig[goon].pageName))
        return false
    end
    return true
end

-- 获得大关数据 
function elitedata:getBigStages()
    local array = {}
    local lockCount = 0
    for i=1, table.getTableCount(ConfigureStorage.elitePage) do
        local sid = string.format("elitestage_%04d", i)
        local dic = deepcopy(ConfigureStorage.elitePage[sid])
        if elitedata:bigStageUnlock(sid) then
            dic.lock = sid > elitedata.currentStage
        else
            dic.lock = true
        end
        if dic.lock then
            lockCount = lockCount + 1
        end
        if lockCount > 3 then
            break
        end
        array[#array + 1] = dic
    end
    return array
end

-- 获得大关记录
function elitedata:getBigStageRecord()
    local bigIndex = tonumber(string.sub(elitedata.currentStage, 12, 15))
    if not elitedata:bigStageUnlock(string.format("elitestage_%04d", bigIndex)) then
        bigIndex = bigIndex - 1
    end
    return bigIndex
end

function elitedata:getStageStar(stageId)
    if not elitedata.record or not elitedata.record[stageId] then
        return 0
    end
    return elitedata.record[stageId].star or 0
end

function elitedata:canFight(stageId)
    if stageId <= elitedata.currentStage then
        return true
    end
    local rb = tonumber(string.sub(elitedata.currentStage, 12, 15))
    local rs = tonumber(string.sub(elitedata.currentStage, 17, 18))
    local b = tonumber(string.sub(stageId, 12, 15))
    local s = tonumber(string.sub(stageId, 17, 18))
    if b < rb or (b == rb and s <= rs) then
        return true
    end
    return false
end

function elitedata:getSmallStage(stageId)
    return ConfigureStorage.eliteStage[stageId]
end


function elitedata:getSmallStages(bigIndex)
    local stageId = string.format("elitestage_%04d", bigIndex)
    return ConfigureStorage.elitePage[stageId].pageStage
end

-- 获取显示的小关关卡数据
function elitedata:getVisSmallStages(bigIndex)
    local stages = elitedata:getSmallStages(bigIndex)
    local big = tonumber(string.sub(elitedata.currentStage, 12, 15))
    if bigIndex < big then
        return stages
    end
    local smallIndex = tonumber(string.sub(elitedata.currentStage, 17, 18))
    local array = {}
    for i,v in ipairs(stages) do
        if i > smallIndex + 1 then
        else
            table.insert(array, v)
        end
    end
    return array
end

function elitedata:getResetGold(stageId)
    local resetTimes = 0
    if elitedata.record and elitedata.record[stageId] then
        resetTimes = elitedata.record[stageId].resetTimes or 0
    end
    local conf = ConfigureStorage.eliteStage[stageId]
    local pay = ConfigureStorage.eliteStageType[conf.type + 1].pay
    local max = table.getTableCount(pay)
    if resetTimes >= max then
        return pay[tostring(max)]
    end
    return pay[tostring(resetTimes + 1)]
end

-- 小关默认挑战次数
function elitedata:getStageChallengeCount(stageId)
    local conf = ConfigureStorage.eliteStage[stageId]
    return ConfigureStorage.eliteStageType[conf.type + 1].amount
end

-- 获取小关挑战次数
function elitedata:getStageFightCount(stageId)
    if not elitedata.record or not elitedata.record[stageId] then
        return 0
    end
    return elitedata.record[stageId].times or 0
end

function elitedata:updateData(resp)
    if not resp or not resp.eliteData then
        return
    end
    local data = resp.eliteData
    if data.currentStage then
        elitedata.currentStage = data.currentStage
    end
    if data.record then
        elitedata.record = data.record
    end
end

function elitedata:checkRecord(stageId)
    local strs = string.split(stageId, "_")
    local bigIndex = strs[2]
    if not elitedata:checkBigStage(string.format("elitestage_%04d", tonumber(bigIndex))) then
        return false
    end
    local record = elitedata.currentStage or "elitestage_0001_01"
    if stageId > record then
        ShowText(HLNSLocalizedString("stage.unlock"))
        return false
    end
    return true
end

