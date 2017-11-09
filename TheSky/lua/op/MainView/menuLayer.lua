local _layer

menuLayerOwner = menuLayerOwner or {}
ccb["menuLayerOwner"] = menuLayerOwner

local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/menuView.ccbi",proxy, true,"MainSceneOwner")
    _layer = tolua.cast(node,"CCLayer")
end


function getMenuLayer()
	return _layer
end

function createMenuLayer()
    _init()


    local function _onEnter()
        print("onEnter")
        local main = getMainLayer()
        main:test()
    end

    local function _onExit()
        print("menuLayer onExit")
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


    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end