questdata = {
    missions = {},
    newCompleteKey = nil,
    newComplete = nil,
}
QUEST = {
    MAIN = "once",
    DAILY = "daily",
}

--重置用户数据
function questdata:resetAllData()
    questdata.missions = {}
    questdata.newCompleteKey = nil
    questdata.newComplete = nil
end

--[[
    刷新任务数据
    返回新完成的任务id
]]
function questdata:fromDic(dic)
    for k,v in pairs(dic) do
        for id,data in pairs(v) do
            if data.flag == 1 and (questdata.missions[k] == nil or questdata.missions[k][id] == nil or questdata.missions[k][id].flag == 0) then
                print("new complete")
                questdata.newComplete = deepcopy(data)
                questdata.newCompleteKey = deepcopy(k)
                break
            end
        end
    end
    questdata.missions = dic
    return questdata.newComplete ~= nil
end

-- 用户的任务
function questdata:getQuest(key)
    local array = {}
    for k,v in pairs(questdata.missions[key]) do
        table.insert(array, v)
    end
    local function sortFun(a, b)
        if a.flag == b.flag then
            return a.id < b.id
        end 
        return a.flag > b.flag
    end
    table.sort(array, sortFun)
    return array
end

--[[
    用户任务完成数量
    返回值[main, daily]
]]
function questdata:getQuestComplete()
    local main = 0
    local daily = 0
    for k,v in pairs(questdata.missions) do
        for id,dic in pairs(v) do
            if dic.flag == 1 then
                if k == "once" then
                    main = main + 1
                else
                    daily = daily + 1
                end
            end
        end
    end
    return main, daily
end

--[[
    完成任务弹框
    弹出后清除
]]
function questdata:pushComplete()
    local data = deepcopy(questdata.newComplete)
    local key = deepcopy(questdata.newCompleteKey)
    questdata.newComplete = nil
    questdata.newCompleteKey = nil
    return data, key
end


function questdata:getQuestConfig(id, key)
    return ConfigureStorage[string.format("mission_%s", key)][id]
end


