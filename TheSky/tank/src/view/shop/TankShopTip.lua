--[[
	Author: Aaron Wei
	Date: 2015-12-11 17:44:52
]]

local TankShopTip = qy.class("TankShopTip", qy.tank.view.BaseView, "view/shop/TankShopTip")

function TankShopTip:ctor(delegate)
	TankShopTip.super.ctor(self)

	self:InjectView("part1")
	self:InjectView("price")
	self:InjectView("icon")
	self:InjectView("part2")
	self:InjectView("name")
	self:InjectView("part3")
	self:InjectView("node")

	self.part1:setPositionX(0)
	local w = self.part1:getContentSize().width

	self.price:setString(tostring(delegate.number))
	self.price:setPositionX(w)
	w = w + self.price:getContentSize().width

	self.icon:initWithFile(tostring(delegate.priceIcon))
	self.icon:setPositionX(w+17)
	-- w = w + self.icon:getPreferSize().width
	w = w + 30

	self.part2:setPositionX(w)
	w = w + self.part2:getContentSize().width

	self.name:setString(delegate.tank.name)
	self.name:setTextColor(delegate.tank:getFontColor())
	self.name:setPositionX(w)
	w = w + self.name:getContentSize().width

	self.part3:setPositionX(w)
	w = w + self.part3:getContentSize().width
	
	-- self.node:setPositionX((560-w)/2)
	self.node:setPosition(-w/2,-50)
end

return TankShopTip