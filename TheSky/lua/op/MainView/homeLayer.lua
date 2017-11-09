local _layer
local _tableView
local pageView
local _currentPage
local _canGetHotBalloonReward = false        -- 是否能获取热气球奖励（是否能响应手机摇晃）

-- 名字不要重复
HomeSceneOwner = HomeSceneOwner or {}
ccb["HomeSceneOwner"] = HomeSceneOwner

local function gvfbItemClick()    

    local urlstr = ""
    if isPlatform(IOS_GAMEVIEW_EN) or isPlatform(ANDROID_GV_MFACE_EN)
        or isPlatform(IOS_GVEN_BREAK) then
        urlstr = "https://facebook.com/mf360.plusop"
    elseif isPlatform(IOS_GAMEVIEW_TC) or isPlatform(ANDROID_GV_MFACE_TC) or isPlatform(ANDROID_GV_MFACE_TC_GP) then
        urlstr = "http://m.facebook.com/mface.luffy"
    elseif isPlatform(ANDROID_JAGUAR_TC) then
        urlstr = "https://www.facebook.com/playbar.cc"
    end
    Global:instance():AlixPayweb(urlstr) 
end
HomeSceneOwner["gvfbItemClick"] = gvfbItemClick


local function dashboardItemClick()
    if isPlatform(ANDROID_TGAME_KR) or isPlatform(ANDROID_TGAME_KRNEW) or isPlatform(IOS_TGAME_KR) or isPlatform(ANDROID_TGAME_TC) then
        local urlstr = ""
        urlstr = "http://cafe.naver.com/onepice2014"
        Global:instance():AlixPayweb(urlstr) 
    else
        print("dashboardItemClicking~")
        Global:SSOCenter()
    end
end
HomeSceneOwner["dashboardItemClick"] = dashboardItemClick

local function _getHeroFrameCount()
    local count = userdata:getFormMax()
    -- 再加阵型总览和啦啦队
    count = count + 2
    -- 不够8个加一把锁
    if userdata:getFormMax() < 8 then
        count = count + 1
    end
    return count
end

local function _updateMailCount()
    local count = maildata:getNewMail() 
    local mailCountBg = tolua.cast(HomeSceneOwner["mailCountBg"], "CCSprite")
    if count > 0 then
        mailCountBg:setVisible(true)
        local mailCount = tolua.cast(HomeSceneOwner["mailCount"], "CCLabelTTF")
        mailCount:setString(count)
    else
        mailCountBg:setVisible(false)
    end
end

