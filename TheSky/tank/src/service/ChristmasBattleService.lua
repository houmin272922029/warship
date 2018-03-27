

local ChristmasBattleService = qy.class("ChristmasBattleService", qy.tank.service.BaseService)

local model = qy.tank.model.ChristmasBattleModel



-- -- 获取
function ChristmasBattleService:getInfo(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Activity.getInfo",
        ["p"] = {["activity_name"] = "christmas_war"}
    })):send(function(response, request)
       model:init(response.data.activity_info)
       callback(response.data.activity_info)
    end)
end

function ChristmasBattleService:attack(callback)
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "activity.christmas_war_attack",
    })):send(function(response, request)
        qy.tank.model.BattleModel:init(response.data.fight_result)
        qy.tank.manager.ScenesManager:pushBattleScene()
        model:update(response.data)
        callback(response.data)
    end)
end

function ChristmasBattleService:getRankList(type_id,page_num,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "activity.christmas_war_list",
        ["p"] = {
                ["type"] = type_id,
                ["page"] = page_num
    }
    })):send(function(response, request)
      callback(response.data)
    end)
end

return ChristmasBattleService
