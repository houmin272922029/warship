--[[
	
	Author: 
]]

local BoilDumplingService = qy.class("BoilDumplingService", qy.tank.service.BaseService)

local model = qy.tank.model.BoilDumplingModel
-- 获取
function BoilDumplingService:get(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Activity.getInfo",
        ["p"] = {["activity_name"] = "boil_dumpling"}
    })):send(function(response, request)
       model:init(response.data)
       callback(response.data)
    end)
end


function BoilDumplingService:getAward(callback, _type)
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "Activity.getaward",
       ["p"] = {["activity_name"] = "boil_dumpling", ["type"] = _type}
    })):send(function(response, request)
       model:update(response.data)
       callback(response.data)
    end)
end


return BoilDumplingService