local function addHeroTableView()
    print("addHeroTableView")
    local touchLayer = HomeSceneOwner["touchLayer"]
    -- @param fn string Callback type
    -- @param table LuaTableView
    -- @param a1 & a2 mixed Difference means for every "fn"
    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            local sp = CCSprite:createWithSpriteFrameName("frame.png")
            r = CCSizeMake((sp:getContentSize().width) * retina, sp:getContentSize().height * retina)
        elseif fn == "cellAtIndex" then
            -- Return CCTableViewCell, a1 is cell index (zero based), a2 is dequeued cell (maybe nil)
            -- Do something to create cell and change the content
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            if a1 < userdata:getFormMax() then
                -- 半身像
                local heroUId = herodata.form[tostring(a1)]
                if heroUId then
                    local heroId = herodata:getHeroIdByUId( heroUId )
                    local bust2 = herodata:getHeroBust2ByHeroId(heroId)
                    if bust2 then
                        local bustSpr = CCSprite:create(bust2)
                        if bustSpr then
                            bustSpr:setScale(retina)
                            bustSpr:setAnchorPoint(ccp(0, 0))
                            bustSpr:setPosition(ccp(0, 0))
                            a2:addChild(bustSpr, 1, 1)

                            -- 背景效果
                            local heroInfo = herodata:getHeroInfoByHeroUId(heroUId)
                            local proxy = CCBProxy:create()
                            local rank = heroInfo.rank
                            local bgEffect = tolua.cast(CCBReaderLoad(string.format("ccbResources/MainPageHeroBgView%d.ccbi", rank), proxy, true, nil), "CCLayer")
                            if bgEffect then
                                bgEffect:setAnchorPoint(ccp(0, 0))
                                bgEffect:setPosition(ccp(0, 0))
                                bustSpr:addChild(bgEffect, -1, 1)
                            end 
                        end
                    end 
                else
                    local sp = CCSprite:createWithSpriteFrameName("frameNull.png")
                    sp:setScale(retina)
                    sp:setAnchorPoint(ccp(0, 0))
                    sp:setPosition(ccp(0, 0))
                    a2:addChild(sp, 1, 1)
                end
            else
                if a1 == userdata:getFormMax() then
                    -- 总览
                    local sp = CCSprite:createWithSpriteFrameName("frameAll.png")
                    sp:setScale(retina)
                    sp:setAnchorPoint(ccp(0, 0))
                    sp:setPosition(ccp(0, 0))
                    a2:addChild(sp, 1, 1)
                elseif a1 == userdata:getFormMax() + 1 then
                    -- 啦啦队
                    local sp = CCSprite:createWithSpriteFrameName("frameLaLa.png")
                    sp:setScale(retina)
                    sp:setAnchorPoint(ccp(0, 0))
                    sp:setPosition(ccp(0, 0))
                    a2:addChild(sp, 1, 1)
                elseif userdata:getFormMax() < 8 and a1 == userdata:getFormMax() + 2 then
                    local sp = CCSprite:createWithSpriteFrameName("frameLock.png")
                    sp:setScale(retina)
                    sp:setAnchorPoint(ccp(0, 0))
                    sp:setPosition(ccp(0, 0))
                    a2:addChild(sp, 1, 1)
                end
            end

            -- 框
            local norSp = CCSprite:createWithSpriteFrameName("frame.png")
            norSp:setScale(retina)
            norSp:setAnchorPoint(ccp(0, 0))
            norSp:setPosition(ccp(0, 0))
            a2:addChild(norSp, 1, 1)
            r = a2
        elseif fn == "numberOfCells" then
            -- Return number of cells
            r = _getHeroFrameCount()
        -- Cell events:
        elseif fn == "cellTouched" then         -- A cell was touched, a1 is cell that be touched. This is not necessary.
            if userdata:getFormMax() < 8 and a1:getIdx() == userdata:getFormMax() + 2 then
                ShowText(HLNSLocalizedString("team.lock.next", userdata:getNextFormMax()))
                return
            else
                runtimeCache.teamPage = a1:getIdx()
            end
            getMainLayer():gotoTeam()
        elseif fn == "cellTouchBegan" then      -- A cell is touching, a1 is cell, a2 is CCTouch
        elseif fn == "cellTouchEnded" then      -- A cell was touched, a1 is cell, a2 is CCTouch
        elseif fn == "cellHighlight" then       -- A cell is highlighting, coco2d-x 2.1.3 or above
        elseif fn == "cellUnhighlight" then     -- A cell had been unhighlighted, coco2d-x 2.1.3 or above
        elseif fn == "cellWillRecycle" then     -- A cell will be recycled, coco2d-x 2.1.3 or above
        end
        return r
    end)
    local sp = CCSprite:createWithSpriteFrameName("frame.png")
    local size = CCSizeMake(winSize.width, sp:getContentSize().height * retina)
    _tableView = LuaTableView:createWithHandler(h, size)
    _tableView:setBounceable(true)
    _tableView:setAnchorPoint(ccp(0, 1))
    _tableView:setPosition(ccp(0, winSize.height - 135 * retina - sp:getContentSize().height * retina))
    _tableView:setVerticalFillOrder(0)
    _tableView:setDirection(0)
    touchLayer:addChild(_tableView)
end

local function changePage(idx)
    _currentPage = idx
end

