--[[
	将士之战
	Author: 
	Date: 2016年07月13日10:31:29
]]

local MainController = qy.class("MainController", qy.tank.controller.BaseController)


local model = qy.tank.model.SoldiersWarModel
function MainController:ctor(delegate)
    MainController.super.ctor(self)

    self.viewStack = qy.tank.widget.ViewStack.new()
    self.viewStack:addTo(self)
    
    local view = require("soldiers_war.src.BeginView").new(self)
    self.viewStack:push(view)
end


function MainController:showScenelistView()
	local view = require("soldiers_war.src.SceneListView").new(self)
	self.viewStack:push(view)
end



function MainController:onCleanup()

end

return MainController