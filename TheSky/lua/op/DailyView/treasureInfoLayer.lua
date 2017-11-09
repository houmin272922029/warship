local _layer
local _priority = -134
local t

-- 名字不要重复
TreasureInfoOwner = TreasureInfoOwner or {}
ccb["TreasureInfoOwner"] = TreasureInfoOwner


local function closeItemClick()
    _layer:removeFromParentAndCleanup(true)
end
TreasureInfoOwner["closeItemClick"] = closeItemClick


local function addTableView()
    local awards = dailyData:getTreasureAward()
    -- @param fn string Callback type
    -- @param table LuaTableView
    -- @param a1 & a2 mixed Difference means for every "fn"
    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(105, 160)
        elseif fn == "cellAtIndex" then
            -- Return CCTableViewCell, a1 is cell index (zero based), a2 is dequeued cell (maybe nil)
            -- Do something to create cell and change the content
            
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            local layer = CCLayer:create()
            layer:setPosition(ccp(0, 0))
            layer:setAnchorPoint(ccp(0, 0))
            layer:setContentSize(CCSizeMake(105, 160))
            local itemId = awards[a1 + 1]
            local res = wareHouseData:getItemResource(itemId)
            local sp = CCSprite:createWithSpriteFrameName(string.format("frame_%d.png", res.rank))
            sp:setPosition(ccp(105 / 2, 160 * 0.65))
            layer:addChild(sp, 1)
            local icon = CCSprite:create(res.icon)
            if icon then
                sp:addChild(icon)
                icon:setPosition(sp:getContentSize().width / 2, sp:getContentSize().height / 2)
                icon:setScale(0.36)
            end
            local label = CCLabelTTF:create(res.name, "ccbResources/FZCuYuan-M03S.ttf", 18)

            if isPlatform(IOS_VIETNAM_VI) 
            or isPlatform(IOS_VIETNAM_EN) 
            or isPlatform(IOS_VIETNAM_ENSAGA) 
            or isPlatform(IOS_MOBNAPPLE_EN)
            or isPlatform(IOS_MOB_THAI)
            or isPlatform(ANDROID_VIETNAM_MOB_THAI)
            or isPlatform(ANDROID_VIETNAM_VI)
            or isPlatform(ANDROID_VIETNAM_EN)
            or isPlatform(ANDROID_VIETNAM_EN_ALL)
            or isPlatform(IOS_MOBGAME_SPAIN)
            or isPlatform(ANDROID_MOBGAME_SPAIN)
            or isPlatform(IOS_GAMEVIEW_EN)
            or isPlatform(IOS_GVEN_BREAK)
            or isPlatform(ANDROID_GV_MFACE_EN)
            or isPlatform(ANDROID_GV_MFACE_EN_OUMEI)
            or isPlatform(ANDROID_GV_MFACE_EN_OUMEINEW)
            or isPlatform(IOS_INFIPLAY_RUS)
            or isPlatform(ANDROID_INFIPLAY_RUS)
            or isPlatform(WP_VIETNAM_EN) then
                
                label = CCLabelTTF:create(res.name,"ccbResources/FZCuYuan-M03S.ttf",18,CCSizeMake(sp:getContentSize().width,0),kCCTextAlignmentCenter)
            end
            label:setPosition(105 / 2, 160 * 0.2)
            layer:addChild(label, 1)
            a2:addChild(layer)
            r = a2
        elseif fn == "numberOfCells" then
            -- Return number of cells
            r = #awards
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
    local content = tolua.cast(TreasureInfoOwner["contentLayer"], "CCLayer")
    local size = content:getContentSize()
    t = LuaTableView:createWithHandler(h, size)
    t:setBounceable(true)
    t:setAnchorPoint(ccp(0,0))
    t:setPosition(ccp(0, 0))
    t:setVerticalFillOrder(0)
    t:setDirection(0)
    content:addChild(t)
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/TreasureInfoView.ccbi", proxy, true,"TreasureInfoOwner")
    _layer = tolua.cast(node,"CCLayer")
    addTableView()
    t:setTouchPriority(_priority - 2)
    t:reloadData()
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(TreasureInfoOwner["infoBg"], "CCSprite")
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
    local menu = tolua.cast(TreasureInfoOwner["menu"], "CCMenu")
    menu:setHandlerPriority(_priority - 1)
end

-- 该方法名字每个文件不要重复
function getTreasureInfoLayer()
	return _layer
end

function createTreasureInfoLayer(priority)
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