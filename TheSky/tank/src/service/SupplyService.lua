--[[--
    补给 service
    Author: H.X.Sun
    Date: 2015-05-04
--]]

local SupplyService = qy.class("SupplyService", qy.tank.service.BaseService)

SupplyService.model = qy.tank.model.SupplyModel

--[[--
--获取补给信息
--]]
function SupplyService:getSupplyInfo(param, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "supply.show",
        ["p"] = {}
    })):send(function(response, request)
        self.model:getSupplyInfo(response.data)
        callback(response.data)
    end)
end

--[[--
--补给操作
--]]
function SupplyService:supplyOperation(param, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "supply.supply",
        ["p"] = {["ftue"] = qy.GuideModel:getCurrentBigStep()}
    })):send(function(response, request)
        self.model:supplyOperation(response.data)
        callback(response.data)
    end)
end

return SupplyService