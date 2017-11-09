local _layer
local _priority = -132
local _tableView
local _rebateData

-- 名字不要重复
PurchaseRebateOwner = PurchaseRebateOwner or {}
ccb["PurchaseRebateOwner"] = PurchaseRebateOwner

local function closeItemClick()
    -- _layer:removeFromParentAndCleanup(true)

    popUpCloseAction( PurchaseRebateOwner,"infoBg",_layer )
end
PurchaseRebateOwner["closeItemClick"] = closeItemClick

local function payItemClick()
    if getMainLayer() then
        getMainLayer():addChild(createShopRechargeLayer(-140), 1000)
    end
    closeItemClick()
    getLoginActivityLayer():closeView()
end
PurchaseRebateOwner["payItemClick"] = payItemClick

local function helpItemClick()
    local desp = loginActivityData.activitys[Activity_Rebate1].description
    local array = {}
    for i=0,table.getTableCount(desp) - 1 do
        table.insert(array, desp[tostring(i)])
    end
    getMainLayer():getParent():addChild(createCommonHelpLayer(array, -140))
end
PurchaseRebateOwner["helpItemClick"] = helpItemClick

local function refreshTimeLabel()
    local timerLabel = tolua.cast(PurchaseRebateOwner["timerLabel"], "CCLabelTTF")
    local timer = loginActivityData:getPurchaseRebateTimer()
    if timer == 0 then
        closeItemClick()
        getLoginActivityLayer():closeView()
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

local function costRefundCallback(url, rtnData) 
    loginActivityData.activitys[Activity_Rebate1] = rtnData.info.costRefund
     _rebateData = loginActivityData:getPurchaseRebateData()
    local offset = _tableView:getContentOffset().y
    _tableView:reloadData()
    _tableView:setContentOffset(ccp(0, offset))
end

