local _UnionJoinInfoLayer
local _priority
local _otherUnionTag

UnionJoinInfoLayerOwner = UnionJoinInfoLayerOwner or {}
ccb["UnionJoinInfoLayerOwner"] = UnionJoinInfoLayerOwner


-- 关闭
local function closeTiphFun( )
    print(" Print By lixq ---- UnionJoinInfoLayer -- closeTiphFun")
    -- body
    _UnionJoinInfoLayer:removeFromParentAndCleanup(true)
end
UnionJoinInfoLayerOwner["closeTiphFun"] = closeTiphFun

-- 会长阵容回调
local function unionCreatorFormCallback( url, rtnData )
    -- body
    if rtnData.code == 200 then
        playerBattleData:fromDic(rtnData.info)
        -- getMainLayer():getParent():addChild(createTeamCompLayer(userdata:getUserBattleInfo(), playerBattleData))
        getMainLayer():getParent():addChild(createTeamPopupLayer(-140))
        _UnionJoinInfoLayer:removeFromParentAndCleanup(true)
    end
end

-- 会长阵容
local function unionCreatorFormFun( )
    print(" Print By lixq ---- UnionJoinInfoLayer -- unionCreatorFormFun")
    -- body
    if unionData.rank[tostring(_otherUnionTag)] then
        local ceoId = unionData.rank[tostring(_otherUnionTag)]["ceoId"]
        doActionFun("ARENA_GET_BATTLE_INFO", {ceoId}, unionCreatorFormCallback)
    end
end
UnionJoinInfoLayerOwner["unionCreatorFormFun"] = unionCreatorFormFun

-- 查看详情
local function unionInfoFun( )
    print(" Print By lixq ---- UnionJoinInfoLayer -- unionInfoFun")
    -- body
    local unionRankInfoLayer = createUnionRankInfoLayer(_otherUnionTag, -137)
    getMainLayer():addChild(unionRankInfoLayer, 2000)
end
UnionJoinInfoLayerOwner["unionInfoFun"] = unionInfoFun

-- 申请加入 callBack
local function unionApplyCallBack( url, rtnData )
    -- body
    if rtnData.code == 200 then
        ShowText(HLNSLocalizedString("union.joinAccess"))
        closeTiphFun()
    end
end

-- 申请加入
local function unionApplyFun( )
    print(" Print By lixq ---- UnionJoinInfoLayer -- unionApplyFun")
    -- body
    if unionData.rank[tostring(_otherUnionTag)] then
        local unionId = unionData.rank[tostring(_otherUnionTag)]["id"]
        doActionFun("LEAGUE_JOIN", {unionId}, unionApplyCallBack)
    end
end
UnionJoinInfoLayerOwner["unionApplyFun"] = unionApplyFun


local function onTouchBegan(x, y)
    local touchLocation = _UnionJoinInfoLayer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(UnionJoinInfoLayerOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        _UnionJoinInfoLayer:removeFromParentAndCleanup(true)
        return true
    end
    return true
end

local function onTouch(eventType, x, y)
    if eventType == "began" then   
        return onTouchBegan(x, y)
    end
end

-- 点击页面中关闭按钮
local function closeTipFun()
    print(" Print By lixq ---- closeTipFun")
    _UnionJoinInfoLayer:removeFromParentAndCleanup(true)
end
UnionJoinInfoLayerOwner["closeTipFun"] = closeTipFun

-- 修改 按钮优先级
local function setMenuPriority()
    local menu = UnionJoinInfoLayerOwner["unionJoinMenu"]
    tolua.cast(menu, "CCMenu")
    menu:setHandlerPriority(_priority - 1)
end

local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/UnionJoinInfoLayer.ccbi", proxy, true, "UnionJoinInfoLayerOwner")
    _UnionJoinInfoLayer = tolua.cast(node, "CCLayer")

    if unionData.rank[tostring(_otherUnionTag)] then
        local unionName = unionData.rank[tostring(_otherUnionTag)]["name"]
        local otherUnionName = UnionJoinInfoLayerOwner["otherUnionName"]
        otherUnionName = tolua.cast(otherUnionName, "CCLabelTTF")
        otherUnionName:setString(unionName)
    end
end

function createUnionJoinInfoLayer( unionTag, priority )
    _otherUnionTag = unionTag
    _priority = (priority ~= nil) and priority or -132

    _init()

    local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
    _UnionJoinInfoLayer:runAction(seq)

    local function _onEnter()
        
    end

    local function _onExit()
        print("onExit")
        _priority = -132
        _otherUnion = nil
        _UnionJoinInfoLayer = nil
    end

    --onEnter onExit
    local function _layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        end
    end

    _UnionJoinInfoLayer:registerScriptTouchHandler(onTouch, false, _priority, true)
    _UnionJoinInfoLayer:setTouchEnabled(true)
    _UnionJoinInfoLayer:registerScriptHandler(_layerEventHandler)

    return _UnionJoinInfoLayer
end