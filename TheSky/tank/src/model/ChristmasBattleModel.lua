

local ChristmasBattleModel = qy.class("ChristmasBattleModel", qy.tank.model.BaseModel)



function ChristmasBattleModel:init(data)
	self.data = data
	self.start_time = data.start_time
	self.end_time = data.end_time
	self.config = qy.Config.christmas_war
	
end

function ChristmasBattleModel:update(data)
	self.data2 = data
end

function ChristmasBattleModel:getattackUpdate()
	self.data.today_rank = self.data2.today_rank
end

-- 3
function ChristmasBattleModel:getAward(id)
	self.awardList = {}
		local item = self.config[tostring(id)]
		local min,max = self.config[tostring(id)].front_rank,self.config[tostring(id)].post_rank
		if min == max then
			item.range = tostring(min)
		elseif min < max then
			item.range = tostring(min).."~"..tostring(max)
		end
		table.insert(self.awardList,item)
	return self.awardList
end

function ChristmasBattleModel:getlenght(  )
	return table.nums(self.config)
end

--次数减一
function ChristmasBattleModel:jianyi(  )
	self.data.activity_info.times = self.data.activity_info.times - 1
end

function ChristmasBattleModel:getTodayRank(  )
	return self.data.today_rank
end

function ChristmasBattleModel:getYesterdayRank(  )
	return self.data.yesterday
end



return ChristmasBattleModel