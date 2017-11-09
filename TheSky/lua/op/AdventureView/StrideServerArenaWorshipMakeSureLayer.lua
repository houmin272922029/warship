local _layer
local _tableView
local _data
local _rankArray 
local _priority = -132
local _index

-- 劫镖者查看  界面
-- 名字不要重复
StrideServerArenaWorshipMakeSureViewOwner = StrideServerArenaWorshipMakeSureViewOwner or {}
ccb["StrideServerArenaWorshipMakeSureViewOwner"] = StrideServerArenaWorshipMakeSureViewOwner

local function closeItemClick(  )
    popUpCloseAction(StrideServerArenaWorshipMakeSureViewOwner, "infoBg", _layer)
end
StrideServerArenaWorshipMakeSureViewOwner["closeItemClick"] = closeItemClick

local function canCelBtnAction(  )
    popUpCloseAction(StrideServerArenaWorshipMakeSureViewOwner, "infoBg", _layer)
end
StrideServerArenaWorshipMakeSureViewOwner["canCelBtnAction"] = canCelBtnAction

-- 金币膜拜
local function goldworshipBtnAction()
    if userdata.gold < ConfigureStorage.crossDual_worship[tostring(1)].pay.amount  then  --金币不足 跳转进入商城界面
        if getMainLayer() then
            getMainLayer():addChild(createShopRechargeLayer(-140), 100)
        end
    end
    print("金币膜拜")
    local function Callback(url, rtnData)
        closeItemClick()
        ssaData.data = rtnData["info"]
        getStrideServerArenaWorshipViewLayer():_refresh()
    end
    doActionFun("CROSSSERVERBATTLE_WORSHIP", {1 , _index - 1}, Callback)
end
StrideServerArenaWorshipMakeSureViewOwner["goldworshipBtnAction"] = goldworshipBtnAction

-- 贝里膜拜
local function berryworshipBtnAction(  )
    if userdata.berry < ConfigureStorage.crossDual_worship[tostring(2)].pay.amount then
        ShowText(HLNSLocalizedString("SSA.berryNotEnough"))
    end
    print("贝里膜拜") 
    -- 传入的参数 2
    local function Callback(url, rtnData)
        closeItemClick()
        ssaData.data = rtnData["info"]
        getStrideServerArenaWorshipViewLayer():_refresh()
    end
    doActionFun("CROSSSERVERBATTLE_WORSHIP", {2 , _index - 1}, Callback)
end
StrideServerArenaWorshipMakeSureViewOwner["berryworshipBtnAction"] = berryworshipBtnAction


local function _refreshData()
    print("膜拜的配置")
    PrintTable(ConfigureStorage.crossDual_worship)
    local goldget = tolua.cast(StrideServerArenaWorshipMakeSureViewOwner["goldget"], "CCLabelTTF")
    local goldSpend = tolua.cast(StrideServerArenaWorshipMakeSureViewOwner["goldSpend"], "CCLabelTTF")
    local berryget = tolua.cast(StrideServerArenaWorshipMakeSureViewOwner["berryget"], "CCLabelTTF")
    local berrySpend = tolua.cast(StrideServerArenaWorshipMakeSureViewOwner["berrySpend"], "CCLabelTTF")
   
    goldget:setString(ConfigureStorage.crossDual_worship[tostring(1)].gain.amount)
    goldSpend:setString(ConfigureStorage.crossDual_worship[tostring(1)].pay.amount)
    berryget:setString(ConfigureStorage.crossDual_worship[tostring(2)].gain.amount)
    berrySpend:setString(ConfigureStorage.crossDual_worship[tostring(2)].pay.amount)

end

local function setMenuPriority()
    local menu = tolua.cast(StrideServerArenaWorshipMakeSureViewOwner["menu"], "CCMenu")
    menu:setHandlerPriority(_priority - 1)
    if _tableView then
        _tableView:setTouchPriority(_priority - 2)
    end
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer

    local proxy = CCBProxy:create()
    local node  = CCBReaderLoad("ccbResources/StrideServerArenaWorshipMakeSureView.ccbi", proxy, true, "StrideServerArenaWorshipMakeSureViewOwner")
    _layer = tolua.cast(node,"CCLayer")
    _refreshData()
end



-- 该方法名字每个文件不要重复
function getStrideServerArenaWorshipMakeSureLayer()
    return _layer
end


local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(StrideServerArenaWorshipMakeSureViewOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction(StrideServerArenaWorshipMakeSureViewOwner, "infoBg", _layer)
        return true
    end
    return true
end

local function onTouch(eventType, x, y)
    if eventType == "began" then   
        return onTouchBegan(x, y)
    end
end

function createStrideServerArenaWorshipMakeSureLayer(index)
    _index = index
    _priority = (priority ~= nil) and priority or -132
    _init()
    local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
    _layer:runAction(seq)
    local function _onEnter()
        
    end

    local function _onExit()
        _layer = nil
        _priority = -132
        _tableView = nil
        _index = nil
    end

    --onEnter onExit
    local function _layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        end
    end

    _layer:registerScriptTouchHandler(onTouch, false, _priority, true)
    _layer:setTouchEnabled(true)
    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end