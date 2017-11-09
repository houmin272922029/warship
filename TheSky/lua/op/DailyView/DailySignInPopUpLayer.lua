local _layer
local _tableView
local _priority = -132
local _data 
local _index
local _state

-- 名字不要重复
DailySignInPopUpViewOwner = DailySignInPopUpViewOwner or {}
ccb["DailySignInPopUpViewOwner"] = DailySignInPopUpViewOwner

--关闭按钮
local function closeItemClick()
    popUpCloseAction(DailySignInPopUpViewOwner, "infoBg", _layer)
end
DailySignInPopUpViewOwner["closeItemClick"] = closeItemClick


--确定按钮
local function confirmBtnTaped()
    -- 两个状态 1 正常签到  2 补签
    
    if _state == 1 then -- 正常签到
        local function CallBack( url,rtnData )
            getDailySignInViewLayer():getInfo()
            popUpCloseAction(DailySignInPopUpViewOwner, "infoBg", _layer)
        end
        doActionFun("DAILY_SIGNIN", {}, CallBack)
    elseif _state == 3  then -- vip 领取
        popUpCloseAction(DailySignInPopUpViewOwner, "infoBg", _layer)
        local month = _data.signIn.month
        local dic = ConfigureStorage[string.format("HZ_SignIn_reward_%d", month)]
        local data = dic[tostring(_index)]
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
        if userdata:getVipLevel() >= doubledVipLevel then -- 可以领取
            print("玩家vip等级大于领取双倍等级")
            local function CallBack( )
                -- body
                getDailySignInViewLayer():getInfo()
            end
            doActionFun("DAILY_SUPPLSIGNIN", {_index}, CallBack)
        else
            -- getMainLayer():goToLogue()
            if getMainLayer() then
                getMainLayer():addChild(createShopRechargeLayer(-140), 100)
            end
        end
    else
        popUpCloseAction(DailySignInPopUpViewOwner, "infoBg", _layer)
        local function ConfirmClickCallBack()
            getDailySignInViewLayer():getInfo()
        end
        local price = ConfigureStorage.HZ_SignIn_Price[tostring(_data.signIn.supplTimes + 1)].price
        local function needItemConfirmClick()
            if userdata.gold < price  then  --金币不足 跳转进入商城界面
                if getMainLayer() then
                    getMainLayer():addChild(createShopRechargeLayer(-140), 100)
                end
            else
                -- 补签接口
                doActionFun("DAILY_SUPPLSIGNIN", {_index}, ConfirmClickCallBack)
            end
        end 
        local text = HLNSLocalizedString("Daily_signInSpent", price)
        CCDirector:sharedDirector():getRunningScene():addChild(createSimpleConfirCardLayer(text))
        SimpleConfirmCard.confirmMenuCallBackFun = needItemConfirmClick
        SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction  
    end
end
DailySignInPopUpViewOwner["confirmBtnTaped"] = confirmBtnTaped

