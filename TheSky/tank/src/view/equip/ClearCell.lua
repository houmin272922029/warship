--[[--
    装备套装2
    Author: H.X.Sun
--]]--
local ClearCell = qy.class("ClearCell", qy.tank.view.BaseView, "view/equip/ClearCell")
local NodeUtil = qy.tank.utils.NodeUtil
local model = qy.tank.model.EquipModel
function ClearCell:ctor(delegate)
    ClearCell.super.ctor(self)
    self.model = qy.tank.model.EquipModel

    self:InjectView("name")
    self:InjectView("num")

    self:update(delegate.data)
end

--[[--
--套装信息
--]]
function ClearCell:update(data)
    local id  = data.id
    self.name:setString(model.TypeNameList[tostring(data.id)]..":")
    if id < 6 then
        self.num:setString("+"..data.num)
     else
        local num1 = data.num / 10 
        self.num:setString("+"..num1.."%")
     end
end


return ClearCell
