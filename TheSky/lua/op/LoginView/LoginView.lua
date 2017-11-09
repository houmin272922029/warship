-- 登陆界面
local _selected = -1
local _loginLayer = nil
local _isNewer = false
local respGlobal = nil
isSpringFestival = false

LoginLayerOwner = LoginLayerOwner or {}
-- ccb["LoginLayerOwner"] = LoginLayerOwner

local function _clearContentLayer()
    local contentLayer = LoginLayerOwner["contentLayer"] 
    contentLayer:removeAllChildrenWithCleanup(true)
end

local function _showMain()
    _clearContentLayer()
    local contentLayer = LoginLayerOwner["contentLayer"] 
    contentLayer:addChild(createLoginMainLayer())
    getLoginMainLayer():refreshServerList()
    getLoginMainLayer():refreshUid()
end

local function _showServer()
    _clearContentLayer()
    local contentLayer = LoginLayerOwner["contentLayer"]
    contentLayer:addChild(createLoginServerLayer())
end

local function _showLogin()
    _clearContentLayer()
    local contentLayer = LoginLayerOwner["contentLayer"] 
    contentLayer:addChild(createLoginLoginLayer())
end 

local function _showNewAccount()
    _clearContentLayer()
    local contentLayer = LoginLayerOwner["contentLayer"] 
    contentLayer:addChild(createLoginNewAccountLayer())
end 

local function _showModifyPwd()
    _clearContentLayer()
    local contentLayer = LoginLayerOwner["contentLayer"] 
    contentLayer:addChild(createLoginModifyPwdLayer())
end

local function _showUpdate()
    _clearContentLayer() 
    local contentLayer = LoginLayerOwner["contentLayer"]
    contentLayer:addChild(createLoginUpdateLayer())
end

local function _resetCloud(sender)
    local sprite = tolua.cast(sender, "CCSprite")
    local posX, posY =  sprite:getPosition()
    local width = sprite:getContentSize().width
    local offset = width + winSize.width / retina
    if posX > 0 then
        sprite:setPosition(ccp(posX - offset, posY))
    else
        sprite:setPosition(ccp(posX + offset, posY))
    end
end

local function _cloudAni(index, duration)
    local cloud = tolua.cast(LoginLayerOwner["cloud_"..index], "CCSprite")
    local width = cloud:getContentSize().width
    local offset = width + winSize.width / retina
    local posX, posY = cloud:getPosition()
    local seq
    if posX < 0 then
        seq = CCSequence:createWithTwoActions(CCMoveBy:create(duration, ccp(offset, 0)), CCCallFuncN:create(_resetCloud))
    else
        seq = CCSequence:createWithTwoActions(CCMoveBy:create(duration, ccp(-offset, 0)), CCCallFuncN:create(_resetCloud))
    end
    local rep = CCRepeatForever:create(seq)
    cloud:runAction(rep)
end

local function callFirework1()
    local fire = LoginLayerOwner["fire_left"]
    HLAddParticle( "images/firework1.plist", _loginLayer, ccp(fire:getPositionX(),fire:getPositionY()), 1, 1, 1)
end
LoginLayerOwner["callFirework1"] = callFirework1

local function callFirework2()
    local fire = LoginLayerOwner["fire_right"]
    HLAddParticle( "images/firework2.plist", _loginLayer, ccp(fire:getPositionX(),fire:getPositionY()), 1, 1, 1)
end
LoginLayerOwner["callFirework2"] = callFirework2

local function callFirework3()
    local fire = LoginLayerOwner["fire_up"]
    HLAddParticle( "images/firework3.plist", _loginLayer, ccp(fire:getPositionX(),fire:getPositionY()), 1, 1, 1)
end
LoginLayerOwner["callFirework3"] = callFirework3

local function callFirework4()
    local fire = LoginLayerOwner["fire_left"]
    HLAddParticle( "images/firework2.plist", _loginLayer, ccp(fire:getPositionX(),fire:getPositionY()), 1, 1, 1)
end
LoginLayerOwner["callFirework4"] = callFirework4

local function callFirework5()
    local fire = LoginLayerOwner["fire_right"]
    HLAddParticle( "images/firework1.plist", _loginLayer, ccp(fire:getPositionX(),fire:getPositionY()), 1, 1, 1)
end
LoginLayerOwner["callFirework5"] = callFirework5

local function callFirework6()
    local fire = LoginLayerOwner["fire_up"]
    HLAddParticle( "images/firework3.plist", _loginLayer, ccp(fire:getPositionX(),fire:getPositionY()), 1, 1, 1)
end
LoginLayerOwner["callFirework6"] = callFirework6

local function callFirework7()
    local fire = LoginLayerOwner["fire_left"]
    HLAddParticle( "images/firework1.plist", _loginLayer, ccp(fire:getPositionX(),fire:getPositionY()), 1, 1, 1)
end
LoginLayerOwner["callFirework7"] = callFirework7

