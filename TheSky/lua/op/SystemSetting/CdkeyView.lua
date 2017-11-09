local _layer
local _priority = -132

local editBox


-- 名字不要重复
CdkeyOwner = CdkeyOwner or {}
ccb["CdkeyOwner"] = CdkeyOwner

local function closeItemClick(  )
    _layer:removeFromParentAndCleanup(true) 
end

local function commitCallBack( url,rtnData )
    -- PrintTable(rtnData)
    editBox:setText("")
end

local function commitCdkey(  )
    local string = editBox:getText()
    if string.len(string) <= 0 then
        ShowText(HLNSLocalizedString("Cdkey.empty"))    
    else
        doActionFun("CDKEY",{ string },commitCallBack)
    end
end

CdkeyOwner["closeItemClick"] = closeItemClick
CdkeyOwner["commitCdkey"] = commitCdkey

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer

    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/Cdkey.ccbi",proxy, true,"CdkeyOwner")
    _layer = tolua.cast(node,"CCLayer")

    local edixBg = tolua.cast(CdkeyOwner["edixBg"],"CCSprite")
    local editBg = CCScale9Sprite:createWithSpriteFrameName("chat_bg.png")
    editBox = CCEditBox:create(CCSize(edixBg:getContentSize().width,edixBg:getContentSize().height),editBg)
    editBox:setPlaceHolder(HLNSLocalizedString("点此输入CD-KEY"))
    editBox:setAnchorPoint(ccp(0.5,0.5))
    editBox:setPosition(ccp(edixBg:getPositionX(),edixBg:getPositionY()))
    editBox:setFont("ccbResources/FZCuYuan-M03S.ttf", 30 * retina)
    edixBg:getParent():addChild(editBox)
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(CdkeyOwner["infoBg"], "CCSprite")
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
    local menu1 = tolua.cast(CdkeyOwner["closeMenu"], "CCMenu")
    menu1:setHandlerPriority(_priority - 1)
    local edixBg = CdkeyOwner["edixBg"]
    editBox:setTouchPriority(_priority - 1)
end

-- 该方法名字每个文件不要重复
function getCdkeyLayer()
	return _layer
end

function createCdkeyLayer( priority)
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