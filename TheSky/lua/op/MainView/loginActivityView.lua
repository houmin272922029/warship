local _layer = nil
local _priority = -132
local menu
local _tableView
local allActivity

LoginActivityOwner = LoginActivityOwner or {}
ccb["LoginActivityOwner"] = LoginActivityOwner

local function onItemTaped( tag )
    local itemContent = allActivity[tag]
    local allKey = itemContent.activetyName
    if havePrefix(allKey, "rewardExchange") then
        if getMainLayer() then
            getMainLayer():addChild(createExchangeActivityLayer(allKey, _priority - 2), 200)
        end
    elseif allKey == Activity_Rebate1 then
        if getMainLayer() then
            getMainLayer():addChild(createPurchaseRebateLayer(_priority - 2), 200)
        end
    elseif allKey == Activity_Rebate2 then
        if getMainLayer() then
            getMainLayer():addChild(createExpenseRebateLayer(_priority - 2), 200)
        end
    elseif allKey == Activity_Rebate3 then
        if getMainLayer() then
            getMainLayer():addChild(createExpenseRebateGoldLayer(_priority - 2), 200)
        end
    elseif allKey == Activity_Rebate4 then
        if getMainLayer() then
            getMainLayer():addChild(createPurchaseSingleRebateLayer(_priority - 2), 200)
        end
    elseif allKey == Activity_Quiz then
        if getMainLayer() then
            getMainLayer():addChild(createQuizMainLayer(_priority - 2), 200)
        end
    elseif allKey == Activity_LevelUp then
        if getMainLayer() then
            getMainLayer():addChild(createActivityOfLevelLayer(_priority - 2), 200)
        end
    elseif allKey == Activity_Arena then
        if getMainLayer() then
            getMainLayer():addChild(createActivityOfArenaCompetitionLayer(_priority - 2), 200)
        end
    elseif allKey == Activity_JigsawPuzzle then
        if getMainLayer() then
            getMainLayer():addChild(createActivityOfJigsawLayer(_priority - 2), 200) --拼图游戏
        end
    elseif havePrefix(allKey, Activity_FanLi) then
        if getMainLayer() then
            getMainLayer():addChild(createActivityOfFanLiLayer(allKey, _priority - 2), 200) -- 返利
        end
    elseif havePrefix(allKey, Activity_Gamble) then
        if getMainLayer() then
            getMainLayer():addChild(createActivityOfGambleStartLayer(_priority - 2), 200) -- 摇摇乐
        end
    else
        if getMainLayer() then
            getMainLayer():addChild(createLoginActivityCellView(tag), 200)
        end
    end
    
    -- _layer:removeFromParentAndCleanup(true)
end 

