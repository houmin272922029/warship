-- 配置文件缓存
ConfigureStorage = {

}

function ConfigureStorage:fromDictionary( confDic )
    if not confDic then
    	return
    end
    ConfigureStorage.version = confDic.settingVersion
    ConfigureStorage.item = confDic.item
    ConfigureStorage.itemType = confDic.item_type
    ConfigureStorage.equip = confDic.equip
    ConfigureStorage.equipEffect = confDic.equipeffect -- 强化价格系数
    ConfigureStorage.skillConfig = confDic.skillConfig
    ConfigureStorage.skillLv = confDic.skilllv -- 参悟配置
    ConfigureStorage.heroConfig = confDic.heroConfig
    ConfigureStorage.heroConfig2 = confDic.heroConfig2
    ConfigureStorage.heroConfig3 = confDic.heroConfig3
    ConfigureStorage.heroRecuit = confDic.herorecuit -- 英雄突破，英雄变魂，口诀吃魂获得经验配置
    ConfigureStorage.energy = confDic.energy -- 精力体力上限
    ConfigureStorage.pageConfig = confDic.pageConfig -- 江湖配置
    ConfigureStorage.stageTypeConfig = confDic.stageTypeConfig -- 关卡挑战次数
    ConfigureStorage.stageConfig = confDic.stageConfig -- 关卡配置
    ConfigureStorage.stageNpc = confDic.stage_npc
    ConfigureStorage.recruit = confDic.recruit
    ConfigureStorage.freeRecruitCDTime = confDic.freeRecruitCDTime -- 免费刷新cd时间
    ConfigureStorage.freeRecruitTimes = confDic.freeRecruitTimes -- 每日免费刷新次数
    ConfigureStorage.recruitPay = confDic.recruitPay -- 付费刷新配置
    ConfigureStorage.recruitPayFirst = confDic.recruitPayFirst
    ConfigureStorage.goldShop = confDic.goldShop
    ConfigureStorage.vipShop = confDic.vipShop
    ConfigureStorage.cashShop = confDic.cashShop
    ConfigureStorage.levelExp = confDic.levelExp -- value1 掌门升级需要经验 value2 弟子升级经验系数 需要乘弟子初始经验值
    ConfigureStorage.rankScore = confDic.rankScore -- 论剑的一个配置，不知道是啥
    ConfigureStorage.exchange = confDic.exchange -- 论剑兑换奖励配置
    ConfigureStorage.records = confDic.records -- 论剑首次进入排名奖励
    ConfigureStorage.npcList = confDic.npc_list
    ConfigureStorage.thresholdConfig = confDic.thresholdConfig -- 阈值配置
    ConfigureStorage.formMax = confDic.formMax -- 阵容上限配置
    ConfigureStorage.formSevenMax = confDic.formSevenMax -- 七星阵开启配置
    ConfigureStorage.warship_exp = confDic.warship_exp
    ConfigureStorage.warship = confDic.warship
    ConfigureStorage.energy = confDic.energy
    ConfigureStorage.animation = confDic.animation
    ConfigureStorage.titleConfig = confDic.titleConfig  -- 称号配置
    ConfigureStorage.openFormSevenItem = confDic.openFormSevenItem -- 开启七星阵所需道具
    ConfigureStorage.combo = confDic.assist
    ConfigureStorage.combo5 = confDic.assist5
    ConfigureStorage.formSevenAttr = confDic.formSevenAttr
    ConfigureStorage.formSevenUpgrade = confDic.formSevenUpgrade --新增 升级后的属性加成
    ConfigureStorage.formSevenLvUpCost = confDic.formSevenLvUpCost -- 啦啦队Lv升级消耗
    ConfigureStorage.formSevenLv = confDic.formSevenLv -- 啦啦队升级初始等级
    
    ConfigureStorage.storyClearStageLimit = confDic.storyClearStageLimit -- 清除关卡挑战次数
    ConfigureStorage.storyClearBatchCDTime = confDic.storyClearBatchCDTime -- 清除连闯cd
    ConfigureStorage.stageTalk = confDic.stageTalk -- 对话
    ConfigureStorage.upgrade_reward1 = confDic.upgrade_reward1 -- 日常里面的升级奖励配置
    ConfigureStorage.upgrade_reward2 = confDic.upgrade_reward2 -- 每次升级获得奖励配置
    ConfigureStorage.rollGuide = confDic.rollGuide      -- title滚动中的游戏指南信息
    ConfigureStorage.strengthRecoverTime = confDic.strengthRecoverTime -- 体力恢复时间配置
    ConfigureStorage.energyRecoverTime = confDic.energyRecoverTime -- 精力恢复时间配置
    ConfigureStorage.equipStagelMax = confDic.equipStagelMax   --装备最大阶
    ConfigureStorage.vipConfig = confDic.vipconfig
    ConfigureStorage.vipdesp = confDic.vipdesp
    ConfigureStorage.vipaward = confDic.vipaward
    ConfigureStorage.doubleExpCost = confDic.doubleExpCost -- 点拨双倍经验配置
    ConfigureStorage.dianbo = confDic.dianbo -- 点拨文字配置
    if confDic.extraItem and confDic.extraItem[1] then
        ConfigureStorage.extraItem = confDic.extraItem[1].item -- 点拨双倍使用道具
    end
    ConfigureStorage.GoldenBell = confDic.GoldenBell    --黄金钟
    ConfigureStorage.message = confDic.message
    ConfigureStorage.levelguide = confDic.levelguide -- 后续引导
    ConfigureStorage.rollingTable = confDic.rollingTable
    ConfigureStorage.Dreamgift = confDic.Dreamgift
    ConfigureStorage.document = confDic.document    -- 帮助
    ConfigureStorage.customerservice = confDic.customerservice -- 客服信息
    ConfigureStorage.Share = confDic.weibo
    ConfigureStorage.rebate = confDic.rebate
    ConfigureStorage.energyAddWithGold = confDic.energyAddWithGold
    ConfigureStorage.firstCashAward1 = confDic.firstCashAward1 -- 首充翻倍配置
    ConfigureStorage.firstCashAward2 = confDic.firstCashAward2 -- 首充送礼配置
    ConfigureStorage.levelOpen = confDic.levelopen      -- 船长等级开放功能配置 
    ConfigureStorage.pushConfig = confDic.pushConfig    -- 本地推送
    ConfigureStorage.sing = confDic.sing    -- 本地推送
    ConfigureStorage.loading = confDic.loading
    ConfigureStorage.playerlevelMax = confDic.playerlevelMax -- 船长最大等级
    ConfigureStorage.shareAward = confDic.shareAward        -- 分享获得奖励的配置

    ConfigureStorage.bossAttr = confDic.bossattr -- 恶魔谷boss数据
    ConfigureStorage.bossPayAndBuff = confDic.bossPayAndBuff
    ConfigureStorage.invitationAward = confDic.invitationAward --邀请码礼包数据

    ------------------------  联盟信息 begin --------------------------------------
    ConfigureStorage.leagueDefaultNotice = confDic.leagueDefaultNotice  -- 联盟默认公告
    ConfigureStorage.leagueLevelMax = confDic.leagueLevelMax    -- 联盟最高等级
    ConfigureStorage.leagueContributionPay = confDic.leagueContributionPay  -- 联盟点睛
    ConfigureStorage.leagueFingerGuessing = confDic.leagueFingerGuessing    -- 猜拳
    ConfigureStorage.leagueMessage = confDic.leagueMessage  -- 联盟消息
    ConfigureStorage.leaguelevel = confDic.leaguelevel  -- 联盟等级经验
    ConfigureStorage.leagueFingerGuessAward = confDic.leagueFingerGuessAward    -- 猜拳奖励
    ConfigureStorage.leagueDuty = confDic.leagueDuty    -- 联盟职位
    ConfigureStorage.leaguePermission = confDic.leaguePermission    -- 联盟权限
    ConfigureStorage.leagueFuncOpen = confDic.leagueFuncOpen    -- 联盟活动开启配置
    ConfigureStorage.leagueDescription = confDic.leagueDescription  -- 联盟内文案描述
    ConfigureStorage.createLeaguePay = confDic.createLeaguePay  -- 创建联盟所需金币
    ConfigureStorage.leagueDonate = confDic.leagueDonate            -- 联盟捐献限制
    ConfigureStorage.leagueLvup  = confDic.leagueLvup               -- 联盟升级
    ConfigureStorage.leagueFort = confDic.leagueFort
    ConfigureStorage.leagueSiege = confDic.leagueSiege
    ConfigureStorage.leagueDonate = confDic.leagueDonate
    ConfigureStorage.leagueShopLevel = confDic.leagueShopLevel
    ConfigureStorage.leagueDepot = confDic.leagueDepot
    ConfigureStorage.leagueShop = confDic.leagueShop
    ConfigureStorage.leagueShoplv = confDic.leagueShoplv
    ------------------------  联盟信息  end  --------------------------------------

    ConfigureStorage.vipIsOpen = confDic.vipIsOpen              -- 是否屏蔽vip相关显示
    ConfigureStorage.Gspot = confDic.Gspot                      -- 海军支部小关信息 
    ConfigureStorage.nsnpcgroup = confDic.nsnpcgroup              -- 海军支部boss信息 

    -- 寻宝
    ConfigureStorage.qjType = confDic.type 
    ConfigureStorage.qjDegree = confDic.degree

    ConfigureStorage.nsbossfree = confDic.nsbossfree               -- 海军支部boss攻打条件限制

    ConfigureStorage.battleDouble = confDic.battleDouble    -- 战斗双倍经验


    ConfigureStorage.shadowData = confDic.shadowData                -- 练影的配置信息
    ConfigureStorage.shadowLevelMax = confDic.shadowLevelMax
    ConfigureStorage.shadowUpdate = confDic.shadowUpdate
    ConfigureStorage.shadowRand = confDic.shadowRand
    ConfigureStorage.genuineQisMax = confDic.genuineQisMax          -- 能装上的影子数量

    ConfigureStorage.nowindUpdate = confDic.nowindUpdate            -- 无风带升级的数据
    ConfigureStorage.heronowind = confDic.heronowind                -- 每一个英雄对应无风带的属性提升值
    ConfigureStorage.nowindtime = confDic.nowindtime                -- 无风带关于时间的配置
    ConfigureStorage.noWindItemId = confDic.noWindItemId            -- 闭关需要消耗的物品
    ConfigureStorage.noWindReduceItemId = confDic.noWindReduceItemId 
    ConfigureStorage.monthCardShop = confDic.monthCardShop          -- 月卡
    ConfigureStorage.monthCardIsOpen = confDic.monthCardIsOpen
    if ConfigureStorage.monthCardShop then
        if ConfigureStorage.monthCardIsOpen == nil or ConfigureStorage.monthCardIsOpen == true then
            dailyData.daily.yueka = {sort = 0}
        end
    end
    ConfigureStorage.leagueBattleRecordPointer = confDic.leagueBattleRecordPointer
    ConfigureStorage.leagueCandyShopItem = confDic.leagueCandyShopItem
    ConfigureStorage.leagueLvup = confDic.leagueLvup
    ConfigureStorage.leagueSiege = confDic.leagueSiege
    ConfigureStorage.leagueFort = confDic.leagueFort

    ConfigureStorage.fightHelp = confDic.fightHelp -- 盟战进攻帮助文档
    ConfigureStorage.guardHelp = confDic.guardHelp -- 盟战防御帮助文档
    ConfigureStorage.enemyHelp = confDic.enemyHelp -- 盟战宿敌帮助文档
    ConfigureStorage.buildingHelp = confDic.buildingHelp -- 联盟建设帮助文档
    ConfigureStorage.shard = confDic.shard -- 碎片配置
    ConfigureStorage.skill_max_level = confDic.skill_max_level      -- 技能突破最大值
    ConfigureStorage.leagueBattleAllotSweetTimeInterval = confDic.leagueBattleAllotSweetTimeInterval

    ConfigureStorage.bagDelay = confDic.bagDelay -- 延时礼包

    --------国战----------
    ConfigureStorage.WWDefault = confDic.countryBattle_default_playerData -- 默认数据配置
    ConfigureStorage.WWIsland = confDic.countryWar_Island   -- 岛屿配置
    ConfigureStorage.WWCDTime = confDic.countryBattleCDTime -- cd配置
    ConfigureStorage.WWDurable = confDic.countryWar_Durable -- 耐久升级配置
    ConfigureStorage.WWDurableRecover = confDic.countryWar_supplement -- 耐久恢复配置
    ConfigureStorage.WWScience = confDic.countryWar_science -- 实验室配置
    ConfigureStorage.WWScienceId = confDic.countryWar_scienceReset -- 实验室道具配置
    ConfigureStorage.WWScienceOpen = confDic.countryWar_Laboratory -- 实验室开启额外配置
    ConfigureStorage.WWItemUse = confDic.countryWar_itemUsed -- 道具使用
    ConfigureStorage.WWJob = confDic.countryWar_post -- 官职配置
    ConfigureStorage.WWBrave = confDic.countryWar_Courage -- 勇气购买配置
    ConfigureStorage.WWShopCfg = confDic.countryWar_shopcfg -- 商店配置
    ConfigureStorage.WWShop = confDic.countryWar_shop -- 商店道具配置
    ConfigureStorage.WWHelp1 = confDic.countryWar_help1 -- 海战帮助
    ConfigureStorage.WWHelp2 = confDic.countryWar_help2 -- 寻宝帮助
    ConfigureStorage.WWHelp3 = confDic.countryWar_help3 -- 官职帮助
    ConfigureStorage.WWHelp4 = confDic.countryWar_help4 -- 阵营更换帮助
    ConfigureStorage.WWGroupDesp = confDic.countryWar_Description -- 阵营描述
    ConfigureStorage.WWExplore = confDic.countryWar_treasure -- 寻宝价格
    ConfigureStorage.WWReward = confDic.countryWar_Reward -- 阵营强弱奖励
    ConfigureStorage.WWHelp5 = confDic.countryWar_help5
    ConfigureStorage.WWTotalTask = confDic.countryWar_TotalTask -- 总战绩配置

    ConfigureStorage.TrainShadowHelp = confDic.shadowNotice  --炼影其他炼页面规则

    -- 迷雾之海
    ConfigureStorage.SeaMiStage = confDic.seaMist_stage 
    ConfigureStorage.SeaMiBossGroup = confDic.seaMist_bossgroup
    ConfigureStorage.SeaMiNpcAttr = confDic.seaMist_npcattr
    ConfigureStorage.SeaMiLoot = confDic.seaMist_loot
    ConfigureStorage.SeaMiRoute = confDic.seaMist_route
    ConfigureStorage.SeaMiEyes = confDic.seaMist_eyes
    ConfigureStorage.SeaMiChunge = confDic.seaMist_chunge

    ----------任务----------
    ConfigureStorage.mission_once = confDic.mission_once -- 主线
    ConfigureStorage.mission_daily = confDic.mission_daily -- 日常
    ----------任务----------
    --押镖系统
    ConfigureStorage.countryWar_Durable = confDic.countryWar_Durable --奖励加成
    ConfigureStorage.delivery_robDesp = confDic.delivery_robDesp --劫镖描述

    --至尊私人客服窗口 
    ConfigureStorage.vipdesp2 = confDic.vipdesp2


    --跨服战
    ConfigureStorage.crossDual_sundry = confDic.crossDual_sundry -- buf 杂项 
    ConfigureStorage.crossDual_score = confDic.crossDual_score -- 称号 5个称号状态
    ConfigureStorage.crossDual_refresh1 = confDic.crossDual_refresh1 -- 积分赛 每日对手刷新价格
    ConfigureStorage.crossDual_refresh2 = confDic.crossDual_refresh2 -- 积分晋级赛 每日对手刷新价格
    ConfigureStorage.crossDual_refresh3 = confDic.crossDual_refresh3 -- 32超新星抢资格阶段 每日对手刷新价格
    ConfigureStorage.crossDual_buyFight = confDic.crossDual_buyFight -- 积分赛每日挑战次数购买价格
    ConfigureStorage.crossDual_worship = confDic.crossDual_worship -- 膜拜配置
    ConfigureStorage.crossDual_help = confDic.crossDual_help -- 详情配置
    ConfigureStorage.crossDual_BGdesp = confDic.crossDual_BGdesp -- 奖励描述配置
    ConfigureStorage.crossDual_32score = confDic.crossDual_32score -- 32强积分配置
    -- 每日签到配置
    ConfigureStorage.HZ_SignIn_reward_1 = confDic.HZ_SignIn_reward_1
    ConfigureStorage.HZ_SignIn_reward_2 = confDic.HZ_SignIn_reward_2
    ConfigureStorage.HZ_SignIn_reward_3 = confDic.HZ_SignIn_reward_3
    ConfigureStorage.HZ_SignIn_reward_4 = confDic.HZ_SignIn_reward_4
    ConfigureStorage.HZ_SignIn_reward_5 = confDic.HZ_SignIn_reward_5
    ConfigureStorage.HZ_SignIn_reward_6 = confDic.HZ_SignIn_reward_6
    ConfigureStorage.HZ_SignIn_reward_7 = confDic.HZ_SignIn_reward_7
    ConfigureStorage.HZ_SignIn_reward_8 = confDic.HZ_SignIn_reward_8
    ConfigureStorage.HZ_SignIn_reward_9 = confDic.HZ_SignIn_reward_9
    ConfigureStorage.HZ_SignIn_reward_10 = confDic.HZ_SignIn_reward_10
    ConfigureStorage.HZ_SignIn_reward_11 = confDic.HZ_SignIn_reward_11
     ConfigureStorage.HZ_SignIn_reward_12 = confDic.HZ_SignIn_reward_12
    
    ConfigureStorage.HZ_SignIn_Price = confDic.HZ_SignIn_Price

    -- 海运 详情
    ConfigureStorage.delivery_help = confDic.delivery_help -- 详情配置

    -- 排行榜
    ConfigureStorage.RankingWords = confDic.RankingWords -- 活动规则说明

    -- 联盟跨服战配置  
    ConfigureStorage.leagueBoss = confDic.CSRB_leagueBoss -- 不同阶段下的分组
    ConfigureStorage.lbnpcgroup = confDic.CSRB_lbnpcgroup -- 水手、精英阶段下的npc配置
    ConfigureStorage.lbnpc = confDic.CSRB_npc -- 通过npc Id 获得该npc的数据
    ConfigureStorage.CSRB_personaloot = confDic.CSRB_personaloot -- 个人奖励的配置
    ConfigureStorage.CSRB_leagueloot = confDic.CSRB_leagueloot -- 联盟奖励的配置
    ConfigureStorage.CSRB_leaguemessage = confDic.CSRB_leaguemessage -- 详情配置  

    --饮酒 
    ConfigureStorage.Drink_tabodds    = confDic.Drink_tabodds --玩家换酒的几率，key数字的代表为1代表酒A换B，2代表酒B换C，3代表酒C换D，4代表酒D换E，odds为换酒的成长系数，point为增加的潜能点数,,,,,,,
    ConfigureStorage.Drink_buycap     = confDic.Drink_buycap -- 玩家使用瓶盖可购买物品及消耗,ID,可购买物品,消耗瓶盖数量
    ConfigureStorage.Drink_freetimes  = confDic.Drink_freetimes --玩家每日拥有的免费饮酒次数
    ConfigureStorage.Drink_changeWineCost = confDic.Drink_changeWineCost --玩家每次点击换酒的花费 第几次,消费（金币）  
    ConfigureStorage.Drink_othercosts = confDic.Drink_othercosts -- tea：喝醒酒茶的消耗；top：一键换酒的消耗 
    ConfigureStorage.Drink_gainCap    = confDic.Drink_gainCap --玩家每次使用物品反馈的瓶盖数量，tabdrink为普通换酒，tabtop为一键好酒，usetea为使用醒酒茶  
    ConfigureStorage.Drink_rank       = confDic.Drink_rank --各品质角色的潜力值上限的初始值与成长  ,品质,基础,成长系数,计算方式为基础+当前等级*系数（最终结果向上取整）   
    ConfigureStorage.Drink_adout      = confDic.Drink_adout --饮酒说明
    ConfigureStorage.vip_perday = confDic.vip_perday -- vip 每日礼包配置 
    ConfigureStorage.equip_message = confDic.equip_message --弗兰奇之家(装备合成分解)的说明 
    ConfigureStorage.equip_made    = confDic.equip_made --装备铸造装备所需材料表
    ConfigureStorage.equip_compoundItems    = confDic.equip_compoundItems --装备铸造所需材料对应的item 
    ConfigureStorage.equipDecomposeOpen    = confDic.equipDecomposeOpen --装备分解开关
    ConfigureStorage.equipCompoundOpen    = confDic.equipCompoundOpen --装备铸造所开关
    ConfigureStorage.equipNewComposeOpen  = confDic.equipNewComposeOpen --装备合成开关
    if ConfigureStorage.equipDecomposeOpen or ConfigureStorage.equipCompoundOpen then
       dailyData.daily.compose = {sort = 3} --弗兰奇之家 装备分解铸造
       if ConfigureStorage.equipCompoundOpen  then
           dailyData.daily.compose.compoundEquip = userdata.compoundEquip
       end
    end

    -- 霸气
    ConfigureStorage.aggress_lv = confDic.aggress_lv
    ConfigureStorage.aggress_bloodunfree = confDic.aggress_bloodunfree
    ConfigureStorage.aggress_data = confDic.aggress_data
    ConfigureStorage.aggress_npclist = confDic.aggress_npclist
    ConfigureStorage.aggress_roundtalk = confDic.aggress_roundtalk
    ConfigureStorage.aggress_skill = confDic.aggress_skill
    ConfigureStorage.aggress_roundattr = confDic.aggress_roundattr
    ConfigureStorage.aggress_desp1 = confDic.aggress_desp1
    ConfigureStorage.aggress_inheritance = confDic.aggress_inheritance

    -- 精英关卡
    ConfigureStorage.elitePage = confDic.elitepageConfig
    ConfigureStorage.eliteStageType = confDic.elitestageTypeConfig
    ConfigureStorage.eliteStage = confDic.elitestageConfig
    ConfigureStorage.eliteStageNPC = confDic.elitestage_npc
    ConfigureStorage.eliteNPC = confDic.Elitenpc_list

    --觉醒
    ConfigureStorage.bluemission = confDic.awave_bluemission       --蓝卡升级紫卡觉醒配置
    ConfigureStorage.awave_goldmission = confDic.awave_goldmission --紫卡升级金卡配置
    ConfigureStorage.animation5 = confDic.animation5               --觉醒后的人物配置
    ConfigureStorage.awave_Onornot = confDic.awave_Onornot         --所有可觉醒的伙伴
    ConfigureStorage.awave_help1 = confDic.awave_help1             --觉醒页面详情
    ConfigureStorage.awave_help2 = confDic.awave_help2
    ConfigureStorage.awave_show = confDic.awave_show               --本次更新能觉醒伙伴
    ConfigureStorage.awave_heropen = confDic.awave_heropen         --伙伴觉醒需要的等级

    -- 装备合成
    ConfigureStorage.equip_blue_awave = confDic.equip_blue_awave
    ConfigureStorage.equip_pur_awave = confDic.equip_pur_awave
    ConfigureStorage.equip_gold_awave = confDic.equip_gold_awave
    ConfigureStorage.equip_machine = confDic.equip_machine
    ConfigureStorage.equip_exp = confDic.equip_exp
    ConfigureStorage.equip_help = confDic.equip_help

    -- 摇摇乐
    ConfigureStorage.Slot = confDic.Slot
    ConfigureStorage.Picture_Contrast = confDic.Picture_Contrast
    ConfigureStorage.Slot_help = confDic.Slot_help
    --vip商店
    ConfigureStorage.vip_shop = confDic.vip_shop   
   
end
