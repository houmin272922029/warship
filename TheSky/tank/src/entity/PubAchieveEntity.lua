--[[
    干杯成就实体
]]

local PubAchieveEntity = qy.class("PubAchieveEntity", qy.tank.entity.BaseEntity)

function PubAchieveEntity:ctor(data)
    self:setproperty("times", data.times)
    self:setproperty("status", 0) --0 未达成 1 已达成 2 已领取
    self:setproperty("award", data.award)
end

return PubAchieveEntity