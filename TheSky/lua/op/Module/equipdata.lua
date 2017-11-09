-- 用户数据缓存

equipdata = {
    equips = {}
}

local pairs = pairs
-- 去除装备
function equipdata:reduceEquipByID( equipId )
    if equipdata.equips[equipId] then
        equipdata.equips[equipId] = nil
    end
end
-- 获得同一装备的数量
function equipdata:getEquipCountById(itemId)
    local equips = equipdata.equips
    local count = 0
    for k,v in pairs(equips) do
        if v.equipId == itemId then
            if not equipdata:getOwnerByEUid(k) then
                count = count + 1
            end
        end
    end
    return count
end
-- 得到装备所在hero
function equipdata:getOwnerByEUid(eid)
    local form = herodata.form
    for k,hid in pairs(form) do
        local hero = deepcopy(herodata.heroes[hid])
        if hero.equip then
            for i=0,3 do
                local suid = hero.equip[tostring(i)]
                if suid and suid == eid then
                    hero["name"] = herodata:getHeroConfig(hero.heroId).name
                    return hero
                end
            end
        end
    end
    return nil
end

function equipdata:getEquipConfig(equipId) -- 参数 : 装备配置id weapon_000101
    return deepcopy(ConfigureStorage.equip[equipId])
end

-- 装备初始身价
function equipdata:getEquipPriceConfig(equipId)
    local conf = equipdata:getEquipConfig(equipId)
    if not conf or not conf.worth then
        return 0
    end
    return conf.worth
end

-- 装备身价计算
function equipdata:getEquipPrice(equipId, level)
    local price = equipdata:getEquipPriceConfig(equipId)
    local conf = equipdata:getEquipConfig(equipId)
    if not conf or not conf.worthgrow then
        return price
    end
    return price + math.floor(conf.worthgrow * (level - 1))
end

-- 身价计算
function equipdata:getEquipPriceByEid(eid) -- 参数 : 装备唯一id
    local equip = equipdata.equips[eid]
    return equipdata:getEquipPrice(equip.equipId, equip.level)
end

-- 根据属性类型返回装备属性显示图片
function equipdata:getDisplayFrameByType( myType )
    return string.format("%s_icon.png", (myType == "mp") and "int" or myType)
end

-- 返回所有可卖装备信息
function equipdata:getCanSellAllEquipData(  )
    local retArray = {}
    local equips = equipdata.equips
    local owners = {}
    for k,hid in pairs(herodata.form) do
        local hero = herodata.heroes[hid]
        local name = herodata:getHeroConfig(hero.heroId).name
        for i=0,3 do
            if hero.equip[tostring(i)] then
                owners[hero.equip[tostring(i)]] = name
            end
        end
    end
    for equipUniqueId,equipContent in pairs(equips) do
        local equipId = equipContent["equipId"]
        local equip = equipdata:getEquipConfig(equipId)
        local tempArray = {}
        local owner = owners[equipUniqueId]
        if equip and equip ~= {} and not owner then
            tempArray["equip"] = equip
            tempArray["level"] = equipContent["level"]
            tempArray["stage"] = equipContent["stage"]
            tempArray["id"] = equipContent["id"]
            tempArray["expNow"] = equipContent["expNow"]
            table.insert(retArray,tempArray)
        end
    end
    local function sortFun(a, b)
        if a.equip.rank == b.equip.rank then
            if a.equip.type == b.equip.type then
                if a.stage == b.stage then
                    return a.level < b.level
                end
                return a.stage < b.stage
            end
            return a.equip.type < b.equip.type
        end
        return a.equip.rank < b.equip.rank
    end
    table.sort( retArray, sortFun )
    return retArray
end

-- 获得上阵英雄通过uid
function equipdata:getHeorFormPosByUid( uid )
    for k,v in pairs(herodata.form) do
        if v == uid then
            return k
        end
    end
    return nil
end

