local _layer

-- 名字不要重复
RecruitViewOwner = RecruitViewOwner or {}
ccb["RecruitViewOwner"] = RecruitViewOwner

local function updateCardContent(  )
    local cardInfo = recruitData:getAllRecruitCardInfo()
    for i=1,3 do
        local recruitTime = 1
        local freeRTimesTip = tolua.cast(RecruitViewOwner[string.format("freeRecruitTimesTips%d",i)],"CCLabelTTF") 
        local cdTimeLabel = tolua.cast(RecruitViewOwner[string.format("recruitCDTimeLabel%d",i)],"CCLabelTTF")
        local priceLabel = tolua.cast(RecruitViewOwner[string.format("priceLabel%d",i)],"CCLabelTTF")
        local goldIcon = tolua.cast(RecruitViewOwner[string.format("goldIcon%d",i)],"CCSprite")

        if i ~= 1 then
            for j=1,2 do
                RecruitViewOwner[string.format("btn_b_%d_%d", i - 1, j)]:setOpacity(0)
            end

            if recruitData:isFirstRefreshByTag( i ) then
                -- 没有用过首刷
                -- 禁用且不显示十连刷按钮和label
                RecruitViewOwner[string.format("recruit10Btn%d",i-1)]:setVisible(false)
                RecruitViewOwner[string.format("tenTimesText%d",i-1)]:setVisible(false)

                RecruitViewOwner[string.format("recruit10Btn%d_b",i-1)]:setVisible(false)
                RecruitViewOwner[string.format("tenTimesText%d_b",i-1)]:setVisible(false)
                RecruitViewOwner[string.format("b_bg_%d", i - 1)]:setVisible(false)

                for j=1,2 do
                    RecruitViewOwner[string.format("btn_b_%d_%d", i - 1, j)]:setVisible(false)
                end

            else 
                local bonus = recruitData:getActivityBonus(i)
                if not bonus then
                    -- 启用并显示十连刷按钮
                    RecruitViewOwner[string.format("recruit10Btn%d",i-1)]:setVisible(true)
                    RecruitViewOwner[string.format("tenTimesText%d",i-1)]:setVisible(true)

                    RecruitViewOwner[string.format("recruit10Btn%d_b",i-1)]:setVisible(false)
                    RecruitViewOwner[string.format("tenTimesText%d_b",i-1)]:setVisible(false)
                    RecruitViewOwner[string.format("b_bg_%d", i - 1)]:setVisible(false)
                    for j=1,2 do
                        RecruitViewOwner[string.format("btn_b_%d_%d", i - 1, j)]:setVisible(false)
                    end
                else
                    RecruitViewOwner[string.format("recruit10Btn%d",i-1)]:setVisible(false)
                    RecruitViewOwner[string.format("tenTimesText%d",i-1)]:setVisible(false)

                    RecruitViewOwner[string.format("recruit10Btn%d_b",i-1)]:setVisible(true)
                    RecruitViewOwner[string.format("tenTimesText%d_b",i-1)]:setVisible(true)
                    RecruitViewOwner[string.format("b_bg_%d", i - 1)]:setVisible(true)
                    for j=1,2 do
                        local heroId = bonus[j]
                        RecruitViewOwner[string.format("btn_b_%d_%d", i - 1, j)]:setVisible(heroId ~= nil)
                        RecruitViewOwner[string.format("b_f_%d_%d", i - 1, j)]:setVisible(heroId ~= nil)
                        if heroId then
                            local hero = herodata:getHeroConfig(heroId)
                            RecruitViewOwner[string.format("b_i_%d_%d", i - 1, j)]:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(herodata:getHeroHeadByHeroId(heroId)))
                            RecruitViewOwner[string.format("b_f_%d_%d", i - 1, j)]:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", hero.rank)))
                        end
                    end
                end
            end
        end

        if cardInfo[i].freeRecruitCDTime > 0 then
            -- 有cd，不免费
            freeRTimesTip:setVisible(false)
            cdTimeLabel:setVisible(true)
            priceLabel:setVisible(true)
            goldIcon:setVisible(true)
            cdTimeLabel:setString(string.format(HLNSLocalizedString("%s后免费"),DateUtil:second2dhms(cardInfo[i].freeRecruitCDTime)))
            priceLabel:setString(cardInfo[i].recruitPay)
            if i ~= 1 then
                local tipSprite = tolua.cast(RecruitViewOwner["tipSprite"..i],"CCSprite")
                if recruitData:isFirstRefreshByTag( i ) then
                    tipSprite:setVisible(true)
                else                    
                    tipSprite:setVisible(false)
                end
            end
        else
            -- 无cd，免费刷一次
            freeRTimesTip:setVisible(true)
            cdTimeLabel:setVisible(false)
            priceLabel:setVisible(false)
            goldIcon:setVisible(false)
            if recruitData.recruit and recruitData.recruit ~= {} and recruitData.recruit ~= "" then
                if i == 1 then      -- 百万悬赏显示略微不同
                    if recruitData.recruit.times and recruitData.recruit.times[string.format("%d",i)] then
                        if cardInfo[i].freeRecruitTimes == recruitData.recruit.times[string.format("%d",i)]["dayFree"] then                         
                            freeRTimesTip:setVisible(false)
                            cdTimeLabel:setString(HLNSLocalizedString("今日免费机会已用完"))
                            cdTimeLabel:setVisible(true)
                            priceLabel:setString(cardInfo[i].recruitPay)
                            priceLabel:setVisible(true)
                            goldIcon:setVisible(true)
                        else
                            freeRTimesTip:setString(HLNSLocalizedString("今日%s/%s次免费机会",cardInfo[i].freeRecruitTimes - recruitData.recruit.times[string.format("%d",i)]["dayFree"], cardInfo[i].freeRecruitTimes))
                        end
                    else
                        freeRTimesTip:setString(HLNSLocalizedString("今日%s/%s次免费机会",cardInfo[i].freeRecruitTimes, cardInfo[i].freeRecruitTimes))
                    end
                else     
                    
                    if recruitData.recruit.times and recruitData.recruit.times[string.format("%d",i)] then
                        freeRTimesTip:setString(HLNSLocalizedString("今日%s/%s次免费机会",cardInfo[i].freeRecruitTimes - recruitData.recruit.times[string.format("%d",i)]["dayFree"], cardInfo[i].freeRecruitTimes))
                    else
                        freeRTimesTip:setString(HLNSLocalizedString("今日%s/%s次免费机会",cardInfo[i].freeRecruitTimes, cardInfo[i].freeRecruitTimes))
                    end
                end
            else
                freeRTimesTip:setString(HLNSLocalizedString("今日%s/%s次免费机会",cardInfo[i].freeRecruitTimes, cardInfo[i].freeRecruitTimes))
            end
        end
    end
