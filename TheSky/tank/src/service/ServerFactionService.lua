--[[
    阵营战
    Author: Your Name
    Date: 2015-05-26 16:12:18
]]

local ServerFactionService = qy.class("ServerFactionService", qy.tank.service.BaseService)

local model = qy.tank.model.ServerFactionModel
--或许推荐阵容
function ServerFactionService:getInto(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "CampWar.getProposalCamp"
    })):send(function(response, request)
        model:initProposalCamp(response.data)
        callback()
    end)
end
--选择阵营
function ServerFactionService:chooseCamp(camp,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "CampWar.changeCamp",
        ["p"] = {["camp"] = camp}
    })):send(function(response, request)
        model:initMainCamp(response.data)
        callback()
    end)
end
--入口
function ServerFactionService:mainCamp(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "CampWar.main",
        ["p"] = {["camp"] = camp}
    })):send(function(response, request)
        model:initMainCamp(response.data)
        callback()
    end)
end
function ServerFactionService:mainCamp1(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "CampWar.main",
        ["p"] = {["camp"] = camp}
    })):setShowLoading(false)
    :send(function(response, request)
        model:initMainCamp(response.data,1)
        callback()
    end)
end

--某个据点入口
function ServerFactionService:IntoCamp(city_id,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "CampWar.city",
        ["p"] = {["city_id"] = city_id}
    })):send(function(response, request)
        model:initOneCamp(response.data)
        callback()
    end)
end
--占领某个据点
function ServerFactionService:getCamp(city_id,p,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "CampWar.seize",
        ["p"] = {["city_id"] = city_id,["p"] = p}
    })):send(function(response, request)
        if response.data.add_credit then
            model:addFeatsTwo(response.data.add_credit)
        end
        if response.data.fight_result then
            model:changeRedPointStatus2()
            qy.tank.model.BattleModel:init(response.data.fight_result)
            qy.tank.manager.ScenesManager:pushBattleScene()
        end
        callback()
    end)
end
--排行
function ServerFactionService:getrank(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "CampWar.rank",
        ["p"] = {}
    })):send(function(response, request)
        model:initRanklist(response.data)
        callback()
    end)
end
--退出某个城
function ServerFactionService:exitCity( city_id,callback )
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "CampWar.exit_city",
        ["p"] = {["city_id"] = city_id}
    })):setShowLoading(false)
    :send(function(response, request)
        model:initMainCamp(response.data)
        -- model:initSlectcity()
        callback()
    end)
end
--攻打
function ServerFactionService:fightCity(city_id, callback )
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "CampWar.fightCity",
        ["p"] = {["city_id"] = city_id}
    })):send(function(response, request)
        callback()
    end)
end
--修理
function ServerFactionService:repairCity( city_id,callback )
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "CampWar.repairCity",
        ["p"] = {["city_id"] = city_id}
    })):send(function(response, request)
        callback()
    end)
end
function ServerFactionService:BackCity(callback )
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "CampWar.back",
        ["p"] = {}
    })):send(function(response, request)
        if response.data.add_credit then
            model:addFeats(response.data.add_credit)
        end
        callback(response.data)
    end)
end
--战报
function ServerFactionService:getCombat( callback )
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "CampWar.myCombat",
        ["p"] = {}
    })):send(function(response, request)
        model:initCombatlist(response.data)
        callback()
    end)
end
function ServerFactionService:showCombat(combatId, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "user.show_combat",
        ["p"] = {["combat_id"] = combatId}
    })):send(function(response, request)
        qy.tank.model.BattleModel:init(response.data.combat)
        qy.tank.manager.ScenesManager:pushBattleScene() 
    end)
end
--技能
function ServerFactionService:useSkill(skill_id, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "CampWar.useSkill ",
        ["p"] = {["skill_id"] = skill_id}
    })):send(function(response, request)
    end)
end

--点击防守点返回展示数据
function ServerFactionService:getPointInfo(city_id,p,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "CampWar.pointInfo",
        ["p"] = {["city_id"] = city_id,["p"] = p}
    })):send(function(response, request)
        callback(response.data)
    end)
end

--商店兑换
function ServerFactionService:getShopAward(_award,_id,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "CampWar.shop",
        ["p"] = {["id"] = _id}
    })):send(function(response, request)
        model:changeLevel(response.data.rank_level)
        callback(response.data)
        qy.tank.command.AwardCommand:add(response.data.award)
        qy.tank.command.AwardCommand:show(response.data.award)
    end)
end



return ServerFactionService