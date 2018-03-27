--[[
    图鉴 -- 成就 model
    Author: mingming
    Date: 2015-08-24
]]

local AchievementModel = class("AchievementModel", qy.tank.model.BaseModel)

AchievementModel.GREEN = 2
AchievementModel.BLUE = 3
AchievementModel.PURPLE = 4
AchievementModel.ORANGE = 5

--类型
AchievementModel._types = {
	["4"] = AchievementModel.ORANGE, -- 橙色品质
	["3"] = AchievementModel.PURPLE, -- 紫色品质
	["2"] = AchievementModel.BLUE, -- 蓝色品质
	["1"] = AchievementModel.GREEN, -- 绿色品质
}

AchievementModel.attrTypes = {
	["1"] = qy.TextUtil:substitute(3008),
	["2"] = qy.TextUtil:substitute(3009),
	["3"] = qy.TextUtil:substitute(3010),
	["4"] = qy.TextUtil:substitute(3011),
	["5"] = qy.TextUtil:substitute(3012),
	["6"] = qy.TextUtil:substitute(1033),
	["7"] = qy.TextUtil:substitute(1034),
	["8"] = qy.TextUtil:substitute(1035),
	["9"] = qy.TextUtil:substitute(1036),
	["10"] = qy.TextUtil:substitute(1037),
	["14"] = "伤害减免",
}

AchievementModel.attrLevels = {
	["0"] = qy.TextUtil:substitute(1038),
	["1"] = qy.TextUtil:substitute(1039),
	["2"] = qy.TextUtil:substitute(1040),
	["3"] = qy.TextUtil:substitute(1041),
	["4"] = qy.TextUtil:substitute(1042),
	["5"] = qy.TextUtil:substitute(1043),
	["6"] = qy.TextUtil:substitute(1044),
}


-- AchievementModel.picList = {}  -- 图鉴分类列表
-- AchievementModel.totalPicList = {} -- 图鉴总表
-- AchievementModel.achievementList = {} -- 成就总表

--初始化
function AchievementModel:init(data)
	self.picList = {}
	self.totalPicList = {}
	self.achievementList = {}
	self.achievementList_ = {}
	self.openAchievementList = {} -- 已开启成就
	self.achievementAttributeList = {} -- 属性列表
	self.picFinalList = {}
	self.openPicList = {}
	self.picAttribute = {} -- 图鉴、成就属性加成
	self.onlyPicAttr = {} --仅图鉴加成
	self.commentList = {} -- 评论列表
	self.nextPage = 1 -- 评论分页

	local staticData = qy.Config.tank
	local staticAchievement = qy.Config.achievement
	self.attributeData = qy.Config.achievement_plus

	for i, v in pairs(staticData) do
		if v.is_tujian == 1 then
			local entity = qy.tank.entity.TankEntity.new(v)
			local item = qy.tank.view.common.AwardItem.getItemData({
				["type"] = 11,
				["tank_id"] = v.tank_id,
			})

			if not self.picList[tostring(v.quality)] then
				self.picList[tostring(v.quality)] = {}
			end
			table.insert(self.picList[tostring(v.quality)], item)
			self.totalPicList[tostring(v.tank_id)] = item
		end
	end

	self:finalList()

	for i, v in pairs(staticAchievement) do
		local entity = qy.tank.entity.AchievementEntity.new(v)
		table.insert(self.achievementList, entity)
		self.achievementList_[tostring(v.id)] = entity
	end

	table.sort(self.achievementList, function(a, b)
		return a.order < b.order
	end)

	for i, v in pairs(self.attributeData) do
		self.achievementList_[tostring(v.chengjiu_id)]:addAttribute(v)
	end

	self.picAttribute = self:initAttr()
end

-- 排列图鉴显示数据
function AchievementModel:finalList()
	for i = 2, 6 do
		local v = self.picList[tostring(i)]

		if v then
			table.sort(v, function(a, b)
				return a.entity.sortID < b.entity.sortID
			end)

			local list = qy.Utils.oneToTwo(v, math.ceil(table.nums(v) / 3), 3)
			for k, j in pairs(list) do
				table.insert(self.picFinalList, j)
			end
		end
	end
end

-- function
function AchievementModel:update(data, notAddPic)
	if data.handbook then
		self:updatePicList(data.handbook, notAddPic)
	end
	if data.achieve then
		self:updateAchievement(data.achieve)
	end
	self.picAttribute = self:getPicAttributes(false)
	self.onlyPicAttr = self:getPicAttributes(true)
end

