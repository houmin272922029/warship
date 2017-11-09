local _layer
local _priority

-- 名字不要重复
SingSongNotEnoughViewOwner = SingSongNotEnoughViewOwner or {}
ccb["SingSongNotEnoughViewOwner"] = SingSongNotEnoughViewOwner

local function onPayTaped(  )
    popUpCloseAction( SingSongNotEnoughViewOwner,"infoBg",_layer )
    if getMainLayer() then
        getMainLayer():addChild(createShopRechargeLayer(-140))
    end
end

SingSongNotEnoughViewOwner["onPayTaped"] = onPayTaped

local function closeItemClick(  )
    popUpCloseAction( SingSongNotEnoughViewOwner,"infoBg",_layer )
end 

SingSongNotEnoughViewOwner["closeItemClick"] = closeItemClick

local function onCloseBtnTaped(  )
    popUpCloseAction( SingSongNotEnoughViewOwner,"infoBg",_layer ) 
end 

SingSongNotEnoughViewOwner["onCloseBtnTaped"] = onCloseBtnTaped

local function _refreshData(  )

    local topLabel = tolua.cast(SingSongNotEnoughViewOwner["topLabel"],"CCLabelTTF")
    if userdata:getVipLevel() < 13 then
        topLabel:setString(HLNSLocalizedString("今日对歌次数已经用完，成为 VIP%s 可以增加对歌 %s 次，快去充值享受更高级的贵族待遇吧！",userdata:getVipLevel() >= 3 and (userdata:getVipLevel() + 1) or 3 ,vipdata:getCanAddSingCount( userdata:getVipLevel() >= 3 and (userdata:getVipLevel() + 1) or 3 )))
    else
        topLabel:setString(HLNSLocalizedString("船长，布鲁克今日已经对唱得精疲力竭了，让他休息一夜，我们明天再来吧！"))
    end
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/SingSongNotEnouch.ccbi",proxy, true,"SingSongNotEnoughViewOwner")
    _layer = tolua.cast(node,"CCLayer")
    _refreshData()
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(SingSongNotEnoughViewOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction( SingSongNotEnoughViewOwner,"infoBg",_layer )
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
    local menu1 = tolua.cast(SingSongNotEnoughViewOwner["closeMenu"], "CCMenu")
    menu1:setHandlerPriority(_priority - 1)
end

-- 该方法名字每个文件不要重复
function getSingSongNotEnoughLayer()
	return _layer
end

function createSingSongNotEnoughLayer( priority)
    _priority = (priority ~= nil) and priority or -132
    _init()

    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)

        popUpUiAction( SingSongNotEnoughViewOwner,"infoBg" )
    end

    local function _onExit()
        _layer = nil
        _priority = -132
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