-- 该方法用于合成器
-- 返回所有可还原的装备
function equipdata:getReducedEquipment()
    local retArray = {}
    local owners = {}
    for k,hid in pairs(herodata.form) do
        local hero = herodata.heroes[hid]
        local name = herodata:getHeroConfig(hero.heroId).name
        for i=0,3 do
            if hero.equip[tostring(i)] then
                local ownerTable = {}
                ownerTable["name"] = name
                ownerTable["pos"] = k
                owners[hero.equip[tostring(i)]] = ownerTable
            end
        end
    end
    local equips = equipdata.equips
    for equipUniqueId,equipContent in pairs(equips) do
        local equipId = equipContent["equipId"]
        local equip = equipdata:getEquipConfig(equipId)
        if equipContent["advanced"] and equipContent["advanced"] > 0 then
            local tempArray = {}
            if equip and equip ~= {} then
                tempArray["equip"] = equip
                local advanced = equipContent["advanced"]
                if equip.rank == 3 then
                    tempArray["equip"].composeLevel = ConfigureStorage.equip_blue_awave[tostring(advanced)].rankchange
                    tempArray["equip"].rank = ConfigureStorage.equip_blue_awave[tostring(advanced)].awaverank
                elseif equip.rank == 4 then
                    tempArray["equip"].composeLevel = ConfigureStorage.equip_pur_awave[tostring(advanced)].rankchange
                    tempArray["equip"].rank = ConfigureStorage.equip_pur_awave[tostring(advanced)].awaverank
                elseif equip.rank == 5 then
                    tempArray["equip"].composeLevel = ConfigureStorage.equip_gold_awave[tostring(advanced)].rankchange
                    tempArray["equip"].rank = ConfigureStorage.equip_gold_awave[tostring(advanced)].awaverank
                end
                tempArray["level"] = equipContent["level"]
                tempArray["stage"] = equipContent["stage"]
                tempArray["id"] = equipContent["id"]
                tempArray["owner"] = owners[equipUniqueId]
                tempArray["expNow"] = equipContent["expNow"]
                table.insert(retArray,tempArray)
            end
        end
    end
    return retArray
end

-- 该方法只用于合成器(合成区域选择装备 不返回合成等级的装备 不返回穿戴的装备)
-- 返回所有相同id不同uid的装备
-- 参数 物品id和唯一id
function equipdata:getSameEquipById(id,uid)
    local retArray = {}
    local owners = {}
    for k,hid in pairs(herodata.form) do
        local hero = herodata.heroes[hid]
        local name = herodata:getHeroConfig(hero.heroId).name
        for i=0,3 do
            if hero.equip[tostring(i)] then
                local ownerTable = {}
                ownerTable["name"] = name
                ownerTable["pos"] = k
                owners[hero.equip[tostring(i)]] = ownerTable
            end
        end
    end
    local equips = equipdata.equips
    for equipUniqueId,equipContent in pairs(equips) do
        if equipContent["equipId"] == id and equipContent["id"] ~= uid then
            if equipContent["advanced"] and equipContent["advanced"] > 0 then
            else
                local equipId = equipContent["equipId"]
                local equip = equipdata:getEquipConfig(equipId)
                local tempArray = {}
                if equip and equip ~= {} and not owners[equipUniqueId] then
                    tempArray["equip"] = equip
                    tempArray["level"] = equipContent["level"]
                    tempArray["stage"] = equipContent["stage"]
                    tempArray["id"] = equipContent["id"]
                    --tempArray["owner"] = owners[equipUniqueId]
                    tempArray["expNow"] = equipContent["expNow"]
                    table.insert(retArray,tempArray)
                end
            end
        end
    end
    return retArray
end

