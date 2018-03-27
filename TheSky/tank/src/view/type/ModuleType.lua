local ModuleType = {}

ModuleType.STORAGE = "storage"--仓库
ModuleType.EMBATTLE = "embattle"--布阵
ModuleType.GARAGE = "garage" --车库
ModuleType.SUPPLY = "supply" --补给
ModuleType.CHAPTER = "chapter" --关卡
ModuleType.TRAINING = "training" --训练场
ModuleType.INHERIT = "inherit" --坦克置换
ModuleType.EQUIP = "equip" --装备
ModuleType.MAIL = "mail" --邮箱
ModuleType.EXTRACTION_CARD = "extractionCard" --抽卡
ModuleType.TECHNOLOGY = "technology" --科技
ModuleType.OPEN_HELP = "open_help" --功能开启提示(主页)
ModuleType.TASK = "task" --任务
ModuleType.SHOP = "shop" --商店
ModuleType.TANK_SHOP = "tankShop" --坦克工厂
ModuleType.PROP_SHOP = "propShop" --军需商店
ModuleType.MINE_MAIN_VIEW = "mine_view" --矿区主场景
ModuleType.MINE_PLUNDER_VIEW = "plunderView" --普通矿区掠夺界面
ModuleType.MINE_RARE_MINE_VIEW = "rareMineView" --稀有矿区界面
ModuleType.BATTLE_ROOM = "battleRoom" --活动导航(作战室)
-- ModuleType.ARENA = "arena" --竞技场
-- ModuleType.FIGHT_JAPAN = "fightJapan" --抗日远征
ModuleType.ROLE_UPGRADE = "roleUpgrade" --主角升级
ModuleType.FUNCTION_OPEN_TIP = "functionOpenTip" --功能开启
ModuleType.STRONG = "functionStrong" --我要变强
-- ModuleType.INSPECTION = "inspection" --每日检阅
-- ModuleType.INVADE = "invade" --伞兵入侵
-- ModuleType.POT = "pot" --大锅饭
ModuleType.SET = "setting" --设置
ModuleType.PUSH_SET = "pushListSet" --推送设置
ModuleType.VIP = "vip" -- vip特权
-- ModuleType.VIP_AWARD = "vipAward" -- vip award
ModuleType.BUY_OR_USE = "buyOrUseDialog" -- 购买或使用弹窗
ModuleType.MESSAGE = "message" -- 消息
ModuleType.ACTIVITY_LIST = "activityList" -- 运营活动列表
ModuleType.SERVICE_ACTIVITY_LIST = "serviceactivityList" -- 跨服活动列表
ModuleType.TIME_LIMIT_ACTIVITY_LIST = "timelimitactivityList" -- 限时活动列表
ModuleType.SCENE_LOADING = "SCENE_LOADING" --场景切换loading
ModuleType.ACHIEVEMENT = "achievement" -- 成就，图鉴
ModuleType.PLUNDER_LOG = "PLUNDER_LOG" -- 矿区战报
ModuleType.BIND_ACCOUNT = "BIND_ACCOUNT" -- 绑定账号
ModuleType.EXAMINE = "examine" -- 查看资料
ModuleType.EXAMINE_AI = "examine_ai" -- 查看资料
ModuleType.EXAMINE_AI_L = "examine_ai_l" -- 跨服军团战查看ai
ModuleType.RECHARGE = "recharge" -- 充值
ModuleType.ALLOY = "alloy" -- 合金
ModuleType.CD_KEY = "cdkey" -- 礼包兑换
ModuleType.BLACKLIST = "blacklist" -- 黑名单
ModuleType.LEGION = "legion" -- 军团
ModuleType.PASSENGER = "passenger" -- 乘员系统
ModuleType.YOU_CHOOSE_I_SEND = "you_choose_i_send" -- 你选我送
ModuleType.CHRISTMAS_WAR = "christmas_war" -- 圣诞boss
ModuleType.LEGION_RECHARGE = "legion_recharge" -- 军团充值
ModuleType.BATTLE_FORGE_BANQUET = "war_party" -- 宴会

