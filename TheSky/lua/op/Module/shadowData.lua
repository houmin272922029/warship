-- 练影数据缓存
shadowData = {
    allShadows = {},
    shadowData = {},
    shadowExercise = {},
}
ShadowSortType = {
    SortByGainTime = 1,
    SortByRankAndLevel = 2,
    SortByOwnerAndRankAndLevel = 3
}


-- 获取装备该影子的伙伴信息
function shadowData:getShadowOwner(  )
    local hero = herodata:getAllHeroes()
    local owners = {}
    for i=1,getMyTableCount(hero) do
        local dic = hero[i].shadows
        if dic and getMyTableCount(dic) > 0 then
            for k,v in pairs(dic) do
                if not owners[v] then
                    local ownerArray = {}
                    ownerArray.name = hero[i].name
                    ownerArray.id = hero[i].id
                    owners[v] = ownerArray
                end
            end
        end
    end
    return owners
end

-- 获得距离下次免费刷新时间的时间间隔
function shadowData:getTimeDurationNextFreeTime(  )
    if shadowData.shadowData and shadowData.shadowData.nextFreeTime then
        return shadowData.shadowData.nextFreeTime - userdata.loginTime
    end
    return 0
end

function shadowData:getShadowCountById( id )
    local shadows = deepcopy(shadowData.allShadows) 
    local count = 0
    local owners = shadowData:getShadowOwner(  )
    for k,v in pairs(shadowData.allShadows) do
        if v.shadowId == id then
            if not owners[k] then
                count = count + 1
            end
        end
    end
    return count
end

-- 获取用户拥有的影币
function shadowData:getShadowCoin(  )
    if shadowData.shadowData then
        return shadowData.shadowData.shadowCoin 
    end
    return 0 
end

-- 获取单个影子的配置信息
function shadowData:getOneShadowConf( id )
    if ConfigureStorage.shadowData[id] then 
        return deepcopy(ConfigureStorage.shadowData[id])
    end
end

-- 获取一个影子的所有信息
function shadowData:getOneShadowByUID( uid )
    if not uid then
        print("uid is null,please try again")
        return
    end
    local shadow
    if shadowData.allShadows[uid] then
        shadow = deepcopy(shadowData.allShadows[uid])
    end
    local conf
    if shadow.shadowId then
        conf = shadowData:getOneShadowConf(shadow.shadowId)
    end
    local retArray = {}
    retArray["shadow"] = shadow
    retArray["conf"] = conf
    return retArray
end

-- 根据uid组合一个影子详细信息
function shadowData:getShadowPopInfoByUid( uid )
    local retArray = {}
    if not uid then
        print("uid is null ,pls try again")
        return
    end
    local shadow
    if shadowData.allShadows[uid] then
        shadow = deepcopy(shadowData.allShadows[uid])
    end
    local conf
    if shadow.shadowId then
        conf = shadowData:getOneShadowConf(shadow.shadowId)
    end
    retArray["conf"] = conf
    retArray["level"] = shadow.level
    return retArray
end
-- 根据配置id组合一个影子详细信息
function shadowData:getShadowPopInfoByCid( cid )
    
end

-- 根据dic更新影子信息
function shadowData:updateShadowByDic( uid,dic )
    shadowData.allShadows[uid] = dic                -- 没有该影子的时候添加该影子
end


-- 得到一个影子的属性值和类型  影子的唯一id
function shadowData:getShadowAttrByUid( uid )
    if not uid then
        print("uid is null,please try again")
        return
    end
    local shadow = shadowData:getOneShadowByUID( uid )
    local retArray = {}
    retArray["type"] = shadow.conf.property
    local level = shadow.shadow.level
    retArray["value"] = shadow.conf.level[tostring(level)]
    return retArray
end

-- 通过等级和配置id得到一个影子的属性数组
function shadowData:getShadowAttrByLevelAndCid( level,cid )
    local shadowConf = shadowData:getOneShadowConf( cid )
    local retArray = {}
    retArray["type"] = shadowConf.property
    retArray["value"] = shadowConf.level[tostring(level)]
    return retArray
end

