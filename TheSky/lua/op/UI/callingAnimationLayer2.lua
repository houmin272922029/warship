local _aniLayer
local _parent
local _heroId
local _heroRank
local _bTransfered = false
local _firstShow

local _giftSouls = {}
local _resultSoul = {}
local _sendSoulsCount = 0
local _targetIndex = 1
local _rollSprite = nil
local _startshine = nil
local _currentIndex = 0
local _starshineIndex = 0
local _canQuit = false
local _showTipWhenQuit = true
local _bTenCalls = false

callingRoleOwner2 = callingRoleOwner2 or {}

function moveBackTopAndBottom()
    -- 主界面的上下按钮移回来
    if topAndBottomNormalPosition then
        return
    end
    MainSceneOwner["titleBg"]:runAction(CCMoveBy:create(0.25,ccp(0,-150 * retina)))
    MainSceneOwner["broadcastBg"]:runAction(CCMoveBy:create(0.25,ccp(0,-150 * retina)))
    MainSceneOwner["bottomBg"]:runAction(CCMoveBy:create(0.25,ccp(0,150 * retina)))
    MainSceneOwner["menu"]:runAction(CCMoveBy:create(0.25,ccp(0,150 * retina)))
    getButtonsView():runAction(CCMoveBy:create(0.25,ccp(0,150 * retina)))
    
    topAndBottomNormalPosition = true
end

local function setTextColor()
    local blend1 = ccBlendFunc:new()
    blend1.src = GL_ONE
    blend1.dst = GL_ONE_MINUS_SRC_ALPHA
    local owner = callingRoleOwner2
    for i=1,10 do
        local textureG = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("call_".._heroRank.."_"..i..".png")
        if textureG then
            owner["callText_"..i]:setDisplayFrame(textureG)
            owner["callTextAdd_"..i]:setDisplayFrame(textureG)
            owner["callTextAdd_"..i]:setBlendFunc(blend1)
        else
            owner["callText_"..i]:setVisible(false)
            owner["callTextAdd_"..i]:setVisible(false)
        end
    end
end

local function setGateColor()
    local blend1 = ccBlendFunc:new()
    blend1.src = GL_ONE_MINUS_DST_ALPHA
    blend1.dst = GL_ONE
    local texture = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("gate_".._heroRank..".png")
    local texture1 = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("openGate_".._heroRank..".png")
    local owner = callingRoleOwner2
    for i=1,3 do
        owner["gate"..i]:setDisplayFrame(texture)
        owner["gateReflection"..i]:setDisplayFrame(texture)
        owner["gateReflection"..i]:setBlendFunc(blend1)
    end
    owner["openGate"]:setDisplayFrame(texture1)
    owner["gateBtn"]:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("gate_".._heroRank..".png"))
end

local function setCircleColor()
    local owner = callingRoleOwner2
    local rank = _heroRank > 4 and 4 or _heroRank
    local texture2 = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("outlineRing_"..rank..".png")
    local texture3 = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("bgCircle_"..rank..".png")
    owner["scaleHaloRing"]:setDisplayFrame(texture2)
    owner["bgCircle"]:setDisplayFrame(texture3)
end

local function _setMenuItemsPostions()
    if runtimeCache.recruitOption == 1 then

        callingRoleOwner2["goToListMenu"]:setPosition(ccp(winSize.width * 0.3,winSize.height * 0.08))
        callingRoleOwner2["continueMenu"]:setPosition(ccp(winSize.width * 0.7,winSize.height * 0.08))

        callingRoleOwner2["label1"]:setPosition(ccp(winSize.width * 0.3,winSize.height * 0.08))
        callingRoleOwner2["label2"]:setPosition(ccp(winSize.width * 0.7,winSize.height * 0.08))
    end
end

-- private方法如果没有上下调用关系可以写在外面
local function _init()
    ccb["callingRoleOwner2"] = callingRoleOwner2
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/GET2!!.ccbi",proxy, true,"callingRoleOwner2")
    _aniLayer = tolua.cast(node,"CCLayer")
    setTextColor()
    setGateColor()
    setCircleColor()
    _setMenuItemsPostions()
    _parent:addChild(_aniLayer)
end

function getCallingAnimationLayer2()
    return _aniLayer
end


-- 门开了以后加两个粒子效果
local function onGateOpens()
    local rank = _heroRank > 4 and 4 or _heroRank
    HLAddParticleScale( "images/eff_page_72"..(rank+1).."_1.plist", _aniLayer, ccp(winSize.width/2, winSize.height/2), 1, 1, -1,1,1)
    HLAddParticleScale( "images/eff_page_72"..(rank+1).."_2.plist", _aniLayer, ccp(winSize.width/2, winSize.height/2), 1, 1, -1,1,1)
end
callingRoleOwner2["onGateOpens"] = onGateOpens

