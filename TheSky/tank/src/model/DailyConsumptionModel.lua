--[[
	
	Author: Your Name
	Date: 2016年07月13日15:09:18
]]

local DailyConsumptionModel = qy.class("DailyConsumptionModel", qy.tank.model.BaseModel)


local userinfoModel = qy.tank.model.UserInfoModel
local NumberUtil = qy.tank.utils.NumberUtil

function DailyConsumptionModel:init(data)
	local staticData = qy.Config.daily_consumption
	self.score_award = {}
	for i, v in pairs(staticData) do
		table.insert(self.score_award, v)
	end

	table.sort(self.score_award, function(a, b)
   		return a.diamond < b.diamond
   	end)


	self:update(data)
end



function DailyConsumptionModel:update(_data)
	local data = _data
	if _data.activity_info then
		data = _data.activity_info
	end

	self.start_time = data.start_time or self.start_time
	self.end_time = data.end_time or self.end_time


	if data.user_activity_info then
		data = data.user_activity_info
	end

	self.receive_log = data.list or self.receive_log
	self.diamond = data.diamond or self.diamond
end






function DailyConsumptionModel:getRemainTime()
	local time = self.end_time - userinfoModel.serverTime
	if time > 0 then
		return NumberUtil.secondsToTimeStr(time, 6)
	else
		return qy.TextUtil:substitute(63035)
	end
end






return DailyConsumptionModel