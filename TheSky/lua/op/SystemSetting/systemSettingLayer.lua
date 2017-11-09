local _layer
local _tableView = nil
local cellArray = {}

SystemSettingLayerOwner = SystemSettingLayerOwner or {}
ccb["SystemSettingLayerOwner"] = SystemSettingLayerOwner


local function registerSucc()
    _tableView:reloadData()
end

-- 登出游戏

function logoutAction(...)
    print("logoutAction")
    userdata:resetAllData()

    if isPlatform(ANDROID_WDJ_ZH)
        or isPlatform(ANDROID_DK_ZH) 
        or isPlatform(IOS_91_ZH) 
        or isPlatform(IOS_KY_ZH)
        or isPlatform(IOS_ITOOLS) 
        or isPlatform(IOS_ITOOLSPARK)
        or isPlatform(IOS_PPZS_ZH) 
        or isPlatform(IOS_PPZSPARK_ZH)
        or isPlatform(IOS_TBT_ZH) 
        or isPlatform(IOS_TBTPARK_ZH) 
        or isPlatform(IOS_HAIMA_ZH) 
        or isPlatform(ANDROID_91_ZH) 
        or isPlatform(IOS_VIETNAM_VI) 
        or isPlatform(IOS_VIETNAM_EN) 
        or isPlatform(IOS_VIETNAM_ENSAGA)
        or isPlatform(IOS_MOBNAPPLE_EN)
        or isPlatform(IOS_MOBGAME_SPAIN)
        or isPlatform(ANDROID_MOBGAME_SPAIN)
        or isPlatform(IOS_MOB_THAI)
        or isPlatform(ANDROID_BAIDU_ZH)
        or isPlatform(ANDROID_BAIDUIAPPPAY_ZH) 
        or isPlatform(ANDROID_MM_ZH) 
        or isPlatform(ANDROID_VIETNAM_VI) 
        or isPlatform(ANDROID_VIETNAM_EN) 
        or isPlatform(ANDROID_VIETNAM_EN_ALL)
        or isPlatform(ANDROID_VIETNAM_MOB_THAI)
        or isPlatform(ANDROID_XIAOMI_ZH) 
        or isPlatform(ANDROID_OPPO_ZH) 
        or isPlatform(ANDROID_360_ZH) 
        or isPlatform(ANDROID_MMY_ZH)
        or isPlatform(ANDROID_COOLPAY_ZH)
        or isPlatform(ANDROID_HUAWEI_ZH)
        or isPlatform(ANDROID_ANFENG_ZH)
        or isPlatform(ANDROID_GIONEE_ZH)
        or isPlatform(ANDROID_HTC_ZH)
        or isPlatform(IOS_AISI_ZH)
        or isPlatform(IOS_AISIPARK_ZH)
        or isPlatform(IOS_DOWNJOYPARK_ZH)
        or isPlatform(ANDROID_DOWNJOY_ZH)
        or isPlatform(ANDROID_MYEPAY_ZH)
        or onPlatform("TGAME")
        or isPlatform(ANDROID_JAGUAR_TC)
        or isPlatform(IOS_IIAPPLE_ZH) 
        or isPlatform(IOS_XYZS_ZH) then

        SSOPlatform.setSid(nil)
        SSOPlatform.setUid(nil)
        SSOPlatform.setNickname(nil)
        SSOPlatform.setSecret(nil)
        SSOPlatform.setToken(nil)

    elseif isPlatform(IOS_KYPARK_ZH)
        or isPlatform(ANDROID_KY_ZH)  then

        local guid = ...
        SSOPlatform.m_guid = guid
    end
    if not getLoginLayer() then
        
        local  function logoutAndroidKR()
            print("logoutAndroidKR")
            local loginScene = CCScene:create()
            loginScene:addChild(LoginLayer())
            CCDirector:sharedDirector():replaceScene(CCTransitionFade:create(1.0, loginScene))
        end
        if isPlatform(ANDROID_TGAME_KR) or isPlatform(ANDROID_TGAME_KRNEW) or isPlatform(ANDROID_DOWNJOY_ZH) or isPlatform(ANDROID_TGAME_THAI) or isPlatform(ANDROID_TGAME_TC) then
            local seq = CCSequence:createWithTwoActions(CCDelayTime:create(1), CCCallFunc:create(logoutAndroidKR))
            getMainLayer():runAction(seq)
        else    
            local loginScene = CCScene:create()
            loginScene:addChild(LoginLayer())
            CCDirector:sharedDirector():replaceScene(CCTransitionFade:create(0.5, loginScene))
        end
    end
end



function logOutPPZSSuccCallBack()
    logoutAction()
end

-- 快用用户系统sdk关闭回调
function kuaiYongUserSdkClose()
    userdata:subDCount()
