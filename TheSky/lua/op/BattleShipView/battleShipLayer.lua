local _layer
local _tableView = nil
local cellArray = {}

local ATTR_KEY = {
    "hp", "mp", "def", "atk", "dod", "hit", "resi", "cri", "parry", "cnt", 
}

BattleShipLayerOwner = BattleShipLayerOwner or {}
ccb["BattleShipLayerOwner"] = BattleShipLayerOwner

TitleTipsLayerOwner = TitleTipsLayerOwner or {}
ccb["TitleTipsLayerOwner"] = TitleTipsLayerOwner

BattleShipViewCellOwner = BattleShipViewCellOwner or {}
ccb["BattleShipViewCellOwner"] = BattleShipViewCellOwner

local function shipUpdateTap(tag, sender)
    if getMainLayer() ~= nil then
        local myType = ATTR_KEY[tag]
        Global:instance():TDGAonEventAndEventData("warship" .. tag)
        getMainLayer():gotoBattleShipUpdateLayer(myType)
    end
end
BattleShipViewCellOwner["shipUpdateTap"] = shipUpdateTap

local function _addTableView()
    local _topLayer = BattleShipLayerOwner["BSTopLayer"]

    -- @param fn string Callback type
    -- @param table LuaTableView
    -- @param a1 & a2 mixed Difference means for every "fn"
    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            if a1 == 0 then
                r = CCSizeMake(winSize.width, 45 * retina)
            else
                r = CCSizeMake(winSize.width, 180 * retina)
            end
        elseif fn == "cellAtIndex" then
            -- Return CCTableViewCell, a1 is cell index (zero based), a2 is dequeued cell (maybe nil)
            -- Do something to create cell  and change the content
            
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
            local  proxy = CCBProxy:create()
            local  _hbCell
            if a1 == 0 then
                _hbCell = tolua.cast(CCBReaderLoad("ccbResources/TitleTipsLayerView.ccbi", proxy, true, 
                    "TitleTipsLayerOwner"), "CCLayer")
            else
                _hbCell = tolua.cast(CCBReaderLoad("ccbResources/BattleShipViewCell.ccbi", proxy, true, 
                    "BattleShipViewCellOwner"), "CCLayer")
                local shipUpdateBtn = tolua.cast(BattleShipViewCellOwner["shipUpdateBtn"], "CCMenuItemImage")
                shipUpdateBtn:setTag(a1)
                local contentData = battleShipData:getBattleShipInfoByType(ATTR_KEY[a1])

                local nameLabel = tolua.cast(BattleShipViewCellOwner["nameLabel"], "CCLabelTTF")
                nameLabel:setString(battleShipData:getShipNameByType(ATTR_KEY[a1]))
                local avatarIcon = tolua.cast(BattleShipViewCellOwner["avatarIcon"], "CCSprite")
                avatarIcon:setDisplayFrame(cache:spriteFrameByName(string.format("battleship_%s.png", ATTR_KEY[a1])))
                local attrSprite = tolua.cast(BattleShipViewCellOwner["attrSprite"], "CCSprite")
                attrSprite:setDisplayFrame(cache:spriteFrameByName(equipdata:getDisplayFrameByType(ATTR_KEY[a1])))

                local attr = contentData.attr
                local attrLabel = tolua.cast(BattleShipViewCellOwner["attrLabel"], "CCLabelTTF")
                if tostring(math.floor(attr)) ~= tostring(attr) then
                    attrLabel:setString(string.format("+%s%%", tostring(attr * 100)))
                else
                    attrLabel:setString(string.format("+%s", attr))
                end

                local levelLabel = tolua.cast(BattleShipViewCellOwner["levelLabel"], "CCLabelTTF")
                levelLabel:setString(contentData.level)

                local valueLabel = tolua.cast(BattleShipViewCellOwner["valueLabel"], "CCLabelTTF")
                valueLabel:setString(string.format("%s/%s", contentData["expNow"], contentData["expNeed"]))
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
            r = tonumber(battleShipData:canOpenNum()) + 1
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
        local size = CCSizeMake(winSize.width, (winSize.height - _topLayer:getContentSize().height 
            - _mainLayer:getBottomContentSize().height) * 99 / 100)      -- 这里是为了在tableview上面显示一个小空出来
        print(size.width .. " " .. size.height)
        _tableView = LuaTableView:createWithHandler(h, size)
        _tableView:setBounceable(true)
        _tableView:setAnchorPoint(ccp(0, 0))
        _tableView:setPosition(ccp(0, _mainLayer:getBottomContentSize().height))
        _tableView:setVerticalFillOrder(0)
        _layer:addChild(_tableView) 
    end
end

local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/BattleShipView.ccbi",proxy, true,"BattleShipLayerOwner")
    _layer = tolua.cast(node,"CCLayer")
end


function getBattleShipLayer()
	return _layer
end

function createBattleShipLayer()
    _init()


    local function _onEnter()
        print("battleShipLayer onEnter")
        -- _data = herodata:getAllHeroes()
        cellArray = {}
        _addTableView()
        _tableView:reloadData()
        generateCellAction(cellArray, tonumber(battleShipData:canOpenNum()) + 1)
        cellArray = {}
    end

    local function _onExit()
        print("battleShipLayer onExit")
        _layer = nil
        _tableView = nil
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