local _layer
local _tableView
local _bTableViewTouch
local _priority = -132
local _shopData
local itemsArray

MysteryShopOwner = MysteryShopOwner or {}
ccb["MysteryShopOwner"] = MysteryShopOwner

local function errorCallback(url, code)
    if code == "1124" then
        dailyData.daily[Daily_SecretShop] = nil
        getDailyLayer:refreshDailyLayer()
    elseif code == "1125" or code == "1126" or code == "1128" or code == "1127" then
        _layer:refresh()
    end
end

local function _payBtnAction()
    print("paybuttonaction")
    Global:instance():TDGAonEventAndEventData("recharge1")
    -- Global:instance():AlixPayweb(opAppId,userdata.serverCode,userdata.sessionId,"gold_100")
    if getMainLayer() then
        getMainLayer():addChild(createShopRechargeLayer(-140), 100)
    end
end

local function refreshTimeLabel()
    local timerLabel = tolua.cast(MysteryShopOwner["timerLabel"], "CCLabelTTF")
    local timer = dailyData:getMysteryShopRefreshTimer()
    if timer == 0 then
       _layer:getInfo()
    end
    local day, hour, min, sec = DateUtil:secondGetdhms(timer)
    if day > 0 then
        timerLabel:setString(HLNSLocalizedString("timer.tips.1", day, hour, min, sec))
    elseif hour > 0 then
        timerLabel:setString(HLNSLocalizedString("timer.tips.2", hour, min, sec))
    else
        timerLabel:setString(HLNSLocalizedString("timer.tips.3", min, sec))
    end
end

local function _refreshData()
    refreshTimeLabel()
    itemsArray = dailyData:getMysteryShopAwardData()
    _shopData = dailyData:getMysteryShopData()
    _tableView:reloadData()

    local allGoldLabel = tolua.cast(MysteryShopOwner["allGoldLabel"], "CCLabelTTF")
    local allBerryLabel = tolua.cast(MysteryShopOwner["allBerryLabel"], "CCLabelTTF")
    local gold = userdata:getFunctionOfNumberAcronym(tonumber(userdata.gold))
    local berry = userdata:getFunctionOfNumberAcronym(tonumber(userdata.berry))
    allGoldLabel:setString(gold)
    allBerryLabel:setString(berry)
    local gold = tolua.cast(MysteryShopOwner["gold"], "CCSprite")
    local berry = tolua.cast(MysteryShopOwner["berry"], "CCSprite")
    local goldLabel = tolua.cast(MysteryShopOwner["goldLabel"], "CCLabelTTF")
    local freeLayer = tolua.cast(MysteryShopOwner["freeLayer"], "CCLayer")
    local chargeLayer = tolua.cast(MysteryShopOwner["chargeLayer"], "CCLayer")

    if  _shopData.refresh.free then
        local free = _shopData.refresh.free
        local charge = _shopData.refresh.charge 
        local ownerCount = wareHouseData:getItemCountById(free.type)
        if tonumber(ownerCount) >= tonumber(free.amount) then
            chargeLayer:setVisible(false)
            freeLayer:setVisible(true)
            local freeName = tolua.cast(MysteryShopOwner["freeName"], "CCLabelTTF")
            local freeCount = tolua.cast(MysteryShopOwner["freeCount"], "CCLabelTTF")
            freeName:setString(free.name)
            local ownerCount = wareHouseData:getItemCountById(free.type)
            freeCount:setString(string.format("%d/%d",tonumber(ownerCount), tonumber(free.amount)))
        else
            freeLayer:setVisible(false)
            chargeLayer:setVisible(true)
            if charge.type == "gold" then
                berry:setVisible(false)
                gold:setVisible(true)
            else
                gold:setVisible(false)
                berry:setVisible(true)
            end
            goldLabel:setString(charge.amount)
        end
    else
        local charge = _shopData.refresh.charge 
        freeLayer:setVisible(false)
        chargeLayer:setVisible(true)
        if charge.type == "gold" then
            berry:setVisible(false)
            gold:setVisible(true)
        else
            gold:setVisible(false)
            berry:setVisible(true)
        end
        goldLabel:setString(charge.amount)
    end   
end

local function getInfoCallBack( url,rtnData )
    if rtnData.code == 200 then
        itemsArray = dailyData:getMysteryShopAwardData()
        _shopData = dailyData:getMysteryShopData()
        if _shopData then
            if not _tableView then
                _addTableView()
            end
            _refreshData()
        else
            dailyData.daily[Daily_SecretShop] = nil
            -- TODO 刷新dailylayer
            getDailyLayer:refreshDailyLayer()
        end
    end
end
MysteryShopOwner["_payBtnAction"] = _payBtnAction

local function _getInfo()
   doActionFun("DAILY_GET_SECRETSHOP",{},getInfoCallBack, errorCallback) 
end

