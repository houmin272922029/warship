local _layer
local vipShopContent
local _tableView
local cellArray = {}

-- 名字不要重复
VipShopViewOwner = VipShopViewOwner or {}
ccb["VipShopViewOwner"] = VipShopViewOwner

local function buyTimeBagCallBack( url,rtnData )
    if rtnData.code == 200 then
        VipShopData:fromDic(rtnData["info"]["vipShopInfo"])
        vipShopContent = VipShopData:gdata()
        _layer:refresh()
    end
end

local function buyBtnTaped( tag,sender )
    tag = tag - 100 + 1 
    local vipGiftCount = getMyTableCount(vipShopContent)
    
    local item = vipShopContent[tag]
    PrintTable(vipdata:getVipLevel())
    if item.limitVIP > vipdata:getVipLevel() then
        local function cardConfirmAction()
        Global:instance():TDGAonEventAndEventData("box"..item.limitVIP)
            CCDirector:sharedDirector():getRunningScene():addChild(createShopRechargeLayer(-400), 100)
        end
       
        local function cardCancelAction()
        end 

        local text = HLNSLocalizedString("船长，只有达到 VIP%s 才能购买此礼包，充值可享受贵族待遇，快去充值吧！",item.limitVIP)
        _layer:addChild(createSimpleConfirCardLayer(text), 100)
        SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
        SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction
    else
        if vipGiftCount > 0 and tag <= vipGiftCount then
            local item = vipShopContent[(tag)]
            doActionFun("VIP_SHOPBUY_URL",{ item.ID,"1" },buyTimeBagCallBack)
        end
    end
end

local function _addTableView()
    -- 得到数据
    vipShopContent = VipShopData:gdata()
    local _topLayer = VipShopViewOwner["titleLayer"]
    GiftBagTableCellOwner = GiftBagTableCellOwner or {}
    ccb["GiftBagTableCellOwner"] = GiftBagTableCellOwner

    local function onAvatarBtnTaped(tag,sender)
        getMainLayer():addChild(createVipPackageDetailLayer(vipShopContent[tonumber(tag)].Content))
    end
    
    GiftBagTableCellOwner["onAvatarBtnTaped"] = onAvatarBtnTaped
    GiftBagTableCellOwner["buyBtnTaped"] = buyBtnTaped
    
    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(winSize.width, 170 * retina)
        elseif fn == "cellAtIndex" then
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else
                a2 = CCTableViewCell:create()
            end
            local item = vipShopContent[a1 + 1]
            local proxy = CCBProxy:create()
            local _hbCell = tolua.cast(CCBReaderLoad("ccbResources/GiftBagTableCell.ccbi",proxy,true,"GiftBagTableCellOwner"),"CCLayer")
            local btn = tolua.cast(GiftBagTableCellOwner["buyVipCard"],"CCMenuItemImage")
            btn:setTag(a1 + 100)

            local avatarBtn = tolua.cast(GiftBagTableCellOwner["avatarBtn"],"CCMenuItemImage")
                avatarBtn:setTag(a1 + 1)
                avatarBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", 4)))
                avatarBtn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", 4)))
            
            local nameLabel = tolua.cast(GiftBagTableCellOwner["nameLabel"],"CCLabelTTF")
                nameLabel:setString(item.Name)
            local despLabel = tolua.cast(GiftBagTableCellOwner["despLabel"],"CCLabelTTF")
                despLabel:setString(item.Descript)
            local showPrice = tolua.cast(GiftBagTableCellOwner["showPrice"],"CCLabelTTF")
                showPrice:setString(item.Ordin_price)
            local priceLabel = tolua.cast(GiftBagTableCellOwner["priceLabel"],"CCLabelTTF")
                priceLabel:setString(item.Espec_price)
            local limitTimesLabel = tolua.cast(GiftBagTableCellOwner["limitTimesLabel"],"CCLabelTTF")
                limitTimesLabel:setVisible(true)
                limitTimesLabel:setString(HLNSLocalizedString("vipshop.limitTimesByWeek", item.canBuyNum))

            _hbCell:setScale(retina)
            a2:addChild(_hbCell, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            _hbCell:stopAllActions()
            cellArray[tostring(a1)] = _hbCell
            r = a2
        elseif fn == "numberOfCells" then
            -- Return number of cells
            r = getMyTableCount(vipShopContent)
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
    local contentBg = VipShopViewOwner["contentBg"]
    local tableContentLayer = VipShopViewOwner["tableContentLayer"]
    local _mainLayer = getMainLayer()
    if _mainLayer then
        local size = CCSizeMake(winSize.width, (winSize.height - _topLayer:getContentSize().height - _mainLayer:getBottomContentSize().height)*99/100)
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
    local  node  = CCBReaderLoad("ccbResources/GiftBagView.ccbi", proxy, true, "VipShopViewOwner")
    _layer = tolua.cast(node,"CCLayer")
end

local function refresh(  )
    vipShopContent = VipShopData:gdata()
    local ffsetY = _tableView:getContentOffset().y
    _tableView:reloadData()
    _tableView:setContentOffset(ccp(0, -ffsetY))
end

-- 该方法名字每个文件不要重复
function getVipGiftBagViewLayer()
	return _layer
end

function createVipGiftBagViewLayer()
    _init()

	-- public方法写在每个layer的创建的方法内 调用时方法
	-- local layer = getLayer()
	-- layer:refresh()

	function _layer:refresh()
        vipShopContent = VipShopData:gdata()
        _tableView:reloadData()
	end

    local function _onEnter()
        print("vipshop onEnter")
        cellArray = {}
        _addTableView()
        vipShopContent = VipShopData:gdata()
        generateCellAction( cellArray,getMyTableCount(vipShopContent))
        cellArray = {}
    end

    local function _onExit()
        print("onExit")
        _layer = nil
        vipShopContent = nil
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