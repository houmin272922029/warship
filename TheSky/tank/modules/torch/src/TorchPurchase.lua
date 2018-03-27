--[[
	火炬行动
	Author: Aaron Wei
	Date: 2016-01-08 14:20:02
]]

local TorchPurchase = qy.class("TorchPurchase",cc.Node)

function TorchPurchase:ctor(idx)
    self:setIdx(idx)
end

function TorchPurchase:setIdx(idx)
	if idx == 7 then
		if not tolua.cast(self.purchase2,"cc.Node") then
    		self.purchase2 = require("torch.src.TorchPurchase2").new()
    		self:addChild(self.purchase2)
    	end
    	self.purchase2:render()
    else
    	if not tolua.cast(self.purchase1,"cc.Node") then
    		self.purchase1 = require("torch.src.TorchPurchase1").new()
    		self:addChild(self.purchase1)
    	end
    	self.purchase1:render()
    end
end

return TorchPurchase

