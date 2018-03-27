local LegionSkillController = qy.class("LegionSkillController", qy.tank.controller.BaseController)

function LegionSkillController:ctor(delegate)
    LegionSkillController.super.ctor(self)
    
    self.viewStack = qy.tank.widget.ViewStack.new()
    self.viewStack:addTo(self)

    self.model = qy.tank.model.LegionBossModel

    self.view = require("legion_skill.src.SkillView").new({
    	["dismiss"] = function()
            self.viewStack:pop()
            self.viewStack:removeFrom(self)
            self:finish()
        end,
    })
    self.viewStack:push(self.view)
end

return LegionSkillController