local _layer
local tableView
local _priority = -134
local _fortId

-- 名字不要重复
UnionArmySelectOwner = UnionArmySelectOwner or {}
ccb["UnionArmySelectOwner"] = UnionArmySelectOwner


local function closeItemClick()
    _layer:removeFromParentAndCleanup(true)
end
UnionArmySelectOwner["closeItemClick"] = closeItemClick

local function addTableView()

    local members = unionData:getMembers()

    if not members or table.getTableCount(members) <= 0 then
        return
    end
    -- @param fn string Callback type
    -- @param table LuaTableView
    -- @param a1 & a2 mixed Difference means for every "fn"
    local h = LuaEventHandler:create(function(fn, t, a1, a2)
        local r
        if fn == "cellSize" then
            local sp = CCSprite:createWithSpriteFrameName("frame_0.png")
            r = CCSizeMake(585, 152)
        elseif fn == "cellAtIndex" then
            -- Return CCTableViewCell, a1 is cell index (zero based), a2 is dequeued cell (maybe nil)
            -- Do something to create cell and change the content
            UnionArmySelectCellOwner = UnionArmySelectCellOwner or {}
            ccb["UnionArmySelectCellOwner"] = UnionArmySelectCellOwner


            local function selectItemClick(tag)
                local dic = members[tag]
                getUnionBattleLayer():selectArmy(_fortId, dic)
                _layer:removeFromParentAndCleanup(true)
            end
            UnionArmySelectCellOwner["selectItemClick"] = selectItemClick

            local function setCellMenuPriority(sender)
                if sender then
                    local menu = tolua.cast(sender, "CCMenu")
                    menu:setHandlerPriority(_priority - 1)
                end
            end

            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            local proxy = CCBProxy:create()
            local _hbCell = tolua.cast(CCBReaderLoad("ccbResources/UnionArmySelectCell.ccbi",proxy,true,"UnionArmySelectCellOwner"),"CCSprite")
            local contentLayer = UnionArmySelectOwner["contentLayer"]
            a2:addChild(_hbCell, 0, 1)
            local selectItem = UnionArmySelectCellOwner["selectItem"]
            selectItem:setTag(a1 + 1)
            local menu = UnionArmySelectCellOwner["menu"]
            local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCCallFuncN:create(setCellMenuPriority))
            menu:runAction(seq)

            local dic = members[a1 + 1]

            local name = tolua.cast(UnionArmySelectCellOwner["name"], "CCLabelTTF")
            name:setString(dic.name)

            local vip = tolua.cast(UnionArmySelectCellOwner["vip"], "CCLabelTTF")
            if dic.vipLevel and dic.vipLevel > 0 then
                vip:setString(string.format("VIP%d", dic.vipLevel))
                vip:setVisible(true)
            else
                vip:setVisible(false)
            end

            local level = tolua.cast(UnionArmySelectCellOwner["level"], "CCLabelTTF")
            level:setString(dic.level)

            local price = tolua.cast(UnionArmySelectCellOwner["price"], "CCLabelTTF")
            if dic.price then
                price:setString(dic.price)
            else
                price:setString("?????")
            end

            local duty = tolua.cast(UnionArmySelectCellOwner["duty"], "CCLabelTTF")
            duty:setString(unionData:getNameByDuty(dic.duty))
            
            for i=0,2 do
                local heroId
                local herowake
                if dic.form[tostring(i)] and dic then
                    heroId = dic.form[tostring(i)].heroId
                    herowake = dic.form[tostring(i)].wake
                elseif dic.heros then
                    heroId = dic.heros[tostring(i)]
                end
                if heroId then
                    local conf = herodata:getHeroConfig(heroId ,herowake )
                    local frame = tolua.cast(UnionArmySelectCellOwner["frame"..i + 1], "CCSprite")
                    frame:setVisible(true)
                    frame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", conf.rank)))
                    local head = tolua.cast(UnionArmySelectCellOwner["head"..i + 1], "CCSprite")
                    local f = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(herodata:getHeroHeadByHeroId(heroId))
                    if f then
                        head:setDisplayFrame(f)
                        head:setVisible(true)
                    end
                end
            end
            
            r = a2
        elseif fn == "numberOfCells" then
            r = table.getTableCount(members)
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
    local contentLayer = UnionArmySelectOwner["contentLayer"]
    tableView = LuaTableView:createWithHandler(h, contentLayer:getContentSize())
    tableView:setBounceable(true)
    tableView:setAnchorPoint(ccp(0, 0))
    tableView:setPosition(ccp(0, 0))
    tableView:setVerticalFillOrder(0)
    contentLayer:addChild(tableView, 10, 10)
end

local function setMenuPriority()
    local menu = tolua.cast(UnionArmySelectOwner["menu"], "CCMenu")
    menu:setHandlerPriority(_priority - 1)
    if tableView then
        tableView:setTouchPriority(_priority - 1)
    end
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/UnionArmySelectView.ccbi", proxy, true,"UnionArmySelectOwner")
    _layer = tolua.cast(node,"CCLayer")
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(UnionArmySelectOwner["infoBg"], "CCSprite")
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


-- 该方法名字每个文件不要重复
function getUnionArmySelectLayer()
	return _layer
end

function createUnionArmySelectLayer(fortId, priority)
    _init()
    _priority = priority ~= nil and priority or -134
    _fortId = fortId

    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
        addTableView()
    end

    local function _onExit()
        _layer = nil
        tableView = nil
        _priority = -134
        _fortId = nil
    end

    --onEnter onExit
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