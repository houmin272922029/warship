--林绍峰 单笔充值返利功能

local _layer
local _cellLayer = nil
local MyData
-- local arrayForAudit = {} -- vip*********

ActivityOfFanLiOwner = ActivityOfFanLiOwner or {}
ccb["ActivityOfFanLiOwner"] = ActivityOfFanLiOwner

ActivityOfFanLiCellOwner = ActivityOfFanLiCellOwner or {}
ccb["ActivityOfFanLiCellOwner"] = ActivityOfFanLiCellOwner

local function closeItemClick()
    popUpCloseAction(ActivityOfFanLiOwner, "infoBg", _layer )
end
ActivityOfFanLiOwner["closeItemClick"] = closeItemClick


local function RechargeClicked()
    getMainLayer():addChild(createShopRechargeLayer(_priority - 4), 210)
end
ActivityOfFanLiOwner["RechargeClicked"] = RechargeClicked


--显示奖励物品详情 的点击事件
local function itemBtnClicked( tag)
    print("lsf itemBtnClicked")
    print("tag" , tag)
    --local dic = _shopData[tag]

    local itemId = MyData.items[tostring(tag - 1)].itemId
   
    if havePrefix(itemId, "weapon_") or havePrefix(itemId, "belt_") or havePrefix(itemId, "armor_") then
        -- 装备
        if haveSuffix(itemId, "_shard") then
            itemId = string.sub(itemId,1,-7)
        end
        getMainLayer():getParent():addChild(createEquipInfoLayer(itemId, 2, _priority - 2), 10)
    elseif havePrefix(itemId, "item") or havePrefix(itemId, "key") or havePrefix(itemId, "bag") 
        or havePrefix(itemId, "stuff") or havePrefix(itemId, "drawing") then
        -- 道具
        getMainLayer():getParent():addChild(createItemDetailInfoLayer(itemId, _priority - 2, 1, 1), 10)
    elseif havePrefix(itemId, "shadow") then
        -- 影子
        local dic = {}
        local item = shadowData:getOneShadowConf(itemId)
        dic.conf = item
        dic.id = itemId
        getMainLayer():getParent():addChild(createShadowPopupLayer(dic, nil, nil, _priority - 2, 1), 10)
    elseif havePrefix(itemId, "hero") then
        -- 魂魄
        getMainLayer():getParent():addChild(createHeroInfoLayer(itemId, HeroDetail_Clicked_Handbook, _priority - 2), 10)
    elseif havePrefix(itemId, "book") then
        -- 奥义
        getMainLayer():getParent():addChild(createHandBookSkillDetailLayer(itemId, _priority - 2), 10) 
    elseif havePrefix(itemId, "chapter_") then
        -- 残章
        local bookId = string.format("book_%s", string.split(itemId, "_")[2])
        getMainLayer():getParent():addChild(createHandBookSkillDetailLayer(bookId, _priority - 2), 10) 
    else
        -- 金币 银币
    end
end
ActivityOfFanLiCellOwner["itemBtnClicked"] = itemBtnClicked


--领取奖励的按钮 发光
local function _acceptPrBtn_Light()

    if light then
        light:stopAllActions()
        light:removeFromParentAndCleanup(true)
    end
    if MyData.available > 0 then 
        
        local light = CCSprite:createWithSpriteFrameName("lightingEffect_recruitBtn_1.png")
        local animFrames = CCArray:create()
        for j = 1, 3 do
            local frameName = string.format("lightingEffect_recruitBtn_%d.png",j)
            local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(frameName)
            animFrames:addObject(frame)
        end
        local animation = CCAnimation:createWithSpriteFrames(animFrames, 0.2)
        local animate = CCAnimate:create(animation)
        light:runAction(CCRepeatForever:create(animate))
        acceptPr_Btn = ActivityOfFanLiOwner["acceptThePrize"]
        acceptPr_Btn:addChild(light,1,9888)
        light:setPosition(ccp(acceptPr_Btn:getContentSize().width / 2,acceptPr_Btn:getContentSize().height / 2 + 2))
    end
