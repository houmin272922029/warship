local _layer
local _data = nil
local _uiType = 0       -- 0:可以点抽牌  1：点完抽牌   2：点了翻牌后

LuoBinViewOwner = LuoBinViewOwner or {}
ccb["LuoBinViewOwner"] = LuoBinViewOwner


-- 刷新按钮可点状态
local function _refreshBtns( uiType )
    local btnStatus = false
    local cardBtnStatus = false
    if _uiType == 0 then
        btnStatus = true
        cardBtnStatus = false
    elseif _uiType == 1 then
        btnStatus = false
        cardBtnStatus = true
    elseif _uiType == 2 then
        btnStatus = false
        cardBtnStatus = false
    end 
    local btn = tolua.cast(LuoBinViewOwner["btn"], "CCMenuItem")
    -- btn:setEnabled(btnStatus)
    btn:setVisible(btnStatus)
    local btnLabel = tolua.cast(LuoBinViewOwner["btnLabel"], "CCLabelTTF")
    btnLabel:setVisible(btnStatus)

    for i=1,8 do
        local card = tolua.cast(LuoBinViewOwner["card"..i], "CCSprite")
        if card then 
            local menuItem = tolua.cast(card:getChildByTag(12):getChildByTag(i), "CCMenuItem")
            if menuItem then
                menuItem:setEnabled(cardBtnStatus)
            end 
        end 
    end
end 


-- 显示单张卡
local function _displayCard( card, info )
    local iconSprite = tolua.cast(card:getChildByTag(200), "CCSprite")
    if iconSprite then
        iconSprite:removeFromParentAndCleanup(true)
    end 

    tolua.cast(card:getChildByTag(10), "CCSprite"):setVisible(false)
    local labelBg = tolua.cast(card:getChildByTag(11), "CCSprite")
    if labelBg then
        labelBg:setVisible(true)
    end 
    local label = tolua.cast(card:getChildByTag(11):getChildByTag(10), "CCLabelTTF")      -- 名字或数量信息
    if havePrefix( info.itemId, "hero_") then
        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/hero_head.plist")
        if CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(herodata:getHeroHeadByHeroId( info.itemId )) then 
            iconSprite = CCSprite:createWithSpriteFrameName(herodata:getHeroHeadByHeroId( info.itemId ))
        end
        iconSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(herodata:getHeroHeadByHeroId( info.itemId )))
        local heroConf = herodata:getHeroBasicInfoByHeroId( info.itemId )
        card:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", heroConf.rank)))
        if label then
            local heroConf = herodata:getHeroConfig(info.itemId)
            if heroConf and heroConf.name then
                label:setString(heroConf.name)
            end
        end 
    elseif haveSuffix(info.itemId, "_shard") then
        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/publicRes_4.plist")
        local shardContent = userdata:getExchangeResource(info.itemId)
        iconSprite = CCSprite:create(string.format("ccbResources/icons/%s.png",shardContent.icon)) 
        local chipIcon = CCSprite:createWithSpriteFrameName("itemChip_icon.png")
        iconSprite:addChild(chipIcon)
        chipIcon:setAnchorPoint(ccp(1,0))
        chipIcon:setPosition(ccp(iconSprite:getContentSize().width,0))
        card:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", shardContent.rank)))

        local name = shardContent.name
        if label then
            label:setString(name)
        end 
    else 
        local itemBasicInfo = wareHouseData:getItemResource(info.itemId)
        iconSprite = CCSprite:create(itemBasicInfo.icon) 
        card:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", itemBasicInfo.rank)))

        local name = itemBasicInfo.name
        if info.itemId == "gold" then
            name = info.amount..HLNSLocalizedString("金币")
        elseif info.itemId == "silver" then
            name = info.amount..HLNSLocalizedString("贝里")
        end 
        if label then
            label:setString(name)
        end 
    end 
    if iconSprite then 
        iconSprite:setAnchorPoint(ccp(0.5, 0.5))
        iconSprite:setPosition(ccp(card:getContentSize().width/2, card:getContentSize().height/2))
        iconSprite:setScale((card:getContentSize().width/iconSprite:getContentSize().width)*0.9)
        card:addChild(iconSprite, 1, 200)
    end 
    return iconSprite
