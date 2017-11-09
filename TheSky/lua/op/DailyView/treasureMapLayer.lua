local _layer
local pos
local newPos
local bAni
local exploreCount
local dic

-- 名字不要重复
TreasureMapOwner = TreasureMapOwner or {}
ccb["TreasureMapOwner"] = TreasureMapOwner

DiceAniOwner = DiceAniOwner or {}
ccb["DiceAniOwner"] = DiceAniOwner

local function refreshData()
    local count = tolua.cast(TreasureMapOwner["count"], "CCLabelTTF") 
    count:setString(dailyData.daily[Daily_Treasure].times)
    local goldLabel = tolua.cast(TreasureMapOwner["gold"], "CCLabelTTF")
    local gold = userdata:getFunctionOfNumberAcronym(tonumber(userdata.gold))
    goldLabel:setString(gold)
    local berryLabel = tolua.cast(TreasureMapOwner["berry"], "CCLabelTTF")
    local berry = userdata:getFunctionOfNumberAcronym(tonumber(userdata.berry))
    berryLabel:setString(berry)
end

local function refresh()
    pos = dailyData.daily[Daily_Treasure].position + 1
    local flag = tolua.cast(TreasureMapOwner["flag"], "CCSprite")
    local frame = tolua.cast(TreasureMapOwner["frame"..pos], "CCSprite")
    flag:setPosition(frame:getPositionX(), frame:getPositionY())
    for i=1,20 do
        local frame = tolua.cast(TreasureMapOwner["frame"..i], "CCSprite")
        local icon = tolua.cast(TreasureMapOwner["icon"..i], "CCSprite")
        local label = tolua.cast(TreasureMapOwner["label"..i], "CCLabelTTF")
        if dailyData.daily[Daily_Treasure].map[tostring(i - 1)] ~= -1 then
            local itemDic = ConfigureStorage.rollingTable[tostring(dailyData.daily[Daily_Treasure].map[tostring(i - 1)])]
            local res = wareHouseData:getItemResource(itemDic.itemId)
            frame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", res.rank)))
            if res.icon then
                local texture = CCTextureCache:sharedTextureCache():addImage(res.icon)
                if texture then
                    icon:setTexture(texture)
                end
            end
            local amount = itemDic.amount
            if itemDic.itemId == "x3" then
                label:setString(res.name)
            else
                label:setString(HLNSLocalizedString("treasure.award", amount, res.name))
            end
            icon:setVisible(true)
 
            -- renzhan
            if itemDic.lighten == 1 then
                TreasureMapOwner["linghtingEffect_"..i]:setVisible(true)
            else
                TreasureMapOwner["linghtingEffect_"..i]:setVisible(false)
            end

        else
            frame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("frame_1.png"))
            icon:setVisible(false)
            label:setVisible(false)
        end
    end
    refreshData()
end

local function menuEnable(sender)
    sender:setEnabled(true)
end

local function menuDisable(sender)
    sender:setEnabled(false) 
end

local function showNode(sender)
    sender:setVisible(true)
end

local function hideNode(sender)
    sender:setVisible(false) 
end

local function cardAni(index)
    local frameArray = {}
    local frame = tolua.cast(TreasureMapOwner["frame"..index], "CCSprite")
    local icon = tolua.cast(TreasureMapOwner["icon"..index], "CCSprite")
    local label = tolua.cast(TreasureMapOwner["label"..index], "CCLabelTTF")
    local item = tolua.cast(TreasureMapOwner["item"..index], "CCMenuItem")

    local enable = CCCallFuncN:create(menuEnable)
    local disable = CCCallFuncN:create(menuDisable)
    local itemArray = CCArray:create()
    itemArray:addObject(disable)
    itemArray:addObject(CCDelayTime:create(2))
    itemArray:addObject(enable)
    item:runAction(CCSequence:create(itemArray))

    local frameArray = CCArray:create()
    frameArray:addObject(CCScaleTo:create(0.2, 0, 1))
    frameArray:addObject(CCScaleTo:create(0.2, 1, 1))
    frameArray:addObject(CCDelayTime:create(1))
    frameArray:addObject(CCScaleTo:create(0.2, 0, 1))
    frameArray:addObject(CCScaleTo:create(0.2, 1, 1))
    frame:runAction(CCSequence:create(frameArray))

    local iconArray = CCArray:create()
    iconArray:addObject(CCDelayTime:create(0.2))
    iconArray:addObject(CCCallFuncN:create(hideNode))
    iconArray:addObject(CCDelayTime:create(1.4))
    iconArray:addObject(CCCallFuncN:create(showNode))
    icon:runAction(CCSequence:create(iconArray))

    local labelArray = CCArray:create()
    labelArray:addObject(CCDelayTime:create(0.2))
    labelArray:addObject(CCCallFuncN:create(showNode))
    labelArray:addObject(CCDelayTime:create(1.4))
    labelArray:addObject(CCCallFuncN:create(hideNode))
    label:runAction(CCSequence:create(labelArray))

