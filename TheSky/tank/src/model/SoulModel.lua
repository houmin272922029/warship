--
-- Author: Your Name
-- Date: 2015-12-01 17:05:10
--

local SoulModel = qy.class("SoulModel", qy.tank.model.BaseModel)
local StrongModel = qy.tank.model.StrongModel

SoulModel.typeNameList ={
	["1"] = qy.TextUtil:substitute(66001),
	["2"] = qy.TextUtil:substitute(66002),
	["3"] = qy.TextUtil:substitute(66003),
	["4"] = qy.TextUtil:substitute(66004),
	["5"] = qy.TextUtil:substitute(66005),
	["6"] = qy.TextUtil:substitute(66006),
	["7"] = qy.TextUtil:substitute(66007),
	["8"] = qy.TextUtil:substitute(66008),
	["9"] = qy.TextUtil:substitute(1036),
}

SoulModel.anotherList ={
	["1"] = qy.TextUtil:substitute(41001),
	["2"] = qy.TextUtil:substitute(41002),
	["3"] = qy.TextUtil:substitute(41003),
	["4"] = qy.TextUtil:substitute(40044),
	["5"] = qy.TextUtil:substitute(40045),
	["6"] = qy.TextUtil:substitute(66006),
	["7"] = qy.TextUtil:substitute(90291),
	["8"] = qy.TextUtil:substitute(66007),
	["9"] = qy.TextUtil:substitute(90292),
	["10"] = qy.TextUtil:substitute(90293),
	["11"] = qy.TextUtil:substitute(8039)
}

SoulModel.typeList ={
	["1"] = "morale",
	["2"] = "wear",
	["3"] = "anti_wear",
	["4"] = "blood_rate",
	["5"] = "dodge_rate",
	["6"] = "crit_rate",
	["7"] = "crit_hurt",
	["8"] = "disarm_anti_rate",
	["9"] = "hit_plus"
}
function SoulModel:init(data)
	print("军魂数据",json.encode(data))
	self.positions = qy.Config.soul_position_limit
	self.atPosList = {}
	self.enableUse = {}
	self.finalEnableList = {}
	self.list = {}

	self.tankAttrs = {}

	self.page = 1
	
	local staticData = qy.Config.soul
	self.soul_levellist = qy.Config.soul_level

	if data then
		self:update(data)
	end
	self.flag = false
end

function SoulModel:update(data)
	if data then
		local staticData = qy.Config.soul
		for i, v in pairs(data) do
			if not self.list[tostring(v.unique_id)] then
				local entity = qy.tank.entity.SoulEntity.new(v, staticData[tostring(v.soul_id)])
				self.list[tostring(v.unique_id)] = entity
			else
				self.list[tostring(v.unique_id)]:update(v)
			end
		end
	end

	self:classfiy()
	self:sort()
	self.finalEnableList = qy.Utils.oneToTwo(self.enableUse, math.ceil(table.nums(self.enableUse) / 8), 8)

	self:getAttrs()
end

--根据soulid获取soul的图片
function SoulModel:getSoulIconBySoulId(id)
	local staticData = qy.Config.soul
	local soulType = staticData[tostring(id)].type
	local soulQuality = staticData[tostring(id)].quality
	return "res/soul/" .. soulType .. "_" .. soulQuality .. ".png"
end

--根据soulid获取soul的name
function SoulModel:getSoulNameBySoulId(id)
	local staticData = qy.Config.soul
	local Name = staticData[tostring(id)].name
	return Name
end

-- 归类
function SoulModel:classfiy()
	self.atPosList = {}
	self.enableUse = {}
	for i, v in pairs(self.list) do
		if v.pos ~= "" then
			if not self.atPosList[tostring(v.tank_unique_id)] then
				self.atPosList[tostring(v.tank_unique_id)] = {}
				table.insert(self.atPosList[tostring(v.tank_unique_id)], v)
			else
				table.insert(self.atPosList[tostring(v.tank_unique_id)], v)
			end
		else
			table.insert(self.enableUse, v)
		end
	end

	for i, v in pairs(self.atPosList) do

	end
	-- 更新变强数据
	self:updateStrong()
end

function SoulModel:updateStrong()
	local x = 0
    for k,v in pairs(StrongModel.StrongFcList) do
        x = x + 1
        if v.id == 5 then
            table.remove(StrongModel.StrongFcList, x)
        end
    end

	local totalLevel = 0
	for k,v in pairs(self.atPosList) do
		for key,value in pairs(v) do
			totalLevel = totalLevel + value.level
		end
	end
	local list = {["id"] = 5 , ["progressNum"] = totalLevel / 560}
	table.insert(StrongModel.StrongFcList, list)
end

function SoulModel:getAttrs()
	self.tankAttrs = {}
	self.tankAttrsanother = {}
	for k, j in pairs(self.atPosList) do
		if not self.tankAttrs[tostring(k)] then
			self.tankAttrs[tostring(k)] = {}
		end
		if not self.tankAttrsanother[tostring(k)] then
			self.tankAttrsanother[tostring(k)] = {}
		end

		for i, v in pairs(j) do
			if not self.tankAttrs[tostring(k)][tostring(v.soulType)] then
				self.tankAttrs[tostring(k)][tostring(v.soulType)] = v:getAttr1().num
			else
				self.tankAttrs[tostring(k)][tostring(v.soulType)] = self.tankAttrs[tostring(k)][tostring(v.soulType)] + v:getAttr1().num
			end
		end
		for i, v in pairs(j) do
			if not self.tankAttrsanother[tostring(k)][tostring(v.soulType)] then
				self.tankAttrsanother[tostring(k)][tostring(v.soulType)] = v
			elseif type(self.tankAttrsanother[tostring(k)][tostring(v.soulType)]) == "number" and type(v) == "number" then
				self.tankAttrsanother[tostring(k)][tostring(v.soulType)] = self.tankAttrsanother[tostring(k)][tostring(v.soulType)] + v
			end
		end
	end
