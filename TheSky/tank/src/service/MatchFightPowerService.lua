--[[
	战力竞赛
	Author: 
	Date: 2016年07月13日15:08:24
]]

local MatchFightPowerService = qy.class("MatchFightPowerService", qy.tank.service.BaseService)

local model = qy.tank.model.MatchFightPowerModel
-- 获取
function MatchFightPowerService:get(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "activity.matchfightpower",
    })):send(function(response, request)
        model:init(response.data)
        callback(response.data)
    end)
end


return MatchFightPowerService



