--[[
	tank item3 继承tankItem 进行扩展
	Author: mingming 
	Date: 2015-08-24
--]]
local TankItem3 = qy.class("TankItem3", qy.tank.view.BaseView, "view/common/TankItem3")

function TankItem3:ctor(params)
	self:InjectView("AlreadyGet")
	self:InjectView("Info")
	self:InjectCustomView("Tank", qy.tank.view.common.TankItem)
end

function TankItem3:setData(data)
	-- data.namePos = 2
	if not data.notPic then
		data.scale = 0.95
		-- self:InjectCustomView("Tank", qy.tank.view.common.TankItem, data)
		self.AlreadyGet:setVisible(data.entity.isOwn or false)
		if not data.entity.isOwn then
			self.Tank.fatherSprite:setColor(cc.c4b(164, 164, 164, 0))
		else
			self.Tank.fatherSprite:setColor(cc.c4b(255, 255, 255, 0))
		end
		self.Tank.fatherSprite:setSwallowTouches(false)
	else
		self.AlreadyGet:setVisible(false)
		data.namePos = 2
		data.scale = 1
		self.Info:setVisible(data.advanceStatus)
	end
	self.Tank:update(data)
end

function TankItem3:setAdvance(flag)
	-- self.Info:setVisible(flag)
	self.Info:setOpacity(0)
end

function TankItem3:playAvanceAnimate()
	self.Info:setVisible(true)
	local seq = cc.Sequence:create(cc.FadeIn:create(0.5), cc.FadeOut:create(0.5))
	self.Info:runAction(seq)
end

return TankItem3