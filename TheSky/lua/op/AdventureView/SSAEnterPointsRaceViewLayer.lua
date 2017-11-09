local _layer
local _tableView
local _data
local _rankArray
local progress1
local progress2
local payCount

-- 积分赛主界面
-- 名字不要重复
SSAEnterPointsRaceViewOwner = SSAEnterPointsRaceViewOwner or {}
ccb["SSAEnterPointsRaceViewOwner"] = SSAEnterPointsRaceViewOwner

-- 返回按钮回调
local function BackClicked()
    runtimeCache.SSAState = ssaDataFlag.home
    getMainLayer():gotoAdventure()
end
SSAEnterPointsRaceViewOwner["BackClicked"] = BackClicked

-- 战报
local function BattlelogsBtnTaped()
    runtimeCache.SSAState = ssaDataFlag.home
    getMainLayer():gotoSSABattleLogs()
end
SSAEnterPointsRaceViewOwner["BattlelogsBtnTaped"] = BattlelogsBtnTaped

--阵容按钮
local function castBtnTaped()
    runtimeCache.SSAState = ssaDataFlag.home
    getMainLayer():gotoTeam() 
end
SSAEnterPointsRaceViewOwner["castBtnTaped"] = castBtnTaped


-- 积分榜按钮
local function rankNoticeClicked()
    local function Callback(url, rtnData)
        local data = rtnData.info
        getMainLayer():getParent():addChild(createSSARankNoticeViewLayer(data, -132))
    end
    doActionFun("CROSSSERVERBATTLE_LOOKRANKINFO", {}, Callback)
end
SSAEnterPointsRaceViewOwner["rankNoticeClicked"] = rankNoticeClicked


--[[
    rankSprint  当前玩家所在阶段图片 拳头
    Rank  当前玩家所在阶段排名
    server 敌人所在的服务器名
    playerName 敌人名字
    enemyRankName 敌人所在阶段排名
    _data   从缓存数据中拿到_data
    for 1 2 do 左右框数据展示
    FreeLable 免费字
    CostLable 消耗金币的数量
    iconSprite 金币
    ConfigureStorage.crossDual_sundry 跨服战杂项配置
        pkTime  每日免费挑战次数15
        ennrgy  精力消耗1
        buffCost 购买buff消耗挑战次数4次
        buff buff加成大小0.2
    ConfigureStorage.crossDual_refresh1 积分赛每日对手刷新价格配置
        key cost
]]

local function _updateEnergy()
    -- body
    local proLabel2 = tolua.cast(SSAEnterPointsRaceViewOwner["proLabel2" ], "CCLabelTTF")
    local progressBg2 = tolua.cast(SSAEnterPointsRaceViewOwner["proBg2" ], "CCSprite")
    proLabel2:setString(string.format("%d/%d", userdata.energy, userdata:getEnergyMax()))
    proLabel2:setZOrder(1)
    if not progress2 then
        progress2 = CCProgressTimer:create(CCSprite:create("images/oraPro.png"))
        progress2:setScale(retina)
        progress2:setType(kCCProgressTimerTypeBar)
        progress2:setMidpoint(CCPointMake(0, 0))
        progress2:setBarChangeRate(CCPointMake(1, 0))
        local x, y = progressBg2:getPosition()
        progress2:setPosition(x, y)
        progressBg2:getParent():addChild(progress2, 0, 1)
    end
    progress2:setPercentage(math.min(userdata.energy / userdata:getEnergyMax() * 100, 100))  
end

