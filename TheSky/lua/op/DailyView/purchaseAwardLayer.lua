    local _layer

PurchaseAwardOwner = PurchaseAwardOwner or {}
ccb["PurchaseAwardOwner"] = PurchaseAwardOwner

local function purchaseClick()
    print("执行的这里")
    CCDirector:sharedDirector():getRunningScene():addChild(createShopRechargeLayer(-400), 100)
end
PurchaseAwardOwner["purchaseClick"] = purchaseClick


local function updateUI()
    local cd = dailyData:getPurchaseAwardTime() 
    local purchaseLayer = tolua.cast(PurchaseAwardOwner["purchaseLayer"], "CCLayer")
    local awardLayer = tolua.cast(PurchaseAwardOwner["awardLayer"], "CCLayer")
    local purchaseMenu = tolua.cast(PurchaseAwardOwner["purchaseMenu"], "CCMenu")
    local awardMenu = tolua.cast(PurchaseAwardOwner["awardMenu"], "CCMenu")
    local awardText = tolua.cast(PurchaseAwardOwner["awardText"], "CCLabelTTF")
    if cd > 0 then
        purchaseLayer:setVisible(true)
        awardLayer:setVisible(false)
        purchaseMenu:setVisible(true)
        awardMenu:setVisible(false)
        local cdLabel = tolua.cast(PurchaseAwardOwner["cdLabel"], "CCLabelTTF")
        -- local day, hour, min, sec = DateUtil:secondGetdhms(cd)
        cdLabel:setString(HLNSLocalizedString("purchaseAward.cdLabel", DateUtil:secondGetdhms(cd)))
    else
        purchaseLayer:setVisible(false)
        awardLayer:setVisible(true)
        purchaseMenu:setVisible(false)
        awardMenu:setVisible(true)
    end
end

local function _refreshUI()
    local cdLabel = tolua.cast(PurchaseAwardOwner["cdLabel"], "CCLabelTTF")
    cdLabel:enableStroke(ccc3(0, 0, 0), 1)
    local awardTitle = tolua.cast(PurchaseAwardOwner["awardTitle"], "CCLabelTTF")
    awardTitle:enableStroke(ccc3(0, 0, 0), 1)
    local awardGold = tolua.cast(PurchaseAwardOwner["awardGold"], "CCLabelTTF")
    awardGold:enableStroke(ccc3(0, 0, 0), 1)
    local current = tolua.cast(PurchaseAwardOwner["current"], "CCLabelTTF")
    current:enableStroke(ccc3(0, 0, 0), 1)
    local last = tolua.cast(PurchaseAwardOwner["last"], "CCLabelTTF")
    last:enableStroke(ccc3(0, 0, 0), 1)
    local nextLabel = tolua.cast(PurchaseAwardOwner["next"], "CCLabelTTF")
    nextLabel:enableStroke(ccc3(0, 0, 0), 1)
    local dailyReward = tolua.cast(PurchaseAwardOwner["dailyReward"], "CCLabelTTF")
    dailyReward:enableStroke(ccc3(0, 0, 0), 1)

    local current = dailyData.daily[Daily_PurchaseAward].goldCharge
    local currentLabel = tolua.cast(PurchaseAwardOwner["current"], "CCLabelTTF")
    currentLabel:setString(current)
    local min,max = dailyData:getPARange()
    local last = tolua.cast(PurchaseAwardOwner["last"], "CCLabelTTF")
    last:setString(min)
    local nextLabel = tolua.cast(PurchaseAwardOwner["next"], "CCLabelTTF")
    nextLabel:setString(max)
    if current == min or current >= max then
        currentLabel:setVisible(false)
    else
        currentLabel:setVisible(true)
    end

    local box = tolua.cast(PurchaseAwardOwner["box"], "CCSprite")
    if min == 0 and current == 0 then
        box:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("purchaseAwardBox1.png"))
    elseif min == 0 and current > 0 then
        box:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("purchaseAwardBox2.png"))
    else
        box:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("purchaseAwardBox3.png"))
    end

    local progressLayer = tolua.cast(PurchaseAwardOwner["progressLayer"], "CCLayer")
    local progress = CCProgressTimer:create(CCSprite:create("images/awardPro.png"))
    progress:setType(kCCProgressTimerTypeBar)
    progress:setMidpoint(CCPointMake(0, 0))
    progress:setAnchorPoint(ccp(0, 0))
    progress:setPosition(ccp(0, 0))
    progress:setBarChangeRate(CCPointMake(0, 1))
    progress:setPercentage((current - min) / (max - min) * 100)
    progressLayer:addChild(progress)
    currentLabel:setPosition(ccp(currentLabel:getPositionX(), progressLayer:getContentSize().height * (current - min) / (max - min)))

    local config = dailyData:getPAConfig()

    if current == max or min > 0 then
        dailyReward:setVisible(true)
        dailyReward:setString(HLNSLocalizedString("purchaseAward.desp4", math.floor(current * config.proportion[dailyData:getPAStage()] / config.continue1))) 
    end

    local desp1 = tolua.cast(PurchaseAwardOwner["desp1"], "CCLabelTTF")
    local stage = dailyData:getPAStage()
    if stage == 1 then
        stage = 2
    end
    desp1:setString(HLNSLocalizedString("purchaseAward.desp1", max, math.floor(max * config.proportion[stage] / config.continue1), config.continue1))
    local desp2 = tolua.cast(PurchaseAwardOwner["desp2"], "CCLabelTTF")
    desp2:setString(HLNSLocalizedString("purchaseAward.desp2", math.floor(config.upperlimit / config.continue1)))
    local desp3 = tolua.cast(PurchaseAwardOwner["desp3"], "CCLabelTTF")
    local left = dailyData.daily[Daily_PurchaseAward].leftRefundGold
    desp3:setString(HLNSLocalizedString("purchaseAward.desp3", math.floor(current * config.proportion[dailyData:getPAStage()]) - left, left))
    local awardGold = tolua.cast(PurchaseAwardOwner["awardGold"], "CCLabelTTF")
    awardGold:setString(dailyData.daily[Daily_PurchaseAward].todayGold)

    local canRefund = dailyData.daily[Daily_PurchaseAward].canRefund ~= 0
    local awardItem = tolua.cast(PurchaseAwardOwner["awardItem"], "CCMenuItem")
    awardItem:setEnabled(canRefund)
    local awardText1 = tolua.cast(PurchaseAwardOwner["awardText1"], "CCLabelTTF")
    local awardText2 = tolua.cast(PurchaseAwardOwner["awardText2"], "CCLabelTTF")
    awardText1:setVisible(canRefund)
    awardText2:setVisible(not canRefund)

end


local function goldRefundCallback(url, rtnData)
    _refreshUI()
    postNotification(NOTI_DAILY_STATUS, nil)
end

local function awardClick()
    doActionFun("GOLD_REFUND", {}, goldRefundCallback)
end
PurchaseAwardOwner["awardClick"] = awardClick

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/PurchaseAwardView.ccbi",proxy, true,"PurchaseAwardOwner")
    _layer = tolua.cast(node,"CCLayer")

    _refreshUI()
    updateUI()
end

-- 该方法名字每个文件不要重复
function getPurchaseAwardLayer()
	return _layer
end

function createPurchaseLayer()
    _init()

    local function _onEnter()
        addObserver(NOTI_PURCHASEAWARD, updateUI)
    end

    local function _onExit()
        _layer = nil
        removeObserver(NOTI_PURCHASEAWARD, updateUI)
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