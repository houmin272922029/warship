--[[
    说明: 将士之战
]]

local SoldiersWarChestEntity = qy.class("SoldiersWarChestEntity", qy.tank.entity.BaseEntity)

function SoldiersWarChestEntity:ctor(data)

	self:setproperty("checkpoint_id",data.checkpoint_id)
    self:setproperty("award",data.award)
    self:setproperty("first_award",data.first_award)
end

return SoldiersWarChestEntity