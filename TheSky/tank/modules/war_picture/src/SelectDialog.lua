local SelectDialog = qy.class("SelectDialog", qy.tank.view.BaseDialog, "war_picture.ui.SelectDialog")


function SelectDialog:ctor(callback)
   	SelectDialog.super.ctor(self)


    self:OnClick("Btn_close", function()
        self:removeSelf()
    end,{["isScale"] = false})

    self:OnClick("Btn_buy", function()
        callback()
        self:removeSelf()
    end,{["isScale"] = false})

end

return SelectDialog