end

local function _updateCDTimer(  )
    local cardInfo = recruitData:getAllRecruitCardInfo()
    for i=1,3 do
        local cdTimeLabel = tolua.cast(RecruitViewOwner[string.format("recruitCDTimeLabel%d",i)],"CCLabelTTF")
        local recruitBtn = tolua.cast(RecruitViewOwner[string.format("recruitBtn%d",i)],"CCMenuItemImage")
        cdTimeLabel:setString(HLNSLocalizedString("%s后免费",DateUtil:second2dhms(cardInfo[i].freeRecruitCDTime)))
        local light = recruitBtn:getChildByTag(9888)
        if light then
            light:stopAllActions()
            light:removeFromParentAndCleanup(true)
        end
        if cardInfo[i].freeRecruitCDTime ~= 0 then
            updateCardContent()
        else

            local light = CCSprite:createWithSpriteFrameName("lightingEffect_recruitBtn_1.png")
            local animFrames = CCArray:create()
            for j = 1, 3 do
                local frameName = string.format("lightingEffect_recruitBtn_%d.png",j)
                local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(frameName)
                animFrames:addObject(frame)
            end
            local animation = CCAnimation:createWithSpriteFrames(animFrames, 0.2)
            local animate = CCAnimate:create(animation)
            light:runAction(CCRepeatForever:create(animate))
            recruitBtn:addChild(light,1,9888)
            light:setPosition(ccp(recruitBtn:getContentSize().width / 2,recruitBtn:getContentSize().height / 2 + 2))

            if recruitData.recruit and recruitData.recruit ~= {} and recruitData.recruit ~= "" then
                if i == 1 then      -- 百万悬赏显示略微不同
                    if recruitData.recruit.times and recruitData.recruit.times[string.format("%d",i)] then
                        if cardInfo[i].freeRecruitTimes == recruitData.recruit.times[string.format("%d",i)]["dayFree"] then
                            if light then
                                light:stopAllActions()
                                light:removeFromParentAndCleanup(true)
                            end
                        end
                    end
                end
            end
        end
    end
end

