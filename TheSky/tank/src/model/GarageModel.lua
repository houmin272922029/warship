--[[
	车库数据
	Author: Aaron Wei
	Date: 2015-03-20 10:43:32
]]

local GarageModel = qy.class("GarageModel", qy.tank.model.BaseModel)

local StrongModel = qy.tank.model.StrongModel
function GarageModel:init(data)
    self.data = data
	self:updateTankList(data)
	self:updateFormation(data)
	self:updateTankFragment(data)

	--鼠式晋升
	self.config = qy.Config.tank_promotion
	self.config1 = qy.Config.tank_promotion_condition
	self.config2 = qy.Config.tank_promotion_type
	self.config3 = qy.Config.tank_promotion_consume
	print("======表",data)


end

function GarageModel:updateTankList(data)
--	self.data = data
	self.picAddList = {}
	self.totalTanks = {}
	if data and data.tank then
		for i=1,#data.tank do
			local entity = qy.tank.entity.TankEntity.new(data.tank[i])
			table.insert(self.totalTanks,entity)
		end
	end
	-- self.totalTanks = self:sort(self.totalTanks)
end

function GarageModel:updateFormation(data)
	self.selectedTanks = {}
	self.unselectedTanks = {}
	self.unselectedTanks_ = {}
	self.formation = {}
	self.data.formation = data.formation
	if data and data.formation then
		for i=1,#self.totalTanks do
			local entity = self.totalTanks[i]
			entity.formation_id = nil
			if self:contains(data.formation,entity.unique_id) then
				entity:setToBattle(true)
				entity.expedition_status = 1
				table.insert(self.selectedTanks,entity)
			else
				entity:setToBattle(false)
				entity.expedition_status = 0
				table.insert(self.unselectedTanks,entity)
				self.unselectedTanks_[tostring(entity.unique_id)] = entity
			end
		end

		for i=1,6 do
			if data.formation["p_"..i] == -1 then
				table.insert(self.formation,-1)
			elseif data.formation["p_"..i] == 0 then
				table.insert(self.formation,0)
			else
				local entity = self:getEntityByUniqueID(data.formation["p_"..i])
				entity.formation_id = i
				table.insert(self.formation,entity)
			end
		end
		self.selectedTanks = self:sort(self.selectedTanks)
		self.unselectedTanks = self:sort(self.unselectedTanks)		

		self:UpdateStrong() --更新变强数值
		
		self.formationClone = clone(self.formation)
	end
	self.totalTanks = self:sort(self.totalTanks)
end


function GarageModel:updateTankFragment(data)
	self.tankFragmentList = {}
	self.tank_fragment_merge = {20, 50, 80, 100, 150, 200} --白 绿 蓝 紫 黄 红
	if data and data.tank_fragment then
		for i=1,#data.tank_fragment do
			local entity = qy.tank.entity.TankEntity.new(data.tank_fragment[i])
			entity.is_tank_fragment = 1
			entity.num = data.tank_fragment[i].num
			table.insert(self.tankFragmentList,entity)
		end
	end
	self:sortTankFragment()
end

function GarageModel:getTankFragment()
	local _table = {}
	for i = 1, #self.unselectedTanks do
		table.insert(_table, self.unselectedTanks[i])
	end

	for i=1,#self.tankFragmentList do
		table.insert(_table, self.tankFragmentList[i])
	end

	return _table
end


