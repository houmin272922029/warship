--[[
	
	Author: Your Name
	Date: 2016年07月13日15:09:18
]]

local IntruderTimeModel = qy.class("IntruderTimeModel", qy.tank.model.BaseModel)


function IntruderTimeModel:init(data)
	self.monster_list = {}

	
	local staticData = qy.Config.intruder_time_checkpoint 

	for i, v in pairs(staticData) do
		table.insert(self.monster_list, v)
	end

	table.sort(self.monster_list,function(a,b)
		return tonumber(a.id) < tonumber(b.id)
	end)


	self:update(data)
end



function IntruderTimeModel:update(_data)
	local data = _data
	if _data.activity_info then
		data = _data.activity_info
	end


	self.start_time = data.start_time or self.start_time
	self.end_time = data.end_time or self.end_time

	self.repulse = data.repulse or self.repulse
	self.help = data.help or self.help
	self.intruder = data.intruder or self.intruder

end




return IntruderTimeModel