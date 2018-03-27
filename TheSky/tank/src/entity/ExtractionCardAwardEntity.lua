--[[
    -- 军资基地 （领奖）
    Date: 2016-04-27
]]

local ExtractionCardAwardEntity = qy.class("ExtractionCardAwardEntity", qy.tank.entity.BaseEntity)

function ExtractionCardAwardEntity:ctor(data)
	self:setproperty("times", data.times)
	self:setproperty("award", data.award)
	self:setproperty("id", data.id)
end

return ExtractionCardAwardEntity