function GarageModel:UpdateStrong()
	local x = 0
    for k,v in pairs(StrongModel.StrongFcList) do
        x = x + 1
        if v.id == 1 then
            table.remove(StrongModel.StrongFcList, x)
        end
    end
    local i = 0
    for k,v in pairs(StrongModel.StrongFcList) do
        i = i + 1
        if v.id == 2 then
            table.remove(StrongModel.StrongFcList, i)
        end
    end

	local totalLevel = 0
	local totalAdvanceLevel = 0
	local level = qy.tank.model.UserInfoModel.userInfoEntity.level
	print("等级",level)
	for i,v in ipairs(self.formation) do
		if type(v) ~= "number" then
			totalLevel = totalLevel + v.level
			totalAdvanceLevel = totalAdvanceLevel + v.advance_level
		end
	end
	local tanklist = {["id"] = 1 , ["progressNum"] = (totalLevel / (level * 6 * 0.8))}
	table.insert(StrongModel.StrongFcList,tanklist)

	local progressNum = 0
	if level < 40 then
		progressNum = 0
	elseif level >= 40 and level < 45 then
		progressNum = totalAdvanceLevel / (5 * 2)
	elseif level >= 45 and level < 50 then
		progressNum = totalAdvanceLevel / (5 * 3)
	elseif level >= 50 and level < 55 then
		progressNum = totalAdvanceLevel / (5 * 4)
	elseif level >= 55 and level < 60 then
		progressNum = totalAdvanceLevel / (5 * 5)
	elseif level >= 60 and level < 70 then
		progressNum = totalAdvanceLevel / (5 * 6)
	elseif level >= 70 and level < 80 then
		progressNum = totalAdvanceLevel / (5 * 7)
	elseif level >= 80 and level < 90 then
		progressNum = totalAdvanceLevel / (5 * 8)
	elseif level >= 90 then
		progressNum = totalAdvanceLevel / (5 * 9)
	end
	local tanklist1 = {["id"] = 2 , ["progressNum"] = progressNum}
	table.insert(StrongModel.StrongFcList,tanklist1)
end

function GarageModel:updateEquipStrong()
	local i = 0
    for k,v in pairs(StrongModel.StrongFcList) do
        i = i + 1
        if v.id == 6 then
            table.remove(StrongModel.StrongFcList, i)
        end
    end
    local totalEquipLevel = 0
    local uselevel = qy.tank.model.UserInfoModel.userInfoEntity.level
    for i,v in ipairs(self.formation) do
		if type(v) ~= "number" then
			local equipEntity = v:getEquipEntity()
			if equipEntity then
				for key,value in pairs(equipEntity) do
					if type(value) == "table" and value.level then
						totalEquipLevel = totalEquipLevel + value.level
					end
				end
				
			end
		end
	end
	local tanklist = {["id"] = 6 , ["progressNum"] = (totalEquipLevel / (uselevel * 2 * 0.6))}
	table.insert(StrongModel.StrongFcList,tanklist)
end

--[[--
--新手引导自动上阵
--]]
function GarageModel:automaticToFormation(data)
	for i=1,6 do
		if data["p_"..i] > 0 then
			print("p_" .. i .. "---uid---" .. data["p_"..i])
			self.formation[i] = self:getEntityByUniqueID(data["p_"..i])
			table.insert(self.selectedTanks, self.formation[i])
			local index = self:getUnselectIndexByUniqueID(data["p_"..i])
			if index > 0 then
				table.remove(self.unselectedTanks, index)
			end
		end
	end
end

function GarageModel:getUnselectIndexByUniqueID(_uid)
	for i=1,#self.unselectedTanks do
		if self.unselectedTanks[i].unique_id == _uid then
			return i
		end
	end

	return -1
end

function GarageModel:getSelectIndexByUniqueID(_uid)
	for i=1,#self.selectedTanks do
		if self.selectedTanks[i].unique_id == _uid then
			return i
		end
	end

	return -1
end

--[[--
--主角升级开启阵位
--]]
function GarageModel:openFormation(data)
	local _index = 0
	for i = 1, #data do
		_index =  tonumber(string.sub(data[i], 3, string.len(data[i])))
		if tonumber(self.formation[_index]) then
			self.formation[_index] = 0
		end
	end
end

function GarageModel:sort(arr)
	table.sort(arr,function(a,b)
		-- if self:contains(self.data.formation,a) == self:contains(self.data.formation,b) then
		if tonumber(a.isBattle) == tonumber(b.isBattle) then
			if tonumber(a.isBattle) == 1 then -- 已上阵的按阵位排
				return tonumber(a.formation_id) < tonumber(b.formation_id)
			else
				if tonumber(a.quality) == tonumber(b.quality) then
					if tonumber(a.star) == tonumber(b.star) then
						if tonumber(a.level) == tonumber(b.level) then
							if tonumber(a.tank_id) == tonumber(b.tank_id) then
								return false
							else
								-- 按模板表排序
								return tonumber(a.tank_id) > tonumber(b.tank_id)
							end
						else
							-- 按等级排序
							return tonumber(a.level) > tonumber(b.level)
						end
					else
						-- 按星级排序
						return tonumber(a.star) > tonumber(b.star)
					end
				else
					-- 按品质排序
					return tonumber(a.quality) > tonumber(b.quality)
				end
			end
		else
			-- 按是否上阵排序
			return tonumber(a.isBattle) > tonumber(b.isBattle)
			-- return self:contains(data.formation,a) and true or false
		end
	end)
	return arr
