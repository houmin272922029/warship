local _layer
local _priority
local _data
local _index

WWInfoEnemyOwner = WWInfoEnemyOwner or {}
ccb["WWInfoEnemyOwner"] = WWInfoEnemyOwner

-- 关闭
local function closeItemClick()
    popUpCloseAction(WWInfoEnemyOwner, "infoBg", _layer)
end
WWInfoEnemyOwner["closeItemClick"] = closeItemClick

local function refreshTime()
    local player = _data.playerData
    local damageCD = tolua.cast(WWInfoEnemyOwner["damageCD"], "CCLabelTTF")
    local cd = math.max(player.damagedLastTime + ConfigureStorage.WWCDTime.damaged - userdata.loginTime, 0)
    damageCD:setString(DateUtil:second2hms(cd))

    local bloodBuffType = player.bloodBuffType
    local bloodBuff = 0
    if player.bloodBuffEndtime > userdata.loginTime and bloodBuffType and bloodBuffType ~= "" then
        bloodBuff = ConfigureStorage.WWScience[bloodBuffType].params.buff
    end
    local bloodBuffLabel = tolua.cast(WWInfoEnemyOwner["bloodBuff"], "CCLabelTTF")
    bloodBuffLabel:setString(string.format("+%d%%", bloodBuff))
end


local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(WWInfoEnemyOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction(WWInfoEnemyOwner, "infoBg", _layer)
        return true
    end
    return true
end

local function onTouch(eventType, x, y)
    if eventType == "began" then   
        return onTouchBegan(x, y)
    end
end

-- 修改 按钮优先级
local function setMenuPriority()
    local menu = tolua.cast(WWInfoEnemyOwner["menu"], "CCMenu")
    menu:setHandlerPriority(_priority - 1)
end

local function refresh()
    local player = _data.playerData
    local name = tolua.cast(WWInfoEnemyOwner["name"], "CCLabelTTF")
    name:setString(player.name)

    local level = tolua.cast(WWInfoEnemyOwner["level"], "CCLabelTTF")
    level:setString(string.format("LV:%d", player.level))

    local vip = tolua.cast(WWInfoEnemyOwner["vip"], "CCSprite")
    vip:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("VIP_%d.png", player.vip)))

    local jobBuffLabel = tolua.cast(WWInfoEnemyOwner["jobBuff"], "CCLabelTTF")
    local leaderKey = player.leaderKey
    local jobBuff = 0
    if leaderKey and leaderKey ~= "" then
        jobBuff = math.floor(ConfigureStorage.WWJob[leaderKey + 1].property * 100)
    end
    jobBuffLabel:setString(string.format("+%d%%", jobBuff))

    local ship = tolua.cast(WWInfoEnemyOwner["ship"], "CCSprite")
    ship:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(worldwardata:getShipIcon(player.durabilityLevel, player.countryId)))

    refreshTime()
end

local function messageItemClick()
    local player = _data.playerData
    getMainLayer():getParent():addChild(createLeaveMessageLayer(player.name, player.playerId, -500))
end
WWInfoEnemyOwner["messageItemClick"] = messageItemClick

