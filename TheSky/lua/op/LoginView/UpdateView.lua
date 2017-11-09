
local _Layer = nil

UpdateLayerOwner = UpdateLayerOwner or {}
ccb["UpdateLayerOwner"] = UpdateLayerOwner

local function init()
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/UpdateLayer.ccbi",proxy,true,"UpdateLayerOwner")
    _Layer = tolua.cast(node,"CCLayer")

end

function creatUpdateLayer()
    init()

    local function _onEnter()
        print("onEnter")
        playMusic(MUSIC_SOUND_0, true)
    end

    local function _onExit()
        print("onExit")
        _Layer = nil
    end

    --onEnter onExit
    local function layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        end
    end
    -- addTestTable()
    _Layer:registerScriptHandler(layerEventHandler)

    return _Layer
end
