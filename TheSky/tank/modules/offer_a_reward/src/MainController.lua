local MainController = qy.class("MainController", qy.tank.controller.BaseController)


local model = qy.tank.model.OfferARewardModel
function MainController:ctor(delegate)
    MainController.super.ctor(self)

    self.viewStack = qy.tank.widget.ViewStack.new()
    self.viewStack:addTo(self)
    
    local view = require("offer_a_reward.src.OfferARewardLayer").new(self)
    self.viewStack:push(view)
end



return MainController