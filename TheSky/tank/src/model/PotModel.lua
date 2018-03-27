--[[
    伞兵入侵model
    add by lianyi
]]
local PotModel = qy.class("PotModel", qy.tank.model.BaseModel)

PotModel.says = {
	["1"] = qy.TextUtil:substitute(80004),
	["2"] = qy.TextUtil:substitute(80005),
	["3"] = qy.TextUtil:substitute(80006),
	["4"] = qy.TextUtil:substitute(80007),
	["5"] = qy.TextUtil:substitute(80008),
}

function PotModel:init()
	self.status = 0
	self.list = nil
	self.award = nil
end

function PotModel:update(data) 
	if data.status~=nil then
		self.status = data.status
	end

	if data.list ~=nil then
		self.list = data.list
	end

	if data.award ~=nil then
		self.award = data.award
	end
end

function PotModel:getAwardList( )
	return self.list 
end

return PotModel