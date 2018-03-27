--[[--

--]]--
local ProgressCell = qy.class("ProgressCell", qy.tank.view.BaseView, "view/equip/ProgressCell")

local model = qy.tank.model.EquipModel

function ProgressCell:ctor(delegate,idx,data)
    ProgressCell.super.ctor(self)

    self:InjectView("name")
    self:InjectView("Text_10")
    self:InjectView("tiaobg")
    self:InjectView("addnum")

    self:update(delegate,idx,data)
end

function ProgressCell:update(data,idx,data2)
    self.addnum:setVisible(idx == (data2.key + 1))
    local id  = data.id
    local max = model:getFullvalueByid(id)
    if idx == (data2.key + 1) then
        data.num  = data.num + data2.incr
    end
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
        self.addnum:setString("+"..data2.incr)
    else
        local num1 = data.num / 10 
        local num2 = max / 10
        self.Text_10:setString(num1.."%/"..num2.."%")
        local num3 = data2.incr / 10 
        self.addnum:setString("+"..num3.."%")
    end
   
end

return ProgressCell
