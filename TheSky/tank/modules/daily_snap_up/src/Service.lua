--[[
	每日福利
]]
local Service = qy.class("Service", qy.tank.service.BaseService)
Service.model = require("daily_snap_up.src.Model")



function Service:getInfo(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"]= "activity.getInfo",
        ["p"]= {["activity_name"]= "daily_welfare"}
    })):send(function(response, request)
        self.model:init(response.data.activity_info)
        callback()
    end)
end

return Service
