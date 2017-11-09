local _layer = nil
local _isNewer = false

LoginMainOwner = LoginMainOwner or {}
ccb["LoginMainOwner"] = LoginMainOwner

local function menuEnabled(enable)
    local menu = tolua.cast(LoginMainOwner["menu"], "CCMenu")
    menu:setTouchEnabled(enable)
end

local function init()
    print("init...",opPCL)
    local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
    cache:addSpriteFramesWithFile("ccbResources/shadow.plist")
    
    local  proxy = CCBProxy:create()
    local  node
    node = CCBReaderLoad("ccbResources/LoginMainView.ccbi",proxy,true,"LoginMainOwner")
    _layer = tolua.cast(node,"CCLayer")

    local versionLabel = tolua.cast(LoginMainOwner["version"],"CCLabelTTF")
    versionLabel:enableShadow(CCSizeMake(2,-2), 1, 0)
    if versionLabel then

        local CFBundleVersion = uDefault:getStringForKey(opPCL.."_ver")
        versionLabel:setString(string.format("%s (%s)", CFBundleVersion, opVersion))
        -- if isPlatform(IOS_KY_ZH) then
        --     --[[ 
        --         快用提交大版本记得修改
        --     ]]
        --     versionLabel:setString("v 3.0")
        -- else
        --     versionLabel:setString(string.format("v %s", opVersion))
        -- end
    end

    if isPlatform(IOS_TEST_ZH) 
        or isPlatform(ANDROID_TEST_ZH) 
        or isPlatform(IOS_TW_ZH) 
        or isPlatform(ANDROID_TW_ZH)
        or isPlatform(IOS_APPLE_ZH) 
        or isPlatform(IOS_APPLE2_ZH) then

        menuEnabled(false)

    end
    
    local logo = tolua.cast(LoginMainOwner["logo"], "CCSprite")
    if isPlatform(IOS_APPLE2_ZH) 
        or isPlatform(IOS_KY_ZH) 
        or isPlatform(IOS_ITOOLS)
        or isPlatform(IOS_PPZS_ZH) 
        or isPlatform(IOS_PPZSPARK_ZH)
        or isPlatform(ANDROID_AGAME_ZH) 
        or isPlatform(IOS_91_ZH) 
        or isPlatform(ANDROID_91_ZH) 
        or isPlatform(ANDROID_360_ZH) 
        or isPlatform(ANDROID_WDJ_ZH) 
        or isPlatform(ANDROID_MMY_ZH)
        or isPlatform(ANDROID_HUAWEI_ZH)
        or isPlatform(IOS_TBT_ZH)
        or isPlatform(IOS_AISI_ZH)
        or isPlatform(ANDROID_COOLPAY_ZH)
        or isPlatform(ANDROID_GIONEE_ZH)
        or isPlatform(ANDROID_MYEPAY_ZH)
        or isPlatform(ANDROID_HTC_ZH) then

         if isSpringFestival then
            CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/springLogo.plist")
            logo:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("springLogo.png"))         
        else
            CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/tiantianLogo.plist")
            logo:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tiantianLogo.png"))
        end

    elseif isPlatform(ANDROID_GV_MFACE_ZH) 
        or isPlatform(ANDROID_GV_MFACE_EN) 
        or isPlatform(ANDROID_GV_MFACE_EN_OUMEI)
        or isPlatform(ANDROID_GV_MFACE_EN_OUMEINEW)
        or isPlatform(IOS_GAMEVIEW_EN)
        or isPlatform(IOS_GVEN_BREAK)
        or isPlatform(IOS_GAMEVIEW_ZH) then

        if isSpringFestival and (isPlatform(ANDROID_GV_MFACE_EN) or isPlatform(ANDROID_GV_MFACE_EN_OUMEI) or isPlatform(ANDROID_GV_MFACE_EN_OUMEINEW) or isPlatform(IOS_GAMEVIEW_EN)
        or isPlatform(IOS_GVEN_BREAK)) then
            CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/springLogo.plist")
            logo:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("gvSpringLogo.png"))         
        else
            CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/mfaceLogo.plist")
            logo:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("mfaceLogo.png"))
        end

    elseif isPlatform(IOS_MOBNAPPLE_EN) or isPlatform(ANDROID_VIETNAM_EN_ALL) or isPlatform(ANDROID_VIETNAM_EN) then --songjing vietnam en 第二个

        if isSpringFestival then
            CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/springLogo.plist")
            logo:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("pfSpringLogo.png"))         
        else
            -- CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/login.plist")
            logo:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("logo_1.png"))
        end
    elseif isPlatform(ANDROID_JAGUAR_TC) then
        --todo
        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/lbLogo.plist")
        --local logo = tolua.cast(LoginLoginOwner["logo"], "CCSprite")
        logo:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("lbLogo.png")) 
           
    elseif isPlatform(ANDROID_GV_XJP_ZH)
        or isPlatform(ANDROID_GV_MFACE_TC)
        or isPlatform(IOS_GAMEVIEW_TC)
        or isPlatform(ANDROID_GV_MFACE_TC_GP) then

        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/mfaceLogo2.plist")
        local logo = tolua.cast(LoginMainOwner["logo"], "CCSprite")
        logo:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("mfaceLogo2.png"))

    elseif isPlatform(ANDROID_BAIDU_ZH) 
        or isPlatform(ANDROID_BAIDUIAPPPAY_ZH)
        or isPlatform(ANDROID_MM_ZH)
        or isPlatform(ANDROID_XIAOMI_ZH) 
        or isPlatform(ANDROID_OPPO_ZH) 
        or isPlatform(ANDROID_UC_ZH) then

        if isSpringFestival then
            CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/springLogo.plist")
            logo:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("springLogo.png"))         
        else
            CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/daLogo.plist")
            logo:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("daLogo.png"))
        end

    elseif isPlatform(IOS_IIAPPLE_ZH) or isPlatform(IOS_KYPARK_ZH) or isPlatform(ANDROID_KY_ZH) or isPlatform(IOS_TBTPARK_ZH) 
        or isPlatform(IOS_ITOOLSPARK) or isPlatform(IOS_HAIMA_ZH) or isPlatform(IOS_XYZS_ZH) or isPlatform(ANDROID_XYZS_ZH) or isPlatform(IOS_AISIPARK_ZH)
        or isPlatform(IOS_DOWNJOYPARK_ZH) or isPlatform(ANDROID_DOWNJOY_ZH) then

        if isSpringFestival then
            CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/springLogo.plist")
            logo:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("springLogo.png"))         
        else
            CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/iappleLogo.plist")
            logo:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("iapple_logo.png"))
        end
    elseif isPlatform(IOS_TGAME_TC) or isPlatform(ANDROID_TGAME_TC) then
        if isSpringFestival then
            CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/springLogo.plist")
            logo:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("springLogo.png"))         
        else
            CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/tgTcLogo.plist")
            logo:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tgTcLogo.png"))
        end
    elseif isPlatform(IOS_TGAME_TH) or isPlatform(ANDROID_TGAME_THAI) then
        if isSpringFestival then
            CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/springLogo.plist")
            logo:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("springLogo.png"))         
        else
            CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/tgthaiLogo.plist")
            logo:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tgthaiLogo.png"))
        end
    else
        if isSpringFestival then
            CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/springLogo.plist")
            logo:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("springLogo.png")) 
        end
    end