--登录有关界面
ModuleType.REGISTER = "register" -- 快速注册
ModuleType.REMINDER = "reminder" -- 温馨提示
ModuleType.DISTRICT = "district" -- 换区
ModuleType.QY_AGREE = "qyAgree" --奇游用户协议
ModuleType.ENTER_GAME = "ENTER_GAME" --进入游戏
ModuleType.LOGIN_ANNOUNCE = "LOGIN_ANNOUNCE" --登录公告
ModuleType.FINISH_GUIDE = "FINISH_GUIDE" --完成新手引导
ModuleType.SINA_APPSTORE_SCORE = "sina_appstore_score" --sina appstore 星级评价

---运营活动-------------------------------------
ModuleType.LOGIN_GIFT = "seven_day_login" --7天登陆活动 和后端的key保持一致
ModuleType.HEROIC_RACING = "heroic_racing" --英勇竞速   和后端的key保持一致
ModuleType.VISIT_GENERAL = "visit_general" --拜访名将  和后端的key保持一致
ModuleType.HEADQUATER_SUPPORT = "headquarters_support" --总部支援  和后端的key保持一致
ModuleType.OPEN_SERVER_GIFT_BAG = "open_server_gift_bag"  -- 开服礼包  和后端的key保持一致
ModuleType.POT = "pot"  -- 大锅饭  和后端的key保持一致
ModuleType.VIP_AWARD = "vip_award" --VIP津贴  和后端的key保持一致
ModuleType.ARNY_ASSAULT = "army_assault" --战争动员  和后端的key保持一致

ModuleType.UP_FUND = "up_fund" --成长基金
ModuleType.MONTH_CARD = "month_card" --月卡  和后端的key保持一致
ModuleType.YEAR_CARD = "year_card" --季卡,年卡  和后端的key保持一致
ModuleType.PUB = "jiuguan" --成长基金
ModuleType.DAY_MARK = "day_mark" --签到好礼，和后端的key保持一致

ModuleType.GUNNER_TRAIN = "gunner_train" --炮手训练  和后端的key保持一致
ModuleType.INVADE = "invade" --伞兵入侵  和后端的key保持一致
ModuleType.CLASSIC_BATTLE = "classicBattle" --经典战役  和后端的key保持一致
ModuleType.INSPECTION = "inspection" --每日检阅  和后端的key保持一致
ModuleType.ARENA = "arena" --竞技场  和后端的key保持一致
ModuleType.FIGHT_JAPAN = "expedition" --抗日远征  和后端的key保持一致
ModuleType.FIRST_PAY = "first_pay" --首充  和后端的key保持一致
ModuleType.TOTAL_PAY = "total_pay" --累充返利第一版  和后端的key保持一致
ModuleType.PAY_REBATE = "pay_rebate" --累充返利第二版  和后端的key保持一致
ModuleType.PAY_REBATE_VIP = "pay_rebate_new" --累充返利第三版
ModuleType.MATCH_FIGHT_POWER = "matchfightpower" --累充返利第三版
ModuleType.PAY_EVERYDAY = "pay_everyday" --每日充值
ModuleType.GOD_WORSHIP = "god_worship" --战神膜拜
ModuleType.BOIL_DUMPLING = "boil_dumpling" --煮元宵
ModuleType.COMBAT_CASTING = "combat_casting" --战备铸造
ModuleType.DAILY_PUNCH = "daily_punch" --每日累充
ModuleType.DAILY_CONSUMPTION = "daily_consumption" --每日累消
ModuleType.LEAP_FUND = "leap_fund" --飞跃基金
ModuleType.ACTIVITY_2048 = "activity_2048" --2048
ModuleType.JUNENGPINHE = "junengpinhe" --聚能拼合
ModuleType.FANFANLE = "fanfanle" --翻翻乐
ModuleType.KELUBO_TREASURY = "kelubo_treasury" --克虏伯
ModuleType.MARKET = "market" --黑市  和后端的key保持一致
ModuleType.BOSS = "boss" --世界boss  和后端的key保持一致
ModuleType.GOLD_BUNKER = "gold_bunker" --黄金地堡  和后端的key保持一致
ModuleType.CARRAY = "legion_escort" --军团押运
ModuleType.BONUS = "recharge_bonus" --充值红利
ModuleType.TORCH_OPERATION = "torch_operation" -- 火炬行动
ModuleType.IRON_MINE = "iron_mine" --精铁矿脉
ModuleType.LUCKY_CAT = "lucky_cat" --招财猫
ModuleType.F_J_EX_SHOP = "F_J_EX_SHOP" --远征商店
ModuleType.NEWYEAR_SUPPLY = "newyear_supply" --春节特供
ModuleType.LIMIT_TIME_SALE = "limit_time_sale" -- 限时抢购
ModuleType.SUPER_LIMIT_TIME_SALE = "super_limit_time_sale" -- 新的限时抢购

