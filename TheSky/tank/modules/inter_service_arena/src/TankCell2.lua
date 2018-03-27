--[[
	车库坦克列表cell
	Author: Your Name
	Date: 2015-03-20 11:58:36
]]

local TankCell2 = qy.class("TankCell2", qy.tank.view.BaseView, "inter_service_arena.ui.TankCell")

function TankCell2:ctor()
    TankCell2.super.ctor(self)

	self:InjectView("bg")
	self:InjectView("tankName")
	self:InjectView("tankImg")
	self:InjectView("tankLevel")
	self.model = qy.tank.model.GarageModel

end


function TankCell2:render(entity)
	self.tankImg:removeAllChildren()
        self.tank_id = entity.tank_id
		if entity.advance_level and entity.advance_level > 0 then
	        self.tankName:setString(entity.name .. "  +" .. entity.advance_level)
	    else
	        self.tankName:setString(entity.name)
	    end
		self.tankName:setString(entity.name)
		self.tankName:setColor(qy.tank.utils.ColorMapUtil.qualityMapColor(entity.quality))
		self.tankLevel:setString("LV."..entity.level)
		print(entity.level)
		if entity.icon then
			self.tankImg:setTexture("tank/icon/icon_t"..entity.icon..".png")
		else
			--直接用最粗暴的方式
			self.tankConfig = qy.tank.config.MonsterConfig.getItem(0,tostring(entity.tank_id))
			local id = self.tankConfig.icon
			self.tankImg:setTexture("tank/icon/icon_t"..id..".png")
		end

		self.bg:loadTexture("tank/bg/bg" .. entity.quality .. ".png")
end

return TankCell2
