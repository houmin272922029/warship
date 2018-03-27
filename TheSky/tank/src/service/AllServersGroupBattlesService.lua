--[[
	跨服多人副本
]]

local AllServersGroupBattlesService = qy.class("AllServersGroupBattlesService", qy.tank.service.BaseService)

local model = qy.tank.model.AllServersGroupBattlesModel
-- 获取
function AllServersGroupBattlesService:get(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "AllServersGroupBattles.main",
    })):send(function(response, request)
        model:init(response.data)
        callback(response.data)
    end)
end

-- 加入队伍
function AllServersGroupBattlesService:joinTeam(callback, team_id)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "AllServersGroupBattles.join_team",
        ["p"] = {["team_id"] = team_id}
    })):send(function(response, request)
        model:update(response.data)
        callback(response.data)
    end)
end


-- 加入队伍 从聊天中进入
function AllServersGroupBattlesService:joinTeam2(callback, team_id, scene_id)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "AllServersGroupBattles.join_team",
        ["p"] = {["team_id"] = team_id, ["scene_id"] = scene_id}
    })):send(function(response, request)
        if response.data.team_info then
            callback(response.data)

            local extendData = {}
            extendData.callBack1 = function(data)
                model:update(response.data)
                qy.Event.dispatch(qy.Event.GROUP_BATTLES)
            end
            qy.tank.command.ActivitiesCommand:showActivity("group_battles", extendData)
        end
    end)
end


-- 踢出队伍
function AllServersGroupBattlesService:expelMember(callback, uid)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "AllServersGroupBattles.expel_member",
        ["p"] = {["member_kid"] = uid}
    })):send(function(response, request)
        model:update(response.data)
        callback(response.data)
    end)
end


-- 查看队伍信息
function AllServersGroupBattlesService:getTeamInfo(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "AllServersGroupBattles.team_info",
    })):send(function(response, request)
        model:update(response.data)
        callback(response.data)
    end)
end


-- 查看队伍列表
function AllServersGroupBattlesService:getTeamList(callback, scene_id, current_page, one_page_rows)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "AllServersGroupBattles.team_list",
        ["p"] = {["scene_id"] = scene_id, ["current_page"] = current_page, ["one_page_rows"] = one_page_rows}
    })):send(function(response, request)
        model:update(response.data)
        callback(response.data)
    end)
end


-- 主动离开队伍
function AllServersGroupBattlesService:leaveTeam(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "AllServersGroupBattles.exit_team",
    })):send(function(response, request)
        model:update(response.data)
        callback(response.data)
    end)
end

--准备、取消准备
function AllServersGroupBattlesService:ready(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "AllServersGroupBattles.ready",
    })):send(function(response, request)
        model:update(response.data)
        callback(response.data)
    end)
end



-- 购买次数
function AllServersGroupBattlesService:buy(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "AllServersGroupBattles.pay_join_num",
    })):send(function(response, request)
        model:update(response.data)
        callback(response.data)
    end)
end


-- 创建队伍
function AllServersGroupBattlesService:creatTeam(callback, id)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "AllServersGroupBattles.create_team",
        ["p"] = {["scene_id"] = id}
    })):send(function(response, request)
        model:update(response.data)
        callback(response.data)
    end)
end



-- 开始战斗
function AllServersGroupBattlesService:start(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "AllServersGroupBattles.fight",
    })):send(function(response, request)
        model:update(response.data)
        qy.Event.dispatch(qy.Event.ALL_SERVERS_GROUP_BATTLES)

        if response.data.result then
            qy.tank.service.AllServersGroupBattlesService:showCombat(response.data.result.combat_id,function(data)
                qy.tank.model.WarGroupModel:setBattleAward(response.data.result.award)
                model:showBattle(data.combat)
            end)
        end
    end)
end


-- 军团/世界邀请
function AllServersGroupBattlesService:invite(callback, channel)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "AllServersGroupBattles.send_invite_msg",
        ["p"] = {["channel"] = channel}
    })):send(function(response, request)
        model:update(response.data)
        callback(response.data)
    end)
end

function AllServersGroupBattlesService:getUserResource(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "user.get_user_resource",
    })):send(function(response, request)

    end)
end


function AllServersGroupBattlesService:isTeam(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "AllServersGroupBattles.is_team",
    })):send(function(response, request)
        model:update(response.data)
        callback(response.data)
    end)
end
function AllServersGroupBattlesService:showCombat(combatId, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "user.show_combat",
        ["p"] = {["combat_id"] = combatId}
    })):send(function(response, request)
        callback(response.data)
    end)
end


return AllServersGroupBattlesService
