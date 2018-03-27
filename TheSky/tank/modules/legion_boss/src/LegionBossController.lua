--[[
	世界boss
	Author: Aaron Wei
	Date: 2015-12-01 16:09:56
]]

local LegionBossController = qy.class("LegionBossController", qy.tank.controller.BaseController)

function LegionBossController:ctor(delegate)
    LegionBossController.super.ctor(self)
	print("LegionBossController:ctor")
    self.viewStack = qy.tank.widget.ViewStack.new()
    self.viewStack:addTo(self)

    self.model = qy.tank.model.LegionBossModel

    self.view = require("legion_boss.src.LegionBossView").new({
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

function LegionBossController:onCleanup()
    qy.tank.utils.cache.CachePoolUtil.removePlist("Resources/arena/arena",1)
    qy.tank.utils.cache.CachePoolUtil.removeTextureForKey("Resources/arena/JJC_0021.jpg")
    qy.tank.utils.cache.CachePoolUtil.removeTextureForKey("Resources/bg/JJC_22.jpg")
end

return LegionBossController
