--[[
	Author: Aaron Wei
	Date: 2015-12-11 17:44:52
]]

local ReputationTankTip = qy.class("ReputationTankTip", qy.tank.view.BaseView, "view/shop/ReputationTankTip")

function ReputationTankTip:ctor(delegate)
	ReputationTankTip.super.ctor(self)

	self:InjectView("part1")
	self:InjectView("price_1")
	self:InjectView("icon_1")
	self:InjectView("icon_2")
	self:InjectView("price_2")
	self:InjectView("part2")
	self:InjectView("name")
	self:InjectView("part3")
	self:InjectView("node")

	self.part1:setPositionX(0)
	local w = self.part1:getContentSize().width

	self.price_1:setString(tostring(delegate.orange_iron))
	self.price_1:setPositionX(w)
	w = w + self.price_1:getContentSize().width

	self.icon_1:setPositionX(w+17)
	-- w = w + self.icon:getPreferSize().width
	w = w + 30

	self.price_2:setString(tostring(delegate.reputation))
	self.price_2:setPositionX(w)
	w = w + self.price_2:getContentSize().width

	self.icon_2:setPositionX(w+17)
	w = w + 30

	local w2 = self.part2:getContentSize().width
	self.part2:setPositionX(0)
	-- self.part2:setPositionX(w)
	-- w = w + self.part2:getContentSize().width

	self.name:setString(delegate.tank.name)
	self.name:setTextColor(delegate.tank:getFontColor())
	self.name:setPositionX(w2)
	w2 = w2 + self.name:getContentSize().width

	self.part3:setPositionX(w2)
	w2 = w2 + self.part3:getContentSize().width

	-- self.node:setPositionX((560-w)/2)
	self.node:setPosition(-w/2,-40)
end

return ReputationTankTip
