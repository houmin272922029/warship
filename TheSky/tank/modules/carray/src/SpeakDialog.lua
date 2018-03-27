local SpeakDialog = qy.class("SpeakDialog", qy.tank.view.BaseDialog, "carray.ui.SpeakDialog")

function SpeakDialog:ctor()
   	SpeakDialog.super.ctor(self)
    self:setCanceledOnTouchOutside(true)
end

return SpeakDialog
