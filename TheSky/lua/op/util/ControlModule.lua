-- ControlModule

-- 动作管理
ActionTable = nil
ActionTable = {
    -- sso action
    SSO_LOGIN_URL = "?action=sLogin",           
    SSO_GENERATEUID_URL = "?action=sGenerateUid",
    SSO_TOURIST_LOGIN_URL = "?action=sgLogin",         -- 游客方式第一次登陆
    SSO_BINDING_ACCOUNT_URL = "?action=sBindingAccount",    -- 绑定账号
    SSO_REGISTER_ACCOUNT_URL = "?action=sRegisterAccount",       -- 注册新账号
    SSO_MODIFY_PWD_URL = "?action=sUpdatePassword",     -- 修改密码
    SSO_GETSERVERLISTBYVERSION_URL = "?action=getServerListByVersion",   -- 从sso服务器取最新的服务器列表
    -- SSO_REGISTER_URL = "?action=sRegister",
    -- SSO_REGISTER_V2_URL = "?action=sRegister_V2",
    -- sso action end

    -- game server action
    LOGIN_URL = "?action=login",
    TEST_LOGIN_URL = "?action=testlogin",
    REGISTER_URL = "?action=register",
    ADDAPPLEORDER_URL = "?action=addAppleOrder",
    GET_SERVERLISTBYVERSION_URL = "/?action=getServerListByVersion",
    GET_SERVERLIST_URL = "/?action=getServerList",
    SERVERTIME_URL = "?action=getServerTime",
    CONFIGURE_URL = "?action=getSetting",
    GETVIEWER_URL = "?action=getViewer",

    GET_LASTEST_VERSION_V2 = "?action=public_getVersionInfo",
    SSO_GETSERVERLISTBYVERSION_URL_V2 = "?action=public_getServerList",
    SSO_LOGIN_URL_V2 = "?action=sLoginNew",

    PICKNAME_URL = "?action=pickName",

    GET_LASTEST_VERSION = "?action=getLatestAppVersion",

    -- 热气球
    GET_SHAKE_DATA_URL = "?action=getShakeData",
    ADD_SHAKE_AWARD_URL = "?action=addShakeAward",

    --招募
    RECRUITHERO_URL = "?action=recruitHero",            -- 商城招募英雄

    --购买
    BUYITEM_URL = "?action=buyItem",
    BUY_VIPBAG_URL = "?action=buyVipItem",
    BUY_TIMEGIFT_URL = "?action=buyTimesItem",
    VIP_BUY_URL = "?action=VipShop_getVipShopData",
    VIP_SHOPBUY_URL = "?action=VipShop_buyVipShop",
    -- 起航战斗
    STORYBATTLE_URL = "?action=storyBattle",
    ADD_STORY_PAGE_AWARD = "?action=addStoryPageAward", -- 吃鸡
    CLEAR_STORY_STAGE_LIMIT = "?action=clearStoryStageLimit", -- 清除战斗次数
    CLEAR_STORY_BATCH_CDTIME = "?action=clearStoryBatchCdTime", -- 清除连闯cd
    STORY_BATTLE_NEW = "?action=storyBattleNew", -- 快速扫荡n次 

    -- 精英副本
    ELITE_BATTLE = "?action=Elite_battleElite",
    ELITE_SWEEP = "?action=Elite_battleEliteSweep",
    ELITE_RESET = "?action=Elite_resetChallengeTime",

    --伙伴页面
    CULTIVATE_URL = "?action=cultivate",                -- 培养
    CONFIRM_CULTIVATE_URL = "?action=confirmCultivate", -- 培养确认或取消
    RECRUITSOUL_URL = "?action=recruitSoul",             -- 用魂魄招募英雄
    BREAKHERO_URL = "?action=breakHero",             -- 用魂魄招募英雄
    TRANSFER_URL = "?action=transfer",                  -- 伙伴送别

    --包裹
    ITEM_USE_URL = "?action=useItem",

    --装备
    UPDATE_EQUIP_URL = "?action=updateEquip",
    REFINE_EQUIP_URL = "?action=refineEquip",
    SELL_EQUIP_URL = "?action=sellEquip",
    

    --好友
    GET_FRIENDLIST_URL = "?action=getFriendList",
    GET_ENEMYLIST_URL = "?action=getEnemyList",
    GET_FOLLOWLIST_URL = "?action=getFollowList",

    -- 阵容
    ON_FORM = "?action=onForm",
    CHANGE_FORM = "?action=changeForm",
    ON_FORM_SEVEN = "?action=onFormSeven",
    OPEN_FORM_SEVEN = "?action=openFormSeven",

    --战舰
    UPDATE_SHIP_URL = "?action=updateAttr",

    RENAME_WITH_ITEM_URL = "?action=renameWithItem",

    --技能突破

    SKILL_BREAK_URL = "?action=trainSkill",

    -- 日常-吃饭
    DAILY_EAT_URL = "?action=eatDumpling",
    -- 日常-亲吻人鱼公主
    DAILY_WORSHIP_URL = "?action=worship",
    -- 日常-罗宾的花牌
    DAILY_ROBIN = "?action=robin",
    -- 日常-获取邀请码奖励
    DAILY_INVITE_REWARD = "?action=inviteFriends",
    -- 日常-接受邀请
    DAILY_GET_INVITE_REWARD = "?action=getInvitedAward",
    -- 获得神秘商店数据
    DAILY_GET_SECRETSHOP = "?action=secretShopGet", 
    -- 刷新神秘商店数据
    DAILY_FLUSH_SECRETSHOP = "?action=secretShopFlush", 
    -- 购买神秘商店物品
    DAILY_BUY_SECRETSHOP = "?action=secretShopBuy", 

    -- 血战
    GET_BLOOD_INFO = "?action=getBloodInfo",
    BEGIN_BLOOD = "?action=beginBlood",
    BLOOD_BATTLE = "?action=bloodBattle",
    NEWWORLD_ADD_BUFF = "?action=addBuff",
    NEWWORLD_ADD_AWARD = "?action=addAward",
    NEWWORLD_ADD_FIRSTBUFF = "?action=addFirstBuff",
    NEWWORLD_RANKINFO = "?action=getBloodRankInfo",

    --更换奥义
    SKILL_CHANGE_URL = "?action=changeSkill",
    --更换装备
    EQUIP_CHANGE_URL = "?action=changeEquip",

    -- 残章
    GET_CHAPTER_ENEMIES = "?action=getFragEnemies",
    CHAPTER_BATTLE = "?action=fragBattle",
    COMBINE_CHAPTER = "?action=combineFrags",
    GET_BOOK_CHAPTER = "?action=getBookFrags",

    -- 聊天
    GET_PUBLIC_MESSAGE = "?action=getPublicMessage",
    SEND_MESSAGE_URL = "?action=sendPublicMessage",
    GET_LEAGUE_MESSAGE = "?action=getLeagueChatMessage",
    SEND_LEAGUE_MESSAGE_URL = "?action=sendLeagueChatMessage",
    GET_CAMP_MESSAGE_URL = "?action=countryBattleGetChatMessage",
    SEND_CAMP_MESSAGE_URL = "?action=countryBattleSendChatMessage",
    GET_MAIL_DATA = "?action=getMailList",

    -- 决斗
    ARENA_GET_RANK_INFO = "?action=getArenaRankInfo",
    ARENA_GET_BATTLE_INFO = "?action=getArenaBattleInfo",
    ARENA_BATTLE = "?action=arenaBattle",
    ARENA_GET_SCORE = "?action=getArenaScore",
    ARENA_GET_RECORDS = "?action=getArenaRecords",
    ARENA_EXCHANGE = "?action=exchangeArenaAward",
    ARENA_GET_AWARD = "?action=getArenaAward",

    --  接受好友请求
    ACCEPT_FRIEND_INVITAION = "?action=acceptFriend",
    REFUSE_FRIEND_INVITAION = "?action=refuseInvite",

    --  留言
    LEAVEAR_MESSAGE = "?action=sendMessage",

    -- 加好友
    SEARCH_BY_NAME = "?action=searchPlayerByName",
    SEARCH_PLAYER = "?action=searchPlayer",
    SEARCH_BY_LEVEL = "?action=searchPlayerByLevel",

    -- 邀请好友
    INVITE_FRIEND_URL = "?action=inviteFriend",

    -- 删除好友
    DELETE_FRIEND_URL = "?action=deleteFriend",
    --关注
    FOLLOW_FRIEND_URL = "?action=follow",
    CANCEL_FOLLOW_FRIEND_URL = "?action=unfollow",

    -- 获取顶部滚动消息
    GET_PUBLIC_SHARELIST = "?action=getPublicShareList",

    -- 获取连续登陆奖励
    ADD_SUCCESSION_AWARD_URL = "?action=addSuccessionAward",
    
    -- 点拨
    INSTRUCT_HERO = "?action=instructHero",

    -- 黄金钟
    CLICK_BELL_URL = "?action=goldenBell",

    GET_MAIL_REWARD_URL = "?action=getMailAward",
    
    -- 设置新手引导步骤
    SET_GUIDE_STEP = "?action=setGuideStep",

    -- 领取升级奖励
    UPDATE_LEVEL_AWARD = "?action=getUpgrade",

    -- 幸运卡牌
    GET_TREASURE_INFO = "?action=getTreasureInfo",
    EXPLORE_TREASURE = "?action=exploreTreasure", -- 探
    MULTI_EXPLORE_TREASURE = "?action=mxExploreTreasure", -- 探
    GET_TREASURE_GETS = "?action=getTreasureGets",

    -- 布鲁克的吟唱
    MAKE_WISH_URL = "?action=makeWish",

    -- 梦想海贼团
    GET_FANTASY_TEAM_REWARD = "?action=getFantasyTeamAward",

    RECOVER_STRENGTH = "?action=addStrengthWithGold",
    RECOVER_ENERGY = "?action=addEnergyWithGold",

    -- 充值返利
    GOLD_REFUND = "?action=goldRefund",

    -- 分享接口
    SHARE_BYCHANNEL_URL = "?action=shareByChannel",
    SHARE_SETSHAREBINDINGSTATUS_URL = "?action=setShareBindingStatus",
    FEEDBACK = "?action=saveInfoOfPlayer",

    -- 充值翻倍
    RECHARGE_DOUBLE_GET1 = "?action=gainFirstCashAward1",
    RECHARGE_DOUBLE_GET2 = "?action=gainFirstCashAward2",

    GET_INIT_BELL_INFO = "?action=getGoldBellInfo",

    BUY_AND_USE = "?action=buyItemAndUse",

    CDKEY = "?action=receiveCDKey",

    GET_KYSHOP_ORDER_KEY = "?action=gemKYPayOrder",
    GET_ITOOLS_ORDER_KEY = "?action=gemiToolsPayOrder",
    GET_TBTSHOP_ORDER_KEY = "?action=getmTBTPayOrder",
    GET_HAIMASHOP_ORDER_KEY = "?action=gemHaimaPayOrder",
    GET_91SHOP_ORDER_KEY = "?action=gem91PayOrder",
    GET_360_ORDER_KEY = "?action=gem360PayOrder",
    GET_WDJ_ORDER_KEY = "?action=gemWdjPayOrder",
    GET_XIAOMISHOP_ORDER_KEY = "?action=gemXmPayOrder",
    GET_OPPO_ORDER_KEY = "?action=gemOppoPayOrder",
    GET_MM_ORDER_KEY = "?action=gemMmPayOrder",
    GET_MMY_ORDER_KEY = "?action=gemMumayiPayOrder",
    GET_AISI_ORDER_KEY = "?action=gemAisiPayOrder",
    GET_ANFENG_ORDER_KEY = "?action=gemAnfengPayOrder",
    GET_UC_ORDER_KEY = "?action=gemUcPayOrder",
    GET_PPSHOP_ORDER_KEY = "?action=gemPPPayOrder",
    FLUSH_PLAYER_DATA = "?action=flushPlayerData",
    GET_IAPPPAY_ORDER_KEY = "?action=gemIappPayOrder",
    GET_ALIPAY_ORDER_KEY = "?action=getIappAliPayOrder",
    GET_DJPAY_ORDER_KEY = "?action=gemDownjoyPayOrder",
    GET_AGAME_ORDER_KEY = "?action=gemAgamePayOrder",
    GET_COOLPAY_ORDER_KEY = "?action=gemKupaiPayOrder",
    GET_GIONEE_ORDER_KEY = "?action=gemJinliPayOrder",
    GET_HUAWEI_ORDER_KEY = "?action=gemHuaweiPayOrder",

    -- boss战
    GET_BOSS_INFO = "?action=getBossInfo",
    BOSS_BATTLE = "?action=bossBattle",
    GET_BOSS_LOG = "?action=getBossLogAndRank",


    -- 联盟
    LEAGUE_DELETE = "?action=deleteLeague",     -- 解散
    GET_UNION_MAIN_INFO = "?action=querySelfLeagueMainInfo",
    LEAGUE_CHANGEPOS = "?action=promotionOrDemotion",  -- 升降职
    LEAGUE_FIRED = "?action=kickOutOfLeague",       -- 开除
    LEAGUE_QUIT = "?action=quitLeague",         -- 退出
    LEAGUE_DONATE = "?action=contributionForLeague",   -- 捐献
    LEAGUE_DONATE_INFO = "?action=queryContributionInfo", -- 查询捐献
    UNION_CHANGE_NOTICE = "?action=updateLeagueNotice",   -- 修改公告
    UNION_AGREE_OR_DENY_URL = "?action=agreeOrDenyAskForJoin",
    QUERY_UNION_APPLICANTS_URL = "?action=queryAskForJoinInfo",
    QUERY_UNION_MAIN_INFO = "?action=queryLeaguesMainInfo",
    GET_UNION_DETAIL_INFO = "?action=queryLeagueInfoById",
    LEAGUE_CREATE = "?action=createLeague",
    LEAGUE_JOIN = "?action=askForJoinLeague",
    QUERY_UNION_GUESSING_URL = "?action=queryLeagueFingerGuessingInfo",
    UNION_GUESSING_URL = "?action=leagueFingerGuessing",
    LEAGUE_ATTACK_INFO = "?action=leagueBattleFlushAttackInfo", -- 刷新联盟战争战斗列表
    LEAGUE_BATTLE_QUERY = "?action=leagueBattleQueryWaitLeagues", -- 获取可以宣战的列表
    LEAGUE_BATTLE_DECLARE = "?action=leagueBattleDeclare", -- 联盟宣战
    LEAGUE_BATTLE_BATTLE_INFO = "?action=leagueBattleFlushBattleInfo", -- 刷新盟战攻击数据
    LEAGUE_DEFEND_INFO = "?action=leagueBattleFlushDefendInfo", -- 刷新联盟战争防御列表
    LEAGUE_DEPLOY_FORT = "?action=leagueBattleDeployFort", -- 部属工事
    LEAGUE_BATTLE_FIGHTING = "?action=leagueBattleFighting", -- 盟战发起进攻
    LEAGUE_BATTLE_ENEMY_INFO = "?action=leagueBattleFlushEnemyInfo", -- 刷新宿敌接口
    LEAGUE_BATTLE_REPAIRFORT = "?action=leagueBattleRepairFort", -- 盟战修复防御工事
    LEAGUE_BATTLE_GET_BATTLEINFO = "?action=leagueBattleGetFortBattleInfo", -- 盟战获取战斗数据

    ADD_MOBGAME_ORDER = "?action=addMobgameOrder",
    ADD_GOOGLEPLAY_ORDER = "?action=addGooglePlayOrder",
    
    ADD_MOBGAME_WP_ORDER = "?action=addMobgameOrderWP",

    -- 觉醒
    AWAKEN_MAIN = "?action=Awaken_getAwakenMain",
    AWAKEN_BEGIN = "?action=Awaken_beginWake",
    AWAKEN_FINISH = "?action=Awaken_finishTask",
    AWAKEN_GIVEUP = "?action=Awaken_giveUpWake",
    AWAKEN_READDIALOGUE = "?action=Awaken_readDialogue",

    -- 海军支部
    RETRIEVE_HUNTINFO = "?action=retrieveHuntInfo",
    MARINE_FIGHT_BOSS = "?action=fightForTreasure",
    MARINE_MOBS_REWARD = "?action=takeGateReward",
    MARINE_MOBS_BATTLE = "?action=fightForTreasure",

    QINGJIAO_SEEK = "?action=claimTreasure",
    QINGJIAO_TENSEEK = "?action=claimMultiTimes",

    -- 练影
    SHADOW_TRAIN_URL = "?action=shadowExercise",
    SHADOW_BUY_URL = "?action=shadowBuy",
    SHADOW_UPDATE_URL = "?action=shadowUpdate",
    SHADOW_CHANGE_STATUS = "?action=shadowChangeStatus",
    SHADOW_CHANGE = "?action=changeShadow",
    QINGJIAO_TENSEEK = "?action=claimMultiTimes",
    SHADOWEXERCISEWITHSTATUS_URL = "?action=shadowExerciseWithStatus",  -- 不同状态炼影

    -- 无风带相关
    CALME_BELT_EXERCISE = "?action=noWindExercise",
    CALME_BELT_REDUCETIME = "?action=noWindReduceTime",
    CALME_BELT_EXERCISEFINISHED = "?action=noWindExerciseFinished",

    -- 月卡领奖励
    GET_YUEKA_REWARD = "?action=gainMonthCardAward",

    -- 登录活动
    LOGINACTIVITY_CONLOGINONE = "?action=conLoginOne",    --限制领奖次数的登陆奖励
    LOGINACTIVITY_CONLOGIN = "?action=conLogin",          -- 连续登陆(不限制领奖次数的登陆奖励)
    LOGINACTIVITY_NOTCONLOGIN = "?action=notConLogin",    -- 非连续登陆奖励
    LOGINACTIVITY_ADDCONLOGIN = "?action=addConLogin",    -- 累计登陆奖励


    GET_UNION_SHOPDATA = "?action=leagueBattleFlushShop",

    --- 联盟捐献
    UNION_CONTRIBUTE_ACTIONF = "?action=leagueBattleContribution",


    REFRESH_CONTRIBUTE_INFO = "?action=leagueBattleQueryContributionInfo",
    LEAGUE_UPGRATE_BUILDING = "?action=leagueBattleUpdateBuilding",

    UNION_DISTRIBUTE_CANDY = "?action=leagueBattleAllotSweet",
    UNION_BUY_ACTION = "?action=leagueBattleBuyItem",
    MERGE_SHARD_URL = "?action=mergeEquip",
    EXCHANGE_REWARD = "?action=exchangeReward",

    GET_ACTIVITY_DATA = "?action=getEncounter",

    COST_REFUND = "?action=costRefund", -- 充值返道具接口
    COST_REWARD = "?action=costReward", -- 消费返道具接口
    CONSUME_REFUND = "?action=consumeRefund", -- 消费返金币接口

    GET_VIP_LEVEL_REWARD = "?action=getVipLevelReward", -- vip等级礼包
    SPECIFIC_CHARGE_REWARD = "?action=specificChargeReward", -- 单笔充值送礼

    USE_DELAY_ITEM = "?action=useDelayItem",

    -- 国战接口
    WW_GET_MAINDATA = "?action=countryBattleGetMainData", -- 全局信息
    WW_JOIN_GROUP = "?action=countryBattleJoinCountry", -- 加入阵营
    WW_GET_ISLANDDATA = "?action=countryBattleGetIslandMainData", -- 岛屿详情
    WW_SETTLE = "?action=countryBattleChangeIsland", -- 迁徙
    WW_SCOUT = "?action=countryBattleScoutIsland", --侦察
    WW_GET_PLAYERDATA = "?action=countryBattleGetPlayerDataInIsland", -- 获取岛内dock信息
    WW_BUY_DUR = "?action=countryBattleBuyDurability", -- 恢复耐久
    WW_BUY_DURLEVEL = "?action=countryBattleBuyDurabilityLevel", -- 购买耐久上限
    WW_FLUSH_SINGLESCIENC = "?action=countryBattleFlushSingleScience", -- 实验室单个刷新
    WW_USE_SCIENCE = "?action=countryBattleUseScience", -- 实验室使用
    WW_OPEN_SCIENCE = "?action=countryBattleOpenScienceIndex", -- 开启新格子
    WW_FLUSH_ALLSCIENCE = "?action=countryBattleFlushAllScience", -- 实验室刷新所有
    WW_RESET_ALLSCIENCE = "?action=countryBattleResetAllScience", -- 实验室重置所有
    WW_GET_SCORERANK = "?action=countryBattleGetScoreRank", -- 战绩榜
    WW_GET_SCOREREWARD = "?action=countryBattleGetScoreReward", -- 领取战绩奖励
    WW_GET_LEADERS = "?action=countryBattleGetLeaders", -- 获取官职总览
    WW_GET_REWARDPREVIEW = "?action=countryBattleGetDailyRewardPreview", -- 奖励预览
    WW_EXPLORE = "?action=countryBattleExplore", -- 寻宝
    WW_GET_GROUPRANK = "?action=countryBattleGetYesterdayCountryRank", -- 阵营排行榜
    WW_CHANGE_GROUP = "?action=countryBattleChangeCountry", -- 更换阵营
    WW_GET_MEMBERS_BASE = "?action=countryBattleGetMembersInBase", -- 获取基地的成员
    WW_DISTRIBUTE = "?action=countryBattleDispatch", -- 调兵
    WW_FIGHT = "?action=countryBattleFight", -- 战斗
    WW_DAMAGE = "?action=countryBattleDamage", -- 破坏
    WW_BUY_SHOPITEM = "?action=countryBattleBuyShopItem", -- 购买商品
    WW_GET_CANDIDATE = "?action=countryBattleGetScoreRankForChangeLeaders", -- 获取更换官职数据
    WW_CHANGE_JOB = "?action=countryBattleChangeLeaders", -- 更换官职
    WW_BUY_BRAVE = "?action=countryBattleBuyCourage", -- 购买勇气

    WW_UPDATA_CAMP_ANNOUNCE = "?action=countryBattleUpdateLeagueNotice",

    GET_LUCKYREWARD_INFO = "?action=activityRetrieveLuckyDraw",
    ROLL_LUCKYREWARD = "?action=activityLuckDraw",
    REWARDLIST_LUCKYREWARD = "?action=activityGetLuckDrawLogs",
    GET_LUCKYRANK_REWARD = "?action=activityGetLuckDrawRankReward",
    GET_LUCKYSHOP_INFO = "?action=activityRetrieveLuckyDrawShop",
    BUY_LUCKYSHOP_ITEM = "?action=activityBuyLuckItem",

    SEALMIST_GETDATA = "?action=seaMistGetData",
    SEALMIST_BEGIN = "?action=seaMistBegin",
    SEALMIST_SELECTBOSS = "?action=seaMistSelectBoss",
    SEALMIST_FIGHT = "?action=seaMistFight",
    SEALMIST_GETREWARD = "?action=seaMistGetReward",
    SEALMIST_REBIRTH = "?action=seaMistRebirth",
    SEALMIST_RESET = "?action=seaMistReset",
    SEALMIST_GETRANK = "?action=seaMistGetRank",

    QUIZ_BET = "?action=activityGuessWinLoseDraw",
    QUIZ_REWARD = "?action=activityRewardWinLoseDraw",

    QUEST_REWARD = "?action=missionGetReward",
    ACTIVITY_GIFTFORLEVEL = "?action=activityGiftForLevelGet",
    WW_GET_ALLSCORE_REWARD = "?action=countryBattleGetAllScoreReward",
    ACTIVITY_ARENACOMPETITION = "?action=activityRankForArenaRecord",
    ADD_TGAME_ORDER = "?action=addTgameOrder",
    ADD_BLUEBALLWITHGOLD = "?action=addBlueBallWithGold",
    FORMSEVEN_UPGRADE = "?action=formSevenUpgrade",
    GET_ESCORT_INFO = "?action=escortGetEscortInfo",
    GOING_ESCORT = "?action=escortGoingEscort",
    REFRESH_ESCORTCOST = "?action=escortRefreshEscortCost",
    BEGIN_ESCORT = "?action=escortBeginEscort",
    ACCEPT_ESCORT_AWARD = "?action=escortAcceptEscortAward",
    GOING_ROBBERY = "?action=escortGoingRobbery", --我要劫镖
    GET_ROBBERY_INFO = "?action=escortGetRobberyInfo", -- 劫镖接口 1 准备劫镖战斗
    SAVR_ROBLOG = "?action=escortSaveRobLog", -- 劫镖接口 2 劫镖战斗结果
    PLAYE_BACK_ESCORT = "?action=escortPlaybackEscort", --战斗回放接口
    ACTIVITY_JIGSAWPUZZLE_FLAGMENT = "?action=activityJigsawPuzzleFlagment", -- 普通拼图
    ACTIVITY_JIGSAWPUZZLE_HIGHTFLAGMENT = "?action=activityJigsawPuzzleHighFlagment", -- 高级拼图
    ACTIVITY_JIGSAWPUZZLE_VIPFLAGMENT = "?action=activityJigsawPuzzleVipFlagment", -- vip立即拼图
    ACTIVITY_JIGSAWPUZZLE_REWARD = "?action=activityJigsawPuzzleReward", -- 拼图奖励领取

    CROSSSERVERBATTLE_GETMAININFO = "?action=crossServerBattle_getMainInfo", --  跨服战人口
    CROSSSERVERBATTLE_BEGIN = "?action=crossServerBattle_begin", --  进入接口
    CROSSSERVERBATTLE_FIGHT = "?action=crossServerBattle_fight", --  挑战接口
    CROSSSERVERBATTLE_LOOKBATTLELOG = "?action=crossServerBattle_lookBattleLog", --  战报接口
    CROSSSERVERBATTLE_BUYFIGHTCOUNT = "?action=crossServerBattle_buyFightCount", -- 购买挑战次数接口
    CROSSSERVERBATTLE_BUYFLUSHENEMY = "?action=crossServerBattle_buyFlushEnemy", -- 购买刷新敌人接口
    CROSSSERVERBATTLE_GETBATTLEMAP = "?action=crossServerBattle_getBattleMap", -- 调用对战图接口 用于来回切换
    CROSSSERVERBATTLE_BET = "?action=crossServerBattle_bet", -- 押注接口
    CROSSSERVERBATTLE_GETBETREWARD = "?action=crossServerBattle_getBetReward", -- 获得押注奖励
    CROSSSERVERBATTLE_WORSHIP = "?action=crossServerBattle_worship", -- 膜拜
    CROSSSERVERBATTLE_GETDAILYREWARD = "?action=crossServerBattle_getDailyReward", -- 获得每日奖励
    CROSSSERVERBATTLE_GETRANKREWARD = "?action=crossServerBattle_getRankReward", -- 获得四皇奖励
    CROSSSERVERBATTLE_LOOKRANKINFO = "?action=crossServerBattle_lookRankInfo", -- 排行榜信息查看
    CROSSSERVERBATTLE_GETRANKREWARD50 = "?action=crossServerBattle_getRankReward50", -- 50名奖励

    -- 联盟跨服竞速战 
    CROSSSERVERRACEBATTLE_GETMAININFO = "?action=crossServerRaceBattle_getMainInfo", -- 入口
    CROSSSERVERRACEBATTLE_GETAWARDINFO = "?action=crossServerRaceBattle_getAwardInfo", -- 查看奖励
    CROSSSERVERRACEBATTLE_BEGIN = "?action=crossServerRaceBattle_begin", -- 战斗开始
    CROSSSERVERRACEBATTLE_REFERSHHIGHLOOTLIST = "?action=crossServerRaceBattle_refershHighLootList", -- 刷新获得战斗log
    CROSSSERVERRACEBATTLE_BUYPREBEFORE = "?action=crossServerRaceBattle_buyPreBefore", -- 战前准备接口 用来购买buff
    CROSSSERVERRACEBATTLE_FIGHT = "?action=crossServerRaceBattle_fight", -- 开战
    CROSSSERVERRACEBATTLE_GETMARKRANK = "?action=crossServerRaceBattle_getMarkRank", -- 排名
    CROSSSERVERRACEBATTLE_GETMARKRANKAWARD = "?action=crossServerRaceBattle_getMarkRankAward", -- 奖励

    

    -- 获得每日签到数据
    DAILY_GET_SIGNINRECORD = "?action=getSignInRecord", 
    DAILY_SIGNIN = "?action=signIn", -- 签到
    DAILY_SUPPLSIGNIN = "?action=supplSignIn", -- 补签

    --林绍峰 充值返利
    ACTIVITY_FANLI = "?action=getPrepayRewardInfo", -- fanli 检索活动
    ACTIVITY_GET_FANLI = "?action=activityPrepayReward" ,--领奖

    --排行榜
    RANKINGLIST_TOTALDATA = "?action=rankingList_totalData" , --排行榜

    -- 饮酒 
    ACTIVITYDRINK_CHANGEWINE    =  "?action=activityDrink_changeWine" , 
    ACTIVITYDRINK_CHANGEWINETOP =  "?action=activityDrink_changeWineTop" ,   
    ACTIVITYDRINK_DRINKWINE     =  "?action=activityDrink_drinkWine" ,    
    ACTIVITYDRINK_BUYCAP        =  "?action=activityDrink_buyCap" ,
    
    CROSSSERVERRACEBATTLE_GETVIPDAILYREWARD = "?action=getVipDailyReward", -- vip每日礼包奖励奖励

    --装备分解铸造
    EQUIP_DECOMPOSE          =  "?action=equipDecompose"    , 
    EQUIP_DECOMPOSE_BY_RANK  =  "?action=equipDecomposeByRank"    ,   
    EQUIP_COMPOUND           =  "?action=equipCompound"           ,    

    LEAGUEABDICATE = "?action=leagueAbdicate", -- 转让为会长接口

    --新年烟花活动
    ACTIVITY_GETMAININFO = "?action=activity_getMainInfo",
    ACTIVITY_LITFIREWORKS = "?action=activity_litFireworks",
    ACTIVITY_GETRANKLISTFORCLIENT = "?action=activity_getRankListForClient",
    ACTIVITY_GETRANKREWARDS = "?action=activity_getRankRewards",

    -- 霸气
    UNINHABITED_INFO = "?action=aggress_getMainInfo",
    UNINHABITED_START = "?action=aggress_exercise",
    UNINHABITED_ENHANCE = "?action=aggress_enhance",
    UNINHABITED_END = "?action=aggress_endExercise",
    HAKI_FIGHT = "?action=aggress_preFight",
    HAKI_TRAIN = "?action=aggress_training",

    ORDER_ADD_JAGUARGP = "?action=addJaguarGPOrder",

    -- 摇摇乐
    YAO_YAO_HAPPY = "?action=yaoyaoHappy",

    -- 装备合成 (进阶)
    INITEQUIPUPGRADE = "?action=initEquipUpgrade", -- 获取装备进阶机的接口
    UPMACHINE = "?action=upMachine",               -- 升级进阶机的接口
    INTOEQUIP = "?action=intoEquip",               -- 把一件装备放入进阶机
    STARTADVANCED = "?action=startAdvanced",       -- 开始进阶的接口
    GOBACKADVANCED = "?action=goBackAdvanced",     -- 还原装备的接口
}

