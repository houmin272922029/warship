--[[
	
	Author: 
	Date: 2015-12-01 16:09:56
]]

local MianController = qy.class("MianController", qy.tank.controller.BaseController)

local model = qy.tank.model.SoulModel
function MianController:ctor(delegate)
    MianController.super.ctor(self)
    self.viewStack = qy.tank.widget.ViewStack.new()
    self.viewStack:addTo(self)
    
    local view = require("soul.src.MainView").new(self)
    self.viewStack:push(view)
end

function MianController:onCleanup()
   
end

return MianController
