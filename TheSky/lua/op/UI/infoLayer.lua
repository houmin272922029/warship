local _layer

-- 名字不要重复
InfoOwner = InfoOwner or {}
ccb["InfoOwner"] = InfoOwner

ScrollViewOwner = ScrollViewOwner or {}
ccb["ScrollViewOwner"] = ScrollViewOwner

local function closeItemClick()
    _layer:removeFromParentAndCleanup(true)
end
ScrollViewOwner["closeItemClick"] = closeItemClick

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/infoView.ccbi", proxy, true,"InfoOwner")
    _layer = tolua.cast(node,"CCLayer")
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(InfoOwner["infoBg"], "CCSprite")
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
    local sv = tolua.cast(InfoOwner["sv"], "CCScrollView") 
    sv:setTouchPriority(-132)
    local menu = tolua.cast(ScrollViewOwner["menu"], "CCMenu")
    menu:setHandlerPriority(-131)
end

-- 该方法名字每个文件不要重复
function getInfoLayer()
	return _layer
end

function createInfoLayer()
    _init()

    local function _onEnter()
        print("onEnter")
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
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


    _layer:registerScriptTouchHandler(onTouch ,false ,-130 ,true )
    _layer:setTouchEnabled(true)
    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end