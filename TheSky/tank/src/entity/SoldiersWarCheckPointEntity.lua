--[[
    说明: 将士之战
]]

local SoldiersWarCheckPointEntity = qy.class("SoldiersWarCheckPointEntity", qy.tank.entity.BaseEntity)

function SoldiersWarCheckPointEntity:ctor(data)
    self:setproperty("bg_icon_id",data.bg_icon_id)
    self:setproperty("checkpoint_id",data.checkpoint_id)
    self:setproperty("fight_power",data.fight_power)
    self:setproperty("monster2",data.monster2)
    self:setproperty("image_id",data.image_id)
    self:setproperty("name",data.name)
    self:setproperty("level",data.level)
    self:setproperty("tank_id",data.tank_id)
end

return SoldiersWarCheckPointEntity