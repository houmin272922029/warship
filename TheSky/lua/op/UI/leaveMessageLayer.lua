local _layer
local _priority

local editBox
local _name
local _uid


-- 名字不要重复
LeaveMessageOwner = LeaveMessageOwner or {}
ccb["LeaveMessageOwner"] = LeaveMessageOwner

local function closeItemClick(  )
    popUpCloseAction( LeaveMessageOwner,"infoBg",_layer )
end

local function sendMessageCallBack( url,rtnData )
    if rtnData["code"] == 200 then
        ShowText(HLNSLocalizedString("sendMessage.success"))
        popUpCloseAction( LeaveMessageOwner,"infoBg",_layer )
    end
end

local function onSendTap(  )
    local string = editBox:getText()
    doActionFun("LEAVEAR_MESSAGE",{ _uid,string },sendMessageCallBack)
end

local function onCancelTap(  )
    popUpCloseAction( LeaveMessageOwner,"infoBg",_layer )
end

LeaveMessageOwner["closeItemClick"] = closeItemClick
LeaveMessageOwner["onSendTap"] = onSendTap
LeaveMessageOwner["onCancelTap"] = onCancelTap

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer

    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/LeaveMessage.ccbi",proxy, true,"LeaveMessageOwner")
    _layer = tolua.cast(node,"CCLayer")

    -- _refreshData()

    local titleLabel = tolua.cast(LeaveMessageOwner["titleLabel"],"CCLabelTTF") 
    titleLabel:setString(string.format(HLNSLocalizedString("给%s留言"),_name))

    local editBoxBgs = LeaveMessageOwner["editBoxBgs"]
    local editBg = CCScale9Sprite:create("ccbResources/LevelMessageBg.png")
    editBox = CCEditBox:create(CCSize(editBoxBgs:getContentSize().width,editBoxBgs:getContentSize().height),editBg)
    editBox:setPlaceHolder(HLNSLocalizedString("点我输入留言内容"))
    editBox:setAnchorPoint(ccp(0.5,0.5))
    editBox:setPosition(ccp(editBoxBgs:getContentSize().width / 2,editBoxBgs:getContentSize().height / 2))
    editBox:setFont("ccbResources/FZCuYuan-M03S.ttf",25*retina)
    editBoxBgs:addChild(editBox,100,10)
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(LeaveMessageOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction( LeaveMessageOwner,"infoBg",_layer )
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
    local menu1 = tolua.cast(LeaveMessageOwner["closeMenu"], "CCMenu")
    menu1:setHandlerPriority(_priority - 1)
    local edixBg = LeaveMessageOwner["edixBg"]
    editBox:setTouchPriority(_priority - 1)
end

-- 该方法名字每个文件不要重复
function getLeaveMessageLayer()
	return _layer
end
-- uitype 0:点击全部称号只消失 1：添加全部称号层
function createLeaveMessageLayer( name,uid,priority)
    _name = name
    _uid = uid
    _priority = (priority ~= nil) and priority or -132
    _init()

    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)

        popUpUiAction( LeaveMessageOwner,"infoBg" )
    end

    local function _onExit()
        _layer = nil
        _titleId = nil
        _priority = -132
        _uiType = nil
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