end


function GarageModel:sortTankFragment()
	table.sort(self.tankFragmentList,function(a,b)
		return tonumber(a.quality) > tonumber(b.quality)
	end)
end

-- --[[--
-- --获取不在训练中的的坦克列表(顺序：星级（由低到高）＞等级（由低到高）)
-- --]]
-- function GarageModel:sortWithNoTraining()
-- 	local noTrainTanks = {}
-- 	local function __sortForTrain(arr)
-- 		table.sort(arr,function(a,b)
-- 			if tonumber(a.star) == tonumber(b.star) then
-- 				if tonumber(a.star) == tonumber(b.star) then
-- 					return false
-- 				else
-- 					-- 按等级排序
-- 					return tonumber(a.level) < tonumber(b.level)
-- 				end
-- 			else
-- 				-- 按星级排序
-- 				return tonumber(a.star) < tonumber(b.star)
-- 			end
-- 		end)
-- 		return arr
-- 	end

-- 	for i=1,#self.totalTanks do
-- 		if  self.totalTanks[i].is_train == 0 and not self.totalTanks[i]:getToBattle() then
-- 			if self.totalTanks[i].expedition_status == 0 then
-- 				--不在远征阵位上
-- 				if self.totalTanks[i].level > 1 or self.totalTanks[i].quality < 4 then
-- 					--一级的紫色和橙色坦克不在列表里
-- 					table.insert(noTrainTanks, self.totalTanks[i])
-- 				end
-- 			end
-- 		end
-- 	end
-- 	noTrainTanks = __sortForTrain(noTrainTanks)
-- 	return noTrainTanks
-- end

function GarageModel:contains(target,value)
	for i=1,6 do
		if value == target["p_"..i] then
			return true
		end
	end
	return false
end

function GarageModel:getIndexByUniqueID(uid)
	for i=1,#self.totalTanks do
		if self.totalTanks[i].unique_id == uid then
			return i
		end
	end
	return nil
end

function GarageModel:getEntityByUniqueID(uid)
	for i=1,#self.totalTanks do
		if tonumber(self.totalTanks[i].unique_id) == tonumber(uid) then
			return self.totalTanks[i]
		end
	end
	return nil
end


--更新实体数据
function GarageModel:updateEntityData(data)
	print("走了model")
	local entity = self:getEntityByUniqueID(data.unique_id)
	entity.unique_id = data.unique_id
	entity.kid_:set(data.kid)
	entity.tank_id = data.tank_id
	entity.name_:set(data.name)
	entity.type_:set(data.type)
	entity.level_:set(data.level)
	entity.exp_:set(data.exp)
	entity.star_:set(data.star)
	entity.quality_:set(data.quality)
	entity.position = data.position

	entity.basic_attack = data.attack
	entity.basic_defense = data.defense
	entity.basic_blood = data.blood
	entity.basic_crit_hurt = data.crit_hurt

	entity.wear = data.wear
	entity.anti_wear = data.anti_wear
	entity.talent_id = data.talent_id
	entity.common_skill_id = data.common_skill_id
	entity.compat_skill_id = data.compat_skill_id
	entity.morale = data.morale
	entity.is_train = data.is_train
	entity.train_pos = data.train_pos
	entity.equip = data.equip
    entity.reform_stage = data.reform_stage or 0 --坦克改造
    entity.promotion_stage = data.promotion_stage or 0
    print("GarageModel11",entity.promotion_stage)

end

