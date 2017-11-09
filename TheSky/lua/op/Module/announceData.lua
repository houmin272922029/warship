-- 用户数据缓存

announceData = {
    serverNotice = {}
}

-- 获得公告
function announceData:getAllNotice()
    local array = {}
    for k,v in pairs(announceData.serverNotice) do
        local tempArray = {}
        tempArray["sort"] = v["sort"]
        tempArray["title"] = v["title"]
        tempArray["content"] = v["content"]
        tempArray["time"] = v["time"]
        tempArray["dest"] = v["dest"]
        table.insert(array, tempArray)
    end
    local function sortFun(a, b)
        return a.sort < b.sort
    end
    table.sort(array, sortFun)
    return array
end

function announceData:resetAllData()
    announceData.serverNotice = {}
end