local _layer
local pageView
local tableView
local _currentPage
local _adventureList
local _enterSSA = false

local ADVENTURE_WIDTH = 640 * retina

-- ·名字不要重复
AdventureViewOwner = AdventureViewOwner or {}
ccb["AdventureViewOwner"] = AdventureViewOwner

-- ·名字不要重复
NewWorldFirstViewOwner = NewWorldFirstViewOwner or {}
ccb["NewWorldFirstViewOwner"] = NewWorldFirstViewOwner

local function adventureItemClick()
    print("adventureItemClick")
    -- runtimeCache.newWorldState = 1
    -- getNewWorldLayer():showLayer()
end
NewWorldFirstViewOwner["adventureItemClick"] = adventureItemClick

local function rankItemClick()
    print("rankItemClick")
end
NewWorldFirstViewOwner["rankItemClick"] = rankItemClick

local function _changeNewWorldState(state)
    for i=0,0 do
        local layer = NewWorldFirstViewOwner["state_"..i]
        layer:setVisible(false)
    end
    local layer = NewWorldFirstViewOwner["state_"..state]
    layer:setVisible(true)
end

local function changeToPage(tag)
    local key = _adventureList[_currentPage + 1] -- 获取key
    local layer = getMarineBranchEntranceLayer()
    if layer then
        if key == "xunbao" then
            layer:addRewardView()
        else
            layer:removeRewardView()
        end
    end
    if tag == _currentPage then
        return
    end
    pageView:moveToPage(tag)
end

