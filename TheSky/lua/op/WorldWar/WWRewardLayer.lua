local _layer
local _tableView
local _data

-- 名字不要重复
WWRewardOwner = WWRewardOwner or {}
ccb["WWRewardOwner"] = WWRewardOwner


local function getCellHeight(string, width, fontSize, fontName )
    if not fontName then
        fontName = "ccbResources/FZCuYuan-M03S.ttf"
    end
    local tempLabel = CCLabelTTF:create(string, fontName, fontSize, CCSizeMake(width, 0), kCCTextAlignmentLeft)
    tempLabel:setVisible(false)
    _layer:addChild(tempLabel, 200, 8888)
    local height = tempLabel:getContentSize().height
    tempLabel:removeFromParentAndCleanup(true)
    return height
end

local function addTableView() 
    local content = WWRewardOwner["content"]
    local helpHeightArray = {}
    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
                local message = ConfigureStorage.WWHelp5[a1 + 1].desp
                local cellHeight
                if helpHeightArray[a1 + 1] then
                    cellHeight = helpHeightArray[a1 + 1]
                else
                    cellHeight = getCellHeight(message, 585.0, 23, "ccbResources/FZCuYuan-M03S") + 20 
                    helpHeightArray[a1 + 1] = cellHeight 
                end
                r = CCSizeMake(winSize.width, cellHeight)
            -- end
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
            -- _hbCell = CCLayerColor:create(ccc4(255,255,3,255))
            _hbCell = CCLayer:create()

            local message = ConfigureStorage.WWHelp5[a1 + 1].desp
            local cellHeight
            if helpHeightArray[a1 + 1] then
                cellHeight = helpHeightArray[a1 + 1]
            else
                cellHeight = getCellHeight(message, 585.0, 23, "ccbResources/FZCuYuan-M03S") + 20 * retina
                helpHeightArray[a1+1] = cellHeight
            end
            _hbCell:setContentSize(CCSizeMake(585, cellHeight+35))
            _hbCell:setAnchorPoint(ccp(0,0))
            _hbCell:setPosition(ccp(0,0))

            local temp = CCLabelTTF:create(message, "ccbResources/FZCuYuan-M03S", 23, CCSizeMake(585, cellHeight+20), kCCTextAlignmentLeft)
            temp:setAnchorPoint(ccp(0,1))
            temp:setPosition(ccp(0, cellHeight - 10 * retina))
            _hbCell:addChild(temp)
            temp:setColor(ccc3(255, 204, 0))
                
            -- _hbCell:setScale(retina)
            a2:addChild(_hbCell, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)

            r = a2
        elseif fn == "numberOfCells" then
            r = getMyTableCount(ConfigureStorage.WWHelp5)
        elseif fn == "cellTouched" then         -- A cell was touched, a1 is cell that be touched. This is not necessary.
            -- print("cellTouched",a1:getIdx())
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
        local size = CCSizeMake(content:getContentSize().width, content:getContentSize().height)      -- 这里是为了在tableview上面显示一个小空出来
        _tableView = LuaTableView:createWithHandler(h, size)
        _tableView:setBounceable(true)
        _tableView:setAnchorPoint(ccp(0,0))
        _tableView:setPosition(ccp(0, 0))
        _tableView:setVerticalFillOrder(0)
        content:addChild(_tableView)
    end
end

local function refresh()
    local rewardLayer = tolua.cast(WWRewardOwner["rewardLayer"], "CCLayer")
    rewardLayer:setVisible(true)

    local islandName = tolua.cast(WWRewardOwner["islandName"], "CCLabelTTF")
    islandName:setString(worldwardata:getIslandName("island_13"))

    local badge = tolua.cast(WWRewardOwner["badge"], "CCSprite")
    local data = worldwardata.islandData["island_13"]
    local group = data.countryId
    if not data.countryId then
        badge:setVisible(false)
    else
        badge:setVisible(true)
        local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("badge_%d.png", tonumber(string.split(group, "_")[2])))
        badge:setDisplayFrame(frame)
    end

    local islandCount = tolua.cast(WWRewardOwner["islandCount"], "CCLabelTTF")
    islandCount:setString(_data.islandCount)

    local recordCount = tolua.cast(WWRewardOwner["recordCount"], "CCLabelTTF")
    recordCount:setString(_data.score)

    local job = tolua.cast(WWRewardOwner["job"], "CCLabelTTF")
    if worldwardata.playerData.leaderKey and worldwardata.playerData.leaderKey ~= "" then
        local leaderKey = worldwardata.playerData.leaderKey
        job:setString(ConfigureStorage.WWJob[leaderKey + 1][string.format("%s_name", worldwardata.playerData.countryId)])
    else
        job:setString(HLNSLocalizedString("ww.job.normal"))
    end

    local islandReward = tolua.cast(WWRewardOwner["islandReward"], "CCLabelTTF")
    local iAmount = 0
    if _data.islandReward and type(_data.islandReward) == "table" then
        iAmount = _data.islandReward.amount
    end
    islandReward:setString(iAmount)

    local recordReward = tolua.cast(WWRewardOwner["recordReward"], "CCLabelTTF")
    local oAmount = 0
    if _data.onePieceReward and type(_data.onePieceReward) == "table" then
        oAmount = _data.onePieceReward.amount
    end
    recordReward:setString(oAmount)

    local jobReward = tolua.cast(WWRewardOwner["jobReward"], "CCLabelTTF")
    local jAmount = 0
    if _data.leaderReward and type(_data.leaderReward) == "table" then
        jAmount = _data.leaderReward.amount
    end
    jobReward:setString(jAmount)

    local tips = tolua.cast(WWRewardOwner["tips"], "CCLabelTTF")
    tips:setString(HLNSLocalizedString("ww.reward.tips", iAmount + jAmount + oAmount))

    addTableView()
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/WWRewardView.ccbi",proxy, true,"WWRewardOwner")
    _layer = tolua.cast(node,"CCLayer")
end

local function refreshReward()
    local function callback(url, rtnData)
        _data = rtnData.info
        postNotification(NOTI_WW_REFRESH, nil)
    end
    doActionFun("WW_GET_REWARDPREVIEW", {}, callback)
end


-- 该方法名字每个文件不要重复
function getWWRewardLayer()
	return _layer
end

function createWWRewardLayer()
    _init()


    local function _onEnter()
        addObserver(NOTI_WW_REFRESH, refresh)
        refreshReward()
    end

    local function _onExit()
        removeObserver(NOTI_WW_REFRESH, refresh)
        _tableView = nil
        _data = nil
        _layer = nil
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