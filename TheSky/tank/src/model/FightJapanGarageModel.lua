--[[
	车库数据
	Author: lianyi
	Date:复制与  2015-06-11 15:45:32
]]

local FightJapanGarageModel = qy.class("FightJapanGarageModel", qy.tank.model.BaseModel)

function FightJapanGarageModel:init(data)
    self.data = data
    self.totalTanks = qy.tank.model.GarageModel.totalTanks
	-- self:updateTankList(data)
	self:updateFormation(data)
	self.totalMorale = data.total_morale
end

-- function FightJapanGarageModel:updateTankList(data)
-- --	self.data = data
-- 	self.totalTanks = {}
-- 	if data and data.tank then
-- 		for i=1,#data.tank do
-- 			local entity = qy.tank.entity.TankEntity.new(data.tank[i])
-- 			table.insert(self.totalTanks,entity)
-- 		end
-- 	end
-- 	self.totalTanks = self:sort(self.totalTanks)
-- end

function FightJapanGarageModel:updateFormation(data)
	self.selectedTanks = {}
	self.unselectedTanks = {}
	self.formation = {}
	self.data.formation = data.formation
	if data and data.formation then
		for i=1,#self.totalTanks do
			local entity = self.totalTanks[i]
			if self:contains(data.formation,entity.unique_id) then
				entity.expedition_status = 1
				table.insert(self.selectedTanks,entity)
			else
				entity.expedition_status = 0
				table.insert(self.unselectedTanks,entity)
			end
		end
		self.selectedTanks = self:sort(self.selectedTanks)
		self.unselectedTanks = self:sort(self.unselectedTanks)

		for i=1,6 do
			if data.formation["p_"..i] == -1 then
				table.insert(self.formation,-1)
			elseif data.formation["p_"..i] == 0 then
				table.insert(self.formation,0)
			else
				table.insert(self.formation,self:getEntityByUniqueID(data.formation["p_"..i]))
			end
		end
		self.formationClone = clone(self.formation)
	end
end

function FightJapanGarageModel:sort(arr)
	table.sort(arr,function(a,b)
		if self:contains(self.data.formation,a) == self:contains(self.data.formation,b) then
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
		else
			-- 按是否上阵排序
			return self:contains(data.formation,a) and true or false
		end
	end)
	return arr
end

function FightJapanGarageModel:contains(target,value)
	for i=1,6 do
		if value == target["p_"..i] then
			return true
		end
	end
	return false
end

function FightJapanGarageModel:getIndexByUniqueID(uid)
	for i=1,#self.totalTanks do
		if self.totalTanks[i].unique_id == uid then
			return i
		end
	end
	return nil
end

function FightJapanGarageModel:getEntityByUniqueID(uid)

	for i=1,#self.totalTanks do
		if self.totalTanks[i].unique_id == uid then
			return self.totalTanks[i]
		end
	end
	return nil
end


-- 更新实体数据
function FightJapanGarageModel:updateEntityData(data)
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
end

-- [[--
-- 根据服务器的数据，更新坦克列表(此方法仅是更新部分坦克, 且目前不重新排序)
-- @param #table 服务器返回的坦克数据
-- ]]
function FightJapanGarageModel:updateTankListBySerData(tankList)
	for key, var in pairs(tankList) do
		if self:getEntityByUniqueID(tankList[key].unique_id) then
			self:updateEntityData(tankList[key])
		else
			local entity = qy.tank.entity.TankEntity.new(tankList[key])
			table.insert(self.totalTanks,entity)
		end
	end
end

function FightJapanGarageModel:addTank(data)
	if not self.totalTanks then
		self.totalTanks = {}
	end

	if type(data) == "number" or type(data) == "string" then
		-- 通过ID添加坦克
		local entity = qy.tank.entity.TankEntity.new(data)
	elseif type(data) == "table" then
		if data.__type == "entity" then
			-- 通过entity添加坦克
			local entity = data
		else
			-- 通过server data添加坦克
			local entity = qy.tank.entity.TankEntity.new(data)
		end
	end
	table.insert(self.totalTanks,entity)
end

function FightJapanGarageModel:removeTank(data)
	if not self.totalTanks then
		self.totalTanks = {}
	end
	local index
	if type(data) == "number" or type(data) == "string" then
		index = self:getIndexByUniqueID(tonumber(data))
	elseif type(data) == "table" then
		if data.__type == "entity" then
			index = self:getIndexByUniqueID(data.unique_id)
		else
			index = self:getIndexByUniqueID(data.unique_id)
		end
	end

	if index > 0 then
		table.remove(self.totalTanks,index)
	end
end

function FightJapanGarageModel:updateTank(data)
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
function FightJapanGarageModel:getTrainIdxByTankUid(tankUid)
	local entity = self:getEntityByUniqueID(tankUid)
	return entity.train_pos
end

--[[--
--根据坦克id,获取坦克icon
--]]
function FightJapanGarageModel:getTankIconByTankId(tankId)
	return "tank/icon/icon_t"..tankId..".png"
end

--[[--
--根据坦克ID，获取坦克名字
--]]
function FightJapanGarageModel:getTankNameByTankId(tankId)
	return qy.Config.tank[tankId .. ""].name
end

-- 获得总战斗力
function FightJapanGarageModel:getTotalPower()
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
function FightJapanGarageModel:getQualityBgPath(quality)
	-- 白绿蓝紫橙
	if quality == 1 or quality == "1" then
		return "tank/bg/bg1.png"
	elseif quality == 2 or quality == "2" then
		return "tank/bg/bg2.png"
	elseif quality == 3 or quality == "3" then
		return "tank/bg/bg3.png"
	elseif quality == 4 or quality == "4" then
		return "tank/bg/bg4.png"
	elseif quality == 5 or quality == "5" then
		return "tank/bg/bg5.png"
	end
end

function FightJapanGarageModel:reset()
end

--[[--
--远征坦克数据
--]]
function FightJapanGarageModel:updateExTankData(data)
	self.expeTankData = data
end

-- 通过tank唯一ID获取tank扩展数据。
-- 如果返回为nil则代表没有扩展数据。
-- 没有扩展数据意味着tank的血量和士气都是初始状态
function FightJapanGarageModel:getTankExtendDataByTankUId(uid)
	for _k,_v in pairs(self.expeTankData) do
		if tonumber(_k) == tonumber(uid) then
			return self.expeTankData[_k]
		end
	end
	return nil
end

function FightJapanGarageModel:getTotalMorale()
	return self.totalMorale
end

return FightJapanGarageModel
