--[[
--描述
--Author: H.X.Sun
--Date: 2015-05-21
]]

local TankTipCell = qy.class("TankTipCell", qy.tank.view.BaseView, "match_fight_power/ui/TankTipCell")

function TankTipCell:ctor(entity)
    TankTipCell.super.ctor(self)

    self:InjectView("tankName")
	self:InjectView("tankType")
	self:InjectView("attack")
	self:InjectView("defense")
	self:InjectView("blood")
	for i = 1, 6 do
		self:InjectView("star" .. i)
	end

	self.tankName:setString(entity.name)
	self.tankName:setColor(entity:getFontColor())
	-- 战车类型
	self.tankType:setString(entity.typeName)
	-- 战车星级
	self:setStar(entity.star)
	-- 攻击力
	self.attack:setString(tostring(entity:getInitialAttack()))
	-- 防御力
	self.defense:setString(tostring(entity:getInitialDefense()))
	-- 生命力
	self.blood:setString(tostring(entity:getInitialBlood()))
end

function TankTipCell:setStar(value)
    for i = 1,6 do
        if i <= value then
            self["star"..i]:setVisible(true)
        else
            self["star"..i]:setVisible(false)
        end
    end
end

return TankTipCell