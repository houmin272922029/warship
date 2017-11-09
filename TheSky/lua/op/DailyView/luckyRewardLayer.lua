local _layer
local scheduler = CCDirector:sharedDirector():getScheduler()
local ballScheduler
local _lightOffset = 0
local _bAni = false
local _targetIndex = 0
local _currentIndex = 0
local _data = nil
local _gain = nil

LuckyRewardViewOwner = LuckyRewardViewOwner or {}
ccb["LuckyRewardViewOwner"] = LuckyRewardViewOwner

local function refreshTime()
    local cdTime = tolua.cast(LuckyRewardViewOwner["cdTime"], "CCLabelTTF")
    local cd = dailyData:getLuckyRewardCloseTime()
    local day, hour, min, sec = DateUtil:secondGetdhms(cd)
    if day > 0 then
        cdTime:setString(HLNSLocalizedString("timer.tips.1", day, hour, min, sec))
    elseif hour > 0 then
        cdTime:setString(HLNSLocalizedString("timer.tips.2", hour, min, sec))
    else
        cdTime:setString(HLNSLocalizedString("timer.tips.3", min, sec))
    end
end

local function ballAni(dt)
    _lightOffset = (_lightOffset - 1) < 0 and 5 or _lightOffset - 1 
    for i=1,58 do
        local image = string.format("ball%d.png", (i + _lightOffset) % 6 + 1)
        local ball = tolua.cast(LuckyRewardViewOwner[string.format("ball%d", i)], "CCSprite")
        ball:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(image))
    end
end

local function ballLightFast()
    scheduler:unscheduleScriptEntry(ballScheduler)
    ballScheduler = scheduler:scheduleScriptFunc(ballAni, 0.03, false)
    for i=1,58 do
        local ball = tolua.cast(LuckyRewardViewOwner[string.format("ball%d", i)], "CCSprite") 
        ball:setScale(1.4)
    end
end

local function ballLightSlow()
    scheduler:unscheduleScriptEntry(ballScheduler)
    ballScheduler = scheduler:scheduleScriptFunc(ballAni, 0.4, false)
    for i=1,58 do
        local ball = tolua.cast(LuckyRewardViewOwner[string.format("ball%d", i)], "CCSprite") 
        ball:setScale(1.2)
    end
end

local function rollStart()
    _bAni = true 
end

local function rollEnd()
    _bAni = false 
end

local function rollSpriteMove()
    _currentIndex = (_currentIndex + 1) % 8
    local item = tolua.cast(LuckyRewardViewOwner[string.format("item%d", _currentIndex + 1)], "CCSprite")
    local rollSp = tolua.cast(LuckyRewardViewOwner["rollSp"], "CCSprite")
    rollSp:setPosition(ccp(item:getPositionX(), item:getPositionY()))
end

local function gainPopup()
    userdata:popUpGain(_gain, true)
end

