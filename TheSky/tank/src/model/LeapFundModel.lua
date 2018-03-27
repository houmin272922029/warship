--[[
	
	Author: Your Name
	Date: 2016年07月13日15:09:18
]]

local LeapFundModel = qy.class("LeapFundModel", qy.tank.model.BaseModel)


local userinfoModel = qy.tank.model.UserInfoModel
local NumberUtil = qy.tank.utils.NumberUtil

function LeapFundModel:init(data)
	local staticData = qy.Config.leap_fund
	self.score_award = {}
	for i, v in pairs(staticData) do
		table.insert(self.score_award, v)
	end

	table.sort(self.score_award, function(a, b)
   		return a.level < b.level
   	end)

	self:update(data)
end



function LeapFundModel:update(_data)
	local data = _data
	if _data.activity_info then
		data = _data.activity_info
	end


	if data.user_activity_info then
		data = data.user_activity_info
	end


	self.is_active = data.is_active or self.is_active
	self.uptime = data.uptime or self.uptime
	self.click = data.click or self.click
	self.receive_log = data.receive_log or self.receive_log
	self.receive = {}
	for i = 1, #self.receive_log do
		self.receive[tostring(self.receive_log[i])] = 1
	end
	self.status = data.is_active or self.status
end






function LeapFundModel:getRemainTime()
	local time = self.end_time - userinfoModel.serverTime
	if time > 0 then
		return NumberUtil.secondsToTimeStr(time, 6)
	else
		return qy.TextUtil:substitute(63035)
	end
end






return LeapFundModel