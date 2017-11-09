local _layer
local _priority = -132
local _tableView
local _data

--活动主界面 竞技场争霸赛活动
-- 名字不要重复
ActivityOfArenaCompetitionOwner = ActivityOfArenaCompetitionOwner or {}
ccb["ActivityOfArenaCompetitionOwner"] = ActivityOfArenaCompetitionOwner

--关闭按钮的回调
local function closeItemClick()
    popUpCloseAction(ActivityOfArenaCompetitionOwner, "infoBg", _layer )
end
ActivityOfArenaCompetitionOwner["closeItemClick"] = closeItemClick

--设置触摸优先级
local menu2 = tolua.cast(ActivityOfArenaCompetitionOwner["menu2"], "CCMenu")
    if menu2 then
        --设置菜单优先级，确保点击tabelview以及menu的时候正常滑动
        menu2:setTouchPriority(_priority - 1)
end

--去决斗按钮
local function onFightClicked()
    --跳转进入去决斗界面
    getMainLayer():gotoArena()
    popUpCloseAction(ActivityOfArenaCompetitionOwner, "infoBg", _layer )
end
ActivityOfArenaCompetitionOwner["onFightClicked"] = onFightClicked

--帮助按钮
local function onHelpClicked()
    --弹出帮助界面
    local description = {
        HLNSLocalizedString("activity.arena.help.1"),
        HLNSLocalizedString("activity.arena.help.2"),
        HLNSLocalizedString("activity.arena.help.3"),
        HLNSLocalizedString("activity.arena.help.4"),
        HLNSLocalizedString("activity.arena.help.5")
    }
    local contentLayer = MainSceneOwner["contentLayer"]
    getMainLayer():getParent():addChild(createCommonHelpLayer(description, _priority - 3))
end
ActivityOfArenaCompetitionOwner["onHelpClicked"] = onHelpClicked