local function _addTableView()
    -- 得到数据
    _rebateData = loginActivityData:getPurchaseRebateData()

    local content = PurchaseRebateOwner["content"]

    PurchaseRebateCellOwner = PurchaseRebateCellOwner or {}
    ccb["PurchaseRebateCellOwner"] = PurchaseRebateCellOwner

    local function rewardItemClick(tag)
        print("rewardItemClick", tag)
        local dic = _rebateData[tag]
        doActionFun("COST_REFUND", {dic.key}, costRefundCallback)
    end
    PurchaseRebateCellOwner["rewardItemClick"] = rewardItemClick

    local function rebateItemClick(tag)
        print("rebateItemClick", tag)
        local dic = _rebateData[tag]
        local itemId
        local count
        for k,v in pairs(dic.reward) do
            itemId = k
            count = v
            break
        end
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
    PurchaseRebateCellOwner["rebateItemClick"] = rebateItemClick

    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(583, 175)
        elseif fn == "cellAtIndex" then
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            --单条数据
            local  proxy = CCBProxy:create()
            local  _hbCell  = tolua.cast(CCBReaderLoad("ccbResources/PurchaseRebateCell.ccbi",proxy,true,"PurchaseRebateCellOwner"),"CCLayer")

            local function setCellMenuPriority(sender)
                if sender then
                    local menu = tolua.cast(sender, "CCMenu")
                    menu:setHandlerPriority(_priority - 1)
                end
            end

            local menu = PurchaseRebateCellOwner["menu"]
            local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCCallFuncN:create(setCellMenuPriority))
            menu:runAction(seq)

            local dic = _rebateData[a1 + 1]
            local rewardItem = tolua.cast(PurchaseRebateCellOwner["rewardItem"], "CCMenuItem")
            rewardItem:setTag(a1 + 1)
            local rebateItem = tolua.cast(PurchaseRebateCellOwner["rebateItem"], "CCMenuItemImage")
            rebateItem:setTag(a1 + 1)
            local rewardText = tolua.cast(PurchaseRebateCellOwner["rewardText"], "CCSprite")

            local tips1 = tolua.cast(PurchaseRebateCellOwner["tips1"], "CCLabelTTF")
            local tips2 = tolua.cast(PurchaseRebateCellOwner["tips2"], "CCLabelTTF")
            tips2:setString(HLNSLocalizedString("purchaseRebate.tips.4", dic.goldLimit))

            if tonumber(dic.status) == 1 then
                -- 已领取
                rewardItem:setVisible(false)
                rewardText:setVisible(false)
                tips1:setString(HLNSLocalizedString("purchaseRebate.tips.3"))
            else
                -- 未领取
                rewardItem:setVisible(true)
                rewardText:setVisible(true)
                local gold = tonumber(loginActivityData.activitys[Activity_Rebate1].goldCharge)
                if gold >= tonumber(dic.goldLimit) then
                    rewardItem:setEnabled(true)
                    tips1:setString(HLNSLocalizedString("purchaseRebate.tips.2"))
                else
                    rewardItem:setEnabled(false)
                    tips1:setString(HLNSLocalizedString("purchaseRebate.tips.1", dic.goldLimit - gold))
                end
            end

            local contentLayer = tolua.cast(PurchaseRebateCellOwner["contentLayer"],"CCLayer")
            local bigSprite = tolua.cast(PurchaseRebateCellOwner["bigSprite"],"CCSprite")
            local chipIcon = tolua.cast(PurchaseRebateCellOwner["chipIcon"],"CCSprite")
            local littleSprite = tolua.cast(PurchaseRebateCellOwner["littleSprite"],"CCSprite")
            local soulIcon = tolua.cast(PurchaseRebateCellOwner["soulIcon"],"CCSprite")
            local countLabel = tolua.cast(PurchaseRebateCellOwner["countLabel"],"CCLabelTTF")
            local nameLabel = tolua.cast(PurchaseRebateCellOwner["nameLabel"],"CCLabelTTF")

            local itemId
            local count
            for k,v in pairs(dic.reward) do
                itemId = k
                count = v
                break
            end
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
                rebateItem:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("s_frame.png"))
                rebateItem:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("s_frame.png"))

                rebateItem:setPosition(ccp(rebateItem:getPositionX() + 5,rebateItem:getPositionY() - 5))
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
                rebateItem:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", resDic.rank)))
                rebateItem:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", resDic.rank)))
            end

            -- 设置名字和数量

            countLabel:setString(count)
            nameLabel:setString(resDic.name)

            a2:addChild(_hbCell, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            r = a2
        elseif fn == "numberOfCells" then
            r = #_rebateData
        elseif fn == "cellTouched" then         -- A cell was touched, a1 is cell that be touched. This is not necessary.
        elseif fn == "cellTouchBegan" then      -- A cell is touching, a1 is cell, a2 is CCTouch
        elseif fn == "cellTouchEnded" then      -- A cell was touched, a1 is cell, a2 is CCTouch
        elseif fn == "cellHighlight" then       -- A cell is highlighting, coco2d-x 2.1.3 or above
        elseif fn == "cellUnhighlight" then     -- A cell had been unhighlighted, coco2d-x 2.1.3 or above
        elseif fn == "cellWillRecycle" then     -- A cell will be recycled, coco2d-x 2.1.3 or above
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
    refreshTimeLabel()
    _addTableView()

    local purchaseLabel = tolua.cast(PurchaseRebateOwner["purchaseLabel"], "CCLabelTTF")
    purchaseLabel:setString(loginActivityData.activitys[Activity_Rebate1].goldCharge)

    local title0 = tolua.cast(PurchaseRebateOwner["title0"], "CCLabelTTF")
    local title1 = tolua.cast(PurchaseRebateOwner["title1"], "CCLabelTTF")
    title0:setString(loginActivityData.activitys[Activity_Rebate1].name)
    title1:setString(loginActivityData.activitys[Activity_Rebate1].name)
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/PurchaseRebateView.ccbi", proxy, true,"PurchaseRebateOwner")
    _layer = tolua.cast(node,"CCLayer")

    local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
    cache:addSpriteFramesWithFile("ccbResources/shadow.plist")

    _refreshData()
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(PurchaseRebateOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        -- _layer:removeFromParentAndCleanup(true)
        popUpCloseAction( PurchaseRebateOwner,"infoBg", _layer )
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
    
    local menu = tolua.cast(PurchaseRebateOwner["menu"], "CCMenu")
    menu:setTouchPriority(_priority - 2)

    _tableView:setTouchPriority(_priority - 2)
end

function getPurchaseRebateLayer()
	return _layer
end

function createPurchaseRebateLayer(priority)
    _priority = (priority ~= nil) and priority or -132
    _init()

    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
        
        -- local infoBg = tolua.cast(PurchaseRebateOwner["infoBg"], "CCSprite")
        -- infoBg:setScale(0.01)
        -- infoBg:runAction(CCEaseBounceOut:create(CCScaleTo:create(0.6, 1 * retina)))

        popUpUiAction( PurchaseRebateOwner,"infoBg" )

        -- 设置活动时间倒计时
        addObserver(NOTI_PURCHASEREBATE, refreshTimeLabel)
    end

    local function _onExit()
        _layer = nil
        _tableView = nil
        _priority = nil
        _rebateData = nil
        removeObserver(NOTI_PURCHASEREBATE, refreshTimeLabel)
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