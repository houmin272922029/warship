local _UnionOuterLayer
local _unionMainView

UnionOuterLayerOwner = UnionOuterLayerOwner or {}
ccb["UnionOuterLayerOwner"] = UnionOuterLayerOwner

local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/UnionOuterLayer.ccbi", proxy, true, "UnionOuterLayerOwner")
    _UnionOuterLayer = tolua.cast(node, "CCLayer")
end

-- 创建联盟
local function createUnionFun( )
    -- body
    print(" Print By lixq ---- createUnionFun ")
    _unionMainView:gotoCreate()
end
UnionOuterLayerOwner["createUnionFun"] = createUnionFun

-- 加入联盟
local function joinUnionFun( )
    -- body
    print(" Print By lixq ---- joinUnionFun")
    _unionMainView:gotoJoin()
end
UnionOuterLayerOwner["joinUnionFun"] = joinUnionFun

function createUnionOuterLayer( unionMainView )
    _init()

    _unionMainView = unionMainView

    local function _onEnter()

    end

    local function _onExit()
        print("onExit")
        _UnionOuterLayer = nil
    end

    --onEnter onExit
    local function _layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        end
    end


    _UnionOuterLayer:registerScriptHandler(_layerEventHandler)

    return _UnionOuterLayer
end