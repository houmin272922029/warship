--[[
	火炬行动
	Author: Aaron Wei
	Date: 2016-01-05 14:58:45
]]

local TorchService = qy.class("TorchService", qy.tank.service.BaseService)

TorchService.model = require("torch.src.TorchModel")

function TorchService:get(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "torchoperation.get",
        ["p"] = {}
    })):send(function(response, request)
        self.model:init(response.data)
        callback()
    end)
end

function TorchService:draw(day,type,id,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "torchoperation.draw",
        ["p"] = {["day"] = day,["type"] = type,  ["task_id"] = id}
    })):send(function(response, request)
        -- self.model:init(response.data)
        callback(response.data)
    end)
end

function TorchService:buy(day,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "torchoperation.buy",
        ["p"] = {["day"] = day}
    })):send(function(response, request)
        -- self.model:init(response.data)
        callback(response.data)
    end)
end


return TorchService