local function recruitActionCallBack( url,rtnData )
    if rtnData.code ~= 200 then
        return
    end
    
    local dic = rtnData.info
    local pay = dic.pay
    local gain = dic.gain
    local recruitStates = dic.recruit
    recruitData.recruit = dic.recruit

    -- 送的魂
    local giftSouls = dic.sendSouls
    local sendSoul = {}
    local giftSoulCount = 0
    if giftSouls then
        for k,v in pairs(giftSouls) do
            if v.getFlag and v.getFlag == 1 then
                -- 找到送的魂是哪个
                sendSoul = v
                giftSoulCount = v.amount
                break
            end
        end
    else
        sendSoul = nil
    end

    updateCardContent()
    postNotification(NOTI_RECRUIT_BTNUPDATE_REFRESH, nil)
    local heroOrSoulId = ""
    local bTransfered = false
    local sendSoulsCount = 0
    -- 刷到英雄
    if gain.heros then
        local key = firstKeyInDic(gain.heros)
        heroOrSoulId = gain.heros[key].heroId
    elseif gain.heroes_soul then
    -- 刷到的英雄玩家已有，转化为魂
        bTransfered = true
        if not giftSouls then            
            -- 没有赠魂，只有转化的魂，则只有一对kv，取得即可
            heroOrSoulId = firstKeyInDic(gain.heroes_soul)
            sendSoulsCount = gain.heroes_soul[heroOrSoulId]
        else
            -- 有赠魂，要比较，与赠魂id相同，则比较数量，数量大于赠魂的数量，或者与赠魂id不同的一组才是刷到的英雄转化的
            for k,v in pairs(gain.heroes_soul) do
                if sendSoul.hero ~= k then
                -- 不是赠的魂，那转化的魂就是这组了，转化的魂的数量也是直接获得
                    heroOrSoulId = k
                    sendSoulsCount = v
                    break
                elseif sendSoul.hero == k and v ~= giftSoulCount then
                -- 和赠的魂id一致，数量不同，则转化的魂和赠的魂是相同的，转化的数量要减去赠魂的数量
                    heroOrSoulId = k
                    sendSoulsCount = v - giftSoulCount
                    break
                else
                    -- 和赠魂的id数量都一致，那么这就是赠魂，继续循环
                end
            end
        end
    end
    local heroRank = herodata:getHeroConfig(heroOrSoulId).rank
    palyCallingAnimationOfHeroOnNode(heroOrSoulId,bTransfered, heroRank,giftSouls,sendSoul,sendSoulsCount,getLogueTownLayer(),false)
end

local function recruit10ActionCallBack( url,rtnData )
    if rtnData.code ~= 200 then
        return
    end
    
    local dic = rtnData.info
    recruitData.recruit = dic.recruit
    print("done")
    PrintTable(recruitData.recruit)
    updateCardContent()
    postNotification(NOTI_RECRUIT_BTNUPDATE_REFRESH, nil)

    runtimeCache.tenCallsInfo = rtnData.info
    
    palyCallingAnimationOfHeroOnNode("hero_000101",false, runtimeCache.recruitOption+1,{},{},0,getLogueTownLayer(),true)
end

local function recruitAction( tag,sender )
    if tag == 101 then
        Global:instance():TDGAonEventAndEventData("recruit1")
    elseif tag == 102 then
        Global:instance():TDGAonEventAndEventData("recruit2")
    elseif tag == 103 then
        Global:instance():TDGAonEventAndEventData("recruit3")
    end

    local option = math.mod(tag, 100)
    runtimeCache.recruitOption = option
    local cardInfo = recruitData:getAllRecruitCardInfo()
    for i=1,3 do
        local cdTimeLabel = tolua.cast(RecruitViewOwner[string.format("recruitCDTimeLabel%d",i)],"CCLabelTTF")
        cdTimeLabel:setString(HLNSLocalizedString("%s后免费",DateUtil:second2dhms(cardInfo[i].freeRecruitCDTime)))
        if cardInfo[i].freeRecruitCDTime ~= 0 then
            updateCardContent()
        end
    end

    local function sureTenTimesCard(option, tag)

        local moneyNeed = recruitData:getRecruitPriceByTag( option ) * math.floor(tag/100)
        local tpText 
        if option == 2 then
            tpText = HLNSLocalizedString("logue.recruit.tenMillion") --"千万"  
        elseif option == 3 then
            tpText = HLNSLocalizedString("logue.recruit.oneHundredMillion")  --"亿万"
        end
        local text = HLNSLocalizedString("logue.recruit.sureTenTimes?",moneyNeed,tpText )
        local function cardConfirmAction(  )
            doActionFun("RECRUITHERO_URL", {option,0,10}, recruit10ActionCallBack)
        end
        local function cardCancelAction(  )
            
        end
        CCDirector:sharedDirector():getRunningScene():addChild(createSimpleConfirCardLayer(text), 100)
        SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
        SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction
    end

    if cardInfo[option].freeRecruitCDTime > 0 then
        if recruitData:getRecruitPriceByTag( option ) * math.floor(tag/100) > userdata.gold then
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
            if tag > 1000 then
                print("before")
                PrintTable(recruitData.recruit)
                sureTenTimesCard(option, tag) --"即将消耗金币%d,购买10次%s招募,是否继续?"
                -- doActionFun("RECRUITHERO_URL", {option,0,10}, recruit10ActionCallBack)
            else
                doActionFun("RECRUITHERO_URL", {option}, recruitActionCallBack)
            end
            -- for i=1,3 do
            --     if i == option then
            --         recruitData.cdTimes[i] = ConfigureStorage.freeRecruitCDTime[string.format("%d",i)]
            --     end
            -- end
        end
    else
        if tag > 1000 and recruitData:getRecruitPriceByTag( option ) * 9 > userdata.gold then
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
            if tag > 1000 then
                sureTenTimesCard(option, tag) --"即将消耗金币%d,购买10次%s招募,是否继续?"
                -- doActionFun("RECRUITHERO_URL", {option,0,10}, recruit10ActionCallBack)
            else
                doActionFun("RECRUITHERO_URL", {option}, recruitActionCallBack)
            end
            -- for i=1,3 do
            --     if i == option then
            --         recruitData.cdTimes[i] = ConfigureStorage.freeRecruitCDTime[string.format("%d",i)]
            --     end
            -- end
        end
    end
    
