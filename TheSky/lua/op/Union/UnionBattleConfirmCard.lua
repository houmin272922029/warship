local _layer
local _priority = -132
local _pos
local _id
local _name

-- 名字不要重复
UnionBattleConfirmOwner = UnionBattleConfirmOwner or {}
ccb["UnionBattleConfirmOwner"] = UnionBattleConfirmOwner

local function closeItemClick()
    _layer:removeFromParentAndCleanup(true)
end
UnionBattleConfirmOwner["closeItemClick"] = closeItemClick

local function fightClick()
    getUnionBattleLayer():declare(_id)
    _layer:removeFromParentAndCleanup(true)
end
UnionBattleConfirmOwner["fightClick"] = fightClick


-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/UnionBattleConfirm.ccbi", proxy, true,"UnionBattleConfirmOwner")
    _layer = tolua.cast(node,"CCLayer")
    
    local tips = tolua.cast(UnionBattleConfirmOwner["tips"], "CCLabelTTF")
    tips:setString(HLNSLocalizedString("attack.start.tips", _name))
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(UnionBattleConfirmOwner["infoBg"], "CCSprite")
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
    local menu = tolua.cast(UnionBattleConfirmOwner["menu"], "CCMenu")
    menu:setHandlerPriority(_priority - 1)
end

-- 该方法名字每个文件不要重复
function getUnionBattleConfirmCard()
	return _layer
end
--  uitype 0：强化  1：更换装备   2：分享  array { heroid:herouid,pos:_pos}
function createUnionBattleConfirmCard(id, name)
    _id = id
    _name = name
    _priority = (priority ~= nil) and priority or -132
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
        _id = nil
        _name = nil
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