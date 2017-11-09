local _layer
local _priority

-- 名字不要重复
CaptainInfoOwner = CaptainInfoOwner or {}
ccb["CaptainInfoOwner"] = CaptainInfoOwner


local function closeItemClick()

    popUpCloseAction( CaptainInfoOwner,"infoBg",_layer )
    -- _layer:removeFromParentAndCleanup(true)
end
CaptainInfoOwner["closeItemClick"] = closeItemClick

local function onPayClicked()
    Global:instance():TDGAonEventAndEventData("recharge0")
    _layer:removeFromParentAndCleanup(true)
    if getMainLayer() then
        getMainLayer():addChild(createShopRechargeLayer(-400))
    end
end
CaptainInfoOwner["onPayClicked"] = onPayClicked

local function _updateCD()
    local nextStrengthTimer = 0
    local allStrengthTimer = 0
    local nextEnergyTimer = 0
    local allEnergyTimer = 0
    if userdata.strength < userdata:getStrengthMax() then
        nextStrengthTimer = userdata:getNextStrengthTime()
        allStrengthTimer = userdata:getAllStrengthTime()
    end
    if userdata.energy < userdata:getEnergyMax() then
        nextEnergyTimer = userdata:getNextEnergyTime()
        allEnergyTimer = userdata:getAllEnergyTime()
    end
    local nextStrength = tolua.cast(CaptainInfoOwner["nextStrength"], "CCLabelTTF")
    local allStrength = tolua.cast(CaptainInfoOwner["allStrength"], "CCLabelTTF")
    local nextEnergy = tolua.cast(CaptainInfoOwner["nextEnergy"], "CCLabelTTF")
    local allEnergy = tolua.cast(CaptainInfoOwner["allEnergy"], "CCLabelTTF")
    nextStrength:setString(DateUtil:second2hms(nextStrengthTimer))
    allStrength:setString(DateUtil:second2hms(allStrengthTimer))
    nextEnergy:setString(DateUtil:second2hms(nextEnergyTimer))
    allEnergy:setString(DateUtil:second2hms(allEnergyTimer))
end

local function _updateStrength()
    local strength = tolua.cast(CaptainInfoOwner["strength"], "CCLabelTTF")
    strength:setString(string.format("%d/%d", userdata.strength, userdata:getStrengthMax()))
end

local function _updateEnergy()
    local energy = tolua.cast(CaptainInfoOwner["energy"], "CCLabelTTF")
    energy:setString(string.format("%d/%d", userdata.energy, userdata:getEnergyMax()))
end

local function _refreshData()
    local name = tolua.cast(CaptainInfoOwner["name"], "CCLabelTTF") 
    name:setString(userdata.name)
    local vip = tolua.cast(CaptainInfoOwner["vip"], "CCSprite")
    vip:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("VIP_%d.png", userdata:getVipLevel())))
    vip:setVisible(not userdata:getVipAuditState())
    local level = tolua.cast(CaptainInfoOwner["level"], "CCLabelTTF")
    level:setString(userdata.level)
    local exp = tolua.cast(CaptainInfoOwner["exp"], "CCLabelTTF")
    exp:setString(string.format("%d/%d", userdata.exp, ConfigureStorage.levelExp[tostring(userdata.level)].value1))
    local form = tolua.cast(CaptainInfoOwner["form"], "CCLabelTTF")
    form:setString(string.format("%d/%d", table.getTableCount(herodata.form), userdata:getFormMax()))
    local gold = tolua.cast(CaptainInfoOwner["gold"], "CCLabelTTF")
    gold:setString(tostring(userdata.gold))
    local berry = tolua.cast(CaptainInfoOwner["berry"], "CCLabelTTF")
    berry:setString(tostring(userdata.berry))
    local strength = tolua.cast(CaptainInfoOwner["strength"], "CCLabelTTF")
    strength:setString(string.format("%d/%d", userdata.strength, userdata:getStrengthMax()))
    local energy = tolua.cast(CaptainInfoOwner["energy"], "CCLabelTTF")
    energy:setString(string.format("%d/%d", userdata.energy, userdata:getEnergyMax()))
    _updateCD()    
    CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/fontPic_2.plist")
    local firstPaySpr = tolua.cast(CaptainInfoOwner["firstPaySpr"],"CCSprite")

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

        firstPaySpr:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("shouchongsanbei_icon.png"))
    else 
        firstPaySpr:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("shouchongfanbei_pic.png"))
    end
    firstPaySpr:setVisible(vipdata:isFirstRecharge())
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/CaptainInfoView.ccbi", proxy, true,"CaptainInfoOwner")
    _layer = tolua.cast(node,"CCLayer")
    _refreshData()
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(CaptainInfoOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then

        popUpCloseAction( CaptainInfoOwner,"infoBg",_layer )
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
    local menu = tolua.cast(CaptainInfoOwner["menu"], "CCMenu")
    menu:setHandlerPriority(_priority - 1)
end

-- 该方法名字每个文件不要重复
function getCaptainInfoLayer()
	return _layer
end

function createCaptainInfoLayer(priority)
    _priority = priority ~= nil and priority or -134
    _init()

    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
        addObserver(NOTI_TITLE_INFO, _updateCD)
        addObserver(NOTI_STRENGTH, _updateStrength)
        addObserver(NOTI_ENERGY, _updateEnergy)
        
        
        popUpUiAction( CaptainInfoOwner,"infoBg" )
    end

    local function _onExit()
        _layer = nil
        removeObserver(NOTI_TITLE_INFO, _updateCD)
        removeObserver(NOTI_STRENGTH, _updateStrength)
        removeObserver(NOTI_ENERGY, _updateEnergy)
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