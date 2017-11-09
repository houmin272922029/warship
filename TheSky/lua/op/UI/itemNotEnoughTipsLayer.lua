local _layer
local _priority
local _itemId
local _title
local _tips

-- 名字不要重复
ItemNotEnoughTipsViewOwner = ItemNotEnoughTipsViewOwner or {}
ccb["ItemNotEnoughTipsViewOwner"] = ItemNotEnoughTipsViewOwner

local function onConfirmBtnTaped(  )
    local _scene = CCDirector:sharedDirector():getRunningScene()
    _scene:addChild(createShopBuySomeLayer(_itemId,-140),100)
    popUpCloseAction( ItemNotEnoughTipsViewOwner,"infoBg",_layer )
end

ItemNotEnoughTipsViewOwner["onConfirmBtnTaped"] = onConfirmBtnTaped

local function closeItemClick(  )
    popUpCloseAction( ItemNotEnoughTipsViewOwner,"infoBg",_layer )
end 

ItemNotEnoughTipsViewOwner["closeItemClick"] = closeItemClick

local function onCloseBtnTaped(  )
    popUpCloseAction( ItemNotEnoughTipsViewOwner,"infoBg",_layer ) 
end 

ItemNotEnoughTipsViewOwner["onCloseBtnTaped"] = onCloseBtnTaped

local function setLabelString( name,string )
    local Label = tolua.cast(ItemNotEnoughTipsViewOwner[name],"CCLabelTTF")
    Label:setString(string)
end

local function _refreshData(  )
    local itemContent = wareHouseData:getItemConfig(_itemId)
    setLabelString("titleLabel",_title)
    setLabelString("tipsLabel",_tips)
    setLabelString("itemName",itemContent.name)
    setLabelString("despLabel",itemContent.desp)
    setLabelString("priceLabel",shopData:getItemPriceByItemId( _itemId ))
    local rankSprite = tolua.cast(ItemNotEnoughTipsViewOwner["rankSprite"],"CCSprite")
    rankSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", itemContent.rank)))
    local avatarSprite = tolua.cast(ItemNotEnoughTipsViewOwner["avatarSprite"],"CCSprite")
    if avatarSprite then
        local texture = CCTextureCache:sharedTextureCache():addImage(equipdata:getEquipIconByEquipId( itemContent.id))
        if texture then
            avatarSprite:setVisible(true)
            avatarSprite:setTexture(texture)
        end
    end
end
-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/ItemNotEnoughPopUp.ccbi",proxy, true,"ItemNotEnoughTipsViewOwner")
    _layer = tolua.cast(node,"CCLayer")
    _refreshData()
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(ItemNotEnoughTipsViewOwner["infoBg"], "CCSprite")
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
    local menu1 = tolua.cast(ItemNotEnoughTipsViewOwner["closeMenu"], "CCMenu")
    menu1:setHandlerPriority(_priority - 1)
end

-- 该方法名字每个文件不要重复
function getItemNotEnoughTipsLayer()
	return _layer
end

function createItemNotEnoughTipsLayer( itemId,title,tips,priority )
    _itemId = itemId
    _title = title
    _tips = tips
    _priority = (priority ~= nil) and priority or -132
    _init()

    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)

        popUpUiAction( ItemNotEnoughTipsViewOwner,"infoBg" )
    end

    local function _onExit()
        _layer = nil
        _priority = -132
        _itemId = nil
        _tips = nil
        _title = nil
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