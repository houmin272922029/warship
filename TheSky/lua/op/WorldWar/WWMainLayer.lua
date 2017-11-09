local _layer
local _drag = false
local _show = false
local FRAME_OFFSET
local _touchBeginX = 0
local _contentX = 0
local allScore

-- 名字不要重复
WWMainOwner = WWMainOwner or {}
ccb["WWMainOwner"] = WWMainOwner


local function islandClick(tag)
    local function getIslandDataCallback(url, rtnData)
        local data = rtnData.info
        local dic = {["playerData"] = data.playerData, ["island"] = data.islandData}
        worldwardata:fromDic(dic)
        getMainLayer():gotoWorldWarIsland()
    end
    doActionFun("WW_GET_ISLANDDATA", {string.format("island_%02d", tag)}, getIslandDataCallback)
end

local function addIslandTouch()

    local function hideSprite(sender)
        sender:setVisible(false)
    end

    local function hide()
        _show = false
    end

    local _posX = 0

    local function onTouchBegan(x, y)
        local contentLayer = tolua.cast(WWMainOwner["contentLayer"], "CCLayer")
        local touchLocation = contentLayer:convertToNodeSpace(ccp(x, y))
        local rect = contentLayer:boundingBox()
        rect = CCRectMake(0, 0, rect.size.width / retina, rect.size.height / retina)
        if rect:containsPoint(touchLocation) then
            _posX = x
            _touchBeginX = x
            -- if not _show then
            --     _show = true
            --     for i=1,13 do
            --         local info = tolua.cast(WWMainOwner["info_"..i], "CCSprite")
            --         info:setVisible(true)
            --         info:setOpacity(255)
            --         local fade = CCFadeOut:create(0.5)
            --         local array = CCArray:create()
            --         array:addObject(CCDelayTime:create(10))
            --         array:addObject(fade)
            --         array:addObject(CCCallFuncN:create(hideSprite))
            --         info:runAction(CCSequence:create(array))
            --     end
            --     _layer:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(10.5), CCCallFunc:create(hide)))
            -- end
        end
        return true
    end

    local function onTouchMoved(x, y)
        _drag = math.abs(_touchBeginX - x) > 10 and true or false
        if _drag then
            local contentLayer = tolua.cast(WWMainOwner["contentLayer"], "CCLayer")
            local touchLocation = contentLayer:convertToNodeSpace(ccp(x, y))
            local offsetX = _posX - x
            local posX, posY = contentLayer:getPosition()
            _contentX = posX - offsetX
            if _contentX > FRAME_OFFSET + 20 then
                _contentX = FRAME_OFFSET + 20
            elseif _contentX < winSize.width - contentLayer:getContentSize().width * retina - FRAME_OFFSET - 20 then
                _contentX = winSize.width - contentLayer:getContentSize().width * retina - FRAME_OFFSET - 20
            end
            contentLayer:setPosition(ccp(_contentX, posY))
            _posX = x
        end
    end

    local function onTouchEnded(x, y)
        local contentLayer = tolua.cast(WWMainOwner["contentLayer"], "CCLayer")
        local touchLocation = contentLayer:convertToNodeSpace(ccp(x, y))
        if not _drag then
            for i=1,13 do
                local island = tolua.cast(WWMainOwner[string.format("island_%02d", i)], "CCSprite")
                local touchLocation = contentLayer:convertToNodeSpace(ccp(x, y))
                local rect = island:boundingBox()
                if rect:containsPoint(touchLocation) then
                    islandClick(i)
                    _posX = x
                    _drag = false
                    return
                end

            end
        end

        _posX = x
        _drag = false

        local offsetX = _posX - x
        local posX, posY = contentLayer:getPosition()
        -- local newX = posX - offsetX
        if posX >= FRAME_OFFSET then
            _contentX = FRAME_OFFSET
        elseif posX <= winSize.width - contentLayer:getContentSize().width * retina - FRAME_OFFSET then
            _contentX = winSize.width - contentLayer:getContentSize().width * retina - FRAME_OFFSET
        end
        contentLayer:runAction(CCMoveTo:create(0.3, ccp(_contentX, contentLayer:getPositionY())))
    end

    local function onTouch(eventType, x, y)
        if eventType == "began" then   
            return onTouchBegan(x, y)
        elseif eventType == "moved" then
            return onTouchMoved(x, y)
        elseif eventType == "ended" then
            return onTouchEnded(x, y)
        end
    end

    local contentLayer = tolua.cast(WWMainOwner["contentLayer"], "CCLayer")
    contentLayer:registerScriptTouchHandler(onTouch, false , -129 , false)
    contentLayer:setTouchEnabled(true)
end

