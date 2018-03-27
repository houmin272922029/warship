local Game = class("Game", qy.tank.model.BaseModel)

local TaskModel         = qy.tank.model.TaskModel
local BattleModel       = qy.tank.model.BattleModel
local UserInfoModel     = qy.tank.model.UserInfoModel
local RoleUpgradeModel  = qy.tank.model.RoleUpgradeModel

function Game:setdata(jdata, request)
     -- 更新服务器时间
    if jdata.server_time then
        UserInfoModel:updateServerTime(jdata.server_time)
    end

    if jdata.user_exp then
        -- 捕获主角升级数据
        if jdata.user_exp.upgrade_level and jdata.user_exp.upgrade_level > 0 then
            RoleUpgradeModel:setRoleUpgradeData(jdata)
            if jdata.user_exp.activity_list then
                qy.tank.command.ActivitiesCommand:refresh(3, jdata.user_exp)
            end
        end
    end

    if jdata.fight_result or jdata.combat then
        -- 捕获战斗主角经验升级数据
        if jdata.user_exp then
            BattleModel:initUserExp(jdata.user_exp)
        end

        -- 捕获战斗奖励
        if jdata.award then
            BattleModel:initAward(jdata.award,jdata.fight_result.fight_type)
        else
            BattleModel:clearAward()
        end
    end

    --更新用户数据
    UserInfoModel:updateUserInfo(jdata)

    -- 更新任务
    if jdata.task then
         TaskModel:updateTask(jdata.task)
    end

    -- 图鉴达成列表
    if jdata.handbook then
        local notAddPic = request == "System.login" or request ==  "User.handbook" or request ==  "User.achieve_up" 
        qy.tank.model.AchievementModel:update(jdata, notAddPic)
    end

    -- 乘员图鉴
    -- if jdata.passenger then
    --     local addPic = request == "passenger.extract"
    --     qy.tank.model.PassengerModel:updateData(jdata, addPic)
    -- end

    -- 红点 (主要是消息  贺电等)
    if jdata.redpoint then
        qy.tank.model.RedDotModel:checkMessage(jdata.redpoint)
    end

    if jdata.soul then
        qy.tank.model.SoulModel:update(jdata.soul)
    end
end

return Game
