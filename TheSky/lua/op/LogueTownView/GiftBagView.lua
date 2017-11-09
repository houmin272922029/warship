local _layer
local giftBagContent
local timeGiftContent = nil
local _tableView
local cellArray = {}

-- 名字不要重复
GiftBagViewOwner = GiftBagViewOwner or {}
ccb["GiftBagViewOwner"] = GiftBagViewOwner

local function buyVipBagCallBack( url,rtnData )
    if rtnData.code == 200 then
        giftBagData.vipCards = rtnData.info.vipCards
        giftBagContent = giftBagData:getShowGiftBags()
        _tableView:reloadData()
        postNotification(NOTI_VIP_PACKAGE_COUNT, nil)
    end
end

local function buyTimeBagCallBack( url,rtnData )
    if rtnData.code == 200 then
        giftBagData.timeGift = rtnData["info"]["timeGift"]
        giftBagContent = giftBagData:getShowGiftBags()
        timeGiftContent = giftBagData:getTimeGifts()
        _tableView:reloadData()
        postNotification(NOTI_VIP_PACKAGE_COUNT, nil)
    end
end

local function buyBtnTaped( tag,sender )
    local timeGiftCount = getMyTableCount(timeGiftContent)
    if timeGiftCount > 0 and tag <= timeGiftCount then
        local item = timeGiftContent[tag]
        doActionFun("BUY_TIMEGIFT_URL",{ item.id,"1" },buyTimeBagCallBack)
        return
    end
    local item = giftBagContent[tostring(tag - timeGiftCount)]
    if item.vipLevel > vipdata:getVipLevel() then
        local function cardConfirmAction(  )
        Global:instance():TDGAonEventAndEventData("box"..item.vipLevel)
            CCDirector:sharedDirector():getRunningScene():addChild(createShopRechargeLayer(-400), 100)
        end
        local function cardCancelAction(  )
            
        end 
        local text = HLNSLocalizedString("船长，只有达到 VIP%s 才能购买此礼包，充值可享受贵族待遇，快去充值吧！",item.vipLevel)
        _layer:addChild(createSimpleConfirCardLayer(text), 100)
        SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
        SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction
    else
        doActionFun("BUY_VIPBAG_URL",{ item.item.id,"1" },buyVipBagCallBack)
    end
end

local function onAvatarBtnTaped( tag,sender )
    local timeGiftCount = getMyTableCount(timeGiftContent)
    if timeGiftCount > 0 and tag <= timeGiftCount then
        local item = timeGiftContent[tag]
        local array = {}
        for k,v in pairs(item.rewards) do
            array[k] = v
        end
        getMainLayer():addChild(createVipPackageDetailLayer(array))
        return
    end
    local item = giftBagContent[tostring(tag - timeGiftCount)]
    local array = {}
    for k,v in pairs(item.item.params) do
        array[k] = v
    end
    getMainLayer():addChild(createVipPackageDetailLayer(array))
    -- getMainLayer():addChild(createLogueVipDetailInfoLayer(item,-140)) 
end