local function addTableView()
    -- @param fn string Callback type
    -- @param table LuaTableView
    -- @param a1 & a2 mixed Difference means for every "fn"
    local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
    cache:addSpriteFramesWithFile("ccbResources/publicRes_4.plist")
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

            local item
            local key = _adventureList[a1 + 1] -- 获取key
           
            if key == "blood" then
                local norSp = CCSprite:createWithSpriteFrameName("adventure_icon.png")
                local selSp = CCSprite:createWithSpriteFrameName("adventure_icon.png")
                item = CCMenuItemSprite:create(norSp, selSp)
            elseif key == "SSA" then
                local norSp = CCSprite:createWithSpriteFrameName("ssa_icon.png")
                local selSp = CCSprite:createWithSpriteFrameName("ssa_icon.png")
                item = CCMenuItemSprite:create(norSp, selSp)
            elseif key == "boss" then
                -- boss战
                local norSp = CCSprite:createWithSpriteFrameName("boss_icon.png")
                local selSp = CCSprite:createWithSpriteFrameName("boss_icon.png")
                item = CCMenuItemSprite:create(norSp, selSp)
            elseif key == "veiledSea" then
                local norSp = CCSprite:createWithSpriteFrameName("veiledSea_icon.png")
                local selSp = CCSprite:createWithSpriteFrameName("veiledSea_icon.png")
                item = CCMenuItemSprite:create(norSp, selSp)
            --觉醒
            elseif key == "awake" then
                local norSp = CCSprite:createWithSpriteFrameName("awakening_icon.png")
                local selSp = CCSprite:createWithSpriteFrameName("awakening_icon.png")
                item = CCMenuItemSprite:create(norSp,selSp)
            elseif key == "uninhabited" then
                local norSp = CCSprite:createWithSpriteFrameName("uninhabited_icon.png")
                local selSp = CCSprite:createWithSpriteFrameName("uninhabited_icon.png")
                item = CCMenuItemSprite:create(norSp, selSp)
            elseif key == "calmbelt" then
                -- boss战
                local norSp = CCSprite:createWithSpriteFrameName("wufengdai_icon.png")
                local selSp = CCSprite:createWithSpriteFrameName("wufengdai_icon.png")
                item = CCMenuItemSprite:create(norSp, selSp)
            elseif key == "xunbao" then
                -- 寻宝
                local norSp = CCSprite:createWithSpriteFrameName("marine_icon.png")
                local selSp = CCSprite:createWithSpriteFrameName("marine_icon.png")
                item = CCMenuItemSprite:create(norSp, selSp)
            elseif key == "chapters" then
                -- 8种以上残章的情况
                local norSp = CCSprite:createWithSpriteFrameName("chapters_all.png")
                local selSp = CCSprite:createWithSpriteFrameName("chapters_all.png")
                item = CCMenuItemSprite:create(norSp, selSp)
            elseif havePrefix(key, "book_") then
                -- 单种残章的情况
                local conf = wareHouseData:getItemResource(key)
                local norSp = CCSprite:createWithSpriteFrameName(string.format("frame_%d.png", conf.rank))
                local selSp = CCSprite:createWithSpriteFrameName(string.format("frame_%d.png", conf.rank))

                item = CCMenuItemSprite:create(norSp, selSp)
                if conf.icon then
                    local sp = CCSprite:create(conf.icon)
                    if sp then
                        item:addChild(sp, 1, 10) 
                        sp:setScale(0.36)
                        sp:setPosition(item:getContentSize().width / 2, item:getContentSize().height / 2)
                    end
                end
            end
            local sp = CCSprite:createWithSpriteFrameName("frame_0.png")
            item:setAnchorPoint(ccp(0, 0))
            item:setPosition(ccp(sp:getContentSize().width * 0.05 * retina, sp:getContentSize().height * 0.02 * retina))
            item:registerScriptTapHandler(changeToPage)
            menu = CCMenu:create()
            menu:addChild(item, 1, a1)
            menu:setPosition(ccp(0, 0))
            menu:setAnchorPoint(ccp(0, 0))
            menu:setScale(retina)
            a2:addChild(menu, 1, 10)

            if isPlatform(ANDROID_VIETNAM_VI) 
                or isPlatform(ANDROID_VIETNAM_EN)
                or isPlatform(ANDROID_VIETNAM_MOB_THAI)
                or isPlatform(ANDROID_VIETNAM_EN_ALL)
                or isPlatform(IOS_VIETNAM_VI) 
                or isPlatform(IOS_MOBGAME_SPAIN)
                or isPlatform(ANDROID_MOBGAME_SPAIN) 
                or isPlatform(IOS_VIETNAM_EN) 
                or isPlatform(IOS_VIETNAM_ENSAGA) 
                or isPlatform(IOS_MOB_THAI)
                or isPlatform(IOS_MOBNAPPLE_EN)
                or isPlatform(WP_VIETNAM_EN) then
            else

                -- renzhan newAdd
                local menuBg = CCSprite:createWithSpriteFrameName("dailyNameBg.png")
                menuBg:setPosition(ccp(item:getContentSize().width - menuBg:getContentSize().width * 0.6, menuBg:getContentSize().height * 0.71))
                item:addChild(menuBg)

                local label = CCLabelTTF:create("", "ccbResources/FZCuYuan-M03S.ttf", 18)
                label:setPosition(menuBg:getContentSize().width / 2, menuBg:getContentSize().height / 2)
                label:setColor(ccc3(221,233,73))
                menuBg:addChild(label)
                if key == "blood" then
                    label:setString(HLNSLocalizedString("冒险"))
                elseif key == "SSA" then
                    label:setString(HLNSLocalizedString("SSA.server_pkName")) --跨服 
                elseif key == "veiledSea" then
                    label:setString(HLNSLocalizedString("adventure.veiledSea"))
                elseif key == "boss" then
                    -- boss战
                    label:setString(HLNSLocalizedString("daily.emogu"))
                elseif key == "awake" then
                    -- 觉醒
                    label:setString(HLNSLocalizedString("adventure.awake"))
                elseif key == "calmbelt" then
                    -- 无风带
                    label:setString(HLNSLocalizedString("daily.wufengdai"))
                elseif key == "xunbao" then
                    -- 寻宝
                    label:setString(HLNSLocalizedString("支部"))
                elseif key == "chapters" then
                    -- 8种以上残章的情况
                    label:setString(HLNSLocalizedString("残页"))
                elseif key == "uninhabited" then
                    label:setString(HLNSLocalizedString("haki.uninhabited.name"))
                end
            end


            if a1 == _currentPage then
                local sel = CCSprite:createWithSpriteFrameName("selFrame.png")
                item:addChild(sel, -1, 11)
                sel:setPosition(item:getContentSize().width / 2, item:getContentSize().height / 2)
            end
            
            r = a2
        elseif fn == "numberOfCells" then
            -- Return number of cells
            r = #_adventureList
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
    local leftArrow = AdventureViewOwner["leftArrow"]
    local rightArrow = AdventureViewOwner["rightArrow"]
    local sp = CCSprite:createWithSpriteFrameName("frame_0.png")
    local contentLayer = AdventureViewOwner["contentLayer"]
    local size = CCSizeMake((contentLayer:getContentSize().width - leftArrow:getContentSize().width * 2 * retina), sp:getContentSize().height * retina * 1.1)
    tableView = LuaTableView:createWithHandler(h, size)
    tableView:setBounceable(true)
    tableView:setAnchorPoint(ccp(0, 0))
    tableView:setPosition(ccp((leftArrow:getPositionX() + leftArrow:getContentSize().width * retina), winSize.height - sp:getContentSize().height * retina * 0.55))
    tableView:setVerticalFillOrder(0)
    tableView:setDirection(0)
    contentLayer:addChild(tableView, 10, 10)