local function iconItemPressed(tag)
    if tag == 1 then
        -- Global:instance():TDGAonEventAndEventData("sail")
        local _mainLayer = getMainLayer()
        if _mainLayer then
            _mainLayer:goToSail()
        end
        -- 这只是一个测试
    elseif tag == 2 then
        Global:instance():TDGAonEventAndEventData("adventure")
        local _mainLayer = getMainLayer()
        if _mainLayer then
            _mainLayer:gotoAdventure()
        end
    elseif tag == 3 then
        -- 练气
        if  shadowData:bOpenShadowFun() then
            local _mainLayer = getMainLayer()
            if _mainLayer then
                _mainLayer:gotoTrainShadowView()
            end
        else
            if shadowData:openLevel() then
                ShowText(HLNSLocalizedString("shadow.open.tips", shadowData:openLevel()))
            else
                ShowText(HLNSLocalizedString("component.close"))
            end
        end
        -- ShowText(HLNSLocalizedString("component.close"))
    elseif tag == 4 then
        -- 联盟
        --ShowText(HLNSLocalizedString("component.close"))

        local _mainLayer = getMainLayer()
        if _mainLayer then
            _mainLayer:gotoUnion()
        end

    elseif tag == 5 then
        Global:instance():TDGAonEventAndEventData("duel")
        local _mainLayer = getMainLayer()
        if _mainLayer then
            _mainLayer:gotoArena()
        end
    elseif tag == 6 then
        -- 罗格镇
        Global:instance():TDGAonEventAndEventData("town1")
        local _mainLayer = getMainLayer()
        if _mainLayer then
            _mainLayer:goToLogue()
        end
    elseif tag == 7 then
        local _mainLayer = getMainLayer()
        if _mainLayer then
            _mainLayer:goToRankingList()
        end
    elseif tag == 8 then
        local _mainLayer = getMainLayer()
        if _mainLayer then
            _mainLayer:gotoWorldWar()
        end
    end

end

local function addPageView()
    local pageLayer = HomeSceneOwner["pageLayer"]
    local sp = CCSprite:createWithSpriteFrameName("btn_icon_1.png")
    --  pageview滴创建需要3个参数，第一个ccrect用来设置触摸区域，第二个ccsize，用来设置中间的显示区域，如果只需要显示单页，设置为和第一个参数相同，第三个参数是floot，用来设置缩放比率，当小于等于1滴时候可以缩放，大于1滴时候不能缩放
    pageView = PageView:create(
                                CCRect(0, 0, pageLayer:getContentSize().width, pageLayer:getContentSize().height * retina),
                                CCSizeMake(pageLayer:getContentSize().width * 2 / 3, pageLayer:getContentSize().height * retina), 
                                0.5
                            )
    pageView:setPosition(0, 0)
    pageView:setAnchorPoint(ccp(0, 0))
    pageView:registerScriptHandler(changePage)
    
    -- 分页数
    local pagesCount = 8

    for i = 1, pagesCount do
        local pageNode = CCNode:create()
        pageView:addPageView(i - 1, pageNode)
        local menu = CCMenu:create()
        pageNode:addChild(menu, 250, 10)
        menu:setAnchorPoint(ccp(0, 0))
        menu:setPosition(0, 0)
        menu:setContentSize(CCSizeMake(sp:getContentSize().width * retina, sp:getContentSize().height * retina))

        local nor = CCSprite:createWithSpriteFrameName(string.format("btn_icon_%d.png", i))
        local sel = CCSprite:createWithSpriteFrameName(string.format("btn_icon_%d.png", i))
        -- if i == 1 and isPlatform(IOS_APPLE_ZH) then
        --     local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
        --     cache:addSpriteFramesWithFile("ccbResources/appstore_replace.plist")
        --     nor = CCSprite:createWithSpriteFrameName("btn_icon_1_appstore.png")
        --     sel = CCSprite:createWithSpriteFrameName("btn_icon_1_appstore.png")
        -- end
        item = CCMenuItemSprite:create(nor, sel)
        item:registerScriptTapHandler(iconItemPressed)
        item:setScale(retina)
        item:setAnchorPoint(ccp(0.5, 0))
        -- 这个与创建pageview的参数有关，其值是第二个参数宽度值的一半
        item:setPosition(ccp(pageLayer:getContentSize().width * 2 / 3 / 2, 0))
        -- add text pic
        local textSpr = CCSprite:createWithSpriteFrameName(string.format("gy_text_%d.png", i))
        if textSpr then 
            textSpr:setAnchorPoint(ccp(0.5, 0))
            textSpr:setPosition(ccp(item:getContentSize().width/2, 0))
            item:addChild(textSpr)
        end 
        menu:addChild(item, 1, i)
    end

    pageLayer:addChild(pageView)
    pageView:updateView()
