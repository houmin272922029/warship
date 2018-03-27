--[[
	活动导航
	Author: Aaron Wei
	Date: 2015-06-01 20:05:15
]]

local BattleRoomController = qy.class("BattleRoomController", qy.tank.controller.BaseController)

function BattleRoomController:ctor(delegate)
    BattleRoomController.super.ctor(self)

    qy.tank.view.activity.BattleRoomView.new({
    	["dismiss"] = function()
            self:finish()
        end,
    }):addTo(self)
end

return BattleRoomController
