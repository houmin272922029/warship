local _layer
local _tableView
local _priority = -132
local _data

-- 名字不要重复
WWEscortItemRewardViewOwner = WWEscortItemRewardViewOwner or {}
ccb["WWEscortItemRewardViewOwner"] = WWEscortItemRewardViewOwner

--关闭按钮
local function closeItemClick()
    popUpCloseAction(WWEscortItemRewardViewOwner, "infoBg", _layer)
end
WWEscortItemRewardViewOwner["closeItemClick"] = closeItemClick
--确定按钮
local function confirmBtnTaped()
    popUpCloseAction(WWEscortItemRewardViewOwner, "infoBg", _layer)
end
WWEscortItemRewardViewOwner["confirmBtnTaped"] = confirmBtnTaped


--数据后台处理
local function PopUpRewardGain(gain, bAllType)
    local temp = {}
    if gain["items"] then
        for k,v in pairs(gain["items"]) do
            table.insert(temp, {itemId = k , count = v})
        end
    end
    if gain["silver"] then
        table.insert(temp, {itemId = "silver" , count = gain.silver})
    end
     if gain["gold"] then
        table.insert(temp, {itemId = "gold" , count = gain.gold})
    end
    return temp
end

--服务器返回数据处理
local function gainPopup()
    return PopUpRewardGain(_data.gain, true)
end

local function _addTableView()
   
    local array = gainPopup()
    MultiItemCellOwner = MultiItemCellOwner or {}
    ccb["MultiItemCellOwner"] = MultiItemCellOwner

    local containLayer1 = tolua.cast(WWEscortItemRewardViewOwner["containLayer1"],"CCLayer")

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

        
            local rankFrame = tolua.cast(MultiItemCellOwner["rankFrame"], "CCSprite")
            local contentLayer = tolua.cast(MultiItemCellOwner["contentLayer"],"CCLayer")
            local bigSprite = tolua.cast(MultiItemCellOwner["bigSprite"],"CCSprite")
            local littleSprite = tolua.cast(MultiItemCellOwner["littleSprite"],"CCSprite")
            local soulIcon = tolua.cast(MultiItemCellOwner["soulIcon"],"CCSprite")
            local chipIcon = tolua.cast(MultiItemCellOwner["chipIcon"],"CCSprite")
            local itemName = tolua.cast(MultiItemCellOwner["itemName"], "CCSprite")
            local itemCountLabel = tolua.cast(MultiItemCellOwner["countLabel"],"CCLabelTTF")
            -- RobItemSuc.unSought 如果获得图纸，则意外显示获得图纸 getBookItem
            local getBookItem = tolua.cast(WWEscortItemRewardViewOwner["getBookItem"],"CCLabelTTF")
            --图纸判断
            if tostring(itemId) == "silver" then
                getBookItem:setVisible(false)
                itemCountLabel:setString(tostring(_data.original))
            elseif tostring(itemId) == "item_006" then
                getBookItem:setVisible(false)
                itemCountLabel:setString(tostring(_data.original))
            else
                getBookItem:setVisible(true)
                itemCountLabel:setString(tostring(count))
                getBookItem:setString(HLNSLocalizedString("RobItemSuc.unSought", userdata:getExchangeResource(itemId).name, count))
            end
            itemName:setString(tostring(resDic.name))
            chipIcon:setVisible(false)
            --代码整理
            --判断魂魄、影子单独处理
            if havePrefix(itemId, "hero") then
                -- 魂魄
                littleSprite:setVisible(true)
                soulIcon:setVisible(true)
                littleSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(resDic.icon))
            elseif havePrefix(itemId, "shadow") then
                -- 影子
                rankBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("s_frame.png"))
                rankBtn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("s_frame.png"))

                rankBtn:setPosition(ccp(rankBtn:getPositionX() + 5,rankBtn:getPositionY() - 5))
                if resDic.icon then
                    playCustomFrameAnimation(string.format("yingzi_%s_", resDic.icon), contentLayer, ccp(contentLayer:getContentSize().width / 2,
                        contentLayer:getContentSize().height / 2), 1, 4, shadowData:getColorByColorRank(resDic.rank))
                end
            else
                -- 道具，装备，技能，货币
                local texture
                if haveSuffix(itemId, "_shard") then
                    -- 装备碎片
                    texture = CCTextureCache:sharedTextureCache():addImage(string.format("ccbResources/icons/%s.png",resDic.icon))
                    chip_icon:setVisible(true)
                else
                    texture = CCTextureCache:sharedTextureCache():addImage(resDic.icon)
                end
                if texture then
                    bigSprite:setVisible(true)
                    bigSprite:setTexture(texture)
                    if resDic.rank == 4 then
                        HLAddParticleScale( "images/purpleEquip.plist", bigSprite, ccp(bigSprite:getContentSize().width / 2,bigSprite:getContentSize().height / 2), 
                            1, 100, 777, 2 / 0.35 / retina, 2 / 0.35 / retina, 1 )
                    end
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
    local size = CCSizeMake(containLayer1:getContentSize().width, containLayer1:getContentSize().height)  -- 这里是为了在tableview上面显示一个小空出来
    _tableView = LuaTableView:createWithHandler(h, size)
    _tableView:setBounceable(true)
    _tableView:setAnchorPoint(ccp(0,0))
    _tableView:setPosition(0,0)
    _tableView:setVerticalFillOrder(0)
    containLayer1:addChild(_tableView,1000)
