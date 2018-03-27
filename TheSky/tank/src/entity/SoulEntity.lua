--[[
    军魂
    Author: mingming
    Date: 2015-05-11
]]

local SoulEntity = qy.class("SoulEntity", qy.tank.entity.BaseEntity)

local model = qy.tank.model.SoulModel
function SoulEntity:ctor(data, staticData)
	self:setproperty("soul_id", data.soul_id or staticData.soul_id)
	self:setproperty("unique_id", data.unique_id)
	self:setproperty("level", data.level or 1)
	self:setproperty("tank_unique_id", data.tank_unique_id)
	self:setproperty("pos", data.pos)
	self:setproperty("name", staticData.name)
	self:setproperty("quality", staticData.quality)
	self:setproperty("soulType", staticData.type)
	self:setproperty("type", 22)

	local levelData = qy.Config.soul_max_level
	self:setproperty("maxLevel", levelData[tostring(self.quality)].max_level)

	if data.deputy_attr then
		self:setproperty("deputy_attr", data.deputy_attr)
	else
		self:setproperty("deputy_attr", {})
	end
	-- self:setproperty("type", 22)
end

function SoulEntity:update(data)
	if data.pos then
		self.pos = data.pos 
	end

	if data.level then
		self.level = data.level
	end

	if data.tank_unique_id then
		self.tank_unique_id = data.tank_unique_id
	end
end

function SoulEntity:getAttr1()
	local staicData = qy.Config.soul_level
	local data = {}

	data.name = model.typeNameList[tostring(self.soulType)]
	data.num = staicData[tostring(self.level)][tostring(model.typeList[tostring(self.soulType)])]
	data.soulNum = staicData[tostring(self.level)].fragment_num
	return data
end

function SoulEntity:getAttr2()
	local staicData = qy.Config.soul_level
	local data = {}
	data.name = model.typeNameList[tostring(self.soulType)]

	if self.level + 1 > self.maxLevel then
		data.num = staicData[tostring(self.level)][tostring(model.typeList[tostring(self.soulType)])]
		data.soulNum = staicData[tostring(self.level)].fragment_num
	else
		data.num = staicData[tostring(self.level + 1)][tostring(model.typeList[tostring(self.soulType)])]
		data.soulNum = staicData[tostring(self.level + 1)].fragment_num
	end
	
	data.maxLevel = self.level + 1 > self.maxLevel
	return data
end

return SoulEntity