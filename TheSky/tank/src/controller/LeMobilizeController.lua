--[[
	军团动员
	Author: H.X.Sun
]]

local LeMobilizeController = qy.class("LeMobilizeController", qy.tank.controller.BaseController)

function LeMobilizeController:ctor(delegate)
    LeMobilizeController.super.ctor(self)

    print("LeMobilizeController:ctor")
    self.viewStack = qy.tank.widget.ViewStack.new()
    self.viewStack:addTo(self)

    self.mobilizeView = qy.tank.view.legion.mobilize.MobilizeView.new({
        ["dismiss"] = function(isCreateHall)
            self.viewStack:pop()
            self.viewStack:removeFrom(self)
            self:finish()
        end,
        })
    self.viewStack:push(self.mobilizeView)
end

return LeMobilizeController
