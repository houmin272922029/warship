--[[
	充值 cell
	Author: H.X.Sun
	Date: 2015-09-09
--]]
local RechargeCell = qy.class("RechargeCell", qy.tank.view.BaseView, "view/recharge/RechargeCell")

function RechargeCell:ctor(delegate)
	RechargeCell.super.ctor(self)
	
	self.model = qy.tank.model.RechargeModel
	self.num = self.model:getPaymentDataNum()

	for i = 1, 2 do
		self:InjectCustomView("item_" .. i, qy.tank.view.recharge.RechargeItem, {
			["isTouchMoved"] = function()
                return delegate:isTouchMoved()
            end,
		})
	end
end

function RechargeCell:render(idx)
	local _index_1 = idx * 2 + 1
	if self.num >= _index_1  then
		self["item_1"]:setVisible(true)
		self["item_1"]:render(self.model:getPaymentDataByIndex(_index_1))
	else
		self["item_1"]:setVisible(false)
	end
	print("idx ====", _index_1)

	local _index_2 = idx * 2 + 2
	if self.num >= _index_2 then
		self["item_2"]:setVisible(true)
		self["item_2"]:render(self.model:getPaymentDataByIndex(_index_2))
	else
		self["item_2"]:setVisible(false)
	end
	print("otherIdx ====", _index_2)
end

return RechargeCell