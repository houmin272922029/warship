local _layer
local pageView
local tableView
local _currentPage
local _allData = {}

local instructArray = {}

local _dailyBtnStatus = false
local K_TAG_DAILYLIGHT = 9876


-- ·名字不要重复
DailyViewOwner = DailyViewOwner or {}
ccb["DailyViewOwner"] = DailyViewOwner

local function changeToPage(tag) 
    pageView:moveToPage(tag)
end

local function addTableView()
    -- @param fn string Callback type
    -- @param table LuaTableView
    -- @param a1 & a2 mixed Difference means for every "fn"

    local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
    cache:addSpriteFramesWithFile("ccbResources/dailyIcon.plist")
    cache:addSpriteFramesWithFile("ccbResources/daily4.plist")
    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            local sp = CCSprite:createWithSpriteFrameName("frame_0.png")
            r = CCSizeMake(sp:getContentSize().width * retina * 1.1, sp:getContentSize().height * retina * 1.1)
        elseif fn == "cellAtIndex" then
            -- Return CCTableViewCell, a1 is cell index (zero based), a2 is dequeued cell (maybe nil)
            -- Do something to create cell and change the content
            
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end

            local data = _allData[a1 + 1]
             
            local item
            local f = cache:spriteFrameByName(string.format("%s_icon.png", data.name))
            local norSp, selSp
            if f then
                norSp = CCSprite:createWithSpriteFrameName(string.format("%s_icon.png", data.name))
                selSp = CCSprite:createWithSpriteFrameName(string.format("%s_icon.png", data.name))
            else
                norSp = CCSprite:createWithSpriteFrameName("frame_0.png")
                selSp = CCSprite:createWithSpriteFrameName("frame_0.png")
            end
            item = CCMenuItemSprite:create(norSp, selSp)
            item:setAnchorPoint(ccp(0, 0))
            item:setPosition(ccp(norSp:getContentSize().width * 0.05 * retina, norSp:getContentSize().height * 0.02 * retina))
            item:registerScriptTapHandler(changeToPage)
            menu = CCMenu:create()
            menu:addChild(item, 1, a1)
            menu:setPosition(ccp(0, 0))
            menu:setAnchorPoint(ccp(0, 0))
            menu:setScale(retina)
            a2:addChild(menu, 1, 10)

            if isPlatform(ANDROID_VIETNAM_VI) 
                or isPlatform(ANDROID_VIETNAM_EN)
                or isPlatform(ANDROID_VIETNAM_EN_ALL)
                or isPlatform(ANDROID_VIETNAM_MOB_THAI)
                or isPlatform(IOS_VIETNAM_VI)
                or isPlatform(IOS_VIETNAM_EN) 
                or isPlatform(IOS_VIETNAM_ENSAGA) 
                or isPlatform(IOS_MOB_THAI)
                or isPlatform(IOS_MOBNAPPLE_EN)
                or isPlatform(IOS_GAMEVIEW_EN) 
                or isPlatform(IOS_GVEN_BREAK)
                or isPlatform(IOS_MOBGAME_SPAIN)
                or isPlatform(ANDROID_MOBGAME_SPAIN)
                or isPlatform(WP_VIETNAM_EN) then
                
            else
                -- renzhan newAdd
                local menuBg = CCSprite:createWithSpriteFrameName("dailyNameBg.png")
                menuBg:setAnchorPoint(ccp(0,0))
                menuBg:setPosition(ccp(item:getContentSize().width - menuBg:getContentSize().width,0))
                item:addChild(menuBg)

                local label = CCLabelTTF:create("", "ccbResources/FZCuYuan-M03S.ttf", 18)
                label:setPosition(menuBg:getContentSize().width / 2, menuBg:getContentSize().height / 2)
                label:setColor(ccc3(221,233,73))
                menuBg:addChild(label)

                --添加日常中相应的 左上角 icon
                -- 黄金钟、梦想海贼团、充值返利、青椒宝藏
                local r_TopIcon = CCSprite:create()
                r_TopIcon:setAnchorPoint(ccp(0,0))
                r_TopIcon:setPosition(ccp(0, item:getContentSize().height - menuBg:getContentSize().height))
                item:addChild(r_TopIcon)

                local label2 = CCLabelTTF:create("", "ccbResources/FZCuYuan-M03S.ttf", 18)
                label2:setAnchorPoint(ccp(0,0))
                label2:setPosition(ccp(0, item:getContentSize().height - menuBg:getContentSize().height))
                label2:setColor(ccc3(255,255,255))
                item:addChild(label2)
                
                if data then
                    if data.name == Daily_EatDumpling then
                        -- 吃饭 
                        label:setString(HLNSLocalizedString("体力"))
                        --r_TopIcon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("timer_bg.png"))
                        --label2:setString(HLNSLocalizedString("daily.timelimit"))
                    elseif data.name == Daily_Wish then
                        -- 许愿
                        label:setString(HLNSLocalizedString("吟唱"))
                    elseif data.name == Daily_Worship then
                        -- 人鱼公主
                        label:setString(HLNSLocalizedString("亲吻"))
                    elseif data.name == Daily_YUEKA then
                        label:setString(HLNSLocalizedString("月卡"))
                        --r_TopIcon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("timer_bg.png"))
                        --label2:setString(HLNSLocalizedString("daily.timelimit"))
                    -- layer = createYueKaLayer()
                    elseif data.name == Daily_Alcohol then
                        -- 饮酒             
                        -- label:setString("亲吻")  -- test
                    elseif data.name == Daily_GuessGame then
                        -- 猜拳        -- test
                    elseif data.name == Daily_Robin then
                        -- 罗宾的花牌
                        label:setString(HLNSLocalizedString("花牌"))            
                    elseif data.name == Daily_FantasyTeam then
                        -- 梦幻海贼团
                        label:setString(HLNSLocalizedString("集卡"))
                        r_TopIcon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("timer_bg.png"))
                        label2:setString(HLNSLocalizedString("daily.timelimit"))
                    elseif data.name == Daily_Treasure then
                        -- 幸运卡牌
                        label:setString(HLNSLocalizedString("探宝"))      
                    elseif data.name == Daily_LevelUpReward then
                        -- 升级奖励
                        label:setString(HLNSLocalizedString("送礼"))
                    elseif data.name == Daily_GoldenBell then
                        -- 黄金钟
                        label:setString(HLNSLocalizedString("送金")) 
                        r_TopIcon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("timer_bg.png"))
                        label2:setString(HLNSLocalizedString("daily.timelimit"))
                    elseif data.name == Daily_InstructHeroG then
                        -- 高人特训
                        label:setString(HLNSLocalizedString("特训"))
                    elseif data.name == Daily_InstructHeroS then
                        -- 特训
                        label:setString(HLNSLocalizedString("特训"))
                    elseif data.name == Daily_PurchaseAward then
                        -- 充值返利
                        label:setString(HLNSLocalizedString("返利"))
                        r_TopIcon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("timer_bg.png"))
                        label2:setString(HLNSLocalizedString("daily.timelimit"))
                    elseif data.name == Daily_Invite then
                        label:setString(HLNSLocalizedString("邀请"))
                    elseif data.name == Daily_Qingjiao then     
                        -- 青椒的宝藏
                        label:setString(HLNSLocalizedString("宝藏"))
                        r_TopIcon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("timer_bg.png"))
                        label2:setString(HLNSLocalizedString("daily.timelimit"))
                    elseif data.name == Daily_SecretShop then     
                        -- 神秘商店
                        label:setString(HLNSLocalizedString("daily.shop"))

                    elseif data.name == Daily_DailySignIn then      -- 新增 每日签到
                        label:setString(HLNSLocalizedString("Daily_NameSignIn"))
                    elseif data.name == Daily_DrinkWine then      -- 新增 zoro饮酒
                        label:setString(HLNSLocalizedString("daily.drinkWine"))
                    elseif data.name == Daily_Compose then      -- lsf 装备分解合成
                        label:setString(HLNSLocalizedString("daily.compose"))
                    elseif data.name == Daily_LuckyReward then
                        -- 转盘
                        label:setString(HLNSLocalizedString("daily.luckyReward"))
                    elseif data.name == Daily_LuckyRank then
                        -- 转盘排行
                        label:setString(HLNSLocalizedString("daily.luckyRank"))
                    elseif data.name == Daily_LuckyShop then
                        -- 转盘商店
                        label:setString(HLNSLocalizedString("daily.shop"))
                    end 
                end
            end


            local light = item:getChildByTag(K_TAG_DAILYLIGHT)
            if light then
                light:stopAllActions()
                light:removeFromParentAndCleanup(true)
            end

            if data.shouldShine then
                local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
                cache:addSpriteFramesWithFile("ccbResources/treasureCard.plist")
                local light = CCSprite:createWithSpriteFrameName("treasureCard_roundFrame_1.png")
                local animFrames = CCArray:create()
                for j = 1, 3 do
                    local frameName = string.format("treasureCard_roundFrame_%d.png",j)
                    local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(frameName)
                    animFrames:addObject(frame)
                end
                local animation = CCAnimation:createWithSpriteFrames(animFrames, 0.2)
                local animate = CCAnimate:create(animation)
                light:runAction(CCRepeatForever:create(animate))
                item:addChild(light,1,K_TAG_DAILYLIGHT)
                light:setPosition(ccp(item:getContentSize().width / 2,item:getContentSize().height / 2))
            end

            if a1 == _currentPage then
                local sel = CCSprite:createWithSpriteFrameName("selFrame.png")
                item:addChild(sel, -1, 11)
                sel:setPosition(item:getContentSize().width / 2, item:getContentSize().height / 2)
            end

            r = a2
        elseif fn == "numberOfCells" then
            -- Return number of cells
            r = dailyData:getDailyCount()
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
    local leftArrow = DailyViewOwner["leftArrow"]
    local rightArrow = DailyViewOwner["rightArrow"]
    local sp = CCSprite:createWithSpriteFrameName("frame_0.png")
    local contentLayer = DailyViewOwner["contentLayer"]
    local size = CCSizeMake((contentLayer:getContentSize().width  - leftArrow:getContentSize().width * 2 * retina ), sp:getContentSize().height * retina * 1.1)
    tableView = LuaTableView:createWithHandler(h, size)
    tableView:setBounceable(true)
    tableView:setAnchorPoint(ccp(0, 0))
    tableView:setPosition(ccp((leftArrow:getPositionX() + leftArrow:getContentSize().width * retina), winSize.height - sp:getContentSize().height * retina * 0.55))
    tableView:setVerticalFillOrder(0)
    tableView:setDirection(0)
    contentLayer:addChild(tableView, 10, 10)
