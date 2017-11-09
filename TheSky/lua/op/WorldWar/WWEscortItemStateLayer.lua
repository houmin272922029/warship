local _layer
local _tableView
local _data
local _endTime
local _priority = -132
local _rankArray 
local helpHeightArray = {}
-- 物资押运中 主界面
-- 名字不要重复
WWEscortItemStateOwner = WWEscortItemStateOwner or {}
ccb["WWEscortItemStateOwner"] = WWEscortItemStateOwner

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
WWEscortItemStateOwner["WarshipClicked"] = WarshipClicked

-- 查看详情按钮回调
local function AboutClicked()
    print("-------goto AboutClicked------") 
    --进入劫镖者查看界面
    --getMainLayer():getParent():addChild:(createWWEscortItemAboutLayer())
    if not getMainLayer() then
        CCDirector:sharedDirector():replaceScene(mainSceneFun())
    end
    runtimeCache.dailyPageNum = Daily_Worship
    getMainLayer():getParent():addChild(createWWEscortItemAboutLayer(_data , _priority), 100)
end
WWEscortItemStateOwner["AboutClicked"] = AboutClicked

-- 返回按钮回调
local function BackClicked()
    print("-------goto BackClicked------")
    if not getMainLayer() then
        CCDirector:sharedDirector():replaceScene(mainSceneFun())
    end
    runtimeCache.dailyPageNum = Daily_Worship
    getMainLayer():gotoWorldWarExperiment()
end
WWEscortItemStateOwner["BackClicked"] = BackClicked


-- 领取奖励按钮回调 getRewardClicked
local function getRewardClicked()
    --  接口  acceptEscortAward  ACCEPT_ESCORT_AWARD
    local function callback(url, rtnData)
        if not getMainLayer() then
            CCDirector:sharedDirector():replaceScene(mainSceneFun())
        end
        runtimeCache.dailyPageNum = Daily_Worship
        getMainLayer():gotoWorldWarExperiment()
        --弹出对话框，和劫货成功一样，突出玩家战舰等级额外获得的item数量
        getMainLayer():getParent():addChild(createWWEscortItemRewardLayer(rtnData.info , priority))
    end
    --向服务器发送成功领取消息  uid 以及 id
    doActionFun("ACCEPT_ESCORT_AWARD", {}, callback)

end
WWEscortItemStateOwner["getRewardClicked"] = getRewardClicked

local function refreshTimeLabel()
    _endTime = _data.endTime
    -- response["info"]["now"]
    if _endTime then
        local NeedTime = tolua.cast(WWEscortItemStateOwner["NeedTime"], "CCLabelTTF")
        NeedTime:setString(tostring(DateUtil:second2hms(math.max(0, _endTime - userdata.loginTime))))
    end
    if _endTime == userdata.loginTime then
        _data.type = 3
        postNotification(NOTI_WW_REFRESH, nil)
    end
end

local function getCellHeight( string,width,fontSize,fontName )
    if not fontName then
        fontName = "ccbResources/FZCuYuan-M03S.ttf"
    end
    local tempLabel = CCLabelTTF:create(string, fontName, fontSize, CCSizeMake(width, 0), kCCTextAlignmentLeft)
    tempLabel:setVisible(false)
    _layer:addChild(tempLabel, 200, 8888)
    local height = tempLabel:getContentSize().height
    tempLabel:removeFromParentAndCleanup(true)
    return height
