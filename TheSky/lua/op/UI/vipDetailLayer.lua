local _layer
local _priority 
local progress

local _touchBeganLocationX
local _touchBeganLocationY
local _index
local _cellBgMiddle
local _LVIndex = 1
-- 是否在移动
local _isMove = false
local _isTouch = false
local _isAdd = false
local _Type

local _currentIndex = 0

local TAP_TYPE = {
    reward = "reward", -- 奖励
    Privilege = "Privilege", -- 特权
}

-- 名字不要重复
vipDetailOwner = vipDetailOwner or {}
ccb["vipDetailOwner"] = vipDetailOwner

local function closeItemClick()
    popUpCloseAction(vipDetailOwner, "infoBg", _layer)
end
vipDetailOwner["closeItemClick"] = closeItemClick

--客服小美按钮回调
local function SupportSisterBtnClick()
    popUpCloseAction(vipDetailOwner, "infoBg", _layer)
    getMainLayer():addChild(createVipSupportLayer(_priority - 5),100)
end
vipDetailOwner["SupportSisterBtnClick"] = SupportSisterBtnClick

function getMyCurrentLvLevel( )
    if _LVIndex >= 13 then
        _LVIndex = 13
    end 
    return _LVIndex
end

local function animationFadeIn(item)
    local myItemFadeIn = item
    local array = CCArray:create()
    array:addObject(CCFadeIn:create(1.5))
    myItemFadeIn:runAction(CCSequence:create(array))
end

local function animationFadeOut(item)
    local myItemFadeOut = item
    local array = CCArray:create()
    array:addObject(CCFadeOut:create(1.5))
    myItemFadeOut:runAction(CCSequence:create(array))
end

-- 隐藏上一阶段所有元素
local function hideItems()
    for i=1,4 do
        local itemBtn = tolua.cast(vipDetailOwner["itemBtn"..i], "CCMenuItem")
        local contentLayer = tolua.cast(vipDetailOwner["contentLayer"..i], "CCLayer")
        local nameLabel = tolua.cast(vipDetailOwner["nameLabel"..i], "CCLabelTTF")
        local countLabel = tolua.cast(vipDetailOwner["countLabel"..i], "CCLabelTTF")
        local bigSprite = tolua.cast(vipDetailOwner["bigSprite"..i], "CCSprite")
        local littleSprite = tolua.cast(vipDetailOwner["littleSprite"..i], "CCSprite")
        local soulIcon = tolua.cast(vipDetailOwner["soulIcon"..i], "CCSprite")

        itemBtn:setVisible(false)
        contentLayer:setVisible(false)
        bigSprite:setVisible(false)
        littleSprite:setVisible(false)
        soulIcon:setVisible(false)
    end

     for i=1, 4 do
        local itemBtn = tolua.cast(vipDetailOwner["dayItemBtn"..i], "CCMenuItem")
        
        local contentLayer = tolua.cast(vipDetailOwner["dayContentLayer"..i], "CCLayer")
        local nameLabel = tolua.cast(vipDetailOwner["dayNameLabel"..i], "CCLabelTTF")
        local countLabel = tolua.cast(vipDetailOwner["dayCountLabel"..i], "CCLabelTTF")
        local bigSprite = tolua.cast(vipDetailOwner["dayBigSprite"..i], "CCSprite")
        local littleSprite = tolua.cast(vipDetailOwner["dayLittleSprite"..i], "CCSprite")
        local soulIcon = tolua.cast(vipDetailOwner["daySoulIcon"..i], "CCSprite")

        itemBtn:setVisible(false)
        contentLayer:setVisible(false)
        bigSprite:setVisible(false)
        littleSprite:setVisible(false)
        soulIcon:setVisible(false)
    end
end


-- 向左滑动
local function bySwipingLeft()
    if _isMove then
        return
    end
    _LVIndex = _LVIndex + 1 
    if _LVIndex > 13 then
        _LVIndex = 1
    end
    _currentIndex = 1

    hideItems()
    _refreshVipDetailLayer()
end

-- 向右滑动
local function bySwipingRight()
    if _isMove then
        return
    end
    _LVIndex = _LVIndex - 1 
    if _LVIndex < 1 then
        _LVIndex = 13
    end
    _currentIndex = 1

    hideItems()
    _refreshVipDetailLayer()
    
