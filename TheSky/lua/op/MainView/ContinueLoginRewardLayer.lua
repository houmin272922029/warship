local _layer
local _priority = -132
local _obtainRewards = nil
local _clickedCards = nil    
local _touchLayer       

-- 名字不要重复
ContinueLoginRewardOwner = ContinueLoginRewardOwner or {}
ccb["ContinueLoginRewardOwner"] = ContinueLoginRewardOwner

local function close(  )
    _layer:removeFromParentAndCleanup(true) 
    local allData = announceData:getAllNotice()
    if getMyTableCount(allData) > 0 then
        getMainLayer():popUpAnLayer()
    end
end


local function addTouchLayer()  
    print("addTouchLayer---------------")      
    local function onTouchBegan(x, y)
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

    _touchLayer = CCLayer:create()
    _layer:addChild(_touchLayer)
    _touchLayer:registerScriptTouchHandler(onTouch ,false ,_priority - 130 ,true )
    _touchLayer:setTouchEnabled(true)
end

local function _sendConfirmToServer()
    local function addAwardCallBack( url,rtnData )
        close()
    end 
    doActionFun("ADD_SUCCESSION_AWARD_URL", {}, addAwardCallBack)
end 

local function onOkClicked()
    print("onOkClicked")
    _sendConfirmToServer()
end
ContinueLoginRewardOwner["onOkClicked"] = onOkClicked

-- 切换每个卡上的图
local function _changeContent( displayIndex, index, disType)
    local card = tolua.cast(ContinueLoginRewardOwner["card"..index], "CCSprite")
    if card then
        card:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("loginRewardFront.png"))
        local iconLayer = tolua.cast(ContinueLoginRewardOwner["iconLayer"..index], "CCLayer")
        if iconLayer then
            -- 创建icon
            local obtainInfo = continueLoginRewardData:getDisplayInfoByIndex( displayIndex )
            local rank = 1
            local obtainItem = ""
            local obtainItemCount = 1
            for k,v in pairs(obtainInfo) do
                obtainItem = k
                obtainItemCount = tonumber(v)
            end

            local soulLabel = tolua.cast(card:getChildByTag(20), "CCSprite")
            local iconSpr = nil
            if havePrefix(obtainItem, "hero_") then
                -- print("hero icon", obtainItem,  herodata:getHeroHeadByHeroId( obtainItem ))
                CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/hero_head.plist")
                if CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(herodata:getHeroHeadByHeroId( obtainItem )) then 
                    iconSpr = CCSprite:createWithSpriteFrameName(herodata:getHeroHeadByHeroId( obtainItem ))
                end
                rank = herodata:getHeroBasicInfoByHeroId(obtainItem).rank
                -- 显示魂魄标签
                if soulLabel then
                    soulLabel:setVisible(true)
                end 
            elseif havePrefix(obtainItem, "shadow_") then
                local shadowInfo = userdata:getExchangeResource(obtainItem)
                rank = shadowInfo.rank
            elseif haveSuffix(obtainItem, "_shard") then
                local shardInfo = userdata:getExchangeResource(obtainItem)
                iconSpr = CCSprite:create(string.format("ccbResources/icons/%s.png",shardInfo.icon))
                CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/publicRes_4.plist")
                local chipIcon = CCSprite:createWithSpriteFrameName("itemChip_icon.png")
                iconSpr:addChild(chipIcon)
                chipIcon:setAnchorPoint(ccp(1,0))
                chipIcon:setPosition(ccp(iconSpr:getContentSize().width,0))
                rank = shardInfo.rank
            else 
                local itemBasicInfo = wareHouseData:getItemResource(obtainItem)
                iconSpr = CCSprite:create(itemBasicInfo.icon) 
                rank = itemBasicInfo.rank
            end 
            if iconSpr then 
                iconSpr:setAnchorPoint(ccp(0.5, 0.5))
                iconSpr:setPosition(ccp(iconLayer:getContentSize().width/2, iconLayer:getContentSize().height/2))
                iconSpr:setScale(iconLayer:getContentSize().width/iconSpr:getContentSize().width)
                iconLayer:addChild(iconSpr, 1)
            end 
            if havePrefix(obtainItem, "shadow_") then
                local shadowInfo = userdata:getExchangeResource(obtainItem)
                if shadowInfo.icon then
                    CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/shadow.plist")
                    playCustomFrameAnimation( string.format("yingzi_%s_",shadowInfo.icon),iconLayer,ccp(iconLayer:getContentSize().width / 2,iconLayer:getContentSize().height / 2),1,4,shadowData:getColorByColorRank( shadowInfo.rank ) )
                end
            end
            -- rank 框
            local rankSpr = tolua.cast(ContinueLoginRewardOwner["rank"..index], "CCSprite")
            if rankSpr then
                rankSpr:setVisible(true)
                if havePrefix(obtainItem, "shadow_") then
                    CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/shadow.plist")
                    rankSpr:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("s_frame.png"))
                else
                    rankSpr:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", rank)))
                end
            end 
            -- 数量
            local countLabel = tolua.cast(ContinueLoginRewardOwner["count"..index], "CCLabelTTF")
            if countLabel then
                countLabel:setVisible(true)
                countLabel:setString(obtainItemCount)
            end 

            -- 置灰
            if disType == 1 then
                card:setColor(ccc3(150,150,150))
                if iconSpr then
                    iconSpr:setColor(ccc3(150,150,150))
                end 
                if rankSpr then
                    rankSpr:setColor(ccc3(150,150,150))
                end 
                -- if countLabel then
                --     countLabel:setColor(ccc3(150,150,150))
                -- end 
                if soulLabel then
                    soulLabel:setColor(ccc3(150,150,150))
                end
            end 

            if disType == 0 then
                -- 对_clickedCards赋值
                if _clickedCards == nil then
                    _clickedCards = {}
                end 
                table.insert(_clickedCards, index)
            end
        end 
    end 
    if _touchLayer then
        _touchLayer:removeFromParentAndCleanup(true)
        _touchLayer = nil
    end
