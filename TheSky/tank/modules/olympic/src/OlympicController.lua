--[[
	军奥会
	Author: Aaron Wei
	Date: 2016-9-12 15:15:56
]]

local OlympicController = qy.class("OlympicController", qy.tank.controller.BaseController)

function OlympicController:ctor(delegate)
    OlympicController.super.ctor(self)
	print("OlympicController:ctor")
    self.viewStack = qy.tank.widget.ViewStack.new()
    self.viewStack:addTo(self)

    self.model = qy.tank.model.OlympicModel

    self.view = require("olympic.src.OlympicView").new({
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

function OlympicController:onCleanup()
end

return OlympicController