end

-- 向左点击 
local function teamLeftBtnClick()
    if _isTouch then
        return
    end
    _LVIndex = _LVIndex - 1 
    if _LVIndex < 1 then
        _LVIndex = 13
    end
    _currentIndex = 1
    hideItems()
    _refreshVipDetailLayer()
    
end
vipDetailOwner["teamLeftBtnClick"] = teamLeftBtnClick

-- 向右点击
local function teamRightBtnClick()
    if _isTouch then
        return
    end
    _LVIndex = _LVIndex + 1 
    if _LVIndex > 13 then
        _LVIndex = 1
    end
    _currentIndex = 1
    hideItems()
    _refreshVipDetailLayer()
    
end
vipDetailOwner["teamRightBtnClick"] = teamRightBtnClick


-- 点击滑动
local function addSpriteTouch()
    local touchLayer = tolua.cast(vipDetailOwner["tableLayer"], "CCLayer")

    local function onTouchBegan(x, y)
        local touchLocation = touchLayer:convertToNodeSpace(ccp(x, y))
        local rect = touchLayer:boundingBox()
        if rect:containsPoint(touchLocation) then
            _touchBeganLocationX = x
            _touchBeganLocationY = y
        end
        
        return true
    end

    local function onTouchEnded(x, y)
        local touchLocation = touchLayer:convertToNodeSpace(ccp(x, y))
        local rect = touchLayer:boundingBox()
        if rect:containsPoint(touchLocation) then

            if x - _touchBeganLocationX  > 20 and math.abs(y - _touchBeganLocationY) <= 28 then
                bySwipingRight()
            elseif _touchBeganLocationX - x > 20 and math.abs(y - _touchBeganLocationY) <= 28 then
                bySwipingLeft()
            else
                print("滑动不恰当0000000000")
            end
        end
    end

    local function onTouch(eventType, x, y)
        if eventType == "began" then   
            return onTouchBegan(x, y)
        elseif eventType == "moved" then
        else
            return onTouchEnded(x, y)
        end
    end

    touchLayer:registerScriptTouchHandler(onTouch, false, _priority - 1, false)
    touchLayer:setTouchEnabled(true)
end