end

-- 充值按钮点击
local function rechargeNewBtnClick()
    print("新增的充值按钮")
    Global:instance():TDGAonEventAndEventData("recharge1")
    if getMainLayer() then
        getMainLayer():addChild(createShopRechargeLayer(-140), 100)
    end
end
HomeSceneOwner["rechargeNewBtnClick"] = rechargeNewBtnClick


local function refreshPayBtn(  )
    
    local rechargeNewBtn = tolua.cast(HomeSceneOwner["rechargeNewBtn"],"CCMenuItemSprite")
    local rechargeSp = tolua.cast(HomeSceneOwner["rechargeSp"], "CCSprite")

    if vipdata:isFirstRecharge() then  -- 未参加首冲
        -- 若贝壳 存在
        rechargeSp:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("chongzhi2_text.png"))
    else
        -- 说明此时已经首冲了、 充值按钮消失 并显示新的充值按钮 位置为最右边
        rechargeSp:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("chongzhi_text.png"))
    end

end

-- 刷新首页活动数量
local function refreshActivityCount()
    local activityCount = loginActivityData:getActivityCount()
    if activityCount == 0 then
        if HomeSceneOwner["activity"] then
            HomeSceneOwner["activity"]:setVisible(false)
        end
        if HomeSceneOwner["activityBtn"] then
            HomeSceneOwner["activityBtn"]:setVisible(false)
            HomeSceneOwner["activityBtn"]:setEnabled(false) 
        end
    else
        local logLabel = tolua.cast(HomeSceneOwner["activityCount"], "CCLabelTTF")
        logLabel:setString(activityCount)
    end
end

