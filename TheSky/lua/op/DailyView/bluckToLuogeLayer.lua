local _layer
local _priority = -132

Bluk2LuogeOwner = Bluk2LuogeOwner or {}
ccb["Bluk2LuogeOwner"] = Bluk2LuogeOwner

--点击关闭按钮
local function closeItemClick(  )
    if _layer then
        _layer:removeFromParentAndCleanup(true)
    end
end

Bluk2LuogeOwner["closeItemClick"] = closeItemClick

--点击确定。前往罗格镇
local function comfirmClick(  )
    if getMainLayer() then
        getMainLayer():goToLogue()
        _layer:removeFromParentAndCleanup(true)
    end
end

Bluk2LuogeOwner["comfirmClick"] = comfirmClick



local  function refreshUI()
    -- body
    local tipLabel = tolua.cast(Bluk2LuogeOwner["tipInfo"],"CCLabelTTF")
    if tipLabel then 
        tipLabel:setString(HLNSLocalizedString("bluck_sing.notenoughheros"))
    end
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/DailyBluk2LuogeView.ccbi",proxy, true,"Bluk2LuogeOwner")
    _layer = tolua.cast(node,"CCLayer")

    refreshUI()
end


local function setMenuPriority()
    
    local menu = tolua.cast(Bluk2LuogeOwner["menu"], "CCMenu")
    menu:setHandlerPriority(_priority-1)
end


local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(Bluk2LuogeOwner["infoBg"], "CCSprite")
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


function createBluckToLuogeLayer(priority)

    _priority = (priority ~= nil) and priority or -132
    _init()


    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
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

    _layer:registerScriptTouchHandler(onTouch ,false , _priority ,true )
    _layer:setTouchEnabled(true)
    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end