local _layer
local _data = nil

local lightFlag = 0

local btnLightSche
local resultStr
local index

local isQuest = false

GoldClockViewOwner = GoldClockViewOwner or {}
ccb["GoldClockViewOwner"] = GoldClockViewOwner

GoldClockViewOwner["ontestaction"] = ontestaction
local function _refreshEndTimeLabel(  )
    local timeLabel = tolua.cast(GoldClockViewOwner["timeLabel"],"CCLabelTTF")
    local timeString = dailyData:getBellEndTime(  )
    timeLabel:setString(HLNSLocalizedString("活动结束时间：%s",timeString))
end

local function _refreshLabel(  )
    local count = getMyTableCount(dailyData.daily.goldenBell.infoList)
    local resultLabel1 = tolua.cast(GoldClockViewOwner["resultLabel1"],"CCLabelTTF")
    local resultLabel2 = tolua.cast(GoldClockViewOwner["resultLabel2"],"CCLabelTTF")
    local string1
    local string2
    if count > 0 then
        string1 = dailyData.daily.goldenBell.infoList[tostring(index)]
        -- string2 = dailyData.daily.goldenBell.infoList[tostring((index + 1) % count == index and  or)]
        string2 = (index + 1) % count == index and "" or dailyData.daily.goldenBell.infoList[tostring((index + 1) % count)]
    else
        string1 = ""
        string2 = ""
    end
    resultLabel1:setString(string1)
    resultLabel2:setString(string2)
    index = (index + 1) % count
end

--  底部灯闪烁方法
local function btmLightAni(  )
    if lightFlag == 0 then
        lightFlag = 1
    else
        lightFlag = 0
    end
    for i=1,8 do
        local ballLight = tolua.cast(GoldClockViewOwner["light_"..i],"CCSprite")
        if lightFlag == 0 then      
            if i % 2 == 0 then
                ballLight:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("goldenBell_light_r.png"))
            else
                ballLight:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("goldenBell_light_b.png"))
            end
        else
            if i % 2 == 0 then
                ballLight:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("goldenBell_light_b.png"))
            else
                ballLight:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("goldenBell_light_r.png"))
            end
        end
    end
end

-- 添加粒子效果
local function addHLFax(  )
    local _scene = CCDirector:sharedDirector():getRunningScene()
    if resultStr < 20 then
        HLAddParticleScale( "images/goldDrop_1.plist", _scene, ccp(winSize.width / 2,winSize.height), 1, 1, 1,1,1)
    elseif resultStr >= 20 and resultStr < 50 then
        HLAddParticleScale( "images/goldDrop_2.plist", _scene, ccp(winSize.width / 2,winSize.height), 1, 1, 1,1,1)
    elseif resultStr >= 50 and resultStr < 300 then
        HLAddParticleScale( "images/goldDrop_3.plist", _scene, ccp(winSize.width / 2,winSize.height), 1, 1, 1,1,1)
    else
        HLAddParticleScale( "images/goldDrop_4.plist", _scene, ccp(winSize.width / 2,winSize.height), 1, 1, 1,1,1)
    end 
end
-- 刷新UI
local function _refreshUI()
    local currentGold = tolua.cast(GoldClockViewOwner["currentGoldLabel"],"CCLabelTTF")
    currentGold:setString(userdata.gold)
    
    local needGoldLabel = tolua.cast(GoldClockViewOwner["needGoldLabel"],"CCLabelTTF")
    needGoldLabel:setString(HLNSLocalizedString("goldenbell.tips.1", dailyData:getGoldenTipsProb()))
    
    -- local resultLabel = tolua.cast(GoldClockViewOwner["resultLabel"],"CCLabelTTF")
    if resultStr then
        local function addbox(  )
            local clockBtn = tolua.cast(GoldClockViewOwner["clockBtn"],"CCMenuItemImage")
            clockBtn:setEnabled(true)
            local topColorLayer = tolua.cast(GoldClockViewOwner["topColorLayer"],"CCLayerColor")
            if dailyData:getNextClickGold() > 0 then
                topColorLayer:setVisible(true)
            else
                topColorLayer:setVisible(false)
            end
            if not getClickBellSuccessLayer() then
                CCDirector:sharedDirector():getRunningScene():addChild(createClickBellSuccessLayer(resultStr))
            end
            addHLFax()
        end
        local function resetResultStr(  )
            resultStr = nil 
        end
        local acctionArray = CCArray:create()
        acctionArray:addObject(CCDelayTime:create(0.5))
        acctionArray:addObject(CCCallFunc:create(addbox))
        acctionArray:addObject(CCCallFunc:create(resetResultStr))
        local seq = CCSequence:create(acctionArray)
        -- local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(addbox))
        _layer:runAction(seq)
    else
        local clockBtn = tolua.cast(GoldClockViewOwner["clockBtn"],"CCMenuItemImage")
        clockBtn:setEnabled(true)
        local topColorLayer = tolua.cast(GoldClockViewOwner["topColorLayer"],"CCLayerColor")
        if dailyData:getNextClickGold( ) > 0 then
            topColorLayer:setVisible(true)
        else
            topColorLayer:setVisible(false)
        end
    end
