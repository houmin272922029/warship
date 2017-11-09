-- 联盟信息
unionData = {
	-- 联盟详细信息 名称、等级、人数、经验、公告
	detail = nil,

	-- 联盟申请列表
	applicants = nil,

	-- 联盟成员列表
	members = nil,
	
	-- 联盟排行榜列表
	rank = nil,

	-- 联盟动态列表
	informations = nil,

	-- 自己的联盟成员信息
	selfMemberInfo = nil,

	-- 贡献
	contribution = nil,

	-- 联盟商城数据
	shopData = {},

	-- 联盟仓库
	depot = {},

	-- 联盟捐献
	donate = {},

	-- 记录指针数据
	recordPointer = {},

	-- 进攻buff
	sieges = {},

	-- 工事
	forts = {},
}

-- 联盟权限
UNION_DISMISS = 3	-- 解散
UNION_KICK = 4		-- 踢出
UNION_PROMOTE = 5	-- 升职
UNION_DEMOTE = 6	-- 降职
UNION_CHANGENOTICE = 8	-- 修改公告

UnionActType = {
	act1 = 1,
	act2 = 2,
	act3 = 3,
	act4 = 4,
	UNION_DONATE = 5,
	UNION_GUESSING = 6,
}

-- 重置缓存数据
function unionData:resetAllData()
	unionData.detail = nil
	unionData.applicants = nil
	unionData.members = nil
	unionData.rank = nil
	unionData.informations = nil
	unionData.selfMemberInfo = nil
	unionData.contribution = nil
	unionData.shopData = {}
	unionData.depot = {}
	unionData.donate = {}
	unionData.recordPointer = {}
	unionData.sieges = {}
	unionData.forts = {}
end

-- 初始化公会信息
function unionData:fromDic(dic)
	-- body
	-- unionData:resetAllData()
	if dic and dic["league"] and dic["league"]["name"] then
		unionData.detail = dic["league"]
	    unionData.members = dic["league"]["members"]
	    if dic["leagueMessages"] then
		    unionData.informations = dic["leagueMessages"]
		end
	    if dic["contribution"] then
		    unionData.contribution = dic["contribution"]
		end
	    unionData.shopData = dic["league"]["shop"]
	    unionData.depot = dic["league"]["depot"]
	    if dic["sweetContribution"] then
		    unionData.donate = dic["sweetContribution"]
		end
	    unionData.recordPointer = dic["league"]["recordPointer"]
	    unionData.sieges = dic["league"]["sieges"]
	    unionData.forts = dic["league"]["forts"]
	    for kIdx, memberInfo in pairs(unionData.members) do
	    	if memberInfo and memberInfo["playerId"] and tonumber(memberInfo["playerId"]) == tonumber(userdata.userId) then
	    		unionData.selfMemberInfo = memberInfo
	    	end
	    end
	end
end

function unionData:isHaveUnion( )
	-- body
	if unionData.detail and unionData.detail["name"] then
		return true
	end
	return false
end

function unionData:getNameByDuty( duty )
	-- body
	return ConfigureStorage.leagueDuty[tostring(duty)].name
end

-- 职位对应的权限
function unionData:getPermissionByDuty( duty )
	-- body
	return ConfigureStorage.leagueDuty[tostring(duty)].permission
end

-- 某职位是否拥有某种权限
function unionData:IsPermitted( duty, iType )
	-- body
	-- print(iType)
	local permission = ConfigureStorage.leagueDuty[tostring(duty)].permission
	-- PrintTable(permission)
	for k,v in pairs(permission) do
		if v == iType then
			return true
		end
	end
	return false
end

-- 当前职位所能容纳最大人数限制
function unionData:getMaxNumberByDuty( duty )
	-- body
	local numMax = 0
	for k,v in pairs(unionData.members) do
		if v.duty == duty then
			numMax = numMax + 1
		end
	end
	return numMax
end