-- 刷新UI
local function _refreshUI()
    _data = dailyData:getDailyDataByName(Daily_LuckyReward)

    local rankItem = tolua.cast(LuckyRewardViewOwner["rankItem"], "CCMenuItem")
    local rankdata = dailyData:getDailyDataByName(Daily_LuckyRank)
    rankItem:setVisible(rankdata ~= nil)
    local shopItem = tolua.cast(LuckyRewardViewOwner["shopItem"], "CCMenuItem")
    local shopdata = dailyData:getDailyDataByName(Daily_LuckyShop)
    shopItem:setVisible(shopdata ~= nil)

    for i=1,8 do
        local dic = _data.items[tostring(i)]
        local itemId = dic.itemId
        local count = dic.amount

        local resDic = userdata:getExchangeResource(itemId)

        local contentLayer = tolua.cast(LuckyRewardViewOwner["contentLayer"..i],"CCLayer")
        if contentLayer:getChildByTag(9888) then
            contentLayer:removeChildByTag(9888, true)
        end
        local bigSprite = tolua.cast(LuckyRewardViewOwner["bigSprite"..i],"CCSprite")
        bigSprite:setVisible(false)
        bigSprite:removeAllChildrenWithCleanup(true)
        local littleSprite = tolua.cast(LuckyRewardViewOwner["littleSprite"..i],"CCSprite")
        littleSprite:setVisible(false)
        local soulIcon = tolua.cast(LuckyRewardViewOwner["soulIcon"..i],"CCSprite")
        local chip_icon = tolua.cast(LuckyRewardViewOwner["chipIcon"..i],"CCSprite")
        chip_icon:setVisible(false)
        local itemCountLabel = tolua.cast(LuckyRewardViewOwner["countLabel"..i],"CCLabelTTF")
        if resDic then
            if havePrefix(itemId, "weapon_") or havePrefix(itemId, "belt_") or havePrefix(itemId, "armor_") then
                -- 装备
                bigSprite:setVisible(true)
                local texture
                if haveSuffix(itemId, "_shard") then
                    texture = CCTextureCache:sharedTextureCache():addImage(string.format("ccbResources/icons/%s.png",resDic.icon))
                else
                    texture = CCTextureCache:sharedTextureCache():addImage(resDic.icon)
                end
                if texture then
                    bigSprite:setVisible(true)
                    bigSprite:setTexture(texture)
                    if resDic.rank == 4 then
                        HLAddParticleScale( "images/purpleEquip.plist", bigSprite, ccp(bigSprite:getContentSize().width / 2,
                            bigSprite:getContentSize().height / 2), 1, 100, 777, 2 / 0.35 / retina, 2 / 0.35 / retina, 1 )
                    end
                end
                if haveSuffix(itemId, "_shard") then
                    chip_icon:setVisible(true)
                end

            elseif havePrefix(itemId, "item") then
                -- 道具
                bigSprite:setVisible(true)
                local texture = CCTextureCache:sharedTextureCache():addImage(resDic.icon)
                if texture then
                    bigSprite:setVisible(true)
                    bigSprite:setTexture(texture)
                    if resDic.rank == 4 then
                        HLAddParticleScale( "images/purpleEquip.plist", bigSprite, ccp(bigSprite:getContentSize().width / 2,
                            bigSprite:getContentSize().height / 2), 1, 100, 777, 2 / 0.35 / retina, 2 / 0.35 / retina, 1 )
                    end
                end
            elseif havePrefix(itemId, "shadow") then
                -- 影子
                local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
                cache:addSpriteFramesWithFile("ccbResources/shadow.plist")
                if resDic.icon then
                    playCustomFrameAnimation( string.format("yingzi_%s_", resDic.icon), contentLayer, 
                        ccp(contentLayer:getContentSize().width / 2, contentLayer:getContentSize().height / 2), 1, 4, 
                        shadowData:getColorByColorRank(resDic.rank))
                end
            elseif havePrefix(itemId, "hero") then
                -- 魂魄
                littleSprite:setVisible(true)
                littleSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(resDic.icon))

            elseif havePrefix(itemId, "book") then
                -- 奥义
                bigSprite:setVisible(true)
                local texture = CCTextureCache:sharedTextureCache():addImage(resDic.icon)
                if texture then
                    bigSprite:setVisible(true)
                    bigSprite:setTexture(texture)
                    if resDic.rank == 4 then
                        HLAddParticleScale("images/purpleEquip.plist", bigSprite, ccp(bigSprite:getContentSize().width / 2, 
                            bigSprite:getContentSize().height / 2), 1, 100, 777, 2 / 0.35 / retina, 2 / 0.35 / retina, 1)
                    end
                end
            else
                -- 金币 银币
                bigSprite:setVisible(true)
                local texture = CCTextureCache:sharedTextureCache():addImage(resDic.icon)
                if texture then
                    bigSprite:setVisible(true)
                    bigSprite:setTexture(texture)
                end
            end

            -- 设置名字和数量
            itemCountLabel:setString(count)
        else
            contentLayer:setVisible(false)
        end
    end
    local freeFlag = _data.freeTimes and _data.freeTimes > 0
    local freeLabel = tolua.cast(LuckyRewardViewOwner["freeLabel"], "CCLabelTTF")
    freeLabel:setVisible(freeFlag)
    local goldIcon = tolua.cast(LuckyRewardViewOwner["goldIcon"], "CCLabelTTF")
    local gold = tolua.cast(LuckyRewardViewOwner["gold"], "CCLabelTTF")
    goldIcon:setVisible(not freeFlag)
    gold:setVisible(not freeFlag)
    gold:setString(_data.payAmount)
