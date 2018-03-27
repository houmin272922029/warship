--[[
	统一帮助类
]]
local DiamondDialog = qy.class("DiamondDialog", qy.tank.view.BaseDialog, "view/common/DiamondDialog")

function DiamondDialog:ctor(delegate)
    DiamondDialog.super.ctor(self)

	self:InjectView("titleTxt")
	self:InjectView("scrollView")

	 --使用
    self:OnClick("Button_1", function(sender)
        self:dismiss()
    end)

     --使用
    self:OnClick("Button_2", function(sender)
        self:dismissAll()
        qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.RECHARGE)
    end)
end

return DiamondDialog
