-- 登陆sso账号 --

local _layer
local _accountEdit
local _pwdEdit

-- 名字不要重复
LoginLoginOwner = LoginLoginOwner or {}
ccb["LoginLoginOwner"] = LoginLoginOwner

-- 账号登陆
local function onOkClicked()
    print("onOkClicked")
    local account = _accountEdit:getText()
    local pwd = _pwdEdit:getText()
    if string.len(account) <= 0 then
        ShowText(HLNSLocalizedString("sso.account.null"))
        return
    end 
    if string.len(pwd) <= 0 then
        ShowText(HLNSLocalizedString("sso.pwd.null"))
        return
    end 
    SSOPlatform.LoginWithAccount(account, pwd)
end
LoginLoginOwner["onOkClicked"] = onOkClicked

local function onCancelClicked()
    print("onCancelClicked")
    getLoginLayer():showMain()
    getLoginMainLayer():menuEnabled(true)
end 
LoginLoginOwner["onCancelClicked"] = onCancelClicked

local function onCreateAccountClicked()
    print("onCreateAccountClicked")
    getLoginLayer():showNewAccount()
end 
LoginLoginOwner["onCreateAccountClicked"] = onCreateAccountClicked

local function onModifyPwdClicked()
    print("onModifyPwdClicked")
    if isPlatform(IOS_INFIPLAY_RUS) or isPlatform(ANDROID_INFIPLAY_RUS) then
        local urlstr = "https://www.infiplay.ru/p/user/forgetPassword.htm"
        Global:instance():AlixPayweb(urlstr)
    else
        getLoginLayer():showModifyPwd()
    end
end 
LoginLoginOwner["onModifyPwdClicked"] = onModifyPwdClicked

local function _refreshUI()
    -- 加一个背景图
    local grayBg = CCScale9Sprite:create("ccbResources/grayBg.png")
    grayBg:setContentSize(CCSizeMake(winSize.width*0.98, winSize.height*0.98))
    grayBg:setAnchorPoint(ccp(0.5, 0.5))
    grayBg:setPosition(ccp(winSize.width/2, winSize.height/2))
    _layer:addChild(grayBg, -1)

    -- label加阴影
    local mailLabel = tolua.cast(LoginLoginOwner["mailLabel"], "CCLabelTTF")
    if mailLabel then
        mailLabel:enableShadow(CCSizeMake(2*retina,-2*retina), 1, 0)
    end
    local pwdLabel = tolua.cast(LoginLoginOwner["pwdLabel"], "CCLabelTTF")
    if pwdLabel then
        pwdLabel:enableShadow(CCSizeMake(2*retina,-2*retina), 1, 0)
    end

    local editBoxLayer = tolua.cast(LoginLoginOwner["accountEditLayer"],"CCLayer") 
    local editBg = CCScale9Sprite:createWithSpriteFrameName("huichangtiao.png")
    _accountEdit = CCEditBox:create(CCSize(editBoxLayer:getContentSize().width ,editBoxLayer:getContentSize().height ),editBg)
    _accountEdit:setPosition(ccp(0,0))
    _accountEdit:setAnchorPoint(ccp(0,0))
    _accountEdit:setFont("ccbResources/FZCuYuan-M03S.ttf",27*retina)
    _accountEdit:setInputMode(1)
    editBoxLayer:addChild(_accountEdit)
    _accountEdit:setTouchPriority(-200)

    local pwdEditLayer = tolua.cast(LoginLoginOwner["pwdEditLayer"],"CCLayer") 
    local editBg = CCScale9Sprite:createWithSpriteFrameName("huichangtiao.png")
    _pwdEdit = CCEditBox:create(CCSize(pwdEditLayer:getContentSize().width ,pwdEditLayer:getContentSize().height ),editBg)
    _pwdEdit:setPosition(ccp(0,0))
    _pwdEdit:setAnchorPoint(ccp(0,0))
    _pwdEdit:setFont("ccbResources/FZCuYuan-M03S.ttf",27*retina )
    _pwdEdit:setInputFlag(0)
    pwdEditLayer:addChild(_pwdEdit)
    _pwdEdit:setTouchPriority(-200)

    if not SSOPlatform.IsTourist() then
        _accountEdit:setText(SSOPlatform.GetUid())
    else 

        if isPlatform(IOS_INFIPLAY_RUS) or isPlatform(ANDROID_INFIPLAY_RUS) then
        else
        --todo

        -- 隐藏修改密码按钮
            local modifyPwdBtn = tolua.cast(LoginLoginOwner["modifyPwdBtn"], "CCMenuItem")
            if modifyPwdBtn then
                 modifyPwdBtn:setVisible(false)
            end 
            local modifyPwdLabel = tolua.cast(LoginLoginOwner["modifyPwdLabel"], "CCLabelTTF")
            if modifyPwdLabel then
                 modifyPwdLabel:setVisible(false)
            end 
        end
    end 