end


--刷新 取后台数据
local function _refreshData()

    --活动标题
    local title1 = tolua.cast(ActivityOfFanLiOwner["title1"] , "CCLabelTTF")
    title1:setString( MyData.name )

    --领取奖励的字
    local acceptThePrize_Lable = tolua.cast(ActivityOfFanLiOwner["acceptThePrize_Lable"] , "CCLabelTTF")
    if MyData.available == 0 then
        acceptThePrize_Lable:setString( HLNSLocalizedString("Activity.FanLi.acceptThePrize") )  --领取奖励
    else
        acceptThePrize_Lable:setString( HLNSLocalizedString("Activity.FanLi.acceptThePrize") .. "×" .. MyData.available )  --领取奖励 × 3 
    end

    if MyData.available >0 then
        _acceptPrBtn_Light() --领奖按钮 高光
    end

    --剩余活动次数
    local remainderTime_ttf = tolua.cast(ActivityOfFanLiOwner["remainderTime_ttf"] , "CCLabelTTF")
    if MyData.repeated.status == 1 then
       
        remainderTime_ttf:setString( HLNSLocalizedString("Activity.FanLi.remainderTime1",MyData.remainderTimes) )  -- 本日还可以参加
    elseif MyData.repeated.status == 0 or MyData.repeated.status == 2 then
        remainderTime_ttf:setString( HLNSLocalizedString("Activity.FanLi.remainderTime2",MyData.remainderTimes)  )  -- 还可以参加
    end

   
    --活动时间
    local acTime = tolua.cast(ActivityOfFanLiOwner["acTime"] , "CCLabelTTF")
    local  hourMin1  = DateUtil:second2hm( MyData.activityOpenTime )
    print("lsf  ",hourMin1)
    local openTimer =   DateUtil:formatTimeYMDHM( MyData.activityOpenTime )
    local endTimer =  DateUtil:formatTimeYMDHM( MyData.activityEndTime ) 
    acTime:setString(openTimer .. ' ～ ' .. endTimer)


    --活动内容
    local acContent = tolua.cast(ActivityOfFanLiOwner["acContent"] , "CCLabelTTF")
    local desc1 = MyData.description
    --acContent:setString( desc1["0"] )
    local temp = {}
    for i=0,getMyTableCount(desc1) - 1 do
        table.insert(temp, desc1[tostring(i)])
    end
    acContent:setString( temp[1] )
   

    --4个奖励物品 根据id 显示具体图标
    for i=1,4 do
        if MyData.items[tostring(i - 1)] then

            local itemId = MyData.items[tostring(i - 1)].itemId
            local itemAmount = MyData.items[tostring(i - 1)].itemAmount

            --reward.itemId
            local resDic = userdata:getExchangeResource(itemId)
            local contentLayer = tolua.cast(ActivityOfFanLiCellOwner["contentLayer"..i],"CCLayer")
            contentLayer:setVisible(true)

            --奖励物品的点击事件
            local avatarItem = tolua.cast(ActivityOfFanLiCellOwner["rankBtn"..i], "CCMenuItemImage")
            avatarItem:setVisible(true)
            avatarItem:setTag(i)

            local bigSprite = tolua.cast(ActivityOfFanLiCellOwner["bigSprite"..i],"CCSprite")
            local littleSprite = tolua.cast(ActivityOfFanLiCellOwner["littleSprite"..i],"CCSprite")
            local soulIcon = tolua.cast(ActivityOfFanLiCellOwner["soulIcon"..i],"CCSprite")
            local chipIcon = tolua.cast(ActivityOfFanLiCellOwner["chip_icon"..i],"CCSprite")
            chipIcon:setVisible(false)
            local countLabel = tolua.cast(ActivityOfFanLiCellOwner["countLabel"..i],"CCLabelTTF")

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
                avatarItem:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("s_frame.png"))
                avatarItem:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("s_frame.png"))

                avatarItem:setPosition(ccp(avatarItem:getPositionX() + 5,avatarItem:getPositionY() - 5))
                if resDic.icon then
                    playCustomFrameAnimation( string.format("yingzi_%s_",resDic.icon),contentLayer,ccp(contentLayer:getContentSize().width / 2,contentLayer:getContentSize().height / 2),1,4,shadowData:getColorByColorRank( resDic.rank ) )
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
                avatarItem:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", resDic.rank)))
                avatarItem:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", resDic.rank)))
            end

            -- 设置奖励物品 数量      
            countLabel:setString(  tostring (MyData.items[tostring(i - 1)].itemAmount) )

        end
    end

