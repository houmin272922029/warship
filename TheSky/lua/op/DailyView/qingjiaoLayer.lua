local _layer
local progress
local _data = nil
local staticNum = 1
local _hitIndex = 0
local times = 1
local bAni
local K_TAG_LIGHT = 9876

QingjiaoViewOwner = QingjiaoViewOwner or {}
ccb["QingjiaoViewOwner"] = QingjiaoViewOwner

local function _refreshEndTime(  )
    -- -- 倒计时
    local timeLabel = tolua.cast(QingjiaoViewOwner["timeLabel"],"CCLabelTTF")
    local timeLabel1 = tolua.cast(QingjiaoViewOwner["timeLabel1"],"CCLabelTTF")
    local endTime = dailyData:getQingjiaoEndTime( _data.activityEndTime )
    timeLabel:setString(HLNSLocalizedString("活动结束时间：%s",endTime))
    timeLabel1:setString(HLNSLocalizedString("活动结束时间：%s",endTime))
end

-- 刷新UI
local function _refreshQJ()

    local despLabel = tolua.cast(QingjiaoViewOwner["despLabel"],"CCLabelTTF")
    despLabel:setString(HLNSLocalizedString("qingjiao.desp"))

    local count = tolua.cast(QingjiaoViewOwner["count"],"CCLabelTTF")
    count:setString(tostring(_data.freeTimes)) 
    local moneyNeed = tolua.cast(QingjiaoViewOwner["moneyNeed"],"CCLabelTTF")
    moneyNeed:setString(tostring(_data.goldCost))    
    local moneyNow = tolua.cast(QingjiaoViewOwner["moneyNow"],"CCLabelTTF")
    local gold = userdata:getFunctionOfNumberAcronym(tonumber(userdata.gold))
    moneyNow:setString(gold)      

    local tenLabel1 = tolua.cast(QingjiaoViewOwner["tenLabel1"],"CCLabelTTF")
    local tenLabel2 = tolua.cast(QingjiaoViewOwner["tenLabel2"],"CCLabelTTF")
    local tenSeekBtn = tolua.cast(QingjiaoViewOwner["tenSeekBtn"],"CCMenuItemImage")
    if _data.freeTimes > 0 then
        tenLabel1:setVisible(false) 
        tenLabel2:setVisible(false) 
        tenSeekBtn:setVisible(false)
    else
        tenLabel1:setVisible(true) 
        tenLabel2:setVisible(true) 
        tenSeekBtn:setVisible(true)
    end
    -- 进度条
    local silverCount = tolua.cast(QingjiaoViewOwner["silverCount"],"CCLabelTTF")
    local goldCount = tolua.cast(QingjiaoViewOwner["goldCount"],"CCLabelTTF")
    local diamondCount = tolua.cast(QingjiaoViewOwner["diamondCount"],"CCLabelTTF")
    local progressBg = tolua.cast(QingjiaoViewOwner["countLayer"], "CCLayer")
    if progress then
        progress:removeFromParentAndCleanup(true)
        progress = nil
    end
    progress = CCProgressTimer:create(CCSprite:create("images/qingjiaoProgress.png"))
    progress:setType(kCCProgressTimerTypeBar)
    progress:setMidpoint(CCPointMake(0, 0))
    progress:setBarChangeRate(CCPointMake(1, 0))
    progress:setPosition(progressBg:getContentSize().width / 2, progressBg:getContentSize().height / 2)
    progressBg:addChild(progress)
    local aa = 0
    local bb = 100
    local cc = 300

    if isPlatform(ANDROID_VIETNAM_VI) 
        or isPlatform(ANDROID_VIETNAM_EN) 
        or isPlatform(ANDROID_VIETNAM_EN_ALL)
        or isPlatform(ANDROID_VIETNAM_MOB_THAI)
        or isPlatform(IOS_VIETNAM_VI) 
        or isPlatform(IOS_VIETNAM_EN) 
        or isPlatform(IOS_VIETNAM_ENSAGA) 
        or isPlatform(IOS_MOB_THAI)
        or isPlatform(IOS_MOBNAPPLE_EN)
        or isPlatform(IOS_MOBGAME_SPAIN)
        or isPlatform(ANDROID_MOBGAME_SPAIN)
        or isPlatform(WP_VIETNAM_EN) then

        bb = 150
        cc = 450
    end
    if _data.totalTimes >= aa and _data.totalTimes < bb then
        progress:setPercentage(_data.totalTimes / (bb - aa) * 50 )
        silverCount:setString(tostring(_data.totalTimes )) 
        goldCount:setString(tostring(bb)) 
        diamondCount:setString(tostring(cc)) 
    elseif _data.totalTimes >= bb and _data.totalTimes < cc then
        progress:setPercentage((_data.totalTimes - bb) / (cc - bb) * 50 + 50)
        if _data.totalTimes == bb then
            progress:setPercentage(50)
        end
        silverCount:setString(tostring(aa)) 
        goldCount:setString(tostring(_data.totalTimes)) 
        diamondCount:setString(tostring(cc)) 
    else
        progress:setPercentage(100)
        silverCount:setString(tostring(aa)) 
        goldCount:setString(tostring(bb)) 
        diamondCount:setString(tostring(_data.totalTimes)) 
    end

    -- 卡片状态
    local conf = dailyData:getQingjiaoConf( )
    local confC = getMyTableCount(conf) + 1
    for k,v in pairs(conf) do
        local itemId = v.iconid
        local rank = v.rank
        k = tostring(confC - tonumber(k))
        local card = tolua.cast(QingjiaoViewOwner[string.format("card%s",k)],"CCSprite")
        local item = tolua.cast(QingjiaoViewOwner[string.format("item%s",k)],"CCMenuItemImage")
        local levelBg = tolua.cast(QingjiaoViewOwner[string.format("levelBg%s",k)],"CCSprite")
        local chipIcon = tolua.cast(QingjiaoViewOwner["chipIcon"..k],"CCSprite")
        card:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png",rank)))
        item:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png",rank)))
        local texture = CCTextureCache:sharedTextureCache():addImage(equipdata:getEquipIconByEquipId( itemId ))
        if texture then
            levelBg:setTexture(texture)
        end     
        item:setTag(confC - tonumber(k))  
    end
