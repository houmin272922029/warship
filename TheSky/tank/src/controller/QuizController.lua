--[[
    知识竞赛
]]
local QuizController = qy.class("QuizController", qy.tank.controller.BaseController)

function QuizController:ctor(data)
    QuizController.super.ctor(self)

    self.viewStack = qy.tank.widget.ViewStack.new()
    self.viewStack:addTo(self)

    self.viewStack:push(qy.tank.view.quiz.MainDialog.new({
        ["dismiss"] = function()
            self.viewStack:pop()
        	self.viewStack:removeFrom(self)
            self:finish()
        end
    }))

end

return QuizController
