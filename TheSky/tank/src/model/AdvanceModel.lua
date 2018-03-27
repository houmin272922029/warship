--[[
    进阶 model
    Author: mingming
    Date: 2015-08-24
]]

local AdvanceModel = class("AdvanceModel", qy.tank.model.BaseModel)

-- AdvanceModel.GREEN = 2
-- AdvanceModel.BLUE = 3
-- AdvanceModel.PURPLE = 4
-- AdvanceModel.ORANGE = 5

AdvanceModel.attrTypes = {
	["1"] = qy.TextUtil:substitute(3008),
	["2"] = qy.TextUtil:substitute(3009),
	["3"] = qy.TextUtil:substitute(3010),
	["4"] = qy.TextUtil:substitute(3011),
	["5"] = qy.TextUtil:substitute(3012),
	["6"] = qy.TextUtil:substitute(3013),
	["7"] = qy.TextUtil:substitute(3014),
	["8"] = qy.TextUtil:substitute(3015),
	["9"] = qy.TextUtil:substitute(3016),
	["10"] = qy.TextUtil:substitute(3017),
	["11"] = qy.TextUtil:substitute(3018),
	["12"] = qy.TextUtil:substitute(3019),
	["13"] = qy.TextUtil:substitute(3020),
	["14"] = qy.TextUtil:substitute(3021),
	["15"] = qy.TextUtil:substitute(3022),
	["16"] = qy.TextUtil:substitute(3023),
	["17"] = qy.TextUtil:substitute(3023),
	["18"] = qy.TextUtil:substitute(3023),
	["19"] = qy.TextUtil:substitute(3023),
	["20"] = qy.TextUtil:substitute(3023),
}

-- AchievementModel.picList = {}  -- 图鉴分类列表
-- AchievementModel.totalPicList = {} -- 图鉴总表
-- AchievementModel.achievementList = {} -- 成就总表 

--初始化
function AdvanceModel:init()
	self.growUpList = qy.Config.advance_grow_up
	self.commonAttr = qy.Config.advance_common_attr
	self.specialAttr = qy.Config.advance_special_attr
	self.skillAdvance = qy.Config.skill_advance
end

-- 
function AdvanceModel:atGrowUp(entity)
	return self.growUpList[tostring(entity.tank_id)]
end

function AdvanceModel:atCommonAttr(level)
	-- if level > 10 then
	-- 	level = 10
	-- end
	return self.commonAttr[tostring(level)]
end

function AdvanceModel:atSpecailAttr(entity)
	local list = self:atScepcailList(entity)
	local max = self:getMaxLevel(entity)

	local level = entity.advance_level + 1 > max and max or entity.advance_level + 1
	
	return list[tostring(level)]
end

function AdvanceModel:atScepcailList(entity)
	-- local list = {}
	-- for i = 1, self:getMaxLevel(entity) do
	-- 	local id = self:atGrowUp(entity)["special_id" .. i]
	-- 	list[tostring(i)] = self.specialAttr[tostring(id)]
	-- end
	-- return list


	--2016年11月08日14:35:48 fq
	local list = {}
	for i = 1, self:getMaxLevel(entity) > 10 and 10 or self:getMaxLevel(entity) do
		local id = self:atGrowUp(entity)["special_id" .. i]
		list[tostring(i)] = self.specialAttr[tostring(id)]
	end

	if self:getMaxLevel(entity) > 10 then
		for i = 11, self:getMaxLevel(entity) do
			local id = self:atGrowUp(entity)["special_id" .. i]
			print("id", id)
			local data = self.skillAdvance[tostring(id)]
			data.level = i
			list[tostring(i)] = data
		end
	end
	return list
end

function AdvanceModel:atSpecailByLevel(entity, level)
	-- local list = self:atScepcailList(entity)
	-- local max = self:getMaxLevel(entity)

	-- if level > max then
	-- 	level = max
	-- end
	-- local id = self:atGrowUp(entity)["special_id" .. level]
	-- return self.specialAttr[tostring(id)]


	--2016年11月08日14:35:48 fq
	local list = self:atScepcailList(entity)
	local max = self:getMaxLevel(entity)

	if level > max then
		level = max
	end

	if level <= 10 then
		local id = self:atGrowUp(entity)["special_id" .. level]
		return self.specialAttr[tostring(id)]
	else
		local id = self:atGrowUp(entity)["special_id" .. level]
		local data =  self.skillAdvance[tostring(id)]
		data.level = level

		return data
	end
