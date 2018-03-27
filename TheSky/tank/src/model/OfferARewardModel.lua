--[[
	军功悬赏
	Author: Your Name
	Date: 2016年07月13日15:09:18
]]

local OfferARewardModel = qy.class("OfferARewardModel", qy.tank.model.BaseModel)


local userinfoModel = qy.tank.model.UserInfoModel
local NumberUtil = qy.tank.utils.NumberUtil

function OfferARewardModel:init(data)
	--self.table_reward_information = {}	
	self.table_reward_intell_content = {}
	self.table_reward_intell_consume = {}
	self.table_reward = {}

	self.current_selected = 1

	-- local staticData = qy.Config.reward_information
	-- for i, v in pairs(staticData) do
	-- 	table.insert(self.table_reward_information, v)
	-- end

	local staticData2 = qy.Config.reward_intell_content
	for i, v in pairs(staticData2) do
		table.insert(self.table_reward_intell_content, v)
	end


	local staticData2 = qy.Config.reward_intell_consume
	for i, v in pairs(staticData2) do
		table.insert(self.table_reward_intell_consume, v)
	end


	local staticData2 = qy.Config.reward
	for i, v in pairs(staticData2) do
		table.insert(self.table_reward, v)
	end


	-- table.sort(self.table_reward_information,function(a,b)
	-- 	return tonumber(a.id) < tonumber(b.id)
	-- end)

	table.sort(self.table_reward_intell_content,function(a,b)
		return tonumber(a.id) < tonumber(b.id)
	end)

	table.sort(self.table_reward_intell_consume,function(a,b)
		return tonumber(a.id) < tonumber(b.id)
	end)

	table.sort(self.table_reward,function(a,b)
		return tonumber(a.id) < tonumber(b.id)
	end)

	self:update(data)
end



function OfferARewardModel:getEndTime()
	local time = self.endTime - userinfoModel.serverTime
	if time > 0 then
		return NumberUtil.secondsToTimeStr(time, 6)
	else
		return qy.TextUtil:substitute(63035)
	end
end


function OfferARewardModel:update(data)
	self.new_list = data.reward.new_list
	self.ongoing_list = data.reward.ongoing_list
	self.complete_list = data.reward.complete_list
	self.free_times = data.reward.free_times
	self.finish = data.finish or {}
end


function OfferARewardModel:getNewList()
	return self.new_list
end

function OfferARewardModel:getOngoingList()
	return self.ongoing_list
end

function OfferARewardModel:getCompleteList()
	return self.complete_list
end

function OfferARewardModel:getRewardById(id)
	return self.table_reward[id]
end

function OfferARewardModel:getRewardInformationById(id)
	return self.table_reward_information[id]
end

function OfferARewardModel:getRewardContent()
	return self.table_reward_intell_content[math.random(1, #self.table_reward_intell_content)]
end

function OfferARewardModel:getRewardConsumeById(id)
	return self.table_reward_intell_consume[id]
end

function OfferARewardModel:getFinish()
	return self.finish
end

function OfferARewardModel:getFreeRefreshTimes()
	return self.free_times
end

return OfferARewardModel