end
-- 平台登出失败回调
function logOutFailCallBack()
    userdata:subDCount()
    ShowText(HLNSLocalizedString("登出失败"))
end

local function onExitTaped_set()
    local _mainLayer = getMainLayer()
    if _mainLayer then
        _mainLayer:goToHome()
    end
end

SystemSettingLayerOwner["onExitTaped_set"] = onExitTaped_set

-- type:   0 - 绿色按钮   1 - 红色按钮
local function _setBtnImage(btn, type)
    if nil == btn then
        return
    end 
    if type == 0 then 
        btn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn4_0.png"))
        btn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn4_1.png"))
    else
        btn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn2_0.png"))
        btn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn2_1.png"))
    end 
end 
local function SettingLayerReloadTableView()
    local function _reloadTableView(  )
        if _tableView then
            _tableView:reloadData()
        end 
    end 
    _layer:runAction(CCCallFunc:create(_reloadTableView))
end

-- 国内苹果审核专用
local function _addAppleTableView( )
    -- body 
    local _topLayer = SystemSettingLayerOwner["BSTopLayer"]

    SystemSettingCellViewOwner = SystemSettingCellViewOwner or {}
    ccb["SystemSettingCellViewOwner"] = SystemSettingCellViewOwner

    local function onSystemBtnTap( tag,sender )
        print("onSystemBtnTap",tag)
        local sysBtn = tolua.cast(sender, "CCMenuItemImage")
        local btnLabel = tolua.cast(sysBtn:getParent():getParent():getChildByTag(100), "CCLabelTTF")
        if tag == 0 then
            -- 音乐
            Global:instance():TDGAonEventAndEventData("setting3")
            if not getUDBool(UDefKey.Setting_PlayMusicSound, true) then
                -- 打开音乐
                setUDBool(UDefKey.Setting_PlayMusicSound, true)
                playMusic(MUSIC_SOUND_3, true)
                btnLabel:setString(HLNSLocalizedString("已开启"))
                _setBtnImage(sysBtn, 0)
            else 
                -- 关闭音乐
                setUDBool(UDefKey.Setting_PlayMusicSound, false)
                SimpleAudioEngine:sharedEngine():stopBackgroundMusic()
                btnLabel:setString(HLNSLocalizedString("已关闭"))
                _setBtnImage(sysBtn, 1)
            end
        elseif tag == 1 then
            -- 点击音效
            Global:instance():TDGAonEventAndEventData("setting4")
            if not getUDBool(UDefKey.Setting_PlayMusicEffect, true) then
                -- 打开音效
                setUDBool(UDefKey.Setting_PlayMusicEffect, true)
                btnLabel:setString(HLNSLocalizedString("已开启"))
                _setBtnImage(sysBtn, 0)
            else 
                -- 关闭音效
                setUDBool(UDefKey.Setting_PlayMusicEffect, false)
                btnLabel:setString(HLNSLocalizedString("已关闭"))
                _setBtnImage(sysBtn, 1)
            end
        end
    end

    SystemSettingCellViewOwner["onSystemBtnTap"] = onSystemBtnTap

    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
                r = CCSizeMake(winSize.width, 170 * retina)
        elseif fn == "cellAtIndex" then
            -- 增减新功能需要改动三个地方：设置显示状态、设置点击跳转和修改显示的总条数
            -- 从插入或删除的地方往下的各个index都需要修改
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            local  proxy = CCBProxy:create()
            local _hbCell = tolua.cast(CCBReaderLoad("ccbResources/SystemSettingViewCell.ccbi",proxy,true,"SystemSettingCellViewOwner"),"CCLayer")
            
            local systemLabel = tolua.cast(SystemSettingCellViewOwner["sysLabel"],"CCLabelTTF")
            local sysBtn = tolua.cast(SystemSettingCellViewOwner["sysBtn"],"CCMenuItemImage")
            local btnLabel = tolua.cast(SystemSettingCellViewOwner["btnLabel"],"CCLabelTTF")
            sysBtn:setTag(a1)
            if a1 == 0 then
                systemLabel:setString(HLNSLocalizedString("音乐"))
                if not getUDBool(UDefKey.Setting_PlayMusicSound, true) then
                    btnLabel:setString(HLNSLocalizedString("已关闭"))
                    _setBtnImage(sysBtn, 1)
                else 
                    btnLabel:setString(HLNSLocalizedString("已开启"))
                    _setBtnImage(sysBtn, 0)
                end 
            elseif a1 == 1 then
                systemLabel:setString(HLNSLocalizedString("点击音效"))
                if not getUDBool(UDefKey.Setting_PlayMusicEffect, true) then
                    btnLabel:setString(HLNSLocalizedString("已关闭"))
                    _setBtnImage(sysBtn, 1)
                else 
                    btnLabel:setString(HLNSLocalizedString("已开启"))
                    _setBtnImage(sysBtn, 0)
                end 
            end
            _hbCell:setScale(retina)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            a2:addChild(_hbCell, 0, 1)
            r = a2
        elseif fn == "numberOfCells" then
            -- Return number of cells
            return 0
        -- Cell events:
        elseif fn == "cellTouched" then         -- A cell was touched, a1 is cell that be touched. This is not necessary.
        elseif fn == "cellTouchBegan" then      -- A cell is touching, a1 is cell, a2 is CCTouch
        elseif fn == "cellTouchEnded" then      -- A cell was touched, a1 is cell, a2 is CCTouch
        elseif fn == "cellHighlight" then       -- A cell is highlighting, coco2d-x 2.1.3 or above
        elseif fn == "cellUnhighlight" then     -- A cell had been unhighlighted, coco2d-x 2.1.3 or above
        elseif fn == "cellWillRecycle" then     -- A cell will be recycled, coco2d-x 2.1.3 or above
        end
        return r
    end)
    
    local _mainLayer = getMainLayer()
    if _mainLayer then
        local size = CCSizeMake(winSize.width, (winSize.height - _topLayer:getContentSize().height - _mainLayer:getBottomContentSize().height)*98/100)      -- 这里是为了在tableview上面显示一个小空出来
        _tableView = LuaTableView:createWithHandler(h, size)
        _tableView:setBounceable(true)
        _tableView:setAnchorPoint(ccp(0,0))
        _tableView:setPosition(ccp(0, _mainLayer:getBottomContentSize().height))
        _tableView:setVerticalFillOrder(0)
        _layer:addChild(_tableView) 
    end
