local _layer
local _type
local VIEWTYPE = {
    main = 1,   -- 主线
    daily = 2,   -- 日常
}
local QUEST = {
    "once",
    "daily",
}
local COMPOSE = {
    STAGE = "stage", -- 关卡
    SPOT = "spot",  -- 海军支部
    RECRUIT = "recruit", -- 招募
    NEWWORLD = "newworld", -- 冒险新世界
    HERO = "hero",          -- 伙伴
    CHAPTER = "chapter",    -- 冒险残章
    UNION = "union",        -- 联盟
    WW = "sea",             -- 海战
    TREASURE = "treasure",  -- 幸运卡牌
    EQUIP = "equip",        -- 装备
    PACKAGE = "package",    -- 背包
    DUEL = "duel",          -- 决斗
}
local _tableView
local _data

QuestOwner = QuestOwner or {}
ccb["QuestOwner"] = QuestOwner

local function _addTableView()

    QuestCellOwner = QuestCellOwner or {}
    ccb["QuestCellOwner"] = QuestCellOwner

    if _tableView then
        _tableView:removeFromParentAndCleanup(true)
        _tableView = nil
    end

    _data = questdata:getQuest(QUEST[_type])

    local _topLayer = QuestOwner["BSTopLayer"]

    local function rewardItemClick(tag)
        local dic = _data[tag]
        local cfg = questdata:getQuestConfig(dic.id, QUEST[_type])
        if getMyTableCount(cfg.reward) > 1 then
            -- 礼包
            local array = {}
            for k,v in pairs(cfg.reward) do
                table.insert(array, {itemId = k, count = v})
            end
            getMainLayer():getParent():addChild(createMultiItemLayer(array, -130), 100)
        else
            -- 单个
            local itemId
            local count
            for k,v in pairs(cfg.reward) do
                itemId = k
                count = v
                break
            end
            if havePrefix(itemId, "weapon_") or havePrefix(itemId, "belt_") or havePrefix(itemId, "armor_") then
                -- 装备
                if haveSuffix(itemId, "_shard") then
                    itemId = string.sub(itemId,1,-7)
                end
                getMainLayer():getParent():addChild(createEquipInfoLayer(itemId, 2, -130), 10)
            elseif havePrefix(itemId, "item") or havePrefix(itemId, "key") or havePrefix(itemId, "bag") 
                or havePrefix(itemId, "stuff") or havePrefix(itemId, "drawing") then
                -- 道具
                getMainLayer():getParent():addChild(createItemDetailInfoLayer(itemId, -130, 1, 1), 10)
            elseif havePrefix(itemId, "shadow") then
                -- 影子
                local dic = {}
                local item = shadowData:getOneShadowConf(itemId)
                dic.conf = item
                dic.id = itemId
                getMainLayer():getParent():addChild(createShadowPopupLayer(dic, nil, nil, -130, 1), 10)
            elseif havePrefix(itemId, "hero") then
                -- 魂魄
                getMainLayer():getParent():addChild(createHeroInfoLayer(itemId, HeroDetail_Clicked_Handbook, -130), 10)
            elseif havePrefix(itemId, "book") then
                -- 奥义
                getMainLayer():getParent():addChild(createHandBookSkillDetailLayer(itemId, -130), 10) 
            elseif havePrefix(itemId, "chapter_") then
                -- 残章
                local bookId = string.format("book_%s", string.split(itemId, "_")[2])
                getMainLayer():getParent():addChild(createHandBookSkillDetailLayer(bookId, -130), 10) 
            else
                -- 金币 银币
            end
        end
    end
    QuestCellOwner["rewardItemClick"] = rewardItemClick

    local function menuItemClick(tag)
        local dic = _data[tag]
        if dic.flag == 0 then
            -- 前往
            --[[
                STAGE = "stage", -- 关卡
                SPOT = "spot",  -- 海军支部
                RECRUIT = "recruit", -- 招募
                NEWWORLD = "newworld", -- 冒险新世界
                HERO = "hero",          -- 伙伴
                CHAPTER = "chapter",    -- 冒险残章
                UNION = "union",        -- 联盟
                WW = "sea",             -- 海战
                TREASURE = "treasure",  -- 幸运卡牌
                EQUIP = "equip", 
                PACKAGE = "package",    -- 背包
                DUEL = "duel",          -- 决斗
            ]]
            local cfg = questdata:getQuestConfig(dic.id, QUEST[_type])
            local comp = cfg.goto.comp
            local to = cfg.goto.to
            if comp == COMPOSE.STAGE then
                getMainLayer():goToSail()
                if to then
                    getSailLayer():selectBigStage(to)
                end
            elseif comp == COMPOSE.SPOT then
                if marineBranchData:isMarineOpen() then
                    getMainLayer():gotoAdventure()
                    getAdventureLayer():moveToPage(userdata:getMarinePage())
                    getAdventureLayer():refreshAdventureLayer()
                else
                    ShowText(HLNSLocalizedString("quest.spot.close"))
                    getMainLayer():goToSail()
                end
            elseif comp == COMPOSE.RECRUIT then
                getMainLayer():goToLogue()
            elseif comp == COMPOSE.NEWWORLD then
                getMainLayer():gotoAdventure()
                getAdventureLayer():moveToPage(0)
                getAdventureLayer():refreshAdventureLayer()
            elseif comp == COMPOSE.HERO then
                getMainLayer():goToHeroes()
            elseif comp == COMPOSE.CHAPTER then
                getMainLayer():gotoAdventure()
                getAdventureLayer():moveToPage(userdata:getSkillChapterIndex())
                getAdventureLayer():refreshAdventureLayer()
            elseif comp == COMPOSE.UNION then
                getMainLayer():gotoUnion()
            elseif comp == COMPOSE.WW then
                getMainLayer():gotoWorldWar()
            elseif comp == COMPOSE.TREASURE then
                getMainLayer():gotoDaily()
                local page = dailyData:getDailyPage(Daily_Treasure)
                getDailyLayer():gotoPage(page)
            elseif comp == COMPOSE.EQUIP then
                getMainLayer():gotoEquipmentsLayer()
            elseif comp == COMPOSE.PACKAGE then
                getMainLayer():gotoWareHouseLayer()
            elseif comp == COMPOSE.DUEL then
                getMainLayer():gotoArena()
            end
        else
            -- 领奖
            local function callback(url, rtnData)
                getQuestLayer():refresh()
            end
            doActionFun("QUEST_REWARD", {_type, dic.id}, callback)
        end
    end
    QuestCellOwner["menuItemClick"] = menuItemClick

    -- @param fn string Callback type
    -- @param table LuaTableView
    -- @param a1 & a2 mixed Difference means for every "fn"
    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(winSize.width, 155 * retina)
        elseif fn == "cellAtIndex" then
            -- Return CCTableViewCell, a1 is cell index (zero based), a2 is dequeued cell (maybe nil)
            -- Do something to create cell  and change the content
            
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end

            local  proxy = CCBProxy:create()
            local  _hbCell
            _hbCell  = tolua.cast(CCBReaderLoad("ccbResources/QuestCell.ccbi",proxy,true,"QuestCellOwner"),"CCLayer")

            local dic = _data[a1 + 1]
            local cfg = questdata:getQuestConfig(dic.id, QUEST[_type])

            local rewardText = tolua.cast(QuestCellOwner["rewardText"], "CCSprite")
            local gotoText = tolua.cast(QuestCellOwner["gotoText"], "CCSprite")
            rewardText:setVisible(dic.flag == 1)
            gotoText:setVisible(dic.flag == 0)

            local title = tolua.cast(QuestCellOwner["title"], "CCLabelTTF")
            title:setString(string.format("%s(%d/%d)", cfg.name, dic.progress, cfg.progress["end"]))

            local desp = tolua.cast(QuestCellOwner["desp"], "CCLabelTTF")
            desp:setString(dic.desp)

            local rewardItem = tolua.cast(QuestCellOwner["rewardItem"], "CCMenuItem")
            local menuItem = tolua.cast(QuestCellOwner["menuItem"], "CCMenuItem")
            rewardItem:setTag(a1 + 1)
            menuItem:setTag(a1 + 1)

            local contentLayer = tolua.cast(QuestCellOwner["contentLayer"],"CCLayer")
            local bigSprite = tolua.cast(QuestCellOwner["bigSprite"],"CCSprite")
            local chipIcon = tolua.cast(QuestCellOwner["chipIcon"],"CCSprite")
            local littleSprite = tolua.cast(QuestCellOwner["littleSprite"],"CCSprite")
            local soulIcon = tolua.cast(QuestCellOwner["soulIcon"],"CCSprite")
            local countBg = tolua.cast(QuestCellOwner["countBg"],"CCLabelTTF")
            local countLabel = tolua.cast(QuestCellOwner["countLabel"],"CCLabelTTF")

            if getMyTableCount(cfg.reward) > 1 then
                -- 显示礼包
                local texture = CCTextureCache:sharedTextureCache():addImage("ccbResources/icons/vip_001.png")
                if texture then
                    bigSprite:setVisible(true)
                    bigSprite:setTexture(texture)
                end
                rewardItem:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("frame_4.png"))
                rewardItem:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("frame_4.png"))
            else
                -- 显示单个道具
                local itemId
                local count
                for k,v in pairs(cfg.reward) do
                    itemId = k
                    count = v
                    break
                end
                local resDic = userdata:getExchangeResource(itemId)

                if havePrefix(itemId, "shadow") then
                    -- 影子
                    rewardItem:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("s_frame.png"))
                    rewardItem:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("s_frame.png"))

                    rewardItem:setPosition(ccp(rewardItem:getPositionX() + 5,rewardItem:getPositionY() - 5))
                    if resDic.icon then
                        playCustomFrameAnimation(string.format("yingzi_%s_", resDic.icon), contentLayer, ccp(contentLayer:getContentSize().width / 2, 
                            contentLayer:getContentSize().height / 2), 1, 4, shadowData:getColorByColorRank(resDic.rank))
                    end
                elseif havePrefix(itemId, "hero") then
                    -- 魂魄
                    littleSprite:setVisible(true)
                    soulIcon:setVisible(true)
                    littleSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(resDic.icon))
                else
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
                end
                if not havePrefix(itemId, "shadow") then
                    rewardItem:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", resDic.rank)))
                    rewardItem:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", resDic.rank)))
                end
                countBg:setVisible(true)
                countLabel:setString(count)
            end

            _hbCell:setScale(retina)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            a2:addChild(_hbCell, 0, 1)
            r = a2
        elseif fn == "numberOfCells" then
            -- Return number of cells
            r = #_data
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

    local _mainLayer = getMainLayer()
    if _mainLayer then
        local size = CCSizeMake(winSize.width, (winSize.height - _topLayer:getContentSize().height - _mainLayer:getBottomContentSize().height - 10 * retina))
        _tableView = LuaTableView:createWithHandler(h, size)
        _tableView:setBounceable(true)
        _tableView:setAnchorPoint(ccp(0,0))
        _tableView:setPosition(ccp(0, _mainLayer:getBottomContentSize().height))
        _tableView:setVerticalFillOrder(0)
        _layer:addChild(_tableView) 
    end
