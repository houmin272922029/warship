local _layer
local _priority = -132
local _tableView
local _rebateData

-- 名字不要重复
PurchaseSingleRebateOwner = PurchaseSingleRebateOwner or {}
ccb["PurchaseSingleRebateOwner"] = PurchaseSingleRebateOwner

local function closeItemClick()
    -- _layer:removeFromParentAndCleanup(true)

    popUpCloseAction( PurchaseSingleRebateOwner,"infoBg",_layer )
end
PurchaseSingleRebateOwner["closeItemClick"] = closeItemClick

local function payItemClick()
    if getMainLayer() then
        getMainLayer():addChild(createShopRechargeLayer(-140), 1000)
    end
    closeItemClick()
    getLoginActivityLayer():closeView()
end
PurchaseSingleRebateOwner["payItemClick"] = payItemClick

local function helpItemClick()
    local desp = loginActivityData.activitys[Activity_Rebate4].description
    local array = {}
    for i=0,table.getTableCount(desp) - 1 do
        table.insert(array, desp[tostring(i)])
    end
    getMainLayer():getParent():addChild(createCommonHelpLayer(array, -140))
end
PurchaseSingleRebateOwner["helpItemClick"] = helpItemClick

local function refreshTimeLabel()
    local timerLabel = tolua.cast(PurchaseSingleRebateOwner["timerLabel"], "CCLabelTTF")
    local timer = loginActivityData:getPurchaseSingleRebateTimer()
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

local function getRewardCallback(url, rtnData) 
    loginActivityData.activitys[Activity_Rebate4] = rtnData.info.specificChangeReward
     _rebateData = loginActivityData:getPurchaseSingleRebateData()
    local offset = _tableView:getContentOffset().y
    _tableView:reloadData()
    _tableView:setContentOffset(ccp(0, offset))
    getLoginActivityLayer():refresh()
end

local function _addTableView()
    -- 得到数据
    _rebateData = loginActivityData:getPurchaseSingleRebateData()

    local content = PurchaseSingleRebateOwner["content"]

    PurchaseSingleRebateCellOwner = PurchaseSingleRebateCellOwner or {}
    ccb["PurchaseSingleRebateCellOwner"] = PurchaseSingleRebateCellOwner

    local function rewardItemClick(tag)
        print("rewardItemClick", tag)
        local dic = _rebateData[tag]
        doActionFun("SPECIFIC_CHARGE_REWARD", {dic.goldLimit}, getRewardCallback)
    end
    PurchaseSingleRebateCellOwner["rewardItemClick"] = rewardItemClick

    local function rebateItemClick(tag)
        print("rebateItemClick", tag)
        local dic = _rebateData[math.floor(tag / 100) + 1]

        local itemId = dic.reward[tag % 100].itemId
        local count = dic.reward[tag % 100].count

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
    PurchaseSingleRebateCellOwner["rebateItemClick"] = rebateItemClick

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
            local  _hbCell  = tolua.cast(CCBReaderLoad("ccbResources/PurchaseSingleRebateCell.ccbi",proxy,true,"PurchaseSingleRebateCellOwner"),"CCLayer")

            local function setCellMenuPriority(sender)
                if sender then
                    local menu = tolua.cast(sender, "CCMenu")
                    menu:setHandlerPriority(_priority - 1)
                end
            end

            local menu = PurchaseSingleRebateCellOwner["menu"]
            local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCCallFuncN:create(setCellMenuPriority))
            menu:runAction(seq)

            local dic = _rebateData[a1 + 1]
            local rewardItem = tolua.cast(PurchaseSingleRebateCellOwner["rewardItem"], "CCMenuItem")
            rewardItem:setTag(a1 + 1)
            local rewardText = tolua.cast(PurchaseSingleRebateCellOwner["rewardText"], "CCSprite")

            local tips1 = tolua.cast(PurchaseSingleRebateCellOwner["tips1"], "CCLabelTTF")
            tips1:setString(HLNSLocalizedString("purchaseSingleRebate.tips.1", dic.goldLimit, dic.status, dic.limitNum))

            local tips2 = tolua.cast(PurchaseSingleRebateCellOwner["tips2"], "CCLabelTTF")
            local canTake = dic.canTake - dic.status
            tips2:setString(string.format("×%d", canTake))
            if canTake <= 0 then
                rewardItem:setEnabled(false)
            end

            for i=1,4 do
                local rebateItem = tolua.cast(PurchaseSingleRebateCellOwner["rebateItem"..i], "CCMenuItemImage")
                rebateItem:setTag(a1 * 100 + i)

                local contentLayer = tolua.cast(PurchaseSingleRebateCellOwner["contentLayer"..i],"CCLayer")
                local bigSprite = tolua.cast(PurchaseSingleRebateCellOwner["bigSprite"..i],"CCSprite")
                local chipIcon = tolua.cast(PurchaseSingleRebateCellOwner["chipIcon"..i],"CCSprite")
                local littleSprite = tolua.cast(PurchaseSingleRebateCellOwner["littleSprite"..i],"CCSprite")
                local soulIcon = tolua.cast(PurchaseSingleRebateCellOwner["soulIcon"..i],"CCSprite")
                local countLabel = tolua.cast(PurchaseSingleRebateCellOwner["countLabel"..i],"CCLabelTTF")

                local itemDic = dic.reward[i]
                if itemDic then
                    local itemId = itemDic.itemId
                    local count = itemDic.count
                    contentLayer:setVisible(true)
                    rebateItem:setVisible(true)
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

                    countLabel:setString(count)
                else
                    contentLayer:setVisible(false)
                    rebateItem:setVisible(false)
                end
            end
            

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

    local title0 = tolua.cast(PurchaseSingleRebateOwner["title0"], "CCLabelTTF")
    local title1 = tolua.cast(PurchaseSingleRebateOwner["title1"], "CCLabelTTF")
    title0:setString(loginActivityData.activitys[Activity_Rebate4].name)
    title1:setString(loginActivityData.activitys[Activity_Rebate4].name)
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/PurchaseSingleRebateView.ccbi", proxy, true,"PurchaseSingleRebateOwner")
    _layer = tolua.cast(node,"CCLayer")

    local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
    cache:addSpriteFramesWithFile("ccbResources/shadow.plist")

    _refreshData()
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(PurchaseSingleRebateOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        -- _layer:removeFromParentAndCleanup(true)
        popUpCloseAction( PurchaseSingleRebateOwner,"infoBg", _layer )
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
    
    local menu = tolua.cast(PurchaseSingleRebateOwner["menu"], "CCMenu")
    menu:setTouchPriority(_priority - 2)

    _tableView:setTouchPriority(_priority - 2)
end

function getPurchaseSingleRebateLayer()
	return _layer
end

function createPurchaseSingleRebateLayer(priority)
    _priority = (priority ~= nil) and priority or -132
    _init()

    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)

        popUpUiAction( PurchaseSingleRebateOwner,"infoBg" )

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