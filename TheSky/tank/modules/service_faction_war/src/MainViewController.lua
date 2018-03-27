local MainViewController = qy.class("MainViewController", qy.tank.controller.BaseController)

local model = qy.tank.model.ServerFactionModel
local service = qy.tank.service.ServerFactionService


function MainViewController:ctor(delegate)
    MainViewController.super.ctor(self)
	self.viewStack = qy.tank.widget.ViewStack.new()
	self.viewStack:addTo(self)
    if model.isfaction == 0 then
    	self:showChooseView()
    else
    	self:showMianView()
    end
   
end
function MainViewController:showMianView()
	local view = require("service_faction_war.src.MainView").new(self)
	self.viewStack:push(view)
	-- local tips = require("service_faction_war.src.TipsDialog").new()
	-- tips:addRichText(2)
 --    tips:show()
end
function MainViewController:showChooseView()
	local view = require("service_faction_war.src.WarcampView").new(self)
	self.viewStack:push(view)
	
end

return MainViewController