local function _addTableView()

    -- 得到数据
    _data = loginActivityData:getActivityOfArenaCompetitionData()
    local content = ActivityOfArenaCompetitionOwner["content"]
    ActivityOfArenaCompetitionCellOwner = ActivityOfArenaCompetitionCellOwner or {}
    ccb["ActivityOfArenaCompetitionCellOwner"] = ActivityOfArenaCompetitionCellOwner
    local function onGetItemClicked(tag)
        local function callback(url, rtnData)
             --领奖按钮消失，提示可领奖tips label
            loginActivityData.activitys[Activity_Arena] = rtnData.info.frontPage[Activity_Arena]
            _data = loginActivityData:getActivityOfArenaCompetitionData()
            _tableView:reloadData()
        end
        local dic = _data[tag]
        if userdata.loginTime < dic.activityEndDay  then
            ShowText(HLNSLocalizedString("activityArena.TimeOut"))
            return
        end
        if userdata.loginTime > dic.rewardEndDay then -- 不能领取
            --提示领奖结束
            ShowText(HLNSLocalizedString("activityArena.TimeEnd"))
        end
        --向服务器发送成功领取消息  uid 以及 id
        doActionFun("ACTIVITY_ARENACOMPETITION", {dic.uid, dic.key}, callback)    
    end
    ActivityOfArenaCompetitionCellOwner["onGetItemClicked"] = onGetItemClicked

    local function onItemClicked(tag)
        --显示当前装备的信息
         --获取装备id
        local dic = _data[math.floor(tag / 10000) + 1]
        local index = tag % 10000
        itemId = dic.items[index]["itemId"]
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
    ActivityOfArenaCompetitionCellOwner["onItemClicked"] = onItemClicked

    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(583, 150)
        elseif fn == "cellAtIndex" then
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            --单条数据
            local  proxy = CCBProxy:create()
            
            local  _hbCell  = tolua.cast(CCBReaderLoad("ccbResources/ActivityOfArenaCompetitionCell.ccbi",proxy,true,"ActivityOfArenaCompetitionCellOwner"),"CCLayer")
           
            local menu = tolua.cast(ActivityOfArenaCompetitionCellOwner["menu"], "CCMenu")
            if menu then
                --设置菜单优先级，确保点击tabelview以及menu的时候正常滑动
                menu:setTouchPriority(_priority - 1)
            end
            local dic = _data[a1 + 1]
            -- --领奖button
            local getItemBtn = tolua.cast(ActivityOfArenaCompetitionCellOwner["getItemBtn"], "CCMenuItemImage")
            getItemBtn:setTag(a1 + 1)
            --领奖label
            local getItemText = tolua.cast(ActivityOfArenaCompetitionCellOwner["getItemText"], "CCLabelTTF")
            --领奖tips小提示（逻辑为 当前玩家已经领取，显示tips 这个label，为已领取）
            local tips = tolua.cast(ActivityOfArenaCompetitionCellOwner["tips"], "CCLabelTTF")
            getItemBtn:setVisible(false)
            getItemText:setVisible(false)
            tips:setVisible(false)
            --您的当前排名 ranking label
            local pRank = (dic.ranking and dic.ranking ~= "") and dic.ranking or -1
            local ranking = tolua.cast(ActivityOfArenaCompetitionOwner["rank"], "CCLabelTTF")
            if pRank == -1 then
                ranking:setString(HLNSLocalizedString("activity.arena.no.ranking"))
            else
                ranking:setString(pRank)
            end
            
             --显示领奖排名
            local rank = tolua.cast(ActivityOfArenaCompetitionCellOwner["ranking"],"CCLabelTTF")
            local rankfrom = dic.rank.from
            local rankTo = dic.rank.to
            if rankfrom == rankTo then
                rank:setString(rankfrom)
            else
                rank:setString(rankfrom.."-"..rankTo)
            end
            --活动截止日期
            --奖品领取截止实现
            if userdata.loginTime < dic.activityEndDay and userdata.loginTime > dic.activityOpenDay then  -- 活动期间内
                --endTime  endTimer  rewardEndtime rewardTimer
                --活动截止日期以及相对应的展示日期
                local endTime = tolua.cast(ActivityOfArenaCompetitionOwner["endTime"], "CCLabelTTF")
                local endTimer = tolua.cast(ActivityOfArenaCompetitionOwner["endTimer"], "CCLabelTTF")
                endTime:setVisible(true)
                endTimer:setVisible(true)
                endTimer:setString(DateUtil:formatDateTime(dic.activityEndDay))  
                --领奖按钮变灰
                --只需把按钮中的buttonviewimage
                getItemBtn:setVisible(true)
                getItemText:setVisible(true)
                getItemBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn7_2.png"))
                getItemBtn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn7_2.png"))
            else
                --活动截止 判断是否在奖品领取时间内
                if userdata.loginTime < dic.rewardEndDay then  --可以领取
                    --判断当前决斗排名的玩家是否达到指定的排名段
                    if tonumber(pRank) >= tonumber(dic.rank.from) and tonumber(pRank) <= tonumber(dic.rank.to) then --在区间内
                        getItemBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn7_0.png"))
                        getItemBtn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn7_1.png"))
                        getItemBtn:setVisible(not dic.reward)
                        getItemText:setVisible(not dic.reward)
                        tips:setVisible(dic.reward)
                    end
                  
                end
                --奖品领取截止时间以及相对应的展示时间
                local rewardEndtime = tolua.cast(ActivityOfArenaCompetitionOwner["rewardEndtime"], "CCLabelTTF")
                local rewardTimer = tolua.cast(ActivityOfArenaCompetitionOwner["rewardTimer"], "CCLabelTTF")   
                local endTime = tolua.cast(ActivityOfArenaCompetitionOwner["endTime"], "CCLabelTTF")
                local endTimer = tolua.cast(ActivityOfArenaCompetitionOwner["endTimer"], "CCLabelTTF")
                endTime:setVisible(false)
                endTimer:setVisible(false) 
                rewardEndtime:setVisible(true)
                rewardTimer:setVisible(true)
                rewardTimer:setString(DateUtil:formatDateTime(dic.rewardEndDay))
            end
           
            for i=1,2 do
                local item = dic.items[i]
                if item then
                    local itemId = item.itemId
                    local resDic = userdata:getExchangeResource(itemId)
                    local rankBtn = tolua.cast(ActivityOfArenaCompetitionCellOwner["rankBtn"..i],"CCMenuItemImage")
                    local contentLayer = tolua.cast(ActivityOfArenaCompetitionCellOwner["contentLayer"..i],"CCLayer")
                    --根据是否存在奖励物品，显示相应的物品
                    rankBtn:setVisible(true)
                    rankBtn:setTag(a1 * 10000 + i)
                    contentLayer:setVisible(true)

                    local bigSprite = tolua.cast(ActivityOfArenaCompetitionCellOwner["bigSprite"..i],"CCSprite")
                    local littleSprite = tolua.cast(ActivityOfArenaCompetitionCellOwner["littleSprite"..i],"CCSprite")
                    local soulIcon = tolua.cast(ActivityOfArenaCompetitionCellOwner["soulIcon"..i],"CCSprite")
                    local chip_icon = tolua.cast(ActivityOfArenaCompetitionCellOwner["chip_icon"..i],"CCSprite")
                    local countLabel = tolua.cast(ActivityOfArenaCompetitionCellOwner["countLabel"..i],"CCLabelTTF")
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
                            HLAddParticleScale( "images/purpleEquip.plist", bigSprite, ccp(bigSprite:getContentSize().width / 2,bigSprite:getContentSize().height / 2), 1, 100, 777, 2 / 0.35 / retina, 2 / 0.35 / retina, 1 )
                        end
                    end 
                end
                if not havePrefix(itemId, "shadow") then
                    rankBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", resDic.rank)))
                    rankBtn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", resDic.rank)))
                end
                -- 设置数量
                countLabel:setString(item.amount)
            end
        end
            
           
            --按钮点击事件回调
            --领取按钮

            a2:addChild(_hbCell, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            r = a2
        elseif fn == "numberOfCells" then
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
    _tableView:setTouchPriority(_priority - 2)
    _tableView:setBounceable(true)
    _tableView:setAnchorPoint(ccp(0,0))
    _tableView:setPosition(0,0)
    _tableView:setVerticalFillOrder(0)
    content:addChild(_tableView,1000)
end

local function _refreshData()
    _addTableView()
    local title0 = tolua.cast(ActivityOfArenaCompetitionOwner["title0"], "CCLabelTTF")
    local title1 = tolua.cast(ActivityOfArenaCompetitionOwner["title1"], "CCLabelTTF")
    title0:setString(loginActivityData.activitys[Activity_Arena].name)
    title1:setString(loginActivityData.activitys[Activity_Arena].name)
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/ActivityOfArenaCompetition.ccbi", proxy, true,"ActivityOfArenaCompetitionOwner")
    _layer = tolua.cast(node,"CCLayer")

    local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
    cache:addSpriteFramesWithFile("ccbResources/shadow.plist")
    _refreshData()
end



local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(ActivityOfArenaCompetitionOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction(ActivityOfArenaCompetitionOwner, "infoBg", _layer)
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
    local menu = tolua.cast(ActivityOfArenaCompetitionOwner["menu"], "CCMenu")
    menu:setTouchPriority(_priority - 2)
    --_tableView:setTouchPriority(_priority - 2)
end

function getActivityOfArenaCompetitionOwnerLayer()
    return _layer
end

function createActivityOfArenaCompetitionLayer(priority)
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
        popUpUiAction(ActivityOfArenaCompetitionOwner, "infoBg")
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