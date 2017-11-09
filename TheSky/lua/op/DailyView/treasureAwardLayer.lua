local _layer
local _priority = -134
local t
local _dic

-- 名字不要重复
TreasureAwardOwner = TreasureAwardOwner or {}
ccb["TreasureAwardOwner"] = TreasureAwardOwner

TreasureAwardCellOwner = TreasureAwardCellOwner or {}
ccb["TreasureAwardCellOwner"] = TreasureAwardCellOwner


local function closeItemClick()
    _layer:removeFromParentAndCleanup(true)
end
TreasureAwardOwner["closeItemClick"] = closeItemClick


local function addTableView()
    local keys = dailyData:getTreasureAward()
    local awards = dailyData:getTreasureAwardByDic(_dic)
    -- @param fn string Callback type
    -- @param table LuaTableView
    -- @param a1 & a2 mixed Difference means for every "fn"
    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(500, 110)
        elseif fn == "cellAtIndex" then
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            local proxy = CCBProxy:create()
            local _hbCell = tolua.cast(CCBReaderLoad("ccbResources/TreasureAwardCell.ccbi",proxy,true,"TreasureAwardCellOwner"),"CCLayer")
            local itemId = keys[a1 + 1]
            local res = wareHouseData:getItemResource(itemId)
            local frame = tolua.cast(TreasureAwardCellOwner["frame"], "CCSprite")
            frame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", res.rank)))
            local icon = tolua.cast(TreasureAwardCellOwner["icon"], "CCSprite")
            if res.icon then
                local texture = CCTextureCache:sharedTextureCache():addImage(res.icon)
                if texture then
                    icon:setVisible(true)
                    icon:setTexture(texture)
                end
            end
            local name = tolua.cast(TreasureAwardCellOwner["name"], "CCLabelTTF")
            name:setString(res.name)
            local amount = tolua.cast(TreasureAwardCellOwner["amount"], "CCLabelTTF")
            local count = 0
            if awards[itemId] then
                count = awards[itemId]
            end
            amount:setString(HLNSLocalizedString("数量：")..count)
            a2:addChild(_hbCell, 0, 1)
            r = a2
        elseif fn == "numberOfCells" then
            -- Return number of cells
            r = #keys
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
    local content = tolua.cast(TreasureAwardOwner["contentLayer"], "CCLayer")
    local size = content:getContentSize()
    t = LuaTableView:createWithHandler(h, size)
    t:setBounceable(true)
    t:setAnchorPoint(ccp(0,0))
    t:setPosition(ccp(0, 0))
    t:setVerticalFillOrder(0)
    content:addChild(t)
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/TreasureAwardView.ccbi", proxy, true,"TreasureAwardOwner")
    _layer = tolua.cast(node,"CCLayer")
    addTableView()
    t:setTouchPriority(_priority - 2)
    t:reloadData()
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(TreasureAwardOwner["infoBg"], "CCSprite")
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
    local menu = tolua.cast(TreasureAwardOwner["menu"], "CCMenu")
    menu:setHandlerPriority(_priority - 1)
end

-- 该方法名字每个文件不要重复
function getTreasureAwardLayer()
	return _layer
end

function createTreasureAwardLayer(dic, priority)
    _dic = dic
    _priority = (priority ~= nil) and priority or -134
    _init()

    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
    end

    local function _onExit()
        _layer = nil
        _priority = -134
        t = nil
        _dic = nil
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