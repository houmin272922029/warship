--[[--
--购买提示cell
--Author: H.X.Sun
--Date: 2015-06-24
--]]--
local BuyTips = qy.class("BuyTips", qy.tank.view.BaseView, "market/ui/BuyTips")

function BuyTips:ctor(delegate)
	BuyTips.super.ctor(self)

	self:InjectView("num")
	self:InjectView("icon")
	self:InjectView("name")
	self:InjectView("txt")

	self.num:setString(delegate.sale)
	self.name:setString(delegate.entity.name)
	self.name:setTextColor(delegate.entity:getFontColor())
	self.icon:setTexture(delegate.coinUrl)
	self.txt:setPosition(self.name:getPositionX() + self.name:getContentSize().width, self.name:getPositionY())
end

return BuyTips