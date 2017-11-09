local _layer

local RecruitBtn
local ItemBtn
local GiftBagBtn
local VipItemBtn
local LogueTitleLayer
local LogueContentLayer

LogueTownViewOwner = LogueTownViewOwner or {}
ccb["LogueTownViewOwner"] = LogueTownViewOwner

local function setSpriteFrame( sender,bool )
    if bool then
        sender:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_1.png"))
        sender:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_1.png"))
    else
        sender:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_0.png"))
        sender:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_1.png"))
    end
end

local function _RecruitBtnAction( tag,sender )
    LogueContentLayer:removeAllChildrenWithCleanup(true)
    LogueContentLayer:addChild(createRecruitViewNode())
    setSpriteFrame(RecruitBtn,true)
    setSpriteFrame(ItemBtn,false)
    setSpriteFrame(GiftBagBtn,false)
    setSpriteFrame(VipItemBtn,false)
end

local function _itemBtnAction(  )
    Global:instance():TDGAonEventAndEventData("prop")
    LogueContentLayer:removeAllChildrenWithCleanup(true)
    LogueContentLayer:addChild(createItemsViewLayer())
    setSpriteFrame(RecruitBtn,false)
    setSpriteFrame(ItemBtn,true)
    setSpriteFrame(GiftBagBtn,false)
    setSpriteFrame(VipItemBtn,false)
end

local function _GiftBagBtnAction(  )
    Global:instance():TDGAonEventAndEventData("gift")
    LogueContentLayer:removeAllChildrenWithCleanup(true)
    LogueContentLayer:addChild(createGiftBagViewLayer())
    setSpriteFrame(RecruitBtn,false)
    setSpriteFrame(ItemBtn,false)
    setSpriteFrame(GiftBagBtn,true)
    setSpriteFrame(VipItemBtn,false)
end

--点击进入vip商店的回调方法，请求网络数据到VipShopData表中
local function onEnterCallBack(url,rtnData)
    if rtnData["code"] == 200 then
        VipShopData:fromDic(rtnData["info"]["vipShopInfo"])
        PrintTable(rtnData["info"])
        print("onEnterCallBack(url,rtnData-------------)")
        LogueContentLayer:removeAllChildrenWithCleanup(true)
        LogueContentLayer:addChild(createVipGiftBagViewLayer())
        setSpriteFrame(RecruitBtn,false)
        setSpriteFrame(ItemBtn,false)
        setSpriteFrame(GiftBagBtn,false)
        setSpriteFrame(VipItemBtn,true)
    end
end

local function _VipitemBtnAction()
    print("shop do action")
    if ConfigureStorage.vip_shop then
        doActionFun("VIP_BUY_URL", {}, onEnterCallBack)
    end
end

local function _payBtnAction(  )
    print("paybuttonaction")
    Global:instance():TDGAonEventAndEventData("recharge1")
    -- Global:instance():AlixPayweb(opAppId,userdata.serverCode,userdata.sessionId,"gold_100")
    if getMainLayer() then
        getMainLayer():addChild(createShopRechargeLayer(-140), 100)
    end
end

LogueTownViewOwner["_RecruitBtnAction"] = _RecruitBtnAction
LogueTownViewOwner["_itemBtnAction"] = _itemBtnAction
LogueTownViewOwner["_GiftBagBtnAction"] = _GiftBagBtnAction
LogueTownViewOwner["_payBtnAction"] = _payBtnAction
LogueTownViewOwner["_VipitemBtnAction"] = _VipitemBtnAction


local function refreshPayBtn(  )
    local firstPaySprite = tolua.cast(LogueTownViewOwner["firstPaySprite"],"CCSprite")
    firstPaySprite:setVisible(vipdata:isFirstRecharge()) 

    if isPlatform(IOS_VIETNAM_VI) 
        or isPlatform(IOS_VIETNAM_EN) 
        or isPlatform(IOS_VIETNAM_ENSAGA)
        or isPlatform(IOS_MOBNAPPLE_EN)
        or isPlatform(IOS_MOB_THAI)
        or isPlatform(ANDROID_VIETNAM_VI)
        or isPlatform(ANDROID_VIETNAM_EN)
        or isPlatform(ANDROID_VIETNAM_MOB_THAI)
        or isPlatform(ANDROID_VIETNAM_EN_ALL)
        or isPlatform(IOS_MOBGAME_SPAIN)
        or isPlatform(ANDROID_MOBGAME_SPAIN)
        or isPlatform(WP_VIETNAM_EN) then

        firstPaySprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("shouchongsanbei_icon.png"))

    else 

        firstPaySprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("shouchongfanbei_pic.png"))

    end
end

local function _updatePackageCount()
    local giftBagContent = giftBagData:getShowGiftBags(  )
    local count = 0
    for i,item in pairs(giftBagContent) do
        if item.vipLevel <= vipdata:getVipLevel() then
            count = count + 1
        end
    end
    count = count + getMyTableCount(giftBagData:getTimeGifts())

    local mailCountBg = tolua.cast(LogueTownViewOwner["mailCountBg"], "CCSprite")
    if count > 0 then
        mailCountBg:setVisible(true)
        local mailCount = tolua.cast(LogueTownViewOwner["mailCount"], "CCLabelTTF")
        mailCount:setString(count)
    else
        mailCountBg:setVisible(false)
    end
end