local function attackItemClick()
    -- 相邻才能攻击
    if not worldwardata:bLink(worldwardata.island.islandId, worldwardata.playerData.islandId) then
        ShowText(HLNSLocalizedString("ww.text.1"))
        return
    end
    if worldwardata.playerData.courage == 0 then
        getMainLayer():getParent():addChild(createWWUseItemLayer(2, _priority - 2))
        return
    end

    local player = _data.playerData
    local function callback(url, rtnData)
        runtimeCache.responseData = rtnData.info
        playerBattleData:fromDic(rtnData.info)
        BattleField.leftName = userdata.name
        BattleField.rightName = player.name
        RandomManager.cursor = RandomManager.randomRange(0, 999)
        local seed = RandomManager.cursor

        -- 计算buff
        local function calcBuff(data)
            local function getBloodCD()
                local endTime = data.bloodBuffEndtime or 0
                local cd = endTime - userdata.loginTime
                return math.max(0, cd) 
            end
            local buff = 0
            local leaderKey = data.leaderKey
            local jobBuff = 0
            if leaderKey and leaderKey ~= "" then
                jobBuff = math.floor(ConfigureStorage.WWJob[leaderKey + 1].property * 100)
            end
            buff = buff + jobBuff
            -- 热血
            local bloodBuffType = data.bloodBuffType
            local bloodBuff = 0
            local bloodCD = getBloodCD()
            if bloodCD > 0 and bloodBuffType and bloodBuffType ~= "" then
                bloodBuff = ConfigureStorage.WWScience[bloodBuffType].params.buff
            end
            buff = buff + bloodBuff
            -- 强弱阵营加成
            local groupBuff = 0
            if worldwardata.yesterdayRank and type(worldwardata.yesterdayRank) == "table" then
                for i=0,2 do
                    local dic = worldwardata.yesterdayRank[tostring(i)]
                    if dic and dic.countryId == data.countryId then
                        groupBuff = ConfigureStorage.WWReward[i + 1].Property or 0
                        break
                    end
                end
            end
            buff = buff + groupBuff * 100
            return buff
        end

        local buff = calcBuff(worldwardata.playerData)
        local oppoBuff = calcBuff(player)

        BattleField:worldwarFight(oppoBattleInfo, buff, oppoBuff)
        local result = 0
        if BattleField.result == RESULT_WIN then
            result = BattleField.round - 1
        else
            result = BattleField.round + 2
        end
        local function fightCallback(url, rtnData)
            runtimeCache.responseData = rtnData["info"]
            local data = rtnData.info
            local dic = {["playerData"] = data.playerData, ["island"] = data.islandData}
            worldwardata:fromDic(dic)
            CCDirector:sharedDirector():replaceScene(CCTransitionFade:create(0.6, FightingScene()))
        end
        doActionFun("WW_FIGHT", {worldwardata.island.islandId, _index, player.playerId, result}, fightCallback)
    end
    doActionFun("ARENA_GET_BATTLE_INFO", {player.playerId}, callback)
end
WWInfoEnemyOwner["attackItemClick"] = attackItemClick

local function damage(itemId)
    local function callback(url, rtnData)
        local data = rtnData.info
        local dic = {["playerData"] = data.playerData, ["island"] = data.islandData}
        worldwardata:fromDic(dic)
        ShowText(HLNSLocalizedString("ww.damage.succ"))
        postNotification(NOTI_WW_REFRESH, nil)
        closeItemClick()
    end
    
    local function errCallback(url, code)
        closeItemClick() 
    end
    local player = _data.playerData
    doActionFun("WW_DAMAGE", {worldwardata.island.islandId, _index, player.playerId, itemId}, callback, errCallback)
end

local function damageItemClick()
     -- 相邻才能破坏
    if not worldwardata:bLink(worldwardata.island.islandId, worldwardata.playerData.islandId) then
        ShowText(HLNSLocalizedString("ww.text.1"))
        return
    end
    -- 检查保护时间
    local player = _data.playerData
    local cd = math.max(player.damagedLastTime + ConfigureStorage.WWCDTime.damaged - userdata.loginTime, 0)
    if cd > 0 then
        ShowText(HLNSLocalizedString("ww.text.2"))
        return
    end
    -- 等级差在10级内
    if player.level - userdata.level >= 10 then
        ShowText(HLNSLocalizedString("ww.text.3"))
        return
    end
    if table.getTableCount(worldwardata:getDamageItem()) == 0 then
        ShowText(HLNSLocalizedString("ww.damage.no.item"))
        return
    end
    -- 破坏令界面
    getMainLayer():getParent():addChild(createWWDamageLayer(damage, _priority - 2))
end
WWInfoEnemyOwner["damageItemClick"] = damageItemClick


local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/WWInfoEnemy.ccbi", proxy, true, "WWInfoEnemyOwner")
    _layer = tolua.cast(node, "CCLayer")

    refresh()
end

function createWWInfoEnemyLayer( data, index, priority )
    _data = data
    _index = index
    _priority = (priority ~= nil) and priority or -132

    _init()

    local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
    _layer:runAction(seq)

    local function _onEnter()
        addObserver(NOTI_TICK, refreshTime)
        popUpUiAction(WWInfoEnemyOwner, "infoBg")
    end

    local function _onExit()
        print("onExit")
        removeObserver(NOTI_TICK, refreshTime)
        _priority = -132
        _data = nil
        _layer = nil
        _index = 0
    end

    --onEnter onExit
    local function _layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        end
    end

    _layer:registerScriptTouchHandler(onTouch, false, _priority, true)
    _layer:setTouchEnabled(true)
    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end