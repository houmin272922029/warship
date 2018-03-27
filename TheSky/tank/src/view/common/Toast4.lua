--[[
    声望 + 文字
]]

local Toast4 = qy.class("Toast4", qy.tank.view.BaseView, "view/common/Toast4")

function Toast4:ctor(params)
    Toast4.super.ctor(self)
	self:InjectView("text")
	self:InjectView("crit")
	self.text:setString(params.text)
end

return Toast4