end

local function _addSelFrame()
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
    local contentLayer = AdventureViewOwner["contentLayer"]
    local leftArrow = AdventureViewOwner["leftArrow"]
    local rightArrow = AdventureViewOwner["rightArrow"]
    local width = contentLayer:getContentSize().width - leftArrow:getContentSize().width * 2 * retina
    local sp = CCSprite:createWithSpriteFrameName("frame_0.png")
    if tableView:getContentOffset().x >= -_currentPage * sp:getContentSize().width * 1.1 * retina 
        and tableView:getContentOffset().x < (width - _currentPage * sp:getContentSize().width * 1.1 * retina) then
        _addSelFrame()
        return
    end

    local x = math.min(_currentPage * sp:getContentSize().width * 1.1 * retina, #_adventureList * sp:getContentSize().width * 1.1 * retina - width)
    tableView:setContentOffsetInDuration(ccp(-x, 0), 0.2)
    _layer:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCCallFunc:create(_addSelFrame)))
end

local function changePage(idx)
    local cell = tableView:cellAtIndex(_currentPage)
    if cell then
        local item = tolua.cast(cell:getChildByTag(10):getChildByTag(_currentPage), "CCMenuItemImage")
        if item:getChildByTag(11) then 
            item:removeChildByTag(11, true)
        end
    end
    _currentPage = idx
    refreshTableViewOffset()
    if getAwakeSecondLayer() then
        getAwakeSecondLayer():close()
    end
    local key = _adventureList[_currentPage + 1] -- 获取key
    if key == "SSA" then
        getStrideServerArenaLayer():refreshLayer()
    elseif key == "boss" then
        getBossLayer():getBossInfo()
    elseif key == "veiledSea" then
        getVeiledSeaFirstLayer():refreshLayer()
    elseif key == "uninhabited" then
        getUninhabitedLayer():getInfo()
    end
    local layer = getMarineBranchEntranceLayer()
    if layer then
        if key == "xunbao" then
            layer:addRewardView()
        else
            layer:removeRewardView()
        end
    end
end

local function addPageView()
    local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
    cache:addSpriteFramesWithFile("ccbResources/newworld.plist")
    local sp = CCSprite:createWithSpriteFrameName("newworld_bg_0.png")
    local topBg = AdventureViewOwner["teamTopBg"]

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
    
    -- 分页数
    local pagesCount = #_adventureList

    local proxy = CCBProxy:create()
    for i = 1, pagesCount do
        local layer
        local key = _adventureList[i]
        
        if key == "blood" then
            layer = createNewWorldLayer()
        elseif key == "SSA" then  
            layer = createStrideServerArenaLayer()  
        elseif key == "boss" then
            -- boss战
            layer = createBossLayer()
        elseif key == "calmbelt" then
            layer = createCalmBeltLayer()
        elseif key == "awake" then
            layer = createawakeFirstViewLayer()
        elseif key == "xunbao" then
            layer = createMarineBranchEntranceLayer()
        elseif key == "chapters" then
            -- 8种以上残章的情况
            layer = createChaptersLayer()
        elseif havePrefix(key, "book_") then
            -- 单种残章的情况
            layer = createChapterLayer(key)
        elseif havePrefix(key, "veiledSea") then
            -- 迷雾之海
            layer = createVeiledSeaFirstLayer()
        elseif key == "uninhabited" then
            layer = createUninhabitedLayer()
        end
        layer:setAnchorPoint(ccp(0, 0))
        layer:setPosition(ccp((winSize.width - layer:getContentSize().width * retina) / 2, 0))
        local n = CCNode:create()
        n:addChild(layer)
        pageView:addPageView(i - 1, n)
    end

    _layer:addChild(pageView)
    pageView:updateView()
