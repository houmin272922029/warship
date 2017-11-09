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

ArenaTag = {
    arena = 1,
    award = 2,
}

local RankType = {
    View = 0, -- 查看阵容
    Normal = 1, -- 普通攻击
    Counter = 2, -- 反击
    None = 3, -- 无按钮
    Info = 4, -- 玩家信息
}

-- ·名字不要重复
ArenaViewOwner = ArenaViewOwner or {}
ccb["ArenaViewOwner"] = ArenaViewOwner

ArenaInfoCellOwner = ArenaInfoCellOwner or {}
ccb["ArenaInfoCellOwner"] = ArenaInfoCellOwner

ArenaEnemyCellOwner = ArenaEnemyCellOwner or {}
ccb["ArenaEnemyCellOwner"] = ArenaEnemyCellOwner

ArenaAwardCellOwner = ArenaAwardCellOwner or {}
ccb["ArenaAwardCellOwner"] = ArenaAwardCellOwner

local function arenaFightCallback(url, rtnData)
    runtimeCache.responseData = rtnData["info"]
    CCDirector:sharedDirector():replaceScene(CCTransitionFade:create(0.6, FightingScene())) 
    -- local resultType = ResultType.SailWin
    -- local bWin = BattleField.result == RESULT_WIN
    -- if bWin then
    --     resultType = ResultType.SailWin
    -- else
    --     resultType = ResultType.SailLose
    -- end
    -- CCDirector:sharedDirector():replaceScene(CCTransitionFade:create(0.6, FightingResultSceneFun(resultType)))
end

local function getBattleInfoCallback(url, rtnData)
    RandomManager.cursor = RandomManager.randomRange(0, 999)
    local seed = RandomManager.cursor
    playerBattleData:fromDic(rtnData.info)
    BattleField.leftName = userdata.name
    BattleField.rightName = rtnData.info.name
    BattleField:arenaFight()
    -- BattleField.result = RESULT_LOSE
    local result = BattleField.result == RESULT_WIN and 4 - BattleField.round or 0
    local enemy = _rankArray[_fightIdx]
    doActionFun("ARENA_BATTLE", {enemy.id, enemy.rank, result, seed}, arenaFightCallback)
end

local function fightItemClick(tag)
    print("fightItemClick", tag)
    Global:instance():TDGAonEventAndEventData("challenge")
    if _fightCount <= 0 then
        _layer:getParent():addChild(createBuyAndUseLayer("item_003", HLNSLocalizedString("arena.fightCount.need"), -150), 100)
        _bNetwork = true
        return
    end
    _fightIdx = tag
    doActionFun("ARENA_GET_BATTLE_INFO", {_rankArray[tag].id}, getBattleInfoCallback)
end

local function arenaMenuClick( tag ,sender )
    -- body
    print("tag = ",tag)
    local dic = _rankArray[tag]
    if dic.type ~= RankType.Info then
        if getMainLayer() then
            getMainLayer():addChild(createArenaMenu(dic))
        end
    end
end

ArenaEnemyCellOwner["fightItemClick"] = fightItemClick
ArenaEnemyCellOwner["arenaMenuClick"] = arenaMenuClick

local function viewBattleInfo(url, rtnData)
    playerBattleData:fromDic(rtnData.info)
    -- getMainLayer():getParent():addChild(createTeamCompLayer(userdata:getUserBattleInfo(), playerBattleData), 100)
    getMainLayer():getParent():addChild(createTeamPopupLayer(-140))
end

local function viewItemClick(tag)
    print("viewItemClick", tag)
    Global:instance():TDGAonEventAndEventData("check")
    doActionFun("ARENA_GET_BATTLE_INFO", {_rankArray[tag].id}, viewBattleInfo)
end
ArenaEnemyCellOwner["viewItemClick"] = viewItemClick

local function getArenaScoreCallback(url, rtnData)
    _playerScore = rtnData.info.score

    local playerScore = tolua.cast(ArenaInfoCellOwner["playerScore"], "CCLabelTTF")
    local playerScore_s = tolua.cast(ArenaInfoCellOwner["playerScore_s"], "CCLabelTTF")
    if playerScore then
        playerScore:setString(HLNSLocalizedString("arena.score", _playerScore))
    end
    if playerScore_s then
        playerScore_s:setString(HLNSLocalizedString("arena.score", _playerScore))
    end
