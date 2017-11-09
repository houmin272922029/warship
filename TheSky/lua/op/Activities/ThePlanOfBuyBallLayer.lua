-- 蓝波球购买页面
local _layer
local _priority = -132
local _tableView
local _data

-- 名字不要重复
ThePlanOfBuyBallOwner = ThePlanOfBuyBallOwner or {}
ccb["ThePlanOfBuyBallOwner"] = ThePlanOfBuyBallOwner

--关闭按钮的回调
local function closeItemClick()
    popUpCloseAction(ThePlanOfBuyBallOwner, "infoBg", _layer )
end
ThePlanOfBuyBallOwner["closeItemClick"] = closeItemClick


--去商城按钮
local function onClickedStoreBtn()
    --跳转进入商城界面
    getMainLayer():goToLogue()
    popUpCloseAction(ThePlanOfBuyBallOwner, "infoBg", _layer )
end
ThePlanOfBuyBallOwner["onClickedStoreBtn"] = onClickedStoreBtn

--刷新数据
local function _refreshData()
    --提示文字
    local despLabel = tolua.cast(ThePlanOfBuyBallOwner["despLabel"], "CCLabelTTF")
    
    local recoverTime = userdata:getEnergyAddWithGoldTime()
    local recoverConfig = userdata:getRecoverConfig(recoverTime + 1)
    despLabel:setString(string.format(HLNSLocalizedString("planBuyBall.desp"), recoverTime, vipdata:recoverRecoverAddWithGoldTimes(vipdata:getVipLevel()), vipdata:getNextRecoverAddWithGold()))

    local tipsLabel = tolua.cast(ThePlanOfBuyBallOwner["tipsLabel"], "CCLabelTTF")
    local buyBallTimes = userdata:getEnergyAddWithGoldTime()
    local MakeCount = userdata:getEnergyAddWithGoldOfAdd(buyBallTimes) 
    tipsLabel:setString(string.format(HLNSLocalizedString("planBuyBall.tips"), MakeCount))

    local priceLabel = tolua.cast(ThePlanOfBuyBallOwner["priceLabel"], "CCLabelTTF")
    local goldNum = userdata:getEnergyAddWithGoldOfGold(buyBallTimes)
    priceLabel:setString(goldNum)
end

-- 确认按钮
local function onConfirmBtnTaped()
    local function  callback(url, rtnData)
        --刷新数据
        userdata:addItemsWithGoldSucc()
        getCultureLayer():updateCulUI()
        closeItemClick()
    end
    doActionFun("ADD_BLUEBALLWITHGOLD", {}, callback)  
end
ThePlanOfBuyBallOwner["onConfirmBtnTaped"] = onConfirmBtnTaped

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/ThePlanOfBuyBall.ccbi", proxy, true,"ThePlanOfBuyBallOwner")
    _layer = tolua.cast(node,"CCLayer")

    local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
    cache:addSpriteFramesWithFile("ccbResources/shadow.plist")
    _refreshData()
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(ThePlanOfBuyBallOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction(ThePlanOfBuyBallOwner, "infoBg", _layer)
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
    local Menu = tolua.cast(ThePlanOfBuyBallOwner["Menu"], "CCMenu")
    Menu:setTouchPriority(_priority - 2)
end

function getThePlanOfBuyBallOwnerLayer()
    return _layer
end

function createThePlanOfBuyBallOwnerLayer(priority)
    _priority = (priority ~= nil) and priority or -132
    _init()

    function _layer:refreshData()
       -- _data = loginActivityData:getQuizData() 
       --_tableView:reloadData()
    end

    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)

        addObserver(NOTI_TICK, refreshTimeLabel)
        popUpUiAction(ThePlanOfBuyBallOwner, "infoBg")
    end

    local function _onExit()
        removeObserver(NOTI_TICK, refreshTimeLabel)
        _layer = nil
        _tableView = nil
        _priority = nil
        _data = nil
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