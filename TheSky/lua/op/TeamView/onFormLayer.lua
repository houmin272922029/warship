local _layer
local _offForm
local _selected = -1
local _tableView

-- 名字不要重复
OnFormOwner = OnFormOwner or {}
ccb["OnFormOwner"] = OnFormOwner
OnFormCellOwner = OnFormCellOwner or {}
ccb["OnFormCellOwner"] = OnFormCellOwner

local function onFormCallback(url, rtnData)
    local form = rtnData["info"].form
    local sevenForm = rtnData["info"].form_seven
    local heroes = rtnData["info"].heros
    if heroes then
        herodata.heroes = heroes
    end
    if form then
        herodata.form = form
    end
    if sevenForm then
        herodata.sevenForm = sevenForm
    end
    getMainLayer():gotoTeam()
end

local function onFormSevenCallback(url, rtnData)
    local form = rtnData["info"].form
    local sevenForm = rtnData["info"].form_seven
    local heroes = rtnData["info"].heros
    if heroes then
        herodata.heroes = heroes
    end
    if form then
        herodata.form = form
    end
    if sevenForm then
        herodata.sevenForm = sevenForm
    end
    getMainLayer():gotoTeam()
end

local function confirmItemClick(tag)
    print(runtimeCache.teamPage)
    if _selected == -1 then
        getMainLayer():gotoTeam()
    else
        local hid = _offForm[_selected + 1]
        if runtimeCache.isSevenForm then
            doActionFun("ON_FORM_SEVEN", {runtimeCache.sevenFormPosition, hid}, onFormSevenCallback)
        else
            doActionFun("ON_FORM", {runtimeCache.teamPage, hid}, onFormCallback)
        end
    end
end
OnFormOwner["confirmItemClick"] = confirmItemClick

local function _addTableView()
    local function onHeadIconClicked(tag)
        local heroUid = _offForm[tag + 1]
        if heroUid then
            -- 显示英雄信息
            getMainLayer():addChild(createHeroInfoLayer(heroUid, HeroDetail_Clicked_SelectHero, -135))
        end 
    end
    OnFormCellOwner["onHeadIconClicked"] = onHeadIconClicked
    
    local _topLayer = OnFormOwner["HBTopLayer"]
    -- @param fn string Callback type
    -- @param table LuaTableView
    -- @param a1 & a2 mixed Difference means for every "fn"
    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(winSize.width, 170 * retina)
        elseif fn == "cellAtIndex" then
            -- Return CCTableViewCell, a1 is cell index (zero based), a2 is dequeued cell (maybe nil)
            -- Do something to create cell  and change the content
            
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            local  proxy = CCBProxy:create()
            local  _hbCell = tolua.cast(CCBReaderLoad("ccbResources/OnFormCell.ccbi",proxy,true, "OnFormCellOwner"),"CCSprite")
            _hbCell:setAnchorPoint(ccp(0.5, 0.5))
            _hbCell:setPosition(winSize.width/2, 170 * retina/2)
            _hbCell:setScale(retina)

            local hid = _offForm[a1 + 1]
            local hero = herodata:getHero(herodata.heroes[hid])
            local frame = tolua.cast(OnFormCellOwner["frame"], "CCSprite")
            frame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", hero.rank)))
            local headIconBtn = tolua.cast(OnFormCellOwner["headIconBtn"], "CCMenuItemImage")
            if headIconBtn then
                headIconBtn:setTag(a1)
                local headSpr = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(herodata:getHeroHeadByHeroId(hero.heroId))
                if headSpr then
                    headIconBtn:setNormalSpriteFrame(headSpr)
                end
            end 
            local breakLevel = OnFormCellOwner["breakLevel"]
            local breakLevelFnt = tolua.cast(OnFormCellOwner["breakLevelFnt"], "CCLabelBMFont")
            local breakValue = hero["break"]
            if breakLevel and breakValue ~= 0 then 
                breakLevel:setVisible(true)
                breakLevelFnt:setString(breakValue)
            end 
            local name = tolua.cast(OnFormCellOwner["name"], "CCLabelTTF")
            name:setString(hero.name)
            local rank = tolua.cast(OnFormCellOwner["rank"], "CCSprite")
            rank:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("rank_%d_icon.png", hero.rank)))
            local level = tolua.cast(OnFormCellOwner["level"], "CCLabelTTF")
            level:setString(hero.level)
            local price = tolua.cast(OnFormCellOwner["price"], "CCLabelTTF")
            price:setString(hero.price)
            local stamp = tolua.cast(OnFormCellOwner["stamp"], "CCSprite")
            local bg = tolua.cast(OnFormCellOwner["bg"], "CCSprite")
            if a1 == _selected then
                stamp:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("stamp3.png"))
                bg:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("huobanCellBg_sel.png"))
            end

            a2:addChild(_hbCell, 0, 100)

            r = a2
        elseif fn == "numberOfCells" then
            -- Return number of cells
            r = #_offForm
        -- Cell events:
        elseif fn == "cellTouched" then         -- A cell was touched, a1 is cell that be touched. This is not necessary.
            local headIconBtn = tolua.cast(a1:getChildByTag(100):getChildByTag(100):getChildByTag(100):getChildByTag(a1:getIdx()), "CCMenuItemImage")
            if headIconBtn:isSelected() then
                return r
            end
            _selected = _selected == a1:getIdx() and -1 or a1:getIdx()
            local offsetY = _tableView:getContentOffset().y
            _tableView:reloadData()
            _tableView:setContentOffset(ccp(0, offsetY))
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
        local size = CCSizeMake(winSize.width, (winSize.height - _topLayer:getContentSize().height - _mainLayer:getBottomContentSize().height)*99/100)      -- 这里是为了在tableview上面显示一个小空出来
        -- print(size.width.." "..size.height)
        _tableView = LuaTableView:createWithHandler(h, size)
        _tableView:setBounceable(true)
        _tableView:setAnchorPoint(ccp(0,0))
        _tableView:setPosition(ccp(0, _mainLayer:getBottomContentSize().height))
        _tableView:setVerticalFillOrder(0)
        _layer:addChild(_tableView)
    end
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/OnFormView.ccbi", proxy, true,"OnFormOwner")
    _layer = tolua.cast(node,"CCLayer")
end

-- 该方法名字每个文件不要重复
function getOnFormLayer()
    return _layer
end

local function cardConfirmAction()
    getMainLayer():goToLogue() 
end
local function cardCancelAction()

end

function createOnFormLayer()
    _init()

    function _layer:selectHero(index)
        _selected = index
        local offsetY = _tableView:getContentOffset().y
        _tableView:reloadData()
        _tableView:setContentOffset(ccp(0, offsetY))
    end

    function _layer:confirmItemClick()
        confirmItemClick() 
    end

    function _layer:onFormCallback(url, rtnData)
        onFormCallback(url, rtnData)
    end

    local function _onEnter()
        _offForm = herodata:getHeroOffForm()
        _addTableView()
        _tableView:reloadData()
        if #_offForm == 0 and not herodata.heroes[index] then
            local text = HLNSLocalizedString("team.need.partner")
            _layer:addChild(createSimpleConfirCardLayer(text), 100)
            SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
            SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction
        end
    end

    local function _onExit()
        print("onExit")
        _layer = nil
        _offForm = nil
        _selected = -1
        _tableView = nil
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