--[[
    威震欧亚
]]
local FameModel = qy.class("FameModel", qy.tank.model.BaseModel)

function FameModel:init(data)
	self.times = data.overawe.times or 0
end

function FameModel:update(data) 
    self.times = data.overawe.times
end

function  FameModel:getList()
	return self.times
end

return FameModel