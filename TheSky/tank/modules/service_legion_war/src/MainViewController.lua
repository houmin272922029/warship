local MainViewController = qy.class("MainViewController", qy.tank.controller.BaseController)

function MainViewController:ctor(delegate)
    MainViewController.super.ctor(self)
    self.viewStack = qy.tank.widget.ViewStack.new()
    self.viewStack:addTo(self)
    
    local view = require("service_legion_war.src.MainView").new(self)
    self.viewStack:push(view)
end

return MainViewController