local function showResultSoul()
    for i=0,5 do
        callingRoleOwner2["giftSoul_"..i]:setVisible(false)
        _rollSprite:setVisible(false)
        _startshine:setVisible(false)
    end
    callingRoleOwner2["menu"]:setVisible(true)
    callingRoleOwner2["menu"]:setHandlerPriority(-133)
    callingRoleOwner2["goToListMenu"]:setEnabled(true)
    callingRoleOwner2["continueMenu"]:setEnabled(true)
    _canQuit = true
    callingRoleOwner2["label1"]:setVisible(true)
    callingRoleOwner2["label2"]:setVisible(true)
    if runtimeCache.recruitOption ~= 1 then
        callingRoleOwner2["tenTimesMenu"]:setEnabled(true)
        callingRoleOwner2["label3"]:setVisible(true)
    else
        callingRoleOwner2["tenTimesMenu"]:setVisible(false)
    end
    callingRoleOwner2["gainSoulBg"]:setVisible(true)
    callingRoleOwner2["roleMenuItem"]:setEnabled(true)
    callingRoleOwner2["roleMenu"]:setHandlerPriority(-133)

    local soulId = _resultSoul.hero
    local soulCount = _resultSoul.amount

    local heroConfig = herodata:getHeroConfig(soulId)
    local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(herodata:getHeroHeadByHeroId(soulId))
    if frame then
        callingRoleOwner2["gainHeadImage"]:setDisplayFrame(frame)
    end
    callingRoleOwner2["gainedSoulFrame"]:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", heroConfig.rank)))

    if isPlatform(ANDROID_VIETNAM_VI) 
        or isPlatform(ANDROID_VIETNAM_EN) 
        or isPlatform(ANDROID_VIETNAM_EN_ALL)
        or isPlatform(ANDROID_VIETNAM_MOB_THAI)
        or isPlatform(IOS_VIETNAM_VI) 
        or isPlatform(IOS_VIETNAM_EN) 
        or isPlatform(IOS_VIETNAM_ENSAGA)
        or isPlatform(IOS_MOB_THAI)
        or isPlatform(IOS_MOBNAPPLE_EN)
        or isPlatform(IOS_MOBGAME_SPAIN)
        or isPlatform(ANDROID_MOBGAME_SPAIN)
        or isPlatform(IOS_GAMEVIEW_EN)
        or isPlatform(IOS_GVEN_BREAK)
        or isPlatform(ANDROID_GV_MFACE_EN)
        or isPlatform(ANDROID_GV_MFACE_EN_OUMEI)
        or isPlatform(ANDROID_GV_MFACE_EN_OUMEINEW)
        or isPlatform(WP_VIETNAM_EN) then

        callingRoleOwner2["gainedSoulNameLabel"]:setString(HLNSLocalizedString("getsoul.count", soulCount, heroConfig.name))
        
    else
        callingRoleOwner2["gainedSoulNameLabel"]:setString(HLNSLocalizedString("getsoul.count", heroConfig.name, soulCount))
    end
    if runtimeCache.bGuide then
        getMainLayer():addChild(createGuideLayer(), 999)
    end
end

local function rollSpriteMove()
    _currentIndex = _currentIndex + 1
    local frame = callingRoleOwner2[string.format("giftSoul_%d",math.mod(_currentIndex,6))]
    _rollSprite:setPosition(ccp(frame:getPositionX(),frame:getPositionY()))
end
local function starMove()
    _starshineIndex = _starshineIndex + 1
    local frame = callingRoleOwner2[string.format("giftSoul_%d",math.mod(_starshineIndex,6))]
    _startshine:setPosition(ccp(frame:getPositionX() - 25 * retina,frame:getPositionY() - 40 * retina))
end

local function rollAnimation()

    local actionArray1 = CCArray:create()
    local actionArray2 = CCArray:create()
    local delay = 0.22
     --先加速走到最高速
     for i=1,10 do
        actionArray1:addObject(CCDelayTime:create(delay))
        actionArray2:addObject(CCDelayTime:create(delay))
        local func1 = CCCallFunc:create(rollSpriteMove)
        actionArray1:addObject(func1)
        local func2 = CCCallFunc:create(starMove)
        actionArray2:addObject(func2)
        delay = delay - 0.02
    end
    delay = 0.02
    --最高速随机跑圈
    for i=1,45 do
        actionArray1:addObject(CCDelayTime:create(delay))
        actionArray2:addObject(CCDelayTime:create(delay))
        local func1 = CCCallFunc:create(rollSpriteMove)
        actionArray1:addObject(func1)
        local func2 = CCCallFunc:create(starMove)
        actionArray2:addObject(func2)
    end
    --最高速移动到偏移目标值距离slowStep格的位置
    for i=1,5 do
        delay = delay + 0.02
        actionArray1:addObject(CCDelayTime:create(delay))
        actionArray2:addObject(CCDelayTime:create(delay))
        local func1 = CCCallFunc:create(rollSpriteMove)
        actionArray1:addObject(func1)
        local func2 = CCCallFunc:create(starMove)
        actionArray2:addObject(func2)
    end
    for i=1,_targetIndex + 7 do
        delay = delay + 0.02
        actionArray1:addObject(CCDelayTime:create(delay))
        local func = CCCallFunc:create(rollSpriteMove)
        actionArray1:addObject(func)
    end
    actionArray1:addObject(CCDelayTime:create(1))
    local openBox = CCCallFunc:create(showResultSoul)
    -- local delayTime = CCDelayTime:create(0.3)   --临时添加滴，也算临时工啦
    -- actionArray:addObject(delayTime)
    actionArray1:addObject(openBox)
    local seq1 = CCSequence:create(actionArray1)
    _rollSprite:runAction(seq1)

    actionArray2:addObject(CCFadeOut:create(0.2))
    local seq2 = CCSequence:create(actionArray2)
    _startshine:runAction(seq2)
end 

-- 开始时，人物按钮是不可以点击的，召唤结果出现以后设为可用状态，并设置优先级高于本层
local function whenRoll()
    if _giftSouls and table.getTableCount(_giftSouls) > 0 then
        for i,soul in pairs(_giftSouls) do
            local heroConfig = herodata:getHeroConfig(soul.hero)
            local giftSoul = callingRoleOwner2["giftSoul_"..(i-1)]
            local headImage = callingRoleOwner2["headImage_"..(i-1)]
            local soulCountLabel = callingRoleOwner2["soulsCountLabel_"..(i-1)]
            giftSoul:setVisible(true)
            giftSoul:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", heroConfig.rank)))
            local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(herodata:getHeroHeadByHeroId(soul.hero))
            if frame then
                headImage:setDisplayFrame(frame)
            end
            soulCountLabel:setString(soul.amount)
        end

        _rollSprite = callingRoleOwner2["selFrame"]
        _rollSprite:setVisible(true)
        _startshine = callingRoleOwner2["starshine"]
        _startshine:setVisible(true)

        rollAnimation()
        callingRoleOwner2["roleMenuItem"]:setEnabled(false)
    else
        callingRoleOwner2["roleMenuItem"]:setEnabled(true)
        callingRoleOwner2["roleMenu"]:setHandlerPriority(-133)
        callingRoleOwner2["menu"]:setVisible(true)
        callingRoleOwner2["menu"]:setHandlerPriority(-133)
        callingRoleOwner2["goToListMenu"]:setEnabled(true)
        callingRoleOwner2["continueMenu"]:setEnabled(true)
        _canQuit = true
        callingRoleOwner2["label1"]:setVisible(true)
        callingRoleOwner2["label2"]:setVisible(true)
        if runtimeCache.recruitOption ~= 1 then
            callingRoleOwner2["tenTimesMenu"]:setEnabled(true)
            callingRoleOwner2["label3"]:setVisible(true)
        else
            callingRoleOwner2["tenTimesMenu"]:setVisible(false)
        end
        if runtimeCache.bGuide then
            getMainLayer():addChild(createGuideLayer(), 999)
        end
    end