ErrorCodeTable = {
    ERR_401 = 401,          -- 用户未登陆
    ERR_402 = 402,          -- 在其他设备登陆
    ERR_800 = 800,          -- 服务器维护中
    ERR_1118 = 1118,        -- 字符串太长
    ERR_1201 = 1201,        -- 账号或密码错误
    ERR_1202 = 1202,        -- sso已经绑定过账号，不是游客账号了
    ERR_1203 = 1203,        -- 账号不合法
    ERR_1204 = 1204,        -- 注册账号长度过长或者过短
    ERR_1205 = 1205,        -- 当前账号已经被注册
    ERR_1206 = 1206,        -- 注册密码长度过长或者过短
    ERR_1207 = 1207,        -- 登录游戏区时，玩家没有初始化
    ERR_1208 = 1208,        -- 账号被封
    ERR_1209 = 1209,        -- 玩家已经注册过了
    ERR_1210 = 1210,        -- sso账号索引对应的ssoId对应的ssouser不存在
    ERR_1211 = 1211,        -- sso账号是游客账号，不能改密码
    ERR_1212 = 1212,        -- sso账号不存在
    ERR_1213 = 1213,        -- sso服务器校验失败（需要踢到登陆sso页面）

    ERR_1116 = 1116,        -- 并发操作问题，提示玩家重试

    ERR_1101 = 1101,        -- 金币不足
    ERR_1102 = 1102,        -- 银币不足
    ERR_1103 = 1103,        -- 体力不足
    ERR_1104 = 1104,        -- 气力不足
    ERR_1106 = 1106,        -- 对方残章不足
    ERR_1107 = 1107,        -- VIP等级不足
    ERR_1401 = 1401,        -- 体力不足
    ERR_1402 = 1402,        -- 气力不足
    ERR_1105 = 1105,        -- 内容为空
    ERR_1106 = 1106,        -- 道具不足
    ERR_1403 = 1403,        -- 玩家昵称太长
    ERR_1404 = 1404,        -- 玩家昵称太短
    ERR_1405 = 1405,        -- 玩家昵称包含非法字符
    ERR_1406 = 1406,        -- 玩家昵称已存在

    -- 伙伴相关
    ERR_1501 = 1501,        -- 不存在该伙伴
    ERR_1502 = 1502,        -- 不存在该技能
    ERR_1504 = 1504,        -- 已经拥有该技能
    ERR_1505 = 1505,        -- 更换位置不对
    ERR_1506 = 1506,        -- 没有该影子
    ERR_1507 = 1507,        -- 送别伙伴等级必须大于1
    ERR_1508 = 1508,        -- 传功伙伴等级不能大于玩家等级的3倍
    ERR_1509 = 1509,        -- 送别伙伴不能在阵容中
    ERR_1510 = 1510,        -- 生命牌不足
    ERR_1511 = 1511,        -- 已经拥有该装备
    ERR_1512 = 1512,        -- 暂时不用
    ERR_1513 = 1513,        -- 已经拥有该弟子
    ERR_1514 = 1514,        -- 魂魄数量不足
    ERR_1517 = 1517,        -- 魂魄数量不足
    ERR_1515 = 1515,        -- 不存在该魂魄对应的伙伴
    ERR_1516 = 1516,        -- 超过突破级数
    ERR_1518 = 1518,        -- 伙伴等级不够
    ERR_1519 = 1519,        -- 伙伴已经达到无风带最高级
    ERR_1520 = 1520,        -- 冲脉：英雄还没有开脉
    ERR_1521 = 1521,        -- 冲脉：已达到冲脉极限
    ERR_1522 = 1522,        -- 无法出关
    ERR_1523 = 1523,        -- 无法闭关

    ERR_1526=1526,          -- 闭关时间已经无法缩短
    
    -- 装备相关
    ERR_1601 = 1601,        -- 装备级别超过最大限制

    ERR_1604 = 1604,
    
    -- 奥义相关
    ERR_1701 = 1701,        -- 已达到奥义最高上限
    
    -- 影子相关
    ERR_1801 = 1801,        -- 影子级别超过最大限制
    ERR_1802 = 1802,        -- 残影不足
    ERR_1808 = 1808,        -- 拥有影子已达上限

    -- 限时礼包相关
    ERR_2111 = 2111,
    ERR_2112 = 2112,
    ERR_2113 = 2113,
    ERR_2114 = 2114,
    ERR_2115 = 2115,

    -- 月卡
    ERR_2116 = 2116,        -- 不能重复购买月卡
    ERR_2117 = 2117,        -- 玩家没有月卡或月卡已经过期
    ERR_2118 = 2118,        -- 今天已经领取过月卡奖励了

    -- 奇遇相关
    ERR_2201 = 2201,        -- 未到开饭时间
    ERR_2202 = 2202,        -- 当前没有S级伙伴
    ERR_2203 = 2203,        -- 超过最大许愿次数
    ERR_2204 = 2204,        -- 今日已亲吻
    ERR_2205 = 2205,        -- 未达到活动级别
    ERR_2206 = 2206,        -- 兑换列表不存在
    ERR_2207 = 2207,        -- 伙伴不在玩家列表中
    ERR_2208 = 2208,        -- 当前时段已吃过饭
    ERR_2209 = 2209,        -- 玩家等级不足
    ERR_2210 = 2210,        -- 酒精数量不足
    ERR_2211 = 2211,        -- 超过最大兑换数量
    ERR_2212 = 2212,        -- 饮酒次数为0
    ERR_2213 = 2213,        -- 玩家VIP级别不够
    ERR_2214 = 2214,        -- 许愿：配置表中无此数据
    ERR_2215 = 2215,        -- 高人指点：无效的点拨选项
    ERR_2216 = 2216,        -- 高人指点：当前玩家没有点拨机会
    ERR_2217 = 2217,        -- 今日奖品已领取
    ERR_2218 = 2218,        -- 今日奖品已领取
    ERR_2219 = 2219,        -- 时间未到

    -- 大冒险
    ERR_2401 = 2401,        -- 今日已经挑战完毕
    ERR_2402 = 2402,        -- 当前Boss已死
    ERR_2403 = 2403,        -- 关卡数据错误
    ERR_2410 = 2410,        -- 无此关卡
    ERR_2411 = 2411,        -- 无效的关卡坐标
    ERR_2412 = 2412,        -- 不可攻打已通过的关卡
    ERR_2413 = 2413,        -- 超过可攻打的最大次数
    ERR_2414 = 2414,        -- 未达到攻打Boss的要求

    -- 决斗
    ERR_2501 = 2501,        -- 等级不足
    ERR_2502 = 2502,        -- 当时决斗次数达到规定上限
    ERR_2503 = 2503,        -- 当前排名发生改变，请刷新数据
    ERR_2504 = 2504,        -- 积分不足
    ERR_2505 = 2505,        -- 未达到领取条件
    ERR_2506 = 2506,        -- 决斗次数不足
    
    -- 其他
    ERR_2601 = 2601,        -- 钥匙不足
    ERR_2602 = 2602,        -- 道具不是可用的
    ERR_2603 = 2603,        -- 重复添加好友
    ERR_2604 = 2604,        -- 好友数量达到上限
    ERR_2605 = 2605,        -- 玩家不在好友列表中
    ERR_2606 = 2606,        -- 箱子不足
    ERR_2607 = 2607,
    ERR_2613 = 2613,        -- 已经发送过好友请求
    ERR_2614 = 2614,

    -- 联盟的错误码
    ERR_2701 = 2701,    -- 玩家已经加入其它联盟了
    ERR_2702 = 2702,    -- 联盟名称太短
    ERR_2703 = 2703,    -- 联盟名称太长
    ERR_2704 = 2704,    -- 联盟名称不合法
    ERR_2705 = 2705,    -- 联盟名称已经存在
    ERR_2706 = 2706,    -- 联盟不存在
    ERR_2707 = 2707,    -- 玩家不在联盟中
    ERR_2708 = 2708,    -- 联盟操作权限不足
    ERR_2709 = 2709,    -- 玩家已经点睛过该类型的点睛了
    ERR_2710 = 2710,    -- 联盟猜拳还未开放
    ERR_2711 = 2711,    -- 玩家已经猜过拳了
    ERR_2712 = 2712,    -- 玩家今日猜拳次数已经达到限制
    ERR_2713 = 2713,    -- 本次猜拳已经结束
    ERR_2716 = 2716,    -- 联盟已经达到最大人数
    ERR_2717 = 2717,    -- 职位人数已满（副会长）
    ERR_1113 = 1113,    -- 玩家等级不足

    ERR_2718 = 2718,    -- 未到盟战时间，请耐心等候。
    ERR_2719 = 2719,    --  您不是会长/副会长，不可以宣战哦
    ERR_2720 = 2720,    -- 不能宣战，已有人开启战斗了。
    ERR_2721 = 2721,    --  宣战失败，被宣战方已经正在盟战中了。
    ERR_2722 = 2722,    -- 宣战失败，被宣战方已经正在盟战中了。
    ERR_2723 = 2723,    -- 记录指针不足！请补充
    ERR_2724 = 2724,    -- 盟战功能需要联盟等级2，现在还未开启哦
    ERR_2725 = 2725,    -- 盟战时间，不能进行该操作
    ERR_2726 = 2726,    -- 盟战建筑不存在
    ERR_2727 = 2727,    -- 联盟糖果不足
    ERR_2728 = 2728,    -- 盟战建筑等级达到上限
    ERR_2729 = 2729,    -- 联盟商城已经刷新，请重新购买
    ERR_2730 = 2730,    -- 联盟商城已经刷新，请重新购买
    ERR_2731 = 2731,    --  不能购买该物品，商城等级不足
    ERR_2732 = 2732,    -- 糖果数不足，不能购买该物品
    ERR_2733 = 2733,    -- 购买次数已达上限。
    ERR_2734 = 2734,    -- 战斗未开始或已结束，请刷新
    ERR_2735 = 2735,    --玩家不能参加某场战斗
    ERR_2736 = 2736,    -- 不能宣战，此联盟已被抢光了。
    ERR_2737 = 2737,    -- 已达最大捐赠次数
    ERR_2738 = 2738,    -- 此防御已被占领！请尝试其他防御
    ERR_2739 = 2739,    -- 同一个玩家不能部署到多个工事上
    ERR_2740 = 2740,    -- 该防御为空，不能获取信息。
    ERR_2741 = 2741,    -- 耐久已满，无需修复
    ERR_2742 = 2742,    -- 此防御已被占领！请尝试其他防御
    ERR_2743 = 2743,
    -- cdkey
    ERR_2801 = 2801,        -- cdkey不存在
    ERR_2802 = 2802,
    ERR_2803 = 2803,
    ERR_2804 = 2804,

    -- BOSS
    ERR_2901 = 2901,        -- BOSS战还未开始
    ERR_2902 = 2902,        -- boss已死
    ERR_2903 = 2903,        -- BOSS挑战间隔太短
    ERR_2904 = 2904,        -- 参数错误
    ERR_2905 = 2905,        -- 还未复活
    
    --邀请码
    ERR_2619 = 2619,        --填写自己的邀请码
    ERR_2618 = 2618,        --邀请码填写的空格
    ERR_2616 = 2616,        --不存在的邀请码
    ERR_1110 = 1110,        --已经领取所有邀请码奖励

    -- vip等级礼包
    ERR_2624 = 2624,        --vip礼包已领取

    
    ERR_9999 = 9999,        -- 未知错误

    ERR_1122 = 1122,        -- 道具不存在
    ERR_7015 = 7015,        -- 道具不存在

}


