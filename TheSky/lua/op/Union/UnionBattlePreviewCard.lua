local _layer
local _priority = -132
local _fortId
local _name
local _battleType
local BattleType = {
    attack = 1,
    defend = 2,
}

-- 名字不要重复
UnionBattlePreviewOwner = UnionBattlePreviewOwner or {}
ccb["UnionBattlePreviewOwner"] = UnionBattlePreviewOwner

local function closeItemClick()
    _layer:removeFromParentAndCleanup(true)
end
UnionBattlePreviewOwner["closeItemClick"] = closeItemClick

local function preViewFightClick()
    if _battleType == BattleType.attack then
        -- 进攻
        getUnionBattleLayer():attackFort(_fortId)
    else
        getUnionBattleLayer():defendFort(_fortId)
    end
    _layer:removeFromParentAndCleanup(true)
end
UnionBattlePreviewOwner["preViewFightClick"] = preViewFightClick


-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/UnionBattlePreview.ccbi", proxy, true, "UnionBattlePreviewOwner")
    _layer = tolua.cast(node,"CCLayer")

    local attackName = tolua.cast(UnionBattlePreviewOwner["attackName"], "CCLabelTTF")
    attackName:setString(userdata.name)
    local defendName = tolua.cast(UnionBattlePreviewOwner["defendName"], "CCLabelTTF")
    if _name then
        defendName:setString(_name)
        defendName:setVisible(true)
    else
        defendName:setVisible(false)
    end
    local succTips = tolua.cast(UnionBattlePreviewOwner["succTips"], "CCLabelTTF")
    if _battleType == BattleType.attack then
        succTips:setString(HLNSLocalizedString("attack.succ.tips", ConfigureStorage.leagueLvup[_fortId].name))
    else
        succTips:setString(HLNSLocalizedString("defend.succ.tips", ConfigureStorage.leagueLvup[_fortId].name))
    end
    local succCandy = tolua.cast(UnionBattlePreviewOwner["succCandy"], "CCLabelTTF")
    succCandy:setString(30)
    local failCandy = tolua.cast(UnionBattlePreviewOwner["failCandy"], "CCLabelTTF")
    failCandy:setString(2)
    
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(UnionBattlePreviewOwner["infoBg"], "CCSprite")
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
    local menu = tolua.cast(UnionBattlePreviewOwner["menu"], "CCMenu")
    menu:setHandlerPriority(_priority - 1)
end

-- 该方法名字每个文件不要重复
function getUnionBattlePreviewCard()
    return _layer
end

function createUnionBattlePreviewCard(fortId, name, battleType)
    _fortId = fortId
    _name = name
    _priority = (priority ~= nil) and priority or -132
    _battleType = battleType
    _init()

    local function _onEnter()
        print("onEnter")
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
    end

    local function _onExit()
        print("onExit")
        _layer = nil
        _priority = -132
        _fortId = nil
        _name = nil
        _captured = nil
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