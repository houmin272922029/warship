--[[
	火炬行动
	Author: Aaron Wei
	Date: 2016-01-08 14:20:02
]]

local TorchPurchase1 = qy.class("TorchPurchase1", qy.tank.view.BaseView, "torch.ui.TorchPurchase1")

function TorchPurchase1:ctor(delegate)
    TorchPurchase1.super.ctor(self)
    self.model = require("torch.src.TorchModel")
    self.service = require("torch.src.TorchService")
    self.today = self.model.day

    
    self:InjectView("purchaseBtn")
    self:InjectView("price1")
    self:InjectView("price2")
    -- self:InjectView("tip")
    self:InjectView("purchasedIcon")

   	self:OnClick("purchaseBtn", function()
        delegate.onPurchase()
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = true})
end

function TorchPurchase1:render(data)
	if not tolua.cast(self.awardList,"cc.Node") then
        self.awardList = qy.AwardList.new({
            ["award"] =  data.award,
            ["hasName"] = true,
            ["type"] = 2,
            ["cellSize"] = cc.size(140,100),
            ["itemSize"] = 1, 
        })
        self.awardList:setPosition(-135,290)
        self:addChild(self.awardList,0)
   	else
   		self.awardList:update(data.award)
   	end

	self.price1:setString(tostring(data.price))
	self.price2:setString(tostring(data.old_price))
	-- self.tip:setString("仅限前"..tostring(data.num).."人购买（剩余"..tostring(data.num-data.buy).."件）")

    if self.model.my_buy[tostring(data.id)] == 1 then
        self.purchaseBtn:setVisible(false)
        self.purchasedIcon:setVisible(true)
        -- self.purchaseBtn:setTouchEnabled(false)
    else
        self.purchaseBtn:setVisible(true)
        self.purchasedIcon:setVisible(false)
        -- self.purchaseBtn:setTouchEnabled(true)
    end
end

return TorchPurchase1

