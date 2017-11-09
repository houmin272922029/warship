local _layer
local _scene
local t
-- 日常按钮状态：是否提醒
local _dailyBtnStatus = false
-- renzhan
-- 大冒险按钮状态：是否提醒
local _advantureBtnStatus = 0

local btm = {
    adventure = nil,
    daily = nil,
    logueTown = nil,
}

local currentTag = 0
local K_TAG_DAILYLIGHT = 9876

local bottomTag = {
    home = 1,
    team = 2,
    sail = 3,
    adventure = 4,
    daily = 5,
    logue = 6,
    fight = 7,
    unit = 8,
    others = 9,
    marineBranch = 10,
    worldwar = 11,
}

mainMenuEnabled = true

MainSceneOwner = MainSceneOwner or {}
ccb["MainSceneOwner"] = MainSceneOwner

local function _titleBgVisible(visible)
    local titleBg = MainSceneOwner["titleBg"] 
    titleBg:setVisible(visible)
    local titleMenu = MainSceneOwner["titleMenu"]
    titleMenu:setVisible(visible)
end

local function _clearContentLayer()
    local contentLayer = MainSceneOwner["contentLayer"] 
    contentLayer:removeAllChildrenWithCleanup(true)
end

local mainFunArray = {
    showSkillView = function(  )
        _clearContentLayer()
        currentTag = -1
        local contentLayer = MainSceneOwner["contentLayer"]
        contentLayer:addChild(createSkillLayer())
    end,
    showSystemSetting = function(  )
        _clearContentLayer()
        currentTag = -1
        local contentLayer = MainSceneOwner["contentLayer"]
        contentLayer:addChild(createSystemSettingLayer())
    end,
    closeLoginActivity = function ( )  
        if getLoginActivityLayer() then
            getLoginActivityLayer():closeView()
        end
        if getExchangeActivityLayer() then
            getExchangeActivityLayer():closeView()
        end
    end,
    refreshWWMainData = function()
        if not worldwardata:bOpen() then
            if worldwardata:openLevel() then
                ShowText(HLNSLocalizedString("ww.open.tips", worldwardata:openLevel()))
            else
                ShowText(HLNSLocalizedString("component.close"))
            end
            return
        end
        local function showWorldWar()
            _titleBgVisible(false)
            _clearContentLayer()
            currentTag = bottomTag.worldwar
            local contentLayer = MainSceneOwner["contentLayer"]
            if worldwardata.playerData then
                contentLayer:addChild(createWWMainLayer())
            else
                contentLayer:addChild(createWWChooseGroupLayer())
            end
        end
        local function getMainDataCallback(url, rtnData)
            worldwardata:fromDic(rtnData.info)
            showWorldWar()
        end
        doActionFun("WW_GET_MAINDATA", {}, getMainDataCallback)
    end,
    --linshaofeng
    refreshRankingListData = function()

        function _showRankingList( ) --排行榜 林绍峰
           
            if getMainLayer() then
                getMainLayer():addChild(createRankingListLayer(-140), 100)
            end
            currentTag = bottomTag.others
        end

        local function getPlayerLevelDataCallback(url, rtnData)
            rankingListData:WriteInAllData_fromDic(rtnData.info)
            _showRankingList()
        end
        doActionFun("RANKINGLIST_TOTALDATA", {}, getPlayerLevelDataCallback)
    end,

    showWorldWarIsland = function()
        _titleBgVisible(false)
        _clearContentLayer()
        currentTag = bottomTag.worldwar
        local contentLayer = MainSceneOwner["contentLayer"]
        contentLayer:addChild(createWWIslandLayer())
    end,
    showWorldWarExperiment = function()
        _titleBgVisible(false)
        _clearContentLayer()
        currentTag = bottomTag.worldwar
        local contentLayer = MainSceneOwner["contentLayer"]
        contentLayer:addChild(createWWExperimentLayer())
    end,
    showWorldWarRecord = function()
        _titleBgVisible(false)
        _clearContentLayer()
        currentTag = bottomTag.worldwar
        local contentLayer = MainSceneOwner["contentLayer"]
        contentLayer:addChild(createWWRecordLayer())
    end,
    showWorldWarGroup = function()
        _titleBgVisible(false)
        _clearContentLayer()
        currentTag = bottomTag.worldwar
        local contentLayer = MainSceneOwner["contentLayer"]
        contentLayer:addChild(createWWGroupLayer())
    end,
    showQuest = function()
        _titleBgVisible(true)
        _clearContentLayer()
        currentTag = -1
        local contentLayer = MainSceneOwner["contentLayer"]
        contentLayer:addChild(createQuestLayer())
    end,
    showEscortItem = function()
        --向服务器发送数据成功 函数回调
        local function callback(url, rtnData)
            _titleBgVisible(false)
            _clearContentLayer()
            currentTag = -1
            local contentLayer = MainSceneOwner["contentLayer"]
            if tonumber(rtnData.info.type) == 1 then
                contentLayer:addChild(createWWEscortItemLayer(rtnData.info , priority))
            else
                contentLayer:addChild(createWWEscortItemStateLayer(rtnData.info , priority))
            end 
        end
        doActionFun("GOING_ESCORT", {}, callback)
    end,
    showEscortItemState = function()
        --向服务器发送数据成功 函数回调
        _titleBgVisible(false)
        _clearContentLayer()
        currentTag = -1
        local contentLayer = MainSceneOwner["contentLayer"]
        local function callback(url, rtnData)
            contentLayer:addChild(createWWEscortItemStateLayer(rtnData.info , priority))
        end
        doActionFun("BEGIN_ESCORT", {}, callback)
    end,

    showRobItem = function()
        --向服务器发送数据成功 函数回调
        local function callback(url, rtnData)
            _titleBgVisible(false)
            _clearContentLayer()
            currentTag = -1
            local contentLayer = MainSceneOwner["contentLayer"]
            contentLayer:addChild(createWWRobItemLayer(rtnData.info , priority))
        end
        doActionFun("GOING_ROBBERY", {}, callback)
        
    end,
    showPointsRace = function()
        -- --向服务器发送数据成功 函数回调
        local function callback(url, rtnData)
            _titleBgVisible(false)
            ssaData.data = rtnData.info
            _clearContentLayer()
            local contentLayer = MainSceneOwner["contentLayer"]
            contentLayer:addChild(createSSAEnterPointsRaceViewLayer())
        end
        doActionFun("CROSSSERVERBATTLE_BEGIN", {}, callback)
    end,
    showPointsRaceRanking = function()
        _titleBgVisible(false)
        _clearContentLayer()
        local contentLayer = MainSceneOwner["contentLayer"]
        contentLayer:addChild(createSSAPointsRaceRankingViewLayer()) 
    end,
    showSSAFourKing = function()
        _titleBgVisible(false)
        _clearContentLayer()
        local contentLayer = MainSceneOwner["contentLayer"]
        local timeStatus = {"32to16Begin","16to8Begin","8to4Begin","4to2Begin","2to1Begin"}
        local betEnd = {"32to16BetEnd","16to8BetEnd","8to4BetEnd","4to2BetEnd","2to1BetEnd"}
        local currentIndex
        for i=1,getMyTableCount(timeStatus) do
            if timeStatus[i] == ssaData.data.timeStatus then
                print("main里面四皇中的数据可以显示,加载当前状态")
                currentIndex = i
                print(currentIndex)
            end
        end
        for i=1,getMyTableCount(betEnd) do
            if betEnd[i] == ssaData.data.timeStatus then
                currentIndex = i
                print(currentIndex)
            end
        end
        if ssaData.data.timeStatus == "worshipBegin" then
            print("进来了吗")
            currentIndex = 5
        end
        contentLayer:addChild(createSSAFourKingContendViewLayer(currentIndex)) 
    end,
    showSSABattleLogs = function()
        --向服务器发送数据成功 函数回调
        local function callback(url, rtnData)
            _titleBgVisible(true)
            ssaData.data = rtnData.info
            _clearContentLayer()
            local contentLayer = MainSceneOwner["contentLayer"]
            contentLayer:addChild(createSSABattlelogsViewOwnerLayer())
        end
        doActionFun("CROSSSERVERBATTLE_LOOKBATTLELOG", {}, callback)
    end,
     showSSAWorship = function()
        --向服务器发送数据成功 函数回调
        _titleBgVisible(false)
        _clearContentLayer()
        local contentLayer = MainSceneOwner["contentLayer"]
        contentLayer:addChild(createStrideServerArenaWorshipViewLayer()) 
    end,
}
local _updateState = {
    daily = function (  )
        local light = btm.daily:getChildByTag(K_TAG_DAILYLIGHT)
        if light then
            light:stopAllActions()
            light:removeFromParentAndCleanup(true)
        end
        if _dailyBtnStatus then
            local light = CCSprite:createWithSpriteFrameName("lightingEffect_daily_1.png")
            local animFrames = CCArray:create()
            for j = 1, 3 do
                local frameName = string.format("lightingEffect_daily_%d.png",j)
                local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(frameName)
                animFrames:addObject(frame)
            end
            local animation = CCAnimation:createWithSpriteFrames(animFrames, 0.2)
            local animate = CCAnimate:create(animation)
            light:runAction(CCRepeatForever:create(animate))
            btm.daily:addChild(light,1,K_TAG_DAILYLIGHT)
            light:setPosition(ccp(btm.daily:getContentSize().width / 2,btm.daily:getContentSize().height / 2 + 2))
        end
    end,

    advanture = function (  )
        local light = btm.adventure:getChildByTag(9888)
        if light then
            light:stopAllActions()
            light:removeFromParentAndCleanup(true)
        end
        if (_advantureBtnStatus == 1 and not bossdata.hasCheckedFirst) or (_advantureBtnStatus == 2 and not bossdata.hasCheckedSecond) then
            local light = CCSprite:createWithSpriteFrameName("lightingEffect_adventure_1.png")
            local animFrames = CCArray:create()
            for j = 1, 3 do
                local frameName = string.format("lightingEffect_adventure_%d.png",j)
                local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(frameName)
                animFrames:addObject(frame)
            end
            local animation = CCAnimation:createWithSpriteFrames(animFrames, 0.2)
            local animate = CCAnimate:create(animation)
            light:runAction(CCRepeatForever:create(animate))
            btm.adventure:addChild(light,1,9888)
            light:setPosition(ccp(btm.adventure:getContentSize().width / 2,btm.adventure:getContentSize().height / 2 + 2))
        end
    end,

    recruit = function (  )
        local light = btm.logueTown:getChildByTag(9888)
        if light then
            light:stopAllActions()
            light:removeFromParentAndCleanup(true)
        end
        local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
        cache:addSpriteFramesWithFile("ccbResources/publicRes_4.plist")
        if recruitData:isHaveCanFreeRecruitItem() or vipdata:bHaveAward() then
            local light = CCSprite:createWithSpriteFrameName("lightingEffect_shop_1.png")
            local animFrames = CCArray:create()
            for j = 1, 3 do
                local frameName = string.format("lightingEffect_shop_%d.png",j)
                local frame = cache:spriteFrameByName(frameName)
                animFrames:addObject(frame)
            end
            local animation = CCAnimation:createWithSpriteFrames(animFrames, 0.2)
            local animate = CCAnimate:create(animation)
            light:runAction(CCRepeatForever:create(animate))
            btm.logueTown:addChild(light,1,9888)
            light:setPosition(ccp(btm.logueTown:getContentSize().width / 2,btm.logueTown:getContentSize().height / 2 + 2))
        end
    end,
}