-- 获取图鉴每行数据
function AchievementModel:getlistAt(idx)
	return self.picFinalList[idx + 1]
end

--获取增加的图鉴的tank id
function AchievementModel:isTankInPicAddList(_tankId)
	if self.picAddList then
		for i =1, #self.picAddList do
			if self.picAddList[i] == _tankId then
				return true
			end
		end
		return false
	else
		return false
	end
end

function AchievementModel:getPicAddListNum()
	if self.picAddList and #self.picAddList > 0 then
		return #self.picAddList
	else
		return 0
	end
end

function AchievementModel:removeTankInPicList(_tankId)
	if self.picAddList then
		for i =1, #self.picAddList do
			if self.picAddList[i] == _tankId then
				table.remove(self.picAddList,i)
				return
			end
		end
	end
end

--更新图鉴信息
function AchievementModel:updatePicList(list, notAddPic)

	for i, v in pairs(list) do
		if self.totalPicList[tostring(v)] then
			self.totalPicList[tostring(v)].entity.isOwn = true
			local tankId = tostring(self.totalPicList[tostring(v)].entity.tank_id)
			if not self.openPicList[tankId] then
				self.openPicList[tankId] = self.totalPicList[tostring(v)]
			end
		end
	end

	if #list > 0 and not notAddPic then
		self.picAddList = list
		qy.Event.dispatch(qy.Event.SHOW_PICADD_TIPS)
		--获得新战车：激活图鉴
		--红点需要，激活图鉴，删除分解状态
		qy.tank.model.RedDotModel:setResolveStatus(false)
	end
end

-- 更新成就信息
function AchievementModel:updateAchievement(list)
	for i, v in pairs(list) do
		if self.achievementList_[tostring(i)] then
			self.achievementList_[tostring(i)].level = v
			if not self.openAchievementList[tostring(i)] then
				self.openAchievementList[tostring(i)] = self.achievementList_[tostring(i)]
			end
		end
	end
	-- self.achievementAttributeList = self:getAchievementAttrList()
end

-- 获取成就属性加成列表
-- function AchievementModel:getAchievementAttrList()
-- 	local attr = {}
-- 	for j, k in pairs(self.openAchievementList) do
-- 		local temp = self:getAttributeByLevel(k.id, k.level)

-- 		-- for i, v in pairs(temp) do
-- 		if not attr[tostring(temp.shuxing1_type)] then
-- 			attr[tostring(temp.shuxing1_type)] = temp.shuxing1_val
-- 		else
-- 			attr[tostring(temp.shuxing1_type)] = attr[tostring(temp.shuxing1_type)] + temp.shuxing1_val
-- 		end

-- 		if not attr[tostring(temp.shuxing2_type)] then
-- 			attr[tostring(temp.shuxing2_type)] = temp.shuxing2_val
-- 		else
-- 			attr[tostring(temp.shuxing2_type)] = attr[tostring(temp.shuxing2_type)] + temp.shuxing2_val
-- 		end

-- 		if not attr[tostring(temp.shuxing3_type)] then
-- 			attr[tostring(temp.shuxing3_type)] = temp.shuxing3_val
-- 		else
-- 			attr[tostring(temp.shuxing3_type)] = attr[tostring(temp.shuxing3_type)] + temp.shuxing3_val
-- 		end
-- 		-- end
-- 	end
-- 	return attr
-- end

-- 更新评论信息
function AchievementModel:updateComment(data, TankEntity)
	self.nextPage = data.nextpage
	for i, v in pairs(data.list) do
		if TankEntity then
			if TankEntity.commentList_[tostring(v._id)] then
				TankEntity.commentList_[tostring(v._id)]:update(v)
			else
				local entity = qy.tank.entity.CommentEntity.new(v)
				TankEntity:addCommnet(entity)
			end
		else
			if self.commentList[tostring(v._id)] then
				self.commentList[tostring(v._id)]:update(v)
			else
				local entity = qy.tank.entity.CommentEntity.new(v)
				self.commentList[tostring(v._id)] = entity
				self.totalPicList[tostring(v.tank_id)].entity:addCommnet(entity)
			end
		end
	end
end

-- 获取评论信息
function AchievementModel:getCommentByTankId(tankId)
	return self.commentList[tostring(tankId)]
end