end
-- 配置文件下载完毕
local function downloadFinished()
    
    loadAllConfigureFile()
    -- 处理新手
    runtimeCache.firstIn = 1
    if _isNewer then
        runtimeCache.opAniStep = userdata:getVipAuditState() and 16 or 1
        if platformType() == PLATFORM_TYPE["9158"] then
            -- Global:TDGAcpaLoginSuc(userdata.userId)
        end 
        CCDirector:sharedDirector():replaceScene(CCTransitionFade:create(0.6, OPSceneFun()))
        return
    else
        startTimer()
        -- print("login success userid")
        if platformType() == PLATFORM_TYPE["9158"] then
            -- Global:TDGAcpaLoginSuc(userdata.userId)
        end 

                CCSpriteFrameCache:sharedSpriteFrameCache():removeUnusedSpriteFrames()
                CCTextureCache:sharedTextureCache():removeUnusedTextures()
        CCDirector:sharedDirector():replaceScene(CCTransitionFade:create(0.6, mainSceneFun()))

    end
    -- _shopData = shopData:getCashShopData()
    -- for i,v in ipairs(_shopData) do
    --     print(i,v)
    --     print(v["itemId"])
    -- end
end

-- 新号，则强制下一个配置文件，然后再走注册流程
local function _userNotFound()
    _isNewer = true
    doDownLoadConf("CONFIGURE_URL", CONF_PATH..CONF_FILE_NAME, downloadFinished)
