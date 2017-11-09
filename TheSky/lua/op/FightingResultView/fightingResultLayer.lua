local _layer
local _scene
local _resultType

ResultType = {
    NewWorldWin = 1,
    NewWorldLose = 2,
    SailWin = 3,
    SailLose = 4,
}
-- 跳转权重
local goto_weight = {
    ["1"] = 3,  -- 装备强化
    ["2"] = 3,  -- 伙伴培养
    ["3"] = 2,  -- 奥义突破
    ["4"] = 2,  -- 战舰强化
    ["5"] = 1,  -- 伙伴突破
    ["6"] = 1,  -- 炼影
}

local GOTO_TAG = {
    REFINE = 1,
    CULTURE = 2,
    SKILL = 3,
    BATTLESHIP = 4,
    BREAK = 5,
    SHADOW = 6,
    RECRUIT = 7,
    BOX = 8,
}

local NewWorldWinViewOwner = NewWorldWinViewOwner or {}

local NewWorldLoseViewOwner = NewWorldLoseViewOwner or {}

local SailWinViewOwner = SailWinViewOwner or {}

local SailLoseViewOwner = SailLoseViewOwner or {}

local function videoItemClick()
    runtimeCache.bVideo = true
    BattleLog:reset()
    CCDirector:sharedDirector():replaceScene(CCTransitionFade:create(0.6, FightingScene()))
end
NewWorldWinViewOwner["videoItemClick"] = videoItemClick
NewWorldLoseViewOwner["videoItemClick"] = videoItemClick
SailWinViewOwner["videoItemClick"] = videoItemClick
SailLoseViewOwner["videoItemClick"] = videoItemClick

local function newWorldWinClose()
    runtimeCache.newWorldState = blooddata.data.flag
    CCDirector:sharedDirector():replaceScene(mainSceneFun())
    getMainLayer():gotoAdventure()
end
NewWorldWinViewOwner["newWorldWinClose"] = newWorldWinClose

local function newWorldLoseClose()
    _scene:addChild(createNewWorldOverLayer(), 100)
end
NewWorldLoseViewOwner["newWorldLoseClose"] = newWorldLoseClose

local function viewItemClick()
    -- _layer:getParent():addChild(createTeamCompLayer(userdata:getUserBattleInfo(), playerBattleData), 100)
    _layer:getParent():addChild(createTeamPopupLayer(-140))
end
SailLoseViewOwner["viewItemClick"] = viewItemClick

local function gotoItemClick(tag)
    if blooddata and blooddata.data then
        runtimeCache.newWorldState = blooddata.data.flag
    end
    if tag == GOTO_TAG.REFINE then
        CCDirector:sharedDirector():replaceScene(CCTransitionFade:create(0.6, mainSceneFun()))
        getMainLayer():gotoEquipmentsLayer()
    elseif tag == GOTO_TAG.CULTURE then
        CCDirector:sharedDirector():replaceScene(CCTransitionFade:create(0.6, mainSceneFun()))
        getMainLayer():goToHeroes(0)
    elseif tag == GOTO_TAG.SKILL then
        CCDirector:sharedDirector():replaceScene(CCTransitionFade:create(0.6, mainSceneFun()))
        getMainLayer():gotoSkillViewLayer()
    elseif tag == GOTO_TAG.BATTLESHIP then
        CCDirector:sharedDirector():replaceScene(CCTransitionFade:create(0.6, mainSceneFun()))
        getMainLayer():gotoBattleShipLayer()
    elseif tag == GOTO_TAG.BREAK then
        CCDirector:sharedDirector():replaceScene(CCTransitionFade:create(0.6, mainSceneFun()))
        getMainLayer():goToHeroes(1)
        getHeroesLayer():clickHunPo(  )
    elseif tag == GOTO_TAG.SHADOW then
        if shadowData:bOpenShadowFun() then
            CCDirector:sharedDirector():replaceScene(CCTransitionFade:create(0.6, mainSceneFun()))
            getMainLayer():gotoTrainShadowView()
        else
            if shadowData:openLevel() then
                ShowText(HLNSLocalizedString("shadow.open.tips", shadowData:openLevel()))
            else
                ShowText(HLNSLocalizedString("component.close"))
            end
        end
    elseif tag == GOTO_TAG.RECRUIT then
        CCDirector:sharedDirector():replaceScene(CCTransitionFade:create(0.6, mainSceneFun()))
        getMainLayer():goToLogue()
    elseif tag == GOTO_TAG.BOX then
        CCDirector:sharedDirector():replaceScene(CCTransitionFade:create(0.6, mainSceneFun()))
        getMainLayer():goToLogue()
        local function changePage()
            getLogueTownLayer():gotoPageByType(1)
        end
        _layer:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(changePage)))
    end
