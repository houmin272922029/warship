local _layer = nil
local _priority = -138
-- local menu
local _tableView
local theActiviityKey
local succDay
local findDays
local specialTag 
local todayArray

FestivalActivityOwner = FestivalActivityOwner or {}
ccb["FestivalActivityOwner"] = FestivalActivityOwner

CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/publicRes_1.plist")

local function closeItemClick()
    if _layer then
        FestivalActivityOwner["commitBtn"]:setEnabled(true)
        _layer:removeFromParentAndCleanup(true)
    end
end
FestivalActivityOwner["closeItemClick"] = closeItemClick

local function getCellHeight( string,width,fontSize,fontName )
    if not fontName then
        fontName = "ccbResources/FZCuYuan-M03S.ttf"
    end
    local tempLabel = CCLabelTTF:create(string,fontName,fontSize,CCSizeMake(width,0),kCCTextAlignmentLeft)
    tempLabel:setVisible(false)
    _layer:addChild(tempLabel,200,8888)
    local height = tempLabel:getContentSize().height
    tempLabel:removeFromParentAndCleanup(true)
    return height
end

local function displayReward(info , card , count)
    local head = tolua.cast(FestivalActivityOwner["head"..card], "CCSprite")
    local smallHead = tolua.cast(FestivalActivityOwner["head_"..card], "CCSprite")
    local rewardName = tolua.cast(FestivalActivityOwner["name"..card], "CCLabelTTF")
    local frame = tolua.cast(FestivalActivityOwner["frame"..card], "CCSprite")
    local chipIcon = tolua.cast(FestivalActivityOwner["chipIcon"..card], "CCSprite")
    local contentLayer = tolua.cast(FestivalActivityOwner["contentLayer"..card], "CCSprite")
    -- local rewardCount = tolua.cast(FestivalActivityOwner["count"..card], "CCLabelTTF")
    head:setVisible(false)
    smallHead:setVisible(false)
    rewardName:setVisible(false)
    frame:setVisible(false)
    chipIcon:setVisible(false)
    contentLayer:setVisible(false)

    if havePrefix(info, "hero_") then
        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/hero_head.plist")
        if CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(herodata:getHeroHeadByHeroId( info )) then 
            head:setVisible(true)
            head:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(herodata:getHeroHeadByHeroId( info )))
            -- rewardCount:setString(count)
        end
        local heroConf = herodata:getHeroBasicInfoByHeroId( info )
        frame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", heroConf.rank)))
        frame:setVisible(true)
        if rewardName then
            local heroConf = herodata:getHeroConfig(info)
            if heroConf and heroConf.name then
                rewardName:setVisible(true)
                rewardName:setString(heroConf.name.."  X "..count)
            end
        end 
    else 
        -- local itemBasicInfo = wareHouseData:getItemResource(info)
        local itemBasicInfo = userdata:getExchangeResource(info)

        if havePrefix(info, "weapon_") or havePrefix(info, "belt_") or havePrefix(info, "armor_") then
            -- 装备
            local texture = CCTextureCache:sharedTextureCache():addImage(string.format("ccbResources/icons/%s.png", itemBasicInfo.icon))
            if haveSuffix(info, "_shard") then
                chipIcon:setVisible(true)
            end
            if texture then
                smallHead:setVisible(true)
                smallHead:setTexture(texture)
            end
            frame:setVisible(true)
            frame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", itemBasicInfo.rank)))
        elseif havePrefix(info, "shadow") then
            -- 影子
            -- head:setVisible(true)
            frame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("s_frame.png"))
            frame:setPosition(ccp(frame:getPositionX() + 5,frame:getPositionY() - 5))
            if itemBasicInfo.icon then
                contentLayer:setVisible(true)
                playCustomFrameAnimation( string.format("yingzi_%s_",itemBasicInfo.icon),contentLayer,ccp(contentLayer:getContentSize().width / 2,contentLayer:getContentSize().height / 2),1,4,shadowData:getColorByColorRank( itemBasicInfo.rank ) )
            end
            frame:setVisible(true)
            -- frame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", itemBasicInfo.rank)))
        else
            smallHead:setTexture(CCTextureCache:sharedTextureCache():addImage(itemBasicInfo.icon))
            smallHead:setVisible(true)
            frame:setVisible(true)
            frame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", itemBasicInfo.rank)))
        end

        local name = itemBasicInfo.name
        if rewardName then
            rewardName:setVisible(true)
            rewardName:setString(name.."  X "..count)
            -- rewardCount:setString(count)
        end 
    end