local function refreshQuest()
    local main, daily = questdata:getQuestComplete()
    local quest = tolua.cast(HomeSceneOwner["quest"], "CCSprite")
    quest:setVisible(main + daily > 0)
    local questCount = tolua.cast(HomeSceneOwner["questCount"], "CCLabelTTF")
    questCount:setString(main + daily)
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local proxy = CCBProxy:create()
    local node  = CCBReaderLoad("ccbResources/HomeView.ccbi",proxy, true,"HomeSceneOwner")
    _layer = tolua.cast(node,"CCLayer")
    _updateMailCount()
    refreshActivityCount()
    CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/fontPic_2.plist")
    CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/fontPic_99.plist")

    refreshPayBtn()


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
        or isPlatform(ANDROID_MOBGAME_SPAIN) then
        HomeSceneOwner["vndashboard"]:setVisible(true)
        HomeSceneOwner["vndashboard"]:setEnabled(true)
        HomeSceneOwner["dashboardlayer"]:setVisible(true)
    elseif isPlatform(IOS_GAMEVIEW_EN) 
        or isPlatform(IOS_GVEN_BREAK)
        or isPlatform(ANDROID_GV_MFACE_EN) then
        
        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/mFaceFb.plist")
        local nor = CCSprite:createWithSpriteFrameName("fb_logo.png")
        local sel = CCSprite:createWithSpriteFrameName("fb_logo.png")

        gvfb = CCMenuItemSprite:create(nor, sel)
        gvfb:registerScriptTapHandler(gvfbItemClick)
        gvfb:setScale(0.4)
        gvfb:setAnchorPoint(ccp(0, 1))
        HomeSceneOwner["menu1"]:addChild(gvfb,1,1)
        gvfb:setPosition(ccp(HomeSceneOwner["vndashboard"]:getPositionX(), HomeSceneOwner["vndashboard"]:getPositionY()))

    elseif isPlatform(IOS_GAMEVIEW_TC) 
        or isPlatform(ANDROID_GV_MFACE_TC)
        or isPlatform(ANDROID_GV_MFACE_TC_GP) then

        HomeSceneOwner["gvfb"]:setVisible(true)
        HomeSceneOwner["gvfb"]:setEnabled(true)
    elseif isPlatform(IOS_TGAME_TC) or isPlatform(ANDROID_JAGUAR_TC) or isPlatform(ANDROID_TGAME_TC)then
        HomeSceneOwner["gvfb"]:setVisible(false)
        HomeSceneOwner["gvfb"]:setEnabled(false)
    elseif isPlatform(WP_VIETNAM_VN) then
        HomeSceneOwner["vndashboard"]:setVisible(false)
        HomeSceneOwner["vndashboard"]:setEnabled(false)
        HomeSceneOwner["dashboardlayer"]:setVisible(false)
    elseif isPlatform(WP_VIETNAM_EN) then
        HomeSceneOwner["vndashboard"]:setVisible(false)
        HomeSceneOwner["vndashboard"]:setEnabled(false)
        HomeSceneOwner["dashboardlayer"]:setVisible(false)
    end
    
    if userdata:getVipAuditState() then
        if HomeSceneOwner["userCenterBtn"] then
            HomeSceneOwner["userCenterBtn"]:setVisible(false)
            HomeSceneOwner["userCenterBtn"]:setEnabled(false)
        end
        if HomeSceneOwner["activityBtn"] then
            HomeSceneOwner["activityBtn"]:setVisible(false)
            HomeSceneOwner["activityBtn"]:setEnabled(false)
        end
        if HomeSceneOwner["activity"] then
            HomeSceneOwner["activity"]:setVisible(false)
        end
        if HomeSceneOwner["vndashboard"] then
            HomeSceneOwner["vndashboard"]:setVisible(false)
            HomeSceneOwner["vndashboard"]:setEnabled(false)
        end
        if HomeSceneOwner["dashboardlayer"] then
            HomeSceneOwner["dashboardlayer"]:setVisible(false)
        end
    end

    refreshQuest()

    local newYearActivityBtn = tolua.cast(HomeSceneOwner["newYearActivityBtn"],"CCMenuItemSprite")
    if IsFreeFestival == true then
        print("=============IsFreeFestival:",IsFreeFestival)
        newYearActivityBtn:setVisible(true)
    else
        newYearActivityBtn:setVisible(false)
        print("=============IsFreeFestival:",IsFreeFestival)
    end

    -- local getMainInfo = function( url,rtnData )
    --     PrintTable(rtnData)
    --     local endTime = rtnData["info"]["freeFestival"]["endTime"]
    --     local serverTime = rtnData["info"]["freeFestival"]["serverTime"]
    --     local openTime = rtnData["info"]["freeFestival"]["openTime"]
    --     local isNewYearActivityOpen = nil
    --     if serverTime > openTime and serverTime < endTime then
    --         isNewYearActivityOpen = true
    --         newYearActivityBtn:setVisible(true)
    --     else
    --         isNewYearActivityOpen = false
    --         newYearActivityBtn:setVisible(false)
    --     end
    --     print("============isNewYearActivityOpen:",isNewYearActivityOpen)
    -- end

    -- doActionFun("ACTIVITY_GETMAININFO",{},getMainInfo)

end

local function heroItemClick()
    Global:instance():TDGAonEventAndEventData("partner")
    local _mainLayer = getMainLayer()
    if _mainLayer then
        _mainLayer:goToHeroes()
    end
end
HomeSceneOwner["heroItemClick"] = heroItemClick

local function equipItemClick()
    Global:instance():TDGAonEventAndEventData("equipment")
    local _mainLayer = getMainLayer()
    if _mainLayer then
        _mainLayer:gotoEquipmentsLayer()
    end
end
HomeSceneOwner["equipItemClick"] = equipItemClick

local function skillItemClick()
    Global:instance():TDGAonEventAndEventData("profound")
    local _mainLayer = getMainLayer()
    if _mainLayer then
        _mainLayer:gotoSkillViewLayer()
    end
end
HomeSceneOwner["skillItemClick"] = skillItemClick

local function warshipItem()
    Global:instance():TDGAonEventAndEventData("warship")
    local _mainLayer = getMainLayer()
    if _mainLayer then
        if battleShipData:ifCanOpenBattleShip() then
            _mainLayer:gotoBattleShipLayer()
        else
            text = HLNSLocalizedString("战舰功能%s级后开启，是否前往起航升级？",ConfigureStorage.levelOpen["warship"].level)
            local function cardConfirmAction()
               local _mainLayer = getMainLayer()
                if _mainLayer then
                    _mainLayer:goToSail()
                end
            end
            local function cardCancelAction()
                
            end
            getMainLayer():addChild(createSimpleConfirCardLayer(text), 100)
            SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
            SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction
            -- ShowText(HLNSLocalizedString("战舰功能%s级后开启",ConfigureStorage.levelOpen["warship"].level))
        end
    end
