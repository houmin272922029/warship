local _layer
local scheduler = CCDirector:sharedDirector():getScheduler()
local auotScheduler
local _posX = 0
local _posY = 0
local _lineRect = {minx = 0, miny = 0, maxx = 0, maxy = 0}
local currentPass = 0
-- local mapArray = {}
local fightType
local auto = false
local _gain
local TYPE_FIGHT = {
    normal = 1,
    auto = 2,
}

local function newMap()
    local pos = ccp(0, 0)
    local array = {}
    if #runtimeCache.veiledSeaMapLayer > 0 then
        pos = runtimeCache.veiledSeaMapLayer[#runtimeCache.veiledSeaMapLayer]
    end
    local rand = RandomManager.randomRange(1, table.getTableCount(ConfigureStorage.SeaMiRoute)) 
    local confArray = ConfigureStorage.SeaMiRoute[string.format("route_%03d", rand)].point
    for i=1,table.getTableCount(confArray) do
        local arr = confArray[tostring(i)]
        pos = ccpAdd(pos, ccp(arr[1], arr[2]))
        _lineRect = {
            minx = math.min(_lineRect.minx, -pos.x), 
            miny = math.min(_lineRect.miny, -pos.y), 
            maxx = math.max(_lineRect.maxx, pos.x), 
            maxy = math.max(_lineRect.maxy, pos.y), 
        }
        table.insert(runtimeCache.veiledSeaMapLayer, pos)
        table.insert(array, pos)
    end
    return array
end

-- 名字不要重复
VeiledSeaChallengeOwner = VeiledSeaChallengeOwner or {}
ccb["VeiledSeaChallengeOwner"] = VeiledSeaChallengeOwner

local function closeItemClick()
    runtimeCache.veiledSeaState = 0
    showVeiledSea()
end
VeiledSeaChallengeOwner["closeItemClick"] = closeItemClick

local function addProperty()
    local attr = {hp = 0, atk = 0, def = 0, mp = 0}

    if veiledSeaData.data.bossSelected and table.getTableCount(veiledSeaData.data.bossSelected) ~= 0 then
        for k,v in pairs(veiledSeaData.data.bossSelected) do
            local conf = ConfigureStorage.SeaMiBossGroup[v].attr
            if conf then
                for key,value in pairs(conf) do
                    attr[key] = attr[key] + value
                end
            end 
        end
    end
    for k,v in pairs(attr) do
        local label = tolua.cast(VeiledSeaChallengeOwner[k], "CCLabelTTF")
        str = "%d%%"
        if v > 0 then
            label:setColor(ccc3(0,255,0))
            str = "+%d%%"
        elseif v < 0 then
            label:setColor(ccc3(255, 0, 0))
        else
            label:setColor(ccc3(255, 255, 255))
        end
        label:setString(string.format(str, math.ceil(v * 100)))
    end
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    _posX = touchLocation.x
    _posY = touchLocation.y
    return true
end

local function onTouchMoved(x, y)
    local flagLayer = tolua.cast(VeiledSeaChallengeOwner["flagLayer"], "CCLayer")
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local offsetX = x - _posX
    local offsetY = y - _posY
    local newPos = ccpAdd(ccp(offsetX, offsetY), ccp(flagLayer:getPositionX(), flagLayer:getPositionY()))
    flagLayer:setPosition(newPos)
    _posX = x
    _posY = y
end

local function onTouchEnded(x, y)
    
end

local function refreshData( )
    local flag = tolua.cast(VeiledSeaChallengeOwner["flag"], "CCSprite")
    if flag and userdata.flag then
        flag:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(userdata.flag..".png"))
    end 
    local stageKey = veiledSeaData.data.stageKey - 1
    local mapLayer = tolua.cast(VeiledSeaChallengeOwner["mapLayer"], "CCLayer")
    local pos = runtimeCache.veiledSeaMapLayer[tonumber(stageKey)] or ccp(0, 0)
    mapLayer:setPosition(ccp(-pos.x, -pos.y))
    currentPass = stageKey

    local count = tolua.cast(VeiledSeaChallengeOwner["count"], "CCLabelTTF")
    local rebirthCount = veiledSeaData.data.rebirthCount or 0
    count:setString(veiledSeaData.data.rebirthCount or 0)
    local proterty = tolua.cast(VeiledSeaChallengeOwner["proterty"], "CCLabelTTF")
    local allProperty = tolua.cast(VeiledSeaChallengeOwner["allProperty"], "CCLabelTTF")
    if rebirthCount > 0 then  
        proterty:setVisible(true)
        allProperty:setVisible(true)
        if ConfigureStorage.SeaMiChunge[tostring(veiledSeaData.data.rebirthCount)].attr then
            local str = "%d%%"
            local propertyNum = ConfigureStorage.SeaMiChunge[tostring(veiledSeaData.data.rebirthCount)].attr
            if propertyNum > 0 then
                str = "+%d%%"
                allProperty:setColor(ccc3(0,255,0))
            elseif v < 0 then
                allProperty:setColor(ccc3(255, 0, 0))
            else
                allProperty:setColor(ccc3(255, 255, 255))
            end

            allProperty:setString(string.format(str, math.floor(propertyNum * 100)))
        end
    else
        proterty:setVisible(false)
        allProperty:setVisible(false)
    end

    local challengeItem = tolua.cast(VeiledSeaChallengeOwner["challengeItem"], "CCMenuItem")
    local autoItem = tolua.cast(VeiledSeaChallengeOwner["autoItem"], "CCMenuItem")
    local stopItem = tolua.cast(VeiledSeaChallengeOwner["stopItem"], "CCMenuItem")
    local challengeText = tolua.cast(VeiledSeaChallengeOwner["challengeText"], "CCSprite")
    local autoText = tolua.cast(VeiledSeaChallengeOwner["autoText"], "CCSprite")
    local duringItem = tolua.cast(VeiledSeaChallengeOwner["duringItem"], "CCSprite")
    local duringText = tolua.cast(VeiledSeaChallengeOwner["duringText"], "CCSprite")
    local stopText = tolua.cast(VeiledSeaChallengeOwner["stopText"], "CCSprite")
    challengeItem:setVisible(not auto)
    autoItem:setVisible(not auto)
    stopItem:setVisible(auto)
    challengeText:setVisible(not auto)
    autoText:setVisible(not auto)
    duringItem:setVisible(auto)
    duringText:setVisible(auto)
    stopText:setVisible(auto)

    local rankLabel = tolua.cast(VeiledSeaChallengeOwner["rankLabel"], "CCLabelTTF")
    rankLabel:setString(veiledSeaData.data.stageKey)