end

local function _addSelFrame()
    if not _currentPage then
        return
    end
    if not tableView then
        return
    end
    local cell = tableView:cellAtIndex(_currentPage)
    if cell then
        local item = tolua.cast(cell:getChildByTag(10):getChildByTag(_currentPage), "CCMenuItemImage")
        if not item:getChildByTag(11) then
            local sel = CCSprite:createWithSpriteFrameName("selFrame.png")
            item:addChild(sel, -1, 11)
            sel:setPosition(item:getContentSize().width / 2, item:getContentSize().height / 2)
        end
    end    
end

local function refreshTableViewOffset()
    local contentLayer = DailyViewOwner["contentLayer"]
    local leftArrow = DailyViewOwner["leftArrow"]
    local rightArrow = DailyViewOwner["rightArrow"]
    local width = contentLayer:getContentSize().width - leftArrow:getContentSize().width * 2 * retina
    local sp = CCSprite:createWithSpriteFrameName("frame_0.png")
    local count = dailyData:getDailyCount()
    if tableView:getContentOffset().x >= -_currentPage * sp:getContentSize().width * 1.1 * retina 
        and tableView:getContentOffset().x < (width - _currentPage * sp:getContentSize().width * 1.1 * retina) then
        -- 如果需要显示的大关cell在显示区域中
        _addSelFrame()
        return
    end

    local x = math.min(_currentPage * sp:getContentSize().width * 1.1 * retina, count * sp:getContentSize().width * 1.1 * retina - width)
    tableView:setContentOffsetInDuration(ccp(-x, 0), 0.2)
    _layer:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCCallFunc:create(_addSelFrame)))