end
SailLoseViewOwner["gotoItemClick"] = gotoItemClick
NewWorldLoseViewOwner["gotoItemClick"] = gotoItemClick


local function SailResultClose()
    CCDirector:sharedDirector():replaceScene(mainSceneFun())
    if BattleField.mode == BattleMode.stage then
        getMainLayer():goToSail()
        if runtimeCache.bPlayStageTalk then
            getSailLayer():playStageTalk()
            runtimeCache.bPlayStageTalk = false
        end
    elseif BattleField.mode == BattleMode.chapter then
        getMainLayer():gotoAdventure()
        getAdventureLayer():chapterFightResult()
    elseif BattleField.mode == BattleMode.arena then
        getMainLayer():gotoArena()
    elseif BattleField.mode == BattleMode.marineBoss then
        -- 前往海军支部
        getMainLayer():gotoMarineBranchLayer()
    elseif BattleField.mode == BattleMode.boss then
        CCDirector:sharedDirector():replaceScene(CCTransitionFade:create(0.6, mainSceneFun()))
        getMainLayer():gotoAdventure()
        getAdventureLayer():bossFightEnd()
    elseif BattleField.mode == BattleMode.unionBattle then
        CCDirector:sharedDirector():replaceScene(CCTransitionFade:create(0.6, mainSceneFun()))
        runtimeCache.unionBattleBack = true
        getMainLayer():gotoUnion()
    elseif BattleField.mode == BattleMode.worldwar then
        CCDirector:sharedDirector():replaceScene(CCTransitionFade:create(0.6, mainSceneFun()))
        getMainLayer():gotoWorldWarIsland()
    elseif BattleField.mode == BattleMode.veiledSea then
        CCDirector:sharedDirector():replaceScene(CCTransitionFade:create(0.6, mainSceneFun()))
        showVeiledSea()
    elseif BattleField.mode == BattleMode.wwRob then
        CCDirector:sharedDirector():replaceScene(CCTransitionFade:create(0.6, mainSceneFun()))
        getMainLayer():gotoRobItem()
        local function popup()
            getWWRobItemLayer():popupResult()
        end
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.6), CCCallFunc:create(popup))
        _scene:runAction(seq)
    elseif BattleField.mode == BattleMode.SSA then  -- 战斗结束后跳转界面
        CCDirector:sharedDirector():replaceScene(CCTransitionFade:create(0.6, mainSceneFun()))
        
        local _data = ssaData.data

        if ssaData.data.timeStatus == "begin" then  --排位赛结束，等待阶段
            if tonumber(ssaData.data.rankId) == 0 then -- 32 晋升之路
                runtimeCache.SSAState = ssaDataFlag.pointRace
                getMainLayer():gotoAdventure(false)  
            else
                if _data.data.expNow < ConfigureStorage.crossDual_score[tonumber(_data.rankId) + 1].scoreNeed then
                    -- 积分不够，继续挑战
                    runtimeCache.SSAState = ssaDataFlag.pointRace
                    -- getMainLayer():gotoAdventure(false)
                else
                    runtimeCache.SSAState = ssaDataFlag.pointRaceRanking
                    getMainLayer():gotoAdventure(false)
                    local winCount = 0
                    for k,v in pairs(_data.data.enemys) do
                        if v.isWin == true then
                            winCount = winCount + 1
                        end
                    end
                    if winCount < 3 then  -- 没打赢三场 继续挑战
                        runtimeCache.SSAState = ssaDataFlag.pointRaceRanking  
                    else
                        runtimeCache.SSAState = ssaDataFlag.pointRace
                        getMainLayer():gotoAdventure(false) 
                    end    
                end     
            end
        elseif ssaData.data.timeStatus == auditionsEnd then 
            
        elseif ssaData.data.timeStatus == "worshipBegin" then
            
        else
            
            runtimeCache.SSAState = ssaDataFlag.FourKing
        end
        if runtimeCache.SSAState == ssaDataFlag.FourKing then -- 四皇争霸
            getMainLayer():gotoSSAFourKing() 
        elseif runtimeCache.SSAState == ssaDataFlag.pointRace then -- 积分赛
            getMainLayer():gotoPointsRace() 
        elseif runtimeCache.SSAState == ssaDataFlag.pointRaceRanking then -- 排位晋级赛
            getMainLayer():gotoPointsRaceRanking()    
        end
        -- 胜利local bWin = BattleField.result == RESULT_WIN
    elseif BattleField.mode == BattleMode.wwRobVideo then  --劫镖战斗回放结束后跳转
        CCDirector:sharedDirector():replaceScene(CCTransitionFade:create(0.6, mainSceneFun()))
        getMainLayer():gotoEscortItemState()
    elseif BattleField.mode == BattleMode.racingBattle or BattleField.mode == BattleMode.racingBattleBoss then
        CCDirector:sharedDirector():replaceScene(CCTransitionFade:create(0.6, mainSceneFun()))
        -- 先回到主页面创建一个Layer 再跳转
        runtimeCache.unionRacingBattleBack = true
        getMainLayer():gotoUnion()
    end
