

local Bosshold = qy.class("Bosshold", qy.tank.view.BaseView, "service_faction_war/ui/Bosshold")

local model = qy.tank.model.ServerFactionModel
local service = qy.tank.service.ServerFactionService

function Bosshold:ctor(delegate)
    Bosshold.super.ctor(self)
    self.delegate = delegate
    self:InjectView("img")
    self:InjectView("name")
    self:InjectView("icon")
    self.id = delegate.id
    self:OnClick("img",function()
        qy.hint:show("暂未开启")
    end,{["isScale"] = false})
end

function Bosshold:update()
	self.data = model.city_info[self.id]
    self.name:setString(self.data.name)
end


return Bosshold
