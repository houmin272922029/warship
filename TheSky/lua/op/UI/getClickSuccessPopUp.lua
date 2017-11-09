local _layer
local _priority
local _contentText

-- 名字不要重复
GoldBellSuccessViewOwner = GoldBellSuccessViewOwner or {}
ccb["GoldBellSuccessViewOwner"] = GoldBellSuccessViewOwner

local function closeItemClick(  )
    popUpCloseAction( GoldBellSuccessViewOwner,"infoBg",_layer )
end 

GoldBellSuccessViewOwner["closeItemClick"] = closeItemClick
GoldBellSuccessViewOwner["onConfirmTaped"] = closeItemClick

local function onShareTaped(  )
    local shareInfo = {pic = fileUtil:fullPathForFilename("images/sharePic_2.jpg"), text = string.format(ConfigureStorage.Share[9]["content"]), size = 1}--1是分享小图
    local share = createShareLayer(shareInfo, _priority - 1)
    CCDirector:sharedDirector():getRunningScene():addChild(share,100)
    popUpCloseAction( GoldBellSuccessViewOwner,"infoBg",_layer )
end

GoldBellSuccessViewOwner["onShareTaped"] = onShareTaped

local function onCloseBtnTaped(  )
    popUpCloseAction( GoldBellSuccessViewOwner,"infoBg",_layer ) 
end 

GoldBellSuccessViewOwner["onCloseBtnTaped"] = onCloseBtnTaped

local function _refreshData(  )
    local contentLabel = tolua.cast(GoldBellSuccessViewOwner["contentLabel"],"CCLabelTTF")
    if _contentText then
        contentLabel:setString(HLNSLocalizedString("恭贺船长大人获得%s金币！",_contentText))
    else
        contentLabel:setString("")
    end
    local despLabel = tolua.cast(GoldBellSuccessViewOwner["despLabel"],"CCLabelTTF")
    if _contentText then
        despLabel:setString(HLNSLocalizedString("钟声一响，黄金万两！恭贺船长大人获得%s金币！",_contentText))
    else
        despLabel:setString("")
    end

    if not isOpenShare(  ) then
        local  sharebtn = tolua.cast(GoldBellSuccessViewOwner["goldsharebtn"],"CCMenuItemImage")
        local  sharefont = tolua.cast(GoldBellSuccessViewOwner["goldsharefont"],"CCSprite")
        sharebtn:setVisible(false)
        sharefont:setVisible(false)
    end
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/GetGoldBellSuccessView.ccbi",proxy, true,"GoldBellSuccessViewOwner")
    _layer = tolua.cast(node,"CCLayer")
    _refreshData()
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(GoldBellSuccessViewOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction( GoldBellSuccessViewOwner,"infoBg",_layer )
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
    local menu1 = tolua.cast(GoldBellSuccessViewOwner["closeMenu"], "CCMenu")
    menu1:setHandlerPriority(_priority - 1)
end

-- 该方法名字每个文件不要重复
function getClickBellSuccessLayer()
	return _layer
end

function createClickBellSuccessLayer( contentText,priority)
    _contentText = contentText
    _priority = (priority ~= nil) and priority or -130
    _init()

    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)

        popUpUiAction( GoldBellSuccessViewOwner,"infoBg" )
    end

    local function _onExit()
        _layer = nil
        _priority = -130
        _contentText = nil
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