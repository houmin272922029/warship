local _layer
local _data = nil
local _tableView
local _bTableViewTouch

LuckyRankViewOwner = LuckyRankViewOwner or {}
ccb["LuckyRankViewOwner"] = LuckyRankViewOwner

local function refreshTime()
    local cdTime = tolua.cast(LuckyRankViewOwner["cdTime"], "CCLabelTTF")
    local cd = dailyData:getLuckyRankTime()
    local day, hour, min, sec = DateUtil:secondGetdhms(cd)
    if day > 0 then
        cdTime:setString(HLNSLocalizedString("timer.tips.1", day, hour, min, sec))
    elseif hour > 0 then
        cdTime:setString(HLNSLocalizedString("timer.tips.2", hour, min, sec))
    else
        cdTime:setString(HLNSLocalizedString("timer.tips.3", min, sec))
    end

    local title1 = tolua.cast(LuckyRankViewOwner["title1"], "CCLabelTTF")
    local title2 = tolua.cast(LuckyRankViewOwner["title2"], "CCLabelTTF")
    local state1 = tolua.cast(LuckyRankViewOwner["state1"], "CCSprite")
    local state2 = tolua.cast(LuckyRankViewOwner["state2"], "CCSprite")
    local rankItem = tolua.cast(LuckyRankViewOwner["rankItem"], "CCMenuItem")
    if dailyData:getLuckyRankState() == 1 then
        title1:setVisible(true)
        title2:setVisible(false)
        state1:setVisible(true)
        state2:setVisible(false)
        rankItem:setVisible(true)
    else
        title1:setVisible(false)
        title2:setVisible(true)
        state1:setVisible(false)
        state2:setVisible(_data.rewardFlag)
        local rankItem = tolua.cast(LuckyRankViewOwner["rankItem"], "CCMenuItem")
        rankItem:setVisible(_data.rewardFlag)
    end
end