-- 获取所有可售影子信息
function shadowData:getWaveConfigData()
    local retArray = {}
    for k,v in pairs(ConfigureStorage.shadowData) do
        if v.rank ~= 0 and v.rank ~= -1 and v.isSale == 1 then
            local shadowArray = {}
            shadowArray["id"] = k
            shadowArray["conf"] = deepcopy(v)
            table.insert(retArray,shadowArray)
        end
    end
    local function sortFun( a,b )
        if a.conf.rank ~= b.conf.rank then
            return a.conf.rank > b.conf.rank
        else
            return a.id < b.id
        end
    end
    table.sort( retArray, sortFun )
    return retArray
end

-- 获得所有的配置影子信息
function shadowData:getAllShadowConfigData(  )
    local retArray = {}
    for k,v in pairs(ConfigureStorage.shadowData) do
        if v.rank ~= 0 and v.rank ~= -1 then
            local shadowArray = {}
            shadowArray["id"] = k
            shadowArray["conf"] = deepcopy(v)
            table.insert(retArray,shadowArray)
        end
    end
    local function sortFun( a,b )
        if a.conf.rank ~= b.conf.rank then
            return a.conf.rank > b.conf.rank
        else
            return a.id < b.id
        end
    end
    table.sort( retArray, sortFun )
    return retArray
end
                 
-- -- 根据影子唯一id获得影子加成属性值
-- function shadowData:getShadowPropertyAddValueByUID( uid )
    
-- end

-- 获得现在在中间显示的影子索引
function shadowData:getCenterIndex(  )
    if shadowData.shadowData then
        return shadowData.shadowData.statusNow
    end
    return 1
end

-- 根据颜色品阶获取颜色值
function shadowData:getColorByColorRank( rank )
    local color
    if rank == 5 then
        color =  ccc3(255,225,59)
    elseif rank == 4 then
        color =  ccc3(202,100,221) 
    elseif rank == 3 then
        color =  ccc3(4,211,255) 
    elseif rank == 2 then
        color =  ccc3(127,252,58)
    elseif rank == 1 then
        color =  ccc3(255,255,255)
    end
    return color
end


-- 获得所有练影信息
function shadowData:getAllShadowData( _sortType )
    local retArray = {}
    local sortType = (_sortType ~= nil) and _sortType or ShadowSortType.SortByGainTime
    local owners = {}
    local hero = herodata:getAllHeroes()
    for i=1,getMyTableCount(hero) do
        local dic = hero[i].shadows
        if dic and getMyTableCount(dic) > 0 then
            for k,v in pairs(dic) do
                if not owners[v] then
                    local ownerArray = {}
                    ownerArray.name = hero[i].name
                    ownerArray.id = hero[i].id
                    owners[v] = ownerArray
                end
            end
        end
    end
    for k,v in pairs(shadowData.allShadows) do
        local shadowArray = {}
        if not havePrefix(v.shadowId, "canying_") then
            shadowArray["suid"] = v.id
            shadowArray["id"] = v.shadowId
            shadowArray["level"] = v.level
            shadowArray["expNow"] = v.expNow
            shadowArray["time"] = v.gainTime ~= nil and v.gainTime or 0 -- 获得时间
            local confDic = shadowData:getOneShadowConf(v.shadowId)
            shadowArray["conf"] = confDic
            shadowArray["owner"] = owners[k]
            table.insert(retArray,shadowArray)
        end
    end
    local function sortFun( a,b )
        return a.time < b.time 
    end
    local function sortByRankAndLevel( a,b )
        if a.conf.rank ~= b.conf.rank then
            return a.conf.rank > b.conf.rank
        else
            return a.level > b.level
        end
    end
    local function sortByOwnerAndRankAndLevel( a,b )
        if a.owner and b.owner then
            if a.conf.rank ~= b.conf.rank then
                return a.conf.rank > b.conf.rank
            else
                return a.level > b.level
            end
        elseif not a.owner and not b.owner then
            if a.conf.rank ~= b.conf.rank then
                return a.conf.rank > b.conf.rank
            else
                return a.level > b.level
            end
        else
            return a.owner ~= nil
        end
    end
    if sortType then
        if sortType == ShadowSortType.SortByGainTime then
            table.sort( retArray, sortFun ) 
        elseif sortType == ShadowSortType.SortByRankAndLevel then
            table.sort( retArray, sortByRankAndLevel ) 
        elseif sortType == ShadowSortType.SortByOwnerAndRankAndLevel then
            table.sort( retArray, sortByOwnerAndRankAndLevel ) 
        end
    end
    return retArray
