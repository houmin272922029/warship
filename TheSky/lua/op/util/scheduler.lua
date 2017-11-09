--scheduler
-- module("scheduler", package.seeall)

callBackFunsTable1s = {
    refineCD = nil,
    userdata_timeTick = nil,
    plantTime = nil,
    totemTime = nil,
    farmInfoTipTime = nil,
    totemsTimerTick = nil,
    fieldsTimerTick = nil,
}

function time_tick(tickTime)
    userdata.loginTime = userdata.loginTime + tickTime
    -- 重置体力精力恢复时间
    if userdata.strength < userdata:getStrengthMax() and userdata.loginTime - userdata.strengthTime >= ConfigureStorage.strengthRecoverTime then
        local count = math.floor((userdata.loginTime - userdata.strengthTime) / ConfigureStorage.strengthRecoverTime)
        userdata.strength = userdata.strength + count
        if userdata.strength >= userdata:getStrengthMax() then
            userdata.strength = userdata:getStrengthMax()
            userdata.strengthTime = userdata.loginTime
        else
            userdata.strengthTime = userdata.strengthTime + ConfigureStorage.strengthRecoverTime * count
        end
        postNotification(NOTI_STRENGTH, nil)
    end
    if userdata.energy and userdata.energy < userdata:getEnergyMax() and userdata.loginTime - userdata.energyTime >= ConfigureStorage.energyRecoverTime then
        
        local count = math.floor((userdata.loginTime - userdata.energyTime) / ConfigureStorage.energyRecoverTime)
        userdata.energy = userdata.energy + count
        if userdata.energy >= userdata:getEnergyMax() then
            userdata.energy = userdata:getEnergyMax()
            userdata.energyTime = userdata.loginTime
        else
            userdata.energyTime = userdata.energyTime + ConfigureStorage.energyRecoverTime * count
        end
        postNotification(NOTI_ENERGY, nil)
    end
    -- local dic = dailyData.daily[Daily_SecretShop]
    local dic = dailyData:getMysteryShopData()
    if dic then
        if dic.interval == userdata.loginTime - dic.lastFlushTime then
            runtimeCache.isSecretShopRefresh = true
        end
    end
end

-- 每秒 定时器
local function timer_1s()
    time_tick(1)
    postNotification(NOTI_RECRUIT_CD_TIMER, nil)
    postNotification(NOTI_FANTASY_END_TIMER, nil)
    postNotification(NOTI_SAIL_SWEEP, nil)
    postNotification(NOTI_TITLE_INFO, nil)
    postNotification(NOTI_INSTRUCT, nil)
    postNotification(NOTI_PURCHASEAWARD, nil)
    postNotification(NOTI_GOLD_CLICK_ENDTIME_TIMER, nil)
    postNotification(NOTI_BOSS_BEGIN, nil)
    postNotification(NOTI_BOSS_RESURRECT, nil)
    postNotification(NOTI_BOSS_AUTO, nil)
    postNotification(NOTI_BOSS_CHALLENGE, nil)
    postNotification(NOTI_UNION_FINGER_TIMER, nil)
    postNotification(NOTI_TRINGSHADOW_CD_TIME, nil)
    postNotification(NOTI_CALMBELT_CD, nil)
    postNotification(NOTI_UNION_BATTLE, nil)
    postNotification(NOTI_REFLUSH_EXCHANGEACTIVITY_LAYER, nil)
    postNotification(NOTI_PURCHASEREBATE, nil)
    postNotification(NOTI_EXPENSEREBATE, nil)
    postNotification(NOTI_MYSTERYSHOP,nil)
    postNotification(NOTI_TICK, nil)
end

local function timer_3s()
    postNotification(NOTI_GOLD_CLICK_REFRESH_TIMER,nil)
end

local function timer_10s(  )
    postNotification(NOTI_REFRESH_ALLCHATDATA, nil)
    postNotification(NOTI_BOSS_LOG, nil)
end 

local function timer_40s()
    postNotification(NOTI_EAT_CD, nil)
    postNotification(NOTI_ARENA, nil)
    postNotification(NOTI_DAILY_STATUS, nil)
    postNotification(NOTI_ADVENTURE_STATUS, nil)
    postNotification(NOTI_RECRUIT_BTNUPDATE_REFRESH, nil)
    postNotification(NOTI_LOGINACTIVITY_NUMBERSTATUS, nil)
end

-- 10分钟定时器
local function timer_600s()
    -- body
    hotBalloonData:getHotBalloonData()
    topRollData:getTopRollDataFromServer()
    maildata:getMailList()
    dailyData:getsecretShopData()
end

-- 半小时定时器
local function timer_1800s()
end 

local tSecond1 = 0
local tSecond3 = 0
local tSecond10 = 0
local tSecond40 = 0
local tSecond600 = 0
local tSecond1800 = 0
local function timers_( dt )
    -- body
    if not dt then
        dt = 0
    end
    -- 每秒 方法
    tSecond1 = tSecond1 + dt
    if tSecond1 > 1 then
        tSecond1 = tSecond1 - 1
        timer_1s()
    end
    -- 3秒
    tSecond3 = tSecond3 + dt
    if tSecond3 > 3 then
        tSecond3 = tSecond3 - 3
        timer_3s()
    end

    -- 10秒
    tSecond10 = tSecond10 + dt
    if tSecond10 > 10 then
        tSecond10 = tSecond10 - 10
        timer_10s()
    end

    -- 40秒
    tSecond40 = tSecond40 + dt
    if tSecond40 > 40 then
        tSecond40 = tSecond40 - 40
        timer_40s()
    end

    -- 600秒 方法
    tSecond600 = tSecond600 + dt
    if tSecond600 > 600 then
        tSecond600 = tSecond600 - 600
        timer_600s()
    end

    -- 30分钟方法
    tSecond1800 = tSecond1800 + dt
    if tSecond1800 > 1800 then
        tSecond1800 = tSecond1800 - 1800
        timer_1800s()
    end
end

-- 公用定时器
function startTimer()
    -- body
    scheduler = CCDirector:sharedDirector():getScheduler()
    scehTimer = scheduler:scheduleScriptFunc(timers_, 0, bPause)
end

function endTimer(  )
    if scehTimer then
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(scehTimer)
        scehTimer = nil
    end
end

