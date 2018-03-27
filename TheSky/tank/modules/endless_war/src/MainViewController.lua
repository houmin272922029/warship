local MainViewController = qy.class("MainViewController", qy.tank.controller.BaseController)

function MainViewController:ctor(delegate)
    MainViewController.super.ctor(self)
    self.viewStack = qy.tank.widget.ViewStack.new()
    self.viewStack:addTo(self)
    
    local view = require("endless_war.src.MainDialog").new(self)
    self.viewStack:push(view)
end


return MainViewController