local _layer
local _endTime
local _myRank
local _todayScore
local _weekScore
local _allScore
local _tableView
local _data
local _reward

-- 名字不要重复
WWRecordRankOwner = WWRecordRankOwner or {}
ccb["WWRecordRankOwner"] = WWRecordRankOwner

local function refreshTime()
    if _endTime then
        local rankCD = tolua.cast(WWRecordRankOwner["rankCD"], "CCLabelTTF")
        rankCD:setString(DateUtil:second2hms(math.max(0, _endTime - userdata.loginTime)))
    end
end

local function addTableView()
    if _tableView then
        _tableView:removeFromParentAndCleanup(true)
        _tableView = nil
    end
    _data = worldwardata:getScoreRank()


    WWRecordRankCellOwner = WWRecordRankCellOwner or {}
    ccb["WWRecordRankCellOwner"] = WWRecordRankCellOwner

    local function viewItemClick(tag)
        local function viewBattleInfo(url, rtnData)
            playerBattleData:fromDic(rtnData.info)
            getMainLayer():getParent():addChild(createTeamPopupLayer(-140))
        end
        local dic = _data[tag]
        doActionFun("ARENA_GET_BATTLE_INFO", {dic.playerId}, viewBattleInfo)
    end
    WWRecordRankCellOwner["viewItemClick"] = viewItemClick

    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(winSize.width, 155 * retina)
        elseif fn == "cellAtIndex" then
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end

            local  proxy = CCBProxy:create()
            local  _cell = tolua.cast(CCBReaderLoad("ccbResources/WWRecordRankCell.ccbi",proxy,true,"WWRecordRankCellOwner"), "CCLayer")
            
            local dic = _data[a1 + 1]

            local viewItem = tolua.cast(WWRecordRankCellOwner["viewItem"], "CCMenuItem")
            viewItem:setTag(a1 + 1)
            local viewText = tolua.cast(WWRecordRankCellOwner["viewText"], "CCSprite")
            viewItem:setVisible(dic.playerId ~= userdata.userId)
            viewText:setVisible(dic.playerId ~= userdata.userId)

            local rank = tolua.cast(WWRecordRankCellOwner["rank"], "CCLabelTTF")
            rank:setString(a1 + 1)
            local name = tolua.cast(WWRecordRankCellOwner["name"], "CCLabelTTF")
            name:setString(dic.name)
            local vip = tolua.cast(WWRecordRankCellOwner["vip"], "CCLabelTTF")
            vip:setVisible(true)
            vip:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("VIP_%d.png", dic.vip)))
            local record = tolua.cast(WWRecordRankCellOwner["record"], "CCLabelTTF")
            record:setString(dic.score)
            for i=0,2 do
                if not dic.form[tostring(i)] then
                    -- modified by赵艳秋，有时候玩家上阵英雄数不足三个（20151110）
                else
                    local heroId
                    if dic.form[tostring(i)].heroId then
                        heroId = dic.form[tostring(i)].heroId
                    else
                        heroId = dic.form[tostring(i)]
                    end
                    local herowake = dic.form[tostring(i)].wake
                    if heroId then
                        local conf = herodata:getHeroConfig(heroId ,herowake )
                        local frame = tolua.cast(WWRecordRankCellOwner["frame"..i + 1], "CCSprite")
                        frame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", conf.rank)))
                        frame:setVisible(true)
                        local head = tolua.cast(WWRecordRankCellOwner["head"..i + 1], "CCSprite")
                        local f = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(herodata:getHeroHeadByHeroId(heroId))
                        if f then
                            head:setDisplayFrame(f)
                            head:setVisible(true)
                        end
                    end
                end
            end

            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            _cell:setScale(retina)
            a2:addChild(_cell, 0, 1)

            r = a2
        elseif fn == "numberOfCells" then
            r = #_data
        elseif fn == "cellTouched" then
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
        local size = CCSizeMake(winSize.width, (winSize.height - 520 * retina 
            - _mainLayer:getBottomContentSize().height))      -- 这里是为了在tableview上面显示一个小空出来
        _tableView = LuaTableView:createWithHandler(h, size)
        _tableView:setBounceable(true)
        _tableView:setAnchorPoint(ccp(0, 0))
        _tableView:setPosition(ccp(0, _mainLayer:getBottomContentSize().height))
        _tableView:setVerticalFillOrder(0)
        _layer:addChild(_tableView)
    end
end

local function rewardItemClick()
    local itemId = _reward.itemId
    if havePrefix(itemId, "weapon_") or havePrefix(itemId, "belt_") or havePrefix(itemId, "armor_") then
            -- 装备
        if haveSuffix(itemId, "_shard") then
            itemId = string.sub(itemId, 1, -7)
        end
        getMainLayer():getParent():addChild(createEquipInfoLayer(itemId, 2, -133), 10)
    elseif havePrefix(itemId, "item") or havePrefix(itemId, "key") or havePrefix(itemId, "bag") 
        or havePrefix(itemId, "stuff") or havePrefix(itemId, "drawing") then
        -- 道具
        getMainLayer():getParent():addChild(createItemDetailInfoLayer(itemId, -133, 1, 1), 10)
    elseif havePrefix(itemId, "shadow") then
        -- 影子
        local dic = {}
        local item = shadowData:getOneShadowConf(itemId)
        dic.conf = item
        dic.id = itemId
        getMainLayer():getParent():addChild(createShadowPopupLayer(dic, nil, nil, -133, 1), 10)
    elseif havePrefix(itemId, "hero") then
        -- 魂魄
        getMainLayer():getParent():addChild(createHeroInfoLayer(itemId, HeroDetail_Clicked_Handbook, -133), 10)
    elseif havePrefix(itemId, "book") then
        -- 奥义
        getMainLayer():getParent():addChild(createHandBookSkillDetailLayer(itemId, -133), 10) 
    elseif havePrefix(itemId, "chapter_") then
        -- 残章
        local bookId = string.format("book_%s", string.split(itemId, "_")[2])
        getMainLayer():getParent():addChild(createHandBookSkillDetailLayer(bookId, -133), 10) 
    else
        -- 金币 银币
    end
