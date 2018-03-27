--[[
	军魂之路
	Author: Your Name
	Date: 2015-06-13 15:04:55
]]

local SoulRoadModel = qy.class("SoulRoadModel", qy.tank.model.BaseModel)

function SoulRoadModel:init(data)
	-- {"soul_road":{"current_scene":1,"complete_scene":0,"buy_times":0,"current":1,"complete":0,"left_free_times":9,"left_buy_times":0,"is_draw_daily_award":0}}
	self.current_scene = data.soul_road.current_scene
	self.complete_scene = data.soul_road.complete_scene
	self.buy_times = data.soul_road.buy_times
	self.current = data.soul_road.current
	self.complete = data.soul_road.complete
	self.left_free_times = data.soul_road.left_free_times
	self.left_buy_times = data.soul_road.left_buy_times
	self.is_draw_daily_award = data.soul_road.is_draw_daily_award

	self.checkpointList = {}
	self.list = {}

	local staticData = qy.Config.soul_road_checkpoint

	for i, v in pairs(staticData) do
		local entity = qy.tank.entity.SoulCheckPointEntity.new(v)
		if not self.checkpointList[tostring(v.scene_id)] then
			self.checkpointList[tostring(v.scene_id)] = {}
			table.insert(self.checkpointList[tostring(v.scene_id)], entity)
		else
			table.insert(self.checkpointList[tostring(v.scene_id)], entity)
		end

		self.list[tostring(entity.checkpoint_id)] = entity
		-- if self.complete >= entity.checkpoint_id then
		-- 	entity.complete = true
		-- end

		-- if self.current == entity.checkpoint_id then
		-- 	entity.current = true
		-- end
	end

	self:sort()
end

function SoulRoadModel:update(data)
	self.current_scene = data.current_scene
	self.complete_scene = data.complete_scene
	self.buy_times = data.buy_times
	self.current = data.current
	self.complete = data.complete
	self.left_free_times = data.left_free_times
	self.left_buy_times = data.left_buy_times
	self.is_draw_daily_award = data.is_draw_daily_award
	self.buy_times = data.buy_times
end

function SoulRoadModel:atCheckpoint(checkpoint_id)
	return self.list[tostring(checkpoint_id)]
end

function SoulRoadModel:atSecne(sceneId)
	return qy.Config.soul_road_scene[tostring(sceneId)]
end

function SoulRoadModel:getCheckPointByScene(sceneID)
	return self.checkpointList[tostring(sceneID)]
end

function SoulRoadModel:getCurrentIdx(sceneId)
	local data = self:getCheckPointByScene(sceneId)
	for i, v in pairs(data) do
		if v.checkpoint_id == self.current then
			return i
		end
	end
	return 1
end

function SoulRoadModel:sort()
	for i, v in pairs(self.checkpointList) do
		table.sort(v, function(a, b)
			return tonumber(a.checkpoint_id) < tonumber(b.checkpoint_id)
		end)
	end
end

-- 获取购买次数的花费
function SoulRoadModel:getFreeNum(n)
	local num = 0
	if not n then
		num = 2 * (self.buy_times + 1)
	else
		num = 2 * n
	end
	num = num > 20 and 20 or num
	return num
end

-- 获取扫荡花费
function SoulRoadModel:getAutoFightCost(num)
	if self.left_free_times + self.left_buy_times >= num then
		return 0
	else
		local total = 0
		local times =  num - (self.left_free_times + self.left_buy_times)
		if self.buy_times == 0 then
			for i = 1, num - self.left_free_times do
				total = total + self:getFreeNum(i)
			end 
		else
			if num <= self.left_free_times + self.left_buy_times then
				local total = 0
			else
				for i = self.buy_times + 1, self.buy_times + num - (self.left_free_times + self.left_buy_times) do
					total = total + self:getFreeNum(i)
				end 
			end
		end
		return total
	end
end

return SoulRoadModel