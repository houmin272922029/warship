--
-- Author: Your Name
-- Date: 2015-05-25 17:35:56
--
local ArenaModel = qy.class("ArenaModel", qy.tank.model.BaseModel)

-- 排名
ArenaModel.rank = 0

function ArenaModel:init(data)
	local start_time = os.clock()

	self.userInfo = qy.tank.model.UserInfoModel.userInfoEntity
	self.myChallengeIdx = nil
	self.myRankIdx = nil

	for k,v in pairs(data.my_arena) do
		self[k] = v	
		if k == "rank" then
			self.rank = v
		end
	end

	self.challengeList = {} 
	for i=1,#data.arena do
		-- print(qy.json.encode(data.arena[i]))
		local entity = ArenaModel.Entity.new(data.arena[i])
		table.insert(self.challengeList,entity)
		if data.arena[i].kid == self.userInfo.kid then
			self.myChallengeIdx = i
		end
	end
	
	self.rankList = {} 
	for i=1,#data.rank do
		local entity = ArenaModel.Entity.new(data.rank[i])
		table.insert(self.rankList,entity)
		if data.rank[i].kid == self.userInfo.kid then
			self.myRankIdx = i
		end
	end

	local awards = qy.Config.arena_daily_award
	self.awardList = {}
	for i=1,15 do
		local item = awards[tostring(i)]
		local min,max = awards[tostring(i)].min_rank,awards[tostring(i)].max_rank
		if max <= 0 then
			item.range = qy.TextUtil:substitute(46008)..tostring(min).."~..."..qy.TextUtil:substitute(50012)
		elseif min == max then
			item.range = qy.TextUtil:substitute(46008)..tostring(min)..qy.TextUtil:substitute(50012)
		else
			item.range = qy.TextUtil:substitute(46008)..tostring(min).."~"..tostring(max)..qy.TextUtil:substitute(50012)
		end
		table.insert(self.awardList,item)
	end

	local end_time = os.clock()
	print("ArenaModel:init",end_time-start_time)
end

function ArenaModel:update(data)
end

ArenaModel.Entity = qy.class("Entity", qy.tank.entity.BaseEntity)

function ArenaModel.Entity:ctor(data)
	for k,v in pairs(data) do
		self[k] = v
	end
	-- self.kid = data.kid
	-- self.rank = data.rank
	-- self.level = data.level
	-- self.nickname = data.nickname
	-- self.fight_power = data.fight_power
	-- self.formation = data.formation

	if self.rank == 1 then
		self.icon = "Resources/arena/JJC_12.png"
	elseif self.rank == 2 then
		self.icon = "Resources/arena/JJC_13.png"
	elseif self.rank == 3 then
		self.icon = "Resources/arena/JJC_14.png"
	else
		self.icon = "Resources/arena/JJC_4.png"
	end

	for i=1,#self.formation do
		if data.kid <= 10000 then
			self.formation[i] = qy.tank.entity.TankEntity.new(self.formation[i],3,true)
		else
			self.formation[i] = qy.tank.entity.TankEntity.new(self.formation[i],0,true)
		end
	end
end

-- 军神商店
function ArenaModel:initGoodsList()
	local data = qy.Config.arena_shop
	if self.goodsList == nil or #self.goodsList < 1 then
		self.goodsList = {}
		for k, v in pairs(data) do
			self.goodsList[v.id] = v
			self.goodsList[v.id].remain_times = 1
		end
	end
end

function ArenaModel:updateGoodsByData(data)
	if self.goodsList and self.goodsList[data.id] then
		self.goodsList[data.id].remain_times = data.remain_times
	end
end

function ArenaModel:updateGoodsList(data)
	if data.shopInfo and #data.shopInfo > 0 then
		for i = 1, #data.shopInfo do
			self:updateGoodsByData(data.shopInfo[i])
		end
	end
end

function ArenaModel:getExpeditionGoodsNum()
	if self.goodsList then
		return #self.goodsList
	end
end

function ArenaModel:getExGoodsByIndex(idx)
	return self.goodsList[idx]
end

return ArenaModel