end

local function playDailyMusic(idx)
    local name = _allData[idx + 1].name
    if name == Daily_Worship then
        playMusic(MUSIC_SOUND_DAILY_MERMAN, true) 
    elseif name == Daily_Wish then
        playMusic(MUSIC_SOUND_DAILY_BLUCK, true) 
    elseif name == Daily_EatDumpling then
        playMusic(MUSIC_SOUND_DAILY_EAT, true) 
    elseif name == Daily_Robin then
        playMusic(MUSIC_SOUND_DAILY_ROBIN, true) 
    elseif name == Daily_GoldenBell then
        playMusic(MUSIC_SOUND_DAILY_GOLDBELL, true)
    elseif name == Daily_LevelUpReward then
        playMusic(MUSIC_SOUND_DAILY_LEVELUP, true)
    elseif string.find(name, "instruct") then
        playMusic(MUSIC_SOUND_DAILY_INSTRUCT, true) 
    else
        playMusic(MUSIC_SOUND_1, true)
    end
end

local function changePage(idx)
    print("changePage", idx)
    local cell = tableView:cellAtIndex(_currentPage)
    if cell then
        local item = tolua.cast(cell:getChildByTag(10):getChildByTag(_currentPage), "CCMenuItemImage")
        if item:getChildByTag(11) then 
            item:removeChildByTag(11, true)
        end
    end
    _currentPage = idx
    refreshTableViewOffset()
    for i,v in ipairs(_allData) do
        if _currentPage == i - 1 then
            if v.name == Daily_GoldenBell then
                if getGoldClockLayer() then
                    getGoldClockLayer():refresh()
                end
            elseif v.name == Daily_Invite then
                if getInviteLayer() then
                    getInviteLayer():onEnterFresh()
                end
            elseif v.name == Daily_DailySignIn then  -- 新增 每日签到 
                if getDailySignInViewLayer() then
                    getDailySignInViewLayer():getInfo()
                end
            elseif v.name == Daily_SecretShop then
                runtimeCache.isSecretShopRefresh = false
                _layer:updateDailyStatus()
                if getMysteryShopLayer() then
                    getMysteryShopLayer():getInfo()
                end
            elseif v.name == Daily_LuckyReward then
                getLuckyRewardLayer():getInfo()
            elseif v.name == Daily_LuckyRank then
                getLuckyRankLayer():getInfo()
            elseif v.name == Daily_LuckyShop then
                getLuckyShopLayer():getInfo()
            end
            break
        end
    end
    playDailyMusic(idx)
