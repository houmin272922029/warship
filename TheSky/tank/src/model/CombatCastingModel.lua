--[[
	
	Author: Your Name
	Date: 2016年07月13日15:09:18
]]

local CombatCastingModel = qy.class("CombatCastingModel", qy.tank.model.BaseModel)


local userinfoModel = qy.tank.model.UserInfoModel
local NumberUtil = qy.tank.utils.NumberUtil

function CombatCastingModel:init(data)
	local staticData = qy.Config.combat_casting
	self.score_award = {}
	for i, v in pairs(staticData) do
		table.insert(self.score_award, v)
	end

	table.sort(self.score_award, function(a, b)
   		return a.level < b.level
   	end)



   	local staticData1 = qy.Config.combat_casting_achieve
	self.achieve = {}
	for i, v in pairs(staticData1) do
		table.insert(self.achieve, v)
	end

	table.sort(self.achieve, function(a, b)
   		return a.id < b.id
   	end)




   	local staticData2 = qy.Config.combat_casting_rank
	self.rank = {}
	for i, v in pairs(staticData2) do
		table.insert(self.rank, v)
	end

	table.sort(self.rank, function(a, b)
   		return a.id < b.id
   	end)



	self:update(data)
end



function CombatCastingModel:update(_data)
	local data = _data
	if _data.activity_info then
		data = _data.activity_info
	end

	self.start_time = data.start_time or self.start_time
	self.end_time = data.end_time or self.end_time
	self.award_end_time = data.award_end_time or self.award_end_time

	if data.user_activity_info then
		data = data.user_activity_info
	end


	self.to_eat_award = data.to_eat_award
	if self.point then
		self.add_point = (data.point or 0) - (self.point or 0)
	else
		self.add_point = 0
	end
	self.get_rank_award = data.get_rank_award or self.get_rank_award
	self.point = data.point or self.point
	self.level = data.level or self.level
	self.achieve_got = data.achieve_got or self.achieve_got
	self.click_times = data.click_times or self.click_times
	

	self.rank_list = _data.rank_list or self.rank_list
	self.my_rank = _data.my_rank or self.my_rank
end





function CombatCastingModel:getRankRewardList() 
	return self.rank
end

function CombatCastingModel:getRankRewardById(idx) 
	return self.rank[idx]
end



function CombatCastingModel:getRankList() 
	return self.rank_list
end

function CombatCastingModel:getRankById(idx) 
	return self.rank_list[idx]
end


function CombatCastingModel:getRemainTime()
	local time = self.end_time - userinfoModel.serverTime
	if time > 0 then
		return NumberUtil.secondsToTimeStr(time, 6)
	else
		return qy.TextUtil:substitute(63035)
	end
end



function CombatCastingModel:getReceiveRemainTime()
	local time = self.award_end_time - userinfoModel.serverTime
	if time > 0 then
		return NumberUtil.secondsToTimeStr(time, 6)
	else
		return qy.TextUtil:substitute(63035)
	end
end




return CombatCastingModel