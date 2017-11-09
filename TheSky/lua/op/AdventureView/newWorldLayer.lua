local _layer

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/NewWorldFirstView.ccbi",proxy, true,"NewWorldFirstViewOwner")
    _layer = tolua.cast(node,"CCLayer")
end

local function _changeState(state)
	_layer:removeAllChildrenWithCleanup(true)
    if state == blooddataFlag.home or state == blooddataFlag.lose then
        _layer:addChild(createNewWorldFirstLayer())
    elseif state == blooddataFlag.dayBuff then
        _layer:addChild(createNewWorldSecondLayer())
    elseif state == blooddataFlag.fight then
        _layer:addChild(createNewWorldThirdLayer())
    elseif state == blooddataFlag.reward then
        _layer:addChild(createNewWorldFourthLayer())
    elseif state == blooddataFlag.tempBuff then
        _layer:addChild(createNewWorldFifthLayer())
    end
end

-- 该方法名字每个文件不要重复
function getNewWorldLayer()
	return _layer
end

function createNewWorldLayer()
    _init()

    function _layer:showLayer()
        _changeState(runtimeCache.newWorldState)
    end

    local function _onEnter()
        runtimeCache.newWorldState = blooddata.data.flag
    	_changeState(runtimeCache.newWorldState)
    end

    local function _onExit()
        _layer = nil
        runtimeCache.newWorldState = 0
    end

    --onEnter onExit
    local function _layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        end
    end


    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end