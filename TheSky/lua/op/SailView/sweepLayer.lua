local _layer
local _priority = -134
local _storyResult
local tableView
local _type

-- 名字不要重复
SweepInfoOwner = SweepInfoOwner or {}
ccb["SweepInfoOwner"] = SweepInfoOwner

SweepCellOwner = SweepCellOwner or {}
ccb["SweepCellOwner"] = SweepCellOwner

local function _close()
    userdata:updateUserDataWithGainAndPay(_storyResult["gain"], _storyResult["pay"])
    postNotification(NOTI_SAIL_SWEEP_FINISH, nil) --刷新起航界面的tableview
    _layer:removeFromParentAndCleanup(true)
end

local function closeItemClick()
    _close()
end
SweepInfoOwner["closeItemClick"] = closeItemClick

local function _addTableView()
    local result
    if stageMode == STAGE_MODE.NOR then
        result = _storyResult.storyResult
    elseif stageMode == STAGE_MODE.ELITE then
        result = _storyResult.eliteResult
    end
    local contentLayer = tolua.cast(SweepInfoOwner["contentLayer"], "CCLayer")
    -- @param fn string Callback type
    -- @param table LuaTableView
    -- @param a1 & a2 mixed Difference means for every "fn"
    local h = LuaEventHandler:create(function(fn, t, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(contentLayer:getContentSize().width, 275)
        elseif fn == "cellAtIndex" then
            -- Return CCTableViewCell, a1 is cell index (zero based), a2 is dequeued cell (maybe nil)
            -- Do something to create cell  and change the content
            local dic = result[tostring(a1)]

            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            local  proxy = CCBProxy:create()
            local  _hbCell = tolua.cast(CCBReaderLoad("ccbResources/SweepCellView.ccbi",proxy,true, "SweepCellOwner"),"CCSprite")
            _hbCell:setAnchorPoint(ccp(0.5, 0.5))
            _hbCell:setPosition(contentLayer:getContentSize().width / 2, 275 / 2)

            local titleLabel = tolua.cast(SweepCellOwner["titleLabel"], "CCLabelTTF")
            titleLabel:setString(string.format(titleLabel:getString(), a1 + 1))
            if _type == "one_small" then
                titleLabel:setVisible(false)
            end
            local name = tolua.cast(SweepCellOwner["name"], "CCLabelTTF")
            name:setString(userdata.name)
            local playerExp = tolua.cast(SweepCellOwner["playerExp"], "CCLabelTTF")
            playerExp:setString(string.format(playerExp:getString(), dic.gain.exp_player))
            local berryLabel = tolua.cast(SweepCellOwner["berryLabel"], "CCLabelTTF")
            berryLabel:setString(string.format("+%d", dic.gain.silver))

            local heroInfo = tolua.cast(SweepCellOwner["heroInfo"], "CCLabelTTF")
            local info = ""
            for hid,v in pairs(dic.heros) do
                local hero = herodata:getHero(herodata.heroes[hid])
                info = string.format("%s%s+%d", info, hero.name, dic.gain.exp_hero)
                if v.levelOri ~= v.levelNow then
                    info = string.format("%s(%s)", info, HLNSLocalizedString("sail.levelup"))
                end
                info = string.format("%s  ", info)
            end
            heroInfo:setString(info)

            --双倍掉落
            local DoubleDropBg = tolua.cast(SweepCellOwner["huodong"], "CCSprite")
            if DoubleDropBg then
                DoubleDropBg:setVisible(loginActivityData:isDoubleDropOpen())
            end
            
            local gain = userdata:getSpecialGain(dic.gain)
            if gain and table.getTableCount(gain) > 0 then
                local awardTitle = tolua.cast(SweepCellOwner["awardTitle"], "CCLabelTTF")
                awardTitle:setVisible(true)
                local awardLabel = tolua.cast(SweepCellOwner["awardLabel"], "CCLabelTTF")
                awardLabel:setVisible(true)
                local info = ""
                for k,v in pairs(gain) do
                    if k == "heroes_soul" then
                        for heroId,count in pairs(v) do
                            local conf = herodata:getHeroConfig(heroId)
                            info = string.format("%s%s", info, HLNSLocalizedString("gain.hero_soul", count, conf.name))
                            info = string.format("%s ", info)
                        end
                    elseif k == "items" then
                        for itemId,count in pairs(v) do
                            local conf = wareHouseData:getItemConfig(itemId)
                            info = string.format("%s%s", info, HLNSLocalizedString("gain.item", count, conf.name))
                            info = string.format("%s ", info)
                        end
                    elseif k == "books" then
                        local t = {}
                        for sid,dic in pairs(v) do
                            local conf = skilldata:getSkillConfig(dic.skillId)
                            if t[conf.name] then
                                t[conf.name] = t[conf.name] + 1
                            else
                                t[conf.name] = 1
                            end
                        end
                        for name,count in pairs(t) do
                            info = string.format("%s%s", info, HLNSLocalizedString("gain.books", count, name))
                            info = string.format("%s ", info)
                        end
                    elseif k == "frags" then
                        for chapterId,count in pairs(v) do
                            local conf = wareHouseData:getItemConfig(chapterId)
                            info = string.format("%s%s", info, HLNSLocalizedString("gain.item", count, conf.name))
                            info = string.format("%s ", info)
                        end
                    elseif k == "equips" then
                        local t = {}
                        for eid,dic in pairs(v) do
                            local conf = equipdata:getEquipConfig(dic.equipId)
                            if t[conf.name] then
                                t[conf.name] = t[conf.name] + 1
                            else
                                t[conf.name] = 1
                            end
                        end
                        for name,count in pairs(t) do
                            info = string.format("%s%s", info, HLNSLocalizedString("gain.item", count, name))
                            info = string.format("%s ", info)
                        end
                    elseif k == "shadows" then
                        local t = {}
                        for sid,shadow in pairs(v) do
                            local conf = shadowData:getOneShadowConf(shadow.shadowId)
                            if t[conf.name] then
                                t[conf.name] = t[conf.name] + 1
                            else
                                t[conf.name] = 1
                            end
                        end
                        for name,count in pairs(t) do
                            info = string.format("%s%s", info, HLNSLocalizedString("gain.item", count, name))
                            info = string.format("%s ", info)
                        end
                    elseif k == "equipShard" then
                        for sid,count in pairs(v) do
                            local conf = shardData:getShardConf(sid)
                            info = string.format("%s%s", info, HLNSLocalizedString("gain.item", count, conf.name))
                            info = string.format("%s ", info)
                        end
                    elseif k == "delayItems" then
                        local t = {}
                        for bid,bag in pairs(v) do
                            local conf = wareHouseData:getItemConfig(bag.itemId)
                            if t[conf.name] then
                                t[conf.name] = t[conf.name] + 1
                            else
                                t[conf.name] = 1
                            end
                        end
                        for name,count in pairs(t) do
                            info = string.format("%s%s", info, HLNSLocalizedString("gain.item", count, name))
                            info = string.format("%s ", info)
                        end
                    elseif k == "gold" then
                        info = string.format("%s%s", info, HLNSLocalizedString("gain.gold", v))
                        info = string.format("%s ", info)
                    end
                end
                awardLabel:setString(info)
             end

             a2:addChild(_hbCell, 0, 100)
             r = a2
        elseif fn == "numberOfCells" then
            -- Return number of cells
            r = table.getTableCount(result)
        -- Cell events:
        elseif fn == "cellTouched" then
        elseif fn == "cellTouchBegan" then      -- A cell is touching, a1 is cell, a2 is CCTouch
        elseif fn == "cellTouchEnded" then      -- A cell was touched, a1 is cell, a2 is CCTouch
        elseif fn == "cellHighlight" then       -- A cell is highlighting, coco2d-x 2.1.3 or above
        elseif fn == "cellUnhighlight" then     -- A cell had been unhighlighted, coco2d-x 2.1.3 or above
        elseif fn == "cellWillRecycle" then     -- A cell will be recycled, coco2d-x 2.1.3 or above
        end
        return r
    end)
    local size = CCSizeMake(contentLayer:getContentSize().width, contentLayer:getContentSize().height)
    _tableView = LuaTableView:createWithHandler(h, size)
    _tableView:setBounceable(true)
    _tableView:setAnchorPoint(ccp(0,0))
    _tableView:setPosition(ccp(0, 0))
    _tableView:setVerticalFillOrder(0)
    contentLayer:addChild(_tableView)
    _tableView:setTouchPriority(_priority - 1)

end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  node 
    local  proxy = CCBProxy:create()
    if _type == "ten_big" then
        print("**lsf ten_big")
        node  = CCBReaderLoad("ccbResources/SweepInfoView.ccbi", proxy, true,"SweepInfoOwner")
    elseif _type == "one_small" then
        node  = CCBReaderLoad("ccbResources/SweepInfoView2.ccbi", proxy, true,"SweepInfoOwner")
    end
    _layer = tolua.cast(node,"CCLayer")
    _addTableView()
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(SweepInfoOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        _close()
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
    local menu = tolua.cast(SweepInfoOwner["menu"], "CCMenu")
    menu:setHandlerPriority(_priority - 2)
end

-- 该方法名字每个文件不要重复
function getSweepInfoLayer()
    return _layer
end

function createSweepInfoLayer(storyResult,type, priority)
    _storyResult = storyResult
    _type = type
    _priority = (priority ~= nil) and priority or -134
    _init()

    local function _onEnter()
        print("onEnter")
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
    end

    local function _onExit()
        print("onExit")
        _layer = nil
        tableView = nil
        _priority = -134
        _storyResult = nil
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