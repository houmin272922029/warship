local _layer
local _priority
local _itemId

-- 名字不要重复
ItemNotEnoughViewOwner = ItemNotEnoughViewOwner or {}
ccb["ItemNotEnoughViewOwner"] = ItemNotEnoughViewOwner

local function onPayTaped(  )
    popUpCloseAction( ItemNotEnoughViewOwner,"infoBg",_layer )
    if getMainLayer() then
        getMainLayer():goToLogue()
        getLogueTownLayer():gotoPageByType( 1 )
    end
end

ItemNotEnoughViewOwner["onPayTaped"] = onPayTaped

local function closeItemClick(  )
    popUpCloseAction( ItemNotEnoughViewOwner,"infoBg",_layer )
end 

ItemNotEnoughViewOwner["closeItemClick"] = closeItemClick

local function onCloseBtnTaped(  )
    popUpCloseAction( ItemNotEnoughViewOwner,"infoBg",_layer )
end 

ItemNotEnoughViewOwner["onCloseBtnTaped"] = onCloseBtnTaped

local function _refreshData(  )

    local topLabel = tolua.cast(ItemNotEnoughViewOwner["topLabel"],"CCLabelTTF")
    if _itemId == "item_007" then
        topLabel:setString(HLNSLocalizedString("chatview.gotoleague"))
    end
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/ItemNotEnouch.ccbi",proxy, true,"ItemNotEnoughViewOwner")
    _layer = tolua.cast(node,"CCLayer")
    _refreshData()
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(ItemNotEnoughViewOwner["infoBg"], "CCSprite")
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
    local menu1 = tolua.cast(ItemNotEnoughViewOwner["closeMenu"], "CCMenu")
    menu1:setHandlerPriority(_priority - 1)
end

-- 该方法名字每个文件不要重复
function getItemNotEnoughLayer()
	return _layer
end

function createItemNotEnoughLayer( itemId,priority )
    _itemId = itemId
    _priority = (priority ~= nil) and priority or -132
    _init()

    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
        popUpUiAction( ItemNotEnoughViewOwner,"infoBg" )
    end

    local function _onExit()
        _layer = nil
        _priority = -132
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