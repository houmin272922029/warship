--[[
	
	Author: Your Name
	Date: 2016年07月13日15:09:18
]]

local YuriEngineerModel = qy.class("YuriEngineerModel", qy.tank.model.BaseModel)


local userinfoModel = qy.tank.model.UserInfoModel

function YuriEngineerModel:init(data)
	self.award_list = {}

	local staticData = qy.Config.yuri_engineer 

	for i, v in pairs(staticData) do
		table.insert(self.award_list, v)
	end

	table.sort(self.award_list,function(a,b)
		return tonumber(a.id) < tonumber(b.id)
	end)




	self.rank_award_list = {}

	local staticData2 = qy.Config.yuri_engineer_rank 

	for i, v in pairs(staticData2) do
		table.insert(self.rank_award_list, v)
	end

	table.sort(self.rank_award_list,function(a,b)
		return tonumber(a.id) < tonumber(b.id)
	end)


	self:update(data)
end



function YuriEngineerModel:update(_data)
	local data = _data
	if _data.activity_info then
		data = _data.activity_info
	end

	self.start_time = data.start_time or self.start_time
	self.end_time = data.end_time or self.end_time
	self.today_best = data.today_best or self.today_best
	self.record = data.record or self.record
	self.today_times = data.today_times or self.today_times
	--self.best_max = data.best_max or self.best_max
	self.best_max = data.week_max or self.best_max
	self.award = data.award
	self.upper_limit = data.upper_limit 
	self.level = data.level
	self.rank_list = data.rank_list or self.rank_list
	self.my_rank = data.my_rank or self.my_rank
end



return YuriEngineerModel