--[[--
--根据服务器的数据，更新坦克列表(此方法仅是更新部分坦克, 且目前不重新排序)
--@param #table 服务器返回的坦克数据
--]]
function GarageModel:updateTankListBySerData(tankList)
	for key, var in pairs(tankList) do
		if self:getEntityByUniqueID(tankList[key].unique_id) then
			self:updateEntityData(tankList[key])
		else
			local entity = qy.tank.entity.TankEntity.new(tankList[key])
			table.insert(self.totalTanks,entity)
		end
	end
end

function GarageModel:addTank(data, isNew)
	if not self.totalTanks then
		self.totalTanks = {}
	end
	local entity = nil
	if type(data) == "number" or type(data) == "string" then
		-- 通过ID添加坦克
		entity = qy.tank.entity.TankEntity.new(data)
	elseif type(data) == "table" then
		if data.__type == "entity" then
			-- 通过entity添加坦克
			entity = data
		else
			-- 通过server data添加坦克
			entity = qy.tank.entity.TankEntity.new(data)
		end
	end
	entity:setToBattle(false)

	if isNew then
		entity:setNewStatus(isNew)
	end

	table.insert(self.totalTanks,entity)
	table.insert(self.unselectedTanks,entity)
end

function GarageModel:removeTank(data)
	if not self.totalTanks then
		self.totalTanks = {}
	end
	local index
	local unSelectedIndex
	local selectedIndex
	if type(data) == "number" or type(data) == "string" then
		index = self:getIndexByUniqueID(tonumber(data))
		unSelectedIndex = self:getUnselectIndexByUniqueID(tonumber(data))
		if unSelectedIndex < 0 then
			selectedIndex = self:getSelectIndexByUniqueID(tonumber(data))
		end
	elseif type(data) == "table" then
		if data.__type == "entity" then
			index = self:getIndexByUniqueID(data.unique_id)
			unSelectedIndex = self:getUnselectIndexByUniqueID(data.unique_id)
			if unSelectedIndex < 0 then
				selectedIndex = self:getSelectIndexByUniqueID(data.unique_id)
			end
		else
			index = self:getIndexByUniqueID(data.unique_id)
			unSelectedIndex = self:getUnselectIndexByUniqueID(data.unique_id)
			if unSelectedIndex < 0 then
				selectedIndex = self:getSelectIndexByUniqueID(data.unique_id)
			end
		end
	end

	if index > 0 then
		table.remove(self.totalTanks,index)
	end
	if unSelectedIndex > 0 then
		table.remove(self.unselectedTanks,unSelectedIndex)
	elseif selectedIndex > 0 then
		table.remove(self.selectedTanks,selectedIndex)
	end
end

function GarageModel:updateTank(data)
	if not self.totalTanks then
		self.totalTanks = {}
	end
	local entity
	if type(data) == "number" or type(data) == "string" then
		entity = qy.tank.entity.TankEntity.new(data)
	elseif type(data) == "table" then
		if data.__type == "entity" then
			entity = data
		else
			entity = qy.tank.entity.TankEntity.new(data)
		end
	end

	if self:getEntityByUniqueID(entity.unique_id) then
		self:updateEntityData(data)
	else
		table.insert(self.totalTanks,entity)
	end
end

--根据坦克ID获取训练位
function GarageModel:getTrainIdxByTankUid(tankUid)
	local entity = self:getEntityByUniqueID(tankUid)
	return entity.train_pos
end

--[[--
--根据坦克id,获取坦克icon
--]]
function GarageModel:getTankIconByTankId(tankId)
	return "tank/icon/icon_t"..tankId..".png"
end

--[[--
--根据坦克ID，获取坦克名字
--]]
function GarageModel:getTankNameByTankId(tankId)
	return qy.Config.tank[tankId .. ""].name
end

-- 获得总战斗力
function GarageModel:getTotalPower()
	local power = 0
	for i=1,#self.selectedTanks do
		local tank = self.selectedTanks[i]
		power = power + tank
	end
end

