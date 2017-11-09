local _layer

-- ·名字不要重复
NewWorldThirdViewOwner = NewWorldThirdViewOwner or {}
ccb["NewWorldThirdViewOwner"] = NewWorldThirdViewOwner

local function rankItemClick()
    Global:instance():TDGAonEventAndEventData("adventure9")
    local layer = createNewWorldRankLayer(-134)
    getMainLayer():getParent():addChild(layer, 100)
end
NewWorldThirdViewOwner["rankItemClick"] = rankItemClick

local function bloodBattleCallback( url,rtnData )
    blooddata:fromDic(rtnData["info"]["bloodInfo"])
    runtimeCache.responseData = rtnData.info
    -- local bWin = BattleField.result == RESULT_WIN
    -- if bWin then
    --     CCDirector:sharedDirector():replaceScene(CCTransitionFade:create(0.6, FightingResultSceneFun(ResultType.NewWorldWin)))
    -- else
    --     CCDirector:sharedDirector():replaceScene(CCTransitionFade:create(0.6, FightingResultSceneFun(ResultType.NewWorldLose)))
    -- end
    CCDirector:sharedDirector():replaceScene(CCTransitionFade:create(0.6, FightingScene()))
end

local function fightItemClick(tag)
    Global:instance():TDGAonEventAndEventData("adventure"..tag+3)
    print("fightItemClick", tag)
    local dic = blooddata.data.battleInfo[tostring(tag)]
    runtimeCache.newWorldPlayerBattleInfo = dic
    local playerBattleInfo = {}
    local npcBattleInfo = {}
    
    BattleField.leftName = userdata.name
    BattleField.rightName = dic.npcBattleInfo["0"].name

    RandomManager.cursor = RandomManager.randomRange(0, 999)
    local seed = RandomManager.cursor
    BattleField:newWorldFight(dic.playerCount, blooddata.data.dayBuff, dic.npcBattleInfo)
    -- BattleField.result = RESULT_WIN
    -- BattleField.round = 1
    local result = BattleField.result == RESULT_WIN and 4 - BattleField.round or 0
    doActionFun("BLOOD_BATTLE", {blooddata.data.outpostNum, tag, seed, result}, bloodBattleCallback)
    runtimeCache.newWorldGrade = tag
    runtimeCache.newWorldOutpostNum = blooddata.data.outpostNum
    runtimeCache.newWorldSkip = blooddata.data.outpostNum <= blooddata.data.skipNum and 3 or 2
    -- runtimeCache.newWorldState = 3
    -- getNewWorldLayer():showLayer()
end
NewWorldThirdViewOwner["fightItemClick"] = fightItemClick




local function sweepOnceCallback( url,rtnData )
    blooddata:fromDic(rtnData["info"]["bloodInfo"])
    runtimeCache.responseData = rtnData.info
    print("**lsf BattleField.result",BattleField.result)
    getMainLayer():addChild(createNewWorldSweepInfoLayer( BattleField.result, -134), 200)
    --CCDirector:sharedDirector():replaceScene(FightingResultSceneFun(ResultType.NewWorldLose))

end


local function cardConfirmAction() 
    CCDirector:sharedDirector():getRunningScene():addChild(createShopRechargeLayer(-400), 100)
end

local function cardCancelAction()
    
end
-- 开启连闯
local function openSweep()
    -- 船长，您的VIP等级不够，成为VIP%d可以进行连闯，快些充值吧！
    local text = HLNSLocalizedString("newWorld.openSweepOnce", vipdata:getVipRaidsLevel())
    getMainLayer():addChild(createSimpleConfirCardLayer(text), 100)
    SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
    SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction
end
--lsf 快速战斗
local function sweepOnceItemClick(tag)
    Global:instance():TDGAonEventAndEventData("adventure"..tag+3)
    print("sweepOnceItemClick", tag)

    if vipdata:getVipLevel() < vipdata:getVipRaidsLevel() then
        openSweep()
        return
    end

    local dic = blooddata.data.battleInfo[tostring(tag)]
    runtimeCache.newWorldPlayerBattleInfo = dic
    local playerBattleInfo = {}
    local npcBattleInfo = {}
    
    BattleField.leftName = userdata.name
    BattleField.rightName = dic.npcBattleInfo["0"].name

    RandomManager.cursor = RandomManager.randomRange(0, 999)
    local seed = RandomManager.cursor
    BattleField:newWorldFight(dic.playerCount, blooddata.data.dayBuff, dic.npcBattleInfo)
    -- BattleField.result = RESULT_WIN
    -- BattleField.round = 1
    local result = BattleField.result == RESULT_WIN and 4 - BattleField.round or 0
    doActionFun("BLOOD_BATTLE", {blooddata.data.outpostNum, tag, seed, result}, sweepOnceCallback)
    runtimeCache.newWorldGrade = tag
    runtimeCache.newWorldOutpostNum = blooddata.data.outpostNum
    runtimeCache.newWorldSkip = blooddata.data.outpostNum <= blooddata.data.skipNum and 3 or 2
    -- runtimeCache.newWorldState = 3
    -- getNewWorldLayer():showLayer()