end

function SoulModel:sort()
	table.sort(self.enableUse, function(a, b)
		return a.unique_id < b.unique_id
	end)

	table.sort(self.atPosList, function(a, b)
		return a.unique_id < b.unique_id
	end)
end

-- 查找entity的索引
function SoulModel:getKey(list, entity)
	if list then
		for i, v in pairs(list) do
			if v.unique_id == entity.unique_id then
				return i
			end
		end
	end
	return 0
end

function SoulModel:getEnableUse()
	return self.finalEnableList
	-- return qy.Utils.oneToTwo(self.enableUse, math.ceil(table.nums(self.enableUse) / 6), 6)
end

function SoulModel:atTank(entity)
	if type(entity) == "table" then
		local tankUniqueId = entity.unique_id
		local list = self.atPosList[tostring(tankUniqueId)]

		return list
	end
end

function SoulModel:getMaxPage()
	return #self.finalEnableList
end

function SoulModel:setPage(page)
	if page > 0 and page <= self:getMaxPage() then
		self.page = page
	end

	if page <= 0 then
		self.page = 1
	end

	if page > self:getMaxPage() then
		self.page = self:getMaxPage()
	end
end

-- 获取soulinfo面板上显示的entity
function SoulModel:getSelectSoulEntity(entity, idx, stype)
	if stype == 1 then
		return self:getCurrentPageFirstSoul(idx)
	else
		if type(entity) == "table" then
			local data = self.atPosList[tostring(entity.unique_id)]
			if data ~= nil and #data > 0 then
				if not idx then
					table.sort(data, function(a, b)
						local key1 = string.sub(a.pos, 3)
						local key2 = string.sub(b.pos, 3)
						return key1 < key2
					end)

					return data[1]
				else
					for i, v in pairs(data) do
						if v.pos == "p_" .. idx then
							return v
						end
					end
				end
			else
				return self:getCurrentPageFirstSoul()
			end
		else
			return self:getCurrentPageFirstSoul()
		end
	end
end

-- 获取当前页可用的第一个soul
function SoulModel:getCurrentPageFirstSoul(idx)
	idx = idx or 1
	if self.finalEnableList[self.page] then
		return self.finalEnableList[self.page][idx], idx
	end
end

-- 获取坦克 军魂 提供的属性加成
function SoulModel:getAttribute(unique_id)
	if not self.tankAttrs[tostring(unique_id)] then
		return {}
	end
	print("tankadd",json.encode(self.tankAttrs))
	return self.tankAttrs[tostring(unique_id)]
end
-- 获取坦克 军魂 提供的副属性加成
function SoulModel:getanothAttribute(unique_id,types)
	-- print("s",json.encode(self.tankAttrsanother))
	if self.tankAttrsanother[tostring(unique_id)] then
		local num = 0
		
		-- print("战车属性",json.encode(self.tankAttrsanother[tostring(unique_id)]))
		for i ,v in pairs(self.tankAttrsanother[tostring(unique_id)]) do
			local nums = 0
			local list = v.deputy_attr
			for i=1,#list do
				if list[i].type == types then
					nums = self.soul_levellist[tostring(v.level)]["deputy_attr_"..types]
				end
			end
			num = num + nums
		end
		if types == 1 or types ==2 or types == 3 then
			return num/1000 + 1
		else
			return num
		end
		
	else
		if types == 1 or types ==2 or types == 3 then
			return 1
		else
			return 0
		end
		
	end
	
end

function SoulModel:remove(unique_id)
	self.list[tostring(unique_id)] = nil
	self:update()
end


-- 新加的soul不可能出现在坦克位置上，所以不需要重新计算增加属性
function SoulModel:addSoul(data)
	if data then
		local staticData = qy.Config.soul
		if not self.list[tostring(data.unique_id)] then
			local entity = qy.tank.entity.SoulEntity.new(data, staticData[tostring(data.soul_id)])
			self.list[tostring(data.unique_id)] = entity
		else
			self.list[tostring(data.unique_id)]:update(data)
		end
	end

	self:classfiy()
	self:sort()
	self.finalEnableList = qy.Utils.oneToTwo(self.enableUse, math.ceil(table.nums(self.enableUse) / 8), 8)
end
--额外属性
function SoulModel:getAnother( type,level )
	local maxlevellist = qy.Config.soul_max_level
	table.sort(self.soul_levellist, function(a, b)
		return a.level < b.level
	end)
	local num = self.soul_levellist[tostring(level)]["deputy_attr_"..type]
	local str = SoulModel.anotherList[tostring(type)].."+"..num/10 .."%"
	local numa 
	local strs 
	if level < maxlevellist[tostring(6)].max_level then
		numa = self.soul_levellist[tostring(level+1)]["deputy_attr_"..type]
		strs = "  下一级:+"..numa/10 .."%"
	else
		numa = self.soul_levellist[tostring(level)]["deputy_attr_"..type]
		strs = "  下一级:+"..numa/10 .."%"
	end
	if self.flag then
		return str..strs
	else
		return str
	end
	
end

return SoulModel