end
local function _addTableView()
    WWEscortItemStateDesCellOwner = WWEscortItemStateDesCellOwner or {}
    ccb["WWEscortItemStateDesCellOwner"] = WWEscortItemStateDesCellOwner
    local containLayer = tolua.cast(WWEscortItemStateOwner["containLayer"],"CCLayer")

    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            local message = _rankArray[a1 +1].desc_1
                local cellHeight
                if helpHeightArray[a1+1] then
                    cellHeight = helpHeightArray[a1+1]
                else
                    cellHeight = getCellHeight(message,620.0,22,"ccbResources/FZCuYuan-M03S") + 20 * retina
                    helpHeightArray[a1+1] = cellHeight 
                end
                r = CCSizeMake(winSize.width, cellHeight)

        elseif fn == "cellAtIndex" then
            -- Return CCTableViewCell, a1 is cell index (zero based), a2 is dequeued cell (maybe nil)
            -- Do something to create cell  and change the content
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            -- --单条数据
            local  proxy = CCBProxy:create()
            local  _hbCell
            _hbCell = CCLayer:create()
            --报酬剩余数量 iconCount 劫去物资剩余百分比RobPer
            local iconCount = tolua.cast(WWEscortItemStateOwner["iconCount"], "CCLabelTTF")
            local RobPer = tolua.cast(WWEscortItemStateOwner["RobPer"], "CCLabelTTF")
            local per = 0
            for i,v in ipairs(_rankArray) do
                per = per + v.percent
            end
            RobPer:setString(tostring(HLNSLocalizedString("itemRobedCount") .. per .. '%'))
            iconCount:setString(tostring(math.ceil(_data.goods.count * (100 - per) / 100)))

            -- 描述信息
            local message = _rankArray[a1 +1].desc_1
            local cellHeight
            if helpHeightArray[a1+1] then
                cellHeight = helpHeightArray[a1+1]
            else
                cellHeight = getCellHeight(message,620.0,22,"ccbResources/FZCuYuan-M03S") + 20 * retina
                helpHeightArray[a1+1] = cellHeight
            end
            _hbCell:setContentSize(CCSizeMake(620,cellHeight))
            _hbCell:setAnchorPoint(ccp(0,0))
            _hbCell:setPosition(ccp(0,0))

            local temp = CCLabelTTF:create(message, "ccbResources/FZCuYuan-M03S", 22,CCSizeMake(620,0),kCCTextAlignmentLeft)
            temp:setAnchorPoint(ccp(0,1))
            temp:setPosition(ccp(0,cellHeight - 10 * retina))
            _hbCell:addChild(temp)
            temp:setColor(ccc3(255,204,0))

            -- _hbCel:setScale(retina)
            a2:addChild(_hbCell, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            r = a2
        elseif fn == "numberOfCells" then
            r = #_rankArray
        -- Cell events:
        elseif fn == "cellTouched" then         -- A cell was touched, a1 is cell that be touched. This is not necessary.
        elseif fn == "cellTouchBegan" then      -- A cell is touching, a1 is cell, a2 is CCTouch
        elseif fn == "cellTouchEnded" then      -- A cell was touched, a1 is cell, a2 is CCTouch
        elseif fn == "cellHighlight" then       -- A cell is highlighting, coco2d-x 2.1.3 or above
        elseif fn == "cellUnhighlight" then     -- A cell had been unhighlighted, coco2d-x 2.1.3 or above
        elseif fn == "cellWillRecycle" then     -- A cell will be recycled, coco2d-x 2.1.3 or above
        end
        return r
    end)
    local size = CCSizeMake(containLayer:getContentSize().width, containLayer:getContentSize().height)  -- 这里是为了在tableview上面显示一个小空出来
    _tableView = LuaTableView:createWithHandler(h, size)
    _tableView:setBounceable(true)
    _tableView:setAnchorPoint(ccp(0,0))
    _tableView:setPosition(0,0)
    _tableView:setVerticalFillOrder(0)
    containLayer:addChild(_tableView,1000)
end

