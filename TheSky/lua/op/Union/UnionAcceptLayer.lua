local _UnionAcceptLayer
local _applicantData = {}
local _UnionManageLayer
local _hasRight = false

UnionAcceptLayerOwner = UnionAcceptLayerOwner or {}
ccb["UnionAcceptLayerOwner"] = UnionAcceptLayerOwner


local function messageBtnClicked( )
    getMainLayer():addChild(createLeaveMessageLayer(_applicantData.name, _applicantData.id, -500))
end
UnionAcceptLayerOwner["messageBtnClicked"] = messageBtnClicked

local function _inviteFriendCallBack(url,rtnData)
    if rtnData.code == 200 then
        ShowText(HLNSLocalizedString("好友请求已发送"))
    end
end


local function addFriendBtnClicked( )
    doActionFun("INVITE_FRIEND_URL",{ _applicantData.id},_inviteFriendCallBack)
end
UnionAcceptLayerOwner["addFriendBtnClicked"] = addFriendBtnClicked

local function _getBattleInfoCallback(url,rtnData)
    if rtnData.code == 200 then
        playerBattleData:fromDic(rtnData.info)
        -- getMainLayer():getParent():addChild(createTeamCompLayer(userdata:getUserBattleInfo(), playerBattleData))
        getMainLayer():getParent():addChild(createTeamPopupLayer(-140))
        _UnionAcceptLayer:removeFromParentAndCleanup(true)
    end
end

local function formBtnClicked( )
    doActionFun("ARENA_GET_BATTLE_INFO", {_applicantData.id}, _getBattleInfoCallback)
end
UnionAcceptLayerOwner["formBtnClicked"] = formBtnClicked


local function closeItemClick()
    _UnionAcceptLayer:removeFromParentAndCleanup(true)
end
UnionAcceptLayerOwner["closeItemClick"] = closeItemClick

local function _acceptAskCallBack(url,rtnData)
    if rtnData.code == 200 then
        _UnionManageLayer:refreshTable(url,rtnData)
        _UnionAcceptLayer:removeFromParentAndCleanup(true)
        ShowText(HLNSLocalizedString("union.accept.success"))
    else
        ShowText(HLNSLocalizedString("union.accept.fail"))
    end
end

local function inviteBtnClicked( )
    if not _hasRight then
        closeItemClick()
    else
        local acceptId = {_applicantData.id}    
        doActionFun("UNION_AGREE_OR_DENY_URL",{acceptId,true},_acceptAskCallBack)
    end
end
UnionAcceptLayerOwner["inviteBtnClicked"] = inviteBtnClicked

local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/UnionAcceptLayer.ccbi", proxy, true, "UnionAcceptLayerOwner")
    _UnionAcceptLayer = tolua.cast(node, "CCLayer")

    if not _hasRight then
        UnionAcceptLayerOwner["invitePic"]:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("guanbi_text.png"))
    end
end

local function onTouchBegan(x, y)
    local menu = tolua.cast(UnionAcceptLayerOwner["menu"], "CCMenu")
    menu:setHandlerPriority( -133 )
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

function createUnionAcceptLayer( applicantData,UnionManageLayer )
    _applicantData = applicantData
    _UnionManageLayer = UnionManageLayer
    if unionData.selfMemberInfo.duty <= 2 then
        _hasRight = true
    else
        _hasRight = false
    end
    _init()

    local function _onEnter()

    end

    local function _onExit()
        print("onExit")
        _UnionAcceptLayer = nil
        _applicantData = {}
    end

    --onEnter onExit
    local function _layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        end
    end


    _UnionAcceptLayer:registerScriptHandler(_layerEventHandler)
    _UnionAcceptLayer:registerScriptTouchHandler(onTouch ,false ,-132 ,true )
    _UnionAcceptLayer:setTouchEnabled(true)

    return _UnionAcceptLayer
end