local _layer
local _priority = -132
local _nameEdit
local _keyEdit
local _flagType = 0     -- 左边为0   右边为1
local _heroId
local _names
local _cursor

-- 名字不要重复
CreateNameOwner = CreateNameOwner or {}
ccb["CreateNameOwner"] = CreateNameOwner

local function onOkClicked()
    Global:instance():TDGAonEventAndEventData("name2")
    if isPlatform(ANDROID_JAGUAR_TC) then
        Global:instance():JaguarTrackRoleCreated()
    end
    print("onOkClicked")
    local name = _nameEdit:getText()
    if name == nil or string.len(name) <= 0 then
        ShowText(HLNSLocalizedString("register.name.null"))
        return
    end 

    -- 配置文件下载完毕
    local function downloadFinished()
        
        loadAllConfigureFile()

        -- 处理新手
        if _isNewer then
            return
        else
            -- 正常登陆
            -- 启动定时器
            startTimer()
            if platformType() == PLATFORM_TYPE["9158"] then
                -- Global:TDGAcpaRegisterSuc(userdata.userId)
            end
            CCSpriteFrameCache:sharedSpriteFrameCache():removeUnusedSpriteFrames()
            CCTextureCache:sharedTextureCache():removeUnusedTextures()
            CCDirector:sharedDirector():replaceScene(CCTransitionFade:create(0.6, mainSceneFun()))
        end
    end

    local function registerCallBack(url, rtnData)
        local rtnCode = rtnData["code"]

        local rtnInfo = rtnData["info"]
        if not rtnInfo then
            return
        end
        userdata:fromDictionary(rtnInfo)

        announceData.serverNotice = rtnInfo["serverNotice"]

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
        --         startTimer()
        --         if platformType() == PLATFORM_TYPE["9158"] then
        --             -- Global:TDGAcpaRegisterSuc(userdata.userId)
        --         end
        --         CCDirector:sharedDirector():replaceScene(CCTransitionFade:create(0.6, mainSceneFun()))
        --     end
        -- else
        --     -- 下载配置文件
            print("---- print meiyou peizhi wenjian ?????? ----createnameView.lua-- ")
            doDownLoadConf("CONFIGURE_URL", CONF_PATH..CONF_FILE_NAME, downloadFinished)
           
            if isPlatform(IOS_INFIPLAY_RUS) then
                Global:instance():AFTrackEvent("registration","username:"..SSOPlatform.GetUid())
                -- Global:instance():ADjustEvent("registration","username:"..SSOPlatform.GetUid())
            end
            -- if isPlatform(ANDROID_INFIPLAY_RUS) then
            --     Global:instance():ADjustEvent("registration","username:"..SSOPlatform.GetUid())
            -- end

            if onPlatform("TGAME") then
                Global:instance():TgameRoleRegisterSucc(userdata.userId)
            end
    end

    local params = {}
    
    if isPlatform(IOS_TEST_ZH) 
        or isPlatform(ANDROID_TEST_ZH) 
        or isPlatform(IOS_TW_ZH) 
        or isPlatform(ANDROID_TW_ZH)
        or isPlatform(IOS_APPLE_ZH)
        or isPlatform(IOS_APPLE2_ZH) then

        table.insert(params, opAppId)
        table.insert(params, SSOPlatform.GetUid())
        table.insert(params, SSOPlatform.GetSid())

    elseif isPlatform(IOS_PPZS_ZH) 
        or isPlatform(IOS_PPZSPARK_ZH)
        or isPlatform(IOS_ITOOLS) 
        or isPlatform(IOS_ITOOLSPARK)
        or isPlatform(ANDROID_UC_ZH)
        or isPlatform(IOS_91_ZH) 
        or isPlatform(ANDROID_91_ZH) 
        or isPlatform(ANDROID_XIAOMI_ZH) 
        or isPlatform(ANDROID_AGAME_ZH) 
        or isPlatform(ANDROID_WDJ_ZH) 
        or isPlatform(ANDROID_DK_ZH) 
        or onPlatform("TGAME")
        or onPlatform("HTC")
        or isPlatform(ANDROID_MYEPAY_ZH) 
        or isPlatform(IOS_HAIMA_ZH) then

        table.insert(params, SSOPlatform.GetUid())
        table.insert(params, SSOPlatform.GetSid())

    elseif isPlatform(ANDROID_ANFENG_ZH) then

        table.insert(params, SSOPlatform.GetNickname())
        table.insert(params, SSOPlatform.GetUid())
        table.insert(params, SSOPlatform.GetToken())
    
    elseif isPlatform(IOS_VIETNAM_VI) 
        or isPlatform(IOS_VIETNAM_EN) 
        or isPlatform(IOS_VIETNAM_ENSAGA) 
        or isPlatform(IOS_MOBNAPPLE_EN)
        or isPlatform(IOS_MOB_THAI)
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

        table.insert(params, SSOPlatform.GetUid())
        table.insert(params, "")

    elseif isPlatform(ANDROID_GV_MFACE_ZH) 
        or isPlatform(ANDROID_GV_MFACE_EN) 
        or isPlatform(ANDROID_GV_MFACE_EN_OUMEI)
        or isPlatform(ANDROID_GV_MFACE_EN_OUMEINEW)
        or isPlatform(IOS_GAMEVIEW_ZH) 
        or isPlatform(IOS_GAMEVIEW_EN) 
        or isPlatform(IOS_GVEN_BREAK)
        or isPlatform(ANDROID_GV_XJP_ZH) 
        or isPlatform(ANDROID_MMY_ZH)
        or isPlatform(IOS_GAMEVIEW_TC)
        or isPlatform(ANDROID_GV_MFACE_TC)
        or isPlatform(ANDROID_GV_MFACE_TC_GP)
        or isPlatform(IOS_AISI_ZH)
        or isPlatform(IOS_AISIPARK_ZH)
        or isPlatform(ANDROID_GIONEE_ZH) 
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

    elseif isPlatform(ANDROID_OPPO_ZH) then

        table.insert(params, SSOPlatform.GetUid())
        table.insert(params, SSOPlatform.GetSid())
        table.insert(params, SSOPlatform.GetSecret())

    elseif isPlatform(ANDROID_360_ZH)
        or isPlatform(ANDROID_HUAWEI_ZH) then

        table.insert(params,SSOPlatform.GetToken())
        
    elseif isPlatform(IOS_INFIPLAY_RUS)
        or isPlatform(ANDROID_INFIPLAY_RUS) then

        table.insert(params,SSOPlatform.m_guid)
        table.insert(params,"")
    elseif isPlatform(WP_VIETNAM_VN) then
        table.insert(params,SSOPlatform.m_guid)
        table.insert(params,SSOPlatform.vn_access_token)
    elseif isPlatform(WP_VIETNAM_EN) then
        table.insert(params,SSOPlatform.m_guid)
        table.insert(params,SSOPlatform.vn_access_token)
    else 

        table.insert(params,SSOPlatform.GetSid())
    end
    table.insert(params, name)
    table.insert(params, _heroId)
    table.insert(params, _flagType == 0 and "flag_004" or "flag_010")
    if isPlatform(ANDROID_AGAME_ZH) then

        table.insert(params, "")
        table.insert(params, "")
        table.insert(params, Global:instance():getSmallPCLStr())

    end
    local params1 = {}
    table.insert(params1, params)
    doActionFun("REGISTER_URL", params1, registerCallBack)
