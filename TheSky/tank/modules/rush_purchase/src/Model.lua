--[[
	时限抢购
	Author: Aaron Wei
	Date: 2016-01-29 20:48:48
]]

local Model = class("Model", qy.tank.model.BaseModel)

function Model:init(data)
	self.config = qy.Config.limit_time_sale

	self.start_time = data.start_time
	self.end_time = data.end_time
	self.award_list = data.award_list

	self.list = {}
	for k,v in pairs(self.config) do
		v.buy = data.buyed[k]
		table.insert(self.list,v)
	end

	table.sort(self.list,function(a,b)
		return tonumber(a.id) < tonumber(b.id)
	end)
end

function Model:update(data)
	self:init(data)
	self.award = data.award	
end

return Model
