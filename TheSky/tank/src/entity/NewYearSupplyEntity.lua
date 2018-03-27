--[[
    春节特供
  
    Date: 2016-01-29
]]

local NewYearSupplyEntity = qy.class("NewYearSupplyEntity", qy.tank.entity.BaseEntity)

function NewYearSupplyEntity:ctor(data)
	self:setproperty("product_id", data.product_id)
	self:setproperty("idx", data.idx)
	self:setproperty("price", data.price)
	self:setproperty("award", data.award)
	self:setproperty("div", data.div)
	self:setproperty("gem", data.gem)
	self:setproperty("name", data.name)
	self:setproperty("status", 1) -- 1 未购买 -- 2 已购买未领取 -- 3 已领取
end

return NewYearSupplyEntity