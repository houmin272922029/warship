--[[--
	
--]]--

local ZPGiftCellMax = qy.class("ZPGiftCellMax", qy.tank.view.BaseView, "fire_rebate/ui/ZPGiftCellMax")

function ZPGiftCellMax:ctor(delegate)
    ZPGiftCellMax.super.ctor(self)
    self:InjectView("ConNum")
    self:InjectView("bg")
    self:InjectView("Day")
    self:InjectView("YiLingqu")
    self:InjectView("Sprite_1")
end

--[[
	signState 签到状态 
]]--
function ZPGiftCellMax:render(idx, data, signState )
	self.Sprite_1:setVisible(false)
    self.ConNum:setString("")
    self.Day:setString("第"..idx.."天")

    if self.mitem == nil then
	 	local item = qy.tank.view.common.AwardItem.createAwardView(data ,1)
	  	item:setPosition(self.Sprite_1:getPosition())
	  	item:setScale(0.7)
	  	item.fatherSprite:setSwallowTouches(false)
	  	item.name:setVisible(false)
	  	self.bg:addChild(item)
	  	self.mitem = item
	end

	-- 0 不可以，1 可以签到，2 签过
	if signState == 0 then
	
	elseif signState == 1 then

	else
		self.YiLingqu:setVisible(true)
	end

end
function ZPGiftCellMax:SetBgCentSize(size)
    self.bg:setString("cc")
end
return ZPGiftCellMax