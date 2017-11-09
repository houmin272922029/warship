local _layer
local _data = nil
local _tableView
local _bTableViewTouch
local _satate
local cal = {}

DailySignInViewOwner = DailySignInViewOwner or {}
ccb["DailySignInViewOwner"] = DailySignInViewOwner

local function getCalendar()
    cal = {}
    local month = _data.signIn.month
    local dic = ConfigureStorage[string.format("HZ_SignIn_reward_%d", month)]
    local signInRecord = _data.signIn.signInRecord

    local getRewardCount = getMyTableCount(_data.signIn.signInRecord) -- 已经签到的次数
    local supplCount  -- 可补签的次数


    local tday = true
    if _data.signIn.tday == "" then
        tday = false
    end          

    if not tday then  --  今天没签
        supplCount = _data.signIn.day - getRewardCount 
    else
        supplCount = _data.signIn.day - getRewardCount
    end

    print("已经签到的次数",getRewardCount)
    print("可补签的次数",supplCount)

    for i = 1, getMyTableCount(dic) do
        local data = dic[tostring(i)]
        local rate = 1
        for j = 1, getMyTableCount(data["vip"]) do
            if rate < data.vip[j] then
                rate = data.vip[j]
                break
            end
        end

        local state = 0 -- 0 过期 1 当天未签可领 2 补签可领 3 VIP补领奖 4 不可签到 5 当天已签到，但不存在补签次数
        if i <= getRewardCount then
            local record = signInRecord[tostring(i)]
            if rate > record.mul then
                if DateUtil:beginDay(record.time) == DateUtil:beginDay(_data.signIn.lastTime) then
                    state = 3
                else
                    state = 0
                end 
            else
                state = 0
            end
        else 
            
            if i == getRewardCount + 1 then
                if not tday then
                    state = 1
                elseif supplCount > 0 then
                    state = 2
                else
                    state = 5
                end 
            else
                state = 4
            end
        end  
        table.insert(cal, state) 
    end
    return cal
end