local function refresh()
    _data = ssaData.data 
    -- if tonumber(ssaData.data.rankId) == 0 then -- 32 晋升之路
    -- end
    -- 进入排位赛

    local rankSprint = tolua.cast(SSAEnterPointsRaceViewOwner["rankSprint"], "CCSprite")
    local Rank = tolua.cast(SSAEnterPointsRaceViewOwner["Rank"], "CCLabelTTF")
    Rank:setString(ConfigureStorage.crossDual_score[tonumber(_data.rankId) + 1].name)
    print("新增修改好的配置表")
    PrintTable(ConfigureStorage.crossDual_score)
    -- if _data.rankId == 0 then  -- 测试
    --     rankSprint:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("ranking" .. (4) .. "_1.png"))
    -- end
    rankSprint:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("ranking" .. (5- _data.rankId) .. "_1.png"))
    for i=1,2 do
        local server = tolua.cast(SSAEnterPointsRaceViewOwner["server" .. i], "CCLabelTTF")
        local playerName = tolua.cast(SSAEnterPointsRaceViewOwner["playerName" .. i], "CCLabelTTF")
        local enemyRankName = tolua.cast(SSAEnterPointsRaceViewOwner["rankName" .. i], "CCLabelTTF")
        local lv = tolua.cast(SSAEnterPointsRaceViewOwner["lv" .. i], "CCLabelTTF")
        local lvBlack = tolua.cast(SSAEnterPointsRaceViewOwner["lvBlack" .. i], "CCLabelTTF")
        local countLabel = tolua.cast(SSAEnterPointsRaceViewOwner["count" .. i], "CCLabelTTF")  -- 根据等级差确定改玩家的等级
        local myScoreSprite = tolua.cast(SSAEnterPointsRaceViewOwner["scoreSprite" .. i], "CCSprite")  -- 打败敌人获得积分图片
        
        local dic = _data.data.enemys[tostring(i-1)]
        -- maxlvldiff 玩家与敌人的等级差
        local maxlvldiff = dic.battleData.level - userdata.level 
        if maxlvldiff >= 5 then
            maxlvldiff = 5
        elseif maxlvldiff <= -5 then
            maxlvldiff = -5
        end
        local count = ConfigureStorage.crossDual_32score[tostring(maxlvldiff)].scoreWin
        print("count", count)
        countLabel:setString(count)

        countLabel:setVisible(tonumber(_data.rankId) == 0)
        myScoreSprite:setVisible(tonumber(_data.rankId) == 0)

        server:setString(dic.serveName)
        playerName:setString(dic.battleData.name)
        enemyRankName:setString(ConfigureStorage.crossDual_score[tonumber(_data.rankId) + 1].name) 
        lv:setString('Lv' .. dic.battleData.level)
        lvBlack:setString('Lv' .. dic.battleData.level)
        
        if dic.battleData.heros and dic.battleData.heros[dic.battleData.form[tostring(i - 1)]] then 
            local hero = dic.battleData.heros[dic.battleData.form[tostring(0)]]
            local heroId = hero.heroId
            local conf = herodata:getHeroConfig(heroId)
            if conf then
                local rankFrame = tolua.cast(SSAEnterPointsRaceViewOwner["rankFrame" .. i], "CCSprite") 
                local heroSprite = tolua.cast(SSAEnterPointsRaceViewOwner["heroSprite" .. i], "CCSprite")
                local colorSprite = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", herodata:fixRank(conf.rank, hero.wake)))
                local f = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(herodata:getHeroHeadByHeroId(heroId))
                if f then
                    heroSprite:setVisible(true)
                    rankFrame:setVisible(true)
                    heroSprite:setDisplayFrame(f)
                    rankFrame:setDisplayFrame(colorSprite)
                end
            end 
        end
    end
    local ChallengeCount = tolua.cast(SSAEnterPointsRaceViewOwner["ChallengeCount"], "CCLabelTTF")
    ChallengeCount:setString(HLNSLocalizedString("SSA.ChallengeCount") .. (ConfigureStorage.crossDual_sundry.pkTime - _data.data.fightCount) .. '/' .. ConfigureStorage.crossDual_sundry.pkTime)
    local FreeLable = tolua.cast(SSAEnterPointsRaceViewOwner["FreeLable"], "CCLabelTTF")
    local CostLable = tolua.cast(SSAEnterPointsRaceViewOwner["CostLable"], "CCLabelTTF")
    local iconSprite = tolua.cast(SSAEnterPointsRaceViewOwner["iconSprite"], "CCSprite")
    if _data.data.flushEnemyCount == 0 then
        FreeLable:setVisible(true)
    elseif  _data.data.flushEnemyCount + 1 >= getMyTableCount(ConfigureStorage.crossDual_refresh1) then
         FreeLable:setVisible(false)
         CostLable:setVisible(true)
         CostLable:setString(ConfigureStorage.crossDual_refresh1[tostring(getMyTableCount(ConfigureStorage.crossDual_refresh1))].cost)
         iconSprite:setVisible(true)
    else
         FreeLable:setVisible(false)
         CostLable:setVisible(true)
         PrintTable(ConfigureStorage.crossDual_refresh1[tostring(_data.data.flushEnemyCount + 1)])
         CostLable:setString(ConfigureStorage.crossDual_refresh1[tostring(_data.data.flushEnemyCount + 1)].cost)
         iconSprite:setVisible(true)
    end
    _updateEnergy()
    local rankNoticeBtn = tolua.cast(SSAEnterPointsRaceViewOwner["rankNoticeBtn"] , "CCMenuItemImage")
    local scoreSprite = tolua.cast(SSAEnterPointsRaceViewOwner["scoreSprite"] , "CCSprite")
    local scoreLabel = tolua.cast(SSAEnterPointsRaceViewOwner["scoreLabel"] , "CCLabelTTF")
    local jifenLabel = tolua.cast(SSAEnterPointsRaceViewOwner["jifenLabel"] , "CCLabelTTF")    
    rankNoticeBtn:setVisible(tonumber(_data.rankId) == 0)
    scoreSprite:setVisible(tonumber(_data.rankId) == 0)
    scoreLabel:setVisible(tonumber(_data.rankId) == 0)
    jifenLabel:setVisible(tonumber(_data.rankId) == 0)
    local proLabel1 = tolua.cast(SSAEnterPointsRaceViewOwner["proLabel1"], "CCLabelTTF")
    local progressBg1 = tolua.cast(SSAEnterPointsRaceViewOwner["proBg1"], "CCSprite")
    proLabel1:setZOrder(1)
    if progress1 then
        progress1:removeFromParentAndCleanup(true)
        progress1 = nil
    end
    progress1 = CCProgressTimer:create(CCSprite:create("images/grePro_refine.png"))
    progress1:setScale(retina)
    progress1:setType(kCCProgressTimerTypeBar)
    progress1:setMidpoint(CCPointMake(0, 0))
    progress1:setBarChangeRate(CCPointMake(1, 0))
    local x, y = progressBg1:getPosition()
    progress1:setPosition(x, y)
    progressBg1:getParent():addChild(progress1, 0, 1)
    proLabel1:setVisible(tonumber(_data.rankId) ~= 0)
    progressBg1:setVisible(tonumber(_data.rankId) ~= 0)
    progress1:setVisible(tonumber(_data.rankId) ~= 0)
    if tonumber(_data.rankId) == 0 then
        scoreLabel:setString(_data.data.expNow)
    else
        proLabel1:setString(string.format("%d/%d", _data.data.expNow, ConfigureStorage.crossDual_score[tonumber(_data.rankId) + 1].scoreNeed))
        progress1:setPercentage(math.min(_data.data.expNow / ConfigureStorage.crossDual_score[tonumber(_data.rankId) + 1].scoreNeed * 100, 100)) 
    end
