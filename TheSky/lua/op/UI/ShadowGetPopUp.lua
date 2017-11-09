local _layer
local _priority
local _sid

-- 名字不要重复
ShadowGetPopupViewOwner = ShadowGetPopupViewOwner or {}
ccb["ShadowGetPopupViewOwner"] = ShadowGetPopupViewOwner

local function closeItemClick(  )
    popUpCloseAction( ShadowGetPopupViewOwner,"infoBg",_layer ) 
end 

ShadowGetPopupViewOwner["closeItemClick"] = closeItemClick

local function onCloseBtnTaped(  )
    popUpCloseAction( ShadowGetPopupViewOwner,"infoBg",_layer )
end 

ShadowGetPopupViewOwner["onCloseBtnTaped"] = onCloseBtnTaped

local function _refreshData(  )
    -- local bookId = string.gsub(string.sub(_chapterId, 0, 14), "chapter", "book")
    -- local conf = wareHouseData:getItemConfig(_chapterId)
    -- local bookConf = skilldata:getSkillConfig(bookId) 
    local content = shadowData:getOneShadowByUID( _sid )

    local topLabel = tolua.cast(ShadowGetPopupViewOwner["topLabel"],"CCLabelTTF")
    topLabel:setString(HLNSLocalizedString("恭喜船长获得了“%s”影子",content.conf.name))

    local nameLabel = tolua.cast(ShadowGetPopupViewOwner["nameLabel"],"CCLabelTTF")
    nameLabel:setString(HLNSLocalizedString("%s影子",content.conf.name))

    local levelIconTTF = tolua.cast(ShadowGetPopupViewOwner["levelIconTTF"],"CCLabelTTF")
    levelIconTTF:setString(content.shadow.level)

    -- local countLabel = tolua.cast(ShadowGetPopupViewOwner["countLabel"],"CCLabelTTF")
    -- countLabel:setString(HLNSLocalizedString("数量：").."1")

    local rankLayer = tolua.cast(ShadowGetPopupViewOwner["rankLayer"],"CCLayer")
    if content.conf.icon then
        playCustomFrameAnimation( string.format("yingzi_%s_",content.conf.icon),rankLayer,ccp(rankLayer:getContentSize().width / 2,rankLayer:getContentSize().height / 2),1,4,shadowData:getColorByColorRank( content.conf.rank ) )
    end

    local attrArray = shadowData:getShadowAttrByLevelAndCid( content.shadow.level,content.shadow.shadowId )

    local attrLabel = tolua.cast(ShadowGetPopupViewOwner["attrLabel"],"CCLabelTTF")
    attrLabel:setString(attrArray.value)

    local attSprite = tolua.cast(ShadowGetPopupViewOwner["attrIcon"],"CCSprite")
    attSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(equipdata:getDisplayFrameByType(attrArray.type)))
    -- local avatarSprite = tolua.cast(ShadowGetPopupViewOwner["avatarSprite"], "CCSprite")
    -- if avatarSprite then
    --     local headSpr = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(herodata:getHeroHeadByHeroId(soulConf.heroId))
    --     if headSpr then
    --         avatarSprite:setVisible(true)
    --         avatarSprite:setDisplayFrame(headSpr)
    --     end 
    -- end 

    -- local rankSprite = tolua.cast(ShadowGetPopupViewOwner["rankSprite"],"CCSprite")
    -- rankSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", soulConf.rank)))
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/ShadowGetPopUp.ccbi",proxy, true,"ShadowGetPopupViewOwner")
    _layer = tolua.cast(node,"CCLayer")
    _refreshData()
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(ShadowGetPopupViewOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction( ShadowGetPopupViewOwner,"infoBg",_layer )
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
    local menu1 = tolua.cast(ShadowGetPopupViewOwner["closeMenu"], "CCMenu")
    menu1:setHandlerPriority(_priority - 1)
end

-- 该方法名字每个文件不要重复
function getShadowGetPopUpLayer()
	return _layer
end

function createShadowGetPopUpLayer( sid, priority)
    _sid = sid
    _priority = (priority ~= nil) and priority or -132
    _init()

    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)

        popUpUiAction( ShadowGetPopupViewOwner,"infoBg" )
    end

    local function _onExit()
        _layer = nil
        _sid = nil
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


    _layer:registerScriptTouchHandler(onTouch ,false ,_priority ,true )
    _layer:setTouchEnabled(true)
    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end