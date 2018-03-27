
--[[--
       战车置换
    Date: 
]]

local InheritController = qy.class("InheritController", qy.tank.controller.BaseController)

function InheritController:ctor(delegate)
    InheritController.super.ctor(self)
	
	self.viewStack = qy.tank.widget.ViewStack.new()
	self.viewStack:addTo(self)

  if delegate == nil then
    delegate = {}
  end

  delegate["dismiss"] = function()
    self.viewStack:pop()
    self.viewStack:removeFrom(self)
    self:finish()
  end

	self.viewStack:push(qy.tank.view.inherit.MainView.new(delegate))

end

return InheritController
