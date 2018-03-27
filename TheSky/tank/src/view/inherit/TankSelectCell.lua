--[[
	车库坦克列表cell
	Author: Aaron Wei
	Date: 2015-03-20 20:02:10
]]

local TankSelectCell = qy.class("TankSelectCell", qy.tank.view.BaseView, "view/inherit/TankSelectCell")

local FightJapanModel = qy.tank.model.FightJapanModel
local VipModel = qy.tank.model.VipModel

function TankSelectCell:ctor(delegate)
    TankSelectCell.super.ctor(self)

	self.delegate = delegate
	self.entity = nil
	self:InjectView("bg")
	self:InjectView("tankName")
	self:InjectView("tankLevel")
	self:InjectView("tankStar")
	self:InjectView("tankIcon")
	self:InjectView("quality")
	self:InjectView("btn")
    self:InjectView("reform_num")
    self:InjectView("reform_bg")
    self:InjectView("levelTitle")
    self:InjectView("tank_fragment")
    self:InjectView("tankAdvance")
	local awardType = qy.tank.view.type.AwardType
	self.achieveModel = qy.tank.model.AchievementModel

	for i = 1,5 do
        self:InjectView("s"..i)
    end

	self:OnClick("btn", function(sender)
        self.delegate:set(self.entity)
    end)

    self:OnClick("quality", function(sender)
    	local itemData = {}
    	itemData.type = awardType.TANK
    	itemData.entity = self.entity
        qy.alert:showTip(qy.tank.utils.TipUtil.createTipContent(itemData))
    end)



	self.bg:setSwallowTouches(true)
	self.btn:setSwallowTouches(false)
	self.quality:setSwallowTouches(false)
end

function TankSelectCell:render(entity)
	if entity then
		self.entity = entity
		if entity.advance_level and entity.advance_level > 0 then
            self.tankName:setString(entity.name .. "  +" .. entity.advance_level)
        else
            self.tankName:setString(entity.name)
        end
		self.tankName:setTextColor(qy.tank.utils.ColorMapUtil.qualityMapColor(entity.quality))

		if entity.num and tonumber(entity.is_tank_fragment) == 1 then
			self.levelTitle:setString(qy.TextUtil:substitute(90260))
			self.tankLevel:setString(entity.num % qy.tank.model.GarageModel.tank_fragment_merge[entity.quality].." / "..qy.tank.model.GarageModel.tank_fragment_merge[entity.quality])
			self.tank_fragment:setVisible(true)
			self.btn:setVisible(false)
		else
			self.levelTitle:setString(qy.TextUtil:substitute(90259))
			self.tankLevel:setString(""..entity.level)
			self.tank_fragment:setVisible(false)
			self.btn:setVisible(true)
		end

		
		local res_id = qy.Config.tank[tostring(entity.tank_id)].icon
		self.tankIcon:setTexture("tank/icon/icon_t"..res_id..".png")
		self.quality:loadTexture(qy.tank.model.GarageModel:getQualityBgPath(entity.quality))


		if qy.InternationalUtil:hasTankReform() then
			if entity.reform_stage == 0 then
				self.reform_bg:setVisible(false)
			else
				self.reform_bg:setVisible(true)
            	self.reform_num:setString(entity.reform_stage)
			end
        end

        self.tankAdvance:setString(entity.advance_level)
	end
end

return TankSelectCell
