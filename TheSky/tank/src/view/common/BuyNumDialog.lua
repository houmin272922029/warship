--[[
    仓库弹框
    Author: Aaron Wei
	Date: 2015-06-29 18:10:18
]]

local BuyNumDialog = qy.class("BuyNumDialog", qy.tank.view.BaseDialog, "widget/BuyNumDialog")

function BuyNumDialog:ctor(num,callback)
    BuyNumDialog.super.ctor(self)

	self:setCanceledOnTouchOutside(true)

    -- 内容样式
    self:InjectView("panel")
    self.panel:setLocalZOrder(1)
    self.panel:setSwallowTouches(false)

    self:OnClick("closeBtn", function(sender)
    	self:dismiss()
    end)

    self:OnClick("purchaseBtn", function(sender)
        self:dismiss()
        callback()
    end)
end

return BuyNumDialog

