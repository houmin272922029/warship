--[[
	孤胆英雄
	Author: Your Name
	Date: 2015-06-13 15:04:55
]]

local SingleHeroModel = qy.class("SingleHeroModel", qy.tank.model.BaseModel)

function SingleHeroModel:init(data)
	-- {"single_hero":{"buy_times":0,"current":1,"tank_unique_id":0,"complete":0,"left_free_times":10}}
	self.buy_times = data.single_hero.buy_times
	self.current = data.single_hero.current
	self.tank_unique_id = data.single_hero.tank_unique_id
	self.complete = data.single_hero.complete
	self.left_free_times = data.single_hero.left_free_times

	self.list = {}
	local staticData = qy.Config.single_hero_checkpoint
	for i, v in pairs(staticData) do
		local entity = qy.tank.entity.SingleHeroEntity.new(v)
		table.insert(self.list, entity)
	end

	self:sort()
	self.page = math.ceil(self.current / 3)

	self:finalList()
end

function SingleHeroModel:update(data)
	self.buy_times = data.buy_times
	self.current = data.current
	self.tank_unique_id = data.tank_unique_id
	self.complete = data.complete
	self.left_free_times = data.left_free_times

	self.page = math.ceil(self.current / 3)
end

function SingleHeroModel:sort()
	table.sort(self.list, function(a, b)
		return a.checkpoint_id < b.checkpoint_id
	end)
end

function SingleHeroModel:getPageList()
	return self.finalList_[self.page]
end

function SingleHeroModel:finalList()
	self.finalList_ = qy.Utils.oneToTwo(self.list, math.ceil(table.nums(self.list) / 3), 3)
end

function SingleHeroModel:setPage(page)
	if page < 1 then
		page = 1
	end

	if page > #self.finalList_ then
		page = #self.finalList_
	end
	self.page = page
end

function SingleHeroModel:getMaxPage()
	return #self.finalList_
end

function SingleHeroModel:setPlayList(data)
	self.playList = data.list
end

function SingleHeroModel:setRank(data)
	self.myrank = data.myrank
	self.ranklist = data.rank
end

return SingleHeroModel