-- 总战绩刷新
local function refreshTotalReward()
    local allScoreLayer = tolua.cast(WWMainOwner["allScoreLayer"], "CCLayer")
    local progressBg = tolua.cast(WWMainOwner["progressLayer"], "CCLayer")
    local rewardItem = tolua.cast(WWMainOwner["rewardItem"], "CCMenuItem")
    local allScoreLabel = tolua.cast(WWMainOwner["allScoreLabel"], "CCLabelTTF")
    local maxLabel = tolua.cast(WWMainOwner["max"], "CCLabelTTF")
    local min, max = worldwardata:getAllScoreMinMax()
    if max == nil then
        allScoreLayer:setVisible(false)
        rewardItem:setVisible(false)
        return
    end
    maxLabel:setString(max)
    local add = 0
    if not allScore then
        allScore = worldwardata.playerData.allScore
    else
        -- 需要做动画
        add = worldwardata.playerData.allScore - allScore
    end
    allScoreLabel:setString(allScore)
    local progress = tolua.cast(progressBg:getChildByTag(1001), "CCProgressTimer")
    if not progress then
        progress = CCProgressTimer:create(CCSprite:create("images/ww_reward_progress.png"))
        progress:setType(kCCProgressTimerTypeRadial)
        progress:setMidpoint(CCPointMake(0.5, 0.5))
        progress:setBarChangeRate(CCPointMake(0, 1))
        progress:setPosition(progress:getContentSize().width / 2, progress:getContentSize().height / 2)
        progressBg:addChild(progress,0, 1001)
    end
    progress:setPercentage(math.min(allScore / max * 100, 100))
    if add > 0 then
        local addPic = CCLabelBMFont:create(add, "ccbResources/breakNumber.fnt")
        progressBg:addChild(addPic, 144)
        addPic:setScale(0.01)
        addPic:setPosition(progress:getContentSize().width / 2, progress:getContentSize().height / 2)
        addPic:setAnchorPoint(ccp(0.5, 0.5))

        local function textAction(sender)
            local function removeLabel()
                sender:removeFromParentAndCleanup(true)
            end
            local array = CCArray:create()
            if add > 20 then
                array:addObject(CCScaleTo:create(0.1, 1.2))
            else
                array:addObject(CCScaleTo:create(0.1, 1))
            end
            array:addObject(CCScaleBy:create(0.1, 0.8))
            array:addObject(CCDelayTime:create(0.25))
            array:addObject(CCFadeOut:create(0.1))
            array:addObject(CCCallFunc:create(removeLabel))
            local seq = CCSequence:create(array)
            sender:runAction(seq)
        end
        if add > 20 then
            addPic:setColor(ccc3(255, 0, 0))
        end
        local function addAni()
            textAction(addPic)     
        end
        local function scoreAdd()
            allScoreLabel:setString(allScore)
        end
        local function progressAni()
            progress:runAction(CCProgressTo:create(0.5, math.min(allScore / max * 100, 100))) 
        end
        local function refreshScore()
            allScore = allScore + add 
        end
        local array = CCArray:create()
        array:addObject(CCDelayTime:create(0.3))
        array:addObject(CCCallFunc:create(addAni))
        array:addObject(CCDelayTime:create(0.3))
        array:addObject(CCCallFunc:create(refreshScore))
        array:addObject(CCDelayTime:create(0.1))
        array:addObject(CCCallFunc:create(scoreAdd))
        array:addObject(CCCallFunc:create(progressAni))
        progressBg:runAction(CCSequence:create(array))
    end
end

local function refresh()
    local function setString(key, str)
        local label = tolua.cast(WWMainOwner[key], "CCLabelTTF")
        label:setString(str)
        label:setVisible(true)
    end
    setString("name", userdata.name)
    setString("level", string.format("LV:%d", userdata.level))
    setString("durability", string.format("%d/%d", worldwardata.playerData.durability, worldwardata:getDurabilityMax(worldwardata.playerData.durabilityLevel)))
    setString("brave", worldwardata.playerData.courage)
    setString("islandCount", worldwardata:getCaptureCount())
    local leaderKey = worldwardata.playerData.leaderKey
    local jobBuff = 0
    if leaderKey and leaderKey ~= "" then
        jobBuff = math.floor(ConfigureStorage.WWJob[leaderKey + 1].property * 100)
    end
    setString("jobAttr", string.format("%d%%", jobBuff))

    local vip = tolua.cast(WWMainOwner["vip"], "CCSprite")
    vip:setVisible(true)
    vip:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("VIP_%d.png", vipdata:getVipLevel())))

    local cursor = tolua.cast(WWMainOwner["cursor"], "CCLayer")
    for i=1,13 do
        local islandId = string.format("island_%02d", i)
        if islandId == worldwardata.playerData.islandId then
            local item = tolua.cast(WWMainOwner[islandId], "CCSprite")
            cursor:setPosition(item:getPositionX(), item:getPositionY())
        end
        local data = worldwardata.islandData[islandId]
        local count = tolua.cast(WWMainOwner["count_"..i], "CCLabelTTF")
        count:setString(data.count)

        local badge = tolua.cast(WWMainOwner["badge_"..i], "CCSprite")
        local info = tolua.cast(WWMainOwner["info_"..i], "CCSprite")
        local group = data.countryId
        if not data.countryId then
            badge:setVisible(false)
            info:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("island_info_bg_0.png"))
        else
            badge:setVisible(true)
            local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("badge_%d.png", tonumber(string.split(group, "_")[2])))
            badge:setDisplayFrame(frame)
            info:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("island_info_bg_%d.png", tonumber(string.split(group, "_")[2]))))
        end
        for j=0,1 do
            local islandName = tolua.cast(WWMainOwner[string.format("island_name_%d_%d", i, j)], "CCLabelTTF")
            local conf = ConfigureStorage.WWIsland[islandId]
            if conf.type == 1 and group then
                local color = group == worldwardata.playerData.countryId and ccc3(171, 197, 0) or ccc3(255, 120, 0)
                if j == 1 then
                    islandName:setColor(color)
                end
            end
            islandName:setString(worldwardata:getIslandName(islandId))
        end
    end
    refreshTotalReward()
