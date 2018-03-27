--[[
	查看资料
	Author: Aaron Wei
	Date: 2015-09-09 14:35:31
]]

local ArenaController = qy.class("ArenaController", qy.tank.controller.BaseController)

function ArenaController:ctor(delegate)
    ArenaController.super.ctor(self)
	print("ArenaController:ctor")
    self.viewStack = qy.tank.widget.ViewStack.new()
    self.viewStack:addTo(self)
    self.model = qy.tank.model.ArenaModel

    self.view = qy.tank.view.arena.ArenaView.new({
    	["dismiss"] = function()
            self.viewStack:pop()
            self.viewStack:removeFrom(self)
            self:finish()
        end,

        ["getAward"] = function()
            local service = qy.tank.service.ArenaService
            service:drawAward(function(data)
                self.view:render()
                qy.tank.command.AwardCommand:add(data.award)
                qy.tank.command.AwardCommand:show(data.award)
            end)
        end
    })
    self.viewStack:push(self.view)
end

return ArenaController
