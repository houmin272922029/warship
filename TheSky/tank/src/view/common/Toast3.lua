--[[
    toast2 用于飘icon + 文字
    Author: H.X.Sun
    Date: 2015-04-18
]]

local Toast3 = qy.class("Toast3", qy.tank.view.BaseView, "view/common/Toast3")

--params.critNum: 暴击倍数，现在有2、4、6、8倍，默认没有
--params.text :显示的文字
function Toast3:ctor(params)
    Toast3.super.ctor(self)

	self:InjectView("crit")
	self:InjectView("text")
	if params.critMultiple and params.critMultiple > 1 then
		self.crit:setSpriteFrame("Resources/toast/bj_ty_" .. params.critMultiple .. ".png")
		self.crit:setVisible(true)
	else
		self.crit:setVisible(false)
	end

	self.text:setString(params.text)

end

return Toast3