-- 当前职位成员是否超过人数限制
function unionData:IsDutyFull( duty )
	-- body
	local max = ConfigureStorage.leagueDuty[tostring(duty)].numMax
	local currentNum = unionData:getMaxNumberByDuty(duty)
	if max == -1 then	-- 无人数限制
		return false
	elseif currentNum >= max then	-- 超过人数限制
		return true
	end
	return false	-- 不超过人数限制
end

-- 是否是会长判断
function unionData:isCreator( )
	-- body
	if unionData.selfMemberInfo and unionData.selfMemberInfo["playerId"] and tonumber(unionData.selfMemberInfo["playerId"]) == tonumber(userdata.userId) then
		if unionData.selfMemberInfo["duty"] == 1 or unionData.selfMemberInfo["duty"] == 2 then
			return true
		end
	end
	return false
end

function unionData:getConfByTypeAndID( myType,id )
	local item
	if myType == "stuff_01" or myType == "stuff_02" or myType == "stuff_03" or myType == "add" or myType == "keybag" or myType == "item" or myType == "" then
		item = wareHouseData:getItemConfig(id)
	elseif myType == "book" then
		item = skilldata:getSkillConfig(id)
	elseif myType == "soul" then
		item = herodata:getHeroConfig(id)
	elseif myType == "shard" then
		item = shardData:getOneShardConf( id )
	elseif myType == "shadow" then
		item = shadowData:getOneShadowConf( id )
	end
	return item
end

-- 获得一个联盟商城商品的配置信息
function unionData:getOneItemConfByCid( cid )
	local item = {}
	local unionItemConf = ConfigureStorage.leagueCandyShopItem
	local temp = unionItemConf[tostring(cid)]
	local conf = unionData:getConfByTypeAndID( temp.type,temp.ID )
	item.level = temp.level
	item.id = temp.ID
	item.cost = temp.cost
	item.type = temp.type
	item.daily = temp.daily
	item.max = temp.max
	item.weight = temp.weight
	item.conf = conf
	return item
end

-- 获取联盟商城的数据
function unionData:getUnionData(  )
	local retArray = {}
	local unionConf = ConfigureStorage.leagueCandyShopItem
	if unionData.shopData.items then
		local items = unionData.shopData.items
		for i=1,9 do
			local item = items[tostring(i)]
			local tempArray = unionData:getOneItemConfByCid( item.itemKey )
			if item.buyLogs and item.buyLogs[tostring(userdata.userId)] then
				tempArray.count = item.buyLogs[tostring(userdata.userId)]
			else
				tempArray.count = 0
			end
			table.insert(retArray,tempArray)
		end
	end
	return retArray
end
-- 联盟商城预览数据
function unionData:getNextRefreshUnionData(  )
	local retArray = {}
	local unionConf = ConfigureStorage.leagueCandyShopItem
	if unionData.shopData.itemsNext then
		local items = unionData.shopData.itemsNext
		for i=1,9 do
			local item = items[tostring(i)]
			local tempArray = unionData:getOneItemConfByCid( item.itemKey )
			table.insert(retArray,tempArray)
		end
	end
	return retArray
end

function unionData:isOneDonateCanUse( index )
	local donateNum = unionData.donate[tostring(index)]
	local limitCount = ConfigureStorage.leagueDonate[tostring(index)].max
	if donateNum then
		if donateNum >= limitCount then
			return false
		end
	end
	return true
end
-- 获得糖果屋属性加成
function unionData:getDepotAttrAddByLevel( level,key )
	local retArray = {}
	local conf = ConfigureStorage.leagueDepot 
	retArray[1] = conf[tostring(level)].max
	local nextLevel = level + 1
	retArray[2] = conf[tostring(nextLevel)].max
	retArray[3] = conf[tostring(level)].min 
	return retArray
