json = require "cjson"

require "lua/util/CCBReaderLoad"
require "lua/conf"

function newUpdate()
    if UpdateVer and UpdateVer == 2 then
        return true
    end
    return false
end

require "lua/addSearchPath"

--重新加载模块
function reloadGameModules()
    for i, name in ipairs(requiresTable) do
        package.loaded[name] = nil

        require(name)
    end
end

-- startTmp
function startSceneFun()
    -- 检查更新
    local _scene

    print(" ---- start print ---- ", EnableUpdate)
    local files = {
        "lua/util/netWork",
        "lua/util/common",
        "lua/util/commonEx",
        "lua/util/userDefault",
        "lua/util/SoundUtil",
        "lua/util/Notification",
        "lua/LoginView/LoginMainView",
        "lua/LoginView/LoginUpdateLayerV2",
        "lua/LoginView/LoginServerView",
        "lua/LoginView/LoginModifyPwdLayer",
        "lua/LoginView/LoginNewAccountLayer",
        "lua/LoginView/LoginLoginLayer",
        "lua/LoginView/LoginView",
        "lua/SSO/sso",
        "lua/UI/touchFeedbackLayer",
        "lua/UI/loadingLayer",
        "lua/Module/ConfigureStorage",
        "lua/Module/userdata",
        "lua/util/reqUtil",
        "lua/UI/loginErrorPopUp",
        "lua/util/OPAnimation"
    }

    -- 根据渠道 区分语言
    if opPCL == IOS_VIETNAM_VI or opPCL == ANDROID_VIETNAM_VI then          -- 越南
        table.insert(files, "lua/Localizable-vn")

    elseif opPCL == IOS_VIETNAM_EN 
        or opPCL == IOS_VIETNAM_ENSAGA
        or opPCL == IOS_MOBNAPPLE_EN 
        or opPCL == IOS_GAMEVIEW_EN 
        or opPCL == IOS_GVEN_BREAK
        or opPCL == ANDROID_VIETNAM_EN 
        or opPCL == ANDROID_GV_MFACE_EN 
        or opPCL == ANDROID_GV_MFACE_EN_OUMEI
        or opPCL == ANDROID_GV_MFACE_EN_OUMEINEW
        or opPCL == ANDROID_VIETNAM_EN_ALL then
        table.insert(files, "lua/Localizable-en")

    elseif opPCL == IOS_MOB_THAI or opPCL == ANDROID_VIETNAM_MOB_THAI or opPCL == IOS_TGAME_TH or opPCL == ANDROID_TGAME_THAI then          -- MOBGAME

        table.insert(files, "lua/Localizable-th")

    elseif opPCL == IOS_TGAME_KR or opPCL == ANDROID_TGAME_KR or opPCL == ANDROID_TGAME_KRNEW then          -- TGAME

        table.insert(files, "lua/Localizable-kr")

    elseif opPCL == IOS_GAMEVIEW_TC or opPCL == ANDROID_GV_MFACE_TC or opPCL == ANDROID_GV_MFACE_TC_GP or opPCL == ANDROID_JAGUAR_TC
        or opPCL == IOS_JAGUAR_TC or opPCL == IOS_TGAME_TC or opPCL == ANDROID_TGAME_TC then          -- TGAME

        table.insert(files, "lua/Localizable-tc")

    elseif opPCL == IOS_INFIPLAY_RUS or opPCL == ANDROID_INFIPLAY_RUS then          -- 俄罗斯版

        table.insert(files, "lua/Localizable-rus")

    elseif opPCL == IOS_MOBGAME_SPAIN or opPCL == ANDROID_MOBGAME_SPAIN then          -- 西班牙版
        table.insert(files, "lua/Localizable-spain")
    elseif opPCL == WP_VIETNAM_VN then
        require "lua/Localizable-vn"
        require "lua/UI/VNRechargeLayer"
    elseif opPCL == WP_VIETNAM_EN then
        require "lua/Localizable-en"
        require "lua/UI/VNRechargeLayer"

    else

        table.insert(files, "lua/Localizable")
    end

    for i,v in ipairs(files) do
        package.loaded[v] = nil
        require(v)
    end

    _scene = CCScene:create()
    _scene:addChild(LoginLayer())
    preloadEffectMusic()

    return _scene
end

if CCDirector:sharedDirector():getRunningScene() then
    CCDirector:sharedDirector():replaceScene(startSceneFun())
else
    CCDirector:sharedDirector():runWithScene(startSceneFun())
end
