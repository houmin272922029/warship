local _layer
local _tab = 1

WWGroupOwner = WWGroupOwner or {}
ccb["WWGroupOwner"] = WWGroupOwner

local function setSpriteFrame(sender, bool)
    if bool then
        sender:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_1.png"))
        sender:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_1.png"))
    else
        sender:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_0.png"))
        sender:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_1.png"))
    end
end


local function tabClick(tag)
    if tag == _tab then
        return
    end
    _tab = tag
    local content = tolua.cast(WWGroupOwner["content"], "CCLayer")
    content:removeAllChildrenWithCleanup(true)
    for i=1,2 do
        local tabItem = tolua.cast(WWGroupOwner["tabItem"..i], "CCMenuItem")
        if i == _tab then
            setSpriteFrame(tabItem, true)
        else
            setSpriteFrame(tabItem, false)
        end
    end
    if _tab == 1 then
        -- 排行
        content:addChild(createWWGroupRankLayer())
    elseif _tab == 2 then
        -- 更换
        content:addChild(createWWGroupChangeLayer())
    end
end
WWGroupOwner["tabClick"] = tabClick

local function refresh()
    local function setString(key, str)
        local label = tolua.cast(WWGroupOwner[key], "CCLabelTTF")
        label:setString(str)
    end
    setString("name", userdata.name)
    setString("level", string.format("LV:%d", userdata.level))
    setString("durability", string.format("%d/%d", worldwardata.playerData.durability, worldwardata:getDurabilityMax(worldwardata.playerData.durabilityLevel)))
    setString("brave", worldwardata.playerData.courage)

    local vip = tolua.cast(WWGroupOwner["vip"], "CCSprite")
    vip:setVisible(true)
    vip:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("VIP_%d.png", vipdata:getVipLevel())))

    local titleBadge = tolua.cast(WWGroupOwner["titleBadge"], "CCSprite")
    local index = tonumber(string.split(worldwardata.playerData.countryId, "_")[2])
    local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("badge_%d.png", index))
    titleBadge:setDisplayFrame(frame)
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/WWGroupView.ccbi",proxy, true,"WWGroupOwner")
    _layer = tolua.cast(node,"CCLayer")
    
    refresh()
end

local function backItemClick()
    getMainLayer():gotoWorldWar() 
end
WWGroupOwner["backItemClick"] = backItemClick

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
WWGroupOwner["addDurabilityClick"] = addDurabilityClick

function getWWGroupLayer()
    return _layer
end

function createWWGroupLayer()
    _init()

    local function _onEnter()
        _tab = 0
        addObserver(NOTI_WW_REFRESH, refresh)
        tabClick(1)
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