end

local function onCardClicked( tag )
    local index = getMyTableCount(_data.showList) - tag + 1
    getMainLayer():addChild(createVipPackageDetailLayer(_data.showList[tostring(tag)] , Daily_QingjiaoTresure))
end

-- renzhan
local function shakeAni( tag )

    local card = tolua.cast(QingjiaoViewOwner[string.format("card%s",tag)],"CCSprite")
    HLAddParticleScale( "images/eff_lightingAnim.plist", QingjiaoViewOwner["bgLayer"], ccp(card:getPositionX(),card:getPositionY()), 1, 200, 1,1.5/retina,1.5/retina)

    local posArray = CCArray:create()
    posArray:addObject(CCDelayTime:create(0.5))
    posArray:addObject(CCMoveBy:create(0.05, ccp( - card:getContentSize().width * 0.1 , 0)))
    posArray:addObject(CCMoveBy:create(0.05, ccp( card:getContentSize().width * 0.1 , 0)))
    posArray:addObject(CCMoveBy:create(0.05, ccp( - card:getContentSize().width * 0.1 , 0)))
    posArray:addObject(CCMoveBy:create(0.05, ccp( card:getContentSize().width * 0.1 , 0)))
    card:runAction(CCSequence:create(posArray))
end 

local function showAni()

    RandomManager.cursor = RandomManager.randomRange(4, 7)
    times = RandomManager.cursor
    -- times = RandomManager.randomRange(4, 7)
    -- 动画效果
    -- renzhan
    local function lastLightingAni(  )
        -- body
        staticNum = 1
        if _hitIndex == 0 then
            return
        end
        shakeAni(9-_hitIndex)

        local card = tolua.cast(QingjiaoViewOwner[string.format("card%s",9-_hitIndex)],"CCSprite")
        local bgLayer = QingjiaoViewOwner["bgLayer"]
        HLAddParticleScale( "images/effsk_000409_2.plist",bgLayer , ccp(card:getPositionX(),card:getPositionY()), 1, 200, K_TAG_LIGHT,1.0/retina,1.0/retina)
    end 
    local function allLightingAni(  )
        -- body
        RandomManager.cursor = RandomManager.randomRange(1, 8)
        staticNum = RandomManager.cursor
        shakeAni(staticNum)
    end 

    -- renzhan newadd
    -- 娜美半身像移入屏幕
    local naMeiBust = CCSprite:create("ccbResources/hero_bust_1/hero_000353_bust_1.png")
    naMeiBust:setAnchorPoint(ccp(0.5, 0.5))
    naMeiBust:setPosition(ccp(QingjiaoViewOwner["bgLayer"]:getContentSize().width + naMeiBust:getContentSize().width * 0.5,naMeiBust:getContentSize().height * 0.5))

    QingjiaoViewOwner["bgLayer"]:addChild(naMeiBust)
   

    local function bustEnter(  )
         naMeiBust:runAction(CCMoveBy:create(0.3,ccp(-naMeiBust:getContentSize().width,0)))
    end 

     -- 娜美半身像移出屏幕
    local function shutShiftOut( )
        -- renzhan
        if QingjiaoViewOwner["bgLayer"]:getChildByTag(K_TAG_LIGHT) then
            QingjiaoViewOwner["bgLayer"]:getChildByTag(K_TAG_LIGHT):stopAllActions()
            QingjiaoViewOwner["bgLayer"]:getChildByTag(K_TAG_LIGHT):removeFromParentAndCleanup(true)
        end
        -- 
        naMeiBust:runAction(CCMoveBy:create(0.3,ccp(naMeiBust:getContentSize().width,0)))
    end
    -- 
    
    local function setBustHide(  )
        -- naMeiBust:setVisible(false)
        naMeiBust:stopAllActions()
        naMeiBust:removeFromParentAndCleanup(true)
    end 

    local function LightingAni( )

        local delayArray = CCArray:create()
        for i=1,times + 1 do
            if i == times+1 then
                delayArray:addObject(CCCallFunc:create(lastLightingAni))
            else
                delayArray:addObject(CCCallFunc:create(allLightingAni))
            end 
            delayArray:addObject(CCDelayTime:create(0.3))               
        end
        _layer:runAction(CCSequence:create(delayArray))
    end 

    -- renzhan newadd
    local function bustAndLightingAni(  )
        local array = CCArray:create()
        array:addObject(CCCallFunc:create(bustEnter))
        array:addObject(CCDelayTime:create(0.3))
        array:addObject(CCCallFunc:create(LightingAni))
        array:addObject(CCDelayTime:create((1+times)*0.3))
        array:addObject(CCCallFunc:create(shutShiftOut))
        array:addObject(CCDelayTime:create(0.3))

        array:addObject(CCCallFunc:create(setBustHide))
        _layer:runAction(CCSequence:create(array))
    end 
    
    bustAndLightingAni()
    
