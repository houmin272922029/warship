--[[
	围攻柏林
	Author: 
	Date: 2016年07月13日10:31:29
]]

local MainController = qy.class("MainController", qy.tank.controller.BaseController)


function MainController:ctor(delegate)
	self.model = qy.tank.model.AttackBerlinModel
	self.service = qy.tank.service.AttackBerlinService

    MainController.super.ctor(self)

    self.viewStack = qy.tank.widget.ViewStack.new()
    self.viewStack:addTo(self)
    local view = require("attack_berlin.src.MainView").new(self)
    self.viewStack:push(view)
    
    
end

function MainController:showTeamListView(ids,data)
 	self.service:inToElite(ids,function (  )
        local view = require("attack_berlin.src.GroupBattlesLayer").new(data,self)
        self.viewStack:push(view)
    end)
end


function MainController:showBossView()
	local view = require("attack_berlin.src.BossDialog").new(self)
	self.viewStack:push(view)
end



function MainController:onCleanup()

end

return MainController