local _layer
local _tableView
local _data
local _rankArray
local _bAni = false
local _lootIndex
local _currentIndex

-- 押运物资主界面
-- 名字不要重复
WWEscortItemOwner = WWEscortItemOwner or {}
ccb["WWEscortItemOwner"] = WWEscortItemOwner

-- 升级战舰按钮回调          
local function WarshipClicked()
    
    if tonumber(worldwardata.playerData.durabilityLevel) >= 18 then
        --提示达到上限
        ShowText(HLNSLocalizedString("durabilityLevel.Enough"))
        return
    else
        getMainLayer():getParent():addChild(createWWBuyDurabilityLayer(true, -133))
    end
    
end
WWEscortItemOwner["WarshipClicked"] = WarshipClicked

local function getArrayData()
    local rankArray = {}
    for key,v in pairs(_data.goods) do
        local dic = {["key"] = key}
        table.insert(rankArray, dic)  
    end
    return rankArray
end

local function animation()
    -- item 变亮暗动画
    local temp = 1
    local function action()
        temp = temp + 1
        local CCScale9SpriteLight = tolua.cast(WWEscortItemOwner["CCScale9SpriteLight" .. _currentIndex], "CCSprite")
        CCScale9SpriteLight:setVisible(false)
        _currentIndex = _currentIndex % 4 + 1
        local CCScale9SpriteLight1 = tolua.cast(WWEscortItemOwner["CCScale9SpriteLight" .. _currentIndex], "CCSprite")
        CCScale9SpriteLight1:setVisible(true)
    end
    
    local function aniStart()
        _bAni = true 
    end

    local function aniEnd()
        _bAni = false
        _layer:refresh()
    end

    local array = CCArray:create()

    array:addObject(CCCallFunc:create(aniStart))
    array:addObject(CCDelayTime:create(0.05))
    
    for i = 1, 8 do
        array:addObject(CCCallFunc:create(action))
        array:addObject(CCDelayTime:create(0.05))
    end
    
    local tempCurrentIndex = _currentIndex
    local delay = 0.1
    local slowStep = 4
    local offStep = (4 - tempCurrentIndex + _lootIndex) % 4 + (8 - slowStep)
    for i=1, offStep do
        array:addObject(CCCallFunc:create(action))
        array:addObject(CCDelayTime:create(delay))
    end
    for i=1, slowStep do
        delay = delay + 0.05
        array:addObject(CCCallFunc:create(action))
        array:addObject(CCDelayTime:create(delay))
    end
    array:addObject(CCCallFunc:create(aniEnd))
    array:addObject(CCDelayTime:create(0.5))
    _layer:runAction(CCSequence:create(array))
end



-- 刷新按钮回调
local function RefreshClicked()
    if userdata.gold < _data.refresh.count  then  --刷新金币不足 跳转进入商城界面
        if getMainLayer() then
            getMainLayer():addChild(createShopRechargeLayer(-140), 100)
        end
    end
    if userdata.gold < _data.refresh.count  then  --刷新金币不足 跳转进入商城界面
        if getMainLayer() then
            getMainLayer():addChild(createShopRechargeLayer(-140), 100)
        end
    end
    --接口 refreshEscortCost
    local function callback(url, rtnData)
        _data.rank = rtnData.info.rank
        _data.money = rtnData.info.money
        _data.refresh = rtnData.info.refresh
        -- postNotification(NOTI_WW_REFRESH, nil)
        _rankArray = getArrayData()
        for i=1,4 do
            local CCScale9SpriteLight = tolua.cast(WWEscortItemOwner["CCScale9SpriteLight" .. i], "CCSprite")
            if tonumber(_rankArray[i].key) == tonumber(_data.rank) then
                _lootIndex = i
            end
        end
        animation()
        
       
    end
    --向服务器发送成功领取消息  uid 以及 id
    doActionFun("REFRESH_ESCORTCOST", {}, callback)