local function showVipRewardGiftBag(currentIndex)
    local myCurrentIndex = currentIndex
   
    local function itemClick(tag)
        local awards = vipdata:getVipAward(getMyCurrentLvLevel( ))
        local award = awards[tag]
        local itemId = award.itemId
        if havePrefix(itemId, "weapon_") or havePrefix(itemId, "belt_") or havePrefix(itemId, "armor_") then
            -- 装备
            getMainLayer():getParent():addChild(createEquipInfoLayer(itemId, 2, _priority - 2), 101)
        elseif havePrefix(itemId, "item") or havePrefix(itemId, "key") or havePrefix(itemId, "stuff") then
            -- 道具
            getMainLayer():getParent():addChild(createItemDetailInfoLayer(itemId, _priority - 2, 1, 1), 101)
        elseif havePrefix(itemId, "shadow") then
            -- 影子
            local dic = {}
            local item = shadowData:getOneShadowConf(itemId)
            dic.conf = item
            dic.id = itemId
            getMainLayer():getParent():addChild(createShadowPopupLayer(dic, nil, nil, _priority - 2, 1), 101)
        elseif havePrefix(itemId, "hero") then
            -- 魂魄
            getMainLayer():getParent():addChild(createHeroInfoLayer(itemId, HeroDetail_Clicked_Handbook, _priority - 2), 101)
        elseif havePrefix(itemId, "book") then
            -- 奥义
            getMainLayer():getParent():addChild(createHandBookSkillDetailLayer(itemId, _priority - 2), 101) 
        elseif havePrefix(itemId, "chapter_") then
            -- 残章
            local bookId = string.format("book_%s", string.split(itemId, "_")[2])
            getMainLayer():getParent():addChild(createHandBookSkillDetailLayer(bookId, _priority - 2), 101) 
        else
            -- 金币 银币
        end
    end
    local awards = vipdata:getVipAward(getMyCurrentLvLevel( ))
    local giftTitle = tolua.cast(vipDetailOwner["giftTitle"], "CCLabelTTF")
    giftTitle:setString(HLNSLocalizedString("vip.gift.title", getMyCurrentLvLevel( )))
    local haveGetGiftRewardLabel = tolua.cast(vipDetailOwner["haveGetGiftRewardLabel"], "CCLabelTTF")
    for i=1,4 do
        local itemBtn = tolua.cast(vipDetailOwner["itemBtn"..i], "CCMenuItem")
        itemBtn:setTag(i)
        itemBtn:registerScriptTapHandler(itemClick)
        local contentLayer = tolua.cast(vipDetailOwner["contentLayer"..i], "CCLayer")
        local nameLabel = tolua.cast(vipDetailOwner["nameLabel"..i], "CCLabelTTF")
        local countLabel = tolua.cast(vipDetailOwner["countLabel"..i], "CCLabelTTF")
        local bigSprite = tolua.cast(vipDetailOwner["bigSprite"..i], "CCSprite")
        local littleSprite = tolua.cast(vipDetailOwner["littleSprite"..i], "CCSprite")
        local soulIcon = tolua.cast(vipDetailOwner["soulIcon"..i], "CCSprite")
        local redSprite = tolua.cast(vipDetailOwner["redSprite"..i], "CCSprite")

        -- 说明滑动了 、 渐变效果
        if myCurrentIndex == 1 then

            animationFadeIn(giftTitle)
            animationFadeIn(itemBtn)
            animationFadeIn(nameLabel)
            animationFadeIn(countLabel)
            animationFadeIn(bigSprite)
            animationFadeIn(littleSprite)
            animationFadeIn(soulIcon)
            animationFadeIn(redSprite)
            animationFadeIn(haveGetGiftRewardLabel)
        end

        local award = awards[i]
        if not award then
            contentLayer:setVisible(false)
            itemBtn:setVisible(false)
        else
            contentLayer:setVisible(true)
            itemBtn:setVisible(true)

            local itemId = award.itemId
            local count = award.amount

            -- 通过id 获取物品
            local resDic = userdata:getExchangeResource(itemId)

            if havePrefix(itemId, "weapon_") or havePrefix(itemId, "belt_") or havePrefix(itemId, "armor_") then
                -- 装备
                bigSprite:setVisible(true)
                local texture = CCTextureCache:sharedTextureCache():addImage(resDic.icon)
                if texture then
                    bigSprite:setVisible(true)
                    bigSprite:setTexture(texture)
                end
            elseif havePrefix(itemId, "item") then
                -- 道具
                bigSprite:setVisible(true)
                local texture = CCTextureCache:sharedTextureCache():addImage(resDic.icon)
                if texture then
                    bigSprite:setVisible(true)
                    bigSprite:setTexture(texture)
                end
            elseif havePrefix(itemId, "shadow") then
                -- 影子
                rebateItem:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("s_frame.png"))
                rebateItem:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("s_frame.png"))

                rebateItem:setPosition(ccp(rebateItem:getPositionX() + 5,rebateItem:getPositionY() - 5))
                if resDic.icon then
                    playCustomFrameAnimation( string.format("yingzi_%s_",resDic.icon),contentLayer,ccp(contentLayer:getContentSize().width / 2,contentLayer:getContentSize().height / 2),1,4,shadowData:getColorByColorRank( resDic.rank ) )
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
                end
            else
                -- 金币 银币
                bigSprite:setVisible(true)
                local texture = CCTextureCache:sharedTextureCache():addImage(resDic.icon)
                if texture then
                    bigSprite:setVisible(true)
                    bigSprite:setTexture(texture)
                end
            end
            if not havePrefix(itemId, "shadow") then
                itemBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", resDic.rank)))
                itemBtn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", resDic.rank)))
            end
            -- 设置名字和数量
            countLabel:setString(count)
            nameLabel:setString(resDic.name)
        end
    end
end

