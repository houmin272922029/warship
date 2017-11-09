local _layer
local _accountEdit
local _oldPwdEdit
local _newPwdEdit 
local _comNewPwdEdit

-- 名字不要重复
LoginModifyPwdOwner = LoginModifyPwdOwner or {}
ccb["LoginModifyPwdOwner"] = LoginModifyPwdOwner

local function onBackClicked()
    print("onBackClicked")
    getLoginLayer():showLogin()
end
LoginModifyPwdOwner["onBackClicked"] = onBackClicked

local function onSubmitClicked()
    print("onSubmitClicked")
    local account = _accountEdit:getText()
    local oldPwd = _oldPwdEdit:getText()
    local newPwd = _newPwdEdit:getText()
    local comNewPwd = _comNewPwdEdit:getText()
    if string.len(account) <= 0 then
        ShowText(HLNSLocalizedString("sso.account.null"))
        return
    end 
    if string.len(oldPwd) <= 0 or string.len(newPwd) <= 0 or string.len(comNewPwd) <= 0 then
        ShowText(HLNSLocalizedString("sso.pwd.null"))
        return
    end 
    if newPwd ~= comNewPwd then
        ShowText(HLNSLocalizedString("sso.pwd.notEqual"))
        return
    end 

    SSOPlatform.ModifyPwd(account, oldPwd, newPwd)
end 
LoginModifyPwdOwner["onSubmitClicked"] = onSubmitClicked

local function _refreshUI()
    -- 加一个背景图
    local grayBg = CCScale9Sprite:create("ccbResources/grayBg.png")
    grayBg:setContentSize(CCSizeMake(winSize.width*0.98, winSize.height*0.98))
    grayBg:setAnchorPoint(ccp(0.5, 0.5))
    grayBg:setPosition(ccp(winSize.width/2, winSize.height/2))
    _layer:addChild(grayBg, -1)

    -- label加阴影
    for i=1,5 do
        local label = tolua.cast(LoginModifyPwdOwner["text"..i], "CCLabelTTF")
        if label then
            label:enableShadow(CCSizeMake(2*retina,-2*retina), 1, 0)
        end
    end

    -- 创建edit
    local function _createEdit( key )
        local editBoxLayer = tolua.cast(LoginModifyPwdOwner[key],"CCLayer") 
        local editBg = CCScale9Sprite:createWithSpriteFrameName("huichangtiao.png")
        local edit = CCEditBox:create(CCSize(editBoxLayer:getContentSize().width ,editBoxLayer:getContentSize().height ),editBg)
        edit:setPosition(ccp(0,0))
        edit:setAnchorPoint(ccp(0,0))
        edit:setFont("ccbResources/FZCuYuan-M03S.ttf",27*retina)
        editBoxLayer:addChild(edit)
        edit:setTouchPriority(-200)
        if key == "oldPwdEditLayer" or key == "newPwdEditLayer" then
            edit:setPlaceHolder(HLNSLocalizedString("6到12位英文或者数字"))
        else
            edit:setPlaceHolder(HLNSLocalizedString("必填"))
        end
        if key == "accountEditLayer" then
            edit:setInputMode(1)
        else
            edit:setInputFlag(0)
        end 

        return edit
    end 
    _accountEdit = _createEdit("accountEditLayer")
    _oldPwdEdit = _createEdit("oldPwdEditLayer")
    _newPwdEdit = _createEdit("newPwdEditLayer")
    _comNewPwdEdit = _createEdit("comNewPwdEditLayer")

    if not SSOPlatform.IsTourist() then
        _accountEdit:setEnabled(false)
        _accountEdit:setText(SSOPlatform.GetUid())
    end 
end 

local function Login_SSOModPwdNoti(  )
    ShowText(HLNSLocalizedString("sso.mod.pwd.succ"))
    getLoginLayer():showMain()
    getLoginMainLayer():menuEnabled(true)
end 

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/LoginModifyPwdView.ccbi", proxy, true,"LoginModifyPwdOwner")
    _layer = tolua.cast(node,"CCLayer")

    _refreshUI()
end

function createLoginModifyPwdLayer()
    _init()

    local function _onEnter()
        print("ModifyPwd onEnter")
        addObserver(HL_SSO_ModifyPwd, Login_SSOModPwdNoti)
    end

    local function _onExit()
        print("ModifyPwd onExit")
        _layer = nil
        _accountEdit = nil
        _oldPwdEdit = nil
        _newPwdEdit = nil
        _comNewPwdEdit = nil
        removeObserver(HL_SSO_ModifyPwd, Login_SSOModPwdNoti)
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