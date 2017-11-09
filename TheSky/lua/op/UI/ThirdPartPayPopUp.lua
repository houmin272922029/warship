local _layer
local _priority

ThirdPartPayCard = {
    otherPayActionFun = nil,
    aliPayActionFun = nil
}

-- 名字不要重复
ThirdPartPayPopUpOwner = ThirdPartPayPopUpOwner or {}
ccb["ThirdPartPayPopUpOwner"] = ThirdPartPayPopUpOwner

local function closeItemClick(  )
    popUpCloseAction( ThirdPartPayPopUpOwner,"infoBg",_layer )
end

ThirdPartPayPopUpOwner["closeItemClick"] = closeItemClick

local function otherPayAction(  )
    -- 第三方支付
    print(" Print By lixq ---- otherPayAction")
    popUpCloseAction( ThirdPartPayPopUpOwner,"infoBg",_layer )
    if ThirdPartPayCard.otherPayActionFun then
        ThirdPartPayCard.otherPayActionFun()
    end
end

ThirdPartPayPopUpOwner["otherPayAction"] = otherPayAction

local function aliPayAction(  )
    -- 阿里支付
    print(" Print By lixq ---- aliPayAction")
    popUpCloseAction( ThirdPartPayPopUpOwner,"infoBg",_layer )
    if ThirdPartPayCard.aliPayActionFun then
        ThirdPartPayCard.aliPayActionFun()
    end
end

ThirdPartPayPopUpOwner["aliPayAction"] = aliPayAction

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer

    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/ThirdPartPayPopUp.ccbi",proxy, true,"ThirdPartPayPopUpOwner")
    _layer = tolua.cast(node,"CCLayer")
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(ThirdPartPayPopUpOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        -- _layer:removeFromParentAndCleanup(true)
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
    local menu1 = tolua.cast(ThirdPartPayPopUpOwner["closeMenu"], "CCMenu")
    menu1:setHandlerPriority(_priority - 1)
end

-- 该方法名字每个文件不要重复
function getThirdPartPayPopUpLayer()
	return _layer
end

function createThirdPartPayPopUpLayer( priority )
    _priority = (priority ~= nil) and priority or -132
    _init()

    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)

        popUpUiAction( ThirdPartPayPopUpOwner,"infoBg" )
    end

    local function _onExit()
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