end
-- 刷新按钮回调
local function RefreshClicked()
    local function Callback(url, rtnData)
        ssaData.data = rtnData.info
        refresh()
    end
    doActionFun("CROSSSERVERBATTLE_BUYFLUSHENEMY", {}, Callback)
end
SSAEnterPointsRaceViewOwner["RefreshClicked"] = RefreshClicked


-- 各个相关战斗按钮回调
local function arenaFightCallback(url, rtnData)
    runtimeCache.responseData = rtnData["info"]
    ssaData.data = rtnData.info
    CCDirector:sharedDirector():replaceScene(CCTransitionFade:create(0.6, FightingScene())) 
end
--[[
    战斗注释
    调用接口 、传入的三个参数 
    1 result 、 
    2 敌人id 、 
    3 state 0 和 1 ，0为普通挑战 1为背水一战 加buf 
    
    TagBtnTap 根据tag值确定点击的那个按钮以及判断是否为背水一战
    buff 友方buf 
    oppoBuff 敌方buf
]]
local function TagBtnTap(tag)
    -- 若挑战次数不足，调用购买挑战次数接口
    -- buff挑战
    local fightBuyAmount = ConfigureStorage.crossDual_sundry.fightBuyAmount  -- 每次点击按钮 购买的挑战次数 (5) 从配置取得
    if _data.data.fightCountBuy + fightBuyAmount > ConfigureStorage.crossDual_sundry.fightBuy then
        ShowText(HLNSLocalizedString("SSA.BuyUpperLimit"))
        return
    end
    if _data.data.fightCountBuy >= getMyTableCount(ConfigureStorage.crossDual_buyFight) then
        payCount = ConfigureStorage.crossDual_buyFight[tostring(getMyTableCount(ConfigureStorage.crossDual_buyFight))].cost
    else
        payCount = ConfigureStorage.crossDual_buyFight[tostring(_data.data.fightCountBuy + 1)].cost
    end
    --[[
        time: 需要购买多少次
        currentTime: 已购买次数
    ]]
    local function needGold(time, currentTime, gold)
        gold = gold or 0
        currentTime = currentTime + 1
        time = time - 1
        local cost = ConfigureStorage.crossDual_buyFight[tostring(getMyTableCount(ConfigureStorage.crossDual_buyFight))].cost
        if ConfigureStorage.crossDual_buyFight[tostring(currentTime)] then
            cost = ConfigureStorage.crossDual_buyFight[tostring(currentTime)].cost
        end
        gold = gold + cost
        if time == 0 then
            return gold
        else
            return needGold(time, currentTime, gold)
        end 
    end

    local function needBuffFight()
        RandomManager.cursor = RandomManager.randomRange(0, 999)
        local seed = RandomManager.cursor
        local battleData = _data.data.enemys[tostring(math.floor(tag % 10))].battleData  -- 1 为右边
        playerBattleData:fromDic(battleData)
        BattleField.leftName = userdata.name
        BattleField.rightName = battleData.name
        local buff = ConfigureStorage.crossDual_sundry.buff
        local oppoBuff = battleData.buffs
        BattleField:SSAFight(buff, oppoBuff)
        local result = BattleField.result == RESULT_WIN and 4 - BattleField.round or 0  --传入0 1 2 3 四中状态 
        doActionFun("CROSSSERVERBATTLE_FIGHT", {result, _data.data.enemys[tostring(math.floor(tag % 10))].id, 1}, arenaFightCallback)
    end
    -- 普通挑战
    local function Fight()
        RandomManager.cursor = RandomManager.randomRange(0, 999)
        local seed = RandomManager.cursor
        local battleData = _data.data.enemys[tostring(math.floor(tag % 10))].battleData
        playerBattleData:fromDic(battleData)
        BattleField.leftName = userdata.name
        BattleField.rightName = battleData.name
        local buff = nil
        local oppoBuff = nil
        BattleField:SSAFight(buff, oppoBuff)
        local result = BattleField.result == RESULT_WIN and 4 - BattleField.round or 0  --传入0 1 2 3 四中状态
        doActionFun("CROSSSERVERBATTLE_FIGHT", {result, _data.data.enemys[tostring(math.floor(tag % 10))].id, 0}, arenaFightCallback)
    end
    --确定购买并使用背水一战
    local function needBuyBuffFightConfirmClick()
        --若挑战次数不足，确认购买调用接口
        local function Callback(url, rtnData)
            ssaData.data = rtnData.info
            refresh()
            needBuffFight()
        end
        local times = 5
        doActionFun("CROSSSERVERBATTLE_BUYFIGHTCOUNT", {times}, Callback)
    end
    --确定使用背水一战
    local function needBuffFightConfirmClick()
        needBuffFight()
    end
     --确定购买并使用普通挑战
    local function FightConfirmClick()
        local function Callback(url, rtnData)
            ssaData.data = rtnData.info
            Fight()
        end
        local times = 5
        doActionFun("CROSSSERVERBATTLE_BUYFIGHTCOUNT", {times}, Callback)   
    end
    -- 首先判断是否为buff战
    if math.floor(tag / 10) == 1 then
        if ConfigureStorage.crossDual_sundry.pkTime - _data.data.fightCount >= ConfigureStorage.crossDual_sundry.buffCost + 1 then -- 挑战次数足够
            local text = HLNSLocalizedString("SSA.needBuff.desp") -- 背水一战描述
            CCDirector:sharedDirector():getRunningScene():addChild(createSimpleConfirCardLayer(text))
            SimpleConfirmCard.confirmMenuCallBackFun = needBuffFightConfirmClick
            SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction
        else
            -- local times = (ConfigureStorage.crossDual_sundry.buffCost + 1) + _data.data.fightCount - ConfigureStorage.crossDual_sundry.pkTime
            local cost = needGold(5, _data.data.fightCountBuy) 
            local text = HLNSLocalizedString("SSA.needBuff.buffBuyDesp",_data.data.fightCountBuy, cost, 5)
            CCDirector:sharedDirector():getRunningScene():addChild(createSimpleConfirCardLayer(text))
            SimpleConfirmCard.confirmMenuCallBackFun = needBuyBuffFightConfirmClick
            SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction 
        end   
    else
        if _data.data.fightCount < ConfigureStorage.crossDual_sundry.pkTime then
            Fight() 
        else
            local name = wareHouseData:getItemConfig(ConfigureStorage.openFormSevenItem.itemId).name
            local times = 5
            local count = payCount * times
            local text = HLNSLocalizedString("SSA.simpleFight.Desp",_data.data.fightCountBuy, count, times)
            CCDirector:sharedDirector():getRunningScene():addChild(createSimpleConfirCardLayer(text))
            SimpleConfirmCard.confirmMenuCallBackFun = FightConfirmClick
            SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction 
        end  
    end
