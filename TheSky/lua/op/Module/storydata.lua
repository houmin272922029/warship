-- 用户数据缓存

storydata = {
    record = "stage_01_01",
    stageData = nil,
    bigStageSelected = 1,
    pageData = nil,
    nextBatchTime = nil,
}

--重置用户数据
function storydata:resetAllData()
    storydata.record = "stage_01_01"
    storydata.bigStageSelected = 1
    storydata.stageData = nil
    storydata.pageData = nil
    storydata.nextBatchTime = nil
end

-- 获得大关数据 
function storydata:getBigStages()
    local array = {}
    for sid,v in pairs(ConfigureStorage.pageConfig) do
        v.lock = sid > storydata.record and true or false
        table.insert(array, v)
    end
    local function sortFun( a, b )
        return a.pageId < b.pageId 
    end
    table.sort(array, sortFun)
    local ret = {}
    local lockCount = 0
    for i,v in ipairs(array) do
        if v.lock then
            lockCount = lockCount + 1
        end
        if lockCount > 3 then
            break
        end
        ret[#ret + 1] = v
    end
    return ret
end

function storydata:getSmallStages(bigIndex)
    local stageId = string.format("stage_%02d", bigIndex)
    return ConfigureStorage.pageConfig[stageId].pageStage
end

-- 获得大关记录
function storydata:getBigStageRecord()
    local bigIndex = tonumber(string.sub(storydata.record, 7, 8))
    -- local smallIndex = tonumber(string.sub(storydata.record, 10, 11))
    -- local smallStages = storydata:getSmallStages(bigIndex)
    -- if smallIndex == table.getTableCount(smallStages) then
    --     bigIndex = bigIndex+1
    -- end
    return bigIndex
end

-- 获取显示的小关关卡数据
function storydata:getVisSmallStages(bigIndex)
    local stages = storydata:getSmallStages(bigIndex)
    local big = tonumber(string.sub(storydata.record, 7, 8))
    if bigIndex < big then
        return stages
    end
    local smallIndex = tonumber(string.sub(storydata.record, 10, 11))
    local array = {}
    for i,v in ipairs(stages) do
        if i > smallIndex + 1 then
        else
            table.insert(array, v)
        end
    end
    return array
end

function storydata:getSmallStage(stageId)
    return ConfigureStorage.stageConfig[stageId]
end

function storydata:canFight(stageId)
    if stageId <= storydata.record then
        return true
    end
    local rb = tonumber(string.sub(storydata.record, 7, 8))
    local rs = tonumber(string.sub(storydata.record, 10, 11))
    local b = tonumber(string.sub(stageId, 7, 8))
    local s = tonumber(string.sub(stageId, 10, 11))
    if b < rb or (b == rb and s <= rs) then
        return true
    end
    return false
end

-- 获取小关挑战次数
function storydata:getStageFightCount(stageId)
    if not storydata.stageData or not storydata.stageData[stageId] or not storydata.stageData[stageId].times then
        return 0
    end
    return storydata.stageData[stageId].times
end


function storydata:getStageConfFightCount(stageType)
    return ConfigureStorage.stageTypeConfig[stageType + 1]
end

function storydata:getStageStar(stageId)
    if not storydata.stageData or not storydata.stageData[stageId] or not storydata.stageData[stageId].record then
        return 0
    end
    return storydata.stageData[stageId].record
end

-- 是否可以吃鸡
function storydata:bPageCanEat(bigIndex)
    local stages = storydata:getSmallStages(bigIndex)
    for i,stageId in ipairs(stages) do
        if storydata:getStageStar(stageId) ~= 3 then
            return false
        end
    end
    return true
end

-- 是否已经吃过
function storydata:bPageAte(bigIndex)
    local stageId = string.format("stage_%02d", bigIndex)
    if not storydata.pageData[stageId] or storydata.pageData[stageId].awardFlag == 0 then
        return false
    end
    return true
end

-- 获取连闯冷却时间 
function storydata:getSweepCDTime()
    if not storydata.nextBatchTime or storydata.nextBatchTime < userdata.loginTime then
        return 0
    end
    return storydata.nextBatchTime - userdata.loginTime
end

-- 获取剧情对话
function storydata:getStageTalk(bigIndex)
    local stageId = string.format("stage_%02d", bigIndex)
    local dialogId = ConfigureStorage.pageConfig[stageId].pageDialogue
    return deepcopy(ConfigureStorage.stageTalk[dialogId])
end

-- 是否第一次战大关卡的最后一个小关
function storydata:bFirstPageLastStage(bigIndex, stageId)
    if stageId ~= storydata.record then
        return false
    end
    local stages = storydata:getSmallStages(bigIndex)
    print("bigIndex = ", bigIndex)
    print("lastStage = ", stages[#stages])
    return stageId == stages[#stages]
end

function storydata:updateStoryData(resp)
    if resp.storys.record then
        storydata.record = resp.storys.record
    end
    if resp.storys.stageData then
        storydata.stageData = resp.storys.stageData
    end
    if resp.storys.pageData then
        storydata.pageData = resp.storys.pageData
    end
    if resp.storys.nextBatchTime then
        storydata.nextBatchTime = resp.storys.nextBatchTime
    end
end

function storydata:getMarineId(bigIndex)
    local stageId = string.format("stage_%02d", bigIndex)
    if ConfigureStorage.pageConfig[stageId] and ConfigureStorage.pageConfig[stageId].pageAward then
        return ConfigureStorage.pageConfig[stageId].pageAward
    end
    return nil
end

function storydata:checkRecord(stageId)
    local record = storydata.record or "stage_01_01"
    if stageId > record then
        ShowText(HLNSLocalizedString("stage.unlock"))
        return false
    end
    return true
end

