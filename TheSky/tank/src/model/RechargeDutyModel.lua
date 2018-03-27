--[[
	
	Author: Your Name

]]

local RechargeDutyModel = qy.class("RechargeDutyModel", qy.tank.model.BaseModel)


local userinfoModel = qy.tank.model.UserInfoModel
local NumberUtil = qy.tank.utils.NumberUtil
function RechargeDutyModel:init(data)
	self.award_list = {}

	
	local staticData = qy.Config.recharge_duty 

	for i, v in pairs(staticData) do
		table.insert(self.award_list, v)
	end

	table.sort(self.award_list,function(a,b)
		return tonumber(a.id) < tonumber(b.id)
	end)


	self:update(data)
end



function RechargeDutyModel:update(_data)
	local data = _data
	if _data.activity_info then
		data = _data.activity_info
	end


	self.start_time = data.start_time or self.start_time
	self.end_time = data.end_time or self.end_time
	self.current_day = data.current_day or self.current_day
	self.list = data.list or self.list

end



function RechargeDutyModel:getRemainTime()
	local time = self.end_time - userinfoModel.serverTime
	if time > 0 then
		return NumberUtil.secondsToTimeStr(time, 6)
	else
		return qy.TextUtil:substitute(63035)
	end
end



return RechargeDutyModel