end

local function refreshItemClick()
    print("refreshItemClick")
    Global:instance():TDGAonEventAndEventData("refresh")
    doActionFun("ARENA_GET_SCORE", {}, getArenaScoreCallback)
end
ArenaInfoCellOwner["refreshItemClick"] = refreshItemClick
ArenaViewOwner["refreshItemClick"] = refreshItemClick

local function _updateTab(sender, sel)
    local item = tolua.cast(sender, "CCMenuItemImage")
    if sel then
        item:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_1.png"))
    else
        item:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_0.png"))
    end 
end

-- 添加排名
local function addRankTableView()
    local _topLayer = ArenaViewOwner["TopLayer"]
    local despLayer = ArenaViewOwner["despLayer1"]

    -- @param fn string Callback type
    -- @param table LuaTableView
    -- @param a1 & a2 mixed Difference means for every "fn"
    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(winSize.width, 175 * retina)
        elseif fn == "cellAtIndex" then
            local dic = _rankArray[a1 + 1]
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end

            -- renzhan
            for i,v in ipairs(_rankArray) do
                if v.type == RankType.Info then
                    lastAdvantureOfCell = i
                end        
            end 
            -- 

            local  proxy = CCBProxy:create()
            local  _cell
            local owner
            if dic.type == RankType.Info then
                _cell = tolua.cast(CCBReaderLoad("ccbResources/ArenaInfoCell.ccbi",proxy,true,"ArenaInfoCellOwner"),"CCLayer")
                owner = ArenaInfoCellOwner
                local playerScore = tolua.cast(owner["playerScore"], "CCLabelTTF")
                local playerScore_s = tolua.cast(owner["playerScore_s"], "CCLabelTTF")
                playerScore:setString(HLNSLocalizedString("arena.score", _playerScore))
                playerScore_s:setString(HLNSLocalizedString("arena.score", _playerScore))
                local infoLabel = tolua.cast(owner["infoLabel"], "CCLabelTTF")
                local infoLabel_s = tolua.cast(owner["infoLabel_s"], "CCLabelTTF")
                infoLabel:setString(string.format(infoLabel:getString(), dic.awardScore))
                infoLabel_s:setString(string.format(infoLabel_s:getString(), dic.awardScore))
            else
                _cell = tolua.cast(CCBReaderLoad("ccbResources/ArenaEnemyCell.ccbi",proxy,true,"ArenaEnemyCellOwner"),"CCLayer")
                owner = ArenaEnemyCellOwner
                local arenaMenu = tolua.cast(owner["arenaMenu"], "CCMenuItemImage")
                arenaMenu:setTag(a1 + 1)
                for i=0,2 do
                    if dic.heros[tostring(i)] then
                        local heroId = dic.heros[tostring(i)].heroId
                        local herowake = dic.heros[tostring(i)].wake
                        if heroId == nil then
                            heroId = dic.heros[tostring(i)]
                        end
                        --print(heroId,herowake)
                        local conf = herodata:getHeroConfig(heroId,herowake)
                        if conf then
                            local frame = tolua.cast(owner["frame"..(i + 1)], "CCSprite")
                            local head = tolua.cast(owner["head"..(i + 1)], "CCSprite")
                            frame:setVisible(true)
                            frame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", conf.rank)))
                            local f = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(herodata:getHeroHeadByHeroId(heroId))
                            if f then
                                head:setVisible(true)
                                head:setDisplayFrame(f)
                            end
                        end
                    end
                end
                if dic.type == RankType.View then
                    local viewItem = tolua.cast(owner["viewItem"], "CCMenuItemImage")
                    viewItem:setVisible(true)
                    local viewText = tolua.cast(owner["viewText"], "CCSprite")
                    viewText:setVisible(true)
                    viewItem:setTag(a1 + 1)
                else
                    local fightItem = tolua.cast(owner["fightItem"], "CCMenuItemImage")
                    if dic.type ~= RankType.None then
                        fightItem:setVisible(true)
                    end
                    if dic.type == RankType.Normal then
                        local fightText = tolua.cast(owner["fightText"], "CCSprite")
                        fightText:setVisible(true)
                    elseif dic.type == RankType.Counter then
                        local fightText = tolua.cast(owner["fightText"], "CCSprite")
                        fightText:setVisible(true)
                    end
                    fightItem:setTag(a1 + 1)
                    -- renzhan
                    if a1 == lastAdvantureOfCell - 2 and userdata.level == 5 then
                        local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
                        cache:addSpriteFramesWithFile("ccbResources/treasureCard.plist")
                        local light = CCSprite:createWithSpriteFrameName("treasureCard_roundFrame_1.png")
                        light:setScale(1.1)
                        local animFrames = CCArray:create()
                        for j = 1, 3 do
                            local frameName = string.format("treasureCard_roundFrame_%d.png",j)
                            local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(frameName)
                            animFrames:addObject(frame)
                        end
                        local animation = CCAnimation:createWithSpriteFrames(animFrames, 0.2)
                        local animate = CCAnimate:create(animation)
                        light:runAction(CCRepeatForever:create(animate))
                        fightItem:addChild(light)
                        light:setPosition(ccp(fightItem:getContentSize().width / 2,fightItem:getContentSize().height / 2))
                    end
                    -- 
                    
                end
            end
 
            local name = tolua.cast(owner["name"], "CCLabelTTF")
            name:setString(dic.name)

            local rank = dic.rank
            local grade = 1
            local tmpRank = rank
            while true do
                if math.floor(tmpRank / 10) == 0 then
                    break
                end
                grade = grade + 1
                if grade == 5 then
                    break
                end
                tmpRank = math.floor(tmpRank / 10)
            end
            local rankLabel = tolua.cast(owner["rank"..grade], "CCLabelTTF")
            rankLabel:setString(tostring(rank))
            rankLabel:setVisible(true)

            local level = dic.level
            if not level then
                level = userdata.level
            end
            local levelLabel = tolua.cast(owner["level"], "CCLabelTTF")
            if isPlatform(IOS_INFIPLAY_RUS) or isPlatform(ANDROID_INFIPLAY_RUS) then
                levelLabel:setString(string.format("Ур. %d", level))
            else
                levelLabel:setString(string.format("LV %d", level))
            end

            local scoreLabel = tolua.cast(owner["scoreLabel"], "CCLabelTTF")
            scoreLabel:setString(HLNSLocalizedString("arena.rankScore", dic.awardScore))

            _cell:setAnchorPoint(ccp(0.5, 0.5))
            _cell:setPosition(winSize.width/2, 175 * retina/2)
            _cell:setScale(retina)
            a2:addChild(_cell, 0, 1)

            r = a2
        elseif fn == "numberOfCells" then
            -- Return number of cells
            r = #_rankArray
        -- Cell events:
        elseif fn == "cellTouched" then
            
        elseif fn == "cellTouchBegan" then      -- A cell is touching, a1 is cell, a2 is CCTouch
        elseif fn == "cellTouchEnded" then      -- A cell was touched, a1 is cell, a2 is CCTouch
        elseif fn == "cellHighlight" then       -- A cell is highlighting, coco2d-x 2.1.3 or above
        elseif fn == "cellUnhighlight" then     -- A cell had been unhighlighted, coco2d-x 2.1.3 or above
        elseif fn == "cellWillRecycle" then     -- A cell will be recycled, coco2d-x 2.1.3 or above
        end
        return r
    end)
    
    local _mainLayer = getMainLayer()
    if _mainLayer then
        local size = CCSizeMake(winSize.width, (winSize.height - _topLayer:getContentSize().height - _mainLayer:getBottomContentSize().height) - despLayer:getContentSize().height * retina)      -- 这里是为了在tableview上面显示一个小空出来
        _tableView = LuaTableView:createWithHandler(h, size)
        _tableView:setBounceable(true)
        _tableView:setAnchorPoint(ccp(0,0))
        _tableView:setPosition(ccp(0, _mainLayer:getBottomContentSize().height))
        _tableView:setVerticalFillOrder(0)
        _layer:addChild(_tableView)
    end

    local function _refreshOffset()
        local height = (winSize.height - _topLayer:getContentSize().height - _mainLayer:getBottomContentSize().height) - despLayer:getContentSize().height * retina
        for i,v in ipairs(_rankArray) do
            if v.type == RankType.Info then
                _tableView:setContentOffset(ccp(0, math.max(-175 * retina * (#_rankArray - i), -175 * retina * #_rankArray + height)))
                break
            end        
        end 
    end
    _refreshOffset()
end

-- 添加奖励
local function addAwardTableView()
    local _topLayer = ArenaViewOwner["TopLayer"]
    local despLayer = ArenaViewOwner["despLayer2"]

    -- @param fn string Callback type
    -- @param table LuaTableView
    -- @param a1 & a2 mixed Difference means for every "fn"
    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(winSize.width, 170 * retina)
        elseif fn == "cellAtIndex" then
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            
            local  proxy = CCBProxy:create()
            local  _cell = tolua.cast(CCBReaderLoad("ccbResources/ArenaAwardCell.ccbi",proxy,true,"ArenaAwardCellOwner"),"CCLayer")
            if a1 < #_exchangeArray then
                local dic = _exchangeArray[a1 + 1]
                local heroId = dic.head
                local conf = herodata:getHeroConfig(heroId)

                local exchangeItem = tolua.cast(ArenaAwardCellOwner["exchangeItem"], "CCMenuItemImage")
                exchangeItem:setVisible(true)
                local exchangeText = tolua.cast(ArenaAwardCellOwner["exchangeText"], "CCSprite")
                exchangeText:setVisible(true)
                exchangeItem:setTag(a1 + 1)

                local frame = tolua.cast(ArenaAwardCellOwner["frame"], "CCSprite")
                frame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", conf.rank)))
                local head = tolua.cast(ArenaAwardCellOwner["hero"], "CCSprite")
                local f = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(herodata:getHeroHeadByHeroId(heroId))
                if f then
                    head:setVisible(true)
                    head:setDisplayFrame(f)
                end

                local awardName = tolua.cast(ArenaAwardCellOwner["awardName"], "CCLabelTTF")
                awardName:setString(dic.name)
                local scoreLabel = tolua.cast(ArenaAwardCellOwner["scoreLabel"], "CCLabelTTF")
                scoreLabel:setString(HLNSLocalizedString("arena.exchange", dic.cost))
                local despLabel = tolua.cast(ArenaAwardCellOwner["despLabel"], "CCLabelTTF")
                despLabel:setString(dic.text)

            else
                local dic = _recordsArray[a1 - #_exchangeArray + 1]
                local itemId
                local count
                for k,v in pairs(dic.gain) do
                    itemId = k
                    count = v
                end
                local awardItem = tolua.cast(ArenaAwardCellOwner["awardItem"], "CCMenuItemImage")
                awardItem:setVisible(true)
                awardItem:setEnabled(dic.state == 1)
                local awardText = tolua.cast(ArenaAwardCellOwner["awardText"], "CCSprite")
                awardText:setVisible(true)
                awardItem:setTag(a1 - #_exchangeArray + 1)

                local conf = wareHouseData:getItemResource(itemId)
                local frame = tolua.cast(ArenaAwardCellOwner["frame"], "CCSprite")
                frame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", conf.rank)))
                local icon = tolua.cast(ArenaAwardCellOwner["icon"], "CCSprite")
                icon:setVisible(true)
                icon:setTexture(CCTextureCache:sharedTextureCache():addImage(conf.icon))

                local awardName = tolua.cast(ArenaAwardCellOwner["awardName"], "CCLabelTTF")
                awardName:setString(string.format("%d%s", count, ConfigureStorage.item[itemId].name))
                local scoreLabel = tolua.cast(ArenaAwardCellOwner["scoreLabel"], "CCLabelTTF")
                scoreLabel:setString(HLNSLocalizedString("arena.exchange", 0))
                local despLabel = tolua.cast(ArenaAwardCellOwner["despLabel"], "CCLabelTTF")
                despLabel:setString(dic.text)
            end

            _cell:setAnchorPoint(ccp(0.5, 0.5))
            _cell:setPosition(winSize.width/2, 170 * retina/2)
            _cell:setScale(retina)
            a2:addChild(_cell, 0, 1)

            r = a2
        elseif fn == "numberOfCells" then
            -- Return number of cells
            r = #_exchangeArray + #_recordsArray
        -- Cell events:
        elseif fn == "cellTouched" then
        elseif fn == "cellTouchBegan" then      -- A cell is touching, a1 is cell, a2 is CCTouch
        elseif fn == "cellTouchEnded" then      -- A cell was touched, a1 is cell, a2 is CCTouch
        elseif fn == "cellHighlight" then       -- A cell is highlighting, coco2d-x 2.1.3 or above
        elseif fn == "cellUnhighlight" then     -- A cell had been unhighlighted, coco2d-x 2.1.3 or above
        elseif fn == "cellWillRecycle" then     -- A cell will be recycled, coco2d-x 2.1.3 or above
        end
        return r
    end)
    
    local _mainLayer = getMainLayer()
    if _mainLayer then
        local size = CCSizeMake(winSize.width, (winSize.height - _topLayer:getContentSize().height - _mainLayer:getBottomContentSize().height) - despLayer:getContentSize().height * retina)      -- 这里是为了在tableview上面显示一个小空出来
        _tableView = LuaTableView:createWithHandler(h, size)
        _tableView:setBounceable(true)
        _tableView:setAnchorPoint(ccp(0,0))
        _tableView:setPosition(ccp(0, _mainLayer:getBottomContentSize().height))
        _tableView:setVerticalFillOrder(0)
        _layer:addChild(_tableView)
    end

end

local function getArenaRecordsCallback(url,rtnData)
    arenadata.records = rtnData.info
    _exchangeArray = arenadata:getExchangeAward()
    _recordsArray = arenadata:getRecordAward()
    addAwardTableView()
end

local function _refreshData()
    if _tableView then
        _tableView:removeFromParentAndCleanup(true)
        _tableView = nil
    end
    local despLayer1 = tolua.cast(ArenaViewOwner["despLayer1"], "CCLayer")
    local despLayer2 = tolua.cast(ArenaViewOwner["despLayer2"], "CCLayer")
    local refreshItem = tolua.cast(ArenaViewOwner["refreshItem"], "CCMenuItemImage")
    if _currentTag == ArenaTag.arena then
        _updateTab(ArenaViewOwner["arenaItem"], true)
        _updateTab(ArenaViewOwner["awardItem"], false)
        despLayer1:setVisible(true)
        despLayer2:setVisible(false)
        refreshItem:setVisible(false)
        addRankTableView()
        local rankLabel = tolua.cast(ArenaViewOwner["rankLabel"], "CCLabelTTF")
        for i,dic in ipairs(_rankArray) do
            if dic.type == RankType.Info then
                rankLabel:setString(HLNSLocalizedString("arena.rank", dic.rank))
                break
            end
        end
        local countLabel = tolua.cast(ArenaViewOwner["countLabel"], "CCLabelTTF")
        countLabel:setString(HLNSLocalizedString("arena.fightCount", _fightCount))
    else
        _updateTab(ArenaViewOwner["arenaItem"], false)
        _updateTab(ArenaViewOwner["awardItem"], true)
        despLayer1:setVisible(false)
        despLayer2:setVisible(true)
        refreshItem:setVisible(true)
        local scoreLabel = tolua.cast(ArenaViewOwner["scoreLabel"], "CCLabelTTF")
        scoreLabel:setString(HLNSLocalizedString("arena.score", _playerScore))
        doActionFun("ARENA_GET_RECORDS", {}, getArenaRecordsCallback)
    end
end

local function stirThePotAction(  )
    -- body
    local bg = CCLayerColor:create(ccc4(0,0,0,255))
    getMainLayer():addChild(bg)
    bg:setPosition(ccp(0,0))

    ChopperStiring_LayerOwner = ChopperStiring_LayerOwner or {}
    ccb["ChopperStiring_LayerOwner"] = ChopperStiring_LayerOwner

    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/chopperStiring.ccbi",proxy,true,"ChopperStiring_LayerOwner")
    bg:addChild(node)
    node:setPosition(0, 0)

    local function onTouchBegan(x, y)
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
    bg:registerScriptTouchHandler(onTouch ,false ,-145 ,true )
    bg:setTouchEnabled(true)

    local function flashAction(  ) 
        HLAddParticleScale( "images/eff_page_723_1.plist", bg, ccp(winSize.width/2, winSize.height/2 - 70), 1, 1, -1,1,1)
        HLAddParticleScale( "images/eff_page_723_2.plist", bg, ccp(winSize.width/2, winSize.height/2), 1, 1, -1,1,1)
    end 

    local function removeNode(  ) 
        node:stopAllActions()
        node:removeFromParentAndCleanup(true)
    end 

    local function showTableView(  )    
        bg:removeFromParentAndCleanup(true)
        userdata:popUpGain(runtimeCache.responseData["gain"], true)
    end 

    local action = CCArray:create()
    action:addObject(CCDelayTime:create(2))
    action:addObject(CCCallFunc:create(flashAction))
    action:addObject(CCDelayTime:create(0.3))
    action:addObject(CCCallFunc:create(removeNode))
    action:addObject(CCDelayTime:create(1))
    action:addObject(CCCallFunc:create(showTableView))
    local seq = CCSequence:create(action)
    bg:runAction(seq)
end 

local function exchangeCallback(url, rtnData)
    runtimeCache.responseData = rtnData.info
    -- TODO 动画效果
    _playerScore = _playerScore - rtnData.info.pay.arenaScore
    _refreshData()

    stirThePotAction()
end

local function exchangeItemClick(tag)
    print("exchangeItemClick", tag)
    Global:instance():TDGAonEventAndEventData("exchange"..tag+1)
    if _playerScore < _exchangeArray[tag].cost then
        ShowText(HLNSLocalizedString("arena.needScore"))
        return
    end
    doActionFun("ARENA_EXCHANGE", {tag - 1}, exchangeCallback)
end
ArenaAwardCellOwner["exchangeItemClick"] = exchangeItemClick

local function getAwardCallback(url, rtnData)
    runtimeCache.responseData = rtnData.info
    _refreshData()
    stirThePotAction()
end

local function awardItemClick(tag)
    print("awardItemClick", tag)
    Global:instance():TDGAonEventAndEventData("exchange"..tag+3)
    doActionFun("ARENA_GET_AWARD", {_recordsArray[tag].id}, getAwardCallback)
end
ArenaAwardCellOwner["awardItemClick"] = awardItemClick

local function tabClick(tag)
    Global:instance():TDGAonEventAndEventData("exchange")
    if _currentTag == tag then
        return
    end
    _currentTag = tag
    _refreshData()
end
ArenaViewOwner["tabClick"] = tabClick

local function menuEnabled(enable)
    local menu = tolua.cast(ArenaViewOwner["menu"], "CCMenu")
    menu:setTouchEnabled(enable)
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/ArenaView.ccbi",proxy, true,"ArenaViewOwner")
    _layer = tolua.cast(node,"CCLayer")
    menuEnabled(false)
end

local function getRankInfoCallback(url, rtnData)
    _bNetwork = false
    _rankArray = {}
    _playerScore = rtnData.info.score
    _fightCount = rtnData.info.arenaTimes
    local rankInfo = rtnData.info.rankInfo
    for i=0,table.getTableCount(rankInfo) do
        if rankInfo[tostring(i)] then
            table.insert(_rankArray, rankInfo[tostring(i)])
        end
    end
    local function sortFun(a, b)
        return a.rank < b.rank 
    end
    PrintTable(_rankArray)
    table.sort(_rankArray, sortFun)
    _refreshData()
end

local function _updateArena()
    if _currentTag ~= ArenaTag.arena then
        return
    end
    menuEnabled(true)
    if not _bNetwork then
        doActionFun("ARENA_GET_RANK_INFO", {}, getRankInfoCallback)
        _bNetwork = true
    end
end

-- 该方法名字每个文件不要重复
function getArenaLayer()
	return _layer
end

function createArenaLayer()
    _init()

    function _layer:updateArena()
        _bNetwork = false
        _updateArena()
    end

    local function _onEnter()
        if not _currentTag then
            _currentTag = ArenaTag.arena
        end
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(_updateArena))
        _layer:runAction(seq)
        addObserver(NOTI_ARENA, _updateArena)
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
        _currentTag = nil
        removeObserver(NOTI_ARENA, _updateArena)
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