-- 返回所有A等级级以上装备信息
function equipdata:getASREquipData(  )
    local retArray = {}
    local owners = {}
    for k,hid in pairs(herodata.form) do
        local hero = herodata.heroes[hid]
        local name = herodata:getHeroConfig(hero.heroId).name
        for i=0,3 do
            if hero.equip[tostring(i)] then
                local ownerTable = {}
                ownerTable["name"] = name
                ownerTable["pos"] = k
                owners[hero.equip[tostring(i)]] = ownerTable
            end
        end
    end
    local equips = equipdata.equips
    for equipUniqueId,equipContent in pairs(equips) do
        local equipId = equipContent["equipId"]
        local equip = equipdata:getEquipConfig(equipId)
        if equip.rank >= 3 then
            local tempArray = {}
            if equip and equip ~= {} then
                tempArray["equip"] = equip
                if equipContent["advanced"] and equipContent["advanced"] > 0 then
                    local advanced = equipContent["advanced"]
                    if equip.rank == 3 then
                        tempArray["equip"].composeLevel = ConfigureStorage.equip_blue_awave[tostring(advanced)].rankchange
                        tempArray["equip"].rank = ConfigureStorage.equip_blue_awave[tostring(advanced)].awaverank
                    elseif equip.rank == 4 then
                        tempArray["equip"].composeLevel = ConfigureStorage.equip_pur_awave[tostring(advanced)].rankchange
                        tempArray["equip"].rank = ConfigureStorage.equip_pur_awave[tostring(advanced)].awaverank
                    elseif equip.rank == 5 then
                        tempArray["equip"].composeLevel = ConfigureStorage.equip_gold_awave[tostring(advanced)].rankchange
                        tempArray["equip"].rank = ConfigureStorage.equip_gold_awave[tostring(advanced)].awaverank
                    end
                else
                    tempArray["equip"].composeLevel = 0
                end
                tempArray["level"] = equipContent["level"]
                tempArray["stage"] = equipContent["stage"]
                tempArray["id"] = equipContent["id"]
                tempArray["owner"] = owners[equipUniqueId]
                tempArray["expNow"] = equipContent["expNow"]
                table.insert(retArray,tempArray)
            end
        end
    end
     local function sortFun(a, b)
        if (a.owner and b.owner) then
            if a.owner.pos == b.owner.pos then
                if a.equip.rank == b.equip.rank then
                    if a.stage == b.stage then
                        if a.level == b.level then
                            return a.equip.composeLevel > b.equip.composeLevel
                        end
                    end
                    return a.stage < b.stage
                end
                return a.equip.rank < b.equip.rank
            end
            return a.owner.pos > b.owner.pos
        elseif (a.owner == nil and b.owner == nil) then
            if a.equip.rank == b.equip.rank then
                if a.equip.type == b.equip.type then
                    if a.equip.id == b.equip.id then
                        if a.stage == b.stage then
                            if a.level == b.level then
                                return a.equip.composeLevel < b.equip.composeLevel
                            end
                        end
                        return a.stage < b.stage
                    end
                    return a.equip.id > b.equip.id
                end
                return a.equip.type > b.equip.type
            end
            return a.equip.rank < b.equip.rank
        else
            return a.owner ~= nil
        end
    end
    table.sort( retArray, sortFun )
    return retArray
end