end

-- 快速闪烁
local function btmLightFastAction(  )
    if btnLightSche then
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(btnLightSche)
    end
    btnLightSche = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(btmLightAni, 0.1, false)
    local clockBtn = tolua.cast(GoldClockViewOwner["clockBtn"],"CCMenuItemImage")
    clockBtn:setEnabled(false)
end
-- 普通闪烁
local function btmLightSlowAction(  )
    if btnLightSche then
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(btnLightSche)
    end
    btnLightSche = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(btmLightAni, 0.8, false)
    
end

local function setFinalResult(  )
    _refreshUI()
    btmLightSlowAction()
end

local function rollSprite1( pos,finalChar )
    local posT1 = tolua.cast(GoldClockViewOwner["posT"..pos],"CCSprite")
    local posB1 = tolua.cast(GoldClockViewOwner["posB"..pos],"CCSprite")
    local aniSprite11 = tolua.cast(GoldClockViewOwner[string.format("aniSprite%s1",pos)],"CCSprite")
    local aniSprite12 = tolua.cast(GoldClockViewOwner[string.format("aniSprite%s2",pos)],"CCSprite")
    local aniSprite13 = tolua.cast(GoldClockViewOwner[string.format("aniSprite%s3",pos)],"CCSprite")
    local topPos = ccp(posT1:getPositionX(),posT1:getPositionY())
    local botPos = ccp(posB1:getPositionX(),posB1:getPositionY())
    local finalPosition11 = ccp(aniSprite11:getPositionX(),aniSprite11:getPositionY())
    local finalPosition12 = ccp(aniSprite11:getPositionX(),aniSprite11:getPositionY())
    local finalPosition13 = ccp(aniSprite11:getPositionX(),aniSprite11:getPositionY())
    function move( sprite )
        sprite = tolua.cast(sprite,"CCSprite")
        local actionArray = CCArray:create()
        -- local distance = 2 * (topPos.y - botPos.y)
        local count = 1
        local isgood = 0
        local numberStr1 = 1
        local numberStr2 = 0
        local numberStr3 = 9
        if sprite == aniSprite11 then
            sprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("y_num_%s.png",numberStr1)))
        elseif sprite == aniSprite12 then
            sprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("y_num_%s.png",numberStr2)))
        elseif sprite == aniSprite13 then
            sprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("y_num_%s.png",numberStr3)))
        end
        local _speed = 1400
        local _flag = 1
        local currentPos = ccp(sprite:getPositionX(),sprite:getPositionY())
        local function setPos(  )
            sprite:setPosition(ccp(posT1:getPositionX(),posT1:getPositionY()))

            numberStr1 = (tonumber(finalChar) + 10 + 1) % 10
            numberStr2 = tonumber(finalChar)
            numberStr3 = (tonumber(finalChar) + 10 - 1) % 10
            
            if sprite == aniSprite11 then
                sprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("y_num_%s.png",numberStr1)))
            elseif sprite == aniSprite12 then
                sprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("y_num_%s.png",numberStr2)))
            elseif sprite == aniSprite13 then
                sprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("y_num_%s.png",numberStr3)))
            end
        end
        local function setConstomPos(  )
            sprite:setPosition(ccp(posT1:getPositionX(),posT1:getPositionY()))
            numberStr2 = (tonumber(numberStr2) + 3) % 10
            numberStr1 = (tonumber(numberStr2) + 10 + 1) % 10
            numberStr3 = (tonumber(numberStr2) + 10 - 1) % 10
            if sprite == aniSprite11 then
                sprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("y_num_%s.png",numberStr1)))
            elseif sprite == aniSprite12 then
                sprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("y_num_%s.png",numberStr2)))
            elseif sprite == aniSprite13 then
                sprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("y_num_%s.png",numberStr3)))
            end
        end
        for i=1,10000 do
            local move1 = CCMoveBy:create((currentPos.y - botPos.y) / _speed,ccp(0, -(currentPos.y - botPos.y)))  -- 移动第一段
            local setPos2
            if isgood == 0 then
                setPos2 = CCCallFunc:create(setConstomPos)
            else
                setPos2 = CCCallFunc:create(setPos)
            end
            local move2 = CCMoveBy:create((topPos.y - currentPos.y) / _speed,ccp(0, -(topPos.y - currentPos.y)))  -- 移动第二段
            actionArray:addObject(move1:copy():autorelease())
            actionArray:addObject(setPos2:copy():autorelease())
            actionArray:addObject(move2:copy():autorelease())
            if _speed >= 2100 then    --  保持速度不更改
                _flag = _flag + 1
                if _flag == 10 * (6 - tonumber(pos)) - 2 then
                    isgood = 1
                else
                    isgood = 0
                end
                if _flag >10 * (6 - tonumber(pos)) then
                    _speed = _speed - 100
                end
            elseif _speed >= 100 and _speed < 2100 then
                if _flag <= 10 then
                    _speed = _speed + 200
                elseif _flag >= 11 then
                    _speed = _speed - 300
                end
            end
            if _speed < 100 then
                break
            end
        end
        if pos == 1 and sprite == aniSprite11 then
            actionArray:addObject(CCCallFunc:create(setFinalResult))
        end
        local seq = CCSequence:create(actionArray)
        sprite:runAction(seq)
    end
    move(aniSprite11)
    move(aniSprite12)
    move(aniSprite13)