end
-- 根据等级获得建筑属性加成值
function unionData:getAttrAddByLevel( level,key )
	local retArray = {}
	if havePrefix(key,"fort") then
		local conf = ConfigureStorage.leagueFort
		retArray[1] = conf[tostring(level)][tostring(key)].value
		local nextLevel = level + 1
		retArray[2] = conf[tostring(nextLevel)][tostring(key)].value
	elseif havePrefix(key,"siege") then
		local conf = ConfigureStorage.leagueSiege
		retArray[1] = conf[tostring(level)][tostring(key)].value
		local nextLevel = level + 1
		retArray[2] = conf[tostring(nextLevel)][tostring(key)].value
	end
	return retArray
end
-- 获得联盟建筑升级所有数据
function unionData:getAllBuildingUpgrateData(  )
	local confDic = deepcopy(ConfigureStorage.leagueLvup)
	local retArray = {}
	-- 获取所有建筑等级属性
	local buildLevelArray = {}
	buildLevelArray["leagueshop"] = deepcopy(unionData.detail.shop) 
	buildLevelArray["leaguedepot"] = deepcopy(unionData.detail.depot)
	for k,v in pairs(unionData.detail.forts) do
		buildLevelArray[k] = v
	end
	for k,v in pairs(unionData.detail.sieges) do
		buildLevelArray[k] = v
	end
	for k,v in pairs(confDic) do
		local tempArray = {}
		tempArray.content = buildLevelArray[k]
		tempArray.conf = v
		tempArray.pos = v.position
		tempArray.id = k
		table.insert(retArray,tempArray)
	end
	local function sortFun( a,b )
		return a.pos < b.pos
	end
	table.sort( retArray,sortFun )
	return retArray
end

-- 获取自己的糖果数
function unionData:getOwnerCandy()
	return unionData.selfMemberInfo.sweetCount
end

-- 获取进攻buff
function unionData:getAttackBuff()
	local buff = {}
	local keys = {"atk", "def", "hp", "mp"}
	for k,v in pairs(unionData.sieges) do
		local dic = ConfigureStorage.leagueSiege[tostring(v.level)][k]
		for i,key in ipairs(keys) do
			if dic[key] then
				if buff[key] then
					buff[key] = buff[key] + dic[key] * 100
				else
					buff[key] = dic[key] * 100
				end
			end
		end
	end
	return buff
end
-- 获得联盟成员列表
function unionData:getUnionMemberList(  )
	-- PrintTable(unionData.members)
	return deepcopy(unionData.members)
end
-- 成员列表
function unionData:getMembers()
	local array = {}
	for k,v in pairs(unionData.members) do
		table.insert(array, v)
	end
	local function sortFun(a, b)
		return a.duty < b.duty
	end
	return array
end
-- 获取商城等级
function unionData:getShopLevel(  )
	if unionData.detail then
		return unionData.detail.shop.level
	end
	return 1
end

-- 获得商城购买需求等级限制
function unionData:getNeedLevelByIndex( index )
	-- local needLevel = 0
	local conf = deepcopy(ConfigureStorage.leagueShopLevel)
	-- for i=1,9 do
	-- 	local reqLevel = conf[tostring(i)].lvrequire
	-- 	if index <= reqLevel then
	-- 		needLevel = i
	-- 		return needLevel
	-- 	end
	-- end
	return conf[tostring(index)].lvrequire
end

function unionData:getOneItemCanBuyTime( index )
	local shopData = unionData.detail.shop
	local items = shopData.items
	local conf = ConfigureStorage.leagueCandyShopItem
	local itemKey = items[tostring(index)].itemKey
	local confDic = conf[tostring(itemKey)]
	local max = confDic.max
	local buyLogs = items[tostring(index)].buyLogs
	if buyLogs then
		if buyLogs[tostring(userdata.userId)] then
			if buyLogs[tostring(userdata.userId)] >= max then
				return 0
			else
				return max - buyLogs[tostring(userdata.userId)]
			end
		end
	end
	return max
end