end

RecruitViewOwner["recruitAction"] = recruitAction

local function bonusClick(tag)
    local bonus = recruitData:getActivityBonus(math.floor(tag / 10) + 1)
    if not bonus or not bonus[math.floor(tag % 10)] then
        return
    end
    local heroId = bonus[math.floor(tag % 10)]
    getMainLayer():getParent():addChild(createHeroInfoLayer(heroId, HeroDetail_Clicked_Handbook, -135), 10)
end
RecruitViewOwner["bonusClick"] = bonusClick

local function infoClick(tag)
    local heroes = recruitData:getRecruitHeroes(tag)
    local bonus = recruitData:getActivityBonusAndResult(tag)
    getMainLayer():addChild(createRecruitHeroesLayer(heroes, bonus))
end
RecruitViewOwner["infoClick"] = infoClick

local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/RecruitView.ccbi",proxy, true,"RecruitViewOwner")
    _layer = tolua.cast(node,"CCLayer")
    local _mainLayer = getMainLayer()
    local recritBg = RecruitViewOwner["recritBg"]
    local contentHeight = recritBg:getContentSize().height * retina
    local height = contentHeight - (winSize.height - 235.2 * retina - _mainLayer:getBottomContentSize().height) / 2
    local frameBg1 = RecruitViewOwner["frameBg1"]
    frameBg1:setPosition(ccp(frameBg1:getPositionX(),height/retina))
    local frameBg2 = RecruitViewOwner["frameBg2"]
    frameBg2:setPosition(ccp(frameBg2:getPositionX(),height/retina))
    local frameBg3 = RecruitViewOwner["frameBg3"]
    frameBg3:setPosition(ccp(frameBg3:getPositionX(),height/retina))

    updateCardContent()

    print("guideStep", runtimeCache.guideStep)
    if runtimeCache.bGuide and runtimeCache.guideStep + 1 == GUIDESTEP.recruit then
        local recruitBtn3 = tolua.cast(RecruitViewOwner["recruitBtn3"], "CCMenuItem")
        local guideLayer = getGuideLayer()
        local touchLayer = tolua.cast(GuideOwner["touch5"], "CCLayer")
        local ghLayer = tolua.cast(GuideOwner["ghLayer5"], "CCLayer")
        if touchLayer and ghLayer then
            local y = (winSize.height - 235.2 * retina + _mainLayer:getBottomContentSize().height - frameBg3:getContentSize().height * retina) / 2 
                        + recruitBtn3:getPositionY() * retina
            local x = (recritBg:getContentSize().width * retina - winSize.width) / 2
            touchLayer:setPosition(ccp(frameBg3:getPositionX() * retina - x, y))
            ghLayer:setPosition(ccp(frameBg3:getPositionX() * retina - x, y))
        end
    end
end


-- 该方法名字每个文件不要重复
function getRecruitLayer()
	return _layer
end

function createRecruitViewNode()
    _init()

	function _layer:refresh()
		
	end

    function _layer:recruitActionCallBack(url, rtnData)
        recruitActionCallBack(url, rtnData)     
    end

    function _layer:recruitAction(tag)
        recruitAction(tag)
    end

    local function _onEnter()
        recruitData:setAllCardCDTime()
        addObserver(NOTI_RECRUIT_CD_TIMER, _updateCDTimer)
    end

    local function _onExit()
        removeObserver(NOTI_RECRUIT_CD_TIMER, _updateCDTimer)
        _layer = nil
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