local _layer
local _priority = -132
local _tag 
local _betstate

-- 名字不要重复
SSAMyBetViewOwner = SSAMyBetViewOwner or {}
ccb["SSAMyBetViewOwner"] = SSAMyBetViewOwner

local function closeItemClick()
    popUpCloseAction(SSAMyBetViewOwner, "infoBg", _layer )
end
SSAMyBetViewOwner["closeItemClick"] = closeItemClick

local function confirmBtnTaped()
    if _betstate == 2 then
        local function beginCallback(url, rtnData)
            -- body
            ssaData.data = rtnData.info
            closeItemClick()
            getSSAFourKingContendViewLayer():_refresh()
        end
        -- 两个参数 status 、mapIndex
        doActionFun("CROSSSERVERBATTLE_GETBETREWARD",{_data.mapStatus,_tag}, beginCallback) 
    else
        closeItemClick()
    end
end
SSAMyBetViewOwner["confirmBtnTaped"] = confirmBtnTaped

local function _refreshData()
    if _betstate == 2  then -- 领取奖励
        local rewardbetCount = tolua.cast(SSAMyBetViewOwner["rewardbetCount"] , "CCLabelTTF")
        local rewardLabel = tolua.cast(SSAMyBetViewOwner["rewardLabel"] , "CCLabelTTF")
        local rewardLayerColor = tolua.cast(SSAMyBetViewOwner["rewardLayerColor"] , "CCSprite")
        local rewardGoldSprite = tolua.cast(SSAMyBetViewOwner["rewardGoldSprite"] , "CCSprite")
        rewardLabel:setVisible(true)
        rewardLayerColor:setVisible(true)
        rewardGoldSprite:setVisible(true)
        local servers = tolua.cast(SSAMyBetViewOwner["servers"] , "CCLabelTTF")
        local name = tolua.cast(SSAMyBetViewOwner["name"] , "CCLabelTTF")
        local level = tolua.cast(SSAMyBetViewOwner["level"] , "CCLabelTTF")
        local GoldSprite = tolua.cast(SSAMyBetViewOwner["GoldSprite"] , "CCSprite")
        local betCount = tolua.cast(SSAMyBetViewOwner["betCount"] , "CCLabelTTF")
        local battleMap = _data.battleMap[tostring(_tag)]
        local vsIndex = battleMap.betLog.vsIndex
        local betType = battleMap.betLog.type
        local amount = battleMap.betLog.amount
        servers:setString(battleMap.vs[tostring(vsIndex)].serverName)
        name:setString(battleMap.vs[tostring(vsIndex)].playerData.name)
        level:setString('LV'.. battleMap.vs[tostring(vsIndex)].playerData.level)
        betCount:setString(amount)
        rewardbetCount:setVisible(true)
        rewardbetCount:setString(amount * 2)

        local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
        if betType == "gold" then
            GoldSprite:setDisplayFrame(cache:spriteFrameByName("gold.png"))
            rewardGoldSprite:setDisplayFrame(cache:spriteFrameByName("gold.png"))
        else
            GoldSprite:setDisplayFrame(cache:spriteFrameByName("berry.png"))
            rewardGoldSprite:setDisplayFrame(cache:spriteFrameByName("berry.png"))
        end
    else
        local servers = tolua.cast(SSAMyBetViewOwner["servers"] , "CCLabelTTF")
        local name = tolua.cast(SSAMyBetViewOwner["name"] , "CCLabelTTF")
        local level = tolua.cast(SSAMyBetViewOwner["level"] , "CCLabelTTF")
        local GoldSprite = tolua.cast(SSAMyBetViewOwner["GoldSprite"] , "CCSprite")
        local betCount = tolua.cast(SSAMyBetViewOwner["betCount"] , "CCLabelTTF")
        local battleMap = _data.battleMap[tostring(_tag)]
        local vsIndex = battleMap.betLog.vsIndex
        local betType = battleMap.betLog.type
        local amount = battleMap.betLog.amount
        servers:setString(battleMap.vs[tostring(vsIndex)].serverName)
        name:setString(battleMap.vs[tostring(vsIndex)].playerData.name)
        level:setString('LV'.. battleMap.vs[tostring(vsIndex)].playerData.level)
        betCount:setString(amount)
        local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
        if betType == "gold" then
            GoldSprite:setDisplayFrame(cache:spriteFrameByName("gold.png"))
        else
            GoldSprite:setDisplayFrame(cache:spriteFrameByName("berry.png"))
        end
    end
    
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/SSAMyBetView.ccbi", proxy, true,"SSAMyBetViewOwner")
    _layer = tolua.cast(node,"CCLayer")
    _betGold = 20
    _betBerry = 50000
    _refreshData()
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(SSAMyBetViewOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
       closeItemClick()
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

local function setMenuPriority()
    local menu = tolua.cast(SSAMyBetViewOwner["menu"], "CCMenu")
    menu:setTouchPriority(_priority - 2)
end

function getSSAMyBetViewLayer()
	return _layer
end

function createSSAMyBetViewLayer(data , tag ,state)
    _data = data
    _tag = tag - 1
    _betstate = state
    _priority = (priority ~= nil) and priority or -132
    _init()
    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)

        popUpUiAction(SSAMyBetViewOwner, "infoBg")
        addObserver(NOTI_TICK, _refreshData)
    end

    local function _onExit()
        _layer = nil
        _priority = nil
        _data = nil
        _tag = nil
        _betstate = nil
        removeObserver(NOTI_TICK, _refreshData)
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