--[[
    抗日远征
]]
local FightJapanController = qy.class("FightJapanController", qy.tank.controller.BaseController)

function FightJapanController:ctor(data)
    FightJapanController.super.ctor(self)

    self.viewStack = qy.tank.widget.ViewStack.new()
    self.viewStack:addTo(self)

    self.viewStack:push(qy.tank.view.fightJapan.FightJapanView.new({
        ["dismiss"] = function()
            self.viewStack:pop()
        	self.viewStack:removeFrom(self)
            self:finish()
        end,
        ["showSpeak"] = function()
            qy.tank.view.fightJapan.SpeakDialog.new():show()
        end,
        }))
end



return FightJapanController
