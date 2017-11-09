local _layer
local _priority = -132
local _shadowInfo
local _hid
local _pos
local _uitype


-- 名字不要重复
shadowPopupOwner = shadowPopupOwner or {}
ccb["shadowPopupOwner"] = shadowPopupOwner

local function closeItemClick(  )
    -- _layer:removeFromParentAndCleanup(true) 
    popUpCloseAction( shadowPopupOwner,"infoBg",_layer )
end


local function changeShadowClick(  )
    print("----- changeShadowClick -----")
    popUpCloseAction( shadowPopupOwner,"infoBg",_layer )
    getMainLayer():gotoChangeShadowLayer( _hid, _pos ,_shadowInfo)
end

local function upgradeShadowClick(  )
    print("------ upgradeShadowClick ----")
    local _mainLayer = getMainLayer()
    if _mainLayer then
        _mainLayer:gotoTrainShadowView(2)
    end
    popUpCloseAction( shadowPopupOwner,"infoBg",_layer )
end

shadowPopupOwner["closeItemClick"] = closeItemClick
shadowPopupOwner["changeShadowClick"] = changeShadowClick
shadowPopupOwner["upgradeShadowClick"] = upgradeShadowClick

-- 根据uitype 调整页面显示
local function updateContenView( uitype )
    local upgrateShadow = tolua.cast(shadowPopupOwner["upgrateShadow"],"CCMenuItemImage") 
    local changeBtn = tolua.cast(shadowPopupOwner["changeBtn"],"CCMenuItemImage")
    local closeBtn = tolua.cast(shadowPopupOwner["closeBtn"],"CCMenuItemImage")
    local updateSprite = tolua.cast(shadowPopupOwner["updateSprite"],"CCSprite")
    local changeSprite = tolua.cast(shadowPopupOwner["changeSprite"],"CCSprite")
    local closeSprite = tolua.cast(shadowPopupOwner["closeSprite"],"CCSprite")

    local flag                  --为1 表示只是影子详情
    if _uitype == 1 then
        flag = false
    else
        flag = true
    end
    upgrateShadow:setVisible(flag)
    updateSprite:setVisible(flag)
    changeBtn:setVisible(flag)
    changeSprite:setVisible(flag)
    closeBtn:setVisible(not flag)
    closeSprite:setVisible(not flag)
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer

    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/shadowPopup.ccbi",proxy, true,"shadowPopupOwner")
    _layer = tolua.cast(node,"CCLayer")

    local conf = _shadowInfo.conf
    local name = tolua.cast(shadowPopupOwner["name"], "CCLabelTTF")
    name:setString(conf.name)
    local rank = tolua.cast(shadowPopupOwner["rank"], "CCSprite")
    rank:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("rank_%d_icon.png", conf.rank)))
    local level = tolua.cast(shadowPopupOwner["level"], "CCLabelTTF")
    local attrArray
    if _shadowInfo.level then
        level:setString(string.format(HLNSLocalizedString("LV:%d"),_shadowInfo.level))
        attrArray = shadowData:getShadowAttrByLevelAndCid( _shadowInfo.level,_shadowInfo.id )
    else
        level:setVisible(false)
        attrArray = shadowData:getShadowAttrByLevelAndCid( 1,_shadowInfo.id )
    end

    local desp = tolua.cast(shadowPopupOwner["desp"], "CCLabelTTF")
    desp:setString(string.format("%s%s%s",conf.propertyName ,"  + ",attrArray.value))

    local shadowSpr = tolua.cast(shadowPopupOwner["shadowSpr"], "CCLayer")
    playCustomFrameAnimation( string.format("yingzi_%s_",conf.icon),shadowSpr,ccp(shadowSpr:getContentSize().width / 2,shadowSpr:getContentSize().height / 2),1,4,shadowData:getColorByColorRank( conf.rank ) )
            
    updateContenView( _uitype )
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(shadowPopupOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
    popUpCloseAction( shadowPopupOwner,"infoBg",_layer )
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
    local menu1 = tolua.cast(shadowPopupOwner["closeMenu"], "CCMenu")
    menu1:setHandlerPriority(_priority - 1)
end

-- 该方法名字每个文件不要重复
function getShadowPopupLayer()
	return _layer
end
-- uitype 0 可升级的弹框  1 影子详情弹框
function createShadowPopupLayer( info, hid, pos, priority, uitype)
    _shadowInfo = info
    _hid = hid
    _pos = pos
    _priority = (priority ~= nil) and priority or -132
    _uitype = (uitype ~= nil) and uitype or 0
    _init()

    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)

        -- local infoBg = tolua.cast(shadowPopupOwner["infoBg"], "CCSprite")
        -- infoBg:setScale(0.01)
        -- infoBg:runAction(CCEaseBounceOut:create(CCScaleTo:create(0.6,1)))
        popUpUiAction( shadowPopupOwner,"infoBg" )
    end

    local function _onExit()
        _layer = nil
        _priority = -132
        _uitype = nil
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