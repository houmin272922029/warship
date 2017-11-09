local _layer
local _currentTag
local _tableView

local _rankArray
local _playerScore
local _fightCount
local _fightIdx

local _exchangeArray
local _recordsArray

local _bNetwork
local lastAdvantureOfCell
local _data
local progress
local cellArray = {}

-- ·名字不要重复
SSAPointsRaceRankingViewOwner = SSAPointsRaceRankingViewOwner or {}
ccb["SSAPointsRaceRankingViewOwner"] = SSAPointsRaceRankingViewOwner

SSAPointsRaceRankingCellOwner = SSAPointsRaceRankingCellOwner or {}
ccb["SSAPointsRaceRankingCellOwner"] = SSAPointsRaceRankingCellOwner
-- 返回按钮回调
local function BackClicked()
    runtimeCache.SSAState = ssaDataFlag.home
    getMainLayer():gotoAdventure()
end
SSAPointsRaceRankingViewOwner["BackClicked"] = BackClicked

-- 添加tableview
local function _addTableView()
    local containLayer = tolua.cast(SSAPointsRaceRankingViewOwner["containLayer"],"CCLayer")
    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(620, 180)
        elseif fn == "cellAtIndex" then
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            --单条数据
            local  _hbCell 
            local  proxy = CCBProxy:create()
            local  _hbCell  = tolua.cast(CCBReaderLoad("ccbResources/SSAPointsRaceRankingCell.ccbi",proxy,true,"SSAPointsRaceRankingCellOwner"),"CCLayer")
            local dic = _data.data.enemys[tostring(a1)]
            local fightItem = tolua.cast(SSAPointsRaceRankingCellOwner["fightItem"], "CCMenuItemImage")
            fightItem:setTag(a1 + 1)
            local fightText = tolua.cast(SSAPointsRaceRankingCellOwner["fightText"], "CCSprite")
            local rewardLabel = tolua.cast(SSAPointsRaceRankingCellOwner["rewardLabel"], "CCLabelTTF")
            --name level scoreLabel
            local name = tolua.cast(SSAPointsRaceRankingCellOwner["name"], "CCLabelTTF")
            local level = tolua.cast(SSAPointsRaceRankingCellOwner["level"], "CCLabelTTF")
            local scoreLabel = tolua.cast(SSAPointsRaceRankingCellOwner["scoreLabel"], "CCLabelTTF")
            name:setString(dic.battleData.name)
            level:setString('Lv' .. dic.battleData.level)
            scoreLabel:setString(ConfigureStorage.crossDual_score[tonumber(dic.rankId) + 1].name)
            if dic.isWin == true then
                fightItem:setVisible(false)
                fightText:setVisible(false)
                rewardLabel:setVisible(true)
            end
            for i=1,3 do
                if dic.battleData.heros  and dic.battleData.heros[dic.battleData.form[tostring(i - 1)]] then 
                    local hero = dic.battleData.heros[dic.battleData.form[tostring(i - 1)]]
                    local heroId = hero.heroId
                    local conf = herodata:getHeroConfig(heroId)
                    if conf then
                        local frame = tolua.cast(SSAPointsRaceRankingCellOwner["frame" .. i], "CCSprite") 
                        local head = tolua.cast(SSAPointsRaceRankingCellOwner["head" .. i], "CCSprite")
                        local colorSprite = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", herodata:fixRank(conf.rank, hero.wake)))
                        local f = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(herodata:getHeroHeadByHeroId(heroId))
                        if f then
                            head:setVisible(true)
                            frame:setVisible(true)
                            head:setDisplayFrame(f)
                            frame:setDisplayFrame(colorSprite)
                        end
                    end      
                end
                
            end
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            a2:addChild(_hbCell, 0, 1)
            cellArray[tostring(a1)] = _hbCell
            r = a2
        elseif fn == "numberOfCells" then
            -- r = #_data
            --tabelview中cell的行数
            r = getMyTableCount(_data.data.enemys)
        elseif fn == "cellTouched" then         -- A cell was touched, a1 is cell that be touched. This is not necessary.
        elseif fn == "cellTouchBegan" then      -- A cell is touching, a1 is cell, a2 is CCTouch
        elseif fn == "cellTouchEnded" then      -- A cell was touched, a1 is cell, a2 is CCTouch
        elseif fn == "cellHighlight" then       -- A cell is highlighting, coco2d-x 2.1.3 or above
        elseif fn == "cellUnhighlight" then     -- A cell had been unhighlighted, coco2d-x 2.1.3 or above
        elseif fn == "cellWillRecycle" then     -- A cell will be recycled, coco2d-x 2.1.3 or above
        end
        return r
    end)
    local size = CCSizeMake(containLayer:getContentSize().width, containLayer:getContentSize().height)  -- 这里是为了在tableview上面显示一个小空出来
    _tableView = LuaTableView:createWithHandler(h, size)
    _tableView:setBounceable(true)
    _tableView:setAnchorPoint(ccp(0,0))
    _tableView:setPosition(0,0)
    _tableView:setVerticalFillOrder(0)
    containLayer:addChild(_tableView,1000)