end 

-- 所有的获得卡片点击完了，这时要打开其他的卡片
local function _openAllCards()
    -- 打开确定和关闭按钮
    local okBtn = tolua.cast(ContinueLoginRewardOwner["okBtn"], "CCMenuItemImage")
    okBtn:setVisible(true)
    local okLabel = tolua.cast(ContinueLoginRewardOwner["okLabel"], "CCLabelTTF")
    okLabel:setVisible(true)

    -- 把别的卡都打开
    local unObtainArr = continueLoginRewardData:getUnObtainIndexArr()
    for i=1,9 do
        if not table.ContainsObject(_clickedCards, i) then
            -- _flipCard(i)

            local tempIndex = unObtainArr[1]
            table.remove(unObtainArr, 1)
            _changeContent(tempIndex, i, 1)
        end 
    end
end 

--翻转卡牌
local function _flipCard( index )
    if table.getTableCount(_obtainRewards) <= 0 then
        return
    end 

    local tempIndex = _obtainRewards[1]
    table.remove(_obtainRewards, 1)

    _changeContent(tempIndex, index, 0)

    if table.getTableCount(_obtainRewards) <= 0 then
        _openAllCards()
    end 
end 

local function cardAni1CallBack()
    print("cardAni1CallBack")
    _flipCard(1)
end
ContinueLoginRewardOwner["cardAni1CallBack"] = cardAni1CallBack

local function cardAni2CallBack()
    print("cardAni2CallBack")
    _flipCard(2)
end
ContinueLoginRewardOwner["cardAni2CallBack"] = cardAni2CallBack

local function cardAni3CallBack()
    print("cardAni3CallBack")
    _flipCard(3) 
end
ContinueLoginRewardOwner["cardAni3CallBack"] = cardAni3CallBack

local function cardAni4CallBack()
    print("cardAni4CallBack")
    _flipCard(4)
end
ContinueLoginRewardOwner["cardAni4CallBack"] = cardAni4CallBack

