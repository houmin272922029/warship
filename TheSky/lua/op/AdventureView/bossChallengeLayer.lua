local _layer
local _priority = -134
local _autoTimer = 2
local _logs = {}
local _bNetwork
local progress

-- 名字不要重复
BossChallengeOwner = BossChallengeOwner or {}
ccb["BossChallengeOwner"] = BossChallengeOwner


local function closeItemClick()
    _layer:removeFromParentAndCleanup(true)
end
BossChallengeOwner["closeItemClick"] = closeItemClick


local function setMenuPriority()
    local menu = tolua.cast(BossChallengeOwner["menu"], "CCMenu")
    menu:setHandlerPriority(_priority - 1)
end

local function getLogCallback(url, rtnData)
    bossdata:insertLog(rtnData.info.logs)
    _bNetwork = false
end

local function getLog()
    if _bNetwork then
        return
    end
    _bNetwork = true
    if not bossdata.logTime or bossdata.logTime == 0 then
        bossdata.logTime = userdata.loginTime - 10
    end
    doActionNoLoadingFun("GET_BOSS_LOG", {bossdata.logTime}, getLogCallback)
    bossdata.logTime = userdata.loginTime
end

local function readLog()
    local log = bossdata:popLog()
    if log then
        table.insert(_logs, log)
        -- 飞蛾扑火
        local function removeNode(node)
            node:removeFromParentAndCleanup(true)
        end
        local bossBust = tolua.cast(BossChallengeOwner["bossBust"], "CCSprite")
        local infoBg = tolua.cast(BossChallengeOwner["infoBg"], "CCSprite")
        local f = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(herodata:getHeroHeadByHeroId(log.heroId))
        if f then
            local sp = CCSprite:createWithSpriteFrame(f)
            infoBg:addChild(sp, 2)
            local x = infoBg:getContentSize().width / 2 * (1 + (RandomManager.fakeRandomRange(0, 1) - 0.5) * 2)
            local y = infoBg:getContentSize().height / 2 * (1 + (RandomManager.fakeRandomRange(0, 1) - 0.5) * 2)
            sp:setPosition(ccp(x, y))
            sp:setOpacity(0)
            local move = CCMoveTo:create(0.2, ccp(bossBust:getPositionX(), bossBust:getPositionY() + bossBust:getContentSize().height / 5))
            local fadeIn = CCFadeTo:create(0.2, 255)
            local spawn = CCSpawn:createWithTwoActions(move, fadeIn)
            local array = CCArray:create()
            array:addObject(spawn)
            array:addObject(CCFadeTo:create(0.2, 0))
            array:addObject(CCDelayTime:create(0.5))
            array:addObject(CCCallFuncN:create(removeNode))
            sp:runAction(CCSequence:create(array))
        end
        -- BOSS 虎躯一震
        if bossBust then
            local oriPosX, oriPosY = bossBust:getPosition()
            local array = CCArray:create()
            array:addObject(CCDelayTime:create(0.2))
            array:addObject(CCMoveBy:create(0.05, ccp(-12, 13)))
            array:addObject(CCMoveBy:create(0.05, ccp(14, -15)))
            array:addObject(CCMoveBy:create(0.05, ccp(13, -13)))
            array:addObject(CCMoveBy:create(0.05, ccp(-15, 0)))
            array:addObject(CCMoveBy:create(0.05, ccp(0, 15)))
            array:addObject(CCMoveBy:create(0.05, ccp(-12, -12)))
            array:addObject(CCMoveBy:create(0.05, ccp(13, -13)))
            array:addObject(CCMoveBy:create(0.05, ccp(-11, 13)))
            array:addObject(CCMoveBy:create(0.05, ccp(0, 11)))
            array:addObject(CCMoveTo:create(0.05, ccp(oriPosX, oriPosY)))
            bossBust:runAction(CCSequence:create(array))
        end
        -- BOSS 菊花一紧
        if log.damage and log.damage > 0 then
            local font = CCLabelBMFont:create("-"..log.damage, "images/fight_Red.fnt")
            font:setPosition(ccp(bossBust:getPositionX(), bossBust:getPositionY() + bossBust:getContentSize().height / 2))
            infoBg:addChild(font, 2)
            font:setOpacity(0)
            font:setScale(2.5)
            local array = CCArray:create()
            array:addObject(CCDelayTime:create(0.2))
            array:addObject(CCFadeTo:create(0.05, 255))
            array:addObject(CCDelayTime:create(0.5))
            local move = CCMoveBy:create(0.1, ccp(0, 100))
            local fadeOut = CCFadeTo:create(0.1, 0)
            local spawn = CCSpawn:createWithTwoActions(move, fadeOut)
            array:addObject(spawn)
            array:addObject(CCDelayTime:create(0.5))
            array:addObject(CCCallFuncN:create(removeNode))
            font:runAction(CCSequence:create(array))
        end
    end
    if #_logs > 4 then
        table.remove(_logs, 1)
    end
    for i,v in ipairs(_logs) do
        local logLabel = tolua.cast(BossChallengeOwner["log"..i], "CCLabelTTF")
        logLabel:setString(HLNSLocalizedString("boss.log", v.name, v.damage))
        logLabel:setVisible(true)
    end
