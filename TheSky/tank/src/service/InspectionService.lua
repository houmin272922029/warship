--[[
    每日检阅  服务
]]

local InspectionService = qy.class("InspectionService", qy.tank.service.BaseService)

InspectionService.model = qy.tank.model.InspectionModel

function InspectionService:getList(param, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Inspection.getList",
        ["p"] = {}
    })):send(function(response, request)
        self.model:init()
        self.model:update(response.data)
        callback(response.data)
    end)
end

function InspectionService:set(param, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Inspection.set",
        ["p"] = param
    })):send(function(response, request)
        callback(response.data)
    end)
end

return InspectionService