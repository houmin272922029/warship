--[[
	Author: 孤胆英雄
	Date: 2015-06-13 15:49:49
]]

local SingleHeroService = qy.class("SingleHeroService", qy.tank.service.BaseService)

local model = qy.tank.model.SingleHeroModel
-- 获取信息
function SingleHeroService:get(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "singlehero.get",
    })):send(function(response, request)
        model:init(response.data)
        callback(response.data)
    end)
end

-- 布阵
function SingleHeroService:lineup(uid,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "singlehero.lineup",
        ["p"] = {["unique_id"]=uid}
    })):send(function(response, request)
        model:update(response.data.single_hero)
        callback(response.data)
    end)
end

-- 攻打
function SingleHeroService:attack(checkpoint_id, multiple, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "singlehero.attack",
        ["p"] = {
            ["checkpoint_id"] = checkpoint_id,
            ["multiple"] = multiple,
        }
    })):send(function(response, request)
        qy.tank.command.AwardCommand:add(response.data.award)
        qy.tank.model.BattleModel:init(response.data.fight_result)
        model:update(response.data.single_hero)
        callback(response.data)
    end)
end



-- 扫荡
function SingleHeroService:sweep(checkpoint_id, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "singlehero.sweep",
        ["p"] = {
            ["checkpoint_id"] = checkpoint_id,
        }
    })):send(function(response, request)
        model:update(response.data.single_hero)
        callback(response.data)
    end)
end


-- 购买次数
function SingleHeroService:buy(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "singlehero.buy",
    })):send(function(response, request)
        model:update(response.data.single_hero)
        callback(response.data)
    end)
end

-- 攻略
function SingleHeroService:getList(checkpoint_id,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "singlehero.getList",
        ["p"] = {["checkpoint_id"] = checkpoint_id}
    })):send(function(response, request)
        -- self.model:updateFormation(response.data)
        model:setPlayList(response.data)
        print("++++"..qy.json.encode(response.data))
        callback(response.data)
    end)
end

-- 排行榜
function SingleHeroService:getRankList(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "singlehero.getRankList",
    })):send(function(response, request)
        model:setRank(response.data)
        callback(response.data)
    end)
end

--攻略战报
function SingleHeroService:video(checkpoint_id, att_kid, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "SingleHero.video",
        ["p"] = {
            ["checkpoint_id"] = checkpoint_id,
            ["att_kid"] = att_kid,
        }
    })):send(function(response, request)
    qy.tank.model.BattleModel:init(response.data.fight_result)
        model:setPlayList(response.data)
        callback(response.data)
    end)
end

return SingleHeroService