end
SSAEnterPointsRaceViewOwner["TagBtnTap"] = TagBtnTap

-- 购买挑战次数按钮 ( ‘+’ 号)
local function addItemClick()
    
    print("购买挑战次数上限" , ConfigureStorage.crossDual_sundry.fightBuy)
    local fightBuyAmount = ConfigureStorage.crossDual_sundry.fightBuyAmount  -- 每次点击按钮 购买的挑战次数 (5) 从配置取得
    if _data.data.fightCountBuy + fightBuyAmount > ConfigureStorage.crossDual_sundry.fightBuy then
        ShowText(HLNSLocalizedString("SSA.BuyUpperLimit"))
        return
    end
    --[[
        time: 需要购买多少次
        currentTime: 已购买次数
    ]]
    -- 可以购买
    if (ConfigureStorage.crossDual_sundry.pkTime - _data.data.fightCount) < ConfigureStorage.crossDual_sundry.pkTime - fightBuyAmount then  
        local function needGold(time, currentTime, gold)
            gold = gold or 0
            currentTime = currentTime + 1
            time = time - 1
            local cost = ConfigureStorage.crossDual_buyFight[tostring(getMyTableCount(ConfigureStorage.crossDual_buyFight))].cost
            if ConfigureStorage.crossDual_buyFight[tostring(currentTime)] then
                cost = ConfigureStorage.crossDual_buyFight[tostring(currentTime)].cost
            end
            gold = gold + cost
            if time == 0 then
                return gold
            else
                return needGold(time, currentTime, gold)
            end 
        end
        local function ConfirmClick()
            local function Callback(url, rtnData)
                ssaData.data = rtnData.info
                refresh()
            end
            doActionFun("CROSSSERVERBATTLE_BUYFIGHTCOUNT", {ConfigureStorage.crossDual_sundry.fightBuyAmount}, Callback)
        end
        local times = ConfigureStorage.crossDual_sundry.fightBuyAmount
        local cost = needGold(times, _data.data.fightCountBuy) 
        local text = HLNSLocalizedString("SSA.simpleFight.Desp",_data.data.fightCountBuy, cost, times)
        CCDirector:sharedDirector():getRunningScene():addChild(createSimpleConfirCardLayer(text))
        SimpleConfirmCard.confirmMenuCallBackFun = ConfirmClick
        SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction 
    else
        ShowText(HLNSLocalizedString("SSA.fightBuyAmount.needless"))
        return
    end
