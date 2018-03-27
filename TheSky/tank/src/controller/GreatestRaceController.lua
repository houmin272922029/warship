--[[
	最强之战
	Author: H.X.Sun
]]

local GreatestRaceController = qy.class("GreatestRaceController", qy.tank.controller.BaseController)

function GreatestRaceController:ctor(delegate)
    GreatestRaceController.super.ctor(self)
    print("GreatestRaceController:ctor")
    qy.tank.model.GreatestRaceModel:initShopList()
    self.viewStack = qy.tank.widget.ViewStack.new()
    self.viewStack:addTo(self)

    self.mainView = qy.tank.view.greatest_race.MainView.new({
        ["dismiss"] = function()
            self.viewStack:pop()
            self.viewStack:removeFrom(self)
            self:finish()
        end,
        ["showHero"] = function()
            print("showHero showHero")
            self:__showHero()
        end
    })
    self.viewStack:push(self.mainView)
end

function GreatestRaceController:__showHero()
    local hero = qy.tank.view.greatest_race.HeroView.new({
        ["dismiss"] = function()
            self.viewStack:pop()
        end,
    })
    self.viewStack:push(hero)
end

return GreatestRaceController
