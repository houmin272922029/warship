
local _layer
local _tab = 2

-- 商业主界面
WWExperimentOwner = WWExperimentOwner or {}
ccb["WWExperimentOwner"] = WWExperimentOwner

local function setSpriteFrame(sender, bool)
    if bool then
        sender:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_1.png"))
        sender:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_1.png"))
    else
        sender:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_0.png"))
        sender:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_1.png"))
    end
end

--增加耐久度按钮回调
local function addDurabilityClick()
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
WWExperimentOwner["addDurabilityClick"] = addDurabilityClick

--根据tag确定点击的具体是那个按钮， 1为实验室 2为海上商运
local function tabClick(tag)
    if tag == _tab then
        return
    end
    _tab = tag
    local content = tolua.cast(WWExperimentOwner["content"], "CCLayer")
    content:removeAllChildrenWithCleanup(true)
    for i=1,2 do
        local tabItem = tolua.cast(WWExperimentOwner["tabItem"..i], "CCMenuItem")
        if i == _tab then
            setSpriteFrame(tabItem, true)
        else
            setSpriteFrame(tabItem, false)
        end
    end
    if _tab == 1 then
        content:addChild(createWWRecruitLayer())
    elseif _tab == 2 then
        --doAction
        local function callback(url, rtnData)
            content:addChild(createWWTradeTransportLayer(rtnData.info , priority))
        end
        doActionFun("GET_ESCORT_INFO", {}, callback)
    end
end
WWExperimentOwner["tabClick"] = tabClick

--返回按钮回调
local function backItemClick()
    getMainLayer():gotoWorldWar() 
end
WWExperimentOwner["backItemClick"] = backItemClick

local function refreshTime()
    local blood = tolua.cast(WWExperimentOwner["blood"], "CCLabelTTF")
    local bloodCD = worldwardata:getBloodCD()
    blood:setString(DateUtil:second2hms(bloodCD))

    local settle = tolua.cast(WWExperimentOwner["settle"], "CCLabelTTF")
    local settleCD = worldwardata:getSettleCD()
    settle:setString(DateUtil:second2hms(settleCD))

    local attr = tolua.cast(WWExperimentOwner["attr"], "CCLabelTTF")
    local bloodBuffType = worldwardata.playerData.bloodBuffType
    local bloodBuff = 0
    if bloodCD > 0 and bloodBuffType and bloodBuffType ~= "" then
        bloodBuff = ConfigureStorage.WWScience[bloodBuffType].params.buff
    end
    attr:setString(string.format("+%d%%", bloodBuff))
end

local function refresh()
    local function setString(key, str)
        local label = tolua.cast(WWExperimentOwner[key], "CCLabelTTF")
        label:setString(str)
    end
    setString("name", userdata.name)
    setString("level", string.format("LV:%d", userdata.level))
    setString("durability", string.format("%d/%d", worldwardata.playerData.durability, worldwardata:getDurabilityMax(worldwardata.playerData.durabilityLevel)))
    setString("brave", worldwardata.playerData.courage)

    local vip = tolua.cast(WWExperimentOwner["vip"], "CCSprite")
    vip:setVisible(true)
    vip:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("VIP_%d.png", vipdata:getVipLevel())))

    local titleBadge = tolua.cast(WWExperimentOwner["titleBadge"], "CCSprite")
    local index = tonumber(string.split(worldwardata.playerData.countryId, "_")[2])
    local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("badge_%d.png", index))
    titleBadge:setDisplayFrame(frame)
    refreshTime()
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/WWExperimentView.ccbi",proxy, true,"WWExperimentOwner")
    _layer = tolua.cast(node,"CCLayer")
    refresh()
end

function getWWExperimentLayer()
    return _layer
end

function createWWExperimentLayer()
    _init()
    local function _onEnter()
        _tab = 0
        addObserver(NOTI_WW_REFRESH, refresh)
        tabClick(2)
    end
    local function _onExit()
        removeObserver(NOTI_WW_REFRESH, refresh)
        _layer = nil
        _tab = 0
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