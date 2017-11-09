local _layer
local _uiType
local _priority = -134

-- 名字不要重复
RecoverOwner = RecoverOwner or {}
ccb["RecoverOwner"] = RecoverOwner

local function closeItemClick()
    popUpCloseAction( RecoverOwner,"infoBg",_layer )
end
RecoverOwner["closeItemClick"] = closeItemClick

local function gotoArenaClick()
    popUpCloseAction( RecoverOwner,"infoBg",_layer )
    if getMainLayer() then
        getMainLayer():gotoArena()
    end
end
RecoverOwner["gotoArenaClick"] = gotoArenaClick

local function gotoSailClick()
    popUpCloseAction( RecoverOwner,"infoBg",_layer )
    if getMainLayer() then
        getMainLayer():goToSail()
    end
end
RecoverOwner["gotoSailClick"] = gotoSailClick

local function recoverEnergyCallback(url, rtnData)
    userdata:recoverEnergySucc()
    popUpCloseAction( RecoverOwner,"infoBg",_layer )
end

local function recoverEnergyClick()
    local recoverTime = userdata:getRecoverEnergyTime()
    local recoverConfig = userdata:getRecoverConfig(recoverTime + 1)
    if recoverTime >= vipdata:recoverEnergyTimes(vipdata:getVipLevel()) then
        ShowText(HLNSLocalizedString("ERR_1107"))
        CCDirector:sharedDirector():getRunningScene():addChild(createShopRechargeLayer(-400), 100)
        popUpCloseAction( RecoverOwner,"infoBg",_layer )
    else
        doActionFun("RECOVER_ENERGY",{}, recoverEnergyCallback)
    end
end
RecoverOwner["recoverEnergyClick"] = recoverEnergyClick

local function recoverStrengthCallback(url, rtnData)
     userdata:recoverStrengthSucc()
     postNotification(NOTI_SAIL_SWEEP_FINISH, nil)
     popUpCloseAction( RecoverOwner,"infoBg",_layer )
end

local function recoverStrengthClick()
    local recoverTime = userdata:getRecoverStrengthTime()
    local recoverConfig = userdata:getRecoverConfig(recoverTime + 1)
    if recoverTime >= vipdata:recoverStrengthTimes(vipdata:getVipLevel()) then
        ShowText(HLNSLocalizedString("ERR_1107"))
        CCDirector:sharedDirector():getRunningScene():addChild(createShopRechargeLayer(-400), 100)
        popUpCloseAction( RecoverOwner,"infoBg",_layer )
    else
        doActionFun("RECOVER_STRENGTH",{}, recoverStrengthCallback)
    end
end
RecoverOwner["recoverStrengthClick"] = recoverStrengthClick

-- 刷新UI数据
local function _refreshData()
    if _uiType == 0 then
        -- 体力不足
        local strengthLayer = tolua.cast(RecoverOwner["strengthLayer"], "CCLayer")
        strengthLayer:setVisible(true)
        local strengthMenu = tolua.cast(RecoverOwner["strengthMenu"], "CCMenu")
        strengthMenu:setVisible(true)
        local strengthSay = tolua.cast(RecoverOwner["strengthSay"], "CCLabelTTF")
        local recoverTime = userdata:getRecoverStrengthTime()
        local recoverConfig = userdata:getRecoverConfig(recoverTime + 1)
        strengthSay:setString(string.format(strengthSay:getString(), recoverConfig.strength_add))
        local strengthTips = tolua.cast(RecoverOwner["strengthTips"], "CCLabelTTF")
        strengthTips:setString(string.format(strengthTips:getString(), recoverTime, vipdata:recoverStrengthTimes(vipdata:getVipLevel()), vipdata:getNextRecoverStrengthLevel()))
        local strengthPrice = tolua.cast(RecoverOwner["strengthPrice"], "CCLabelTTF")
        strengthPrice:setString(recoverConfig.strength_gold)
    elseif _uiType == 1 then
        -- 精力不足
        local energyLayer = tolua.cast(RecoverOwner["energyLayer"], "CCLayer")
        energyLayer:setVisible(true)
        local energyMenu = tolua.cast(RecoverOwner["energyMenu"], "CCMenu")
        energyMenu:setVisible(true)
        local energySay = tolua.cast(RecoverOwner["energySay"], "CCLabelTTF")
        local recoverTime = userdata:getRecoverEnergyTime()
        local recoverConfig = userdata:getRecoverConfig(recoverTime + 1)
        energySay:setString(string.format(energySay:getString(), recoverConfig.energy_add))
        local energyTips = tolua.cast(RecoverOwner["energyTips"], "CCLabelTTF")
        energyTips:setString(string.format(energyTips:getString(), recoverTime, vipdata:recoverEnergyTimes(vipdata:getVipLevel()), vipdata:getNextRecoverEnergyLevel()))
        local energyPrice = tolua.cast(RecoverOwner["energyPrice"], "CCLabelTTF")
        energyPrice:setString(recoverConfig.energy_gold)
    end    
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/RecoverView.ccbi", proxy, true,"RecoverOwner")
    _layer = tolua.cast(node,"CCLayer")
    _refreshData()
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(RecoverOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction( RecoverOwner,"infoBg",_layer )
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
    local menu = tolua.cast(RecoverOwner["menu"], "CCMenu") 
    menu:setTouchPriority(_priority - 1)
    local strengthMenu = tolua.cast(RecoverOwner["strengthMenu"], "CCMenu") 
    strengthMenu:setTouchPriority(_priority - 1)
    local energyMenu = tolua.cast(RecoverOwner["energyMenu"], "CCMenu") 
    energyMenu:setTouchPriority(_priority - 1)
end

-- 该方法名字每个文件不要重复
function getRecoverInfoLayer()
	return _layer
end
--  uitype 0：体力不足  1：精力不足
function createRecoverInfoLayer(uiType)
    _uiType = uiType
    _priority = (priority ~= nil) and priority or -134
    _init()

    local function _onEnter()
        print("onEnter")
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)

        popUpUiAction( RecoverOwner,"infoBg" )
    end

    local function _onExit()
        print("onExit")
        _layer = nil
        _priority = -134
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


    _layer:registerScriptTouchHandler(onTouch, false, _priority, true )
    _layer:setTouchEnabled(true)
    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end