local AdvanceController = qy.class("AdvanceController", qy.tank.controller.BaseController)

function AdvanceController:ctor(delegate)
    AdvanceController.super.ctor(self)
    print("cocos2dx ===============>111111 ")
    self.viewStack = qy.tank.widget.ViewStack.new()
    self.viewStack:addTo(self)
    self.entity = delegate.entity
    self.isTips = delegate.isTips
    if delegate.isTips then
    	self:startAddStarPreView()
    else
        print("cocos2dx ===============> ")
	    qy.tank.module.Helper:register("advance")
	    qy.tank.module.Helper:start("advance", self)
	end
end

function AdvanceController:startAddStarPreView()
	self.viewStack:push(qy.tank.view.advance.PreView.new(self))
end

return AdvanceController