end

local function addAward( )
    local allActivity = loginActivityData:getAllActivity()
    local rewardArr = allActivity[specialTag].content.reward

    if rewardArr[tostring(findDays)] then
        local reward = rewardArr[tostring(findDays)].reward
        local cardCount = getMyTableCount(reward)
        local rewardNameArr = loginActivityData:getActivityRewardName(theActiviityKey,findDays)
        local infoBg = tolua.cast(FestivalActivityOwner["infoBg"], "CCSprite")
        for i = 1, 5 do
            local frame = tolua.cast(FestivalActivityOwner["frame"..i], "CCSprite")
            if i <= cardCount then
                frame:setVisible(true)
                frame:setPosition(ccp(infoBg:getContentSize().width * (i / (cardCount + 1)),infoBg:getContentSize().height * 0.38))
                displayReward(rewardNameArr[i],i,reward[rewardNameArr[i]])
            else
                frame:setVisible(false)
            end
        end
    end
end 

-- 刷新按钮可点状态
local function _refreshBtns( )
   local allActivity = loginActivityData:getAllActivity()

    if allActivity[specialTag] then

        if allActivity[specialTag].activetyName ~= theActiviityKey then
             local commitBtn = tolua.cast(FestivalActivityOwner["commitBtn"], "CCMenuItemImage")
            commitBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn4_2.png"))
        else
            local rewardArr = allActivity[specialTag].content.reward
            local canTake = rewardArr[tostring(findDays)].canTake

            if canTake ~= 0 then
                local commitBtn = tolua.cast(FestivalActivityOwner["commitBtn"], "CCMenuItemImage")
                commitBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn4_2.png"))
            end
        end
    else
        local commitBtn = tolua.cast(FestivalActivityOwner["commitBtn"], "CCMenuItemImage")
        commitBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn4_2.png"))
    end
end

local function _refreshLoginActivityUI()
    local showDays = tolua.cast(FestivalActivityOwner["showDays"], "CCLabelTTF")
    if theActiviityKey == Activity_conLoginOne or theActiviityKey == Activity_conLogin then
        showDays:setString(HLNSLocalizedString("连续登录：第%d天",succDay))
    elseif theActiviityKey == Activity_notConLogin or theActiviityKey == Activity_addConLogin then
        showDays:setString(HLNSLocalizedString("累计登录：第%d天",succDay))
    end
    addAward()
    _refreshBtns()
end

local function loginActivityCallBack( url,rtnData )
    -- 更新活动数据           
    -- if rtnData.info[theActiviityKey] then
    --     loginActivityData:updataActiveDataByKeyAndDic( theActiviityKey,rtnData.info[theActiviityKey] )
    -- end

    if rtnData.info.frontPage then
        loginActivityData:updataActiveDataByKeyAndDic(rtnData.info.frontPage)
    end

    -- _refreshLoginActivityUI()
    _refreshBtns()
    if getLoginActivityLayer() then
        getLoginActivityLayer():refresh()
    end
    FestivalActivityOwner["commitBtn"]:setEnabled(true)  

end

-- 点击领取
local function getItemClick()
    local allActivity = loginActivityData:getAllActivity()

    if allActivity[specialTag] == nil then
        ShowText(HLNSLocalizedString("此活动已结束"))
        return
    end

    if allActivity[specialTag].activetyName ~= theActiviityKey then
        ShowText(HLNSLocalizedString("此活动已结束"))
        return
    end

    -- local allActivity = loginActivityData:getAllActivity()
    local rewardArr = allActivity[specialTag].content.reward
    local canTake = rewardArr[tostring(findDays)].canTake
    if canTake == -1 then
        ShowText(HLNSLocalizedString("您登录的天数还不够，请继续努力！"))
        return
    elseif canTake == 1 then
        ShowText(HLNSLocalizedString("您已领取了，不能再领了！"))
        print("已经领取过了")

    else
        print("可以提交")

        if theActiviityKey == Activity_conLoginOne then 
            --限制领奖次数的登陆奖励
            doActionFun("LOGINACTIVITY_CONLOGINONE", {findDays}, loginActivityCallBack)
        elseif theActiviityKey == Activity_conLogin then
            -- 连续登陆(不限制领奖次数的登陆奖励)
            doActionFun("LOGINACTIVITY_CONLOGIN", {findDays}, loginActivityCallBack)
        elseif theActiviityKey == Activity_notConLogin then
            -- 非连续登陆奖励
            doActionFun("LOGINACTIVITY_NOTCONLOGIN", {findDays}, loginActivityCallBack)
        elseif theActiviityKey == Activity_addConLogin then
            -- 累计登陆奖励
            doActionFun("LOGINACTIVITY_ADDCONLOGIN", {findDays}, loginActivityCallBack)
        end   
        FestivalActivityOwner["commitBtn"]:setEnabled(false)   
    end