local function _addTableView()
    -- 得到数据
    local content = DailySignInViewOwner["content"]

    local month = _data.signIn.month
    local dic = ConfigureStorage[string.format("HZ_SignIn_reward_%d", month)]

    DailySignInCellOwner = DailySignInCellOwner or {}
    ccb["DailySignInCellOwner"] = DailySignInCellOwner

    local function onCardClicked(tag)
        local dic = math.floor(tag / 10000) + 1
        local index = tag % 10000
        local state = cal[index]
        getMainLayer():getParent():addChild(createDailySignInPopUpLayer(_data, state , index, -132))

    end 
    DailySignInCellOwner["onCardClicked"] = onCardClicked

    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(580, 145)
        elseif fn == "cellAtIndex" then
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            --单条数据
            local  proxy = CCBProxy:create()
            local  _hbCell  = tolua.cast(CCBReaderLoad("ccbResources/DailySignInCell.ccbi", proxy, true, "DailySignInCellOwner"), "CCLayer")
            for i=1,4 do
                local data = dic[tostring(i + a1 * 4)]
                if data and data.reward then
                    local itemId = data.reward
                    local resDic = userdata:getExchangeResource(itemId)
                    local item = tolua.cast(DailySignInCellOwner["item"..i],"CCMenuItemImage")
                    local contentLayer = tolua.cast(DailySignInCellOwner["contentLayer"..i],"CCLayer")
                    --根据是否存在奖励物品，显示相应的物品
                    item:setVisible(true)
                    item:setTag(a1 * 10000 + i + a1 * 4)
                    contentLayer:setVisible(true)
                    contentLayer:setTag(a1 * 10000 + i + a1 * 4)
                    local bigSprite = tolua.cast(DailySignInCellOwner["bigSprite"..i],"CCSprite")
                    local littleSprite = tolua.cast(DailySignInCellOwner["littleSprite"..i],"CCSprite")
                    local soulIcon = tolua.cast(DailySignInCellOwner["soulIcon"..i],"CCSprite")
                    local chip_icon = tolua.cast(DailySignInCellOwner["chip_icon"..i],"CCSprite")
                    
                    local SignInMarkSprite = tolua.cast(DailySignInCellOwner["SignInMarkSprite"..i],"CCSprite") -- 左上角斜杠图 已签到图片
                    local Vip = tolua.cast(DailySignInCellOwner["Vip"..i],"CCLabelTTF") -- Vip
                    local Multiple = tolua.cast(DailySignInCellOwner["Multiple"..i],"CCLabelTTF") -- 倍数
                    local SignInHaveGetSprite = tolua.cast(DailySignInCellOwner["SignInHaveGetSprite"..i],"CCSprite") -- 已签到图片
                    local CCLayerColor = tolua.cast(DailySignInCellOwner["CCLayerColor"..i],"CCLayerColor") -- 已签到图片

                     -- 能够翻倍的vip等级  rate 倍数
                    local doubledVipLevel = 0
                    local rate = 1
                    for j = 1, getMyTableCount(data["vip"]) do
                        if rate < data.vip[j] then
                            rate = data.vip[j]
                            doubledVipLevel = j - 1
                           break
                        end
                    end
                    if rate > 1 then
                        SignInMarkSprite:setVisible(true)
                        Vip:setString('Vip' .. doubledVipLevel)
                        Multiple:setString('X' .. rate)
                    end
                    SignInMarkSprite:setVisible(not userdata:getVipAuditState())
                    Vip:setVisible(not userdata:getVipAuditState())
                    Multiple:setVisible(not userdata:getVipAuditState())

                    -- 加上光圈效果
                    local function addParticle()
                        local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
                        cache:addSpriteFramesWithFile("ccbResources/treasureCard.plist")
                        local light = CCSprite:createWithSpriteFrameName("treasureCard_roundFrame_1.png")
                        light:setScale(0.95)
                        local animFrames = CCArray:create()
                        for j = 1, 3 do
                            local frameName = string.format("treasureCard_roundFrame_%d.png",j)
                            local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(frameName)
                            animFrames:addObject(frame)
                        end
                        local animation = CCAnimation:createWithSpriteFrames(animFrames, 0.2)
                        local animate = CCAnimate:create(animation)
                        light:runAction(CCRepeatForever:create(animate))
                        item:addChild(light,1)
                        light:setPosition(ccp(item:getContentSize().width / 2,item:getContentSize().height / 2))
                    end

                    -- 判断签到记录
                    local state = cal[i + a1 * 4]
                    if state == 0 then
                        CCLayerColor:setVisible(true)
                        SignInHaveGetSprite:setVisible(true)
                    else
                        if state == 4 or state == 5 then
                        else
                            addParticle()
                        end
                        if state == 3 then
                            SignInHaveGetSprite:setVisible(true)
                        end
                    end
                    chip_icon:setVisible(false)
                    --代码整理
                    --判断魂魄、影子单独处理
                    if havePrefix(itemId, "hero") then
                        -- 魂魄
                        littleSprite:setVisible(true)
                        soulIcon:setVisible(true)
                        littleSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(resDic.icon))
                    elseif havePrefix(itemId, "shadow") then
                        -- 影子
                        item:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("s_frame.png"))
                        item:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("s_frame.png"))

                        item:setPosition(ccp(item:getPositionX() + 5,item:getPositionY() - 5))
                        if resDic.icon then
                            playCustomFrameAnimation(string.format("yingzi_%s_", resDic.icon), contentLayer, ccp(contentLayer:getContentSize().width / 2,
                                contentLayer:getContentSize().height / 2), 1, 4, shadowData:getColorByColorRank(resDic.rank))
                        end
                    else
                        -- 道具，装备，技能，货币
                        local texture
                        if haveSuffix(itemId, "_shard") then
                            -- 装备碎片
                            texture = CCTextureCache:sharedTextureCache():addImage(string.format("ccbResources/icons/%s.png",resDic.icon))
                            chip_icon:setVisible(true)
                        else
                            texture = CCTextureCache:sharedTextureCache():addImage(resDic.icon)
                        end
                        if texture then
                            bigSprite:setVisible(true)
                            bigSprite:setTexture(texture)
                        end 
                    end
                    if not havePrefix(itemId, "shadow") then
                        item:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", resDic.rank)))
                        item:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", resDic.rank)))
                    end      
                end
            end
            a2:addChild(_hbCell, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            r = a2
        elseif fn == "numberOfCells" then
            r = math.ceil(getMyTableCount(ConfigureStorage[string.format("HZ_SignIn_reward_%d", _data.signIn.month)]) / 4)
        elseif fn == "cellTouched" then         -- A cell was touched, a1 is cell that be touched. This is not necessary.
        elseif fn == "cellTouchBegan" then      -- A cell is touching, a1 is cell, a2 is CCTouch
            getDailyLayer():pageViewTouchEnabled(true)
            _bTableViewTouch = true
        elseif fn == "cellTouchEnded" then      -- A cell was touched, a1 is cell, a2 is CCTouch
            if _bTableViewTouch then
                getDailyLayer():pageViewTouchEnabled(true)
                _bTableViewTouch = false
            end
        elseif fn == "cellHighlight" then       -- A cell is highlighting, coco2d-x 2.1.3 or above
        elseif fn == "cellUnhighlight" then     -- A cell had been unhighlighted, coco2d-x 2.1.3 or above
        elseif fn == "cellWillRecycle" then     -- A cell will be recycled, coco2d-x 2.1.3 or above
        elseif fn == "scroll" then   
            if _bTableViewTouch then
                getDailyLayer():pageViewTouchEnabled(false)
            end
        end
        return r
    end)

    local size = content:getContentSize()
    _tableView = LuaTableView:createWithHandler(h, size)
    _tableView:setBounceable(true)
    _tableView:setAnchorPoint(ccp(0,0))
    _tableView:setPosition(0,0)
    _tableView:setVerticalFillOrder(0)
    content:addChild(_tableView,1000)