local function callFirework8()
    local fire = LoginLayerOwner["fire_right"]
    HLAddParticle( "images/firework3.plist", _loginLayer, ccp(fire:getPositionX(),fire:getPositionY()), 1, 1, 1)
end
LoginLayerOwner["callFirework8"] = callFirework8

local function callFirework9()
    local fire = LoginLayerOwner["fire_up"]
    HLAddParticle( "images/firework2.plist", _loginLayer, ccp(fire:getPositionX(),fire:getPositionY()), 1, 1, 1)
end
LoginLayerOwner["callFirework9"] = callFirework9


local function init()
    ccb["LoginLayerOwner"] = LoginLayerOwner
    local  proxy = CCBProxy:create()
    local  node
    if isSpringFestival then
        node  = CCBReaderLoad("ccbResources/LoginSpringView.ccbi",proxy,true,"LoginLayerOwner")
    else
        node  = CCBReaderLoad("ccbResources/LoginView.ccbi",proxy,true,"LoginLayerOwner")
    end
    _loginLayer = tolua.cast(node,"CCLayer")

    if not isSpringFestival then
        _cloudAni(1, 30)
        _cloudAni(2, 25)
        _cloudAni(3, 25)
        _cloudAni(4, 20)
        _cloudAni(5, 17)
        _cloudAni(6, 19)
        _cloudAni(7, 18)
    end
    _showMain()
end

-- sso登陆
local function ssoLogin()
    SSOPlatform.Login()
    if getLoginMainLayer() then
        getLoginMainLayer():menuEnabled(false)
    end
end

local function getSSOUid()
    local ssoUid = SSOPlatform.GetUid()
    if ssoUid and string.len(ssoUid) > 0 then
        ssoLogin()    
    elseif isPlatform(IOS_INFIPLAY_RUS) or isPlatform(ANDROID_INFIPLAY_RUS) then
    elseif isPlatform(WP_VIETNAM_VN) then
    elseif isPlatform(WP_VIETNAM_EN) then
        print("ent WP_VIETNAM_EN")
    else
        SSOPlatform.GenerateUid()
    end
end

local function SSOGenerateUidNoti()
    ssoLogin()
end

local function SSOGetServerListNoti(resp)
    if resp.info.server_list then
        userdata.serverList = resp.info.server_list
        userdata.serverListArr = HLSortDicInArray(userdata.serverList, "sort", false)           -- sort越大排前面
    end
    local server = nil
    if not resp.info.serverCode or resp.info.serverCode == "" or table.getTableCount(resp.info.serverCode) <= 0 then
        userdata.serverCodes = nil
        server = userdata.serverListArr[1].v
    else
        userdata.serverCodes = resp.info.serverCode
        server = userdata.serverList[userdata.serverCodes["0"]]
    end
    userdata.selectServer = server
    userdata.serverCode = server.id

    if getLoginMainLayer() then
        getLoginMainLayer():refreshServerList()
        getLoginMainLayer():refreshUid()
    else
        _showMain()
    end
    if getLoginMainLayer() then
        getLoginMainLayer():menuEnabled(true)
    end
end 

