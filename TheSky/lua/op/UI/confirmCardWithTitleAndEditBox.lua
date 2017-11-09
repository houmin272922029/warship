local _layer
-- local _simpleText
local editBox

ConfirmCardWithTitleAndEditBox = {
    confirmMenuCallBackFun = nil,
    cancelMenuCallBackFun = nil
}

-- 名字不要重复
ConfirmCardWithTitleAndEditBoxOwner = ConfirmCardWithTitleAndEditBoxOwner or {}
ccb["ConfirmCardWithTitleAndEditBoxOwner"] = ConfirmCardWithTitleAndEditBoxOwner

local function closeItemClick()
    popUpCloseAction( ConfirmCardWithTitleAndEditBoxOwner,"cardContent",_layer )
    ConfirmCardWithTitleAndEditBox.cancelMenuCallBackFun()
end

local function closeBtnAction(  )
    popUpCloseAction( ConfirmCardWithTitleAndEditBoxOwner,"cardContent",_layer )
    ConfirmCardWithTitleAndEditBox.cancelMenuCallBackFun()
end

local function renameCallBack( url,rtnData )
    if rtnData.code == 200 then
        userdata.name = editBox:getText()
        postNotification(NOTI_RENAME_SUCCESS, nil)
        ShowText(HLNSLocalizedString("海盗船更名成功"))
        popUpCloseAction( ConfirmCardWithTitleAndEditBoxOwner,"cardContent",_layer )
    end
end

local function confirmBtnAction(  )
    local name = editBox:getText()
    if string.len(name) <= 0 then
        ShowText(HLNSLocalizedString("海盗船名字不能为空"))
    else
        doActionFun("RENAME_WITH_ITEM_URL",{ name },renameCallBack)
        ConfirmCardWithTitleAndEditBox.confirmMenuCallBackFun()
    end
end

ConfirmCardWithTitleAndEditBoxOwner["closeItemClick"] = closeItemClick
ConfirmCardWithTitleAndEditBoxOwner["confirmBtnAction"] = confirmBtnAction
ConfirmCardWithTitleAndEditBoxOwner["closeBtnAction"] = closeBtnAction
-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/ConfirmCardWithTitleAndEditBox.ccbi", proxy, true,"ConfirmCardWithTitleAndEditBoxOwner")
    _layer = tolua.cast(node,"CCLayer")

    -- local simpleLabel = ConfirmCardWithTitleAndEditBoxOwner["simpleText"]
    -- simpleLabel:setString(_simpleText)
    local editBoxLayer = tolua.cast(ConfirmCardWithTitleAndEditBoxOwner["editBoxLayer"],"CCLayer") 
    -- local editBg = CCScale9Sprite:createWithSpriteFrameName("btn3_1.png")
    local editBg = CCScale9Sprite:createWithSpriteFrameName("chat_bg.png")
    editBox = CCEditBox:create(CCSize(editBoxLayer:getContentSize().width,editBoxLayer:getContentSize().height),editBg)
    editBox:setAnchorPoint(ccp(0,0.5))
    editBox:setPosition(ccp(0,editBoxLayer:getContentSize().height / 2))
    
    editBox:setFont("ccbResources/FZCuYuan-M03S.ttf",30*retina)

    editBoxLayer:addChild(editBox)
    editBox:setTouchPriority(-510)
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(ConfirmCardWithTitleAndEditBoxOwner["cardContent"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction( ConfirmCardWithTitleAndEditBoxOwner,"cardContent",_layer )
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
    local menu = tolua.cast(ConfirmCardWithTitleAndEditBoxOwner["nimeiya"], "CCMenu")
    menu:setHandlerPriority(-501)
end

-- 该方法名字每个文件不要重复
function getConfirmCardWithTitleAndEditBoxLayer()
	return _layer
end

function createConfirmCardWithTitleAndEditBoxLayer()
    _init()

    local function _onEnter()
        print("onEnter")
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)

        popUpUiAction( ConfirmCardWithTitleAndEditBoxOwner,"cardContent" )
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