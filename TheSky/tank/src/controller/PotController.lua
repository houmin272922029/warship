--[[
    大锅饭
]]
local PotController = qy.class("PotController", qy.tank.controller.BaseController)

function PotController:ctor(data)
    PotController.super.ctor(self)

    self.viewStack = qy.tank.widget.ViewStack.new()
    self.viewStack:addTo(self)
    
    self.viewStack:push(qy.tank.view.pot.PotView.new({
        ["dismiss"] = function()
            self.viewStack:pop()
        	self.viewStack:removeFrom(self)
            self:finish()
        end,
        }))
end

return PotController