end

local function itemClick(tag)
    if tag ~= pos and dailyData.daily[Daily_Treasure].map[tostring(tag - 1)] ~= -1 then
        cardAni(tag)
    end
end
TreasureMapOwner["itemClick"] = itemClick


local function explore(bTen)

    local function aniStart()
        bAni = true 
    end

    local function aniEnd()
        bAni = false
        exploreCount = exploreCount - 1
        if exploreCount > 0 then
            explore()
        end
    end

    local function removeNode(sender)
        sender:removeFromParentAndCleanup(true) 
    end

    local function awardAni()
        local frame = tolua.cast(TreasureMapOwner["frame"..newPos], "CCSprite")
        -- print(dailyData.daily[Daily_Treasure].map[tostring(newPos - 1)])
        local itemDic = ConfigureStorage.rollingTable[tostring(dailyData.daily[Daily_Treasure].map[tostring(newPos - 1)])]
        local res = wareHouseData:getItemResource(itemDic.itemId)
        local sp = CCSprite:create(res.icon)
        sp:setScale(0.36)
        sp:setPosition(frame:getPositionX(), frame:getPositionY())
        frame:getParent():addChild(sp, 100)
        local viewItem = tolua.cast(TreasureMapOwner["viewItem"], "CCMenuItem")
        local move = CCMoveTo:create(0.5, ccp(viewItem:getPositionX(), viewItem:getPositionY()))
        local fade = CCFadeOut:create(0.5)
        local spawn = CCSpawn:createWithTwoActions(move, fade)
        sp:runAction(CCSequence:createWithTwoActions(spawn, CCCallFuncN:create(removeNode)))

        for k,v in pairs(dic.gain) do
            if k == "titles" or k == "encounter" then
            elseif k == "awardTimes" then
                ShowText(itemDic.name)
            elseif k == "books" then
                ShowText(skilldata:gainSkillString(v))
            else
                if k == "silver" or k == "gold" or string.find(itemDic.itemId, "dice") then
                    if k == "silver" or k == "gold" then
                        userdata:popUpGain(dic.gain, true)
                    else
                        local res = wareHouseData:getItemResource(itemDic.itemId)
                        ShowText(HLNSLocalizedString("treasure.getAward", v, res.name)) 
                    end
                else
                    for j,amount in pairs(v) do
                        ShowText(HLNSLocalizedString("treasure.getAward", amount, itemDic.name))
                    end
                end
            end
        end

    end

    local function updateData()
        dailyData:updateTreasure(dic)
    end

    local function refreshAction()
        for i=1,20 do
            local removeSpriteArray = CCArray:create()
            local sprite = CCSprite:createWithSpriteFrameName("treasureCard_itemRefresh_1.png")
            TreasureMapOwner["frame"..i]:addChild(sprite)
            sprite:setPosition(ccp(51, 51))
            local animFrames = CCArray:create()

            for j = 1, 4 do
                local frameName = string.format("treasureCard_itemRefresh_%d.png",j)
                local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(frameName)
                animFrames:addObject(frame)
            end
            sprite:runAction(CCAnimate:create(CCAnimation:createWithSpriteFrames(animFrames, 0.1)))

            function removeSprite( )
                sprite:removeFromParentAndCleanup(true)
            end

            removeSpriteArray:addObject(CCDelayTime:create(0.4))
            removeSpriteArray:addObject(CCCallFunc:create(removeSprite))
            _layer:runAction(CCSequence:create(removeSpriteArray))

        end
    end

    local function exploreAni()
        local count = newPos - pos
        if newPos < pos then
            -- 走了一圈
            count = count + 20
        end
        local flag = tolua.cast(TreasureMapOwner["flag"], "CCSprite")
        local array = CCArray:create()
        local interval = 0.1
        for i=1, count do
            pos = pos % 20 + 1
            array:addObject(CCDelayTime:create(interval))
            local frame = tolua.cast(TreasureMapOwner["frame"..pos], "CCSprite")
            array:addObject(CCMoveTo:create(interval, ccp(frame:getPositionX(), frame:getPositionY())))
        end
        flag:runAction(CCSequence:create(array))

        if pos == 1 then
            local newArray = CCArray:create()
            newArray:addObject(CCDelayTime:create(interval * 2 * count))
            newArray:addObject(CCCallFunc:create(refreshAction))
            _layer:runAction(CCSequence:create(newArray))
        end

        local aniArray = CCArray:create()
        aniArray:addObject(CCCallFunc:create(aniStart))
        aniArray:addObject(CCDelayTime:create(count * interval * 2 + interval))
        aniArray:addObject(CCCallFunc:create(aniEnd))
        aniArray:addObject(CCCallFunc:create(awardAni))
        aniArray:addObject(CCCallFunc:create(updateData))
        aniArray:addObject(CCCallFunc:create(refresh))
        _layer:runAction(CCSequence:create(aniArray))

        local cursor = tolua.cast(TreasureMapOwner["cursor"], "CCSprite")
        local frame = tolua.cast(TreasureMapOwner["frame"..newPos], "CCSprite")
        cursor:setVisible(true)
        cursor:setPosition(ccp(frame:getPositionX(), frame:getPositionY()))
        cursor:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(count * interval * 2), CCCallFuncN:create(hideNode)))
    end

    local function diceAni()
        local removeSpriteArray = CCArray:create()
        local sprite = CCSprite:createWithSpriteFrameName("treasureCard_diceLight_1.png")
        sprite:setPosition(ccp(92,100))
        TreasureMapOwner["dice_ani"]:addChild(sprite)
        local animFrames = CCArray:create()
        for j = 1, 4 do
            local frameName = string.format("treasureCard_diceLight_%d.png",j)
            local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(frameName)
            animFrames:addObject(frame)
        end
        sprite:runAction(CCAnimate:create(CCAnimation:createWithSpriteFrames(animFrames, 0.1)))

        function removeSprite( )
            sprite:removeFromParentAndCleanup(true)
        end

        removeSpriteArray:addObject(CCDelayTime:create(0.4))
        removeSpriteArray:addObject(CCCallFunc:create(removeSprite))
        _layer:runAction(CCSequence:create(removeSpriteArray))

        local diceFrame = tolua.cast(TreasureMapOwner["dice_ani"], "CCSprite")
        local dice = tolua.cast(TreasureMapOwner["dice_icon"], "CCSprite")
        local exploreItem = tolua.cast(TreasureMapOwner["exploreItem"], "CCMenuItem")

        local itemArray = CCArray:create()
        itemArray:addObject(CCCallFuncN:create(hideNode))
        itemArray:addObject(CCDelayTime:create(1))
        itemArray:addObject(CCCallFuncN:create(showNode))
        exploreItem:runAction(CCSequence:create(itemArray))

        local diceArray = CCArray:create()
        diceArray:addObject(CCCallFuncN:create(hideNode))
        diceArray:addObject(CCDelayTime:create(1))
        diceArray:addObject(CCCallFuncN:create(showNode))
        dice:runAction(CCSequence:create(diceArray))

        local diceAniArray = CCArray:create()
        diceAniArray:addObject(CCCallFuncN:create(showNode))
        diceAniArray:addObject(CCDelayTime:create(1))
        diceAniArray:addObject(CCCallFuncN:create(hideNode))
        diceFrame:runAction(CCSequence:create(diceAniArray))

    end

    local function exploreCallback(url, rtnData)
        refreshData()
        newPos = rtnData.info.newPosition + 1
        dic = rtnData["info"]
        local dice = tolua.cast(TreasureMapOwner["dice_icon"], "CCSprite")
        dice:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("dice_icon_%d.png", rtnData["info"]["diceNumber"])))
        local array = CCArray:create()
        array:addObject(CCCallFunc:create(diceAni))
        array:addObject(CCDelayTime:create(1))
        array:addObject(CCCallFunc:create(exploreAni))
        _layer:runAction(CCSequence:create(array))

        local frame = tolua.cast(TreasureMapOwner["frame"..newPos], "CCSprite")
        local moving = tolua.cast(TreasureMapOwner["movingFlag"], "CCSprite")
        moving:runAction(CCFadeIn:create(0.25))
        local array1 = CCArray:create()
        local function moveAndFadeOut()
            moving:runAction(CCFadeOut:create(0.5))
            moving:setPosition(TreasureMapOwner["dice_icon"]:getPositionX(), TreasureMapOwner["dice_icon"]:getPositionY())
        end
        array1:addObject(CCDelayTime:create(0.5))
        array1:addObject(CCMoveTo:create(0.5, ccp(frame:getPositionX(),frame:getPositionY())))
        array1:addObject(CCCallFunc:create(moveAndFadeOut))
        moving:runAction(CCSequence:create(array1))
    end

    local function exploreErrorCallback(url, code)
        exploreCount = 0
    end

    local function multiExploreCallback(url, rtnData)
        dic = rtnData["info"]
        newPos = rtnData.info.newPosition + 1
        local dice = tolua.cast(TreasureMapOwner["dice_icon"], "CCSprite")
        dice:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("dice_icon_%d.png", rtnData["info"]["diceNumber"])))
        local array = CCArray:create()
        array:addObject(CCCallFunc:create(aniStart))
        array:addObject(CCCallFunc:create(diceAni))
        array:addObject(CCDelayTime:create(1))
        local function showResult()
            dailyData:updateTreasure(dic)
            userdata:updateUserDataWithGainAndPay(dic["gain"], dic["pay"])
            userdata:popUpGain(dic["gain"], true)

        end
        array:addObject(CCCallFunc:create(showResult))
        array:addObject(CCCallFunc:create(refresh))
        array:addObject(CCCallFunc:create(aniEnd))
        _layer:runAction(CCSequence:create(array))


        local newArray = CCArray:create()
        newArray:addObject(CCDelayTime:create(1))
        newArray:addObject(CCCallFunc:create(refreshAction))
        _layer:runAction(CCSequence:create(newArray))

        -- local dic = rtnData["info"]
        -- userdata:updateUserDataWithGainAndPay(dic["gain"], dic["pay"])
        -- userdata:popUpGain(dic["gain"], true)
    end

    if bTen then
        doActionFun("MULTI_EXPLORE_TREASURE", {}, multiExploreCallback, exploreErrorCallback)
    else
        doActionFun("EXPLORE_TREASURE", {}, exploreCallback, exploreErrorCallback) 
    end
