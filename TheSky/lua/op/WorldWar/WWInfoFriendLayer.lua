local _layer
local _priority
local _data

WWInfoFriendOwner = WWInfoFriendOwner or {}
ccb["WWInfoFriendOwner"] = WWInfoFriendOwner


-- 关闭
local function closeItemClick()
    popUpCloseAction(WWInfoFriendOwner, "infoBg", _layer)
end
WWInfoFriendOwner["closeItemClick"] = closeItemClick

-- 邀请好友成功
local function inviteFriendCallBack(url, rtnData)
    if rtnData.code == 200 then
        ShowText(HLNSLocalizedString("好友请求已发送"))
    end
end

local function messageItemClick()
    local player = _data.playerData
    getMainLayer():getParent():addChild(createLeaveMessageLayer(player.name, player.playerId, -500))
end
WWInfoFriendOwner["messageItemClick"] = messageItemClick

local function addItemClick()
    local player = _data.playerData
    doActionFun("INVITE_FRIEND_URL", {player.playerId}, inviteFriendCallBack)
end
WWInfoFriendOwner["addItemClick"] = addItemClick

local function teamItemClick()
    local function viewBattleInfo(url, rtnData)
        playerBattleData:fromDic(rtnData.info)
        getMainLayer():getParent():addChild(createTeamPopupLayer(-140))
        closeItemClick()
    end
    local player = _data.playerData
    doActionFun("ARENA_GET_BATTLE_INFO", {player.playerId}, viewBattleInfo)
end
WWInfoFriendOwner["teamItemClick"] = teamItemClick

local function refreshTime()
    local player = _data.playerData
    local bloodBuffType = player.bloodBuffType
    local bloodBuff = 0
    if player.bloodBuffEndtime > userdata.loginTime and bloodBuffType and bloodBuffType ~= "" then
        bloodBuff = ConfigureStorage.WWScience[bloodBuffType].params.buff
    end
    local bloodBuffLabel = tolua.cast(WWInfoFriendOwner["bloodBuff"], "CCLabelTTF")
    bloodBuffLabel:setString(string.format("+%d%%", bloodBuff))
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(WWInfoFriendOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction(WWInfoFriendOwner, "infoBg", _layer)
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
    local menu = tolua.cast(WWInfoFriendOwner["menu"], "CCMenu")
    menu:setHandlerPriority(_priority - 1)
end

local function refresh()
    local player = _data.playerData
    local name = tolua.cast(WWInfoFriendOwner["name"], "CCLabelTTF")
    name:setString(player.name)

    local level = tolua.cast(WWInfoFriendOwner["level"], "CCLabelTTF")
    level:setString(string.format("LV:%d", player.level))

    local vip = tolua.cast(WWInfoFriendOwner["vip"], "CCSprite")
    vip:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("VIP_%d.png", player.vip)))

    local jobBuffLabel = tolua.cast(WWInfoFriendOwner["jobBuff"], "CCLabelTTF")
    local leaderKey = player.leaderKey
    local jobBuff = 0
    if leaderKey and leaderKey ~= "" then
        jobBuff = math.floor(ConfigureStorage.WWJob[leaderKey + 1].property * 100)
    end
    jobBuffLabel:setString(string.format("+%d%%", jobBuff))

    local attackCount = tolua.cast(WWInfoFriendOwner["attackCount"], "CCLabelTTF")
    attackCount:setString(player.attackCount)

    local defendCount = tolua.cast(WWInfoFriendOwner["defendCount"], "CCLabelTTF")
    defendCount:setString(player.defendCount)

    local ship = tolua.cast(WWInfoFriendOwner["ship"], "CCSprite")
    ship:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(worldwardata:getShipIcon(player.durabilityLevel, player.countryId)))

    refreshTime()

    local messageItem = tolua.cast(WWInfoFriendOwner["messageItem"], "CCMenuItem")
    local addItem = tolua.cast(WWInfoFriendOwner["addItem"], "CCMenuItem")
    local teamItem = tolua.cast(WWInfoFriendOwner["teamItem"], "CCMenuItem")
    local messageText = tolua.cast(WWInfoFriendOwner["messageText"], "CCSprite")
    local addText = tolua.cast(WWInfoFriendOwner["addText"], "CCSprite")
    local teamText = tolua.cast(WWInfoFriendOwner["teamText"], "CCSprite")
    messageItem:setVisible(player.playerId ~= userdata.userId)
    addItem:setVisible(player.playerId ~= userdata.userId)
    teamItem:setVisible(player.playerId ~= userdata.userId)
    messageText:setVisible(player.playerId ~= userdata.userId)
    addText:setVisible(player.playerId ~= userdata.userId)
    teamText:setVisible(player.playerId ~= userdata.userId)

    local upgradeItem = tolua.cast(WWInfoFriendOwner["upgradeItem"], "CCMenuItem")
    local recoverItem = tolua.cast(WWInfoFriendOwner["recoverItem"], "CCMenuItem")
    local upgradeText = tolua.cast(WWInfoFriendOwner["upgradeText"], "CCSprite")
    local recoverText = tolua.cast(WWInfoFriendOwner["recoverText"], "CCSprite")
    local durLevelTitle = tolua.cast(WWInfoFriendOwner["durLevelTitle"], "CCLabelTTF")
    local durLevel = tolua.cast(WWInfoFriendOwner["durLevel"], "CCLabelTTF")
    local durTitle = tolua.cast(WWInfoFriendOwner["durTitle"], "CCLabelTTF")
    local dur = tolua.cast(WWInfoFriendOwner["dur"], "CCLabelTTF")
    upgradeItem:setVisible(player.playerId == userdata.userId)
    recoverItem:setVisible(player.playerId == userdata.userId and player.durability < worldwardata:getDurabilityMax(player.durabilityLevel))
    upgradeText:setVisible(player.playerId == userdata.userId)
    recoverText:setVisible(player.playerId == userdata.userId and player.durability < worldwardata:getDurabilityMax(player.durabilityLevel))
    durLevelTitle:setVisible(player.playerId == userdata.userId)
    durLevel:setVisible(player.playerId == userdata.userId)
    durTitle:setVisible(player.playerId == userdata.userId)
    dur:setVisible(player.playerId == userdata.userId)
    durLevel:setString(player.durabilityLevel)
    dur:setString(string.format("%d/%d", player.durability, worldwardata:getDurabilityMax(player.durabilityLevel)))
