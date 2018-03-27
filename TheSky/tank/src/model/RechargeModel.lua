--[[
    充值 model
    Author: H.X.Sun
    Date: 2015-08-24
]]

local RechargeModel = class("RechargeModel", qy.tank.model.BaseModel)

function RechargeModel:init()
	self.paymentData = {}
	local data = {}
	if qy.product == "sina" then
		-- 新浪
		data = qy.Config.payment_sina
	elseif qy.product == "local" or qy.product == "develop" then
		-- 开发服
		if qy.language == "en" then
			-- 英文开发服
			data = qy.Config.payment_xiaoao
		else
			-- 中文开发服
			data = qy.Config.payment_dev
		end
	elseif qy.product == "oversea" or qy.product == "oversea-test" then
		-- 海外
		data = qy.Config.payment_xiaoao
	else
		-- 混服
		data = qy.Config.payment_prod
	end

	for _k, _v in pairs(data) do
		self.paymentData[_v.index] = _v
	end
	self.data = data
end

function RechargeModel:updateRechargeInfo(data)
	self.firstPayment = {}
	if data and data.payment_diamond_added_first then
		self.firstPayment = data.payment_diamond_added_first
	end
end

function RechargeModel:isFirstPayment(_productId)
	if self.firstPayment == nil then
		return true
	end

	for i = 1, #self.firstPayment do
		if self.firstPayment[i] == _productId then
			return false
		end
	end
	return true
end

function RechargeModel:getPaymentDataByIndex(_index)
	return self.paymentData[_index]
end

function RechargeModel:getPaymentDataNum()
	return #self.paymentData
end

return RechargeModel
