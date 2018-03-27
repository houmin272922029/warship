
 --[[
	暴打敌营
	Author: fq
	Date: 2016年08月05日15:02:10
]]

local BeatEnemyService = qy.class("BeatEnemyService", qy.tank.service.BaseService)

local model = qy.tank.model.BeatEnemyModel
-- 获取
function BeatEnemyService:get(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Activity.getInfo",
        ["p"] = {["activity_name"] = "beat_enemy"}
    })):send(function(response, request)
       model:init(response.data)
       callback(response.data)
    end)
end


-- activity.getAward 参数
-- type=1打击，id打击类型：1机枪打击 2炮火打击 3饱和打击
-- type=2领取宝箱奖励，id领取宝箱的id
-- type=3领取排行奖励
function BeatEnemyService:getAward(callback, _type, _id)
    local param = {}

    param = _id == nil and   {["activity_name"] = "beat_enemy", ["type"] = _type} or {["activity_name"] = "beat_enemy", ["type"] = _type, ["id"] = _id}

    qy.Http.new(qy.Http.Request.new({
       ["m"] = "Activity.getaward",
       ["p"] = param
    })):send(function(response, request)
       model:update(response.data)
       callback(response.data)
    end)
end





return BeatEnemyService



