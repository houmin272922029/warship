local _layer

-- 名字不要重复
VeiledSeaLoseViewOwner = VeiledSeaLoseViewOwner or {}
ccb["VeiledSeaLoseViewOwner"] = VeiledSeaLoseViewOwner

local function refresh()
    local frame = tolua.cast(VeiledSeaLoseViewOwner["frame"], "CCSprite")
    local head = tolua.cast(VeiledSeaLoseViewOwner["head"], "CCSprite")
    local nameLabel = tolua.cast(VeiledSeaLoseViewOwner["name"], "CCLabelTTF")
    local rank
    local headId
    local name
    local group = ConfigureStorage.SeaMiBossGroup[veiledSeaData.data.bossId]
    local pass = veiledSeaData.data.stageKey
    if  pass % 5 == 0 then
        rank = 4
        headId = group.boss.head
        name = group.boss.name
    else
        rank = 3
        headId = group.mob.head
        name = group.mob.name
    end
    frame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", rank)))
    head:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(herodata:getHeroHeadByHeroId(headId)))
    nameLabel:setString(name)
    local stage = tolua.cast(VeiledSeaLoseViewOwner["stage"], "CCLabelTTF")
    stage:setString(pass)
    local rewardStage = tolua.cast(VeiledSeaLoseViewOwner["rewardStage"], "CCLabelTTF")
    rewardStage:setString(5 - pass % 5)
    local reward = tolua.cast(VeiledSeaLoseViewOwner["reward"], "CCLabelTTF")
    for itemId,v in pairs(group.loot) do
        local resDic = userdata:getExchangeResource(itemId)
        reward:setString(string.format("%s×%d", resDic.name, v.value))
        reward:setColor(shadowData:getColorByColorRank(resDic.rank))
        break
    end
    local gold = tolua.cast(VeiledSeaLoseViewOwner["gold"], "CCLabelTTF")
    local goldIcon = tolua.cast(VeiledSeaLoseViewOwner["goldIcon"], "CCSprite")
    local rebirthItem = tolua.cast(VeiledSeaLoseViewOwner["rebirthItem"], "CCMenuItem")
    local dic = ConfigureStorage.SeaMiChunge[tostring(veiledSeaData.data.rebirthCount + 1)]
    if dic then
        gold:setString(dic.gold)
    else
        gold:setVisible(false)
        goldIcon:setVisible(false)
        rebirthItem:setEnabled(false)
    end
end

local function closeItemClick()
    runtimeCache.veiledSeaState = veiledSeaDataFlag.home
    showVeiledSea()
end
VeiledSeaLoseViewOwner["closeItemClick"] = closeItemClick

local function callback(url, rtnData)
    veiledSeaData:fromDic(rtnData["info"])      
    runtimeCache.veiledSeaState = veiledSeaData.data.flag
    getVeiledSeaLayer():changeState()
end

local function resetCallback(url, rtnData)
    veiledSeaData:fromDic(rtnData["info"])      
    runtimeCache.veiledSeaState = veiledSeaData.data.flag
    getVeiledSeaLayer():changeState()
    runtimeCache.veiledSeaMapLayer = {}
end

local function resurgenceBtnClick()
    if runtimeCache.veiledSeaState == veiledSeaDataFlag.other then
        ShowText(HLNSLocalizedString("veiledSea.through"))
        doActionFun("SEALMIST_RESET", {}, resetCallback)
        return
    end

    local vipLavel = userdata:getVipLevel()
    local chungeCount = vipdata:getVipSeaVeiledChungeLevel(vipLavel)
    local todayFreeCount = veiledSeaData:dailyFreeCount()
    if veiledSeaData.data.playCount > chungeCount + todayFreeCount then
        ShowText(HLNSLocalizedString("veiledSea.noHaveChance"))
    else
        doActionFun("SEALMIST_REBIRTH", {}, callback)
    end
end
VeiledSeaLoseViewOwner["resurgenceBtnClick"] = resurgenceBtnClick

local function exitBtnClick()
    doActionFun("SEALMIST_RESET", {}, resetCallback)
end
VeiledSeaLoseViewOwner["exitBtnClick"] = exitBtnClick

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/VeiledSeaLoseView.ccbi", proxy, true,"VeiledSeaLoseViewOwner")
    _layer = tolua.cast(node,"CCLayer")

    refresh()
end

-- 该方法名字每个文件不要重复
function getVeiledSeaLoseLayer()
	return _layer
end

function createVeiledSeaLoseLayer(tag)
    _init()

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

    local function onTouch(eventType, x, y)
        if eventType == "began" then   
            return onTouchBegan(x, y)
        elseif eventType == "moved" then
        elseif eventType == "ended" then
        end
    end
    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end