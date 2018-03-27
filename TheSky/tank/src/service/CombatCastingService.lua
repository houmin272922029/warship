--[[
	
	Author: 
]]

local CombatCastingService = qy.class("CombatCastingService", qy.tank.service.BaseService)

local model = qy.tank.model.CombatCastingModel
-- 获取
function CombatCastingService:get(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Activity.getInfo",
        ["p"] = {["activity_name"] = "combat_casting"}
    })):send(function(response, request)
       model:init(response.data)
       callback(response.data)
    end)
end


function CombatCastingService:getAward(callback, times, is_no_alert)
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "Activity.getaward",
       ["p"] = {["activity_name"] = "combat_casting", ["type"] = 1, ["times"] = times, ["is_no_alert"] = is_no_alert}
    })):send(function(response, request)
       model:update(response.data)
       callback(response.data)
    end)
end


function CombatCastingService:getAward2(callback, _type)
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "Activity.getaward",
       ["p"] = {["activity_name"] = "combat_casting", ["type"] = _type}
    })):send(function(response, request)
       model:update(response.data)
       callback(response.data)
    end)
end



function CombatCastingService:getAward3(callback, achieve_id)
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "Activity.getaward",
       ["p"] = {["activity_name"] = "combat_casting", ["type"] = 3, ["achieve_id"] = achieve_id}
    })):send(function(response, request)
       model:update(response.data)
       callback(response.data)
    end)
end


return CombatCastingService



