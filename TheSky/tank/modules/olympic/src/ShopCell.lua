--[[
	军奥商城cell
	Author: Aaron Wei
	Date: 2016-09-14 14:17:08
]]


local ShopCell = qy.class("ShopCell", qy.tank.view.BaseView, "olympic.ui.ShopCell")

function ShopCell:ctor(delegate)
	print("ShopCell:ctor")
    ShopCell.super.ctor(self)

	self.delegate = delegate
	self.service = qy.tank.service.OlympicService

	self:InjectView("bg")
	self:InjectView("mark")
	self:InjectView("limit")
	self:InjectView("propName")
	self:InjectView("exchangeNum")
	self:InjectView("remainTitle")
	self:InjectView("remain")
	self:InjectView("exchangeBtn")

	self:OnClick("exchangeBtn",function(sender)
		self.service:exchange(self.data.id,function(data)
			self.delegate.exchange(data)
		end)
	end, {["isScale"] = false})
end

function ShopCell:render(data)
	self.data = data
	if self.item and tolua.cast(self.item,"cc.Node") and self.item:getParent() then
		self.bg:removeChild(self.item)
	end

	self.item = qy.tank.view.common.AwardItem.createAwardView(data.award[1],1,1,false)
	self.bg:addChild(self.item,0)
	self.mark:setLocalZOrder(1)
	self.item:setPosition(75,78)
	self.item:showTitle(false)

	self.propName:setString(qy.tank.view.common.AwardItem.getItemData(data.award[1]).name)
	self.exchangeNum:setString(tostring(data.number))
	self.remain:setString(tostring(data.num))

	-- local x,y = self.exchangeBtn:getPosition()
	if data.pay_limit > 0 then
		self.mark:setVisible(true)
		self.remainTitle:setVisible(true)
		self.remain:setVisible(true)
		self.exchangeBtn:setPosition(518,57)
		self.limit:setString("限购"..tostring(data.remain).."个")
	else
		self.mark:setVisible(false)
		self.remainTitle:setVisible(false)
		self.remain:setVisible(false)
		self.exchangeBtn:setPosition(518,57+25)
	end

end

return ShopCell