end

local function loginCallBack(url, rtnData)
    print("login main view logincall back")
     local rtnCode = rtnData["code"]
    -- code 判断
    if rtnCode == ErrorCodeTable.ERR_1207 then
        print("user not found")
        -- 360
        if isPlatform(ANDROID_360_ZH) then
            SSOPlatform.setToken(rtnData.info)
        end
        _userNotFound()
        return
    end

    local rtnInfo = rtnData["info"]

    if not rtnInfo then
        return
    end

    userdata:fromDictionary(rtnInfo)

    -- 配置文件处理
    -- print(" ----------------- writePath ------ ",CONF_PATH)
    -- if fileUtil:isFileExist(CONF_PATH..CONF_FILE_NAME) then
    --     -- 读取配置文件
    --     loadAllConfigureFile()
    --     print(" -------- conf version -------- ", ConfigureStorage.version, userdata.servConfVersion)
    --     if ConfigureStorage.version ~= userdata.servConfVersion then
    --         -- 下载配置文件
    --         doDownLoadConf("CONFIGURE_URL", CONF_PATH..CONF_FILE_NAME, downloadFinished)
    --     else
    --         -- 跳转主场景
    --         -- 启动定时器
    --         runtimeCache.firstIn = 1
    --         startTimer()
    --         -- if opPCL == IOS_91_ZH then
    --         --     Global:SSOShowUserIcon(false)
    --         -- end
    --         print("tdga login succ")
    --         if platformType() == PLATFORM_TYPE["9158"] then
    --             -- Global:TDGAcpaLoginSuc(userdata.userId)
    --         end
    --         CCDirector:sharedDirector():replaceScene(CCTransitionFade:create(0.6, mainSceneFun()))
    --     end
    -- else
    --     -- 下载配置文件
        print("---- print meiyou peizhi wenjian ?????? -----loginmainview.lua- ")
        doDownLoadConf("CONFIGURE_URL", CONF_PATH..CONF_FILE_NAME, downloadFinished)
    -- end
end

local function loginError(url, rtnData)
    -- postNotification(HL_SSO_ERROR, nil) 
end

