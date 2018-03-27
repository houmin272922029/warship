--[[
    -- 探宝日记
    Date: 2016-05-10
]]

local SearchTreasureEntity = qy.class("SearchTreasureEntity", qy.tank.entity.BaseEntity)

function SearchTreasureEntity:ctor(data)
	if data.rank then
		self:__initRankAwardList(data)
	elseif data.times then
		self:__initTimesAwardList(data)
	else
		self:__initTreaseAwardList(data)
	end
end

function SearchTreasureEntity:__initRankAwardList(data)
	self:setproperty("rank", data.rank)
	self:setproperty("rankAwardList", data.award)
end

function SearchTreasureEntity:__initTimesAwardList(data)
	self:setproperty("ID", data.ID)
	self:setproperty("times", data.times)
	self:setproperty("timesAwardList", data.award)
end

function SearchTreasureEntity:__initTreaseAwardList(data)
	self:setproperty("id", data.id)
	self:setproperty("award", data.award)
	self:setproperty("weight", data.weight)
end

return SearchTreasureEntity