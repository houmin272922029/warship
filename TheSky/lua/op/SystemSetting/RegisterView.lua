local _layer
local _priority
local _accountEdit
local _pwdEdit
local _comfirmPwdEdit
local _phoneEdit

-- 名字不要重复
RegisterLayerViewOwner = RegisterLayerViewOwner or {}
ccb["RegisterLayerViewOwner"] = RegisterLayerViewOwner

local function closeItemClick()
    _layer:removeFromParentAndCleanup(true)
end

local function onRegisterClicked(  )
    print("注册")
    local account = _accountEdit:getText()
    local pwd = _pwdEdit:getText()
    local comPwd = _comfirmPwdEdit:getText()
    local phone = _phoneEdit:getText()
    if string.len(account) <= 0 then
        ShowText(HLNSLocalizedString("sso.account.null"))
        return
    end 
    if string.len(pwd) <= 0 or string.len(comPwd) <= 0 then
        ShowText(HLNSLocalizedString("sso.pwd.null"))
        return
    end 
    if comPwd ~= pwd then
        ShowText(HLNSLocalizedString("sso.pwd.notEqual"))
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

RegisterLayerViewOwner["closeItemClick"] = closeItemClick
RegisterLayerViewOwner["onRegisterClicked"] = onRegisterClicked

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/RegisterView.ccbi", proxy, true,"RegisterLayerViewOwner")
    _layer = tolua.cast(node,"CCLayer")

    -- 创建edit
    local function _createEdit( key )
        local editBoxLayer = tolua.cast(RegisterLayerViewOwner[key],"CCLayer") 
        local editBg = CCScale9Sprite:createWithSpriteFrameName("chat_bg.png")
        local edit = CCEditBox:create(CCSize(editBoxLayer:getContentSize().width ,editBoxLayer:getContentSize().height ),editBg)
        edit:setPosition(ccp(0,0))
        edit:setAnchorPoint(ccp(0,0))
        edit:setFont("ccbResources/FZCuYuan-M03S.ttf",30*retina)
        editBoxLayer:addChild(edit)
        edit:setTouchPriority(_priority - 1)
        if key == "pwdEditLayer" or key == "comPwdEditLayer" then
            edit:setInputFlag(0)
            edit:setPlaceHolder(HLNSLocalizedString("必填"))
        elseif key == "accountEditLayer" then
            edit:setInputMode(1)
            edit:setPlaceHolder(HLNSLocalizedString("必填"))
        elseif key == "phoneEditLayer" then
            edit:setInputMode(3)
            edit:setPlaceHolder(HLNSLocalizedString("选填"))
        end 
        return edit
    end 
    _accountEdit = _createEdit("accountEditLayer")
    _pwdEdit = _createEdit("pwdEditLayer")
    _comfirmPwdEdit = _createEdit("comPwdEditLayer")
    _phoneEdit = _createEdit("phoneEditLayer")
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(RegisterLayerViewOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    -- if not rect:containsPoint(touchLocation) then
    --     _layer:removeFromParentAndCleanup(true)
    --     return true
    -- end
    return true
end

local function onTouchEnded(x, y)

end

local function onTouch(eventType, x, y)
    if eventType == "began" then   
        return onTouchBegan(x, y)
    elseif eventType == "moved" then
    else
        return onTouchEnded(x, y)
    end
end

local function setMenuPriority()
    local menu1 = tolua.cast(RegisterLayerViewOwner["myCloseMenu"], "CCMenu")
    menu1:setHandlerPriority(_priority-1)
end

-- 该方法名字每个文件不要重复
function getAnnounceLayer()
	return _layer
end

function createRegisterLayer(priority)
    _priority = (priority ~= nil) and priority or -132
    _init()
    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)   
        addObserver(HL_SSO_Register, closeItemClick)
    end

    local function _onExit()
        _layer = nil
        _priority = nil
        _accountEdit = nil
        _pwdEdit = nil
        _comfirmPwdEdit = nil
        _phoneEdit = nil
        removeObserver(HL_SSO_Register, closeItemClick)
    end

    --onEnter onExit
    local function _layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        end
    end
    _layer:registerScriptTouchHandler(onTouch ,false , _priority ,true )
    _layer:setTouchEnabled(true)
    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end