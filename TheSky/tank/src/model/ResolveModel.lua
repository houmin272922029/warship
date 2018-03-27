--[[
    分解 model
    Author: mingming
    Date: 2015-09-10
]]

local ResolveModel = class("ResolveModel", qy.tank.model.BaseModel)

--初始化
function ResolveModel:init(callback)
	self.unResolveList = qy.tank.model.AchievementModel:getUnResolveList() -- 所有已达成成就坦克

	self.totalTank = qy.tank.model.GarageModel.totalTanks
	self.achievementList = qy.tank.model.AchievementModel:getAchievementTankList() -- 所有成就包含的坦克
	self.upTankList = qy.tank.model.GarageModel.selectedTanks

	self.selectList = {}
	self.rewardList = {}

	self.unselectedTanks_ = qy.tank.model.GarageModel.unselectedTanks -- 所有未上阵坦克
	self.unselectedTanks  = self:getEnableTanks()
	self.unselectEquip = qy.tank.model.EquipModel:getFreeList()
	--  过滤已达成就的坦克
	-- if qy.tank.model.UserInfoModel.userInfoEntity.level >= 60 then
	-- 	self:getCanResolve()
	-- end
	self.vipconfig = qy.Config.vip_privilege
	callback()
end

function ResolveModel:update()
	self.unselectedTanks_ = qy.tank.model.GarageModel.unselectedTanks -- 所有未上阵坦克
	self.unselectedTanks  = self:getEnableTanks()
	self.unselectEquip = qy.tank.model.EquipModel:getFreeList()
	--  过滤已达成就的坦克
	-- if qy.tank.model.UserInfoModel.userInfoEntity.level >= 60 then
	-- 	self:getCanResolve()
	-- end
	-- self.unResolveList = qy.tank.model.AchievementModel:getUnResolveList()
	-- self.unselectedTanks = clone(qy.tank.model.GarageModel.unselectedTanks_)
end

-- 获取状态码，是否可以分解，以及对应的提示
--  1. 可以分解,（3, 5, 6） 2. <60 提示分解, 3. >60 唯一 未达成成就，但在成就中会用到  提示分解
--	4. >60 唯一 已达成成就(已排除) 5. 不唯一 6. 唯一 但不在成就中用到  10. 已经选中
function ResolveModel:testResolve(entity)
	if self:testSelect(entity.unique_id) then
		return 10
	end

	local tank_id = entity.tank_id
	if qy.tank.model.UserInfoModel.userInfoEntity.level >= 60 then
		if (self:testUnique(tank_id) and table.keyof(self.achievementList, tank_id)) and not table.keyof(self.unResolveList, tank_id) then
			return 3
		elseif self:testUnique(tank_id) and table.keyof(self.unResolveList, tank_id) then
			return 4
		else
			return 1
		end
	else
		if self:testUnique(tank_id) and table.keyof(self.achievementList, tank_id) then
			return 2
		else
			return 1
		end
	end
end

-- 判断表内相同坦克是否唯一
function ResolveModel:testUnique(tank_id)
	local idx = 0
	for i, v in pairs(self.totalTank) do
		if tonumber(v.tank_id) == tonumber(tank_id) then
			idx = idx + 1
		end
	end
	return idx <= 1
end


--[[
--根据品质获得分解后获得的陶瓷装甲数量
--]]
function ResolveModel:getEquipReformNumByQuality(quality)
	local equipCfg = qy.Config.equip_quality_exp
	return equipCfg[tostring(quality)].exp
end




-- 可分解的列表
function ResolveModel:getCanResolve()
	for i, v in pairs(self.unResolveList) do
		for k, j in pairs(self.unselectedTanks) do
			if (j.tank_id == v and not self:testAtSelect(j.tank_id)) and (self:testUnique(j.tank_id) and j.level == 1) then
				table.remove(self.unselectedTanks, k)
			end
		end
		-- if table.keyof(self.unselectedTanks, v) self.unselectedTanks[tostring(v)] then
		-- 	self.unselectedTanks[tostring(v)] = nil
		-- end
	end

	-- self.unselectedTanks_ = self.unselectedTanks
	-- self.unselectedTanks_ = table.values(self.unselectedTanks)
	-- table.sort(self.unselectedTanks_, function(a, b)
	-- 	return a.quality < b.quality
	-- end)
end

-- 此坦克是否有同类型坦克上阵
function ResolveModel:testAtSelect(tank_id)
	for i, v in pairs(self.upTankList) do
		if v.tank_id == tank_id then
			return true
		end
	end
	return false
end

-- 过滤品质底的tank
function ResolveModel:getEnableTanks()
	local temp = {}
	for i, v in pairs(self.unselectedTanks_) do
		if v.is_train == 0 and v.expedition_status == 0 then
		-- if (v.quality > 3 and v.is_train == 0) and v.expedition_status == 0 then
			table.insert(temp, v)
		end
	end
	return temp
end

-- 列表
function ResolveModel:getList(idx)
	return idx == 1 and self.unselectedTanks or self.unselectEquip
end

