--[[
	
	Author: 
	Date: 2016年07月13日15:08:24
]]

local IntruderTimeService = qy.class("IntruderTimeService", qy.tank.service.BaseService)

-- 获取
function IntruderTimeService:get(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Activity.getInfo",
        ["p"] = {["activity_name"] = "intruder_time"}
    })):send(function(response, request)
        callback(response.data)
    end)
end


function IntruderTimeService:go(callback, from_id, to_id)
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "tank.inherit",
       ["p"] = {["from_id"] = from_id, ["to_id"] = to_id}
    })):send(function(response, request)
       callback(response.data)
       if response.data.tank then
            for key, var in pairs(response.data.tank) do
                local entity = qy.tank.model.GarageModel:getEntityByUniqueID(key)
                entity:__initByData(response.data.tank[key])
            end
        end

        if response.data.soul then
          qy.tank.model.SoulModel:update(response.data.soul)
        end
    end)
end

return IntruderTimeService