end

function shadowData:getCanUserShadowMaterialByUid( uid )
    local retArray = {}

    local owners = {}
    local hero = herodata:getAllHeroes()
    for i=1,getMyTableCount(hero) do
        local dic = hero[i].shadows
        if dic and getMyTableCount(dic) > 0 then
            for k,v in pairs(dic) do
                if not owners[v] then
                    owners[v] = hero[i].name
                end
            end
        end
    end

    for k,v in pairs(shadowData.allShadows) do
        if not havePrefix(v.shadowId, "canying_") and k ~= uid and not owners[k] then
            local shadow = shadowData:getOneShadowByUID( k )
            table.insert(retArray,shadow)
        end
    end
    -- 排序
    local function sortFun( a,b )
        if a.conf.rank == b.conf.rank then
            return a.shadow.level < b.shadow.level
        end
        return a.conf.rank < b.conf.rank
    end
    table.sort( retArray, sortFun )
    return retArray
end

-- 获得由一个等级升到下一个等级需要的经验值   参数：当前等级 品阶
function shadowData:getNeedEXPToNextLevel(level, rank)
    local shadowUpdate = deepcopy(ConfigureStorage.shadowUpdate)
    if not shadowUpdate[tostring(level)] then
        return nil
    end
    return shadowUpdate[tostring(level)][tostring(rank)]
end
-- 一个影子可以提供的经验值
function shadowData:oneShadowCanGaveEXP( id,rank,level )
    local exp = 0
    local conf = shadowData:getOneShadowConf(id)
    local shadowUpdate = ConfigureStorage.shadowUpdate
    for i=0,level - 1 do
        if i == 0 then
            exp = exp + conf.exp
        else
            exp = exp + shadowUpdate[tostring(i)][tostring(rank)]
        end
    end
    return exp
end
-- 获得练影所需贝利数目
function shadowData:getTrainShadowNeedBerry( pos )
    local rand = ConfigureStorage.shadowRand
    return rand[tostring(pos)]["silver"]
end
-- 获得坚决所需金币数
function shadowData:getChangeStatusNeedGold(  )
    return 200
end

-- 得到能更换的影子列表
function shadowData:getOffShadowByPropertyAndHid( hid, shadowInfo )
    local function sortByOwnerAndRankAndLevel( a,b )
        if a.owner and b.owner then
            if a.conf.rank ~= b.conf.rank then
                return a.conf.rank > b.conf.rank
            else
                return a.level > b.level
            end
        elseif not a.owner and not b.owner then
            if a.conf.rank ~= b.conf.rank then
                return a.conf.rank > b.conf.rank
            else
                return a.level > b.level
            end
        else
            return a.owner ~= nil
        end
    end

    local myShadows = {}
    local owners = {}
    local hero = herodata:getAllHeroes()
    for i=1,getMyTableCount(hero) do
        local dic = hero[i].shadows
        if dic and getMyTableCount(dic) > 0 then
            for k,v in pairs(dic) do
                if not owners[v] then
                    local ownerArray = {}
                    ownerArray.name = hero[i].name
                    ownerArray.id = hero[i].id
                    owners[v] = ownerArray
                end
            end
        end
    end
    for k,v in pairs(shadowData.allShadows) do
        if not havePrefix(v.shadowId, "canying_") then
            local dic = deepcopy(v)
            local shadowArray = {}
            shadowArray["suid"] = dic.id
            shadowArray["id"] = dic.shadowId
            shadowArray["level"] = dic.level
            local confDic = shadowData:getOneShadowConf(v.shadowId)
            shadowArray["conf"] = confDic
            shadowArray["owner"] = owners[k]
            table.insert(myShadows,shadowArray)
        end
    end
    
    local huobanShadows = shadowData:getShadowConfByHid( hid )
    local retArray = {}
    if not huobanShadows or getMyTableCount(huobanShadows) <= 0 then
        table.sort( myShadows, sortByOwnerAndRankAndLevel ) 
        return myShadows
    end
    for i=1,getMyTableCount(myShadows) do
        local flag = false
        -- 更换影子
        if shadowInfo then
            local property = shadowInfo.conf.property
            if myShadows[i].conf.property == property then
                if myShadows[i].owner then 
                    if  hid ~= myShadows[i].owner.id then
                        table.insert(retArray,myShadows[i])
                    end
                else
                    table.insert(retArray,myShadows[i])
                end
            else
                for j=1,getMyTableCount(huobanShadows) do
                    if myShadows[i].conf.property ~= huobanShadows[j].conf.property then
                        flag = true
                    else
                        flag = false
                        break
                    end
                end
                if flag then
                    table.insert(retArray,myShadows[i])
                end
            end
        -- 新装上的影子
        else
            for j=1,getMyTableCount(huobanShadows) do
                if myShadows[i].conf.property ~= huobanShadows[j].conf.property then
                    flag = true
                else
                    flag = false
                    break
                end
            end
            if flag then
                table.insert(retArray,myShadows[i])
            end
        end
    end
    table.sort( retArray, sortByOwnerAndRankAndLevel ) 
    return retArray
