--[[--
    周年庆
--]]--


local Dialog = qy.class("Dialog", qy.tank.view.BaseDialog, "anniver_pay/ui/Layer")



function Dialog:ctor(delegate)
    Dialog.super.ctor(self)
    self.model = qy.tank.model.AnniverPayModel
    self.service = qy.tank.service.AnniverPayService

    self:InjectView("Txt_time")

	self:OnClick("Btn_close", function(sender)
        self:removeSelf()
    end,{["isScale"] = false})

    self:OnClick("Btn_gopay", function(sender)
        self:removeSelf()
        qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.RECHARGE)
    end,{["isScale"] = false})

    self.Txt_time:setString(os.date("%Y.%m.%d", self.model.startTime) .."-" .. os.date("%Y.%m.%d", self.model.endTime))
    

end



function Dialog:update()

end




return Dialog