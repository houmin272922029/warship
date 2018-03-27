local DiamondRebateEntity = qy.class("DiamondRebateEntity", qy.tank.entity.BaseEntity)

function DiamondRebateEntity:ctor(data)
    self:setproperty("id", data.id)
    self:setproperty("status", data.status)
end

return DiamondRebateEntity