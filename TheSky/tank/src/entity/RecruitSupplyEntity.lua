

local RecruitSupplyEntity = qy.class("RecruitSupplyEntity", qy.tank.entity.BaseEntity)

function RecruitSupplyEntity:ctor(data)
	self:setproperty("id", data.id)
	self:setproperty("status", data.status) -- 0 未购买 -- 1 已购买未领取 -- -1 已领取
end

return RecruitSupplyEntity