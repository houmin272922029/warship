--[[
	军需商店道具&装备cell
	Author: Aaron Wei
	Date: 2015-05-13 16:41:49
]]

local PropShopCell = qy.class("PropShopCell", qy.tank.view.BaseView, "view/shop/PropShopCell")

function PropShopCell:ctor(entity)
    PropShopCell.super.ctor(self)

	self.entity = entity
	self:InjectView("light")
	self:InjectView("bg")
	self:InjectView("icon")
	self:InjectView("vipExclusive")

	self:createEquipSuitEffert()
	
	self:render(entity)
end

function PropShopCell:render(entity, index)
	self.light:setVisible(false)
	if entity.props then
		self.icon:setTexture(entity.props:getIcon())
		self.bg:setSpriteFrame(entity.props:getIconBG())
	elseif entity.equip then
		self.icon:setTexture(entity.equip:getIcon())
		self.bg:setSpriteFrame(entity.equip:getIconBg())
	end
	if entity.vip_limit > 0 then
		self.vipExclusive:setSpriteFrame("Resources/shop/Vbuy_icon_" .. entity.vip_limit .. ".png")
		self.vipExclusive:setVisible(true)
	else
		self.vipExclusive:setVisible(false)
	end
	
	if entity.vip_limit == 8 and index == 5 then
		self._effert:setVisible(true)
	else
		self._effert:setVisible(false)
	end

end

function PropShopCell:createEquipSuitEffert()
	local _effert = ccs.Armature:create("Flame")
	self.icon:addChild(_effert)
	_effert:setPosition(51,49)
	self._effert = _effert
	_effert:getAnimation():playWithIndex(0)
end

return PropShopCell                   

