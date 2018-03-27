--[[
	火炬行动
	Author: Aaron Wei
	Date: 2016-01-08 14:20:02
]]

local TorchPurchase2 = qy.class("TorchPurchase2", qy.tank.view.BaseView, "torch.ui.TorchPurchase2")

function TorchPurchase2:ctor(delegate)
    TorchPurchase2.super.ctor(self)
    self.model = require("torch.src.TorchModel")
    self.service = require("torch.src.TorchService")
    self.today = self.model.day
    self.chooseDay = self.model.day
    
    self:InjectView("purchaseBtn")
    self:InjectView("purchasedIcon")

   	self:OnClick("purchaseBtn", function()
        delegate.onPurchase()
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = true})

    self:OnClick("previewBtn", function()
        local preview = require("torch.src.PreviewDialog").new()
        preview:show()
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = true})
end

function TorchPurchase2:render(data)
    if self.model.my_buy[tostring(data.id)] == 1 then
        self.purchaseBtn:setVisible(false)
        self.purchasedIcon:setVisible(true)
    else
        self.purchaseBtn:setVisible(true)
        self.purchasedIcon:setVisible(false)
    end
end

return TorchPurchase2

