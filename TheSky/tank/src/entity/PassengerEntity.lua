--[[
	乘员系统
    Date: 2016-07-11
]]

local PassengerEntity = qy.class("PassengerEntity", qy.tank.entity.BaseEntity)

local model = qy.tank.model.PassengerModel
function PassengerEntity:ctor(data, staticData)
	local cfg = qy.Config.passenger

	if data then
		self:setproperty("passenger_id", data.pass_id or staticData.id)
		self:setproperty("unique_id", data.unique_id)
		self:setproperty("level", data.level or 1)
		self:setproperty("tank_unique_id", data.tank_unique_id)
		self:setproperty("pos", data.pos)
		self:setproperty("num", data.num)
		self:setproperty("exp", data.exp)
		self:setproperty("isjoin", data.isjoin)
		self:setproperty("iscomplete", data.iscomplete)
		self:setproperty("type", data.iscomplete == 100 and 25 or 26)
		self:setproperty("study_level", data.study_level or 1)
		self:setproperty("study_exp", data.study_exp or 0)
	else
		self:setproperty("passenger_id", staticData.pass_id)
	end


	self:setproperty("name", staticData.name or cfg[self.passenger_id..""].name)
	self:setproperty("quality", staticData.quality or cfg[self.passenger_id..""].quality)
	self:setproperty("atk", staticData.attack or cfg[self.passenger_id..""].attack)
	self:setproperty("def", staticData.defense or cfg[self.passenger_id..""].defense)
	self:setproperty("hp", staticData.blood or cfg[self.passenger_id..""].blood)
	self:setproperty("passengerType", staticData.type or cfg[self.passenger_id..""].type)
	

	
	-- local levelData = qy.Config.soul_max_level
	-- self:setproperty("maxLevel", levelData[tostring(self.quality)].max_level)
	-- self:setproperty("type", 22)
end

function PassengerEntity:update(data)
	if data.exp then
		self.exp = data.exp 
	end

	if data.atk then
		self.atk = data.atk 
	end

	if data.def then
		self.def = data.def 
	end

	if data.hp then
		self.hp = data.hp 
	end

	if data.pos then
		self.pos = data.pos 
	end

	if data.level then
		self.level = data.level
	end
	if data.study_exp then
		self.study_exp = data.study_exp
	end

	if data.tank_unique_id then
		self.tank_unique_id = data.tank_unique_id
	end
end

function PassengerEntity:getAttr1()
	local staicData = qy.Config.passenger
	local data = {}
	local passData = staicData[tostring(self.passenger_id)]
	local nums = (self.study_exp/1000) + 1
	data.atk = math.floor(passData.attack * (self.level + 1)^1.5 * nums)
	data.def = math.floor(passData.defense * (self.level+1)^1.5 * nums)
	data.hp = math.floor(passData.blood * (self.level+1)^1.5 * nums)
	return data
end

function PassengerEntity:getAttr()
	local staicData = qy.Config.passenger_level
	local data = {}

	data.name = model.typeNameList[tostring(self.passengerType)]
	data.num = staicData[tostring(self.level)][tostring(model.typeList[tostring(self.passengerType)])]
	data.soulNum = staicData[tostring(self.level)].fragment_num
	return data
end

return PassengerEntity