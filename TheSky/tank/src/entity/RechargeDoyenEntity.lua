--[[
    充值达人
    Author: mingming
    Date: 2015-03-20 11:58:36
]]

local RechargeDoyenEntity = qy.class("RechargeDoyenEntity", qy.tank.entity.BaseEntity)

function RechargeDoyenEntity:ctor(data)
    self:setproperty("amount", data.amount)
    self:setproperty("rank", data.rank)
    self:setproperty("award", data.award)
    self:setproperty("status", 1)
end

return RechargeDoyenEntity