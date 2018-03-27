--[[
	
	Author: 
]]

local GodWorshipService = qy.class("GodWorshipService", qy.tank.service.BaseService)

local model = qy.tank.model.GodWorshipModel
-- 获取
function GodWorshipService:get(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Activity.getInfo",
        ["p"] = {["activity_name"] = "god_worship"}
    })):send(function(response, request)
       model:init(response.data)
       callback(response.data)
    end)
end


function GodWorshipService:getAward(callback, _type)
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "Activity.getaward",
       ["p"] = {["activity_name"] = "god_worship", ["type"] = _type}
    })):send(function(response, request)
       model:update(response.data)
       callback(response.data)
    end)
end


return GodWorshipService



