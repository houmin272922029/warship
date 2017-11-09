local _layer
local _priority
local _data
local _tableView

WWDistributeOwner = WWDistributeOwner or {}
ccb["WWDistributeOwner"] = WWDistributeOwner

-- 关闭
local function closeItemClick()
    popUpCloseAction(WWDistributeOwner, "infoBg", _layer)
end
WWDistributeOwner["closeItemClick"] = closeItemClick


local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(WWDistributeOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction(WWDistributeOwner, "infoBg", _layer)
        return true
    end
    return true
end

local function onTouch(eventType, x, y)
    if eventType == "began" then   
        return onTouchBegan(x, y)
    end
end

-- 修改 按钮优先级
local function setMenuPriority()
    local menu = tolua.cast(WWDistributeOwner["menu"], "CCMenu")
    menu:setHandlerPriority(_priority - 1)
    _tableView:setTouchPriority(_priority - 1)
end

local function addTableView()
    if _tableView then
        _tableView:removeFromParentAndCleanup(true)
        _tableView = nil
    end

    WWDistributeCellOwner = WWDistributeCellOwner or {}
    ccb["WWDistributeCellOwner"] = WWDistributeCellOwner

    local function armyItemClick(tag)
        local rewardCount = 0
        if worldwardata.yesterdayRank and type(worldwardata.yesterdayRank) == "table" then
            for i=0,2 do
                local dic = worldwardata.yesterdayRank[tostring(i)]
                if dic and dic.countryId == worldwardata.playerData.countryId then
                    rewardCount = ConfigureStorage.WWReward[i + 1].Dispatch or 0
                    break
                end
            end
        end
        local leaderKey = worldwardata.playerData.leaderKey
        local count = math.max(0, ConfigureStorage.WWJob[leaderKey + 1].dispatch + rewardCount - worldwardata.playerData.dispatchCount)
        if count == 0 then
            ShowText(HLNSLocalizedString("distribute.count.tips"))
            return
        end
        local function callback(url, rtnData)
            local data = rtnData.info
            local dic = {["playerData"] = data.playerData, ["island"] = data.islandData}
            worldwardata:fromDic(dic)
            postNotification(NOTI_WW_REFRESH, nil)
            closeItemClick()
        end
        local dic = _data[tag]
        doActionFun("WW_DISTRIBUTE", {worldwardata.playerData.islandId, dic.id}, callback)
    end
    WWDistributeCellOwner["armyItemClick"] = armyItemClick

    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(600, 300)
        elseif fn == "cellAtIndex" then
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            --单条数据
            local  proxy = CCBProxy:create()
            local  _hbCell  = tolua.cast(CCBReaderLoad("ccbResources/WWDistributeCell.ccbi",proxy,true,"WWDistributeCellOwner"),"CCLayer")

            local function setCellMenuPriority(sender)
                if sender then
                    local menu = tolua.cast(sender, "CCMenu")
                    menu:setHandlerPriority(_priority - 1)
                end
            end

            local menu = WWDistributeCellOwner["menu"]
            local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCCallFuncN:create(setCellMenuPriority))
            menu:runAction(seq)

            for i=1,3 do
                local dic = _data[a1 * 3 + i]
                local armyItem = tolua.cast(WWDistributeCellOwner["armyItem"..i], "CCMenuItem") 
                local layer = tolua.cast(WWDistributeCellOwner["layer"..i], "CCLayer")
                if dic then
                    local icon = worldwardata:getShipIcon(dic.durabilityLevel, worldwardata.playerData.countryId)
                    armyItem:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(icon))
                    armyItem:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(icon))
                    armyItem:setTag(a1 * 3 + i)

                    local record = tolua.cast(WWDistributeCellOwner["record"..i], "CCLabelTTF")
                    record:setString(dic.score)

                    local name = tolua.cast(WWDistributeCellOwner["name"..i], "CCLabelTTF")
                    name:setString(dic.name)

                    local level = tolua.cast(WWDistributeCellOwner["level"..i], "CCLabelTTF")
                    level:setString(string.format("LV:%d", dic.level))

                    local vip = tolua.cast(WWDistributeCellOwner["vip"..i], "CCSprite")
                    vip:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("VIP_%d.png", dic.vip)))
                else
                    armyItem:setVisible(false)
                    layer:setVisible(false)
                end
            end
            

            a2:addChild(_hbCell, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            r = a2
        elseif fn == "numberOfCells" then
            r = #_data % 3 == 0 and #_data / 3 or #_data / 3 + 1
        elseif fn == "cellTouched" then         -- A cell was touched, a1 is cell that be touched. This is not necessary.
        elseif fn == "cellTouchBegan" then      -- A cell is touching, a1 is cell, a2 is CCTouch
        elseif fn == "cellTouchEnded" then      -- A cell was touched, a1 is cell, a2 is CCTouch
        elseif fn == "cellHighlight" then       -- A cell is highlighting, coco2d-x 2.1.3 or above
        elseif fn == "cellUnhighlight" then     -- A cell had been unhighlighted, coco2d-x 2.1.3 or above
        elseif fn == "cellWillRecycle" then     -- A cell will be recycled, coco2d-x 2.1.3 or above
        end
        return r
    end)
    local content = tolua.cast(WWDistributeOwner["content"], "CCLayer")
    local size = content:getContentSize()
    _tableView = LuaTableView:createWithHandler(h, size)
    _tableView:setBounceable(true)
    _tableView:setAnchorPoint(ccp(0,0))
    _tableView:setPosition(0,0)
    _tableView:setVerticalFillOrder(0)
    content:addChild(_tableView,1000)
end

local function refresh()
    _islandId = worldwardata.playerData.islandId
    local title = tolua.cast(WWDistributeOwner["island"], "CCLabelTTF")
    title:setString(worldwardata:getIslandName(_islandId))
    
    local rewardCount = 0
    if worldwardata.yesterdayRank and type(worldwardata.yesterdayRank) == "table" then
        for i=0,2 do
            local dic = worldwardata.yesterdayRank[tostring(i)]
            if dic and dic.countryId == worldwardata.playerData.countryId then
                rewardCount = ConfigureStorage.WWReward[i + 1].Dispatch or 0
                break
            end
        end
    end
    local leaderKey = worldwardata.playerData.leaderKey
    local count = math.max(0, ConfigureStorage.WWJob[leaderKey + 1].dispatch + rewardCount - worldwardata.playerData.dispatchCount)
    local tips = tolua.cast(WWDistributeOwner["tips"], "CCLabelTTF")
    tips:setString(HLNSLocalizedString("distribute.tips", count))
    
    local godTips = tolua.cast(WWDistributeOwner["godtips"], "CCLabelTTF")
    godTips:setString(ConfigureStorage.WWItemUse.Dispatch.cost)

    addTableView()
end

local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/WWDistribute.ccbi", proxy, true, "WWDistributeOwner")
    _layer = tolua.cast(node, "CCLayer")

    refresh()
end

function createWWDistributeLayer(data, priority)
    _data = data
    _priority = (priority ~= nil) and priority or -132

    _init()

    local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
    _layer:runAction(seq)

    local function _onEnter()
        popUpUiAction(WWDistributeOwner, "infoBg")
    end

    local function _onExit()
        _priority = -132
        _data = nil
        _layer = nil
        _tableView = nil
    end

    --onEnter onExit
    local function _layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        end
    end

    _layer:registerScriptTouchHandler(onTouch, false, _priority, true)
    _layer:setTouchEnabled(true)
    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end