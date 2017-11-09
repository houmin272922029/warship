--林绍峰  

local _layer
local _priority
local _contentLayer 

local _herosData
local _selected = -1
local _tableView

local  _cSdrink_buycap 
local _data = nil  


DailyDrinkCapExchangeViewOwner = DailyDrinkCapExchangeViewOwner or {}
ccb["DailyDrinkCapExchangeViewOwner"] = DailyDrinkCapExchangeViewOwner

DailyDrinkCapExchangeCellOwner = DailyDrinkCapExchangeCellOwner or {}
ccb["DailyDrinkCapExchangeCellOwner"] = DailyDrinkCapExchangeCellOwner

local function closeItemClick()
    popUpCloseAction(DailyDrinkCapExchangeViewOwner, "infoBg", _layer )
end
DailyDrinkCapExchangeViewOwner["closeItemClick"] = closeItemClick

local function drinkAgainBtnClick()
    popUpCloseAction(DailyDrinkCapExchangeViewOwner, "infoBg", _layer )
end
DailyDrinkCapExchangeViewOwner["drinkAgainBtnClick"] = drinkAgainBtnClick


-- 刷新  UI
local function _refreshUI()

    local todaysCapNum = tolua.cast(DailyDrinkCapExchangeViewOwner["todaysCapNum"], "CCLabelTTF")
    todaysCapNum:setString(  tonumber(_data.capToday) )

    local totalCapNum = tolua.cast(DailyDrinkCapExchangeViewOwner["totalCapNum"], "CCLabelTTF")
    totalCapNum:setString(  tonumber(_data.capAll) )
end


local function exChangeBtnClick( tag)

    if _data.capAll < _cSdrink_buycap[tostring(tag)].capPay then
        ShowText(HLNSLocalizedString("daily.drinkW.Cap.lackOfCap" ))
        return
    end
    print("**lsf exChangeBtnClick",tag)
    local function Callback(url, rtnData)
        print("**lsf exChangeBtnClick ACTIVITYDRINK_BUYCAP Callback -- table",tag)
        PrintTable(rtnData)
        _data = dailyData:getDrinkWineData()
        _refreshUI()
        ShowText(HLNSLocalizedString("daily.drinkW.Cap.getRumble" ))
    end
    doActionFun("ACTIVITYDRINK_BUYCAP", {tag}, Callback)

end
DailyDrinkCapExchangeCellOwner["exChangeBtnClick"] = exChangeBtnClick  


local function _addTableView()

    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake( 620,165 )
        elseif fn == "cellAtIndex" then
            -- Return CCTableViewCell, a1 is cell index (zero based), a2 is dequeued cell (maybe nil)
            -- Do something to create cell  and change the content
            
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            local  proxy = CCBProxy:create()
            local  _hbCell = tolua.cast(CCBReaderLoad("ccbResources/DailyDrinkCapExchangeCell.ccbi",proxy,true, "DailyDrinkCapExchangeCellOwner"),"CCSprite")
             -- 设置menu 优先级
            local menu = tolua.cast(DailyDrinkCapExchangeCellOwner["menu"], "CCMenu")
            local function setCellMenuPriority(sender)
                if sender then               
                    local menu = tolua.cast(sender, "CCMenu")
                    menu:setHandlerPriority(_priority - 2)
                end
            end
            local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCCallFuncN:create(setCellMenuPriority))
            menu:runAction(seq)

            local exChangeBtn = tolua.cast(DailyDrinkCapExchangeCellOwner["exChangeBtn"],"CCMenuItemImage")
            exChangeBtn:setTag(a1 + 1)


            local conf = wareHouseData:getItemResource("item_006")
            local icon = tolua.cast(DailyDrinkCapExchangeCellOwner["icon"], "CCSprite")
            icon:setTexture(CCTextureCache:sharedTextureCache():addImage(conf.icon)) 

            local capNum = tolua.cast(DailyDrinkCapExchangeCellOwner["capNum"], "CCLabelTTF")
            capNum:setString( string.format("X%d", _cSdrink_buycap[tostring(a1+1)].capPay ))
            
            local countLabel = tolua.cast(DailyDrinkCapExchangeCellOwner["countLabel"], "CCLabelTTF")
            countLabel:setString( string.format("%d", _cSdrink_buycap[tostring(a1+1)].items.item_006 ))

            local need = tolua.cast(DailyDrinkCapExchangeCellOwner["need"], "CCLabelTTF")
            need:setString( HLNSLocalizedString("daily.drinkW.Cap.need" ))


            a2:addChild(_hbCell, 0, 100)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            r = a2
        elseif fn == "numberOfCells" then
            -- Return number of cells
            r = 4
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


    local size = _contentLayer:getContentSize()
    _tableView = LuaTableView:createWithHandler(h, size)
    _tableView:setBounceable(true)
    _tableView:setAnchorPoint(ccp(0,0))
    _tableView:setPosition(0,0)
    _tableView:setVerticalFillOrder(0)
    _contentLayer:addChild(_tableView,1000)

end



local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(DailyDrinkCapExchangeViewOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction(DailyDrinkCapExchangeViewOwner, "infoBg", _layer)
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

local function setMenuPriority()
    local menu = tolua.cast(DailyDrinkCapExchangeViewOwner["menu"], "CCMenu")
    menu:setTouchPriority(_priority - 2)
   _tableView:setTouchPriority(_priority - 2)
 
end

function getDailyDrinkCapExchangeLayer()
    return _layer
end



local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/DailyDrinkCapExchangeView.ccbi",proxy, true,"DailyDrinkCapExchangeViewOwner")
    _layer = tolua.cast(node,"CCLayer")
    _contentLayer = DailyDrinkCapExchangeViewOwner["contentLayer"]

    local exchangeThings = tolua.cast(DailyDrinkCapExchangeViewOwner["exchangeThings"], "CCLabelTTF")
    exchangeThings:setString( HLNSLocalizedString("daily.drinkW.Cap.exchangeThings" ))
    
    local todaysCap = tolua.cast(DailyDrinkCapExchangeViewOwner["todaysCap"], "CCLabelTTF")
    todaysCap:setString( HLNSLocalizedString("daily.drinkW.Cap.todaysCap" ))

    local totalCap = tolua.cast(DailyDrinkCapExchangeViewOwner["totalCap"], "CCLabelTTF")
    totalCap:setString( HLNSLocalizedString("daily.drinkW.Cap.totalCap" ))
    local drinkAgain = tolua.cast(DailyDrinkCapExchangeViewOwner["drinkAgain"], "CCLabelTTF")
    drinkAgain:setString( HLNSLocalizedString("daily.drinkW.Cap.drinkAgain" ))
        

    _cSdrink_buycap   = ConfigureStorage.Drink_buycap  --配置
    _data = dailyData:getDrinkWineData()
    _refreshUI() 
    _addTableView()
    _tableView:reloadData()

    
end


function createDailyDrinkCapExchangeLayer(priority) --priority -140
    _priority = (priority ~= nil) and priority or -140

    _init()
  
    local function _onEnter()
        print("DailyDrinkCapExchangeView onEnter")                   
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
        popUpUiAction(DailyDrinkCapExchangeViewOwner, "infoBg")
        
    end

    local function _onExit()
        print("DailyDrinkCapExchangeView onExit")
        _layer = nil
        _selected = -1
        _tableView = nil
       
    end

    function _layer:close()
        closeItemClick()
    end
    
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