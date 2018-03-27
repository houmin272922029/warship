--[[
	登陆作战
	Author: Aaron Wei
	Date: 2016-03-05 14:32:25
]]

local Model = class("Model", qy.tank.model.BaseModel)

function Model:init(data)
	self.config = qy.Config.login_combat

	self.day = data.days
	self.end_time = data.end_time
	self.award_list = data.award_list

	self.list = {}
	for k,v in pairs(self.config) do
		if self.day >= v.day then
			v.is_draw = 1 -- 未领取
		else
			v.is_draw = 0 -- 不能领
		end
		v.schedule = math.min(self.day,v.day) 
		table.insert(self.list,v)
	end

	table.sort(self.list,function(a,b)
		return tonumber(a.day) < tonumber(b.day)
	end)

	for i=1,#self.award_list do
		self.list[self.award_list[i]].is_draw = 2 -- 已领取
	end
end

function Model:update(data)
	self:init(data)
end

return Model
