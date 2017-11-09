-- 用户数据缓存

shardData = {
    equipShard = {}
}

function shardData:getShardConf( shardID )
    local conf = ConfigureStorage.shard
    if conf[shardID] then
        return deepcopy(conf[shardID])
    end
    return nil
end

function shardData:reduceShardByIdAndCount( id,count )
    if shardData.equipShard[id] then
        shardData.equipShard[id] = shardData.equipShard[id] - count
        if shardData.equipShard[id] <= 0 then
            shardData.equipShard[id] = nil
        end
    end
end

function shardData:addShardByIdAndCount( id,count )
    if shardData.equipShard[id] then
        shardData.equipShard[id] = shardData.equipShard[id] + count
    else
        shardData.equipShard[id] = count
    end
end

-- 根据配置id获得一个碎片的数目
function shardData:getOneShardCount( cid )
    if shardData.equipShard then
        if shardData.equipShard[cid] then
            return shardData.equipShard[cid]
        end
    end
    return 0
end

function shardData:getOneShardConf( id )
    local sconf = shardData:getShardConf(id)
    local equipID = sconf.equip
    -- local equip = equipdata:getEquipConfig(equipID)
    local retArray = {}
    retArray.name = sconf.name
    retArray.rank = sconf.rank
    retArray.icon = sconf.icon
    return retArray
end

-- 获得公告
function shardData:getAllShard()
    local array = {}
    for k,v in pairs(shardData.equipShard) do
        local shardConf = shardData:getShardConf( k )
        local equipConf = equipdata:getEquipConfig(shardConf.equip)
        local needCount = shardConf.num
        local tempArray = {}
        tempArray["id"] = k
        tempArray["count"] = v
        tempArray["canMerge"] = (v >= needCount) and 1 or 0
        tempArray.shardConf = shardConf
        tempArray.equipConf = equipConf
        table.insert(array, tempArray)
    end
    local function sortFun(a, b)
        if a.canMerge == b.canMerge then
            if a.shardConf.rank == b.shardConf.rank then
                return a.count > b.count
            end
            return a.shardConf.rank > b.shardConf.rank 
        end
        return a.canMerge > b.canMerge
    end
    table.sort(array, sortFun)
    return array
end

function shardData:resetAllData()
    shardData.equipShard = {}
end