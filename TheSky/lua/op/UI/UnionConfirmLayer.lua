local _layer
local _type

UnionConfirmCard = {
    confirmMenuCallBackFun = nil,
}

-- 名字不要重复
UnionConfirmOwner = UnionConfirmOwner or {}
ccb["UnionConfirmOwner"] = UnionConfirmOwner

local function closeItemClick()
    popUpCloseAction( UnionConfirmOwner,"cardContent",_layer )
end

local function confirmBtnAction(  )
    popUpCloseAction( UnionConfirmOwner,"cardContent",_layer )
    if UnionConfirmCard.confirmMenuCallBackFun then
        UnionConfirmCard.confirmMenuCallBackFun()
    end
end

UnionConfirmOwner["closeItemClick"] = closeItemClick
UnionConfirmOwner["confirmBtnAction"] = confirmBtnAction
-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/UnionConfirm.ccbi", proxy, true,"UnionConfirmOwner")
    _layer = tolua.cast(node,"CCLayer")

    local quit = UnionConfirmOwner["quit"]
    local dismiss = UnionConfirmOwner["dismiss"]
    if _type == 1 then
        quit:setVisible(false)
        dismiss:setVisible(true)
    end
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(UnionConfirmOwner["cardContent"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
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
    local menu = tolua.cast(UnionConfirmOwner["nimeiya"], "CCMenu")
    menu:setHandlerPriority(-501)
end

-- 该方法名字每个文件不要重复
function getUnionConfirmCard()
	return _layer
end

function createUnionConfirmCard( type )

    _type = type
    _init()

    local function _onEnter()
        print("onEnter")
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)

        popUpUiAction( UnionConfirmOwner,"cardContent" )
    end

    local function _onExit()
        print("onExit")
        _layer = nil
    end

    --onEnter onExit
    local function _layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        end
    end

    _layer:registerScriptTouchHandler(onTouch ,false ,-500 ,true )
    _layer:setTouchEnabled(true)
    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end