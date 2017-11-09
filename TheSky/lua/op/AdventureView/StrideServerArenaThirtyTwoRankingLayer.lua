local _layer
local progress
local _data
local payCount
-- 32强晋升
-- 名字不要重复
StrideServerArenaThirtyTwoRankingViewOwner = StrideServerArenaThirtyTwoRankingViewOwner or {}
ccb["StrideServerArenaThirtyTwoRankingViewOwner"] = StrideServerArenaThirtyTwoRankingViewOwner

local function refreshData()
    _data = ssaData.data
    for i=1,2 do
        local dic = _data.data.enemys[tostring(i - 1)]
        local server = tolua.cast(StrideServerArenaThirtyTwoRankingViewOwner["server" .. i], "CCLabelTTF")
        local playerName = tolua.cast(StrideServerArenaThirtyTwoRankingViewOwner["playerName" .. i], "CCLabelTTF")
        local enemyRankName = tolua.cast(StrideServerArenaThirtyTwoRankingViewOwner["rankName" .. i], "CCLabelTTF")
        local dic = _data.data.enemys[tostring(i-1)]
        server:setString(dic.serveName)
        playerName:setString(dic.battleData.name)
        enemyRankName:setString(ConfigureStorage.crossDual_score[tonumber(_data.rankId) + 1].name) 
        if dic.battleData.heros  and dic.battleData.heros[dic.battleData.form[tostring(i - 1)]] then 
            local hero = dic.battleData.heros[dic.battleData.form[tostring(0)]]
            local heroId = hero.heroId
            local conf = herodata:getHeroConfig(heroId)
            if conf then
                local rankFrame = tolua.cast(StrideServerArenaThirtyTwoRankingViewOwner["rankFrame" .. i], "CCSprite") 
                local heroSprite = tolua.cast(StrideServerArenaThirtyTwoRankingViewOwner["heroSprite" .. i], "CCSprite")
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
        local FreeLable = tolua.cast(StrideServerArenaThirtyTwoRankingViewOwner["FreeLable"], "CCLabelTTF")
        local CostLable = tolua.cast(StrideServerArenaThirtyTwoRankingViewOwner["CostLable"], "CCLabelTTF")
        local iconSprite = tolua.cast(StrideServerArenaThirtyTwoRankingViewOwner["iconSprite"], "CCSprite")
        if _data.data.flushEnemyCount == 0 then
            FreeLable:setVisible(true)
        elseif  _data.data.flushEnemyCount + 1 >= getMyTableCount(ConfigureStorage.crossDual_refresh3) then
             FreeLable:setVisible(false)
             CostLable:setVisible(true)
             CostLable:setString(ConfigureStorage.crossDual_refresh3[tostring(getMyTableCount(ConfigureStorage.crossDual_refresh3))].cost)
             iconSprite:setVisible(true)
        else
             FreeLable:setVisible(false)
             CostLable:setVisible(true)
             PrintTable(ConfigureStorage.crossDual_refresh3[tostring(_data.data.flushEnemyCount + 1)])
             CostLable:setString(ConfigureStorage.crossDual_refresh3[tostring(_data.data.flushEnemyCount + 1)].cost)
             iconSprite:setVisible(true)
        end
        local proLabel = tolua.cast(StrideServerArenaThirtyTwoRankingViewOwner["proLabel" ], "CCLabelTTF")
        local progressBg = tolua.cast(StrideServerArenaThirtyTwoRankingViewOwner["proBg" ], "CCSprite")
        proLabel:setString(string.format("%d/%d", userdata.energy, userdata:getEnergyMax()))
        proLabel:setZOrder(1)
        if progress then
            progress:removeFromParentAndCleanup(true)
            progress = nil
        end
        progress = CCProgressTimer:create(CCSprite:create("images/oraPro.png"))
        progress:setType(kCCProgressTimerTypeBar)
        progress:setMidpoint(CCPointMake(0, 0))
        progress:setBarChangeRate(CCPointMake(1, 0))
        local x, y = progressBg:getPosition()
        progress:setPosition(x, y)
        progressBg:getParent():addChild(progress, 0, 1)
        progress:setPercentage(math.min(userdata.energy / userdata:getEnergyMax() * 100, 100))    
        
    end  
end

--若挑战次数不足，确认购买调用接口
local function needItemConfirmClick()
    --接口 refreshEscortCost
    local function Callback(url, rtnData)
            ssaData.data = rtnData.info
            refreshData()
        end
    doActionFun("CROSSSERVERBATTLE_BUYFIGHTCOUNT", {}, Callback)
end
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
    local index = tag 
    -- 若挑战次数不足，调用购买挑战次数接口

    if _data.data.fightCountBuy >= getMyTableCount(ConfigureStorage.crossDual_buyFight) then
        payCount = ConfigureStorage.crossDual_buyFight[tostring(getMyTableCount(ConfigureStorage.crossDual_buyFight))].cost
    else
        payCount = ConfigureStorage.crossDual_buyFight[tostring(_data.data.fightCountBuy + 1)].cost
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

     --确定购买并使用普通挑战
    local function FightConfirmClick()
        local function Callback(url, rtnData)
            ssaData.data = rtnData.info
            Fight()
        end
        doActionFun("CROSSSERVERBATTLE_BUYFIGHTCOUNT", {}, Callback)   
    end
    if _data.data.fightCount >= ConfigureStorage.crossDual_sundry.pkTime then
        -- 弹出购买窗口
        local name = wareHouseData:getItemConfig(ConfigureStorage.openFormSevenItem.itemId).name
        local times = 1
        local count = payCount * times
        local text = HLNSLocalizedString("SSA.simpleFight.Desp",_data.data.fightCountBuy, count, times)
        CCDirector:sharedDirector():getRunningScene():addChild(createSimpleConfirCardLayer(text))
        SimpleConfirmCard.confirmMenuCallBackFun = FightConfirmClick
        SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction 
    else
        Fight()
    end
end
StrideServerArenaThirtyTwoRankingViewOwner["TagBtnTap"] = TagBtnTap

-- 刷新按钮回调
local function RefreshClicked()
    local function Callback(url, rtnData)
        ssaData.data = rtnData.info
        refreshData()
    end
    doActionFun("CROSSSERVERBATTLE_BUYFLUSHENEMY", {}, Callback)
end
StrideServerArenaThirtyTwoRankingViewOwner["RefreshClicked"] = RefreshClicked

-- 返回按钮回调
local function BackHomeClicked()
    runtimeCache.SSAState = ssaDataFlag.home
    getStrideServerArenaLayer():changeState()
    print("home")
end
StrideServerArenaThirtyTwoRankingViewOwner["BackHomeClicked"] = BackHomeClicked

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/StrideServerArenaThirtyTwoRankingView.ccbi", proxy, true,"StrideServerArenaThirtyTwoRankingViewOwner")
    _layer = tolua.cast(node,"CCLayer")
    refreshData()
end

-- 该方法名字每个文件不要重复
function getStrideServerArenaThirtyTwoRankingLayer()
    return _layer
end

function createStrideServerArenaThirtyTwoRankingLayer()
    _init()
    local function _onEnter()
        
    end
    local function _onExit()
        _layer = nil
        progress = nil
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