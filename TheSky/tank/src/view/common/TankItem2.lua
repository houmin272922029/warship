--[[
	tank item2 继承tankItem 进行扩展
	Author: mingming 
	Date: 2015-08-24
--]]
local TankItem2 = qy.class("TankItem2", qy.tank.view.BaseView, "view/common/TankItem2")

function TankItem2:ctor(delegate)
	self:InjectView("Attribute")
	self:InjectView("AlreadyGet")
	self:InjectCustomView("Tank", qy.tank.view.common.TankItem)

	self.delegate = delegate

end

function TankItem2:update(params)
	if params and params.entity then
		params.namePos = 2
		params.scale = 0.824

		params.callback = function()
			self.delegate.callback(params.entity)
		end
		
		local num = params.entity.tujian_val
		if params.entity.tujian_type == 6 or params.entity.tujian_type == 7 then
			num = num / 10 .. "%"
		end
		self.Attribute:setString(qy.tank.model.AchievementModel.attrTypes[tostring(params.entity.tujian_type)] .. "+" .. num)
		self.AlreadyGet:setVisible(params.entity.isOwn)

		local color = not params.entity.isOwn and cc.c4b(164, 164, 164, 0) or cc.c4b(255, 255, 255, 255)
		self.Tank.fatherSprite:setColor(color)
		-- self.Attribute:setColor(color)
		self.Tank.fatherSprite:setSwallowTouches(false)

		self.Tank:update(params)
	end

	
end

return TankItem2