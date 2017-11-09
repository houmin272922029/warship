local _layer
local _priority = -132
local _nserialEdit
local _idEdit
local _money

local typelabel

local initIndex = 1 

local isOpen = false

local boxLayer

local types = {"Viettel", "Vinaphone", "Mobifone"}
local apiType = {"VIETTEL", "VNP", "VMS"}

-- 名字不要重复
VNRechargeLayerOwner = VNRechargeLayerOwner or {}
ccb["VNRechargeLayerOwner"] = VNRechargeLayerOwner

local function closeItemClick(  )
    popUpCloseAction( VNRechargeLayerOwner,"infoBg",_layer )
end 
VNRechargeLayerOwner["closeItemClick"] = closeItemClick

local function checkOrderCallback( url,rtnData )
    
end

local function onOkClicked(  )
    local serialNum = _nserialEdit:getText()
    local cardId = _idEdit:getText()
    local vpcBank = apiType[tonumber(initIndex)]
    print(" Print By caiyaguang ---- ADD_MOBGAME_WP_ORDER ", serialNum, cardId)
    doActionFun("ADD_MOBGAME_WP_ORDER", {serialNum, cardId, vpcBank}, checkOrderCallback)
end 
VNRechargeLayerOwner["onOkClicked"] = onOkClicked

local function onCancelClicked(  )
    closeItemClick()
end 
VNRechargeLayerOwner["onCancelClicked"] = onCancelClicked

local function onTypeBtnClicked(  )
    if isOpen then
        isOpen = false
    else 
        isOpen = true
    end
    -- isOpen = isOpen and false or true
    boxLayer:setVisible(isOpen)
end 
VNRechargeLayerOwner["onTypeBtnClicked"] = onTypeBtnClicked

local function menuCallback( tag )
    initIndex = tag

    local str = types[tonumber(initIndex)]
    typelabel:setString(str)

    onTypeBtnClicked()
end

local function _refreshUI()
    boxLayer = VNRechargeLayerOwner["boxLayer"]
    boxLayer:setVisible(isOpen)

    local serialEditLayer = VNRechargeLayerOwner["serialLabel"]
    _nserialEdit = CCEditBox:create(CCSize(serialEditLayer:getContentSize().width,serialEditLayer:getContentSize().height),CCScale9Sprite:createWithSpriteFrameName("chat_bg.png"))
    _nserialEdit:setPosition(ccp(0,0))
    _nserialEdit:setAnchorPoint(ccp(0,0))
    _nserialEdit:setFont("ccbResources/FZCuYuan-M03S.ttf",30*retina)
    serialEditLayer:addChild(_nserialEdit)
    _nserialEdit:setTouchPriority(_priority-1)
    -- edit:setInputFlag(0)
    -- edit:setPlaceHolder(HLNSLocalizedString("6到12位英文或者数字"))
    local idEditLayer = VNRechargeLayerOwner["cardidLabel"]
    _idEdit = CCEditBox:create(CCSize(idEditLayer:getContentSize().width,idEditLayer:getContentSize().height),CCScale9Sprite:createWithSpriteFrameName("chat_bg.png"))
    _idEdit:setPosition(ccp(0,0))
    _idEdit:setAnchorPoint(ccp(0,0))
    _idEdit:setFont("ccbResources/FZCuYuan-M03S.ttf",30*retina)
    idEditLayer:addChild(_idEdit)
    _idEdit:setTouchPriority(_priority-1)

    typelabel = VNRechargeLayerOwner["typelabel"]
    typelabel:setString(types[tonumber(initIndex)])

    local menu2 = tolua.cast(VNRechargeLayerOwner["menu2"], "CCMenu")
    local Mwidth = menu2:getContentSize().width
    local Mheight = menu2:getContentSize().height
    local LINE_SPACE = 60
    for i,v in ipairs(types) do
        local testLabel = CCLabelTTF:create(v, "ccbResources/FZCuYuan-M03S.ttf", 24)
        local testMenuItem = CCMenuItemLabel:create(testLabel)
        testMenuItem:registerScriptTapHandler(menuCallback)
        testMenuItem:setPosition(ccp(Mwidth / 2, (Mheight - (i - 1) * LINE_SPACE) - 45))
        menu2:addChild(testMenuItem, i, i)
    end
end 

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/VNRechargeLayer.ccbi", proxy, true,"VNRechargeLayerOwner")
    _layer = tolua.cast(node,"CCLayer")
    print("fuck aslkdf")
    _refreshUI()
end

local function onTouchBegan(x, y)
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
    local menu1 = tolua.cast(VNRechargeLayerOwner["menu"], "CCMenu")
    menu1:setHandlerPriority(_priority-1)

    local menu2 = tolua.cast(VNRechargeLayerOwner["menu2"], "CCMenu")
    menu2:setHandlerPriority(_priority-2)
end

-- 该方法名字每个文件不要重复
function getVNRechargeLayer()
    return _layer
end

function createVNRechargeLayer(moneyNum, priority)
    _money = moneyNum
    _priority = (priority ~= nil) and priority or -132
    _init()

    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
    end

    local function _onExit()
        print("CreateNameLayer onExit")
        _layer = nil
        _nserialEdit = nil
        _idEdit = nil
        _priority = -132
    end

    --onEnter onExit
    local function _layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        end
    end


    _layer:registerScriptTouchHandler(onTouch ,false , _priority ,true )
    _layer:setTouchEnabled(true)
    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end