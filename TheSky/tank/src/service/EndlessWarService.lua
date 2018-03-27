--[[
	
	Author: 
	Date: 2016年07月13日15:08:24
]]

local EndlessWarService = qy.class("EndlessWarService", qy.tank.service.BaseService)

local model = qy.tank.model.EndlessWarModel
-- 获取
function EndlessWarService:get(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "endlessWar.battleField",
        ["p"] = {}
    })):send(function(response, request)
        model:init(response.data)
        callback(response.data)
    end)
end


function EndlessWarService:getAward(callback)
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "endlessWar.openSpoils",
       ["p"] = {["times"] = -1}
    })):send(function(response, request)
        model:update(response.data)
        qy.tank.command.AwardCommand:add(response.data.award)
        qy.tank.command.AwardCommand:show(response.data.award)
        callback(response.data)
    end)
end



function EndlessWarService:getRankList(callback)
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "endlessWar.endlessWarRank",
       ["p"] = {}
    })):send(function(response, request)
       model:initRankList(response.data)
       callback(response.data)
    end)
end
function EndlessWarService:BuyBattleNum( callback )
   qy.Http.new(qy.Http.Request.new({
       ["m"] = "endlessWar.speed",
       ["p"] = {["times"] = 1}
    })):send(function(response, request)
       model:update(response.data)
       callback(response.data)
    end)
end
function EndlessWarService:Tobattle( callback )
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "endlessWar.attack",
       ["p"] = {}
    })):send(function(response, request)
        if response.data.fight_result then
            qy.tank.model.BattleModel:init(response.data.fight_result)
            qy.tank.manager.ScenesManager:pushBattleScene()
        else
            qy.hint:show("您当前有战利品未领取，请领取后再来挑战")
        end
        model:update(response.data)
        callback()
    end)
end




return EndlessWarService



