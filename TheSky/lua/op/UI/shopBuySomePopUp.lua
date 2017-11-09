local _layer
local _priority
local _itemId
local count = 1
local dic


-- 名字不要重复
ShopBuySomeOwner = ShopBuySomeOwner or {}
ccb["ShopBuySomeOwner"] = ShopBuySomeOwner

local function closeItemClick(  )
    popUpCloseAction( ShopBuySomeOwner,"infoBg",_layer )
end

ShopBuySomeOwner["closeItemClick"] = closeItemClick

local function buyCallBack( url,rtnData )
    if rtnData.code == 200 then
        runtimeCache.buySuccessItemId = _itemId
        postNotification(NOTI_SHOP_BUY_SUCCESS, nil)
        popUpCloseAction( ShopBuySomeOwner,"infoBg",_layer )
    end
end

local function confirmBtnTaped(  )
    doActionFun("BUYITEM_URL", { _itemId,count}, buyCallBack)
end

ShopBuySomeOwner["confirmBtnTaped"] = confirmBtnTaped

local function ExitBtnTaped(  )
    _layer:removeFromParentAndCleanup(true) 
end

ShopBuySomeOwner["ExitBtnTaped"] = ExitBtnTaped

local function addBtnAction( tag,sender )
    print(tag)
    local canBuyCount = math.floor(userdata.gold / dic.price)
    local addBtn1 = tolua.cast(ShopBuySomeOwner["addBtn1"],"CCMenuItemImage")
    local addBtn2 = tolua.cast(ShopBuySomeOwner["addBtn2"],"CCMenuItemImage")
    local addBtn3 = tolua.cast(ShopBuySomeOwner["addBtn3"],"CCMenuItemImage")
    local addBtn4 = tolua.cast(ShopBuySomeOwner["addBtn4"],"CCMenuItemImage")
    local countLabel = tolua.cast(ShopBuySomeOwner["countLabel"],"CCLabelTTF")
    if tag == 0 then
        if count > 10 then
            count = count - 10 
        else
            count = 1
        end
    elseif tag == 1 then
        if count > 1 then
            count  = count - 1
        end
    elseif tag == 2 then
        if count + 1 <= canBuyCount then
            count = count + 1
        else
            count = canBuyCount
        end
    elseif tag == 3 then
        if count + 10 <= canBuyCount then
            count = count + 10
        else
            count = canBuyCount
        end
    end
    if count == 0 then
        count = 1
    end
    countLabel:setString(count)


    if itemId == "keybag_004" then--沉船宝箱
        Global:instance():TDGAonEventAndEventDataDictionary("pay",count)
    elseif itemId == "keybag_003" then
        Global:instance():TDGAonEventAndEventDataDictionary("pay2",count)
    elseif itemId == "keybag_002" then
        Global:instance():TDGAonEventAndEventDataDictionary("pay4",count)
    elseif itemId == "keybag_001" then
        Global:instance():TDGAonEventAndEventDataDictionary("pay5",count)
    elseif itemId == "bagkey_003" then
        Global:instance():TDGAonEventAndEventDataDictionary("pay3",count)
    elseif itemId == "bagkey_004" then
        Global:instance():TDGAonEventAndEventDataDictionary("pay1",count)
    elseif itemId == "item_009" then
        Global:instance():TDGAonEventAndEventDataDictionary("pay6",count)
    elseif itemId == "item_008" then
        Global:instance():TDGAonEventAndEventDataDictionary("pay7",count)
    elseif itemId == "item_005" then
        Global:instance():TDGAonEventAndEventDataDictionary("pay8",count)
    elseif itemId == "item_004" then
        Global:instance():TDGAonEventAndEventDataDictionary("pay9",count)
    elseif itemId == "item_003" then
        Global:instance():TDGAonEventAndEventDataDictionary("pay10",count)
    elseif itemId == "item_007" then
        Global:instance():TDGAonEventAndEventDataDictionary("pay11",count)
    end


    local priceLabel = tolua.cast(ShopBuySomeOwner["priceLabel"],"CCLabelTTF")
    priceLabel:setString(dic.price * count)
    if canBuyCount > 1 then
        if count > 1 and count < canBuyCount then
            addBtn1:setVisible(true)
            addBtn2:setVisible(true)
            addBtn3:setVisible(true)
            addBtn4:setVisible(true)
        elseif count == 1 then
            addBtn1:setVisible(false)
            addBtn2:setVisible(false)
            addBtn3:setVisible(true)
            addBtn4:setVisible(true)
        elseif count == canBuyCount then
            addBtn1:setVisible(true)
            addBtn2:setVisible(true)
            addBtn3:setVisible(false)
            addBtn4:setVisible(false)
        end
    elseif canBuyCount == 1 then
        addBtn1:setVisible(false)
        addBtn2:setVisible(false)
        addBtn3:setVisible(false)
        addBtn4:setVisible(false)
    end
end

ShopBuySomeOwner["addBtnAction"] = addBtnAction

local function _refreshData(  )
    dic = shopData:getItemByItemId( _itemId )
    local nameLabel = tolua.cast(ShopBuySomeOwner["nameLabel"],"CCLabelTTF")
    nameLabel:setString(HLNSLocalizedString("shopview.buyitemname",dic.item.name))

    local priceLabel = tolua.cast(ShopBuySomeOwner["priceLabel"],"CCLabelTTF")
    priceLabel:setString(dic.price * count)
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer

    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/ShopBuySomePopUp.ccbi",proxy, true,"ShopBuySomeOwner")
    _layer = tolua.cast(node,"CCLayer")
    _refreshData()
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(ShopBuySomeOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction( ShopBuySomeOwner,"infoBg",_layer )
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
    local menu1 = tolua.cast(ShopBuySomeOwner["closeMenu"], "CCMenu")
    menu1:setHandlerPriority(_priority - 1)
end

-- 该方法名字每个文件不要重复
function getShopBuySomeLayer()
	return _layer
end

function createShopBuySomeLayer( itemsId, priority)
    _itemId = itemsId
    _priority = (priority ~= nil) and priority or -132
    _init()

    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)

        popUpUiAction( ShopBuySomeOwner,"infoBg" )
    end

    local function _onExit()
        _layer = nil
        _priority = -132
        _itemId = nil
        count = 1
        dic = nil
    end

    --onEnter onExit
    local function _layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        end
    end


    _layer:registerScriptTouchHandler(onTouch ,false ,_priority ,true )
    _layer:setTouchEnabled(true)
    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end