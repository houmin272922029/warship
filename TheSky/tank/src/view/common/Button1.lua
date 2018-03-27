--[[
    Button1
]]

local Button1 = qy.class("Button1", qy.tank.view.BaseView, "view/common/Button1")

function Button1:ctor(params)
    Button1.super.ctor(self)
    self:InjectView("Button_1")
    self:InjectView("btn_txt")
end

function Button1:setTitleText(str)
	self.btn_txt:setString(str)
end


return Button1