-- 获取一个商品是否可以继续购买
function unionData:getOneItemCanBuy( index )
	local shopData = unionData.detail.shop
	local items = shopData.items
	local conf = ConfigureStorage.leagueCandyShopItem
	local itemKey = items[tostring(index)].itemKey
	local confDic = conf[tostring(itemKey)]
	local max = confDic.max
	local buyLogs = items[tostring(index)].buyLogs
	if buyLogs then
		if buyLogs[tostring(userdata.userId)] then
			if buyLogs[tostring(userdata.userId)] >= max then
				return false
			end
		end
	end
	return true
end

-- 根据建筑id获得建筑升级消耗
function unionData:getNeedCountByLevelAndKey( level,key )
	local lvcost = 0
	if key == "leagueshop" then
		local conf = ConfigureStorage.leagueShop
		lvcost = conf[tostring(level)].lvcost
	elseif key == "leaguedepot" then
		local conf = ConfigureStorage.leagueDepot
		lvcost = conf[tostring(level)].lvcost
	elseif havePrefix(key,"fort") then
		local conf = ConfigureStorage.leagueFort
		lvcost = conf[tostring(level)][tostring(key)].lvcost
	elseif havePrefix(key,"siege") then
		local conf = ConfigureStorage.leagueSiege
		lvcost = conf[tostring(level)][tostring(key)].lvcost
	end
	return lvcost
end

-- 判断一个建筑是否可以升级
function unionData:isShopBuildingCanUpgrate(  )
	local conf = deepcopy(ConfigureStorage.leagueShoplv)
	local unionLv = unionData.detail["level"]
	local shopCanUpgrateLv = conf[tostring(unionLv)].shoplv
	local shopLv = unionData.detail.shop.level
	if shopCanUpgrateLv <= shopLv then
		return false
	else
		return true
	end
end

-- 获取联盟信息弹框所有信息
function unionData:getUnionAllData(  )
	local retArray = {}
	retArray.name = unionData.detail.name  
	retArray.level = unionData.detail.level
	retArray.contributionValue = unionData.detail.depot.sweetCount
	retArray.safeCount = ConfigureStorage.leagueDepot[tostring(retArray.level)].min
	retArray.memberCount = getMyTableCount(unionData.detail.members) 
	retArray.bossName = ""
	for i=1,getMyTableCount(unionData.detail.members)  do
		local member = unionData.detail.members[tostring(i - 1)]
		if tonumber(member.duty) == 1 then
			retArray.bossName = member.name
		end
	end
	retArray.memberCountMax = unionData.detail.memberMax 
	retArray.recordPointerCount =  unionData.recordPointer.count
	
	return retArray
end

-- 获得记录指针恢复时间
function unionData:getPointRecoverTime(  )
	local retArray = {}
	local totlePointCount = ConfigureStorage.leagueBattleRecordPointer.max
	local pointDuration = ConfigureStorage.leagueBattleRecordPointer.recoverTime
	
	if unionData.detail.recordPointer and unionData.detail.recordPointer.lastTime and (totlePointCount > unionData.detail.recordPointer.count) then
		local lastRecoverTime = unionData.detail.recordPointer.lastTime 
		local currentPointCount = unionData.detail.recordPointer.count
		local usedCount = totlePointCount - currentPointCount
		retArray.allTime = lastRecoverTime + usedCount * pointDuration - userdata.loginTime
		retArray.nextTime = lastRecoverTime +  pointDuration - userdata.loginTime
	else
		retArray.allTime = 0
		retArray.nextTime = 0
	end
	return retArray
end
-- 获得下次可以发放的联盟糖果倒计时时间
function unionData:getUnionCandyTime(  )
	if unionData.detail.depot and unionData.detail.depot.lastAllotTime then
		return unionData.detail.depot.lastAllotTime + ConfigureStorage.leagueBattleAllotSweetTimeInterval - userdata.loginTime
	end
	return 0
end