end
SSAEnterPointsRaceViewOwner["addItemClick"] = addItemClick

--刷新时间显示函数
local function refreshTimeLabel()
    local timeEnd = tolua.cast(SSAEnterPointsRaceViewOwner["timeEnd"], "CCLabelTTF")

    local timer = _data.nextTime - userdata.loginTime
    if timer < 0 then
        timer = 0
    end
    local day, hour, min, sec = DateUtil:secondGetdhms(timer)
    if day > 0 then
        timeEnd:setString(HLNSLocalizedString("timer.tips.1", day, hour, min, sec) .. HLNSLocalizedString("SSA.raceRankingTime"))
    elseif hour > 0 then
        timeEnd:setString(HLNSLocalizedString("timer.tips.2", hour, min, sec) .. HLNSLocalizedString("SSA.raceRankingTime"))
    else
        timeEnd:setString(HLNSLocalizedString("timer.tips.3", min, sec) .. HLNSLocalizedString("SSA.raceRankingTime"))
    end
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/SSAEnterPointsRaceView.ccbi",proxy, true,"SSAEnterPointsRaceViewOwner")
    _layer = tolua.cast(node,"CCLayer")
    refresh()
    refreshTimeLabel()
end

-- 该方法名字每个文件不要重复
function getSSAEnterPointsRaceViewLayer()
	return _layer
end

function createSSAEnterPointsRaceViewLayer()
    _init()
    print("进入次阶段")
    local function _onEnter()
        addObserver(NOTI_TICK, refreshTimeLabel)
        addObserver(NOTI_WW_REFRESH, refresh)
        addObserver(NOTI_ENERGY, _updateEnergy)
    end

    local function _onExit()
        removeObserver(NOTI_TICK, refreshTimeLabel)
        removeObserver(NOTI_WW_REFRESH, refresh)
        removeObserver(NOTI_ENERGY, _updateEnergy)
        _tableView = nil
        progress1 = nil
        progress2 = nil
        _data = nil
        _layer = nil
        payCount = nil
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