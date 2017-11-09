local _layer
local _data
local helpHeightArray = {}
local _despArray = {}
local _tableView

-- 名字不要重复
WWGroupRankOwner = WWGroupRankOwner or {}
ccb["WWGroupRankOwner"] = WWGroupRankOwner

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
    local content = WWGroupRankOwner["content"]

    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
                local message = _despArray[a1 + 1]
                local cellHeight
                if helpHeightArray[a1 + 1] then
                    cellHeight = helpHeightArray[a1 + 1]
                else
                    cellHeight = getCellHeight(message, 585.0, 23, "ccbResources/FZCuYuan-M03S") + 20 * retina
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

            local message = _despArray[a1 + 1]
            local cellHeight
            if helpHeightArray[a1 + 1] then
                cellHeight = helpHeightArray[a1 + 1]
            else
                cellHeight = getCellHeight(message, 585.0, 23, "ccbResources/FZCuYuan-M03S") + 20 * retina
                helpHeightArray[a1+1] = cellHeight
            end
            _hbCell:setContentSize(CCSizeMake(585, cellHeight))
            _hbCell:setAnchorPoint(ccp(0,0))
            _hbCell:setPosition(ccp(0,0))

            local temp = CCLabelTTF:create(message, "ccbResources/FZCuYuan-M03S", 23, CCSizeMake(585, 0), kCCTextAlignmentLeft)
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
            r = getMyTableCount(_despArray)
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

local function changeDesp(index)
    local dic = ConfigureStorage.WWGroupDesp[index]
    _despArray = {}
    table.insert(_despArray, dic.name)
    for i=1,table.getTableCount(dic) do
        local reward = dic["Reward"..i]
        if reward then
            table.insert(_despArray, reward)
        end
    end
end

local function groupItemClick(tag)
    changeDesp(tag)
    _tableView:reloadData()
end
WWGroupRankOwner["groupItemClick"] = groupItemClick

local function refresh()
    local rankLayer = tolua.cast(WWGroupRankOwner["rankLayer"], "CCLayer")
    rankLayer:setVisible(true)

    for i=1,3 do
        local groupItem = tolua.cast(WWGroupRankOwner["groupItem"..i], "CCMenuItem")
        groupItem:setOpacity(0)
        groupItem:setTag(i)

        local dic = _data.yesterdayRank[tostring(i - 1)]
        local index = tonumber(string.split(dic.countryId, "_")[2])
        local badge = tolua.cast(WWGroupRankOwner["badge"..i], "CCSprite")
        local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("badge_%d.png", index))
        badge:setDisplayFrame(frame)

        local record = tolua.cast(WWGroupRankOwner["record"..i], "CCLabelTTF")
        record:setString(math.floor(dic.scores))

        local name = tolua.cast(WWGroupRankOwner["name"..i], "CCLabelTTF")
        local level = tolua.cast(WWGroupRankOwner["level"..i], "CCLabelTTF")
        local vip = tolua.cast(WWGroupRankOwner["vip"..i], "CCSprite")
        local powerTitle = tolua.cast(WWGroupRankOwner["powerTitle"..i], "CCLabelTTF")
        local power = tolua.cast(WWGroupRankOwner["power"..i], "CCLabelTTF")
        local groupTips = tolua.cast(WWGroupRankOwner["groupTips"..i], "CCLabelTTF")
        if dic.king and type(dic.king) == "table" and table.getTableCount(dic.king) > 0 then
            -- name:setString()
            name:setString(dic.king.name)
            level:setString(string.format("LV:%d", dic.king.level))
            vip:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("VIP_%d.png", dic.king.vip)))
            power:setString(dic.king.worth)
        else
            name:setVisible(false)
            level:setVisible(false)
            vip:setVisible(false)
            powerTitle:setVisible(false)
            power:setVisible(false)
            groupTips:setVisible(true)
        end
        if worldwardata.playerData.countryId == dic.countryId then
            local tips = tolua.cast(WWGroupRankOwner["tips"], "CCLabelTTF")
            tips:setString(HLNSLocalizedString("ww.group.rank.tips."..i))
        end
        if dic.countryId == worldwardata.playerData.countryId then
            changeDesp(i)
        end
    end

    addTableView()
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/WWGroupRankView.ccbi",proxy, true,"WWGroupRankOwner")
    _layer = tolua.cast(node,"CCLayer")
end

local function refreshRank()
    local function callback(url, rtnData)
        _data = rtnData.info
        worldwardata:fromDic(_data)
        postNotification(NOTI_WW_REFRESH, nil)
    end
    doActionFun("WW_GET_GROUPRANK", {}, callback)
end


-- 该方法名字每个文件不要重复
function getWWGroupRankLayer()
	return _layer
end

function createWWGroupRankLayer()
    _init()


    local function _onEnter()
        addObserver(NOTI_WW_REFRESH, refresh)
        refreshRank()
    end

    local function _onExit()
        removeObserver(NOTI_WW_REFRESH, refresh)
        _layer = nil
        _data = nil
        helpHeightArray = {}
        _despArray = {}
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


    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end