end


local function buyDurabilityClick()
    local dur = worldwardata.playerData.durability
    local durMax = worldwardata:getDurabilityMax(worldwardata.playerData.durabilityLevel)
    if dur < durMax then
        local count = worldwardata.playerData.durabilityBuyCount
        if not count or count == "" then
            count = 0
        end
        if not ConfigureStorage.WWDurableRecover[tostring(count + 1)] then
            ShowText(HLNSLocalizedString("ww.text.4"))
            return
        end
    else
        local nextLevel =  ConfigureStorage.WWDurable[worldwardata.playerData.durabilityLevel + 2]
        if not nextLevel then
            ShowText(HLNSLocalizedString("ww.text.5"))
            return
        end
        if nextLevel.vip > vipdata:getVipLevel() then
            ShowText(HLNSLocalizedString("ww.text.6", nextLevel.vip))
            return
        end
    end
    getMainLayer():getParent():addChild(createWWBuyDurabilityLayer(dur >= durMax, -133))
end
WWMainOwner["buyDurabilityClick"] = buyDurabilityClick

local function experimentItemClick()
    getMainLayer():gotoWorldWarExperiment()
end
WWMainOwner["experimentItemClick"] = experimentItemClick

local function recordItemClick()
    getMainLayer():gotoWorldWarRecord()
end
WWMainOwner["recordItemClick"] = recordItemClick

local function groupItemClick()
    getMainLayer():gotoWorldWarGroup()
end
WWMainOwner["groupItemClick"] = groupItemClick

local function rewardItemClick()
    getMainLayer():getParent():addChild(createWWAllScorePopupLayer(-133))
end
WWMainOwner["rewardItemClick"] = rewardItemClick

local function helpItemClick()
    local array = {}
    for i,v in ipairs(ConfigureStorage.WWHelp1) do
        table.insert(array, v.desp)
    end
    getMainLayer():getParent():addChild(createCommonHelpLayer(array, -133))
end
WWMainOwner["helpItemClick"] = helpItemClick

local function chatItemClick()
    getMainLayer():TitleBgVisible(true)
    getMainLayer():gotoChatLayer(ChatType.allServerChat,false)
end
WWMainOwner["chatItemClick"] = chatItemClick

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/WWMainView.ccbi", proxy, true,"WWMainOwner")
    _layer = tolua.cast(node,"CCLayer")

    addIslandTouch()
    refresh()

    -- local ship = tolua.cast(WWMainOwner["ship"], "CCSprite")
    -- local array = CCArray:create()
    -- array:addObject(CCEaseOut:create(CCMoveTo:create(22 / 30, ccp(50, 70)), 2))
    -- array:addObject(CCEaseIn:create(CCMoveTo:create(23 / 30, ccp(50, 80)), 2))
    -- ship:runAction(CCRepeatForever:create(CCSequence:create(array)))

    for i=1,13 do
        local info = tolua.cast(WWMainOwner["info_"..i], "CCSprite")
        info:setVisible(true)
    end
    FRAME_OFFSET = (winSize.width - 560 * retina) / 2

    local ww_frame = tolua.cast(WWMainOwner["ww_frame"], "CCSprite")
    local offset = (winSize.height / retina - 180) - 877
    ww_frame:setPosition(ccp(ww_frame:getPositionX(), offset))
end

-- 该方法名字每个文件不要重复
function getWWMainLayer()
	return _layer
end

local function relocateLayer()
    local contentLayer = tolua.cast(WWMainOwner["contentLayer"], "CCLayer")
    if _contentX and _contentX <= FRAME_OFFSET and _contentX >= winSize.width - contentLayer:getContentSize().width * retina - FRAME_OFFSET then
        local _, posY = contentLayer:getPosition()
        contentLayer:setPosition(ccp(_contentX, posY))
    end
end

function resetWWAllScore()
    allScore = nil
end

function createWWMainLayer()
    _init()

    function _layer:refreshTotalReward()
        refreshTotalReward()
    end

    local function _onEnter()
        local function title()
            getMainLayer():TitleBgVisible(false) 
        end
        _layer:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.02), CCCallFunc:create(title)))
        addObserver(NOTI_WW_REFRESH, refresh)
        relocateLayer()
    end

    local function _onExit()
        removeObserver(NOTI_WW_REFRESH, refresh)
        _layer = nil
        _drag = false
        _show = false
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