end

function callTenTimesAnimation(tenCallsData)
    -- 存放赠魂的数组
    local sendSoulsArray = {}
    -- 存放11张卡的数组
    local heroCardsArray = {}

    -- 遍历11个刷将结果
    for i=0,10 do
        local recruitResult = tenCallsData[tostring(i)]

        local sendSoulId = nil
        local sendSoulCount = 0

        -- 如果有赠魂
        if recruitResult.sendSouls then
            -- 遍历赠魂选项,滤除假象，找到真正的赠魂
            for index,soulInfo in pairs(recruitResult.sendSouls) do
                --如果标记为1则为真正赠的魂，添加到赠魂的数组中
                if soulInfo.getFlag and soulInfo.getFlag == 1 then

                    sendSoulId = soulInfo.hero
                    sendSoulCount = soulInfo.amount
                    if sendSoulsArray[sendSoulId] then
                        sendSoulsArray[sendSoulId] = sendSoulsArray[sendSoulId] + sendSoulCount
                    else
                        sendSoulsArray[sendSoulId] = sendSoulCount
                    end
                end
            end

            -- 如果有赠魂，gain中一定有heroes_soul
            if recruitResult.gain.heros then
                -- 如果gain中有英雄，则英雄和赠魂自然分开
                for id,heroData in pairs(recruitResult.gain.heros) do
                    -- 找到英雄的id添加到数组中，为与魂区别，value设为-1
                    heroCardsArray[tostring(i)] = {}
                    heroCardsArray[tostring(i)].heroId = heroData.heroId
                    heroCardsArray[tostring(i)].isSoul = false
                end
            else
                -- gain中只有魂
                for soulId,amount in pairs(recruitResult.gain.heroes_soul) do
                    if soulId == sendSoulId then
                    -- 和赠魂id相同
                        if amount == sendSoulCount then
                            -- 数量和赠魂数目相同，正是赠的魂
                        else
                            -- 数量不相等，则既包含了赠魂，又包含了刷到的魂
                            heroCardsArray[tostring(i)] = {}
                            heroCardsArray[tostring(i)].heroId = soulId
                            heroCardsArray[tostring(i)].isSoul = true
                            heroCardsArray[tostring(i)].amount = amount - sendSoulCount
                        end
                    else
                        -- 和赠魂id不同
                        heroCardsArray[tostring(i)] = {}
                        heroCardsArray[tostring(i)].heroId = soulId
                        heroCardsArray[tostring(i)].isSoul = true
                        heroCardsArray[tostring(i)].amount = amount
                    end
                end
            end

        else
            -- 没有赠魂
            if recruitResult.gain.heroes_soul then
                -- 刷到的是魂
                for heroSoulId,amount in pairs(recruitResult.gain.heroes_soul) do
                    heroCardsArray[tostring(i)] = {}
                    heroCardsArray[tostring(i)].heroId = heroSoulId
                    heroCardsArray[tostring(i)].isSoul = true
                    heroCardsArray[tostring(i)].amount = amount
                end
            else
                for id,heroData in pairs(recruitResult.gain.heros) do
                    heroCardsArray[tostring(i)] = {}
                    heroCardsArray[tostring(i)].heroId = heroData.heroId
                    heroCardsArray[tostring(i)].isSoul = false
                end
            end
        end
    end


    local moveActions = CCArray:create()
    local movingTime = 0.2

    local function moveCurrentLayer()
        callingRoleOwner2["goToListMenu"]:setEnabled(false)
        callingRoleOwner2["continueMenu"]:setEnabled(false)
        callingRoleOwner2["tenTimesMenu"]:setEnabled(false)
        _canQuit = false

        if _bTenCalls then
            -- 从罗格镇直接十连刷的
            callingRoleOwner2["singleCallLayer"]:setPosition(ccp(-winSize.width * 0.6,winSize.height * 0.5))
            callingRoleOwner2["tenTimesCallLayer"]:setPosition(ccp(winSize.width * 0.5,winSize.height * 0.5))
            return
        end
        -- 判断当前画面在单次刷将画面还是十连刷画面
        if callingRoleOwner2["singleCallLayer"]:getPositionX() == winSize.width * 0.5 then
            -- 当前画面是单次刷将，单次刷将移到左边，十连刷结果画面移进来
            callingRoleOwner2["singleCallLayer"]:runAction(CCMoveBy:create(movingTime,ccp(-winSize.width * 1.1,0)))
        elseif callingRoleOwner2["tenTimesCallLayer"]:getPositionX() == winSize.width * 0.5 then
            -- 当前已在十连刷画面
            callingRoleOwner2["tenTimesCallLayer"]:runAction(CCMoveBy:create(movingTime,ccp(-winSize.width * 1.1,0)))
        end
    end

    moveActions:addObject(CCCallFunc:create(moveCurrentLayer))

    if not _bTenCalls then
        moveActions:addObject(CCDelayTime:create(movingTime+0.05))
    end
    

    -- 给每张卡片赋值
    local function updateCardInfo()

        for cardIndex,cardData in pairs(heroCardsArray) do

            local heroConfig = herodata:getHeroConfig(cardData.heroId)

            callingRoleOwner2["rankBg"..cardIndex]:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("hero_bg_"..heroConfig.rank..".png"))
            callingRoleOwner2["bust"..cardIndex]:setTexture(CCTextureCache:sharedTextureCache():addImage(herodata:getHeroBust1ByHeroId(cardData.heroId)))
            -- callingRoleOwner2["rankSprite"..cardIndex]:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("rank_"..heroConfig.rank.."_icon.png"))
            callingRoleOwner2["nameLabel"..cardIndex]:setString(heroConfig.name)
        end

        for i=0,10 do
            callingRoleOwner2["coverBg"..i]:setOpacity(255)
            callingRoleOwner2["rankCoverBg"..i]:setOpacity(255)
            local callsPurple = callingRoleOwner2["bust"..i]:getChildByTag(88)
            if callsPurple then
                callsPurple:removeFromParentAndCleanup(true)
            end
            local callsStars = callingRoleOwner2["bust"..i]:getChildByTag(99)
            if callsStars then
                callsStars:removeFromParentAndCleanup(true)
            end
            local newIcon = callingRoleOwner2["rankBg"..i]:getChildByTag(66)
            if newIcon then
                newIcon:removeFromParentAndCleanup(true)
            end
        end
        for i=0,3 do
            callingRoleOwner2["soulCover"..i]:setOpacity(255)
            callingRoleOwner2["10giftSoul_"..i]:setVisible(false)
            callingRoleOwner2["10soulCountBg"..i]:setVisible(false)
        end

        local sendSoulIndex = 0
        for sendSoulId,amount in pairs(sendSoulsArray) do
            
            local heroConfig = herodata:getHeroConfig(sendSoulId)
            local giftSoul = callingRoleOwner2["10giftSoul_"..sendSoulIndex]
            local headImage = callingRoleOwner2["10headImage_"..sendSoulIndex]
            local soulCountLabel = callingRoleOwner2["10soulsCountLabel_"..sendSoulIndex]
            giftSoul:setVisible(true)
            giftSoul:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("frame_"..heroConfig.rank..".png"))
            local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(herodata:getHeroHeadByHeroId(sendSoulId))
            if frame then
                headImage:setDisplayFrame(frame)
            end
            soulCountLabel:setString(amount)

            sendSoulIndex = sendSoulIndex + 1
        end
    end

    moveActions:addObject(CCCallFunc:create(updateCardInfo))

    if not _bTenCalls then
    
        local function setTenTimesLayerPosition()
            callingRoleOwner2["tenTimesCallLayer"]:stopAllActions()
            callingRoleOwner2["tenTimesCallLayer"]:setPosition(ccp(winSize.width * 1.6,winSize.height * 0.5))
        end
        moveActions:addObject(CCCallFunc:create(setTenTimesLayerPosition))

        local function TenTimesLayerMoveIn()
            callingRoleOwner2["tenTimesCallLayer"]:stopAllActions()
            callingRoleOwner2["tenTimesCallLayer"]:runAction(CCMoveTo:create(movingTime,ccp(winSize.width * 0.5,winSize.height * 0.5)))
        end
        moveActions:addObject(CCCallFunc:create(TenTimesLayerMoveIn))
    end

    local soulCardsCount = table.getTableCount(sendSoulsArray)
    local turningTime = 0.2
    local function turnOutCards()
        for i=0,10 do
            local cardActions = CCArray:create()
            cardActions:addObject(CCDelayTime:create(i * turningTime))
            local function fadeActions()
                local whiteLayerActions = CCArray:create()
                whiteLayerActions:addObject(CCFadeIn:create(turningTime/2))
                whiteLayerActions:addObject(CCFadeOut:create(turningTime/2))
                callingRoleOwner2["cardCover_"..i]:runAction(CCSequence:create(whiteLayerActions))
                callingRoleOwner2["coverBg"..i]:runAction(CCFadeOut:create(turningTime))
                callingRoleOwner2["rankCoverBg"..i]:runAction(CCFadeOut:create(turningTime))

                local heroConfig = herodata:getHeroConfig(heroCardsArray[tostring(i)].heroId)
                if heroConfig.rank == 4 then
                    local class4Bust = callingRoleOwner2["bust"..i]
                    HLAddParticleScale( "images/10callsPurple.plist", class4Bust, ccp(class4Bust:getContentSize().width/2, class4Bust:getContentSize().height/2), -1,-1, 88,2/retina,2/retina)
                
                    HLAddParticleScale( "images/10callsStars.plist", class4Bust, ccp(class4Bust:getContentSize().width/2, class4Bust:getContentSize().height/2), -1,1, 99,2/retina,2/retina)
                end
            end
            cardActions:addObject(CCCallFunc:create(fadeActions))
            callingRoleOwner2["coverBg"..i]:runAction(CCSequence:create(cardActions))

            -- 盖new的章
            if not heroCardsArray[tostring(i)].isSoul then
                local newIcon = CCSprite:createWithSpriteFrameName("new_icon.png")
                newIcon:setScale(20)
                newIcon:setOpacity(0)
                newIcon:setPosition(ccp(290,430))
                callingRoleOwner2["rankBg"..i]:addChild(newIcon,10,66)
                local newIconActions = CCArray:create()
                -- 先等卡都翻完
                newIconActions:addObject(CCDelayTime:create(turningTime * 11))
                local function stampNewIcon()
                    newIcon:runAction(CCEaseIn:create(CCFadeIn:create(0.3),2))
                    newIcon:runAction(CCEaseBounceOut:create(CCScaleTo:create(0.3,2)))
                end
                -- 盖章动作
                newIconActions:addObject(CCCallFunc:create(stampNewIcon))
                -- 等盖章完成
                newIconActions:addObject(CCDelayTime:create(0.3))
                local function newIconShine()
                    local newEffect = CCSprite:createWithSpriteFrameName("NewEffect_1.png")
                    newIcon:addChild(newEffect,1)
                    newEffect:setPosition(ccp(newIcon:getContentSize().width/2,newIcon:getContentSize().height/2))

                    local newFrames = CCArray:create()
                    for j = 0, 5 do
                        local frameName = string.format("NewEffect_%d.png",math.mod(j,3)+1)
                        local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(frameName)
                        newFrames:addObject(frame)
                    end
                    local frame7 = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("new_icon.png")
                    newFrames:addObject(frame7)
                    local newAnimation = CCAnimation:createWithSpriteFrames(newFrames, 0.1)
                    local newAnimate = CCAnimate:create(newAnimation)
                    newEffect:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(newAnimate,CCDelayTime:create(0.5))))
                end
                -- 闪光效果序列帧
                newIconActions:addObject(CCCallFunc:create(newIconShine))
                newIcon:runAction(CCSequence:create(newIconActions))
            end
        end
        for i=0,soulCardsCount-1 do
            local soulActions = CCArray:create()
            soulActions:addObject(CCDelayTime:create(turningTime * 11 + i * turningTime))
            local function cardFadeActions()
                local soulWhiteLayerActions = CCArray:create()
                soulWhiteLayerActions:addObject(CCFadeIn:create(turningTime/2))
                soulWhiteLayerActions:addObject(CCFadeOut:create(turningTime/2))
                local function showSendSoulCount()
                    callingRoleOwner2["10soulCountBg"..i]:setVisible(true)
                end
                soulWhiteLayerActions:addObject(CCCallFunc:create(showSendSoulCount))
                callingRoleOwner2["soulCoverLayer"..i]:runAction(CCSequence:create(soulWhiteLayerActions))
                callingRoleOwner2["soulCover"..i]:runAction(CCFadeOut:create(turningTime))
            end
            soulActions:addObject(CCCallFunc:create(cardFadeActions))
            callingRoleOwner2["soulCover"..i]:runAction(CCSequence:create(soulActions))
        end
    end
    moveActions:addObject(CCCallFunc:create(turnOutCards))

    moveActions:addObject(CCDelayTime:create(turningTime * 11 + soulCardsCount * turningTime))

    local function enableMenuItems()
        callingRoleOwner2["goToListMenu"]:setEnabled(true)
        callingRoleOwner2["continueMenu"]:setEnabled(true)
        callingRoleOwner2["tenTimesMenu"]:setEnabled(true)
        _canQuit = true
        _bTenCalls = false 
    end
    moveActions:addObject(CCCallFunc:create(enableMenuItems))
    
    callingRoleOwner2["singleCallLayer"]:runAction(CCSequence:create(moveActions))
