--[[
	坦克工厂
	Author: Aaron Wei
	Date: 2015-10-29 15:16:23
]]

local TankShopController = qy.class("TankShopController", qy.tank.controller.BaseController)

function TankShopController:ctor(delegate)
    TankShopController.super.ctor(self)

    self.viewStack = qy.tank.widget.ViewStack.new()
    self.viewStack:addTo(self)
    self.model = qy.tank.model.GarageModel
    local index = 1
    if delegate and delegate.index then
        index = delegate.index
    end

    self.view = qy.tank.view.shop.TankShopView.new({
        ["dismiss"] = function()
            self.viewStack:pop()
            self.viewStack:removeFrom(self)
            self:finish()
        end,
        ["index"] = index,
    })
    self.viewStack:push(self.view)
end

function TankShopController:onCleanup()
    -- display.removeSpriteFrames("Resources/plist/ui_login.plist", "Resources/plist/ui_login.png")
    -- display.removeImage("shine")
    -- display.removeImage("play_enable")
    -- display.removeImage("play_background")
end


return TankShopController
