--[[
    -- 充值红利
    Date: 2015-05-11
]]

local RechargeBonusEntity = qy.class("RechargeBonusEntity", qy.tank.entity.BaseEntity)

function RechargeBonusEntity:ctor(data, idx)
	self:setproperty("day", data.day)
	self:setproperty("old_price", data.old_price)
	self:setproperty("price", data.price)
	self:setproperty("award", data.award) 
	self:setproperty("idx", idx)
end

return RechargeBonusEntity