end

--不加额外掉落 图纸的tableview  通过array判断
local function _addTableView2()
    local array = gainPopup()
    local myData = {}
    for i,v in ipairs(array) do
        if not havePrefix(v.itemId, "drawing_weapon") then
            table.insert(myData,v)
        end
    end
    array = myData
    MultiItemCellOwner = MultiItemCellOwner or {}
    ccb["MultiItemCellOwner"] = MultiItemCellOwner

    local containLayer2 = tolua.cast(WWEscortItemRewardViewOwner["containLayer2"],"CCLayer")

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

          
            local rankFrame = tolua.cast(MultiItemCellOwner["rankFrame"], "CCSprite")
            local contentLayer = tolua.cast(MultiItemCellOwner["contentLayer"],"CCLayer")
            local bigSprite = tolua.cast(MultiItemCellOwner["bigSprite"],"CCSprite")
            local littleSprite = tolua.cast(MultiItemCellOwner["littleSprite"],"CCSprite")
            local soulIcon = tolua.cast(MultiItemCellOwner["soulIcon"],"CCSprite")
            local chipIcon = tolua.cast(MultiItemCellOwner["chipIcon"],"CCSprite")
            local itemName = tolua.cast(MultiItemCellOwner["itemName"], "CCSprite")
            -- 数量 名称
            local itemCountLabel = tolua.cast(MultiItemCellOwner["countLabel"],"CCLabelTTF")
            itemCountLabel:setString(tostring(_data.extra))
            itemName:setString(tostring(resDic.name))
            chipIcon:setVisible(false)
            --代码整理
            --判断魂魄、影子单独处理
            if havePrefix(itemId, "hero") then
                -- 魂魄
                littleSprite:setVisible(true)
                soulIcon:setVisible(true)
                littleSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(resDic.icon))
            elseif havePrefix(itemId, "shadow") then
                -- 影子
                rankBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("s_frame.png"))
                rankBtn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("s_frame.png"))

                rankBtn:setPosition(ccp(rankBtn:getPositionX() + 5,rankBtn:getPositionY() - 5))
                if resDic.icon then
                    playCustomFrameAnimation(string.format("yingzi_%s_", resDic.icon), contentLayer, ccp(contentLayer:getContentSize().width / 2,
                        contentLayer:getContentSize().height / 2), 1, 4, shadowData:getColorByColorRank(resDic.rank))
                end
            else
                -- 道具，装备，技能，货币
                local texture
                if haveSuffix(itemId, "_shard") then
                    -- 装备碎片
                    texture = CCTextureCache:sharedTextureCache():addImage(string.format("ccbResources/icons/%s.png",resDic.icon))
                    chip_icon:setVisible(true)
                else
                    texture = CCTextureCache:sharedTextureCache():addImage(resDic.icon)
                end
                if texture then
                    bigSprite:setVisible(true)
                    bigSprite:setTexture(texture)
                    if resDic.rank == 4 then
                        HLAddParticleScale( "images/purpleEquip.plist", bigSprite, ccp(bigSprite:getContentSize().width / 2,bigSprite:getContentSize().height / 2), 
                            1, 100, 777, 2 / 0.35 / retina, 2 / 0.35 / retina, 1 )
                    end
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
    local size = CCSizeMake(containLayer2:getContentSize().width, containLayer2:getContentSize().height)  -- 这里是为了在tableview上面显示一个小空出来
    _tableView = LuaTableView:createWithHandler(h, size)
    _tableView:setBounceable(true)
    _tableView:setAnchorPoint(ccp(0,0))
    _tableView:setPosition(0,0)
    _tableView:setVerticalFillOrder(0)
    containLayer2:addChild(_tableView,1000)
end


local function refresh()
    --通过战舰等级判断是否显示战舰等级加成显示
    if tonumber(worldwardata.playerData.durabilityLevel) == 0 then
        --隐藏相应的items and 不添加tableview
        local extra = tolua.cast(WWEscortItemRewardViewOwner["extra"] , "CCLabelTTF")
        extra:setVisible(false)
        _addTableView()
    else
        --有额外掉落
        _addTableView()
        _addTableView2()
    end
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    local proxy = CCBProxy:create()
    local node  = CCBReaderLoad("ccbResources/WWEscortItemRewardView.ccbi", proxy, true, "WWEscortItemRewardViewOwner")
    _layer = tolua.cast(node,"CCLayer")
    refresh()
end

-- 修改 按钮优先级
local function setMenuPriority()
    local menu = tolua.cast(WWEscortItemRewardViewOwner["menu"] , "CCMenu")
    menu:setHandlerPriority(_priority - 1)
end


-- 该方法名字每个文件不要重复
function getWWEscortItemRewardLayer()
	return _layer
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(WWEscortItemRewardViewOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction(WWEscortItemRewardViewOwner, "infoBg", _layer)
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

function createWWEscortItemRewardLayer(data , priority)
     _priority = (priority ~= nil) and priority or -132
     _data = data
    _init()
    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
        _bAni = false
        addObserver(NOTI_WW_REFRESH, refresh)
        popUpUiAction(WWEscortItemRewardViewOwner, "infoBg")
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

    _layer:registerScriptTouchHandler(onTouch, false, _priority, true)
    _layer:setTouchEnabled(true)
    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end