end

-- 结果出现时
local function onResultShows()
    if _bTenCalls then
        callTenTimesAnimation(runtimeCache.tenCallsInfo)
        callingRoleOwner2["menu"]:setVisible(true)
        callingRoleOwner2["menu"]:setHandlerPriority(-133)
        callingRoleOwner2["goToListMenu"]:setEnabled(true)
        callingRoleOwner2["continueMenu"]:setEnabled(true)
        _canQuit = true
        callingRoleOwner2["label1"]:setVisible(true)
        callingRoleOwner2["label2"]:setVisible(true)
        callingRoleOwner2["tenTimesMenu"]:setEnabled(true)
        callingRoleOwner2["label3"]:setVisible(true)
        return
    end

    local added = CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(herodata:getHeroAnimationByHeroId(_heroId))
    if not added then
        _heroId = "hero_000433"
        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(herodata:getHeroAnimationByHeroId(_heroId))
    end
    local aniRes = string.format("%s_attack_0001.png",_heroId)
    local s = CCSprite:createWithSpriteFrameName(aniRes)


    local animFrames = CCArray:create()
    for j = 1, 4 do
        local frameName = string.format("%s_stand_000%d.png",_heroId, j)
        local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(frameName)
        animFrames:addObject(frame)
    end
    for j = 1, 4 do
        local frameName = string.format("%s_stand_000%d.png",_heroId, j)
        local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(frameName)
        animFrames:addObject(frame)
    end
    for j = 1, 6 do
        local frameName = string.format("%s_attack_000%d.png",_heroId, j)
        local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(frameName)
        animFrames:addObject(frame)
    end
    local animation = CCAnimation:createWithSpriteFrames(animFrames, 0.1)

    -- 按钮图像换成召唤到的任务形象
    callingRoleOwner2["attackingOne"]:addChild(s)
    s:setScaleX(-1)
    s:setPosition(callingRoleOwner2["attackingOne"]:getContentSize().width / 2,callingRoleOwner2["attackingOne"]:getContentSize().height / 2)
    s:runAction(CCRepeatForever:create(CCAnimate:create(animation)))

    local showDetailInfoArray = CCArray:create()
    showDetailInfoArray:addObject(CCDelayTime:create(2))
    local function showDetailInfo()
        s:runAction(CCMoveBy:create(0.25,ccp(64,0)))

        local heroConfig = herodata:getHeroConfig(_heroId)
        local heroName = heroConfig.name
        local hp = heroConfig.attr.hp
        local atk = heroConfig.attr.atk
        local def = heroConfig.attr.def
        local mp = heroConfig.attr.mp

        -- renzhan newAdd
        -- PrintTable(heroConfig.attr)
        -- "hit":0,"cnt":0,"dod":0,"atk":58,"hp":46,"parry":0,"cri":0,"def":16,"mp":46,"resi":0
        -- 

        local nameFrame = CCSprite:create("images/heroNameFrame_long.png")
        callingRoleOwner2["attackingOne"]:addChild(nameFrame)
        nameFrame:setAnchorPoint(ccp(0,0.5))
        nameFrame:setPosition(ccp(-515,195 + 40))
        nameFrame:runAction(CCMoveTo:create(0.25,ccp(-15,195 + 40)))
        nameFrame:setScale(0.5)
        local nameLabel = CCLabelTTF:create(heroName, "ccbResources/FZCuYuan-M03S.ttf", 35)
        nameFrame:addChild(nameLabel)
        if _heroRank == 1 then
            nameLabel:setColor(ccc3(188,198,219))
        elseif _heroRank == 2 then
            nameLabel:setColor(ccc3(84,195,11))
        elseif _heroRank == 3 then
            nameLabel:setColor(ccc3(0,153,255))
        elseif _heroRank == 4 then
            nameLabel:setColor(ccc3(154,78,205))
        elseif _heroRank == 5 then
            nameLabel:setColor(ccc3(228,195,33))
        end
        nameLabel:setPosition(ccp(128,nameFrame:getContentSize().height / 2))

        local rankIcon = CCSprite:createWithSpriteFrameName("rank_".._heroRank.."_icon.png")
        nameFrame:addChild(rankIcon)
        rankIcon:setPosition(ccp(276,nameFrame:getContentSize().height / 2 - 128))
        rankIcon:setScale(10)
        rankIcon:setOpacity(0)
        local rankActions0 = CCArray:create()
        rankActions0:addObject(CCDelayTime:create(0.75))
        rankActions0:addObject(CCEaseIn:create(CCScaleBy:create(1.5,0.1),10))
        -- rankIcon:runAction(CCSequence:create(rankActions0))
        rankIcon:runAction(CCSpeed:create(CCSequence:create(rankActions0),0.8))
        local rankActions1 = CCArray:create()
        rankActions1:addObject(CCDelayTime:create(0.75))
        rankActions1:addObject(CCEaseIn:create(CCFadeTo:create(1.5,255),10))
        -- rankIcon:runAction(CCSequence:create(rankActions1))
        rankIcon:runAction(CCSpeed:create(CCSequence:create(rankActions1),0.8))
        local rankActions2 = CCArray:create()
        rankActions2:addObject(CCDelayTime:create(0.75))
        rankActions2:addObject(CCEaseIn:create(CCMoveBy:create(1.5,ccp(0,128)),10))
        -- rankIcon:runAction(CCSequence:create(rankActions2))
        rankIcon:runAction(CCSpeed:create(CCSequence:create(rankActions2),0.8))

        local hpFrame = CCSprite:create("images/heroAttFrame_short.png")
        callingRoleOwner2["attackingOne"]:addChild(hpFrame)
        hpFrame:setAnchorPoint(ccp(0,0.5))
        hpFrame:setPosition(ccp(-1015,165 + 40))
        hpFrame:runAction(CCMoveTo:create(0.5,ccp(-15,165 + 40)))
        hpFrame:setScale(0.5)
        local hpIcon = CCSprite:createWithSpriteFrameName("hp_icon.png")
        hpFrame:addChild(hpIcon)
        hpIcon:setPosition(ccp(45,hpFrame:getContentSize().height / 2))
        local hpLabel = CCLabelTTF:create(hp, "ccbResources/FZCuYuan-M03S.ttf", 35)
        hpFrame:addChild(hpLabel)
        hpLabel:setAnchorPoint(ccp(0,0.5))
        hpLabel:setPosition(ccp(100,hpFrame:getContentSize().height / 2))

        local atkFrame = CCSprite:create("images/heroAttFrame_short.png")
        callingRoleOwner2["attackingOne"]:addChild(atkFrame)
        atkFrame:setAnchorPoint(ccp(0,0.5))
        atkFrame:setPosition(ccp(-1515,135 + 40))
        atkFrame:runAction(CCMoveTo:create(0.75,ccp(-15,135 + 40)))
        atkFrame:setScale(0.5)
        local atkIcon = CCSprite:createWithSpriteFrameName("atk_icon.png")
        atkFrame:addChild(atkIcon)
        atkIcon:setPosition(ccp(45,atkFrame:getContentSize().height / 2))
        local atkLabel = CCLabelTTF:create(atk, "ccbResources/FZCuYuan-M03S.ttf", 35)
        atkFrame:addChild(atkLabel)
        atkLabel:setAnchorPoint(ccp(0,0.5))
        atkLabel:setPosition(ccp(100,atkFrame:getContentSize().height / 2))

        local defFrame = CCSprite:create("images/heroAttFrame_short.png")
        callingRoleOwner2["attackingOne"]:addChild(defFrame)
        defFrame:setAnchorPoint(ccp(0,0.5))
        defFrame:setPosition(ccp(-2015,105 + 40))
        defFrame:runAction(CCMoveTo:create(1.0,ccp(-15,105 + 40)))
        defFrame:setScale(0.5)
        local defIcon = CCSprite:createWithSpriteFrameName("def_icon.png")
        defFrame:addChild(defIcon)
        defIcon:setPosition(ccp(45,defFrame:getContentSize().height / 2))
        local defLabel = CCLabelTTF:create(def, "ccbResources/FZCuYuan-M03S.ttf", 35)
        defFrame:addChild(defLabel)
        defLabel:setAnchorPoint(ccp(0,0.5))
        defLabel:setPosition(ccp(100,defFrame:getContentSize().height / 2))

        local mpFrame = CCSprite:create("images/heroAttFrame_short.png")
        callingRoleOwner2["attackingOne"]:addChild(mpFrame)
        mpFrame:setAnchorPoint(ccp(0,0.5))
        mpFrame:setPosition(ccp(-2515,75 + 40))
        mpFrame:runAction(CCMoveTo:create(1.25,ccp(-15,75 + 40)))
        mpFrame:setScale(0.5)
        local mpIcon = CCSprite:createWithSpriteFrameName("int_icon.png")
        mpFrame:addChild(mpIcon)
        mpIcon:setPosition(ccp(45,mpFrame:getContentSize().height / 2))
        local mpLabel = CCLabelTTF:create(mp, "ccbResources/FZCuYuan-M03S.ttf", 35)
        mpFrame:addChild(mpLabel)
        mpLabel:setAnchorPoint(ccp(0,0.5))
        mpLabel:setPosition(ccp(100,mpFrame:getContentSize().height / 2))

        -- renzhan newAdd

        local specialAdd = heroConfig.specialadd.attr
        if specialAdd ~= nil then

            -- 显示其他有的副属性
            local mermanNum = 1
            for k,v in pairs(heroConfig.attr) do
                if heroConfig.attr[k] ~= 0 then
                    if k ~= "hp" and k ~= "atk" and k ~= "def" and k ~= "mp" and k ~= specialAdd then
                        local frame = CCSprite:create("images/heroAttFrame_short.png")
                        callingRoleOwner2["attackingOne"]:addChild(frame)
                        frame:setAnchorPoint(ccp(0,0.5))
                        frame:setPosition(ccp(-2515,75 - 30 * mermanNum + 40))
                        frame:runAction(CCMoveTo:create(1.25 + 0.25 * mermanNum,ccp(-15,75 - 30 * mermanNum + 40)))
                        frame:setScale(0.5)
                        local icon = CCSprite:createWithSpriteFrameName(tostring(k).."_icon.png")
                        frame:addChild(icon)
                        icon:setPosition(ccp(45 ,frame:getContentSize().height / 2))

                        local num = heroConfig.attr[k]

                        local label = CCLabelTTF:create(num, "ccbResources/FZCuYuan-M03S.ttf", 35)
                        frame:addChild(label)
                        label:setAnchorPoint(ccp(0,0.5))
                        label:setPosition(ccp(100,frame:getContentSize().height / 2))
                        mermanNum = mermanNum + 1

                    end
                end      
            end 

            local specialFrame = CCSprite:create("images/heroAttFrame_short.png")
            callingRoleOwner2["attackingOne"]:addChild(specialFrame)
            specialFrame:setAnchorPoint(ccp(0,0.5))
            specialFrame:setPosition(ccp(-2515,75 - 30 * mermanNum + 40))
            specialFrame:runAction(CCMoveTo:create(1.25 + 0.25 * mermanNum,ccp(-15,75 - 30 * mermanNum + 40)))
            specialFrame:setScale(0.5)
            local specialIcon = CCSprite:createWithSpriteFrameName(tostring(specialAdd).."_icon.png")
            specialFrame:addChild(specialIcon)
            specialIcon:setPosition(ccp(45,specialFrame:getContentSize().height / 2))
            local specialNum = heroConfig.attr[specialAdd]
            local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
            cache:addSpriteFramesWithFile("ccbResources/publicRes_1.plist")
            if specialNum ~= 0 then
                local specialLabel = CCLabelTTF:create(specialNum, "ccbResources/FZCuYuan-M03S.ttf", 35)
                specialFrame:addChild(specialLabel)
                specialLabel:setAnchorPoint(ccp(0,0.5))
                specialLabel:setPosition(ccp(100,specialFrame:getContentSize().height / 2))
                local specialArrow = CCSprite:createWithSpriteFrameName("arrow_3.png")
                specialArrow:setScale(1.5)
                specialFrame:addChild(specialArrow)
                specialArrow:setAnchorPoint(ccp(0,0.5))
                specialArrow:setPosition(ccp(170,specialFrame:getContentSize().height / 2))
            else
                local specialArrow = CCSprite:createWithSpriteFrameName("arrow_3.png")
                specialArrow:setScale(1.5)
                specialFrame:addChild(specialArrow)
                specialArrow:setAnchorPoint(ccp(0,0.5))
                specialArrow:setPosition(ccp(100,specialFrame:getContentSize().height / 2))
            end
            
        end
        
    end

    showDetailInfoArray:addObject(CCCallFunc:create(showDetailInfo))
    -- s:runAction(CCSequence:create(showDetailInfoArray))
    s:runAction(CCSpeed:create(CCSequence:create(showDetailInfoArray),0.8))
    -- 三个幻影
    for i=1,3 do
        local shadow = CCSprite:createWithSpriteFrameName(aniRes)
        callingRoleOwner2["shadowsLayer"]:addChild(shadow)
        shadow:setAnchorPoint(ccp(0.5,0.5))
        shadow:setPosition(ccp(winSize.width / 2,winSize.height / 2))
        shadow:setOpacity(100)
        shadow:setScaleX(-8-i*2)
        shadow:setScaleY(8+i*2)
        shadow:runAction(CCScaleTo:create(0.75,2))
        shadow:runAction(CCFadeOut:create(0.75))
    end

    -- 让下面的圈转起来
    local rank = _heroRank > 4 and 2 or _heroRank
    local circle = CCSprite:createWithSpriteFrameName("rotatingCircle_"..rank..".png")
    callingRoleOwner2["spinningLayer"]:addChild(circle)
    circle:setPosition(callingRoleOwner2["spinningCircle"]:getPosition())
    circle:runAction(CCRepeatForever:create(CCRotateBy:create(1,24)))
    -- 若隐若现的背景
    local bgRole = CCSprite:create(herodata:getHeroBust1ByHeroId(_heroId))
    callingRoleOwner2["bgLayer"]:addChild(bgRole)
    bgRole:setAnchorPoint(ccp(0.5,0.5))
    bgRole:setPosition(ccp(winSize.width / 2,winSize.height / 2))
    bgRole:setOpacity(0)
    bgRole:setScaleX(-2)
    bgRole:setScaleY(2)
    bgRole:runAction(CCFadeTo:create(0.5,50))
    -- 上飘的粒子效果
    local circleLayer = callingRoleOwner2["circleLayer"]
    HLAddParticleScale( "images/eff_page_72"..(rank+1).."_3.plist", circleLayer, ccp(circleLayer:getContentSize().width/2, circleLayer:getContentSize().height * 0.35), 1, 1, -1,1.25,1.25)

    local giftSoulsAction = CCArray:create()
    giftSoulsAction:addObject(CCDelayTime:create(4.5))
    giftSoulsAction:addObject(CCCallFunc:create(whenRoll))
    bgRole:runAction(CCSequence:create(giftSoulsAction))