end

--奖励物品 调用显示
local function _addReward()
    
    local rewardLayer = ActivityOfFanLiOwner["rewardLayer"]
    local size = rewardLayer:getContentSize()
    local  proxy = CCBProxy:create()
    _cellLayer:setAnchorPoint(ccp(0, 0))
    rewardLayer:addChild(_cellLayer,1000)
    _cellLayer:setPosition(0,0)
end


--领取奖励按钮
local function AcceptThePrizeClicked()
      --没有新的充值
    if MyData.available == 0 then
        if MyData.remainderTimes == 0 then
            if MyData.repeated.status == 1 then  
                ShowText( HLNSLocalizedString("Activity.FanLi.AcceptThePrizeClicked_Error1") )  --每天的次数用光了 status1
                return               
            elseif  MyData.repeated.status == 2 or MyData.repeated.status == 0  then  
                ShowText( HLNSLocalizedString("Activity.FanLi.AcceptThePrizeClicked_Error2") )  --活动所有的次数 都 用光了
                return    
            end
        end   
        ShowText( HLNSLocalizedString("Activity.FanLi.AcceptThePrizeClicked_Error") ) --没有新的充值
        return      
    end
    
    local uid = MyData.uid
    local function  callback(url, rtnData)
        -- body
        print("成功调用")
        loginActivityData.activitys[Activity_FanLi][uid] = rtnData.info[uid]
        closeItemClick()
    end
    doActionFun("ACTIVITY_GET_FANLI", {uid}, callback)
end
ActivityOfFanLiOwner["AcceptThePrizeClicked"] = AcceptThePrizeClicked



local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(ActivityOfFanLiOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction(ActivityOfFanLiOwner, "infoBg", _layer)
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
    local menu = tolua.cast(ActivityOfFanLiOwner["menu"], "CCMenu")
    menu:setTouchPriority(_priority - 2)

    local menuCell = tolua.cast(ActivityOfFanLiCellOwner["menu1"], "CCMenu")
    menuCell:setTouchPriority(_priority - 2)

end

function getFanLiLayer()
    return _layer
end


local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/ActivityOfFanLi.ccbi",proxy, true,"ActivityOfFanLiOwner")
    _layer = tolua.cast(node,"CCLayer")

    local  proxy1 = CCBProxy:create()
    local  node1  = CCBReaderLoad("ccbResources/ActivityOfFanLiCell.ccbi",proxy1, true,"ActivityOfFanLiCellOwner")
    _cellLayer = tolua.cast(node1,"CCLayer")


    local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
    cache:addSpriteFramesWithFile("ccbResources/shadow.plist")
    
    _addReward() --奖励物品 的 调用显示
    _refreshData()

end


function createActivityOfFanLiLayer( uid, priority )
    _priority = (priority ~= nil) and priority or -132
    print(uid)
    MyData = loginActivityData.activitys[Activity_FanLi][uid]
    --PrintTable(MyData)
    _init()

    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)

        -- addObserver(NOTI_TICK, refreshTimeLabel)
        popUpUiAction(ActivityOfFanLiOwner, "infoBg")
    end

    local function _onExit()
        print("FanLi onExit")
        _layer = nil
        _cellLayer = nil
        MyData = nil
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