function _updateRecruitBtmState(  )
    if not t:cellAtIndex(4) then
        return
    end
    _updateState:recruit()
end


local function _showHelpLayer(  )
    _clearContentLayer()
    currentTag = -1
    local contentLayer = MainSceneOwner["contentLayer"]
    contentLayer:addChild(createHelpLayer())
end

local function _showFeedbackLayer(  )
    _clearContentLayer()
    currentTag = -1
    local contentLayer = MainSceneOwner["contentLayer"]
    contentLayer:addChild(createFeedbackLayer())
end

local function _showCusserviceLayer(  )
    _clearContentLayer()
    currentTag = -1
    local contentLayer = MainSceneOwner["contentLayer"]
    contentLayer:addChild(createCusserviceLayer())
end

local function _showRegisterLayer(  )
    _clearContentLayer()
    currentTag = -1
    local contentLayer = MainSceneOwner["contentLayer"]
    contentLayer:addChild(createRegisterLayer( -140 ))
end

local function _showEquipmentsView(  )
    _clearContentLayer()
    currentTag = -1
    local contentLayer = MainSceneOwner["contentLayer"]
    contentLayer:addChild(createEquipmentsLayer())
end

local function _showSkillChangeSelectView( huid,pos,suid ) 
    _clearContentLayer()
    currentTag = -1
    local contentLayer = MainSceneOwner["contentLayer"]
    contentLayer:addChild(createSkillChangeSelectLayer(huid,pos,suid))
end

local function _showEquipChangeSelcetView( huid,pos,euid )
    _clearContentLayer()
    currentTag = -1
    local contentLayer = MainSceneOwner["contentLayer"]
    contentLayer:addChild(createEquipChangeSelectLayer(huid,pos,euid))
end

local function _showEquipRefineView( uniqueId )
    _clearContentLayer()
    currentTag = -1
    local contentLayer = MainSceneOwner["contentLayer"]
    contentLayer:addChild(createEquipRefineLayer(uniqueId))
end

local function _showBattleShipUpdateView( uniqueId )
    _clearContentLayer()
    currentTag = -1
    local contentLayer = MainSceneOwner["contentLayer"]
    contentLayer:addChild(createBattleShipUpdateLayer(uniqueId))
end
-- 前往练影升级
function _showShadowUpdateView( uniqueId )
    Global:instance():TDGAonEventAndEventData("compound_shadow")
    _clearContentLayer()
    currentTag = -1
    local contentLayer = MainSceneOwner["contentLayer"]
    contentLayer:addChild(createShadowUpdateLayer(uniqueId))
end

-- 前往罗格镇
local function _showLogueTown(  )
    if currentTag == bottomTag.logue then
        return
    end
    _clearContentLayer()
    _titleBgVisible(true)
    local contentLayer = MainSceneOwner["contentLayer"]
    contentLayer:addChild(createLogueTownLayer())
    currentTag = bottomTag.logue

end

function _showTrainShadowView( page )
    _clearContentLayer()
    _titleBgVisible(true)
    local contentLayer = MainSceneOwner["contentLayer"]
    contentLayer:addChild(createTrainShadowView(page))
    currentTag = bottomTag.others
end

local function _showEquipUpdateLayer( dic )
    _clearContentLayer()
    currentTag = -1
    local contentLayer = MainSceneOwner["contentLayer"]
    contentLayer:addChild(createEquipUpdateLayer(dic))
end

local function _showHeroes(page)
    _clearContentLayer()
    currentTag = -1
    local contentLayer = MainSceneOwner["contentLayer"]
    contentLayer:addChild(createHeroesLayer(page))
end 

local function _showCulture(heroUId)
    _clearContentLayer()
    currentTag = -1
    local contentLayer = MainSceneOwner["contentLayer"]
    contentLayer:addChild(createCultureLayer(heroUId))