end

local function _changeTab()
    for i=1,2 do
        local item = tolua.cast(QuestOwner["tabBtn"..i], "CCMenuItemImage")
        if i == _type then
            item:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_1.png"))
        else
            item:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_0.png"))
        end
    end
end

-- 刷新页面
local function _refreshLayer()
    _changeTab()
    _addTableView()
    local main, daily = questdata:getQuestComplete()
    if main > 0 then
        local countBg = tolua.cast(QuestOwner["countBg1"], "CCSprite")
        countBg:setVisible(true)
        local countLabel = tolua.cast(QuestOwner["countLabel1"], "CCLabelTTF")
        countLabel:setString(main)
    else
        local countBg = tolua.cast(QuestOwner["countBg1"], "CCSprite")
        countBg:setVisible(false)
    end
    if daily > 0 then
        local countBg = tolua.cast(QuestOwner["countBg2"], "CCSprite")
        countBg:setVisible(true)
        local countLabel = tolua.cast(QuestOwner["countLabel2"], "CCLabelTTF")
        countLabel:setString(daily)
    else
        local countBg = tolua.cast(QuestOwner["countBg2"], "CCSprite")
        countBg:setVisible(false)
    end
end

local function questItemClick(tag)
    if tag == _type then
        return
    end
    _type = tag
    _refreshLayer()
end
QuestOwner["questItemClick"] = questItemClick

local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/QuestLayer.ccbi", proxy, true, "QuestOwner")
    _layer = tolua.cast(node, "CCLayer")
end

function getQuestLayer()
    return _layer
end

function createQuestLayer(type)
    _type = type or VIEWTYPE.main
    _init()

    local function _onEnter()
        addObserver(NOTI_QUEST, _refreshLayer)
        _refreshLayer()
    end

    local function _onExit()
        removeObserver(NOTI_QUEST, _refreshLayer)
        _layer = nil
        _tableView = nil
        _data = nil
    end

    function _layer:refresh()
        _refreshLayer()
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