end

local function seekCallBack( url,rtnData )

    local dic = rtnData.info.qingjiaoTreasure
    local hit = dic.hit
    _hitIndex = dic.hitItem

    -- RandomManager.cursor = RandomManager.randomRange(4, 7)
    -- times = RandomManager.cursor

    local function showGain(  )
        bAni = false
        -- QingjiaoViewOwner["seekBtn"]:setEnabled(true)
        -- QingjiaoViewOwner["tenSeekBtn"]:setEnabled(true)
        userdata:popUpGain(rtnData.info["gain"], true) 
    end
    local function showTips(  )
        local text = dic.remindInfo.content
        ShowText(text)
    end
    if hit == 0 then
        local array = CCArray:create()
        array:addObject(CCCallFunc:create(showAni))
        array:addObject(CCDelayTime:create((1+times)*0.3+1+0.6))
        array:addObject(CCCallFunc:create(showGain))
        array:addObject(CCDelayTime:create(0.8))
        array:addObject(CCCallFunc:create(showTips))
        local seq = CCSequence:create(array)  
        _layer:runAction(seq)
    else  
        local array = CCArray:create()
        array:addObject(CCCallFunc:create(showAni))
        array:addObject(CCDelayTime:create((1+times)*0.3+1+0.6))
        array:addObject(CCCallFunc:create(showGain))
        local seq = CCSequence:create(array)  
        _layer:runAction(seq)
    end
    _data.totalTimes = dic.totalTimes
    _data.goldCost = dic.goldCost
    _data.freeTimes = dic.freeTimes
    dailyData:updateQingjiaoTreasureData(_data)
    _refreshQJ()
    postNotification(NOTI_DAILY_STATUS, nil)
