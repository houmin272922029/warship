--[[
    兑换 service
    Author: H.X.Sun
]]
local ExchangeService = qy.class("ExchangeService", qy.tank.service.BaseService)

local AwardCommand = qy.tank.command.AwardCommand

function ExchangeService:exchangeCdkey(_key, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "cdkey.exchange_cdkey",
        ["p"] = {["cdkey"] = _key}
    })):send(function(response, request)
        AwardCommand:add(response.data.award)
        callback(response.data)
    end)
end

return ExchangeService
