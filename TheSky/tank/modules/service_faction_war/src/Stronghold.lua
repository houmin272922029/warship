

local Stronghold = qy.class("Stronghold", qy.tank.view.BaseView, "service_faction_war/ui/Stronghold")

local model = qy.tank.model.ServerFactionModel
local service = qy.tank.service.ServerFactionService

function Stronghold:ctor(delegate)
    Stronghold.super.ctor(self)
    self.delegate = delegate
    self:InjectView("img")
    self:InjectView("name")
    self:InjectView("icon")
    self:InjectView("myposition")
    self.id = delegate.id
    self:OnClick("img",function()
        service:IntoCamp(self.id,function ( ... )
            model:setSlectcity(self.id)
            require("service_faction_war.src.StrongholdDialog").new(self.id):show()
        end)
       
    end,{["isScale"] = false})
   
end

function Stronghold:update()
	self.data = model.city_info[self.id]
    self.name:setString(self.data.name)
    self.icon:setVisible(self.data.camp ~= 0)
    self.myposition:setVisible(self.id == model.my_city)
    local camp = self.data.camp 
    if camp == 1 then
        self.icon:setSpriteFrame("service_faction_war/res/hong.png")
    elseif camp == 2 then
        self.icon:setSpriteFrame("service_faction_war/res/lv.png")
    else
        self.icon:setSpriteFrame("service_faction_war/res/lan.png")
    end
end


return Stronghold
