local InputNameDialog = qy.class("InputNameDialog", qy.tank.view.BaseDialog, "view.chat.InputNameDialog")

local DialogStyle5 = qy.tank.view.style.DialogStyle5

function InputNameDialog:ctor(cb)
    InputNameDialog.super.ctor(self)
    self:setCanceledOnTouchOutside(true)

    self:InjectView("Image_3")

    DialogStyle5.new({
        size = cc.size(460,200),
        position = cc.p(0,0),
        offset = cc.p(0,0),
        -- ["onClose"] = function()
        --     self:dismiss()
        -- end
    }):addTo(self, -1)

    local editBox = ccui.EditBox:create(cc.size(390, 40), ccui.Scale9Sprite:create())
    editBox:setAnchorPoint(0, 0)
    editBox:setPosition(5, 5)
   	editBox:setFontSize(22)
    editBox:setPlaceHolder(qy.TextUtil:substitute(69001))
   	editBox:setPlaceholderFontSize(22)
   	editBox:setInputMode(6)
    if editBox.setReturnType then
        editBox:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    end
    editBox:addTo(self.Image_3)

    self:OnClick("Btn_ok", function()
        self:removeSelf()
        cb(editBox:getText())
    end)

    self:OnClick("Btn_reset", function()
        editBox:setText("")
    end)
end

return InputNameDialog
