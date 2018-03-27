
local StrongService = qy.class("StrongService", qy.tank.service.BaseService)

StrongService.model = qy.tank.model.StrongModel

--[[--
--获玩家信息
--]]
function StrongService:getSupplyInfo(param, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "supply.show",
        ["p"] = {}
    })):send(function(response, request)
        self.model:getSupplyInfo(response.data)
        callback(response.data)
    end)
end

return StrongService