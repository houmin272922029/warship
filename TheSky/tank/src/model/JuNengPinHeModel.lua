--[[
	
	Author: Your Name
	Date: 2016年07月13日15:09:18
]]

local JuNengPinHeModel = qy.class("JuNengPinHeModel", qy.tank.model.BaseModel)


local userinfoModel = qy.tank.model.UserInfoModel
local NumberUtil = qy.tank.utils.NumberUtil

function JuNengPinHeModel:init(data)
	self.award_list = {}


	self:update(data)
end



function JuNengPinHeModel:update(_data)
	local data = _data
	if _data.activity_info then
		data = _data.activity_info
	end

	self.p1 = data.p_1
	self.p2 = data.p_2
	self.p3 = data.p_3
	self.p4 = data.p_4
	self.start_time = data.start_time or self.start_time
	self.end_time = data.end_time or self.end_time
	self.need = data.need or self.need

end




function JuNengPinHeModel:getRemainTime()
	local time = self.end_time - userinfoModel.serverTime
	if time > 0 then
		return NumberUtil.secondsToTimeStr(time, 6)
	else
		return qy.TextUtil:substitute(63035)
	end
end


function JuNengPinHeModel:getSuiPianFlag()
	if self:getNum1() <= 0 or self:getNum2() <= 0 or self:getNum3() <= 0 or self:getNum4() <= 0 then
		return false		
	else
		return true
	end
end

function JuNengPinHeModel:getNum1()


	return self.p1
end

function JuNengPinHeModel:getNum2()


	return self.p2
end

function JuNengPinHeModel:getNum3()


	return self.p3
end

function JuNengPinHeModel:getNum4()


	return self.p4
end

function JuNengPinHeModel:getNeed()


	return self.need
end


return JuNengPinHeModel