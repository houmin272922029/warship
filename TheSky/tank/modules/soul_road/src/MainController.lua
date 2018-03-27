--[[
	军魂之路
	Author: 
	Date: 2015-12-01 16:09:56
]]

local MainController = qy.class("MainController", qy.tank.controller.BaseController)

local service = qy.tank.service.CarrayService
function MainController:ctor(delegate)
    MainController.super.ctor(self)
    self.viewStack = qy.tank.widget.ViewStack.new()
    self.viewStack:addTo(self)

    local view = require("soul_road.src.MainView").new(self)

    self.viewStack:push(view)
end

function MainController:showSceneList(idx)
	local view = require("soul_road.src.SceneListView").new(self, idx)
	self.viewStack:push(view)
end

function MainController:onCleanup()
   
end

return MainController
