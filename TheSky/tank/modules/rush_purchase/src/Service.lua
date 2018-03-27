--[[
	Author: Your Name
	Date: 2016-01-29 19:51:27
]]
local Service = qy.class("Service", qy.tank.service.BaseService)

Service.model = require("rush_purchase.src.Model")

function Service:getInfo(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "activity.getInfo",
        ["p"] = {["activity_name"]="limit_time_sale"}
    })):send(function(response, request)
        self.model:init(response.data.activity_info)
        callback()
    end)
end

function Service:buy(id,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "activity.getaward",
        ["p"] = {["activity_name"]="limit_time_sale",["id"]=id}
    })):send(function(response, request)
        self.model:update(response.data)
        qy.tank.command.AwardCommand:add(response.data.award)
        qy.tank.command.AwardCommand:show(response.data.award)
        callback()
    end)
end

return Service
