--[[
	军奥活动tab
	Author: Aaron Wei
	Date: 2016-09-12 18:57:55
]]

local ActivityView = qy.class("ActivityView", qy.tank.view.BaseView, "olympic.ui.ActivityView")

function ActivityView:ctor(delegate)
	print("ActivityView:ctor")
    ActivityView.super.ctor(self)

    self.model = qy.tank.model.OlympicModel
	self.delegate = delegate

	self:InjectView("free1")
	self:InjectView("free2")
	self:InjectView("diamondNode")
	self:InjectView("diamond1")
	self:InjectView("diamond2")

	self:OnClick("joinBtn1",function(sender)
		local service = qy.tank.service.OlympicService
		service:join(100,1,function()
			self:update()
			local controller = require("olympic.src.GameShootController").new()
			qy.App.runningScene:push(controller)
		end)
	end, {["isScale"] = false})
	
	self:OnClick("join10Btn1",function(sender)
		local service = qy.tank.service.OlympicService
		service:join(100,10,function()
			self:update()
			local controller = require("olympic.src.GameShootController").new()
			qy.App.runningScene:push(controller)
		end)
	end, {["isScale"] = false})

	self:OnClick("joinBtn2",function(sender)
		local service = qy.tank.service.OlympicService
		service:join(200,1,function()
			self:update()
			local controller = require("olympic.src.GameGoalController").new()
			qy.App.runningScene:push(controller)
		end)
	end, {["isScale"] = false})

	-- self:OnClick("join10Btn2",function(sender)
	-- 	local service = qy.tank.service.OlympicService
	-- 	service:join(200,10,function()
	-- 		local controller = require("olympic.src.GameGoalController").new()
	-- 		qy.App.runningScene:push(controller)
	-- 	end)
	-- end, {["isScale"] = false})

end

function ActivityView:update()
	if self.model.free1 > 0 then
		self.free1:setVisible(true)
		self.diamondNode:setVisible(false)
		self.free1:setString("免费剩余次数: "..self.model.free1.."/"..self.model.join1)
	else
		self.free1:setVisible(false)
		self.diamondNode:setVisible(true)
		self.diamond1:setString(tostring(self.model.diamond1))
		self.diamond2:setString(tostring(self.model.diamond1*10))
	end

	if self.model.free2 > 0 then
		self.free2:setString("免费剩余次数: "..self.model.free2.."/"..self.model.join2)
	else
		self.free2:setString("")
	end
end

return ActivityView