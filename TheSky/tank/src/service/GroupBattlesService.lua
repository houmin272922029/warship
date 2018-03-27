--[[
	多人副本
	Author:
	Date: 2016年07月13日15:08:24
]]

local GroupBattlesService = qy.class("GroupBattlesService", qy.tank.service.BaseService)

local model = qy.tank.model.GroupBattlesModel
-- 获取
function GroupBattlesService:get(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "groupbattles.main",
    })):send(function(response, request)
        model:init(response.data)
        callback(response.data)
    end)
end

-- 加入队伍
function GroupBattlesService:joinTeam(callback, team_name, scene_id)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "groupbattles.join_team",
        ["p"] = {["team_id"] = team_name, ["scene_id"] = scene_id}
    })):send(function(response, request)
        model:update(response.data)
        callback(response.data)
    end)
end


-- 加入队伍 从聊天中进入
function GroupBattlesService:joinTeam2(callback, team_name, scene_id)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "groupbattles.join_team",
        ["p"] = {["team_id"] = team_name, ["scene_id"] = scene_id}
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
function GroupBattlesService:removeTeam(callback, uid)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "groupbattles.remove_team",
        ["p"] = {["uid"] = uid}
    })):send(function(response, request)
        model:update(response.data)
        callback(response.data)
    end)
end


-- 主动离开队伍
function GroupBattlesService:leaveTeam(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "groupbattles.leave_team",
    })):send(function(response, request)
        model:update(response.data)
        callback(response.data)
    end)
end



-- 购买次数
function GroupBattlesService:buy(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "groupbattles.pay_join_num",
    })):send(function(response, request)
        model:update(response.data)
        callback(response.data)
    end)
end


-- 创建队伍
function GroupBattlesService:creatTeam(callback, id)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "groupbattles.create_team",
        ["p"] = {["scene_id"] = id}
    })):send(function(response, request)
        model:update(response.data)
        callback(response.data)
    end)
end



-- 开始战斗
function GroupBattlesService:start(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "groupbattles.battles",
    })):send(function(response, request)
        model:update(response.data)
        qy.tank.model.WarGroupModel:setBattleAward(response.data.award)
        model:showBattle(response.data.battle)
    end)
end


-- 军团/世界邀请
function GroupBattlesService:invite(callback, channel)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "groupbattles.send_invite_msg",
        ["p"] = {["channel"] = channel}
    })):send(function(response, request)
        model:update(response.data)
        callback(response.data)
    end)
end

function GroupBattlesService:getUserResource(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "user.get_user_resource",
    })):send(function(response, request)

    end)
end


function GroupBattlesService:isTeam(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "groupbattles.is_team",
    })):send(function(response, request)
        model:update(response.data)
        callback(response.data)
    end)
end


return GroupBattlesService