end

local function setResultVisible( flag )
    for i=1,5 do
        local sprite = tolua.cast(GoldClockViewOwner["numberSprite"..i],"CCSprite")
        sprite:setVisible(flag)
    end
end 

local function setVisibleFalse(  )
    setResultVisible(false)
end

local function setVisibleTrue(  )
    setResultVisible(true)
end

local function rool1(  )
    local finalStr = string.format("%05d",resultStr)
    rollSprite1(1,string.sub(finalStr,1,1))
end
local function rool2(  )
    local finalStr = string.format("%05d",resultStr)
    rollSprite1(2,string.sub(finalStr,2,2))
end
local function rool3(  )
    local finalStr = string.format("%05d",resultStr)
    rollSprite1(3,string.sub(finalStr,3,3))
end
local function rool4(  )
    local finalStr = string.format("%05d",resultStr)
    rollSprite1(4,string.sub(finalStr,4,4))
end
local function rool5(  )
    local finalStr = string.format("%05d",resultStr)
    rollSprite1(5,string.sub(finalStr,5,5))
end

--
local function rollAnimation(  )
    local actionArray = CCArray:create()
    actionArray:addObject(CCCallFunc:create(rool5))
    actionArray:addObject(CCCallFunc:create(rool4))
    actionArray:addObject(CCCallFunc:create(rool3))
    actionArray:addObject(CCCallFunc:create(rool2))
    actionArray:addObject(CCCallFunc:create(rool1))
    local seq = CCSequence:create(actionArray)
    _layer:runAction(seq)
end


-- 中间灯打开方法
local function centerLightOpen( duration )
    local centerLightSche
    local index = 1
    local function openOrCloseLight(  )
        if index >= 10 and index <= 18 then
            local centerLight = tolua.cast(GoldClockViewOwner["btm_light_"..(19 - index)],"CCSprite")
            centerLight:setVisible(false)
            if index == 10 then
                if centerLightSche then
                    CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(centerLightSche)
                end
                centerLightSche = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(openOrCloseLight, duration / 23, false)
            end
        elseif index == 9 then
            if centerLightSche then
                CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(centerLightSche)
            end
            centerLightSche = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(openOrCloseLight, duration / 23 * 5, false)
            local centerLight = tolua.cast(GoldClockViewOwner["btm_light_"..index],"CCSprite")
            centerLight:setVisible(true)
        elseif index < 9 then
            local centerLight = tolua.cast(GoldClockViewOwner["btm_light_"..index],"CCSprite")
            centerLight:setVisible(true)
        else
            --  如果大于18 则终止动画
            if centerLightSche then
                CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(centerLightSche)
            end
        end
        index = index + 1
    end

    if centerLightSche then
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(centerLightSche)
    end
    centerLightSche = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(openOrCloseLight, duration / 23, false)