-- 第三方平台登陆通知
local function Login_PlatformNoti(resp)
    if isPlatform(IOS_KY_ZH) then

        if string.len(SSOPlatform.GetUid()) > 0 then
            -- 如果在登陆界面注销sdk登陆
            SSOPlatform.setUid("")
        else
            SSOPlatform.setToken(resp[1])
            SSOPlatform.GenerateUid()
        end

    elseif isPlatform(IOS_KYPARK_ZH) or isPlatform(ANDROID_KY_ZH) then

            SSOPlatform.setToken(resp[2])
            SSOPlatform.GenerateUid()

    elseif isPlatform(ANDROID_JAGUAR_TC) then  --LINGLING
        -- SSOPlatform.setSid(resp[2])
        local function jg_login( ... )
            SSOPlatform.setToken(resp[2])
            SSOPlatform.setUid(resp[1])
            SSOPlatform.setNickname(resp[1])
            if getLoginMainLayer() then
                getLoginMainLayer():refreshUid()
            end
            ssoLogin()
        end 
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(1.0), CCCallFunc:create(jg_login))
        _loginLayer:runAction(seq)

    elseif isPlatform(IOS_IIAPPLE_ZH) then  
        local function iiapple_login( ... )
            SSOPlatform.setToken(resp[2])
            SSOPlatform.setUid(resp[1])
            SSOPlatform.setNickname(resp[1])
            if getLoginMainLayer() then
                getLoginMainLayer():refreshUid()
            end
            ssoLogin()
        end 
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(iiapple_login))
        _loginLayer:runAction(seq)

    elseif isPlatform(IOS_XYZS_ZH) 
        or isPlatform(IOS_DOWNJOYPARK_ZH)
        or isPlatform(ANDROID_XYZS_ZH) then  
        local function xysso_login( ... )
            SSOPlatform.setUid(resp[1])
            SSOPlatform.setToken(resp[2])
            SSOPlatform.setNickname(resp[3])
            if getLoginMainLayer() then
                getLoginMainLayer():refreshUid()
            end
            ssoLogin()
        end 
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(xysso_login))
        _loginLayer:runAction(seq)

    elseif isPlatform(ANDROID_DOWNJOY_ZH) then  
        local function dlsso_login( ... )
            SSOPlatform.setUid(resp[1])
            SSOPlatform.setToken(resp[4])
            SSOPlatform.setNickname(resp[3])
            if getLoginMainLayer() then
                getLoginMainLayer():refreshUid()
            end
            ssoLogin()
        end 
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(dlsso_login))
        _loginLayer:runAction(seq)

    elseif isPlatform(IOS_ITOOLS) or isPlatform(IOS_ITOOLSPARK) then

        SSOPlatform.setSid(resp[1])
        SSOPlatform.setUid(resp[2])
        SSOPlatform.setNickname(resp[2])
        if getLoginMainLayer() then
            getLoginMainLayer():refreshUid()
        end
        ssoLogin()
    --  木蚂蚁不能加到下面三个参数的elseif中（添加一个可选参数），因为sid 和token 的顺序不同
    elseif isPlatform(ANDROID_MMY_ZH) then
        local function mmy_login( ... )
            print(resp[1],resp[2],resp[3],resp[4])
            SSOPlatform.setUid(resp[1])
            SSOPlatform.setNickname(resp[2])
            SSOPlatform.setSid(resp[3])
            SSOPlatform.setToken(resp[4])
            if getLoginMainLayer() then
                getLoginMainLayer():refreshUid()
            end
            ssoLogin()
        end
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(1.0), CCCallFunc:create(mmy_login))
        _loginLayer:runAction(seq)

    elseif isPlatform(ANDROID_360_ZH )then

        local function ssoGenerateUIDFor360()
            SSOPlatform.setSid(resp[1])
            SSOPlatform.GenerateUid()
        end 
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(1.0), CCCallFunc:create(ssoGenerateUIDFor360))
        _loginLayer:runAction(seq)

    elseif isPlatform(ANDROID_UC_ZH) then

        local function ssoGenerateUIDForUC()
            SSOPlatform.setToken(resp[1])
            SSOPlatform.GenerateUid()
        end 
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(1.0), CCCallFunc:create(ssoGenerateUIDForUC))
        _loginLayer:runAction(seq)

    elseif isPlatform(IOS_PPZS_ZH) or isPlatform(IOS_PPZSPARK_ZH) then
        print("PP助手setToken,生成Uid")
        print(resp[1])

        SSOPlatform.setToken(resp[1])
        SSOPlatform.GenerateUid()

    elseif isPlatform(IOS_VIETNAM_VI) 
        or isPlatform(IOS_VIETNAM_EN) 
        or isPlatform(IOS_VIETNAM_ENSAGA)
        or isPlatform(IOS_MOB_THAI)
        or isPlatform(IOS_MOBNAPPLE_EN)
        or isPlatform(IOS_MOBGAME_SPAIN) then

        SSOPlatform.setSid(resp[1])
        SSOPlatform.setUid(resp[1])
        SSOPlatform.setNickname(resp[2])
        if getLoginMainLayer() then
            getLoginMainLayer():refreshUid()
        end
        ssoLogin()

    elseif isPlatform(ANDROID_HUAWEI_ZH) then

        local function huawei_login( ... )
            print(resp[1],resp[2],resp[3],resp[4])
            SSOPlatform.setUid(resp[1])
            SSOPlatform.setNickname(resp[2])
            SSOPlatform.setToken(resp[4])
            
            if getLoginMainLayer() then
                getLoginMainLayer():refreshUid()
            end
            ssoLogin()
        end
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(1.0), CCCallFunc:create(huawei_login))
        _loginLayer:runAction(seq)

    elseif isPlatform(ANDROID_VIETNAM_VI) 
        or isPlatform(ANDROID_VIETNAM_EN)
        or isPlatform(ANDROID_VIETNAM_EN_ALL)
        or isPlatform(ANDROID_VIETNAM_MOB_THAI)
        or isPlatform(ANDROID_MOBGAME_SPAIN) then

        local function vnSSOFun( ... )
            SSOPlatform.setSid(Global:getUid())
            SSOPlatform.setUid(Global:getUid())
            SSOPlatform.setNickname(Global:getUserName())
            if getLoginMainLayer() then
                getLoginMainLayer():refreshUid()
            end
            ssoLogin()
        end
        print("zhajianming mob login suc", resp[1])
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(1.0), CCCallFunc:create(vnSSOFun))
        _loginLayer:runAction(seq)

    elseif isPlatform(ANDROID_BAIDU_ZH)
        or isPlatform(ANDROID_BAIDUIAPPPAY_ZH) 
        or isPlatform(ANDROID_MM_ZH)
        or isPlatform(ANDROID_COOLPAY_ZH) then

        local function baiduSSOFun( ... )
            local rtnTbl = json.decode(resp[1])
            SSOPlatform.setSid(rtnTbl["uid"])
            SSOPlatform.setUid(rtnTbl["uid"])
            SSOPlatform.setNickname(rtnTbl["uname"])
            if getLoginMainLayer() then
                getLoginMainLayer():refreshUid()
            end
            ssoLogin()
        end        
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(1.0), CCCallFunc:create(baiduSSOFun))
        _loginLayer:runAction(seq)

    elseif isPlatform(ANDROID_AGAME_ZH) then

        local function agameSSOFun( ... )
            local rtnTbl = json.decode(resp[1])
            SSOPlatform.setSid(rtnTbl["sessionid"])
            SSOPlatform.setUid(rtnTbl["accountid"])
            SSOPlatform.setToken(rtnTbl["sessionid"])
            if getLoginMainLayer() then
                getLoginMainLayer():refreshUid()
            end
            ssoLogin()
        end
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(1.0), CCCallFunc:create(agameSSOFun))
        _loginLayer:runAction(seq)

    elseif onPlatform("TGAME")
        or isPlatform(ANDROID_MYEPAY_ZH)
        or isPlatform(ANDROID_HTC_ZH)
        or isPlatform(IOS_TBTPARK_ZH)
        or isPlatform(IOS_HAIMA_ZH) then
        print("uid,sid,nickname",resp[1],resp[2],resp[3])

        local function ssoFun( ... )
            -- body
            SSOPlatform.setUid(resp[1])
            SSOPlatform.setSid(resp[2])
            SSOPlatform.setNickname(resp[3])
            if getLoginMainLayer() then
                getLoginMainLayer():refreshUid()
            end
            ssoLogin()
        end
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(1.0), CCCallFunc:create(ssoFun))
        _loginLayer:runAction(seq)

    elseif isPlatform(IOS_AISIPARK_ZH) then
        SSOPlatform.setUid(resp[1])
        SSOPlatform.setToken(resp[2])
        SSOPlatform.setNickname(resp[3])
        if getLoginMainLayer() then
            getLoginMainLayer():refreshUid()
        end
        ssoLogin()
    elseif isPlatform(ANDROID_GIONEE_ZH) 
        or isPlatform(IOS_AISI_ZH)
        or isPlatform(ANDROID_ANFENG_ZH) then
        local function gioneeFun( ... )
            -- body
            SSOPlatform.setUid(resp[1])
            SSOPlatform.setToken(resp[2])
            SSOPlatform.setNickname(resp[3])
            if getLoginMainLayer() then
                getLoginMainLayer():refreshUid()
            end
            ssoLogin()
        end
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(1.0), CCCallFunc:create(gioneeFun))
        _loginLayer:runAction(seq)
    end