end


local function rollAnimation()
    local rollSp = tolua.cast(LuckyRewardViewOwner["rollSp"], "CCSprite") 
    rollSp:stopAllActions()

    local array = CCArray:create()
    array:addObject(CCCallFunc:create(rollStart))
    array:addObject(CCCallFunc:create(ballLightFast))

    local delay = 0.02
    local tempCurrentIndex = _currentIndex
    local randTurn = RandomManager.randomRange(4, 6)
    for i=1,randTurn do
        for j=1,8 do
            array:addObject(CCDelayTime:create(delay))
            array:addObject(CCCallFunc:create(rollSpriteMove))
        end
    end
    local slowStep = 15
    local offStep = (8 - tempCurrentIndex + _targetIndex) % 8 + (24 - slowStep)
    for i=1,offStep do
        array:addObject(CCDelayTime:create(delay))
        array:addObject(CCCallFunc:create(rollSpriteMove))
    end
    for i=1,slowStep do
        delay = delay + 0.02
        array:addObject(CCDelayTime:create(delay))
        array:addObject(CCCallFunc:create(rollSpriteMove))
    end
    array:addObject(CCCallFunc:create(ballLightSlow))
    array:addObject(CCCallFunc:create(rollEnd))
    array:addObject(CCDelayTime:create(0.5))
    array:addObject(CCCallFunc:create(gainPopup))
    array:addObject(CCCallFunc:create(_refreshUI))
    rollSp:runAction(CCSequence:create(array))
end



-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/LuckyRewardView.ccbi",proxy, true,"LuckyRewardViewOwner")
    _layer = tolua.cast(node,"CCLayer")

    _refreshUI()
    
    ballScheduler = scheduler:scheduleScriptFunc(ballAni, 0.4, false)

    local light1 = tolua.cast(LuckyRewardViewOwner["light_1"], "CCSprite")
    light1:runAction(CCRepeatForever:create(CCRotateBy:create(15, -360)))

    for i=1,58 do
        local image = string.format("ball%d.png", (i + _lightOffset) % 6 + 1)
        local ball = tolua.cast(LuckyRewardViewOwner[string.format("ball%d", i)], "CCSprite")
        ball:setScale(1.2)
    end
end

local function _getInfo()
    local function callback(url, rtnData)
        _refreshUI() 
    end
    doActionFun("GET_LUCKYREWARD_INFO", {}, callback)
end

local function errorCallback()
    _getInfo()
end

local function rollItemClick()
    local function callback(url, rtnData)
        _gain = rtnData.info.gain
        _targetIndex = rtnData.info.luckDrawResult["0"].group - 1
        rollAnimation()
    end
    doActionFun("ROLL_LUCKYREWARD", {_data.uid, _data.lastFlushTime, 1}, callback, errorCallback)
end
LuckyRewardViewOwner["rollItemClick"] = rollItemClick

local function tenItemClick()
    local function callback(url, rtnData)
        _gain = rtnData.info.gain 
        gainPopup()
        _refreshUI()
    end
    doActionFun("ROLL_LUCKYREWARD", {_data.uid, _data.lastFlushTime, 10}, callback, errorCallback)
end
LuckyRewardViewOwner["tenItemClick"] = tenItemClick

