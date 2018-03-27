--[[
    Button1
]]

local Button2 = qy.class("Button2", qy.tank.view.BaseView, "view/common/Button2")

function Button2:ctor(params)
    Button2.super.ctor(self)
    self:InjectView("Button_1")
    self:InjectView("btn_txt")
end

function Button2:setTitleText(str)
	self.btn_txt:setString(str)
end


return Button2
