--[[
    酒馆实体
]]

local PubEntity = qy.class("PubEntity", qy.tank.entity.BaseEntity)

function PubEntity:ctor(data)
    self:setproperty("id", data.id)
    self:setproperty("type", data.type) --1 普通 2 至尊
    self:setproperty("award", data.award)
end

return PubEntity