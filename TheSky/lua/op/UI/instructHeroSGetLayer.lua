local _layer
local _priority = -134
local _tableView
local _instructArray

-- 名字不要重复
InstructHeroSGetOwner = InstructHeroSGetOwner or {}
ccb["InstructHeroSGetOwner"] = InstructHeroSGetOwner



local function closeItemClick()
    popUpCloseAction( InstructHeroSGetOwner,"infoBg",_layer )
end
InstructHeroSGetOwner["closeItemClick"] = closeItemClick

local function gotoDaily()
    if not getMainLayer() then
        CCDirector:sharedDirector():replaceScene(mainSceneFun())
    end
    getMainLayer():gotoDaily()
    local page = dailyData:getDailyPage(Daily_InstructHeroS)
    getDailyLayer():gotoPage(page)
    closeItemClick()
    if getBossResultLayer() then
        getBossResultLayer():close()
    end
    if getBossChallengeLayer() then
        getBossChallengeLayer():close()
    end
end
InstructHeroSGetOwner["gotoDaily"] = gotoDaily

-- 刷新UI数据
local function _refreshData()
    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(winSize.width, 110)
        elseif fn == "cellAtIndex" then
            -- Return CCTableViewCell, a1 is cell index (zero based), a2 is dequeued cell (maybe nil)
            -- Do something to create cell  and change the content
            
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            --单条数据
            
            InstructHeroSGetCellOwner = InstructHeroSGetCellOwner or {}
            ccb["InstructHeroSGetCellOwner"] = InstructHeroSGetCellOwner

            local proxy = CCBProxy:create()
            local _hbCell = tolua.cast(CCBReaderLoad("ccbResources/InstructHeroSGetCell.ccbi",proxy,true,"InstructHeroSGetCellOwner"),"CCLayer")

            local heroId = _instructArray[a1 + 1].heroId
            local frame = tolua.cast(InstructHeroSGetCellOwner["frame"], "CCSprite")
            local conf = herodata:getHeroConfig(heroId)
            frame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", conf.rank)))
            local head = tolua.cast(InstructHeroSGetCellOwner["head"], "CCSprite")
            local f = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(herodata:getHeroHeadByHeroId(heroId))
            if f then
                head:setVisible(true)
                head:setDisplayFrame(f)
            end
            local sayLabel = tolua.cast(InstructHeroSGetCellOwner["sayLabel"], "CCLabelTTF")
            sayLabel:setString(ConfigureStorage.dianbo[heroId].desp1)

            a2:addChild(_hbCell, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            r = a2
        elseif fn == "numberOfCells" then
            -- Return number of cells
            -- r = 5
            r = #_instructArray
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
    local contentBg = InstructHeroSGetOwner["contentLayer"]
    local size = contentBg:getContentSize()
    _tableView = LuaTableView:createWithHandler(h, size)
    _tableView:setBounceable(true)
    _tableView:setAnchorPoint(ccp(0,0))
    _tableView:setPosition(0, 0)
    _tableView:setVerticalFillOrder(0)
    contentBg:addChild(_tableView,1000)
    _tableView:reloadData()
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/IntructHeroSGetView.ccbi", proxy, true,"InstructHeroSGetOwner")
    _layer = tolua.cast(node,"CCLayer")
    _refreshData()
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(InstructHeroSGetOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction( InstructHeroSGetOwner,"infoBg",_layer )
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
    local menu = tolua.cast(InstructHeroSGetOwner["menu"], "CCMenu")
    menu:setHandlerPriority(_priority - 1)
    _tableView:setTouchPriority(_priority - 2)
end

-- 该方法名字每个文件不要重复
function getInstructHeroSGetLayer()
	return _layer
end

function createInstructHeroSGetLayer(instructArray, priority)
    _instructArray = instructArray
    _priority = (priority ~= nil) and priority or -140
    _init()

    local function _onEnter()
        print("onEnter")
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)

        popUpUiAction( InstructHeroSGetOwner,"infoBg" )
    end

    local function _onExit()
        print("onExit")
        _layer = nil
        _tableView = nil
        _priority = -140
        _instructArray = nil
    end

    --onEnter onExit
    local function _layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        end
    end


    _layer:registerScriptTouchHandler(onTouch ,false ,_priority ,true )
    _layer:setTouchEnabled(true)
    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end