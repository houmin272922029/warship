--[[
	
	Author: 
]]

local LeapFundService = qy.class("LeapFundService", qy.tank.service.BaseService)

local model = qy.tank.model.LeapFundModel
-- 获取
function LeapFundService:get(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Activity.getInfo",
        ["p"] = {["activity_name"] = "leap_fund"}
    })):send(function(response, request)
       model:init(response.data)
       callback(response.data)
    end)
end


function LeapFundService:getAward(callback, level)
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "Activity.getaward",
       ["p"] = {["activity_name"] = "leap_fund", ["level"] = level}
    })):send(function(response, request)
       model:update(response.data)
       callback(response.data)
    end)
end



return LeapFundService



