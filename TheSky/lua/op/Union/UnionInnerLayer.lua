local _UnionInnerLayer
local _unionMainView

UnionInnerLayerOwner = UnionInnerLayerOwner or {}
ccb["UnionInnerLayerOwner"] = UnionInnerLayerOwner

-- 活动方法
local function unionActivityFun( tag )
    -- body
    _unionMainView:gotoShowActivity( tag )
end
UnionInnerLayerOwner["unionActivityFun"] = unionActivityFun

-- 联盟建设
local function unionBuildFun()
    _unionMainView:gotoBuild()
end
UnionInnerLayerOwner["unionBuildFun"] = unionBuildFun

-- 联盟战斗
local function unionBattleFun()
    _unionMainView:gotoBattle()
end
UnionInnerLayerOwner["unionBattleFun"] = unionBattleFun

-- 联盟商城
local function unionShopFun()
    _unionMainView:gotoShop()
end
UnionInnerLayerOwner["unionShopFun"] = unionShopFun

-- 联盟跨服竞速战
local function unionRacingBattleFun()
    _unionMainView:gotoRacingBattle()
end
UnionInnerLayerOwner["unionRacingBattleFun"] = unionRacingBattleFun

-- 管理
local function unionManageFun( )
    -- body
    print(" Print By lixq ---- unionManageFun")
    _unionMainView:gotoShowManage( )
end
UnionInnerLayerOwner["unionManageFun"] = unionManageFun

-- 成员
local function unionMemberFun( )
    -- body
    print(" Print By lixq ---- unionMemberFun")
    _unionMainView:gotoShowMember( )
end
UnionInnerLayerOwner["unionMemberFun"] = unionMemberFun

-- 聊天
local function unionChatFun( )
    -- body
    print(" Print By lixq ---- unionChatFun")
    _unionMainView:gotoShowChat( )
end
UnionInnerLayerOwner["unionChatFun"] = unionChatFun

-- 排行
local function unionRankFun( )
    -- body
    print(" Print By lixq ---- unionRankFun")
    _unionMainView:gotoShowRank( )
end
UnionInnerLayerOwner["unionRankFun"] = unionRankFun

-- 战利品
local function unionAwardFun( )
    -- body
    print(" Print By lixq ---- unionAwardFun")
    _unionMainView:gotoShowAward( )
end
UnionInnerLayerOwner["unionAwardFun"] = unionAwardFun

-- 本盟动态
local function unionInformationFun( )
    -- body
    print(" Print By lixq ---- unionInformationFun")
    _unionMainView:gotoShowInformation( )
end
UnionInnerLayerOwner["unionInformationFun"] = unionInformationFun

local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/UnionInnerLayer.ccbi", proxy, true, "UnionInnerLayerOwner")
    _UnionInnerLayer = tolua.cast(node, "CCLayer")

    -- Detail
    
    -- enableShadow(CCSizeMake(2, -2), 1, 0) 阴影
    -- enableStroke(ccc3(255, 255, 255), 1) 描边
end

function createUnionInnerLayer( unionMainView )
    _init()

    _unionMainView = unionMainView

    local function _onEnter()
        _unionMainView:titleVisible(true)
    end

    local function _onExit()
        print("onExit")
        _unionMainView:titleVisible(false)
        _UnionInnerLayer = nil
    end

    --onEnter onExit
    local function _layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        end
    end


    _UnionInnerLayer:registerScriptHandler(_layerEventHandler)

    return _UnionInnerLayer
end