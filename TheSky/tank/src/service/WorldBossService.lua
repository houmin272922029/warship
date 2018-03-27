--[[
    世界BOSS
    Author: Aaron Wei
    Date: 2015-12-01 15:10:44
]]

local WorldBossService = qy.class("WorldBossService", qy.tank.service.BaseService)

function WorldBossService:getList(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "boss.get",
    })):send(function(response, request)
        qy.tank.model.WorldBossModel:init(response.data)
        callback()
    end)
end

function WorldBossService:inspire(type,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "boss.inspire",
        ["p"] = {["type"] = type}
    })):send(function(response, request)
        qy.tank.model.WorldBossModel:update(response.data)
        callback()
    end)
end

function WorldBossService:reset(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "boss.reset",
    })):send(function(response, request)
        qy.tank.model.WorldBossModel:update(response.data)
        callback()
    end)
end

function WorldBossService:attack(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "boss.attack",
    })):send(function(response, request)
        qy.tank.model.WorldBossModel:init(response.data)
        qy.tank.model.BattleModel:init(response.data.fight_result)
        qy.tank.manager.ScenesManager:pushBattleScene()
        callback()
    end)
end

function WorldBossService:refresh(callback)
    local userInfoModel = qy.tank.model.UserInfoModel
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "boss.getTime",
    })):send(function(response, request)
        userInfoModel:updateServerTime(response.data.server_time)
        callback()
    end)
end

return WorldBossService