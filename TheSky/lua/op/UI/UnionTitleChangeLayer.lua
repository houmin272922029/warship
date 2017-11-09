local _layer
local _priority = -132
local _unionMainView

local editBox


-- 名字不要重复
UnionTitleChangeOwner = UnionTitleChangeOwner or {}
ccb["UnionTitleChangeOwner"] = UnionTitleChangeOwner

local function closeItemClick(  )
    popUpCloseAction( UnionTitleChangeOwner,"infoBg",_layer )
end

local function changeTitleCallBack( url,rtnData )
    if rtnData["code"] == 200 then
        ShowText(HLNSLocalizedString("联盟公告修改成功"))
        unionData:fromDic( rtnData.info )
        _unionMainView:refreshUnion()
        closeItemClick()
    end
end

local function changeTitleClick(  )
    
    local string = editBox:getText()
    if string.len(string) > 150 then
        ShowText(HLNSLocalizedString("字数不得超过50"))    
    else
        if editBox:getText() == nil or editBox:getText() == "" then
            ShowText(HLNSLocalizedString("联盟公告不得为空"))  
        else
            doActionFun("UNION_CHANGE_NOTICE",{ string },changeTitleCallBack)
        end
    end
end

UnionTitleChangeOwner["closeItemClick"] = closeItemClick
UnionTitleChangeOwner["changeTitleClick"] = changeTitleClick

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer

    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/UnionTitleChange.ccbi",proxy, true,"UnionTitleChangeOwner")
    _layer = tolua.cast(node,"CCLayer")

    local editBoxBgs = tolua.cast(UnionTitleChangeOwner["editBoxBgs"],"CCLayer")
    local editBg = CCScale9Sprite:create("ccbResources/LevelMessageBg.png")
    editBox = CCEditBox:create(CCSize(editBoxBgs:getContentSize().width,editBoxBgs:getContentSize().height),editBg)
    editBox:setPlaceHolder(HLNSLocalizedString("点此输入联盟公告内容"))
    editBox:setAnchorPoint(ccp(0.5,0.5))
    editBox:setPosition(ccp(editBoxBgs:getContentSize().width / 2,editBoxBgs:getContentSize().height / 2))
    editBox:setFont("ccbResources/FZCuYuan-M03S.ttf",25 * retina)
    editBoxBgs:addChild(editBox,100,10)
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(UnionTitleChangeOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction( UnionTitleChangeOwner,"infoBg",_layer )
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
    local menu1 = tolua.cast(UnionTitleChangeOwner["closeMenu"], "CCMenu")
    menu1:setHandlerPriority(_priority - 1)
    local edixBg = UnionTitleChangeOwner["edixBg"]
    editBox:setTouchPriority(_priority - 1)
end

-- 该方法名字每个文件不要重复
function getUnionTitleChangeLayer()
    return _layer
end

-- 修改联盟公告
function createUnionTitleChangeLayer( mainview ,priority)
    _unionMainView = mainview
    _priority = (priority ~= nil) and priority or -132
    _init()

    local function _onEnter()
        print("onEnter")
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)

        popUpUiAction( UnionTitleChangeOwner,"infoBg" )
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
    --UnionTitleChange

    _layer:registerScriptTouchHandler(onTouch ,false ,_priority ,true )
    _layer:setTouchEnabled(true)
    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end