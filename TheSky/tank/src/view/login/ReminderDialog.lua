--[[--
--温馨提示dialog
--Author: H.X.Sun
--Date: 2015-07-28
--]]

local ReminderDialog = qy.class("ReminderDialog", qy.tank.view.BaseDialog, "view/login/ReminderDialog")

function ReminderDialog:ctor(delegate)
    ReminderDialog.super.ctor(self)

    self:setBGOpacity(0)

	self:InjectView("container")
	self:InjectView("tips")

	qy.tank.utils.TextUtil:autoChangeLine(self.tips , cc.size(420 , 80))
	self.tips:setTextHorizontalAlignment(1)
	self.tips:setTextVerticalAlignment(1)
	self.tips:enableOutline(cc.c4b(0, 0, 0,255),1)

	--确定
	self:OnClick("confirmBtn", function()
		qy.tank.utils.QYSDK.visitorLogin(1, function()
			self:dismiss()
			qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.ENTER_GAME)
        end, {["isScale"] = false})
	end, {["isScale"] = false})

	--返回
	self:OnClick("returnBtn", function()
		self:dismiss()
	end, {["isScale"] = false})
end

return ReminderDialog
