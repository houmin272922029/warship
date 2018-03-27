--[[
    -- 精英招募
    Date: 2016-09-5
]]

local OutStandingEntity = qy.class("OutStandingEntity", qy.tank.entity.BaseEntity)

function OutStandingEntity:ctor(data, data2)
	self:setproperty("id", data.id)
	self:setproperty("times", data.times)
	self:setproperty("award", data.award)
	if data2[data.times..""] == 0 then
		self:setproperty("index", 1)
	elseif  data2[data.times..""] == 1 then
		self:setproperty("index", 2)
	elseif  data2[data.times..""] == 2 then
		self:setproperty("index", 0)
	end
end

return OutStandingEntity