local function _addTableView()
   
    MultiItemCellOwner = MultiItemCellOwner or {}
    ccb["MultiItemCellOwner"] = MultiItemCellOwner

    local containLayer = tolua.cast(DailySignInPopUpViewOwner["containLayer"],"CCLayer")

    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(600, 120)
        elseif fn == "cellAtIndex" then
            -- Return CCTableViewCell, a1 is cell index (zero based), a2 is dequeued cell (maybe nil)
            -- Do something to create cell  and change the content
            
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            --单条数据
            local month = _data.signIn.month
            local dic = ConfigureStorage[string.format("HZ_SignIn_reward_%d", month)]
            local itemId = dic[tostring(_index)].reward
            local count = dic[tostring(_index)].amount
            local proxy = CCBProxy:create()
            local _hbCell = tolua.cast(CCBReaderLoad("ccbResources/MultiItemCell.ccbi", proxy, true, "MultiItemCellOwner"), "CCLayer")
            local resDic = userdata:getExchangeResource(itemId)

            local rankFrame = tolua.cast(MultiItemCellOwner["rankFrame"], "CCSprite")
            local contentLayer = tolua.cast(MultiItemCellOwner["contentLayer"],"CCLayer")
            local bigSprite = tolua.cast(MultiItemCellOwner["bigSprite"],"CCSprite")
            local littleSprite = tolua.cast(MultiItemCellOwner["littleSprite"],"CCSprite")
            local soulIcon = tolua.cast(MultiItemCellOwner["soulIcon"],"CCSprite")
            local chipIcon = tolua.cast(MultiItemCellOwner["chipIcon"],"CCSprite")
            local itemName = tolua.cast(MultiItemCellOwner["itemName"], "CCSprite")
            itemName:setString(tostring(resDic.name))
            local itemCountLabel = tolua.cast(MultiItemCellOwner["countLabel"],"CCLabelTTF")
            itemCountLabel:setString(tostring(count))
            chipIcon:setVisible(false)
            if havePrefix(itemId, "weapon_") or havePrefix(itemId, "belt_") or havePrefix(itemId, "armor_") then
                -- 装备
                bigSprite:setVisible(true)
                local texture
                if haveSuffix(itemId, "_shard") then
                    chipIcon:setVisible(true)
                    texture = CCTextureCache:sharedTextureCache():addImage(string.format("ccbResources/icons/%s.png", resDic.icon))
                else
                    texture = CCTextureCache:sharedTextureCache():addImage(resDic.icon)
                end
                if texture then
                    bigSprite:setVisible(true)
                    bigSprite:setTexture(texture)
                end

            elseif havePrefix(itemId, "item") then
                -- 道具
                bigSprite:setVisible(true)
                local texture = CCTextureCache:sharedTextureCache():addImage(resDic.icon)
                if texture then
                    bigSprite:setVisible(true)
                    bigSprite:setTexture(texture)
                end
            elseif havePrefix(itemId, "shadow") then
                -- 影子
                rankFrame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("s_frame.png"))
                rankFrame:setPosition(ccp(rankFrame:getPositionX() + 5,rankFrame:getPositionY() - 5))
                if resDic.icon then
                    playCustomFrameAnimation(string.format("yingzi_%s_", resDic.icon), contentLayer, 
                        ccp(contentLayer:getContentSize().width / 2,contentLayer:getContentSize().height / 2), 1, 4,
                        shadowData:getColorByColorRank(resDic.rank))
                end
            elseif havePrefix(itemId, "hero") then
                -- 魂魄
                littleSprite:setVisible(true)
                littleSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(resDic.icon))

            elseif havePrefix(itemId, "book") then
                -- 奥义
                bigSprite:setVisible(true)
                local texture = CCTextureCache:sharedTextureCache():addImage(resDic.icon)
                if texture then
                    bigSprite:setVisible(true)
                    bigSprite:setTexture(texture)
                end
            else
                -- 金币 银币
                bigSprite:setVisible(true)
                local texture = CCTextureCache:sharedTextureCache():addImage(resDic.icon)
                if texture then
                    bigSprite:setVisible(true)
                    bigSprite:setTexture(texture)
                end
            end
            if not havePrefix(itemId, "shadow") then
                rankFrame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", resDic.rank)))
            end

            -- _hbCell:setScale(retina)
            a2:addChild(_hbCell, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            r = a2
        elseif fn == "numberOfCells" then
            r = 1
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
    _addTableView()
    local stateBtnLabel = tolua.cast(DailySignInPopUpViewOwner["stateBtnLabel"] , "CCLabelTTF")
    local stateLabel = tolua.cast(DailySignInPopUpViewOwner["stateLabel"] , "CCLabelTTF")
    local signInLabel = tolua.cast(DailySignInPopUpViewOwner["signInLabel"] , "CCLabelTTF")
    signInLabel:setString(HLNSLocalizedString("Daily_signInLabel",_index))
    local stateBtn = tolua.cast(DailySignInPopUpViewOwner["stateBtn"] , "CCMenuItemImage")

     -- 能够翻倍的vip等级  rate 倍数
    -- 0 过期 1 当天未签可领 2 补签可领 3 VIP补领奖 4 不可签到 
    if _state == 0 then
        stateBtnLabel:setVisible(false)
        stateLabel:setString(HLNSLocalizedString("Daily_haveGetReward"))
        stateBtn:setVisible(false)
    elseif _state == 1 then
        stateLabel:setString(HLNSLocalizedString("Daily_getTodayReward"))
        stateBtnLabel:setString(HLNSLocalizedString("Daily_nameOfSignIn"))
    elseif _state == 2 then
        stateLabel:setString(HLNSLocalizedString("Daily_ICansuppl"))
        stateBtnLabel:setString(HLNSLocalizedString("Daily_nameOfSuppl"))
    elseif _state == 3 then
        -- 先判断是否符合vip领取条件()
        local month = _data.signIn.month
        local dic = ConfigureStorage[string.format("HZ_SignIn_reward_%d", month)]
        local data = dic[tostring(_index)]
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
        print("doubledVipLevel" , doubledVipLevel)
        if userdata:getVipLevel() >= doubledVipLevel then -- 可以领取 
            stateLabel:setString(HLNSLocalizedString("Daily_getVipReward"))
            stateBtnLabel:setString(HLNSLocalizedString("Daily_lingqu"))
        else
            stateLabel:setString(HLNSLocalizedString("Daily_NotgetVipReward"))
            stateBtnLabel:setString(HLNSLocalizedString("Daily_chongzhi"))
        end 
    elseif _state == 4 then
        stateBtnLabel:setVisible(false)
        stateLabel:setString(HLNSLocalizedString("Daily_signInUnconditional"))   
        stateBtn:setVisible(false)
    elseif _state == 5 then
        stateBtnLabel:setVisible(false)
        stateLabel:setString(HLNSLocalizedString("Daily_signInconditional"))   
        stateBtn:setVisible(false)
    end
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    local proxy = CCBProxy:create()
    local node  = CCBReaderLoad("ccbResources/DailySignInPopUpView.ccbi", proxy, true, "DailySignInPopUpViewOwner")
    _layer = tolua.cast(node,"CCLayer")
    refresh()
end

-- 修改 按钮优先级
local function setMenuPriority()
    local menu = tolua.cast(DailySignInPopUpViewOwner["menu"], "CCMenu")
    menu:setHandlerPriority(_priority - 1)
end



local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(DailySignInPopUpViewOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction(DailySignInPopUpViewOwner, "infoBg", _layer)
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

-- 该方法名字每个文件不要重复
function getDailySignInPopUpLayer()
	return _layer
end


function createDailySignInPopUpLayer(data , state , index, priority)
    _priority = (priority ~= nil) and priority or -132
    _data = data
    _state = state
    _index = index
    _init()
    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
    end

    local function _onExit()
        _tableView = nil
        _layer = nil
        _priority = -132
        
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