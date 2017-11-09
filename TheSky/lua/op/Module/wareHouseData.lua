wareHouseData = {
	items = {},
	equips = {},
	books = {},
	bagDelay = {}, -- 延时礼包
}

ITEMTYPE = {
	none = 0,
	stuff_01 = 1,
	stuff_02 = 2,
	stuff_03 = 3,
	drawing = 4,
	keybag = 5,
	delay = 6,
	vip = 7,
}

function wareHouseData:getItemConfig(itemId)
	return deepcopy(ConfigureStorage.item[itemId])
end

function wareHouseData:getItemCountById( itemId )
	if wareHouseData.items[itemId] then
		return wareHouseData.items[itemId]
	else
		return 0
	end
end

-- 获取道具资源配置
function wareHouseData:getItemResource(itemId)
	local conf = {}
	if itemId == "silver" or itemId == "berry" then
		conf.rank = 1
		conf.icon = "ccbResources/icons/berryIcon.png"
		conf.name = HLNSLocalizedString("贝里")
	elseif itemId == "gold" then
		conf.rank = 4
		conf.icon = "ccbResources/icons/goldIcon.png"
		conf.name = HLNSLocalizedString("金币")
	elseif havePrefix(itemId, "hero_") then
		local config = herodata:getHeroConfig(itemId)
		conf.rank = config.rank
		conf.icon = herodata:getHeroHeadByHeroId( itemId )
		conf.name = config.name
	else
		local config = wareHouseData:getItemConfig(itemId)
		if not config then
			config = equipdata:getEquipConfig(itemId)
		end
		if not config then
			config = skilldata:getSkillConfig(itemId)
		end
		if not config then
			conf.rank = 1
			conf.icon = nil
			conf.name = ""
		else
			if havePrefix(itemId,"chapter") then
				conf.icon = string.format("ccbResources/icons/%s.png", config.params)
			else
				conf.icon = string.format("ccbResources/icons/%s.png", config.icon)
			end
			conf.rank = config.rank
			conf.name = config.name
		end

	end
	conf.id = itemId
	return conf
end

-- 减少包裹中某个道具数量
function wareHouseData:reduceUserItem( item_id, amount )
    if tonumber(amount) <= tonumber(wareHouseData.items[item_id]) then        
        wareHouseData.items[item_id] = wareHouseData.items[item_id] - amount
    	if wareHouseData.items[item_id] == 0 then
    		wareHouseData.items[item_id] = nil
    	end
    else 
        wareHouseData.items[item_id] = nil
    end
end

-- 获取某个道具拥有的数量
-- 参数：道具id
-- 返回：数量
function wareHouseData:getItemCount( itemId )
    if nil == itemId or string.len(itemId) == 0 then
        return 0
    end
	return wareHouseData.items[itemId] and wareHouseData.items[itemId] or 0
end

-- 获取某个道具名字
-- 参数：道具id
-- 返回：
function wareHouseData:getItemName( itemId )
    if nil == itemId or string.len(itemId) == 0 then
        return 0
    end
	return ConfigureStorage.item[itemId].name
end
--判断一个字符串是否包含一个前缀
function wareHouseData:stringHasPrix( sourceStr,str )
	local max,min = string.find(sourceStr,str)
	if max and min and max == 1 then
		return true
	else
		return false
	end
end

-- 延时礼包剩余次数
function wareHouseData:getBagDelayLastTime(bid)
	local bag = wareHouseData.bagDelay[bid]
	local conf = ConfigureStorage.bagDelay[bag.itemId]
	local total = #conf.value
	if not bag.lastTime then
		-- 礼包还没有领取
		if DateUtil:beginDay(bag.beginTime) == DateUtil:beginDay(userdata.loginTime) then
			-- 购买时间是今天
			return total
		else
			-- 购买时间不是今天 减去流逝的时间
			return total - (DateUtil:beginDay(userdata.loginTime) - DateUtil:beginDay(bag.beginTime)) / (24 * 60 * 60)
		end
	else
		-- 礼包有领取过
		if DateUtil:beginDay(bag.lastTime) == DateUtil:beginDay(userdata.loginTime) then
			-- 今天领取的
			return total - (DateUtil:beginDay(bag.lastTime) - DateUtil:beginDay(bag.beginTime)) / (24 * 60 * 60) - 1
		else
			-- 非今天领取的 减去流逝的时间
			return total - (DateUtil:beginDay(userdata.loginTime) - DateUtil:beginDay(bag.beginTime)) / (24 * 60 * 60)
		end
	end
