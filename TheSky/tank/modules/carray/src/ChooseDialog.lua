local ChooseDialog = qy.class("ChooseDialog", qy.tank.view.BaseDialog)

function ChooseDialog:ctor(delegate)
   	ChooseDialog.super.ctor(self)
    -- self:setCanceledOnTouchOutside(true)

     -- 通用弹窗样式
    local style = qy.tank.view.style.DialogStyle2.new({
        size = cc.size(830, 515),
        position = cc.p(0, 0),
        offset = cc.p(0, 0),
        titleUrl = "carray/res/jieshouweipai.png",

        ["onClose"] = function()
            self:dismiss()
        end
    })
    self:addChild(style)
    style:setLocalZOrder(-1)
    self.style = style
   	
    style:changeHeadBgSize(85)
    self.delegate = delegate
    local view = require("carray.src.ChooseDialog2").new(self, delegate)

    style:addChild(view)
end

function ChooseDialog:update()
    self.delegate:update()
end

return ChooseDialog