ModuleType.FIGHT_THE_WOLF="war_wolf"--战狼
ModuleType.LIMIT_SECKILL="limit_seckill"--限时秒杀
ModuleType.DOUBLE_ELEVEN="double_eleven"--双十一


ModuleType.NEWYEAR_SUPPLY = "spring_festival" --春节特供
ModuleType.ASSEMBLY = "assembly"--集结号
ModuleType.SPR_GIT = "spring_gift" --猴年吉祥
ModuleType.LEGION_BOSS = "legion_boss" --军团boss
ModuleType.LEGION_SKILL = "legion_skill" --军团技能
ModuleType.HEAD_TREASURE = "head_treasure" --猴年吉祥
ModuleType.SOUL = "soul" --军魂
ModuleType.SOUL_ROAD = "soul_road" --军魂之路
ModuleType.LOGIN_COMBAT = "login_combat" --登陆作战
ModuleType.SIGNLE_HERO = "single_hero" --孤胆英雄
ModuleType.SOLDIERS_WAR = "soldier_battle"--将士之战
ModuleType.OFFER_A_REWARD = "reward"--军功悬赏
ModuleType.BEAT_ENEMY = "beat_enemy"--暴打敌营
ModuleType.SIGN = "sign"--签到系统
ModuleType.GROUP_BATTLES = "group_battles"--多人副本
ModuleType.WAR_PICTURE = "warfarejigsaws"--战争图卷
ModuleType.RECHARGE_DOYEN = "recharge_doyen" --充值达人
ModuleType.EARTH_SOUL = "earth_soul" -- 大地英魂
ModuleType.ALL_RECHARGE = "all_recharge" -- 全民充值  和后端的key保持一致
ModuleType.SINGLE_RECHARGE = "single_recharge" -- 单笔充值(白虎来袭)  和后端的key保持一致
ModuleType.SEARCH_TREASURE = "search_treasure" -- 探宝日记  和后端的key保持一致
ModuleType.QUIZ = "quiz" -- 知识竞赛  和后端的key保持一致
ModuleType.GROUPPURCHASE = "grouppurchase" -- 超值购物  和后端的key保持一致
ModuleType.ACHIEVE_SHARE = "achieve_share" -- 分享有礼  和后端的key保持一致
ModuleType.WAR_AID = "war_aid" -- 战地援助  和后端的key保持一致
ModuleType.FAME = "overawe" -- 威震欧亚  和后端的key保持一致
ModuleType.MILITARY_SUPPLY = "military_supply" -- 军资整备  和后端的key保持一致