end

-- 获取延时礼包道具信息
function wareHouseData:getBagDelayData(bid)
	local array = {}
	local bag = wareHouseData.bagDelay[bid]
	local conf = ConfigureStorage.bagDelay[bag.itemId]
	local index = 1
	if bag.lastTime then
		index = (DateUtil:beginDay(userdata.loginTime) - DateUtil:beginDay(bag.beginTime)) / (24 * 60 * 60) + 1
		if DateUtil:beginDay(bag.lastTime) == DateUtil:beginDay(userdata.loginTime) then
			index = index + 1
		end
	end
	for itemId,count in pairs(conf.value[index]) do
		local dic = {["itemId"] = itemId, ["count"] = count}
		table.insert(array, dic)
	end
	return array
end


-- 得到所有仓库内容信息
function wareHouseData:getAllWareHouseData(  )
	local function getBagDelay()
		local array = {}
		if not wareHouseData.bagDelay then
			return array
		end
		for bid, bag in pairs(wareHouseData.bagDelay) do
			
		end
	end
	local retArray = {}
	if wareHouseData.items then
		for itemId,count in pairs(wareHouseData.items) do
			local oneContent = {}
			local item = getItemWithItemID(itemId)
			oneContent["item"] = item
			oneContent["id"] = itemId
			oneContent["count"] = count
			if item.type ~= "chapter" then
				table.insert(retArray,oneContent)
			end
			oneContent["type"] = ITEMTYPE[item.type] or ITEMTYPE.none
		end
	end
	if wareHouseData.bagDelay then
		for bid,bag in pairs(wareHouseData.bagDelay) do
			local oneContent = {}
			local item = getItemWithItemID(bag.itemId)
			oneContent["item"] = item
			oneContent["bag"] = bag
			oneContent["id"] = bid
			oneContent["type"] = ITEMTYPE.delay
			table.insert(retArray, oneContent)
		end
	end

	local function sortFun( a,b )
		if a.type == b.type then
			return a.item.rank > b.item.rank
		end
		return a.type > b.type
	end
	table.sort( retArray,sortFun )

	return retArray
	
end
--判断一个键值对的数组是否包含某个key
function dicHaveKey( dic,key )
	local flag = false
	for theKey,value in pairs(dic) do
		if theKey == key then
			flag = true
		end
	end
	return flag
end

--判断一个数组是否有某个值
function isArrayHavaValue( array,value )
	local flag = false
	for key,myvalue in pairs(array) do
		if myvalue == value then
			flag = true
		end
	end
	return flag
end



--返回所有武器精炼材料
function wareHouseData:getWeaponRefineItem(  )
	local retArray = {}
	local items = ConfigureStorage.item
	local allMaterial = {}
	for key,value in pairs(items) do
		if value["type"] == "stuff_01" then
			table.insert(allMaterial,key)
		end
	end

	for i=1,getMyTableCount(allMaterial) do
		if wareHouseData.items[allMaterial[i]] then
			local oneContent = {}
			local item = getItemWithItemID(allMaterial[i])
			oneContent["item"] = item
			oneContent["count"] = wareHouseData.items[allMaterial[i]]
			table.insert(retArray,oneContent)
		else
			local oneContent = {}
			local item = getItemWithItemID(allMaterial[i])
			oneContent["item"] = item
			oneContent["count"] = 0
			table.insert(retArray,oneContent)
		end
	end
	local function sortFun( a,b )
		return a.item.sort < b.item.sort
	end
	table.sort( retArray,sortFun )
	return retArray
end

