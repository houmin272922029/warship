local _layer
local _priority
local _tableView
local _index
local _data

WWJobSelectOwner = WWJobSelectOwner or {}
ccb["WWJobSelectOwner"] = WWJobSelectOwner

-- 关闭
local function closeItemClick()
    popUpCloseAction(WWJobSelectOwner, "infoBg", _layer)
end
WWJobSelectOwner["closeItemClick"] = closeItemClick


local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(WWJobSelectOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction(WWJobSelectOwner, "infoBg", _layer)
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
    local menu = tolua.cast(WWJobSelectOwner["menu"], "CCMenu")
    menu:setHandlerPriority(_priority - 1)
    _tableView:setTouchPriority(_priority - 1)
end


local function addTableView()

    WWJobSelectCellOwner = WWJobSelectCellOwner or {}
    ccb["WWJobSelectCellOwner"] = WWJobSelectCellOwner

    local function selectItemClick(tag)
        local dic = _data[tag]
        local function callback(url, rtnData)
            worldwardata:fromDic(rtnData.info)
            postNotification(NOTI_WW_REFRESH, nil)
        end
        doActionFun("WW_CHANGE_JOB", {_index, dic.playerId}, callback)
        closeItemClick()
    end
    WWJobSelectCellOwner["selectItemClick"] = selectItemClick
    
    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(585, 155)
        elseif fn == "cellAtIndex" then
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            --单条数据
            local  proxy = CCBProxy:create()
            local  _hbCell  = tolua.cast(CCBReaderLoad("ccbResources/WWJobSelectCell.ccbi",proxy,true,"WWJobSelectCellOwner"),"CCLayer")

            local function setCellMenuPriority(sender)
                if sender then
                    local menu = tolua.cast(sender, "CCMenu")
                    menu:setHandlerPriority(_priority - 1)
                end
            end

            local menu = WWJobSelectCellOwner["menu"]
            local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCCallFuncN:create(setCellMenuPriority))
            menu:runAction(seq)

            local changeItem = tolua.cast(WWJobSelectCellOwner["changeItem"], "CCMenuItem")
            changeItem:setTag(a1 + 1)

            local dic = _data[a1 + 1]
            local name = tolua.cast(WWJobSelectCellOwner["name"], "CCLabelTTF")
            name:setString(dic.name)
            local level = tolua.cast(WWJobSelectCellOwner["level"], "CCLabelTTF")
            level:setString(dic.level)
            local score = tolua.cast(WWJobSelectCellOwner["score"], "CCLabelTTF")
            score:setString(dic.score)
            local vip = tolua.cast(WWJobSelectCellOwner["vip"], "CCSprite")
            vip:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("VIP_%d.png", dic.vip)))

            for i=0,2 do
                local heroId = dic.form[tostring(i)]
                if heroId then
                    local conf = herodata:getHeroConfig(heroId)
                    local frame = tolua.cast(WWJobSelectCellOwner["frame"..i + 1], "CCSprite")
                    frame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", conf.rank)))
                    frame:setVisible(true)
                    local head = tolua.cast(WWJobSelectCellOwner["head"..i + 1], "CCSprite")
                    local f = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(herodata:getHeroHeadByHeroId(heroId))
                    if f then
                        head:setDisplayFrame(f)
                        head:setVisible(true)
                    end
                end
            end
            

            a2:addChild(_hbCell, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            r = a2
        elseif fn == "numberOfCells" then
            r = #_data
        elseif fn == "cellTouched" then         -- A cell was touched, a1 is cell that be touched. This is not necessary.
        elseif fn == "cellTouchBegan" then      -- A cell is touching, a1 is cell, a2 is CCTouch
        elseif fn == "cellTouchEnded" then      -- A cell was touched, a1 is cell, a2 is CCTouch
        elseif fn == "cellHighlight" then       -- A cell is highlighting, coco2d-x 2.1.3 or above
        elseif fn == "cellUnhighlight" then     -- A cell had been unhighlighted, coco2d-x 2.1.3 or above
        elseif fn == "cellWillRecycle" then     -- A cell will be recycled, coco2d-x 2.1.3 or above
        end
        return r
    end)
    local content = tolua.cast(WWJobSelectOwner["content"], "CCLayer")
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
    local  node  = CCBReaderLoad("ccbResources/WWJobChange.ccbi", proxy, true, "WWJobSelectOwner")
    _layer = tolua.cast(node, "CCLayer")

    addTableView()
end

function createWWJobSelectLayer(data, index, priority)
    _data = data
    _index = index
    _priority = (priority ~= nil) and priority or -132

    _init()

    local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
    _layer:runAction(seq)

    local function _onEnter()
        popUpUiAction(WWJobSelectOwner, "infoBg")
    end

    local function _onExit()
        _priority = -132
        _layer = nil
        _tableView = nil
        _data = nil
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