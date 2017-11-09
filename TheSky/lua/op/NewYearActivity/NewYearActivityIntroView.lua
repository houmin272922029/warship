local _layer = nil
local _priority = -180

NewYearActivityIntroOwner = NewYearActivityIntroOwner or {}
ccb["NewYearActivityIntroOwner"] = NewYearActivityIntroOwner

local function _init()
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/NewYearActivityIntroView.ccbi",proxy,true,"NewYearActivityIntroOwner")
    _layer = tolua.cast(node,"CCLayer")
end

local function closeItemClick()
    popUpCloseAction(NewYearActivityIntroOwner, "infoBg", _layer )
end
NewYearActivityIntroOwner["closeItemClick"] = closeItemClick

local function onSureClicked()
    popUpCloseAction(NewYearActivityIntroOwner, "infoBg", _layer )
end
NewYearActivityIntroOwner["onSureClicked"] = onSureClicked



local function setMenuPriority()   
    local menu1 = tolua.cast(NewYearActivityIntroOwner["myCloseMenu"], "CCMenu")
    menu1:setHandlerPriority(_priority - 2)    
end


local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(NewYearActivityIntroOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        print("=============wewe111",_layer)
        popUpCloseAction(NewYearActivityIntroOwner, "infoBg", _layer)
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

local function _closeView(  )
    _layer:removeFromParentAndCleanup(true) 
end

function createNewYearActivityIntroView(y,intro)  
    _init()

    _priority = (priority ~= nil) and priority or -180

    local text1 = tolua.cast(NewYearActivityIntroOwner["text1"],"CCLabelTTF")
    text1:setString(intro)

    function _layer:refresh(  )
        -- refreshContentView()
    end

    function _layer:closeView(  )
        _closeView()
    end

    local function _onEnter()

        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)

        popUpUiAction( NewYearActivityIntroOwner,"infoBg" )
    end

    local function _onExit()
        _layer = nil
        _priority = -180
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