end

local function upgradeItemClick()
    local dur = worldwardata.playerData.durability
    local durMax = worldwardata:getDurabilityMax(worldwardata.playerData.durabilityLevel)
    local nextLevel =  ConfigureStorage.WWDurable[worldwardata.playerData.durabilityLevel + 2]
    if not nextLevel then
        ShowText(HLNSLocalizedString("ww.text.5"))
        return
    end
    if nextLevel.vip > vipdata:getVipLevel() then
        ShowText(HLNSLocalizedString("ww.text.6", nextLevel.vip))
        return
    end
    getMainLayer():getParent():addChild(createWWBuyDurabilityLayer(true, _priority - 2))
    closeItemClick()
end
WWInfoFriendOwner["upgradeItemClick"] = upgradeItemClick

local function recoverItemClick()
    local dur = worldwardata.playerData.durability
    local durMax = worldwardata:getDurabilityMax(worldwardata.playerData.durabilityLevel)
    local count = worldwardata.playerData.durabilityBuyCount
    if not count or count == "" then
        count = 0
    end
    if not ConfigureStorage.WWDurableRecover[tostring(count + 1)] then
        ShowText(HLNSLocalizedString("ww.text.4"))
        return
    end
    getMainLayer():getParent():addChild(createWWBuyDurabilityLayer(false, _priority - 2))
    closeItemClick()
end
WWInfoFriendOwner["recoverItemClick"] = recoverItemClick

local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/WWInfoFriend.ccbi", proxy, true, "WWInfoFriendOwner")
    _layer = tolua.cast(node, "CCLayer")

    refresh()
end

function createWWInfoFriendLayer( data, priority )
    _data = data
    _priority = (priority ~= nil) and priority or -132

    _init()

    local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
    _layer:runAction(seq)

    local function _onEnter()
        addObserver(NOTI_TICK, refreshTime)
        popUpUiAction(WWInfoFriendOwner, "infoBg")
    end

    local function _onExit()
        removeObserver(NOTI_TICK, refreshTime)
        _priority = -132
        _data = nil
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

    _layer:registerScriptTouchHandler(onTouch, false, _priority, true)
    _layer:setTouchEnabled(true)
    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end