end

-- 刷新UI
local function _refreshUI()
    local despLabel = tolua.cast(DailySignInViewOwner["despLabel"],"CCLabelTTF") 
    local signInCount = getMyTableCount(_data.signIn.signInRecord)

    local haveNotSignIn 
    local tday = true
    if _data.signIn.tday == "" then
        tday = false
    end
    -- modified by 赵艳秋，20150825，漏签次数用当天日期减去签到次数就好了，当天没有签到也算到漏签里面
    -- if not tday then  --  今天没签
        haveNotSignIn = _data.signIn.day - signInCount 
        if haveNotSignIn <= 0 then
            haveNotSignIn = 0
        end
    -- else
    --     haveNotSignIn = _data.signIn.day - signInCount - 1
    --     if haveNotSignIn <= 0 then
    --         haveNotSignIn = 0
    --     end
    -- end
    despLabel:setString(HLNSLocalizedString("Daily_MysignInCount", signInCount, haveNotSignIn))
    if not _tableView then
        _addTableView()
    end
    _tableView:reloadData()
    _tableView:reloadData()
end


local function _getInfo()
    local function getInfoCallBack( url,rtnData )
        _data = rtnData.info
        cal = getCalendar()
        _refreshUI()
    end
    doActionFun("DAILY_GET_SIGNINRECORD", {}, getInfoCallBack)
end


-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/DailySignInView.ccbi",proxy, true,"DailySignInViewOwner")
    _layer = tolua.cast(node,"CCLayer")
end

-- 该方法名字每个文件不要重复
function getDailySignInViewLayer()
	return _layer
end

function createDailySignInViewLayer()
    _init()

    function _layer:getInfo()
        _getInfo()
    end

    local function _onEnter()

    end

    local function _onExit()
        _layer = nil
        _data = nil
        _tableView = nil
        _bTableViewTouch = false
    end

    --onEnter onExit
    local function _layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        end
    end

local function onTouchBegan(x, y)
        if _bAni then
            return true
        end
        return false
    end

    local function onTouchEnded(x, y)
    end

    local function onTouch(eventType, x, y)
        if eventType == "began" then   
            return onTouchBegan(x, y)
        elseif eventType == "moved" then
        elseif eventType == "ended" then
        end
    end
    _layer:registerScriptTouchHandler(onTouch, false, -300, true)
    _layer:setTouchEnabled(true)
    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end