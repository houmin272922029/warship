json = require "cjson"
print = function ( ... )
    local paramNum = select("#", ...)
    local str = "Lua Log: "
    for i=1,paramNum do
        local temp = select(i, ...)
        
        if temp then
            str = str .. "  " .. temp
        else
            str = str .. "  " .. "_nil_"
        end
    end


    CCLuaLog(str)
end

prt = function ( str )
    local ntime = str .. " : " .. os.clock()
    print(ntime)
end

require "lua/util/CCBReaderLoad"
require "lua/conf"

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

    if opPCL ~= IOS_KY_ZH and opPCL ~= IOS_KYPARK_ZH and opPCL ~= IOS_TEST_ZH and opPCL ~= ANDROID_TEST_ZH then

    print(" ---- else called ---- ")
        require "lua/util/netWork"
        require "lua/util/common"
        require "lua/util/commonEx"
        require "lua/util/userDefault"
        require "lua/util/SoundUtil"
        require "lua/util/Notification"
        require "lua/LoginView/LoginMainView"
        require "lua/LoginView/LoginUpdateLayer"
        require "lua/LoginView/LoginServerView"
        require "lua/LoginView/LoginModifyPwdLayer"
        require "lua/LoginView/LoginNewAccountLayer"
        require "lua/LoginView/LoginLoginLayer"
        require "lua/LoginView/LoginView"
        require "lua/SSO/sso"
        require "lua/UI/touchFeedbackLayer"
        require "lua/UI/loadingLayer"
        require "lua/Module/ConfigureStorage"
        require "lua/Module/userdata"
        require "lua/util/reqUtil"
        require "lua/UI/loginErrorPopUp"
        require "lua/util/OPAnimation"
        -- 根据渠道 区分语言
        if opPCL == IOS_VIETNAM_VI or opPCL == ANDROID_VIETNAM_VI then          -- 越南
            require "lua/Localizable-vn"
            -- require "lua/Localizable"
        elseif opPCL == WP_VIETNAM_VN then
            require "lua/Localizable-vn"
            require "lua/UI/VNRechargeLayer"
        elseif opPCL == WP_VIETNAM_EN then
            require "lua/Localizable-en"
            require "lua/UI/VNRechargeLayer"
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
            require "lua/Localizable-en"

        elseif opPCL == IOS_MOB_THAI or opPCL == ANDROID_VIETNAM_MOB_THAI  or opPCL == IOS_TGAME_TH or  opPCL == ANDROID_TGAME_THAI then          -- MOBGAME
            require "lua/Localizable-th"

        elseif opPCL == IOS_TGAME_KR or opPCL == ANDROID_TGAME_KR or opPCL == ANDROID_TGAME_KRNEW then          -- TGAME
            require "lua/Localizable-kr"

        elseif opPCL == IOS_GAMEVIEW_TC or opPCL == ANDROID_GV_MFACE_TC or opPCL == ANDROID_GV_MFACE_TC_GP or opPCL == ANDROID_JAGUAR_TC
        or opPCL == IOS_JAGUAR_TC  or opPCL == IOS_TGAME_TC or opPCL == ANDROID_TGAME_TC then          -- TGAME
            require "lua/Localizable-tc"

        elseif opPCL == IOS_INFIPLAY_RUS or opPCL == ANDROID_INFIPLAY_RUS then          -- 俄罗斯版
            require "lua/Localizable-rus"

        elseif opPCL == IOS_MOBGAME_SPAIN or opPCL == ANDROID_MOBGAME_SPAIN then          -- 西班牙版
            require "lua/Localizable-spain"

        else
            require "lua/Localizable"
        end
        _scene = CCScene:create()
        _scene:addChild(LoginLayer())
        preloadEffectMusic()
    elseif EnableUpdate and EnableUpdate == 1 then
        -- print(" ---- start update ---- ")
        require "lua/util/UpdateUtil"
        require "lua/util/netWork"
        require "lua/util/common"
        _scene = updateUtilFun()
    else
        -- print("reqFun() is called")
        require "lua/util/UpdateUtil"
        require "lua/util/netWork"
        require "lua/util/reqUtil"
        reqFun()
        -- print("reqFun() is called")
        _scene = CCScene:create()
        _scene:addChild(LoginLayer())
        preloadEffectMusic()
    end

    return _scene
end

CCDirector:sharedDirector():runWithScene(startSceneFun())