end

local function onceClick(tag)
    Global:instance():TDGAonEventAndEventData("lucky1")
    exploreCount = 1
    explore()
end
TreasureMapOwner["onceClick"] = onceClick


local function closeClick(tag)
    Global:instance():TDGAonEventAndEventData("lucky2")
    getMainLayer():TitleBgVisible(true)
    getMainLayer():gotoDaily()
end
TreasureMapOwner["closeClick"] = closeClick


local function tenthClick(tag)
    Global:instance():TDGAonEventAndEventData("lucky3")
    exploreCount = 1
    explore(true)
end
TreasureMapOwner["tenthClick"] = tenthClick

local function getTreasureGets(url, rtnData)
    getMainLayer():getParent():addChild(createTreasureAwardLayer(rtnData["info"]), 300)
end

local function viewClick(tag)
    Global:instance():TDGAonEventAndEventData("lucky4")
    doActionFun("GET_TREASURE_GETS", {}, getTreasureGets) 
end
TreasureMapOwner["viewClick"] = viewClick


-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/TreasureSecondView.ccbi", proxy, true,"TreasureMapOwner")
    _layer = tolua.cast(node,"CCLayer")
    for i=1,20 do
        local item = tolua.cast(TreasureMapOwner["item"..i], "CCMenuItem")
        item:setOpacity(0)
        -- renzhan
        local animFrames = CCArray:create()
        for j = 1, 3 do
            local frameName = string.format("treasureCard_roundFrame_%d.png",j)
            local fra = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(frameName)
            animFrames:addObject(fra)
        end
        local animation = CCAnimation:createWithSpriteFrames(animFrames, 0.3)
        local animate = CCAnimate:create(animation)
        TreasureMapOwner["linghtingEffect_"..i]:runAction(CCRepeatForever:create(animate))
    end
    refresh()
end

-- 该方法名字每个文件不要重复
function getTreasureMapLayer()
	return _layer
end

local function onTouchBegan(x, y)
    -- print("exploreCount", exploreCount)
    if exploreCount == 0 and not bAni then
        return false
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

local function diceFrameAni()
    local sprite = tolua.cast(TreasureMapOwner["dice_ani"], "CCSprite")
    local animFrames = CCArray:createWithCapacity(4)
    for i=1,5 do
        local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("dice_frame_%d.png", i))
        animFrames:addObject(frame)
    end

    local animation = CCAnimation:createWithSpriteFrames(animFrames, 0.05)
    sprite:runAction(CCRepeatForever:create( CCAnimate:create(animation)))
end

function createTreasureMapLayer()
    _init()

    local function _onEnter()
        exploreCount = 0
        bAni = false
        diceFrameAni()
    end

    local function _onExit()
        _layer = nil
        pos = 1
        newPos = 1
        bAni = false
        exploreCount = 0
        dic = nil
    end

    --onEnter onExit
    local function _layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        end
    end
    _layer:registerScriptTouchHandler(onTouch ,false ,-300 ,true )
    _layer:setTouchEnabled(true)
    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end