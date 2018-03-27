--[[
	最强之战-网络异常
	Author: H.X.Sun
]]

local ErrorDialog = qy.class("ErrorDialog", qy.tank.view.BaseDialog, "greatest_race/ui/ErrorDialog")

function ErrorDialog:ctor(delegate)
    ErrorDialog.super.ctor(self)
    self.model = qy.tank.model.GreatestRaceModel

    self:InjectView("tip")
    self.tip:setString(qy.TextUtil:substitute(90210))
    self:OnClick("btn", function()
        self:update()
    end)
end

function ErrorDialog:update()
    qy.Event.dispatch(qy.Event.GREATEST_RACE_UPDATE,true)
    self:dismiss()
end

function ErrorDialog:onEnter()
    self.timer1 = qy.tank.utils.Timer.new(30,1,function()
        self:update()
    end)
    self.timer1:start()
    self.model:setErrorStatus(true)
end

function ErrorDialog:onExit()
    self.model:setErrorStatus(false)
    self.timer1:stop()
end

return ErrorDialog