end
WWRecordRankOwner["rewardItemClick"] = rewardItemClick

local function rewardClick()
    local function callback(url, rtnData)
        _reward = rtnData.info.reward
        postNotification(NOTI_WW_REFRESH, nil)
    end
    doActionFun("WW_GET_SCOREREWARD", {}, callback)
end
WWRecordRankOwner["rewardClick"] = rewardClick

local function refresh()
    local rewardLayer = tolua.cast(WWRecordRankOwner["rewardLayer"], "CCLayer")
    rewardLayer:setVisible(true)

    local rank = tolua.cast(WWRecordRankOwner["rank"], "CCLabelTTF")
    rank:setString(_myRank)

    local dayRecord = tolua.cast(WWRecordRankOwner["dayRecord"], "CCLabelTTF")
    dayRecord:setString(_todayScore)

    local weekRecord = tolua.cast(WWRecordRankOwner["weekRecord"], "CCLabelTTF")
    weekRecord:setString(_weekScore)

    local totalRecord = tolua.cast(WWRecordRankOwner["totalRecord"], "CCLabelTTF")
    totalRecord:setString(_allScore)

    local menuLayer = tolua.cast(WWRecordRankOwner["menuLayer"], "CCLayer")
    local rewardMenu = tolua.cast(WWRecordRankOwner["rewardMenu"], "CCMenu")
    local noReward = tolua.cast(WWRecordRankOwner["noReward"], "CCLabelTTF")
    if _reward and type(_reward) == "table" and _reward.itemId and _reward.itemId ~= "" then
        local itemId = _reward.itemId
        menuLayer:setVisible(true)
        rewardMenu:setVisible(true)
        noReward:setVisible(false)

        local rewardItem = tolua.cast(WWRecordRankOwner["rewardItem"], "CCMenuItem")
        local contentLayer = tolua.cast(WWRecordRankOwner["contentLayer"],"CCLayer")
        local bigSprite = tolua.cast(WWRecordRankOwner["bigSprite"],"CCSprite")
        local chipIcon = tolua.cast(WWRecordRankOwner["chipIcon"],"CCSprite")
        local littleSprite = tolua.cast(WWRecordRankOwner["littleSprite"],"CCSprite")
        local soulIcon = tolua.cast(WWRecordRankOwner["soulIcon"],"CCSprite")

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

            rewardItem:setPosition(ccp(rewardItem:getPositionX() + 5, rewardItem:getPositionY() - 5))
            if resDic.icon then
                playCustomFrameAnimation(string.format("yingzi_%s_",resDic.icon),contentLayer,ccp(contentLayer:getContentSize().width / 2,contentLayer:getContentSize().height / 2),1,4,shadowData:getColorByColorRank( resDic.rank ) )
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

        local desp1 = tolua.cast(WWRecordRankOwner["desp1"], "CCLabelTTF")
        desp1:setString(_reward.description)
        local desp2 = tolua.cast(WWRecordRankOwner["desp2"], "CCLabelTTF")
        desp2:setString(string.format("%s×%d", resDic.name, _reward.amount))
    else
        menuLayer:setVisible(false)
        rewardMenu:setVisible(false)
        noReward:setVisible(true)
    end

    refreshTime()
    addTableView()
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/WWRecordRankView.ccbi",proxy, true,"WWRecordRankOwner")
    _layer = tolua.cast(node,"CCLayer")
end

local function refreshRank()
    local function getScoreRankCallback(url, rtnData)
        worldwardata:fromDic(rtnData.info)
        PrintTable(worldwardata.scoreRank)
        _endTime = rtnData.info.endTime
        _myRank = rtnData.info.myIndex
        _todayScore = rtnData.info.todayScore
        _weekScore = rtnData.info.weekScore
        _allScore = rtnData.info.allScore
        _reward = rtnData.info.reward
        postNotification(NOTI_WW_REFRESH, nil)
    end
    doActionFun("WW_GET_SCORERANK", {}, getScoreRankCallback)
end


-- 该方法名字每个文件不要重复
function getWWRecordRankLayer()
	return _layer
end

function createWWRecordRankLayer()
    _init()


    local function _onEnter()
        addObserver(NOTI_TICK, refreshTime)
        addObserver(NOTI_WW_REFRESH, refresh)
        refreshRank()
    end

    local function _onExit()
        removeObserver(NOTI_TICK, refreshTime)
        removeObserver(NOTI_WW_REFRESH, refresh)
        _layer = nil
        _endTime = 0
        _myRank = 1
        _tableView = nil
        _data = nil
        _todayScore = 0
        _weekScore = 0
        _allScore = 0
        _reward = nil
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