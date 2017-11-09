local _layer
local _priority = -132

-- 名字不要重复
yuekaSajiaoOwner = yuekaSajiaoOwner or {}
ccb["yuekaSajiaoOwner"] = yuekaSajiaoOwner

local function closeItemClick(  )
    popUpCloseAction( yuekaSajiaoOwner,"infoBg",_layer )
end

local function onXufeiClick(  )
    -- body
    print("你说该怎么续费吧！")
end

yuekaSajiaoOwner["closeItemClick"] = closeItemClick
yuekaSajiaoOwner["onXufeiClick"] = onXufeiClick

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer

    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/yuekaSajiao.ccbi",proxy, true,"yuekaSajiaoOwner")
    _layer = tolua.cast(node,"CCLayer")

end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(yuekaSajiaoOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction( yuekaSajiaoOwner,"infoBg",_layer )
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
    local menu1 = tolua.cast(yuekaSajiaoOwner["closeMenu"], "CCMenu")
    menu1:setHandlerPriority(_priority - 1)
end

-- 该方法名字每个文件不要重复
function getYuekaSajiaoLayer()
	return _layer
end

function createYuekaSajiaoLayer( priority)
    _priority = (priority ~= nil) and priority or -132
    _init()

    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)

        popUpUiAction( yuekaSajiaoOwner,"infoBg" )
    end

    local function _onExit()
        _layer = nil
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