local function loginItemClick()
    -- ShowText(HLNSLocalizedString("sso.pwd.null"))
    if isPlatform(IOS_KY_ZH)    
        or isPlatform(IOS_KYPARK_ZH)
        or isPlatform(ANDROID_KY_ZH) 
        or isPlatform(IOS_PPZS_ZH) 
        or isPlatform(IOS_PPZSPARK_ZH)
        or isPlatform(IOS_XYZS_ZH)
        or isPlatform(ANDROID_XYZS_ZH)
        or isPlatform(ANDROID_UC_ZH)  
        or isPlatform(ANDROID_GV_MFACE_ZH) 
        or isPlatform(ANDROID_GV_MFACE_EN) 
        or isPlatform(ANDROID_GV_MFACE_EN_OUMEI)
        or isPlatform(ANDROID_GV_MFACE_EN_OUMEINEW)
        or isPlatform(IOS_GAMEVIEW_ZH) 
        or isPlatform(IOS_GAMEVIEW_EN) 
        or isPlatform(IOS_GVEN_BREAK) 
        or isPlatform(ANDROID_GV_XJP_ZH)
        or isPlatform(ANDROID_GV_MFACE_TC)
        or isPlatform(IOS_GAMEVIEW_TC)
        or isPlatform(ANDROID_GV_MFACE_TC_GP)
        or isPlatform(IOS_AISI_ZH)
        or isPlatform(IOS_AISIPARK_ZH)
        or isPlatform(IOS_DOWNJOYPARK_ZH)
        or isPlatform(ANDROID_DOWNJOY_ZH)
        or isPlatform(IOS_TBT_ZH) 
        or isPlatform(IOS_TBTPARK_ZH) 
        or isPlatform(IOS_HAIMA_ZH) then

        tpSSOLogin({}, "ssoLoginSucc", "ssoLoginFail")

    elseif isPlatform(ANDROID_360_ZH)
        or isPlatform(ANDROID_HUAWEI_ZH)
        or isPlatform(ANDROID_ANFENG_ZH)
        or isPlatform(ANDROID_GIONEE_ZH) then

        local function loginAfterlogout()
            tpSSOLogin({}, "ssoLoginSucc", "ssoLoginFail")
        end
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(1.0), CCCallFunc:create(loginAfterlogout))
        _layer:runAction(seq)

    elseif isPlatform(IOS_ITOOLS) or isPlatform(IOS_ITOOLSPARK) then        
        
        if string.len(SSOPlatform.GetUid()) > 0 then
            -- 用户已经登陆
            Global:SSOCenter()
        else
            -- 用户没有登陆
            tpSSOLogin({}, "ssoLoginSucc", "ssoLoginFail")
        end

    elseif isPlatform(IOS_91_ZH) 
        or isPlatform(ANDROID_91_ZH) then

        if string.len(SSOPlatform.GetUid()) > 0 then
            -- 用户已经登陆
            Global:SSOCenter()
        else
            -- 用户没有登陆
            local function loginAfterLogout()
                --body
                tpSSOLogin({}, "ssoLoginSucc", "ssoLoginFail")
            end
            local seq = CCSequence:createWithTwoActions(CCDelayTime:create(1.0), CCCallFunc:create(loginAfterLogout))
            _layer:runAction(seq)
        end

    elseif isPlatform(ANDROID_XIAOMI_ZH) 
        or isPlatform(ANDROID_WDJ_ZH) 
        or isPlatform(ANDROID_DK_ZH) then

        if string.len(SSOPlatform.GetUid()) > 0 then
            -- 用户已经登陆
            Global:SSOLogout(nil, nil)
            userdata:resetAllData()
            SSOPlatform.setSid(nil)
            SSOPlatform.setUid(nil)
            SSOPlatform.setNickname(nil)
            local function loginAfterLogout()
                --body
                tpSSOLogin({}, "ssoLoginXiaoMiSucc", "ssoLoginFail")
            end
            local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(loginAfterLogout))
            _layer:runAction(seq)
        else
            -- 用户没有登陆
            local function relogin()
                --body
                tpSSOLogin({}, "ssoLoginXiaoMiSucc", "ssoLoginFail")
            end
            local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(relogin))
            _layer:runAction(seq)
        end

    elseif isPlatform(ANDROID_OPPO_ZH) then

        if string.len(SSOPlatform.GetUid()) > 0 then
            print("android oppo zh > 0 ")
            userdata:resetAllData()
            SSOPlatform.setSid(nil)
            SSOPlatform.setUid(nil)
            SSOPlatform.setNickname(nil)
            SSOPlatform.setSecret(nil)
            tpSSOLogin({}, "ssoLoginOPPOSucc", "ssoLoginFail")
        else
            tpSSOLogin({}, "ssoLoginOPPOSucc", "ssoLoginFail")
        end

    elseif isPlatform(ANDROID_MMY_ZH) then

        if string.len(SSOPlatform.GetUid()) > 0 then
            print("android oppo zh > 0 ")
            userdata:resetAllData()
            SSOPlatform.setSid(nil)
            SSOPlatform.setUid(nil)
            SSOPlatform.setNickname(nil)
            SSOPlatform.setToken(nil)
            tpSSOLogin({}, "ssoLoginSucc", "ssoLoginFail")
        else
            tpSSOLogin({}, "ssoLoginSucc", "ssoLoginFail")
        end

    elseif isPlatform(IOS_VIETNAM_VI) 
        or isPlatform(IOS_VIETNAM_EN) 
        or isPlatform(IOS_VIETNAM_ENSAGA) 
        or isPlatform(IOS_MOBNAPPLE_EN)
        or isPlatform(IOS_MOB_THAI)
        or isPlatform(ANDROID_BAIDU_ZH)
        or isPlatform(ANDROID_BAIDUIAPPPAY_ZH) 
        or isPlatform(ANDROID_MM_ZH) 
        or isPlatform(ANDROID_VIETNAM_MOB_THAI)
        or isPlatform(ANDROID_VIETNAM_VI) 
        or isPlatform(ANDROID_VIETNAM_EN)
        or isPlatform(ANDROID_VIETNAM_EN_ALL) 
        or isPlatform(IOS_MOBGAME_SPAIN)
        or isPlatform(ANDROID_MOBGAME_SPAIN)  
        or isPlatform(ANDROID_COOLPAY_ZH)
        or onPlatform("TGAME")
        or onPlatform("HTC")
        or isPlatform(ANDROID_MYEPAY_ZH) then

        Global:SSOLogout("logOutSuccCallBack", "logOutFailCallBack")
        tpSSOLogin({}, "ssoLoginSucc", "ssoLoginFail")

    elseif isPlatform(ANDROID_JAGUAR_TC) then
        Global:SSOLogout("logOutSuccCallBack", "logOutFailCallBack")
        local function relogin()
            tpSSOLogin({}, "ssoLoginSucc", "ssoLoginFail")
        end
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(1), CCCallFunc:create(relogin))
        _layer:runAction(seq)

    elseif isPlatform(ANDROID_AGAME_ZH) then

    	tpSSOLogin({}, "ssoLoginSucc", "ssoLoginFail")

    elseif isPlatform(IOS_IIAPPLE_ZH) then

        if string.len(SSOPlatform.GetUid()) > 0 then

            Global:SSOLogout()
            local function loginAfterLogout()
                tpSSOLogin({}, "ssoLoginSucc", "ssoLoginFail")
            end
            local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(loginAfterLogout))
            _layer:runAction(seq)
        else
            tpSSOLogin({}, "ssoLoginSucc", "ssoLoginFail")
        end

    else

        getLoginLayer():showLogin()

    end
    if isPlatform(IOS_AISI_ZH) then
        getLoginMainLayer():menuEnabled(false)
    end
