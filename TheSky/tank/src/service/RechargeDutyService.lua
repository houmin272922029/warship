--[[
	
	Author: 
	Date: 2016年07月13日15:08:24
]]

local RechargeDutyService = qy.class("RechargeDutyService", qy.tank.service.BaseService)

local model = qy.tank.model.RechargeDutyModel
-- 获取
function RechargeDutyService:get(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Activity.getInfo",
        ["p"] = {["activity_name"] = "recharge_duty"}
    })):send(function(response, request)
        model:init(response.data)
        callback(response.data)
    end)
end


function RechargeDutyService:getAward(callback, id)
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "Activity.getaward",
       ["p"] = {["activity_name"] = "recharge_duty", ["id"] = id}
    })):send(function(response, request)
       model:update(response.data)
       callback(response.data)
    end)
end



return RechargeDutyService