end
SailWinViewOwner["SailResultClose"] = SailResultClose
SailLoseViewOwner["SailResultClose"] = SailResultClose

-- 在录像下、boss阻止弹出奖励框 方法
local function _popupGain()
    if runtimeCache.bVideo then
        runtimeCache.bVideo = false
        return
    end
    if BattleField.mode == BattleMode.boss or BattleField.mode == BattleMode.wwRob then
        return
    end
    local resp = runtimeCache.responseData
    if resp.gain then
        userdata:popUpGain(resp.gain)
    end
end

-- 刷新新世界战斗胜利界面
local function _refreshNewWorldWinLayer()
    local resp = runtimeCache.responseData
    local gain = {}
    if resp.gain then
        gain = resp.gain
    end
    local pay = {}
    if resp.pay then
        pay = resp.pay
    end
    if not runtimeCache.bVideo then
        userdata:updateUserDataWithGainAndPay(gain, pay)
    end

    local resultLabel = tolua.cast(NewWorldWinViewOwner["resultLabel"], "CCSprite")
    local result = 4 - BattleField.round
    resultLabel:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("win_%d.png", result)))
    for i=1,result do
        local star = tolua.cast(NewWorldWinViewOwner["star"..i], "CCSprite")
        star:setVisible(true)
    end
    local roundLabel = tolua.cast(NewWorldWinViewOwner["roundLabel"], "CCLabelTTF")
    roundLabel:setString(string.format(roundLabel:getString(), BattleField.round))
    local starLabel = tolua.cast(NewWorldWinViewOwner["starLabel"], "CCLabelTTF")
    starLabel:setString(string.format(starLabel:getString(), result, runtimeCache.newWorldGrade))
    local attrLabel = tolua.cast(NewWorldWinViewOwner["attrLabel"], "CCLabelTTF")
    if runtimeCache.newWorldOutpostNum % 3 == 0 then
        attrLabel:setString(string.format(attrLabel:getString(), 0))
    else
        attrLabel:setString(string.format(attrLabel:getString(), 3 - runtimeCache.newWorldOutpostNum % 3))
    end
    local rewardLabel = tolua.cast(NewWorldWinViewOwner["rewardLabel"], "CCLabelTTF")
    if runtimeCache.newWorldOutpostNum % 5 == 0 then
        rewardLabel:setString(string.format(rewardLabel:getString(), 0))
    else
        rewardLabel:setString(string.format(rewardLabel:getString(), 5 - runtimeCache.newWorldOutpostNum % 5))
    end

end

local function _refreshNewWorldLoseLayer()
    local resp = runtimeCache.responseData
    local gain = {}
    if resp.gain then
        gain = resp.gain
    end
    local pay = {}
    if resp.pay then
        pay = resp.pay
    end
    if not runtimeCache.bVideo then
        userdata:updateUserDataWithGainAndPay(gain, pay)
    end
    local resultLabel = tolua.cast(NewWorldLoseViewOwner["resultLabel"], "CCSprite")
    local result = BattleField.round
    resultLabel:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("lose_%d.png", result)))
    
    local tipsLabel = tolua.cast(NewWorldLoseViewOwner["tipsLabel"], "CCLabelTTF")
    tipsLabel:setString(HLNSLocalizedString("deadGuide.tips."..RandomManager.randomRange(1, 4)))
    local gotos = {}
    while(#gotos < 2) do
        local rand = RandomManager.prob(goto_weight)
        if not table.ContainsObject(gotos, rand) then
            table.insert(gotos, rand)
        end   
    end
    for i=1,2 do
        local gotoItem = tolua.cast(NewWorldLoseViewOwner["gotoItem"..i], "CCMenuItem")
        gotoItem:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("btn_goto_%s_0.png", gotos[i])))
        gotoItem:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("btn_goto_%s_1.png", gotos[i])))
        gotoItem:setTag(tonumber(gotos[i]))

        local gotoLabel = tolua.cast(NewWorldLoseViewOwner["gotoLabel"..i], "CCLabelTTF")
        gotoLabel:setString(HLNSLocalizedString(string.format("deadGuide.goto."..gotos[i])))
    end
