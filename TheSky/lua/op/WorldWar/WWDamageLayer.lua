local _layer
local _priority
local _damageFun
local _data
local _tableView

WWDamagePopupOwner = WWDamagePopupOwner or {}
ccb["WWDamagePopupOwner"] = WWDamagePopupOwner


-- 关闭
local function closeItemClick()
    popUpCloseAction(WWDamagePopupOwner, "infoBg", _layer)
end
WWDamagePopupOwner["closeItemClick"] = closeItemClick


local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(WWDamagePopupOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction(WWDamagePopupOwner, "infoBg", _layer)
        return true
    end
    return true
end

local function onTouch(eventType, x, y)
    if eventType == "began" then   
        return onTouchBegan(x, y)
    end
end

-- 修改 按钮优先级
local function setMenuPriority()
    local menu = tolua.cast(WWDamagePopupOwner["menu"], "CCMenu")
    menu:setHandlerPriority(_priority - 1)
    _tableView:setTouchPriority(_priority - 1)
end

local function addTableView()
    _data = worldwardata:getDamageItem()

    WWDamagePopupCellOwner = WWDamagePopupCellOwner or {}
    ccb["WWDamagePopupCellOwner"] = WWDamagePopupCellOwner

    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(585, 150)
        elseif fn == "cellAtIndex" then
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            --单条数据
            local  proxy = CCBProxy:create()
            local  _hbCell  = tolua.cast(CCBReaderLoad("ccbResources/WWDamagePopupCell.ccbi",proxy,true,"WWDamagePopupCellOwner"),"CCLayer")

            local dic = _data[a1 + 1]

            local frame = tolua.cast(WWDamagePopupCellOwner["frame"], "CCSprite")
            frame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", dic.rank)))

            local resDic = wareHouseData:getItemResource(dic.itemId)

            local icon = tolua.cast(WWDamagePopupCellOwner["icon"], "CCSprite")
            local texture = CCTextureCache:sharedTextureCache():addImage(resDic.icon)
            if texture then
                icon:setVisible(true)
                icon:setTexture(texture)
            end
            local name = tolua.cast(WWDamagePopupCellOwner["name"], "CCLabelTTF")
            name:setString(dic.name)
            local desp = tolua.cast(WWDamagePopupCellOwner["desp"], "CCLabelTTF")
            desp:setString(dic.desp)


            a2:addChild(_hbCell, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            r = a2
        elseif fn == "numberOfCells" then
            r = #_data
        elseif fn == "cellTouched" then         -- A cell was touched, a1 is cell that be touched. This is not necessary.
            local dic = _data[a1:getIdx() + 1]
            _damageFun(dic.itemId)
            closeItemClick()
        elseif fn == "cellTouchBegan" then      -- A cell is touching, a1 is cell, a2 is CCTouch
        elseif fn == "cellTouchEnded" then      -- A cell was touched, a1 is cell, a2 is CCTouch
        elseif fn == "cellHighlight" then       -- A cell is highlighting, coco2d-x 2.1.3 or above
        elseif fn == "cellUnhighlight" then     -- A cell had been unhighlighted, coco2d-x 2.1.3 or above
        elseif fn == "cellWillRecycle" then     -- A cell will be recycled, coco2d-x 2.1.3 or above
        end
        return r
    end)
    local content = tolua.cast(WWDamagePopupOwner["content"], "CCLayer")
    local size = content:getContentSize()
    _tableView = LuaTableView:createWithHandler(h, size)
    _tableView:setBounceable(true)
    _tableView:setAnchorPoint(ccp(0,0))
    _tableView:setPosition(0,0)
    _tableView:setVerticalFillOrder(0)
    content:addChild(_tableView,1000)
end

local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/WWDamagePopup.ccbi", proxy, true, "WWDamagePopupOwner")
    _layer = tolua.cast(node, "CCLayer")

    addTableView()
end

function createWWDamageLayer(damageFun, priority)
    _damageFun = damageFun
    _priority = (priority ~= nil) and priority or -132

    _init()

    local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
    _layer:runAction(seq)

    local function _onEnter()
        popUpUiAction(WWDamagePopupOwner, "infoBg")
    end

    local function _onExit()
        _priority = -132
        _damageFun = nil
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

    _layer:registerScriptTouchHandler(onTouch, false, _priority, true)
    _layer:setTouchEnabled(true)
    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end