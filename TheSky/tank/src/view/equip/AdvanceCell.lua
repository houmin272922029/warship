--[[--

--]]--
local AdvanceCell = qy.class("AdvanceCell", qy.tank.view.BaseView, "view/equip/AdvanceCell")

local model = qy.tank.model.EquipModel
function AdvanceCell:ctor(delegate)
    AdvanceCell.super.ctor(self)
    for i = 1, 10 do
        self:InjectView("att_"..i)
    end

    self:update(delegate.entity)
end

function AdvanceCell:update(equipEntity)

    local list = model:atScepcailList(equipEntity)

    for i = 1, 10 do        
        local data = list[tostring(i)]

        value = model:getAdvanceData(data)
        self["att_"..i]:setString(model.attrTypes[tostring(data.type)].."+"..value)
    end
    
end

function AdvanceCell:getHeight()
    return 375
end

return AdvanceCell