end 
local function seekErrorCallBack(  )
    bAni = false
    _refreshQJ()
end
local function onSeekClicked(  )
    -- body
    if userdata.gold < _data.goldCost and _data.freeTimes <= 0 then
        local function cardConfirmAction(  )
            CCDirector:sharedDirector():getRunningScene():addChild(createShopRechargeLayer(-400), 100)
        end
        local function cardCancelAction(  )
            
        end 
        local text = HLNSLocalizedString("qingjiao.goldEnough")
        getMainLayer():getParent():addChild(createSimpleConfirCardLayer(text), 100)
        SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
        SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction
    else
        local iType = 0
        if _data.freeTimes <= 0 then
            iType = 1
        end
        -- QingjiaoViewOwner["seekBtn"]:setEnabled(false)
        -- QingjiaoViewOwner["tenSeekBtn"]:setEnabled(false)
        bAni = true
        doActionFun("QINGJIAO_SEEK",{ iType },seekCallBack,seekErrorCallBack)
    end
end



local function tenSeekCallBack( url,rtnData )
    local dic = rtnData.info.qingjiaoTreasure

    local function showTenAni(  )
        showAni()
        local bgLayer = QingjiaoViewOwner["bgLayer"]
        HLAddParticleScale( "images/effsk_000409_1.plist",bgLayer,ccp(bgLayer:getContentSize().width/2,bgLayer:getContentSize().height*0.7), 1, 200, K_TAG_LIGHT,1.5/retina,1.5/retina)

    end
    local function showGain(  )
        bAni = false
        userdata:popUpGain(rtnData.info["gain"], true) 
        -- QingjiaoViewOwner["seekBtn"]:setEnabled(true)
        -- QingjiaoViewOwner["tenSeekBtn"]:setEnabled(true)
    end
    local array = CCArray:create()
    array:addObject(CCCallFunc:create(showTenAni))
    array:addObject(CCDelayTime:create((1+times)*0.3+1+0.9))
    array:addObject(CCCallFunc:create(showGain))
    local seq = CCSequence:create(array)  
    _layer:runAction(seq)
    _data.totalTimes = dic.totalTimes
    _data.goldCost = dic.goldCost
    _data.freeTimes = dic.freeTimes
    dailyData:updateQingjiaoTreasureData(_data)
    _refreshQJ()
end
local function onTenSeekClicked(  )
    -- body
    if userdata.gold < _data.goldCost * 10 then
        local function cardConfirmAction(  )
            CCDirector:sharedDirector():getRunningScene():addChild(createShopRechargeLayer(-400), 100)
        end
        local function cardCancelAction(  )
            
        end 
        local text = HLNSLocalizedString("qingjiao.goldEnough")
        getMainLayer():getParent():addChild(createSimpleConfirCardLayer(text), 100)
        SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
        SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction
    else
        -- QingjiaoViewOwner["tenSeekBtn"]:setEnabled(false)
        -- QingjiaoViewOwner["seekBtn"]:setEnabled(false)
        bAni = true
        doActionFun("QINGJIAO_TENSEEK",{ },tenSeekCallBack,seekErrorCallBack)
    end
end

QingjiaoViewOwner["onCardClicked"] = onCardClicked
QingjiaoViewOwner["onSeekClicked"] = onSeekClicked
QingjiaoViewOwner["onTenSeekClicked"] = onTenSeekClicked

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/DailyQingjiao.ccbi",proxy, true,"QingjiaoViewOwner")
    _layer = tolua.cast(node,"CCLayer")
    staticNum = 1
    times = 1

end

local function onTouchBegan(x, y)
    if not bAni then
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

-- 该方法名字每个文件不要重复
function getQingjiaoLayer()
	return _layer
end

function createQingjiaoLayer()

    _init()
    _data = dailyData:getDailyDataByName( Daily_QingjiaoTresure )
    _refreshQJ()

    local function _onEnter()
        bAni = false
        addObserver(NOTI_GOLD_CLICK_ENDTIME_TIMER, _refreshEndTime)
    end

    local function _onExit()
        bAni = false
        _layer = nil
        progress = nil
        _data = nil
        removeObserver(NOTI_GOLD_CLICK_ENDTIME_TIMER,_refreshEndTime)
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