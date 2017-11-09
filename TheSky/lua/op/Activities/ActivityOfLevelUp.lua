local _layer
local _priority = -132
local _tableView
local _data

--活动主界面 开服冲级王
-- 名字不要重复
ActivityOfLevelOwner = ActivityOfLevelOwner or {}
ccb["ActivityOfLevelOwner"] = ActivityOfLevelOwner

local function closeItemClick()
    popUpCloseAction(ActivityOfLevelOwner, "infoBg", _layer )
end
ActivityOfLevelOwner["closeItemClick"] = closeItemClick

local function _addTableView()

    -- 得到数据
    _data = loginActivityData:getActivityOfLevelUpData()

    local content = ActivityOfLevelOwner["content"]

    ActivityOfLevelCellOwner = ActivityOfLevelCellOwner or {}
    ccb["ActivityOfLevelCellOwner"] = ActivityOfLevelCellOwner
    --按钮点击事件回调
    --领取按钮
    local function onGetItemClicked(tag)

        local function callback(url, rtnData)
             --领奖按钮消失，提示可领奖tips label
            loginActivityData.activitys[Activity_LevelUp] = rtnData.info.frontPage[Activity_LevelUp]
            _data = loginActivityData:getActivityOfLevelUpData()
            _tableView:reloadData()
        end
        local dic = _data[tag]
        if userdata.level < dic.level then
            ShowText(HLNSLocalizedString("activitylevel.notenough"))
            return
        end
        --向服务器发送成功领取消息  uid 以及 id
        doActionFun("ACTIVITY_GIFTFORLEVEL", {dic.uid, dic.key}, callback)
        
    end
    ActivityOfLevelCellOwner["onGetItemClicked"] = onGetItemClicked

    local function onItemClicked(tag)
        --显示当前装备的信息
         --获取装备id
        local dic = _data[math.floor(tag / 10000) + 1]
        local index = tag % 10000
        itemId = dic.reward[index]["itemId"]
        if havePrefix(itemId, "weapon_") or havePrefix(itemId, "belt_") or havePrefix(itemId, "armor_") then
        -- 装备
            if haveSuffix(itemId, "_shard") then
                itemId = string.sub(itemId, 1, -7)
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
    ActivityOfLevelCellOwner["onItemClicked"] = onItemClicked

    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(583, 175)
        elseif fn == "cellAtIndex" then
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            --单条数据
            local  proxy = CCBProxy:create()
            
            local  _hbCell  = tolua.cast(CCBReaderLoad("ccbResources/ActivityOfLevelCell.ccbi",proxy,true,"ActivityOfLevelCellOwner"),"CCLayer")
           

            local menu = tolua.cast(ActivityOfLevelCellOwner["menu"], "CCMenu")
            if menu then
                --设置菜单优先级，确保点击tabelview以及menu的时候正常滑动
                menu:setTouchPriority(_priority - 1)
            end
            
            local dic = _data[a1 + 1]
            --领奖button
            local getItemBtn = tolua.cast(ActivityOfLevelCellOwner["getItemBtn"], "CCMenuItemImage")
            getItemBtn:setTag(a1 + 1)
            --领奖label
            local getItemText = tolua.cast(ActivityOfLevelCellOwner["getItemText"], "CCLabelTTF")
            --领奖tips小提示（逻辑为 当前玩家已经领取，显示tips 这个label，为已领取）
            local tips = tolua.cast(ActivityOfLevelCellOwner["tips"], "CCLabelTTF")
            getItemBtn:setVisible(not dic.isGet)
            getItemText:setVisible(not dic.isGet)
            tips:setVisible(dic.isGet)
           
            if userdata.level < dic.level then
               --领奖按钮变灰
               --只需把按钮中的buttonviewimage
                getItemBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn7_2.png"))
                getItemBtn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn7_2.png"))
                   
            end

            for i=1,4 do
                local reward = dic.reward[i]
                if reward then
                    local itemId = reward.itemId
                    local resDic = userdata:getExchangeResource(itemId)

                    local rankBtn = tolua.cast(ActivityOfLevelCellOwner["rankBtn"..i],"CCMenuItemImage")
                    local contentLayer = tolua.cast(ActivityOfLevelCellOwner["contentLayer"..i],"CCLayer")
                    --根据是否存在奖励物品，显示相应的物品
                    rankBtn:setVisible(true)
                    rankBtn:setTag(a1 * 10000 + i)
                    contentLayer:setVisible(true)

                    local bigSprite = tolua.cast(ActivityOfLevelCellOwner["bigSprite"..i],"CCSprite")
                    local littleSprite = tolua.cast(ActivityOfLevelCellOwner["littleSprite"..i],"CCSprite")
                    local soulIcon = tolua.cast(ActivityOfLevelCellOwner["soulIcon"..i],"CCSprite")
                    local chip_icon = tolua.cast(ActivityOfLevelCellOwner["chip_icon"..i],"CCSprite")
                    local countLabel = tolua.cast(ActivityOfLevelCellOwner["countLabel"..i],"CCLabelTTF")
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
                        rankBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("s_frame.png"))
                        rankBtn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("s_frame.png"))

                        rankBtn:setPosition(ccp(rankBtn:getPositionX() + 5,rankBtn:getPositionY() - 5))
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
                            if resDic.rank == 4 then
                                HLAddParticleScale( "images/purpleEquip.plist", bigSprite, ccp(bigSprite:getContentSize().width / 2,bigSprite:getContentSize().height / 2), 
                                    1, 100, 777, 2 / 0.35 / retina, 2 / 0.35 / retina, 1 )
                            end
                        end 
                    end
                    if not havePrefix(itemId, "shadow") then
                        rankBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", resDic.rank)))
                        rankBtn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", resDic.rank)))
                    end
                    -- 设置数量
                    countLabel:setString(reward.count)
                end
            end

            --动态显示玩家等级
            local ActivityLevel = tolua.cast(ActivityOfLevelCellOwner["ActivityLevel"], "CCLabelTTF")
            ActivityLevel:setString(dic.level)

            
            a2:addChild(_hbCell, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            r = a2
        elseif fn == "numberOfCells" then
            -- r = #_data
            --tabelview中cell的行数
            r = #_data
        elseif fn == "cellTouched" then         -- A cell was touched, a1 is cell that be touched. This is not necessary.
        elseif fn == "cellTouchBegan" then      -- A cell is touching, a1 is cell, a2 is CCTouch
        elseif fn == "cellTouchEnded" then      -- A cell was touched, a1 is cell, a2 is CCTouch
        elseif fn == "cellHighlight" then       -- A cell is highlighting, coco2d-x 2.1.3 or above
        elseif fn == "cellUnhighlight" then     -- A cell had been unhighlighted, coco2d-x 2.1.3 or above
        elseif fn == "cellWillRecycle" then     -- A cell will be recycled, coco2d-x 2.1.3 or above
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

local function _refreshData()
    _addTableView()
end

--刷新时间显示函数
local function refreshTimeLabel()
    local timerLabel = tolua.cast(ActivityOfLevelOwner["timerLabel"], "CCLabelTTF")
    local timer = loginActivityData:getActivityOfLevelUpTimer()
    if timer == 0 then
        closeItemClick()
        getLoginActivityLayer():closeView()
    end
    local day, hour, min, sec = DateUtil:secondGetdhms(timer)
    if day > 0 then
        timerLabel:setString(HLNSLocalizedString("timer.tips.1", day, hour, min, sec))
    elseif hour > 0 then
        timerLabel:setString(HLNSLocalizedString("timer.tips.2", hour, min, sec))
    else
        timerLabel:setString(HLNSLocalizedString("timer.tips.3", min, sec))
    end
end

--刷新显示任务描述函数
local function refreshDescriptionLabel()
    local activityDescription = tolua.cast(ActivityOfLevelOwner["activityDescription"], "CCLabelTTF")
    local dic = loginActivityData.activitys[Activity_LevelUp]
    --活的开服冲级王的活动描述
    local description = dic.description["0"]
    activityDescription:setString(description)

    for i=0,1 do
        local title = tolua.cast(ActivityOfLevelOwner["title"..i], "CCLabelTTF")
        title:setString(dic.name)
    end
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/ActivityOfLevel.ccbi", proxy, true,"ActivityOfLevelOwner")
    _layer = tolua.cast(node,"CCLayer")

    local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
    cache:addSpriteFramesWithFile("ccbResources/shadow.plist")
    -- 显示活动时间函数timerLabel
    refreshTimeLabel()
    --显示活动描述
    refreshDescriptionLabel()
    _refreshData()
end



local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(ActivityOfLevelOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction(ActivityOfLevelOwner, "infoBg", _layer)
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
    local menu = tolua.cast(ActivityOfLevelOwner["menu"], "CCMenu")
    menu:setTouchPriority(_priority - 2)
    _tableView:setTouchPriority(_priority - 2)
end

function getActivityOfLevelLayer()
    return _layer
end

function createActivityOfLevelLayer(priority)
    _priority = (priority ~= nil) and priority or -132
    _init()

    function _layer:refreshData()
        _data = loginActivityData:getQuizData() 
        _tableView:reloadData()
    end


    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)

        addObserver(NOTI_TICK, refreshTimeLabel)
        popUpUiAction(ActivityOfLevelOwner, "infoBg")
    end

    local function _onExit()
        removeObserver(NOTI_TICK, refreshTimeLabel)
        _layer = nil
        _tableView = nil
        _priority = nil
        _data = nil
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