local _layer
local _priority = -150
local _title
local _itemId

-- 名字不要重复
BuyAndUseOwner = BuyAndUseOwner or {}
ccb["BuyAndUseOwner"] = BuyAndUseOwner

local function close()
    getArenaLayer():updateArena()

    popUpCloseAction( BuyAndUseOwner,"infoBg",_layer )
    -- _layer:removeFromParentAndCleanup(true)
end

local function closeItemClick()
    close()
end
BuyAndUseOwner["closeItemClick"] = closeItemClick

local function buyCallback(url, rtnData)
    close()
end

local function buyClick()
    doActionFun("BUY_AND_USE", {_itemId, 1}, buyCallback)
end
BuyAndUseOwner["buyClick"] = buyClick

-- 刷新UI数据
local function _refreshData()
    local titleLabel = tolua.cast(BuyAndUseOwner["titleLabel"], "CCLabelTTF")
    titleLabel:setString(_title)
    local conf = wareHouseData:getItemConfig(_itemId)
    local res = wareHouseData:getItemResource(_itemId)
    local frame = tolua.cast(BuyAndUseOwner["frame"], "CCSprite")
    frame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", conf.rank)))
    local icon = tolua.cast(BuyAndUseOwner["icon"], "CCSprite")
    local texture = CCTextureCache:sharedTextureCache():addImage(res.icon)
    if texture then
        icon:setTexture(texture)
    else
        icon:setVisible(false)
    end
    local name = tolua.cast(BuyAndUseOwner["name"], "CCLabelTTF")
    name:setString(conf.name)
    local desp = tolua.cast(BuyAndUseOwner["desp"], "CCLabelTTF")
    desp:setString(conf.desp)
    local priceLabel = tolua.cast(BuyAndUseOwner["priceLabel"], "CCLabelTTF")
    priceLabel:setString(shopData:getItemPriceByItemId(_itemId))
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/BuyAndUseView.ccbi", proxy, true,"BuyAndUseOwner")
    _layer = tolua.cast(node,"CCLayer")
    _refreshData()
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(BuyAndUseOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        close()
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
    local menu = tolua.cast(BuyAndUseOwner["menu"], "CCMenu")
    menu:setHandlerPriority(_priority - 1)
end

-- 该方法名字每个文件不要重复
function getBuyAndUseLayer()
	return _layer
end
--  uitype 0：强化  1：更换装备   2：分享  array { heroid:herouid,pos:_pos}
function createBuyAndUseLayer(itemId, title, priority)
    _itemId = itemId
    _title = title
    _priority = (priority ~= nil) and priority or -150
    _init()

    local function _onEnter()
        print("onEnter")
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
        
        popUpUiAction( BuyAndUseOwner,"infoBg" )
    end

    local function _onExit()
        print("onExit")
        _layer = nil
        _priority = -150
        _title = nil
        _itemId = nil
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