--[[--
--根据品质quality获取品质背景图路径
--@param #number quality:品质
--]]
function GarageModel:getQualityBgPath(quality)
	-- 白绿蓝紫橙
	-- if quality == 1 or quality == "1" then
	-- 	return "tank/bg/bg1.png"
	-- elseif quality == 2 or quality == "2" then
	-- 	return "tank/bg/bg2.png"
	-- elseif quality == 3 or quality == "3" then
	-- 	return "tank/bg/bg3.png"
	-- elseif quality == 4 or quality == "4" then
	-- 	return "tank/bg/bg4.png"
	-- elseif quality == 5 or quality == "5" then
	-- 	return "tank/bg/bg5.png"
	-- end
	return "tank/bg/bg"..tostring(quality)..".png"
end

function GarageModel:getTalentMap()
	return {qy.TextUtil:substitute(14021),qy.TextUtil:substitute(14022),qy.TextUtil:substitute(14023),qy.TextUtil:substitute(14024),qy.TextUtil:substitute(14025),qy.TextUtil:substitute(14026),qy.TextUtil:substitute(14027)}
end

function GarageModel:reset()
end

function GarageModel:hasRedDotOnTankIcon(uid)
	local model = qy.tank.model.RedDotModel
	if model:isGarageLoadHasRedDot(uid) then
		return true
	else
		local flagData = model:isGarageEquipHasRedDot(uid)
		for i = 1, 4 do
			if flagData[i] == true then
				return true
			end
		end
		return false
	end
end

function GarageModel:getUnlockLevelByIndex(_index)
	if _index == 1 then
		return 1
	elseif _index == 2 then
		return 1
	elseif _index == 3 then
		return 3
	elseif _index == 4 then
		return 6
	elseif _index == 5 then
		return 10
	elseif _index == 6 then
		return 15
	end

	return 0
end

-- 分解的坦克删除
function GarageModel:removeResolveList(data)
	for i, v in pairs(data) do
        self:removeTank(v)
    end
end

--通过 tank_id 获取 little_icon
--(写在 model 里是因为在军团战中，坦克数量太多且只需要获取坦克的little_icon,不需要new entity)
function GarageModel:getLittleIconByTankId(tank_id)
    local icon = qy.Config.tank[tostring(tank_id)].icon
    return "tank/little_icon/"..icon..".png"
end



function GarageModel:addTankFragment(data)
	local flag = true
	if data then
		for i = 1, #self.tankFragmentList do
			if self.tankFragmentList[i].tank_id == data.id and self.tankFragmentList[i].is_tank_fragment == 1 then
				self.tankFragmentList[i].num = self.tankFragmentList[i].num + data.num

				if self.tankFragmentList[i].num % qy.tank.model.GarageModel.tank_fragment_merge[self.tankFragmentList[i].quality] == 0 then
					table.remove(self.tankFragmentList, i)
				end
				flag = false
			end
		end

		if flag then
			local entity = qy.tank.entity.TankEntity.new(data)
			entity.is_tank_fragment = 1
			entity.num = data.num
			table.insert(self.tankFragmentList,entity)
		end
	end
end
--鼠式晋升
function GarageModel:TiaoJian(id)
	
end

function GarageModel:init2(data)
	print("333---111",json.encode(data))
	self.JinSheng = data
end

function GarageModel:GetJinSheng( )	
	return self.JinSheng
end

function GarageModel:GetTypeId(id,select_tank_id)
	self.config8 = qy.Config.tank_promotion

	self.config9 = qy.Config.tank_promotion_type

	print("GarageModel000111",self.select_tank_id)

	local idx = self.config8[tostring(self.select_tank_id)]["type_"..id]
	if idx ~= nil then
		if #idx == 1 then
			return self.config9[tostring(idx[1].id)]
		elseif #idx ==2 then
			return self.config9[tostring(idx[1].id)],self.config9[tostring(idx[2].id)]
		end
	end
end
function GarageModel:GetTankPromotion(id,select_tank_id)
	-- print("777==000",json.encode(self.config3[tostring(79)]["consume_"..id]))
	return self.config3[tostring(self.select_tank_id)]["consume_"..id]
end

function GarageModel:Addx(  )
	self.JinSheng.tank_list.promotion_stage = self.JinSheng.tank_list.promotion_stage + 1
