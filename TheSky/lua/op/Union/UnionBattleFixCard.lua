local _layer
local _priority = -132
local _fortId
local _name

-- 名字不要重复
UnionBattleFixOwner = UnionBattleFixOwner or {}
ccb["UnionBattleFixOwner"] = UnionBattleFixOwner

local function _refreshData()
    local amount = 0
    for i=1,5 do
        local fortId = string.format("fort_%02d", i)
        local fortDic = unionData.forts[fortId]
        local left = tolua.cast(UnionBattleFixOwner["left_"..i], "CCLabelTTF")
        left:setString(string.format("%d%%", fortDic.durability))
        local candy = tolua.cast(UnionBattleFixOwner["candy_"..i], "CCLabelTTF")
        local need = math.ceil((100 - fortDic.durability) * ConfigureStorage.leagueFort[tostring(fortDic.level)][fortId].repaircost)
        amount = amount + need
        candy:setString(need)
    end
    local candyAll = tolua.cast(UnionBattleFixOwner["candyAll"], "CCLabelTTF")
    candyAll:setString(amount)
end

local function repairCallback(url, rtnData)
    unionData:fromDic(rtnData.info)
    _refreshData()
    getUnionBattleLayer():refreshLayer()
    getUnionMainLayer():refreshData()
end

local function closeItemClick()
    _layer:removeFromParentAndCleanup(true)
end
UnionBattleFixOwner["closeItemClick"] = closeItemClick

local function fixItemClick(tag)
    local fortId = string.format("fort_%02d", tag)
    local fortDic = unionData.forts[fortId]
    local need = math.ceil((100 - fortDic.durability) * ConfigureStorage.leagueFort[tostring(fortDic.level)][fortId].repaircost)
    if need == 0 then
        ShowText(HLNSLocalizedString("fix.tips.already"))
    else
        if unionData.depot.sweetCount < need then
            local text = HLNSLocalizedString("fix.tips.candy.notEnough")
            getMainLayer():getParent():addChild(createSimpleConfirCardLayer(text), 100)
            SimpleConfirmCard.confirmMenuCallBackFun = nil
            SimpleConfirmCard.cancelMenuCallBackFun = nil
        else
            -- 修复单个接口
            doActionFun("LEAGUE_BATTLE_REPAIRFORT", {fortId}, repairCallback)
        end
    end
end
UnionBattleFixOwner["fixItemClick"] = fixItemClick

local function fixAllClick()
    local amount = 0
    for i=1,5 do
        local fortId = string.format("fort_%02d", i)
        local fortDic = unionData.forts[fortId]
        local need = math.ceil((100 - fortDic.durability) * ConfigureStorage.leagueFort[tostring(fortDic.level)][fortId].repaircost)
        amount = amount + need
    end
    if amount == 0 then
        ShowText(HLNSLocalizedString("fix.tips.already"))
    else
        if unionData.depot.sweetCount < amount then
            local text = HLNSLocalizedString("fix.tips.candy.notEnough")
            getMainLayer():getParent():addChild(createSimpleConfirCardLayer(text), 100)
            SimpleConfirmCard.confirmMenuCallBackFun = nil
            SimpleConfirmCard.cancelMenuCallBackFun = nil
        else
            -- 修复全部接口
            doActionFun("LEAGUE_BATTLE_REPAIRFORT", {}, repairCallback)
        end
    end
end
UnionBattleFixOwner["fixAllClick"] = fixAllClick

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/UnionBattleFixView.ccbi", proxy, true, "UnionBattleFixOwner")
    _layer = tolua.cast(node,"CCLayer")
    _refreshData()
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(UnionBattleFixOwner["infoBg"], "CCSprite")
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
    local menu = tolua.cast(UnionBattleFixOwner["menu"], "CCMenu")
    menu:setHandlerPriority(_priority - 1)
end

-- 该方法名字每个文件不要重复
function getUnionBattleFixCard()
    return _layer
end

function createUnionBattleFixCard(priority)
    _fortId = fortId
    _priority = (priority ~= nil) and priority or -132
    _init()

    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
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