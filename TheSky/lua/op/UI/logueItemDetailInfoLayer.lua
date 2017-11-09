
local _layer
local _itemId
local _priority = -132
local _uiType = 0      

-- 名字不要重复
LogueItemDetailInfoOwner = LogueItemDetailInfoOwner or {}
ccb["LogueItemDetailInfoOwner"] = LogueItemDetailInfoOwner

local function closerAction()
    popUpCloseAction( LogueItemDetailInfoOwner,"infoBg",_layer )
end
LogueItemDetailInfoOwner["closerAction"] = closerAction

local function buyaction()
    local itemId = _itemId
    local shopType = "goldShop"
    if getMainLayer() then
        getMainLayer():addChild(createShopBuySomeLayer(itemId,-140))
    end
    if _layer then
        _layer:removeFromParentAndCleanup(true)
    end
end

LogueItemDetailInfoOwner["buyaction"] = buyaction

local function closeItemClick()
    _layer:removeFromParentAndCleanup(true)
end
LogueItemDetailInfoOwner["closeItemClick"] = closeItemClick


local function _updateLabelString(labelStr, string)
    print("labelStr",labelStr)
    local label = tolua.cast(LogueItemDetailInfoOwner[labelStr], "CCLabelTTF")
    label:setString(string)
    label:setVisible(true)
end


local function _refreshData()
    local dic = wareHouseData:getItemConfig(_itemId)
    if dic == nil then
        return
    end
    _updateLabelString("nameLabel", dic.name)

    local rankSprite = tolua.cast(LogueItemDetailInfoOwner["rankSprite"], "CCSprite")
    rankSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("rank_%s_icon.png", dic.rank)))

    local itemBg = tolua.cast(LogueItemDetailInfoOwner["itemBg"], "CCSprite")
    itemBg:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("itemInfoBg_2_%d.png", dic.rank)))

    -- 半身像
    local bustSpr = tolua.cast(LogueItemDetailInfoOwner["itemIcon"], "CCSprite")
    if dic.icon then
        if bustSpr then 
            local texture = CCTextureCache:sharedTextureCache():addImage(equipdata:getEquipIconByEquipId( dic.icon ))
            if texture then
                bustSpr:setTexture(texture)
            end     
        end 
    end

    -- 简介
    local desp = tolua.cast(LogueItemDetailInfoOwner["despLabel"], "CCLabelTTF")
    if desp then
        desp:setString(dic.desp)
    end 

    local priceLabel = tolua.cast(LogueItemDetailInfoOwner["priceLabel"],"CCLabelTTF")
    priceLabel:setString(shopData:getItemPriceByItemId( dic.id ))
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/LogueItemDetailInfoView.ccbi", proxy, true,"LogueItemDetailInfoOwner")
    _layer = tolua.cast(node,"CCLayer")

    _refreshData()
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(LogueItemDetailInfoOwner["infoBg"], "CCSprite")
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
    local menu1 = tolua.cast(LogueItemDetailInfoOwner["menu"], "CCMenu")
    menu1:setHandlerPriority(_priority-1)
end

-- 该方法名字每个文件不要重复
function getLogueItemDetailInfoLayer()
	return _layer
end

function createLogueItemDetailInfoLayer(itemId, priority,uiType)
    _itemId = itemId
    _uiType = uiType
    _priority = (priority ~= nil) and priority or -132
    _init()

    local function _onEnter()
        print("onEnter")
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)

        popUpUiAction( LogueItemDetailInfoOwner,"infoBg" )
    end

    local function _onExit()
        print("onExit")
        _layer = nil
        _itemId = nil
        _uiType = 0
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