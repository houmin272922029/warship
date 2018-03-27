--[[
	军团战
	Author: H.X.Sun
]]

local LegionWarController = qy.class("LegionWarController", qy.tank.controller.BaseController)

local model = qy.tank.model.LegionWarModel

function LegionWarController:ctor(delegate)
    LegionWarController.super.ctor(self)
    -- model:init()
    print("LegionWarController:ctor")
    self.viewStack = qy.tank.widget.ViewStack.new()
    self.viewStack:addTo(self)

    self.mainView = qy.tank.view.legion.war.MainView.new({
    -- self.mainView = qy.tank.view.legion.war.BattleView.new({
        ["dismiss"] = function()
            self.viewStack:pop()
            self.viewStack:removeFrom(self)
            self:finish()
        end,
        ["showRank"] = function(params)
            self.rankView = qy.tank.view.legion.war.RankView.new({
                ["dismiss"] = function()
                    self.viewStack:pop()
                    params.callFunc()
                end,
            })
            self.viewStack:push(self.rankView)
        end,
        -- ["showBattle"] = function()
        --     self.battleView = qy.tank.view.legion.war.BattleView.new({
        --         ["dismiss"] = function()
        --             self.viewStack:pop()
        --         end,
        --     })
        --     self.viewStack:push(self.battleView)
        -- end,
    })
    self.viewStack:push(self.mainView)

    -- self.
end

return LegionWarController