local function refresh()
    local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
    local Lv = tolua.cast(WWEscortItemStateOwner["Lv"], "CCLabelTTF")
    Lv:setString(tostring(worldwardata.playerData.durabilityLevel))
    -- 计算海运奖励加成 Per 
    local Per = tolua.cast(WWEscortItemStateOwner["Per"], "CCLabelTTF")
    Per:setString(tostring(ConfigureStorage.countryWar_Durable[worldwardata.playerData.durabilityLevel + 1].deliveryAdd * 100 .. '%'))
    -- 显示 name lv vip 
    local name = tolua.cast(WWEscortItemStateOwner["name"], "CCLabelTTF")
    local level = tolua.cast(WWEscortItemStateOwner["level"], "CCLabelTTF")
    local vip = tolua.cast(WWEscortItemStateOwner["vip"], "CCSprite")
    name:setString(userdata.name)
    level:setString(string.format("LV:%d", userdata.level))
    vip:setDisplayFrame(cache:spriteFrameByName(string.format("VIP_%d.png", vipdata:getVipLevel())))
    
    -- 计算
    -- 货物攻击被劫走的百分比 RobPer 共计被劫走 百分比
    local RobPer = tolua.cast(WWEscortItemStateOwner["RobPer"], "CCLabelTTF")
    if #_rankArray == 0 then --并为被劫走物资

        RobPer:setString(tostring(HLNSLocalizedString("itemRobedCount") .. '0%'))

        --报酬剩余数量
        local iconCount = tolua.cast(WWEscortItemStateOwner["iconCount"], "CCLabelTTF")
        iconCount:setString(tostring(_data.goods.count))
    end

   
    -- 判断当时间倒计时为00:00:00 时， 今日海运end 界面
    --_endTime = _data.endTime   or tostring(DateUtil:second2hms( _endTime)) == tostring(DateUtil:second2hms(userdata.loginTime))
    if tonumber(_data.type) == 3  then -- 押镖结束
        --隐藏返回按钮 达到目的地还需label 所需时间label 以及trade ani 动画 NeedTime 押运中logo
        local BackBtn = tolua.cast(WWEscortItemStateOwner["BackBtn"], "CCMenuItemImage")
        BackBtn:setVisible(false) 
        local fanhuiSprite = tolua.cast(WWEscortItemStateOwner["fanhuiSprite"], "CCSprite")
        fanhuiSprite:setVisible(false)
        local arriveDestination = tolua.cast(WWEscortItemStateOwner["arriveDestination"], "CCLabelTTF")
        arriveDestination:setVisible(false)
        local NeedTime = tolua.cast(WWEscortItemStateOwner["NeedTime"], "CCLabelTTF")
        NeedTime:setVisible(false)
        local EscortItemStart = tolua.cast(WWEscortItemStateOwner["EscortItemStart"], "CCLabelTTF")
        EscortItemStart:setVisible(false)
        local EscortItemStart1 = tolua.cast(WWEscortItemStateOwner["EscortItemStart1"], "CCLabelTTF")
        EscortItemStart1:setVisible(false)
        local tradeAni = tolua.cast(WWEscortItemStateOwner["tradeAni"], "CCSprite")
        tradeAni:setVisible(false)

        --显示领取报酬Btn 成功到达目的地logo  领取奖励sprite
        local getRewardBtn = tolua.cast(WWEscortItemStateOwner["getRewardBtn"], "CCMenuItemImage")
        getRewardBtn:setVisible(true) 
        local EscortItemEnd = tolua.cast(WWEscortItemStateOwner["EscortItemEnd"], "CCLabelTTF")
        EscortItemEnd:setVisible(true)
        local EscortItemEnd1 = tolua.cast(WWEscortItemStateOwner["EscortItemEnd1"], "CCLabelTTF")
        EscortItemEnd1:setVisible(true)
        local getRewardSprite = tolua.cast(WWEscortItemStateOwner["getRewardSprite"], "CCSprite")
        getRewardSprite:setVisible(true)
        
    end
    -- RobTimes 被劫次数
    local RobTimes = tolua.cast(WWEscortItemStateOwner["RobTimes"], "CCLabelTTF")   
    RobTimes:setString(HLNSLocalizedString("RobItemTimes" , tonumber(#_rankArray)))

    -- 报酬剩余 的icon
    local iconSprite = tolua.cast(WWEscortItemStateOwner["iconSprite"], "CCSprite")
    if _data.goods.item == "silver" then
        iconSprite:setDisplayFrame(cache:spriteFrameByName("berry.png"))
    elseif _data.goods.item == "gold" then
        iconSprite:setDisplayFrame(cache:spriteFrameByName("gold.png"))
    elseif _data.goods.item == "item_006" then
        iconSprite:setDisplayFrame(cache:spriteFrameByName("blueIcon.png"))
    end
    -- 船
    local ship = tolua.cast(WWEscortItemStateOwner["ship"], "CCSprite")
    ship:setDisplayFrame(cache:spriteFrameByName(worldwardata:getShipIcon(worldwardata.playerData.durabilityLevel, 
        worldwardata.playerData.countryId)))
    if #_rankArray == 0 then
        local desripttion = tolua.cast(WWEscortItemStateOwner["desripttion"], "CCLabelTTF")
        desripttion:setVisible(true)
        desripttion:setString(HLNSLocalizedString("RobItem.des.2"))
    else
        local desripttion = tolua.cast(WWEscortItemStateOwner["desripttion"], "CCLabelTTF")
        desripttion:setVisible(false)
        _addTableView()
    end
end

local  function getArrayData()
    local DesArray = {}
    if _data.robLog then
        for k,v in pairs(_data.robLog) do
            if v and v.result then
                table.insert(DesArray, v)
            end
        end
    end
    return DesArray
end

local function updateRefresh()
    local function callback(url, rtnData)
        _data = rtnData.info
        _rankArray = getArrayData()

        if _tableView then 
            _tableView:reloadData()
        end
        refresh()
    end
    doActionFun("GOING_ESCORT", {}, callback)
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/WWEscortItemStateView.ccbi",proxy, true,"WWEscortItemStateOwner")
    _layer = tolua.cast(node,"CCLayer")

    _rankArray = getArrayData()

    refresh()
    refreshTimeLabel()
    
    local tradeAni = tolua.cast(WWEscortItemStateOwner["tradeAni"], "CCSprite")
    local animFrames = CCArray:create()
    for i = 1, 3 do
        local frameName = string.format("trade_ani_%d.png", i)
        local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(frameName)
        animFrames:addObject(frame)
    end
    local animation = CCAnimation:createWithSpriteFrames(animFrames, 0.2)
    local animate = CCAnimate:create(animation)
    tradeAni:runAction(CCRepeatForever:create(animate))
end

-- 该方法名字每个文件不要重复
function getWWEscortItemStateLayer()
    return _layer
end

function createWWEscortItemStateLayer(data , priority)
    _data = data
    _priority = (priority ~= nil) and priority or -132
    _init()

    local function _onEnter()
        addObserver(NOTI_WW_REFRESH, updateRefresh)
        addObserver(NOTI_TICK, refreshTimeLabel)
        refreshTimeLabel()
    end

    local function _onExit()
        removeObserver(NOTI_WW_REFRESH, updateRefresh)
        removeObserver(NOTI_TICK, refreshTimeLabel)
        _tableView = nil
        _data = nil
        _layer = nil
        _rankArray = nil
        helpHeightArray = {}
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