local _layer
local _priority = -132
local _memberInfo

-- 名字不要重复
ArenaMenuOwner = ArenaMenuOwner or {}
ccb["ArenaMenuOwner"] = ArenaMenuOwner

-- 邀请好友成功
local function inviteFriendCallBack( url, rtnData )
    if rtnData.code == 200 then
        ShowText(HLNSLocalizedString("好友请求已发送"))
    end
end

local function closeBtnClick()
    _layer:removeFromParentAndCleanup(true)
end

local function closeItemClick(  )
    _layer:removeFromParentAndCleanup(true) 
end

local function leaveMsgClicked(  )
    getMainLayer():addChild(createLeaveMessageLayer(_memberInfo.name, _memberInfo.id, -500))
end
local function addFriendClicked(  )
    doActionFun("INVITE_FRIEND_URL",{ _memberInfo.id },inviteFriendCallBack)
end

ArenaMenuOwner["closeItemClick"] = closeItemClick     -- 关闭
ArenaMenuOwner["closeBtnClick"] = closeBtnClick     -- 关闭
ArenaMenuOwner["leaveMsgClicked"] = leaveMsgClicked       -- 留言
ArenaMenuOwner["addFriendClicked"] = addFriendClicked     -- 加好友


-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/ArenaMenu.ccbi",proxy, true,"ArenaMenuOwner")
    _layer = tolua.cast(node,"CCLayer")
    local name = tolua.cast(ArenaMenuOwner["name"],"CCLabelTTF")
    name:setString(_memberInfo.name)
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(ArenaMenuOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        _layer:removeFromParentAndCleanup(true)
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
    local menu1 = tolua.cast(ArenaMenuOwner["closeMenu"], "CCMenu")
    menu1:setHandlerPriority(_priority - 1)
end

-- 该方法名字每个文件不要重复
function getArenaMenu()
	return _layer
end

function createArenaMenu( info,priority)
    _priority = (priority ~= nil) and priority or -132
    _memberInfo = info
    _init()

    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
    end

    local function _onExit()
        _layer = nil
        _priority = -132
        _memberInfo = nil
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