hlText = ""

function parseByControlModule( url, code, response )
    -- print(" Print By lixq ---- network return Code ", code)
    -- PrintTable(response)
    -- if code ~= 200 and code ~= 119 then
    --     if string.find(url, ActionTable.SSO_LOGIN_URL) and code == 101 then
    --         HLShowText(pDirector:getRunningScene(), HLNSLocalizedString("SSO.login.fail.101"))
    --     else
    --         HLShowErrorText(pDirector:getRunningScene(), code, response)
    --     end
    --     if code == 102 then
    --         shotcutShopLayer(pDirector:getRunningScene())
    --     end
    --     return
    -- end
    -- -- if (code == NSIntegerMin) {
    -- --     // 网络问题
    -- --     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:HLGetDisplayName() message:HLNSLocalizedString(@"network.netError") delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    -- --     [alertView show];
    -- --     [alertView release];
    -- --     [self retain];
    -- -- }
    local dic = response["info"]
    print("dic 111111")
    --PrintTable(dic)

    if code ~= 200 and code ~= ErrorCodeTable.ERR_1207 then
        if code == 99305 then
            -- redis锁 踢出游戏登陆
            local scene = CCDirector:sharedDirector():getRunningScene()
            scene:addChild(createLoginErrorPopUpLayer(-1000), 10000)
        elseif code == 2602 then
            ShowErrorText( code, HLNSLocalizedString("该物品无法使用"))
        elseif code == 2110 then
            if isPlatform(ANDROID_INFIPLAY_RUS) then
                Global:consumeItem()
            end
        else
            local layer = CCDirector:sharedDirector():getRunningScene():getChildByTag(65525)
            if layer then
                layer:removeFromParentAndCleanup(true)
                layer = nil
            end
            if code == 1107 then
                -- vip等级不够
                CCDirector:sharedDirector():getRunningScene():addChild(createShopRechargeLayer(-140), 100)
            elseif code == 1103 or code == 1401 then
                -- 体力不足
                CCDirector:sharedDirector():getRunningScene():addChild(createRecoverInfoLayer(0), 100)
            elseif code == 1104 or code == 1402 then
                -- 精力不足
                CCDirector:sharedDirector():getRunningScene():addChild(createRecoverInfoLayer(1), 100)
            elseif code == 1213 then
                PrintTable(response)
                -- 不同平台对服务器认证失败的处理
                if isPlatform(IOS_KY_ZH)
                    or isPlatform(IOS_KYPARK_ZH) 
                    or isPlatform(IOS_TBT_ZH) or isPlatform(IOS_TBTPARK_ZH) 
                    or isPlatform(IOS_PPZS_ZH) 
                    or isPlatform(IOS_PPZSPARK_ZH)
                    or isPlatform(IOS_ITOOLS)
                    or isPlatform(IOS_ITOOLSPARK) 
                    or isPlatform(ANDROID_360_ZH) 
                    or isPlatform(ANDROID_WDJ_ZH) 
                    or isPlatform(ANDROID_GV_MFACE_ZH) 
                    or onPlatform("TGAME") 
                    or isPlatform(ANDROID_GV_MFACE_EN) 
                    or isPlatform(ANDROID_GV_MFACE_EN_OUMEI)
                    or isPlatform(ANDROID_GV_MFACE_EN_OUMEINEW)
                    or isPlatform(IOS_GAMEVIEW_ZH) 
                    or isPlatform(IOS_GAMEVIEW_EN) 
                    or isPlatform(IOS_GVEN_BREAK)
                    or isPlatform(ANDROID_GV_XJP_ZH)
                    or isPlatform(ANDROID_GV_MFACE_TC)
                    or isPlatform(IOS_GAMEVIEW_TC)
                    or isPlatform(ANDROID_MYEPAY_ZH)
                    or isPlatform(ANDROID_HTC_ZH)
                    or isPlatform(ANDROID_GV_MFACE_TC_GP)
                    or isPlatform(ANDROID_JAGUAR_TC)
                    or isPlatform(IOS_JAGUAR_TC) 
                    or isPlatform(ANDROID_DOWNJOY_ZH)
                    or isPlatform(IOS_DOWNJOYPARK_ZH)
                    or isPlatform(IOS_XYZS_ZH)
                    or isPlatform(ANDROID_XYZS_ZH)
                    or isPlatform(IOS_HAIMA_ZH) then

                    tpSSOLogin({}, "ssoLoginSucc", "ssoLoginFail")

                elseif isPlatform(ANDROID_XIAOMI_ZH) then

                    tpSSOLogin({}, "ssoLoginXiaoMiSucc", "ssoLoginFail")

                elseif isPlatform(ANDROID_OPPO_ZH) then

                    tpSSOLogin({}, "ssoLoginOPPOSucc", "ssoLoginFail")
                    
                else
                    if getLoginLayer() then
                        getLoginLayer():showLogin()
                    end 
                end
            end
            ShowErrorText( code, response)
        end
        return
    end
    if response["info"]["eliteOpen"] then
        userdata.eliteClose = response["info"]["eliteOpen"]
    end
    if response["info"]["wakeOpen"] then
        userdata.wakeClose = response["info"]["wakeOpen"]
    end
    if response["info"]["now"] then
        userdata.loginTime = response["info"]["now"]
    end
    if response["info"]["encounter"] then
        if not dailyData.daily then
            dailyData.daily = {}
        end
        for key,dic in pairs(response["info"]["encounter"]) do
            if not dailyData.daily[key] then
                dailyData.daily[key] = {}
            end
            if dic.sort then
                dailyData.daily[key].sort = dic.sort
            end
            if key == Daily_InstructHeroS then
                if not dailyData.daily[key] then
                    dailyData.daily[key] = {}
                end
                for k,v in pairs(dic) do
                    dailyData.daily[key][k] = v
                end
            elseif key == Daily_Treasure then
                dailyData:updateTreasure(dic)
            else
                dailyData.daily[key] = dic
            end
        end 
        if userdata.monthCardData then
            dailyData.daily.yueka = {sort = 0}
        end
    end
    if response["info"]["timeGift"] then
        giftBagData.timeGift = response["info"]["timeGift"]
    end
    if response["info"]["serverNotice"] then
        if not announceData.serverNotice then
            announceData.serverNotice = {}
        end
        
        announceData.serverNotice = response["info"]["serverNotice"]
    end
    -- 任务
    if response["info"]["missions"] then
        local flag =  questdata:fromDic(response["info"]["missions"])
        -- 如果是在非登陆接口或者非战斗接口，并且有完成任务的时候，弹出任务完成提示
        if not (string.find(url, ActionTable.LOGIN_URL) or string.find(url, ActionTable.STORYBATTLE_URL) or string.find(url, ActionTable.CHAPTER_BATTLE) 
            or string.find(url, ActionTable.BLOOD_BATTLE) or string.find(url, ActionTable.ARENA_BATTLE) 
            or string.find(url, ActionTable.MARINE_FIGHT_BOSS) 
            or (string.find(url, ActionTable.LEAGUE_BATTLE_FIGHTING) and runtimeCache.unionBattleInFight)
            or string.find(url, ActionTable.WW_FIGHT) or string.find(url, ActionTable.ELITE_BATTLE) or string.find(url, ActionTable.ELITE_SWEEP)) and flag then
        
            local popup = createQuestPopupLayer()
            if popup then
                getMainLayer():getParent():addChild(popup, 99999)
            end
        end
    end
    if string.find(url, ActionTable.LOGIN_URL) or string.find(url, ActionTable.DAILY_BUY_SECRETSHOP)
     or string.find(url, ActionTable.DAILY_FLUSH_SECRETSHOP) or string.find(url, ActionTable.DAILY_GET_SECRETSHOP) 
     or string.find(url, ActionTable.REGISTER_URL) then
        if response["info"]["secretShop"] and type(response["info"]["secretShop"]) == "table" then
            dailyData:updateMysteryShopAwardData(response["info"]["secretShop"])
        end
    end
    
    if string.find(url, ActionTable.LOGIN_URL) or string.find(url, ActionTable.DAILY_GET_SIGNINRECORD) 
        or string.find(url, ActionTable.REGISTER_URL) then
        if response["info"]["signIn"] and type(response["info"]["signIn"]) == "table" then
            dailyData:updateMySignInData(response["info"]["signIn"])  -- 往dailyData添加数据 每日签到
        end
    end

    if string.find(url, ActionTable.STORYBATTLE_URL) or string.find(url, ActionTable.CHAPTER_BATTLE) 
        or string.find(url, ActionTable.BLOOD_BATTLE) or string.find(url, ActionTable.ARENA_BATTLE) 
        or string.find(url, ActionTable.MARINE_FIGHT_BOSS) 
        or (string.find(url, ActionTable.LEAGUE_BATTLE_FIGHTING) and runtimeCache.unionBattleInFight)
        or string.find(url, ActionTable.WW_FIGHT) or string.find(url, ActionTable.SEALMIST_FIGHT)  
        or string.find(url, ActionTable.SAVR_ROBLOG) or string.find(url, ActionTable.CROSSSERVERBATTLE_FIGHT)  
        or string.find(url, ActionTable.CROSSSERVERRACEBATTLE_FIGHT) or string.find(url, ActionTable.MULTI_EXPLORE_TREASURE)
        or string.find(url, ActionTable.ELITE_BATTLE) or string.find(url, ActionTable.ELITE_SWEEP) then
        return
    end
    local dic = response["info"]
    userdata:updateUserDataWithGainAndPay(dic["gain"], dic["pay"])
    print("ControlModule中的pay和gain")
    --PrintTable(dic["pay"])
    if string.find(url,ActionTable.ITEM_USE_URL) then
        if string.find(url,"item_001") then
            ShowText(HLNSLocalizedString("香吉士的厨艺果然名不虚传，他做的鲜美\n【牛排】已帮您回复10点体力，有需要时\n再来食用吧！"))
            return
        end
        if string.find(url,"item_002") then
            ShowText(HLNSLocalizedString("【宾克斯的美酒】果然不错，让你找回了\n战斗的勇气，立马帮您回复了10点精力！"))
            return
        end
        if string.find(url,"item_003") then
            ShowText(HLNSLocalizedString("恭喜船长，成功获得3次德雷斯罗萨竞技场\n的【决斗】机会，快去击败您的对手吧！"))
            return
        end
        
    end
    -- 在战斗前阻止弹出奖励框
    if string.find(url, ActionTable.CLICK_BELL_URL) or string.find(url, ActionTable.RECRUITHERO_URL) or string.find(url, ActionTable.ADD_SUCCESSION_AWARD_URL) or string.find(url, ActionTable.MAKE_WISH_URL) 
        or string.find(url, ActionTable.EXPLORE_TREASURE) or string.find(url, ActionTable.ADD_SHAKE_AWARD_URL)  or string.find(url, ActionTable.DAILY_ROBIN) 
        or string.find(url, ActionTable.COMBINE_CHAPTER) or string.find(url, ActionTable.TRANSFER_URL) or string.find(url, ActionTable.BUY_AND_USE) or string.find(url, ActionTable.ARENA_EXCHANGE) 
        or string.find(url, ActionTable.MAKE_WISH_URL) or string.find(url, ActionTable.ARENA_GET_AWARD) or string.find(url, ActionTable.BOSS_BATTLE) or string.find(url, ActionTable.MARINE_MOBS_BATTLE)
        or string.find(url, ActionTable.MARINE_FIGHT_BOSS) or string.find(url, ActionTable.QINGJIAO_SEEK) or string.find(url, ActionTable.QINGJIAO_TENSEEK) 
        or string.find(url, ActionTable.WW_EXPLORE) or string.find(url, ActionTable.ROLL_LUCKYREWARD) or string.find(url, ActionTable.SEALMIST_GETREWARD)
        or string.find(url, ActionTable.SEALMIST_FIGHT) or string.find(url, ActionTable.ACCEPT_ESCORT_AWARD) or string.find(url, ActionTable.CROSSSERVERRACEBATTLE_FIGHT)
        or string.find(url, ActionTable.HAKI_FIGHT) or string.find(url, ActionTable.YAO_YAO_HAPPY) then
        return
    end
    userdata:popUpGain(dic["gain"], true)
end