local function cardAni5CallBack()
    print("cardAni5CallBack")
    _flipCard(5)
end
ContinueLoginRewardOwner["cardAni5CallBack"] = cardAni5CallBack

local function cardAni6CallBack()
    print("cardAni6CallBack")
    _flipCard(6)
end
ContinueLoginRewardOwner["cardAni6CallBack"] = cardAni6CallBack

local function cardAni7CallBack()
    print("cardAni7CallBack")
    _flipCard(7)
end
ContinueLoginRewardOwner["cardAni7CallBack"] = cardAni7CallBack

local function cardAni8CallBack()
    print("cardAni8CallBack")
    _flipCard(8)
end
ContinueLoginRewardOwner["cardAni8CallBack"] = cardAni8CallBack

local function cardAni9CallBack()
    print("cardAni9CallBack")
    _flipCard(9)
end
ContinueLoginRewardOwner["cardAni9CallBack"] = cardAni9CallBack

local function changeCard(sender)
    local card = tolua.cast(sender, "CCSprite")
    _flipCard(card:getTag())
end

local function cardAni(index)
    local card = tolua.cast(ContinueLoginRewardOwner["card"..index], "CCSprite")
    local frameArray = CCArray:create()
    frameArray:addObject(CCScaleTo:create(0.1, 0, 1))
    frameArray:addObject(CCCallFuncN:create(changeCard))
    frameArray:addObject(CCScaleTo:create(0.1, 1, 1))
    card:runAction(CCSequence:create(frameArray))
end

-- 点击卡片按钮
local function onCardClicked(tag)
    print("onCardClicked", tag)
    if table.getTableCount(_obtainRewards) <= 0 then
        return
    end 

    if table.ContainsObject(_clickedCards, tag) then
        return
    end 

    cardAni(tag)
end
ContinueLoginRewardOwner["onCardClicked"] = onCardClicked

local function _refreshUI()
    for i=1,9 do
        local cardBtn = tolua.cast(ContinueLoginRewardOwner["cardBtn"..i], "CCMenuItemImage")
        if cardBtn then
            --设置透明度  0-255 0 为全透明
            cardBtn:setOpacity(0)
        end 
    end

    local okBtn = tolua.cast(ContinueLoginRewardOwner["okBtn"], "CCMenuItemImage")
    okBtn:setVisible(false)
    local okLabel = tolua.cast(ContinueLoginRewardOwner["okLabel"], "CCLabelTTF")
    okLabel:setVisible(false)

    -- 下面的天数
    if table.getTableCount(_obtainRewards) > 0 then
        for i=1, table.getTableCount(_obtainRewards) do
            local light = tolua.cast(ContinueLoginRewardOwner["light"..i], "CCSprite")
            if light then
                light:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("light_1.png"))
            end 
        end
    end 
end 

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/ContinueLoginRewardView.ccbi", proxy, true,"ContinueLoginRewardOwner")
    _layer = tolua.cast(node,"CCLayer")

    _obtainRewards = continueLoginRewardData:getObtain()
    _refreshUI()
end

local function onTouchBegan(x, y)
    -- local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    -- local infoBg = tolua.cast(SelectSMPOwner["infoBg"], "CCSprite")
    -- local rect = infoBg:boundingBox()
    -- if not rect:containsPoint(touchLocation) then
    --     _layer:removeFromParentAndCleanup(true)
    --     return true
    -- end
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
    local menu1 = tolua.cast(ContinueLoginRewardOwner["menu"], "CCMenu")
    menu1:setHandlerPriority(_priority-1)
end

-- 该方法名字每个文件不要重复
function getContinueLoginRewardLayer()
	return _layer
end

function createContinueLoginRewardLayer(priority)
    _priority = (priority ~= nil) and priority or -132
    _init()

    local function _onEnter()
        print("ContinueLoginReward onEnter")
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
    end

    local function _onExit()
        print("ContinueLoginReward onExit")
        _layer = nil
        _priority = -132
        _obtainRewards = nil
        _clickedCards = nil
        _touchLayer = nil
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