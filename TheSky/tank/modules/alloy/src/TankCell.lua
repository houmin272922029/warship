--[[--
	tank
	Author: H.X.Sun
--]]--

local TankCell = qy.class("TankCell", qy.tank.view.BaseView, "alloy/ui/TankCell")

function TankCell:ctor(params)
	self:InjectView("light")
	self:InjectView("bg")
	self:InjectView("icon")
	self:InjectView("level")
	self:InjectView("name")
	self:InjectView("reform_num")
	self:InjectView("reform_bg")
end

function TankCell:render(entity)
	if entity == nil or tonumber(entity) then
		self.name:setString("")
		self.level:setString("")
		self.icon:setTexture("Resources/common/bg/c_12.png")
		self.bg:setTexture("tank/bg/bg1.png")
		if qy.InternationalUtil:hasTankReform() then
            self.reform_bg:setVisible(false)
        end
	else
		self.tank_id = entity.tank_id
		self.name:setString(entity.name)
		self.name:setColor(entity:getFontColor())
		self.level:setString("LV."..entity.level)
		self.icon:setTexture(entity:getIcon())
		self.bg:setTexture(entity:getIconBg())

		if qy.InternationalUtil:hasTankReform() then
			if entity.reform_stage == 0 then
				self.reform_bg:setVisible(false)
			else
				self.reform_bg:setVisible(true)
            	self.reform_num:setString(entity.reform_stage)
			end
        end
	end
end

return TankCell
