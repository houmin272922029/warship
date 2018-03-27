--[[
	全局事件工具
	Author: Your
	Date: 2015-01-15 21:21:22
]]

local EventUtil = {}

EventUtil.BACK_OF_BATTLE = "backOfBattle" -- 战斗结束，返回的事件

EventUtil.SERVICE_LOADING_SHOW = "serviceLoadingShow"
EventUtil.SERVICE_LOADING_HIDE = "serviceLoadingHide"

EventUtil.CAMPAIGN_UPDATE_CHECKPOINT = "campaignUpdateCheckPoint"
EventUtil.CAMPAIGN_UPDATE_SCENE = "campaignUpdateScene"

EventUtil.USER_BASE_INFO_DATA_UPDATE = "userBaseInfoDataUpdate"  --用户基础数据更新
EventUtil.USER_RESOURCE_DATA_UPDATE = "userResourceDataUpdate"  --用户资源数据更新
EventUtil.USER_RECHARGE_DATA_UPDATE = "userRechargeDataUpdate"  --用户recharge数据更新
EventUtil.TASK_REWARD_UPDATE = "taskRewardUpdate"  --更新任务奖励显示
EventUtil.MINE_SERVER_TIME_UPDATE = "mineServerTimeUpdate"  --矿区服务器时间更新
EventUtil.MINE_OIL_UPDATE = "mineOilUpdate"  --矿区油料更新
EventUtil.SUPPLY_NUM_UPDATE = "supplyNumUpdate"  --矿区油料更新

EventUtil.MAIL_NEW = "mailNew"  --矿区油料更新
EventUtil.RACING_TIME = "RacingTime"  --矿区油料更新

EventUtil.LINEUP_SUCCESS = "lineupSuccess"  -- 布阵更新
EventUtil.GARAGE_UPDATE = "garageUpdate"  -- 车库更新(用于训练场升级、装备装载升级)
EventUtil.BATTLE_RESULT = "battleResult"  -- 战斗结算
EventUtil.UPDATA_SHUSHI = "updatashushi"  --晋升更新

EventUtil.ACTIVITY_REFRESH = "activeRefresh"  -- 活动刷新

EventUtil.BATTLE_START = "battleStart"  -- 战斗开始
EventUtil.BATTLE_END = "battleEnd"  -- 战斗结束
EventUtil.BATTLE_ENTER = "battleEnter"  -- 进入战斗
EventUtil.BATTLE_EXIT = "battleExit"  -- 退出战斗

EventUtil.BATTLE_AWARDS_SHOW = "battle_awards_show"  -- 显示经典战役奖励
EventUtil.BATTLE_AWARDS_HIDE = "battle_awards_hide"  -- 隐藏经典战役奖励

EventUtil.MESSAGE_UPDATE = "MESSAGE_UPDATE"  -- 消息更新
EventUtil.ARENA_RANK_UPDATE = "ARENA_RANK_UPDATE" -- 竞技场排名更新

EventUtil.CLIENT_ENERGY_UPDATE = "CLIENT_ENERGY_UPDATE" -- 客户端体力自动更新
EventUtil.SCENE_LOAD_HIDE = "SCENE_LOAD_HIDE" -- 隐藏场景切换loading

EventUtil.SCENE_TRANSITION_SHOW = "sceneTransitionShow" -- 显示切换场景
EventUtil.SCENE_TRANSITION_HIDE = "sceneTransitionHide" -- 隐藏切换场景
EventUtil.CENE_TRANSITION_OPEN = "sceneTransitionOpen" -- 打开切换场景
EventUtil.SCENE_TRANSITION_CLOSE = "sceneTransitionClose" -- 闭合切换场景

EventUtil.ACHIEVEMENT_RESCOURES_CHANGE = "ACHIEVEMENT_RESCOURES_CHANGE" -- 成就升级更新代币

EventUtil.CAMPAIGN_UPDATE_TIMES = "CAMPAIGN_UPDATE_TIMES" -- 更新关卡次数

EventUtil.PRELOAD_RES = "prelaodRes" -- 预载入资源

EventUtil.SHOW_PICADD_TIPS = "show_picadd_tips" -- 图鉴激活

EventUtil.BONUS_TIME = "bonus_time" -- 活动中的倒计时，不光在矿脉中用到，在其他活动中倒计时也可以用

EventUtil.IRON_MINE = "iron_mine" -- 精铁矿脉