end
HomeSceneOwner["warshipItem"] = warshipItem

local function _payBtnAction(  )
    print("paybuttonaction")
    Global:instance():TDGAonEventAndEventData("recharge1")
    -- Global:instance():AlixPayweb(opAppId,userdata.serverCode,userdata.sessionId,"gold_100")
    if getMainLayer() then
        getMainLayer():addChild(createShopRechargeLayer(-140), 100)
    end
end
HomeSceneOwner["_payBtnAction"] = _payBtnAction

local function questItemClick()
    getMainLayer():showQuest()
end
HomeSceneOwner["questItemClick"] = questItemClick

-- renzhan newAdd
local function _actiivityBtnAction(  )
    local function getActivityCallBack( url,rtnData )
        loginActivityData:updataActiveDataByKeyAndDic( rtnData.info.frontPage )
        if getMainLayer() then
            HomeSceneOwner["activityBtn"]:setTag(123)
            local layer = createloginActivityView()
            getMainLayer():addChild(layer, 100)
        end
    end
    doActionFun("GET_ACTIVITY_DATA",{},getActivityCallBack)
    
end
HomeSceneOwner["_actiivityBtnAction"] = _actiivityBtnAction
-- 
local function _newYearActivityBtnAction(  )
    local getMainInfo = function( url,rtnData )
        PrintTable(rtnData)
        if getMainLayer() then
            HomeSceneOwner["newYearActivityBtn"]:setTag(123)
            --local layer = createNewYearActivityView()
            --getMainLayer():addChild(layer, 100)
            local rewardShow = rtnData["info"]["freeFestival"]["rewardShow"]
            local itemsCost = rtnData["info"]["freeFestival"]["itemsCost"]
            local sign = rtnData["info"]["freeFestival"]["sign"]
            FreeFestivalUid = rtnData["info"]["freeFestival"]["uid"]
            IsRankOpen = rtnData["info"]["freeFestival"]["isRankOpen"]
            getMainLayer():addChild(createNewYearActivityView(-140,rewardShow,itemsCost,sign), 100)
            print("open newYearActivity wnd")
        end
    end

    doActionFun("ACTIVITY_GETMAININFO",{},getMainInfo)
    -- local function getActivityCallBack( url,rtnData )
    --     --loginActivityData:updataActiveDataByKeyAndDic( rtnData.info.frontPage )
    --     if getMainLayer() then
    --         HomeSceneOwner["newYearActivityBtn"]:setTag(123)
    --         --local layer = createNewYearActivityView()
    --         --getMainLayer():addChild(layer, 100)

    --         getMainLayer():addChild(createNewYearActivityView(-140), 100)
    --         print("open newYearActivity wnd")
    --     end
    -- end
   
    -- doActionFun("ACTIVITY_LITFIREWORKS",{},getActivityCallBack)
    
end
HomeSceneOwner["_newYearActivityBtnAction"] = _newYearActivityBtnAction

local function packageItemClick()
    local _mainLayer = getMainLayer()
    if _mainLayer then
        _mainLayer:gotoWareHouseLayer()
    end
end
HomeSceneOwner["packageItemClick"] = packageItemClick

local function rosterItemClick()
    local _mainLayer = getMainLayer()
    if _mainLayer then
        _mainLayer:gotoHandBookLayer()
    end
end
HomeSceneOwner["rosterItemClick"] = rosterItemClick

local function mailItemClick()
    local _mainLayer = getMainLayer()
    if _mainLayer then
        _mainLayer:gotoNewsLayer()
    end
end
HomeSceneOwner["mailItemClick"] = mailItemClick

local function logItemClick()
    local _mainLayer = getMainLayer()
    if _mainLayer then
        _mainLayer:gotoFriendViewLayer()
    end
end
HomeSceneOwner["logItemClick"] = logItemClick