local function showVipDayGiftBag(currentIndex)
   local myCurrentIndex = currentIndex
    local function dayItemClick(tag)

        local awards = vipdata:getVipDayGiftAward(getMyCurrentLvLevel( ))
        local award = awards[tag]
        local itemId = award.itemId
        if havePrefix(itemId, "weapon_") or havePrefix(itemId, "belt_") or havePrefix(itemId, "armor_") then
            -- 装备
            getMainLayer():getParent():addChild(createEquipInfoLayer(itemId, 2, _priority - 2), 101)
        elseif havePrefix(itemId, "item") or havePrefix(itemId, "key") or havePrefix(itemId, "stuff") then
            -- 道具
            getMainLayer():getParent():addChild(createItemDetailInfoLayer(itemId, _priority - 2, 1, 1), 101)
        elseif havePrefix(itemId, "shadow") then
            -- 影子
            local dic = {}
            local item = shadowData:getOneShadowConf(itemId)
            dic.conf = item
            dic.id = itemId
            getMainLayer():getParent():addChild(createShadowPopupLayer(dic, nil, nil, _priority - 2, 1), 101)
        elseif havePrefix(itemId, "hero") then
            -- 魂魄
            getMainLayer():getParent():addChild(createHeroInfoLayer(itemId, HeroDetail_Clicked_Handbook, _priority - 2), 101)
        elseif havePrefix(itemId, "book") then
            -- 奥义
            getMainLayer():getParent():addChild(createHandBookSkillDetailLayer(itemId, _priority - 2), 101) 
        elseif havePrefix(itemId, "chapter_") then
            -- 残章
            local bookId = string.format("book_%s", string.split(itemId, "_")[2])
            getMainLayer():getParent():addChild(createHandBookSkillDetailLayer(bookId, _priority - 2), 101) 
        else
            -- 金币 银币
        end
    end
    
    -- 获得奖励列表
    local awards = vipdata:getVipDayGiftAward(getMyCurrentLvLevel( ))
    local dayTitle = tolua.cast(vipDetailOwner["dayTitle"], "CCLabelTTF")
    local haveGetDayRewardLabel = tolua.cast(vipDetailOwner["haveGetDayRewardLabel"], "CCLabelTTF")
    for i=1, 4 do
        local dayItemBtn = tolua.cast(vipDetailOwner["dayItemBtn"..i], "CCMenuItem")
        dayItemBtn:setTag(i)
        dayItemBtn:registerScriptTapHandler(dayItemClick)
        local dayContentLayer = tolua.cast(vipDetailOwner["dayContentLayer"..i], "CCLayer")
        local dayNameLabel = tolua.cast(vipDetailOwner["dayNameLabel"..i], "CCLabelTTF")
        local dayCountLabel = tolua.cast(vipDetailOwner["dayCountLabel"..i], "CCLabelTTF")
        local dayBigSprite = tolua.cast(vipDetailOwner["dayBigSprite"..i], "CCSprite")
        local dayLittleSprite = tolua.cast(vipDetailOwner["dayLittleSprite"..i], "CCSprite")
        local daySoulIcon = tolua.cast(vipDetailOwner["daySoulIcon"..i], "CCSprite")
        local dayRedSprite = tolua.cast(vipDetailOwner["dayRedSprite"..i], "CCSprite")
    
        -- 说明滑动了 、 渐变效果
        if myCurrentIndex == 1 then
            animationFadeIn(dayTitle)
            animationFadeIn(dayItemBtn)
            animationFadeIn(dayNameLabel)
            animationFadeIn(dayCountLabel)
            animationFadeIn(dayBigSprite)
            animationFadeIn(dayLittleSprite)
            animationFadeIn(daySoulIcon)
            animationFadeIn(dayRedSprite)
            animationFadeIn(haveGetDayRewardLabel) 
        end

        local award = awards[i]
        if not award then
            dayContentLayer:setVisible(false)
            dayItemBtn:setVisible(false)
        else
            dayContentLayer:setVisible(true)
            dayItemBtn:setVisible(true)

            local itemId = award.itemId
            local count = award.amount

            local resDic = userdata:getExchangeResource(itemId)

            if havePrefix(itemId, "weapon_") or havePrefix(itemId, "belt_") or havePrefix(itemId, "armor_") then
                -- 装备
                dayBigSprite:setVisible(true)
                local texture = CCTextureCache:sharedTextureCache():addImage(resDic.icon)
                if texture then
                    dayBigSprite:setVisible(true)
                    dayBigSprite:setTexture(texture)
                end
            elseif havePrefix(itemId, "item") then
                -- 道具
                dayBigSprite:setVisible(true)
                local texture = CCTextureCache:sharedTextureCache():addImage(resDic.icon)
                if texture then
                    dayBigSprite:setVisible(true)
                    dayBigSprite:setTexture(texture)
                end
            elseif havePrefix(itemId, "shadow") then
                -- 影子
                rebateItem:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("s_frame.png"))
                rebateItem:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("s_frame.png"))

                rebateItem:setPosition(ccp(rebateItem:getPositionX() + 5,rebateItem:getPositionY() - 5))
                if resDic.icon then
                    playCustomFrameAnimation( string.format("yingzi_%s_",resDic.icon),dayContentLayer,ccp(dayContentLayer:getContentSize().width / 2,dayContentLayer:getContentSize().height / 2),1,4,shadowData:getColorByColorRank( resDic.rank ) )
                end
            elseif havePrefix(itemId, "hero") then
                -- 魂魄
                dayLittleSprite:setVisible(true)
                dayLittleSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(resDic.icon))

            elseif havePrefix(itemId, "book") then
                -- 奥义
                dayBigSprite:setVisible(true)
                local texture = CCTextureCache:sharedTextureCache():addImage(resDic.icon)
                if texture then
                    dayBigSprite:setVisible(true)
                    dayBigSprite:setTexture(texture)
                end
            else
                -- 金币 银币
                dayBigSprite:setVisible(true)
                local texture = CCTextureCache:sharedTextureCache():addImage(resDic.icon)
                if texture then
                    dayBigSprite:setVisible(true)
                    dayBigSprite:setTexture(texture)
                end
            end
            if not havePrefix(itemId, "shadow") then
                dayItemBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", resDic.rank)))
                dayItemBtn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", resDic.rank)))
            end
            -- 设置名字和数量
            dayCountLabel:setString(count)
            dayNameLabel:setString(resDic.name)
        end
    end
