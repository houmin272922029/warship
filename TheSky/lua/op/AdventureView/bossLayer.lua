local _layer

BossViewOwner = BossViewOwner or {}
ccb["BossViewOwner"] = BossViewOwner

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/BossView.ccbi",proxy, true,"BossViewOwner")
    _layer = tolua.cast(node,"CCLayer")
end

-- 该方法名字每个文件不要重复
function getBossLayer()
	return _layer
end

local function _updateAutoIcon()
    local checkIcon = tolua.cast(BossViewOwner["checkIcon"], "CCSprite")
    if getUDBool(UDefKey.Setting_BossAuto, false) then
        checkIcon:setVisible(true)
    else
        checkIcon:setVisible(false)
    end
end

local function _updateTimer()
    local openTime = tolua.cast(BossViewOwner["openTime"], "CCLabelTTF")
    if not bossdata.thisBoss or not bossdata.thisBoss.beginTime then
        openTime:setVisible(false)
        return
    end
    openTime:setVisible(true)
    local cd = math.max(0, bossdata.thisBoss.beginTime - userdata.loginTime)
    if cd > 0 then
        openTime:setString(HLNSLocalizedString("boss.openTime", DateUtil:second2hms(cd)))
    else
        openTime:setString(HLNSLocalizedString("boss.open"))  
    end
end

local function _refreshLayer()
    local bossDic = ConfigureStorage.bossAttr[bossdata.thisBoss.key]
    local bossBust = tolua.cast(BossViewOwner["bossBust"], "CCSprite")
    local texture = CCTextureCache:sharedTextureCache():addImage(herodata:getHeroBust1ByHeroId(bossDic.npc[1].ID))
    if texture then
        bossBust:setVisible(true)
        bossBust:setTexture(texture)
        -- renzhan
        HLAddParticleScale( "images/eff_bossBust.plist", BossViewOwner["bossBust"], ccp(BossViewOwner["bossBust"]:getContentSize().width / 2 , BossViewOwner["bossBust"]:getContentSize().height / 2), 5, -1, 100, 1/retina, 1/retina )
        -- 
    end

    local bossDesp = tolua.cast(BossViewOwner["bossDesp"], "CCLabelTTF")
    bossDesp:setVisible(true)
    bossDesp:setString(bossDic.desp)

    local challengeInfo = tolua.cast(BossViewOwner["challengeInfo"], "CCLabelTTF")
    local last = ""
    if bossdata.lastBoss then
        -- 击杀时间
        last = string.format("%s%s", last, HLNSLocalizedString("boss.last.challengeTime", DateUtil:second2hms(bossdata.lastBoss.endTime - bossdata.lastBoss.beginTime)))
        -- 前3名
        local ranks = ""
        local rankArray = bossdata:getLastRank()
        for i=1,3 do
            local dic = rankArray[i]
            if dic then
                ranks = string.format("%s%s", ranks, dic.name)
                if i < math.min(3, #rankArray) then
                    ranks = string.format("%s,", ranks)
                end
            end
        end
        last = string.format("%s\r\n%s", last, HLNSLocalizedString("boss.last.rank", ranks))
        -- 上次击杀
        local defeat = ""
        if bossdata.lastBoss.finalKiller then
            defeat = bossdata.lastBoss.finalKiller.name
        end
        last = string.format("%s\r\n%s", last, HLNSLocalizedString("boss.last.defeat", defeat))
    end
    challengeInfo:setVisible(true)
    challengeInfo:setString(last)

    _updateAutoIcon()

end

local function getBossInfoCallback(url, rtnData)
    bossdata.lastBoss = rtnData.info.lastBoss
    bossdata.thisBoss = rtnData.info.thisBoss
    local begin = DateUtil:beginDay(userdata.loginTime)
    
    bossdata.hasCheckedFirst = bossdata:bBossFight() == 1
    bossdata.hasCheckedSecond = bossdata:bBossFight() == 2
    
    _refreshLayer()
end

local function getBossInfo()
    doActionFun("GET_BOSS_INFO", {}, getBossInfoCallback) 
end

local function cardConfirmAction()
    if userdata.gold >= ConfigureStorage.bossPayAndBuff["3"].gold then
        local layer = createBossChallengeLayer(-134)
        getMainLayer():getParent():addChild(layer, 100)
    else
        ShowText(HLNSLocalizedString("ERR_1101"))
        getMainLayer():addChild(createShopRechargeLayer(-140), 100)
    end
end

local function onEnterClick()
    local cd = math.max(0, bossdata.thisBoss.beginTime - userdata.loginTime)
    if cd > 0 then
        ShowText(HLNSLocalizedString("boss.close"))
        local rankArray = bossdata:getRank()
        if #rankArray > 0 then
            getMainLayer():getParent():addChild(createBossRankLayer(-134))
        end
    else
        if getUDBool(UDefKey.Setting_BossAuto, false) then
            local text = HLNSLocalizedString("boss.auto.tips")
            getMainLayer():getParent():addChild(createSimpleConfirCardLayer(text), 100)
            SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
            SimpleConfirmCard.cancelMenuCallBackFun = nil
        else
            local layer = createBossChallengeLayer(-134)
            getMainLayer():getParent():addChild(layer, 100)
        end
    end
end
BossViewOwner["onEnterClick"] = onEnterClick

local function onAutoClick()
    setUDBool(UDefKey.Setting_BossAuto, not getUDBool(UDefKey.Setting_BossAuto, false))
    _updateAutoIcon()
end
BossViewOwner["onAutoClick"] = onAutoClick

function createBossLayer()
    _init()

    function _layer:getBossInfo()
        getBossInfo()
    end

    function _layer:refreshLayer()
        _refreshLayer()
    end

    function _layer:bossFightEnd()
        local layer = createBossChallengeLayer(-134)
        getMainLayer():getParent():addChild(layer, 100)
        getBossChallengeLayer():showFightResult()
    end

    local function _onEnter()
        -- 开始倒计时通知
        addObserver(NOTI_BOSS_BEGIN, _updateTimer)
    end

    local function _onExit()
        _layer = nil
        removeObserver(NOTI_BOSS_BEGIN, _updateTimer)
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