end
callingRoleOwner2["onResultShows"] = onResultShows



-- 开始时，门按钮是不可以点击的，手型出现以后设为可用状态，并设置优先级高于本层
local function onHandShows()
    callingRoleOwner["gateBtn"]:setEnabled(true)
    callingRoleOwner["gateMenu"]:setHandlerPriority(-133)
end
callingRoleOwner["onHandShows"] = onHandShows


-- 结束，移除这一层
local function remove()
    _aniLayer:stopAllActions()
    _aniLayer:removeFromParentAndCleanup(true)

   
end
-- 点击召唤出的角色
local function roleTouched()
    -- renzhan
    if runtimeCache.guideStep ~= GUIDESTEP.recruitResult then
        _aniLayer:setTouchEnabled(false)
        callingRoleOwner2["roleMenuItem"]:setEnabled(false)
        callingRoleOwner2["goToListMenu"]:setEnabled(false)
        callingRoleOwner2["continueMenu"]:setEnabled(false)
        callingRoleOwner2["tenTimesMenu"]:setEnabled(false)
        -- 变黑消失
        local array = CCArray:create()
        array:addObject(CCFadeTo:create(0.25,255))
        array:addObject(CCCallFuncN:create(remove))
           
        callingRoleOwner2["cover"]:runAction(CCSequence:create(array))

        moveBackTopAndBottom()
    end
