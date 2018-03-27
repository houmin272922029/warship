

local TextCell2 = qy.class("TextCell2", qy.tank.view.BaseView, "medal/ui/TextCell2")

local service = qy.tank.service.MedalService
local garageModel = qy.tank.model.GarageModel
local  model = qy.tank.model.MedalModel
local StorageModel = qy.tank.model.StorageModel
local userInfoModel = qy.tank.model.UserInfoModel

function TextCell2:ctor(delegate)
    TextCell2.super.ctor(self)
    self.delegate = delegate
    self:InjectView("miaoshu")
    self:InjectView("name")
    self.num = delegate.num
    self.id = delegate.id
    self:update()
end
function TextCell2:update(  )
	local data = model.localmedalcfg
	self.name:setString(data[tostring(self.id)]["name"..self.num])
	self.miaoshu:setString("("..data[tostring(self.id)]["group"..self.num.."_desc"]..")")
end
function TextCell2:onEnter()
    
end
function TextCell2:onExit()
    
end


return TextCell2
