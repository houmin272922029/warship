local _UnionCreateLayer
local _unionMainView
local _priority
local _editBox
local _edixBg

UnionCreateLayerOwner = UnionCreateLayerOwner or {}
ccb["UnionCreateLayerOwner"] = UnionCreateLayerOwner

local function onTouchBegan(x, y)
    local touchLocation = _UnionCreateLayer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(UnionCreateLayerOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        _UnionCreateLayer:removeFromParentAndCleanup(true)
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

-- 点击页面中关闭按钮
local function closeTipFun()
    print(" Print By lixq ---- closeTipFun")
    _UnionCreateLayer:removeFromParentAndCleanup(true)
end
UnionCreateLayerOwner["closeTipFun"] = closeTipFun

-- 创建联盟回调函数
local function createUnionCallBack( url, rtnData )
    -- body
    if rtnData and rtnData.code == 200 then
        _editBox:setText("")
        unionData:fromDic(rtnData.info)
        _unionMainView:refreshUnion()
        closeTipFun()
    end
end

-- 点击确定 创建公会
local function createUnionFun( )
    -- body
    print(" Print By lixq ---- createUnionFun")
    local string = _editBox:getText()
    if string.len(string) <= 0 then
        ShowText(HLNSLocalizedString("union.empty"))    
    else
        doActionFun("LEAGUE_CREATE", { string }, createUnionCallBack)
    end
end
UnionCreateLayerOwner["createUnionFun"] = createUnionFun

-- 修改 按钮优先级
local function setMenuPriority()
    local menu = UnionCreateLayerOwner["unionCreateMenu"]
    tolua.cast(menu, "CCMenu")
    menu:setHandlerPriority(_priority - 1)
    _editBox:setTouchPriority(_priority - 1)
end

local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/UnionCreateLayer.ccbi", proxy, true, "UnionCreateLayerOwner")
    _UnionCreateLayer = tolua.cast(node, "CCLayer")

    _edixBg = tolua.cast(UnionCreateLayerOwner["UnionCreateNameLayer"], "CCLayer")
    local editBg = CCScale9Sprite:createWithSpriteFrameName("chat_bg.png")
    _editBox = CCEditBox:create(CCSize(_edixBg:getContentSize().width, _edixBg:getContentSize().height), editBg)
    _editBox:setPlaceHolder(HLNSLocalizedString("union.printUnionName"))
    _editBox:setAnchorPoint(ccp(0.5,0.5))
    _editBox:setPosition(ccp(_edixBg:getPositionX(), _edixBg:getPositionY()))
    _editBox:setFont("ccbResources/FZCuYuan-M03S.ttf", 30 * retina)
    _edixBg:getParent():addChild(_editBox)

    local createDespTTF = UnionCreateLayerOwner["UnionCreateInfoTTF"]
    createDespTTF = tolua.cast(createDespTTF, "CCLabelTTF")
    if ConfigureStorage.leagueDescription and ConfigureStorage.leagueDescription["createLeague"] then
        createDespTTF:setString(ConfigureStorage.leagueDescription["createLeague"]["desp"])
    end

    local createLeaguePayTTF = UnionCreateLayerOwner["createLeaguePayTTF"]
    createLeaguePayTTF = tolua.cast(createLeaguePayTTF, "CCLabelTTF")
    if ConfigureStorage.createLeaguePay and ConfigureStorage.createLeaguePay["gold"] and createLeaguePayTTF then
        createLeaguePayTTF:setString(ConfigureStorage.createLeaguePay["gold"])
    end
end

function createUnionCreateLayer( unionMainView, priority )
    _init()

    local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
    _UnionCreateLayer:runAction(seq)

    _unionMainView = unionMainView
    _priority = (priority ~= nil) and priority or -132

    local function _onEnter()
        
    end

    local function _onExit()
        print("onExit")
        _priority = -132
        _UnionCreateLayer = nil
    end

    --onEnter onExit
    local function _layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        end
    end

    _UnionCreateLayer:registerScriptTouchHandler(onTouch, false, _priority, true)
    _UnionCreateLayer:setTouchEnabled(true)
    _UnionCreateLayer:registerScriptHandler(_layerEventHandler)

    return _UnionCreateLayer
end