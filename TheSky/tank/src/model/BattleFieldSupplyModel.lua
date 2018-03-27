--[[
	
	Author: Your Name
	Date: 2016年07月13日15:09:18
]]

local BattleFieldSupplyModel = qy.class("BattleFieldSupplyModel", qy.tank.model.BaseModel)


local userinfoModel = qy.tank.model.UserInfoModel
local NumberUtil = qy.tank.utils.NumberUtil
function BattleFieldSupplyModel:init(data)
	self.award_list = {}

	
	local staticData = qy.Config.battlefield_supply 

	for i, v in pairs(staticData) do
		table.insert(self.award_list, v)
	end

	table.sort(self.award_list,function(a,b)
		return tonumber(a.id) < tonumber(b.id)
	end)


	self:update(data)
end



function BattleFieldSupplyModel:update(_data)
	local data = _data
	if _data.activity_info then
		data = _data.activity_info
	end


	self.start_time = data.start_time or self.start_time
	self.end_time = data.end_time or self.end_time
	self.cash_id = data.cash_id or self.cash_id

end



function BattleFieldSupplyModel:getRemainTime()
	local time = self.end_time - userinfoModel.serverTime
	if time > 0 then
		return NumberUtil.secondsToTimeStr(time, 6)
	else
		return qy.TextUtil:substitute(63035)
	end
end



return BattleFieldSupplyModel