end
LoginMainOwner["loginItemClick"] = loginItemClick

local function serverItemClick()
    if getServerListCount() > 0 then
        getLoginLayer():showServer()
    else
        if isPlatform(IOS_VIETNAM_VI) 
        or isPlatform(IOS_VIETNAM_EN) 
        or isPlatform(IOS_VIETNAM_ENSAGA) 
        or isPlatform(IOS_MOBNAPPLE_EN)
        or isPlatform(IOS_MOB_THAI)
        or isPlatform(ANDROID_VIETNAM_MOB_THAI)
        or isPlatform(ANDROID_VIETNAM_VI)
        or isPlatform(ANDROID_VIETNAM_EN)
        or isPlatform(ANDROID_VIETNAM_EN_ALL)
        or isPlatform(IOS_MOBGAME_SPAIN)
        or isPlatform(ANDROID_MOBGAME_SPAIN)   then

            if not Global:getUid() or string.len(Global:getUid()) <= 0 then
                tpSSOLogin({}, "ssoLoginSucc", "ssoLoginFail")
                return
            end

        elseif onPlatform("TGAME")
            or onPlatform("HTC")
            or isPlatform(ANDROID_MYEPAY_ZH)
            or isPlatform(IOS_IIAPPLE_ZH)
            or isPlatform(IOS_TBTPARK_ZH)
            or isPlatform(IOS_AISIPARK_ZH)
            or isPlatform(IOS_DOWNJOYPARK_ZH)
            or isPlatform(ANDROID_DOWNJOY_ZH)
            or isPlatform(IOS_HAIMA_ZH) then

            print("serverItemClick  only called login")
            tpSSOLogin({}, "ssoLoginSucc", "ssoLoginFail")

        elseif isPlatform(IOS_INFIPLAY_RUS) or isPlatform(ANDROID_INFIPLAY_RUS) then
            getLoginLayer():showLogin()
        elseif isPlatform(WP_VIETNAM_VN) then
            getLoginLayer():showLogin()
        elseif isPlatform(WP_VIETNAM_EN) then
            getLoginLayer():showLogin()
        end
    end