ModuleType.YURI_ENGINEER = "yuri_engineer" --尤里的工程师
ModuleType.BATTLE_FIELD_STORE = "battlefield_store" --战地储备
ModuleType.BATTLE_FIELD_SUPPLY = "battlefield_supply" --战地补给
ModuleType.LOGIN_FUND = "login_fund" --战地补给
ModuleType.RECHARGE_DUTY = "recharge_duty" --端午充值返利
ModuleType.INTRUDER_TIME = "intruder_time" --入侵者
ModuleType.DISCOUNT_SALE = "discount" --折扣贩售
ModuleType.OUTSTANDING = "mid_autumn" --精英招募
ModuleType.MILITARY_RANK = "militaryrank" --军衔
ModuleType.OLYMPIC = "junaohui_main" -- 军奥会
ModuleType.RECHARGE_KING = "recharge_king"--充值之王
ModuleType.DIAMOND_REBATE = "diamond_rebate"--钻石返利
ModuleType.LUCKY_INDIANA = "lucky_indiana"--幸运夺宝
ModuleType.SEVEN_DAYS_HAPPY = "seven_days_happy"--圣诞七天乐
ModuleType.ANNUAL_BONUS = "annual_bonus"--年终福利
ModuleType.RECRUIT_SUPPLY = "recruit_supply"--新兵特供
ModuleType.DAILY_WELFARE = "daily_welfare"--每日福利
ModuleType.RED_PACKET = "red_packet"--新年红包
ModuleType.ANNIVER_PAY = "anniver_pay" --周年庆充值
ModuleType.SERIES_RECHARGE = "series_recharge" --连充惊喜
ModuleType.MEDAL = "medal" -- 勋章
ModuleType.FITTINGS = "fittings" -- 配件 accessories模块名
ModuleType.NATASHA_DOUBLE = "natasha_double"--娜塔莎的祝福
ModuleType.NATASHA_DROP = "natasha_drop"--娜塔莎的祝福
ModuleType.LUCKY_TRUNTABLE = "lucky_truetable"--幸运转盘
ModuleType.MAY_PLEASURE = "may_pleasure" --五一嗨翻天
ModuleType.COLLECT_DUMPLINGS = "collect_dumplings" --粽子活动
ModuleType.ZONGZI_FIGHT = "zongzi_fight" --粽味争霸
ModuleType.MERGE_CARNIVAL = "merge_carnival" --合服大狂欢
ModuleType.CROSSFIRE = "crossfire"--冲破火线
ModuleType.GODWAR = "god_of_war"--至尊战神
ModuleType.TANK_918 = "tank_918"--鼠式增援
ModuleType.RECHARGE_SECTION = "recharge_section"--区间充值
ModuleType.TIGER_MACHINE = "tiger_machine"--老虎机
ModuleType.HAPPY_NATIONAL = "happy_festival"--国庆快乐
---------------------------------------------

ModuleType.DIAMOND_NOT_ENOUGH = "ModuleType" --钻石不足

ModuleType.RESOLVE = "resolve" --分解

ModuleType.TANK_COMMENT = "TANK_COMMENT" -- 战车点评

ModuleType.ADVANCE = "ADVANCE" -- 进阶

ModuleType.ENDLESS_WAR = "endless_war" --无尽战斗


---军团type--
ModuleType.LE_MOB = "legion_mobilize" --军团动员
ModuleType.LE_CLUB = "legion_club" --军团俱乐部
ModuleType.Le_WAR = "legion_war"--军团战
ModuleType.WAR_GROUP = "war_group" --群战(军团战 还有可能以后的跨服战)
ModuleType.ATTACK_BERLIN = "attack_berlin" --围攻柏林

--------跨服战--------
ModuleType.SER_WAR = "interservice" --巅峰之战
ModuleType.GREATEST_RACE = "strongest_battle" --最强之战
ModuleType.STRONG_BATTLE = "strongestbattle" --最强之战
ModuleType.SER_CAMP = "camp_war"--跨服阵营战

ModuleType.EXERCISE = "exercise" --跨服军演
ModuleType.INTER_SERVICE_ARENA = "inter_service_arena"--跨服军神榜
ModuleType.INTER_SERVICE_ESCORT = "inter_service_escort"--跨服军神榜

ModuleType.INTERSERVICE_LEGIONBATTLE = "interservice_legionbattle"--跨服军团战
ModuleType.ALL_SERVERS_GROUP_BATTLES = "all_servers_group_battles"--跨服多人副本


----
ModuleType.FIRE_REBATE = "fire_line_rebate" -- 前端 "fire_rebate" 后端 fire_line_rebate -- 火线返利

ModuleType.LEGIONGENERALTIONMODEL = "legion_mobilization"

ModuleType.COUPON_SHOP = "Coupon_Shop"


return ModuleType
