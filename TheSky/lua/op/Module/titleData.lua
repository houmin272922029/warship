-- 用户数据缓存

titleData = {
    titles = {}
}
-- 根据称号id得到称号配置
function titleData:getTitleConfigById( id )
    if ConfigureStorage.titleConfig[id] then
        return deepcopy(ConfigureStorage.titleConfig[id]) 
    else
        return nil
    end
end

function titleData:updateOneTitleByIdanddic( id,dic )
    if titleData.titles[tostring(id)] then
        titleData.titles[tostring(id)] = deepcopy(dic)
    end
end

-- 根据唯一id获得一条称号信息
function titleData:getOneTitleByUID( uid )
    local retArray = {}
    if titleData.titles[tostring(uid)] then
        local title = deepcopy(titleData.titles[tostring(uid)])
        local conf = titleData:getTitleConfigById(title.titleId)
        retArray["title"] = title
        retArray["conf"] = conf
        return retArray
    else
        return nil
    end
end

-- 得到称号页面默认显示称号
function titleData:getDefalutTitles(  )
    local outerDic = {}
    for k,v in pairs(ConfigureStorage.titleConfig) do
        if v.outer ~= 0 then
            table.insert(outerDic,k)
        end
    end
    local retArray = {}
    for i=1,getMyTableCount(outerDic) do
        local tempArray = {}
        local titleConf = titleData:getTitleConfigById( outerDic[i] )
        local titleContent = deepcopy(titleData.titles[outerDic[i]]) 
        tempArray["conf"] = titleConf
        tempArray["title"] = titleContent
        table.insert(retArray,tempArray)
    end
    local function sorFun( a,b )
        return a.conf.outer < b.conf.outer
    end
    table.sort(retArray,sorFun)
    return retArray
end

-- 根据titleid得到一条title信息
function titleData:getOneTitleByTitleId( titleId )
    local tempArray = {}
    local titleConf = titleData:getTitleConfigById( titleId )
    local titleContent = deepcopy(titleData.titles[titleId]) 
    tempArray["conf"] = titleConf
    tempArray["title"] = titleContent
    return tempArray
end

--得到全部称号页面上部所有称号
function titleData:getTopAllTitleInfo(  )
    local innerTop = {}
    for k,v in pairs(ConfigureStorage.titleConfig) do
        local tempArray = {}
        if v.inner == 0 then
            tempArray["title"] = deepcopy(titleData.titles[k])
            tempArray["conf"] = v
            table.insert(innerTop,tempArray)
        end
    end


    local function sorFun( a,b )
        return a.conf.sort <= b.conf.sort 
    end
    table.sort( innerTop,sorFun )
    return innerTop
end

-- 得到所有底部信息
function titleData:getBottomAllTitleInfo(  )
    local innerBottom = {}
    for k,v in pairs(ConfigureStorage.titleConfig) do
        local tempArray = {}
        if v.inner == 1 then
            tempArray["title"] = deepcopy(titleData.titles[k])
            tempArray["conf"] = v
            table.insert(innerBottom,tempArray)
        end
    end


    local function sorFun( a,b )
        return a.conf.sort <= b.conf.sort 
    end
    table.sort( innerBottom,sorFun )
    return innerBottom
end

-- 获得总气势值
function titleData:getAllFame()
    local fame = 0
    local famePer = 0
    for k,v in pairs(titleData.titles) do
        if v.level > 0 then
            local conf = titleData:getTitleConfigById(k)
            if conf.baseValue < 1 then
                if conf.targetID then
                    for i,id in ipairs(conf.targetID) do
                        local data = titleData.titles[id]
                        if data then
                            local targetConf = titleData:getTitleConfigById(id)
                            local targetFame = targetConf.baseValue + targetConf.updateValue * (data.level - 1)
                            fame = fame + math.floor(targetFame * (conf.baseValue + conf.updateValue * (v.level - 1)))
                        end
                    end
                else
                    famePer = famePer + conf.baseValue + conf.updateValue * (v.level - 1)
                end
            else
                fame = fame + conf.baseValue + conf.updateValue * (v.level - 1)    
            end
        end
    end
    fame = math.floor(fame * (1 + famePer))
    return fame
end

function titleData:resetAllData()
    titleData.titles = {}
end