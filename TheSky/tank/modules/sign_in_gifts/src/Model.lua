--[[
	每日好礼
	
]]

local Model = class("Model", qy.tank.model.BaseModel)
function Model:init(data)
	self.data = data
	self.start_time = self.data.start_t
	self.end_time = self.data.end_t
	self.server_time = self.data.server_time

	--拿到表中的数据
	self.config = qy.Config.day_mark
	print("888---000",table.nums(self.config))
	print("666--1111",self.data.award.id)

	for k,v in pairs(self.data) do
		--for k,v in pairs(v) do
			print(k,v)
		--end
	end
	
end

-- function Model:GetData()
-- 	local list = {}
-- 	for k,v in pairs(self.config) do
-- 			table.insert(list,v)		
-- 	end
-- 	table.sort(list,function(a,b)
--         return tonumber(a.id) < tonumber(b.id)
--     end)
-- 	return list	
-- end
--拿到当天的一条信息table
-- function Model:GetDataById(id)
-- 	for k,v in pairs(self.config) do
-- 		if v.id == id then
-- 			return v
-- 		end
-- 	end
-- end
--全勤奖励按钮是否置灰
function Model:GetLingQuStatusById(day)
	local status = 0
		if self.data.state == 1 or self.data.times == day then
			status = 1
		end
 	return status
end
--每日奖励时候签到状态
function Model:GetQianDaoStatusById( id )
	local status = 0
		if self.data.today_state == 2 then
			status = 1
		end
 	return status
end
--累计签到天数加一
function Model:GetUpdateTime( id )
	self.data.times = self.data.times + 1
end
--显示天数
function Model:GetTimes()
	return self.data.times
end
--累计签到天数加一
function Model:GetUpdateStatus( id )
	self.data.today_state = self.data.today_state + 1
end
--累计签到天数加一
function Model:GetUpdateStatus1()
	self.data.state = self.data.state + 2
end
return Model