end

local function _updateEnergy()

    local proLabel = tolua.cast(SSAPointsRaceRankingViewOwner["proLabel"], "CCLabelTTF")
    local progressBg = tolua.cast(SSAPointsRaceRankingViewOwner["proBg"], "CCSprite")
    proLabel:setString(string.format("%d/%d", userdata.energy, userdata:getEnergyMax()))
    proLabel:setZOrder(1)
    if not progress then
        progress = CCProgressTimer:create(CCSprite:create("images/grePro_refine.png"))
        progress:setScale(retina)
        progress:setType(kCCProgressTimerTypeBar)
        progress:setMidpoint(CCPointMake(0, 0))
        progress:setBarChangeRate(CCPointMake(1, 0))
        local x, y = progressBg:getPosition()
        progress:setPosition(x, y)
        progressBg:getParent():addChild(progress, 0, 1)
    end
    progress:setPercentage(math.min(userdata.energy / userdata:getEnergyMax() * 100, 100))
    
end
function SSARankingrefresh()
    _data = ssaData.data
    local UserNextTitle = tolua.cast(SSAPointsRaceRankingViewOwner["UserNextTitle"], "CCLabelTTF")
    UserNextTitle:setString(HLNSLocalizedString("SSA.UserNextTitle", ConfigureStorage.crossDual_score[tonumber(_data.rankId)].name))
   
    local ChallengeCount = tolua.cast(SSAPointsRaceRankingViewOwner["ChallengeCount"], "CCLabelTTF")
    ChallengeCount:setString(HLNSLocalizedString("SSA.ChallengeCount") .. (ConfigureStorage.crossDual_sundry.pkTime - _data.data.fightCount) .. '/' .. ConfigureStorage.crossDual_sundry.pkTime)
    local FreeLable = tolua.cast(SSAPointsRaceRankingViewOwner["FreeLable"], "CCLabelTTF")
    local CostLable = tolua.cast(SSAPointsRaceRankingViewOwner["CostLable"], "CCLabelTTF")
    local iconSprite = tolua.cast(SSAPointsRaceRankingViewOwner["iconSprite"], "CCSprite")
    if _data.data.flushEnemyCount == 0 then
        FreeLable:setVisible(true)
    elseif  _data.data.flushEnemyCount + 1 >= getMyTableCount(ConfigureStorage.crossDual_refresh2) then
         FreeLable:setVisible(false)
         CostLable:setVisible(true)
         CostLable:setString(ConfigureStorage.crossDual_refresh2[tostring(getMyTableCount(ConfigureStorage.crossDual_refresh2))].cost)
         iconSprite:setVisible(true)
    else
         FreeLable:setVisible(false)
         CostLable:setVisible(true)
         PrintTable(ConfigureStorage.crossDual_refresh2[tostring(_data.data.flushEnemyCount + 1)])
         CostLable:setString(ConfigureStorage.crossDual_refresh2[tostring(_data.data.flushEnemyCount + 1)].cost)
         iconSprite:setVisible(true)
    end
    _updateEnergy()
    if tonumber(getMyTableCount(_data.data.enemys)) == 0 then
         if _tableView then 
            _tableView:removeFromParentAndCleanup(true)  --清除tableview
            _tableView = nil
        end
    else
        if _tableView then 
            _tableView:reloadData()
        else
            _addTableView()
        end
    end
end