local function rewardItemCallback(url, rtnData)
    if rtnData.code == 200 then
        itemsArray = dailyData:getMysteryShopAwardData()
        _shopData = dailyData:getMysteryShopData()
        if _shopData then
            if not _tableView then
                _addTableView()
            end
            _refreshData()
        else
            dailyData.daily[Daily_SecretShop] = nil
            -- TODO 刷新dailylayer
            getDailyLayer:refreshDailyLayer()
        end

        local offset = _tableView:getContentOffset().y
        _tableView:setContentOffset(ccp(0, offset))
        
    end
end

local function _addTableView()
    -- 得到数据
    local content = MysteryShopOwner["content"]

    MysteryShopCellOwner = MysteryShopCellOwner or {}
    ccb["MysteryShopCellOwner"] = MysteryShopCellOwner

    local function rewardItemClick(tag)


        local itemsDic = itemsArray[tag]
        local payCount = tonumber(itemsDic.payCost)
        local userOwner = 0
        if itemsDic.payType == "gold" then
            userOwner = userdata.gold
        else
            userOwner = userdata.berry
        end
        if payCount <= tonumber(userOwner) then
            local function confirm()
                doActionFun("DAILY_BUY_SECRETSHOP", {_shopData.lastFlushTime, itemsDic.itemKey, itemsDic.itemId, 
                    itemsDic.amount, itemsDic.buyLimit, itemsDic.payType, itemsDic.payCost}, rewardItemCallback, errorCallback) 
            end
            local text = HLNSLocalizedString("mysteryShop.confirm.tips", itemsDic.name)
            getMainLayer():getParent():addChild(createSimpleConfirCardLayer(text), 100)
            SimpleConfirmCard.confirmMenuCallBackFun = confirm
            SimpleConfirmCard.cancelMenuCallBackFun = nil
        else
            if itemsDic.payType == "gold" then
                ShowText(HLNSLocalizedString("ERR_1101"))
            else
                ShowText(HLNSLocalizedString("ERR_1102"))
            end
        end
    end
    MysteryShopCellOwner["rewardItemClick"] = rewardItemClick

    local function frameItemClick(tag)
        local dic = _shopData[tag]
        local itemId = itemsArray[tag].itemId

        if havePrefix(itemId, "weapon_") or havePrefix(itemId, "belt_") or havePrefix(itemId, "armor_") then
            -- 装备
            if haveSuffix(itemId, "_shard") then
                itemId = string.sub(itemId,1,-7)
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
    MysteryShopCellOwner["frameItemClick"] = frameItemClick

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
            local  _hbCell  = tolua.cast(CCBReaderLoad("ccbResources/MysteryShopCell.ccbi", proxy, true, "MysteryShopCellOwner"), "CCLayer")

            local function setCellMenuPriority(sender)
                if sender then
                    local menu = tolua.cast(sender, "CCMenu")
                    menu:setHandlerPriority(_priority - 1)
                end
            end

            local menu = MysteryShopOwner["menu"]
            local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCCallFuncN:create(setCellMenuPriority))
            menu:runAction(seq)

            local rewardItem = tolua.cast(MysteryShopCellOwner["rewardItem"], "CCMenuItem")
            rewardItem:setTag(a1 + 1)
            local avatarItem = tolua.cast(MysteryShopCellOwner["avatarBtn"], "CCMenuItemImage")
            avatarItem:setTag(a1 + 1)

            local rewardText = tolua.cast(MysteryShopCellOwner["rewardText"], "CCSprite")

            local goldLabel = tolua.cast(MysteryShopCellOwner["goldLabel"], "CCLabelTTF")
            local alreadyBuy = tolua.cast(MysteryShopCellOwner["alreadyBuy"], "CCLabelTTF")

            local itemsDic = itemsArray[a1 + 1]

            goldLabel:setString(itemsDic.payCost)

            local goldIcon = tolua.cast(MysteryShopCellOwner["gold"], "CCSprite")
            local berryIcon = tolua.cast(MysteryShopCellOwner["berry"], "CCSprite")
            if itemsDic.payType == "gold" then
                goldIcon:setVisible(true)
                berryIcon:setVisible(false)
            else
                goldIcon:setVisible(false)
                berryIcon:setVisible(true)
            end

            if itemsDic.buyCount >= tonumber(itemsDic.buyLimit) then
                -- 已领取
                rewardItem:setVisible(false)
                rewardText:setVisible(false)
                alreadyBuy:setVisible(true)
            else
                -- 未领取
                rewardItem:setVisible(true)
                rewardText:setVisible(true)
                alreadyBuy:setVisible(false)
                -- local payCount = tonumber(itemsDic.payCost)
                -- local userOwner = 0
                -- if itemsDic.payType == "gold" then
                --     userOwner = userdata.gold
                -- else
                --     userOwner = userdata.berry
                -- end
                -- if payCount <= tonumber(userOwner) then
                --     rewardItem:setEnabled(true)
                -- else
                --     rewardItem:setEnabled(false)
                -- end
            end

            local contentLayer = tolua.cast(MysteryShopOwner["contentLayer"], "CCLayer")
            local bigSprite = tolua.cast(MysteryShopCellOwner["bigSprite"], "CCSprite")
            local chipIcon = tolua.cast(MysteryShopCellOwner["chip_icon"], "CCSprite")
            local littleSprite = tolua.cast(MysteryShopCellOwner["littleSprite"], "CCSprite")
            local soulIcon = tolua.cast(MysteryShopCellOwner["soulIcon"], "CCSprite")
            local countLabel = tolua.cast(MysteryShopCellOwner["countLabel"], "CCLabelTTF")
            local nameLabel = tolua.cast(MysteryShopCellOwner["nameLabel"], "CCLabelTTF")
            local shengyuCount = tolua.cast(MysteryShopCellOwner["shengyuCount"], "CCLabelTTF")
            shengyuCount:setString(itemsDic.buyLimit - itemsDic.buyCount)

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
            r = #itemsArray
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
                local downArrow = tolua.cast(MysteryShopOwner["downArrow"], "CCSprite") 
                local upArrow = tolua.cast(MysteryShopOwner["upArrow"], "CCSprite")  
                if  _tableView:getContentOffset().y >= 0 then
                    downArrow:setVisible(false)
                elseif _tableView:getContentOffset().y <= content:getContentSize().height - #itemsArray * 115 then
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

