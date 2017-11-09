local _layer
local _priority = -132
local _tableView
local _exchangeData
local _activityName
local resultContent = nil

-- 名字不要重复
ExchangeActivityPopUpOwner = ExchangeActivityPopUpOwner or {}
ccb["ExchangeActivityPopUpOwner"] = ExchangeActivityPopUpOwner

local function closeItemClick(  )
    -- _layer:removeFromParentAndCleanup(true)
    popUpCloseAction( ExchangeActivityPopUpOwner,"infoBg", _layer )
end

ExchangeActivityPopUpOwner["closeItemClick"] = closeItemClick

local function refreshTimeLabel(  )
    local timeLabel = tolua.cast(ExchangeActivityPopUpOwner["timeLabel"],"CCLabelTTF") 
    local time = loginActivityData:getExchangeTime( _activityName )
    if time <= 3600 then
        timeLabel:setString(DateUtil:second2ms(time))
        timeLabel:setFontSize(30)
    else
        timeLabel:setString(DateUtil:second2dhms(time))
    end
end

local function rewardCallBack( url,rtnData )
    if rtnData.code == 200 then
        loginActivityData:updataActiveDataByKeyAndDic( rtnData.info.frontPage )
        _exchangeData = loginActivityData:getExchangeData( _activityName )
        local offset = _tableView:getContentOffset().y
        _tableView:reloadData()
        _tableView:setContentOffset(ccp(0, offset))
        if getLoginActivityLayer(  ) then
            getLoginActivityLayer(  ):refresh()
        end
        -- getMainLayer():addChild(createExchangeSuccessLayer(resultContent),100) 
    end
end

