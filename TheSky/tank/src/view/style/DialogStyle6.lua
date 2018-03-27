--[[
	dialog边框样式5
	Author: H.X.Sun
	Date: 2015-05-22
]]

local DialogStyle6 = qy.class("DialogStyle6", qy.tank.view.style.DialogBaseStyle, "view/style/DialogStyle6")

function DialogStyle6:ctor(params)
    DialogStyle6.super.ctor(self, params)
	self.bg:setSwallowTouches(false)
    self.bg:setContentSize(params.size.width,params.size.height)
    self.bg:setPosition(qy.winSize.width/2, qy.winSize.height/2)
    self.closeBtn:setPosition(self.frame:getPositionX()+params.size.width/2-2, self.frame:getPositionY()+params.size.height/2+14)
end

return DialogStyle6