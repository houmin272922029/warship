--[[
	围攻柏林
	Author:
	Date: 2016年07月13日15:08:24
]]

local AttackBerlinService = qy.class("AttackBerlinService", qy.tank.service.BaseService)

local model = qy.tank.model.AttackBerlinModel

-- 开启
function AttackBerlinService:open(difficuty,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "AttackBerlin.index",
        ["p"] = {["hard_type"] = difficuty,["func"]= "_actionOpenMap"}
    })):send(function(response, request)
        model:init1(response.data)
        callback(response.data)
    end)
end
-- 获取
function AttackBerlinService:get(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "AttackBerlin.index",
        ["p"] = {["func"]= "_actionIndex"}
    })):send(function(response, request)
        model:init2(response.data)
        callback(response.data)
    end)
end
function AttackBerlinService:get1(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "AttackBerlin.index",
        ["p"] = {["func"]= "_actionIndex"}
    }))
    :setShowLoading(false)
    :send(function(response, request)
        model:init2(response.data)
        callback(response.data)
    end)
end
-- 普通副本
function AttackBerlinService:inToGeneral(copy_id,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "AttackBerlin.index",
        ["p"] = {["func"]= "_actionGeneralCopyInfo",["copy_id"] = copy_id}
    })):send(function(response, request)
        model:uptateGeneraldata(response.data)
        callback(response.data)
    end)
end
-- 精英副本
function AttackBerlinService:inToElite(copy_id,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "AttackBerlin.index",
        ["p"] = {["func"]= "_actionEliteCopyInfo",["copy_id"] = copy_id}
    })):send(function(response, request)
        model:uptateElitedata(response.data)
        callback(response.data)
    end)
end
--BOSS副本
function AttackBerlinService:inToBOSS(copy_id,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "AttackBerlin.index",
        ["p"] = {["func"]= "_actionBossCopyInfo",["copy_id"] = copy_id}
    })):send(function(response, request)
        model:uptateBossdata(response.data)
        callback(response.data)
    end)
end
--购买普通次数
function AttackBerlinService:buy1( callback )
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "AttackBerlin.index",
        ["p"] = {["func"]= "_actionGeneralBuyTimes"}
    })):send(function(response, request)
        model:uptateGeneraltimes(response.data)
        callback(response.data)
    end)
end
--购买精英次数
function AttackBerlinService:buy2( callback )
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "AttackBerlin.index",
        ["p"] = {["func"]= "_actionEliteBuytimes"}
    })):send(function(response, request)
        model:uptateElitetimes(response.data)
        callback(response.data)
    end)
end
--攻打普通副本
function AttackBerlinService:GeneralFight(copy_id,checkpoint_id, callback )
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "AttackBerlin.index",
        ["p"] = {["func"]= "_actionGeneralFight",["copy_id"] = copy_id,["checkpoint_id"] = checkpoint_id}
    })):send(function(response, request)
        model:uptateGeneraldata1(copy_id,response.data)
        qy.tank.model.BattleModel:initAward(response.data.award)
        -- print("++++++++++pppppppppp",json.encode(response.data.award))
        qy.tank.command.AwardCommand:add(response.data.award)
        if response.data.fight_result then
            qy.tank.model.BattleModel:init(response.data.fight_result)
            qy.tank.manager.ScenesManager:pushBattleScene()
        end
        callback(response.data)
    end)
end
-- 加入队伍
function AttackBerlinService:joinTeam(callback, team_name)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "AttackBerlin.index",
        ["p"] = {["func"] = "_actionEliteJoinTeam",["team_id"] = team_name}
    })):send(function(response, request)
        model:uptate2(response.data)
        callback(response.data)
    end)
end


-- 加入队伍 从聊天中进入
function AttackBerlinService:joinTeam2(callback, team_id)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "AttackBerlin.index",
        ["p"] = {["team_id"] = team_id, ["func"] =  "_actionEliteJoinTeamByInvite"}
    })):send(function(response, request)
        callback(response.data)
        model:updateChatdate(response.data)
        qy.tank.command.LegionCommand:viewRedirectByModuleType("AttackBerlin1")    
    end)
end


-- 踢出队伍
function AttackBerlinService:removeTeam(callback, uid)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "AttackBerlin.index",
        ["p"] = {["func"] = "_actionEliteExpelTeam",["member_kid"] = uid}
    })):send(function(response, request)
        model:uptate2(response.data)
        callback(response.data)
    end)
