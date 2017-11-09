local _layer
local _priority
local _titleUid
local _titleText


-- 名字不要重复
CaptainGetNewTitleOwner = CaptainGetNewTitleOwner or {}
ccb["CaptainGetNewTitleOwner"] = CaptainGetNewTitleOwner

local function closeItemClick(  )

    popUpCloseAction( CaptainGetNewTitleOwner,"infoBg",_layer )
    -- _layer:removeFromParentAndCleanup(true) 
end

CaptainGetNewTitleOwner["closeItemClick"] = closeItemClick

local function allTitleInfoAction( )
    CCDirector:sharedDirector():getRunningScene():addChild(createAllTitleInfoLayer(-142),130)

    popUpCloseAction( CaptainGetNewTitleOwner,"infoBg",_layer )
    -- _layer:removeFromParentAndCleanup(true) 
end

CaptainGetNewTitleOwner["allTitleInfoAction"] = allTitleInfoAction

-- 刷新UI数据
local function _refreshData()
    local dic = titleData:getOneTitleByTitleId( _titleUid )
    if dic == nil then 
        return
    end
    local nameLabel = tolua.cast(CaptainGetNewTitleOwner["nameLabel"],"CCLabelTTF")
    nameLabel:setString(dic.conf.name)
    local attrLabel = tolua.cast(CaptainGetNewTitleOwner["attrLabel"],"CCLabelTTF")

    local rankFrame = tolua.cast(CaptainGetNewTitleOwner["rankFrame"],"CCSprite")
    rankFrame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", dic.conf.colorRank)))
    local avatarIcon = tolua.cast(CaptainGetNewTitleOwner["avatarIcon"],"CCSprite")
    if avatarIcon and dic.title.titleId then
        local texture = CCTextureCache:sharedTextureCache():addImage(equipdata:getEquipIconByEquipId( dic.title.titleId ))
        if texture then
            avatarIcon:setVisible(true)
            avatarIcon:setTexture(texture)
        end
    end
    if dic.conf.baseValue < 1 then
        attrLabel:setString(HLNSLocalizedString("title.innerPower")..((dic.conf.baseValue + (dic.title.level - 1) * dic.conf.updateValue) * 100).."%")
    else
        attrLabel:setString(HLNSLocalizedString("title.innerPower")..(dic.conf.baseValue + (dic.title.level - 1) * dic.conf.updateValue))
    end
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer

    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/CaptainGetNewTitle.ccbi",proxy, true,"CaptainGetNewTitleOwner")
    _layer = tolua.cast(node,"CCLayer")
    if _titleText then
        local titleLabel = tolua.cast(CaptainGetNewTitleOwner["titleLabel"],"CCLabelTTF")
        titleLabel:setString(_titleText)
    end
    _refreshData()
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(CaptainGetNewTitleOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction( CaptainGetNewTitleOwner,"infoBg",_layer )
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
    local menu1 = tolua.cast(CaptainGetNewTitleOwner["closeMenu"], "CCMenu")
    menu1:setHandlerPriority(_priority - 1)
end

-- 该方法名字每个文件不要重复
function getCaptainGetNewTitleLayer()
	return _layer
end
-- uitype 0:点击全部称号只消失 1：添加全部称号层
function createCaptainGetNewTitleLayer( titleUid,priority,titleText)
    _titleUid = titleUid
    _priority = (priority ~= nil) and priority or -132
    _titleText = titleText
    _init()

    local function _onEnter()
        print("onEnter")
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
        
        popUpUiAction( CaptainGetNewTitleOwner,"infoBg" )
    end

    local function _onExit()
        _layer = nil
        _titleUid = nil
        _priority = -132
        _titleText = nil
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