end 

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/LoginLoginView.ccbi", proxy, true,"LoginLoginOwner")
    _layer = tolua.cast(node,"CCLayer")


    local logo = tolua.cast(LoginLoginOwner["logo"], "CCSprite")
    if isPlatform(IOS_APPLE2_ZH)
        or isPlatform(ANDROID_HTC_ZH) then

        if isSpringFestival then
            CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/springLogo.plist")
            logo:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("springLogo.png"))         
        else
            CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/tiantianLogo.plist")
            logo:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tiantianLogo.png"))
        end

    elseif isPlatform(ANDROID_XIAOMI_ZH) 
        or isPlatform(ANDROID_OPPO_ZH) then

        if isSpringFestival then
            CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/springLogo.plist")
            logo:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("springLogo.png"))         
        else
            CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/daLogo.plist")
            logo:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("daLogo.png"))
        end

    elseif isPlatform(ANDROID_JAGUAR_TC) then
        --todo
        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/lbLogo.plist")
        --local logo = tolua.cast(LoginLoginOwner["logo"], "CCSprite")
        logo:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("lbLogo.png")) 

    elseif isPlatform(ANDROID_GV_MFACE_ZH) 
        or isPlatform(ANDROID_GV_MFACE_EN)
        or isPlatform(ANDROID_GV_MFACE_EN_OUMEI)
        or isPlatform(ANDROID_GV_MFACE_EN_OUMEINEW)
        or isPlatform(IOS_GAMEVIEW_EN) 
        or isPlatform(IOS_GVEN_BREAK)
        or isPlatform(IOS_GAMEVIEW_ZH) then
        
        if isSpringFestival and (isPlatform(ANDROID_GV_MFACE_EN) or isPlatform(ANDROID_GV_MFACE_EN_OUMEI) or isPlatform(ANDROID_GV_MFACE_EN_OUMEINEW) or isPlatform(IOS_GAMEVIEW_EN) or isPlatform(IOS_GVEN_BREAK)) 
        then
            CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/springLogo.plist")
            logo:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("gvSpringLogo.png"))         
        else
            CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/mfaceLogo.plist")
            logo:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("mfaceLogo.png"))
        end

    elseif isPlatform(IOS_MOBNAPPLE_EN) or isPlatform(ANDROID_VIETNAM_EN)
    or isPlatform(ANDROID_VIETNAM_EN_ALL) then

        if isSpringFestival then
            CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/springLogo.plist")
            logo:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("pfSpringLogo.png"))         
        else
            -- CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/login.plist")
            logo:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("logo_1.png"))
        end

    elseif isPlatform(ANDROID_GV_XJP_ZH)
        or isPlatform(ANDROID_GV_MFACE_TC)
        or isPlatform(IOS_GAMEVIEW_TC)
        or isPlatform(ANDROID_GV_MFACE_TC_GP) then

        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/mfaceLogo2.plist")
        local logo = tolua.cast(LoginLoginOwner["logo"], "CCSprite")
        logo:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("mfaceLogo2.png")) 

    elseif isPlatform(IOS_IIAPPLE_ZH) or isPlatform(ANDROID_KY_ZH) or isPlatform(IOS_KYPARK_ZH)
     or isPlatform(IOS_ITOOLSPARK) or isPlatform(IOS_XYZS_ZH) or isPlatform(ANDROID_XYZS_ZH) or isPlatform(IOS_AISIPARK_ZH)
      or isPlatform(IOS_DOWNJOYPARK_ZH) then

        if isSpringFestival then
            CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/springLogo.plist")
            logo:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("springLogo.png"))         
        else
            CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/iappleLogo.plist")
            logo:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("iapple_logo.png"))
        end
    else
        if isSpringFestival then
            CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/springLogo.plist")
            local logo = tolua.cast(LoginLoginOwner["logo"], "CCSprite")
            logo:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("springLogo.png")) 
        end
    end
    
    _refreshUI()
end

function createLoginLoginLayer()
    _init()

    local function _onEnter()
        print("LoginLogin onEnter")
    end

    local function _onExit()
        print("LoginLogin onExit")
        _layer = nil
        _accountEdit = nil
        _pwdEdit = nil
    end

    --onEnter onExit
    local function _layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        end
    end

    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end