end
WWEscortItemOwner["RefreshClicked"] = RefreshClicked

-- 返回按钮回调
local function BackClicked()
    if not getMainLayer() then
        CCDirector:sharedDirector():replaceScene(mainSceneFun())
    end
    runtimeCache.dailyPageNum = Daily_Worship
    getMainLayer():gotoWorldWarExperiment()
end
WWEscortItemOwner["BackClicked"] = BackClicked

--开始海运按钮回调
local function StartTradeClicked()
    -- 海运物资 两个状态 界面回调  
    if _data.remain > 0  then
         --需缴纳的保金
        if _data.money.item == "silver" then
            if userdata.berry >= _data.money.count  then
                getMainLayer():gotoEscortItemState()
            else
                ShowText(HLNSLocalizedString("ERR_1102"))
            end
        elseif _data.money.item == "gold" then
            if userdata.gold >= _data.money.count  then
                getMainLayer():gotoEscortItemState()
            else
                ShowText(HLNSLocalizedString("ERR_1101"))
            end
        elseif _data.money.item == "item_006" then
            if wareHouseData:getItemCountById( "item_006" ) >= _data.money.count  then
                getMainLayer():gotoEscortItemState()
            else
                ShowText(HLNSLocalizedString("EscortItem_blueBallNotEnough"))
            end
           
        end
    else
        -- 今日押运次数已达上限，升级vip能增加押运次数
        ShowText(HLNSLocalizedString("EscortItem_timesNotEnough"))
    end
    
end
WWEscortItemOwner["StartTradeClicked"] = StartTradeClicked


