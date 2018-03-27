--[[--
--开服礼包cell
--Author: H.X.Sun
--Date: 2015-06-24
--]]--

local ZPGiftCell = qy.class("ZPGiftCell", qy.tank.view.BaseView, "fire_rebate/ui/ZPGiftCell")

function ZPGiftCell:ctor(delegate)
    ZPGiftCell.super.ctor(self)
    self:InjectView("ConNum")
    self:InjectView("Sprite_1")
    self:InjectView("bg")
    self.Sprite_1:setVisible(false)
end

function ZPGiftCell:render(idx,data)
    self.ConNum:setString("")

    if self.mitem == nil then
	 	local item = qy.tank.view.common.AwardItem.createAwardView(data ,1)
	  	item:setPosition(self.Sprite_1:getPosition())
	  	item:setScale(0.8)
	  	item.fatherSprite:setSwallowTouches(false)
        item.name:setVisible(false)
	  	self.mitem = item
	  	self.bg:addChild(item)
    end
end

function ZPGiftCell:Getpos()
    return self:getPosition()
end



return ZPGiftCell