-- 返回所有装备信息
function equipdata:getAllEquipData(  )
	local retArray = {}
    local owners = {}
    for k,hid in pairs(herodata.form) do
        local hero = herodata.heroes[hid]
        local name = herodata:getHeroConfig(hero.heroId).name
        for i=0,3 do
            if hero.equip[tostring(i)] then
                local ownerTable = {}
                ownerTable["name"] = name
                ownerTable["pos"] = k
                owners[hero.equip[tostring(i)]] = ownerTable
            end
        end
    end
    local equips = equipdata.equips
	for equipUniqueId,equipContent in pairs(equips) do
		local equipId = equipContent["equipId"]
		local equip = equipdata:getEquipConfig(equipId)
		local tempArray = {}
		if equip and equip ~= {} then
			tempArray["equip"] = equip
			tempArray["level"] = equipContent["level"]
			tempArray["stage"] = equipContent["stage"]
			tempArray["id"] = equipContent["id"]
			tempArray["owner"] = owners[equipUniqueId]
			tempArray["expNow"] = equipContent["expNow"]
            if equipContent["advanced"] and equipContent["advanced"] > 0 then
                local advanced = equipContent["advanced"]
                if equip.rank == 3 then
                    tempArray["equip"].composeLevel = ConfigureStorage.equip_blue_awave[tostring(advanced)].rankchange
                    tempArray["equip"].rank = ConfigureStorage.equip_blue_awave[tostring(advanced)].awaverank
                elseif equip.rank == 4 then
                    tempArray["equip"].composeLevel = ConfigureStorage.equip_pur_awave[tostring(advanced)].rankchange
                    tempArray["equip"].rank = ConfigureStorage.equip_pur_awave[tostring(advanced)].awaverank
                elseif equip.rank == 5 then
                    tempArray["equip"].composeLevel = ConfigureStorage.equip_gold_awave[tostring(advanced)].rankchange
                    tempArray["equip"].rank = ConfigureStorage.equip_gold_awave[tostring(advanced)].awaverank
                end
            else
                tempArray["equip"].composeLevel = 0
            end
			table.insert(retArray,tempArray)
		end
	end
     local function sortFun(a, b)
        if (a.owner and b.owner) then
            if a.owner.pos == b.owner.pos then
                if a.equip.rank == b.equip.rank then
                    if a.stage == b.stage then
                            if  a.equip.composeLevel == b.equip.composeLevel then
                                return a.equip.composeLevel > b.equip.composeLevel
                            end
                        return a.level > b.level
                    end
                    return a.stage > b.stage
                end
                return a.equip.rank > b.equip.rank
            end
            return a.owner.pos < b.owner.pos
        elseif (a.owner == nil and b.owner == nil) then
            if a.equip.rank == b.equip.rank then
                if a.equip.type == b.equip.type then
                    if a.equip.id == b.equip.id then
                        if a.stage == b.stage then
                            if a.equip.composeLevel == b.equip.composeLevel then
                                return a.equip.composeLevel < b.equip.composeLevel
                            end
                            return a.level > b.level
                        end
                        return a.stage > b.stage
                    end
                    return a.equip.id < b.equip.id
                end
                return a.equip.type < b.equip.type
            end
            return a.equip.rank > b.equip.rank
        else
            return a.owner ~= nil
        end
    end
    table.sort( retArray, sortFun )
	return retArray
end
--得到武林谱中装备信息
function equipdata:getAllHandBookEquips(  )
    local retArray = {}
    local equipsConfig = ConfigureStorage.equip
    local myEquips = userdata.roster.equips
    for equipId,equipContent in pairs(equipsConfig) do
        local tempArray = {}
        tempArray["isOpen"] = 0
        for equipUnID,myEquipContent in pairs(myEquips) do
            if myEquipContent == equipId then
                tempArray["isOpen"] = 1
            end
        end
        tempArray["content"] = equipContent
        tempArray["equipId"] = equipId
        table.insert(retArray, tempArray)
    end
    local function sortFu( a,b )
        if a.content.type == b.content.type then
            if a.content.rank == b.content.rank then
                return a.content.id < b.content.id
            end
            return a.content.rank > b.content.rank
        end 
        return a.content.type < b.content.type
    end
    table.sort( retArray,sortFu )
    return retArray