end


local function _updateTimer()
    local resurrentLabel = tolua.cast(BossChallengeOwner["resurrentLabel"], "CCLabelTTF")
    local endLabel = tolua.cast(BossChallengeOwner["endLabel"], "CCLabelTTF")
    local playerData = bossdata.thisBoss.playerData
    local resurrectCD = 0
    if playerData and playerData[tostring(userdata.userId)] then
        resurrectCD = math.max(0, playerData[tostring(userdata.userId)].lastTime + playerData[tostring(userdata.userId)].cdTime - userdata.loginTime)
    end
    if not getUDBool(UDefKey.Setting_BossAuto, false) and resurrectCD ~= 0 then
        resurrentLabel:setVisible(true)
        resurrentLabel:setString(HLNSLocalizedString("boss.resurrect", DateUtil:second2hms(resurrectCD)))
    else
        resurrentLabel:setVisible(false)
    end
    local endCD = math.max(0, bossdata.thisBoss.endTime - userdata.loginTime)
    endLabel:setString(HLNSLocalizedString("boss.end", DateUtil:second2hms(endCD)))

    if endCD == 0 then
        getBossLayer():getBossInfo()
        _layer:removeFromParentAndCleanup(true)
        return
    end

    local challengeItem = tolua.cast(BossChallengeOwner["challengeItem"], "CCMenuItemImage")
    local resurrectItem = tolua.cast(BossChallengeOwner["resurrectItem"], "CCMenuItemImage")
    local buffItem = tolua.cast(BossChallengeOwner["buffItem"], "CCMenuItemImage")
    local autoItem = tolua.cast(BossChallengeOwner["autoItem"], "CCMenuItemImage")
    local challengeIcon = tolua.cast(BossChallengeOwner["challengeIcon"], "CCSprite")
    if getUDBool(UDefKey.Setting_BossAuto, false) then
        challengeItem:setEnabled(false)
        resurrectItem:setEnabled(false)
        buffItem:setEnabled(false)
        -- autoItem:setEnabled(false)
        challengeIcon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tiaozhanzhong_text.png"))
    else
        buffItem:setEnabled(true)
        challengeIcon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("boss_tiaozhan_text.png"))
        if resurrectCD > 0 then
            challengeItem:setEnabled(false)
            resurrectItem:setEnabled(true)
        else
            challengeItem:setEnabled(true)
            resurrectItem:setEnabled(false)
        end
    end

    readLog()

end

local function _refresh()
    local bossDic = ConfigureStorage.bossAttr[bossdata.thisBoss.key]
    local bossBust = tolua.cast(BossChallengeOwner["bossBust"], "CCSprite")
    local texture = CCTextureCache:sharedTextureCache():addImage(herodata:getHeroBust1ByHeroId(bossDic.npc[1].ID))
    if texture then
        bossBust:setTexture(texture)
        -- renzhan
        HLAddParticleScale( "images/eff_bossBust.plist", BossChallengeOwner["bossBust"], ccp(BossChallengeOwner["bossBust"]:getContentSize().width / 2 , BossChallengeOwner["bossBust"]:getContentSize().height / 2), 5, -1, 100, 1/retina, 1/retina )
        -- 
    end

    -- local gold1 = tolua.cast(BossChallengeOwner["gold1"], "CCLabelTTF")
    -- gold1:setString(ConfigureStorage.bossPayAndBuff["2"].gold)
    -- local gold2 = tolua.cast(BossChallengeOwner["gold2"], "CCLabelTTF")
    -- gold2:setString(ConfigureStorage.bossPayAndBuff["3"].gold)


    local progressBg = tolua.cast(BossChallengeOwner["hpLayer"], "CCLayer")
    if progress then
        progress:removeFromParentAndCleanup(true)
        progress = nil
    end
    progress = CCProgressTimer:create(CCSprite:create("images/boss_hp.png"))
    progress:setType(kCCProgressTimerTypeBar)
    progress:setMidpoint(CCPointMake(0, 0))
    progress:setBarChangeRate(CCPointMake(1, 0))
    progress:setPosition(progress:getContentSize().width / 2, progress:getContentSize().height / 2)
    progressBg:addChild(progress,0, 101)
    progress:setPercentage(bossdata.thisBoss.hpNow / bossdata.thisBoss.hp * 100)
    _updateTimer()