end 


-- 刷新所有卡片上的信息
-- isFlip   0:卡片扣着   1:卡片翻过来  
local function _refreshRobinCardInfo( isFlip )
    for i=1,8 do
        local oneCardInfo = _data[tostring(i)]
        local card = tolua.cast(LuoBinViewOwner["card"..i], "CCSprite")
        if card then 
            -- 名字或数量信息
            local labelBg = tolua.cast(card:getChildByTag(11), "CCSprite")
            local iconSprite = nil -- tolua.cast(card:getChildByTag(10), "CCSprite")
            if isFlip == 0 then
                -- 没有领过的卡片扣着
                tolua.cast(card:getChildByTag(10), "CCSprite"):setVisible(true)
                if oneCardInfo.open == 1 then
                    tolua.cast(card:getChildByTag(10), "CCSprite"):setVisible(false)
                    -- 已领过的卡也要显示
                    iconSprite = _displayCard(card, oneCardInfo)
                    -- labelBg:setVisible(true)            -- 显示名字
                else 
                    iconSprite = tolua.cast(card:getChildByTag(200), "CCSprite")
                    if iconSprite then
                        iconSprite:removeFromParentAndCleanup(true)
                    end
                    labelBg:setVisible(false)            -- 不显示名字

                    -- renzhan
                    LuoBinViewOwner["lightingEffect_luobin"..i]:setVisible(true)
                    local animFrames = CCArray:create()
                    for j = 1, 3 do
                        local frameName = string.format("treasureCard_roundFrame_%d.png",j)
                        local fra = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(frameName)
                        animFrames:addObject(fra)
                    end
                    local animation = CCAnimation:createWithSpriteFrames(animFrames, 0.3)
                    local animate = CCAnimate:create(animation)
                    LuoBinViewOwner["lightingEffect_luobin"..i]:runAction(CCRepeatForever:create(animate))
                    -- 

                end 
            else 
                -- 所有卡片翻过来
                -- renzhan
                LuoBinViewOwner["lightingEffect_luobin"..i]:stopAllActions()
                LuoBinViewOwner["lightingEffect_luobin"..i]:setVisible(false)
                -- 
                local gotIcon = tolua.cast(card:getChildByTag(13), "CCSprite")
                tolua.cast(card:getChildByTag(10), "CCSprite"):setVisible(false)
                -- tolua.cast(card:getChildByTag(11), "CCSprite"):setVisible(true)            -- 显示名字
                iconSprite = _displayCard(card, oneCardInfo)
                if oneCardInfo.open == 0 then
                    -- 没领过的卡加上蒙版
                    card:setColor(ccc3(150,150,150))
                    if iconSprite then
                        iconSprite:setColor(ccc3(150,150,150))
                    end 
                    -- tolua.cast(card:getChildByTag(11), "CCSprite"):setColor(ccc3(150,150,150))
                    -- tolua.cast(card:getChildByTag(11):getChildByTag(10), "CCSprite"):setColor(ccc3(150,150,150))
                    gotIcon:setVisible(false)
                else 
                    if gotIcon then
                        gotIcon:setVisible(true)
                        gotIcon:setZOrder(2)
                    end 
                end 
            end 
        end 
    end
end 