--返回说有服装精炼材料
function wareHouseData:getClothRefineItem(  )
	local retArray = {}
	local items = ConfigureStorage.item
	local allMaterial = {}
	for key,value in pairs(items) do
		if value["type"] == "stuff_02" then
			table.insert(allMaterial,key)
		end
	end
	for i=1,getMyTableCount(allMaterial) do
		if wareHouseData.items[allMaterial[i]] then
			local oneContent = {}
			local item = getItemWithItemID(allMaterial[i])
			oneContent["item"] = item
			oneContent["count"] = wareHouseData.items[allMaterial[i]]
			table.insert(retArray,oneContent)
		else
			local oneContent = {}
			local item = getItemWithItemID(allMaterial[i])
			oneContent["item"] = item
			oneContent["count"] = 0
			table.insert(retArray,oneContent)
		end
	end
	local function sortFun( a,b )
		return a.item.sort < b.item.sort
	end
	table.sort( retArray,sortFun )
	return retArray
end

--返回所有饰品精炼材料
function wareHouseData:getDecoratRefineItem(  )
	local retArray = {}
	local items = ConfigureStorage.item
	local allMaterial = {}
	for key,value in pairs(items) do
		if value["type"] == "stuff_03" then
			table.insert(allMaterial,key)
		end
	end
	for i=1,getMyTableCount(allMaterial) do
		if wareHouseData.items[allMaterial[i]] then
			local oneContent = {}
			local item = getItemWithItemID(allMaterial[i])
			oneContent["item"] = item
			oneContent["count"] = wareHouseData.items[allMaterial[i]]
			table.insert(retArray,oneContent)
		else
			local oneContent = {}
			local item = getItemWithItemID(allMaterial[i])
			oneContent["item"] = item
			oneContent["count"] = 0
			table.insert(retArray,oneContent)
		end
	end
	local function sortFun( a,b )
		return a.item.sort < b.item.sort
	end
	table.sort( retArray,sortFun )
	return retArray
end

--返回所有符文精炼材料
function wareHouseData:getRuneRefineItem(  )
	local retArray = {}
	local items = ConfigureStorage.item
	local allMaterial = {}
	for key,value in pairs(items) do
		if value["type"] == "stuff_01" or value["type"] == "stuff_02" or value["type"] == "stuff_03" then
			local oneContent = {}
			local item = getItemWithItemID(key)
			oneContent["item"] = item
			oneContent["count"] = wareHouseData.items[key] or 0
			table.insert(retArray,oneContent)
		end
	end
	local function sortFun( a,b )
		return a.item.sort < b.item.sort
	end
	table.sort( retArray,sortFun )
	return retArray
end

--添加item	
function wareHouseData:addItemByIdAndCount( itemId,count )
	if dicHaveKey(wareHouseData.items,itemId) then
		wareHouseData.items[itemId] = wareHouseData.items[itemId] + count
	else
		wareHouseData.items[itemId] = count
	end
end
-- 返回开箱子的时候需要的itemid
function wareHouseData:getNeedItemIdByItemId( itemId )
	local itemContent = wareHouseData:getItemConfig(itemId)
	local needId  			-- 需要的道具id
	for k,v in pairs(itemContent.params) do
		needId = k
	end
	return needId
end

-- 根据箱子或钥匙的id得到开启还需要的数目
function wareHouseData:getNeedCountByKeyBagIDAndCount( itemId,count )
	local itemContent = wareHouseData:getItemConfig(itemId)
	local needId  			-- 需要的道具id
	local needCount  		-- 需要的道具数目
	for k,v in pairs(itemContent.params) do
		needId = k
		needCount = v * count
	end
	local haveCount = wareHouseData:getItemCountById( needId )
	return (needCount - haveCount) > 0 and (needCount - haveCount) or 0
end

-- 获得一个图纸合成需要的数目
function wareHouseData:getOneDrawingNeedCount( itemId )
	local conf = wareHouseData:getItemConfig(itemId)
	if conf then
		if conf.params then
			if conf.params.piece then
				return conf.params.piece
			end
		end
	end
	return 0
end

function wareHouseData:resetAllData(  )
	wareHouseData.items = nil
	wareHouseData.equips = nil
	wareHouseData.books = nil
	wareHouseData.bagDelay = {}
end