local function updateVipLevelReward()
    local vipRewardCountBg = tolua.cast(LogueTownViewOwner["vipRewardCountBg"], "CCSprite")
    local vipRewardCount = tolua.cast(LogueTownViewOwner["vipRewardCount"], "CCLabelTTF")
    if vipdata:bHaveAward() then
        vipRewardCountBg:setVisible(true)
        vipRewardCount:setString(vipdata:getVipRewardCount())
    else
        vipRewardCountBg:setVisible(false)
    end
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/LogueTownView.ccbi",proxy, true,"LogueTownViewOwner")
    _layer = tolua.cast(node,"CCLayer")
    LogueContentLayer = tolua.cast(LogueTownViewOwner["LogueContentLayer"],"CCLayer")

    _updatePackageCount()

    RecruitBtn = tolua.cast(LogueTownViewOwner["RecruitBtn"],"CCMenuItemImage")
    ItemBtn = tolua.cast(LogueTownViewOwner["ItemBtn"],"CCMenuItemImage")
    
    GiftBagBtn = tolua.cast(LogueTownViewOwner["GiftBagBtn"],"CCMenuItemImage")
    VipItemBtn = tolua.cast(LogueTownViewOwner["VipItemBtn"],"CCMenuItemImage")
    setSpriteFrame(RecruitBtn,true)
    setSpriteFrame(ItemBtn,false)
    setSpriteFrame(GiftBagBtn,false)
    setSpriteFrame(VipItemBtn,false)
    CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/fontPic_2.plist")
    local firstPaySprite = tolua.cast(LogueTownViewOwner["firstPaySprite"],"CCSprite")

    if isPlatform(IOS_VIETNAM_VI) 
        or isPlatform(IOS_VIETNAM_EN) 
        or isPlatform(IOS_VIETNAM_ENSAGA)
        or isPlatform(IOS_MOBNAPPLE_EN)
        or isPlatform(IOS_MOB_THAI)
        or isPlatform(ANDROID_VIETNAM_VI)
        or isPlatform(ANDROID_VIETNAM_EN)
        or isPlatform(ANDROID_VIETNAM_MOB_THAI)
        or isPlatform(ANDROID_VIETNAM_EN_ALL)
        or isPlatform(IOS_MOBGAME_SPAIN)
        or isPlatform(ANDROID_MOBGAME_SPAIN)
        or isPlatform(WP_VIETNAM_EN) then

        firstPaySprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("shouchongsanbei_icon.png"))

    else 
        firstPaySprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("shouchongfanbei_pic.png"))
    end
    firstPaySprite:setVisible(vipdata:isFirstRecharge())
    
    local libao = tolua.cast(LogueTownViewOwner["libao"],"CCLabelTTF")
    local vipfont = tolua.cast(LogueTownViewOwner["vipfont"],"CCSprite")
    GiftBagBtn:setVisible(not userdata:getVipAuditState())
    VipItemBtn:setVisible(not userdata:getVipAuditState())
    vipfont:setVisible(not userdata:getVipAuditState())
    libao:setVisible(not userdata:getVipAuditState())
    updateVipLevelReward()
end


function getLogueTownLayer()
    return _layer
end

function createLogueTownLayer()
    _init()

    function _layer:updateVipLevelReward()
        updateVipLevelReward()
    end

    function _layer:refresh()
    end

    function _layer:gotoPageByType( uitype )
        if uitype == 0 then
            LogueContentLayer:removeAllChildrenWithCleanup(true)
            LogueContentLayer:addChild(createRecruitViewNode())
            setSpriteFrame(RecruitBtn,true)
            setSpriteFrame(ItemBtn,false)
            setSpriteFrame(GiftBagBtn,false)
            setSpriteFrame(VipItemBtn,false)
        elseif uitype == 1 then
            LogueContentLayer:removeAllChildrenWithCleanup(true)
            LogueContentLayer:addChild(createItemsViewLayer())
            setSpriteFrame(RecruitBtn,false)
            setSpriteFrame(ItemBtn,true)
            setSpriteFrame(GiftBagBtn,false)
            setSpriteFrame(VipItemBtn,false)
        elseif uitype == 2 then
            LogueContentLayer:removeAllChildrenWithCleanup(true)
            LogueContentLayer:addChild(createGiftBagViewLayer())
            setSpriteFrame(RecruitBtn,false)
            setSpriteFrame(ItemBtn,false)
            setSpriteFrame(GiftBagBtn,true)
            setSpriteFrame(VipItemBtn,false)
        elseif uitype == 3 then
            LogueContentLayer:removeAllChildrenWithCleanup(true)
            --LogueContentLayer:addChild(createVipGiftBagViewLayer())
            setSpriteFrame(RecruitBtn,false)
            setSpriteFrame(ItemBtn,false)
            setSpriteFrame(GiftBagBtn,false) 
            setSpriteFrame(VipItemBtn,true) 
        end
    end

    local function _onEnter()
        playMusic(MUSIC_SOUND_LOGUETOWN, true)
        LogueContentLayer:addChild(createRecruitViewNode())
        addObserver(NOTI_REFRESH_LOGUETOWN,refreshPayBtn)
        addObserver(NOTI_VIP_PACKAGE_COUNT, _updatePackageCount)
    end

    local function _onExit()
        playMusic(MUSIC_SOUND_1, true)
        removeObserver(NOTI_REFRESH_LOGUETOWN,refreshPayBtn)
        removeObserver(NOTI_VIP_PACKAGE_COUNT, _updatePackageCount)
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


    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end