end

local function addPageView()
    -- 分页数
    local pagesCount = dailyData:getDailyCount()
    if pagesCount <= 0 then
        return
    end 

    local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
    cache:addSpriteFramesWithFile("ccbResources/newworld.plist")
    local sp = CCSprite:createWithSpriteFrameName("newworld_bg_0.png")
    local topBg = DailyViewOwner["teamTopBg"]

    --  pageview滴创建需要3个参数，第一个ccrect用来设置触摸区域，第二个ccsize，用来设置中间的显示区域，如果只需要显示单页，设置为和第一个参数相同，第三个参数是floot，用来设置缩放比率，当小于等于1滴时候可以缩放，大于1滴时候不能缩放
    pageView = PageView:create(
                                CCRect(0, 0, winSize.width, sp:getContentSize().height * retina),
                                CCSizeMake(winSize.width, sp:getContentSize().height * retina), 
                                2
                            )
    local _mainLayer = getMainLayer()
    local y = (winSize.height - _mainLayer:getBroadCastContentSize().height + _mainLayer:getBottomContentSize().height -
     topBg:getContentSize().height * retina - sp:getContentSize().height * retina) / 2
    pageView:setPosition(0, y)
    pageView:setAnchorPoint(ccp(0, 0))
    pageView:registerScriptHandler(changePage)
    
    instructArray = {}
    for i = 1, pagesCount do
        local layer = nil
        local data = _allData[i]
        if data then
            if data.name == Daily_EatDumpling then
                -- 吃饭
                layer = createEatLayer() 
            elseif data.name == Daily_CalmBelt then
                -- 无风带
                layer = createCalmBeltLayer()
            elseif data.name == Daily_Wish then
                -- 许愿
                layer = createBluckSingLayer()       -- test
            elseif data.name == Daily_Worship then
                -- 人鱼公主
                layer = createMermanLayer()
            elseif data.name == Daily_YUEKA then
                layer = createYueKaLayer()
                -- renzhan newAdd
                -- layer = createMysterShopLayer()
            elseif data.name == Daily_Alcohol then
                -- 饮酒
                layer = createMermanLayer()              -- test
            elseif data.name == Daily_GuessGame then
                -- 猜拳
                layer = createMermanLayer()       -- test
            elseif data.name == Daily_Robin then
                -- 罗宾的花牌
                layer = createLuoBinFlowerLayer()             
            elseif data.name == Daily_FantasyTeam then
                -- 梦幻海贼团
                layer = createHaiZeiTeamLayer()       -- test
            elseif data.name == Daily_Treasure then
                -- 幸运卡牌
                layer = createTreasureLayer()       
            elseif data.name == Daily_LevelUpReward then
                -- 升级奖励
                layer = createUpgrateAwardLayer()       -- test
            elseif data.name == Daily_GoldenBell then
                -- 黄金钟
                layer = createGoldClockLayer()  
            elseif data.name == Daily_InstructHeroG then
                layer = createInsturctGroupLayer(data)     
                table.insert(instructArray, layer)
            elseif data.name == Daily_InstructHeroS then
                -- 特训
                layer = createInstructSingleLayer()
            elseif data.name == Daily_PurchaseAward then
                layer = createPurchaseLayer()
            elseif data.name == Daily_Invite then
                layer = createInviteLayer() 
            elseif data.name == Daily_Qingjiao then     
                -- 青椒的宝藏
                layer = createQingjiaoLayer()
            elseif data.name == Daily_SecretShop then
                -- 神秘商店
                layer = createMysterShopLayer()
            elseif data.name == Daily_DailySignIn then  -- 新增 每日签到
                layer = createDailySignInViewLayer()
                if i ==1 then
                    layer:getInfo()
                end
            elseif data.name == Daily_DrinkWine then  -- 新增 zoro饮酒
                layer = createDailyDrinkWineViewLayer()
            elseif data.name == Daily_Compose then  -- 装备合成分解
                layer = createDecomposeAndComposeLayer()
            elseif data.name == Daily_LuckyReward then
                -- 转盘
                layer = createLuckyRewardLayer() 
            elseif data.name == Daily_LuckyRank then
                -- 转盘排行
                layer = createLuckyRankLayer() 
            elseif data.name == Daily_LuckyShop then
                -- 转盘商店
                layer = createLuckyShopLayer() 
            end 
        end
        if layer then 
            layer:setAnchorPoint(ccp(0, 0))
            layer:setPosition(ccp((winSize.width - layer:getContentSize().width * retina) / 2, 0))
            local n = CCNode:create()
            n:addChild(layer)
            pageView:addPageView(i - 1, n)
        end 
    end

    _layer:addChild(pageView)
    pageView:updateView()
