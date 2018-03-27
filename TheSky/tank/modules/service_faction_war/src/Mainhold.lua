

local Mainhold = qy.class("Mainhold", qy.tank.view.BaseView, "service_faction_war/ui/Mainhold")

local model = qy.tank.model.ServerFactionModel
local service = qy.tank.service.ServerFactionService

function Mainhold:ctor(delegate)
    Mainhold.super.ctor(self)
    self.delegate = delegate
    self:InjectView("img")
    self:InjectView("name")
    self:InjectView("icon")
    self.id = delegate.id
    self:OnClick("img",function()
        --mai
    end,{["isScale"] = false})
    if self.id == 1 then
    	self.icon:loadTexture("service_faction_war/res/lv.png",1)
	elseif self.id == 11 then
		self.icon:loadTexture("service_faction_war/res/lan.png",1)
	else
		self.icon:loadTexture("service_faction_war/res/hong.png",1)
	end
end

function Mainhold:update()
    self.data = model.city_info[self.id]
    self.name:setString(self.data.name)
end


return Mainhold