end

-- 91 进行特殊的处理，让点击一次进入游戏就可以登陆游戏
local function Login_SSO91LoginNoti(resp)
    if isPlatform(IOS_91_ZH) then

        SSOPlatform.GetServerListByVersion(resp[2])
        SSOPlatform.setSid(resp[1])
        SSOPlatform.setUid(resp[2])             
        SSOPlatform.setNickname(resp[3])
        if getLoginMainLayer() then
            getLoginMainLayer():refreshUid()
        end
    end

end

local function Login_SSOOPPOLoginNoti(resp)
        local function  refreshserverlistandnicknameOPPO()
            SSOPlatform.GetServerListByVersion(resp[3])
            SSOPlatform.setSid(resp[3])
            SSOPlatform.setUid(resp[1])             
            SSOPlatform.setNickname(resp[2])
            SSOPlatform.setSecret(resp[4])
            if getLoginMainLayer() then
                getLoginMainLayer():refreshUid()
            end
        end
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(1.0), CCCallFunc:create(refreshserverlistandnicknameOPPO))
        _loginLayer:runAction(seq)
end

local function Login_SSOXIAOMILoginNoti(resp)
    respGlobal = resp
    local function refreshserverlistandnickname()
        SSOPlatform.GetServerListByVersion(respGlobal[1])
        SSOPlatform.setSid(respGlobal[2])
        SSOPlatform.setUid(respGlobal[1])
        SSOPlatform.setNickname(respGlobal[3])
        if getLoginMainLayer() then
            getLoginMainLayer():refreshUid()
        end
    end
    local seq = CCSequence:createWithTwoActions(CCDelayTime:create(1.0), CCCallFunc:create(refreshserverlistandnickname))
    _loginLayer:runAction(seq)
end

