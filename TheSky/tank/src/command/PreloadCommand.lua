--[[
    说明: 预加载资源命令
    Author: Aaron Wei
	Date: 2015-10-15 19:02:42
]]

local PreloadCommand = qy.class("PreloadCommand", qy.tank.command.BaseCommand)

function PreloadCommand:start(callback)
    -- 配置表
    require("data/new_user_guide_monster")
    require("data/new_user_guide")
    require("data/payment/payment_dev")
    require("data/chapter")

    
    -- 公共模块
    qy.tank.utils.cache.CachePoolUtil.addPlistAsync("Resources/common/frame/common_frame",1,callback) 
    qy.tank.utils.cache.CachePoolUtil.addPlistAsync("Resources/common/icon/common_icon",1,callback) 
    qy.tank.utils.cache.CachePoolUtil.addPlistAsync("Resources/common/button/common_button",1,callback) 
    qy.tank.utils.cache.CachePoolUtil.addPlistAsync("Resources/common/img/common_img",1,callback) 
    qy.tank.utils.cache.CachePoolUtil.addPlistAsync("Resources/common/item/common_item",1,callback) 
    qy.tank.utils.cache.CachePoolUtil.addPlistAsync("Resources/common/title/common_title",1,callback) 
    qy.tank.utils.cache.CachePoolUtil.addPlistAsync("Resources/common/txt/common_txt",1,callback) 
    

    -- 装备&车库&布阵
    qy.tank.utils.cache.CachePoolUtil.addJPGAsync("Resources/garage/BG_garage.jpg",callback)
    qy.tank.utils.cache.CachePoolUtil.addPlistAsync("Resources/garage/garage",1,callback) 

    -- 仓库
    qy.tank.utils.cache.CachePoolUtil.addPlistAsync("Resources/storage/storage",1,callback) 

    -- 关卡
    qy.tank.utils.cache.CachePoolUtil.addPlistAsync("Resources/campaign/campaign",1,callback)
    qy.tank.utils.cache.CachePoolUtil.addJPGAsync("Resources/campaign/GK_6.jpg",callback)
    qy.tank.utils.cache.CachePoolUtil.addJPGAsync("Resources/campaign/GK_38.jpg",callback)
    qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsync("fx/".. qy.language .."/ui/campaign/ui_fx_bihua",callback)
    qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsync("fx/".. qy.language .."/ui/campaign/ui_fx_kuangzi",callback)
    qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsync("fx/".. qy.language .."/ui/campaign/ui_fx_saodang",callback)
    qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsync("fx/".. qy.language .."/ui/campaign/ui_fx_tubiaojiang",callback)
    qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsync("fx/".. qy.language .."/ui/campaign/ui_fx_xiangziguang",callback)
    qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsync("fx/".. qy.language .."/ui/campaign/ui_fx_cqyan",callback)
    qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsync("fx/".. qy.language .."/ui/campaign/UI_fx_guankajiesuo",callback)

    -- 抽卡
    qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsync("fx/".. qy.language .."/ui/ui_fx_chouka",callback)

    -- 作战室
    qy.tank.utils.cache.CachePoolUtil.addPlistAsync("Resources/activity/activity",1,callback) 
    qy.tank.utils.cache.CachePoolUtil.addJPGAsync("Resources/activity/bg.jpg",callback)

    -- 特效
    qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsync(qy.ResConfig.EQUIP_SUIT_EFFECTS,callback)

    -- 注册&登陆&绑定
    qy.tank.utils.cache.CachePoolUtil.addPlistAsync("Resources/login/bind",1,callback)
    qy.tank.utils.cache.CachePoolUtil.addPlistAsync("Resources/login/login",1,callback)

    -- 主城
    qy.tank.utils.cache.CachePoolUtil.addJPGAsync("Resources/main_city/building/main_bg.jpg",callback)
    qy.tank.utils.cache.CachePoolUtil.addPlistAsync("Resources/main_city/building/maincity_building",1,callback)
    qy.tank.utils.cache.CachePoolUtil.addPlistAsync("Resources/main_city/main_city",1,callback) 
end

return PreloadCommand
