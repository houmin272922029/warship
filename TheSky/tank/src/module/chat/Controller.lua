local Controller = qy.class("Controller", qy.tank.controller.BaseController)

local ChatMainView = require("module.chat.MainView")

function Controller:ctor()
    Controller.super.ctor(self)

    ChatMainView
        .new()
        :addTo(self)
end

return Controller
