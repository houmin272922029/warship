local Service = qy.class("Service", qy.tank.service.BaseService)

function Service.action(name, next, params)
    local is_hard = cc.UserDefault:getInstance():getIntegerForKey(qy.tank.model.UserInfoModel.userInfoEntity.kid .."_gold_bunker_is_hard", 0)
    if params == nil then
        params = {}
    end
    params.is_hard = is_hard
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "goldbunker." .. name,
        ["p"] = params
    })):send(function(response, request)
        next(response)
    end)
end

function Service.getInfo(next)
    Service.action("get", next)
end

function Service.getLeaderboardList(next)
    Service.action("rank", next)
end

function Service.getBattleData(next)
    Service.action("chanllenge", next)
end

function Service.getBunkerData(next)
    Service.action("start", next)
end

function Service.reset(next)
    Service.action("reset", next)
end

function Service.receiveDailyRewards(type)
    return function(next)
        Service.action("getDailyAward", next, {type = type})
    end
end

return Service
