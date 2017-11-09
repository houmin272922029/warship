local _layer
local _priority
local _data
local _tableView
local _itemArray

WWShopPopupOwner = WWShopPopupOwner or {}
ccb["WWShopPopupOwner"] = WWShopPopupOwner

-- 关闭
local function closeItemClick()
    popUpCloseAction(WWShopPopupOwner, "infoBg", _layer)
end
WWShopPopupOwner["closeItemClick"] = closeItemClick


local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(WWShopPopupOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction(WWShopPopupOwner, "infoBg", _layer)
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
    local menu = tolua.cast(WWShopPopupOwner["menu"], "CCMenu")
    menu:setHandlerPriority(_priority - 1)
    _tableView:setTouchPriority(_priority - 1)
end

local function itemData()
    _itemArray = {}
    for k,v in pairs(_data.itemKeys) do
        table.insert(_itemArray, v)
    end
    local function sortFun(a, b)
        return a.itemKey < b.itemKey
    end
    table.sort(_itemArray, sortFun)
end

local function addTableView()

    itemData()

    WWShopPopupCellOwner = WWShopPopupCellOwner or {}
    ccb["WWShopPopupCellOwner"] = WWShopPopupCellOwner
    
    local function shopItemClick(tag)
        local dic = _itemArray[tag]
        local conf = ConfigureStorage.WWShop[tostring(dic.itemKey)]
        local itemId = conf.itemId
        if havePrefix(itemId, "weapon_") or havePrefix(itemId, "belt_") or havePrefix(itemId, "armor_") then
                -- 装备
            if haveSuffix(itemId, "_shard") then
                itemId = string.sub(itemId, 1, -7)
            end
            getMainLayer():getParent():addChild(createEquipInfoLayer(itemId, 2, _priority - 2), 10)
        elseif havePrefix(itemId, "item") or havePrefix(itemId, "key") or havePrefix(itemId, "bag") 
            or havePrefix(itemId, "stuff") or havePrefix(itemId, "drawing") then
            -- 道具
            getMainLayer():getParent():addChild(createItemDetailInfoLayer(itemId, _priority - 2, 1, 1), 10)
        elseif havePrefix(itemId, "shadow") then
            -- 影子
            local dic = {}
            local item = shadowData:getOneShadowConf(itemId)
            dic.conf = item
            dic.id = itemId
            getMainLayer():getParent():addChild(createShadowPopupLayer(dic, nil, nil, _priority - 2, 1), 10)
        elseif havePrefix(itemId, "hero") then
            -- 魂魄
            getMainLayer():getParent():addChild(createHeroInfoLayer(itemId, HeroDetail_Clicked_Handbook, _priority - 2), 10)
        elseif havePrefix(itemId, "book") then
            -- 奥义
            getMainLayer():getParent():addChild(createHandBookSkillDetailLayer(itemId, _priority - 2), 10) 
        elseif havePrefix(itemId, "chapter_") then
            -- 残章
            local bookId = string.format("book_%s", string.split(itemId, "_")[2])
            getMainLayer():getParent():addChild(createHandBookSkillDetailLayer(bookId, _priority - 2), 10) 
        else
            -- 金币 银币
        end
    end
    WWShopPopupCellOwner["shopItemClick"] = shopItemClick

    local function buyItemClick(tag)
        local dic = _itemArray[tag]
        local conf = ConfigureStorage.WWShop[tostring(dic.itemKey)]
        if dic.buyCount >= conf.buyLimit then
            ShowText(HLNSLocalizedString("ERR_2733"))
            return
        end
        local function callback(url, rtnData)
            worldwardata:fromDic(rtnData.info)
            postNotification(NOTI_WW_REFRESH, nil) 
            local exploreData = worldwardata.playerData.exploreData
            local data = exploreData[worldwardata.playerData.islandId].shops
            for k,v in pairs(data) do
                if k == _data.sid then
                    _data = deepcopy(v)
                    _data.sid = k
                    itemData()
                    _tableView:reloadData()
                    break
                end
            end
        end
        doActionFun("WW_BUY_SHOPITEM", {_data.sid, dic.itemKey}, callback)
    end
    WWShopPopupCellOwner["buyItemClick"] = buyItemClick

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
            local  _hbCell  = tolua.cast(CCBReaderLoad("ccbResources/WWShopPopupCell.ccbi",proxy,true,"WWShopPopupCellOwner"),"CCLayer")

            local function setCellMenuPriority(sender)
                if sender then
                    local menu = tolua.cast(sender, "CCMenu")
                    menu:setHandlerPriority(_priority - 1)
                end
            end

            local menu = WWShopPopupCellOwner["menu"]
            local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCCallFuncN:create(setCellMenuPriority))
            menu:runAction(seq)

            local dic = _itemArray[a1 + 1]
            local conf = ConfigureStorage.WWShop[tostring(dic.itemKey)]

            local buyItem = tolua.cast(WWShopPopupCellOwner["buyItem"], "CCMenuItem")
            buyItem:setTag(a1 + 1)
            local frame = tolua.cast(WWShopPopupCellOwner["frame"], "CCMenuItem")
            frame:setTag(a1 + 1)
            local contentLayer = tolua.cast(WWShopPopupCellOwner["contentLayer"],"CCLayer")
            local bigSprite = tolua.cast(WWShopPopupCellOwner["bigSprite"],"CCSprite")
            local chipIcon = tolua.cast(WWShopPopupCellOwner["chipIcon"],"CCSprite")
            local littleSprite = tolua.cast(WWShopPopupCellOwner["littleSprite"],"CCSprite")
            local soulIcon = tolua.cast(WWShopPopupCellOwner["soulIcon"],"CCSprite")
            local countLabel = tolua.cast(WWShopPopupCellOwner["countLabel"],"CCLabelTTF")
            local nameLabel = tolua.cast(WWShopPopupCellOwner["name"],"CCLabelTTF")

            local itemId = conf.itemId
            local amount = conf.amount

            local resDic = userdata:getExchangeResource(itemId)

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
                frame:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("s_frame.png"))
                frame:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("s_frame.png"))

                frame:setPosition(ccp(frame:getPositionX() + 5,frame:getPositionY() - 5))
                if resDic.icon then
                    playCustomFrameAnimation( string.format("yingzi_%s_",resDic.icon),contentLayer,ccp(contentLayer:getContentSize().width / 2,contentLayer:getContentSize().height / 2),1,4,shadowData:getColorByColorRank( resDic.rank ) )
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
                frame:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", resDic.rank)))
                frame:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", resDic.rank)))
            end

            -- 设置名字和数量

            countLabel:setString(amount)
            nameLabel:setString(resDic.name)

            local priceIcon = tolua.cast(WWShopPopupCellOwner["priceIcon"], "CCSprite")
            local price = tolua.cast(WWShopPopupCellOwner["price"], "CCLabelTTF")
            if conf.chargeType == "gold" then
                priceIcon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("gold.png"))
            elseif conf.chargeType == "silver" then
                priceIcon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("berry.png"))
            else
                priceIcon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("crystal_icon.png"))
            end
            price:setString(conf.cost)

            local buyCount = tolua.cast(WWShopPopupCellOwner["buyCount"], "CCLabelTTF")
            buyCount:setString(HLNSLocalizedString("ww.shop.buyCount", conf.buyLimit - dic.buyCount))

            a2:addChild(_hbCell, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            r = a2
        elseif fn == "numberOfCells" then
            r = #_itemArray
        elseif fn == "cellTouched" then         -- A cell was touched, a1 is cell that be touched. This is not necessary.
        elseif fn == "cellTouchBegan" then      -- A cell is touching, a1 is cell, a2 is CCTouch
        elseif fn == "cellTouchEnded" then      -- A cell was touched, a1 is cell, a2 is CCTouch
        elseif fn == "cellHighlight" then       -- A cell is highlighting, coco2d-x 2.1.3 or above
        elseif fn == "cellUnhighlight" then     -- A cell had been unhighlighted, coco2d-x 2.1.3 or above
        elseif fn == "cellWillRecycle" then     -- A cell will be recycled, coco2d-x 2.1.3 or above
        end
        return r
    end)
    local content = tolua.cast(WWShopPopupOwner["content"], "CCLayer")
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
    local  node  = CCBReaderLoad("ccbResources/WWShopPopup.ccbi", proxy, true, "WWShopPopupOwner")
    _layer = tolua.cast(node, "CCLayer")

    local title = tolua.cast(WWShopPopupOwner["title"], "CCLabelTTF")
    local shopId = _data.shopId
    local conf = ConfigureStorage.WWShopCfg[shopId]
    title:setString(conf.name)

    addTableView()
end

function createWWShopLayer(data, priority)
    _data = data
    _priority = (priority ~= nil) and priority or -132

    _init()

    local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
    _layer:runAction(seq)

    local function _onEnter()
        popUpUiAction(WWShopPopupOwner, "infoBg")
    end

    local function _onExit()
        _priority = -132
        _damageFun = nil
        _layer = nil
        _tableView = nil
        _itemArray = nil
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