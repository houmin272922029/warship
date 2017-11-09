local _layer
local _index
local _data
local _func
local _priority = -140

-- 名字不要重复
VeiledSeaSelectedOwner = VeiledSeaSelectedOwner or {}
ccb["VeiledSeaSelectedOwner"] = VeiledSeaSelectedOwner

local function closeItemClick()
    _layer:removeFromParentAndCleanup(true)
end
VeiledSeaSelectedOwner["closeItemClick"] = closeItemClick

local function confirmBtnClick()
    _func(_index)
    closeItemClick()
end
VeiledSeaSelectedOwner["confirmBtnClick"] = confirmBtnClick

local function refresh()
    local contentLayer = tolua.cast(VeiledSeaSelectedOwner["contentLayer"], "CCLayer")
    local frame = tolua.cast(VeiledSeaSelectedOwner["frame"], "CCSprite")
    local bigSprite = tolua.cast(VeiledSeaSelectedOwner["bigSprite"], "CCSprite")
    local chipIcon = tolua.cast(VeiledSeaSelectedOwner["chipIcon"], "CCSprite")
    local littleSprite = tolua.cast(VeiledSeaSelectedOwner["littleSprite"], "CCSprite")
    local soulIcon = tolua.cast(VeiledSeaSelectedOwner["soulIcon"], "CCSprite")
    local countLabel = tolua.cast(VeiledSeaSelectedOwner["count"], "CCLabelTTF")
    local nameLabel = tolua.cast(VeiledSeaSelectedOwner["name"], "CCLabelTTF")

    local itemId = _data.itemId
    local count = _data.value
    local resDic = userdata:getExchangeResource(itemId)

    if havePrefix(itemId, "weapon_") or havePrefix(itemId, "belt_") or havePrefix(itemId, "armor_") then
        -- 装备
        bigSprite:setVisible(true)
        local texture
        if haveSuffix(itemId, "_shard") then
            chipIcon:setVisible(true)
            texture = CCTextureCache:sharedTextureCache():addImage(string.format("ccbResources/icons/%s.png", resDic.icon))
        else
            texture = CCTextureCache:sharedTextureCache():addImage(resDic.icon)
        end
        if texture then
            bigSprite:setVisible(true)
            bigSprite:setTexture(texture)
            if resDic.rank == 4 then
                HLAddParticleScale( "images/purpleEquip.plist", bigSprite, ccp(bigSprite:getContentSize().width / 2,
                    bigSprite:getContentSize().height / 2), 1, 100, 777, 2 / 0.35 / retina, 2 / 0.35 / retina, 1 )
            end
        end

    elseif havePrefix(itemId, "item") then
        -- 道具
        bigSprite:setVisible(true)
        local texture = CCTextureCache:sharedTextureCache():addImage(resDic.icon)
        if texture then
            bigSprite:setVisible(true)
            bigSprite:setTexture(texture)
            if resDic.rank == 4 then
                HLAddParticleScale( "images/purpleEquip.plist", bigSprite, ccp(bigSprite:getContentSize().width / 2,
                    bigSprite:getContentSize().height / 2), 1, 100, 777, 2 / 0.35 / retina, 2 / 0.35 / retina, 1 )
            end
        end
    elseif havePrefix(itemId, "shadow") then
        -- 影子
        local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
        cache:addSpriteFramesWithFile("ccbResources/shadow.plist")

        frame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("s_frame.png"))

        frame:setPosition(ccp(frame:getPositionX() + 5,frame:getPositionY() - 5))
        if resDic.icon then
            playCustomFrameAnimation( string.format("yingzi_%s_",resDic.icon), contentLayer, ccp(contentLayer:getContentSize().width / 2,contentLayer:getContentSize().height / 2),1,4,shadowData:getColorByColorRank( resDic.rank ) )
        end
    elseif havePrefix(itemId, "hero") then
        -- 魂魄
        littleSprite:setVisible(true)
        littleSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(resDic.icon))

    elseif havePrefix(itemId, "book") then
        -- 奥义
        bigSprite:setVisible(true)
        local texture = CCTextureCache:sharedTextureCache():addImage(resDic.icon)
        if texture then
            bigSprite:setVisible(true)
            bigSprite:setTexture(texture)
            if resDic.rank == 4 then
                HLAddParticleScale( "images/purpleEquip.plist", bigSprite, ccp(bigSprite:getContentSize().width / 2,
                    bigSprite:getContentSize().height / 2), 1, 100, 777, 2 / 0.35 / retina, 2 / 0.35 / retina, 1)
            end
        end
    else
        -- 金币 银币
        bigSprite:setVisible(true)
        local texture = CCTextureCache:sharedTextureCache():addImage(resDic.icon)
        if texture then
            bigSprite:setVisible(true)
            bigSprite:setTexture(texture)
            if resDic.rank == 4 then
                HLAddParticleScale( "images/purpleEquip.plist", bigSprite, ccp(bigSprite:getContentSize().width / 2,
                    bigSprite:getContentSize().height / 2), 1, 100, 777, 2 / 0.35 / retina, 2 / 0.35 / retina, 1 )
            end
        end
    end
    if not havePrefix(itemId, "shadow") then
        frame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", resDic.rank)))
    end

    -- 设置名字和数量
    countLabel:setString(count)
    nameLabel:setString(resDic.name)
    nameLabel:setColor(shadowData:getColorByColorRank(resDic.rank))

    local tips = tolua.cast(VeiledSeaSelectedOwner["tips"], "CCLabelTTF")
    tips:setString(HLNSLocalizedString("veiledsea.buyone.tips", _data.gold))
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/VeiledSeaSelectedView.ccbi", proxy, true,"VeiledSeaSelectedOwner")
    _layer = tolua.cast(node,"CCLayer")

    refresh()
end


local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(VeiledSeaSelectedOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction(VeiledSeaSelectedOwner, "infoBg", _layer)
        return true
    end
    return true
end

local function onTouch(eventType, x, y)
    if eventType == "began" then   
        return onTouchBegan(x, y)
    end
end

local function setMenuPriority()
    local menu = tolua.cast(VeiledSeaSelectedOwner["menu"], "CCMenu")
    menu:setHandlerPriority(_priority - 1)
end

-- 该方法名字每个文件不要重复
function getVeiledSeaChallengeLayer()
	return _layer
end

function createVeiledSeaSelectedLayer(index, data, func, priority)
    _index = index
    _data = data
    _func = func
    _priority = (priority ~= nil) and priority or -140
    _init()

    local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
    _layer:runAction(seq)

    local function _onEnter()

    end

    local function _onExit()
        _layer = nil
        _data = nil
    end

    --onEnter onExit
    local function _layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        end
    end

    local function onTouch(eventType, x, y)
        if eventType == "began" then   
            return onTouchBegan(x, y)
        elseif eventType == "moved" then
        elseif eventType == "ended" then
        end
    end 

    _layer:registerScriptTouchHandler(onTouch, false, _priority, true)
    _layer:setTouchEnabled(true)
    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end