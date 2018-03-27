--[[
静态配置类
Author: Aaron Wei
Date: 2015-02-02 20:11:30
]]

local Config = {
    -- monster = require("data/monster"),
    -- classicbattle_monster = require("data/classicbattle_monster"),
    -- arena_monster = require("data/arena_monster"),
    -- mining_monster = require("data/mining_monster"),
    -- expedition_monster = require("data/expedition_monster"),
    -- invade_monster = require("data/invade_monster"),
    guide_monster = require("data/new_user_guide_monster"),

    -- skill = require("data/skill"),
    -- tank = require("data/tank"),
    -- tank_res = require("data/tank_res"),
    -- talent = require("data/talent"),
    -- chapter = require("data/chapter"),
    -- scene = require("data/scene"),
    -- checkpoint = require("data/checkpoint"),
    -- equip = require("data/equip"),
    -- equip_suit = require("data/equip_suit"),
    -- equip_upgrade = require("data/equip_upgrade"),
    -- props = require("data/props"),
    -- supply = require("data/supply"),
    -- classicbattle = require("data/classicbattle"),
    -- daily_task = require("data/daily_task"),
    -- one_times_task = require("data/one_times_task"),
    -- random_task = require("data/random_task"),
    -- shop_tank = require("data/shop_tank"),
    -- shop_props = require("data/shop_props"),
    -- one_times_task_group = require("data/one_times_task_group"),
    -- technology_type = require("data/technology_type"),
    -- technology_value = require("data/technology_value"),
    -- expedition_shop = require("data/expedition_shop"),
    -- expedition_chest = require("data/expedition_chest"),
    function_open = require("data/gongneng_open"),
    -- invade_checkpoint = require("data/invade_checkpoint"),
    -- VIP
    -- vip_award = require("data/vip_award"),
    -- vip_price = require("data/vip_price"),
    -- vip_privilege = require("data/vip_privilege"),

    --新手引导
    step_guide = require("data/new_user_guide"),--步数引导
    payment_dev = require("data/payment/payment_dev"),--充值-开发服
    payment_prod = require("data/payment/payment_prod"),--充值-正式服-混服
    -- payment_sina = require("data/payment/payment_sina"),--充值-正式服-新浪
    -- novice_guide = require("data/novice_guide"),--新手引导
    -- rand_name = require("data/rand_name"),--随机名字

    -- level = require("data/level"),--升级经验表
    -- raremining_event = require("data/raremining_event"),
    -- battle_room_announcement = require("data/battle_room_announcement"),
    -- achievement = require("data/achievement"), -- 成就
    -- achievement_plus = require("data/achievement_plus"), -- 成就属性
}

if qy.product == "sina" then
    Config.payment_sina = require("data/payment/payment_sina")
elseif qy.product == "oversea" or qy.product == "oversea-test" or qy.language == "en" then
    Config.payment_xiaoao = require("data/payment/payment_xiaoao")
end

-- 懒加载
setmetatable(Config, {
    __index = function(t, k)
        local ok, ret = pcall(function()
            return require("data/" .. k)
        end)

        if ok then
            rawset(t, k, ret)
        end

        return ret
    end
})


return Config