local function chatItemClick()
    Global:instance():TDGAonEventAndEventData("chat")
    local _mainLayer = getMainLayer()
    if _mainLayer then
        _mainLayer:gotoChatLayer()
    end
end
HomeSceneOwner["chatItemClick"] = chatItemClick

local function optionItemClick()
    -- RandomManager.cursor = 200
    -- BattleField:fight(deepcopy(battledata:getPlayerBattleInfo()), deepcopy(battledata:getPlayerBattleInfo()))
    -- PrintTable(battledata:readJson())
    -- BattleField:OPAniFight()
    -- CCDirector:sharedDirector():replaceScene(CCTransitionFade:create(0.6, FightingScene()))
    
    local _mainLayer = getMainLayer()
    if _mainLayer then
        _mainLayer:gotoSystemSettingLayer()
    end
end
HomeSceneOwner["optionItemClick"] = optionItemClick

-- 检查刷新是否要出热气球
local function refreshHotBalloon( )
    if hotBalloonData:isShowBalloon() then 
        -- 加动画
        palyHotBalloonAnimationOnNode(getMainLayer())
        _canGetHotBalloonReward = true
    end 
end 

-- 摇晃手机
local function _shakePhone()

    local function _shakePhoneUI(  )
        local function getShakeRewardCallback( url, rtnData )
            if rtnData["info"] then
                hotBalloonData:setHotData( rtnData["info"]["shakeData"] )
                runtimeCache.responseData = rtnData["info"]
            end
            -- 获得动画
            -- local m = HotBalloonAniOwner["mAnimationManager"]
            -- if m then
            --     -- m:runAnimationsForSequenceNamedTweenDuration("openBox", 0)
            -- end
            removeHotBalloonAnimation()
            palyHotBalloonAnimationOnNode2(getMainLayer())
        end 

        local function errorCallBack(url, code)
            if hotBalloonData:isShowBalloon() then 
                _canGetHotBalloonReward = true
            end 
        end 

        if _canGetHotBalloonReward then
            _canGetHotBalloonReward = false
            doActionFun("ADD_SHAKE_AWARD_URL", {}, getShakeRewardCallback, errorCallBack)
        end
    end 
    _layer:runAction(CCCallFunc:create(_shakePhoneUI))

end 

-- 热气球动画结束
local function _hotAniEnd(  )
    print("_hotAniEnd")
    local resp = runtimeCache.responseData
    if resp.gain then
        userdata:popUpGain(resp.gain, true)
    end
    -- 刷新热气球
    refreshHotBalloon()
end 

-- 该方法名字每个文件不要重复
function getHomeLayer()
	return _layer
end

local function setMenuPriority()
    local menu1 = tolua.cast(HomeSceneOwner["menu1"], "CCMenu")
    menu1:setHandlerPriority(-131)
    local menu2 = tolua.cast(HomeSceneOwner["menu2"], "CCMenu")
    menu2:setHandlerPriority(-131)

    -- 刷新热气球
    if not runtimeCache.bGuide and getAnnounceLayer() == nil and getContinueLoginRewardLayer() == nil and not runtimeCache.bLevelGuide then
        refreshHotBalloon()
    end 
end

local function _popup()
    if not runtimeCache.bGuide and runtimeCache.bFirstEnterMain then
        runtimeCache.bFirstEnterMain = false

        -- 连续登陆奖励登陆
        if continueLoginRewardData:isPopup() then 
            getMainLayer():addChild(createContinueLoginRewardLayer(-135)) 
        else
            local allData = announceData:getAllNotice()
            if getMyTableCount(allData) > 0 then
                getMainLayer():popUpAnLayer()
            end
        end
    end 
end

local function _updateDashboard(count)
    print(" Print By lixq ---- _updateDashboard%scount", count)
    -- local function upDashboardNum( )
        -- body
        local mgNewsCountBg = tolua.cast(HomeSceneOwner["mgNewsCountBg"], "CCSprite")
        local mgNewsCount = tolua.cast(HomeSceneOwner["mgNewsCount"], "CCLabelTTF")
        if tonumber(count) > 0 then
            mgNewsCountBg:setVisible(true)
        else
            mgNewsCountBg:setVisible(false)
        end
        mgNewsCount:setString(count)
    -- end
    -- local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(upDashboardNum))
    -- _layer:runAction(seq)
