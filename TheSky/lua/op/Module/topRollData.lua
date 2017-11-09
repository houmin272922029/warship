-- 用户数据缓存

topRollData = {
    data = {},
    index = 1,
}

-- 设置滚动信息,把指南信息随机插进来
function topRollData:setAllData( dic )
    topRollData.data = {}
    local rollConf = ConfigureStorage.rollGuide
    if rollConf ~= nil and table.getTableCount(rollConf) > 0 then
        for i,v in ipairs(rollConf) do
            table.insert(topRollData.data, v.content)
        end
    end 

    if nil ~= dic then
        for k,v in pairs(dic) do
            local rand = RandomManager.randomRange(1, table.getTableCount(topRollData.data))
            table.insert(topRollData.data, rand, v)
        end
    end
    -- PrintTable(topRollData.data)
end

-- 从服务器取新的滚动公告信息
function topRollData:getTopRollDataFromServer()
    local function getTopRollCallBack( url,rtnData )
        print("getTopRollCallBack")
        topRollData:setAllData(rtnData.info.result)
    end 
    doActionNoLoadingFun("GET_PUBLIC_SHARELIST",{},getTopRollCallBack)
end

-- 获取一条滚动信息
function topRollData:getOneInfo()
    if table.getTableCount(topRollData.data) <= 0 then
        return ""
    end 
    local retData = topRollData.data[topRollData.index]
    topRollData.index = (topRollData.index >= table.getTableCount(topRollData.data)) and 1 or topRollData.index+1
    return retData
end

--重置顶部滚动信息
function topRollData:resetAllData()
    topRollData.data = {}
    topRollData.index = 1
end

