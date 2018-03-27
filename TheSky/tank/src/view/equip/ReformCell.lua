--[[--

--]]--
local ReformCell = qy.class("ReformCell", qy.tank.view.BaseView, "view/equip/ReformCell")

function ReformCell:ctor(delegate)
    ReformCell.super.ctor(self)
    for i = 1, 3 do
        self:InjectView("att_"..i)
    end

    self:update(delegate.entity)
end

function ReformCell:update(equipEntity)
    --改造等级
    local reform_level = equipEntity.reform_level or 0

    self.att_1:setString(reform_level)
    self.att_3:setString(equipEntity:getPropertyReformName())
    self.att_2:setString("+"..equipEntity:getPropertyByLevel(reform_level).."%")
end

function ReformCell:getHeight()
    return 100
end

return ReformCell
