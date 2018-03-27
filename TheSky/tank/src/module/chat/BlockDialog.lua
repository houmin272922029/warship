local BlockDialog = qy.class("BlockDialog", qy.tank.view.BaseDialog, "view.chat.BlockDialog")

local DialogStyle5 = qy.tank.view.style.DialogStyle5

function BlockDialog:ctor(cb)
    BlockDialog.super.ctor(self)
    self:setCanceledOnTouchOutside(true)
    
    DialogStyle5.new({
        size = cc.size(440,330),
        position = cc.p(0,0),
        offset = cc.p(0,0)
    }):addTo(self, -1)

    self:OnClick("Btn_ok", function()
        cb()
        self:dismiss()
    end)

    self:OnClick("Btn_close", function()
        self:dismiss()
    end)
end

return BlockDialog