end
--根据装备类型得到可卖装备
function equipdata:getCanSellEquipsByType( equiptype )
    local retArray = {}
    local owners = {}
    for k,hid in pairs(herodata.form) do
        local hero = herodata.heroes[hid]
        local name = herodata:getHeroConfig(hero.heroId).name
        for i=0,3 do
            if hero.equip[tostring(i)] then
                owners[hero.equip[tostring(i)]] = name
            end
        end
    end
    local equips = equipdata.equips
    for equipUniqueId,equipContent in pairs(equips) do
        local equipId = equipContent["equipId"]
        if havePrefix(equipId,equiptype) then
            local equip = equipdata:getEquipConfig(equipId)
            local tempArray = {}
            local owner = owners[equipUniqueId]
            if equip and equip ~= {} and not owner then
                tempArray["equip"] = equip
                tempArray["level"] = equipContent["level"]
                tempArray["stage"] = equipContent["stage"]
                tempArray["id"] = equipContent["id"]
                tempArray["expNow"] = equipContent["expNow"]
                table.insert(retArray,tempArray)
            end
        end
    end
    local function sortFun( a, b )
        if a.equip.rank == b.equip.rank then
            if a.stage == b.stage then
                return a.level < b.level
            end
            return a.stage < b.stage
        end
        return a.equip.rank < b.equip.rank
    end 
    table.sort( retArray, sortFun )
    return retArray
end

-- 装备初始强化价格
function equipdata:getEquipValueConfig(equipId)
    local conf = equipdata:getEquipConfig(equipId)
    if not conf or not conf.silver then
        return 0
    end
    return conf.silver
end

-- 装备强化价格
function equipdata:getEquipValue( eid )
    local equip = equipdata.equips[eid]
    local price = equipdata:getEquipValueConfig(equip.equipId)
    local conf = equipdata:getEquipConfig(equip.equipId)
    return math.floor(price + (conf.updateSilver * ConfigureStorage.equipEffect[tostring(equip.level)].effect) * 0.05) 
end

--根据装备类型得到装备
function equipdata:getEquipsByType( equiptype )
	local retArray = {}
    local owners = {}
    for k,hid in pairs(herodata.form) do
        local hero = herodata.heroes[hid]
        local name = herodata:getHeroConfig(hero.heroId).name
        for i=0,3 do
            if hero.equip[tostring(i)] then
                local ownerTable = {}
                ownerTable["name"] = name
                ownerTable["pos"] = k
                owners[hero.equip[tostring(i)]] = ownerTable
            end
        end
    end
    local equips = equipdata.equips
	for equipUniqueId,equipContent in pairs(equips) do
		local equipId = equipContent["equipId"]
		if havePrefix(equipId,equiptype) then
			local equip = equipdata:getEquipConfig(equipId)
			local tempArray = {}
			if equip and equip ~= {} then
				tempArray["equip"] = equip
				tempArray["level"] = equipContent["level"]
				tempArray["stage"] = equipContent["stage"]
				tempArray["id"] = equipContent["id"]
                tempArray["owner"] = owners[equipUniqueId]
				tempArray["expNow"] = equipContent["expNow"]
                if equipContent.advanced and equipContent.advanced > 0 then
                    local advanced = equipContent.advanced
                    if equip.rank == 3 then
                        tempArray["equip"].composeLevel = ConfigureStorage.equip_blue_awave[tostring(advanced)].rankchange
                        tempArray["equip"].rank = ConfigureStorage.equip_blue_awave[tostring(advanced)].awaverank
                    elseif equip.rank == 4 then
                        tempArray["equip"].composeLevel = ConfigureStorage.equip_pur_awave[tostring(advanced)].rankchange
                        tempArray["equip"].rank = ConfigureStorage.equip_pur_awave[tostring(advanced)].awaverank
                    elseif equip.rank == 5 then
                        tempArray["equip"].composeLevel = ConfigureStorage.equip_gold_awave[tostring(advanced)].rankchange
                        tempArray["equip"].rank = ConfigureStorage.equip_gold_awave[tostring(advanced)].awaverank
                    end
                else
                    tempArray["equip"].composeLevel = 0
                end
				table.insert(retArray,tempArray)
			end
		end
	end
    local function sortFun(a, b)
        if (a.owner and b.owner) then
            if a.owner.pos == b.owner.pos then
                if a.equip.rank == b.equip.rank then
                    if a.stage == b.stage then
                        return a.level > b.level
                    end
                    return a.stage > b.stage
                end
                return a.equip.rank > b.equip.rank
            end
            return a.owner.pos < b.owner.pos
        elseif (a.owner == nil and b.owner == nil) then
            if a.equip.rank == b.equip.rank then
                if a.equip.id == b.equip.id then
                    if a.stage == b.stage then
                        return a.level > b.level
                    end
                    return a.stage > b.stage
                end
                return a.equip.id < b.equip.id
            end
            return a.equip.rank > b.equip.rank
        else
            return a.owner ~= nil
        end
    end
    table.sort( retArray, sortFun )
	return retArray
