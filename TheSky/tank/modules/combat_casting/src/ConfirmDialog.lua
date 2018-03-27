local ConfirmDialog = qy.class("ConfirmDialog", qy.tank.view.BaseDialog, "combat_casting.ui.ConfirmDialog")


function ConfirmDialog:ctor(callback, delegate)
   	ConfirmDialog.super.ctor(self)

    self:InjectView("CheckBox")

    self:OnClick("Btn_close", function()
        self:dismiss()
    end,{["isScale"] = false})

    self:OnClick("Btn_buy", function()
        callback()
        self:dismiss()
    end,{["isScale"] = false})


    self:OnClick("CheckBox", function(sender)
        self.flag = self.CheckBox:isSelected()
        delegate.flag2 = self.flag and 1 or 0
    end,{["isScale"] = false}) 
end


return ConfirmDialog