EventUtil.CARRAY = "CARRAY" -- 押运

EventUtil.SINGLE_HERO = "SINGLE_HERO" -- 孤胆英雄

EventUtil.SOUL_ROAD = "SOUL_ROAD" --军魂之路
EventUtil.SOLDIERS_WAR = "SOLDIERS_WAR" --将士之战
EventUtil.INTER_SERVICE_ARENA = "INTER_SERVICE_ARENA" --跨服军神榜
EventUtil.INTER_SERVICE_ESCORT = "INTER_SERVICE_ESCORT" --跨服押运
EventUtil.OFFER_A_REWARD = "OFFER_A_REWARD" --军功悬赏
EventUtil.BEAT_ENEMY = "BEAT_ENEMY" --暴打敌营
EventUtil.SIGN = "SIGN" --签到系统
EventUtil.WAR_PICTURE = "WAR_PICTURE" --战争图卷
EventUtil.GROUP_BATTLES = "GROUP_BATTLES" --多人副本
EventUtil.GROUP_BATTLES2 = "GROUP_BATTLES2" --多人副本

EventUtil.ALL_SERVERS_GROUP_BATTLES = "ALL_SERVERS_GROUP_BATTLES" --跨服多人副本
EventUtil.ALL_SERVERS_GROUP_BATTLES2 = "ALL_SERVERS_GROUP_BATTLES2" --跨服多人副本

EventUtil.EARTH_SOUL = "EARTH_SOUL" --军魂之路
EventUtil.WAR_GROUP_FIELD = "WAR_GROUP_FIELD" --群战下一场
EventUtil.WAR_GROUP_END = "WAR_GROUP_END" -- 群战 结束
EventUtil.SEARCH_TREASURE = "SEARCH_TREASURE" -- 探宝
EventUtil.SHARE_SHOP = "SHARE_SHOP" -- 分享到appstore或者googlepay
EventUtil.SERVICE_WAR = "SERVICE_WAR" -- 跨服战刷新押注图标
EventUtil.SERVICE_WARVIEW = "SERVICE_WARVIEW"
EventUtil.GROUP_PURCHASE = "GROUP_PURCHASE"
EventUtil.LEGION_WAR = "LEGION_WAR" --跨服军团战刷新弹药储备逻辑
EventUtil.LEGION_WAR_ATT = "LEGION_WAR_ATT"--跨服军团战某个军团被击破刷新

EventUtil.XUNZHANG = "XUNZHANG"--勋章刷新界面

EventUtil.ATTACKBERLIN = "ATTACKBERLIN"--围攻柏林
EventUtil.ATTACKBERLIN1 = "ATTACKBERLIN1"--围攻柏林
EventUtil.ATTACKBERLIN2 = "ATTACKBERLIN2"
EventUtil.ATTACKBERLIN3 = "ATTACKBERLIN3"

EventUtil.HARDATTACK = "HARDATTACK" --战役困难模式
EventUtil.HARDATTACKTWO = "HARDATTACKTWO" --战役困难模式2
EventUtil.HARDATTACKTWOTHREE = "HARDATTACKTWOTHREE" --战役困难模式3

EventUtil.REFRESHMAINVIEW = "REFRESHMAINVIEW" --阵营战刷新主城
EventUtil.REFRESHCITY = "REFRESHCITY" --阵营战刷新某个城

EventUtil.TANK918 = "TANK918"

EventUtil.GREATEST_RACE_UPDATE = "greatest_race_update" -- 最强之战节点更新

EventUtil.dispatcher = cc.Director:getInstance():getEventDispatcher()

-- 增加一个事件监听
-- name: 事件名称
-- func: 事件回调
-- fixedPriority: 优化级, 默认为1
function EventUtil.add(name, func, fixedPriority)
    local listener = cc.EventListenerCustom:create(name, func)
    EventUtil.dispatcher:addEventListenerWithFixedPriority(listener, fixedPriority or 1)
    return listener
end

-- 删除一个事件监听
function EventUtil.remove(listener)
    if listener then
        EventUtil.dispatcher:removeEventListener(listener)
    end
end

-- 触发一个事件监听
function EventUtil.dispatch(name, usedata)
    local event = cc.EventCustom:new(name)
    event._usedata = usedata
    EventUtil.dispatcher:dispatchEvent(event)
end

return EventUtil