end


-- 主动离开队伍
function AttackBerlinService:leaveTeam(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "AttackBerlin.index",
        ["p"] = {["func"] = "_actionEliteLeaveTeam"},
    })):send(function(response, request)
        model:uptate2(response.data)
        callback(response.data)
    end)
end



-- 购买次数
function AttackBerlinService:buy(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "groupbattles.pay_join_num",
    })):send(function(response, request)
        model:update(response.data)
        callback(response.data)
    end)
end

-- 查看奖励
function AttackBerlinService:checkAward(callback)
    qy.Http.new(qy.Http.Request.new({
             ["m"] = "AttackBerlin.index",
        ["p"] = {["func"] = "_actionTotalAward"},
    })):send(function(response, request)
        model:updateawardlist(response.data)
        callback(response.data)
    end)
end
-- 查看可分配列表
function AttackBerlinService:checkSendMember(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "AttackBerlin.index",
        ["p"] = {["func"] = "_actionGetSendMember"},
    })):send(function(response, request)
        model:updatemember(response.data)
        callback(response.data)
    end)
end
--分配奖励
function AttackBerlinService:SendAward(award_id,kid,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "AttackBerlin.index",
        ["p"] = {["func"] = "_actionSendAward",["award_id"] = award_id,["member_kid"] = kid},
    })):send(function(response, request)
        model:updateawardlist(response.data)
        callback(response.data)
    end)
end
-- 查看可分配列表
function AttackBerlinService:checklog(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "AttackBerlin.index",
        ["p"] = {["func"] = "_actionSendAwardLog"},
    })):send(function(response, request)
        model:updateloglist(response.data)
        callback(response.data)
    end)
end
--领取奖励
function AttackBerlinService:getAward(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "AttackBerlin.index",
        ["p"] = {["func"] = "_actionReceiveAward"},
    })):send(function(response, request)
        -- model:updateawardlist(response.data)
        qy.tank.command.AwardCommand:add(response.data.award)
        qy.tank.command.AwardCommand:show(response.data.award)
        callback(response.data)
    end)
end

-- 创建队伍
function AttackBerlinService:creatTeam(callback,copy_id,scene_id)--
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "AttackBerlin.index",
        ["p"] = {["func"]= "_actionEliteCreateTeam",["copy_id"] = copy_id,["scene_id"] = scene_id}
    })):send(function(response, request)
        model:uptate1(response.data,scene_id)
        callback(response.data)
    end)
end



-- 开始战斗
function AttackBerlinService:start(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "AttackBerlin.index",
         ["p"] = {["func"]= "_actionEliteFight"}
    })):send(function(response, request)
        -- model:update(response.data)
        -- qy.tank.model.WarGroupModel:setBattleAward(response.data.award)
        -- model:showBattle(response.data.battle)
    end)
end
-- 开始战斗boss
function AttackBerlinService:Bossstart(copy_id,scene_id,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "AttackBerlin.index",
         ["p"] = {["func"]= "_actionBossFight",["copy_id"] = copy_id,["scene_id"] = scene_id}
    })):send(function(response, request)
        model:uptateBossdata(response.data)
        -- qy.tank.service.GroupBattlesService:getUserResource()
        qy.tank.command.LegionCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.WAR_GROUP, response.data.fight_result)
        callback()
    end)
end


-- 军团/世界邀请
function AttackBerlinService:invite(callback, channel)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "AttackBerlin.index",
        ["p"] = {["func"] = "_actionInvite"}
    })):send(function(response, request)
        callback(response.data)
    end)
end

function AttackBerlinService:getUserResource(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "user.get_user_resource",
    })):send(function(response, request)

    end)
end


function AttackBerlinService:showCombat(combatId, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "user.show_combat",
        ["p"] = {["combat_id"] = combatId}
    })):send(function(response, request)
        qy.tank.command.LegionCommand:viewRedirectByModuleType("WAR_GROUP1", response.data.combat)
    end)
end

function AttackBerlinService:showCombat1(combatId, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "user.show_combat",
        ["p"] = {["combat_id"] = combatId}
    })):send(function(response, request)
        -- qy.tank.command.LegionCommand:viewRedirectByModuleType("WAR_GROUP1", response.data.combat)
        callback(response.data)
    end)
end


return AttackBerlinService
