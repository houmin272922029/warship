--[[
    战斗数据服务
    Author: Aaron Wei
    Date: 2015-02-03 16:33:24
]]

local BattleService = qy.class("BattleService", qy.tank.service.BaseService)

BattleService.model = qy.tank.model.BattleModel

function BattleService:getBattleData(param, callback)
    if qy.BattleConfig.SERVER == "local" then
        local testData = [[{"start":{"left":{"tank":{"1":{"unique_id":1,"kid":10020,"tank_id":1,"name":"\u864e\u738bII","type":3,"level":1,"exp":0,"star":5,"quality":4,"attack":1000,"defense":500,"blood":8000,"wear":95,"anti_wear":80,"crit_hurt":0,"talent_id":1,"common_skill_id":1,"compat_skill_id":2,"morale":0,"talent":{"attak_plus":2,"blood_plus":2,"crit_rate":0,"defense_plus":1.5,"desc":"\u653b\u51fbS\u7ea7\uff0c\u9632\u5fa1\u3001\u8840\u91cfA\u7ea7\uff0c\u95ea\u907fA\u7ea7","disarm_anti":0,"dodge_rate":250,"hit_plus":0,"name":"\u864e\u738bII","talent_id":1},"skill":{"common_skill":{"defense_effect_id":1,"desc":"\u5bf9\u654c\u65b9\u5355\u4f53\u9020\u62101.2\u500d\u4f24\u5bb3\uff0c\u5e76\u670940%\u6982\u7387\u8fde\u51fb","enemy_effect_value":400,"enemy_target":1,"enemy_type":4,"hurt_multiples":1.2,"name":"\u864e\u738bII","own_effect_value":0,"own_target":0,"own_type":0,"skill_id":1,"type":3},"compat_skill":{"defense_effect_id":1,"desc":"\u5bf9\u76ee\u6807\u5355\u4f53\u9020\u62103\u500d\u4f24\u5bb3\u5e7670%\u6982\u7387\u7f34\u68b0\u4e00\u56de\u5408","enemy_effect_value":700,"enemy_target":4,"enemy_type":2,"hurt_multiples":1,"name":"\u864e\u738bII\u5927\u62db","own_effect_value":0,"own_target":0,"own_type":0,"skill_id":2,"type":3}}},"2":{"unique_id":2,"kid":10020,"tank_id":2,"name":"\u864e\u738bII","type":3,"level":1,"exp":0,"star":5,"quality":4,"attack":1000,"defense":500,"blood":8000,"wear":95,"anti_wear":80,"crit_hurt":0,"talent_id":1,"common_skill_id":1,"compat_skill_id":2,"morale":0,"talent":{"attak_plus":2,"blood_plus":2,"crit_rate":0,"defense_plus":1.5,"desc":"\u653b\u51fbS\u7ea7\uff0c\u9632\u5fa1\u3001\u8840\u91cfA\u7ea7\uff0c\u95ea\u907fA\u7ea7","disarm_anti":0,"dodge_rate":250,"hit_plus":0,"name":"\u864e\u738bII","talent_id":1},"skill":{"common_skill":{"defense_effect_id":1,"desc":"\u5bf9\u654c\u65b9\u5355\u4f53\u9020\u62101.2\u500d\u4f24\u5bb3\uff0c\u5e76\u670940%\u6982\u7387\u8fde\u51fb","enemy_effect_value":400,"enemy_target":1,"enemy_type":4,"hurt_multiples":1.2,"name":"\u864e\u738bII","own_effect_value":0,"own_target":0,"own_type":0,"skill_id":1,"type":3},"compat_skill":{"defense_effect_id":1,"desc":"\u5bf9\u76ee\u6807\u5355\u4f53\u9020\u62103\u500d\u4f24\u5bb3\u5e7670%\u6982\u7387\u7f34\u68b0\u4e00\u56de\u5408","enemy_effect_value":700,"enemy_target":4,"enemy_type":2,"hurt_multiples":1,"name":"\u864e\u738bII\u5927\u62db","own_effect_value":0,"own_target":0,"own_type":0,"skill_id":2,"type":3}}},"3":{"unique_id":3,"kid":10020,"tank_id":3,"name":"\u864e\u738bII","type":3,"level":1,"exp":0,"star":5,"quality":4,"attack":1000,"defense":500,"blood":8000,"wear":95,"anti_wear":80,"crit_hurt":0,"talent_id":1,"common_skill_id":1,"compat_skill_id":2,"morale":0,"talent":{"attak_plus":2,"blood_plus":2,"crit_rate":0,"defense_plus":1.5,"desc":"\u653b\u51fbS\u7ea7\uff0c\u9632\u5fa1\u3001\u8840\u91cfA\u7ea7\uff0c\u95ea\u907fA\u7ea7","disarm_anti":0,"dodge_rate":250,"hit_plus":0,"name":"\u864e\u738bII","talent_id":1},"skill":{"common_skill":{"defense_effect_id":1,"desc":"\u5bf9\u654c\u65b9\u5355\u4f53\u9020\u62101.2\u500d\u4f24\u5bb3\uff0c\u5e76\u670940%\u6982\u7387\u8fde\u51fb","enemy_effect_value":400,"enemy_target":1,"enemy_type":4,"hurt_multiples":1.2,"name":"\u864e\u738bII","own_effect_value":0,"own_target":0,"own_type":0,"skill_id":1,"type":3},"compat_skill":{"defense_effect_id":1,"desc":"\u5bf9\u76ee\u6807\u5355\u4f53\u9020\u62103\u500d\u4f24\u5bb3\u5e7670%\u6982\u7387\u7f34\u68b0\u4e00\u56de\u5408","enemy_effect_value":700,"enemy_target":4,"enemy_type":2,"hurt_multiples":1,"name":"\u864e\u738bII\u5927\u62db","own_effect_value":0,"own_target":0,"own_type":0,"skill_id":2,"type":3}}},"4":{"unique_id":4,"kid":10020,"tank_id":4,"name":"IS-3","type":3,"level":1,"exp":0,"star":5,"quality":4,"attack":1000,"defense":500,"blood":4000,"wear":95,"anti_wear":80,"crit_hurt":0,"talent_id":2,"common_skill_id":3,"compat_skill_id":4,"morale":0,"talent":{"attak_plus":2,"blood_plus":1,"crit_rate":500,"defense_plus":1,"desc":"\u653b\u51fbS\u7ea7\uff0c\u66b4\u51fbS\u7ea7","disarm_anti":0,"dodge_rate":0,"hit_plus":0,"name":"IS-3","talent_id":2},"skill":{"common_skill":{"defense_effect_id":2,"desc":"\u5bf9\u654c\u65b9\u6a2a\u6392\u9020\u62101\u500d\u4f24\u5bb3","enemy_effect_value":0,"enemy_target":3,"enemy_type":1,"hurt_multiples":0.8,"name":"IS-3","own_effect_value":15,"own_target":2,"own_type":1,"skill_id":3,"type":2},"compat_skill":{"defense_effect_id":2,"desc":"\u5bf9\u654c\u65b9\u540e\u6392\u9020\u62101.5\u500d\u4f24\u5bb3","enemy_effect_value":0,"enemy_target":5,"enemy_type":1,"hurt_multiples":1.5,"name":"IS-3\u5927\u62db","own_effect_value":0,"own_target":0,"own_type":0,"skill_id":4,"type":3}}},"5":{"unique_id":5,"kid":10020,"tank_id":5,"name":"IS-3","type":3,"level":1,"exp":0,"star":5,"quality":4,"attack":1000,"defense":500,"blood":4000,"wear":95,"anti_wear":80,"crit_hurt":0,"talent_id":2,"common_skill_id":3,"compat_skill_id":4,"morale":0,"talent":{"attak_plus":2,"blood_plus":1,"crit_rate":500,"defense_plus":1,"desc":"\u653b\u51fbS\u7ea7\uff0c\u66b4\u51fbS\u7ea7","disarm_anti":0,"dodge_rate":0,"hit_plus":0,"name":"IS-3","talent_id":2},"skill":{"common_skill":{"defense_effect_id":2,"desc":"\u5bf9\u654c\u65b9\u6a2a\u6392\u9020\u62101\u500d\u4f24\u5bb3","enemy_effect_value":0,"enemy_target":3,"enemy_type":1,"hurt_multiples":0.8,"name":"IS-3","own_effect_value":15,"own_target":2,"own_type":1,"skill_id":3,"type":2},"compat_skill":{"defense_effect_id":2,"desc":"\u5bf9\u654c\u65b9\u540e\u6392\u9020\u62101.5\u500d\u4f24\u5bb3","enemy_effect_value":0,"enemy_target":5,"enemy_type":1,"hurt_multiples":1.5,"name":"IS-3\u5927\u62db","own_effect_value":0,"own_target":0,"own_type":0,"skill_id":4,"type":3}}},"6":{"unique_id":6,"kid":10020,"tank_id":6,"name":"IS-3","type":3,"level":1,"exp":0,"star":5,"quality":4,"attack":1000,"defense":500,"blood":4000,"wear":120,"anti_wear":60,"crit_hurt":0,"talent_id":2,"common_skill_id":3,"compat_skill_id":4,"morale":0,"talent":{"attak_plus":2,"blood_plus":1,"crit_rate":500,"defense_plus":1,"desc":"\u653b\u51fbS\u7ea7\uff0c\u66b4\u51fbS\u7ea7","disarm_anti":0,"dodge_rate":0,"hit_plus":0,"name":"IS-3","talent_id":2},"skill":{"common_skill":{"defense_effect_id":2,"desc":"\u5bf9\u654c\u65b9\u6a2a\u6392\u9020\u62101\u500d\u4f24\u5bb3","enemy_effect_value":0,"enemy_target":3,"enemy_type":1,"hurt_multiples":0.8,"name":"IS-3","own_effect_value":15,"own_target":2,"own_type":1,"skill_id":3,"type":2},"compat_skill":{"defense_effect_id":2,"desc":"\u5bf9\u654c\u65b9\u540e\u6392\u9020\u62101.5\u500d\u4f24\u5bb3","enemy_effect_value":0,"enemy_target":5,"enemy_type":1,"hurt_multiples":1.5,"name":"IS-3\u5927\u62db","own_effect_value":0,"own_target":0,"own_type":0,"skill_id":4,"type":3}}}},"user":{"nickname":"test1","level":10}},"right":{"tank":{"1":{"unique_id":1,"kid":10000,"tank_id":1,"name":"\u864e\u738bII","type":3,"level":1,"exp":0,"star":5,"quality":1,"attack":1000,"defense":500,"blood":8000,"wear":90,"anti_wear":80,"crit_hurt":0,"talent_id":3,"common_skill_id":5,"compat_skill_id":6,"morale":0,"talent":{"attak_plus":2,"blood_plus":2,"crit_rate":0,"defense_plus":1,"desc":"\u653b\u51fbS\u7ea7\uff0c\u95ea\u907f\u3001\u8840\u91cf\u3001\u547d\u4e2dA\u7ea7","disarm_anti":0,"dodge_rate":250,"hit_plus":250,"name":"\u654c\u65b9\u864e\u738bII","talent_id":3},"skill":{"common_skill":{"defense_effect_id":1,"desc":"\u5bf9\u76ee\u6807\u5355\u4f53\u9020\u62101.2\u500d\u4f24\u5bb3","enemy_effect_value":0,"enemy_target":1,"enemy_type":1,"hurt_multiples":1.2,"name":"\u864e\u738bII\u654c\u65b9","own_effect_value":0,"own_target":0,"own_type":0,"skill_id":5,"type":3},"compat_skill":{"defense_effect_id":1,"desc":"\u5bf9\u76ee\u6807\u5355\u4f53\u9020\u62103\u500d\u4f24\u5bb3","enemy_effect_value":0,"enemy_target":1,"enemy_type":1,"hurt_multiples":3,"name":"\u864e\u738bII\u654c\u5927\u62db","own_effect_value":0,"own_target":0,"own_type":0,"skill_id":6,"type":3}}},"2":{"unique_id":2,"kid":10000,"tank_id":2,"name":"\u864e\u738bII","type":3,"level":1,"exp":0,"star":5,"quality":1,"attack":1000,"defense":500,"blood":8000,"wear":90,"anti_wear":80,"crit_hurt":0,"talent_id":3,"common_skill_id":5,"compat_skill_id":6,"morale":0,"talent":{"attak_plus":2,"blood_plus":2,"crit_rate":0,"defense_plus":1,"desc":"\u653b\u51fbS\u7ea7\uff0c\u95ea\u907f\u3001\u8840\u91cf\u3001\u547d\u4e2dA\u7ea7","disarm_anti":0,"dodge_rate":250,"hit_plus":250,"name":"\u654c\u65b9\u864e\u738bII","talent_id":3},"skill":{"common_skill":{"defense_effect_id":1,"desc":"\u5bf9\u76ee\u6807\u5355\u4f53\u9020\u62101.2\u500d\u4f24\u5bb3","enemy_effect_value":0,"enemy_target":1,"enemy_type":1,"hurt_multiples":1.2,"name":"\u864e\u738bII\u654c\u65b9","own_effect_value":0,"own_target":0,"own_type":0,"skill_id":5,"type":3},"compat_skill":{"defense_effect_id":1,"desc":"\u5bf9\u76ee\u6807\u5355\u4f53\u9020\u62103\u500d\u4f24\u5bb3","enemy_effect_value":0,"enemy_target":1,"enemy_type":1,"hurt_multiples":3,"name":"\u864e\u738bII\u654c\u5927\u62db","own_effect_value":0,"own_target":0,"own_type":0,"skill_id":6,"type":3}}},"3":{"unique_id":3,"kid":10000,"tank_id":3,"name":"\u864e\u738bII","type":3,"level":1,"exp":0,"star":5,"quality":1,"attack":1000,"defense":500,"blood":8000,"wear":90,"anti_wear":80,"crit_hurt":0,"talent_id":3,"common_skill_id":5,"compat_skill_id":6,"morale":0,"talent":{"attak_plus":2,"blood_plus":2,"crit_rate":0,"defense_plus":1,"desc":"\u653b\u51fbS\u7ea7\uff0c\u95ea\u907f\u3001\u8840\u91cf\u3001\u547d\u4e2dA\u7ea7","disarm_anti":0,"dodge_rate":250,"hit_plus":250,"name":"\u654c\u65b9\u864e\u738bII","talent_id":3},"skill":{"common_skill":{"defense_effect_id":1,"desc":"\u5bf9\u76ee\u6807\u5355\u4f53\u9020\u62101.2\u500d\u4f24\u5bb3","enemy_effect_value":0,"enemy_target":1,"enemy_type":1,"hurt_multiples":1.2,"name":"\u864e\u738bII\u654c\u65b9","own_effect_value":0,"own_target":0,"own_type":0,"skill_id":5,"type":3},"compat_skill":{"defense_effect_id":1,"desc":"\u5bf9\u76ee\u6807\u5355\u4f53\u9020\u62103\u500d\u4f24\u5bb3","enemy_effect_value":0,"enemy_target":1,"enemy_type":1,"hurt_multiples":3,"name":"\u864e\u738bII\u654c\u5927\u62db","own_effect_value":0,"own_target":0,"own_type":0,"skill_id":6,"type":3}}},"4":{"unique_id":4,"kid":10000,"tank_id":4,"name":"IS-3","type":3,"level":1,"exp":0,"star":5,"quality":2,"attack":1000,"defense":500,"blood":4000,"wear":90,"anti_wear":80,"crit_hurt":0,"talent_id":4,"common_skill_id":7,"compat_skill_id":8,"morale":50,"talent":{"attak_plus":1.5,"blood_plus":1,"crit_rate":0,"defense_plus":1,"desc":"\u653b\u51fbA\u7ea7\uff0c\u95ea\u907fS\u7ea7","disarm_anti":0,"dodge_rate":400,"hit_plus":0,"name":"\u654c\u65b9IS-3","talent_id":4},"skill":{"common_skill":{"defense_effect_id":2,"desc":"\u5bf9\u654c\u65b9\u7eb5\u5217\u9020\u62100.8\u500d\u4f24\u5bb3","enemy_effect_value":0,"enemy_target":3,"enemy_type":1,"hurt_multiples":0.8,"name":"IS-3\u654c\u65b9","own_effect_value":0,"own_target":0,"own_type":0,"skill_id":7,"type":3},"compat_skill":{"defense_effect_id":2,"desc":"\u5bf9\u654c\u65b9\u5168\u4f53\u9020\u62101\u500d\u4f24\u5bb3","enemy_effect_value":0,"enemy_target":4,"enemy_type":1,"hurt_multiples":1,"name":"IS-3\u654c\u65b9\u5927\u62db","own_effect_value":0,"own_target":0,"own_type":0,"skill_id":8,"type":3}}},"5":{"unique_id":5,"kid":10000,"tank_id":5,"name":"IS-3","type":3,"level":1,"exp":0,"star":5,"quality":2,"attack":1000,"defense":500,"blood":4000,"wear":90,"anti_wear":80,"crit_hurt":0,"talent_id":4,"common_skill_id":7,"compat_skill_id":8,"morale":50,"talent":{"attak_plus":1.5,"blood_plus":1,"crit_rate":0,"defense_plus":1,"desc":"\u653b\u51fbA\u7ea7\uff0c\u95ea\u907fS\u7ea7","disarm_anti":0,"dodge_rate":400,"hit_plus":0,"name":"\u654c\u65b9IS-3","talent_id":4},"skill":{"common_skill":{"defense_effect_id":2,"desc":"\u5bf9\u654c\u65b9\u7eb5\u5217\u9020\u62100.8\u500d\u4f24\u5bb3","enemy_effect_value":0,"enemy_target":3,"enemy_type":1,"hurt_multiples":0.8,"name":"IS-3\u654c\u65b9","own_effect_value":0,"own_target":0,"own_type":0,"skill_id":7,"type":3},"compat_skill":{"defense_effect_id":2,"desc":"\u5bf9\u654c\u65b9\u5168\u4f53\u9020\u62101\u500d\u4f24\u5bb3","enemy_effect_value":0,"enemy_target":4,"enemy_type":1,"hurt_multiples":1,"name":"IS-3\u654c\u65b9\u5927\u62db","own_effect_value":0,"own_target":0,"own_type":0,"skill_id":8,"type":3}}},"6":{"unique_id":6,"kid":10000,"tank_id":6,"name":"IS-3","type":3,"level":1,"exp":0,"star":5,"quality":2,"attack":1000,"defense":500,"blood":4000,"wear":90,"anti_wear":80,"crit_hurt":0,"talent_id":5,"common_skill_id":7,"compat_skill_id":8,"morale":65,"talent":{"attak_plus":1.5,"blood_plus":1,"crit_rate":0,"defense_plus":1,"desc":"\u653b\u51fbA\u7ea7\uff0c\u6297\u7f34\u68b0S\u7ea7","disarm_anti":800,"dodge_rate":0,"hit_plus":0,"name":"\u654c\u65b9IS-3","talent_id":5},"skill":{"common_skill":{"defense_effect_id":2,"desc":"\u5bf9\u654c\u65b9\u7eb5\u5217\u9020\u62100.8\u500d\u4f24\u5bb3","enemy_effect_value":0,"enemy_target":3,"enemy_type":1,"hurt_multiples":0.8,"name":"IS-3\u654c\u65b9","own_effect_value":0,"own_target":0,"own_type":0,"skill_id":7,"type":3},"compat_skill":{"defense_effect_id":2,"desc":"\u5bf9\u654c\u65b9\u5168\u4f53\u9020\u62101\u500d\u4f24\u5bb3","enemy_effect_value":0,"enemy_target":4,"enemy_type":1,"hurt_multiples":1,"name":"IS-3\u654c\u65b9\u5927\u62db","own_effect_value":0,"own_target":0,"own_type":0,"skill_id":8,"type":3}}}},"user":{"nickname":"test2","level":8}}},"fight":[{"battle":[{"attack":{"pos":1,"from":0,"skill_id":1,"is_compat":0,"add_m":0,"morale":0,"is_crit":0,"hurt":0,"add":0,"blood":8000},"defense":[{"pos":1,"from":1,"skill_id":1,"hurt":0,"blood":8000,"morale":15,"is_dodge":1,"type":0}],"own":[]},{"attack":{"pos":1,"from":0,"skill_id":1,"is_compat":0,"add_m":0,"morale":35,"is_crit":0,"hurt":0,"add":0,"blood":8000},"defense":[{"pos":1,"from":1,"skill_id":1,"hurt":2070,"blood":5930,"morale":30,"is_dodge":0,"type":0}],"own":[]},{"attack":{"pos":1,"from":1,"skill_id":5,"is_compat":0,"add_m":0,"morale":65,"is_crit":0,"hurt":0,"add":0,"blood":5930},"defense":[{"pos":1,"from":0,"skill_id":5,"hurt":1650,"blood":6350,"morale":50,"is_dodge":0,"type":0}],"own":[]},{"attack":{"pos":2,"from":0,"skill_id":1,"is_compat":0,"add_m":0,"morale":35,"is_crit":0,"hurt":0,"add":0,"blood":8000},"defense":[{"pos":2,"from":1,"skill_id":1,"hurt":2070,"blood":5930,"morale":15,"is_dodge":0,"type":0}],"own":[]},{"attack":{"pos":2,"from":1,"skill_id":5,"is_compat":0,"add_m":0,"morale":50,"is_crit":0,"hurt":0,"add":0,"blood":5930},"defense":[{"pos":2,"from":0,"skill_id":5,"hurt":1650,"blood":6350,"morale":50,"is_dodge":0,"type":0}],"own":[]},{"attack":{"pos":3,"from":0,"skill_id":1,"is_compat":0,"add_m":0,"morale":35,"is_crit":0,"hurt":0,"add":0,"blood":8000},"defense":[{"pos":3,"from":1,"skill_id":1,"hurt":2070,"blood":5930,"morale":15,"is_dodge":0,"type":0}],"own":[]},{"attack":{"pos":3,"from":0,"skill_id":1,"is_compat":0,"add_m":0,"morale":35,"is_crit":0,"hurt":0,"add":0,"blood":8000},"defense":[{"pos":3,"from":1,"skill_id":1,"hurt":0,"blood":5930,"morale":30,"is_dodge":1,"type":0}],"own":[]},{"attack":{"pos":3,"from":1,"skill_id":5,"is_compat":0,"add_m":0,"morale":65,"is_crit":0,"hurt":0,"add":0,"blood":5930},"defense":[{"pos":3,"from":0,"skill_id":5,"hurt":1650,"blood":6350,"morale":50,"is_dodge":0,"type":0}],"own":[]},{"attack":{"pos":4,"from":0,"skill_id":3,"is_compat":0,"add_m":0,"morale":35,"is_crit":1,"hurt":0,"add":0,"blood":4000},"defense":[{"pos":1,"from":1,"skill_id":3,"hurt":2070,"blood":3860,"morale":80,"is_dodge":0,"type":0},{"pos":4,"from":1,"skill_id":3,"hurt":2070,"blood":1930,"morale":65,"is_dodge":0,"type":0}],"own":[{"pos":5,"from":0,"type":1,"change":15,"value":15}]},{"attack":{"pos":4,"from":1,"skill_id":7,"is_compat":0,"add_m":0,"morale":65,"is_crit":0,"hurt":0,"add":0,"blood":1930},"defense":[{"pos":1,"from":0,"skill_id":7,"hurt":0,"blood":6350,"morale":65,"is_dodge":1,"type":0},{"pos":4,"from":0,"skill_id":7,"hurt":880,"blood":3120,"morale":50,"is_dodge":0,"type":0}],"own":[]},{"attack":{"pos":5,"from":0,"skill_id":3,"is_compat":0,"add_m":0,"morale":50,"is_crit":0,"hurt":0,"add":0,"blood":4000},"defense":[{"pos":2,"from":1,"skill_id":3,"hurt":1380,"blood":4550,"morale":65,"is_dodge":0,"type":0},{"pos":5,"from":1,"skill_id":3,"hurt":1380,"blood":2620,"morale":65,"is_dodge":0,"type":0}],"own":[{"pos":6,"from":0,"type":1,"change":15,"value":15}]},{"attack":{"pos":5,"from":1,"skill_id":7,"is_compat":0,"add_m":0,"morale":100,"is_crit":0,"hurt":0,"add":0,"blood":2620},"defense":[{"pos":2,"from":0,"skill_id":7,"hurt":660,"blood":5690,"morale":65,"is_dodge":0,"type":0},{"pos":5,"from":0,"skill_id":7,"hurt":880,"blood":3120,"morale":65,"is_dodge":0,"type":0}],"own":[]},{"attack":{"pos":6,"from":0,"skill_id":3,"is_compat":0,"add_m":0,"morale":50,"is_crit":0,"hurt":0,"add":0,"blood":4000},"defense":[{"pos":3,"from":1,"skill_id":3,"hurt":1679,"blood":4251,"morale":80,"is_dodge":0,"type":0},{"pos":6,"from":1,"skill_id":3,"hurt":1679,"blood":2321,"morale":80,"is_dodge":0,"type":0}],"own":[{"pos":6,"from":0,"type":1,"change":15,"value":65}]},{"attack":{"pos":6,"from":1,"skill_id":7,"is_compat":0,"add_m":0,"morale":115,"is_crit":0,"hurt":0,"add":0,"blood":2321},"defense":[{"pos":3,"from":0,"skill_id":7,"hurt":660,"blood":5690,"morale":65,"is_dodge":0,"type":0},{"pos":6,"from":0,"skill_id":7,"hurt":1040,"blood":2960,"morale":80,"is_dodge":0,"type":0}],"own":[]}],"end":[]},{"battle":[{"attack":{"pos":1,"from":0,"skill_id":1,"is_compat":0,"add_m":0,"morale":100,"is_crit":0,"hurt":0,"add":0,"blood":6350},"defense":[{"pos":1,"from":1,"skill_id":1,"hurt":2070,"blood":1790,"morale":95,"is_dodge":0,"type":0}],"own":[]},{"attack":{"pos":1,"from":0,"skill_id":1,"is_compat":0,"add_m":0,"morale":100,"is_crit":0,"hurt":0,"add":0,"blood":6350},"defense":[{"pos":1,"from":1,"skill_id":1,"hurt":0,"blood":1790,"morale":110,"is_dodge":1,"type":0}],"own":[]},{"attack":{"pos":1,"from":1,"skill_id":6,"is_compat":1,"add_m":-100,"morale":110,"is_crit":0,"hurt":0,"add":0,"blood":1790},"defense":[{"pos":1,"from":0,"skill_id":6,"hurt":4125,"blood":2225,"morale":115,"is_dodge":0,"type":0}],"own":[]},{"attack":{"pos":2,"from":0,"skill_id":1,"is_compat":0,"add_m":0,"morale":100,"is_crit":0,"hurt":0,"add":0,"blood":5690},"defense":[{"pos":2,"from":1,"skill_id":1,"hurt":2070,"blood":2480,"morale":80,"is_dodge":0,"type":0}],"own":[]},{"attack":{"pos":2,"from":1,"skill_id":5,"is_compat":0,"add_m":0,"morale":115,"is_crit":0,"hurt":0,"add":0,"blood":2480},"defense":[{"pos":2,"from":0,"skill_id":5,"hurt":1650,"blood":4040,"morale":115,"is_dodge":0,"type":0}],"own":[]},{"attack":{"pos":3,"from":0,"skill_id":1,"is_compat":0,"add_m":0,"morale":100,"is_crit":0,"hurt":0,"add":0,"blood":5690},"defense":[{"pos":3,"from":1,"skill_id":1,"hurt":2070,"blood":2181,"morale":95,"is_dodge":0,"type":0}],"own":[]},{"attack":{"pos":3,"from":0,"skill_id":1,"is_compat":0,"add_m":0,"morale":100,"is_crit":0,"hurt":0,"add":0,"blood":5690},"defense":[{"pos":3,"from":1,"skill_id":1,"hurt":0,"blood":2181,"morale":110,"is_dodge":1,"type":0}],"own":[]},{"attack":{"pos":3,"from":1,"skill_id":6,"is_compat":1,"add_m":-100,"morale":110,"is_crit":0,"hurt":0,"add":0,"blood":2181},"defense":[{"pos":3,"from":0,"skill_id":6,"hurt":4125,"blood":1565,"morale":115,"is_dodge":0,"type":0}],"own":[]},{"attack":{"pos":4,"from":0,"skill_id":3,"is_compat":0,"add_m":0,"morale":85,"is_crit":1,"hurt":0,"add":0,"blood":3120},"defense":[{"pos":1,"from":1,"skill_id":3,"hurt":2070,"blood":0,"morale":10,"is_dodge":0,"type":0},{"pos":4,"from":1,"skill_id":3,"hurt":2070,"blood":0,"morale":65,"is_dodge":0,"type":0}],"own":[{"pos":4,"from":0,"type":1,"change":15,"value":100}]},{"attack":{"pos":5,"from":0,"skill_id":3,"is_compat":0,"add_m":0,"morale":100,"is_crit":0,"hurt":0,"add":0,"blood":3120},"defense":[{"pos":2,"from":1,"skill_id":3,"hurt":1380,"blood":1100,"morale":130,"is_dodge":0,"type":0},{"pos":5,"from":1,"skill_id":3,"hurt":1380,"blood":1240,"morale":115,"is_dodge":0,"type":0}],"own":[{"pos":5,"from":0,"type":1,"change":15,"value":115}]},{"attack":{"pos":5,"from":1,"skill_id":8,"is_compat":1,"add_m":-100,"morale":115,"is_crit":0,"hurt":0,"add":0,"blood":1240},"defense":[{"pos":1,"from":0,"skill_id":8,"hurt":825,"blood":1400,"morale":130,"is_dodge":0,"type":0},{"pos":2,"from":0,"skill_id":8,"hurt":0,"blood":4040,"morale":130,"is_dodge":1,"type":0},{"pos":3,"from":0,"skill_id":8,"hurt":0,"blood":1565,"morale":130,"is_dodge":1,"type":0},{"pos":4,"from":0,"skill_id":8,"hurt":1100,"blood":2020,"morale":115,"is_dodge":0,"type":0},{"pos":5,"from":0,"skill_id":8,"hurt":1100,"blood":2020,"morale":130,"is_dodge":0,"type":0},{"pos":6,"from":0,"skill_id":8,"hurt":1300,"blood":1660,"morale":95,"is_dodge":0,"type":0}],"own":[]},{"attack":{"pos":6,"from":0,"skill_id":3,"is_compat":0,"add_m":0,"morale":130,"is_crit":0,"hurt":0,"add":0,"blood":1660},"defense":[{"pos":3,"from":1,"skill_id":3,"hurt":1679,"blood":502,"morale":25,"is_dodge":0,"type":0},{"pos":6,"from":1,"skill_id":3,"hurt":1679,"blood":642,"morale":130,"is_dodge":0,"type":0}],"own":[{"pos":6,"from":0,"type":1,"change":15,"value":145}]},{"attack":{"pos":6,"from":1,"skill_id":8,"is_compat":1,"add_m":-100,"morale":130,"is_crit":0,"hurt":0,"add":0,"blood":642},"defense":[{"pos":1,"from":0,"skill_id":8,"hurt":825,"blood":575,"morale":145,"is_dodge":0,"type":0},{"pos":2,"from":0,"skill_id":8,"hurt":825,"blood":3215,"morale":145,"is_dodge":0,"type":0},{"pos":3,"from":0,"skill_id":8,"hurt":825,"blood":740,"morale":145,"is_dodge":0,"type":0},{"pos":4,"from":0,"skill_id":8,"hurt":1100,"blood":920,"morale":130,"is_dodge":0,"type":0},{"pos":5,"from":0,"skill_id":8,"hurt":1100,"blood":920,"morale":145,"is_dodge":0,"type":0},{"pos":6,"from":0,"skill_id":8,"hurt":1300,"blood":360,"morale":160,"is_dodge":0,"type":0}],"own":[]}],"end":[]},{"battle":[{"attack":{"pos":1,"from":0,"skill_id":2,"is_compat":1,"add_m":-100,"morale":145,"is_crit":0,"hurt":0,"add":0,"blood":575},"defense":[{"pos":1,"from":1,"skill_id":-1},{"pos":2,"from":1,"skill_id":2,"hurt":1724,"blood":0,"morale":130,"is_dodge":0,"type":0},{"pos":3,"from":1,"skill_id":2,"hurt":1724,"blood":0,"morale":25,"is_dodge":0,"type":0},{"pos":4,"from":1,"skill_id":-1},{"pos":5,"from":1,"skill_id":2,"hurt":0,"blood":1240,"morale":30,"is_dodge":1,"type":0},{"pos":6,"from":1,"skill_id":2,"hurt":1724,"blood":0,"morale":30,"is_dodge":0,"type":0}],"own":[]},{"attack":{"pos":2,"from":0,"skill_id":2,"is_compat":1,"add_m":-100,"morale":145,"is_crit":0,"hurt":0,"add":0,"blood":3215},"defense":[{"pos":1,"from":1,"skill_id":-1},{"pos":2,"from":1,"skill_id":-1},{"pos":3,"from":1,"skill_id":-1},{"pos":4,"from":1,"skill_id":-1},{"pos":5,"from":1,"skill_id":2,"hurt":1724,"blood":0,"morale":30,"is_dodge":0,"type":0}],"own":[]}],"end":[]}],"end":{"left":{"tank":{"1":{"unique_id":1,"kid":10020,"tank_id":1,"name":"\u864e\u738bII","type":3,"level":1,"exp":0,"star":5,"quality":4,"attack":1000,"defense":500,"blood":575,"wear":95,"anti_wear":80,"crit_hurt":0,"talent_id":1,"common_skill_id":1,"compat_skill_id":2,"morale":45,"talent":{"attak_plus":2,"blood_plus":2,"crit_rate":0,"defense_plus":1.5,"desc":"\u653b\u51fbS\u7ea7\uff0c\u9632\u5fa1\u3001\u8840\u91cfA\u7ea7\uff0c\u95ea\u907fA\u7ea7","disarm_anti":0,"dodge_rate":250,"hit_plus":0,"name":"\u864e\u738bII","talent_id":1},"skill":{"common_skill":{"defense_effect_id":1,"desc":"\u5bf9\u654c\u65b9\u5355\u4f53\u9020\u62101.2\u500d\u4f24\u5bb3\uff0c\u5e76\u670940%\u6982\u7387\u8fde\u51fb","enemy_effect_value":400,"enemy_target":1,"enemy_type":4,"hurt_multiples":1.2,"name":"\u864e\u738bII","own_effect_value":0,"own_target":0,"own_type":0,"skill_id":1,"type":3},"compat_skill":{"defense_effect_id":1,"desc":"\u5bf9\u76ee\u6807\u5355\u4f53\u9020\u62103\u500d\u4f24\u5bb3\u5e7670%\u6982\u7387\u7f34\u68b0\u4e00\u56de\u5408","enemy_effect_value":700,"enemy_target":4,"enemy_type":2,"hurt_multiples":1,"name":"\u864e\u738bII\u5927\u62db","own_effect_value":0,"own_target":0,"own_type":0,"skill_id":2,"type":3}},"buff":{"batter":[]}},"2":{"unique_id":2,"kid":10020,"tank_id":2,"name":"\u864e\u738bII","type":3,"level":1,"exp":0,"star":5,"quality":4,"attack":1000,"defense":500,"blood":3215,"wear":95,"anti_wear":80,"crit_hurt":0,"talent_id":1,"common_skill_id":1,"compat_skill_id":2,"morale":45,"talent":{"attak_plus":2,"blood_plus":2,"crit_rate":0,"defense_plus":1.5,"desc":"\u653b\u51fbS\u7ea7\uff0c\u9632\u5fa1\u3001\u8840\u91cfA\u7ea7\uff0c\u95ea\u907fA\u7ea7","disarm_anti":0,"dodge_rate":250,"hit_plus":0,"name":"\u864e\u738bII","talent_id":1},"skill":{"common_skill":{"defense_effect_id":1,"desc":"\u5bf9\u654c\u65b9\u5355\u4f53\u9020\u62101.2\u500d\u4f24\u5bb3\uff0c\u5e76\u670940%\u6982\u7387\u8fde\u51fb","enemy_effect_value":400,"enemy_target":1,"enemy_type":4,"hurt_multiples":1.2,"name":"\u864e\u738bII","own_effect_value":0,"own_target":0,"own_type":0,"skill_id":1,"type":3},"compat_skill":{"defense_effect_id":1,"desc":"\u5bf9\u76ee\u6807\u5355\u4f53\u9020\u62103\u500d\u4f24\u5bb3\u5e7670%\u6982\u7387\u7f34\u68b0\u4e00\u56de\u5408","enemy_effect_value":700,"enemy_target":4,"enemy_type":2,"hurt_multiples":1,"name":"\u864e\u738bII\u5927\u62db","own_effect_value":0,"own_target":0,"own_type":0,"skill_id":2,"type":3}},"buff":{"batter":[]}},"3":{"unique_id":3,"kid":10020,"tank_id":3,"name":"\u864e\u738bII","type":3,"level":1,"exp":0,"star":5,"quality":4,"attack":1000,"defense":500,"blood":740,"wear":95,"anti_wear":80,"crit_hurt":0,"talent_id":1,"common_skill_id":1,"compat_skill_id":2,"morale":145,"talent":{"attak_plus":2,"blood_plus":2,"crit_rate":0,"defense_plus":1.5,"desc":"\u653b\u51fbS\u7ea7\uff0c\u9632\u5fa1\u3001\u8840\u91cfA\u7ea7\uff0c\u95ea\u907fA\u7ea7","disarm_anti":0,"dodge_rate":250,"hit_plus":0,"name":"\u864e\u738bII","talent_id":1},"skill":{"common_skill":{"defense_effect_id":1,"desc":"\u5bf9\u654c\u65b9\u5355\u4f53\u9020\u62101.2\u500d\u4f24\u5bb3\uff0c\u5e76\u670940%\u6982\u7387\u8fde\u51fb","enemy_effect_value":400,"enemy_target":1,"enemy_type":4,"hurt_multiples":1.2,"name":"\u864e\u738bII","own_effect_value":0,"own_target":0,"own_type":0,"skill_id":1,"type":3},"compat_skill":{"defense_effect_id":1,"desc":"\u5bf9\u76ee\u6807\u5355\u4f53\u9020\u62103\u500d\u4f24\u5bb3\u5e7670%\u6982\u7387\u7f34\u68b0\u4e00\u56de\u5408","enemy_effect_value":700,"enemy_target":4,"enemy_type":2,"hurt_multiples":1,"name":"\u864e\u738bII\u5927\u62db","own_effect_value":0,"own_target":0,"own_type":0,"skill_id":2,"type":3}},"buff":{"batter":[]}},"4":{"unique_id":4,"kid":10020,"tank_id":4,"name":"IS-3","type":3,"level":1,"exp":0,"star":5,"quality":4,"attack":1000,"defense":500,"blood":920,"wear":95,"anti_wear":80,"crit_hurt":0,"talent_id":2,"common_skill_id":3,"compat_skill_id":4,"morale":130,"talent":{"attak_plus":2,"blood_plus":1,"crit_rate":500,"defense_plus":1,"desc":"\u653b\u51fbS\u7ea7\uff0c\u66b4\u51fbS\u7ea7","disarm_anti":0,"dodge_rate":0,"hit_plus":0,"name":"IS-3","talent_id":2},"skill":{"common_skill":{"defense_effect_id":2,"desc":"\u5bf9\u654c\u65b9\u6a2a\u6392\u9020\u62101\u500d\u4f24\u5bb3","enemy_effect_value":0,"enemy_target":3,"enemy_type":1,"hurt_multiples":0.8,"name":"IS-3","own_effect_value":15,"own_target":2,"own_type":1,"skill_id":3,"type":2},"compat_skill":{"defense_effect_id":2,"desc":"\u5bf9\u654c\u65b9\u540e\u6392\u9020\u62101.5\u500d\u4f24\u5bb3","enemy_effect_value":0,"enemy_target":5,"enemy_type":1,"hurt_multiples":1.5,"name":"IS-3\u5927\u62db","own_effect_value":0,"own_target":0,"own_type":0,"skill_id":4,"type":3}},"buff":{"batter":[]}},"5":{"unique_id":5,"kid":10020,"tank_id":5,"name":"IS-3","type":3,"level":1,"exp":0,"star":5,"quality":4,"attack":1000,"defense":500,"blood":920,"wear":95,"anti_wear":80,"crit_hurt":0,"talent_id":2,"common_skill_id":3,"compat_skill_id":4,"morale":145,"talent":{"attak_plus":2,"blood_plus":1,"crit_rate":500,"defense_plus":1,"desc":"\u653b\u51fbS\u7ea7\uff0c\u66b4\u51fbS\u7ea7","disarm_anti":0,"dodge_rate":0,"hit_plus":0,"name":"IS-3","talent_id":2},"skill":{"common_skill":{"defense_effect_id":2,"desc":"\u5bf9\u654c\u65b9\u6a2a\u6392\u9020\u62101\u500d\u4f24\u5bb3","enemy_effect_value":0,"enemy_target":3,"enemy_type":1,"hurt_multiples":0.8,"name":"IS-3","own_effect_value":15,"own_target":2,"own_type":1,"skill_id":3,"type":2},"compat_skill":{"defense_effect_id":2,"desc":"\u5bf9\u654c\u65b9\u540e\u6392\u9020\u62101.5\u500d\u4f24\u5bb3","enemy_effect_value":0,"enemy_target":5,"enemy_type":1,"hurt_multiples":1.5,"name":"IS-3\u5927\u62db","own_effect_value":0,"own_target":0,"own_type":0,"skill_id":4,"type":3}},"buff":{"batter":[]}},"6":{"unique_id":6,"kid":10020,"tank_id":6,"name":"IS-3","type":3,"level":1,"exp":0,"star":5,"quality":4,"attack":1000,"defense":500,"blood":360,"wear":120,"anti_wear":60,"crit_hurt":0,"talent_id":2,"common_skill_id":3,"compat_skill_id":4,"morale":160,"talent":{"attak_plus":2,"blood_plus":1,"crit_rate":500,"defense_plus":1,"desc":"\u653b\u51fbS\u7ea7\uff0c\u66b4\u51fbS\u7ea7","disarm_anti":0,"dodge_rate":0,"hit_plus":0,"name":"IS-3","talent_id":2},"skill":{"common_skill":{"defense_effect_id":2,"desc":"\u5bf9\u654c\u65b9\u6a2a\u6392\u9020\u62101\u500d\u4f24\u5bb3","enemy_effect_value":0,"enemy_target":3,"enemy_type":1,"hurt_multiples":0.8,"name":"IS-3","own_effect_value":15,"own_target":2,"own_type":1,"skill_id":3,"type":2},"compat_skill":{"defense_effect_id":2,"desc":"\u5bf9\u654c\u65b9\u540e\u6392\u9020\u62101.5\u500d\u4f24\u5bb3","enemy_effect_value":0,"enemy_target":5,"enemy_type":1,"hurt_multiples":1.5,"name":"IS-3\u5927\u62db","own_effect_value":0,"own_target":0,"own_type":0,"skill_id":4,"type":3}},"buff":{"batter":[]}}}},"right":{"tank":[]},"is_win":1}}]]
        self.model:init(qy.json.decode(testData))
        callback(qy.json.decode(testData))
        return
    end
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Demo.test",
        ["p"] = {}
    })):send(function(response, request)
        self.model:init(response.data)
        callback(response.data)
    end)
end

function BattleService:getGuideBattle(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "guide.fight",
        ["p"] = {["ftue"] = qy.GuideModel:getCurrentBigStep()}
    }))
    -- :setShowLoading(true)
    :send(function(response, request)
    if not qy.isNoviceGuide then --||||||
                self.model:init(response.data.fight_result)
            end
        callback()
    end)
end

function BattleService:share(callback)
	qy.Http.new(qy.Http.Request.new({
        ["m"] = "user.share",
        ["p"] = {}
    }))
    -- :setShowLoading(true)
    :send(function(response, request)
    	callback()
    end)
end

return BattleService