end

-- 进阶增加的攻击力
function AdvanceModel:getAdvanceAddList(entity)
	local addList = {}

	for i = 1, entity.advance_level > 10 and 10 or entity.advance_level do
		local specailData = self:atSpecailByLevel(entity, i)
		if not addList[tostring(specailData.type)] and specailData.type ~= 9 then
			addList[tostring(specailData.type)] = specailData.param
		elseif addList[tostring(specailData.type)] and specailData.type ~= 9 then
			addList[tostring(specailData.type)] = addList[tostring(specailData.type)] + specailData.param
		end
	end

	return addList
end


function AdvanceModel:getPassiveSkillsAddList(entity)
	local addList2 = {} --进阶11开始的被动技能加成，暂时先这么写
	if entity.advance_level > 10 then
		for i = 11, entity.advance_level do 
			local specailData = self:atSpecailByLevel(entity, i)

			local _type = tostring(specailData.type)
			local _param = tostring(specailData.param)
			local _type_table = {}
			local _param_table = {}

			if string.find(_type, ",") then
				_type_table = string.split(_type, ",")				
			else
				_type_table[1] = _type
			end

			if string.find(_param, ",") then
				_param_table = string.split(_param, ",")				
			else
				_param_table[1] = _param
			end

			for i = 1, #_type_table do
				if not addList2[tostring(_type_table[i])] and _type_table[i] ~= "9" then
					addList2[tostring(_type_table[i])] = tonumber(_param_table[i] or _param_table[1] or 0)
				elseif addList2[tostring(_type_table[i])] and _type_table[i] ~= "9" then
					addList2[tostring(_type_table[i])] = addList2[tostring(_type_table[i])] + tonumber(_param_table[i] or _param_table[1] or 0)
				end
			end
		end
	end

	return addList2
end

-- 测试是否升星
function AdvanceModel:testAddStar(entity)
	local data = self:atSpecailByLevel(entity, entity.advance_level)

	return tostring(data.type) ~= "9"
end

-- 测试是否可以进阶
function AdvanceModel:testGrowUpEnable(entity)
	if type(entity) == "table" and self:atGrowUp(entity) then
		return true
	else
		return false
	end
end

-- 测试是否达到max
function AdvanceModel:testMax(entity)
	local list = self:atGrowUp(entity)

	local z = 0
	for i, v in pairs(list) do
		if v ~= 0 and i ~= "tank_id" then
			z = z + 1
		end
	end
	print(entity.advance_level + 1 > z)
	print("ssssssssssss")
	if entity.advance_level + 1 > z then
		return true
	else
		return false
	end
end

function AdvanceModel:getMaxLevel(entity)
	local list = self:atGrowUp(entity)

	local z = 0
	for i, v in pairs(list) do
		if v ~= 0 and string.find(i, "special_id") ~= nil then
			z = z + 1
		end
	end


	return z

end


function AdvanceModel:getAddAttribute(data)
	local _aData ={}
	local _data = {}

	if data["100"] then
		if data["100"] < 0 then
			_data = {
	    		["value"] = data["100"],
	    		["url"] = qy.ResConfig.IMG_FIGHT_POWER,
	    		["type"] = 21,
	    		["picType"] = 2,
	   	 	}
	    	table.insert(_aData, _data)
	    elseif data["100"] > 0 then
			_data = {
	    		["value"] = data["100"],
	    		["url"] = qy.ResConfig.IMG_FIGHT_POWER,
	    		["type"] = 21,
	    		["picType"] = 2,
	   	 	}
	    	table.insert(_aData, _data)
		end
	end

	return _aData
end

function AdvanceModel:testEsxit(entity)
	if self:atGrowUp(entity) then
		return true
	else
		return false
	end
end

-- function AdvanceModel:getAddAttack(entity)
-- 	local addAtack = 0
-- 	if entity.advance_level <= 0 then
-- 		return 0
-- 	end
-- 	for i = 1, entity.advance_level do
-- 		local commonData = self:atCommonAttr(i)
-- 		addAtack = addAtack + commonData.attack_plus

-- 		local specailData = self:atSpecailAttr(entity)
-- 		if specailData.type == 1 then
-- 			addAtack = addAtack + specailData.param
-- 		end
-- 	end
-- 	return addAtack
-- end

-- function AdvanceModel:getAddAttack(entity)
	
-- end

AdvanceModel:init()

return AdvanceModel
