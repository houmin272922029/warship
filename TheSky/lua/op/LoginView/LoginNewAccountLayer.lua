-- 创建新sso账号 --

local _layer
local _accountEdit
local _pwdEdit
local _comfirmPwdEdit 
local _phoneEdit

-- 名字不要重复
LoginNewAccountOwner = LoginNewAccountOwner or {}
ccb["LoginNewAccountOwner"] = LoginNewAccountOwner

local function onBackClicked()
    print("onBackClicked")
    getLoginLayer():showLogin()
end
LoginNewAccountOwner["onBackClicked"] = onBackClicked

-- 注册账号
local function onRegisterClicked()
    print("onRegisterClicked")
    local account = _accountEdit:getText()
    local pwd = _pwdEdit:getText()
    local comPwd = _comfirmPwdEdit:getText()
    local phone
    if isPlatform(IOS_INFIPLAY_RUS) or isPlatform(ANDROID_INFIPLAY_RUS) then
        phone = nil
    else
        phone = _phoneEdit:getText()
    end
    if string.len(account) <= 0 then
        ShowText(HLNSLocalizedString("sso.account.null"))
        return
    end 
    if string.len(pwd) <= 0 or string.len(comPwd) <= 0 then
        ShowText(HLNSLocalizedString("sso.pwd.null"))
        return
    end 
    if string.len(pwd) >= 16 or string.len(pwd) <= 5 then
        ShowText(HLNSLocalizedString("sso.pwd.tooLong"))
        return
    end 
    if comPwd ~= pwd then
        ShowText(HLNSLocalizedString("sso.pwd.notEqual"))
        return
    end 
    if isPlatform(IOS_INFIPLAY_RUS) or isPlatform(ANDROID_INFIPLAY_RUS) then
        SSOPlatform.Register(account, pwd, phone)
        return
    end

    if isPlatform(WP_VIETNAM_VN) then
        if not phone or string.len(phone) <= 0 then
            ShowText(HLNSLocalizedString("sso.phone.null"))
            return
        end 
        SSOPlatform.Register(account, pwd, phone)
        return
    end

    if isPlatform(WP_VIETNAM_EN) then
        if not phone or string.len(phone) <= 0 then
            ShowText(HLNSLocalizedString("sso.phone.null"))
            return
        end 
        SSOPlatform.Register(account, pwd, phone)
        return
    end

    if SSOPlatform.IsTourist() then
        -- 绑定注册
        SSOPlatform.Binding(account, pwd, phone)
    else 
        -- 注册
        SSOPlatform.Register(account, pwd, phone)
    end 
end 
LoginNewAccountOwner["onRegisterClicked"] = onRegisterClicked

local function _refreshUI()
    -- 加一个背景图
    local grayBg = CCScale9Sprite:create("ccbResources/grayBg.png")
    grayBg:setContentSize(CCSizeMake(winSize.width*0.98, winSize.height*0.98))
    grayBg:setAnchorPoint(ccp(0.5, 0.5))
    grayBg:setPosition(ccp(winSize.width/2, winSize.height/2))
    _layer:addChild(grayBg, -1)

    -- label加阴影
    local totalTexts = 5
    if isPlatform(IOS_INFIPLAY_RUS or ANDROID_INFIPLAY_RUS) then
        totalTexts = 4
    end
    for i=1,totalTexts do
        local label = tolua.cast(LoginNewAccountOwner["text"..i], "CCLabelTTF")
        if label then
            label:enableShadow(CCSizeMake(2*retina,-2*retina), 1, 0)
        end
    end

    -- 创建edit
    local function _createEdit( key )
        local editBoxLayer = tolua.cast(LoginNewAccountOwner[key],"CCLayer") 
        local editBg = CCScale9Sprite:createWithSpriteFrameName("huichangtiao.png")
        local edit = CCEditBox:create(CCSize(editBoxLayer:getContentSize().width ,editBoxLayer:getContentSize().height ),editBg)
        edit:setPosition(ccp(0,0))
        edit:setAnchorPoint(ccp(0,0))
        -- print("没了爱，还会在一起么",math.floor(editBoxLayer:getContentSize().height))
        edit:setFont("ccbResources/FZCuYuan-M03S.ttf",27 * retina)
        editBoxLayer:addChild(edit)
        edit:setTouchPriority(-200)
        if key == "pwdEditLayer" or key == "comPwdEditLayer" then
            edit:setInputFlag(0)
            edit:setPlaceHolder(HLNSLocalizedString("6到12位英文或者数字"))
        elseif key == "accountEditLayer" then
            edit:setInputMode(1)
            edit:setPlaceHolder(HLNSLocalizedString("必填"))
        elseif key == "phoneEditLayer" then
            edit:setInputMode(1)
            if isPlatform(WP_VIETNAM_VN) then
                edit:setPlaceHolder(HLNSLocalizedString("必填"))
            elseif isPlatform(WP_VIETNAM_EN) then
                edit:setPlaceHolder(HLNSLocalizedString("必填"))
            else
                edit:setPlaceHolder(HLNSLocalizedString("选填"))
            end
        end 
        return edit
    end 
    _accountEdit = _createEdit("accountEditLayer")
    _pwdEdit = _createEdit("pwdEditLayer")
    _comfirmPwdEdit = _createEdit("comPwdEditLayer")
    if isPlatform(IOS_INFIPLAY_RUS) or isPlatform(ANDROID_INFIPLAY_RUS) then 
        LoginNewAccountOwner["phoneEditLayer"]:setVisible(false)
        return
    else
        _phoneEdit = _createEdit("phoneEditLayer")
    end
end 

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/LoginNewAccountView.ccbi", proxy, true,"LoginNewAccountOwner")
    _layer = tolua.cast(node,"CCLayer")

    _refreshUI()
end

function createLoginNewAccountLayer()
    _init()

    local function _onEnter()
        print("LoginNewAccount onEnter")
    end

    local function _onExit()
        print("LoginNewAccount onExit")
        _layer = nil
        _accountEdit = nil
        _pwdEdit = nil
        _comfirmPwdEdit = nil
        _phoneEdit = nil
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