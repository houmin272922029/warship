--[[
	登陆作战
	Author: Aaron Wei
	Date: 2016-03-05 14:33:12
]]

local Service = qy.class("Service", qy.tank.service.BaseService)

Service.model = require("login_total.src.Model")

function Service:getInfo(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "activity.getInfo",
        ["p"] = {["activity_name"]="login_combat"}
    })):send(function(response, request)
        self.model:init(response.data.activity_info)
        callback()
    end)
end

function Service:getAward(id,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "activity.getaward",
        ["p"] = {["activity_name"]="login_combat",["id"]=id}
    })):send(function(response, request)
        self.model:update(response.data)
        qy.tank.command.AwardCommand:add(response.data.award)
        qy.tank.command.AwardCommand:show(response.data.award)
        callback()
    end)
end

return Service