end

local function endLevelUpAni()
    print("加粒子")
end
SailWinViewOwner["endLevelUpAni"] = endLevelUpAni

local function _refreshSailWinLayer()
    local resp = runtimeCache.responseData
    local gain = {}
    if resp.gain then
        gain = resp.gain
    end
    local pay = {}
    if resp.pay then
        pay = resp.pay
    end
    if not runtimeCache.bVideo and BattleField.mode ~= BattleMode.boss then
        userdata:updateUserDataWithGainAndPay(gain, pay)
        if BattleField.mode == BattleMode.stage then
            if stageMode == STAGE_MODE.NOR then
                storydata:updateStoryData(resp)
            elseif stageMode == STAGE_MODE.ELITE then
                elitedata:updateData(resp)
            end
        end
    end
    if BattleField.mode == BattleMode.veiledSea then
        if gain["silver"] then
            local _gain = {}
            _gain.silver = gain["silver"]
            userdata:popUpGain(_gain, true)
        end
        -- userdata:popUpGain(gain, true)
    end
    -- runtimeCache.bVideo = false
    local resultLabel = tolua.cast(SailWinViewOwner["resultLabel"], "CCSprite")
    local result = 4 - BattleField.round
    resultLabel:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("win_%d.png", result)))
    for i=1,result do
        local star = tolua.cast(SailWinViewOwner["star"..i], "CCSprite")
        star:setVisible(true)
    end

    local roundLabel = tolua.cast(SailWinViewOwner["roundLabel"], "CCLabelTTF")
    roundLabel:setString(string.format(roundLabel:getString(), BattleField.round))
    local expLabel = tolua.cast(SailWinViewOwner["expLabel"], "CCLabelTTF")
    local heroExp = 0
    if BattleField.mode == BattleMode.worldwar then
        local left = BattleField.round
        local right = 10 - left
        if userdata.level >= playerBattleData.level + 15 then
            left = 0
        end
        expLabel:setString(HLNSLocalizedString("ww.fight.result", right, left))
    elseif BattleField.mode == BattleMode.racingBattle or BattleField.mode == BattleMode.racingBattleBoss then
        
        local score = runtimeCache.responseData.winMark
        expLabel:setString(HLNSLocalizedString("racingBattle.fight.win", score))
        
    else
        local silver = 0
        local playerExp = 0
        if gain.exp_player then
            playerExp = gain.exp_player
        end
        if gain.silver then
            silver = gain.silver
        end
        if gain.exp_hero then
            heroExp = gain.exp_hero
        end
        expLabel:setString(string.format(expLabel:getString(), playerExp, silver))
    end
    for i=0,table.getTableCount(herodata.form) - 1 do
        local heroBg = tolua.cast(SailWinViewOwner["heroBg"..(i + 1)], "CCSprite")
        heroBg:setVisible(true)
        local hid = herodata.form[tostring(i)]
        local hero = herodata:getHero(herodata.heroes[hid])
        local heroConfig = herodata:getHeroConfig(hero.heroId)
        local rank = tolua.cast(SailWinViewOwner["rank"..i+1], "CCSprite")
        rank:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("rank_%d_icon.png", herodata:fixRank(heroConfig.rank, hero.wake))))
        local frame = tolua.cast(SailWinViewOwner["frame"..i+1], "CCSprite")
        frame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", herodata:fixRank(heroConfig.rank, hero.wake))))
        local head = tolua.cast(SailWinViewOwner["head"..i+1], "CCSprite")
        local heroExpLabel = tolua.cast(SailWinViewOwner["heroExp"..i+1], "CCLabelTTF")
        heroExpLabel:setString(string.format(heroExpLabel:getString(), heroExp))
        local f = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(herodata:getHeroHeadByHeroId(hero.heroId))
        if f then
            head:setDisplayFrame(f)
        else
            head:setVisible(false)
        end
        local name = tolua.cast(SailWinViewOwner["name"..i+1], "CCLabelTTF")
        name:setString(heroConfig.name)
        local heroLevel = tolua.cast(SailWinViewOwner["heroLevel"..i+1], "CCLabelTTF")
        if isPlatform(IOS_INFIPLAY_RUS) or isPlatform(ANDROID_INFIPLAY_RUS) then
            heroLevel:setString(string.format("Ур.%d", hero.level))
        else
            heroLevel:setString(string.format("LV%d", hero.level))
        end

        local progressBg = tolua.cast(SailWinViewOwner["progressBg"..i+1], "CCSprite")
        local progress1 = CCProgressTimer:create(CCSprite:create("images/bluePro.png"))
        progress1:setType(kCCProgressTimerTypeBar)
        progress1:setMidpoint(CCPointMake(0, 0))
        progress1:setBarChangeRate(CCPointMake(1, 0))
        progress1:setPosition(progressBg:getPositionX(), progressBg:getPositionY())
        progressBg:getParent():addChild(progress1, 1)

        local progress = CCProgressTimer:create(CCSprite:create("images/grePro.png"))
        progress:setType(kCCProgressTimerTypeBar)
        progress:setMidpoint(CCPointMake(0, 0))
        progress:setBarChangeRate(CCPointMake(1, 0))
        progress:setPosition(progressBg:getPositionX(), progressBg:getPositionY())
        progressBg:getParent():addChild(progress, 0)

        local progressTo
        local heroExp = 0
        if gain.exp_hero then
            heroExp = gain.exp_hero
        end
        if hero.exp_now < heroExp then
            progress1:setPercentage(0)
            progress:setPercentage(0)
            progressTo = CCProgressFromTo:create(0.5, 0, hero.exp_now / hero.expMax * 100)
            local levelIcon = tolua.cast(SailWinViewOwner["levelIcon"..i+1], "CCSprite")
            levelIcon:setVisible(true)
        else
            progress1:setPercentage((hero.exp_now - heroExp) / hero.expMax * 100)
            progress:setPercentage((hero.exp_now - heroExp) / hero.expMax * 100)
            progressTo = CCProgressFromTo:create(0.5, (hero.exp_now - heroExp) / hero.expMax * 100, hero.exp_now / hero.expMax * 100)
        end
        progress:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(1), progressTo))
    end

    local expDoubleBg = tolua.cast(SailWinViewOwner["expDoubleBg"], "CCSprite")
    if expDoubleBg then
        if userdata:hasBattleDouble(BattleField.mode) then
            expDoubleBg:setVisible(true)
            local expDouble = tolua.cast(SailWinViewOwner["expDouble"], "CCLabelTTF")
            expDouble:setString(HLNSLocalizedString("expDouble.tips", ConfigureStorage.battleDouble.expTimes))
        end
    end
