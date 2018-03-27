--[[
	军魂之路
	Author: mingming
	Date: 2015-06-13 15:49:49
]]

local SoulRoadService = qy.class("SoulRoadService", qy.tank.service.BaseService)

local model = qy.tank.model.SoulRoadModel
local soulModel = qy.tank.model.SoulModel
-- 获取
function SoulRoadService:get(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "soulroad.get",
    })):send(function(response, request)
        model:init(response.data)
        callback(response.data)
    end)
end

-- 攻击
function SoulRoadService:attack(checkpoint_id,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "soulroad.attack",
        ["p"] = {["checkpoint_id"]=checkpoint_id}
    })):send(function(response, request)
        qy.tank.model.BattleModel:init(response.data.fight_result)
        qy.tank.command.AwardCommand:add(response.data.award)
        model:update(response.data.soul_road)
        callback(response.data)
    end)
end

-- 扫荡
function SoulRoadService:raids(param,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "soulroad.raids",
        ["p"] = param,
    })):send(function(response, request)
        -- self.model:updateFormation(response.data)
        for i, v in pairs(response.data.list) do
            qy.tank.command.AwardCommand:add(v.award)
        end
        -- 
        model:update(response.data.soul_road)
        callback(response.data)
    end)
end

-- 购买次数
function SoulRoadService:buy(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "soulroad.buy",
    })):send(function(response, request)
        model:update(response.data.soul_road)
        callback(response.data)
    end)
end

-- 获取奖励
function SoulRoadService:drawAward(times,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "soulroad.drawAward",
        ["p"] = {["times"]=times}
    })):send(function(response, request)
        model:update(response.data.soul_road)
        -- self.model:updateFormation(response.data)
        callback(response.data.award)
    end)
end

return SoulRoadService