end

-- function googlePaySuccess( ... )
--     print("=============isPlatform(ANDROID_INFIPLAY_RUS)")
--     local a, b , c, d, e = ...
--     local params = {a, c, d, b, e}
--     PrintTable(params)
--     local function gpcallFun( ... )
--         print("============wy123311111")
--         local callbackFun = function(url,params)
--             print("============wy1233")
--             PrintTable(params)
--             PrintTable(params.code)
--             PrintTable(params.info)
--             if params.code == 200 then
--                 print("============wy123332323")
--                 PrintTable(params.info)
--                 doActionFun("FLUSH_PLAYER_DATA",{}, refreshCallBack)
--                 local pDetailsArr = {}
--                 table.insert(pDetailsArr, "itemdata")
--                 table.insert(pDetailsArr, c)
--                 table.insert(pDetailsArr, "sign")
--                 table.insert(pDetailsArr, d)
--                 Global:consumeItem(pDetailsArr,table.getn(pDetailsArr))
--             end
--         end
--         doActionFun("ADD_GOOGLEPLAY_ORDER", {params}, callbackFun)
--     end
--     local seq = CCSequence:createWithTwoActions(CCDelayTime:create(5), CCCallFunc:create(gpcallFun))
--     _layer:runAction(seq)
--     --gpcallFun()
-- end

function createHomeLayer()
    _init()

    local function _onEnter()
        print("home layer onEnter")
        if isPlatform(ANDROID_INFIPLAY_RUS) and FirstOpenMainLayer then
                FirstOpenMainLayer = false
                local itemListStr = ""
                local shopData = shopData:getCashShopData()
                for i,v in ipairs(shopData) do

                    itemListStr = itemListStr..v["itemId"]..","
                    print("=======123=========="..itemListStr)
                end
                local pDetailsArr = {}
                table.insert(pDetailsArr, "itemList")
                table.insert(pDetailsArr, itemListStr)

                local seq = CCSequence:createWithTwoActions(CCDelayTime:create(5.1), CCCallFunc:create(function ()
                    -- body
                    print("Print By ---- createHomeLayer() CheckItemList")
                    Global:CheckItemList(pDetailsArr,table.getn(pDetailsArr),"googlePaySuccess")
                end))
                _layer:runAction(seq)
                
        end

        
        
       
        addObserver(NOTI_SHAKE_PHONE, _shakePhone)
        addObserver(NOTI_HOTBALLOON_ANI_END, _hotAniEnd)
        addObserver(NOTI_REFRESH_MAILCOUNT, _updateMailCount)
        addObserver(NOTI_REFRESH_LOGUETOWN,refreshPayBtn)
        addObserver(NOTI_QUEST, refreshQuest)
        addObserver(NOTI_LOGINACTIVITY_NUMBERSTATUS,refreshActivityCount)
        addObserver(NOTI_MOBGAME_NEWSCOUNT, _updateDashboard)

        runtimeCache.huobanTableOffsetY = nil         -- 清一下伙伴页面的tableview的缓存

        addHeroTableView()
        _tableView:reloadData()
        addPageView()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.1), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
        if _currentPage then
            pageView:moveToPage(_currentPage)
        end
        local seq2 = CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCCallFunc:create(_popup))
        _layer:runAction(seq2)
    end

    local function _onExit()
        _layer:stopAllActions()
        _layer = nil
        _tableView = nil
        pageView = nil
        removeObserver(NOTI_SHAKE_PHONE, _shakePhone)
        removeObserver(NOTI_HOTBALLOON_ANI_END, _hotAniEnd)
        removeObserver(NOTI_REFRESH_MAILCOUNT, _updateMailCount)
        removeObserver(NOTI_REFRESH_LOGUETOWN,refreshPayBtn)
        removeObserver(NOTI_LOGINACTIVITY_NUMBERSTATUS,refreshActivityCount)
        removeObserver(NOTI_QUEST, refreshQuest)
        removeObserver(NOTI_MOBGAME_NEWSCOUNT, _updateDashboard)

        _canGetHotBalloonReward = false

        removeHotBalloonAnimation()
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
