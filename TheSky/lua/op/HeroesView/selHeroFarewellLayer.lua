local _layer
local _canFarewell = nil
local _selected = -1
local _desHeroUId = nil
local _totalExp 
local _desNextExp = 0
local _tableView = nil
local cellArray = {}

-- 名字不要重复
SelHeroFarewellOwner = SelHeroFarewellOwner or {}
ccb["SelHeroFarewellOwner"] = SelHeroFarewellOwner
OnFormCellOwner = OnFormCellOwner or {}
ccb["OnFormCellOwner"] = OnFormCellOwner

local function calcTotalExp(  )
    _totalExp = 0
    for i=1,#_canFarewell do
        local hid = _canFarewell[i]
        local eachInfo = herodata:getHeroInfoByHeroUId(hid)
        _totalExp = _totalExp + eachInfo.exp_all
    end
    local desInfo = herodata:getHeroInfoByHeroUId(_desHeroUId)
    _desNextExp = desInfo.expMax - desInfo.exp_now
end

local function onFormCallback(url, rtnData)
    -- PrintTable(rtnData)
    -- local form = rtnData["info"].form
    -- herodata.form = form
    -- getMainLayer():gotoTeam()
end

local function confirmItemClick(tag)
    print("confirmItemClick")
    if _selected == -1 then
        getMainLayer():goToFarewell(_desHeroUId, nil, 0)
    else
        local heroUid = _canFarewell[_selected + 1]
        getMainLayer():goToFarewell(_desHeroUId, heroUid, 1)
    end
end
SelHeroFarewellOwner["confirmItemClick"] = confirmItemClick

local function _addTableView()
    -- 经验层
    local expLayer = SelHeroFarewellOwner["expLayer"]
    local function displayExp(  )
        print("displayExp", _selected)
        local heroUid = _canFarewell[_selected + 1]
        local srcExp = herodata:getHeroInfoByHeroUId(heroUid)

        local totalExp = tolua.cast(SelHeroFarewellOwner["totalExp"], "CCLabelTTF")
        local selExp = tolua.cast(SelHeroFarewellOwner["selExp"], "CCLabelTTF")
        local upgradeExp = tolua.cast(SelHeroFarewellOwner["upgradeExp"], "CCLabelTTF")

        totalExp:setString(string.format(HLNSLocalizedString("被传承的伙伴将被消耗，可传承的总经验：%d"), _totalExp))
        selExp:setString(string.format(HLNSLocalizedString("被选择船员总经验：%d"), _selected ~= -1 and srcExp.exp_all or 0))
        upgradeExp:setString(string.format(HLNSLocalizedString("底卡升级需要经验：%d"), _desNextExp))

        totalExp:setVisible(true)
        selExp:setVisible(true)
        upgradeExp:setVisible(true)
    end
    displayExp()
    -- 伙伴列表
    local function onHeadIconClicked(tag)
        print("SelHeroFarewellOwner onHeadIconClicked")
        local heroUid = _canFarewell[tag + 1]
        if heroUid then
            -- 显示英雄信息
            getMainLayer():addChild(createHeroInfoLayer(heroUid, HeroDetail_Clicked_SelectHero, -135))
        end 
    end
    OnFormCellOwner["onHeadIconClicked"] = onHeadIconClicked

    local _topLayer = SelHeroFarewellOwner["HBTopLayer"]
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

            local hid = _canFarewell[a1 + 1]
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

            _hbCell:stopAllActions()
            cellArray[tostring(a1)] = _hbCell
            r = a2
        elseif fn == "numberOfCells" then
            -- Return number of cells
            r = #_canFarewell
        -- Cell events:
        elseif fn == "cellTouched" then         -- A cell was touched, a1 is cell that be touched. This is not necessary.
            local headIconBtn = tolua.cast(a1:getChildByTag(100):getChildByTag(100):getChildByTag(100):getChildByTag(a1:getIdx()), "CCMenuItemImage")
            if headIconBtn:isSelected() then
                return r
            end
            _selected = _selected == a1:getIdx() and -1 or a1:getIdx()
            displayExp()
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
        local size = CCSizeMake(winSize.width, (winSize.height - _topLayer:getContentSize().height - _mainLayer:getBottomContentSize().height)*99/100 - expLayer:getContentSize().height * retina)      -- 这里是为了在tableview上面显示一个小空出来
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
    local  node  = CCBReaderLoad("ccbResources/SelHeroFarewellView.ccbi", proxy, true,"SelHeroFarewellOwner")
    _layer = tolua.cast(node,"CCLayer")
end

-- 该方法名字每个文件不要重复
function getSelHeroFarewellLayer()
    return _layer
end

function createSelHeroFarewellLayer(heroUId)
    _desHeroUId = heroUId
    _init()

    local function _onEnter()
        _canFarewell = herodata:getCanFarewellHeroes(_desHeroUId)
        calcTotalExp()
        local cantTips2 = tolua.cast(SelHeroFarewellOwner["cantTips2"], "CCLabelTTF")
        if _canFarewell == nil or #_canFarewell <= 0 then
            cantTips2:setVisible(true)
        else
            cellArray = {}
            _addTableView()
            _tableView:reloadData()
            generateCellAction( cellArray,#_canFarewell )
            cellArray = {}
        end
    end 

    local function _onExit()
        print("onExit")
        _layer = nil
        _canFarewell = nil
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