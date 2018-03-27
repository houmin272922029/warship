--
-- Author: Your Name
-- Date: 2015-12-01 17:05:10
--

local WorldBossModel = qy.class("WorldBossModel", qy.tank.model.BaseModel)

-- 排名
WorldBossModel.rank = 0

function WorldBossModel:init(data)
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


	local awards = qy.Config.boss_award
	self.awardList = {}
	for i=1,18 do
		local item = awards[tostring(i)]
		local min,max = awards[tostring(i)].front_rank,awards[tostring(i)].post_rank
		if max <= 0 then
			item.range = qy.TextUtil:substitute(65002, tostring(min))
		elseif min == max then
			item.range = qy.TextUtil:substitute(65003, tostring(min))
		else
			item.range = qy.TextUtil:substitute(65003, tostring(min)).."~"..tostring(max)
		end
		table.insert(self.awardList,item)
	end
end

function WorldBossModel:update(data)
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

return WorldBossModel