end
callingRoleOwner2["roleTouched"] = roleTouched

-- 前往伙伴列表
local function goToListMenuClick()
    Global:instance():TDGAonEventAndEventData("recruit3")
    if _bTransfered and _showTipWhenQuit then
        ShowText(HLNSLocalizedString("recruit.transferedSouls",herodata:getHeroConfig(_heroId).name,_sendSoulsCount))
    end
    moveBackTopAndBottom()
    if getMainLayer() ~= nil then
        getMainLayer():goToHeroes()
    end
end
callingRoleOwner2["goToListMenuClick"] = goToListMenuClick

local function continueMenuClick()
    Global:instance():TDGAonEventAndEventData("recruit4")
    if _bTransfered and _showTipWhenQuit then
        ShowText(HLNSLocalizedString("recruit.transferedSouls",herodata:getHeroConfig(_heroId).name,_sendSoulsCount))
    end
    roleTouched()
    -- body
end
callingRoleOwner2["continueMenuClick"] = continueMenuClick

local function tenTimesMenuClick()

    local function tenTimesCallback( url, rtnData )
        if callingRoleOwner2["singleCallLayer"]:getPositionX() == winSize.width * 0.5 then
            -- 单次刷将按钮在中间位置，就要弹出提示
            if _bTransfered then
                ShowText(HLNSLocalizedString("recruit.transferedSouls",herodata:getHeroConfig(_heroId).name,_sendSoulsCount))
                -- 继续刷将不再弹出提示
                _showTipWhenQuit = false
            end
        end

        local info = rtnData.info
        callTenTimesAnimation(info)
    
        local dic = rtnData.info
        recruitData.recruit = dic.recruit
        postNotification(NOTI_RECRUIT_BTNUPDATE_REFRESH, nil)
    end


    local cardInfo = recruitData:getAllRecruitCardInfo()

    if (cardInfo[runtimeCache.recruitOption].freeRecruitCDTime > 0 
    and recruitData:getRecruitPriceByTag( runtimeCache.recruitOption ) * 10 > userdata.gold )
    or (cardInfo[runtimeCache.recruitOption].freeRecruitCDTime <= 0 
    and recruitData:getRecruitPriceByTag( runtimeCache.recruitOption ) * 9 > userdata.gold) then

        local text = HLNSLocalizedString("船长，重金才能招募到厉害的伙伴，但是你的金币数量不足了，快去充值招募心仪的伙伴吧！")
        local function cardConfirmAction(  )
            getMainLayer():addChild(createShopRechargeLayer(-400), 100)
        end
        local function cardCancelAction(  )
            
        end
        CCDirector:sharedDirector():getRunningScene():addChild(createSimpleConfirCardLayer(text), 100)
        SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
        SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction
    else
        --"即将消耗金币%d,购买10次%s招募,是否继续?"
        local function sureTenTimesCard(option)
            local moneyNeed 
            if cardInfo[runtimeCache.recruitOption].freeRecruitCDTime > 0 then
                moneyNeed = recruitData:getRecruitPriceByTag( runtimeCache.recruitOption ) * 10
            elseif cardInfo[runtimeCache.recruitOption].freeRecruitCDTime <= 0 then
                moneyNeed = recruitData:getRecruitPriceByTag( runtimeCache.recruitOption ) * 9 
            end
            local tpText 
            if option == 2 then
                tpText = HLNSLocalizedString("logue.recruit.tenMillion") --"千万"  
            elseif option == 3 then
                tpText = HLNSLocalizedString("logue.recruit.oneHundredMillion")  --"亿万"
            end
            local text = HLNSLocalizedString("logue.recruit.sureTenTimes?",moneyNeed,tpText ) --"即将消耗金币%d,购买10次%s招募,是否继续?"
            local function cardConfirmAction(  )
                doActionFun("RECRUITHERO_URL", {option,0,10}, tenTimesCallback)
            end
            local function cardCancelAction(  )
                
            end
            CCDirector:sharedDirector():getRunningScene():addChild(createSimpleConfirCardLayer(text), 100)
            SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
            SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction
        end

        sureTenTimesCard(runtimeCache.recruitOption) 

        -- doActionFun("RECRUITHERO_URL", {runtimeCache.recruitOption,0,10}, tenTimesCallback)
        -- recruitData.cdTimes[runtimeCache.recruitOption] = ConfigureStorage.freeRecruitCDTime[string.format("%d",runtimeCache.recruitOption)]
    end