--服务器发送成功回调
local function arenaFightCallback(url, rtnData)
    runtimeCache.responseData = rtnData["info"]
    ssaData.data = rtnData.info
    CCDirector:sharedDirector():replaceScene(CCTransitionFade:create(0.6, FightingScene())) 
end
-- 挑战按钮回调 跨服战 
local function fightItemClick(tag)
    if _data.data.fightCountBuy >= getMyTableCount(ConfigureStorage.crossDual_buyFight) then
        payCount = ConfigureStorage.crossDual_buyFight[tostring(getMyTableCount(ConfigureStorage.crossDual_buyFight))].cost
    else
        payCount = ConfigureStorage.crossDual_buyFight[tostring(_data.data.fightCountBuy + 1)].cost
    end
     --确定购买并使用普通挑战
    local function FightConfirmClick()
        local function Callback(url, rtnData)
            ssaData.data = rtnData.info
            local index = tag 
            RandomManager.cursor = RandomManager.randomRange(0, 999)
            local seed = RandomManager.cursor
            local battleData = _data.data.enemys[tostring(index - 1)].battleData
            playerBattleData:fromDic(battleData)
            BattleField.leftName = userdata.name
            BattleField.rightName = battleData.name
            local buff = nil
            local oppoBuff =nil
            BattleField:SSAFight(buff, oppoBuff)
            local result = BattleField.result == RESULT_WIN and 4 - BattleField.round or 0  --传入0 1 2 3 四中状态
            doActionFun("CROSSSERVERBATTLE_FIGHT", {result, _data.data.enemys[tostring(index - 1)].id, 0}, arenaFightCallback)
        end
        local times = 5
        doActionFun("CROSSSERVERBATTLE_BUYFIGHTCOUNT", {times}, Callback)   
    end
    
    if _data.data.fightCount < ConfigureStorage.crossDual_sundry.pkTime then
        local index = tag 
        RandomManager.cursor = RandomManager.randomRange(0, 999)
        local seed = RandomManager.cursor
        local battleData = _data.data.enemys[tostring(index - 1)].battleData
        playerBattleData:fromDic(battleData)
        BattleField.leftName = userdata.name
        BattleField.rightName = battleData.name
        local buff = nil
        local oppoBuff =nil
        BattleField:SSAFight(buff, oppoBuff)
        local result = BattleField.result == RESULT_WIN and 4 - BattleField.round or 0  --传入0 1 2 3 四中状态
        doActionFun("CROSSSERVERBATTLE_FIGHT", {result, _data.data.enemys[tostring(index - 1)].id, 0}, arenaFightCallback)
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
SSAPointsRaceRankingCellOwner["fightItemClick"] = fightItemClick

-- 刷新按钮回调
local function RefreshClicked()
    
    local function Callback(url, rtnData)
        ssaData.data = rtnData.info
        SSARankingrefresh()
        postNotification(NOTI_WW_REFRESH, nil)
        generateCellAction(cellArray,getMyTableCount(_data.data.enemys))
        cellArray = {} 
    end
    doActionFun("CROSSSERVERBATTLE_BUYFLUSHENEMY", {}, Callback)
end
SSAPointsRaceRankingViewOwner["RefreshClicked"] = RefreshClicked

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
                SSARankingrefresh()
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
SSAPointsRaceRankingViewOwner["addItemClick"] = addItemClick

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/SSAPointsRaceRankingView.ccbi",proxy, true,"SSAPointsRaceRankingViewOwner")
    _layer = tolua.cast(node,"CCLayer")
    SSARankingrefresh()
end

-- 该方法名字每个文件不要重复
function getSSAPointsRaceRankingViewLayer()
	return _layer
end

function createSSAPointsRaceRankingViewLayer()
    _init()
    local function _onEnter()
       addObserver(NOTI_WW_REFRESH, SSARankingrefresh)
       addObserver(NOTI_ENERGY, _updateEnergy)
    end
    local function _onExit()
        _layer = nil
        _tableView = nil
        _rankArray = nil
        _playerScore = 0
        _fightCount = 0
        _fightIdx = 0
        _exchangeArray = nil
        _recordsArray = nil
        _bNetwork = false
        _data = nil
        progress = nil
        removeObserver(NOTI_WW_REFRESH, SSARankingrefresh)
        removeObserver(NOTI_ENERGY, _updateEnergy)
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