local function refresh()
    -- 显示 name lv vip 
    local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
    local name = tolua.cast(WWEscortItemOwner["name"], "CCLabelTTF")
    local level = tolua.cast(WWEscortItemOwner["level"], "CCLabelTTF")
    local vip = tolua.cast(WWEscortItemOwner["vip"], "CCSprite")
    name:setString(userdata.name)
    level:setString(string.format("LV:%d", userdata.level))
    vip:setDisplayFrame(cache:spriteFrameByName(string.format("VIP_%d.png", 
        vipdata:getVipLevel())))
    
    --获取战舰等级
    local Lv = tolua.cast(WWEscortItemOwner["Lv"], "CCLabelTTF")
    Lv:setString(worldwardata.playerData.durabilityLevel)
    -- 计算海运奖励加成 Per 未完成
    local Per = tolua.cast(WWEscortItemOwner["Per"], "CCLabelTTF")
    Per:setString(ConfigureStorage.countryWar_Durable[worldwardata.playerData.durabilityLevel + 1].deliveryAdd 
        * 100 .. '%')
     -- 船
    local ship = tolua.cast(WWEscortItemOwner["ship"], "CCSprite")
    ship:setDisplayFrame(cache:spriteFrameByName(worldwardata:getShipIcon(worldwardata.playerData.durabilityLevel, 
        worldwardata.playerData.countryId)))

    --物资品质
    local currentRank = tolua.cast(WWEscortItemOwner["currentRank"], "CCLabelTTF")
    currentRank:setString(HLNSLocalizedString("currentRank" .. tonumber(_data.rank)))
    currentRank:setColor(HLGetColorWithRank(tonumber(_data.rank)))
    --需缴纳的保金
    local BaoJinSprite = tolua.cast(WWEscortItemOwner["BaoJinSprite"], "CCSprite")
    if _data.money.item == "silver" then
        BaoJinSprite:setDisplayFrame(cache:spriteFrameByName("berry.png"))
    elseif _data.money.item == "gold" then
        BaoJinSprite:setDisplayFrame(cache:spriteFrameByName("gold.png"))
    elseif _data.money.item == "item_006" then
       BaoJinSprite:setDisplayFrame(cache:spriteFrameByName("blueIcon.png"))
    end
    --保金数量 BaoJInCount
    local BaoJInCount = tolua.cast(WWEscortItemOwner["BaoJInCount"], "CCLabelTTF")
    BaoJInCount:setString(_data.money.count)

    local RefreshIcon = tolua.cast(WWEscortItemOwner["RefreshIcon"], "CCSprite")
    local RefreshCount = tolua.cast(WWEscortItemOwner["RefreshCount"], "CCLabelTTF")
    local Free = tolua.cast(WWEscortItemOwner["Free"], "CCLabelTTF")
    if _data.refresh.count == 0 then
    else
        RefreshIcon:setVisible(true) 
        RefreshCount:setVisible(true) 
        Free:setVisible(false)
        if _data.refresh.item == "silver" then
            RefreshIcon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("berry.png"))
        elseif _data.refresh.item == "gold" then
            RefreshIcon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("gold.png"))
        elseif _data.refresh.item == "item_006" then
            RefreshIcon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("blueIcon.png"))
        end
        RefreshCount:setString(_data.refresh.count)
    end
    _rankArray = getArrayData()
    for i=1,4 do
        local CCScale9SpriteLight = tolua.cast(WWEscortItemOwner["CCScale9SpriteLight" .. i], "CCSprite")
        print(_rankArray[i].key)
        if tonumber(_rankArray[i].key) == tonumber(_data.rank) then
            CCScale9SpriteLight:setVisible(true)
            _currentIndex = i
        end
    end

    -- 字体颜色 HLGetColorWithRank( rank )
    local index = 1
    for k,v in pairs(_data.goods) do
        --icon 图片颜色背景
        local icon = tolua.cast(WWEscortItemOwner["icon" .. index], "CCSprite")
        icon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("frame_" .. k .. ".png"))
        local rank = tolua.cast(WWEscortItemOwner["rank" .. index], "CCLabelTTF")
        rank:setString(HLNSLocalizedString("rank" .. k))
        rank:setColor(HLGetColorWithRank(tonumber(k)))
        --goods 
        print("k = ", k)
        local goods = tolua.cast(WWEscortItemOwner["goods" .. index], "CCSprite")
        goods:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("escort_item_".. k ..".png"))
        local gold = tolua.cast(WWEscortItemOwner["gold" .. index], "CCSprite") 
        if v.item == "silver" then
            gold:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("berry.png"))
        elseif v.item == "gold" then
            gold:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("gold.png"))
        elseif v.item == "item_006" then
            gold:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("blueIcon.png"))
        end
        local RankCount = tolua.cast(WWEscortItemOwner["RankCount" .. index], "CCLabelTTF")
        RankCount:setString(v.count)
        index = index + 1
    end
    
    -- remainCount
    local remainCount = tolua.cast(WWEscortItemOwner["remainCount" ], "CCLabelTTF")  
    remainCount:setString(_data.remain .. '/' .. _data.total)
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    local proxy = CCBProxy:create()
    local node  = CCBReaderLoad("ccbResources/WWEscortItemView.ccbi", proxy, true, "WWEscortItemOwner")
    _layer = tolua.cast(node,"CCLayer")
    refresh()

    function _layer:refresh()
        refresh() 
    end

    local content = tolua.cast(WWEscortItemOwner["content"], "CCLayer")
    local function onTouchBegan(x, y)
        if _bAni then
            return true
        end
        return false
    end

    local function onTouchMoved(x, y)

    end

    local function onTouchEnded(x, y)

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
    content:registerScriptTouchHandler(onTouch, false, -300, true)
    content:setTouchEnabled(true)
end

-- 该方法名字每个文件不要重复
function getWWEscortItemLayer()
	return _layer
end

function createWWEscortItemLayer(data , priority)
    _data = data
    _init()
    local function _onEnter()
         _bAni = false
        addObserver(NOTI_WW_REFRESH, refresh)
    end

    local function _onExit()
        removeObserver(NOTI_WW_REFRESH, refresh)
        _tableView = nil
        _data = nil
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