end
NewWorldThirdViewOwner["sweepOnceItemClick"] = sweepOnceItemClick



-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/NewWorldThirdView.ccbi",proxy, true,"NewWorldThirdViewOwner")
    _layer = tolua.cast(node,"CCLayer")
end

local function _refreshData()
    local islandCountLabel = tolua.cast(NewWorldThirdViewOwner["islandCountLabel"], "CCLabelTTF")
    islandCountLabel:setString(tostring(blooddata.data.outpostNum))
    local starGetLabel = tolua.cast(NewWorldThirdViewOwner["starGetLabel"], "CCLabelTTF")
    starGetLabel:setString(tostring(blooddata.data.recordAll))
    local starLeftLabel = tolua.cast(NewWorldThirdViewOwner["starLeftLabel"], "CCLabelTTF")
    starLeftLabel:setString(tostring(blooddata.data.recordAll - blooddata.data.recordUsed))
    local nextIslandLabel = tolua.cast(NewWorldThirdViewOwner["nextIslandLabel"], "CCLabelTTF")
    nextIslandLabel:setString(tostring(5 - (blooddata.data.outpostNum - 1) % 5))

    --lsf 去除 可快速战斗的红字
    -- if blooddata.data.outpostNum <= blooddata.data.skipNum then
    --     local canSkipLabel = tolua.cast(NewWorldThirdViewOwner["canSkipLabel"], "CCLabelTTF")
    --     canSkipLabel:setVisible(true)
    -- elseif blooddata.data.outpostNum - blooddata.data.skipNum == 1 then
    --     local howToSkipLabel = tolua.cast(NewWorldThirdViewOwner["howToSkipLabel"], "CCLabelTTF")
    --     howToSkipLabel:setVisible(true)
    -- end

    for i=1,3 do
        local dic = blooddata.data.battleInfo[tostring(i)]
        local heroId = dic.npcBattleInfo["0"].id
        local conf = herodata:getHeroConfig(heroId)
        local frame = tolua.cast(NewWorldThirdViewOwner["frame"..i], "CCSprite")
        frame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", herodata:fixRank(conf.rank, conf.wake))))
        local head = tolua.cast(NewWorldThirdViewOwner["head"..i], "CCSprite")
        local f = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(herodata:getHeroHeadByHeroId(heroId))
        if f then
            head:setDisplayFrame(f)
        end
        local left = tolua.cast(NewWorldThirdViewOwner[string.format("%d_left_label", i)], "CCLabelTTF")
        left:setString(tostring(dic.playerCount))
        local right = tolua.cast(NewWorldThirdViewOwner[string.format("%d_right_label", i)], "CCLabelTTF")
        right:setString(tostring(dic.npcCount))
        if dic.award and table.getTableCount(dic.award) > 0 then
            local award = tolua.cast(NewWorldThirdViewOwner["award"..i], "CCSprite")
            for itemId,v in pairs(dic.award) do
                local conf = wareHouseData:getItemResource(itemId)
                if conf.icon then
                    award:setTexture(CCTextureCache:sharedTextureCache():addImage(conf.icon))
                    award:setVisible(true)
                end
            end
        end
    end
    for k,v in pairs(blooddata.data.dayBuff) do
        local label = tolua.cast(NewWorldThirdViewOwner[k.."Label"], "CCLabelTTF")
        label:setString(string.format("+%d%%", v))
    end
    local passIslandLabel = tolua.cast(NewWorldThirdViewOwner["passIslandLabel"], "CCLabelTTF")
    passIslandLabel:setString(tostring(blooddata.data.best.bestOutpostNum))
    local totalStarLabel = tolua.cast(NewWorldThirdViewOwner["totalStarLabel"], "CCLabelTTF")
    totalStarLabel:setString(tostring(blooddata.data.best.bestRecord))

    --大冒险双倍掉落
    local DoubleDropBg = tolua.cast(NewWorldThirdViewOwner["experenceItem2"], "CCSprite")
    if loginActivityData.activitys and loginActivityData.activitys["bloodDropDouble"] and DoubleDropBg then
        print("adventure 1212")
        PrintTable(loginActivityData.activitys["bloodDropDouble"])
        if tonumber(loginActivityData.activitys["bloodDropDouble"]["isOpen"]) == 1 and loginActivityData.activitys["bloodDropDouble"]["activityOpenTime"] <= userdata.loginTime and loginActivityData.activitys["bloodDropDouble"]["activityEndTime"] >= userdata.loginTime then 
            DoubleDropBg:setVisible(true)
        else
            DoubleDropBg:setVisible(false)
        end
    end
end

-- 该方法名字每个文件不要重复
function getNewWorldThirdLayer()
	return _layer
end

function createNewWorldThirdLayer()
    _init()
    _refreshData()

    local function _onEnter()
    end

    local function _onExit()
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