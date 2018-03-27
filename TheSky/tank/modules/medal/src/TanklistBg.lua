

local TanklistBg = qy.class("TanklistBg", qy.tank.view.BaseView, "medal/ui/TanklistBg")

local service = qy.tank.service.MedalService
local garageModel = qy.tank.model.GarageModel
local  model = qy.tank.model.MedalModel
local StorageModel = qy.tank.model.StorageModel
local userInfoModel = qy.tank.model.UserInfoModel

function TanklistBg:ctor(delegate)
    TanklistBg.super.ctor(self)
    self.delegate = delegate
    self:InjectView("miaoshu")
end
function TanklistBg:onEnter()
    
end

function TanklistBg:render(_idx,entity)
	-- print(".....111111111111",entity.unique_id)
	if type(entity) == "table" then
		self.miaoshu:setVisible(true)
		local list = model:atTank(entity.unique_id)
	    local ta = table.nums(list)
	    self.miaoshu:setString("已装备"..ta.."个勋章")
	else
		self.miaoshu:setVisible(false)
	end

end
function TanklistBg:onExit()
    
end


return TanklistBg
