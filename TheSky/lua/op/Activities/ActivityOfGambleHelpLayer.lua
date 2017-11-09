local _layer = nil
local _priority = -134
local pictureArray = {}
local contentLayer
ActivityOfGambleHelpOwner = ActivityOfGambleHelpOwner or {}
ccb["ActivityOfGambleHelpOwner"] = ActivityOfGambleHelpOwner

local function closeItemClick()
    popUpCloseAction(ActivityOfGambleHelpOwner, "infoBg", _layer)
end
ActivityOfGambleHelpOwner["closeItemClick"] = closeItemClick

local function _addTableView()
    -- 得到数据
    
    for k,v in pairs(ConfigureStorage.Picture_Contrast) do
        pictureArray[k] = v.ID
    end
    ActivityOfGambleHelpCellOwner = ActivityOfGambleHelpCellOwner or {}
    ccb["ActivityOfGambleHelpCellOwner"] = ActivityOfGambleHelpCellOwner
    local width  = contentLayer:getContentSize().width 
    local height = contentLayer:getContentSize().height 
    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(  width , height )
        elseif fn == "cellAtIndex" then
            
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            --单条数据
            
            local itemContent = pictureArray[tostring(3)]
            
            local  proxy = CCBProxy:create()
            local  _hbCell 
            
            _hbCell = tolua.cast(CCBReaderLoad("ccbResources/ActivityOfGambleHelpCell.ccbi",proxy,true,"ActivityOfGambleHelpCellOwner"),"CCLayer")
            
            local function setRewardTexture(texture,pos)
                local item11 = tolua.cast(ActivityOfGambleHelpCellOwner[string.format("item%d1",pos)],"CCSprite")
                local item12 = tolua.cast(ActivityOfGambleHelpCellOwner[string.format("item%d2",pos)],"CCSprite")
                local item13 = tolua.cast(ActivityOfGambleHelpCellOwner[string.format("item%d3",pos)],"CCSprite")
                item11:setTexture(texture)
                item12:setTexture(texture)
                item13:setTexture(texture)
                local times1 = tolua.cast(ActivityOfGambleHelpCellOwner[string.format("times%d",pos)],"CCLabelTTF")
                local dic1 = ConfigureStorage.Slot[tostring(pos + 2)].Multiple
                times1:setString(dic1)
            end
            local texture1 = CCTextureCache:sharedTextureCache():addImage(string.format("icons/%s.png",pictureArray[tostring(1)]))
            setRewardTexture(texture1,1)

            local texture2 = CCTextureCache:sharedTextureCache():addImage(string.format("icons/%s.png",pictureArray[tostring(2)]))
            setRewardTexture(texture2,2)

            local texture3 = CCTextureCache:sharedTextureCache():addImage(string.format("icons/%s.png",pictureArray[tostring(3)]))
            setRewardTexture(texture3,3)

            local texture4 = CCTextureCache:sharedTextureCache():addImage(string.format("icons/%s.png",pictureArray[tostring(4)]))
            setRewardTexture(texture4,4)

            --_hbCell:setScale(retina)
            a2:addChild(_hbCell, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            r = a2
        elseif fn == "numberOfCells" then
            -- Return number of cells
            -- r = 5
            r = 1
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
    local size = CCSizeMake( width, height) 
    _tableView = LuaTableView:createWithHandler(h, size)
    _tableView:setBounceable(true)
    _tableView:setAnchorPoint(ccp(0,0))
    _tableView:setPosition(0,0)
    _tableView:setVerticalFillOrder(0)
    contentLayer:addChild(_tableView,1000)
    _tableView:reloadData()
end


local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(ActivityOfGambleHelpOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        _layer:removeFromParentAndCleanup(true)
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
    local menu = tolua.cast(ActivityOfGambleHelpOwner["closeMenu"], "CCMenu")
    menu:setHandlerPriority(_priority - 100)
    _tableView:setTouchPriority(_priority - 2)
end

local function _init()
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/ActivityOfGambleHelp.ccbi",proxy,true,"ActivityOfGambleHelpOwner")
    _layer = tolua.cast(node,"CCLayer")
    contentLayer = tolua.cast(ActivityOfGambleHelpOwner["contentLayer"],"CCLayer")
    
end

function getActivityOfGambleHelp()
    return _layer
end

function createActivityOfGambleHelp(priority)  
    
    _init()
    _priority = (priority ~= nil) and priority or -134

    local function OnEnter()
        _addTableView()
        pictureArray = {}
         local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
    end

    local function OnExit()
        _layer = nil
        _priority = -134
        pictureArray = {}
        contentLayer = nil
    end

    --onEnter onExit
    local function layerEventHandler(eventType)
        if eventType == "enter" then
            if OnEnter then OnEnter() end
        elseif eventType == "exit" then
            if OnExit then OnExit() end
        end
    end

    _layer:registerScriptTouchHandler(onTouch ,false ,_priority ,true )
    _layer:setTouchEnabled(true)
    _layer:registerScriptHandler(layerEventHandler)
    
    return _layer
end