end

local function _addTableView()
    local _topLayer = SystemSettingLayerOwner["BSTopLayer"]

    SystemSettingCellViewOwner = SystemSettingCellViewOwner or {}
    ccb["SystemSettingCellViewOwner"] = SystemSettingCellViewOwner

    local function onSystemBtnTap(tag, sender)
        local sysBtn = tolua.cast(sender, "CCMenuItemImage")
        local btnLabel = tolua.cast(sysBtn:getParent():getParent():getChildByTag(100), "CCLabelTTF")
        if tag == 0 then
            Global:instance():TDGAonEventAndEventData("setting2")
            if userdata.weiboId == nil or userdata.weiboToken == nil or userdata.weiboId == "" or userdata.weiboToken == "" then
                setUDBool(UDefKey.Setting_WeiboShareButtonIsClicked, false)
                --1 微博 2 微信
                Global:instance():ShareTo(1)
                    --调用弹框的方法
            else
                Global:instance():logoutWeibo()
            end
        elseif tag == 1 then
            -- 音乐
            Global:instance():TDGAonEventAndEventData("setting3")
            if not getUDBool(UDefKey.Setting_PlayMusicSound, true) then
                -- 打开音乐
                setUDBool(UDefKey.Setting_PlayMusicSound, true)
                playMusic(MUSIC_SOUND_3, true)
                btnLabel:setString(HLNSLocalizedString("已开启"))
                _setBtnImage(sysBtn, 0)
            else 
                -- 关闭音乐
                setUDBool(UDefKey.Setting_PlayMusicSound, false)
                SimpleAudioEngine:sharedEngine():stopBackgroundMusic()
                btnLabel:setString(HLNSLocalizedString("已关闭"))
                _setBtnImage(sysBtn, 1)
            end
        elseif tag == 2 then
            -- 点击音效
            Global:instance():TDGAonEventAndEventData("setting4")
            if not getUDBool(UDefKey.Setting_PlayMusicEffect, true) then
                -- 打开音效
                setUDBool(UDefKey.Setting_PlayMusicEffect, true)
                btnLabel:setString(HLNSLocalizedString("已开启"))
                _setBtnImage(sysBtn, 0)
            else 
                -- 关闭音效
                setUDBool(UDefKey.Setting_PlayMusicEffect, false)
                btnLabel:setString(HLNSLocalizedString("已关闭"))
                _setBtnImage(sysBtn, 1)
            end
        end
    end
    SystemSettingCellViewOwner["onSystemBtnTap"] = onSystemBtnTap

    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
                r = CCSizeMake(winSize.width, 170 * retina)
        elseif fn == "cellAtIndex" then
            -- 增减新功能需要改动三个地方：设置显示状态、设置点击跳转和修改显示的总条数
            -- 从插入或删除的地方往下的各个index都需要修改
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            local  proxy = CCBProxy:create()
            local _hbCell = tolua.cast(CCBReaderLoad("ccbResources/SystemSettingViewCell.ccbi",proxy,true,"SystemSettingCellViewOwner"),"CCLayer")

            --不要微博，直接跳过 
            a1 = a1 + 1

            local systemLabel = tolua.cast(SystemSettingCellViewOwner["sysLabel"],"CCLabelTTF")
            local sysBtn = tolua.cast(SystemSettingCellViewOwner["sysBtn"],"CCMenuItemImage")
            local btnLabel = tolua.cast(SystemSettingCellViewOwner["btnLabel"],"CCLabelTTF")
            sysBtn:setTag(a1)
            if a1 == 0 then
                if userdata.weiboId == nil or userdata.weiboToken == nil or userdata.weiboId == "" or userdata.weiboToken == "" then
                    print("绑定微博")
                    systemLabel:setString(HLNSLocalizedString("绑定微博有好礼"))
                    btnLabel:setString(HLNSLocalizedString("绑定微博"))
                else 
                    print("解除绑定")
                    systemLabel:setString(HLNSLocalizedString("绑定微博有好礼，机会不要错过"))
                    btnLabel:setString(HLNSLocalizedString("解除绑定"))
                end
                _setBtnImage(sysBtn, 0)
            elseif a1 == 1 then
                systemLabel:setString(HLNSLocalizedString("音乐"))
                if not getUDBool(UDefKey.Setting_PlayMusicSound, true) then
                    btnLabel:setString(HLNSLocalizedString("已关闭"))
                    _setBtnImage(sysBtn, 1)
                else 
                    btnLabel:setString(HLNSLocalizedString("已开启"))
                    _setBtnImage(sysBtn, 0)
                end 
            elseif a1 == 2 then
                systemLabel:setString(HLNSLocalizedString("点击音效"))
                if not getUDBool(UDefKey.Setting_PlayMusicEffect, true) then
                    btnLabel:setString(HLNSLocalizedString("已关闭"))
                    _setBtnImage(sysBtn, 1)
                else 
                    btnLabel:setString(HLNSLocalizedString("已开启"))
                    _setBtnImage(sysBtn, 0)
                end 
            elseif a1 == 3 then
                systemLabel:setString(HLNSLocalizedString("活动"))
            elseif a1 == 4 then
                systemLabel:setString(HLNSLocalizedString("帮助"))
            elseif a1 == 5 then
                systemLabel:setString(HLNSLocalizedString("反馈bug或建议"))
            elseif a1 == 6 then
                systemLabel:setString(HLNSLocalizedString("点击输入兑换礼品CD-KEY"))
            elseif a1 == 7 then
                systemLabel:setString(HLNSLocalizedString("联系客服"))
            else
                local function addInfo()
                    local layer = tolua.cast(systemLabel:getParent(), "CCLayer")
                    local server = CCLabelTTF:create(userdata.selectServer.serverName, "ccbResources/FZCuYuan-M03S", 22) 
                    layer:addChild(server)
                    server:setAnchorPoint(ccp(1, 0.5))
                    server:setPosition(ccp(layer:getContentSize().width * 0.95, layer:getContentSize().height / 2))
                    local user = CCLabelTTF:create(userdata.name, "ccbResources/FZCuYuan-M03S", 22)
                    layer:addChild(user)
                    user:setAnchorPoint(ccp(1, 0.5))
                    user:setPosition(ccp(layer:getContentSize().width * 0.95, layer:getContentSize().height / 4 * 3))
                    local CFBundleVersion = uDefault:getStringForKey(opPCL.."_ver")
                    local ver = CCLabelTTF:create(string.format("%s (%s)", CFBundleVersion, opVersion), "ccbResources/FZCuYuan-M03S", 22)
                    layer:addChild(ver)
                    ver:setAnchorPoint(ccp(1, 0.5))
                    ver:setPosition(ccp(layer:getContentSize().width * 0.95, layer:getContentSize().height / 4))
                end
                if isPlatform(IOS_KY_ZH)
                    or isPlatform(IOS_KYPARK_ZH)
                    or isPlatform(IOS_91_ZH)
                    or isPlatform(ANDROID_360_ZH)
                    or isPlatform(ANDROID_WDJ_ZH)
                    or isPlatform(ANDROID_AGAME_ZH)
                    or isPlatform(ANDROID_ANFENG_ZH)
                    or isPlatform(ANDROID_UC_ZH) then -- or opPCL == IOS_PPZS_ZH then

                    if a1 == 8 then 
                        systemLabel:setString(HLNSLocalizedString("登出游戏"))
                        addInfo()
                    end

                else
                    if a1 == 8 then
                        if isPlatform(IOS_PPZS_ZH) or isPlatform(IOS_PPZSPARK_ZH) then 

                            systemLabel:setString(HLNSLocalizedString("pp助手中心"))

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

                            systemLabel:setString(HLNSLocalizedString("system.dashboard"))

                        elseif isPlatform(IOS_TBT_ZH) 
                            or isPlatform(IOS_TBTPARK_ZH)
                            or isPlatform(IOS_HAIMA_ZH)  
                            or isPlatform(IOS_ITOOLS)
                            or isPlatform(IOS_ITOOLSPARK) 
                            or isPlatform(ANDROID_OPPO_ZH) 
                            or isPlatform(ANDROID_91_ZH) 
                            or isPlatform(ANDROID_DK_ZH) 
                            or isPlatform(ANDROID_MMY_ZH)
                            or isPlatform(IOS_AISI_ZH)
                            or isPlatform(IOS_AISIPARK_ZH)
                            or isPlatform(IOS_DOWNJOYPARK_ZH)
                            or isPlatform(ANDROID_DOWNJOY_ZH)
                            or onPlatform("TGAME")
                            or isPlatform(ANDROID_HTC_ZH)
                            or isPlatform(IOS_IIAPPLE_ZH)
                            or isPlatform(IOS_XYZS_ZH) then

                            systemLabel:setString(HLNSLocalizedString("用户中心"))

                        elseif isPlatform(ANDROID_BAIDU_ZH) 
                            or isPlatform(ANDROID_BAIDUIAPPPAY_ZH) 
                            or isPlatform(ANDROID_XIAOMI_ZH)
                            or isPlatform(ANDROID_MM_ZH)
                            or isPlatform(ANDROID_COOLPAY_ZH) then

                            systemLabel:setString(HLNSLocalizedString("进入论坛"))

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

                            systemLabel:setString(HLNSLocalizedString("进入facebook粉丝团"))

                        elseif SSOPlatform.IsTourist() then

                            systemLabel:setString(HLNSLocalizedString("绑定账号"))

                        else
                            systemLabel:setString(HLNSLocalizedString("登出游戏"))
                            addInfo()

                        end
                    elseif a1 == 9 then
                        systemLabel:setString(HLNSLocalizedString("登出游戏"))
                        addInfo()
                    end
                end
            end
            if a1 >= 3 then
                sysBtn:setVisible(false)
                btnLabel:setVisible(false)
            end
            _hbCell:setScale(retina)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            a2:addChild(_hbCell, 0, 1)
            _hbCell:stopAllActions()
            cellArray[tostring(a1)] = _hbCell
            r = a2
        elseif fn == "numberOfCells" then
            -- Return number of cells

            if isPlatform(IOS_KY_ZH) 
                or isPlatform(IOS_KYPARK_ZH)
                or isPlatform(ANDROID_91_ZH) 
                or isPlatform(ANDROID_DK_ZH) 
                or isPlatform(ANDROID_BAIDU_ZH)
                or isPlatform(ANDROID_BAIDUIAPPPAY_ZH)
                or isPlatform(ANDROID_MMY_ZH)
                or isPlatform(ANDROID_AGAME_ZH) 
                or isPlatform(IOS_91_ZH) 
                or isPlatform(ANDROID_ANFENG_ZH)
                or isPlatform(ANDROID_360_ZH) 
                or isPlatform(ANDROID_WDJ_ZH) 
                or isPlatform(ANDROID_UC_ZH) then

                r = 8

            elseif isPlatform(IOS_VIETNAM_VI) 
                or isPlatform(IOS_VIETNAM_EN) 
                or isPlatform(IOS_VIETNAM_ENSAGA)
                or isPlatform(IOS_MOBNAPPLE_EN)
                or isPlatform(IOS_MOB_THAI)
                or isPlatform(ANDROID_VIETNAM_VI)
                or isPlatform(ANDROID_VIETNAM_EN)
                or isPlatform(ANDROID_VIETNAM_EN_ALL)
                or isPlatform(IOS_MOBGAME_SPAIN)
                or isPlatform(ANDROID_MOBGAME_SPAIN)
                or isPlatform(ANDROID_VIETNAM_MOB_THAI)
                or onPlatform("TGAME")
                or isPlatform(ANDROID_GV_MFACE_TC)
                or isPlatform(IOS_GAMEVIEW_TC)
                or isPlatform(ANDROID_GV_MFACE_ZH) 
                or isPlatform(ANDROID_GV_MFACE_EN) 
                or isPlatform(ANDROID_GV_MFACE_EN_OUMEI)
                or isPlatform(ANDROID_GV_MFACE_EN_OUMEINEW)
                or isPlatform(IOS_GAMEVIEW_ZH) 
                or isPlatform(IOS_GAMEVIEW_EN) 
                or isPlatform(IOS_GVEN_BREAK)
                or isPlatform(ANDROID_GV_XJP_ZH)
                or isPlatform(IOS_AISI_ZH)
                or isPlatform(IOS_AISIPARK_ZH)
                or isPlatform(IOS_DOWNJOYPARK_ZH)
                or isPlatform(ANDROID_DOWNJOY_ZH)
                or isPlatform(IOS_XYZS_ZH)
                or isPlatform(ANDROID_HTC_ZH)
                or isPlatform(ANDROID_GV_MFACE_TC_GP) then

                r = 9

            else

                if userdata:getVipAuditState() then
                    -- 苹果审核区的话，我们仅开放6项
                    r = 5
                else 
                    r = SSOPlatform.IsTourist() and 9 or 8
                end

            end
        -- Cell events:
        elseif fn == "cellTouched" then         -- A cell was touched, a1 is cell that be touched. This is not necessary.
            local tIndex = a1:getIdx()
            -- 不要微博，直接跳过
            tIndex = tIndex + 1
            if tIndex == 3 then
                Global:instance():TDGAonEventAndEventData("news5")
                if getMainLayer() then
                    getMainLayer():addChild(createAnnounceLayer( -140 ),100)
                end
            elseif tIndex == 4 then
                Global:instance():TDGAonEventAndEventData("news6")
                if getMainLayer() then
                    getMainLayer():gotoHelpLayer()
                end
            elseif tIndex == 5 then
                print("setsetset22222")
                Global:instance():TDGAonEventAndEventData("news7")
                if isPlatform(ANDROID_JAGUAR_TC) then
                    Global:instance():JGCustomerFeedback(userdata.userId,userdata.serverCode,userdata.name)
                else
                    print("getgetget11111")
                    if getMainLayer() then
                        getMainLayer():addChild(createFeedbackLayer())
                    end
                end
                -- cd-key 
            elseif tIndex == 6 then
                if getMainLayer() then
                    getMainLayer():addChild(createCdkeyLayer())
                end
            elseif tIndex == 7 then
                Global:instance():TDGAonEventAndEventData("news8")
                if getMainLayer() then
                    getMainLayer():gotoCusserviceLayer()
                end
            elseif tIndex == 8 or tIndex == 9 then
                Global:instance():TDGAonEventAndEventData("news9")
                
                if isPlatform(IOS_KY_ZH) or isPlatform(IOS_KYPARK_ZH) then
                    userdata:addDCount()
                    Global:SSOLogout("logOutSuccCallBack","logOutFailCallBack")
               
                elseif isPlatform(IOS_ITOOLS)
                    or isPlatform(IOS_ITOOLSPARK) 
                    or isPlatform(IOS_IIAPPLE_ZH)
                    or isPlatform(IOS_TGAME_TC)
                    or isPlatform(IOS_TGAME_TH)
                    or isPlatform(IOS_XYZS_ZH) then

                    if tIndex == 8 then
                        Global:SSOCenter()
                    else
                        -- logoutAction()
                        Global:SSOLogout("logOutSuccCallBack","logOutFailCallBack")
                    end
                 
                        --todo   
                elseif isPlatform(IOS_91_ZH) then

                    Global:SSOLogout("logOutSuccCallBack","logOutFailCallBack")

                elseif isPlatform(ANDROID_360_ZH) then
                    Global:SSOLogout("logOutSuccCallBack","logOutFailCallBack")
                    logoutAction()

                elseif isPlatform(ANDROID_XIAOMI_ZH) 
                    or isPlatform(ANDROID_91_ZH) 
                    or isPlatform(ANDROID_DK_ZH)  
                    or isPlatform(ANDROID_GV_MFACE_ZH) 
                    or isPlatform(ANDROID_GV_MFACE_EN) 
                    or isPlatform(ANDROID_GV_MFACE_EN_OUMEI)
                    or isPlatform(ANDROID_GV_MFACE_EN_OUMEINEW)
                    or isPlatform(IOS_GAMEVIEW_ZH) 
                    or isPlatform(IOS_GAMEVIEW_EN) 
                    or isPlatform(IOS_GVEN_BREAK) 
                    or isPlatform(ANDROID_GV_XJP_ZH) 
                    or isPlatform(ANDROID_MMY_ZH)
                    or onPlatform("TGAME")
                    or isPlatform(ANDROID_GV_MFACE_TC)
                    or isPlatform(IOS_GAMEVIEW_TC)
                    or isPlatform(ANDROID_HTC_ZH)
                    or isPlatform(ANDROID_GV_MFACE_TC_GP) then

                    if tIndex == 8 then

                        if isPlatform(ANDROID_GV_MFACE_ZH)
                            or isPlatform(IOS_GAMEVIEW_ZH) 
                            or isPlatform(ANDROID_GV_XJP_ZH)
                            or isPlatform(ANDROID_GV_MFACE_TC_GP) then

                            local urlstr = "https://www.facebook.com/mface.hzw"
                            Global:instance():AlixPayweb(urlstr)   --这句代码主要是打开一个url并不是只有支付的时候才可以用
                        
                        -- elseif isPlatform(ANDROID_JAGUAR_TC) then
                        --     --todo
                        --     local urlstr = "https://www.facebook.com/playbar.cc"
                        --     Global:instance():AlixPayweb(urlstr)

                        -- zhaoyanqiu,20140702:修改繁体版Facebook粉丝团的地址
                        elseif isPlatform(IOS_GAMEVIEW_TC) 
                            or isPlatform(ANDROID_GV_MFACE_TC) then

                            local urlstr = "http://m.facebook.com/mface.luffy"
                            Global:instance():AlixPayweb(urlstr) 

                        elseif isPlatform(ANDROID_GV_MFACE_EN)
                            or isPlatform(ANDROID_GV_MFACE_EN_OUMEI)
                            or isPlatform(ANDROID_GV_MFACE_EN_OUMEINEW)
                            or isPlatform(IOS_GAMEVIEW_EN)
                            or isPlatform(IOS_GVEN_BREAK) then

                            local urlstr = "https://www.facebook.com/mf360.plusop"
                            Global:instance():AlixPayweb(urlstr)   --这句代码主要是打开一个url并不是只有支付的时候才可以用
                        else
                            Global:SSOCenter()
                        end
                    else
                        if isPlatform(ANDROID_TGAME_KR) or isPlatform(ANDROID_TGAME_KRNEW) or isPlatform(ANDROID_TGAME_THAI) or isPlatform(ANDROID_TGAME_TC) then
                            Global:SSOLogout(nil, nil)
                        else
                            Global:SSOLogout(nil, nil)
                            logoutAction()
                        end
                    end

                elseif isPlatform(ANDROID_OPPO_ZH)
                    or  isPlatform(IOS_AISI_ZH)
                    or  isPlatform(IOS_AISIPARK_ZH)
                    or  isPlatform(IOS_DOWNJOYPARK_ZH)
                    or isPlatform(ANDROID_DOWNJOY_ZH) then
                    if tIndex == 8 then
                        Global:SSOCenter()
                    else
                        -- logoutAction()
                        Global:SSOLogout(nil,nil)
                    end
                elseif isPlatform(IOS_PPZS_ZH) or isPlatform(IOS_PPZSPARK_ZH) then 
                    if tIndex == 8 then
                        Global:SSOCenter()
                    else
                        Global:SSOLogout("logOutPPZSSuccCallBack","logOutFailCallBack")
                    end

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

                    if tIndex == 8 then
                        Global:SSOCenter()
                    else
                        Global:SSOLogout("logOutPPZSSuccCallBack","logOutFailCallBack")
                        logoutAction()
                    end

                elseif isPlatform(ANDROID_BAIDU_ZH) 
                    or isPlatform(ANDROID_BAIDUIAPPPAY_ZH)
                    or isPlatform(ANDROID_COOLPAY_ZH) then

                    if tIndex == 8 then
                        Global:instance().openURL("http://bbs.rom.baidu.com/forum-182-1.html")
                    else
                        Global:SSOLogout("logOutPPZSSuccCallBack","logOutFailCallBack")
                        logoutAction()
                    end

                elseif isPlatform(ANDROID_MM_ZH) then

                    if tIndex == 8 then
                        Global:instance().openURL("http://www.hzdw.com")
                    else
                        Global:SSOLogout("logOutPPZSSuccCallBack","logOutFailCallBack")
                        logoutAction()
                    end

                elseif isPlatform(ANDROID_AGAME_ZH) 
                    or isPlatform(ANDROID_WDJ_ZH)
                    or isPlatform(ANDROID_ANFENG_ZH)
                    or isPlatform(ANDROID_UC_ZH) then

                    if tIndex == 8 then
                        logoutAction()
                    end 
                else
                    if SSOPlatform.IsTourist() then
                        if tIndex == 8 then 
                            
                            if isPlatform(IOS_TBT_ZH) 
                                or isPlatform(IOS_TBTPARK_ZH)
                                or isPlatform(IOS_HAIMA_ZH) then
                                Global:SSOCenter()
                            
                            elseif isPlatform(ANDROID_JAGUAR_TC) then
                            -- Global:SSOLogout("logOutSuccCallBack","logOutFailCallBack")
                                Global:instance():TDGAonEventAndEventData("news9")
                                Global:instance():JGBindJaguarAccount()
                         
                            elseif getMainLayer() then
                                getMainLayer():addChild(createRegisterLayer(-140))
                            end
                            elseif tIndex == 9 then

                            if isPlatform(IOS_TBT_ZH) or isPlatform(IOS_TBTPARK_ZH) then

                                Global:SSOLogout(nil, nil)
                                logoutAction()

                       
                           
                        elseif isPlatform(IOS_VIETNAM_VI) 
                            or isPlatform(IOS_VIETNAM_EN) 
                            or isPlatform(IOS_VIETNAM_ENSAGA)
                            or isPlatform(IOS_MOBNAPPLE_EN)
                            or isPlatform(IOS_MOB_THAI)
                            or isPlatform(ANDROID_VIETNAM_MOB_THAI)
                            or isPlatform(ANDROID_BAIDU_ZH)
                            or isPlatform(ANDROID_BAIDUIAPPPAY_ZH) 
                            or isPlatform(ANDROID_VIETNAM_VI) 
                            or isPlatform(ANDROID_VIETNAM_EN)
                            or isPlatform(ANDROID_VIETNAM_EN_ALL) 
                            or isPlatform(IOS_MOBGAME_SPAIN)
                            or isPlatform(ANDROID_MOBGAME_SPAIN)
                            or isPlatform(ANDROID_MM_ZH)
                            or isPlatform(ANDROID_COOLPAY_ZH) then

                            Global:SSOLogout("logOutSuccCallBack", "logOutFailCallBack")
                            logoutAction()
                        else
                            logoutAction()
                        end
                        end
                    else
                        if tIndex == 8 then
                        -- 登出到登陆页
                            if isPlatform(IOS_TBT_ZH) 
                                or isPlatform(IOS_TBTPARK_ZH) 
                                or isPlatform(IOS_HAIMA_ZH) then
                                Global:SSOLogout(nil, nil)
                                logoutAction()
                            else
                                logoutAction()
                            end
                        end
                    end
                end
            end
          
        elseif fn == "cellTouchBegan" then      -- A cell is touching, a1 is cell, a2 is CCTouch
        elseif fn == "cellTouchEnded" then      -- A cell was touched, a1 is cell, a2 is CCTouch
        elseif fn == "cellHighlight" then       -- A cell is highlighting, coco2d-x 2.1.3 or above
        elseif fn == "cellUnhighlight" then     -- A cell had been unhighlighted, coco2d-x 2.1.3 or above
        elseif fn == "cellWillRecycle" then     -- A cell will be recycled, coco2d-x 2.1.3 or above
        end
        return r
    end)
    
    local _mainLayer = getMainLayer()
    if _mainLayer then
        local size = CCSizeMake(winSize.width, (winSize.height - _topLayer:getContentSize().height - _mainLayer:getBottomContentSize().height) * 98 / 100)      -- 这里是为了在tableview上面显示一个小空出来
        _tableView = LuaTableView:createWithHandler(h, size)
        _tableView:setBounceable(true)
        _tableView:setAnchorPoint(ccp(0,0))
        _tableView:setPosition(ccp(0, _mainLayer:getBottomContentSize().height))
        _tableView:setVerticalFillOrder(0)
        _layer:addChild(_tableView) 
    end