end

local function refreshDailyLayer()
    if pageView then
        pageView:removeFromParentAndCleanup(true)
        pageView = nil
    end
    if tableView then
        tableView:removeFromParentAndCleanup(true)
        tableView = nil
    end
    addPageView()
    addTableView()
    tableView:reloadData() 
    _addSelFrame()
    if runtimeCache.dailyPageNum then
        local page = 0
        for i=1,#_allData do
            if _allData[i].name == runtimeCache.dailyPageNum then
                page = i - 1
            end
        end
        _currentPage = page
        runtimeCache.dailyPageNum = nil
    end
    if _currentPage then
        if _currentPage >= #_allData then
            _currentPage = #_allData - 1
        end
        pageView:moveToPage(_currentPage)
    end
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/DailyView.ccbi",proxy, true,"DailyViewOwner")
    _layer = tolua.cast(node,"CCLayer")

    if userdata:getVipAuditState() then
        dailyData:deleteMonthCardData( )
        dailyData:deleteMysteryShopData()
    end
    if isPlatform(ANDROID_JAGUAR_TC) then
        dailyData:deleteMonthCardData( )
    end

    _dailyBtnStatus = dailyData:getDailyStatus()
    _allData = dailyData:getAllDailyData()

end

local function updateInstructCD()
    for i,v in ipairs(instructArray) do
        v:updateCD()
    end 