end 

local function _showBreak( heroId )
    _clearContentLayer()
    currentTag = -1
    local contentLayer = MainSceneOwner["contentLayer"]
    contentLayer:addChild(createBreakLayer(heroId))
end 

local function _showEquiSell(type)
    _clearContentLayer()
    currentTag = -1
    local contentLayer = MainSceneOwner["contentLayer"]
    contentLayer:addChild(createEquipSellLayer(type))
end

local function _showSkillBreakSelectView(type,dic)
    _clearContentLayer()
    currentTag = -1
    local contentLayer = MainSceneOwner["contentLayer"]
    contentLayer:addChild(createSkillBreakSelectLayer(type,dic))
end  

local function _showFarewell(desHeroUId, srcHeroUId, uiType, srcUI)
    _clearContentLayer()
    currentTag = -1
    local contentLayer = MainSceneOwner["contentLayer"]
    contentLayer:addChild(createFarewellLayer(desHeroUId, srcHeroUId, uiType, srcUI))
end 

local function _showBreakSkillView(dic)
    _clearContentLayer()
    currentTag = -1
    local contentLayer = MainSceneOwner["contentLayer"]
    contentLayer:addChild(createBreakSkillViewLayer(dic))
end 

local function _showBreakSkillResultView(dic,gotoType)
    _clearContentLayer()
    currentTag = -1
    local contentLayer = MainSceneOwner["contentLayer"]
    contentLayer:addChild(createSkillBreakResultLayer(dic,gotoType))
end 

local function _showHome()--首页
    if currentTag == bottomTag.home then
        return
    end
    _clearContentLayer()
    if runtimeCache.breakSkillType then
        if runtimeCache.breakSkillType == 1 then
            runtimeCache.breakSkillType = 0
        end
    else
        runtimeCache.breakSkillType = 0
    end
    local contentLayer = MainSceneOwner["contentLayer"]
    contentLayer:addChild(createHomeLayer())
    currentTag = bottomTag.home
    _titleBgVisible(true)
end

local function _showSail(stageId, mode)--起航
    if currentTag == bottomTag.sail then
        return
    end 
    _clearContentLayer()
    local contentLayer = MainSceneOwner["contentLayer"]
    contentLayer:addChild(createSailLayer(stageId, mode))
    currentTag = bottomTag.sail
    _titleBgVisible(true)
end

local function _showWareHouseLayer( uiType )--仓库
    Global:instance():TDGAonEventAndEventData("warehouse0")
    _clearContentLayer()
    local contentLayer = MainSceneOwner["contentLayer"]
    contentLayer:addChild(createWareHouseLayer())
    if uiType then
        getWareHouseLayer():gotoPageByType(uiType)
    end
    currentTag = bottomTag.others
end

local function _showChatLayer( uiType,bchat )--聊天
    _clearContentLayer()
    local contentLayer = MainSceneOwner["contentLayer"]
    contentLayer:addChild(createChatLayer(bchat)) 
    getChatLayer():gotoChatByType( uitype )
    currentTag = bottomTag.others
end

local function _showHandBookView(  )--图鉴
    Global:instance():TDGAonEventAndEventData("illustrated1")
    _clearContentLayer()
    local contentLayer = MainSceneOwner["contentLayer"]
    contentLayer:addChild(createHandBookViewLayer()) 
    currentTag = bottomTag.others
end

local function _showFriendViewLayer(  )--伙伴
    _clearContentLayer()
    local contentLayer = MainSceneOwner["contentLayer"]
    contentLayer:addChild(createFriendViewLayer()) 
    currentTag = bottomTag.others
end

local function _showNewsViewLayer(  )--新闻
    Global:instance():TDGAonEventAndEventData("news")
    _clearContentLayer()
    local contentLayer = MainSceneOwner["contentLayer"]
    contentLayer:addChild(createNewsViewLayer()) 
    currentTag = bottomTag.others
end

local function _showChangeShadowLayer( heroId, pos, property )--更换影子
    _clearContentLayer()
    currentTag = -1
    local contentLayer = MainSceneOwner["contentLayer"]
    contentLayer:addChild(createChangeShadowLayer(heroId, pos, property)) 
end

local function _showBattleShipLayer()--战舰
    _clearContentLayer()
    currentTag = -1
    local contentLayer = MainSceneOwner["contentLayer"]
    contentLayer:addChild(createBattleShipLayer()) 
end 

local function _showAddFriendLayer()
    _clearContentLayer()
    currentTag = -1
    local contentLayer = MainSceneOwner["contentLayer"]
    contentLayer:addChild(createAddFriendLayer()) 
end 

local function _showTeam()
    -- RandomManager.cursor = 660
    -- local left = battledata:readJsonPlayer("/Users/sUmmy/Downloads/server101.1763.txt")
    -- local right = battledata:readJsonPlayer("/Users/sUmmy/Downloads/server97.5663.txt")
    -- BattleField:fight(left, right)

    -- if 普通关卡 then
    --     if storydata:checkRecord(stageId) then
    --         _showSail(stageId, stageMode.NOR)
    --     end
    -- elseif 精英关卡 then
    --     if elitedata:checkRecord(stageId) then
    --         _showSail(stageId, stageMode.ELITE)
    --     end
    -- end

    if currentTag == bottomTag.team then
        return
    end 
    _clearContentLayer() 
    _titleBgVisible(false)
    local contentLayer = MainSceneOwner["contentLayer"]
    if runtimeCache.bGuide then
        runtimeCache.teamPage = 1
    end
    Global:instance():TDGAonEventAndEventData("array")
    contentLayer:addChild(createTeamLayer())
    currentTag = bottomTag.team
end

local function _showTreasureMap()
    _clearContentLayer() 
    _titleBgVisible(false)
    currentTag = -1
    local contentLayer = MainSceneOwner["contentLayer"]
    contentLayer:addChild(createTreasureMapLayer())
end

local function _showOnForm()
    _clearContentLayer()
    currentTag = -1
    local contentLayer = MainSceneOwner["contentLayer"]
    contentLayer:addChild(createOnFormLayer()) 
end
-- 不要提
local function _showSelHeroFarewellLayer(heroUId)
    _clearContentLayer()
    currentTag = -1
    local contentLayer = MainSceneOwner["contentLayer"]
    contentLayer:addChild(createSelHeroFarewellLayer(heroUId)) 
end

local function _showAdventure(init)
    if currentTag == bottomTag.adventure then
        return
    end 
    if init == nil or init then
        runtimeCache.SSAState = ssaDataFlag.home
    end
    _clearContentLayer() 
    _titleBgVisible(false)
    local contentLayer = MainSceneOwner["contentLayer"]
    contentLayer:addChild(createAdventureLayer())
    currentTag = bottomTag.adventure
end

function showAdventureFromAwake(  )
    _clearContentLayer() 
    _titleBgVisible(false)
    local contentLayer = MainSceneOwner["contentLayer"]
    contentLayer:addChild(createAdventureLayer())
    currentTag = bottomTag.adventure
end

function showAdventureFromMarine(  )
    _clearContentLayer() 
    _titleBgVisible(false)
    local contentLayer = MainSceneOwner["contentLayer"]
    contentLayer:addChild(createAdventureLayer())
    currentTag = bottomTag.adventure
end

function showVeiledSea()
    if runtimeCache.veiledSeaState == veiledSeaDataFlag.home then
        _layer:gotoAdventure()
    else
        _clearContentLayer()
        _titleBgVisible(false)
        local contentLayer = MainSceneOwner["contentLayer"]
        contentLayer:addChild(createVeiledSeaLayer())
        currentTag = -1
    end
end