end

local function getCellHeight( string,width,fontSize,fontName )
    if not fontName then
        fontName = "ccbResources/FZCuYuan-M03S.ttf"
    end
    local tempLabel = CCLabelTTF:create(string,fontName,fontSize,CCSizeMake(width,0),kCCTextAlignmentLeft)
    tempLabel:setVisible(false)
    _layer:addChild(tempLabel,200,8888)
    local height = tempLabel:getContentSize().height
    tempLabel:removeFromParentAndCleanup(true)
    return height
end

local function addPointAndLine(array, index)
    local mapLayer = tolua.cast(VeiledSeaChallengeOwner["mapLayer"],"CCLayer") 
    local lineLayer = tolua.cast(VeiledSeaChallengeOwner["lineLayer"],"CCLayer") 
    for i=1,table.getTableCount(array) do
        local current = i + index * 5
        local point = nil
        if i % 5 == 0 then
            local bossId = veiledSeaData.data.bossSelected[tostring(math.floor(i / 5 - 1 + index))]
            if not ConfigureStorage.SeaMiBossGroup[bossId] then
                return
            end
            local boss = ConfigureStorage.SeaMiBossGroup[bossId].boss
            local frame = CCSprite:createWithSpriteFrameName("frame_4.png")
            frame:setPosition(array[i])
            if havePrefix(boss.head, "hero_") then
                if CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(herodata:getHeroHeadByHeroId( boss.head )) then 
                    point = CCSprite:createWithSpriteFrameName(herodata:getHeroHeadByHeroId( boss.head ))
                    point:setPosition(frame:getContentSize().width / 2, frame:getContentSize().height / 2)
                    mapLayer:addChild(frame, 0, 10000 + current)
                    frame:addChild(point)
                else
                    point = CCSprite:createWithSpriteFrameName("hero_000328_head.png")
                    point:setPosition(frame:getContentSize().width / 2, frame:getContentSize().height / 2)
                    mapLayer:addChild(frame, 0, 10000 + current)
                    frame:addChild(point)
                end
            end
            if current < veiledSeaData.data.stageKey then
                local passedArrow = CCSprite:createWithSpriteFrameName("pass_front_bg.png")
                passedArrow:setPosition(ccp(frame:getContentSize().width / 2 - 5, frame:getContentSize().height / 2 - 5))
                point:addChild(passedArrow)
            end

            local awardId = nil
            local specialArray = {}
            local specialInfo = nil
            local labelSize = 20
            if isPlatform(IOS_MOB_THAI) 
                or isPlatform(ANDROID_VIETNAM_MOB_THAI) then
                labelSize = 26
            end
            local specialAward = CCLabelTTF:create("", "ccbResources/FZCuYuan-M03S.ttf", labelSize, CCSizeMake(point:getContentSize().width * 1.5,0), kCCTextAlignmentCenter)
            local resDic = nil
           
            local bossReward = veiledSeaData.data.bossRewardLogs
            if  current < veiledSeaData.data.stageKey then
                if bossReward and bossReward[tostring(math.floor(i / 5 + index) * 5)] then
                    local gain = bossReward[tostring(math.floor(i / 5  + index) * 5)].gain
                    local rewadType = "normal"
                    local rewadrKey = nil
                    rewadType = gain.type
                    rewadrKey = gain.key
                    specialArray = bossReward[tostring(math.floor(i / 5 + index) * 5)].options[rewadType][tostring(rewadrKey)]
                    awardId = specialArray.itemId
                    resDic = userdata:getExchangeResource(awardId)
                    specialInfo = tostring(resDic.name.." × "..specialArray.value)
                    -- specialAward:setColor(ccc3(0,255,0))
                end
            else
                specialArray = ConfigureStorage.SeaMiBossGroup[bossId].loot
                for k,v in pairs(specialArray) do
                    awardId = k
                end
                resDic = userdata:getExchangeResource(awardId)
                specialInfo = tostring(resDic.name.." × "..specialArray[tostring(awardId)].value) 
                -- specialAward:setColor(ccc3(255,255,255))
            end

            local grayBg = CCScale9Sprite:create("ccbResources/grayBg.png")
            local grayBgHeight = getCellHeight( specialInfo ,point:getContentSize().width * 1.7, 20, "ccbResources/FZCuYuan-M03S.ttf" )
            grayBg:setContentSize(CCSizeMake(point:getContentSize().width * 1.7, grayBgHeight + 20))
            grayBg:setAnchorPoint(ccp(0.5,0))
            grayBg:setPosition(ccp(frame:getPositionX(),frame:getPositionY() + frame:getContentSize().height * 0.6))
            mapLayer:addChild(grayBg,888)
            
            specialAward:setPosition(grayBg:getContentSize().width / 2, grayBg:getContentSize().height / 2)
            grayBg:addChild(specialAward)
            specialAward:setString(specialInfo)
            specialAward:setColor(shadowData:getColorByColorRank(resDic.rank))
        
        else
            if current < veiledSeaData.data.stageKey then
                point = CCSprite:createWithSpriteFrameName("mark_1.png")
            else
                point = CCSprite:createWithSpriteFrameName("mark_0.png")
            end
            point:setPosition(array[i])
            mapLayer:addChild(point, 0, 10000 + current) 
        end
        if i > 1 then
            local line = CCSprite:createWithSpriteFrameName("line_pixel.png")
            local lineLength = math.sqrt((array[i].x - array[i - 1].x) ^ 2 + (array[i].y - array[i - 1].y) ^ 2)
            local lineScaleX = lineLength / 5.0
            -- line:runAction(CCScaleTo:create(0.3, lineScaleX, 1))
            line:setScaleX(lineScaleX)
            local offsetY = array[i].y - array[i - 1].y
            local offsetX = array[i].x - array[i - 1].x
            local angle = math.deg(math.atan(math.abs(offsetY) / math.abs(offsetX)))
            if offsetX >= 0 and offsetY > 0 then
                angle = -angle
            elseif offsetX < 0 and offsetY <= 0 then
                angle = 180 - angle
            elseif offsetX < 0 and offsetY > 0 then
                angle = angle - 180
            end
            -- angle = (angle >= 90 and angle <= 180) and -(180 + angle) or -angle
            line:setRotation(angle)
            line:setPosition(array[i - 1])
            line:setAnchorPoint(ccp(0, 0.5))
            lineLayer:addChild(line)
        end
    end
    local line = CCSprite:createWithSpriteFrameName("line_pixel.png")
    local startX = 0
    local startY = 0
    startX = runtimeCache.veiledSeaMapLayer[#runtimeCache.veiledSeaMapLayer - #array] ~= nil and runtimeCache.veiledSeaMapLayer[#runtimeCache.veiledSeaMapLayer - #array].x or 0
    startY = runtimeCache.veiledSeaMapLayer[#runtimeCache.veiledSeaMapLayer - #array] ~= nil and runtimeCache.veiledSeaMapLayer[#runtimeCache.veiledSeaMapLayer - #array].y or 0

    local lineLength = math.sqrt((array[1].x - startX) ^ 2 + (array[1].y - startY) ^ 2)
    local lineScaleX = lineLength / 5.0
    -- line:runAction(CCScaleTo:create(0.3, lineScaleX, 1))
    line:setScaleX(lineScaleX)
    local offsetY = array[1].y - startY
    local offsetX = array[1].x - startX
    local angle = math.deg(math.atan(math.abs(offsetY) / math.abs(offsetX)))
    if offsetX > 0 and offsetY > 0 then
        angle = -angle
    elseif offsetX < 0 and offsetY < 0 then
        angle = 180 - angle
    elseif offsetX < 0 and offsetY > 0 then
        angle = angle - 180
    end

    line:setRotation(angle)
    line:setPosition(ccp(startX, startY))
    line:setAnchorPoint(ccp(0, 0.5))
    lineLayer:addChild(line)

end

local function gainPopup()
    if _gain["silver"] then
        local gain = {}
        gain.silver = _gain["silver"]
        userdata:popUpGain(gain, true)
    end
end

local function fightCallback(url, rtnData)
    if rtnData.code == 200 then      
        if BattleField.result == RESULT_WIN then
            local mapLayer = tolua.cast(VeiledSeaChallengeOwner["mapLayer"], "CCLayer")
            local stageKey = veiledSeaData.data.stageKey
            local sp = tolua.cast(mapLayer:getChildByTag(10000 + stageKey), "CCSprite")
            if stageKey % 5 == 0 then
                local passedArrow = CCSprite:createWithSpriteFrameName("pass_front_bg.png")
                passedArrow:setPosition(ccp(sp:getContentSize().width / 2 - 5, sp:getContentSize().height / 2 - 5))
                sp:addChild(passedArrow)
            else
                sp:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("mark_1.png"))
            end
        end
        runtimeCache.responseData = rtnData["info"]

        veiledSeaData:seaMistDataFromDic(rtnData["info"]["seaMist"])
        runtimeCache.veiledSeaState = veiledSeaData.data.flag
        if fightType == TYPE_FIGHT.normal then
            CCDirector:sharedDirector():replaceScene(CCTransitionFade:create(0.6, FightingScene()))
        elseif fightType == TYPE_FIGHT.auto then
            userdata:updateUserDataWithGainAndPay(rtnData["info"]["gain"], rtnData["info"]["pay"])
            if runtimeCache.veiledSeaState ~= veiledSeaDataFlag.challenge then
                auto = false
                -- getVeiledSeaLayer():changeState()
                showVeiledSea()
            else
                _gain = rtnData.info.gain
                gainPopup()
                _layer:autoChallenge()
                refreshData()
            end
        end 
    end
end

local function fightFun()
    local stage = veiledSeaData.data.stageKey
    local group = ConfigureStorage.SeaMiBossGroup[veiledSeaData.data.bossId]
    local bossBuff = {hp = 0, atk = 0, def = 0, mp = 0}
    if veiledSeaData.data.bossSelected and table.getTableCount(veiledSeaData.data.bossSelected) ~= 0 then
        for k,v in pairs(veiledSeaData.data.bossSelected) do
            local conf = ConfigureStorage.SeaMiBossGroup[v].attr
            if conf then
                for key,value in pairs(conf) do
                    bossBuff[key] = bossBuff[key] + value
                end
            end 
        end
    end
    local buff = {hp = 0, atk = 0, def = 0, mp = 0}
    if veiledSeaData.data.rebirthCount and veiledSeaData.data.rebirthCount > 0 then
        local attr = ConfigureStorage.SeaMiChunge[tostring(veiledSeaData.data.rebirthCount)].attr
        for k,v in pairs(buff) do
            buff[k] = attr * 100
        end
    end
    local name
    if  stage % 5 == 0 then
        name = group.boss.name
    else
        name = group.mob.name
    end
    BattleField.leftName = userdata.name
    BattleField.rightName = name
    RandomManager.cursor = RandomManager.randomRange(0, 999)
    local seed = RandomManager.cursor
    BattleField:veiledSeaFight(stage, veiledSeaData.data.bossId, bossBuff, buff)
    local result = BattleField.result == RESULT_WIN and 4 - BattleField.round or 0
    doActionFun("SEALMIST_FIGHT", {result}, fightCallback) 
end

local function clickChallengeBtn()
    local challengeItem = tolua.cast(VeiledSeaChallengeOwner["challengeItem"], "CCMenuItem")
    challengeItem:setEnabled(false)
    local flagLayer = tolua.cast(VeiledSeaChallengeOwner["flagLayer"],"CCLayer")
    flagLayer:setPosition(ccp(0, 0))
    fightType = TYPE_FIGHT.normal
    local mapLayer = tolua.cast(VeiledSeaChallengeOwner["mapLayer"],"CCLayer")
    if  currentPass < table.getTableCount(runtimeCache.veiledSeaMapLayer)then
        local fightArray = CCArray:create()
        fightArray:addObject(CCMoveTo:create(0.3, ccp(-runtimeCache.veiledSeaMapLayer[currentPass + 1].x,
            -runtimeCache.veiledSeaMapLayer[currentPass + 1].y)))        
        fightArray:addObject(CCCallFunc:create(fightFun))
        mapLayer:runAction(CCSequence:create(fightArray))

        -- mapLayer:runAction(CCMoveTo:create(0.3,ccp(-mapArray[currentPass + 1].x,-mapArray[currentPass + 1].y)))
        currentPass = currentPass + 1
    end
end
VeiledSeaChallengeOwner["clickChallengeBtn"] = clickChallengeBtn

-- 自动挑战 每3秒调用一次
-- local auto = true --停止按钮
local function AutoChallenge()
    if auotScheduler then
        scheduler:unscheduleScriptEntry(auotScheduler)
        auotScheduler = nil
    end
    local array = CCArray:create()
    array:addObject(CCMoveTo:create(0.3, ccp(-runtimeCache.veiledSeaMapLayer[currentPass + 1].x, 
        -runtimeCache.veiledSeaMapLayer[currentPass + 1].y)))
    array:addObject(CCCallFunc:create(fightFun))
    local mapLayer = tolua.cast(VeiledSeaChallengeOwner["mapLayer"],"CCLayer")
    mapLayer:runAction(CCSequence:create(array))
end

local function clickAutoChallengeBtn()
    local vipLavel = userdata:getVipLevel()
    local autoLvell = vipdata:getVipAutoLevel()
    if vipLavel < autoLvell then
        ShowText(HLNSLocalizedString("sail.openSweep",autoLvell))
        return
    end
    local flagLayer = tolua.cast(VeiledSeaChallengeOwner["flagLayer"],"CCLayer")
    flagLayer:setPosition(ccp(0, 0))
    -- _layer:addChild(createVeiledSeaLoseLayer(3))
    auto = true
    fightType = TYPE_FIGHT.auto
    -- auotScheduler = scheduler:scheduleScriptFunc(AutoChallenge, 3, false)
    AutoChallenge()
    refreshData()
end
VeiledSeaChallengeOwner["clickAutoChallengeBtn"] = clickAutoChallengeBtn

local function clickStopItem()
    if auto then
        if auotScheduler then
            scheduler:unscheduleScriptEntry(auotScheduler)
            auotScheduler = nil
            auto = false
            refreshData() 
        end
    end
end
VeiledSeaChallengeOwner["clickStopItem"] = clickStopItem

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/VeiledSeaChallengeView.ccbi", proxy, true,"VeiledSeaChallengeOwner")
    _layer = tolua.cast(node,"CCLayer")
end

-- 该方法名字每个文件不要重复
function getVeiledSeaChallengeLayer()
	return _layer
end

function createSeiledSeaChallengeLayer()
    _init()

    function _layer:autoChallenge() 
        auotScheduler = scheduler:scheduleScriptFunc(AutoChallenge, 2, false)
    end

    local function _onEnter()
        local posLayer = tolua.cast(VeiledSeaChallengeOwner["posLayer"],"CCLayer")

        HLAddParticleScale( "images/fog_crosswise.plist", posLayer, ccp(posLayer:getContentSize().width / 2, posLayer:getContentSize().height * 1), 1, 1000, 100, 1 / retina, 1 / retina, 1)
        HLAddParticleScale( "images/fog_crosswise.plist", posLayer, ccp(posLayer:getContentSize().width / 2, posLayer:getContentSize().height * 0.22), 1, 1000, 100, 1 / retina, 1 / retina, 1)
        HLAddParticleScale( "images/fog_lengthways.plist", posLayer, ccp(posLayer:getContentSize().width * 1.2, posLayer:getContentSize().height / 2), 1, 1000, 100, 1 / retina, 1 / retina, 1)
        HLAddParticleScale( "images/fog_lengthways.plist", posLayer, ccp(- posLayer:getContentSize().width * 0.2, posLayer:getContentSize().height / 2), 1, 1000, 100, 1 / retina, 1 / retina, 1)

        -- mapArray = {}
        for i=math.floor(#runtimeCache.veiledSeaMapLayer / 5) + 1,table.getTableCount(veiledSeaData.data.bossSelected) do
            newMap()
        end

        addPointAndLine(runtimeCache.veiledSeaMapLayer, 0)

        refreshData()
        addProperty()
    end

    local function _onExit()
        _layer = nil
        if auotScheduler then
            scheduler:unscheduleScriptEntry(auotScheduler)
            auotScheduler = nil
        end
        auto = false
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

    local function onTouch(eventType, x, y)
        if eventType == "began" then   
            return onTouchBegan(x, y)
        elseif eventType == "moved" then
            return onTouchMoved(x, y)
        elseif eventType == "ended" then
            return onTouchEnded(x, y)
        end
    end
    _layer:registerScriptTouchHandler(onTouch, false, -120, true)
    _layer:setTouchEnabled(true)
    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end