end
FestivalActivityOwner["getItemClick"] = getItemClick

local function _addTableView()

    LoginActiveCellOwner = LoginActiveCellOwner or {}
    ccb["LoginActiveCellOwner"] = LoginActiveCellOwner

    local containLayer = tolua.cast(FestivalActivityOwner["containLayer"],"CCLayer")
    local allActivity = loginActivityData:getAllActivity()

    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            local activityDes = allActivity[specialTag].content.description

            
            -- local height = getCellHeight( activityDes , 336 , 22 , "ccbResources/FZCuYuan-M03S.ttf" )

            r = CCSizeMake(613, 200)
        elseif fn == "cellAtIndex" then
            -- Return CCTableViewCell, a1 is cell index (zero based), a2 is dequeued cell (maybe nil)
            -- Do something to create cell  and change the content  
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            --单条数据
            local  proxy = CCBProxy:create()
            local  _hbCell = tolua.cast(CCBReaderLoad("ccbResources/LoginActiveCell.ccbi",proxy,true,"LoginActiveCellOwner"),"CCLayer")

            local activityTime = tolua.cast(LoginActiveCellOwner["openTime"],"CCLabelTTF")
            local description = tolua.cast(LoginActiveCellOwner["description"], "CCLabelTTF")

            description:setString(allActivity[specialTag].content.description)

            local openTime = DateUtil:formatTime(loginActivityData:getActivityOpenTime(theActiviityKey))
            local endTime = DateUtil:formatTime(loginActivityData:getActivityEndTime(theActiviityKey))

            activityTime:setString(openTime.." ~ "..endTime)

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

local function findAwardDays( )
    local daysArr = loginActivityData:getActivityReward(theActiviityKey)
    local allCount = getMyTableCount(daysArr)
    local function sortFun(a, b)
        return a < b
    end
    table.sort(daysArr, sortFun)

    for i,v in ipairs(daysArr) do
        if tonumber(daysArr[i]) == succDay then
            return succDay
        end
    end  

    for i=1,allCount - 1 do
        if succDay > tonumber(daysArr[i]) and succDay < tonumber(daysArr[i + 1]) then
            return daysArr[i + 1]
        elseif succDay < tonumber(daysArr[1]) then
            return daysArr[1]
        end
    end
    return daysArr[allCount]

end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(FestivalActivityOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        if _layer then
            _layer:removeFromParentAndCleanup(true)
        end
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
    local menu = tolua.cast(FestivalActivityOwner["menu"], "CCMenu")
    menu:setHandlerPriority(_priority - 2)
    _tableView:setTouchPriority(_priority - 1)
end
-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/FestivalActivityView.ccbi",proxy,true,"FestivalActivityOwner")
    _layer = tolua.cast(node,"CCLayer")

    
end

function createLoginActivityCellView( tag )  
    _init()
    _priority = (priority ~= nil) and priority or -138   

    local allActivity = loginActivityData:getAllActivity()
    local rewardArr = allActivity[tag].content.reward
    theActiviityKey = allActivity[tag].activetyName

    succDay = allActivity[tonumber(tag)].content.succDays
    specialTag = tag

    findDays = findAwardDays()
    PrintTable(rewardArr)
    print(tostring(findDays))
    local canTake = rewardArr[tostring(findDays)].canTake

    todayArray = allActivity[tag]

    _refreshLoginActivityUI()

    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
        _addTableView()
    end

    local function _onExit()
        _layer = nil
        _priority = -138
        _tableView = nil
        theActiviityKey = nil
        succDay = nil
        findDays = nil
        pecialTag = nil
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



