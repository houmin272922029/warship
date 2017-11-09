
local _layer
local _itemContent
local _priority = -132  

-- 名字不要重复
LogueVipDetailInfoOwner = LogueVipDetailInfoOwner or {}
ccb["LogueVipDetailInfoOwner"] = LogueVipDetailInfoOwner

local function buyVipBagCallBack( url,rtnData )
    if rtnData.code == 200 then
        giftBagData.vipCards = rtnData.info.vipCards
        if getGiftBagViewLayer() then
            getGiftBagViewLayer():refresh()
        end
        popUpCloseAction( LogueVipDetailInfoOwner,"infoBg",_layer )
    end
end

local function closerAction()
    popUpCloseAction( LogueVipDetailInfoOwner,"infoBg",_layer )
end
LogueVipDetailInfoOwner["closerAction"] = closerAction

local function buyaction()

    if _itemContent.vipLevel > vipdata:getVipLevel() then
        local function cardConfirmAction(  )
            CCDirector:sharedDirector():getRunningScene():addChild(createShopRechargeLayer(-400), 100)
        end
        local function cardCancelAction(  )
            
        end 
        local text = HLNSLocalizedString("船长，只有达到 VIP%s 才能购买此礼包，充值可享受贵族待遇，快去充值吧！",_itemContent.vipLevel)
        CCDirector:sharedDirector():getRunningScene():addChild(createSimpleConfirCardLayer(text), 100)
        SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
        SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction
        popUpCloseAction( LogueVipDetailInfoOwner,"infoBg",_layer )
    else
        doActionFun("BUY_VIPBAG_URL",{ _itemContent.item.id,"1" },buyVipBagCallBack)
    end
end

LogueVipDetailInfoOwner["buyaction"] = buyaction

local function closeItemClick()
    popUpCloseAction( LogueVipDetailInfoOwner,"infoBg",_layer )
end
LogueVipDetailInfoOwner["closeItemClick"] = closeItemClick


local function _updateLabelString(labelStr, string)
    print("labelStr",labelStr)
    local label = tolua.cast(LogueVipDetailInfoOwner[labelStr], "CCLabelTTF")
    label:setString(string)
    label:setVisible(true)
end


local function _refreshData()
    _updateLabelString("nameLabel", _itemContent.item.name)
    _updateLabelString("priceLabel",_itemContent.price.gold )

    local rankSprite = tolua.cast(LogueVipDetailInfoOwner["rankSprite"], "CCSprite")
    rankSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("rank_%s_icon.png", _itemContent.item.rank)))

    local itemBg = tolua.cast(LogueVipDetailInfoOwner["itemBg"], "CCSprite")
    itemBg:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("itemInfoBg_2_%d.png", _itemContent.item.rank)))

    -- 半身像
    -- local bustSpr = tolua.cast(LogueVipDetailInfoOwner["itemIcon"], "CCSprite")
    -- if dic.icon then
    --     if bustSpr then 
    --         local texture = CCTextureCache:sharedTextureCache():addImage(equipdata:getEquipIconByEquipId( dic.icon ))
    --         if texture then
    --             bustSpr:setTexture(texture)
    --         end     
    --     end 
    -- end

    -- 简介
    local desp = tolua.cast(LogueVipDetailInfoOwner["despLabel"], "CCLabelTTF")
    if desp then
        desp:setString(_itemContent.item.desp)
    end 
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/LogueVipDetailView.ccbi", proxy, true,"LogueVipDetailInfoOwner")
    _layer = tolua.cast(node,"CCLayer")

    _refreshData()
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(LogueVipDetailInfoOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction( LogueVipDetailInfoOwner,"infoBg",_layer )
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
    local menu1 = tolua.cast(LogueVipDetailInfoOwner["menu"], "CCMenu")
    menu1:setHandlerPriority(_priority-1)
end

-- 该方法名字每个文件不要重复
function getLogueVipDetailInfoLayer()
	return _layer
end

function createLogueVipDetailInfoLayer(itemContent, priority )
    _itemContent = itemContent
    _priority = (priority ~= nil) and priority or -132
    _init()

    local function _onEnter()
        print("onEnter")
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)

        popUpUiAction( LogueVipDetailInfoOwner,"infoBg" )
    end

    local function _onExit()
        print("onExit")
        _layer = nil
        _itemContent = nil
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