local function _addTableView()
    -- 得到数据
    giftBagContent = giftBagData:getShowGiftBags()
    timeGiftContent = giftBagData:getTimeGifts()
    -- giftBagData:getTimeGifts()
    -- local i = table.getTableCount(giftBagContent)

    local _topLayer = GiftBagViewOwner["titleLayer"]

    GiftBagTableCellOwner = GiftBagTableCellOwner or {}
    ccb["GiftBagTableCellOwner"] = GiftBagTableCellOwner

    GiftBagTableCellOwner["buyBtnTaped"] = buyBtnTaped 
    
    GiftBagTableCellOwner["onAvatarBtnTaped"] = onAvatarBtnTaped 
    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(winSize.width, 170 * retina)
        elseif fn == "cellAtIndex" then
            -- Return CCTableViewCell, a1 is cell index (zero based), a2 is dequeued cell (maybe nil)
            -- Do something to create cell  and change the content
            
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            --单条数据
            
            local  proxy = CCBProxy:create()
            local  _hbCell  = tolua.cast(CCBReaderLoad("ccbResources/GiftBagTableCell.ccbi",proxy,true,"GiftBagTableCellOwner"),"CCLayer")
            
            local timeGiftCount = getMyTableCount(timeGiftContent)
            if timeGiftCount > 0 and a1 + 1 <= timeGiftCount then

                local timeItem  = timeGiftContent[a1 + 1]
                if timeItem.moneyType == "silver" then                    
                    local priceLabelIcon = tolua.cast(GiftBagTableCellOwner["priceLabelIcon"],"CCSprite")                   
                    local showPriceIcon = tolua.cast(GiftBagTableCellOwner["showPriceIcon"],"CCSprite")
                    priceLabelIcon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("berry.png")))
                    showPriceIcon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("berry.png")))
                end
                local buyVipCard = tolua.cast(GiftBagTableCellOwner["buyVipCard"],"CCMenuItemImage")
                buyVipCard:setTag(a1 + 1)

                local avatarBtn = tolua.cast(GiftBagTableCellOwner["avatarBtn"],"CCMenuItemImage")
                avatarBtn:setTag(a1 + 1)
                avatarBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", 4)))
                avatarBtn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", 4)))

                local nameLabel = tolua.cast(GiftBagTableCellOwner["nameLabel"],"CCLabelTTF")
                nameLabel:setString(timeItem.name)

                local despLabel = tolua.cast(GiftBagTableCellOwner["despLabel"],"CCLabelTTF")
                despLabel:setString(timeItem.desp)

                local showPrice = tolua.cast(GiftBagTableCellOwner["showPrice"],"CCLabelTTF")
                showPrice:setString(timeItem.originPrice)

                local priceLabel = tolua.cast(GiftBagTableCellOwner["priceLabel"],"CCLabelTTF")
                priceLabel:setString(timeItem.nowPrice) 

                local timeStr = DateUtil:formatDateTime(timeItem.endTime)
                local timeLabel = tolua.cast(GiftBagTableCellOwner["timeLabel"],"CCLabelTTF")
                timeLabel:setVisible(true)
                timeLabel:setString(HLNSLocalizedString("活动结束时间：%s",timeStr))  

                local countLabel = tolua.cast(GiftBagTableCellOwner["countLabel"],"CCLabelTTF")
                if timeItem.limitAmount then
                    countLabel:setVisible(true)
                    countLabel:setString(HLNSLocalizedString("giftBag.totalAmount",timeItem.totalAmount))
                end
                -- renzhan newAdd
                if timeItem.buyTimes and timeItem.buyTimes == timeItem.myTimes then
                    local alreadyBuybg = tolua.cast(GiftBagTableCellOwner["alreadyBuybg"],"CCLabelTTF")
                    local alreadyBuy = tolua.cast(GiftBagTableCellOwner["alreadyBuy"],"CCLabelTTF")
                    alreadyBuybg:setVisible(true)
                    alreadyBuy:setVisible(true)
                    buyVipCard:setVisible(false)
                    local buyTitle = tolua.cast(GiftBagTableCellOwner["buyTitle"],"CCSprite")
                    buyTitle:setVisible(false)
                end
            end 
            if a1 + 1 > timeGiftCount then
                local item = giftBagContent[string.format("%d",a1 - timeGiftCount + 1)]
                local buyVipCard = tolua.cast(GiftBagTableCellOwner["buyVipCard"],"CCMenuItemImage")
                buyVipCard:setTag(a1 + 1)

                local avatarBtn = tolua.cast(GiftBagTableCellOwner["avatarBtn"],"CCMenuItemImage")
                avatarBtn:setTag(a1 + 1)
                avatarBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", item.item.rank)))
                avatarBtn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", item.item.rank)))

                local nameLabel = tolua.cast(GiftBagTableCellOwner["nameLabel"],"CCLabelTTF")
                nameLabel:setString(item.item.name)

                local despLabel = tolua.cast(GiftBagTableCellOwner["despLabel"],"CCLabelTTF")
                despLabel:setString(item.item.desp)

                local showPrice = tolua.cast(GiftBagTableCellOwner["showPrice"],"CCLabelTTF")
                showPrice:setString(item.specialPrice.gold)

                local priceLabel = tolua.cast(GiftBagTableCellOwner["priceLabel"],"CCLabelTTF")
                priceLabel:setString(item.price.gold)
            end
            
            _hbCell:setScale(retina)
            a2:addChild(_hbCell, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            _hbCell:stopAllActions()
            cellArray[tostring(a1)] = _hbCell
            r = a2
        elseif fn == "numberOfCells" then
            -- Return number of cells
            r = getMyTableCount(giftBagContent) + getMyTableCount(timeGiftContent)
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
    local contentBg = GiftBagViewOwner["contentBg"]
    local tableContentLayer = GiftBagViewOwner["tableContentLayer"]
    local _mainLayer = getMainLayer()
    if _mainLayer then
        local size = CCSizeMake(winSize.width, (winSize.height - _topLayer:getContentSize().height - _mainLayer:getBottomContentSize().height)*99/100)  -- 这里是为了在tableview上面显示一个小空出来
        _tableView = LuaTableView:createWithHandler(h, size)
        _tableView:setBounceable(true)
        _tableView:setAnchorPoint(ccp(0,0))
        _tableView:setPosition(0,_mainLayer:getBottomContentSize().height)
        _tableView:setVerticalFillOrder(0)
        
        _layer:addChild(_tableView)
    end
end
-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/GiftBagView.ccbi",proxy, true,"GiftBagViewOwner")
    _layer = tolua.cast(node,"CCLayer")
end


-- 该方法名字每个文件不要重复
function getGiftBagViewLayer()
	return _layer
end

function createGiftBagViewLayer()
    _init()

	-- public方法写在每个layer的创建的方法内 调用时方法
	-- local layer = getLayer()
	-- layer:refresh()

	function _layer:refresh()
		giftBagContent = giftBagData:getShowGiftBags()
        timeGiftContent = giftBagData:getTimeGifts()
        _tableView:reloadData()
	end

    local function _onEnter()
        print("onEnter")
        cellArray = {}
        _addTableView()
        generateCellAction( cellArray,getMyTableCount(giftBagContent) + getMyTableCount(timeGiftContent) )
        cellArray = {}
    end

    local function _onExit()
        print("onExit")
        _layer = nil
        giftBagContent = nil
        timeGiftContent = nil
        _tableView = nil
        cellArray = {}
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