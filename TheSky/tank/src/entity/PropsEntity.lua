--[[
	宝箱、道具、材料实体
	Author: Aaron Wei
	Date: 2015-04-17 15:30:37
]]

local PropsEntity = qy.class("PropsEntity", qy.tank.entity.BaseEntity)

function PropsEntity:ctor(data)
	if type(data) == "number" then
		self:setproperty("id", tostring(data))
	elseif type(data) == "table" then
		-- remote server data
		self.data = data
		self.clone = clone(data)
		self:setproperty("id", tostring(data.id))
		self:setproperty("num",tonumber(data.num))
	end
	self:initByID(self.id)
end

function PropsEntity:initByID(id)
	self:setproperty("id", id)
	-- local config data
	self.name = qy.Config.props[id].name
	self.type = qy.Config.props[id].type
	self.quality = qy.Config.props[id].quality
	self.price = qy.Config.props[id].price
	-- 是否可使用
	self.is_use = qy.Config.props[id].is_use
	-- 最大使用限制
	self.max_use_limit = qy.Config.props[id].max_use_limit
	-- 不可使用提示
	self.not_use_tips = qy.Config.props[id].not_use_tips
	-- 出售限制
	self.sell_limit = qy.Config.props[id].sell_limit
	-- 不可出售提示
	self.not_sell_tips = qy.Config.props[id].not_sell_tips
	self.trigger_type = qy.Config.props[id].trigger_type
	self.icon = qy.Config.props[id].icon
	self.desc = qy.Config.props[id].describe
	self.trigger_args = qy.Config.props[id].trigger_args

	self.extra_tip = qy.Config.props[id].extra_tip

	--不为空 则点击使用后弹出选择奖励
	self.award = qy.Config.props[id].award

	--点击使用后弹出面板，面板中显示的物品（选择一个获得）
	self.choice_award = qy.Config.props[id].award or nil

	self.need_id = qy.Config.props[id].need_id or 0 
end

function PropsEntity:getNum()
	return self.num
end

function PropsEntity:setNum(num)
	if self.num ~= nil then
		self.num_:set(num)
	else
		self:setproperty("num",num)
	end
end

function PropsEntity:getIconBG()
	local quality = self.quality
	-- 白绿蓝紫橙
	return "Resources/common/item/item_bg_" .. quality .. ".png"
end

function PropsEntity:getTextColor()
	return qy.tank.utils.ColorMapUtil.qualityMapColor(self.quality)
end

function PropsEntity:getIcon()
	return "props/"..self.id..".png"	
	-- return "props/1.png"	
end

return PropsEntity
