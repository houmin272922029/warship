local _layer
local _priority
local _soulId
local _count
local _topTitle

-- 名字不要重复
SingSongSuccessViewOwner = SingSongSuccessViewOwner or {}
ccb["SingSongSuccessViewOwner"] = SingSongSuccessViewOwner

local function closeItemClick(  )
    popUpCloseAction( SingSongSuccessViewOwner,"infoBg",_layer )
end 

SingSongSuccessViewOwner["closeItemClick"] = closeItemClick

local function onCloseBtnTaped(  )
    popUpCloseAction( SingSongSuccessViewOwner,"infoBg",_layer )
end 

SingSongSuccessViewOwner["onCloseBtnTaped"] = onCloseBtnTaped

local function _refreshData(  )
    -- local bookId = string.gsub(string.sub(_chapterId, 0, 14), "chapter", "book")
    -- local conf = wareHouseData:getItemConfig(_chapterId)
    -- local bookConf = skilldata:getSkillConfig(bookId) 
    local soulConf = herodata:getHeroConfig(_soulId)

    local topTitle = tolua.cast(SingSongSuccessViewOwner["topTitle"],"CCLabelTTF")
    if _topTitle then
        topTitle:setString(_topTitle)
    end

    local topLabel = tolua.cast(SingSongSuccessViewOwner["topLabel"],"CCLabelTTF")
    topLabel:setString(HLNSLocalizedString("恭喜船长获得了%s个“%s”魂魄", _count, soulConf.name))

    local nameLabel = tolua.cast(SingSongSuccessViewOwner["nameLabel"],"CCLabelTTF")
    nameLabel:setString(soulConf.name)

    local despLabel = tolua.cast(SingSongSuccessViewOwner["despLabel"],"CCLabelTTF")
    despLabel:setString(soulConf.desp)

    local countLabel = tolua.cast(SingSongSuccessViewOwner["countLabel"],"CCLabelTTF")
    countLabel:setString(_count)

    local avatarSprite = tolua.cast(SingSongSuccessViewOwner["avatarSprite"], "CCSprite")
    if avatarSprite then
        local headSpr = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(herodata:getHeroHeadByHeroId(soulConf.heroId))
        if headSpr then
            avatarSprite:setVisible(true)
            avatarSprite:setDisplayFrame(headSpr)
        end 
    end 

    local rankSprite = tolua.cast(SingSongSuccessViewOwner["rankSprite"],"CCSprite")
    rankSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", soulConf.rank)))
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/SingSongSuccessView.ccbi",proxy, true,"SingSongSuccessViewOwner")
    _layer = tolua.cast(node,"CCLayer")
    _refreshData()
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(SingSongSuccessViewOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction( SingSongSuccessViewOwner,"infoBg",_layer )
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
    local menu1 = tolua.cast(SingSongSuccessViewOwner["closeMenu"], "CCMenu")
    menu1:setHandlerPriority(_priority - 1)
end

-- 该方法名字每个文件不要重复
function getSingSongSuccessLayer()
	return _layer
end

function createSingSongSuccessLayer( soulId, count, priority, topTitle)
    _soulId = soulId
    _count = count
    _topTitle = topTitle
    _priority = (priority ~= nil) and priority or -132
    _init()

    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)

        popUpUiAction( SingSongSuccessViewOwner,"infoBg" )
    end

    local function _onExit()
        _layer = nil
        _soulId = nil
        _priority = -132
        _count = nil
        _topTitle = nil
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