end


local function showVipPrivilege()
    -- vip 查看特权 传入LV等级
    local despStr = vipdata:getVipDesp( getMyCurrentLvLevel() )  
    local despStrLabel = tolua.cast(vipDetailOwner["despStrLabel"], "CCLabelTTF")
    despStrLabel:setVisible(true)
    despStrLabel:setString(despStr) 
end

function _refreshVipDetailLayer()
    
    local tabBtn1 = tolua.cast(vipDetailOwner["tabBtn1"], "CCMenuItemImage")
    local tabBtn2 = tolua.cast(vipDetailOwner["tabBtn2"], "CCMenuItemImage")

    local vipPrivilegeScale9Sprite = tolua.cast(vipDetailOwner["vipPrivilegeScale9Sprite"], "CCSprite")
    local vipGiftBagScale9Sprite = tolua.cast(vipDetailOwner["vipGiftBagScale9Sprite"], "CCSprite")
    local vipGiftBagLayer = tolua.cast(vipDetailOwner["vipGiftBagLayer"], "CCLayer")
    local vipPrivilegeLayer = tolua.cast(vipDetailOwner["vipPrivilegeLayer"], "CCLayer")
    local despStrLabel = tolua.cast(vipDetailOwner["despStrLabel"], "CCLabelTTF")
    

    if _Type == TAP_TYPE.reward then 
        -- 按钮状态改变  查看奖励
        tabBtn1:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_1.png"))
        tabBtn2:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_0.png"))

        showVipRewardGiftBag(_currentIndex)
        showVipDayGiftBag(_currentIndex)

        vipPrivilegeScale9Sprite:setVisible(true)
        vipGiftBagScale9Sprite:setVisible(true)
        vipGiftBagLayer:setVisible(true)
        vipPrivilegeLayer:setVisible(true)
        despStrLabel:setVisible(false)

    else
        -- 查看特权  按钮状态
        tabBtn2:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_1.png"))
        tabBtn1:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_0.png"))

        showVipPrivilege()

        vipPrivilegeScale9Sprite:setVisible(false)
        vipGiftBagScale9Sprite:setVisible(false)
        vipGiftBagLayer:setVisible(false)
        vipPrivilegeLayer:setVisible(false)
        despStrLabel:setVisible(true)

    end

    addSpriteTouch()
    _refreshBtnStatus()
end


