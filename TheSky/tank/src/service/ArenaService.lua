--[[
    竞技场服务
    Author: Your Name
    Date: 2015-05-26 16:12:18
]]

local ArenaService = qy.class("ArenaService", qy.tank.service.BaseService)

function ArenaService:getList(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "arena.getList",
        -- ["p"] = {["pid"] = pid}
    })):send(function(response, request)
        qy.tank.model.ArenaModel:init(response.data)
        callback()
    end)
end

function ArenaService:attack(rank,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "arena.attack",
        ["p"] = {["rank"] = rank}
    }))
    -- :setShowLoading(false)
    :send(function(response, request)
        qy.tank.model.BattleModel:init(response.data.fight_result)
        qy.tank.model.ArenaModel:init(response.data.list)
        callback()
        -- qy.tank.manager.ScenesManager:pushScene(qy.tank.view.scene.BattleScene.new())
        qy.tank.manager.ScenesManager:pushBattleScene()
    end)
end

function ArenaService:buy(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "arena.buy",
        ["p"] = {}
    })):send(function(response, request)
        qy.tank.model.ArenaModel.buy_times = response.data.buy_times
        callback()
    end)
end

function ArenaService:drawAward(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "arena.drawAward",
        ["p"] = {}
    })):send(function(response, request)
        qy.tank.model.ArenaModel.win_times = response.data.win_times
        qy.tank.model.ArenaModel.is_draw_award = response.data.is_draw_award
        callback(response.data)
    end)
end

-- 军神商店数据
function ArenaService:getExchage(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "arena.shop",
        ["p"] = {}
    })):send(function(response, request)
        qy.tank.model.ArenaModel:updateGoodsList(response.data)
        callback(response.data)
    end)
end

--远征商店兑换
function ArenaService:exchageItem(param, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "arena.exchange",
        ["p"] = param
    })):send(function(response, request)
        qy.tank.model.ArenaModel:updateGoodsList(response.data)
        callback(response.data)
    end)
end

return ArenaService