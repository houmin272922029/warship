--[[
    最强之战
    Author: H.X.Sun
]]

local GreatestRaceService = qy.class("GreatestRaceService", qy.tank.service.BaseService)

local model = qy.tank.model.GreatestRaceModel
local BattleModel = qy.tank.model.BattleModel

function GreatestRaceService:get(flag,callback,onError)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "strongestbattle.get",
        ["p"] = {}
    }))
    :setShowLoading(flag)
    :send(function(response,request)
        model:init(response.data)
        callback(response.data)
    end,function()
        if onError then
            onError()
        end
    end,function()
        if onError then
            onError()
        end
    end)
end

-- 报名
function GreatestRaceService:sign(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "strongestbattle.enter",
        ["p"] = {}
    })):send(function(response,request)
        -- model:setSignUpStatus(response.data)
        model:update(response.data)
        callback(response.data)
    end)
end

-- 同步阵法
function GreatestRaceService:sync(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "strongestbattle.sync",
        ["p"] = {}
    })):send(function(response,request)
        model:update(response.data)
        callback(response.data)
    end)
end

-- 支持 0支持左边，1支持右边
function GreatestRaceService:support(index, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "strongestbattle.support",
        ["p"] = {["side"]=index}
    })):send(function(response,request)
        -- model:setSignUpStatus(response.data)
        callback(response.data)
    end)
end

-- 根据轮次获取战报信息的参数：
-- 阶段:stage:int:
-- 轮次:round:int:
-- 局数:game_num:int:
-- 要查看的用户ID:log_kid:int:
--
-- 根据日志ID获取战报信息的参数：
-- 日志ID:id:int:
function GreatestRaceService:getCombat(data, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "strongestbattle.getCombat",
        ["p"] = data,
    })):send(function(response,request)
        local showAward = true
        if data.id then
            -- 如果是有 ID 则是显示战报，忽略奖励
            showAward = false
        end
        model:initBattleData(response.data,showAward)
        BattleModel:init(response.data.log.fight_result)
        callback(response.data)
    end)
end

function GreatestRaceService:getLog(kid,mon,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "strongestbattle.getLog",
        ["p"] = {
            ["log_kid"]=kid,
            ["mon"] = mon,
        },
    })):send(function(response,request)
        model:initLog(response.data)
        callback(response.data)
    end)
end

function GreatestRaceService:getHistory(mon,next, callback)
    -- mon
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "StrongestBattle.getHistory",
        ["p"] = {
            ["mon"] = mon,
            ["next"] = next,
        },
    })):send(function(response,request)
        model:updateHistory(response.data.mon,response.data.history)
        callback(response.data)
    end)
end

function GreatestRaceService:buy(id, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "StrongestBattle.buy",
        ["p"] = {["id"]=id},
    })):send(function(response,request)
        -- model:setSignUpStatus(response.data)
        qy.tank.command.AwardCommand:add(response.data.award)
        qy.tank.command.AwardCommand:show(response.data.award)
        callback(response.data)
    end)
end

return GreatestRaceService