end

local function _refreshSailLoseLayer()
    local resp = runtimeCache.responseData
    local gain = resp.gain
    if not gain then
        gain = {}
    end
    local pay = resp.pay
    if not pay then
        pay = {}
    end
    if not runtimeCache.bVideo then
        userdata:updateUserDataWithGainAndPay(gain, pay)
        if BattleField.mode == BattleMode.stage then
            if stageMode == STAGE_MODE.NOR then
                storydata:updateStoryData(resp)
            elseif stageMode == STAGE_MODE.ELITE then
                elitedata:updateData(resp)
            end
        end
    end
    -- runtimeCache.bVideo = false
    local resultLabel = tolua.cast(SailLoseViewOwner["resultLabel"], "CCSprite")
    local result = BattleField.round
    resultLabel:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("lose_%d.png", result)))
    local roundLabel = tolua.cast(SailLoseViewOwner["roundLabel"], "CCLabelTTF")
    roundLabel:setString(string.format(roundLabel:getString(), BattleField.round))
    local expLabel = tolua.cast(SailLoseViewOwner["expLabel"], "CCLabelTTF")
    if BattleField.mode == BattleMode.worldwar then
        local right = BattleField.round
        local left = 10 - right
        if userdata.level <= playerBattleData.level - 15 then
            right = 0
        end
        expLabel:setString(HLNSLocalizedString("ww.fight.result", right, left))
    else
        local playerExp = 0
        local silver = 0
        if gain.exp_player then
            playerExp = gain.exp_player
        end
        if gain.silver then
            silver = gain.silver
        end
        expLabel:setString(string.format(expLabel:getString(), playerExp, silver))
    end
    local resultLabel = tolua.cast(SailLoseViewOwner["resultLabel"], "CCSprite")
    local result = BattleField.round
    resultLabel:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("lose_%d.png", result)))

    local tipsLabel = tolua.cast(SailLoseViewOwner["tipsLabel"], "CCLabelTTF")
    tipsLabel:setString(HLNSLocalizedString("deadGuide.tips."..RandomManager.randomRange(1, 4)))
    local gotos = {}
    while(#gotos < 2) do
        local rand = RandomManager.prob(goto_weight)
        if not table.ContainsObject(gotos, rand) then
            table.insert(gotos, rand)
        end   
    end
    for i=1,2 do
        local gotoItem = tolua.cast(SailLoseViewOwner["gotoItem"..i], "CCMenuItem")
        gotoItem:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("btn_goto_%s_0.png", gotos[i])))
        gotoItem:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("btn_goto_%s_1.png", gotos[i])))
        gotoItem:setTag(tonumber(gotos[i]))

        local gotoLabel = tolua.cast(SailLoseViewOwner["gotoLabel"..i], "CCLabelTTF")
        gotoLabel:setString(HLNSLocalizedString(string.format("deadGuide.goto."..gotos[i])))
    end

    if BattleField.mode == BattleMode.chapter or BattleField.mode == BattleMode.arena then
        local viewItem = tolua.cast(SailLoseViewOwner["viewItem"], "CCMenuItem")
        local viewLabel = tolua.cast(SailLoseViewOwner["viewLabel"], "CCSprite")
        viewLabel:setVisible(true)
        viewItem:setVisible(true)
    end
