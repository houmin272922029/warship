local Model = class("Model", qy.tank.model.BaseModel)

local Service = require("gold_bunker.src.Service")

--[[
    定立规定：
        返回的数据以functionName_date的方法保存在self
]]

function Model:init(next)
    co(function()
        local response = yield(Service.getInfo) -- 预加载完成后才会执行下面的代码
        self.init_data = response.data.gold_bunker
        self.hard_data = response.data.gold_bunker_hard
        -- 关卡
        self.levels = yield(Model.initLevels)
        self.level_count = #self.levels

        self.hard_levels = yield(Model.initHardLevels)
        self.hard_level_count = #self.hard_levels
        -- 奖励
        self.rewards = yield(Model.initRewards)
        self.rewards_count = #self.rewards

        self.hard_rewards = yield(Model.initHardRewards)
        self.hard_rewards_count = #self.hard_rewards

        self.is_hard = cc.UserDefault:getInstance():getIntegerForKey(qy.tank.model.UserInfoModel.userInfoEntity.kid .."_gold_bunker_is_hard", 0)
    end, next)
end




function Model.initLevels(next)
    local levels = {}
    for _, v in pairs(require("data/gold_bunker_checkpoint")) do
        table.insert(levels, Model.M(v, {
            tank_icon = "gold_bunker/res/" .. v.icon .. ".png"
        }))
    end

    table.sort(levels, function(a, b)
        return tonumber(a.checkpoint_id) < tonumber(b.checkpoint_id)
    end)

    next(levels)
end


function Model.initHardLevels(next)
    local levels = {}
    for _, v in pairs(require("data/gold_bunker_hard_checkpoint")) do
        table.insert(levels, Model.M(v, {
            tank_icon = "gold_bunker/res/" .. v.icon .. ".png"
        }))
    end

    table.sort(levels, function(a, b)
        return tonumber(a.checkpoint_id) < tonumber(b.checkpoint_id)
    end)

    next(levels)
end

function Model.initRewards(next)
    local t = {}
    for k, v in pairs(require("data/gold_bunker_chest")) do
        table.insert(t, Model.M(v, {
            id = k
        }))
    end
    table.sort(t, function(a, b)
        return tonumber(a.id) < tonumber(b.id)
    end)

    next(t)
end

function Model.initHardRewards(next)
    local t = {}
    for k, v in pairs(require("data/gold_bunker_hard_chest")) do
        table.insert(t, Model.M(v, {
            id = k
        }))
    end
    table.sort(t, function(a, b)
        return tonumber(a.id) < tonumber(b.id)
    end)

    next(t)
end


function Model:getLeaderboardList(next)
    co(function()
        local response = yield(Service.getLeaderboardList)
        for k,v in pairs(response.data.gold_bunker) do
            self.init_data[k] = v
        end

        for k,v in pairs(response.data.gold_bunker_hard) do
            self.hard_data[k] = v
        end

        return response.data
    end, next)
end

function Model:getBunkerData(next)
    co(function()
        local response = yield(Service.getBunkerData)
        for k,v in pairs(response.data.gold_bunker) do
            self.init_data[k] = v
        end

        for k,v in pairs(response.data.gold_bunker_hard) do
            self.hard_data[k] = v
        end

        -- 自动完成奖励
        return response.data.award
    end, next)
end

function Model:getBattleData()
    co(function()
        local response = yield(Service.getBattleData)
        for k,v in pairs(response.data.gold_bunker) do
            self.init_data[k] = v
        end

        for k,v in pairs(response.data.gold_bunker_hard) do
            self.hard_data[k] = v
        end
        if response.data.award then
             qy.tank.command.AwardCommand:add(response.data.award)
        end
        qy.tank.model.BattleModel:init(response.data.fight_result)
    end, function()
        qy.tank.manager.ScenesManager:pushBattleScene()
    end)
end

function Model:receiveDailyRewards(type, next)
    co(function()
        local response = yield(Service.receiveDailyRewards(type))
        for k,v in pairs(response.data.gold_bunker) do
            self.init_data[k] = v
        end

        for k,v in pairs(response.data.gold_bunker_hard) do
            self.hard_data[k] = v
        end
        return response.data.award
    end, next)
end

function Model:reset(next)
    co(function()
        local response = yield(Service.reset)
        for k,v in pairs(response.data.gold_bunker) do
            self.init_data[k] = v
        end

        for k,v in pairs(response.data.gold_bunker_hard) do
            self.hard_data[k] = v
        end
    end, next)
end

function Model:getInitData()
    if self.is_hard == 1 then
        return self.hard_data
    end
    return self.init_data
end

function Model:getLevels()
    if self.is_hard == 1 then
        return self.hard_levels
    end
    return self.levels
end

function Model:getRewards()
    if self.is_hard == 1 then
        return self.hard_rewards
    end
    return self.rewards
end

function Model:getLevelCount()
    if self.is_hard == 1 then
        return self.hard_level_count
    end
    return self.level_count
end

function Model:getRewardCount()
    if self.is_hard == 1 then
        return self.hard_rewards_count
    end
    return self.rewards_count
end


return Model