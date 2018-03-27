--[[
	跨服多人副本
	Author: 
	Date: 2016年07月13日10:31:29
]]

local MainController = qy.class("MainController", qy.tank.controller.BaseController)


function MainController:ctor(delegate)
	self.model = qy.tank.model.AllServersGroupBattlesModel
	self.service = qy.tank.service.AllServersGroupBattlesService

    MainController.super.ctor(self)

    self.viewStack = qy.tank.widget.ViewStack.new()
    self.viewStack:addTo(self)
    
    local view = require("all_servers_group_battles.src.BeginView").new(self)
    self.viewStack:push(view)
end


function MainController:showTeamListView(scene_id)
	self.service:getTeamList(function(data)    	
		local view = require("all_servers_group_battles.src.TeamListLayer").new(self)
		self.viewStack:push(view)
    end, scene_id, 1, 20)
end


function MainController:showTeamInfoView()
	local view = require("all_servers_group_battles.src.TeamInfoLayer").new(self)
	self.viewStack:push(view)
end



function MainController:onCleanup()

end

return MainController