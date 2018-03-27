--[[
--图鉴
--Author: mingming
--Date:
]]

local Attribute = qy.class("Attribute", qy.tank.view.BaseView, "view/achievement/Attribute")

function Attribute:ctor(delegate)
    Attribute.super.ctor(self)

    self:InjectView("Name")
    self:InjectView("Num")
	-- local data = delegate.data
 --    for i = 1, 3 do
 --    	self:InjectCustomView("Item" .. i, qy.tank.view.common.TankItem2, data[i])
    	-- self["Item" .. i]:setVisible(false)
 --    end

 --    self:setData(data)
end

function Attribute:setData(data, idx)
    self.Name:setString(data.type)
	self.Num:setString("+" .. data.val)
	if tostring(data.typeIndex) == "6" or tostring(data.typeIndex) == "7" or tostring(data.typeIndex) == "9" then
		self.Num:setString("+" .. data.val / 10 .. "%")
	end
end


return Attribute