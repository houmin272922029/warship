--[[
    体力
    Author: H.X.Sun 
    Date: 2015-08-13
]]

local EnergyNode = qy.class("EnergyNode", qy.tank.view.BaseView, "view/common/EnergyNode")

local model = qy.tank.model.UserInfoModel

function EnergyNode:ctor(delegate)
  EnergyNode.super.ctor(self)
	self:InjectView("energyTxt")

	local award = {["type"] = 14, ["num"] = 1, ["id"] = 1}
	local _data = {award}
	self:OnClick("addEnergyBtn", function(sender)
    	qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.BUY_OR_USE,_data)
  end)
end

function EnergyNode:updateEnergy()
	self.energyTxt:setString(model.userInfoEntity.energy .. "/" ..  model:getEnergyLimitByVipLevel())
end

function EnergyNode:getEnergyLabel()
	return self.energyTxt
end

function EnergyNode:onEnter()
  	self:updateEnergy()
		self.updateEnergyListener = qy.Event.add(qy.Event.USER_RESOURCE_DATA_UPDATE,function(event)
     		self:updateEnergy()
    end)

		self.updateOneEnergyListener = qy.Event.add(qy.Event.CLIENT_ENERGY_UPDATE,function(event)
     		self:updateEnergy()
    end)
end

function EnergyNode:onExit()
	qy.Event.remove(self.updateEnergyListener)
	qy.Event.remove(self.updateOneEnergyListener)
end

return EnergyNode 