--[[
    基础工具类。目前包括一些 字符串、table 的扩展处理
    修改了部分方法名，如 split 修改为 string.split 加了前缀 以便增加可读性！
--]]

LANG_TYPE = {
    zh = 1,
    en = 2,
    vn = 3,
    kr = 4,
    th = 5,
    rus = 6,
    spain = 7,
}

function langType()
    if isPlatform(IOS_TEST_ZH)
        or isPlatform(ANDROID_TEST_ZH)
        or isPlatform(ANDROID_BAIDU_ZH)
        or isPlatform(ANDROID_MM_ZH)
        or isPlatform(ANDROID_BAIDUIAPPPAY_ZH)
        or isPlatform(ANDROID_MMY_ZH)
        or isPlatform(IOS_TGAME_ZH)
        or isPlatform(IOS_TW_ZH)
        or isPlatform(ANDROID_TW_ZH)
        or isPlatform(IOS_APPLE_ZH)
        or isPlatform(IOS_91_ZH)
        or isPlatform(IOS_KY_ZH)
        or isPlatform(IOS_KYPARK_ZH)
        or isPlatform(IOS_PPZS_ZH)
        or isPlatform(IOS_PPZSPARK_ZH)
        or isPlatform(IOS_ITOOLS)
        or isPlatform(IOS_ITOOLSPARK)
        or isPlatform(ANDROID_AGAME_ZH)
        or isPlatform(ANDROID_91_ZH)
        or isPlatform(ANDROID_DK_ZH)
        or isPlatform(ANDROID_WDJ_ZH)
        or isPlatform(ANDROID_XIAOMI_ZH)
        or isPlatform(ANDROID_UC_ZH)
        or isPlatform(IOS_TBT_ZH)
        or isPlatform(IOS_TBTPARK_ZH) 
        or isPlatform(ANDROID_360_ZH)
        or isPlatform(ANDROID_GV_MFACE_ZH)
        or isPlatform(ANDROID_GV_XJP_ZH)
        or isPlatform(IOS_GAMEVIEW_ZH)
        or isPlatform(ANDROID_GV_MFACE_TC)
        or isPlatform(ANDROID_OPPO_ZH) 
        or isPlatform(ANDROID_DOWNJOY_ZH)
        or isPlatform(IOS_DOWNJOYPARK_ZH)
        or isPlatform(ANDROID_HUAWEI_ZH)
        or isPlatform(IOS_GAMEVIEW_TC)
        or isPlatform(ANDROID_COOLPAY_ZH) 
        or isPlatform(ANDROID_GIONEE_ZH)
        or isPlatform(ANDROID_TGAME_ZH)
        or isPlatform(ANDROID_ANFENG_ZH)
        or isPlatform(ANDROID_HTC_ZH)
        or isPlatform(ANDROID_GV_MFACE_TC_GP)
        or isPlatform(ANDROID_JAGUAR_TC)
        or isPlatform(ANDROID_XYZS_ZH) 
        or isPlatform(IOS_TGAME_TC)
        or isPlatform(IOS_TGAME_TH)
        or isPlatform(IOS_XYZS_ZH)
        or isPlatform(ANDROID_TGAME_TC) then  

        return LANG_TYPE.zh

    elseif isPlatform(IOS_VIETNAM_VI)
        or isPlatform(ANDROID_VIETNAM_VI)
        or isPlatform(WP_VIETNAM_VN)
        or isPlatform(WP_VIETNAM_EN) then

        return LANG_TYPE.vn

    elseif isPlatform(IOS_VIETNAM_EN) 
        or isPlatform(IOS_VIETNAM_ENSAGA)
        or isPlatform(IOS_MOBNAPPLE_EN)
        or isPlatform(ANDROID_GV_MFACE_EN)
        or isPlatform(ANDROID_GV_MFACE_EN_OUMEI)
        or isPlatform(ANDROID_GV_MFACE_EN_OUMEINEW)
        or isPlatform(IOS_GAMEVIEW_EN)
        or isPlatform(IOS_GVEN_BREAK)
        or isPlatform(ANDROID_VIETNAM_EN)
        or isPlatform(ANDROID_VIETNAM_EN_ALL)
        or isPlatform(WP_VIETNAM_EN) then

        return LANG_TYPE.en
    elseif isPlatform(IOS_MOB_THAI) or isPlatform(ANDROID_VIETNAM_MOB_THAI) or isPlatform(ANDROID_TGAME_THAI) then

        return LANG_TYPE.th

    elseif isPlatform(ANDROID_TGAME_KR) or isPlatform(ANDROID_TGAME_KRNEW)
     or isPlatform(IOS_TGAME_KR) then

         return LANG_TYPE.kr

    elseif isPlatform(IOS_INFIPLAY_RUS)
     or isPlatform(ANDROID_INFIPLAY_RUS) then
        return LANG_TYPE.rus

    elseif isPlatform(IOS_MOBGAME_SPAIN) or isPlatform(ANDROID_MOBGAME_SPAIN) then
        return LANG_TYPE.spain
    end
end

function onPlatform(platform)
    return havePrefix(string.split(opPCL, "_")[2], platform)
end

