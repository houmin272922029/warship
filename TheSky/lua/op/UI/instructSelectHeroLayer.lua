local _layer
local tableView
local _priority = -134
local _heroes
local _selected
local _instructId


-- 名字不要重复
InstructSelectHeroOwner = InstructSelectHeroOwner or {}
ccb["InstructSelectHeroOwner"] = InstructSelectHeroOwner


local function closeItemClick()
    popUpCloseAction( InstructSelectHeroOwner,"infoBg",_layer )
end
InstructSelectHeroOwner["closeItemClick"] = closeItemClick

local function instructSingleHeroCallback(url, rtnData)
    getMainLayer():getParent():addChild(createIntructSingleResultLayer(rtnData.info.gain.instruct, dailyData:getSingleHeroId(_instructId), -134), 200)
    dailyData:getSingleInstructSucc(_instructId)
    getDailyLayer():refreshDailyLayer()
    popUpCloseAction( InstructSelectHeroOwner,"infoBg",_layer )
end

local function confirmClick()
    if _selected == -1 then
        popUpCloseAction( InstructSelectHeroOwner,"infoBg",_layer )
    else
        doActionFun("INSTRUCT_HERO", {_instructId, _heroes[_selected + 1].id, 0}, instructSingleHeroCallback)
    end
end
InstructSelectHeroOwner["confirmClick"] = confirmClick

local function addTableView()
    if not _heroes or table.getTableCount(_heroes) <= 0 then
        return
    end
    -- @param fn string Callback type
    -- @param table LuaTableView
    -- @param a1 & a2 mixed Difference means for every "fn"
    local h = LuaEventHandler:create(function(fn, t, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(585, 170)
        elseif fn == "cellAtIndex" then
            -- Return CCTableViewCell, a1 is cell index (zero based), a2 is dequeued cell (maybe nil)
            -- Do something to create cell and change the content
            InstructSelectHeroCellOwner = InstructSelectHeroCellOwner or {}
            ccb["InstructSelectHeroCellOwner"] = InstructSelectHeroCellOwner

            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            local proxy = CCBProxy:create()
            local _hbCell = tolua.cast(CCBReaderLoad("ccbResources/InstructSelectHeroCell.ccbi",proxy,true,"InstructSelectHeroCellOwner"),"CCSprite")
            _hbCell:setAnchorPoint(ccp(0.5, 0.5))
            local contentLayer = InstructSelectHeroOwner["contentLayer"]
            _hbCell:setPosition(contentLayer:getContentSize().width / 2, 170 / 2)
            a2:addChild(_hbCell, 0, 1)

            local hero = _heroes[a1 + 1]

            local frame = tolua.cast(InstructSelectHeroCellOwner["frame"], "CCSprite")
            frame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", hero.rank)))
            local head = tolua.cast(InstructSelectHeroCellOwner["head"], "CCSprite")
            local f = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(herodata:getHeroHeadByHeroId(hero.heroId))
            if f then
                head:setVisible(true)
                head:setDisplayFrame(f)
            end
            local name = tolua.cast(InstructSelectHeroCellOwner["name"], "CCLabelTTF")
            name:setString(hero.name)
            local rank = tolua.cast(InstructSelectHeroCellOwner["rank"], "CCSprite")
            rank:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("rank_%d_icon.png", hero.rank)))
            local exp = tolua.cast(InstructSelectHeroCellOwner["exp"], "CCLabelTTF")
            exp:setString(string.format("%d/%d", hero.exp_now, hero.expMax))
            local level = tolua.cast(InstructSelectHeroCellOwner["level"], "CCLabelTTF")
            level:setString(string.format("LV：%d", hero.level))
            
            local stamp = tolua.cast(InstructSelectHeroCellOwner["stamp"], "CCSprite")
            local bg = tolua.cast(InstructSelectHeroCellOwner["bg"], "CCSprite")
            if a1 == _selected then
                stamp:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("stamp3.png"))
                bg:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("popUpFrame_11.png"))
            end

            r = a2
        elseif fn == "numberOfCells" then
            r = table.getTableCount(_heroes)
        -- Cell events:
        elseif fn == "cellTouched" then         -- A cell was touched, a1 is cell that be touched. This is not necessary.
            local hero = _heroes[a1:getIdx() + 1]
            if hero.level == userdata.level * 3 and hero.exp_now >= hero.expMax - 1 then
                ShowText(HLNSLocalizedString("hero.level.max"))
                return r
            end
            _selected = _selected == a1:getIdx() and -1 or a1:getIdx()
            local offsetY = tableView:getContentOffset().y
            tableView:reloadData()
            tableView:setContentOffset(ccp(0, offsetY))
        elseif fn == "cellTouchBegan" then      -- A cell is touching, a1 is cell, a2 is CCTouch
        elseif fn == "cellTouchEnded" then      -- A cell was touched, a1 is cell, a2 is CCTouch
        elseif fn == "cellHighlight" then       -- A cell is highlighting, coco2d-x 2.1.3 or above
        elseif fn == "cellUnhighlight" then     -- A cell had been unhighlighted, coco2d-x 2.1.3 or above
        elseif fn == "cellWillRecycle" then     -- A cell will be recycled, coco2d-x 2.1.3 or above
        end
        return r
    end)
    local contentLayer = InstructSelectHeroOwner["contentLayer"]
    tableView = LuaTableView:createWithHandler(h, contentLayer:getContentSize())
    tableView:setBounceable(true)
    tableView:setAnchorPoint(ccp(0, 0))
    tableView:setPosition(ccp(0, 0))
    tableView:setVerticalFillOrder(0)
    contentLayer:addChild(tableView, 10, 10)
end

local function setMenuPriority()
    local menu = tolua.cast(InstructSelectHeroOwner["menu"], "CCMenu")
    menu:setHandlerPriority(_priority - 1)
    if tableView then
        tableView:setTouchPriority(_priority - 1)
    end
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/InstructSelectHeroView.ccbi", proxy, true,"InstructSelectHeroOwner")
    _layer = tolua.cast(node,"CCLayer")
    local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
    cache:addSpriteFramesWithFile("ccbResources/publicRes_3.plist")
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(InstructSelectHeroOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction( InstructSelectHeroOwner,"infoBg",_layer )
        return true
    end
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

local function _refreshData()
    _heroes = herodata:getHeroOnFormCanInstruct()
    _selected = -1
    addTableView()
end


-- 该方法名字每个文件不要重复
function getInstructSelectHeroLayer()
	return _layer
end

function createInstructSelectHeroLayer(instructId, priority)
    _init()
    _instructId = instructId
    _priority = priority ~= nil and priority or -134

    local function _onEnter()
        print("onEnter")
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
        _refreshData()

        popUpUiAction( InstructSelectHeroOwner,"infoBg" )
    end

    local function _onExit()
        print("onExit")
        _layer = nil
        tableView = nil
        _priority = -134
        _heroes = nil
        _selected = nil
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