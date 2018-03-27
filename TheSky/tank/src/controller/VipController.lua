--[[
	VIP控制器
	Author: Aaron Wei
	Date: 2015-06-11 20:10:15
]]

local VipController = qy.class("VipController", qy.tank.controller.BaseController)

function VipController:ctor(delegate)
    VipController.super.ctor(self)

	print("VipController:ctor")
    self.viewStack = qy.tank.widget.ViewStack.new()
    self.viewStack:addTo(self)
    -- self.model = qy.tank.model.ArenaModel

    if delegate then
        delegate["dismiss"] = function()
            self.viewStack:pop()
            self.viewStack:removeFrom(self)
            self:finish()
        end
    end

    self.view = qy.tank.view.vip.VipPrivilegeView.new(delegate)
    self.viewStack:push(self.view)
end

return VipController