local function displayLight()
    local rewardItem = tolua.cast(vipDetailOwner["getRewardBtn"], "CCMenuItemImage")
    -- 加光圈
    if not light and not isAdd then  -- if light = nil ， isAdd = false then  --------》 light 不= nil ， isAdd = true
        light = CCSprite:createWithSpriteFrameName("lightingEffect_recruitBtn_1.png")
        local animFrames = CCArray:create()
        for j = 1, 3 do
            local frameName = string.format("lightingEffect_recruitBtn_%d.png",j)
            local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(frameName)
            animFrames:addObject(frame)
        end
        local animation = CCAnimation:createWithSpriteFrames(animFrames, 0.3)
        local animate = CCAnimate:create(animation)
        light:runAction(CCRepeatForever:create(animate))
        light:setPosition(ccp(rewardItem:getContentSize().width / 2, rewardItem:getContentSize().height / 2 + 2))
        rewardItem:addChild(light, 1, 9888)
        _isAdd = true
    end
    if vipdata.vipItems and vipdata.vipItems[tostring(getMyCurrentLvLevel( ))] and tonumber(vipdata.vipItems[tostring(getMyCurrentLvLevel( ))]) == 1 then
       if _isAdd then  -- if light 不= nil ， isAdd = true then  --------》 light = nil ， isAdd = false
            light:stopAllActions()
            light:removeFromParentAndCleanup(true)
            light = nil
            _isAdd = false
        end
    elseif vipdata:getVipLevel() < getMyCurrentLvLevel( ) then
        if _isAdd then  -- if light 不= nil ， isAdd = true then  --------》 light = nil ， isAdd = false
            light:stopAllActions()
            light:removeFromParentAndCleanup(true)
            light = nil
            _isAdd = false
        end
    else
        if light and _isAdd then
            _isAdd = true
        end
    end

    -- 每日礼包 光圈
    local getDayGiftBtn = tolua.cast(vipDetailOwner["getDayGiftBtn"], "CCMenuItemImage")
    if vipdata:getVipLevel() == getMyCurrentLvLevel() then
        if not dayLight then  
            dayLight = CCSprite:createWithSpriteFrameName("lightingEffect_recruitBtn_1.png")
            local animDayFrames = CCArray:create()
            for j = 1, 3 do
                local frameDayName = string.format("lightingEffect_recruitBtn_%d.png",j)
                local frameDay = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(frameDayName)
                animDayFrames:addObject(frameDay)
            end
            local animationDay = CCAnimation:createWithSpriteFrames(animDayFrames, 0.3)
            local animateDay = CCAnimate:create(animationDay)
            dayLight:runAction(CCRepeatForever:create(animateDay))
            dayLight:setPosition(ccp(getDayGiftBtn:getContentSize().width / 2, getDayGiftBtn:getContentSize().height / 2 + 2))
            getDayGiftBtn:addChild(dayLight, 1, 9888)
        end
        if vipdata.vipDailyItems and getMyTableCount(vipdata.vipDailyItems) > 0 then
            if dayLight then  
                dayLight:stopAllActions()
                dayLight:removeFromParentAndCleanup(true)
                dayLight = nil
            end
        end
    else
        if dayLight then 
            dayLight:stopAllActions()
            dayLight:removeFromParentAndCleanup(true)
            dayLight = nil
        end
    end
end

