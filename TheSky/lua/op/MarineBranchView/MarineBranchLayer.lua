local _layer
local pageView
local tableView
local _currentPage
local _marineBranchList

-- ·名字不要重复
MarineBranchViewOwner = MarineBranchViewOwner or {}
ccb["MarineBranchViewOwner"] = MarineBranchViewOwner

local function changeToPage(tag)
    if tag == _currentPage then
        return
    end
    pageView:moveToPage(tag)
end

local function addTableView()
    -- @param fn string Callback type
    -- @param table LuaTableView
    -- @param a1 & a2 mixed Difference means for every "fn"
    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            local sp = CCSprite:createWithSpriteFrameName("marine_island_0.png")
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
            local contentData = _marineBranchList[a1 + 1] -- 获取key
            local sp = CCSprite:createWithSpriteFrameName("marine_island_0.png")

            local norSp = CCSprite:createWithSpriteFrameName("marine_island_0.png")
            local selSp = CCSprite:createWithSpriteFrameName("marine_island_0.png")
            item = CCMenuItemSprite:create(norSp, selSp)

            local marineName = marineBranchData:getConfig(contentData.stageId).nsname
            local nums = string.split(marineName, "-")[2]
            local strLen = string.len(nums)
            local spriteG = CCSprite:createWithSpriteFrameName("num_G.png")
            local startPointX = (sp:getContentSize().width - (strLen + 1) * spriteG:getContentSize().width) / 2
            item:addChild(spriteG)
            spriteG:setPosition(ccp(startPointX + spriteG:getContentSize().width / 2,spriteG:getContentSize().height / 2))
            for i=1,strLen do
                local char = string.sub(nums, i, i)
                local spriteCount = CCSprite:createWithSpriteFrameName(string.format("num_%s.png",char))
                item:addChild(spriteCount)
                spriteCount:setPosition(ccp(startPointX + spriteG:getContentSize().width * i + spriteG:getContentSize().width / 2,spriteG:getContentSize().height / 2))
            end

            item:setAnchorPoint(ccp(0, 0))
            item:setPosition(ccp(sp:getContentSize().width * retina * 0.1,0))
            item:registerScriptTapHandler(changeToPage)
            menu = CCMenu:create()
            menu:addChild(item, 1, a1)
            menu:setPosition(ccp(0, 0))
            menu:setAnchorPoint(ccp(0, 0))
            menu:setScale(retina)
            
            a2:addChild(menu, 1, 10)
           
            if a1 == _currentPage then
                local sel = CCSprite:createWithSpriteFrameName("marine_island_1.png")
                item:addChild(sel, -1, 11)
                sel:setPosition(item:getContentSize().width / 2, item:getContentSize().height / 2)
            end
            
            r = a2
        elseif fn == "numberOfCells" then
            r = getMyTableCount(_marineBranchList)
        elseif fn == "cellTouched" then         -- A cell was touched, a1 is cell that be touched. This is not necessary.
        elseif fn == "cellTouchBegan" then      -- A cell is touching, a1 is cell, a2 is CCTouch
        elseif fn == "cellTouchEnded" then      -- A cell was touched, a1 is cell, a2 is CCTouch
        elseif fn == "cellHighlight" then       -- A cell is highlighting, coco2d-x 2.1.3 or above
        elseif fn == "cellUnhighlight" then     -- A cell had been unhighlighted, coco2d-x 2.1.3 or above
        elseif fn == "cellWillRecycle" then     -- A cell will be recycled, coco2d-x 2.1.3 or above
        end
        return r
    end)
    local leftArrow = MarineBranchViewOwner["leftArrow"]
    local rightArrow = MarineBranchViewOwner["rightArrow"]
    local sp = CCSprite:createWithSpriteFrameName("marine_island_0.png")
    local contentLayer = MarineBranchViewOwner["contentLayer"]
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
            local sel = CCSprite:createWithSpriteFrameName("marine_island_1.png")
            item:addChild(sel, -1, 11)
            sel:setPosition(item:getContentSize().width / 2, item:getContentSize().height / 2)
        end
    end
