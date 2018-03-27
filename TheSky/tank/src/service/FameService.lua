--[[
    威震欧亚
]]

local FameService = qy.class("FameService", qy.tank.service.BaseService)

local model = qy.tank.model.FameModel

function FameService:getList(param, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "overawe.get",
        ["p"] = {}
    })):send(function(response, request)
        model:init(response.data)
        callback(response.data)
    end)
end
--type:int:
function FameService:draw(param, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "overawe.draw",
        ["p"] = param
    })):send(function(response, request)
        model:update(response.data)
        callback(response.data)
    end)
end

return FameService