local function Login_SSOLoginNoti(resp)
    if isPlatform(IOS_TBT_ZH) then

        SSOPlatform.GetServerListByVersion(resp[2])
        SSOPlatform.setSid(resp[1])
        SSOPlatform.setUid(resp[2])
        SSOPlatform.setNickname(resp[3])
        if getLoginMainLayer() then
            getLoginMainLayer():refreshUid()
        end

    elseif isPlatform(ANDROID_GV_MFACE_ZH) 
        or isPlatform(ANDROID_GV_MFACE_EN) 
        or isPlatform(ANDROID_GV_MFACE_EN_OUMEI)
        or isPlatform(ANDROID_GV_MFACE_EN_OUMEINEW)
        or isPlatform(IOS_GAMEVIEW_ZH) 
        or isPlatform(IOS_GAMEVIEW_EN)         
        or isPlatform(IOS_GVEN_BREAK)
        or isPlatform(ANDROID_GV_XJP_ZH)
        or isPlatform(ANDROID_GV_MFACE_TC)
        or isPlatform(IOS_GAMEVIEW_TC)
        or isPlatform(ANDROID_GV_MFACE_TC_GP) then

        local function gv_login( ... )
            SSOPlatform.GetServerListByVersion(resp[1])
            SSOPlatform.setUid(resp[1])
            SSOPlatform.setNickname(resp[2])
            SSOPlatform.setToken(resp[3])
            if getLoginMainLayer() then
                getLoginMainLayer():refreshUid()
            end
        end
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(1.0), CCCallFunc:create(gv_login))
        _loginLayer:runAction(seq)

    elseif isPlatform(IOS_91_ZH) 
        or isPlatform(ANDROID_91_ZH) 
        or isPlatform(ANDROID_WDJ_ZH) then

        local function ndSSOFun( ... )
            SSOPlatform.GetServerListByVersion(resp[2])
            SSOPlatform.setSid(resp[1])
            SSOPlatform.setUid(resp[2])             
            SSOPlatform.setNickname(resp[3])
            if getLoginMainLayer() then
                getLoginMainLayer():refreshUid()
            end
        end
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(1.0), CCCallFunc:create(ndSSOFun))
        _loginLayer:runAction(seq)

    else

        if resp.info.server_list then   
            userdata.serverList = resp.info.server_list
            userdata.serverListArr = HLSortDicInArray(userdata.serverList, "sort", false)           -- sort越大排前面
        end
        local server = nil
        if not resp.info.serverCode or resp.info.serverCode == "" or table.getTableCount(resp.info.serverCode) <= 0 then
            userdata.serverCodes = nil
            print("-------------------userdata.serverListArr-------")
            PrintTable(userdata.serverListArr)
            server = userdata.serverListArr[1].v
        else
            userdata.serverCodes = resp.info.serverCode
            for k,v in pairs(userdata.serverCodes) do
                if not userdata.serverList[v] then
                    userdata.serverCodes[k] = nil
                end
            end
            server = userdata.serverList[userdata.serverCodes["0"]]
        end
        if server then
            userdata.selectServer = server
            userdata.serverCode = server.id
        end
    
        if getLoginMainLayer() then
            getLoginMainLayer():refreshUid()
            getLoginMainLayer():refreshServerList()
        else
            _showMain()
        end
        if getLoginMainLayer() then
            getLoginMainLayer():menuEnabled(true)
        end
    end 
end

local function Login_SSOError(errCode)
    if errCode == ERR_1201 then
        _showLogin()
    else
        _loginLayer:addChild(createLoginErrorPopUpLayer(-132))
    end
    if getLoginMainLayer() then
        getLoginMainLayer():menuEnabled(true)
    end
end

local function Login_SSORegisterNoti()
    _showMain()
    getSSOUid()
end 