end

local function _fight(buff)
    RandomManager.cursor = RandomManager.randomRange(0, 999)
    BattleField:bossFight(bossdata.thisBoss.key, bossdata.thisBoss.level, bossdata.thisBoss.hp, bossdata.thisBoss.hpNow, buff)
    BattleField.leftName = userdata.name
    BattleField.rightName = ConfigureStorage.bossAttr[bossdata.thisBoss.key].npc[1].name
end

local function _showFightResult()
    if getBossResultLayer() then
        getBossResultLayer():refresh()
    else
        getMainLayer():getParent():addChild(createBossResultLayer(-136), 100)
    end
end

local function challengeCallback(url, rtnData)
    runtimeCache.responseData = rtnData.info
    bossdata.thisBoss = rtnData.info.boss
    local logs = {
                    ["0"] = {
                                ["name"] = userdata.name, 
                                ["damage"] = BattleField.damage.left, 
                                ["heroId"] = herodata.heroes[herodata.form["0"]].heroId, 
                                ["time"] = userdata.loginTime
                            }
                }
    bossdata:insertLog(logs)
    CCDirector:sharedDirector():replaceScene(CCTransitionFade:create(0.6, FightingScene()))
end

local function errorCallback(url, rtnCode)
    if rtnCode == ErrorCodeTable.ERR_2901 or rtnCode == ErrorCodeTable.ERR_2902 then
        getBossLayer():getBossInfo()
        if getBossResultLayer() then
            getBossResultLayer():removeFromParentAndCleanup(true)
        end
        _layer:removeFromParentAndCleanup(true)
    end
end

local function challengeItemClick()
    Global:instance():TDGAonEventAndEventData("gorge3") 
    local resurrectCD = 0
    if playerData and playerData[tostring(userdata.userId)] then
        resurrectCD = math.max(0, playerData[tostring(userdata.userId)].lastTime + playerData[tostring(userdata.userId)].cdTime - userdata.loginTime)
    end
    if resurrectCD > 0 then
        ShowText(HLNSLocalizedString("boss.resurrect.tips"))
        return
    end
    _fight()
    doActionFun("BOSS_BATTLE", {BattleField.damage.left, 1}, challengeCallback, errorCallback) 
end
BossChallengeOwner["challengeItemClick"] = challengeItemClick

local function resurrectItemClick()
    Global:instance():TDGAonEventAndEventData("gorge1")
    _fight()
    doActionFun("BOSS_BATTLE", {BattleField.damage.left, 2}, challengeCallback, errorCallback)
end
BossChallengeOwner["resurrectItemClick"] = resurrectItemClick

local function buffItemClick()
    Global:instance():TDGAonEventAndEventData("gorge2")
    -- renzhan
    HLAddParticleScale( "images/eff_bornOfFire.plist", BossChallengeOwner["buffItem"], ccp(BossChallengeOwner["buffItem"]:getContentSize().width / 2 , BossChallengeOwner["buffItem"]:getContentSize().height / 2), 5, 100, 100, 1/retina, 1/retina )
    -- 
    _fight(ConfigureStorage.bossPayAndBuff["3"].buff)
    doActionFun("BOSS_BATTLE", {BattleField.damage.left, 3}, challengeCallback, errorCallback)
end
BossChallengeOwner["buffItemClick"] = buffItemClick

