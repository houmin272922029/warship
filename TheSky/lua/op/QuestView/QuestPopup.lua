local _layer
local _priority
local _data
local _key

QuestPopupOwner = QuestPopupOwner or {}
ccb["QuestPopupOwner"] = QuestPopupOwner

local function onTouchBegan(x, y)
    return true
end

local function onTouch(eventType, x, y)
    if eventType == "began" then   
        return onTouchBegan(x, y)
    end
end

-- 修改 按钮优先级
local function setMenuPriority()
    local menu = tolua.cast(QuestPopupOwner["menu"], "CCMenu")
    menu:setHandlerPriority(_priority - 1)
end

local function refresh()
    local title = tolua.cast(QuestPopupOwner["title"], "CCLabelTTF")
    local cfg = questdata:getQuestConfig(_data.id, _key)
    title:setString(string.format("%s(%d/%d)", cfg.name, _data.progress, cfg.progress["end"]))
    local desp = tolua.cast(QuestPopupOwner["desp"], "CCLabelTTF")
    desp:setString(_data.desp)

    local rewardItem = tolua.cast(QuestPopupOwner["rebateItem"], "CCMenuItem")
    local contentLayer = tolua.cast(QuestPopupOwner["contentLayer"],"CCLayer")
    local bigSprite = tolua.cast(QuestPopupOwner["bigSprite"],"CCSprite")
    local chipIcon = tolua.cast(QuestPopupOwner["chipIcon"],"CCSprite")
    local littleSprite = tolua.cast(QuestPopupOwner["littleSprite"],"CCSprite")
    local soulIcon = tolua.cast(QuestPopupOwner["soulIcon"],"CCSprite")
    local countBg = tolua.cast(QuestPopupOwner["countBg"],"CCLabelTTF")
    local countLabel = tolua.cast(QuestPopupOwner["countLabel"],"CCLabelTTF")

    if getMyTableCount(cfg.reward) > 1 then
        -- 显示礼包
        local texture = CCTextureCache:sharedTextureCache():addImage("ccbResources/icons/vip_001.png")
        if texture then
            bigSprite:setVisible(true)
            bigSprite:setTexture(texture)
        end
        rewardItem:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("frame_4.png"))
        rewardItem:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("frame_4.png"))
    else
        -- 显示单个道具
        local itemId
        local count
        for k,v in pairs(cfg.reward) do
            itemId = k
            count = v
            break
        end
        local resDic = userdata:getExchangeResource(itemId)

        if havePrefix(itemId, "shadow") then
            -- 影子
            rewardItem:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("s_frame.png"))
            rewardItem:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("s_frame.png"))

            rewardItem:setPosition(ccp(rewardItem:getPositionX() + 5,rewardItem:getPositionY() - 5))
            if resDic.icon then
                playCustomFrameAnimation(string.format("yingzi_%s_", resDic.icon), contentLayer, ccp(contentLayer:getContentSize().width / 2, 
                    contentLayer:getContentSize().height / 2), 1, 4, shadowData:getColorByColorRank(resDic.rank))
            end
        elseif havePrefix(itemId, "hero") then
            -- 魂魄
            littleSprite:setVisible(true)
            littleSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(resDic.icon))
        else
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
            end
        end
        if not havePrefix(itemId, "shadow") then
            rewardItem:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", resDic.rank)))
            rewardItem:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", resDic.rank)))
        end
        countBg:setVisible(true)
        countLabel:setString(count)
    end
end

local function animation()
    local function remove()
        _layer:removeFromParentAndCleanup(true)
    end
    local function popup()
        local infoBg = tolua.cast(QuestPopupOwner["infoBg"], "CCSprite") 
        local array = CCArray:create()
        array:addObject(CCDelayTime:create(0.2))
        array:addObject(CCMoveBy:create(0.5, ccp(0, -190 * retina)))
        array:addObject(CCDelayTime:create(2))
        array:addObject(CCMoveBy:create(0.5, ccp(0, 190 * retina)))
        infoBg:runAction(CCSequence:create(array))
    end
    local array = CCArray:create()
    array:addObject(CCCallFunc:create(popup))
    array:addObject(CCDelayTime:create(3.5))
    array:addObject(CCCallFunc:create(remove))
    _layer:runAction(CCSequence:create(array))
end

local function rewardItemClick()
    local qType = _key == "once" and 1 or 2
    local function callback(url, rtnData)
        postNotification(NOTI_QUEST, nil)
    end
    doActionFun("QUEST_REWARD", {qType, _data.id}, callback)
end
QuestPopupOwner["rewardItemClick"] = rewardItemClick


local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/QuestPopup.ccbi", proxy, true, "QuestPopupOwner")
    _layer = tolua.cast(node, "CCLayer")

    refresh()
end

function createQuestPopupLayer()
    _data, _key = questdata:pushComplete()
    if not _data or not _key then
        return nil
    end
    _priority = -130
    _init()

    local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
    _layer:runAction(seq)

    local function _onEnter()
        animation()
    end

    local function _onExit()
        _priority = -130
        _data = nil
        _key = nil
    end

    --onEnter onExit
    local function _layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        end
    end

    _layer:registerScriptTouchHandler(onTouch, false, _priority, false)
    _layer:setTouchEnabled(true)
    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end