end

-- 根据类型获得无排序的各种装备
-- 根据装备类型得到装备
function equipdata:getEquipsByTypeAndNoSort( equiptype )
    local retArray = {}
    local owners = {}
    for k,hid in pairs(herodata.form) do
        local hero = herodata.heroes[hid]
        local name = herodata:getHeroConfig(hero.heroId).name
        for i=0,3 do
            if hero.equip[tostring(i)] then
                local ownerTable = {}
                ownerTable["name"] = name
                ownerTable["pos"] = k
                owners[hero.equip[tostring(i)]] = ownerTable
            end
        end
    end
    local equips = equipdata.equips
    for equipUniqueId,equipContent in pairs(equips) do
        local equipId = equipContent["equipId"]
        if havePrefix(equipId,equiptype) then
            local equip = equipdata:getEquipConfig(equipId)
            local tempArray = {}
            if equip and equip ~= {} then
                tempArray["equip"] = equip
                tempArray["level"] = equipContent["level"]
                tempArray["stage"] = equipContent["stage"]
                tempArray["id"] = equipContent["id"]
                tempArray["owner"] = owners[equipUniqueId]
                tempArray["expNow"] = equipContent["expNow"]

                if equipContent.advanced and equipContent.advanced > 0 then
                    local advanced = equipContent.advanced
                    if equip.rank == 3 then
                        tempArray["equip"].composeLevel = ConfigureStorage.equip_blue_awave[tostring(advanced)].rankchange
                        tempArray["equip"].rank = ConfigureStorage.equip_blue_awave[tostring(advanced)].awaverank
                    elseif equip.rank == 4 then
                        tempArray["equip"].composeLevel = ConfigureStorage.equip_pur_awave[tostring(advanced)].rankchange
                        tempArray["equip"].rank = ConfigureStorage.equip_pur_awave[tostring(advanced)].awaverank
                    elseif equip.rank == 5 then
                        tempArray["equip"].composeLevel = ConfigureStorage.equip_gold_awave[tostring(advanced)].rankchange
                        tempArray["equip"].rank = ConfigureStorage.equip_gold_awave[tostring(advanced)].awaverank
                    end
                end
                table.insert(retArray,tempArray)
            end
        end
    end
    return retArray
end

-- 获得英雄头像名称
function equipdata:getEquipIconByEquipId( equipId )
    if nil == equipId or string.len(equipId) == 0 then
        return nil
    end
    if havePrefix(equipId,"vip_") then
        return "ccbResources/icons/vip_001.png"
    end
    return string.format("ccbResources/icons/%s.png", equipId)
end

--根据唯一id更新装备信息
function equipdata:updateEquipByUniqueId( uniqueId,dic )
	if equipdata.equips[uniqueId] then
		equipdata.equips[uniqueId] = dic
	end
end

--得到所有武器信息
function equipdata:getAllWeaponsData(  )
	return equipdata:getEquipsByType( "weapon" )
end

function equipdata:getAllWeaponsDataAndNoSort(  )
    return equipdata:getEquipsByTypeAndNoSort( "weapon" )
end

-- 得到所有可卖武器信息
function equipdata:getCanSellAllWeaponsData(  )
    return equipdata:getCanSellEquipsByType( "weapon" )
end


--得到所有符文的信息
function equipdata:getAllRunesData( )
    return equipdata:getEquipsByType("rune")
