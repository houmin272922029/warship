--[[
    -- 全民充值
    Date: 2016-04-27
]]

local AllRechargeEntity = qy.class("AllRechargeEntity", qy.tank.entity.BaseEntity)

function AllRechargeEntity:ctor(data)
	self:setproperty("num", data.num)
	self:setproperty("all_award", data.all_award)
	self:setproperty("recharge_award", data.recharge_award)
	self:setproperty("id", data.id)
end

return AllRechargeEntity