--[[
	射门
	Aaron Wei 
	Date: 2016-09-20 17:47:41
]]

local GameGoalController = qy.class("GameGoalController", qy.tank.controller.BaseController)

function GameGoalController:ctor(delegate)
    GameGoalController.super.ctor(self)
	print("GameGoalController:ctor")
    self.viewStack = qy.tank.widget.ViewStack.new()
    self.viewStack:addTo(self)

    self.model = qy.tank.model.OlympicModel

    self.view = require("olympic.src.GameGoalView").new({
    	["dismiss"] = function()
            self.viewStack:pop()
            self.viewStack:removeFrom(self)
            self:finish()
        end,
        
     --    ["getAward"] = function()
     --        local service = qy.tank.service.ArenaService
     --        service:drawAward(function(data)
     --            qy.tank.command.AwardCommand:add(data.award)
     --            -- qy.tank.command.AwardCommand:show(data.award)
     --            self.view:render()

     --            self.awardView = qy.tank.view.arena.ArenaAwardView.new({
     --                ["dismiss"] = function()
     --                    self.viewStack:pop()
     --                end,
     --                ["awards"] = data.award, 
     --                ["show_awards"] = data.show_award
     --            })
     --            self.viewStack:push(self.awardView)
     --        end)
     --    end
    })
    self.viewStack:push(self.view)
end

function GameGoalController:onCleanup()
end

return GameGoalController

