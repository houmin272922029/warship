

local ServerExerciseService = qy.class("ServerExerciseService", qy.tank.service.BaseService)

local model = qy.tank.model.ServerExerciseModel

-- 入口
function ServerExerciseService:getMainList(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "exercise.index",
    })):send(function(response, request)
        if response.data.status == 200 then
            model:setstatus()
        else
            model:init(response.data)
        end
        callback()
    end)
end
--报名
function ServerExerciseService:GoInTo(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "exercise.enroll",
    })):send(function(response, request)
        model:update(response.data)
        callback()
    end)
end
--刷新对手
function ServerExerciseService:Changeopponent(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "exercise.changeopponent",
    })):send(function(response, request)
        model:update(response.data)
        callback()
    end)
end
--退赛
function ServerExerciseService:Finish(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "exercise.exit_exercise",
    })):send(function(response, request)
        model:update(response.data)
        qy.tank.command.AwardCommand:add(response.data.award)
        qy.tank.command.AwardCommand:show(response.data.award)
        callback(response.data)
    end)
end

-- 挑战
function ServerExerciseService:ToChallenge(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "exercise.battle",
    })):send(function(response, request)
        model:update(response.data)
        callback(response.data)
    end)
end
--排行榜
function ServerExerciseService:GetRanklist(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "exercise.getranklist",
    })):send(function(response, request)
        model:initranklist(response.data)
        callback()
    end)
end
--查看战况列表
function ServerExerciseService:WatchDetailList(type,page,pagesize, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "exercise.battlelist",
        ["p"] = {
        ["page"] = page,
        ["type"] = type,
        ["pagesize"] = pagesize
        }
        })):send(function (response, request)
            model:getMyWarDetail(response.data)
            callback()
    end)
end
 
--查看战况详情
function ServerExerciseService:WatchDetail(battleid, callback)
    print("ppppppppppppppp,",battleid)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "exercise.findbattle",
        ["p"] = {
                    ["battleid"] = battleid
                }
                })):send(function (response, request)
            print("++++++++++++++",json.encode(response.data))
            qy.tank.model.BattleModel:initserver(response.data,2)
            -- model:getWarDetail(response.data)
            callback(response.data)
    end)
 end
return ServerExerciseService