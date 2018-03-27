--[[--

--]]--
local ProgressCell1 = qy.class("ProgressCell1", qy.tank.view.BaseView, "view/equip/ProgressCell1")

local model = qy.tank.model.EquipModel

function ProgressCell1:ctor(delegate)
    ProgressCell1.super.ctor(self)

    self:InjectView("name")
    self:InjectView("Text_10")
    self:InjectView("tiaobg")

    self:update(delegate)
end

function ProgressCell1:update(data)
    local id  = data.id
    local max = model:getFullvalueByid(id)
    if data.num > max then
        self.tiaobg:loadTexture("Resources/equip/hong.png", 1)
    else
        self.tiaobg:loadTexture("Resources/equip/lan.png", 1)
    end
    local progres = data.num / max  > 1 and 1 or data.num / max
    self.tiaobg:setScaleX(progres)
   
    self.name:setString(model.TypeNameList[tostring(data.id)]..":")
    if id < 6 then
        self.Text_10:setString(data.num.."/"..max)
     else
        local num1 = data.num / 10 
        local num2 = max / 10
        self.Text_10:setString(num1.."%/"..num2.."%")
     end
   
end

return ProgressCell1
