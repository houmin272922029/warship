--[[
	
	Author: Your Name
	Date: 2016年07月13日15:09:18
]]

local LoginFundModel = qy.class("LoginFundModel", qy.tank.model.BaseModel)


local userinfoModel = qy.tank.model.UserInfoModel
local NumberUtil = qy.tank.utils.NumberUtil
function LoginFundModel:init(data)
	self.award_list = {}

	
	local staticData = qy.Config.login_fund 

	for i, v in pairs(staticData) do
		table.insert(self.award_list, v)
	end

	table.sort(self.award_list,function(a,b)
		return tonumber(a.id) < tonumber(b.id)
	end)


	self:update(data)
end



function LoginFundModel:update(_data)
	local data = _data
	if _data.activity_info then
		data = _data.activity_info
	end


	self.start_time = data.start_time or self.start_time
	self.end_time = data.end_time or self.end_time
	self.close_time = data.close_time or self.close_time
	self.list = data.list or self.list

end



function LoginFundModel:getRemainTime()
	local time = self.end_time - userinfoModel.serverTime
	if time > 0 then
		return NumberUtil.secondsToTimeStr(time, 6)
	else
		return qy.TextUtil:substitute(63035)
	end
end



return LoginFundModel