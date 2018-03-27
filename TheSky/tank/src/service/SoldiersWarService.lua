--[[
	将士之战
	Author:
	Date: 2016年07月13日15:08:24
]]

local SoldiersWarService = qy.class("SoldiersWarService", qy.tank.service.BaseService)

local model = qy.tank.model.SoldiersWarModel
-- 获取
function SoldiersWarService:get(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "soldierbattle.get",
    })):send(function(response, request)
        model:init(response.data)
        callback(response.data)
    end)
end

-- 进入战斗
function SoldiersWarService:chanllenge(checkpoint_id,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "soldierbattle.challenge",
    })):send(function(response, request)

        qy.tank.model.BattleModel:init(response.data.fight_result,{
            ["checkpoint_id"] = checkpoint_id,
        })
        qy.tank.command.AwardCommand:add(response.data.award)
        response.data.award = nil
        model:update(response.data)
        callback(response.data)
    end)
end


-- 开始挑战
function SoldiersWarService:start(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "soldierbattle.start",
    })):send(function(response, request)
        model:update(response.data)
        callback(response.data)
    end)
end

-- 结束挑战
function SoldiersWarService:reset(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "soldierbattle.reset",
    })):send(function(response, request)
        model:update(response.data)
        callback(response.data)
    end)
end


-- 购买次数
function SoldiersWarService:buy(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "soldierbattle.buy",
    })):send(function(response, request)
        model:update(response.data)
        callback(response.data)
    end)
end


-- 推荐战力
function SoldiersWarService:getFightPower(callback, id)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "soldierbattle.getFightPower",
        ["p"] = {["checkpoint_id"] = id}
    })):send(function(response, request)
        callback(response.data)
    end)
end


return SoldiersWarService
