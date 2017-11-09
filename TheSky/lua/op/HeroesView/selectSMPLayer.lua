local _layer
local _priority = -132

-- 名字不要重复
SelectSMPOwner = SelectSMPOwner or {}
ccb["SelectSMPOwner"] = SelectSMPOwner

local function closeItemClick()
    _layer:removeFromParentAndCleanup(true)
end
SelectSMPOwner["closeItemClick"] = closeItemClick

local function onUse1Clicked()
    print("onUse1Clicked")
    setSMPType(1)
    _layer:removeFromParentAndCleanup(true)
end
SelectSMPOwner["onUse1Clicked"] = onUse1Clicked

-- 购买稀有生命牌
local function onBuy1Clicked()
    print("onBuy1Clicked")
    if getMainLayer() then
        getMainLayer():addChild(createShopBuySomeLayer("item_009", -136))
    end
end
SelectSMPOwner["onBuy1Clicked"] = onBuy1Clicked

local function onUse2Clicked()
    print("onUse2Clicked")
    setSMPType(0)
    _layer:removeFromParentAndCleanup(true)
end
SelectSMPOwner["onUse2Clicked"] = onUse2Clicked

-- 购买普通生命牌
local function onBuy2Clicked()
    print("onBuy2Clicked")
    if getMainLayer() then
        getMainLayer():addChild(createShopBuySomeLayer("item_008", -136))
    end
end
SelectSMPOwner["onBuy2Clicked"] = onBuy2Clicked

local function _refreshUI()
    local conf1 = wareHouseData:getItemConfig("item_009")
    local conf2 = wareHouseData:getItemConfig("item_008")

    local useBtn1 = tolua.cast(SelectSMPOwner["useBtn1"], "CCMenuItemImage")
    local buyBtn1 = tolua.cast(SelectSMPOwner["buyBtn1"], "CCMenuItemImage")
    local useBtn2 = tolua.cast(SelectSMPOwner["useBtn2"], "CCMenuItemImage")
    local buyBtn2 = tolua.cast(SelectSMPOwner["buyBtn2"], "CCMenuItemImage")
    local useLabel1 = tolua.cast(SelectSMPOwner["useLabel1"], "CCLabelTTF")
    local buyLabel1 = tolua.cast(SelectSMPOwner["buyLabel1"], "CCLabelTTF")
    local useLabel2 = tolua.cast(SelectSMPOwner["useLabel2"], "CCLabelTTF")
    local buyLabel2 = tolua.cast(SelectSMPOwner["buyLabel2"], "CCLabelTTF")
    useBtn1:setVisible(false)
    buyBtn1:setVisible(false)
    useBtn2:setVisible(false)
    buyBtn2:setVisible(false)
    useLabel1:setVisible(false)
    buyLabel1:setVisible(false)
    useLabel2:setVisible(false)
    buyLabel2:setVisible(false)

    local priceLabel1 = tolua.cast(SelectSMPOwner["priceLabel1"], "CCLabelTTF")
    local price1 = tolua.cast(SelectSMPOwner["price1"], "CCLabelTTF")
    local amountLabel1 = tolua.cast(SelectSMPOwner["amountLabel1"], "CCLabelTTF")
    local amount1 = tolua.cast(SelectSMPOwner["amount1"], "CCLabelTTF")
    local gold1 = tolua.cast(SelectSMPOwner["gold1"], "CCSprite")
    local priceLabel2 = tolua.cast(SelectSMPOwner["priceLabel2"], "CCLabelTTF")
    local price2 = tolua.cast(SelectSMPOwner["price2"], "CCLabelTTF")
    local amountLabel2 = tolua.cast(SelectSMPOwner["amountLabel2"], "CCLabelTTF")
    local amount2 = tolua.cast(SelectSMPOwner["amount2"], "CCLabelTTF")
    local gold2 = tolua.cast(SelectSMPOwner["gold2"], "CCSprite")
    priceLabel1:setVisible(false)
    price1:setVisible(false)
    amountLabel1:setVisible(false)
    amount1:setVisible(false)
    gold1:setVisible(false)
    priceLabel2:setVisible(false)
    price2:setVisible(false)
    amountLabel2:setVisible(false)
    amount2:setVisible(false)
    gold2:setVisible(false)

    local item1Amount = wareHouseData:getItemCount("item_009")            -- 稀有生命牌
    local item2Amount = wareHouseData:getItemCount("item_008")            -- 普通生命牌
    if item1Amount <= 0 then
        buyBtn1:setVisible(true)
        buyLabel1:setVisible(true)
        priceLabel1:setVisible(true)
        price1:setVisible(true)
        gold1:setVisible(true)
        price1:setString(shopData:getItemPriceByItemId( "item_009" ))
    else 
        useBtn1:setVisible(true)
        useLabel1:setVisible(true)
        amountLabel1:setVisible(true)
        amount1:setVisible(true)
        amount1:setString(item1Amount)
    end 
    if item2Amount <= 0 then
        buyBtn2:setVisible(true)
        buyLabel2:setVisible(true)
        priceLabel2:setVisible(true)
        price2:setVisible(true)
        gold2:setVisible(true)
        price2:setString(shopData:getItemPriceByItemId( "item_008" ))
    else 
        useBtn2:setVisible(true)
        useLabel2:setVisible(true)
        amountLabel2:setVisible(true)
        amount2:setVisible(true)
        amount2:setString(item2Amount)
    end 

    tolua.cast(SelectSMPOwner["name1"], "CCLabelTTF"):setString(conf1.name)
    tolua.cast(SelectSMPOwner["desp1"], "CCLabelTTF"):setString(conf1.desp)
    tolua.cast(SelectSMPOwner["name2"], "CCLabelTTF"):setString(conf2.name)
    tolua.cast(SelectSMPOwner["desp2"], "CCLabelTTF"):setString(conf2.desp)
end 

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/SelectSMPView.ccbi", proxy, true,"SelectSMPOwner")
    _layer = tolua.cast(node,"CCLayer")

    _refreshUI()
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(SelectSMPOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        _layer:removeFromParentAndCleanup(true)
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
    local menu1 = tolua.cast(SelectSMPOwner["menu"], "CCMenu")
    menu1:setHandlerPriority(_priority-1)
end

-- 该方法名字每个文件不要重复
function getSelectSMPLayer()
	return _layer
end

function createSelectSMPLayer(priority)
    _priority = (priority ~= nil) and priority or -132
    _init()

    local function _onEnter()
        print("onEnter")
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)

        addObserver(NOTI_SHOP_BUY_SUCCESS, _refreshUI)
    end

    local function _onExit()
        print("onExit")
        _layer = nil
        _priority = -132

        removeObserver(NOTI_SHOP_BUY_SUCCESS, _refreshUI)
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