-- 刷新UI
local function _refreshRobinUI()
    -- 提示文字加阴影
    for i=1,3 do
        local tip = tolua.cast(LuoBinViewOwner["tip"..i], "CCLabelTTF")
        if tip then
            -- tip:enableStroke(ccc3(0,0,0), 0.3)
            tip:enableShadow(CCSizeMake(2,-2), 1, 0)
        end 
    end

    -- 把卡片上的按钮透明度设为0
    for i=1,8 do
        local card = tolua.cast(LuoBinViewOwner["card"..i], "CCSprite")
        if card then 
            local menuItem = tolua.cast(card:getChildByTag(12):getChildByTag(i), "CCMenuItem")
            if menuItem then
                menuItem:setOpacity(0)
            end 
        end 
    end

    -- 
    if _data == nil then
        return
    end 
    if _data.takeReward == 0 then
        -- 今日没领
        _refreshRobinCardInfo(1)
        local btn = tolua.cast(LuoBinViewOwner["btn"], "CCMenuItem")
        if btn then
            btn:setVisible(true)
        end 
    else 
        -- 今日已领
        _refreshRobinCardInfo(1)
        local tip2 = tolua.cast(LuoBinViewOwner["tip2"], "CCLabelTTF")
        if tip2 then 
            tip2:setVisible(true)
        end 
    end 
    local btn = tolua.cast(LuoBinViewOwner["btn"], "CCMenuItem")
    if btn then
        btn:setVisible(_data.takeReward == 0 and true or false)
    end 
    local btnLabel = tolua.cast(LuoBinViewOwner["btnLabel"], "CCLabelTTF")
    if btnLabel then
        btnLabel:setVisible(_data.takeReward == 0 and true or false)
    end 

    -- 刷新按钮状态
    _refreshBtns(_uiType)
end


local function changeCardInfo()
    
end 
LuoBinViewOwner["changeCardInfo"] = changeCardInfo

-- 没领的卡片扣起来
local function changeCard()
    _refreshRobinCardInfo( 0 )
end 

local function onTurnCardClicked()
    local card1 = tolua.cast(LuoBinViewOwner["card1"], "CCSprite")
    local card2 = tolua.cast(LuoBinViewOwner["card2"], "CCSprite")
    local card3 = tolua.cast(LuoBinViewOwner["card3"], "CCSprite")
    local card4 = tolua.cast(LuoBinViewOwner["card4"], "CCSprite")
    local card5 = tolua.cast(LuoBinViewOwner["card5"], "CCSprite")
    local card6 = tolua.cast(LuoBinViewOwner["card6"], "CCSprite")
    local card7 = tolua.cast(LuoBinViewOwner["card7"], "CCSprite")
    local card8 = tolua.cast(LuoBinViewOwner["card8"], "CCSprite")

    local array1 = CCArray:create()
    array1:addObject(CCMoveTo:create(1/3, ccp(320, 280)))
    array1:addObject(CCDelayTime:create(1/3))
    array1:addObject(CCMoveTo:create(1/3, ccp(205, 499)))
    card1:runAction(CCSequence:create(array1))

    local array2 = CCArray:create()
    array2:addObject(CCMoveTo:create(1/3, ccp(320, 280)))
    array2:addObject(CCDelayTime:create(1/3))
    array2:addObject(CCMoveTo:create(1/3, ccp(96, 366.0)))
    card2:runAction(CCSequence:create(array2))

    local array3 = CCArray:create()
    array3:addObject(CCMoveTo:create(1/3, ccp(320, 280)))
    array3:addObject(CCDelayTime:create(1/3))
    array3:addObject(CCMoveTo:create(1/3, ccp(96, 228)))
    card3:runAction(CCSequence:create(array3))

    local array4 = CCArray:create()
    array4:addObject(CCMoveTo:create(1/3, ccp(320, 280)))
    array4:addObject(CCDelayTime:create(1/3))
    array4:addObject(CCMoveTo:create(1/3, ccp(205, 102)))
    card4:runAction(CCSequence:create(array4))

    local array5 = CCArray:create()
    array5:addObject(CCMoveTo:create(1/3, ccp(320, 280)))
    array5:addObject(CCDelayTime:create(1/3))
    array5:addObject(CCMoveTo:create(1/3, ccp(437.0, 102.0)))
    card5:runAction(CCSequence:create(array5))

    local array6 = CCArray:create()
    array6:addObject(CCMoveTo:create(1/3, ccp(320, 280)))
    array6:addObject(CCDelayTime:create(1/3))
    array6:addObject(CCMoveTo:create(1/3, ccp(551.0, 228.0)))
    card6:runAction(CCSequence:create(array6))

    local array7 = CCArray:create()
    array7:addObject(CCMoveTo:create(1/3, ccp(320, 280)))
    array7:addObject(CCDelayTime:create(1/3))
    array7:addObject(CCMoveTo:create(1/3, ccp(551.0, 366.0)))
    card7:runAction(CCSequence:create(array7))

    local array8 = CCArray:create()
    array8:addObject(CCMoveTo:create(1/3, ccp(320, 280)))
    array8:addObject(CCDelayTime:create(1/3))
    array8:addObject(CCMoveTo:create(1/3, ccp(437.0, 499.0)))
    card8:runAction(CCSequence:create(array8))

    local array = CCArray:create()
    array:addObject(CCDelayTime:create(2/3))
    array:addObject(CCCallFunc:create(changeCard))
    _layer:runAction(CCSequence:create(array))

    _uiType = 1
    _refreshBtns(_uiType)
