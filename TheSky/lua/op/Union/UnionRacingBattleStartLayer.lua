local _layer
local _tableView
local unionShopDatada
local _data
local _bNetwork
local _logs = {}

UnionRacingBattleStartViewOwner = UnionRacingBattleStartViewOwner or {}
ccb["UnionRacingBattleStartViewOwner"] = UnionRacingBattleStartViewOwner

--返回
local function onExitTaped(  )   
    getUnionMainLayer():gotoRacingBattle()
end
UnionRacingBattleStartViewOwner["onExitTaped"] = onExitTaped

local function arenaFightCallback(url, rtnData)

    runtimeCache.responseData = rtnData["info"]
    runtimeCache.UnionRacingBattle_BeginTime = os.time()
    CCDirector:sharedDirector():replaceScene(CCTransitionFade:create(0.6, FightingScene()))
end

local function errorCallback(rtnData , code)
    
    getUnionMainLayer():gotoRacingBattleStart()
end

-- 战
local function fightBtnTaped()
    if _data.bossData.curStep == "finish" then
        
        ShowText(HLNSLocalizedString("union.racingBattle.end"))

        getUnionMainLayer():gotoRacingBattle()
        return
    elseif _data.bossData.curStep == "step3" then
        if os.time() - runtimeCache.UnionRacingBattle_BeginTime < 15 then
            ShowText(HLNSLocalizedString("union.RacingBattle.fighting"))
            return
        end
        RandomManager.cursor = RandomManager.randomRange(0, 999)
        local seed = RandomManager.cursor
        local bossId = _data.bossData.step3_curBoss
        local level = _data.bossData.step3_level
        local hpMax = tonumber(_data.bossData.step3_totalBaseHp)
        local hp = tonumber(_data.bossData.step3_totalHp)
        local battleData = battledata:getRacingBattleBossInfo(bossId, level, hpMax, hp)
        
        BattleField.leftName = userdata.name
        BattleField.rightName = battleData[1].name
        local buff = {}
        if _data.before == 0 then -- 没有买buf
            buff = nil
        else
            
            buff = {atk = 20,def = 20,hp = 20,mp = 20,cri = 20,resi = 20,hit = 20,dod = 20,cnt = 20,parry = 20}
        end
        BattleField:racingBattleBossFight(bossId, level, hpMax, hp, buff)
        local damage = BattleField.damage.left
        -- print("type(damage)" , type(damage))
        -- print("type(hp)" , type(hp))
        -- if hp <= damage then
        --     runtimeCache.racingBattleStep = "step3"
        -- end
        local result = BattleField.result == RESULT_WIN and 4 - BattleField.round or 0  --传入0 1 2 3 四中状态
        doActionFun("CROSSSERVERRACEBATTLE_FIGHT", {result,_data.bossData.curStep,bossId,damage}, arenaFightCallback, errorCallback)
    else
        -- if os.time() - runtimeCache.UnionRacingBattle_BeginTime < 15 then
        --     ShowText("战斗准备中")
        --     print("嘿嘿",runtimeCache.UnionRacingBattle_BeginTime)
        -- else
            print("吼吼")
            RandomManager.cursor = RandomManager.randomRange(0, 999)
            local seed = RandomManager.cursor
            local battleData = battledata:getRacingBattleInfo(_data.bossData.curStep , _data.bossData.step1_level)
            BattleField.leftName = userdata.name
            BattleField.rightName = battleData[1].name
            local buff 
            if _data.before == 0 then -- 没有买buf
                buff = nil
            else
                buff = 20
            end
            BattleField:racingBattleFight(battleData, buff)
            local result = BattleField.result == RESULT_WIN and 4 - BattleField.round or 0  --传入0 1 2 3 四中状态
            doActionFun("CROSSSERVERRACEBATTLE_FIGHT", {result, _data.bossData.curStep}, arenaFightCallback, errorCallback)
            --runtimeCache.UnionRacingBattle_BeginTime = os.time()

        -- end
    end
end
UnionRacingBattleStartViewOwner["fightBtnTaped"] = fightBtnTaped

-- 站前准备
local function fightBeforeBtnTaped()    
    if _data.before == 0 then  -- 未使用战前准备
        local function ConfirmClick()
            local function callBack(url, rtnData)
 
                _data.before = 1
                local battleBeforeBtn = tolua.cast(UnionRacingBattleStartViewOwner["battleBeforeBtn"] , "CCMenuItemImage")
                battleBeforeBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn7_2.png"))
                battleBeforeBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn7_2.png"))
            end
            doActionFun("CROSSSERVERRACEBATTLE_BUYPREBEFORE",{},callBack)
        end
        local text = HLNSLocalizedString(HLNSLocalizedString("union.racingBattle.buyPreBefore"))
        CCDirector:sharedDirector():getRunningScene():addChild(createSimpleConfirCardLayer(text))
        SimpleConfirmCard.confirmMenuCallBackFun = ConfirmClick
        SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction 
    else
        ShowText(HLNSLocalizedString("union.racingBattleStart.buy")) 
    end