local function refreshItemCallBack(url, rtnData)
    if rtnData.code == 200 then
        itemsArray = dailyData:getMysteryShopAwardData()
        _shopData = dailyData:getMysteryShopData()
        if _shopData then
            if not _tableView then
                _addTableView()
            end
            _refreshData()
        else
            dailyData.daily[Daily_SecretShop] = nil
            getDailyLayer:refreshDailyLayer()
        end
        local offset = _tableView:getContentOffset().y
        _tableView:setContentOffset(ccp(0, offset))
    end
end

local function refreshItemClick( )
    if _shopData.refresh.free then
        local free = _shopData.refresh.free
        local charge = _shopData.refresh.charge
        local ownerCount = wareHouseData:getItemCountById(free.type)
        if ownerCount >= tonumber(free.amount) then
            doActionFun("DAILY_FLUSH_SECRETSHOP",{},refreshItemCallBack, errorCallback) 
        elseif charge.type == "gold" then
            if tonumber(charge.amount) <= userdata.gold then
                doActionFun("DAILY_FLUSH_SECRETSHOP",{},refreshItemCallBack, errorCallback) 
            else
                ShowText(HLNSLocalizedString("ERR_1101"))
            end
        else
            if tonumber(charge.amount) <= userdata.berry then
                doActionFun("DAILY_FLUSH_SECRETSHOP",{},refreshItemCallBack, errorCallback) 
            else
                ShowText(HLNSLocalizedString("ERR_1102"))
            end
        end
    else
        local charge = _shopData.refresh.charge
        if charge.type == "gold" then
            if tonumber(charge.amount) <= userdata.gold then
                doActionFun("DAILY_FLUSH_SECRETSHOP",{},refreshItemCallBack, errorCallback) 
            else
                ShowText(HLNSLocalizedString("ERR_1101"))
            end
        else
            if tonumber(charge.amount) <= userdata.berry then
                doActionFun("DAILY_FLUSH_SECRETSHOP",{},refreshItemCallBack, errorCallback) 
            else
                ShowText(HLNSLocalizedString("ERR_1102"))
            end
        end
    end
end

MysteryShopOwner["refreshItemClick"] = refreshItemClick

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/MysteryShopView.ccbi",proxy, true, "MysteryShopOwner")
    _layer = tolua.cast(node, "CCLayer")
end

-- 该方法名字每个文件不要重复
function getMysteryShopLayer()
    return _layer
end

function createMysterShopLayer()
    _priority = (priority ~= nil) and priority or -132
    _init()

    function _layer:getInfo()
        _getInfo()
    end
    
    function _layer:refresh()
        _refreshData()
    end

    local function _onEnter()
        addObserver(NOTI_MYSTERYSHOP, refreshTimeLabel)
        itemsArray = dailyData:getMysteryShopAwardData()
        _shopData = dailyData:getMysteryShopData()

        if _shopData then
            if not _tableView then
                _addTableView()
            end
            _refreshData()
        else
            dailyData.daily[Daily_SecretShop] = nil
            -- TODO 刷新dailylayer
            getDailyLayer:refreshDailyLayer()
        end
    end

    local function _onExit()
        _layer = nil
        _tableView = nil
        _bTableViewTouch = false
        _priority = nil
        removeObserver(NOTI_MYSTERYSHOP, refreshTimeLabel)
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