end
CreateNameOwner["onOkClicked"] = onOkClicked

local function onSelectFlag1()
    print("onSelectFlag1")
    if _flagType ~= 0 then
        _flagType = 0
        local flagBtn1 = tolua.cast(CreateNameOwner["flagBtn1"], "CCMenuItemImage")
        local flagBtn2 = tolua.cast(CreateNameOwner["flagBtn2"], "CCMenuItemImage")
        flagBtn1:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("flagBg_1.png"))
        flagBtn2:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("flagBg_0.png"))
    end
end
CreateNameOwner["onSelectFlag1"] = onSelectFlag1

local function onSelectFlag2()
    print("onSelectFlag2")
    if _flagType ~= 1 then
        _flagType = 1
        local flagBtn1 = tolua.cast(CreateNameOwner["flagBtn1"], "CCMenuItemImage")
        local flagBtn2 = tolua.cast(CreateNameOwner["flagBtn2"], "CCMenuItemImage")
        flagBtn1:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("flagBg_0.png"))
        flagBtn2:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("flagBg_1.png"))
    end
end
CreateNameOwner["onSelectFlag2"] = onSelectFlag2

local function _setName()
    _nameEdit:setText(_names[tostring(_cursor)])
    _cursor = _cursor + 1
end

local function diceCallBack( url, rtnData )
    _cursor = 0
    _names = rtnData.info.names
    _setName()
end 

local function onRandomNameClicked(  )
    Global:instance():TDGAonEventAndEventData("name1")
    if not _names or _cursor > table.getTableCount(_names) then
        doActionFun("PICKNAME_URL", {}, diceCallBack)
    else
        _setName()
    end
end 
CreateNameOwner["onRandomNameClicked"] = onRandomNameClicked

local function _refreshUI()
    local nameEditLayer = CreateNameOwner["nameEditBg"]
    _nameEdit = CCEditBox:create(CCSize(nameEditLayer:getContentSize().width,nameEditLayer:getContentSize().height),CCScale9Sprite:createWithSpriteFrameName("chat_bg.png"))
    _nameEdit:setPosition(ccp(0,0))
    _nameEdit:setAnchorPoint(ccp(0,0))
    _nameEdit:setFont("ccbResources/FZCuYuan-M03S.ttf",30*retina)
    nameEditLayer:addChild(_nameEdit)
    _nameEdit:setTouchPriority(_priority-1)
end 

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/CreateNameView.ccbi", proxy, true,"CreateNameOwner")
    _layer = tolua.cast(node,"CCLayer")

    _refreshUI()
end

local function onTouchBegan(x, y)
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
    local menu1 = tolua.cast(CreateNameOwner["menu"], "CCMenu")
    menu1:setHandlerPriority(_priority-1)

    -- 默认获取一个名字
end

-- 该方法名字每个文件不要重复
function getCreateNameLayer()
    return _layer
end

function createCreateNameLayer(heroId, priority)
    _heroId = heroId
    _priority = (priority ~= nil) and priority or -132
    _init()

    local function _onEnter()
        print("CreateNameLayer onEnter")
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
        doActionFun("PICKNAME_URL", {}, diceCallBack)
    end

    local function _onExit()
        print("CreateNameLayer onExit")
        _layer = nil
        _nameEdit = nil
        -- _keyEdit = nil
        _priority = -132
        _heroId = nil
        _names = nil
        _cursor = 0
        _isNewer = false
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