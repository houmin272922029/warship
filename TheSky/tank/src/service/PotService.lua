--[[
    大锅饭  服务
]]

local PotService = qy.class("PotService", qy.tank.service.BaseService)

PotService.model = qy.tank.model.PotModel

--主接口
function PotService:main(param, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Pot.main",
        ["p"] = {}
    })):send(function(response, request)
        self.model:init()
        self.model:update(response.data)
        callback(response.data)
    end)
end

-- 吃鸡
function PotService:eat(param, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Pot.eat",
        ["p"] = param
    })):send(function(response, request)
        self.model:update(response.data)
        callback(response.data)
    end)
end

-- 抽奖
function PotService:getAward(param, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Pot.getAward",
        ["p"] = param
    })):send(function(response, request)
        self.model:update(response.data)
        callback(response.data)
    end)
end

return PotService