end

local function _addResultLayer(resultType)
    local  proxy = CCBProxy:create()
    local node
    if resultType == ResultType.NewWorldWin then
        ccb["NewWorldWinViewOwner"] = NewWorldWinViewOwner
        node = CCBReaderLoad("ccbResources/NewWorldWinView.ccbi",proxy, true,"NewWorldWinViewOwner")
        _refreshNewWorldWinLayer()
    elseif resultType == ResultType.NewWorldLose then
        ccb["NewWorldLoseViewOwner"] = NewWorldLoseViewOwner
        node = CCBReaderLoad("ccbResources/NewWorldLoseView.ccbi",proxy, true,"NewWorldLoseViewOwner")
        _refreshNewWorldLoseLayer()
    elseif resultType == ResultType.SailWin then
        ccb["SailWinViewOwner"] = SailWinViewOwner
        node = CCBReaderLoad("ccbResources/SailWinView.ccbi",proxy, true,"SailWinViewOwner")
        _refreshSailWinLayer()
    elseif resultType == ResultType.SailLose then
        ccb["SailLoseViewOwner"] = SailLoseViewOwner
        node = CCBReaderLoad("ccbResources/SailLoseView.ccbi",proxy, true,"SailLoseViewOwner")
        _refreshSailLoseLayer()
    end
    _layer = tolua.cast(node,"CCLayer")
    _scene:addChild(_layer) 
end

local function _init()
    -- get layer
    _scene = CCScene:create()
end

function getFightingResultLayer()
	return _layer
end

function FightingResultSceneFun(resultType)
    _init()
    _resultType = resultType

    local function _onEnter()
        _addResultLayer(_resultType)
        if runtimeCache.bGuide then
            _layer:addChild(createGuideLayer(), 999)
        end
        local popup = createQuestPopupLayer()
        if popup then
            _scene:addChild(popup, 99999)
        end
        _popupGain()
    end

    local function _onExit()
        _layer = nil
        _scene = nil
        _resultType = nil
        ccb["NewWorldWinViewOwner"] = nil
        ccb["NewWorldLoseViewOwner"] = nil
        ccb["SailWinViewOwner"] = nil
        ccb["SailLoseViewOwner"] = nil
    end

    local function _cleanup()
    end

    --onEnter onExit
    local function _layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        elseif eventType == "cleanup" then
            if _cleanup then _cleanup() end
        end
    end

    _scene:registerScriptHandler(_layerEventHandler)

    return _scene
end