--跨服决斗main
function showSSAMain()
    if runtimeCache.SSAState == ssaDataFlag.home then
        _layer:gotoAdventure()
    else
        _clearContentLayer()
        _titleBgVisible(false)
        local contentLayer = MainSceneOwner["contentLayer"]
        contentLayer:addChild(createStrideServerArenaLayer())
        currentTag = -1
    end
end

--跨服决斗32强
function showSSAThirtyTwoRanking()
    if runtimeCache.SSAState == ssaDataFlag.ThirtyTwoRanking then
        _layer:gotoAdventure()
    else
        _clearContentLayer()
        _titleBgVisible(false)
        local contentLayer = MainSceneOwner["contentLayer"]
        contentLayer:addChild(createStrideServerArenaThirtyTwoRankingLayer())
        currentTag = -1
    end
end


function _showMarineBranch()
    -- if currentTag == bottomTag.marineBranch then
    --     return
    -- end 
    _clearContentLayer() 
    _titleBgVisible(false)
    local contentLayer = MainSceneOwner["contentLayer"]
    contentLayer:addChild(createMarineBranchLayer())
    currentTag = bottomTag.adventure
end



-- 联盟
local function _showUnion()
    if ConfigureStorage.levelOpen and ConfigureStorage.levelOpen.league 
        and ConfigureStorage.levelOpen.league.level > userdata.level then
        ShowText(HLNSLocalizedString("union.openLevelDesp", ConfigureStorage.levelOpen.league.level))
        return
    end

    if currentTag == bottomTag.unit then
        return
    end 
    _clearContentLayer() 
    local contentLayer = MainSceneOwner["contentLayer"]
    contentLayer:addChild(createUnionMainLayer())
    currentTag = bottomTag.unit
end

local function _showAnPopUp(  )
    _layer:addChild(createAnnounceLayer( -140 ),100)
end

local function _showChapterRob(dic, bookId, chapterId)
    _clearContentLayer()
    currentTag = -1
    local contentLayer = MainSceneOwner["contentLayer"]
    contentLayer:addChild(createChapterRobLayer(dic, bookId, chapterId))
end



local function _showDaily()
    if currentTag == bottomTag.daily then
        return
    end 
    _clearContentLayer() 
    _titleBgVisible(false)
    local contentLayer = MainSceneOwner["contentLayer"]
    contentLayer:addChild(createDailyLayer())
    currentTag = bottomTag.daily
end



local function _showArena()
    if ConfigureStorage.levelOpen and ConfigureStorage.levelOpen.arena 
        and ConfigureStorage.levelOpen.arena.level > userdata.level then
        ShowText(HLNSLocalizedString("component.close.duel"))
        return
    end

    if currentTag == bottomTag.fight then
        return
    end 
    _titleBgVisible(true)
    _clearContentLayer()
    local contentLayer = MainSceneOwner["contentLayer"]
    contentLayer:addChild(createArenaLayer())
    currentTag = bottomTag.fight  
end

local function bottomBtnPress(tag)
   
    if getTeamPopupLayer() then
        return
    end

    if runtimeCache.breakSkillType then
        if runtimeCache.breakSkillType == 1 then
            runtimeCache.breakSkillType = 0
        end
    else
        runtimeCache.breakSkillType = 0
    end
    if not mainMenuEnabled then
        return
    end

    if tag == 0 then
        _showTeam()
    elseif tag == 1 then
        Global:instance():TDGAonEventAndEventData("sail1")
        _showSail()
    elseif tag == 2 then
        Global:instance():TDGAonEventAndEventData("adventure1")
        _showAdventure()
    elseif tag == 3 then
        Global:instance():TDGAonEventAndEventData("everyday")
        _showDaily()
    elseif tag == 4 then
         Global:instance():TDGAonEventAndEventData("town2")
        _showLogueTown()
    elseif tag == 5 then
        Global:instance():TDGAonEventAndEventData("duel1")
        _showArena()
    elseif tag == 6 then
        -- ShowText(HLNSLocalizedString("component.close"))
        Global:instance():TDGAonEventAndEventData("union1")
        _showUnion()
    elseif tag == 7 then
        if currentTag == bottomTag.worldwar then
            return
        end
        _layer:gotoWorldWar()
    end
end

local function _updateDailyState()
    _dailyBtnStatus = dailyData:getDailyStatus()

    if not t:cellAtIndex(3) then
        return
    end

    _updateState.daily()
end

local function _updateAdventureState()
    _advantureBtnStatus = bossdata:bBossFight()
    if not t:cellAtIndex(2) then
        return
    end

    _updateState:advanture()
end

local function addBottomBtn()
    local homeBtn = tolua.cast(MainSceneOwner["homeBtn"], "CCMenuItemImage")
    -- if isPlatform(IOS_APPLE_ZH) then
    --     local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
    --     cache:addSpriteFramesWithFile("ccbResources/appstore_replace.plist")
    --     homeBtn:setNormalSpriteFrame(cache:spriteFrameByName("btn_btm0_0_appstore.png"))
    --     homeBtn:setSelectedSpriteFrame(cache:spriteFrameByName("btn_btm0_1_appstore.png"))
    -- end
    -- @param fn string Callback type
    -- @param table LuaTableView
    -- @param a1 & a2 mixed Difference means for every "fn"
    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(homeBtn:getContentSize().width * retina, homeBtn:getContentSize().height * retina)
        elseif fn == "cellAtIndex" then
            -- Return CCTableViewCell, a1 is cell index (zero based), a2 is dequeued cell (maybe nil)
            -- Do something to create cell and change the content
            
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end

            local norSp
            local selSp
            --注意
            --在这里把罗格镇和大冒险的位置互换了，第三个变成了罗格镇，第五个是大冒险
            --对应的按钮事件也进行了相应调整

            -- local norSp = CCSprite:createWithSpriteFrameName(string.format("btn_btm%d_0.png", a1 + 1))
            -- local selSp = CCSprite:createWithSpriteFrameName(string.format("btn_btm%d_1.png", a1 + 1))
                
            local item = CCMenuItemImage:create()
            item:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("btn_btm%d_0.png", a1 + 1)))
            item:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("btn_btm%d_1.png", a1 + 1)))
            
            -- if a1 == 2 then 
            --     item:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("btn_btm%d_0.png", a1 + 3)))
            --     item:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("btn_btm%d_1.png", a1 + 3)))
            -- elseif a1 == 4 then 
            --     item:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("btn_btm%d_0.png", a1 - 1)))
            --     item:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("btn_btm%d_1.png", a1 - 1)))
            -- end
            item:setAnchorPoint(ccp(0,0))
            item:setPosition(ccp(0,0))
            item:registerScriptTapHandler(bottomBtnPress)
            if a1 == 3 then
                btm.daily = item
                _updateState:daily()
            end

            -- renzhan
            if a1 == 2 then
                btm.adventure = item
                _updateState:advanture()
            end
            -- 
            -- add by caiyaguang
            if a1 == 4 then
                btm.logueTown = item
                _updateState:recruit()
            end

            menu = CCMenu:create()
            menu:addChild(item, 1, a1)
            menu:setPosition(ccp(0, 0))
            menu:setAnchorPoint(ccp(0, 0))
            menu:setScale(retina)
            a2:addChild(menu, 1, 1)
            local function setCellMenuPriority(sender)
                if sender then
                    local menu = tolua.cast(sender, "CCMenu")
                    menu:setHandlerPriority(-131)
                end
            end
            local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCCallFuncN:create(setCellMenuPriority))
            menu:runAction(seq)
            r = a2
        elseif fn == "numberOfCells" then
            -- Return number of cells
            r = 8
        -- Cell events:
        elseif fn == "cellTouched" then         -- A cell was touched, a1 is cell that be touched. This is not necessary.
        elseif fn == "cellTouchBegan" then      -- A cell is touching, a1 is cell, a2 is CCTouch
        elseif fn == "cellTouchEnded" then      -- A cell was touched, a1 is cell, a2 is CCTouch
        elseif fn == "cellHighlight" then       -- A cell is highlighting, coco2d-x 2.1.3 or above
        elseif fn == "cellUnhighlight" then     -- A cell had been unhighlighted, coco2d-x 2.1.3 or above
        elseif fn == "cellWillRecycle" then     -- A cell will be recycled, coco2d-x 2.1.3 or above
        end
        return r
    end)
    
    local size = CCSizeMake(winSize.width - homeBtn:getContentSize().width * retina, homeBtn:getContentSize().height * retina)
    t = LuaTableView:createWithHandler(h, size)
    t:setBounceable(true)
    t:setAnchorPoint(ccp(0,0))
    t:setPosition(ccp(homeBtn:getContentSize().width * retina, 0))
    t:setVerticalFillOrder(0)
    t:setDirection(0)
    _layer:addChild(t)
    t:setTouchPriority(-132)         