end
UnionRacingBattleStartViewOwner["fightBeforeBtnTaped"] = fightBeforeBtnTaped


local function getLogCallback(url, rtnData)
    racingBattleData:insertLog(rtnData.info.highLootList)
    racingBattleData.logTime = userdata.loginTime
end

local function getLog()
    if not racingBattleData.logTime or racingBattleData.logTime == 0 then
        racingBattleData.logTime = userdata.loginTime - 10
    end
    doActionNoLoadingFun("CROSSSERVERRACEBATTLE_REFERSHHIGHLOOTLIST", {racingBattleData.logTime}, getLogCallback)
    
end

local function readLog()
    local log = racingBattleData:popLog()
    -- print("1111111111111111111")
    -- PrintTable(log)
    for i,v in ipairs(log) do
        local logLabel = tolua.cast(UnionRacingBattleStartViewOwner["log" .. i], "CCLabelTTF")
        local temp = ""
        if v and v.items then
            for key,value in pairs( v.items) do
                temp = temp .. ',' ..  userdata:getExchangeResource(key).name .. 'X' .. value
                logLabel:setString(HLNSLocalizedString("union.racingBattleStart.log1", v.uid ,temp ))
                logLabel:setVisible(true)
            end
        end
    end
end

local function _updateTimer()

    readLog()
end

local function refresh()
    local scoreLabel = tolua.cast(UnionRacingBattleStartViewOwner["scoreLabel"] , "CCLabelTTF")
    local progress = tolua.cast(UnionRacingBattleStartViewOwner["progress"] , "CCLayer")


    local color1 = tolua.cast(UnionRacingBattleStartViewOwner["color1"] , "CCLayer")
    local color2 = tolua.cast(UnionRacingBattleStartViewOwner["color2"] , "CCLayer")
    local color3 = tolua.cast(UnionRacingBattleStartViewOwner["color3"] , "CCLayer")

    if _data.bossData.curStep == "step1" then
        scoreLabel:setString(_data.bossData.step1_num .. '/' .. ConfigureStorage.leagueBoss[1].num)
        progress:setContentSize(CCSizeMake(progress:getContentSize().width * _data.bossData.step1_num/ConfigureStorage.leagueBoss[1].num , progress:getContentSize().height))
        progress:setColor(ccc3(128,193,12)) -- 水手
        
    elseif _data.bossData.curStep == "step2" then  
        scoreLabel:setString(_data.bossData.step2_num .. '/' .. ConfigureStorage.leagueBoss[2].num)
        progress:setContentSize(CCSizeMake(progress:getContentSize().width * _data.bossData.step2_num/ConfigureStorage.leagueBoss[2].num , progress:getContentSize().height))
        progress:setColor(ccc3(228,197,40)) -- 精英
        color1:setOpacity(255)
    elseif _data.bossData.curStep == "step3" then
        scoreLabel:setString(_data.bossData.step3_num .. '/' .. ConfigureStorage.leagueBoss[3].num)
        progress:setContentSize(CCSizeMake(progress:getContentSize().width * _data.bossData.step3_num/ConfigureStorage.leagueBoss[3].num , progress:getContentSize().height))
        progress:setColor(ccc3(255,166,22)) -- boss
        color1:setOpacity(255)
        color2:setOpacity(255)
    elseif _data.bossData.curStep == "finish" then
        scoreLabel:setString(_data.bossData.step3_num .. '/' .. ConfigureStorage.leagueBoss[3].num)
        progress:setContentSize(CCSizeMake(progress:getContentSize().width * _data.bossData.step3_num/ConfigureStorage.leagueBoss[3].num , progress:getContentSize().height))
        progress:setColor(ccc3(255,166,22)) -- boss
        color1:setOpacity(255)
        color2:setOpacity(255)
        color3:setOpacity(255)
    end
    if _data.before == 1 then 
        local battleBeforeBtn = tolua.cast(UnionRacingBattleStartViewOwner["battleBeforeBtn"] , "CCMenuItemImage")
        battleBeforeBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn7_2.png"))
        battleBeforeBtn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn7_2.png"))
    end  

end

local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/unionRacingBattleStartView.ccbi",proxy, true,"UnionRacingBattleStartViewOwner")
    _layer = tolua.cast(node,"CCLayer")
    refresh()
    readLog()
end

local function setMenuPriority()
    
end

function getUnionRacingBattleStartViewLayer()
	return _layer
end

function createUnionRacingBattleStartViewLayer( data )
    _data = data
    _init()

    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
        _bNetwork = false
        addObserver(NOTI_TICK, _updateTimer)
        addObserver(NOTI_BOSS_LOG, getLog)
    end

    local function _onExit()
        _layer = nil
        _bNetwork = false
        removeObserver(NOTI_TICK, _updateTimer)
        removeObserver(NOTI_BOSS_LOG, getLog)
    end

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