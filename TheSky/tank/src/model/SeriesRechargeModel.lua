--[[
	Author: fq
	Date: 2016年08月05日15:02:46
]]

local SeriesRechargeModel = qy.class("SeriesRechargeModel", qy.tank.model.BaseModel)

local userinfoModel = qy.tank.model.UserInfoModel
local NumberUtil = qy.tank.utils.NumberUtil

function SeriesRechargeModel:init(_data)
	self.config = {}

	local staticData = qy.Config.series_recharge
	for i, v in pairs(staticData) do
		table.insert(self.config, v)
	end


	table.sort(self.config,function(a,b)
		return tonumber(a.id) < tonumber(b.id)
	end)

	self:update(_data)
end

function SeriesRechargeModel:update(_data)
	local data = _data

	if _data.activity_info then 
		data = _data.activity_info
	end

	self.startTime = data.start_time or self.startTime
	self.endTime = data.end_time or self.endTime
	self.progress = data.progress or self.progress
	self.complete = data.complete or self.complete
	self.award_status  = data.award_status or self.award_status
end


function SeriesRechargeModel:getEndTime()
	local time = self.endTime - userinfoModel.serverTime
	if time > 0 then
		return NumberUtil.secondsToTimeStr(time, 6)
	else
		return qy.TextUtil:substitute(63035)
	end
end



return SeriesRechargeModel