local function _addTableView()
    -- 得到数据
    local tableViewLayer = ExchangeActivityPopUpOwner["tableLayer"]

    ExchangeActivityCellOwner = ExchangeActivityCellOwner or {}
    ccb["ExchangeActivityCellOwner"] = ExchangeActivityCellOwner

    local function onExchangeTaped( tag,sender )
        local itemContent = _exchangeData.content[tonumber(tag)]
        local uid = itemContent.uid
        resultContent = itemContent

        if itemContent.canExchange then
            if itemContent.limitType == 0 then
                -- 按天
                if itemContent.limitNum  == itemContent.numbers then
                    
                    ShowText(HLNSLocalizedString("exchange.giftTodayEnough"))
                    return
                end
            elseif itemContent.limitType == 1 then
                -- 按总次数
                if itemContent.limitNum  == itemContent.numbers then

                    ShowText(HLNSLocalizedString("exchange.giftAcitvityEnough"))
                    return
                end
            end
            doActionFun("EXCHANGE_REWARD", { uid }, rewardCallBack)
        else
            if itemContent.limitType == 0 then
                -- 按天
                if itemContent.limitNum  == itemContent.numbers then
                    
                    ShowText(HLNSLocalizedString("exchange.giftTodayEnough"))
                    return
                end
            elseif itemContent.limitType == 1 then
                -- 按总次数
                if itemContent.limitNum  == itemContent.numbers then

                    ShowText(HLNSLocalizedString("exchange.giftAcitvityEnough"))
                    return
                end
            end
            if itemContent.goldNotEnough then
                -- ShowText("金币不足")
                local function cardConfirmAction(  )
                    getMainLayer():addChild(createShopRechargeLayer(-400), 100)
                    -- _layer:removeFromParentAndCleanup(true)
                    popUpCloseAction( ExchangeActivityPopUpOwner,"infoBg", _layer )
                    if getLoginActivityLayer(  ) then
                        getLoginActivityLayer(  ):closeView()
                    end
                end
                local function cardCancelAction(  )
                    
                end
                local text = HLNSLocalizedString("exchange.goldnotenough")
                getMainLayer():getParent():addChild(createSimpleConfirCardLayer(text), 100)
                SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
                SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction
                return
            end
            if itemContent.itemNotEnough then
                -- ShowText("道具不足")
                local function cardConfirmAction(  )
                    if getMainLayer() then
                        getMainLayer():goToLogue()
                        if itemContent.notEnoughId == "item_101" then
                            getLogueTownLayer():gotoPageByType( 2 )
                        else
                            getLogueTownLayer():gotoPageByType( 1 )
                        end
                        -- _layer:removeFromParentAndCleanup(true)
                        popUpCloseAction( ExchangeActivityPopUpOwner,"infoBg", _layer )

                        if getLoginActivityLayer(  ) then
                            getLoginActivityLayer(  ):closeView()
                        end
                    end
                end
                local function cardCancelAction(  )
                    
                end
                local text
                if itemContent.notEnoughId == "item_101" then
                    text = HLNSLocalizedString("exchange.roseNOtenough",itemContent.notEnoughName)
                else
                    text = HLNSLocalizedString("exchange.itemNOtenough",itemContent.notEnoughName)
                end
                getMainLayer():getParent():addChild(createSimpleConfirCardLayer(text), 100)
                SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
                SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction
                return
            end
            if itemContent.shadowNotEnough then
                -- ShowText("金币不足")
                local function cardConfirmAction(  )
                    local _mainLayer = getMainLayer()
                    if _mainLayer then
                        _mainLayer:gotoTrainShadowView(0)
                    end
                    -- _layer:removeFromParentAndCleanup(true) 
                    popUpCloseAction( ExchangeActivityPopUpOwner,"infoBg", _layer )

                    if getLoginActivityLayer(  ) then
                        getLoginActivityLayer(  ):closeView()
                    end
                end
                local function cardCancelAction(  )
                    
                end
                local text = HLNSLocalizedString("exchange.shadownotenough",itemContent.shadowName)
                getMainLayer():getParent():addChild(createSimpleConfirCardLayer(text), 100)
                SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
                SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction
                return
            end
            if itemContent.heroNotEnough then
                local function cardConfirmAction(  )
                    if getMainLayer() then
                        getMainLayer():goToLogue()
                        getLogueTownLayer():gotoPageByType( 0 )
                        -- _layer:removeFromParentAndCleanup(true)
                        popUpCloseAction( ExchangeActivityPopUpOwner,"infoBg", _layer )
                        
                        if getLoginActivityLayer(  ) then
                            getLoginActivityLayer(  ):closeView()
                        end
                    end
                end
                local function cardCancelAction(  )
                    
                end
                local text = HLNSLocalizedString("exchange.heronotenough",itemContent.heroName)
                getMainLayer():getParent():addChild(createSimpleConfirCardLayer(text), 100)
                SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
                SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction
                return
            end
        end
    end

    ExchangeActivityCellOwner["onExchangeTaped"] = onExchangeTaped

    _exchangeData = loginActivityData:getExchangeData( _activityName )

    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(600 , 145)
        elseif fn == "cellAtIndex" then
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            --单条数据
            local itemContent = _exchangeData.content[a1 + 1]
            local  proxy = CCBProxy:create()
            local  _hbCell  = tolua.cast(CCBReaderLoad("ccbResources/ExchangeActivityCell.ccbi",proxy,true,"ExchangeActivityCellOwner"),"CCLayer")

            local menu1 = tolua.cast(ExchangeActivityCellOwner["menu"], "CCMenu")
            if menu1 then
                menu1:setTouchPriority(_priority - 2)
            end
            local exchangeBtn = tolua.cast(ExchangeActivityCellOwner["exchangeBtn"],"CCMenuItemImage")
            exchangeBtn:setTag(a1 + 1)
            if itemContent.canExchange then
                local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
                cache:addSpriteFramesWithFile("ccbResources/treasureCard.plist")
                local light = CCSprite:createWithSpriteFrameName("treasureCard_roundFrame_1.png")
                light:setScale(1.1)
                local animFrames = CCArray:create()
                for j = 1, 3 do
                    local frameName = string.format("treasureCard_roundFrame_%d.png",j)
                    local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(frameName)
                    animFrames:addObject(frame)
                end
                local animation = CCAnimation:createWithSpriteFrames(animFrames, 0.2)
                local animate = CCAnimate:create(animation)
                light:runAction(CCRepeatForever:create(animate))
                exchangeBtn:addChild(light)
                light:setPosition(ccp(exchangeBtn:getContentSize().width / 2,exchangeBtn:getContentSize().height / 2))
            end
            for i=1,4 do
                local cellContent
                local itemId
                -- 设置图片
                if i <= 3 then
                    cellContent = itemContent[tostring(i - 1)]
                    if cellContent then
                        itemId = cellContent.id
                    end
                else
                    cellContent = itemContent.gain 
                    if cellContent then
                        itemId = cellContent.id
                    end
                end

                local rankBtn = tolua.cast(ExchangeActivityCellOwner["rankBtn"..i],"CCMenuItemImage")
                local contentLayer = tolua.cast(ExchangeActivityCellOwner["contentLayer"..i],"CCLayer")
                local bigSprite = tolua.cast(ExchangeActivityCellOwner["bigSprite"..i],"CCSprite")
                local littleSprite = tolua.cast(ExchangeActivityCellOwner["littleSprite"..i],"CCSprite")
                local soulIcon = tolua.cast(ExchangeActivityCellOwner["soulIcon"..i],"CCSprite")
                local chip_icon = tolua.cast(ExchangeActivityCellOwner["chip_icon"..i],"CCSprite")
                local itemCountLabel = tolua.cast(ExchangeActivityCellOwner["itemCountLabel"..i],"CCLabelTTF")
                local nameLabel = tolua.cast(ExchangeActivityCellOwner["nameLabel"..i],"CCLabelTTF")
                chip_icon:setVisible(false)
                if cellContent then
                    if havePrefix(itemId, "weapon_") or havePrefix(itemId, "belt_") or havePrefix(itemId, "armor_") then
                        -- 装备
                        bigSprite:setVisible(true)
                        local texture
                        if haveSuffix(itemId, "_shard") then
                            texture = CCTextureCache:sharedTextureCache():addImage(string.format("ccbResources/icons/%s.png",cellContent.icon))
                        else
                            texture = CCTextureCache:sharedTextureCache():addImage(cellContent.icon)
                        end
                        if texture then
                            bigSprite:setVisible(true)
                            bigSprite:setTexture(texture)
                            if cellContent.rank == 4 then
                                HLAddParticleScale( "images/purpleEquip.plist", bigSprite, ccp(bigSprite:getContentSize().width / 2,bigSprite:getContentSize().height / 2), 1, 100, 777, 2 / 0.35 / retina, 2 / 0.35 / retina, 1 )
                            end
                        end
                        if haveSuffix(itemId, "_shard") then
                            chip_icon:setVisible(true)
                        end

                    elseif havePrefix(itemId, "item") then
                        -- 道具
                        bigSprite:setVisible(true)
                        local texture = CCTextureCache:sharedTextureCache():addImage(cellContent.icon)
                        if texture then
                            bigSprite:setVisible(true)
                            bigSprite:setTexture(texture)
                            if cellContent.rank == 4 then
                                HLAddParticleScale( "images/purpleEquip.plist", bigSprite, ccp(bigSprite:getContentSize().width / 2,bigSprite:getContentSize().height / 2), 1, 100, 777, 2 / 0.35 / retina, 2 / 0.35 / retina, 1 )
                            end
                        end
                    elseif havePrefix(itemId, "shadow") then
                        -- 影子
                        rankBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("s_frame.png"))
                        rankBtn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("s_frame.png"))

                        rankBtn:setPosition(ccp(rankBtn:getPositionX() + 5,rankBtn:getPositionY() - 5))
                        if cellContent.icon then
                            playCustomFrameAnimation( string.format("yingzi_%s_",cellContent.icon),contentLayer,ccp(contentLayer:getContentSize().width / 2,contentLayer:getContentSize().height / 2),1,4,shadowData:getColorByColorRank( cellContent.rank ) )
                        end
                    elseif havePrefix(itemId, "hero") then
                        -- 魂魄
                        littleSprite:setVisible(true)
                        littleSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(cellContent.icon))
    
                    elseif havePrefix(itemId, "book") then
                        -- 奥义
                        bigSprite:setVisible(true)
                        local texture = CCTextureCache:sharedTextureCache():addImage(cellContent.icon)
                        if texture then
                            bigSprite:setVisible(true)
                            bigSprite:setTexture(texture)
                            if cellContent.rank == 4 then
                                HLAddParticleScale( "images/purpleEquip.plist", bigSprite, ccp(bigSprite:getContentSize().width / 2,bigSprite:getContentSize().height / 2), 1, 100, 777, 2 / 0.35 / retina, 2 / 0.35 / retina, 1 )
                            end
                        end
                    else
                        -- 金币 银币
                        bigSprite:setVisible(true)
                        local texture = CCTextureCache:sharedTextureCache():addImage(cellContent.icon)
                        if texture then
                            bigSprite:setVisible(true)
                            bigSprite:setTexture(texture)
                        end
                    end
                    if not havePrefix(itemId, "shadow") then
                        rankBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", cellContent.rank)))
                        rankBtn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", cellContent.rank)))
                    end

                    -- 设置名字和数量

                    itemCountLabel:setString(cellContent.needCount)
                    if i <= 3 then
                        if tonumber(cellContent.needCount) > tonumber(cellContent.count) then
                            itemCountLabel:setColor(ccc3(255,0,0))
                        else
                            itemCountLabel:enableStroke(ccc3(0,0,0), 1)
                        end 
                    else 
                        itemCountLabel:enableStroke(ccc3(0,0,0), 1)
                    end
                    -- itemCountLabel:enableShadow(CCSizeMake(2,-2), 1, 0)
                    nameLabel:setString(cellContent.name)
                else
                    rankBtn:setVisible(false)
                    contentLayer:setVisible(false)
                    nameLabel:setVisible(false)
                end

            end

            -- 已兑换的次数
            local exchangeLimit = tolua.cast(ExchangeActivityCellOwner["exchangeLimit"],"CCLabelTTF")
            local str = itemContent.numbers.."/"..itemContent.limitNum
            if itemContent.numbers < itemContent.limitNum then
                exchangeLimit:setString(str)
            else
                exchangeLimit:setString(HLNSLocalizedString("已兑换"))
            end
            a2:addChild(_hbCell, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            r = a2
        elseif fn == "numberOfCells" then
            r = getMyTableCount(_exchangeData.content)
        elseif fn == "cellTouched" then         -- A cell was touched, a1 is cell that be touched. This is not necessary.
        elseif fn == "cellTouchBegan" then      -- A cell is touching, a1 is cell, a2 is CCTouch
        elseif fn == "cellTouchEnded" then      -- A cell was touched, a1 is cell, a2 is CCTouch
        elseif fn == "cellHighlight" then       -- A cell is highlighting, coco2d-x 2.1.3 or above
        elseif fn == "cellUnhighlight" then     -- A cell had been unhighlighted, coco2d-x 2.1.3 or above
        elseif fn == "cellWillRecycle" then     -- A cell will be recycled, coco2d-x 2.1.3 or above
        end
        return r
    end)
    local _mainLayer = getMainLayer()
    if _mainLayer then

        local size = CCSizeMake(tableViewLayer:getContentSize().width, tableViewLayer:getContentSize().height*99/100)  -- 这里是为了在tableview上面显示一个小空出来
        _tableView = LuaTableView:createWithHandler(h, size)
        _tableView:setBounceable(true)
        _tableView:setAnchorPoint(ccp(0,0))
        _tableView:setPosition(0,0)
        _tableView:setVerticalFillOrder(0)
        tableViewLayer:addChild(_tableView,1000)
    end
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/ExchangeActivityPopUp.ccbi", proxy, true,"ExchangeActivityPopUpOwner")
    _layer = tolua.cast(node,"CCLayer")

    local nameLabel = tolua.cast(ExchangeActivityPopUpOwner["activityLabel"],"CCLabelTTF")
    nameLabel:setString(loginActivityData:getExchangeName( _activityName ))
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(ExchangeActivityPopUpOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        -- _layer:removeFromParentAndCleanup(true)
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
    
    local menu1 = tolua.cast(ExchangeActivityPopUpOwner["menu"], "CCMenu")
    menu1:setTouchPriority(_priority - 2)
    
    -- local tableLayer = tolua.cast(ExchangeActivityPopUpOwner["tableLayer"], "CCLayer")
    -- tableLayer:setTouchPriority(_priority - 2)

    -- local sv = tolua.cast(_tableView, "LuaTableView") 
    -- sv:setTouchPriority(_priority - 2)

    _tableView:setTouchPriority(_priority - 2)
end

function getExchangeActivityLayer()
	return _layer
end

function setActitityTime(  )
    
end

function createExchangeActivityLayer(activityName, priority)
    _priority = (priority ~= nil) and priority or -132
    _activityName = activityName
    _init()

    function _layer:closeView(  )
        closeItemClick(  )
    end

    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
        
        popUpUiAction( ExchangeActivityPopUpOwner,"infoBg" )

        -- 设置活动时间倒计时
        refreshTimeLabel()
        _addTableView()
        addObserver(NOTI_REFLUSH_EXCHANGEACTIVITY_LAYER, refreshTimeLabel)
    end

    local function _onExit()
        _layer = nil
        _tableView = nil
        _priority = nil
        _exchangeData = nil
        resultContent = nil
        _activityName = nil
        removeObserver(NOTI_REFLUSH_EXCHANGEACTIVITY_LAYER, refreshTimeLabel)
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