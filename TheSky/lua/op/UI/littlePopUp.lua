local _layer
local _priority

-- 名字不要重复
LittlePopUpViewOwner = LittlePopUpViewOwner or {}
ccb["LittlePopUpViewOwner"] = LittlePopUpViewOwner

local function onPayTaped(  )
    popUpCloseAction( LittlePopUpViewOwner,"infoBg",_layer )
    if getMainLayer() then
        getMainLayer():addChild(createShopRechargeLayer(-140))
    end
end

LittlePopUpViewOwner["onPayTaped"] = onPayTaped

local function closeItemClick(  )
    popUpCloseAction( LittlePopUpViewOwner,"infoBg",_layer ) 
end 

LittlePopUpViewOwner["closeItemClick"] = closeItemClick

local function onCloseBtnTaped(  )
    popUpCloseAction( LittlePopUpViewOwner,"infoBg",_layer )

end 

LittlePopUpViewOwner["onCloseBtnTaped"] = onCloseBtnTaped

local function _refreshData(  )

    local topLabel = tolua.cast(LittlePopUpViewOwner["topLabel"],"CCLabelTTF")
    print("走到这里了")
    topLabel:setString(HLNSLocalizedString("获得VIP %s，得到额外奖励次数",userdata:getVipLevel() >= 3 and (userdata:getVipLevel() + 1) or 3 ))
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/LittlePopUp.ccbi",proxy, true,"LittlePopUpViewOwner")
    _layer = tolua.cast(node,"CCLayer")
    _refreshData()
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(LittlePopUpViewOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction( LittlePopUpViewOwner,"infoBg",_layer )

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
    local menu1 = tolua.cast(LittlePopUpViewOwner["closeMenu"], "CCMenu")
    menu1:setHandlerPriority(_priority - 1)
end

-- 该方法名字每个文件不要重复
function getLittlePopUpLayer()
	return _layer
end

function createLittlePopUpLayer( priority)
    _priority = (priority ~= nil) and priority or -132
    _init()

    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)

        popUpUiAction( LittlePopUpViewOwner,"infoBg" )
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