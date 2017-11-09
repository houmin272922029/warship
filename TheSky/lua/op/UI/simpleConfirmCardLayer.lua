simpleConfirmLayer = class("simpleConfirmLayer", function()
    local proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/SimpleConfirmCard.ccbi", proxy, true,"SimpleConfirmCardOwner")
    local layer = tolua.cast(node,"CCLayer")
    return layer
end)

SimpleConfirmCard = {
    confirmMenuCallBackFun = nil,
    cancelMenuCallBackFun = nil
}

simpleConfirmLayer.simpleText = nil
simpleConfirmLayer.title = nil

SimpleConfirmCardOwner = SimpleConfirmCardOwner or {}
ccb["SimpleConfirmCardOwner"] = SimpleConfirmCardOwner


function simpleConfirmLayer:refreshLayer()
    local simpleLabel = SimpleConfirmCardOwner["simpleText"]
    simpleLabel:setString(self.simpleText)
    local titleLabel = SimpleConfirmCardOwner["titleLabel"]
    titleLabel:setVisible(true)
    titleLabel:setString(self.title)
end

function getsimpleConfirmCardLayer()
    if _layer and _layer:getParent() then
        return _layer
    end
    return nil
end

function createSimpleConfirCardLayer(simpleText,title, priority)
    local _layer = simpleConfirmLayer.new()
    _layer.priority = priority or -999
    
    local function closeItemClick()
        popUpCloseAction( SimpleConfirmCardOwner, "cardContent", _layer)
        if SimpleConfirmCard.cancelMenuCallBackFun then
            SimpleConfirmCard.cancelMenuCallBackFun()
        end
    end

    local function closeBtnAction()
        popUpCloseAction(SimpleConfirmCardOwner, "cardContent", _layer)
        if SimpleConfirmCard.cancelMenuCallBackFun then
            SimpleConfirmCard.cancelMenuCallBackFun()
        end
    end

    local function confirmBtnAction()
        popUpCloseAction(SimpleConfirmCardOwner, "cardContent", _layer)
        if SimpleConfirmCard.confirmMenuCallBackFun then
            SimpleConfirmCard.confirmMenuCallBackFun()
        end
    end

    local confirmBtn = tolua.cast(SimpleConfirmCardOwner["confirmBtn"], "CCMenuItem")
    confirmBtn:registerScriptTapHandler(confirmBtnAction)
    local closeBtn = tolua.cast(SimpleConfirmCardOwner["closeBtn"], "CCMenuItem")
    closeBtn:registerScriptTapHandler(closeItemClick)
    local cancelBtn = tolua.cast(SimpleConfirmCardOwner["cancelBtn"], "CCMenuItem")
    cancelBtn:registerScriptTapHandler(closeBtnAction)

    _layer.simpleText = simpleText
    if title then
        _layer.title = title
    else
        _layer.title = ""
    end
    function _layer:closePopupBox()
        -- body
        closeItemClick()
    end
    _layer:refreshLayer()

    local function _onEnter()
        local function setMenuPriority()
            local menu = tolua.cast(SimpleConfirmCardOwner["nimeiya"], "CCMenu")
            menu:setHandlerPriority(_layer.priority - 1)
        end
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)

        popUpUiAction(SimpleConfirmCardOwner, "cardContent")
    end

    local function _onExit()
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

    
    local function onTouchBegan(x, y)
        local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
        local infoBg = tolua.cast(SimpleConfirmCardOwner["cardContent"], "CCSprite")
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


    _layer:registerScriptTouchHandler(onTouch ,false , _layer.priority ,true )
    _layer:setTouchEnabled(true)
    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end