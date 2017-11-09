-- CCUserDefault
KV_SEPERATOR = "----"
PAIR_SEPERATOR = "####"
UDefKey = {
    testKey = "test_key",

    -- SSO 相关存储
    KEY_LOCAL_UID = "sso_uid",
    KEY_LOCAL_PWD = "sso_pwd",
    KEY_LOCAL_NICKNAME = "sso_nickname",            -- 存储第三方平台的昵称
    -- SSO 相关存储 end

    kEY_LOCAL_DEFAULTSERVER = "default_server",

    KEY_LOCAL_GAME_DATE = "game_date",      -- 游戏home的时候存储当前游戏的日期

    -- Setting_HideSpecialSkill = "hideSpecialSkill",
    -- Setting_FightingSpeed = "fightingSpeed",
    -- Setting_SkipLevelStory = "skipLevelStory",
    Setting_PlayMusicSound = "playMusicSound",
    Setting_PlayMusicEffect = "playMusicEffect",
    Setting_WeiboAuthorized = "WeiBoAuth",
    Setting_WeiboShareButtonIsClicked = "weiboShareClick",
    Setting_WeiboUserId = "WeiboUserId",
    Seting_weiboToken = "WeiBoToken",

    Setting_BossAuto = "bossAuto", -- boss战自动挑战

    -- Setting_LastServerInfo = "lastServer",
    -- Setting_LocalNotificationCount = "localNotificationCount",
    -- Setting_LocalNotificationTime = "localNotificationTime",
    -- Setting_SinaWeiboAccessTokenInfo = "sinaweiboAccessToken",
    -- Setting_ResTsInfo = "resTs",
    -- Setting_IsRated = "isRated",
    -- Setting_Rate = "rate",
    -- Setting_AppleUuid = "appleUuid",
    -- Setting_AppVersionInfo = "appVersionInfo",
}

-- check UserDefault is existed
local function isUDExisted()
    -- body
    if not uDefault:getBoolForKey("isExisted") then
        uDefault:setBoolForKey("isExisted", true)
    end
end

-- UserDefault setStringForKey
function setUDString( key, value )
    -- body
    isUDExisted()

    uDefault:setStringForKey(key, value)
    uDefault:flush()
end

-- UserDefault getStringForKey
function getUDString( key )
    -- body
    return uDefault:getStringForKey(key)
end

-- UserDefault setIntegerForKey
function setUDInteger( key, value )
    -- body
    isUDExisted()

    uDefault:setIntegerForKey(key, value)
    uDefault:flush()
end

-- UserDefault getIntegerForKey
function getUDInteger( key )
    -- body
    return uDefault:getIntegerForKey(key)
end

-- UserDefault setDoubleForKey
function setUDDouble( key, value )
    -- body
    isUDExisted()

    uDefault:setDoubleForKey(key, value)
    uDefault:flush()
end

-- UserDefault getDoubleForKey
function getUDDouble( key )
    -- body
    return uDefault:getDoubleForKey(key)
end

-- UserDefault setFloatForKey
function setUDFloat( key, value )
    -- body
    isUDExisted()

    uDefault:setFloatForKey(key, value)
    uDefault:flush()
end

-- UserDefault getFloatForKey
function getUDFloat( key )
    -- body
    return uDefault:getFloatForKey(key)
end

-- UserDefault setBoolForKey
function setUDBool( key, value )
    -- body
    isUDExisted()

    uDefault:setBoolForKey(key, value)
    uDefault:flush()
end

-- UserDefault getBoolForKey
function getUDBool( key , bDefault)
    -- body
    if bDefault ~= nil then
        return uDefault:getBoolForKey(key, bDefault)
    end
    return uDefault:getBoolForKey(key, bDefault)
end

function setUDTable(key,valueTable)
    -- 把table转成string
    local tableString = ""
    for k,v in pairs(valueTable) do
        if tableString == "" then
            tableString = k..KV_SEPERATOR..v
        else
            tableString = tableString..PAIR_SEPERATOR..k..KV_SEPERATOR..v
        end
    end    

    isUDExisted()

    uDefault:setStringForKey(key,tableString)
    uDefault:flush()
end

function getUDTable(key)
    local tableString = uDefault:getStringForKey(key)
    
    if not tableString or tableString == "" then
        return nil
    end

    local kvArray = split(tableString,PAIR_SEPERATOR)
    local retTable = {}
    for i,kvPair in ipairs(kvArray) do
        local kv = split(kvPair,KV_SEPERATOR)
        retTable[kv[1]] = kv[2]
    end
    return retTable
end