end

local function _init()
    -- get layer
    ccb["MainSceneOwner"] = MainSceneOwner
    _scene = CCScene:create()
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/MainView.ccbi",proxy, true,"MainSceneOwner")
    _layer = tolua.cast(node,"CCLayer")

    local titleMenu = MainSceneOwner["titleMenu"]
    titleMenu:setOpacity(0)
    -- contentLayer:addChild(createMenuLayer())

    _scene:addChild(_layer)

    _dailyBtnStatus = dailyData:getDailyStatus()
    -- renzhan
    _advantureBtnStatus = bossdata:bBossFight()
    addBottomBtn()
    t:reloadData() 

    _showHome()
end

local function titleMenuClick()
    print("titleClick")
    _layer:getParent():addChild(createCaptainInfoLayer(), 200)
end
MainSceneOwner["titleMenuClick"] = titleMenuClick


local function titleVipMenuClick()
    if userdata:getVipAuditState() then
        return true
    end
    print("titleClick11")
    Global:instance():TDGAonEventAndEventData("recharge9")
    if getMainLayer() then
        getMainLayer():getParent():addChild(createVipDetailLayer(-140 - 2), 100) 
        -- _layer:removeFromParentAndCleanup(true)
    end
    return true
end
MainSceneOwner["titleVipMenuClick"] = titleVipMenuClick

local function onHomeClick()
    if getTeamPopupLayer() then
        return
    end
    if not mainMenuEnabled then
        return
    end 
    _showHome()
end
MainSceneOwner["onHomeClick"] = onHomeClick


-- 更新船长等级
local function _updateLevel()
    local lvLabel = tolua.cast(MainSceneOwner["lvLabel"], "CCLabelTTF")
    lvLabel:setString(userdata.level)
end

-- 更新金币数据显示
local function _updateGold()
    local goldLabel = tolua.cast(MainSceneOwner["goldLabel"], "CCLabelTTF")
    local gold = userdata:getFunctionOfNumberAcronym(tonumber(userdata.gold))
    goldLabel:setString(gold)
end 

-- 更新贝里数据显示
local function _updateBerry()
    local berryLabel = tolua.cast(MainSceneOwner["berryLabel"], "CCLabelTTF")
    local berry = userdata:getFunctionOfNumberAcronym(tonumber(userdata.berry))
    berryLabel:setString(berry)
end 
--更新体力
local function _updateStrength()
    local strengthLabel = tolua.cast(MainSceneOwner["strengthLabel"], "CCLabelTTF")
    strengthLabel:setString(string.format("%d/%d", userdata.strength, userdata:getStrengthMax()))

    local strengthProgressBg = tolua.cast(MainSceneOwner["strengthProgressBg"], "CCSprite")
    local progress = tolua.cast(strengthProgressBg:getParent():getChildByTag(101), "CCProgressTimer")
    progress:setPercentage(math.min(userdata.strength / userdata:getStrengthMax() * 100, 100))
end

local function _updateEnergy()
    local energyLabel = tolua.cast(MainSceneOwner["energyLabel"], "CCLabelTTF")
    energyLabel:setString(string.format("%d/%d", userdata.energy, userdata:getEnergyMax()))

    local energyProgressBg = tolua.cast(MainSceneOwner["energyProgressBg"], "CCSprite")
    local progress = tolua.cast(energyProgressBg:getParent():getChildByTag(102), "CCProgressTimer")
    progress:setPercentage(math.min(userdata.energy / userdata:getEnergyMax() * 100, 100))
end

local function _updateExp()
    local expLabel = tolua.cast(MainSceneOwner["expLabel"], "CCLabelTTF")
    expLabel:setString(tostring(userdata.exp))

    local expProgressBg = tolua.cast(MainSceneOwner["expProgressBg"], "CCSprite")
    local progress = tolua.cast(expProgressBg:getParent():getChildByTag(100), "CCProgressTimer")
    progress:setPercentage(userdata.exp / ConfigureStorage.levelExp[tostring(userdata.level)].value1 * 100)
end

-- 更新动画高亮效果 vip等级礼包领取状态 
-- lightingEffect_recruitBtn_1.png
local function _updateVipLevelReward()
    local centerVipFlag = tolua.cast(MainSceneOwner["centerVipFlag"], "CCSprite")
    local light = tolua.cast(centerVipFlag:getChildByTag(9888), "CCSprite")
    if vipdata:getVipLevel() >= 1 and ((vipdata:bHaveAward() and not light) or ((not vipdata.vipDailyItems or getMyTableCount(vipdata.vipDailyItems) <= 0)and not light)) then
        -- 需要加光环
        local light = CCSprite:createWithSpriteFrameName("flagBg_frame_1.png")
        local animFrames = CCArray:create()
        for j = 1, 4 do
            local frameName = string.format("flagBg_frame_%d.png",j)
            local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(frameName)
            animFrames:addObject(frame)
        end
        local animation = CCAnimation:createWithSpriteFrames(animFrames, 0.3)
        local animate = CCAnimate:create(animation)
        light:runAction(CCRepeatForever:create(animate))
        light:setPosition(ccp(centerVipFlag:getContentSize().width / 2, centerVipFlag:getContentSize().height / 2 + 2))
        centerVipFlag:addChild(light, 1, 9888)
    elseif not vipdata:bHaveAward() and light and (vipdata.vipDailyItems or getMyTableCount(vipdata.vipDailyItems) > 0) then
        -- 需要去掉光环
        light:stopAllActions()
        light:removeFromParentAndCleanup(true)
    end
end

local function _updateVip()
    -- vip*********
    local vipLabel = tolua.cast(MainSceneOwner["vipLabel"], "CCLabelTTF")
    vipLabel:setString(string.format("VIP %d", userdata:getVipLevel()))
    local centerVipFlag = tolua.cast(MainSceneOwner["centerVipFlag"], "CCSprite")
    centerVipFlag:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("flagBg%d.png", userdata:getVipLevel())))
    vipLabel:setVisible(not userdata:getVipAuditState())
    centerVipFlag:setVisible(not userdata:getVipAuditState())
    _updateVipLevelReward()
end

local function _getTopRollInfo()
    local function getTopRollCallBack( url,rtnData )
        print("getTopRollCallBack")
        topRollData:setAllData(rtnData.info.result)
    end 
    doActionNoLoadingFun("GET_PUBLIC_SHARELIST",{},getTopRollCallBack)
end 

function getMainLayer()
	return _layer
end

function  getButtonsView()
    return t
end

