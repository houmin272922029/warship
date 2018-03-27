--[[
	
	Author: Your Name
	Date: 2016年07月13日15:09:18
]]

local PayEveryDayModel = qy.class("PayEveryDayModel", qy.tank.model.BaseModel)


local userinfoModel = qy.tank.model.UserInfoModel

function PayEveryDayModel:init(data)
	self.award_list = {}

	self:update(data)
end



function PayEveryDayModel:update(_data)
	local data = _data
	if _data.activity_info then
		data = _data.activity_info
	end


	self.cash = data.cash or self.cash
	self.award_list = data.award_list or self.award_list
	self.start_time = data.start_time
	self.end_time = data.end_time

	table.sort(self.award_list,function(a,b)
		return tonumber(a.cash) < tonumber(b.cash)
	end)


end


function PayEveryDayModel:getChestList()
	return self.award_list
end


function PayEveryDayModel:getCash()
	return self.cash
end

function PayEveryDayModel:getStartTime()
	return self.start_time
end

function PayEveryDayModel:getEndTime()
	return self.end_time
end


return PayEveryDayModel