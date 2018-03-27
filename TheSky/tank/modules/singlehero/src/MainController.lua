--[[
	孤胆英雄
	Author: 
	Date: 2015-12-01 16:09:56
]]

local MainController = qy.class("MainController", qy.tank.controller.BaseController)

local service = qy.tank.service.SingleHeroService
function MainController:ctor(delegate)
    MainController.super.ctor(self)
    self.viewStack = qy.tank.widget.ViewStack.new()
    self.viewStack:addTo(self)

    local view = require("singlehero.src.MainView").new(self)

    self.viewStack:push(view)
end

function MainController:showList(idx)
	local view = require("singlehero.src.ListDialog").new(self)
	view:show()
end

function MainController:showBuy()
	local view = require("singlehero.src.BuyDialog").new()
	view:show()
end

function MainController:showRank()
	service:getRankList(function()
		local view = require("singlehero.src.LeaderboardDialog").new()
		view:show()
	end)
end

function MainController:onCleanup()
   
end

return MainController
