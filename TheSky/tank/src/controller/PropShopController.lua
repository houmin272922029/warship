--[[
	军需商店
	Author: Aaron Wei
	Date: 2015-10-29 11:19:56
]]

local PropShopController = qy.class("PropShopController", qy.tank.controller.BaseController)

function PropShopController:ctor(delegate)
    PropShopController.super.ctor(self)

    self.viewStack = qy.tank.widget.ViewStack.new()
    self.viewStack:addTo(self)
    self.model = qy.tank.model.GarageModel

    local _index = 1
    if delegate and delegate.idx then
        _index = delegate.idx
    end
    print("PropShopController default idx==>>", _index)

    self.view = qy.tank.view.shop.PropShopView.new({
        ["dismiss"] = function()
            self.viewStack:pop()
            self.viewStack:removeFrom(self)
            self:finish()
        end,
        ["idx"] = _index,
    })
    self.viewStack:push(self.view)
end

function PropShopController:onCleanup()
    -- display.removeSpriteFrames("Resources/plist/ui_login.plist", "Resources/plist/ui_login.png")
    -- display.removeImage("shine")
    -- display.removeImage("play_enable")
    -- display.removeImage("play_background")
end


return PropShopController
