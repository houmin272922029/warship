local MianController = qy.class("MianController", qy.tank.controller.BaseController)

function MianController:ctor(delegate)
    MianController.super.ctor(self)
    self.viewStack = qy.tank.widget.ViewStack.new()
    self.viewStack:addTo(self)
    
    local _index = 1
    if delegate and delegate.idx1 then
        _index = delegate.idx1
    end
    local _index2 = 1
    if delegate and delegate.idx2 then
        _index2 = delegate.idx2
    end
    self.view = require("passenger.src.MainView").new({
        ["dismiss"] = function()
            self.viewStack:pop()
            self.viewStack:removeFrom(self)
            self:finish()
        end,
        ["idx1"] = _index,
        ["idx2"] = _index2,
    })
    self.viewStack:push(self.view)
end

function MianController:onCleanup()
   
end

return MianController