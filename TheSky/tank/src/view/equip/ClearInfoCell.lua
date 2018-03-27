--[[--
    装备套装2
    Author: H.X.Sun
--]]--
local ClearInfoCell = qy.class("ClearInfoCell", qy.tank.view.BaseView, "view/equip/ClearInfoCell")
local NodeUtil = qy.tank.utils.NodeUtil

function ClearInfoCell:ctor(delegate)
    ClearInfoCell.super.ctor(self)
end
function ClearInfoCell:getHeight()
    return 40
end

return ClearInfoCell
