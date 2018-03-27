--[[
    军团BOSS
    Author: Aaron Wei
	Date: 2016-02-18 18:27:28
]]

local LegionBossService = qy.class("LegionBossService", qy.tank.service.BaseService)

function LegionBossService:get(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "legionboss.get",
    })):send(function(response, request)
        qy.tank.model.LegionBossModel:init(response.data)
        callback()
    end)
end

function LegionBossService:selectboss(id,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "legionboss.selectboss",
        ["p"] = {["boss_id"] = id}
    })):send(function(response, request)
        qy.tank.model.LegionBossModel.boss_id = response.data.boss_id
        callback()
    end)
end

function LegionBossService:inspire(type,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "legionboss.inspire",
        ["p"] = {["type"] = type}
    })):send(function(response, request)
        qy.tank.model.LegionBossModel:update(response.data)
        callback()
    end)
end

function LegionBossService:reset(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "legionboss.reset",
    })):send(function(response, request)
        qy.tank.model.LegionBossModel:update(response.data)
        callback()
    end)
end

function LegionBossService:attack(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "legionboss.attack",
    })):send(function(response, request)
        qy.tank.model.LegionBossModel:init(response.data)
        qy.tank.model.BattleModel:init(response.data.fight_result)
        qy.tank.manager.ScenesManager:pushBattleScene()
        callback()
    end)
end

return LegionBossService