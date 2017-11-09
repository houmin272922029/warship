var ACTION = {
	// 登陆
	LOGIN:"user_login",
	GETSETTING:"setting_getSetting",
	GETSERVERLIST:"public_getServerList",
	REGISTER:"user_register",
	GETVERSION:"public_getVersionInfo",
	
	//支付
	FLUSH_PLAYER_DATA:"player_flushPlayerData",
	
	// 英雄
	HEROCULTURE:"hero_cultivate",
	FORM_BREAKHERO:"hero_breakHero",
	FORM_RECRUITSOUL:"hero_recruitSoul",
	HEROFARME:"hero_transfer",
	CULTURECONFIRM:"hero_confirmCultivate",
	HEROTRAIN:"aggress_training",
	HEROFIGHTING:"aggress_preFight",
	HERO_CHANGESKILL:"hero_changeSkill",
	HERO_CHANGEEQUIP:"hero_changeEquip",
	
	// 阵容
	FORM_ONFORM:"form_onForm",
	FORM_ONSEVENFORM:"form_onFormSeven",
	FORM_CHANGEFORM:"form_changeForm",
	FORM_OPENSEVEN:"form_openFormSeven",
	FORM_UPGRADESEVEN:"form_formSevenUpgrade",
	FROM_GETALLTITLES:"title_getAllTitles",
	// 技能
	SKILL_BREAK:"skill_trainSkill",
	
	// 道具
	ITEM_USEITEM:"item_useItem",
	ITEM_USEDELAYITEM:"item_useDelayItem",
	
	// vip
	GETVIPDAILYREWARD:"vip_getVipDailyReward", 
	GETVIPLEVELREWARD:"vip_getVipLevelReward",
	
	// 装备
	EQUIP_SELLEQUIP:"equip_sellEquip",
	EQUIP_UPDATE:"equip_updateEquip",
	EQUIP_REFINE:"equip_refineEquip",

	// 活动
	DAILY_INVITE_INFO : "invitation_getInvitation",
	DAILY_INVITE_ACCEPT : "invitation_acceptAnybodyCode",
	DAILY_INVITE_GET_REWARD : "invitation_getInvitationAward",
	DAILY_EAT_INFO : "dayEnergy_eatInfo",
	DAILY_EAT_ACTION: "dayEnergy_eat",
	DAILY_LIST : "daily_list",
	DAILY_KISS_MERMAID : "kissMermaid_kissInfo",
	DAILY_KISS : "kissMermaid_kiss",
	DAILY_DRING_INFO : "drink_drinkInfo",
	DAILY_CHANGE_WINE : "drink_changeWine",
	DAILY_CHANGE_ONE_KEY : "drink_changeWineOneKey",
	DAILY_DRING : "drink_drink",
	DAILY_CAP_EXCHANGE : "drink_capExchange",
	
	//  高人特训
	DAILY_Instruct_List_EXCHANGE : "item_instructList",
	DAILY_Instruct_SomeOne_EXCHANGE : "item_instructSomeOne",
	DAILY_Instruct_Cache_EXCHANGE : "item_cacheHeroInstruct",
	DAILY_Instruct_Use_EXCHANGE : "item_useInstruct",
	
	// 影子
	SHADOW_CHANGE_STATUS:"shadow_changeStatus",
	SHADOW_SHADOW_BUY:"shadow_shadowBuy",
	SHADOW_SHADOW_UPDATE:"shadow_shadowUpdate",
	SHADOW_EXERCISE_STATUS:"shadow_exerciseWithStatus",
	SHADOW_EXERCISE:"shadow_exercise",
	
	// 大冒险
	ADVENTURE_INFO:"adventure_info",
	
	// 新世界
	BLOOD_GETBLOODINFO:"blood_getBloodInfo",
	BLOOD_BEGINBLOOD:"blood_beginBlood",
	BLOOD_ADDFIRSTBUFF:"blood_addFirstBuff",
	BLOOD_ADDBUFF:"blood_addBuff",
	BLOOD_ADDAWARD:"blood_addAward",
	BLOOD_BLOODBATTLE:"blood_bloodBattle",
	BLOOD_GETBLOODRANKINFO:"blood_getBloodRankInfo",
	BLOOD_RANKANDAWARDFORONEDAY:"blood_bloodRankAndAwardForOneDay",
	// 恶魔谷
	BOSS_GETBOSSINFO:"boss_getBossInfo",
	VIPBUY:"vip_buyVipShop",
	VIPSHOP:"vip_rushVipShop",
	BOSS_BOSSBATTLE:"boss_bossBattle",
	HERO_CHANGESKILL:"hero_changeSkill",
	HERO_CHANGEEQUIP:"hero_changeEquip",

	//罗格镇
	BUYSHOPITEM:"shop_buyShopItem",
	BUYVIPBAGS:"shop_buyVipBag",
	RECRUITHEROES:"shop_rushHero",

	HERO_CHANGESHADOW:"hero_changeShadow",
	FRAG_GET_FRAGENEMIES:"frag_getFragEnemies",
	FRAG_GET_BOOKFRAGS:"frag_getBookFrags",
	FRAG_COMBINEFRAGS:"frag_combineFrags",
	FRAG_GETFRAGENEMIES:"frag_getFragEnemies",
	FRAG_FRAG_BATTLE:"frag_fragBattle",
	ARENA_ARENAMAIN:"arena_arenaMain",
	ARENA_ARENABATTLE:"arena_arenaBattle",
	ARENA_GETARENA_RECORDS:"arena_getArenaRecords",
	ARENA_RECORD_AWARD:"arena_getArenaRecordsAward",
	ARENA_GET_SCORE:"arena_getArenaScore",
	ARENA_EXCHANGE_ITEM:"arena_exchangeItems",
	
	// 联盟
	UNION_MAININFO:"league_getMainInfo",
	UNION_CREATE:"league_createLeague",
	UNION_QUERY:"league_queryLeagues",
	UNION_QUERY_ID:"league_queryLeagueById",
	UNION_JOIN:"league_askForJoinLeague",
	UNION_APPLICANT:"league_queryAskForJoin",
	UNION_APPLICANT_PROCESS:"league_agreeOrDenyAskForJoin",
	UNION_DELETE:"league_deleteLeague",
	UNION_QUIT:"league_quitLeague",
	UNION_CHANGEDUTY:"league_changeDuty",
	UNION_FIRE:"League_kickOutMember",
	UNION_ABDICATE:"league_abdicate",
	UNION_MESSAGE:"league_getLeagueMessage",
	UNION_BUILDING_UPGRADE:"league_buildingUpgrade",
	UNION_CONTRIBUTIONINFO:"league_contributionInfo",
	UNION_CONTRIBUTE:"league_contribute",
	UNION_SWEET_CONTRIBUTE:"league_sweetContribute",
	UNION_DISTRIBUTE_SWEET:"league_serveOutSweet",
	UNION_SHOP_BUY:"league_shopBuy",
	
	//下载更新
	GET_LASTEST_VERSION:"public_getVersionInfo",

	// 起航
	STAGE_FIGHT:"stage_battleStage",
	STAGE_MULTI_FIGHT:"stage_battleStageSweep",
	STAGE_RESET:"stage_resetSategCount",
	STAGE_CHAPTER_REWARD:"stage_getPageAward",
	
	DAILY_GET_SIGNIN_DATA:"signIn_getRecord",
	DAILY_SIGNIN:"signIn_signIn",
	DAILY_SUPER_SIGNIN:"signIn_supplSignIn",
	DAILY_LEVELUP_GIFT_GET_INFO :"levelUpGift_getMainInfo",
	DAILY_LEVELUP_GET_REWARD : "levelUpGift_getAwards",
	DAILY_CASH_MONTHLIST : "cash_monthList",
	DAILY_CASH_GAINMONTHCARD : "cash_gainMonthCardAward",
	DAILY_CASH_GAIN_UNLIMIT : "cash_gainUnlimitCardAward",
	DAILY_IS_BUY : "cash_isBuy",
	
	// 获取工坊数据
	DAILY_GET_CRAFTS_MAN_DATA : "equip_getCraftsman",
	DAILY_CRAFT_MAN_DECOMPOSE_ACTIONG : "equip_decompose",
	DAILY_CRAFT_MAN_DECOMPOSE_BY_RANK_ACTIONG : "equip_decomposeByRank",
	DAILY_GET_CRAFTS_MADE_EQUIP : "equip_made",

	//聊天
	SEND_MESSAGE:"chat_sendPublicMessage",
	SEND_LEAGUE_MESSAGE:"chat_sendLeagueChatMessage",
	SEND_HORN_MESSAGE:"chat_sendTrumpetMessage",
	GET_PUBLIC_MESSAGE:"chat_getPublicMessage",
	GET_LEAGUE_MESSAGE:"chat_getLeagueChatMessage",
	GET_HORN_MESSAGE:"chat_getTrumpetMessage",

	//任务系统 领奖
	MISSION_GETREWARD:"mission_getMissionReward",
	
	//好友系统 
	GET_FRIEND_LIST:"friend_getFriendList",
	GETPLAYER_BY_LEVEL:"friend_getPlayersByLevel",
	GETPLAYER_BY_NAME:"friend_getPlayersByName",
	INVITE_FRIEND:"friend_inviteFriend",
	ACCEPT_FRIEND:"friend_acceptFriend",
	DELETE_FRIEND:"friend_deleteFriend",
	ATTENTION_FRIEND:"friend_attention",
	UNATTENTION_FRIEND:"friend_unAttention",
	SEND_EACH_STRENGTH:"friend_sendEachStrength",
	LEVEL_MESSAGE_FRIEND:"friend_leaveMessage",
	
	//用户反馈
	FEED_BACK:"player_saveErrorsOfPlayer",
	
	//新闻系统
	MAIL_GET_MAIL_AWARDS : "mail_getMailAwards",
}