local function _addTableView()
    -- 得到数据
    local content = LuckyRankViewOwner["content"]

    LuckyRankCellOwner = LuckyRankCellOwner or {}
    ccb["LuckyRankCellOwner"] = LuckyRankCellOwner

    local function rewardItemClick(tag)

        local dic = _data.ranks[tostring(math.floor(tag / 100))].reward[tostring(tag % 100 - 1)]
        local itemId = dic.itemId

        if havePrefix(itemId, "weapon_") or havePrefix(itemId, "belt_") or havePrefix(itemId, "armor_") then
            -- 装备
            if haveSuffix(itemId, "_shard") then
                itemId = string.sub(itemId,1,-7)
            end
            getMainLayer():getParent():addChild(createEquipInfoLayer(itemId, 2, -141), 10)
        elseif havePrefix(itemId, "item") or havePrefix(itemId, "key") or havePrefix(itemId, "bag") 
            or havePrefix(itemId, "stuff") or havePrefix(itemId, "drawing") then
            -- 道具
            getMainLayer():getParent():addChild(createItemDetailInfoLayer(itemId, -141, 1, 1), 10)
        elseif havePrefix(itemId, "shadow") then
            -- 影子
            local dic = {}
            local item = shadowData:getOneShadowConf(itemId)
            dic.conf = item
            dic.id = itemId
            getMainLayer():getParent():addChild(createShadowPopupLayer(dic, nil, nil, -141, 1), 10)
        elseif havePrefix(itemId, "hero") then
            -- 魂魄
            getMainLayer():getParent():addChild(createHeroInfoLayer(itemId, HeroDetail_Clicked_Handbook, -140), 10)
        elseif havePrefix(itemId, "book") then
            -- 奥义
            getMainLayer():getParent():addChild(createHandBookSkillDetailLayer(itemId, -141), 10) 
        elseif havePrefix(itemId, "chapter_") then
            -- 残章
            local bookId = string.format("book_%s", string.split(itemId, "_")[2])
            getMainLayer():getParent():addChild(createHandBookSkillDetailLayer(bookId, -141), 10) 
        else
            -- 金币 银币
        end
    end
    LuckyRankCellOwner["rewardItemClick"] = rewardItemClick

    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(615, 175)
        elseif fn == "cellAtIndex" then
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            --单条数据
            local  proxy = CCBProxy:create()
            local  _hbCell  = tolua.cast(CCBReaderLoad("ccbResources/LuckyRankCell.ccbi", proxy, true, "LuckyRankCellOwner"), "CCLayer")

            local function setCellMenuPriority(sender)
                if sender then
                    local menu = tolua.cast(sender, "CCMenu")
                    menu:setHandlerPriority(-140)
                end
            end

            local menu = LuckyRankCellOwner["menu"]
            local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCCallFuncN:create(setCellMenuPriority))
            menu:runAction(seq)

            local dic = _data.ranks[tostring(a1)]

            local rank = tolua.cast(LuckyRankCellOwner["rank"], "CCLabelTTF")
            rank:setString(a1 + 1)
            local name = tolua.cast(LuckyRankCellOwner["name"], "CCLabelTTF")
            local vip = tolua.cast(LuckyRankCellOwner["vip"], "CCSprite")
            local luckyTitle = tolua.cast(LuckyRankCellOwner["luckyTitle"], "CCLabelTTF")
            local lucky = tolua.cast(LuckyRankCellOwner["lucky"], "CCLabelTTF")
            if dic.playerId and dic.playerId ~= "" then
                name:setString(dic.name)
                vip:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("VIP_%d.png", dic.vipLevel)))
                lucky:setString(dic.count)
            else
                name:setVisible(false)
                vip:setVisible(false)
                luckyTitle:setVisible(false)
                lucky:setVisible(false)
            end

            for i=1,5 do
                local reward = dic.reward[tostring(i - 1)]
                if reward then
                    local itemId = reward.itemId
                    local count = reward.amount

                    local rewardItem = tolua.cast(LuckyRankCellOwner["rewardItem"..i], "CCMenuItem")
                    rewardItem:setTag(a1 * 100 + i)
                    rewardItem:setVisible(true)
                    local contentLayer = tolua.cast(LuckyRankCellOwner["contentLayer"..i], "CCLayer")
                    contentLayer:setVisible(true)
                    local bigSprite = tolua.cast(LuckyRankCellOwner["bigSprite"..i], "CCSprite")
                    local chipIcon = tolua.cast(LuckyRankCellOwner["chip_icon"..i], "CCSprite")
                    local littleSprite = tolua.cast(LuckyRankCellOwner["littleSprite"..i], "CCSprite")
                    local soulIcon = tolua.cast(LuckyRankCellOwner["soulIcon"..i], "CCSprite")
                    local countLabel = tolua.cast(LuckyRankCellOwner["countLabel"..i], "CCLabelTTF")
                    countLabel:setString(count)
                    
                    local resDic = userdata:getExchangeResource(itemId)

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
                        rewardItem:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("s_frame.png"))
                        rewardItem:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("s_frame.png"))

                        rewardItem:setPosition(ccp(rewardItem:getPositionX() + 5,rewardItem:getPositionY() - 5))
                        if resDic.icon then
                            playCustomFrameAnimation(string.format("yingzi_%s_", resDic.icon), contentLayer, 
                                ccp(contentLayer:getContentSize().width / 2, contentLayer:getContentSize().height / 2), 1, 4,
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
                        rewardItem:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", resDic.rank)))
                        rewardItem:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", resDic.rank)))
                    end
                end
            end

            a2:addChild(_hbCell, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            r = a2
        elseif fn == "numberOfCells" then
            r = getMyTableCount(_data.ranks)
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
    _data = dailyData:getDailyDataByName(Daily_LuckyRank)

    local lucky = tolua.cast(LuckyRankViewOwner["lucky"], "CCLabelTTF")
    local count = _data.myCount or 0
    lucky:setString(count)

    if _tableView then
        _tableView:removeFromParentAndCleanup(true)
        _tableView = nil
    end
    _addTableView()
end

local function rankItemClick()
    if dailyData:getLuckyRankState() == 1 then
        getDailyLayer():moveToPageByName(Daily_LuckyReward)
    else
        local function callback()
            _refreshUI() 
        end
        doActionFun("GET_LUCKYRANK_REWARD", {_data.uid}, callback)
    end
end
LuckyRankViewOwner["rankItemClick"] = rankItemClick

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/LuckyRankView.ccbi",proxy, true,"LuckyRankViewOwner")
    _layer = tolua.cast(node,"CCLayer")
    _refreshUI()
end

local function _getInfo()
    local function callback(url, rtnData)
        _refreshUI() 
    end
    doActionFun("GET_LUCKYREWARD_INFO", {}, callback)
end

-- 该方法名字每个文件不要重复
function getLuckyRankLayer()
	return _layer
end

function createLuckyRankLayer()
    _init()

    function _layer:getInfo()
         _getInfo()
    end

    local function _onEnter()
        addObserver(NOTI_TICK, refreshTime)
    end

    local function _onExit()
        removeObserver(NOTI_TICK, refreshTime)
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