local function setMenuPriority()
    local menu = tolua.cast(MainSceneOwner["menu"], "CCMenu")
    menu:setHandlerPriority(-132)
end

local function _addTouchFBLayer()
    -- 添加点击反馈层
    local scene = CCDirector:sharedDirector():getRunningScene()
    if scene then
        scene:addChild(createTouchFeedbackLayer(), 9998, 9998)
    end 
end

function mainSceneFun()
    _init()

    --首页上方title的 vip头像框高亮效果
    function _layer:updateVipLevelReward()
        _updateVipLevelReward()
    end

    function _layer:updateRecruitBtmState()
        _updateRecruitBtmState()
    end

    -- 主页面
    function _layer:goToHome()
        mainFunArray.closeLoginActivity()
        _showHome()
    end

    -- 伙伴
    function _layer:goToHeroes(page)
        mainFunArray.closeLoginActivity()
        _showHeroes(page)
    end
    -- 送别
    function _layer:goToFarewell(desHeroUId, srcHeroUId, uiType, srcUI)         -- srcUI:来源UI (0:伙伴列表  1:阵容中的英雄弹框)
        if srcUI == nil then
            srcUI = 0
        end 
        _showFarewell(desHeroUId, srcHeroUId, uiType, srcUI)
    end
    -- 培养
    function _layer:goToCulture(heroId)
        mainFunArray.closeLoginActivity()
        _showCulture(heroId)
    end
    -- 突破
    function _layer:goToBreak( heroId )
        mainFunArray.closeLoginActivity()
        _showBreak(heroId)
    end

    -- 商城
    function _layer:goToLogue()
        mainFunArray.closeLoginActivity()
        _showLogueTown()
    end

    -- 远航
    function _layer:goToSail(stageId, stageMode)
        mainFunArray.closeLoginActivity()
        _showSail(stageId, stageMode)
    end

    -- 排行榜
    function _layer:goToRankingList()
        mainFunArray.closeLoginActivity()
        mainFunArray.refreshRankingListData()
    end


    --仓库
    function _layer:gotoWareHouseLayer(uiType)
        mainFunArray.closeLoginActivity()
        _showWareHouseLayer(uiType)
    end
    --[[聊天
        两个参数  ChatType.allServerChat : 全服聊天   ChatType.uniteChat ：联盟聊天
        bUnit 是否是联盟跳转聊天
    ]]
    function _layer:gotoChatLayer(uiType, bUnit)
        mainFunArray.closeLoginActivity()
        uitype = (uiType ~= nil) and uiType or ChatType.allServerChat
        _showChatLayer(uiType, bUnit)
    end
    --设置
    function _layer:gotoSystemSettingLayer(  )
        Global:instance():TDGAonEventAndEventData("setting1")
        mainFunArray.showSystemSetting()
        -- _showSystemSetting()
    end

    function _layer:gotoHandBookLayer(  )
        _showHandBookView()
    end

    --羁绊
    function _layer:gotoFriendViewLayer(  )
        _showFriendViewLayer()
    end

    --新闻
    function _layer:gotoNewsLayer(  )
        _showNewsViewLayer()
    end

    --更换影子
    function _layer:gotoChangeShadowLayer( heroId, pos, property )
        mainFunArray.closeLoginActivity()
        _showChangeShadowLayer(heroId, pos, property)
    end

    --装备
    function _layer:gotoEquipmentsLayer( )
        mainFunArray.closeLoginActivity()
        _showEquipmentsView()
    end

    function _layer:gotoHelpLayer(  )
        _showHelpLayer()
    end

    -- 反馈
    function _layer:gotoFeedbackLayer(  )
        _showFeedbackLayer()
    end

    -- function _layer:gotoCdkeyLayer(  )
    --     _showCdkeyLayer()
    -- end

    function _layer:gotoCusserviceLayer(  )
        _showCusserviceLayer()
    end

    function _layer:gotoRegisterLayer( )
        _showRegisterLayer()
    end
    -- 装备选择
    function _layer:getoEquipChangeSelectView( huid,pos,euid )
        mainFunArray.closeLoginActivity()
        _showEquipChangeSelcetView(huid,pos,euid)
    end

    --奥义
    function _layer:gotoSkillViewLayer(  )
        mainFunArray.closeLoginActivity()
        mainFunArray.showSkillView()
        -- _showSkillView()
    end

    --战舰
    function _layer:gotoBattleShipLayer()
        mainFunArray.closeLoginActivity()
        _showBattleShipLayer()
    end

    -- 加好友
    function _layer:gotoAddFriendLayer()
        _showAddFriendLayer()
    end

    -- 阵容
    function _layer:gotoTeam()
        mainFunArray.closeLoginActivity()
        _showTeam()
    end
    -- 公告弹框
    function _layer:popUpAnLayer(  )
        _showAnPopUp()
    end

    function _layer:gotoOnForm()
        _showOnForm()
    end

    function _layer:gotoBreakSkillView( dic )
        _showBreakSkillView(dic)
    end

    function _layer:gotoBreakSkillResultView( dic,gotoType )
        _showBreakSkillResultView(dic,gotoType)
    end

    function _layer:getoSkillChangeSelectView( huid,pos,suid )
        _showSkillChangeSelectView(huid,pos,suid)
    end

    -- 前往练影 炼影
    function _layer:gotoTrainShadowView( page )
        mainFunArray.closeLoginActivity()
        _showTrainShadowView(page)
    end

    -- 选择送别伙伴
    function _layer:gotoSelHeroFarewell(heroUId)
        _showSelHeroFarewellLayer(heroUId)
    end

    function _layer:TitleBgVisible(visible)
        _titleBgVisible(visible)
    end

    --装备

    function _layer:getoEquipRefineLayer( uniqueId )
        mainFunArray.closeLoginActivity()
        _showEquipRefineView(uniqueId)
    end

    function _layer:gotoBattleShipUpdateLayer( uniqueId )
        mainFunArray.closeLoginActivity()
        _showBattleShipUpdateView(uniqueId)
    end
    
    -- 练影升级
    function _layer:gotoShadowUpdateLayer( uniqueId )
        mainFunArray.closeLoginActivity()
        _showShadowUpdateView(uniqueId)
    end

    function _layer:gotoEquipSellLayer( type )
        mainFunArray.closeLoginActivity()
        _showEquiSell(type)
    end

    function _layer:gotoSkillBreakSelectLayer( type,dic )
        mainFunArray.closeLoginActivity()
        _showSkillBreakSelectView(type,dic)
    end

    function _layer:gotoEquipUpdateLayer( dic )
        mainFunArray.closeLoginActivity()
        _showEquipUpdateLayer(dic)
    end

    -- 大冒险
    function _layer:gotoAdventure(init)
        currentTag = -1
        mainFunArray.closeLoginActivity()
        _showAdventure(init)
    end

    -- 海军支部
    function _layer:gotoMarineBranchLayer(  )
        mainFunArray.closeLoginActivity()
        _showMarineBranch()
    end


    -- 日常
    function _layer:gotoDaily()
        mainFunArray.closeLoginActivity()
        _showDaily()
    end

    -- 决斗
    function _layer:gotoArena()
        mainFunArray.closeLoginActivity()
        _showArena()
    end

    function _layer:reloadBottomBtn()
        t:reloadData()
    end

    -- 幸运卡牌地图
    function _layer:gotoTreasureMap()
        mainFunArray.closeLoginActivity()
        _showTreasureMap()
    end

    -- 抢残章
    function _layer:gotoChapterRob(dic, bookId, chapterId)
        mainFunArray.closeLoginActivity()
        _showChapterRob(dic, bookId, chapterId)
    end

    -- 联盟
    function _layer:gotoUnion(  )
        mainFunArray.closeLoginActivity()
        _showUnion()
    end

    -- 国战
    function _layer:gotoWorldWar()
        mainFunArray.closeLoginActivity()
        mainFunArray.refreshWWMainData()
    end

    -- 国战岛屿界面
    function _layer:gotoWorldWarIsland()
        mainFunArray.closeLoginActivity()    
        mainFunArray.showWorldWarIsland()
    end

    -- 国战实验室
    function _layer:gotoWorldWarExperiment()
        mainFunArray.closeLoginActivity()
        mainFunArray.showWorldWarExperiment()
    end

    -- 国战战绩
    function _layer:gotoWorldWarRecord()
        mainFunArray.closeLoginActivity()
        mainFunArray.showWorldWarRecord()
    end

    -- 国战阵营
    function _layer:gotoWorldWarGroup()
        mainFunArray.closeLoginActivity()
        mainFunArray.showWorldWarGroup()
    end

     -- 押运物资界面
    function _layer:gotoEscortItem()
        mainFunArray.closeLoginActivity()
        mainFunArray.showEscortItem()
    end
    -- 押运物资state 界面  押运中，押运结束
    function _layer:gotoEscortItemState()
        mainFunArray.closeLoginActivity()
        mainFunArray.showEscortItemState()
    end
    

     -- 劫物资(劫镖)界面  
    function _layer:gotoRobItem()
        mainFunArray.closeLoginActivity()
        mainFunArray.showRobItem()
    end

    -- 积分排位赛界面 (跨服决斗) 
    function _layer:gotoPointsRace()
        mainFunArray.closeLoginActivity()
        mainFunArray.showPointsRace()
    end
    -- 排位晋级赛界面 (跨服决斗) 
    function _layer:gotoPointsRaceRanking()
        mainFunArray.closeLoginActivity()
        mainFunArray.showPointsRaceRanking()
    end
    -- 膜拜界面 (跨服决斗) 
    function _layer:gotoSSAWorship()
        mainFunArray.closeLoginActivity()
        mainFunArray.showSSAWorship()
    end
    
     -- 战报界面 (跨服决斗) 
    function _layer:gotoSSABattleLogs()
        mainFunArray.closeLoginActivity()
        mainFunArray.showSSABattleLogs()
    end

     -- 四皇界面 (跨服决斗) 
    function _layer:gotoSSAFourKing()
        mainFunArray.closeLoginActivity()
        mainFunArray.showSSAFourKing()
    end

    function _layer:getBroadCastContentSize()
        local broadcastBg = tolua.cast(MainSceneOwner["broadcastBg"], "CCSprite")
        return CCSizeMake(broadcastBg:getContentSize().width * retina, broadcastBg:getContentSize().height * retina)
    end

    function _layer:getTitleContentSize()   
        local titleBg = tolua.cast(MainSceneOwner["titleBg"], "CCSprite")
        return CCSizeMake(titleBg:getContentSize().width * retina, titleBg:getContentSize().height * retina)
    end

    function _layer:getBottomContentSize()
        local bottomBg = tolua.cast(MainSceneOwner["bottomBg"], "CCSprite")
        return CCSizeMake(bottomBg:getContentSize().width * retina, bottomBg:getContentSize().height * retina)
    end
    local function renameFunction(  )
        local nameLabel = tolua.cast(MainSceneOwner["nameLabel"], "CCLabelTTF")
        nameLabel:setString(userdata.name)
    end

    function _layer:refreshTitleData()
        local nameLabel = tolua.cast(MainSceneOwner["nameLabel"], "CCLabelTTF")
        nameLabel:setString(userdata.name)
        
        -- vip*********
        local vipLabel = tolua.cast(MainSceneOwner["vipLabel"], "CCLabelTTF")
        vipLabel:setString(string.format("VIP %d", userdata:getVipLevel()))
        local centerVipFlag = tolua.cast(MainSceneOwner["centerVipFlag"], "CCSprite")
        centerVipFlag:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("flagBg%d.png", userdata:getVipLevel())))
        vipLabel:setVisible(not userdata:getVipAuditState())
        centerVipFlag:setVisible(not userdata:getVipAuditState())
        _updateVipLevelReward() --vip领取高亮

        local lvLabel = tolua.cast(MainSceneOwner["lvLabel"], "CCLabelTTF")
        lvLabel:setString(userdata.level)

        local goldLabel = tolua.cast(MainSceneOwner["goldLabel"], "CCLabelTTF")
        local gold = userdata:getFunctionOfNumberAcronym(tonumber(userdata.gold))
        goldLabel:setString(gold)

        local berryLabel = tolua.cast(MainSceneOwner["berryLabel"], "CCLabelTTF")
        local berry = userdata:getFunctionOfNumberAcronym(tonumber(userdata.berry))
        berryLabel:setString(berry)

        local strengthLabel = tolua.cast(MainSceneOwner["strengthLabel"], "CCLabelTTF")
        strengthLabel:setZOrder(1)
        strengthLabel:setString(string.format("%d/%d", userdata.strength, userdata:getStrengthMax()))

        local strengthProgressBg = tolua.cast(MainSceneOwner["strengthProgressBg"], "CCSprite")
        local strengthProgress = CCProgressTimer:create(CCSprite:create("images/grePro.png"))
        strengthProgress:setType(kCCProgressTimerTypeBar)
        strengthProgress:setMidpoint(CCPointMake(0, 0))
        strengthProgress:setBarChangeRate(CCPointMake(1, 0))
        strengthProgress:setPosition(strengthProgressBg:getPositionX(), strengthProgressBg:getPositionY())
        strengthProgressBg:getParent():addChild(strengthProgress,0, 101)
        strengthProgress:setPercentage(math.min(userdata.strength / userdata:getStrengthMax() * 100, 100))

        local energyLabel = tolua.cast(MainSceneOwner["energyLabel"], "CCLabelTTF")
        energyLabel:setZOrder(1)
        energyLabel:setString(string.format("%d/%d", userdata.energy, userdata:getEnergyMax()))

        local energyProgressBg = tolua.cast(MainSceneOwner["energyProgressBg"], "CCSprite")
        local energyProgress = CCProgressTimer:create(CCSprite:create("images/oraPro.png"))
        energyProgress:setType(kCCProgressTimerTypeBar)
        energyProgress:setMidpoint(CCPointMake(0, 0))
        energyProgress:setBarChangeRate(CCPointMake(1, 0))
        energyProgress:setPosition(energyProgressBg:getPositionX(), energyProgressBg:getPositionY())
        energyProgressBg:getParent():addChild(energyProgress, 0, 102)
        energyProgress:setPercentage(math.min(userdata.energy / userdata:getEnergyMax() * 100, 100))

        local expLabel = tolua.cast(MainSceneOwner["expLabel"], "CCLabelTTF")
        expLabel:setZOrder(1)
        expLabel:setString(tostring(userdata.exp))

        local expProgressBg = tolua.cast(MainSceneOwner["expProgressBg"], "CCSprite")
        local progress = CCProgressTimer:create(CCSprite:create("images/bluePro.png"))
        progress:setType(kCCProgressTimerTypeBar)
        progress:setMidpoint(CCPointMake(0, 0))
        progress:setBarChangeRate(CCPointMake(1, 0))
        progress:setPosition(expProgressBg:getPositionX(), expProgressBg:getPositionY())
        expProgressBg:getParent():addChild(progress, 0, 100)
        progress:setPercentage(userdata.exp / ConfigureStorage.levelExp[tostring(userdata.level)].value1 * 100)

        local flag = tolua.cast(MainSceneOwner["flag"], "CCSprite")
        if flag and userdata.flag then
            flag:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(userdata.flag..".png"))
        end 
    end

    -- 移动下方按钮，offset 正数左移 负数右移
    function _layer:setBottomBtnOffset(offset)
        local homeBtn = MainSceneOwner["homeBtn"]
        local pos = t:getContentOffset()
        t:setContentOffset(ccpAdd(pos, ccp(-homeBtn:getContentSize().width * retina * offset, 0)))
    end

    -- 底部菜单显示联盟
    function _layer:showBottomLeague()
        local homeBtn = MainSceneOwner["homeBtn"]
        local width = winSize.width - homeBtn:getContentSize().width * retina
        local pos = t:getContentOffset()
        t:setContentOffset(ccpAdd(pos, ccp(width - t:getContentSize().width + homeBtn:getContentSize().width * retina, 0)))
    end

    function _layer:showBottomWorldWar()
        local homeBtn = MainSceneOwner["homeBtn"]
        local width = winSize.width - homeBtn:getContentSize().width * retina
        local pos = t:getContentOffset()
        t:setContentOffset(ccpAdd(pos, ccp(width - t:getContentSize().width, 0)))
    end

    function _layer:addInfoLayer(dic)
        local infoLayer = createInfoLayer()
        _layer:addChild(infoLayer)
    end

    function _layer:showQuest()
        mainFunArray.closeLoginActivity()
        mainFunArray.showQuest()
    end

    function _layer:refreshBroadcast()
        local broadcastBg = tolua.cast(MainSceneOwner["broadcastBg"], "CCSprite")
        if broadcastBg then
            local content = topRollData:getOneInfo()
            local bcLabel = CCLabelTTF:create(content, "ccbResources/FZCuYuan-M03S.ttf", 22)
            bcLabel:setAnchorPoint(ccp(0,0.5))
            bcLabel:setPosition(ccp(broadcastBg:getContentSize().width, broadcastBg:getContentSize().height/2))
            broadcastBg:addChild(bcLabel)
            local labelWidth = bcLabel:getContentSize().width
            local function setLabelPos(  )
                content = topRollData:getOneInfo()
                bcLabel:setString(content)
                bcLabel:setPosition(ccp(broadcastBg:getContentSize().width, broadcastBg:getContentSize().height/2))
                labelWidth = bcLabel:getContentSize().width

                local callFunc = CCCallFunc:create(setLabelPos)
                bcLabel:runAction(CCSequence:createWithTwoActions(CCMoveBy:create((broadcastBg:getContentSize().width+labelWidth)/50, ccp(-(broadcastBg:getContentSize().width+labelWidth), 0)), callFunc))
            end 
            local callFunc = CCCallFunc:create(setLabelPos)
            bcLabel:runAction(CCSequence:createWithTwoActions(CCMoveBy:create((broadcastBg:getContentSize().width+labelWidth)/50, ccp(-(broadcastBg:getContentSize().width+labelWidth), 0)), callFunc))
        end 
    end

    _layer:refreshTitleData()


    local function _onEnter()
        addObserver(NOTI_GOLD, _updateGold)
        addObserver(NOTI_BERRY, _updateBerry)
        addObserver(NOTI_STRENGTH, _updateStrength)
        addObserver(NOTI_RENAME_SUCCESS, renameFunction)
        addObserver(NOTI_ENERGY, _updateEnergy)
        addObserver(NOTI_EXP, _updateExp)
        addObserver(NOTI_TOPROLL_INFO, _getTopRollInfo)
        addObserver(NOTI_VIPSCORE, _updateVip)
        addObserver(NOTI_DAILY_STATUS, _updateDailyState)
        addObserver(NOTI_LEVELUP, _updateLevel)
        -- renzhan
        addObserver(NOTI_ADVENTURE_STATUS, _updateAdventureState)
        
        addObserver(NOTI_RECRUIT_BTNUPDATE_REFRESH, _updateRecruitBtmState)
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.1), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
        local seq2 = CCSequence:createWithTwoActions(CCDelayTime:create(1), CCCallFunc:create(_addTouchFBLayer))
        _layer:runAction(seq2)
        local function addQuestPopup()
            local popup = createQuestPopupLayer()
            if popup then
                getMainLayer():getParent():addChild(popup, 99999)
            end
        end
        local seq3 = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(addQuestPopup))
        _layer:runAction(seq3)
        
        _layer:refreshBroadcast()

        playMusic(MUSIC_SOUND_1, true)
        
        if runtimeCache.bGuide then
            _scene:addChild(createGuideLayer(), 999)
            if runtimeCache.guideStep == GUIDESTEP.firstStageFight or runtimeCache.guideStep == GUIDESTEP.gotoRogue 
                or runtimeCache.guideStep == GUIDESTEP.secondStageFight or runtimeCache.guideStep == GUIDESTEP.secondGotoTeam 
                or runtimeCache.guideStep == GUIDESTEP.guideEnd then
                _showSail()
            elseif runtimeCache.guideStep == GUIDESTEP.recruit or runtimeCache.guideStep == GUIDESTEP.firstGotoTeam then
                _showLogueTown() 
            elseif runtimeCache.guideStep == GUIDESTEP.onForm 
                or runtimeCache.guideStep == GUIDESTEP.gotoHome 
                or runtimeCache.guideStep == GUIDESTEP.selectNeedUpdateEquip then
                _showTeam()
            elseif runtimeCache.guideStep == GUIDESTEP.thirdGotoSail then
                _showWareHouseLayer()
            end
            
            if runtimeCache.bGuide and runtimeCache.guideStep == GUIDESTEP.gotoRogue then
                local homeBtn = MainSceneOwner["homeBtn"]
                local pos = t:getContentOffset()
                t:setContentOffset(ccpAdd(pos, ccp(-homeBtn:getContentSize().width * retina, 0)))
            end
        end
    end

    local function _onExit()
        _scene = nil
        btm.adventure = nil
        btm.logueTown = nil
        btm.daily = nil
        t = nil
        currentTag = 0
        removeObserver(NOTI_GOLD, _updateGold)
        removeObserver(NOTI_BERRY, _updateBerry)
        removeObserver(NOTI_STRENGTH, _updateStrength)
        removeObserver(NOTI_RENAME_SUCCESS, renameFunction)
        removeObserver(NOTI_ENERGY, _updateEnergy)
        removeObserver(NOTI_EXP, _updateExp)
        removeObserver(NOTI_TOPROLL_INFO, _getTopRollInfo)
        removeObserver(NOTI_VIPSCORE, _updateVip)
        removeObserver(NOTI_DAILY_STATUS, _updateDailyState)
        removeObserver(NOTI_LEVELUP, _updateLevel)
        removeObserver(NOTI_RECRUIT_BTNUPDATE_REFRESH, _updateRecruitBtmState)
        -- renzhan
        removeObserver(NOTI_ADVENTURE_STATUS, _updateAdventureState)
        
        if getHotBalloonLayer() then
            removeHotBalloonAnimation()
        end 
    end

    local function _cleanup(  )
        ccb["MainSceneOwner"] = nil
        _layer:removeAllChildrenWithCleanup(true)
        _layer = nil
        CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile("ccbResources/huoban.plist")
        CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile("ccbResources/mainScene.plist")
        CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile("ccbResources/flag.plist")
        -- CCSpriteFrameCache:sharedSpriteFrameCache():removeUnusedSpriteFrames()
        CCTextureCache:sharedTextureCache():removeUnusedTextures()
        CCTextureCache:sharedTextureCache():dumpCachedTextureInfo()
    end 

    --onEnter onExit
    local function _layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() 
            end
        elseif eventType == "cleanup" then
            if _cleanup then _cleanup() end
        end
    end

    _scene:registerScriptHandler(_layerEventHandler)

    return _scene
end