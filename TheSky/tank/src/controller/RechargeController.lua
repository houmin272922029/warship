--[[
	充值控制器
	Author: H.X.Sun
	Date: 2015-09-23
]]

local RechargeController = qy.class("RechargeController", qy.tank.controller.BaseController)

function RechargeController:ctor(delegate)
    RechargeController.super.ctor(self)
    local isVipView = false
    if delegate and delegate.isVipView then
        isVipView = delegate.isVipView
    end

	print("VipController:ctor")
    self.viewStack = qy.tank.widget.ViewStack.new()
    self.viewStack:addTo(self)

    self.view = qy.tank.view.recharge.RechargeView.new({
    	["dismiss"] = function()
            self.viewStack:removeFrom(self)
            self:finish()
        end,
        ["isVipView"] = isVipView,

    })
    self.viewStack:push(self.view)
end

return RechargeController