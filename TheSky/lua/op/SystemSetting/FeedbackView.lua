local _layer
local _priority = -132

local editBox


-- 名字不要重复
FeedbackOwner = FeedbackOwner or {}
ccb["FeedbackOwner"] = FeedbackOwner

local function closeItemClick(  )
    _layer:removeFromParentAndCleanup(true) 
end

local function commitCallBack( url,rtnData )
    if rtnData["code"] == 200 then
        ShowText(HLNSLocalizedString("feedback.success"))
        editBox:setText("")
        popUpCloseAction(FeedbackOwner, "infoBg", _layer )
    end
end

local function commitFeedback(  )
    local string = editBox:getText()
    if string.len(string) >= 500 then
        ShowText(HLNSLocalizedString("feedback.exceed"))    
    else
        if editBox:getText() == nil or editBox:getText() == "" then
            ShowText(HLNSLocalizedString("feedback.tips"))  
        else
            doActionFun("FEEDBACK",{ string },commitCallBack)
        end
    end
end

FeedbackOwner["closeItemClick"] = closeItemClick
FeedbackOwner["commitFeedback"] = commitFeedback

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer

    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/Feedback.ccbi",proxy, true,"FeedbackOwner")
    _layer = tolua.cast(node,"CCLayer")

    local editBoxBgs = tolua.cast(FeedbackOwner["editBoxBgs"],"CCLayer")
    local editBg = CCScale9Sprite:create("ccbResources/LevelMessageBg.png")
    editBox = CCEditBox:create(CCSize(editBoxBgs:getContentSize().width,editBoxBgs:getContentSize().height),editBg)
    editBox:setPlaceHolder(HLNSLocalizedString("请留下您的宝贵意见及建议"))
    editBox:setAnchorPoint(ccp(0.5,0.5))
    editBox:setPosition(ccp(editBoxBgs:getContentSize().width / 2,editBoxBgs:getContentSize().height / 2))
    editBox:setFont("ccbResources/FZCuYuan-M03S.ttf",25*retina)
    editBoxBgs:addChild(editBox,100,10)
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(FeedbackOwner["infoBg"], "CCSprite")
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
    local menu1 = tolua.cast(FeedbackOwner["closeMenu"], "CCMenu")
    menu1:setHandlerPriority(_priority - 1)
    local edixBg = FeedbackOwner["edixBg"]
    editBox:setTouchPriority(_priority - 1)
end

-- 该方法名字每个文件不要重复
function getFeedbackLayer()
	return _layer
end
-- uitype 0:点击全部称号只消失 1：添加全部称号层
function createFeedbackLayer( priority)
    _priority = (priority ~= nil) and priority or -132
    _init()

    local function _onEnter()
        print("onEnter")
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
    end

    local function _onExit()
        _layer = nil
        _priority = -132
        editBox = nil
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