local _layer
local _tableView = nil
local _serviceInfo

SystemSettingLayerOwner = SystemSettingLayerOwner or {}
ccb["SystemSettingLayerOwner"] = SystemSettingLayerOwner

local function onExitTaped(  )
    local _mainLayer = getMainLayer()
    if _mainLayer then
        _mainLayer:gotoSystemSettingLayer()
    end
end

SystemSettingLayerOwner["onExitTaped"] = onExitTaped

local function _addTableView()
    local _topLayer = SystemSettingLayerOwner["titleLayer"]

    CusserviceCellOwner = CusserviceCellOwner or {}
    ccb["CusserviceCellOwner"] = CusserviceCellOwner

    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
                r = CCSizeMake(620 * retina, 180 * retina)
        elseif fn == "cellAtIndex" then
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            local  proxy = CCBProxy:create()
            local _hbCell = tolua.cast(CCBReaderLoad("ccbResources/CusserviceCell.ccbi",proxy,true,"CusserviceCellOwner"),"CCLayer")
            local dic = _serviceInfo[tostring(a1+1)]
            -- 标题
            local title = tolua.cast(CusserviceCellOwner["title"],"CCLabelTTF")
            local str = dic["id"] 
            title:setString(str)
            -- 客服信息内容
            local context = tolua.cast(CusserviceCellOwner["context"],"CCLabelTTF")
            local label = ""
            if dic.content1 then
                label = dic.content1
            end
            if dic.content2 then
                label = string.format("%s\r\n%s", label, dic.content2)
            end
            context:setString(label)

            _hbCell:setScale(retina)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            a2:addChild(_hbCell, 0, 1)
            r = a2
        elseif fn == "numberOfCells" then
            -- Return number of cells
            r = getMyTableCount(_serviceInfo)
            print("r = ",r)
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
    local  node  = CCBReaderLoad("ccbResources/Cusservice.ccbi",proxy, true,"SystemSettingLayerOwner")
    _layer = tolua.cast(node,"CCLayer")
    _serviceInfo = ConfigureStorage.customerservice
end


function getCusserviceLayer()
    return _layer
end

function createCusserviceLayer()
    _init()

    local function _onEnter()
        _addTableView()
    end

    local function _onExit()
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