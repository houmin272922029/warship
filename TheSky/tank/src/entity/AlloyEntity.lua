--[[
    合金
    Author: H.X.Sun
]]

local AlloyEntity = qy.class("AlloyEntity", qy.tank.entity.BaseEntity)

local AlloyModel = qy.tank.model.AlloyModel
local AwardType = qy.tank.view.type.AwardType

function AlloyEntity:ctor(data)
	if data.unique_id then
		self:__initByServer(data)
	else
		self:__initByAward(data)
	end
end

function AlloyEntity:__initByServer(data)
	self:setproperty("level", data.level)
	self:setproperty("pos", data.pos)
	self:setproperty("exp", data.exp)
	self:setproperty("alloy_id", data.alloy_id)
	self:setproperty("unique_id", data.unique_id)
	self:setproperty("equip_unique_id", data.equip_unique_id)
end

function AlloyEntity:__initByAward(data)
	self:setproperty("level", data.id)
	self:setproperty("pos", "")
	self:setproperty("exp", 0)
	self:setproperty("unique_id", 0)
	self:setproperty("equip_unique_id", 0)
	local alloy_id = 1
	if AwardType.ALLOY_1 == data.type then
		alloy_id = AlloyModel.ALLOY_ID_1
	elseif AwardType.ALLOY_2 == data.type then
		alloy_id = AlloyModel.ALLOY_ID_2
	else
		alloy_id = AlloyModel.ALLOY_ID_3
	end

	self:setproperty("alloy_id", alloy_id)
end

function AlloyEntity:update(data)
	if data.level then
		self.level = data.level
	end
	if data.pos then
		self.pos = data.pos
	end
	if data.exp then
		self.exp = data.exp
	end
	-- if data.alloy_id then
	-- 	self.alloy_id = data.alloy_id
	-- end
	-- if data.unique_id then
	-- 	self.unique_id = data.unique_id
	-- end
	if data.equip_unique_id then
		self.equip_unique_id = data.equip_unique_id
	end
end

function AlloyEntity:getColor()
	local _level = tonumber(self.level)
	return AlloyModel:getColorByLevel(_level)
end

function AlloyEntity:getUpExpPercent()
	if self.level == AlloyModel.MAX_Level then
		return 100
	end
	if self.exp == 0 then
		return 0
	end

	local data = qy.Config.alloy_level
	return self.exp / tonumber(data[self.level .. ""]["exp"]) * 100
	-- for _k, _v in pairs(data) do
	-- 	if _v["level"] == self.level then
	-- 		return self.exp / tonumber(_v["exp"]) * 100
	-- 	end
	-- end

	-- return 100
end

function AlloyEntity:getTotoalExp()
	local data = qy.Config.alloy_level
	-- for _k, _v in pairs(data) do
	-- 	if _v["level"] == self.level then
	-- 		return _v["total_exp"] + self.exp
	-- 	end
	-- end

	return data[self.level .. ""]["total_exp"] + self.exp
end

function AlloyEntity:getName()
	return qy.TextUtil:substitute(41004, self.level) .. self:getAttributeName().. qy.TextUtil:substitute(41005)
end

function AlloyEntity:getAttributeDesc()
	return self:getAttributeName() .. "+" .. self:getAttribute()
end

function AlloyEntity:getNextLevelAttriDesc()
	return self:getAttributeName() .. "+" .. self:getAttribute(self.level+1)
end

function AlloyEntity:getAttribute(_level)
	if _level == nil then
		_level = self.level
	end
	local data = qy.Config.alloy
	local _str = self.alloy_id .. "_" .. _level
	for _k, _v in pairs(data) do
		if _v["alloy_id_level"] == _str then
			return _v["plus"]
		end
	end

	return 0
end


function AlloyEntity:getAttributeName()
	return AlloyModel:getAttributeNameByAlloyId(self.alloy_id)
end

function AlloyEntity:getIcon()
	local _url = "equip/alloy/alloy_"
	if self.alloy_id == AlloyModel.ALLOY_ID_1 then
		--攻击
		_url = _url .. "attack_"
	elseif self.alloy_id == AlloyModel.ALLOY_ID_2 then
		--防御
		_url = _url .. "defense_"
	else
		--血量
		_url = _url .. "blood_"
	end

	local _level = tonumber(self.level)
	if _level < 4 then
		--1~3 
		_url = _url .. "1"
	elseif _level >= 4 and _level < 7 then
		--4~6
		_url = _url .. "2"
	else
		--7~10
		_url = _url .. "3"
	end

	return _url .. ".png"
end

return AlloyEntity