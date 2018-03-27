--[[
	战力竞赛
	Author: Your Name
	Date: 2016年07月13日15:09:18
]]

local MatchFightPowerModel = qy.class("MatchFightPowerModel", qy.tank.model.BaseModel)


local userinfoModel = qy.tank.model.UserInfoModel
local NumberUtil = qy.tank.utils.NumberUtil

function MatchFightPowerModel:init(data)
	self.list = {}
	self.ranking = data.activity_info.ranking or 0
	self.endTime = data.activity_info.endtime or 0
	self.myFightPower = data.activity_info.FightPower or qy.tank.model.UserInfoModel.userInfoEntity.fightPower

	self.chest_list = {}
	local staticData = qy.Config.fightpower_ranking_award
	for i, v in pairs(staticData) do
		table.insert(self.chest_list, v)
	end


	self.power_chest_list = {}
	local staticData2 = qy.Config.fightpower_award
	for i, v in pairs(staticData2) do
		table.insert(self.power_chest_list, v)
	end

	for i, v in pairs(data.activity_info.list) do
		table.insert(self.list, v)
	end

	table.sort(self.list,function(a,b)
		return tonumber(a.ranking) < tonumber(b.ranking)
	end)

	table.sort(self.chest_list,function(a,b)
		return tonumber(a.rank) < tonumber(b.rank)
	end)

	table.sort(self.power_chest_list,function(a,b)
		return tonumber(a.id) < tonumber(b.id)
	end)

end



function MatchFightPowerModel:getEndTime()
	local time = self.endTime - userinfoModel.serverTime
	if time > 0 then
		return NumberUtil.secondsToTimeStr(time, 6)
	else
		return qy.TextUtil:substitute(63035)
	end
end

function MatchFightPowerModel:update(data)
	self.list = data.activity_info.list
	self.ranking = data.activity_info.ranking
end



return MatchFightPowerModel