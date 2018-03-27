--[[
	射门
	Author: Aaron Wei
	Date: 2016-09-22 14:18:41
]]

local GameShootController = qy.class("GameShootController", qy.tank.controller.BaseController)

function GameShootController:ctor(delegate)
    GameShootController.super.ctor(self)
	print("GameShootController:ctor")
    self.viewStack = qy.tank.widget.ViewStack.new()
    self.viewStack:addTo(self)

    self.model = qy.tank.model.OlympicModel

    self.view = require("olympic.src.GameShootView").new({
    	["dismiss"] = function()
            self.viewStack:pop()
            self.viewStack:removeFrom(self)
            self:finish()
        end,
    })
    self.viewStack:push(self.view)
end

function GameShootController:onCleanup()
end

return GameShootController