--
function ResolveModel:atTank(idx, ttype)
	return ttype == 1 and self.unselectedTanks[idx + 1] or self.unselectEquip[idx + 1]
end

function ResolveModel:atEquip(idx)

end

-- 选中列表
function ResolveModel:select(entity)
	if not self.selectList[tostring(entity.unique_id)] then
		self.selectList[tostring(entity.unique_id)] = entity
	else
		self.selectList[tostring(entity.unique_id)] = nil
	end
end

-- 一键选中
function ResolveModel:selectAll(idx)
	local data = self:getList(idx)
	for i, v in pairs(data) do
		local quality = tonumber(idx) == 1 and v.quality or v:getQuality()
		if quality <=3 then
			self.selectList[tostring(v.unique_id)] = v
		end
	end
end

-- 鼠式分批选中
function ResolveModel:selectAll1(idx,list)
	local data = self:getList(idx)
	print("666---111",#list)
	print("666---111",list[1])
	print("666---111",list[2])
	print("777---111",data)
	for k,v in pairs(data) do
		print(k,v)
	end
	for a = 1,#list do
		for i, v in pairs(data) do
			local quality = tonumber(idx) == 1 and v.quality or v:getQuality()
			if quality == list[a] then
				self.selectList[tostring(v.unique_id)] = v
			end
		end
	end
	
	print("888---111",self.selectList)
	for k,v in pairs(self.selectList) do
		print(k,v)
	end
end

function ResolveModel:GetVip(id)
	local list = {}
	for i=1,id do
		if self.vipconfig[tostring(i)].type_2 == 27 then
			table.insert(list,self.vipconfig[tostring(i)].param_2)
		end
	end


	return list
end

-- 清空选中列表
function ResolveModel:clearSelectList()
	self.selectList = {}
end

-- 测试是否已被选中
function ResolveModel:testSelect(entity)
	local id = type(entity) == "table" and entity.unique_id or entity
	return self.selectList[tostring(id)] and true or false
end

-- 获取奖励列表
function ResolveModel:getRewardData(idx)
	self.rewardList = {}
	for i, v in pairs(self.selectList) do
		if idx == 1 then
			-- if not (self:testUnique(v.tank_id) and table.keyof(self.unResolveList, v.tank_id)) then -- 只要不是 testResolve 方法中 4状态
				for j = 1, 10 do
					local _type = v["currency_type"..(j == 1 and "" or tostring(j))] 
					local _num = v["currency_num"..(j == 1 and "" or tostring(j))] 

					if type(_type) ~= "number" or type(_num) ~= "number" then
						break
					end

					if _type ~= 0 then
						if not self.rewardList[tostring(_type)] then
							self.rewardList[tostring(_type)] = qy.tank.view.common.AwardItem.getItemData({["type"] = _type, ["num"] = _num})
						else
							self.rewardList[tostring(_type)].num = self.rewardList[tostring(_type)].num + _num
						end
					end

				end
			-- end
			local totalExp = 0
			local tank_level_config = qy.Config.tank_level
			local tank_reform_config = qy.Config.tank_reform
			local reform_level = 0
			for i = 1, v.reform_stage do
				reform_level = tank_reform_config[tostring(i)].level
				totalExp = totalExp + tank_level_config[tostring(reform_level)].exp_all
			end
			totalExp = tank_level_config[tostring(v.level)].exp_all + v.exp + totalExp

			local expNum = math.floor(totalExp / 1000)
			if not self.rewardList["4"] then
				self.rewardList["4"] = qy.tank.view.common.AwardItem.getItemData({["type"] = 4, ["num"] = expNum})
			else
				self.rewardList["4"].num = self.rewardList["4"].num + expNum
			end

			if not self.rewardList["20"] then
				self.rewardList["20"] = qy.tank.view.common.AwardItem.getItemData({["type"] = 20, ["num"] = v:getAdvanceSourceNum().advance_material})
			else
				self.rewardList["20"].num = self.rewardList["20"].num + v:getAdvanceSourceNum().advance_material
			end

			if not self.rewardList["7"] then
				self.rewardList["7"] = qy.tank.view.common.AwardItem.getItemData({["type"] = 7, ["num"] = v:getAdvanceSourceNum().purple_iron})
			else
				self.rewardList["7"].num = self.rewardList["7"].num + v:getAdvanceSourceNum().purple_iron
			end

			if not self.rewardList["8"] then
				self.rewardList["8"] = qy.tank.view.common.AwardItem.getItemData({["type"] = 8, ["num"] = v:getAdvanceSourceNum().orange_iron})
			else
				self.rewardList["8"].num = self.rewardList["8"].num + v:getAdvanceSourceNum().orange_iron
			end

			if not self.rewardList["28"] then
				self.rewardList["28"] = qy.tank.view.common.AwardItem.getItemData({["type"] = 28, ["num"] = v:getAdvanceSourceNum().reputation})
			else
				self.rewardList["28"].num = self.rewardList["28"].num + v:getAdvanceSourceNum().reputation
			end

			-- if not self.rewardList["3"] then
			-- 	self.rewardList["3"] = qy.tank.view.common.AwardItem.getItemData({["type"] = 3, ["num"] = num})
			-- else
			-- 	self.rewardList["3"].num = self.rewardList["3"].num + num
			-- end
		elseif idx == 2 then
			local num = 0
			-- if v:getQuality() >= 3 then
			-- 	num = v.silver
			-- else
			-- 	num = v.silver + v.price
			-- end
			num = v.silver + v.price + v.reform_silver
			if not self.rewardList["3"] then
				self.rewardList["3"] = qy.tank.view.common.AwardItem.getItemData({["type"] = 3, ["num"] = num})
			else
				self.rewardList["3"].num = self.rewardList["3"].num + num
			end


			num = v.reform_essence + self:getEquipReformNumByQuality(v:getQuality())
			if num > 0 then
				if not self.rewardList["37"] then
					self.rewardList["37"] = qy.tank.view.common.AwardItem.getItemData({["type"] = 37, ["num"] = num})
				else
					self.rewardList["37"].num = self.rewardList["37"].num + num
				end
			end

			num = v.advanced_purple_iron
			if num > 0 then
				if not self.rewardList["7"] then
					self.rewardList["7"] = qy.tank.view.common.AwardItem.getItemData({["type"] = 7, ["num"] = num})
				else
					self.rewardList["7"].num = self.rewardList["7"].num + num
				end
			end
			local quality = v:getQuality()
			local levels = v.advanced_level
			if quality > 5 then
				local nums = 2 --* (levels + 1)
				if not self.rewardList["50"] then
					self.rewardList["50"] = qy.tank.view.common.AwardItem.getItemData({["type"] = 50, ["num"] = nums})
				else
					self.rewardList["50"].num = self.rewardList["50"].num + nums
				end
				local nums = 1 --* (levels + 1)
				if not self.rewardList["51"] then
					self.rewardList["51"] = qy.tank.view.common.AwardItem.getItemData({["type"] = 51, ["num"] = nums})
				else
					self.rewardList["51"].num = self.rewardList["51"].num + nums
				end
			end
		end
	end

	if self.rewardList["4"] and self.rewardList["4"].num == 0 then
		self.rewardList["4"] = nil
	end

	if self.rewardList["20"] and self.rewardList["20"].num == 0 then
		self.rewardList["20"] = nil
	end

	if self.rewardList["7"] and self.rewardList["7"].num == 0 then
		self.rewardList["7"] = nil
	end

	if self.rewardList["8"] and self.rewardList["8"].num == 0 then
		self.rewardList["8"] = nil
	end

	if self.rewardList["28"] and self.rewardList["28"].num == 0 then
		self.rewardList["28"] = nil
	end

	local temp = table.values(self.rewardList)
	return temp
end

-- 获取分解参数
function ResolveModel:getSelectParams(idx)
	self.removeList = {}
	local str = ""
	for i, v in pairs(self.selectList) do
		if idx == 2 then
			local type = v:getType()
			str = str .. type .. "-" .. v.unique_id .. ","
		else
			str = str .. v.unique_id .. ","
		end
		table.insert(self.removeList, v.unique_id)
	end

	return str
end

-- 删除已被分解的坦克/装备
function ResolveModel:removeResolveList(data, ttype)
	for i, v in pairs(data) do
		if ttype == 1 then
			local idx = self:getTankByUniqueID(v.unique_id)
			table.remove(self.unselectedTanks, idx)
		else
			local unique = type(v) == "table" and v.uniqueId or v
			local idx = self:getEquipByUniqueID(unique)

			table.remove(self.unselectEquip, idx)
		end
	end
	self:clearSelectList()
end

function ResolveModel:getTankByUniqueID(uid)
	for i, v in pairs(self.unselectedTanks) do
		if v.unique_id == uid then
			return i
		end
	end
end

function ResolveModel:getEquipByUniqueID(uid)
	for i, v in pairs(self.unselectEquip) do
		if v.unique_id == uid then
			return i
		end
	end
end

function ResolveModel:testOpen()
	local userLevel = qy.tank.model.UserInfoModel.userInfoEntity.level
    local needAchievementLevel = qy.Config.function_open["21"].open_level
    return userLevel >= needAchievementLevel
end

--分解获得基础值
function ResolveModel:getJiChu()
	self.ewardList = {}
	for k,v in pairs(self.selectList) do
		for j = 1, 10 do
			 _type = v["currency_type"..(j == 1 and "" or tostring(j))] 
			 _num = v["currency_num"..(j == 1 and "" or tostring(j))] 

			if type(_type) ~= "number" or type(_num) ~= "number" then
				break
			end

			if _type ~= 0 then
				if not self.ewardList[tostring(_type)] then
					self.ewardList[tostring(_type)] = qy.tank.view.common.AwardItem.getItemData({["type"] = _type, ["num"] = _num})
				else
					self.ewardList[tostring(_type)].num = self.ewardList[tostring(_type)].num + _num
				end
			end
		end
	end

	return self.ewardList
	
end

return ResolveModel