local function todayItemClick()
    local function callback(url, rtnData)
        local dic = {}
        for k,v in pairs(rtnData.info) do
            dic[v.itemId] = dic[v.itemId] ~= nil and dic[v.itemId] + v.amount or v.amount
        end
        local array = {}
        for k,v in pairs(dic) do
            table.insert(array, {itemId = k, count = v})
        end
        getMainLayer():getParent():addChild(createMultiItemLayer(array, -140))
    end
    doActionFun("REWARDLIST_LUCKYREWARD", {_data.uid}, callback)
end
LuckyRewardViewOwner["todayItemClick"] = todayItemClick

local function itemClick(tag)
    local dic = _data.items[tostring(tag)]
    local itemId = dic.itemId
    local count = dic.amount

    if havePrefix(itemId, "weapon_") or havePrefix(itemId, "belt_") or havePrefix(itemId, "armor_") then
        -- 装备
        if haveSuffix(itemId, "_shard") then
            itemId = string.sub(itemId, 1, -7)
        end
        getMainLayer():getParent():addChild(createEquipInfoLayer(itemId, 2, -140), 10)
    elseif havePrefix(itemId, "item") or havePrefix(itemId, "key") or havePrefix(itemId, "bag") 
        or havePrefix(itemId, "stuff") or havePrefix(itemId, "drawing") or havePrefix(itemId, "soulbag") then
        -- 道具
        getMainLayer():getParent():addChild(createItemDetailInfoLayer(itemId, -140, 1, 1), 10)
    elseif havePrefix(itemId, "shadow") then
        -- 影子
        local dic = {}
        local item = shadowData:getOneShadowConf(itemId)
        dic.conf = item
        dic.id = itemId
        getMainLayer():getParent():addChild(createShadowPopupLayer(dic, nil, nil, -140, 1), 10)
    elseif havePrefix(itemId, "hero") then
        -- 魂魄
        getMainLayer():getParent():addChild(createHeroInfoLayer(itemId, HeroDetail_Clicked_Handbook, -140), 10)
    elseif havePrefix(itemId, "book") then
        -- 奥义
        getMainLayer():getParent():addChild(createHandBookSkillDetailLayer(itemId, -140), 10) 
    elseif havePrefix(itemId, "chapter_") then
        -- 残章
        local bookId = string.format("book_%s", string.split(itemId, "_")[2])
        getMainLayer():getParent():addChild(createHandBookSkillDetailLayer(bookId, -140), 10) 
    else
        -- 金币 银币
    end
end
LuckyRewardViewOwner["itemClick"] = itemClick

local function rankItemClick()
    getDailyLayer():moveToPageByName(Daily_LuckyRank)
end
LuckyRewardViewOwner["rankItemClick"] = rankItemClick

local function shopItemClick()
    getDailyLayer():moveToPageByName(Daily_LuckyShop)
end
LuckyRewardViewOwner["shopItemClick"] = shopItemClick


-- 该方法名字每个文件不要重复
function getLuckyRewardLayer()
	return _layer
end

function createLuckyRewardLayer()
    _init()

    function _layer:getInfo()
         _getInfo()
    end

    local function _onEnter()
        addObserver(NOTI_TICK, refreshTime)
    end

    local function _onExit()
        removeObserver(NOTI_TICK, refreshTime)
        _layer = nil
        if ballScheduler ~= nil then
            scheduler:unscheduleScriptEntry(ballScheduler)
            ballScheduler = nil
        end
        _lightOffset = 0
        _bAni = false
        _data = nil
        _gain = nil
    end

    --onEnter onExit
    local function _layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        end
    end

local function onTouchBegan(x, y)
        if _bAni then
            return true
        end
        return false
    end

    local function onTouchEnded(x, y)
    end

    local function onTouch(eventType, x, y)
        if eventType == "began" then   
            return onTouchBegan(x, y)
        elseif eventType == "moved" then
        elseif eventType == "ended" then
        end
    end
    _layer:registerScriptTouchHandler(onTouch, false, -300, true)
    _layer:setTouchEnabled(true)
    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end