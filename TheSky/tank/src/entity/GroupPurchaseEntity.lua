--[[
    -- 超值购物
    Date: 2016-04-27
]]

local GroupPurchaseEntity = qy.class("GroupPurchaseEntity", qy.tank.entity.BaseEntity)

function GroupPurchaseEntity:ctor(data)
	self:setproperty("title", data.title)
	self:setproperty("award", data.award)
	self:setproperty("shop_type", data.shop_type)
	self:setproperty("id", data.id)
	self:setproperty("num", data.num)
	self:setproperty("vip_limit", data.vip_limit)
	self:setproperty("number", data.number)
end

return GroupPurchaseEntity