-- 获取无法分解的坦克列表
function AchievementModel:getUnResolveList()
	local staticData = qy.Config.advance_grow_up
	local staticData2 = qy.Config.advance_special_attr
	local list = {}
	for i, v in pairs(self.openAchievementList) do
		for k = 1, 6 do
			if (v["tank" .. k] and v["tank" .. k] ~= "") and not list[tostring(v["tank" .. k])] then
				list[tostring(v["tank" .. k])] = v["tank" .. k]

				local id = staticData[tostring(v["tank" .. k])].special_id6    -- 组成成就的坦克的经过升星后的id也要排除
				local param = staticData2[tostring(id)].param
				list[tostring(param)] = param
			end

			-- if (v["tank" .. k] and v["tank" .. k] ~= "") and not list[tostring(v["tank" .. k])] then
			-- 	list[tostring(v["tank" .. k])] = v["tank" .. k]
			-- 	-- table.insert(list, v["tank" .. k])
			-- end
		end
	end
	return list
end

-- 获取所有成就包含坦克列表
function AchievementModel:getAchievementTankList()
	local list = {}
	for i, v in pairs(self.achievementList_) do
		for k = 1, 6 do
			if v["tank" .. k] and v["tank" .. k] ~= "" then
				table.insert(list, v["tank" .. k])
			end
		end
	end

	return list
end

-- 获取成就属性
function AchievementModel:getAttributeByLevel(id, level)
	return self.attributeData[id .. "_" .. level]
end

-- 测试成就是否可升级
function AchievementModel:testUpgade(entity)
	return self:getAttributeByLevel(entity.id, entity.level + 1)
end

-- 通过 tank_id 获取单个 tank 数据
function AchievementModel:atPic(id)
	return self.totalPicList[tostring(id)]
end

--[[
	获取属性列表
	参数：isOnlyOpic true：仅获取图鉴属性 false：获取图鉴+成就属性
]]--
function AchievementModel:getPicAttributes(isOnlyOpic)
	local attribute = self:initAttr()
	for i, v in pairs(self.openPicList) do
		local entity = v.entity
		if attribute[tostring(entity.tujian_type)] then
			attribute[tostring(entity.tujian_type)].val = attribute[tostring(entity.tujian_type)].val + entity.tujian_val
		end
	end

	if isOnlyOpic == false then
		for i, v in pairs(self.openAchievementList) do
			local temp = self:getAttributeByLevel(v.id, v.level)
			if attribute[tostring(temp.shuxing1_type)] then
				attribute[tostring(temp.shuxing1_type)].val = attribute[tostring(temp.shuxing1_type)].val + temp.shuxing1_val
			end

			if attribute[tostring(temp.shuxing2_type)] then
				attribute[tostring(temp.shuxing2_type)].val = attribute[tostring(temp.shuxing2_type)].val + temp.shuxing2_val
			end

			if attribute[tostring(temp.shuxing3_type)] then
				attribute[tostring(temp.shuxing3_type)].val = attribute[tostring(temp.shuxing3_type)].val + temp.shuxing3_val
			end
		end
	end

	local temp = table.values(attribute)

	table.sort(temp, function(a, b)
		return tonumber(a.typeIndex) < tonumber(b.typeIndex)
	end)

	return temp
end

-- 初始化属性
function AchievementModel:initAttr()
	local attribute = {}
	for i, v in pairs(self.attrTypes) do
		if not attribute[i] then
			attribute[i] = {}
			attribute[i].type = v
			attribute[i].typeIndex = i
			attribute[i].val = 0
		end
	end
	return attribute
end

-- 获取图鉴各种颜色列表
function AchievementModel:getList(type)
	local list = self.picList[tostring(type)]

	table.sort(list, function(a, b)
		return tonumber(a.entity.tank_id) < tonumber(b.entity.tank_id)
	end)

	return self.picList[tostring(type)]
end

-- 每种类型计算需要 tableviewCell 的高度
function AchievementModel:getHeight(type)
	local list = self:getList(type)

	if not list then
		return 0
	end

	return math.ceil(table.nums(list) / 3) * 145 + 40
end

-- 获取图鉴滚动总高度
function AchievementModel:getAllHeight()
	local height = 0

	for i, v in pairs(self._types) do
		height = height + self:getHeight(v)
	end

	return height
end

-- 成就列表数量
function AchievementModel:getAchievementNum()
	return #self.achievementList
end

--
function AchievementModel:getAchievementHeight(idx)
	local item = self.achievementList[idx + 1]
	return (item.tank5 and item.tank5 ~= "") and 400 or 280
end

function AchievementModel:testPicOpen()
	local userLevel = qy.tank.model.UserInfoModel.userInfoEntity.level
    local needAchievementLevel = qy.Config.function_open["19"].open_level
    return userLevel >= needAchievementLevel
