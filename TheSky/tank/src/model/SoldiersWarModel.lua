--[[
	将士之战
	Author: Your Name
	Date: 2016年07月13日15:09:18
]]

local SoldiersWarModel = qy.class("SoldiersWarModel", qy.tank.model.BaseModel)

function SoldiersWarModel:init(data)
	-- {"soldier_battle":{"status":0,"max_id":0,"current_id":0,"free_times":2,"buy_times":0,"left_buy_times":0}}
	self.status = data.soldier_battle.status
	self.max_id = data.soldier_battle.max_id
	self.current_id = data.soldier_battle.current_id
	self.free_times = data.soldier_battle.free_times
	self.buy_times = data.soldier_battle.buy_times
	self.left_buy_times = data.soldier_battle.left_buy_times
	self.vip_buy_times = qy.tank.model.VipModel:getSoldierWarBuyTimes()[qy.tank.model.UserInfoModel.userInfoEntity.vipLevel]
	self.current_times = data.soldier_battle.current_times
	self.award = data.award


	if self.current_id == 0 then
        self.current_id = 1
    end

	self.list = {}
	self.checkpointList = {}
	self.checkpoint_size = 0

	local staticData = qy.Config.soldier_battle_checkpoint
	for i, v in pairs(staticData) do
		local entity = qy.tank.entity.SoldiersWarCheckPointEntity.new(v)
		self.list[tostring(entity.checkpoint_id)] = entity
		if not self.checkpointList[tostring(math.floor((i - 1) / 5) + 1)] then
			self.checkpointList[tostring(math.floor((i - 1) / 5) + 1)] = {}
			table.insert(self.checkpointList[tostring(math.floor((i - 1) / 5) + 1)], entity)
		else
			table.insert(self.checkpointList[tostring(math.floor((i - 1) / 5) + 1)], entity)
		end
		self.checkpoint_size = self.checkpoint_size + 1
	end



	local staticData2 = qy.Config.soldier_battle_chest
	self.chest_list = {}
	for i, v in pairs(staticData2) do
		v["checkpoint_id"] = i
 
		local entity = qy.tank.entity.SoldiersWarChestEntity.new(v)

		table.insert(self.chest_list, entity)
	end


	table.sort(self.chest_list,function(a,b)
		return tonumber(a.checkpoint_id) < tonumber(b.checkpoint_id)
	end)


	self:sort()
end

function SoldiersWarModel:update(data)
	self.status = data.soldier_battle.status
	self.max_id = data.soldier_battle.max_id
	self.current_id = data.soldier_battle.current_id
	self.free_times = data.soldier_battle.free_times
	self.buy_times = data.soldier_battle.buy_times
	self.left_buy_times = data.soldier_battle.left_buy_times
	self.current_times = data.soldier_battle.current_times
	self.award = data.award

	if self.current_id == 0 then
        self.current_id = 1
    end	
end

function SoldiersWarModel:atCheckpoint()
	return self.list[tostring(self.current_id)]
end

function SoldiersWarModel:getCheckPointsById()
	return self.checkpointList[tostring(math.floor((self.current_id - 1) / 5) + 1)]
end

function SoldiersWarModel:getCurrentIdx()	
	local data = self:getCheckPointsById(self.current_id)
	for i, v in pairs(data) do
		if v.checkpoint_id == self.current_id then
			return i
		end
	end
	return 1
end

function SoldiersWarModel:sort()
	for i, v in pairs(self.checkpointList) do
		table.sort(v, function(a, b)
			return tonumber(a.checkpoint_id) < tonumber(b.checkpoint_id)
		end)
	end
end


function SoldiersWarModel:getTankIdByCurrentId()
	return self:atCheckpoint()["tank_id"]
end


function SoldiersWarModel:getChest() 
	return self.chest_list
end

function SoldiersWarModel:getChestById(idx) 
	return self.chest_list[idx]
end





return SoldiersWarModel