local function _addTouchFBLayer()
    print("_addTouchFBLayer", opPCL);
    if isPlatform(IOS_KY_ZH) then

        -- 快用版本调用快用的登陆接口
        if string.len(SSOPlatform.GetUid()) <= 0 then
            tpSSOLogin({}, "ssoLoginSucc", "ssoLoginFail")
        end
    elseif isPlatform(IOS_KYPARK_ZH) or isPlatform(ANDROID_KY_ZH) then

        if string.len(SSOPlatform.GetUid()) > 0 and SSOPlatform.GetUid() == SSOPlatform.m_guid then
            -- 从登陆退出，且是登出操作而不是刷小号，无处理
        else
            -- 刚启动游戏，或者刷小号
            tpSSOLogin({}, "ssoLoginSucc", "ssoLoginFail")
        end

    elseif isPlatform(IOS_PPZS_ZH) 
        or isPlatform(IOS_PPZSPARK_ZH)
        or isPlatform(ANDROID_UC_ZH) 
        or isPlatform(IOS_ITOOLS)
        or isPlatform(IOS_ITOOLSPARK) 
        or isPlatform(IOS_XYZS_ZH)
        or isPlatform(ANDROID_XYZS_ZH)
        or isPlatform(ANDROID_91_ZH) 
        or isPlatform(IOS_TBT_ZH) 
        or isPlatform(IOS_TBTPARK_ZH) 
        or isPlatform(ANDROID_360_ZH) 
        or isPlatform(ANDROID_WDJ_ZH) 
        or isPlatform(ANDROID_DK_ZH) 
        or isPlatform(ANDROID_GV_MFACE_ZH) 
        or isPlatform(ANDROID_AGAME_ZH) 
        or isPlatform(ANDROID_BAIDU_ZH) 
        or isPlatform(ANDROID_MM_ZH) 
        or isPlatform(ANDROID_GV_MFACE_EN)
        or isPlatform(ANDROID_GV_MFACE_EN_OUMEI)
        or isPlatform(ANDROID_GV_MFACE_EN_OUMEINEW)
        or isPlatform(IOS_GAMEVIEW_EN)
        or isPlatform(IOS_GVEN_BREAK)
        or isPlatform(IOS_GAMEVIEW_ZH)
        or isPlatform(ANDROID_GV_XJP_ZH)
        or isPlatform(ANDROID_MMY_ZH) 
        or isPlatform(ANDROID_BAIDUIAPPPAY_ZH)
        or isPlatform(ANDROID_GV_MFACE_TC)
        or isPlatform(ANDROID_HUAWEI_ZH)
        or isPlatform(ANDROID_COOLPAY_ZH)
        or isPlatform(IOS_GAMEVIEW_TC)
        or isPlatform(ANDROID_GIONEE_ZH)
        or isPlatform(ANDROID_ANFENG_ZH)
        or isPlatform(ANDROID_MYEPAY_ZH)
        or isPlatform(ANDROID_HTC_ZH)
        or isPlatform(ANDROID_GV_MFACE_TC_GP)
        or isPlatform(ANDROID_JAGUAR_TC)
        or isPlatform(IOS_HAIMA_ZH)  
        or isPlatform(IOS_DOWNJOYPARK_ZH)  
        or isPlatform(ANDROID_DOWNJOY_ZH) then
        
        tpSSOLogin({}, "ssoLoginSucc", "ssoLoginFail")

    elseif onPlatform("TGAME") then

        if SSOPlatform.GetUid() and string.len(SSOPlatform.GetUid()) > 0 then
            if getLoginMainLayer() then
                getLoginMainLayer():refreshUid()
            end
            ssoLogin()
        else
            tpSSOLogin({}, "ssoLoginSucc", "ssoLoginFail")
        end

    elseif isPlatform(ANDROID_XIAOMI_ZH) then

        tpSSOLogin({}, "ssoLoginXiaoMiSucc", "ssoLoginFail")

    elseif isPlatform(ANDROID_OPPO_ZH) then

        tpSSOLogin({}, "ssoLoginOPPOSucc", "ssoLoginFail")

    elseif isPlatform(IOS_VIETNAM_VI) 
        or isPlatform(IOS_VIETNAM_EN) 
        or isPlatform(IOS_VIETNAM_ENSAGA)
        or isPlatform(IOS_MOBNAPPLE_EN)
        or isPlatform(IOS_MOB_THAI)
        or isPlatform(ANDROID_VIETNAM_VI)
        or isPlatform(ANDROID_VIETNAM_EN)
        or isPlatform(ANDROID_VIETNAM_MOB_THAI)
        or isPlatform(ANDROID_VIETNAM_EN_ALL)
        or isPlatform(IOS_MOBGAME_SPAIN)
        or isPlatform(ANDROID_MOBGAME_SPAIN) then

        if Global:getUid() and string.len(Global:getUid()) > 0 then
            SSOPlatform.setSid(Global:getUid())
            SSOPlatform.setUid(Global:getUid())
            SSOPlatform.setNickname(Global:getUserName())
            if getLoginMainLayer() then
                getLoginMainLayer():refreshUid()
            end
            ssoLogin()
        end

    elseif isPlatform(IOS_91_ZH) or isPlatform(IOS_AISI_ZH)then
        -- 91未做

    elseif isPlatform(IOS_AISIPARK_ZH) then
        -- 调出爱思的SDK页面
        tpSSOLogin({}, "ssoLoginSucc", "ssoLoginFail")

    elseif isPlatform(WP_VIETNAM_VN) then
        getSSOUid() 
    elseif isPlatform(WP_VIETNAM_EN) then
        getSSOUid() 

    elseif isPlatform(IOS_IIAPPLE_ZH) then

        if SSOPlatform.GetUid() and string.len(SSOPlatform.GetUid()) > 0 then
            if getLoginMainLayer() then
                getLoginMainLayer():refreshUid()
            end
            ssoLogin()
        else
            tpSSOLogin({}, "ssoLoginSucc", "ssoLoginFail")
        end
    else 
        -- 未接第三方平台去取sso uid
        getSSOUid()     -- 
    end
    -- 添加点击反馈层
    local scene = CCDirector:sharedDirector():getRunningScene()
    if scene then
        scene:addChild(createTouchFeedbackLayer(), 9998, 9998)
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
end

-- 新号，则强制下一个配置文件，然后再走注册流程
local function _userNotFound()
    _isNewer = true
    doDownLoadConf("CONFIGURE_URL", CONF_PATH..CONF_FILE_NAME, downloadFinished)
end

