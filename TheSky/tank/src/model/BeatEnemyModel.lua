--[[
	暴打敌营
	Author: fq
	Date: 2016年08月05日15:02:46
]]

local BeatEnemyModel = qy.class("BeatEnemyModel", qy.tank.model.BaseModel)

local userinfoModel = qy.tank.model.UserInfoModel
local NumberUtil = qy.tank.utils.NumberUtil

function BeatEnemyModel:init(_data)

	local data = _data.activity_info

	self.chest_list = {}
	self.rank_reward_list = {}

	local staticData = qy.Config.beat_enemy_chest
	for i, v in pairs(staticData) do
		v.is_obtain = false
		table.insert(self.chest_list, v)
	end

	local staticData2 = qy.Config.beat_enemy_rank
	for i, v in pairs(staticData2) do
		table.insert(self.rank_reward_list, v)
	end



	table.sort(self.chest_list,function(a,b)
		return tonumber(a.id) < tonumber(b.id)
	end)
	
	table.sort(self.rank_reward_list,function(a,b)
		return tonumber(a.rank) < tonumber(b.rank)
	end)

	self:update(data)

end

function BeatEnemyModel:update(_data)

	local data = _data
	if _data.activity_info then
		data = _data.activity_info
	end

	self.is_draw_rank = data.beat_enemy.is_draw_rank
	self.total_point = data.beat_enemy.total_point
	self.my_rank = data.beat_enemy.rank.my_rank
	self.rank_list = data.beat_enemy.rank.rank_list
	self.chest = data.beat_enemy.chest
	self.point = data.beat_enemy.point
	self.diamond = data.beat_enemy.diamond
	self.recharge_point = data.beat_enemy.recharge_point
	self.end_time = data.end_time
	self.award_end_time = data.award_end_time


	table.sort(self.rank_list,function(a,b)
		return tonumber(a.rank) < tonumber(b.rank)
	end)

	for i, v in pairs(self.chest) do
		print(v)
		self.chest_list[tonumber(v)].is_obtain = true
	end
end


function BeatEnemyModel:getTotalPoint()
	return self.total_point
end


function BeatEnemyModel:getChestList() 
	return self.chest_list
end

function BeatEnemyModel:getChestById(idx) 
	return self.chest_list[idx]
end




function BeatEnemyModel:getRankRewardList() 
	return self.rank_reward_list
end

function BeatEnemyModel:getRankRewardById(idx) 
	return self.rank_reward_list[idx]
end



function BeatEnemyModel:getRankList() 
	return self.rank_list
end

function BeatEnemyModel:getRankById(idx) 
	return self.rank_list[idx]
end



function BeatEnemyModel:getRemainTime()
	local time = self.end_time - userinfoModel.serverTime
	if time > 0 then
		return NumberUtil.secondsToTimeStr(time, 6)
	else
		return qy.TextUtil:substitute(63035)
	end
end


function BeatEnemyModel:getReceiveRemainTime()
	local time = self.award_end_time - userinfoModel.serverTime
	if time > 0 then
		return NumberUtil.secondsToTimeStr(time, 6)
	else
		return qy.TextUtil:substitute(63035)
	end
end


return BeatEnemyModel