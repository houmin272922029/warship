local MainViewController = qy.class("MainViewController", qy.tank.controller.BaseController)

function MainViewController:ctor(delegate)
    MainViewController.super.ctor(self)
    self.viewStack = qy.tank.widget.ViewStack.new()
    self.viewStack:addTo(self)
    
    local view = require("Military_rank.src.MilitaryRankView").new(self)
    self.viewStack:push(view)
end
function MainViewController:showScenelistView()
	local view = require("Military_rank.src.CheckAllview").new(self)
	self.viewStack:push(view)
end

return MainViewController