local function loginCallBack(url, rtnData)  
     local rtnCode = rtnData["code"]
     --这句打开西班牙会飞
     -- PrintTable(rtnData)
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

    if rtnData["info"]["freeFestival"] == "1" then
        IsFreeFestival = true
    else
        IsFreeFestival = false
    end
    

    if not rtnInfo then
        return
    end

    userdata:fromDictionary(rtnInfo)

    if isPlatform(IOS_INFIPLAY_RUS) then
        Global:instance():GATrackEvent("enterGame","loginGame","login",1)
        Global:instance():AFTrackEvent("loginGame","username:"..SSOPlatform.GetUid())
    end

    if isPlatform(ANDROID_INFIPLAY_RUS) then
        Global:instance():GATrackEvent("enterGame","loginGame","login",1)
        Global:instance():ADjustEvent("logingame",SSOPlatform.GetUid())
    end
    if onPlatform("TGAME") then
        if isPlatform(IOS_TGAME_TC) or isPlatform(IOS_TGAME_TH) then
            Global:setTGAMEUser(userdata.userId, userdata.username, userdata.serverCode, userdata.selectServer.serverName) 
        end 
        -- Global:instance():TgameRoleLoginSucc("loginGame","userid:"..userdata.userId)
    end

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
        print("---- print meiyou peizhi wenjian ?????? ----loginview.lua-- ")
        doDownLoadConf("CONFIGURE_URL", CONF_PATH..CONF_FILE_NAME, downloadFinished)
    -- end
end

local function loginGame()
    print("loginGame notice recieve")
    local params = {}
    local params1 = {}
    if isPlatform(IOS_KY_ZH)
        or isPlatform(IOS_TBT_ZH)
        or isPlatform(IOS_TBTPARK_ZH) then

        table.insert(params, SSOPlatform.GetSid())

    elseif isPlatform(IOS_PPZS_ZH) 
        or isPlatform(IOS_PPZSPARK_ZH)
        or isPlatform(ANDROID_UC_ZH) 
        or isPlatform(ANDROID_WDJ_ZH) 
        or isPlatform(ANDROID_DK_ZH) 
        or isPlatform(IOS_ITOOLS) 
        or isPlatform(IOS_ITOOLSPARK)
        or isPlatform(ANDROID_XIAOMI_ZH)
        or isPlatform(ANDROID_AGAME_ZH)
        or onPlatform("TGAME")
        or isPlatform(ANDROID_MYEPAY_ZH)
        or isPlatform(ANDROID_HTC_ZH)
        or isPlatform(IOS_91_ZH) 
        or isPlatform(ANDROID_91_ZH) 
        or isPlatform(IOS_HAIMA_ZH) then
        
        table.insert(params, SSOPlatform.GetUid())
        table.insert(params, SSOPlatform.GetSid())

    elseif isPlatform(ANDROID_ANFENG_ZH) then
        
        table.insert(params, SSOPlatform.GetNickname())
        table.insert(params, SSOPlatform.GetUid())
        table.insert(params, SSOPlatform.GetToken())
        

    elseif isPlatform(ANDROID_GV_MFACE_ZH) 
        or isPlatform(ANDROID_GV_MFACE_EN) 
        or isPlatform(ANDROID_GV_MFACE_EN_OUMEI)
        or isPlatform(ANDROID_GV_MFACE_EN_OUMEINEW)
        or isPlatform(IOS_GAMEVIEW_ZH) 
        or isPlatform(IOS_GAMEVIEW_EN) 
        or isPlatform(IOS_GVEN_BREAK)
        or isPlatform(ANDROID_GV_XJP_ZH) 
        or isPlatform(ANDROID_MMY_ZH)
        or isPlatform(ANDROID_GV_MFACE_TC)
        or isPlatform(IOS_GAMEVIEW_TC)
        or isPlatform(IOS_AISI_ZH)
        or isPlatform(IOS_AISIPARK_ZH)
        or isPlatform(ANDROID_HUAWEI_ZH)
        or isPlatform(ANDROID_GIONEE_ZH)
        or isPlatform(ANDROID_GV_MFACE_TC_GP)
        or isPlatform(ANDROID_JAGUAR_TC)
        or isPlatform(IOS_IIAPPLE_ZH)
        or isPlatform(IOS_KYPARK_ZH)
        or isPlatform(ANDROID_KY_ZH)
        or isPlatform(IOS_XYZS_ZH)
        or isPlatform(ANDROID_XYZS_ZH)
        or isPlatform(IOS_DOWNJOYPARK_ZH)  
        or isPlatform(ANDROID_DOWNJOY_ZH) then

        table.insert(params, SSOPlatform.GetUid())
        table.insert(params, SSOPlatform.GetToken())

    elseif isPlatform(ANDROID_360_ZH) then

        table.insert(params, SSOPlatform.GetToken())

    elseif isPlatform(ANDROID_OPPO_ZH) then
        table.insert(params, SSOPlatform.GetUid())
        table.insert(params, SSOPlatform.GetSid())
        table.insert(params, SSOPlatform.GetSecret())

    elseif isPlatform(IOS_VIETNAM_VI) 
        or isPlatform(IOS_VIETNAM_EN)  
        or isPlatform(IOS_VIETNAM_ENSAGA)
        or isPlatform(IOS_MOB_THAI)
        or isPlatform(IOS_MOBNAPPLE_EN)
        or isPlatform(ANDROID_VIETNAM_MOB_THAI)
        or isPlatform(ANDROID_BAIDU_ZH) 
        or isPlatform(ANDROID_BAIDUIAPPPAY_ZH) 
        or isPlatform(ANDROID_MM_ZH) 
        or isPlatform(ANDROID_VIETNAM_VI) 
        or isPlatform(ANDROID_VIETNAM_EN)
        or isPlatform(ANDROID_VIETNAM_EN_ALL)
        or isPlatform(ANDROID_COOLPAY_ZH)
        or isPlatform(IOS_MOBGAME_SPAIN)
        or isPlatform(ANDROID_MOBGAME_SPAIN) then

        -- table.insert(params, "6998534")

        table.insert(params, SSOPlatform.GetUid())
    

    elseif isPlatform(IOS_INFIPLAY_RUS) or isPlatform(ANDROID_INFIPLAY_RUS) then
        table.insert(params, SSOPlatform.m_guid)
    elseif isPlatform(WP_VIETNAM_VN) then
        table.insert(params, SSOPlatform.m_guid)
        table.insert(params, SSOPlatform.vn_access_token)
    elseif isPlatform(WP_VIETNAM_EN) then
        table.insert(params, SSOPlatform.m_guid)
        table.insert(params, SSOPlatform.vn_access_token)
    else

        table.insert(params, opAppId)
        table.insert(params, SSOPlatform.GetUid())
        table.insert(params, SSOPlatform.GetSid())

    end
    table.insert(params1, params)