end

function equipdata:getAllRunesDataAndNoSort(  )
    return equipdata:getEquipsByTypeAndNoSort("rune")
end

--得到所有可卖符文信息
function equipdata:getCanSellAllRuneData( )
    return equipdata:getCanSellEquipsByType( "rune" )
end

--得到所有盔甲信息
function equipdata:getAllArmorData(  )
    return equipdata:getEquipsByType( "armor" )
end

function equipdata:getAllArmorDataAndNoSort(  )
    return equipdata:getEquipsByTypeAndNoSort( "armor" )
end

--得到所有可卖盔甲信息
function equipdata:getCanSellAllArmorData(  )
    return equipdata:getCanSellEquipsByType( "armor" )
end

--得到所有腰带信息
function equipdata:getAllBeltData(  )
    return equipdata:getEquipsByType( "belt" )
end

function equipdata:getAllBeltDataAndNoSort(  )
    return equipdata:getEquipsByTypeAndNoSort( "belt" )
end

--得到所有可卖腰带信息
function equipdata:getCanSellAllBeltData(  )
    return equipdata:getCanSellEquipsByType( "belt" )
end

--重置用户数据
function equipdata:resetAllData()
    equipdata.equips = {}
end

function equipdataGetCCEquipData( euid )
	local equip = deepcopy(equipdata.equips[eid])
end

-- 获取装备信息
function equipdata:getEquip(eid)
	local equip = deepcopy(equipdata.equips[eid])
	local conf = equipdata:getEquipConfig(equip.equipId)
    equip.rank = conf.rank
    local equipType
    local attachValue = 0
    if conf.type == 0 then
        equipType = "weapon"
    elseif conf.type == 1 then
        equipType = "belt"
    elseif conf.type == 2 then
        equipType = "armor"
    elseif conf.type == 3 then
        equipType = "rune"
    end
    local cCfg = nil
    if equip.advanced and equip.advanced > 0 then
        local advanced = equip.advanced
        if conf.rank == 3 then
            cCfg = ConfigureStorage.equip_blue_awave
            equip.composeLevel = cCfg[tostring(advanced)].rankchange
            equip.rank = cCfg[tostring(advanced)].awaverank
        elseif conf.rank == 4 then
            cCfg = ConfigureStorage.equip_pur_awave
            equip.composeLevel = cCfg[tostring(advanced)].rankchange
            equip.rank = cCfg[tostring(advanced)].awaverank
        elseif conf.rank == 5 then
            cCfg = ConfigureStorage.equip_gold_awave
            equip.composeLevel = cCfg[tostring(advanced)].rankchange
            equip.rank = cCfg[tostring(advanced)].awaverank
        end
    end
    if cCfg then
        for i=1,equip.advanced do
            attachValue = attachValue + cCfg[tostring(i)].typeawaveplus[equipType]
        end
    end
	equip.name = conf.name
	equip.updateSilver = math.floor(conf.updateSilver * ConfigureStorage.equipEffect[tostring(equip.level)].effect)
	equip.icon = conf.icon
	equip.updateEffect = conf.updateEffect
	equip["type"] = conf["type"]
	equip.desp = conf.desp
    for k,v in pairs(conf.initial) do
        equip.initial = v
    end
    equip.refine = conf.refine
    equip.nature = conf.nature
	local level = equip.level
	local stage = equip.stage
	local attr = {}
	for k,v in pairs(conf.initial) do
		local value
        if conf.refine then
            value = v + math.floor((conf.updateEffect + conf.refine * stage) * (level - 1))
        else
            value = v + math.floor(conf.updateEffect * (level - 1))
        end
        if attr[k] then
            attr[k] = attr[k] + value + attachValue
        else
            attr[k] = value + attachValue
        end
    end
    equip.attr = attr
    equip.refinelv = conf.refinelv
    equip.price = equipdata:getEquipPriceByEid(eid)
   	equip.owner = equipdata:getOwnerByEUid(eid)
    return equip