end
LuoBinViewOwner["onTurnCardClicked"] = onTurnCardClicked

local function showRewardAni(  )
    userdata:popUpGain(runtimeCache.responseData["gain"], true)  
end
local function robinCallBack( url,rtnData )
    -- 获得奖励动画
    runtimeCache.responseData = rtnData.info
    if rtnData["info"]["hit"] then
        for k,v in pairs(rtnData["info"]["hit"]) do
            print(k,v)
            local card = tolua.cast(LuoBinViewOwner["card"..k], "CCSprite")
            _displayCard(card, v)
        end
    end
    dailyData.daily[Daily_Robin] = rtnData["info"]["robin"]
    _data = dailyData:getDailyDataByName(Daily_Robin)
    local arr = CCArray:create()
    local delay1 = CCDelayTime:create(1.0)
    local delay2 = CCDelayTime:create(0.5)
    local show1 = CCCallFunc:create(_refreshRobinUI)
    local show2 = CCCallFunc:create(showRewardAni)
    arr:addObject(delay1)
    arr:addObject(show1)
    arr:addObject(delay2)
    arr:addObject(show2)
    local seq = CCSequence:create(arr)
    -- local seq = CCSequence:createWithTwoActions(CCDelayTime:create(1.0), CCCallFunc:create(_refreshRobinUI), CCDelayTime:create(0.5), CCCallFunc:create(showRewardAni))
    if _layer then
        _layer:runAction(seq)
    end
    postNotification(NOTI_DAILY_STATUS, nil)
end 

local function onCardClicked(tag)
    Global:instance():TDGAonEventAndEventData("card")
    print(tag)
    if _data == nil then 
        return
    end 

    local oneCardInfo = _data[tostring(tag)]
    if oneCardInfo.open == 1 then
        return
    end 

    _uiType = 2
    -- DAILY_ROBIN
    doActionFun("DAILY_ROBIN", {tag}, robinCallBack)
end
LuoBinViewOwner["onCardClicked"] = onCardClicked

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/DailyLuoBinFlowerView.ccbi",proxy, true,"LuoBinViewOwner")
    _layer = tolua.cast(node,"CCLayer")

    _data = dailyData:getDailyDataByName(Daily_Robin)

    _uiType = (_data.takeReward == 0) and 0 or 2
    _refreshRobinUI()
end

-- 该方法名字每个文件不要重复
function getLuoBinFlowerLayer()
	return _layer
end

function createLuoBinFlowerLayer()
    _init()

    local function _onEnter()
    end

    local function _onExit()
        _layer = nil
        _data = nil
        _uiType = 0
    end

    --onEnter onExit
    local function _layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        end
    end


    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end