local _layer
local _priority = -132
local _tableView
local _array
local _data

--活动主界面 拼图游戏
-- 名字不要重复
ActivityOfJigsawViewOwner = ActivityOfJigsawViewOwner or {}
ccb["ActivityOfJigsawViewOwner"] = ActivityOfJigsawViewOwner

local function closeItemClick()
    popUpCloseAction(ActivityOfJigsawViewOwner, "infoBg", _layer )
end
ActivityOfJigsawViewOwner["closeItemClick"] = closeItemClick

--详情
local function descBtnTaped()
    -- popUpCloseAction(ActivityOfJigsawViewOwner, "infoBg", _layer )
    --弹出帮助界面
    local desc = loginActivityData.activitys[Activity_JigsawPuzzle].description
    local  function getMyDescription()
        -- body
        local temp = {}
            for k,v in pairs(desc) do
                table.insert(temp, v)
            end
            return temp
        end
    description = getMyDescription()
    local contentLayer = MainSceneOwner["contentLayer"]
    getMainLayer():getParent():addChild(createCommonHelpLayer(description, _priority - 3))
end
ActivityOfJigsawViewOwner["descBtnTaped"] = descBtnTaped

--进入
local function confirmBtnTaped()
    popUpCloseAction(ActivityOfJigsawViewOwner, "infoBg", _layer )
    if getMainLayer() then
        getMainLayer():addChild(createActivityOfJigsawStartLayer(_priority - 2), 300) --拼图游戏
    end
end
ActivityOfJigsawViewOwner["confirmBtnTaped"] = confirmBtnTaped



local function _addTableView()
    local MyData = loginActivityData.activitys[Activity_JigsawPuzzle]
    _array = MyData.reward
    local function getMyData()
        -- body
        local temp = {}
        for k,v in pairs(_array) do
            table.insert(temp, {itemId = v.itemId, amount = v.amount})
        end
        return temp
    end
    _data = getMyData()
    local containLayer = ActivityOfJigsawViewOwner["containLayer"]
    ActivityOfJigsawCellOwner = ActivityOfJigsawCellOwner or {}
    ccb["ActivityOfJigsawCellOwner"] = ActivityOfJigsawCellOwner

    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(120, 120)
        elseif fn == "cellAtIndex" then
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            --单条数据
            local  proxy = CCBProxy:create()
            local  _hbCell  = tolua.cast(CCBReaderLoad("ccbResources/ActivityOfJigsawCell.ccbi",proxy,true,"ActivityOfJigsawCellOwner"),"CCLayer")
            local  reward = _data[a1 + 1]
            if reward then
                local itemId = reward.itemId
                local amount = reward.amount
                local resDic = userdata:getExchangeResource(itemId)

                local contentLayer = tolua.cast(ActivityOfJigsawCellOwner["contentLayer"],"CCLayer")
                
            

                local bigSprite = tolua.cast(ActivityOfJigsawCellOwner["bigSprite"],"CCSprite")
                local littleSprite = tolua.cast(ActivityOfJigsawCellOwner["littleSprite"],"CCSprite")
                local soulIcon = tolua.cast(ActivityOfJigsawCellOwner["soulIcon"],"CCSprite")
                local chip_icon = tolua.cast(ActivityOfJigsawCellOwner["chip_icon"],"CCSprite")
                local rankFrame = tolua.cast(ActivityOfJigsawCellOwner["rankFrame"],"CCSprite")
                
                local countLabel = tolua.cast(ActivityOfJigsawCellOwner["countLabel"],"CCLabelTTF")
                chip_icon:setVisible(false)
                 -- 设置数量
                countLabel:setString(reward.amount)
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
            end
           
            
            a2:addChild(_hbCell, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            r = a2
        elseif fn == "numberOfCells" then
            r = #_data
            --tabelview中cell的行数
            -- r = #_data
        elseif fn == "cellTouched" then         -- A cell was touched, a1 is cell that be touched. This is not necessary.
        elseif fn == "cellTouchBegan" then      -- A cell is touching, a1 is cell, a2 is CCTouch
        elseif fn == "cellTouchEnded" then      -- A cell was touched, a1 is cell, a2 is CCTouch
        elseif fn == "cellHighlight" then       -- A cell is highlighting, coco2d-x 2.1.3 or above
        elseif fn == "cellUnhighlight" then     -- A cell had been unhighlighted, coco2d-x 2.1.3 or above
        elseif fn == "cellWillRecycle" then     -- A cell will be recycled, coco2d-x 2.1.3 or above
        end
        return r
    end)
    local size = containLayer:getContentSize()
    _tableView = LuaTableView:createWithHandler(h, size)
    _tableView:setBounceable(true)
    _tableView:setAnchorPoint(ccp(0,0))
    _tableView:setPosition(0,0)
    _tableView:setDirection(0) --横向tableview
    _tableView:setVerticalFillOrder(0)
    containLayer:addChild(_tableView,1000)
end

local function _refreshData()
    _addTableView()
end

--刷新时间显示函数
local function refreshTimeLabel()
    local timerLabel = tolua.cast(ActivityOfJigsawViewOwner["timerLabel"], "CCLabelTTF")
    local timer = loginActivityData:getActivityOfJigsawPuzzleTimer()
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

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/ActivityOfJigsawView.ccbi", proxy, true,"ActivityOfJigsawViewOwner")
    _layer = tolua.cast(node,"CCLayer")

    local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
    cache:addSpriteFramesWithFile("ccbResources/shadow.plist")
    -- 显示活动时间函数timerLabel
    refreshTimeLabel()
    _refreshData()
end



local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(ActivityOfJigsawViewOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction(ActivityOfJigsawViewOwner, "infoBg", _layer)
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
    local menu = tolua.cast(ActivityOfJigsawViewOwner["menu"], "CCMenu")
    menu:setTouchPriority(_priority - 2)
    _tableView:setTouchPriority(_priority - 2)
end

function getActivityOfJigsawLayer()
    return _layer
end

function createActivityOfJigsawLayer(priority)
    _priority = (priority ~= nil) and priority or -132
    _init()

    -- function _layer:refreshData()
    --     _data = loginActivityData:getQuizData() 
    --     _tableView:reloadData()
    -- end

    function _layer:refresh()
        refresh() 
    end
    
    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)

        addObserver(NOTI_TICK, refreshTimeLabel)
        popUpUiAction(ActivityOfJigsawViewOwner, "infoBg")
    end

    local function _onExit()
        removeObserver(NOTI_TICK, refreshTimeLabel)
        _layer = nil
        _tableView = nil
        _priority = nil
        _data = nil
        _array = nil
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