--[[
    说明: 军魂之路
]]

local SoulCheckPointEntity = qy.class("SoulCheckPointEntity", qy.tank.entity.BaseEntity)

function SoulCheckPointEntity:ctor(data)
    self:setproperty("icon",data.icon)
    self:setproperty("checkpoint_id",data.checkpoint_id)
    self:setproperty("daily_award",data.daily_award)
    self:setproperty("drop_award",data.drop_award)
    self:setproperty("first_num",data.first_num)
    self:setproperty("name",data.name)
    self:setproperty("num",data.num)
    self:setproperty("scene_id",data.scene_id)
    self:setproperty("level",data.level)
    self:setproperty("type",data.type)
    self:setproperty("complete",false)
    self:setproperty("current",false)
end

return SoulCheckPointEntity