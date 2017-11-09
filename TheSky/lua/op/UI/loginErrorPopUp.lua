local _layer
local _priority

-- 名字不要重复
LoginErrorPopupOwner = LoginErrorPopupOwner or {}
ccb["LoginErrorPopupOwner"] = LoginErrorPopupOwner

local function close()
    if getLoginLayer() then
        getLoginLayer():getSSOUid()
    else
        if isPlatform(IOS_KY_ZH) or isPlatform(IOS_KYPARK_ZH) then     -- 当为快用平台，网络错误的时候不重设uid
            userdata:resetAllData(0)
        else
            userdata:resetAllData()
        end
        local loginScene = CCScene:create()
        loginScene:addChild(LoginLayer())
        CCDirector:sharedDirector():replaceScene(CCTransitionFade:create(0.6, loginScene))
    end
    popUpCloseAction( LoginErrorPopupOwner,"infoBg",_layer )

end

local function closeItemClick(  )
    close()
end 
LoginErrorPopupOwner["closeItemClick"] = closeItemClick

local function onCloseBtnTaped(  )
    close()
end 

LoginErrorPopupOwner["onCloseBtnTaped"] = onCloseBtnTaped

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/LoginErrorPopup.ccbi",proxy, true,"LoginErrorPopupOwner")
    _layer = tolua.cast(node,"CCLayer")
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(LoginErrorPopupOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        close()
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
    local menu = tolua.cast(LoginErrorPopupOwner["closeMenu"], "CCMenu")
    menu:setHandlerPriority(_priority - 1)
end

-- 该方法名字每个文件不要重复
function getLoginErrorPopUpLayer()
	return _layer
end

function createLoginErrorPopUpLayer( priority)
    _priority = (priority ~= nil) and priority or -1000
    _init()

    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)

        popUpUiAction( LoginErrorPopupOwner,"infoBg" )
    end

    local function _onExit()
        _layer = nil
        _priority = -1000
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