local function _addTableView()

    local containLayer = tolua.cast(LoginActivityOwner["containLayer"],"CCLayer")
    local width = containLayer:getContentSize().width

    allActivity = loginActivityData:getAllActivity( )
    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            local norSp = CCSprite:createWithSpriteFrameName("loginBtn2.png")
            r = CCSizeMake(width, LoginActivityOwner["loginActivity_bg"]:getContentSize().height / 3)
        elseif fn == "cellAtIndex" then
            -- Return CCTableViewCell, a1 is cell index (zero based), a2 is dequeued cell (maybe nil)
            -- Do something to create cell  and change the content  
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
             local  _hbCell
            _hbCell = CCLayer:create()
            -- _hbCell = CCLayerColor:create(ccc4(255,0,0,255))

            _hbCell:setContentSize(CCSizeMake(width,120))
            _hbCell:setAnchorPoint(ccp(0,0))
            _hbCell:setPosition(ccp(0,0))
            local menu = CCMenu:create()

            local loginActivity_bg = LoginActivityOwner["loginActivity_bg"]


            for i = 1,3 do
                if getMyTableCount(allActivity) >= (a1 * 3 + i) then
                    local itemContent = allActivity[a1 * 3 + i]
                    local norSp,selSp
                    local allKey = itemContent.activetyName
                    if allKey == Activity_conLoginOne then
                        norSp = CCSprite:createWithSpriteFrameName("loginBtn2.png")
                        selSp = CCSprite:createWithSpriteFrameName("loginBtn2.png")
                    elseif allKey == Activity_conLogin then
                        norSp = CCSprite:createWithSpriteFrameName("loginBtn1.png")
                        selSp = CCSprite:createWithSpriteFrameName("loginBtn1.png")
                    elseif allKey == Activity_notConLogin then
                        norSp = CCSprite:createWithSpriteFrameName("signInBtn1.png")
                        selSp = CCSprite:createWithSpriteFrameName("signInBtn1.png")
                    elseif allKey == Activity_addConLogin then
                        norSp = CCSprite:createWithSpriteFrameName("signInBtn2.png")
                        selSp = CCSprite:createWithSpriteFrameName("signInBtn2.png")
                    elseif allKey == Activity_Exchange1 or allKey == Activity_Exchange2 or allKey == Activity_Exchange3 then
                        norSp = CCSprite:createWithSpriteFrameName("exchangeBtn1.png")
                        selSp = CCSprite:createWithSpriteFrameName("exchangeBtn1.png")
                    elseif allKey == Activity_Rebate1 or allKey == Activity_Rebate2 or allKey == Activity_Rebate4 then
                        norSp = CCSprite:createWithSpriteFrameName("rebateItemBtn.png")
                        selSp = CCSprite:createWithSpriteFrameName("rebateItemBtn.png")
                    elseif allKey == Activity_Rebate3 then
                        norSp = CCSprite:createWithSpriteFrameName("rebateGoldBtn.png")
                        selSp = CCSprite:createWithSpriteFrameName("rebateGoldBtn.png")
                    elseif allKey == Activity_Quiz then
                        norSp = CCSprite:createWithSpriteFrameName("guessBtn1.png")
                        selSp = CCSprite:createWithSpriteFrameName("guessBtn1.png")
                    elseif allKey == Activity_LevelUp then
                        norSp = CCSprite:createWithSpriteFrameName("chongjiBtn.png")
                        selSp = CCSprite:createWithSpriteFrameName("chongjiBtn.png")
                    elseif allKey == Activity_Arena then
                        norSp = CCSprite:createWithSpriteFrameName("zhengbaBtn.png")
                        selSp = CCSprite:createWithSpriteFrameName("zhengbaBtn.png")
                    elseif allKey == Activity_JigsawPuzzle then  -- 拼图游戏活动
                        norSp = CCSprite:createWithSpriteFrameName("jigsawBtn.png")
                        selSp = CCSprite:createWithSpriteFrameName("jigsawBtn.png")
                    elseif havePrefix(allKey, Activity_FanLi) then  --  返利
                        norSp = CCSprite:createWithSpriteFrameName("fanliBtn.png")
                        selSp = CCSprite:createWithSpriteFrameName("fanliBtn.png") 
                    elseif havePrefix(allKey, Activity_Gamble) then --  摇摇乐
                        norSp = CCSprite:createWithSpriteFrameName("oabBtn.png")
                        selSp = CCSprite:createWithSpriteFrameName("oabBtn.png") 
                    end

                    local item
                    item = CCMenuItemSprite:create(norSp, selSp)
                    local countSprite = CCSprite:createWithSpriteFrameName("count_bg.png")
                    item:setAnchorPoint(ccp(0.5, 0.5))
                    item:setPosition(ccp((2 * i - 1) * width / 6, _hbCell:getContentSize().height * 0.65))
                    item:addChild(countSprite)
                    countSprite:setAnchorPoint(ccp(0.5, 0.5))
                    countSprite:setPosition(item:getContentSize().width / 7 * 6, item:getContentSize().height / 6* 5)
                    menu:addChild(item, 1, a1 * 3 + i)

                    local Countlabel = CCLabelTTF:create("", "ccbResources/FZCuYuan-M03S.ttf", 20)
                    countSprite:addChild(Countlabel)
                    Countlabel:setPosition(countSprite:getContentSize().width / 2, countSprite:getContentSize().height / 2)

                    item:registerScriptTapHandler(onItemTaped)

                    local activityContent = loginActivityData:getExchangeData( allKey )
                    local canExchangeCount = 0
                    for i=1,getMyTableCount(activityContent.content) do
                        local cellContent = activityContent.content[tonumber(i)]
                        if cellContent.canExchange then
                            canExchangeCount = canExchangeCount + 1
                        end
                    end
                    if allKey == Activity_Rebate4 then
                        canExchangeCount = loginActivityData:getPurchaseSingleCanTake()
                    end
                    --林绍峰 返利的 可领取奖励次数
                    if havePrefix(allKey, Activity_FanLi) then       
                        canExchangeCount = itemContent.content.available                                      
                    end  
                    if canExchangeCount > 0 then
                        countSprite:setVisible(true)
                        Countlabel:setString(canExchangeCount)
                    else
                        countSprite:setVisible(false)
                    end
                    --添加文字
                    local labelTextSize = 24

                    if isPlatform(IOS_VIETNAM_VI) 
                        or isPlatform(IOS_VIETNAM_EN) 
                        or isPlatform(IOS_VIETNAM_ENSAGA)
                        or isPlatform(IOS_MOBNAPPLE_EN)
                        or isPlatform(IOS_MOB_THAI)
                        or isPlatform(ANDROID_VIETNAM_MOB_THAI)
                        or isPlatform(ANDROID_VIETNAM_VI)
                        or isPlatform(ANDROID_VIETNAM_EN)
                        or isPlatform(ANDROID_VIETNAM_EN_ALL)
                        or isPlatform(IOS_MOBGAME_SPAIN)
                        or isPlatform(ANDROID_MOBGAME_SPAIN)
                        or isPlatform(WP_VIETNAM_EN) then

                        labelTextSize = 18
                        
                    end
                    local label = CCLabelTTF:create("", "ccbResources/FZCuYuan-M03S.ttf", labelTextSize , CCSizeMake(item:getContentSize().width * 2,24), kCCTextAlignmentCenter)
                    
                    if allKey == Activity_conLoginOne or allKey == Activity_conLogin then
                        label:setString(HLNSLocalizedString("登录"))
                    elseif allKey == Activity_notConLogin or allKey == Activity_addConLogin then
                        label:setString(HLNSLocalizedString("签到"))
                    elseif allKey == Activity_Exchange1 or allKey == Activity_Exchange2 or allKey == Activity_Exchange3 then
                        label:setString(HLNSLocalizedString("exchange.title"))
                    elseif allKey == Activity_Rebate1 or allKey == Activity_Rebate3 then
                        label:setString(HLNSLocalizedString("rebate"))
                    elseif allKey == Activity_Rebate2 or allKey == Activity_Rebate4 then
                        label:setString(HLNSLocalizedString("gift"))
                    elseif allKey == Activity_Quiz then
                        label:setString(HLNSLocalizedString("quiz"))
                    elseif allKey == Activity_LevelUp then
                        label:setString(HLNSLocalizedString("activity.levelup"))
                    elseif allKey == Activity_Arena then
                        label:setString(HLNSLocalizedString("activity.Activity_Arena"))
                    elseif allKey == Activity_JigsawPuzzle then --拼图游戏活动
                        label:setString(HLNSLocalizedString("activity.Activity_Jigsaw"))
                    elseif havePrefix(allKey, Activity_FanLi) then -- 返利
                        label:setString(HLNSLocalizedString("activity.Activity_FanLi"))
                    elseif havePrefix(allKey, Activity_Gamble) then -- 摇摇乐
                        label:setString(HLNSLocalizedString("activity.Activity_Gamble"))
                    end
                    label:setPosition(item:getContentSize().width / 2,  item:getContentSize().height / 2 - 50)
                    label:setColor(ccc3(221,233,73))
                    item:addChild(label)
                end
            end

            menu:setPosition(ccp(0,0))
            menu:setAnchorPoint(ccp(0.5,0.5))
            if menu then
                menu:setTouchPriority(_priority - 1)
            end
            _hbCell:addChild(menu)
            a2:addChild(_hbCell, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)

            r = a2
        elseif fn == "numberOfCells" then
            r = math.ceil(getMyTableCount(allActivity) / 3) 
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

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(LoginActivityOwner["loginActivity_bg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        _layer:removeFromParentAndCleanup(true)
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
    _tableView:setTouchPriority(_priority - 1)
end
local function refreshContentView(  )
    allActivity = loginActivityData:getAllActivity( )
    local offset = _tableView:getContentOffset().y
    _tableView:reloadData()
    _tableView:setContentOffset(ccp(0, offset)) 
end
local function _closeView(  )
    _layer:removeFromParentAndCleanup(true) 
end
-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/LoginActivityView.ccbi",proxy,true,"LoginActivityOwner")
    _layer = tolua.cast(node,"CCLayer")
    local bgColorLayer = tolua.cast(LoginActivityOwner["bgColorLayer"],"CCLayerColor")
    bgColorLayer:runAction(CCFadeTo:create(0.3,80))
end

function getLoginActivityLayer(  )
    return _layer
end

function createloginActivityView()  
    _init()

    _priority = (priority ~= nil) and priority or -132

    function _layer:refresh(  )
        refreshContentView()
    end

    function _layer:closeView(  )
        _closeView()
    end

    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
        _addTableView()
    end

    local function _onExit()
        _layer = nil
        _priority = -132
        _tableView = nil
        allActivity = nil
    end

    --onEnter onExit
    local function _layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        end
    end

    _layer:registerScriptTouchHandler(onTouch ,false ,_priority ,true )
    _layer:setTouchEnabled(true)
    _layer:registerScriptHandler(_layerEventHandler)
    
    return _layer
end