end

local function refreshTableViewOffset()
    local contentLayer = MarineBranchViewOwner["contentLayer"]
    local leftArrow = MarineBranchViewOwner["leftArrow"]
    local rightArrow = MarineBranchViewOwner["rightArrow"]
    local width = contentLayer:getContentSize().width - leftArrow:getContentSize().width * 2 * retina
    local sp = CCSprite:createWithSpriteFrameName("marine_island_0.png")
    if tableView:getContentOffset().x >= -_currentPage * sp:getContentSize().width * 1.1 * retina 
        and tableView:getContentOffset().x < (width - _currentPage * sp:getContentSize().width * 1.1 * retina) then
        _addSelFrame()
        return
    end

    local x = math.min(_currentPage * sp:getContentSize().width * 1.1 * retina, #_marineBranchList * sp:getContentSize().width * 1.1 * retina - width)
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
    -- local key = _marineBranchList[_currentPage + 1] -- 获取key
    -- if key == "boss" then
    --     getBossLayer():getBossInfo()
    -- end
end

local function addPageView()
    local sp = CCSprite:createWithSpriteFrameName("newworld_bg_0.png")
    local topBg = MarineBranchViewOwner["teamTopBg"]

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
    local pagesCount = getMyTableCount(_marineBranchList)

    local proxy = CCBProxy:create()
    for i = 1, pagesCount do
        local layerData = _marineBranchList[i]       -- 每个页面的数据

        local layer

        if marineBranchData:isOpenBossLevel( layerData ) then
            layer = createMarineChallengeBossLayer(i)                -- 页面添加到这里
        else
            layer = createMBMobsLayer(i ,layerData)
        end
        -- if marineBranchData:isOpenBossLevel( layerData ) then
            -- layer = createMarineChallengeBossLayer(i)                -- 页面添加到这里
        -- else
        -- end
        layer:setAnchorPoint(ccp(0, 0))
        layer:setPosition(ccp((winSize.width - layer:getContentSize().width * retina) / 2, 0))
        local n = CCNode:create()
        n:addChild(layer)
        pageView:addPageView(i - 1, n)
    end

    _layer:addChild(pageView)
    pageView:updateView()
end

local function refreshMarineBranchLayer()
    _marineBranchList = marineBranchData:getMarineData(  )
    if pageView then
        pageView:removeFromParentAndCleanup(true)
        pageView = nil
    end
    if tableView then
        tableView:removeFromParentAndCleanup(true)
        tableView = nil
    end
    if getMyTableCount(_marineBranchList) > 0 then
        if _currentPage >= getMyTableCount(_marineBranchList) then
            _currentPage = getMyTableCount(_marineBranchList) - 1
        end
        addPageView()
        addTableView()
        tableView:reloadData()
        _addSelFrame()
        pageView:moveToPage(_currentPage)
    end
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/MarineBranchView.ccbi",proxy, true,"MarineBranchViewOwner")
    _layer = tolua.cast(node,"CCLayer")
end

-- 该方法名字每个文件不要重复
function getMarineBranchLayer()
	return _layer
end

function createMarineBranchLayer()
    _init()

    function _layer:refreshMarineBranchLayer()
        refreshMarineBranchLayer()
    end

    function _layer:moveToPage(page)
        _currentPage = page
    end

    function _layer:pageViewTouchEnabled(enable)
        pageView:setPageScrollEnable(enable)
    end

    local function _onEnter()
        if not _currentPage then
            _currentPage = 0
        end
        refreshMarineBranchLayer()
    end

    local function _onExit()
        if getMainLayer() then
            getMainLayer():TitleBgVisible(true)
        end
        _layer = nil
        pageView = nil
        tableView = nil
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