end

local function refreshAdventureLayer()
    _adventureList = userdata:getUserAdventureList()
    if pageView then
        pageView:removeFromParentAndCleanup(true)
        pageView = nil
    end
    if tableView then
        tableView:removeFromParentAndCleanup(true)
        tableView = nil
    end
    if #_adventureList > 0 then
        if _currentPage >= #_adventureList then
            _currentPage = #_adventureList - 1
        end
        addPageView()
        addTableView()
        tableView:reloadData()
        _addSelFrame()
        pageView:moveToPage(_currentPage)
        changeToPage(_currentPage)
    end
end

-- renzhan newAdd
local function infoClick()
    getMainLayer():getParent():addChild(createNewWorldHelp()) 
end
NewWorldFirstViewOwner["infoClick"] = infoClick

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/AdventureView.ccbi",proxy, true,"AdventureViewOwner")
    _layer = tolua.cast(node,"CCLayer")
end

local function _bossFightEnd()
    getBossLayer():bossFightEnd()
end

-- 该方法名字每个文件不要重复
function getAdventureLayer()
	return _layer
end

function createAdventureLayer()
    _init()

    function _layer:refreshAdventureLayer()
        refreshAdventureLayer()
    end

    function _layer:moveToPage(page)
        _currentPage = page
    end

    function _layer:showMarine()
        changeToPage(userdata:getMarinePage())
    end

    function _layer:showCalmBelt()
        changeToPage(userdata:getCalmBeltPage())
    end

    function _layer:showUninhabited()
        changeToPage(userdata:getUninhabitedPage())
    end

    function _layer:enterSSA()
        _enterSSA = true
    end

    -- 觉醒前往大冒险
    function _layer:showAdventure( )
        changeToPage(userdata:getAdventurePage())
    end


    -- 觉醒前往恶魔岛  任务跳转页码用到
    function _layer:showBoss()
        changeToPage(userdata:getBossPage())
    end
    -- 觉醒前往任务 迷雾之海
    function _layer:showHaze()
        changeToPage(userdata:getHazePage())
    end

    function _layer:bossFightEnd()
        _currentPage = userdata:getBossPage()
        _layer:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCCallFunc:create(_bossFightEnd)))
    end

    function _layer:pageViewTouchEnabled(enable)
        pageView:setPageScrollEnable(enable)
    end

    function _layer:chapterFightResult()
        if BattleField.result == RESULT_WIN then
            if runtimeCache.chapterFight.result == 1 then
                getMainLayer():getParent():addChild(createChapterRobSuccLayer(), 10)
            else
                getMainLayer():getParent():addChild(createChapterRobFailLayer(1, -134), 10)
            end
        else
            getMainLayer():getParent():addChild(createChapterRobFailLayer(2, -134), 10)
        end
    end

    local function _onEnter()
        if not _currentPage then
            _currentPage = 0
        end
        refreshAdventureLayer()
        if runtimeCache.levelGuideNext == "blackbeard" then
            pageView:moveToPage(userdata:getBossPage())
            runtimeCache.levelGuideNext = nil
        end
    end

    local function _onExit()
        if not _enterSSA and getMainLayer() then
            getMainLayer():TitleBgVisible(true)
        end
        _layer = nil
        pageView = nil
        tableView = nil
        _enterSSA = false
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