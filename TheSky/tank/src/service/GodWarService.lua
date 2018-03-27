--[[
	
	Author: 
]]

local GodWarService = qy.class("GodWarService", qy.tank.service.BaseService)

local model = qy.tank.model.GodWarModel
-- 获取
function GodWarService:get(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "RechargeBuff.index",
        ["p"] = {}
    })):send(function(response, request)
       model:update(response.data)
       callback(response.data)
    end)
end
function GodWarService:getAward(callback)
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "RechargeBuff.getAward",
       ["p"] = {}
    })):send(function(response, request)
        qy.tank.command.AwardCommand:add(response.data.award)
        qy.tank.command.AwardCommand:show(response.data.award)
        callback(response.data)
    end)
end


return GodWarService