local function autoFightCallback(url, rtnData)
    runtimeCache.responseData = rtnData.info
    bossdata.thisBoss = rtnData.info.boss
    _autoTimer = 8
    progress:setPercentage(bossdata.thisBoss.hpNow / bossdata.thisBoss.hp * 100)
    local logs = {
                    ["0"] = {
                                ["name"] = userdata.name, 
                                ["damage"] = BattleField.damage.left, 
                                ["heroId"] = herodata.heroes[herodata.form["0"]].heroId, 
                                ["time"] = userdata.loginTime
                            }
                }
    bossdata:insertLog(logs)
    -- _showFightResult()
    local text = HLNSLocalizedString("boss.result.damage", BattleField.damage.left)
    local gain = rtnData.info.gain
    if gain["silver"] then
        text = string.format("%s\r\n%s", text, HLNSLocalizedString("boss.result.silver", gain["silver"]))
    end
    local itemId = "item_006"
    if gain["items"] and gain["items"][itemId] then
        local conf = wareHouseData:getItemResource(itemId)
        text = string.format("%s\r\n%s", text, HLNSLocalizedString("boss.result.train", gain["items"][itemId], conf.name))
    end
    if gain["encounter"] then
        print("--------- encounter -----------")
        text = string.format("%s\r\n%s", text, HLNSLocalizedString("boss.result.instruct"))
    end
    ShowText(text)
    -- renzhan
    HLAddParticleScale( "images/eff_bornOfFire.plist", BossChallengeOwner["buffItem"], ccp(BossChallengeOwner["buffItem"]:getContentSize().width / 2 , BossChallengeOwner["buffItem"]:getContentSize().height / 2), 5, 100, 100, 1/retina, 1/retina )
    -- 
end

local function _autoFight()
    if getUDBool(UDefKey.Setting_BossAuto, false) then
        _autoTimer = _autoTimer - 1
        if _autoTimer == 0 then
            if userdata.gold < ConfigureStorage.bossPayAndBuff["3"].gold then
                ShowText(HLNSLocalizedString("ERR_1101"))
                _autoTimer = 2
                setUDBool(UDefKey.Setting_BossAuto, false)
                return
            end
            _fight(ConfigureStorage.bossPayAndBuff["3"].buff)
            doActionFun("BOSS_BATTLE", {BattleField.damage.left, 3}, autoFightCallback, errorCallback)
        end
    end
end

local function cardConfirmAction()
    if getUDBool(UDefKey.Setting_BossAuto, false) then
        _autoTimer = 2
        setUDBool(UDefKey.Setting_BossAuto, not getUDBool(UDefKey.Setting_BossAuto, false))
        getBossLayer():refreshLayer()
    else
        if userdata.gold >= ConfigureStorage.bossPayAndBuff["3"].gold then
            setUDBool(UDefKey.Setting_BossAuto, not getUDBool(UDefKey.Setting_BossAuto, false))
            getBossLayer():refreshLayer()
        else
            ShowText(HLNSLocalizedString("ERR_1101"))
            getMainLayer():addChild(createShopRechargeLayer(-140), 100)
        end
    end
end

local function autoItemClick()
    Global:instance():TDGAonEventAndEventData("gorge4")
    local text
    if getUDBool(UDefKey.Setting_BossAuto, false) then
        text = HLNSLocalizedString("boss.auto.tips.close")
    else
        text = HLNSLocalizedString("boss.auto.tips")
    end
    getMainLayer():getParent():addChild(createSimpleConfirCardLayer(text), 100)
    SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
    SimpleConfirmCard.cancelMenuCallBackFun = nil
end
BossChallengeOwner["autoItemClick"] = autoItemClick

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/BossChallengeView.ccbi", proxy, true,"BossChallengeOwner")
    _layer = tolua.cast(node,"CCLayer")
    _refresh()
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(BossChallengeOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        -- _layer:removeFromParentAndCleanup(true)
        return true
    end
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

-- 该方法名字每个文件不要重复
function getBossChallengeLayer()
	return _layer
end

function createBossChallengeLayer(priority)
    _init()
    _priority = priority ~= nil and priority or -134

    function _layer:showFightResult()
        _showFightResult()
    end

    function _layer:close()
        closeItemClick()
    end

    local function _onEnter()
        print("onEnter")
        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/hero_head.plist")
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
        addObserver(NOTI_BOSS_RESURRECT, _updateTimer)
        addObserver(NOTI_BOSS_AUTO, _autoFight)
        addObserver(NOTI_BOSS_LOG, getLog)
        _autoTimer = 2
        _logs = {}
        _bNetwork = false
        getLog()
    end

    local function _onExit()
        print("onExit")
        _layer = nil
        _priority = -134
        _bNetwork = false
        progress = nil
        removeObserver(NOTI_BOSS_RESURRECT, _updateTimer)
        removeObserver(NOTI_BOSS_AUTO, _autoFight)
        removeObserver(NOTI_BOSS_LOG, getLog)
    end

    --onEnter onExit
    local function _layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        end
    end


    _layer:registerScriptTouchHandler(onTouch ,false , _priority ,true )
    _layer:setTouchEnabled(true)
    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end