--    print("xibanyaxibanyaxibanya")
    doActionFun("LOGIN_URL", params1, loginCallBack)
end

function downloadErr(code)
    if code == -1 then
        doDownLoadConf("CONFIGURE_URL", CONF_PATH..CONF_FILE_NAME, downloadFinished)
    end
end

function getLoginLayer()
    return _loginLayer
end 

function LoginLayer()
    init()

    function _loginLayer:getSSOUid()
        getSSOUid()
    end

    function _loginLayer:showMain()
        _showMain()
    end

    function _loginLayer:showServer()
        _showServer()
    end

    function _loginLayer:showLogin()
        _showLogin()
    end

    function _loginLayer:showNewAccount()
        _showNewAccount()
    end

    function _loginLayer:showModifyPwd()
        _showModifyPwd()
    end

    function _loginLayer:showUpdate()
        _showUpdate()
    end

    local function _onEnter()
        playMusic(MUSIC_SOUND_0, true)
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(1), CCCallFunc:create(_addTouchFBLayer))
        _loginLayer:runAction(seq)
        
        addObserver(HL_SSO_GenerateUid, SSOGenerateUidNoti)
        addObserver(HL_SSO_Login, Login_SSOLoginNoti)
        addObserver(HL_SSO91_Login, Login_SSO91LoginNoti)
        addObserver(HL_SSOXIAOMI_Login, Login_SSOXIAOMILoginNoti)
        addObserver(HL_SSOOPPO_Login, Login_SSOOPPOLoginNoti)
        addObserver(HL_SSO_Register, Login_SSORegisterNoti)
        addObserver(HL_SSO_GetServerList, SSOGetServerListNoti)
        addObserver(HL_SSO_ERROR, Login_SSOError)
        addObserver(HL_PLATFORM_LOGIN, Login_PlatformNoti)
        addObserver(NOTI_LOGIN_GAME, loginGame)
        addObserver(NOTI_DOWNLOAD_ERR, downloadErr)
    end

    local function _onExit()
        removeObserver(HL_SSO_GenerateUid, SSOGenerateUidNoti)
        removeObserver(HL_SSO_Login, Login_SSOLoginNoti)
        removeObserver(HL_SSO91_Login, Login_SSO91LoginNoti)
        removeObserver(HL_SSOXIAOMI_Login, Login_SSOXIAOMILoginNoti)
        removeObserver(HL_SSOOPPO_Login, Login_SSOOPPOLoginNoti)
        removeObserver(HL_SSO_Register, Login_SSORegisterNoti)
        removeObserver(HL_SSO_GetServerList, SSOGetServerListNoti)
        removeObserver(HL_SSO_ERROR, Login_SSOError)
        removeObserver(HL_PLATFORM_LOGIN, Login_PlatformNoti)
        removeObserver(NOTI_LOGIN_GAME, loginGame)
        removeObserver(NOTI_DOWNLOAD_ERR, downloadErr)
    end

    local function _cleanup(  )
        ccb["LoginLayerOwner"] = nil
        _loginLayer:removeAllChildrenWithCleanup(true)
        _loginLayer = nil
        if not isSpringFestival then
            CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile("ccbResources/login.plist")
        else
            CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile("ccbResources/loginSpring.plist")
        end
        CCTextureCache:sharedTextureCache():removeUnusedTextures()
    end 

    --onEnter onExit
    local function layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        elseif eventType == "cleanup" then
            if _cleanup then _cleanup() end
        end
    end
    _loginLayer:registerScriptHandler(layerEventHandler)

    return _loginLayer
end
