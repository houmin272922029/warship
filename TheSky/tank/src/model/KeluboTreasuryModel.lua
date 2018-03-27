--[[
	
	Author: Your Name
	Date: 2016年07月13日15:09:18
]]

local KeluboTreasuryModel = qy.class("KeluboTreasuryModel", qy.tank.model.BaseModel)


function KeluboTreasuryModel:init(data)
	self.award_list = {}
	local staticData = qy.Config.kelubo_treasury 

	for i, v in pairs(staticData) do
		table.insert(self.award_list, v)
	end


	table.sort(self.award_list,function(a,b)
		return tonumber(a.id) < tonumber(b.id)
	end)


	self:update(data)
end



function KeluboTreasuryModel:update(_data)
	local data = _data
	if _data.activity_info then
		data = _data.activity_info
	end


	print("ssadasdasdasdsadas")

	self.start_time = data.start_time
	self.end_time = data.end_time
	self.startAwardTime = data.startAwardTime
	self.endAwardTime = data.endAwardTime
	self.cash = data.cash

end




return KeluboTreasuryModel