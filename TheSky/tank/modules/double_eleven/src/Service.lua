--[[
    双十一活动
]]
local Service = qy.class("Service", qy.tank.service.BaseService)

Service.model = require("double_eleven.src.Model")

function Service:getInfo(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "activity.getInfo",
        ["p"] = {["activity_name"]="double_eleven"}
    })):send(function(response, request)
        self.model:init(response.data.activity_info)
        callback()
    end)
end

function Service:buy(id,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "activity.getaward",
        ["p"] = {["activity_name"]="double_eleven",["award_id"]=id}
    })):send(function(response, request)
        -- self.model:update(response.data)
        qy.tank.command.AwardCommand:add(response.data.award)
        qy.tank.command.AwardCommand:show(response.data.award,{["isShowHint"]=false})
        callback()
    end)
end

return Service
