
HL_NOTI_Test = "testNoti"
HL_TEST = "testNoti"

-- sso 相关通知
HL_SSO_GenerateUid = "sso_generateUid"
HL_SSO91_Login = "sso_91login"
HL_SSO_Login = "sso_login"
HL_SSO_Register = "sso_register"	-- 游客账号绑定成功后的通知 或者 注册新账号成功后的通知
HL_SSO_ModifyPwd = "sso_modifyPwd" 
HL_SSO_ERROR = "sso_error" -- sso操作失败
HL_SSO_GetServerList = "sso_getServerList"			-- 获取 server list 的通知
HL_PLATFORM_LOGIN = "sso_platform_login" -- 第三方平台登陆
HL_SSOXIAOMI_Login = "sso_xiaomi_login"
HL_SSOOPPO_Login = "sso_oppo_login"
-- sso 相关通知 end

-- 游戏 相关通知
NOTI_STRENGTH = "strengthChange"
NOTI_RENAME_SUCCESS = "renameSuccess"
NOTI_ENERGY = "energyChange"
NOTI_GOLD = "goldChange"
NOTI_BERRY = "silverChanged"
NOTI_LEVELUP = "levelUp"
NOTI_RECRUIT_CD_TIMER = "recruitCDTimer"
NOTI_FANTASY_END_TIMER = "fantasyEndTime"
NOTI_EAT_CD = "eatCDTimer"  	-- 吃饭活动的cd时间
NOTI_ARENA = "arenaTimer" -- 决斗刷新时间
NOTI_SAIL_SWEEP = "sweepTimer" -- 连闯冷却时间
NOTI_EXP = "expChange" -- 船长经验改变
NOTI_VIPSCORE = "vipScore" -- vip值改变
NOTI_TITLE_INFO = "titleInfoTimer" -- 首页信息
NOTI_TOPROLL_INFO = "getTopRollInfo"  	-- 获取顶部滚动消息的通知
NOTI_INSTRUCT = "instructTimer" -- 特训时间
NOTI_SHOP_BUY_SUCCESS = "shopbuySuccess"-- 购买道具成功
NOTI_VIPSHOP_BUY_SUCCESS = "vipshopbuySuccess"-- vip商店购买道具成功
NOTI_PURCHASEAWARD = "purchaseAward" -- 充值返利
NOTI_SHAKE_PHONE = "shakePhone"	-- 摇了手机
NOTI_HOTBALLOON_ANI_END = "hotBalloonAniEnd"   -- 热气球动画结束
NOTI_WEIBO_BIND_RESULT = "weiboBindResult"		-- 微博绑定结果，用于刷新设置页面
NOTI_DAILY_STATUS = "dailyStatus"			-- 日常按钮的状态通知
NOTI_ADVENTURE_STATUS = "adventureStatus"			-- 大冒险的状态通知
NOTI_BOSS_BEGIN = "bossBegin" -- boss战开始
NOTI_BOSS_RESURRECT = "bossResurrect" -- boss战等待复活
NOTI_BOSS_AUTO = "bossAuto" -- boss战自动战斗等待时间
NOTI_BOSS_LOG = "bossLog"
NOTI_BOSS_CHALLENGE = "bossChallenge"
NOTI_RECRUIT_BTNUPDATE_REFRESH = "recruitbtmbtnrefresh"
NOTI_CALMBELT_CD = "calmbelttimelabel"
NOTI_PURCHASEREBATE = "purchaseRebate"
NOTI_EXPENSEREBATE = "expenseRebate"
NOTI_MYSTERYSHOP = "mysteryShop" --神秘商店距下次刷新时间

-- 游戏 相关通知 end

NOTI_REFRESH_ALLCHATDATA = "refreshChatData"    --  刷新聊天数据
NOTI_REFRESH_MAILCOUNT = "refreshMailCount" -- 刷新新邮件数量
NOTI_VIP_PACKAGE_COUNT = "refreshVipGift" -- 刷新新邮件数量
NOTI_GOLD_CLICK_REFRESH_TIMER = "refreshLabel"
NOTI_GOLD_CLICK_ENDTIME_TIMER = "endTimeTimer"

NOTI_UNION_FINGER_TIMER = "unionFingerTimer"

NOTI_REFLUSH_SHOP_RECHARGE_LAYER = "refreshShopRechargeLayer"   -- 刷新充值页面
NOTI_REFRESH_LOGUETOWN = "refreshLoguetown"		-- 刷新罗格镇
-- 苹果支付的通知
NOTI_APPLE_IAP_SUCC = "appleIAPSucc"
NOTI_APPLE_IAP_FAIL = "appleIAPFail"

-- 越南MobGame平台的相关通知
NOTI_MOBGAME_NEWSCOUNT = "mobGameNewsCount"

-- 练影相关
NOTI_TRINGSHADOW_CD_TIME = "trainCDTime"
NOTI_REFRESH_COIN = "refreshCoin"

-- 登录、累计活动
NOTI_LOGINACTIVITY_NUMBERSTATUS = "loginActivityNumber"


-- 盟战
NOTI_UNION_BATTLE = "unionBattle"

NOTI_MERGE_SHUIPIAN_SUCCESS = "mergeshuipian"

NOTI_REFLUSH_EXCHANGEACTIVITY_LAYER = "exchangeActivity"

-- 一秒
NOTI_TICK = "tickNoti"

-- 国战
NOTI_WW_REFRESH = "wwRefresh"

NOTI_DAILY_REFRESH = "dailyRefresh"

NOTI_QUEST = "questRefresh"

NOTI_LOGIN_GAME = "loginGameNoti"
-- 扫荡完成
NOTI_SAIL_SWEEP_FINISH = "sweepFinish"
-- 霸气值改变
NOTI_HAKI = "notiHakiChange"

NOTI_DOWNLOAD_ERR = "NOTI_DOWNLOAD_ERR"

--觉醒
NOTI_AWAKEN_CHOOSE = "NOTI_AWAKEN_CHOOSE"

Notification = {}

function postNotification(notiName, object)
    if Notification[notiName] == nil then
    	return
	end
	for k,v in pairs(Notification[notiName]) do
		v(object)
	end
end

function addObserver(notiName, notiCallBack)
	if Notification[notiName] == nil then
		local callbacks = {}
		table.insert(callbacks, notiCallBack)
		Notification[notiName] = callbacks
	else
		for k,v in pairs(Notification[notiName]) do
			if v == notiCallBack then
				return
			end
		end
		table.insert(Notification[notiName], notiCallBack)
	end
end

function removeObserver(notiName, notiCallBack)
	if Notification[notiName] == nil then
		return
	end

	for k,v in ipairs(Notification[notiName]) do
		if v == notiCallBack then
			table.remove(Notification[notiName], k)
		end
	end
	if table.getn(Notification[notiName]) == 0 then
		Notification[notiName] = nil
	end
end