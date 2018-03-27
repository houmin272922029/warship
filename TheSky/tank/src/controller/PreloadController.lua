--[[
    说明: 资源加载器
    Author: Aaron Wei
	Date: 2015-10-15 15:22:57
]]

local PreloadController = qy.class("PreloadController", qy.tank.controller.BaseController)

function PreloadController:ctor()
    PreloadController.super.ctor(self)
    qy.tank.view.preload.PreloadView
        .new()
        :addTo(self)
end

return PreloadController