end

local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/SystemSettingView.ccbi",proxy, true,"SystemSettingLayerOwner")
    _layer = tolua.cast(node,"CCLayer")
end


function getSystemSettingLayer()
	return _layer
end

function createSystemSettingLayer()
    _init()


    local function _onEnter()

        if userdata:getVipAuditState() then

            _addAppleTableView() 
            
        else
            _addTableView()
        end
        cellArray = {}
        local r

        if isPlatform(IOS_KY_ZH)
            or isPlatform(IOS_KYPARK_ZH) 
            or isPlatform(IOS_VIETNAM_VI) 
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

            r = 9

        elseif isPlatform(ANDROID_AGAME_ZH) 
            or isPlatform(IOS_91_ZH) then

            r = 8

        else
            if userdata:getVipAuditState() then
                -- 苹果审核区的话，我们仅开放6项
                r = 6
            else 
                r = SSOPlatform.IsTourist() and 10 or 9
            end
        end
        generateCellAction(cellArray, r)
        cellArray = {}
        -- _tableView:reloadData()
        playMusic(MUSIC_SOUND_3, true)
        addObserver(NOTI_WEIBO_BIND_RESULT, SettingLayerReloadTableView)
        addObserver(HL_SSO_Register, registerSucc)
    end

    local function _onExit()
        _layer = nil
        _tableView = nil
        playMusic(MUSIC_SOUND_1, true)
        removeObserver(NOTI_WEIBO_BIND_RESULT, SettingLayerReloadTableView)
        removeObserver(HL_SSO_Register, registerSucc)
        cellArray = {}
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