local _layer
local _tableView
local _bTableViewTouch
local _data
local COIN_ITEM = "item_020"

LuckyShopViewOwner = LuckyShopViewOwner or {}
ccb["LuckyShopViewOwner"] = LuckyShopViewOwner

local function _addTableView()
    -- 得到数据
    local content = LuckyShopViewOwner["content"]

    LuckyShopCellOwner = LuckyShopCellOwner or {}
    ccb["LuckyShopCellOwner"] = LuckyShopCellOwner

    local function rewardItemClick(tag)
        local dic = _data.items[tostring(tag)]
        local itemId = dic.itemId
        local buyCount = 0
        if dic.buyCount and dic.buyCount ~= "" then
            buyCount = tonumber(dic.buyCount)
        end
        if dic.buyLimit - buyCount <= 0 then
            ShowText(HLNSLocalizedString("luckyshop.soldout"))
            return
        end

        local resDic = userdata:getExchangeResource(itemId)
        local payAmount = dic.payAmount
        if wareHouseData:getItemCountById(COIN_ITEM) < payAmount then
            ShowText(HLNSLocalizedString("luckyshop.item.need", wareHouseData:getItemConfig(COIN_ITEM).name))
            return
        end
        local function callback(url, rtnData)
            _layer:refresh() 
        end
        doActionFun("BUY_LUCKYSHOP_ITEM", {_data.uid, tag}, callback)

    end
    LuckyShopCellOwner["rewardItemClick"] = rewardItemClick

    local function frameItemClick(tag)
        local dic = _data.items[tostring(tag)]
        local itemId = dic.itemId

        if havePrefix(itemId, "weapon_") or havePrefix(itemId, "belt_") or havePrefix(itemId, "armor_") then
            -- 装备
            if haveSuffix(itemId, "_shard") then
                itemId = string.sub(itemId,1,-7)
            end
            getMainLayer():getParent():addChild(createEquipInfoLayer(itemId, 2, -134), 10)
        elseif havePrefix(itemId, "item") or havePrefix(itemId, "key") or havePrefix(itemId, "bag") 
            or havePrefix(itemId, "stuff") or havePrefix(itemId, "drawing") then
            -- 道具
            getMainLayer():getParent():addChild(createItemDetailInfoLayer(itemId, -134, 1, 1), 10)
        elseif havePrefix(itemId, "shadow") then
            -- 影子
            local dic = {}
            local item = shadowData:getOneShadowConf(itemId)
            dic.conf = item
            dic.id = itemId
            getMainLayer():getParent():addChild(createShadowPopupLayer(dic, nil, nil, -134, 1), 10)
        elseif havePrefix(itemId, "hero") then
            -- 魂魄
            getMainLayer():getParent():addChild(createHeroInfoLayer(itemId, HeroDetail_Clicked_Handbook, -134), 10)
        elseif havePrefix(itemId, "book") then
            -- 奥义
            getMainLayer():getParent():addChild(createHandBookSkillDetailLayer(itemId, -134), 10) 
        elseif havePrefix(itemId, "chapter_") then
            -- 残章
            local bookId = string.format("book_%s", string.split(itemId, "_")[2])
            getMainLayer():getParent():addChild(createHandBookSkillDetailLayer(bookId, -134), 10) 
        else
            -- 金币 银币
        end
    end
    LuckyShopCellOwner["frameItemClick"] = frameItemClick

    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(345, 112)
        elseif fn == "cellAtIndex" then
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            --单条数据
            local  proxy = CCBProxy:create()
            local  _hbCell  = tolua.cast(CCBReaderLoad("ccbResources/LuckyShopCell.ccbi", proxy, true, "LuckyShopCellOwner"), "CCLayer")

            local function setCellMenuPriority(sender)
                if sender then
                    local menu = tolua.cast(sender, "CCMenu")
                    menu:setHandlerPriority(-132)
                end
            end

            local menu = LuckyShopCellOwner["menu"]
            local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCCallFuncN:create(setCellMenuPriority))
            menu:runAction(seq)

            local rewardItem = tolua.cast(LuckyShopCellOwner["rewardItem"], "CCMenuItem")
            rewardItem:setTag(a1)
            local avatarItem = tolua.cast(LuckyShopCellOwner["avatarBtn"], "CCMenuItemImage")
            avatarItem:setTag(a1)

            local goldLabel = tolua.cast(LuckyShopCellOwner["goldLabel"], "CCLabelTTF")

            local itemsDic = _data.items[tostring(a1)]

            goldLabel:setString(itemsDic.payAmount)


            local contentLayer = tolua.cast(LuckyShopCellOwner["contentLayer"], "CCLayer")
            local bigSprite = tolua.cast(LuckyShopCellOwner["bigSprite"], "CCSprite")
            local chipIcon = tolua.cast(LuckyShopCellOwner["chip_icon"], "CCSprite")
            local littleSprite = tolua.cast(LuckyShopCellOwner["littleSprite"], "CCSprite")
            local soulIcon = tolua.cast(LuckyShopCellOwner["soulIcon"], "CCSprite")
            local countLabel = tolua.cast(LuckyShopCellOwner["countLabel"], "CCLabelTTF")
            local nameLabel = tolua.cast(LuckyShopCellOwner["nameLabel"], "CCLabelTTF")
            local leftCount = tolua.cast(LuckyShopCellOwner["count"], "CCLabelTTF")

            local buyCount = 0
            if itemsDic.buyCount and itemsDic.buyCount ~= "" then
                buyCount = tonumber(itemsDic.buyCount)
            end
            leftCount:setString(itemsDic.buyLimit - buyCount)

            local itemId = itemsDic.itemId
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

                local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
                cache:addSpriteFramesWithFile("ccbResources/shadow.plist")

                avatarItem:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("s_frame.png"))
                avatarItem:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("s_frame.png"))

                avatarItem:setPosition(ccp(avatarItem:getPositionX() + 5,avatarItem:getPositionY() - 5))
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
                avatarItem:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", resDic.rank)))
                avatarItem:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", resDic.rank)))
            end

            -- 设置名字和数量

            countLabel:setString(itemsDic.amount)
            nameLabel:setString(itemsDic.name)

            a2:addChild(_hbCell, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            r = a2
        elseif fn == "numberOfCells" then
            r = getMyTableCount(_data.items)
        elseif fn == "cellTouched" then         -- A cell was touched, a1 is cell that be touched. This is not necessary.
        elseif fn == "cellTouchBegan" then      -- A cell is touching, a1 is cell, a2 is CCTouch
            getDailyLayer():pageViewTouchEnabled(true)
            _bTableViewTouch = true
        elseif fn == "cellTouchEnded" then      -- A cell was touched, a1 is cell, a2 is CCTouch
            if _bTableViewTouch then
                getDailyLayer():pageViewTouchEnabled(true)
                _bTableViewTouch = false
            end
        elseif fn == "cellHighlight" then       -- A cell is highlighting, coco2d-x 2.1.3 or above
        elseif fn == "cellUnhighlight" then     -- A cell had been unhighlighted, coco2d-x 2.1.3 or above
        elseif fn == "cellWillRecycle" then     -- A cell will be recycled, coco2d-x 2.1.3 or above
        elseif fn == "scroll" then   
            if _bTableViewTouch then
                getDailyLayer():pageViewTouchEnabled(false)
            end
            if _tableView then
                local downArrow = tolua.cast(LuckyShopViewOwner["downArrow"], "CCSprite") 
                local upArrow = tolua.cast(LuckyShopViewOwner["upArrow"], "CCSprite")  
                if  _tableView:getContentOffset().y >= 0 then
                    downArrow:setVisible(false)
                elseif _tableView:getContentOffset().y <= content:getContentSize().height - getMyTableCount(_data.items) * 115 then
                    upArrow:setVisible(false)
                else 
                    upArrow:setVisible(true)
                    downArrow:setVisible(true)
                end
            end
        end
        return r
    end)

    local size = content:getContentSize()
    _tableView = LuaTableView:createWithHandler(h, size)
    _tableView:setBounceable(true)
    _tableView:setAnchorPoint(ccp(0,0))
    _tableView:setPosition(0,0)
    _tableView:setVerticalFillOrder(0)
    content:addChild(_tableView,1000)
