--[[
	军团boss
	Author: Aaron Wei
	Date: 2016-02-18 20:05:57
]]

local LegionBossModel = qy.class("LegionBossModel", qy.tank.model.BaseModel)

-- 排名
LegionBossModel.rank = 0

function LegionBossModel:init(data)
	if data.user_boss then
		self.attack_plus = data.user_boss.attack_plus
		self.inspire1 = data.user_boss.inspire_times1
		self.inspire2 = data.user_boss.inspire_times2
		self.cd = data.user_boss.cd_time
	end
	
	if data.rank_list then
		self.list = data.rank_list
	end

	if data.my_rank then
		self.my_rank = data.my_rank.rank
		self.my_hurt = data.my_rank.hurt
	end

	if data.left_blood then
		self.left_blood = data.left_blood
	end

	if data.boss_id then
		self.boss_id = data.boss_id
	else
		self.boss_id = 1
	end

	local awards = qy.Config.legion_boss_rank_award
	self.awardList = {}
	for i=1,50 do
		local item = awards[tostring(i)]
		table.insert(self.awardList,item)
	end
end

function LegionBossModel:getAwardList()
	local awards = qy.Config.legion_boss_rank_award
	self.awardList = {}
	for i=1,50 do
		local item = awards[tostring(i)]
		table.insert(self.awardList,item)
	end
end

function LegionBossModel:update(data)
	if data.user_boss then
		self.attack_plus = data.user_boss.attack_plus
		self.inspire1 = data.user_boss.inspire_times1
		self.inspire2 = data.user_boss.inspire_times2
		self.cd = data.user_boss.cd_time
	end

	if data.left_blood then
		self.left_blood = data.left_blood
	end

	if data.rank_list then
		self.list = data.rank_list
	end
	
	if data.my_rank then
		self.my_rank = data.my_rank.rank
		self.my_hurt = data.my_rank.hurt
	end
end

return LegionBossModel