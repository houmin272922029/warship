local _layer
local _tableView = nil
local arrayForAudit = {} -- vip*********

SystemSettingLayerOwner = SystemSettingLayerOwner or {}
ccb["SystemSettingLayerOwner"] = SystemSettingLayerOwner

local function onExitTaped(  )
    print("woyaofanhui")
    local _mainLayer = getMainLayer()
    if _mainLayer then
        _mainLayer:gotoSystemSettingLayer()
    end
end

SystemSettingLayerOwner["onExitTaped"] = onExitTaped

local function _addTableView()
    local _topLayer = SystemSettingLayerOwner["BSTopLayer"]

    HelpCellViewOwner = HelpCellViewOwner or {}
    ccb["HelpCellViewOwner"] = HelpCellViewOwner

    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
                r = CCSizeMake(600 * retina, 300 * retina)
        elseif fn == "cellAtIndex" then
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            local  proxy = CCBProxy:create()
            local _hbCell = tolua.cast(CCBReaderLoad("ccbResources/HelpCell.ccbi",proxy,true,"HelpCellViewOwner"),"CCLayer")
            

            local title = tolua.cast(HelpCellViewOwner["title"],"CCLabelTTF")
            print(a1)
            local str = arrayForAudit[a1+1].id -- vip*********
            print(str,a1)
            title:setString(str)
            local context = tolua.cast(HelpCellViewOwner["context"],"CCLabelTTF")
            str = arrayForAudit[a1+1].content -- vip*********
            context:setString(str)

            local icon = tolua.cast(HelpCellViewOwner["icon"],"CCSprite")
            local sprite = arrayForAudit[a1+1].icon -- vip*********
            print(sprite,a1)
            if sprite then
                icon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(sprite))
            else 
                icon:setVisible(false)
            end
            _hbCell:setScale(retina)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            a2:addChild(_hbCell, 0, 1)
            r = a2
        elseif fn == "numberOfCells" then
            -- Return number of cells
            r = #arrayForAudit 
        -- Cell events:
        elseif fn == "cellTouched" then         -- A cell was touched, a1 is cell that be touched. This is not necessary.
            print("cellTouched",a1:getIdx())
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
        print(size.width.." "..size.height)
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
    local  node  = CCBReaderLoad("ccbResources/HelpView.ccbi",proxy, true,"SystemSettingLayerOwner")
    _layer = tolua.cast(node,"CCLayer")
    -- vip*********
    local j = 1
    for i=1,#ConfigureStorage.document-1 do
        if userdata:getVipAuditState() and ConfigureStorage.document[j].id == "VIP" then
            j = j + 1
        end
        table.insert(arrayForAudit,ConfigureStorage.document[j])
        j = j + 1
    end
end


function getHelpLayer()
	return _layer
end

function createHelpLayer()
    _init()


    local function _onEnter()
        print("battleShipLayer onEnter")
        _addTableView()
        -- _tableView:reloadData()
    end

    local function _onExit()
        print("battleShipLayer onExit")
        _layer = nil
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