end

-- 更新日常按钮的状态
local function _updateDailyStatus(  )
    _dailyBtnStatus = dailyData:getDailyStatus()
    _allData = dailyData:getAllDailyData(  )
    if tableView then
        tableView:reloadData()
    end
    _addSelFrame()
    -- refreshTableViewOffset()
end

-- 该方法名字每个文件不要重复
function getDailyLayer()
	return _layer
end

function createDailyLayer()
    _init()
    
    function _layer:gotoPage(page)
        print("page, ",page)
        _currentPage = page
    end

    function _layer:refreshDailyLayer()
        refreshDailyLayer()
    end

    function _layer:updateDailyStatus()
        _updateDailyStatus()
    end

    function _layer:gotoDailyByName( name )
        local page = 0
        for i=1,#_allData do
            if _allData[i].name == name then
                page = i - 1

            end
        end
        _currentPage = page
        -- refreshDailyLayer()
    end

    function _layer:moveToPageByName(name)
        local page = 0
        for i=1,#_allData do
            if _allData[i].name == name then
                page = i - 1

            end
        end
        changeToPage(page)
    end

    function _layer:pageViewTouchEnabled(enable)
        pageView:setPageScrollEnable(enable)
    end

    local function _onEnter()
        if runtimeCache.gotoDailyPage >= 0 then
            _currentPage = runtimeCache.gotoDailyPage
            runtimeCache.gotoDailyPage = -1
        end
        if not _currentPage then
            _currentPage = 0
        end
        refreshDailyLayer()
        if runtimeCache.levelGuideNext then
            local page = dailyData:gotoPage(runtimeCache.levelGuideNext)
            if page > 0 then
                pageView:moveToPage(page)
            end
        else
            pageView:moveToPage(_currentPage)
            if _currentPage == 0 then
                playDailyMusic(0)
            end
        end

        addObserver(NOTI_INSTRUCT, updateInstructCD)
        addObserver(NOTI_DAILY_STATUS, _updateDailyStatus)
        addObserver(NOTI_DAILY_REFRESH, refreshDailyLayer)
    end

    local function _onExit()
        getMainLayer():TitleBgVisible(true)
        _layer = nil
        pageView = nil
        tableView = nil
        removeObserver(NOTI_INSTRUCT, updateInstructCD)
        removeObserver(NOTI_DAILY_STATUS, _updateDailyStatus)
        removeObserver(NOTI_DAILY_REFRESH, refreshDailyLayer)
        runtimeCache.levelGuideNext = nil
        playMusic(MUSIC_SOUND_1, true)
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