end




local function clickBellCallBack( url,rtnData )
    if rtnData["code"] == 200 then
        -- GoldClockViewOwner["mAnimationManager"]:runAnimationsForSequenceNamedTweenDuration("shake", 0)
        -- renzhan

        GoldClockAnimation_LayerOwner = GoldClockAnimation_LayerOwner or {}
        ccb["GoldClockAnimation_LayerOwner"] = GoldClockAnimation_LayerOwner

        local  proxy = CCBProxy:create()
        local  node  = CCBReaderLoad("ccbResources/DailyGoldClockAnimationView.ccbi",proxy,true,"GoldClockAnimation_LayerOwner")
        _layer:addChild(node)
        GoldClockViewOwner["GoldClockLabel"]:setVisible(false)
        GoldClockViewOwner["pendulum"]:setVisible(false)

        local function removeGoldClock( )
            GoldClockViewOwner["GoldClockLabel"]:setVisible(true)
            GoldClockViewOwner["pendulum"]:setVisible(true)
            node:removeFromParentAndCleanup(true)
        end 

        local array = CCArray:create()
        array:addObject(CCDelayTime:create(6))
        array:addObject(CCCallFunc:create(removeGoldClock))
        _layer:runAction(CCSequence:create(array))

        -- 
        local bg = GoldClockViewOwner["clockBg"]
        -- HLAddParticleScale( "images/clock_shakeOutGold.plist", getDailyLayer(), ccp(winSize.width / 2,winSize.height * 0.44 + 250 * retina), 1, 1, 1,2,2)

        local topColorLayer = tolua.cast(GoldClockViewOwner["topColorLayer"],"CCLayerColor")
        topColorLayer:setVisible(false)

        resultStr = rtnData.info.gain.gold
        -- resultStr = 10998
        -- print("时间",rtnData.info.times)
        dailyData.daily.goldenBell = rtnData.info.goldenBell
        index = 0
        btmLightFastAction()
        centerLightOpen(0.3)
        local actionArray = CCArray:create()
        actionArray:addObject(CCDelayTime:create(0.3))
        actionArray:addObject(CCCallFunc:create(rollAnimation))
        local seq = CCSequence:create(actionArray)
        _layer:runAction(seq)
    end
end

local function onGoldBellClicked(  )
    Global:instance():TDGAonEventAndEventData("bell")
    if userdata.gold < dailyData:getNextClickGold( ) then
        local function cardConfirmAction(  )
            getMainLayer():addChild(createShopRechargeLayer(-400), 100)
        end
        local function cardCancelAction(  )
            
        end
        getMainLayer():addChild(createSimpleConfirCardLayer(HLNSLocalizedString("goldbell.click.notmoregold")))
        SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
        SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction
    else
        doActionFun("CLICK_BELL_URL",{},clickBellCallBack)
    end
end

GoldClockViewOwner["onGoldBellClicked"] = onGoldBellClicked

local function getInfoCallBack( url,rtnData )
    isQuest = false
    if rtnData.code == 200 then
        dailyData.daily.goldenBell = rtnData.info.goldenBell
        index = 0
    end
end

local function getInitInfo(  )
    if isQuest == false then
        doActionFun("GET_INIT_BELL_INFO",{},getInfoCallBack) 
        isQuest = true
    end
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/DailyGoldClockView.ccbi",proxy, true,"GoldClockViewOwner")
    _layer = tolua.cast(node,"CCLayer")
    _refreshUI()
end

-- 该方法名字每个文件不要重复
function getGoldClockLayer()
	return _layer
end

function createGoldClockLayer()
    _init()

    function _layer:refresh(  )
        getInitInfo()
        _refreshUI()
    end

    local function _onEnter()
        index = 0
        btmLightSlowAction()
        addObserver(NOTI_GOLD_CLICK_REFRESH_TIMER, _refreshLabel)
        addObserver(NOTI_GOLD_CLICK_ENDTIME_TIMER, _refreshEndTimeLabel)
    end

    local function _onExit()
        _layer = nil
        _data = nil
        lightFlag = 0
        resultStr = nil
        index = nil
        if btnLightSche then
            CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(btnLightSche)
        end
        isQuest = false
        removeObserver(NOTI_GOLD_CLICK_REFRESH_TIMER,_refreshLabel)
        removeObserver(NOTI_GOLD_CLICK_ENDTIME_TIMER,_refreshEndTimeLabel)
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