end

--根据唯一ID获得装备属性类型
function equipdata:getEquipAttrType( uid )
	local equip = equipdata:getEquip(uid)
	local myType
	for key,value in pairs(equip.attr) do
		myType = key
	end
	return myType
end

--根据唯一ID获得装备属性值
function equipdata:getEquipAttrValue( uid )
	local equip = equipdata:getEquip(uid)
	local myValue
	for key,value in pairs(equip.attr) do
		myValue = value
	end
	return myValue
end

--根据唯一id得到装备的类型
function equipdata:getEquipTypeValue( uid )
	local equip = equipdata:getEquip(uid)
	if equip["type"] == 0 then
		return "weapon"
	elseif equip["type"] == 1 then 
		return "belt"
	elseif equip["type"] == 2 then 
		return "armor"
    elseif equip["type"] == 3 then
        return "rune"
	end
end

-- 获取英雄身上所有装备
-- 参数 英雄唯一id
function equipdata:getHeroEquips(hid)
	local dic = {}
    local hero = herodata.heroes[hid]
    for i=0,3 do
    	local eid = hero.equip[tostring(i)]
    	if eid then
    		dic[tostring(i)] = equipdata:getEquip(eid)
    	end
    end
    return dic
end

-- 英雄是否穿了指定的装备
function equipdata:bEquipOnHero(equipId, hid)
    local equips = herodata.heroes[hid].equip
	for k,eid in pairs(equips) do
		if equipdata.equips[eid].equipId == equipId then
			return true
		end
	end
	return false
end

-- 获取英雄可以更改的装备信息
-- 参数 装备类型 英雄唯一id 已经装备的装备uid

function equipdata:getCanChangeEquipByUidAndTypeAndEuid( huid,mytype,euid )
	local allEquipData
	local retArray = {}
	if mytype == "weapon" then
		allEquipData = deepcopy(equipdata:getAllWeaponsDataAndNoSort(  ))
	elseif mytype == "armor" then
		allEquipData = deepcopy(equipdata:getAllArmorDataAndNoSort(  ))
	elseif mytype == "belt" then
		allEquipData = deepcopy(equipdata:getAllBeltDataAndNoSort(  ))
    elseif mytype == "rune" then
        allEquipData = deepcopy(equipdata:getAllRunesDataAndNoSort(  ))
	end
	local equips = deepcopy(equipdata:getHeroEquips(huid))
    local numArray = {}
	for j=0,3 do
        local dic = equips[tostring(j)]
        if dic then
        	for i=1,#allEquipData do
                if allEquipData[i] ~= nil then
            		if allEquipData[i].id == dic.id then
                        table.insert(numArray,i)
    	            end
                end
        	end
        end
    end
    -- 判断一个字符串是否在一个字符数组里
    local function isInArray( string,array )
        for i=1,getMyTableCount(array) do
            if array[i] == string then
                return true
            end
        end
        return false
    end 
    for i=1,getMyTableCount(allEquipData) do
        if not isInArray(i,numArray) then
            table.insert( retArray,allEquipData[i] )
        end
    end
    local function sortFun( a,b )
        if a.equip.rank == b.equip.rank then
            if a.stage == b.stage then
                return a.level > b.level
            end
            return a.stage > b.stage
        end
        return a.equip.rank > b.equip.rank
    end 
    table.sort( retArray,sortFun )
    return retArray
end

function equipdata:addEquip(eid, dic)
    equipdata.equips[eid] = dic
end

function equipdata:getOneEquipAttrByLevelAndStage( equipId,lv,stg )
    local conf = equipdata:getEquipConfig( equipId )
    local attr = {}
    for k,v in pairs(conf.initial) do
        local value
        if conf.refine then
            value = v + math.floor((conf.updateEffect + conf.refine * stg) * (lv - 1))
        else
            value = v + math.floor(conf.updateEffect * (lv - 1))
        end
        return value
    end
end

