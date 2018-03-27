--[[
	群战
	Author: H.X.Sun
]]

local WarGroupController = qy.class("WarGroupController", qy.tank.controller.BaseController)

local model = qy.tank.model.WarGroupModel

function WarGroupController:ctor(delegate)
    WarGroupController.super.ctor(self)
    print("WarGroupController:ctor")
    self.viewStack = qy.tank.widget.ViewStack.new()
    self.viewStack:addTo(self)

    self.mainView = qy.tank.view.war_group.BattleView.new({
        ["dismiss"] = function()
            self.viewStack:pop()
            self.viewStack:removeFrom(self)
            self:finish()
        end,
    })
    self.viewStack:push(self.mainView)
end

return WarGroupController