function _refreshBtnStatus()
    -- vip礼包领取按钮状态
    local rewardItem = tolua.cast(vipDetailOwner["getRewardBtn"], "CCMenuItemImage")
    local getRewadLabel = tolua.cast(vipDetailOwner["getRewadLabel"], "CCLabelTTF")
    local haveGetGiftRewardLabel = tolua.cast(vipDetailOwner["haveGetGiftRewardLabel"], "CCLabelTTF")

    getRewadLabel:setString(HLNSLocalizedString("vip.dayGift.getRewadLabel" , getMyCurrentLvLevel( )))
    if vipdata.vipItems and vipdata.vipItems[tostring(getMyCurrentLvLevel( ))] and tonumber(vipdata.vipItems[tostring(getMyCurrentLvLevel( ))]) == 1 then
        -- 已领取
        rewardItem:setVisible(false)
        getRewadLabel:setVisible(false)
        haveGetGiftRewardLabel:setVisible(true)

    elseif vipdata:getVipLevel() < getMyCurrentLvLevel( ) then
        -- 不可领取
        rewardItem:setVisible(true)
        getRewadLabel:setVisible(true)
        haveGetGiftRewardLabel:setVisible(false)
        rewardItem:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn2_2.png"))
        rewardItem:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn2_2.png"))
    else
        
        getRewadLabel:setVisible(true)
        rewardItem:setVisible(true)
        haveGetGiftRewardLabel:setVisible(false)
        rewardItem:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn_nor_0.png"))
        rewardItem:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn_nor_1.png"))
    end

    -- vip 每日领取按钮状态
    local getDayGiftBtn = tolua.cast(vipDetailOwner["getDayGiftBtn"], "CCMenuItemImage")
    local getPrivilegeLable = tolua.cast(vipDetailOwner["getPrivilegeLable"], "CCLabelTTF")
    local haveGetDayRewardLabel = tolua.cast(vipDetailOwner["haveGetDayRewardLabel"], "CCLabelTTF")
    
    if vipdata:getVipLevel() == getMyCurrentLvLevel() then -- 可以领取
    
        getDayGiftBtn:setVisible(true)
        getPrivilegeLable:setVisible(true)
        getDayGiftBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn_nor_0.png"))
        getDayGiftBtn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn_nor_1.png"))
        if vipdata.vipDailyItems and getMyTableCount(vipdata.vipDailyItems) > 0 then
            getDayGiftBtn:setVisible(false)
            getPrivilegeLable:setVisible(false)
            haveGetDayRewardLabel:setVisible(true)
        end
    else
        -- 当前vip不能领取其它vip等级的每日奖励
        getDayGiftBtn:setVisible(true)
        getPrivilegeLable:setVisible(true)
        haveGetDayRewardLabel:setVisible(false)
        getDayGiftBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn2_2.png"))
        getDayGiftBtn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn2_2.png"))
    end
    --  显示光圈效果
    displayLight()
end

-- 点击查看奖励
local function lookRewardBtnClick() 
    if _Type == TAP_TYPE.reward then
        return
    else
        _Type = TAP_TYPE.reward
        _refreshVipDetailLayer()
    end
end
vipDetailOwner["lookRewardBtnClick"] = lookRewardBtnClick

-- 点击查看特权
local function lookPrivilegeBtnClick() 
    if _Type == TAP_TYPE.Privilege then
        return
    else
        _Type = TAP_TYPE.Privilege
        _refreshVipDetailLayer()
    end
end
vipDetailOwner["lookPrivilegeBtnClick"] = lookPrivilegeBtnClick

-- 领取每日奖励按钮
local function getDayGiftItemClick() 
    local function getRewardCallback(url, rtnData)
        -- 成功领取
        vipdata.vipDailyItems = rtnData.info.vipDailyItems
        _refreshBtnStatus()
        if getShpRechargeLayer() then
            getShpRechargeLayer():updateVipLevelReward()
        end
        ----首页上方title的 vip头像框高亮效果
        if getMainLayer() then
            getMainLayer():updateVipLevelReward()
        end
        if getMainLayer() then
            getMainLayer():updateRecruitBtmState()
        end
        if getLogueTownLayer() then
            getLogueTownLayer():updateVipLevelReward()
        end
    end
    if vipdata:getVipLevel() ~= getMyCurrentLvLevel( ) then
        -- 当前vip等级条件不满足
        ShowText(HLNSLocalizedString("vip.dayGift.getRewadDecp"))
    else
        -- vip每日奖励领取接口
        doActionFun("CROSSSERVERRACEBATTLE_GETVIPDAILYREWARD", {}, getRewardCallback)
    end
end
vipDetailOwner["getDayGiftItemClick"] = getDayGiftItemClick

-- 领取vip奖励按钮
local function getRewardItemClick() 
    local function getRewardCallback(url, rtnData)
        vipdata.vipItems = rtnData.info.vipItems
        _refreshBtnStatus()
        if getShpRechargeLayer() then
            getShpRechargeLayer():updateVipLevelReward()
        end
        ----首页上方title的 vip头像框高亮效果
        if getMainLayer() then
            getMainLayer():updateVipLevelReward()
        end
        if getMainLayer() then
            getMainLayer():updateRecruitBtmState()
        end
        if getLogueTownLayer() then
            getLogueTownLayer():updateVipLevelReward()
        end
    end

    if vipdata:getVipLevel() < getMyCurrentLvLevel( ) then
        -- vip等级不够
        ShowText(HLNSLocalizedString("vip.award.need", getMyCurrentLvLevel( )))
    else
        -- 领取
        doActionFun("GET_VIP_LEVEL_REWARD", { getMyCurrentLvLevel( ) }, getRewardCallback)
    end