end

-- 测试代币是否足够
function AchievementModel:testCoinEnough(entity)
	local data = self:getAttributeByLevel(entity.id, entity.level)

	local num = 0
	if data.up_type == 7 then
		num = qy.tank.model.UserInfoModel.userInfoEntity.purpleIron
	elseif data.up_type == 8 then
		num = qy.tank.model.UserInfoModel.userInfoEntity.orangeIron
	end

	return num >= data.up_val
end

--[[--
--获取增加的属性
--]]
function AchievementModel:getAddAttribute(data)
	local _aData ={}
	local _data = {}

	if data["1"] then
    		_data = {
        		["value"] = data["1"],
        		["url"] = qy.ResConfig.IMG_ATTACK,
        		["url2"] = qy.ResConfig.ALL_TANKS,
        		["type"] = 4,
   	 	}
    	table.insert(_aData, _data)
	end

	if data["2"] then
    		_data = {
        		["value"] = data["2"],
        		["url"] = qy.ResConfig.IMG_DEFENSE,
        		["url2"] = qy.ResConfig.ALL_TANKS,
        		["type"] = 4,
   	 	}
    	table.insert(_aData, _data)
	end

	if data["3"] then
    		_data = {
        		["value"] = data["3"],
        		["url"] = qy.ResConfig.IMG_BLOOD,
        		["url2"] = qy.ResConfig.ALL_TANKS,
        		["type"] = 4,
   	 	}
    	table.insert(_aData, _data)
	end

	if data["4"] then
    		_data = {
        		["value"] = data["4"],
        		["url"] = qy.ResConfig.IMG_WEAR,
        		["url2"] = qy.ResConfig.ALL_TANKS,
        		["type"] = 4,
   	 	}
    	table.insert(_aData, _data)
	end

	if data["5"] then
    		_data = {
        		["value"] = data["5"],
        		["url"] = qy.ResConfig.IMG_ANTI_WEAR,
        		["url2"] = qy.ResConfig.ALL_TANKS,
        		["type"] = 4,
   	 	}
    	table.insert(_aData, _data)
	end

	if data["6"] then
    		_data = {
        		["value"] = data["6"],
        		["url"] = qy.ResConfig.IMG_CRIT_HURT3,
        		["url2"] = qy.ResConfig.ALL_TANKS,
        		["type"] = 26,
        		["isPrecent"] = true,
   	 	}
    	table.insert(_aData, _data)
	end

	if data["7"] then
    		_data = {
        		["value"] = data["7"],
        		["url"] = qy.ResConfig.IMG_CRIT_HURT2,
        		["url2"] = qy.ResConfig.ALL_TANKS,
        		["type"] = 26,
        		["isPrecent"] = true,
   	 	}
    	table.insert(_aData, _data)
	end

	if data["8"] then
    		_data = {
        		["value"] = data["8"],
        		["url"] = qy.ResConfig.IMG_BEGIN_MORALE,
        		["url2"] = qy.ResConfig.ALL_TANKS,
        		["type"] = 4,
   	 	}
    	table.insert(_aData, _data)
	end

	if data["9"] then
    		_data = {
        		["value"] = data["9"],
        		["url"] = qy.ResConfig.IMG_HIT,
        		["url2"] = qy.ResConfig.ALL_TANKS,
        		["type"] = 4,
   	 	}
    	table.insert(_aData, _data)
	end

	if data["10"] then
    		_data = {
        		["value"] = data["10"],
        		["url"] = qy.ResConfig.IMG_DODGE,
        		["url2"] = qy.ResConfig.ALL_TANKS,
        		["type"] = 4,
   	 	}
    	table.insert(_aData, _data)
	end

	if data["100"] then
		if data["100"] < 0 then
			_data = {
	    		["value"] = data["100"],
	    		["url"] = qy.ResConfig.IMG_FIGHT_POWER,
	    		["url2"] = qy.ResConfig.ALL_TANKS,
	    		["type"] = 21,
	    		["picType"] = 2,
	   	 	}
	    		table.insert(_aData, _data)
	    elseif data["100"] > 0 then
			_data = {
	    		["value"] = data["100"],
	    		["url"] = qy.ResConfig.IMG_FIGHT_POWER,
	    		["url2"] = qy.ResConfig.ALL_TANKS,
	    		["type"] = 21,
	    		["picType"] = 2,
	   	 	}
	    	table.insert(_aData, _data)
		end
	end

	return _aData
end

-- function AchievementModel:get

-- AchievementModel:init()

return AchievementModel
