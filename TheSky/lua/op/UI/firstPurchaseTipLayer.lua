local _layer
local _priority = -134
local _userDic
local _maxDic
-- 名字不要重复
FirstPurchaseTipsOwner = FirstPurchaseTipsOwner or {}
ccb["FirstPurchaseTipsOwner"] = FirstPurchaseTipsOwner


local function closeItemClick()
    popUpCloseAction( FirstPurchaseTipsOwner,"infoBg",_layer )
end
FirstPurchaseTipsOwner["closeItemClick"] = closeItemClick

local function userItemClick()
    if getShpRechargeLayer() then
        getShpRechargeLayer():thirdPlatformPayAction( _userDic )
    end
    popUpCloseAction( FirstPurchaseTipsOwner,"infoBg",_layer )
end
FirstPurchaseTipsOwner["userItemClick"] = userItemClick

local function maxItemClick()
    print("FirstPurchaseTipsOwner    ".._maxDic.itemId)
    if getShpRechargeLayer() then
        getShpRechargeLayer():thirdPlatformPayAction( _maxDic)
    end
    popUpCloseAction( FirstPurchaseTipsOwner,"infoBg",_layer )
end
FirstPurchaseTipsOwner["maxItemClick"] = maxItemClick

-- 刷新UI数据
local function _refreshData()
    local goldLabel = tolua.cast(FirstPurchaseTipsOwner["goldLabel"], "CCLabelTTF")
    goldLabel:setString(string.format(goldLabel:getString(), userdata:getFirstAwardGoldMult()))
    local tipsLabel = tolua.cast(FirstPurchaseTipsOwner["tipsLabel"], "CCLabelTTF")
    tipsLabel:setString(string.format(tipsLabel:getString(), _maxDic.price.cash, (_maxDic.gold + _maxDic.sendAmount) * userdata:getFirstAwardGoldMult()))
    local userLabel = tolua.cast(FirstPurchaseTipsOwner["userLabel"], "CCLabelTTF")
    userLabel:setString(string.format(userLabel:getString(), _userDic.price.cash))
    local maxLabel = tolua.cast(FirstPurchaseTipsOwner["maxLabel"], "CCLabelTTF")
    maxLabel:setString(string.format(maxLabel:getString(), _maxDic.price.cash))
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/FirstPurchaseTipsView.ccbi", proxy, true,"FirstPurchaseTipsOwner")
    _layer = tolua.cast(node,"CCLayer")
    _refreshData()
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(FirstPurchaseTipsOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction( FirstPurchaseTipsOwner,"infoBg",_layer )
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
    local menu = tolua.cast(FirstPurchaseTipsOwner["menu"], "CCMenu")
    menu:setHandlerPriority(_priority - 1)
end

-- 该方法名字每个文件不要重复
function getFirstPurchaseTipsLayer()
	return _layer
end

function createFirstPurchaseTipsLayer(userDic, maxDic, priority)
    _userDic = userDic
    _maxDic = maxDic
    _priority = (priority ~= nil) and priority or -134
    _init()



    local function _onEnter()
        print("onEnter")
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)

        popUpUiAction( FirstPurchaseTipsOwner,"infoBg" )
    end

    local function _onExit()
        print("onExit")
        _layer = nil
        _priority = -134
        _userDic = nil
        _maxDic = nil
    end

    --onEnter onExit
    local function _layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        end
    end


    _layer:registerScriptTouchHandler(onTouch, false, _priority ,true )
    _layer:setTouchEnabled(true)
    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end