end
vipDetailOwner["getRewardItemClick"] = getRewardItemClick

local function _init()
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/vipDetailView.ccbi", proxy, true, "vipDetailOwner")
    _layer = tolua.cast(node,"CCLayer")

    local vipLevel = vipdata:getVipLevel()
    local nextVipLevel = vipdata:getVipNextLevel()
    for i=0,1 do
        local nowlv = tolua.cast(vipDetailOwner["nowlv"..i], "CCLabelTTF")
        nowlv:setString(string.format("VIP %d", vipLevel))
        local nextlv = tolua.cast(vipDetailOwner["nextlv"..i], "CCLabelTTF")
        nextlv:setString(string.format("VIP %d", nextVipLevel))
        local proLabel = tolua.cast(vipDetailOwner["proLabel"..i], "CCLabelTTF")
        proLabel:setString(string.format("%d/%d", vipdata.vipScore, vipdata:getNextVipScore()))
        proLabel:setZOrder(2)
    end

    local progressBg = tolua.cast(vipDetailOwner["proBg"], "CCLayer")
    if progress then
        progress:removeFromParentAndCleanup(true)
        progress = nil
    end
    progress = CCProgressTimer:create(CCSprite:create("images/grePro_refine.png"))
    progress:setType(kCCProgressTimerTypeBar)
    progress:setMidpoint(CCPointMake(0, 0))
    progress:setBarChangeRate(CCPointMake(1, 0))
    local x, y = progressBg:getPosition()
    progress:setPosition(x, y)
    progressBg:getParent():addChild(progress, 0, 1)
    progress:setPercentage(math.min(vipdata.vipScore / vipdata:getNextVipScore() * 100, 100))
    
    if ConfigureStorage.vipConfig[userdata:getVipLevel() + 1].Anchor then
        if ConfigureStorage.vipConfig[userdata:getVipLevel() + 1].Anchor == 1 then
           --客服小妹btn
            local SupportSisterBtn = tolua.cast(vipDetailOwner["SupportSisterBtn"], "CCMenuItemImage")
            local sirenkefu_textSprite = tolua.cast(vipDetailOwner["sirenkefu_textSprite"], "CCSprite")
            local VIPTitleNew = tolua.cast(vipDetailOwner["VIPTitleNew"], "CCSprite")
            local VIPTitle = tolua.cast(vipDetailOwner["VIPTitle"], "CCSprite")
            SupportSisterBtn:setVisible(true)
            sirenkefu_textSprite:setVisible(true)
            VIPTitle:setVisible(false)
            VIPTitleNew:setVisible(true)
        end
    end
    _refreshVipDetailLayer()
end


function getVipDetailLayer()
    return _layer
end

local function onTouchBegan(x, y)

    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(vipDetailOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction(vipDetailOwner, "infoBg", _layer)
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
    local menu = tolua.cast(vipDetailOwner["menu"], "CCMenu")
    menu:setHandlerPriority(_priority - 1)

    local giftMenu = tolua.cast(vipDetailOwner["giftMenu"], "CCMenu")
    giftMenu:setHandlerPriority(_priority - 1)

    local dayMenu = tolua.cast(vipDetailOwner["dayMenu"], "CCMenu")
    dayMenu:setHandlerPriority(_priority - 1)
     
end

function createVipDetailLayer(priority)
    _priority = (priority ~= nil) and priority or -128

    _Type = TAP_TYPE.reward

    _currentIndex = 0
    local vipLevel = vipdata:getVipLevel() + 1
    _LVIndex = vipLevel
    
    _init()
    
    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
    end

    local function _onExit()
        _layer = nil
        progress = nil
        _Type = nil
        _priority = nil
        _touchBeganLocationX = nil
        _touchBeganLocationY = nil
        _index = nil
        _cellBgMiddle = nil
        _LVIndex = nil
        _isMove = false
        _isAdd = false
        _currentIndex = 0
        _isTouch = false
        dayLight = nil
        light = nil
    end

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