end
LoginMainOwner["serverItemClick"] = serverItemClick

-- 91登陆方法
function play91Click(  )
    if string.len(SSOPlatform.GetUid()) > 0 then
        local params = {}
        if isPlatform(IOS_91_ZH) 
            or isPlatform(ANDROID_91_ZH) then

            table.insert(params, SSOPlatform.GetUid())

        end
        table.insert(params, SSOPlatform.GetSid())
        local params1 = {}
        table.insert(params1, params)
        doActionFun("LOGIN_URL", params1, loginCallBack, loginError)

    else
        tpSSOLogin({}, "ssoLogin91Succ", "ssoLoginFail")
    end 
end

--登陆游戏

-- local function playClick()
--     print(" Print by lixq ---- get some info !!!")
--     print(" Print by lixq ---- getMACInfo:" .. Global:getMACInfo())
--     print(" Print by lixq ---- getIDFAInfo:" .. Global:getIDFAInfo())
--     print(" Print by lixq ---- getCurrSysVer:" .. Global:getCurrSysVer())
--     print(" Print by lixq ---- getOpenUUIDInfo:" .. Global:getOpenUUIDInfo())

-- end


local function playClick()
    print("playclick start")
    Global:instance():TDGAonEventAndEventData("start")
    if isPlatform(IOS_VIETNAM_VI) 
        or isPlatform(IOS_VIETNAM_EN) 
        or isPlatform(IOS_VIETNAM_ENSAGA) 
        or isPlatform(IOS_MOB_THAI)
        or isPlatform(IOS_MOBNAPPLE_EN)
        or isPlatform(ANDROID_VIETNAM_MOB_THAI)
        or isPlatform(ANDROID_VIETNAM_VI)
        or isPlatform(ANDROID_VIETNAM_EN)
        or isPlatform(ANDROID_VIETNAM_EN_ALL)
        or isPlatform(IOS_MOBGAME_SPAIN)
        or isPlatform(ANDROID_MOBGAME_SPAIN) then

        if not Global:getUid() or string.len(Global:getUid()) <= 0 then

            tpSSOLogin({}, "ssoLoginSucc", "ssoLoginFail")
            return
        end

    else 
        if not SSOPlatform.GetUid() or string.len(SSOPlatform.GetUid()) <= 0 then

            if isPlatform(IOS_91_ZH) 
                or isPlatform(ANDROID_91_ZH) then

                tpSSOLogin({}, "ssoLogin91Succ", "ssoLoginFail")

            elseif isPlatform(ANDROID_XIAOMI_ZH) then

                tpSSOLogin({}, "ssoLoginXiaoMiSucc", "ssoLoginFail")
                
            elseif isPlatform(IOS_INFIPLAY_RUS) or isPlatform(ANDROID_INFIPLAY_RUS) then
                getLoginLayer():showLogin()
            elseif isPlatform(WP_VIETNAM_VN) then
                getLoginLayer():showLogin()
            elseif isPlatform(WP_VIETNAM_EN) then
                getLoginLayer():showLogin()
            else

                tpSSOLogin({}, "ssoLoginSucc", "ssoLoginFail")

            end
            return
        end 
    end
    
    print("一些可爱的数据",SSOPlatform.GetUid(), SSOPlatform.GetSid())
    if not userdata.selectServer or not userdata.serverCode then
        if getServerListCount() <= 0 then

            if isPlatform(IOS_91_ZH) 
                or isPlatform(ANDROID_91_ZH) then

                tpSSOLogin({}, "ssoLogin91Succ", "ssoLoginFail")

            elseif isPlatform(ANDROID_XIAOMI_ZH) then

                tpSSOLogin({}, "ssoLoginXiaoMiSucc", "ssoLoginFail")

            else

                tpSSOLogin({}, "ssoLoginSucc", "ssoLoginFail")

            end
        else
            getLoginLayer():showServer()
        end
        return
    end

    -- 如果所选服务器为维护状态，则弹出提示
    if userdata.selectServer.status == 4 then
        ShowText(HLNSLocalizedString("ERR_800"))
        return
    end 

    -- 新版更新流程