end
callingRoleOwner2["tenTimesMenuClick"] = tenTimesMenuClick

local function onTouchBegan(x, y)
    return true
end

local function onTouchEnded(x, y)
    if _canQuit then
        _aniLayer:setTouchEnabled(false)
        continueMenuClick()
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

local function getTargetIndex()
    local index = 0
    for k,v in pairs(_giftSouls) do
        if v.getFlag and v.getFlag == 1 then
            index = k - 1
            break
        end
    end
    return index
end



function palyCallingAnimationOfHeroOnNode2(heroId,bTransfered,heroRank,giftSouls,sendSoul,sendSoulsCount,node,bTenCalls)
    print("palyCallingAnimationOfHeroOnNode2", heroId, heroRank)
    _heroId = heroId
    _bTransfered = bTransfered
    _sendSoulsCount = sendSoulsCount
    _parent = node
    _heroRank = heroRank
    _firstShow = true
    _canQuit = false
    _showTipWhenQuit = true
    _bTenCalls = bTenCalls

    -- 有送的魂
    if giftSouls then
        _giftSouls = giftSouls
        _targetIndex = getTargetIndex()
        _resultSoul = sendSoul
        _currentIndex = 5
        _starshineIndex = 4
    else
        _giftSouls = nil
        _resultSoul = nil
        _targetIndex = 0
        _currentIndex = 5
        _starshineIndex = 4        
    end

    -- 召唤层移走，使得按钮不可点击
    -- moveOutTopAndBottom()
    
    _init()
    _aniLayer:registerScriptTouchHandler(onTouch ,false ,-132 ,true )
    _aniLayer:setTouchEnabled(true)

    function _aniLayer:layerTouch(enable)
        _aniLayer:setTouchEnabled(false)
    end

    function _aniLayer:clearLayer()
        -- roleTouched()
        remove()
        moveBackTopAndBottom()
    end
end


