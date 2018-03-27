local ServiceWarController = qy.class("ServiceWarController", qy.tank.controller.BaseController)

function ServiceWarController:ctor(delegate)
    ServiceWarController.super.ctor(self)
    self.viewStack = qy.tank.widget.ViewStack.new()
    self.viewStack:addTo(self)

    self.view = require("servicewar.src.ServiceWarView").new({
        ["dismiss"] = function()
           self.viewStack:pop()
           self.viewStack:removeFrom(self)
           self:finish()
        end,
        ["showWar"] = function ()
            self:showWar()
        end
        })
    self.viewStack:push(self.view)
end

function ServiceWarController:showWar()
    local service = qy.tank.service.ServiceWarService
    service:getRankList(page, function()
          self.warview = require("servicewar.src.ShowWar").new({
            ["dismiss"] = function()
              self.viewStack:pop()
            end,
            ["page"] = page
          })
          self.viewStack:push(self.warview)
    end)
end

return ServiceWarController
                                                