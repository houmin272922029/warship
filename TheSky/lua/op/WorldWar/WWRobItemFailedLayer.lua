local _layer
local _priority = -132

-- 劫镖失败
-- 名字不要重复
WWRobItemFailedViewOwner = WWRobItemFailedViewOwner or {}
ccb["WWRobItemFailedViewOwner"] = WWRobItemFailedViewOwner

-- 修改 按钮优先级
local function setMenuPriority()
    local menu = tolua.cast(WWRobItemFailedViewOwner["menu"], "CCMenu")
    menu:setHandlerPriority(_priority - 1)
end

local function refresh()
end

--关闭按钮
local function closeItemClick()
    popUpCloseAction(WWRobItemFailedViewOwner, "infoBg", _layer)
end
WWRobItemFailedViewOwner["closeItemClick"] = closeItemClick

--确定按钮
local function confirmBtnAction()
    popUpCloseAction(WWRobItemFailedViewOwner, "infoBg", _layer)
end
WWRobItemFailedViewOwner["confirmBtnAction"] = confirmBtnAction


-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    local proxy = CCBProxy:create()
    local node  = CCBReaderLoad("ccbResources/WWRobItemFailedView.ccbi", proxy, true, "WWRobItemFailedViewOwner")
    _layer = tolua.cast(node,"CCLayer")
    refresh()
end

-- 该方法名字每个文件不要重复
function getWWRobItemFailedLayer()
	return _layer
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(WWRobItemFailedViewOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction(WWRobItemFailedViewOwner, "infoBg", _layer)
        return true
    end
    return true
end

local function onTouch(eventType, x, y)
    if eventType == "began" then   
        return onTouchBegan(x, y)
    end
end

function createWWRobItemFailedViewLayer(priority)
    _priority = (priority ~= nil) and priority or -132
    _init()
    local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
    _layer:runAction(seq)
    local function _onEnter()
        addObserver(NOTI_WW_REFRESH, refresh)
    end

    local function _onExit()
        removeObserver(NOTI_WW_REFRESH, refresh)
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
    _layer:registerScriptTouchHandler(onTouch, false, _priority, true)
    _layer:setTouchEnabled(true)
    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end