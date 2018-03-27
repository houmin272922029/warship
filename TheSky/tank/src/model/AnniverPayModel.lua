--[[
	Author: fq
	Date: 2016年08月05日15:02:46
]]

local AnniverPayModel = qy.class("AnniverPayModel", qy.tank.model.BaseModel)

local userinfoModel = qy.tank.model.UserInfoModel
local NumberUtil = qy.tank.utils.NumberUtil

function AnniverPayModel:init(_data)

	self:update(_data)
end

function AnniverPayModel:update(_data)
	local data = _data

	if _data.activity_info then 
		data = _data.activity_info
	end

	self.startTime = data.start_time or self.start_time
	self.endTime = data.end_time or self.end_time

end




return AnniverPayModel