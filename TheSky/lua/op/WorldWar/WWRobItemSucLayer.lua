local _layer
local _tableView
local _priority = -132

-- 名字不要重复
WWRobItemSucViewOwner = WWRobItemSucViewOwner or {}
ccb["WWRobItemSucViewOwner"] = WWRobItemSucViewOwner


--关闭按钮
local function closeItemClick()
    popUpCloseAction(WWRobItemSucViewOwner, "infoBg", _layer)
end
WWRobItemSucViewOwner["closeItemClick"] = closeItemClick
--确定按钮
local function confirmBtnTaped()
    popUpCloseAction(WWRobItemSucViewOwner, "infoBg", _layer)
end
WWRobItemSucViewOwner["confirmBtnTaped"] = confirmBtnTaped

local function gainPopup()
    return userdata:PopUpRobSucGain(runtimeCache.responseData.gain, true)
end

local function _addTableView()
   
    local array = gainPopup()
    
    print("------0000000000---------")
    PrintTable(array)
    PrintTable(runtimeCache.responseData.gain)
    MultiItemCellOwner = MultiItemCellOwner or {}
    ccb["MultiItemCellOwner"] = MultiItemCellOwner

    local containLayer = tolua.cast(WWRobItemSucViewOwner["containLayer"],"CCLayer")

    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(600, 120)
        elseif fn == "cellAtIndex" then
            -- Return CCTableViewCell, a1 is cell index (zero based), a2 is dequeued cell (maybe nil)
            -- Do something to create cell  and change the content
            
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            --单条数据
            -- local arrayContent = _itemArray[a1 + 1]
            local dic = array[a1 + 1]
            local itemId = dic.itemId
            local count = dic.count
            local proxy = CCBProxy:create()
            local _hbCell = tolua.cast(CCBReaderLoad("ccbResources/MultiItemCell.ccbi", proxy, true, "MultiItemCellOwner"), "CCLayer")
            local resDic = userdata:getExchangeResource(itemId)

             -- RobItemSuc.unSought 如果获得图纸，则意外显示获得图纸 getBookItem
            local getBookItem = tolua.cast(WWRobItemSucViewOwner["getBookItem"],"CCLabelTTF")

            if tostring(itemId) == "silver" then
                getBookItem:setVisible(false)
            elseif tostring(itemId) == "item_006" then
                getBookItem:setVisible(false)
            else
                getBookItem:setVisible(true)
                getBookItem:setString(HLNSLocalizedString("RobItemSuc.unSought", userdata:getExchangeResource(itemId).name, count))
            end
            local rankFrame = tolua.cast(MultiItemCellOwner["rankFrame"], "CCSprite")
            local contentLayer = tolua.cast(MultiItemCellOwner["contentLayer"],"CCLayer")
            local bigSprite = tolua.cast(MultiItemCellOwner["bigSprite"],"CCSprite")
            local littleSprite = tolua.cast(MultiItemCellOwner["littleSprite"],"CCSprite")
            local soulIcon = tolua.cast(MultiItemCellOwner["soulIcon"],"CCSprite")
            local chipIcon = tolua.cast(MultiItemCellOwner["chipIcon"],"CCSprite")
            local itemName = tolua.cast(MultiItemCellOwner["itemName"], "CCSprite")
            itemName:setString(tostring(resDic.name))
            local itemCountLabel = tolua.cast(MultiItemCellOwner["countLabel"],"CCLabelTTF")
            itemCountLabel:setString(tostring(count))
            chipIcon:setVisible(false)
            if havePrefix(itemId, "weapon_") or havePrefix(itemId, "belt_") or havePrefix(itemId, "armor_") then
                -- 装备
                bigSprite:setVisible(true)
                local texture
                if haveSuffix(itemId, "_shard") then
                    chipIcon:setVisible(true)
                    texture = CCTextureCache:sharedTextureCache():addImage(string.format("ccbResources/icons/%s.png", resDic.icon))
                else
                    texture = CCTextureCache:sharedTextureCache():addImage(resDic.icon)
                end
                if texture then
                    bigSprite:setVisible(true)
                    bigSprite:setTexture(texture)
                end

            elseif havePrefix(itemId, "item") then
                -- 道具
                bigSprite:setVisible(true)
                local texture = CCTextureCache:sharedTextureCache():addImage(resDic.icon)
                if texture then
                    bigSprite:setVisible(true)
                    bigSprite:setTexture(texture)
                end
            elseif havePrefix(itemId, "shadow") then
                -- 影子
                rankFrame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("s_frame.png"))
                rankFrame:setPosition(ccp(rankFrame:getPositionX() + 5,rankFrame:getPositionY() - 5))
                if resDic.icon then
                    playCustomFrameAnimation(string.format("yingzi_%s_", resDic.icon), contentLayer, 
                        ccp(contentLayer:getContentSize().width / 2,contentLayer:getContentSize().height / 2), 1, 4,
                        shadowData:getColorByColorRank(resDic.rank))
                end
            elseif havePrefix(itemId, "hero") then
                -- 魂魄
                littleSprite:setVisible(true)
                littleSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(resDic.icon))

            elseif havePrefix(itemId, "book") then
                -- 奥义
                bigSprite:setVisible(true)
                local texture = CCTextureCache:sharedTextureCache():addImage(resDic.icon)
                if texture then
                    bigSprite:setVisible(true)
                    bigSprite:setTexture(texture)
                end
            else
                -- 金币 银币
                bigSprite:setVisible(true)
                local texture = CCTextureCache:sharedTextureCache():addImage(resDic.icon)
                if texture then
                    bigSprite:setVisible(true)
                    bigSprite:setTexture(texture)
                end
            end
            if not havePrefix(itemId, "shadow") then
                rankFrame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", resDic.rank)))
            end

            -- _hbCell:setScale(retina)
            a2:addChild(_hbCell, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            r = a2
        elseif fn == "numberOfCells" then
            r = getMyTableCount(array)
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
    local size = CCSizeMake(containLayer:getContentSize().width, containLayer:getContentSize().height)  -- 这里是为了在tableview上面显示一个小空出来
    _tableView = LuaTableView:createWithHandler(h, size)
    _tableView:setBounceable(true)
    _tableView:setAnchorPoint(ccp(0,0))
    _tableView:setPosition(0,0)
    _tableView:setVerticalFillOrder(0)
    containLayer:addChild(_tableView,1000)
end

local function refresh()
    _addTableView()
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    local proxy = CCBProxy:create()
    local node  = CCBReaderLoad("ccbResources/WWRobItemSucView.ccbi", proxy, true, "WWRobItemSucViewOwner")
    _layer = tolua.cast(node,"CCLayer")
    refresh()
end

-- 修改 按钮优先级
local function setMenuPriority()
    local menu = tolua.cast(WWRobItemSucViewOwner["menu"], "CCMenu")
    menu:setHandlerPriority(_priority - 1)
end


-- 该方法名字每个文件不要重复
function getWWRobItemSucLayer()
	return _layer
end


function createWWRobItemSucLayer(priority)
     _priority = (priority ~= nil) and priority or -132
    _init()
    local function _onEnter()
        addObserver(NOTI_WW_REFRESH, refresh)
    end

    local function _onExit()
        removeObserver(NOTI_WW_REFRESH, refresh)
        _tableView = nil
        _layer = nil
        _priority = -132
        
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