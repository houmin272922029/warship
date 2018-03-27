--[[
	军魂
	Author: mingming
	Date: 2015-06-13 15:49:49
]]

local SoulService = qy.class("SoulService", qy.tank.service.BaseService)

function SoulService:load(param, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "soul.load",
        ["p"] = param,
    })):send(function(response, request)
        qy.tank.model.SoulModel:update(response.data.soul)
        callback(response.data)
    end)
end

function SoulService:unload(param,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "soul.unload",
        ["p"] = param
    })):send(function(response, request)
        qy.tank.model.SoulModel:update(response.data.soul)
        callback(response.data)
    end)
end

function SoulService:apart(param,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "soul.apart",
        ["p"] = param
    })):send(function(response, request)
        if response.data.award then
            qy.tank.command.AwardCommand:add(response.data.award)
            qy.tank.command.AwardCommand:show(response.data.award)
        end
        callback(response.data)
    end)
end

function SoulService:upgrade(param,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "soul.upgrade",
        ["p"] = param
    })):send(function(response, request)
        -- self.model:updateFormation(response.data)
        qy.tank.model.SoulModel:update(response.data.soul)
        callback(response.data)
    end)
end

return SoulService



