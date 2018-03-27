--[[
	VIP每日津贴cell
	Author: Aaron Wei
	Date: 2015-06-11 12:41:08
]]

local VipAwardCell = qy.class("VipAwardCell", qy.tank.view.BaseView, "view/vip/VipAwardCell")

function VipAwardCell:ctor(delegate)	
    VipAwardCell.super.ctor(self)

	self:InjectView("bg")
	self:InjectView("vip_icon")

	for i=1,3 do
		self:InjectView("icon"..i)
		self:InjectView("num"..i)
	end

	self.vip = qy.tank.widget.Attribute.new({
        ["numType"] = 18,
        ["hasMark"] = 0, 
        ["value"] = 0,
    })
    self.vip:setPosition(self.vip_icon:getPositionX(),self.vip_icon:getPositionY())
    self:addChild(self.vip)
    self.vip:setScale(0.6)
    self.vip:setRotation(2)
end

function VipAwardCell:render(data)
	if data then
		-- self.vip:initWithSpriteFrameName("Resources/vip/v"..data.level..".png")
		self.vip:update(data.level)

		for i=1,3 do
			local icon = self["icon"..i]
			local num = self["num"..i]
			icon:setTexture(qy.tank.utils.AwardUtils.getAwardIconByType(data.daily_award[i].type))
			num:setString("x "..tostring(data.daily_award[i].num))
		end
	end
end

return VipAwardCell                   