--        print("playclick 11")
    if not isPlatform(IOS_KY_ZH) and not isPlatform(ANDROID_TEST_ZH) then

       -- print("playclick 22")
        if EnableUpdate and EnableUpdate == 1 then
            getLoginLayer():showUpdate()
            return
        else
       -- print("playclick 33")
            require "lua/util/reqUtil"
            reqFun()
        end
        
    end
       -- print("playclick 44")
    postNotification(NOTI_LOGIN_GAME, nil)
end
LoginMainOwner["playClick"] = playClick

local function refreshUid()
    if SSOPlatform.GetUid() then
        local accountIcon = tolua.cast(LoginMainOwner["accountIcon"], "CCSprite")
        accountIcon:setVisible(false)
        local accountLabel = tolua.cast(LoginMainOwner["accountLabel"], "CCLabelTTF")

        if isPlatform(IOS_TEST_ZH) 
            or isPlatform(ANDROID_TEST_ZH) 
            or isPlatform(IOS_TW_ZH) 
            or isPlatform(ANDROID_TW_ZH)
            or isPlatform(IOS_APPLE_ZH)
            or isPlatform(IOS_APPLE2_ZH)
            or isPlatform(IOS_INFIPLAY_RUS) or isPlatform(ANDROID_INFIPLAY_RUS)
            or isPlatform(WP_VIETNAM_VN)
            or isPlatform(WP_VIETNAM_EN) then

            if SSOPlatform.IsTourist() then
                accountLabel:setString(HLNSLocalizedString("login.tourist"))
            else
                accountLabel:setString(SSOPlatform.GetUid())
            end        

        elseif isPlatform(ANDROID_AGAME_ZH) then

            accountLabel:setString("账号登陆")

        elseif onPlatform("TGAME")
            or onPlatform("HTC")
            or isPlatform(ANDROID_MYEPAY_ZH) then
            
            accountLabel:setString(SSOPlatform.GetNickname())
            
        else 
            print("LoginMainView refreshUid " .. SSOPlatform.GetNickname())
            accountLabel:setString(SSOPlatform.GetNickname())

        end 
        accountLabel:setVisible(true)

        if isPlatform(ANDROID_VIETNAM_VI) 
            or isPlatform(ANDROID_VIETNAM_MOB_THAI)
            or isPlatform(ANDROID_VIETNAM_EN)
            or isPlatform(ANDROID_VIETNAM_EN_ALL) then

            Global:checkVnLogin()
            
        end
    end
end

local function refreshServerList()
    if userdata.selectServer then
        local server = userdata.selectServer
        local serverLabel = tolua.cast(LoginMainOwner["serverLabel"], "CCLabelTTF")
        serverLabel:setString(server.serverName)
        serverLabel:setVisible(true)
    end
end

function getLoginMainLayer()
    return _layer
end

function createLoginMainLayer()
    init()

    function _layer:refreshServerList()
        refreshServerList()
    end

    function _layer:refreshUid()
        refreshUid()
    end

    function _layer:menuEnabled(enable)
        menuEnabled(enable)
    end

    local function _onEnter()
    end

    local function _onExit()
        print("onExit")
        _layer = nil
        _isNewer = false
    end

    --onEnter onExit
    local function layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        end
    end
    -- addTestTable()
    _layer:registerScriptHandler(layerEventHandler)

    return _layer
end