end
-- 根据影子uid得到影子详细信息
function shadowData:getShadowConfBySuid( suid )
    for k,v in pairs(shadowData.allShadows) do
        if k == suid then
            local dic = deepcopy(v)
            local confDic = shadowData:getOneShadowConf(v.shadowId)
            dic.conf = confDic
            return dic
        end
    end
end
-- 判断某位置能否装个影子
function shadowData:IsShadowOpen(level, index)
    local dic = ConfigureStorage.genuineQisMax
    local temp = {}
    for k,v in pairs(dic) do
        local temp1 = {}
        temp1.level = tonumber(k)
        temp1.number = v
        table.insert(temp,temp1)
    end
    for i,v in ipairs(temp) do
        if index == v.number then
            return level - v.level >= 0 and true or false
        end
    end
    return true
end

-- 判断某位置能否装个影子
function shadowData:getShadowLevelByIndex(index)
    local dic = ConfigureStorage.genuineQisMax
    local temp = {}
    for k,v in pairs(dic) do
        local temp1 = {}
        temp1.level = tonumber(k)
        temp1.number = v
        table.insert(temp,temp1)
    end
    for i,v in ipairs(temp) do
        if index == v.number then
            return v.level 
        end
    end
    return nil
end

-- 获取伙伴所装备的影子信息
function shadowData:getShadowConfByHid( hid )
    local retArray = {}
    local hero = herodata.heroes[hid]
    if hero.shadows and getMyTableCount(hero.shadows) > 0 then
        for k,v in pairs(hero.shadows) do
            local info = shadowData:getShadowConfBySuid( v )
            info.pos = k
            info.id = info.shadowId
            local ownerArray = {}
            local heroInfo = herodata:getHeroBasicInfoByHeroId( hero.heroId )
            ownerArray.name = heroInfo.name
            ownerArray.id = hid
            info.owner = ownerArray
            table.insert(retArray, info)
        end
    end
    return retArray
end

function shadowData:resetAllData()
    shadowData.allShadows = {}
    shadowData.shadowData = {}
    shadowData.shadowExercise = {}
end

-- 练影功能是否开放
function shadowData:bOpenShadowFun()
    if ConfigureStorage.levelOpen["shadow"] then
        return userdata.level >= ConfigureStorage.levelOpen["shadow"].level
    end
    return false
end

function shadowData:openLevel()
    if ConfigureStorage.levelOpen["shadow"] then
        return ConfigureStorage.levelOpen["shadow"].level
    end
    return nil
end

function shadowData:trainShadowRule()
    local array = {}
    for i=1,table.getTableCount(ConfigureStorage.TrainShadowHelp) do
        table.insert(array, ConfigureStorage.TrainShadowHelp[string.format("notice_%03d",i)].desp)
    end
    return array
end
