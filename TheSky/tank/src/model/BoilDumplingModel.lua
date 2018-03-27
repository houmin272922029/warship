--[[
	
	Author: Your Name
	Date: 2016年07月13日15:09:18
]]

local BoilDumplingModel = qy.class("BoilDumplingModel", qy.tank.model.BaseModel)


local userinfoModel = qy.tank.model.UserInfoModel

function BoilDumplingModel:init(data)
	local staticData = qy.Config.boil_dumpling
	self.score_award = {}
	for i, v in pairs(staticData) do
		table.insert(self.score_award, v)
	end

	table.sort(self.score_award, function(a, b)
   		return a.level < b.level
   	end)

	self:update(data)
end



function BoilDumplingModel:update(_data)
	local data = _data
	if _data.activity_info then
		data = _data.activity_info
	end

	self.to_eat_award = data.to_eat_award
	if self.point then
		self.add_point = (data.point or 0) - (self.point or 0)
	else
		self.add_point = 0
	end
	self.point = data.point or self.point
	self.level = data.level or self.level
	self.start_time = data.start_time or self.start_time
	self.end_time = data.end_time or self.end_time

end



return BoilDumplingModel