end
--self.model:GetJinSheng().tank_list.promotion_stage
function GarageModel:totalAttr(idx,id)
	print("GarageModel22",idx)
	if idx then
		if id == 1 then
			return self:getNum(idx,"attack")--全部攻击力
		elseif id == 2 then
			return self:getNum(idx,"defense")--全部防御
		elseif id == 3 then
			return self:getNum(idx,"blood")--血
		elseif id == 4 then
			return self:getNum(idx,"wear")
		elseif id == 5 then
			return self:getNum(idx,"anti_wear")
		elseif id == 6 then
			return self:getNum(idx,"hit_plus")
		elseif id == 7 then
			return self:getNum(idx,"doge_rate")
		elseif id == 8 then
			return self:getNum(idx,"crit_rate")
		elseif id == 11 then
			return self:getNum(idx,"crit_hurt")
		elseif id == 15 then
			return self:getNum(idx,"anti_disarm_ratio")
		else
			return 0
		end
	else
		if idx == 0 then
			return 0
		end
	end
	--local idx = self.JinSheng.tank_list.promotion_stage
end

function GarageModel:getNum(idx,type1,select_tank_id)--当前的位置x 总和
	 --local a,b = self.model:GetTypeId(idx)
	local attacknum = 0
 	for i=1,tonumber(idx) do
 		local j,k = self:GetTypeId(i,self.select_tank_id)
 		if k ~= nil then
	 		if j.type_str == tostring(type1)  then
	 			if k.type_str == tostring(type1) then
	 				attacknum = attacknum + j.param + k.param
	 			else
	 				attacknum = attacknum +j.param
	 			end
	 		else
	 			if k.type_str == tostring(type1) then
	 				attacknum = attacknum  + k.param
	 			else
	 				attacknum = attacknum 
	 			end
	 		end
 		else
 			if j.type_str == tostring(type1)  then	 			
	 			attacknum = attacknum + j.param
	 		else	 			
	 			attacknum = attacknum 
	 		end
 		end
 	end
 	print("GarageModeltype",type1)
 	print("GarageModel33",attacknum)
 	return attacknum
end

function GarageModel:gettext(idx,select_tank_id)--点击按钮的位置
	local a,b = self:GetTypeId(idx,self.select_tank_id)
	if b ~= nil then
		return a.type_str,b.type_str
	else
		return a.type_str
	end
end

function GarageModel:gettext2(idx,select_tank_id)--点击按钮的位置
	local a,b = self:gettext(idx,self.select_tank_id)
	if b ~=nil then
		return self:getNum(idx,a),self:getNum(idx,b)
	else
		return self:getNum(idx,a)
	end
end

function GarageModel:updateziyuan(idx)--点击的下标
	local award = self:GetTankPromotion(idx)
	local propsd = self:GetJinSheng().props
		propsd[tostring(award[2].id)].num = propsd[tostring(award[2].id)].num - tonumber(award[2].num)
end

function GarageModel:set_tankd_id(id)
	self.select_tank_id = id or 0
	print("GarageModel00==00",self.select_tank_id)
end

-- AdvanceModel.attrTypes = {
-- 	["1"] = "attack",--攻击力
-- 	["2"] = "defense",--防御力
-- 	["3"] = "blood",--生命值
-- 	["4"] = "wear",--穿深
-- 	["5"] = "anti_wear",--穿深抵抗
-- 	["6"] = "hit",--命中
-- 	["7"] = "dodge",--闪避
-- 	["8"] = "crit_hurt",--暴击率
-- 	["9"] = "",--升星
-- 	["10"] = "",--初始士气
-- 	["11"] = "",--暴击伤害
-- 	["12"] = "",--攻击百分比
-- 	["13"] = "",--防御百分比
-- 	["14"] = "",--生命百分比
-- 	["15"] = "",--抗缴械
-- 	["16"] = qy.TextUtil:substitute(3023),
-- 	["17"] = qy.TextUtil:substitute(3023),
-- 	["18"] = qy.TextUtil:substitute(3023),
-- 	["19"] = qy.TextUtil:substitute(3023),
-- 	["20"] = qy.TextUtil:substitute(3023),
-- }
return GarageModel
