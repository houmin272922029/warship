--[[
	商城入口
	Author: Aaron Wei
	Date: 2015-10-28 21:14:38
]]

local ShopController = qy.class("ShopController", qy.tank.controller.BaseController)

function ShopController:ctor(delegate)
    ShopController.super.ctor(self)

    self.viewStack = qy.tank.widget.ViewStack.new()
    self.viewStack:addTo(self)
    self.model = qy.tank.model.GarageModel

    self.view = qy.tank.view.shop.ShopView.new({
        ["dismiss"] = function()
            self.viewStack:pop()
            self.viewStack:removeFrom(self)
            self:finish()
        end,
    })
    self.viewStack:push(self.view)
end

function ShopController:onCleanup()
    -- display.removeSpriteFrames("Resources/plist/ui_login.plist", "Resources/plist/ui_login.png")
    -- display.removeImage("shine")
    -- display.removeImage("play_enable")
    -- display.removeImage("play_background")
end


return ShopController
