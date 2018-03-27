

local LegionRechargeModel = qy.class("LegionRechargeModel", qy.tank.model.BaseModel)



function LegionRechargeModel:init(data)
	self.data = data
	self.start_time = data.server_time
	self.end_time = data.end_time
	self.config = qy.Config.legion_recharge
end

function LegionRechargeModel:getAward(id)
	local list = {}
	for k,v in pairs(self.config) do
		if k == id then
			table.insert(list,v)
		end
	end
	return list
end

function LegionRechargeModel:getStatus(idx)
	if self.data.user_activity_data.contribution >= 3000 and self.data.user_activity_data.recharge >= 200 then
		if self.data.my_legion_recharge_info.recharge >= self.config[tostring(idx)].cash then
			local x = self:is_exist(idx)
			if x then
				return 2 --已领取
			else
				return 1 --未领取
			end
		else
			return 0 --不能领取置灰
		end
	else
		return 0 
	end
end

function LegionRechargeModel:is_exist(idx)
	for k,v in pairs(self.data.user_activity_data.get_log) do
		if tonumber(idx) == tonumber(k) then
			return true
		end

	end
	return false
end

function LegionRechargeModel:changeget_log(idx)
	self.data.user_activity_data.get_log[tostring(idx)] = "1"
end

return LegionRechargeModel