end


local function _refreshData()
    _data = dailyData:getDailyDataByName(Daily_LuckyShop)

    local luckyItem = tolua.cast(LuckyShopViewOwner["luckyItem"], "CCMenuItem")
    local state1 = tolua.cast(LuckyShopViewOwner["state1"], "CCSprite")
    luckyItem:setVisible(dailyData:getDailyDataByName(Daily_LuckyReward) ~= nil)
    state1:setVisible(dailyData:getDailyDataByName(Daily_LuckyReward) ~= nil)

    local coinCount = tolua.cast(LuckyShopViewOwner["coinCount"], "CCLabelTTF")
    coinCount:setString(wareHouseData:getItemCountById(COIN_ITEM))

    if _tableView then
        _tableView:removeFromParentAndCleanup(true)
        _tableView = nil
    end
    _addTableView()
end

local function _getInfo()
    local function callback(url, rtnData)
        _refreshData() 
    end
    doActionFun("GET_LUCKYSHOP_INFO", {}, callback) 
end

local function luckyItemClick()
    getDailyLayer():moveToPageByName(Daily_LuckyReward)
end
LuckyShopViewOwner["luckyItemClick"] = luckyItemClick


-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/LuckyShopView.ccbi",proxy, true, "LuckyShopViewOwner")
    _layer = tolua.cast(node, "CCLayer")

    _refreshData()
end

-- 该方法名字每个文件不要重复
function getLuckyShopLayer()
    return _layer
end

function createLuckyShopLayer()
    _init()

    function _layer:getInfo()
        _getInfo()
    end

    function _layer:refresh()
        _refreshData()
    end

    local function _onEnter()

    end

    local function _onExit()
        _layer = nil
        _tableView = nil
        _bTableViewTouch = false
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

    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end