--[[
	跨服军神榜
	Author: fq
	Date: 2016年12月02日15:37:25
]]

local MainController = qy.class("MainController", qy.tank.controller.BaseController)

--local service = qy.tank.service.SingleHeroService
function MainController:ctor(delegate)
    MainController.super.ctor(self)
    self.viewStack = qy.tank.widget.ViewStack.new()
    self.viewStack:addTo(self)

    local view = require("inter_service_arena.src.MainView").new({
    	["Controller"] = self,
    	["dismiss"] = function()
        	self.viewStack:pop()
            self.viewStack:removeFrom(self)
            self:finish()
        end})
    self.viewStack:push(view)
end


function MainController:showRewardView(idx)
	local view = require("inter_service_arena.src.RewardView").new({
    	["Controller"] = self,
    	["dismiss"] = function()
        	self.viewStack:pop()
        end})
    self.viewStack:push(view)
end

function MainController:showTotalRankView(data)
	local view = require("inter_service_arena.src.TotalRankView").new({
    	["Controller"] = self,
        ["data"] = data,
    	["dismiss"] = function()
        	self.viewStack:pop()
        end})
    self.viewStack:push(view)
end


function MainController:showCombatView(data)
	local view = require("inter_service_arena.src.CombatView").new({
    	["Controller"] = self,
        ["data"] = data,
    	["dismiss"] = function()
        	self.viewStack:pop()
        end})
    self.viewStack:push(view)
end


--data1 user.show请求返回数据，坦克列表
--data2 防守方排位信息
function MainController:showChallengeView(data, data2, can_sweep)
	local view = require("inter_service_arena.src.ChallengeView").new({
    	["Controller"] = self,
        ["data"] = data,
        ["data2"] = data2,
        ["can_sweep"] = can_sweep,
    	["dismiss"] = function()
        	self.viewStack:pop()
        end})
    self.viewStack:push(view)
end










function MainController:onCleanup()
   
end

return MainController
