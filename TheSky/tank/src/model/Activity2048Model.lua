--[[
	
	Author: Your Name
	Date: 2016年07月13日15:09:18
]]

local Activity2048Model = qy.class("Activity2048Model", qy.tank.model.BaseModel)


function Activity2048Model:init(data)


	self.award_list = {}

	local staticData = qy.Config.activity_2048_award 


	for i, v in pairs(staticData) do
		table.insert(self.award_list, v.val)
	end

	self.hammer_pay_remain_num = 0
	self.hammer_pay_num = 0


	self:update(data)
end



function Activity2048Model:update(_data)
	local data = _data
	if _data.activity_info then
		data = _data.activity_info
	end


	self.hammer_pay_remain_num = data.hammer_pay_remain_num or self.hammer_pay_remain_num
	self.game_remain_num = data.game_remain_num or self.game_remain_num
	self.max_silver = data.max_silver or self.max_silver
	self.hammer_pay_num = data.hammer_pay_num or self.hammer_pay_num
	self.game_start_sign = data.game_start_sign or self.game_start_sign
	self.max_integral = data.max_integral or self.max_integral
	self.game_num = data.game_num or self.game_num
	self.integral = data.integral or self.integral
	self.schedule = data.schedule or self.schedule
	self.get_silver = data.get_silver or self.get_silver
	self.end_time = data.end_time or self.end_time
end


function Activity2048Model:initRankList(_data)
	local data = _data
	if _data.activity_info then
		data = _data.activity_info
	end

	self.rank = data.rank
	self.rank_list = data.list
	self.source = data.source
end

return Activity2048Model