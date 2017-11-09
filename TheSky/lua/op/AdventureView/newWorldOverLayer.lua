local _layer
local _priority = 130

-- 名字不要重复
NewWorldOverViewOwner = NewWorldOverViewOwner or {}
ccb["NewWorldOverViewOwner"] = NewWorldOverViewOwner

local function getBloodInfoCallback( url,rtnData )
    blooddata:fromDic(rtnData["info"]["bloodInfo"])
    runtimeCache.newWorldState = blooddata.data.flag
    if runtimeCache.newWorldThirdSweep then
        print("**lsf now in NewWorldOverView exit")
        _layer:removeFromParentAndCleanup(true)
        runtimeCache.newWorldThirdSweep = nil
    else
        CCDirector:sharedDirector():replaceScene(mainSceneFun())
    end
    getMainLayer():gotoAdventure()
end

local function closeItemClick()
    doActionFun("GET_BLOOD_INFO", {}, getBloodInfoCallback)
end
NewWorldOverViewOwner["closeItemClick"] = closeItemClick

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/NewWorldOverView.ccbi", proxy, true,"NewWorldOverViewOwner")
    _layer = tolua.cast(node,"CCLayer")

    local stageLabel = tolua.cast(NewWorldOverViewOwner["stageLabel"], "CCLabelTTF")
    stageLabel:setString(string.format(stageLabel:getString(), blooddata.data.outpostNum - 1))
    local starLabel = tolua.cast(NewWorldOverViewOwner["starLabel"], "CCLabelTTF")
    starLabel:setString(string.format(starLabel:getString(), blooddata.data.recordAll))
end

local function onTouchBegan(x, y)
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
    local menu1 = tolua.cast(NewWorldOverViewOwner["menu"], "CCMenu")
    menu1:setHandlerPriority(_priority - 1)
end

-- 该方法名字每个文件不要重复
function getNewWorldOverLayer()
	return _layer
end

function createNewWorldOverLayer(priority)
    _init()
    _priority = priority ~= nil and priority or -132

    local function _onEnter()
        print("onEnter")
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCCallFunc:create(setMenuPriority))
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


    _layer:registerScriptTouchHandler(onTouch ,false , _priority ,true )
    _layer:setTouchEnabled(true)
    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end