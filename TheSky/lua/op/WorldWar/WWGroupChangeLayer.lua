local _layer
local _current
local _bAni = false
local _badgePos = {}
local helpHeightArray = {}
local _tableView = nil

-- 名字不要重复
WWGroupChangeOwner = WWGroupChangeOwner or {}
ccb["WWGroupChangeOwner"] = WWGroupChangeOwner

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
    local content = WWGroupChangeOwner["content"]

    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
                local message = ConfigureStorage.WWHelp4[a1 + 1].desp
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

            local message = ConfigureStorage.WWHelp4[a1 + 1].desp
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
            r = getMyTableCount(ConfigureStorage.WWHelp4)
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

local function menuEnable(sender)
    sender:setEnabled(true)
end

local function menuDisable(sender)
    sender:setEnabled(false) 
end

local function aniEnd()
    _bAni = false 
end

local function changeText()
    for i=0,1 do
        local groupName = tolua.cast(WWGroupChangeOwner["groupName"..i], "CCLabelTTF")
        groupName:setString(HLNSLocalizedString("ww.group.".._current))
    end
    local changeItem = tolua.cast(WWGroupChangeOwner["changeItem"], "CCMenuItem")
    local changeSp = tolua.cast(WWGroupChangeOwner["changeSp"], "CCSprite")
    local flag = string.format("camp_%02d", _current) ~= worldwardata.playerData.countryId

    changeItem:setVisible(flag)
    changeSp:setVisible(flag)
end

local function chooseGroup(index)
    if index == _current then
        return
    end
    _current = index
    _bAni = true
    local duration = 0.2
    -- index move pos.1, scale to 1, color to ccc3(255, 255, 255)
    local badge1 = tolua.cast(WWGroupChangeOwner["badge"..index], "CCSprite")
    if badge1 then
        local array = CCArray:create()
        array:addObject(CCMoveTo:create(duration, ccp(_badgePos[1].x, _badgePos[1].y)))
        array:addObject(CCScaleTo:create(duration, 1))
        array:addObject(CCTintTo:create(duration, 255, 255, 255))
        badge1:runAction(CCSpawn:create(array))
    end
    -- index+1 move pos.2, scale to 0.6, color to ccc3(138, 138, 138)
    local n = index % 3 + 1
    badge2 = tolua.cast(WWGroupChangeOwner["badge"..n], "CCSprite")
    if badge2 then
        local array = CCArray:create()
        array:addObject(CCMoveTo:create(duration, ccp(_badgePos[2].x, _badgePos[2].y)))
        array:addObject(CCScaleTo:create(duration, 0.6))
        array:addObject(CCTintTo:create(duration, 138, 138, 138))
        badge2:runAction(CCSpawn:create(array))
    end
    -- index-1 move pos.3, scale to 0.6, color to ccc3(138, 138, 138) 
    local l = index % 3 - 1
    l = l > 0 and l or l + 3 
    badge3 = tolua.cast(WWGroupChangeOwner["badge"..l], "CCSprite")
    if badge3 then
        local array = CCArray:create()
        array:addObject(CCMoveTo:create(duration, ccp(_badgePos[3].x, _badgePos[3].y)))
        array:addObject(CCScaleTo:create(duration, 0.6))
        array:addObject(CCTintTo:create(duration, 138, 138, 138))
        badge3:runAction(CCSpawn:create(array))
    end
    _layer:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(duration), 
        CCSpawn:createWithTwoActions(CCCallFunc:create(changeText), CCCallFunc:create(aniEnd))))
end

local function addChooseTouch()

    local function onTouchBegan(x, y)
        local chooseLayer = tolua.cast(WWGroupChangeOwner["chooseLayer"], "CCLayer")
        local touchLocation = chooseLayer:convertToNodeSpace(ccp(x, y))
        local rect = chooseLayer:boundingBox()
        rect = CCRectMake(0, 0, rect.size.width, rect.size.height)
        if rect:containsPoint(touchLocation) then
            _touchPos = {x = x, y = y}
            return true
        end
        return false
    end

    local function onTouchEnded(x, y)
        if math.abs(x - _touchPos.x) > 50 * retina then
            local index = _current % 3 + math.floor(x - _touchPos.x) / math.abs(math.floor(x - _touchPos.x))
            index = index > 0 and index or index + 3
            chooseGroup(index)
            return
        end
        local chooseLayer = tolua.cast(WWGroupChangeOwner["chooseLayer"], "CCLayer")
        for i=1,3 do
            local badge = tolua.cast(WWGroupChangeOwner["badge"..i], "CCSprite")
            local touchLocation = chooseLayer:convertToNodeSpace(ccp(x, y))
            local rect = badge:boundingBox()
            if rect:containsPoint(touchLocation) then
                chooseGroup(badge:getTag())
                break
            end
        end

    end

    local function onTouch(eventType, x, y)
        if eventType == "began" then   
            return onTouchBegan(x, y)
        elseif eventType == "moved" then
        elseif eventType == "ended" then
            return onTouchEnded(x, y)
        end
    end

    local chooseLayer = tolua.cast(WWGroupChangeOwner["chooseLayer"], "CCLayer")
    chooseLayer:registerScriptTouchHandler(onTouch)
    chooseLayer:setTouchEnabled(true)
end

local function refreshTime()
    local tips = tolua.cast(WWGroupChangeOwner["tips"], "CCLabelTTF")
    local cd = worldwardata:getChangeGroupCD()
    if cd == 0 then
        tips:setString(HLNSLocalizedString("ww.group.change.tips.1"))
    else
        tips:setString(HLNSLocalizedString("ww.group.change.tips.2", DateUtil:second2hms(cd)))
    end
end

local function refresh()
    refreshTime()
    changeText()
    addTableView()
end

local function groupChangeClick()
    local cd = worldwardata:getChangeGroupCD()
    if cd > 0 then
        ShowText(HLNSLocalizedString("ww.change.cd"))
        return
    end
    getMainLayer():getParent():addChild(createWWGroupChangePopupLayer(string.format("camp_%02d", _current), -133))
end
WWGroupChangeOwner["groupChangeClick"] = groupChangeClick

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/WWGroupChangeView.ccbi",proxy, true,"WWGroupChangeOwner")
    _layer = tolua.cast(node,"CCLayer")

    for i=1,3 do
        local badge = tolua.cast(WWGroupChangeOwner["badge"..i], "CCSprite")
        table.insert(_badgePos, {x = badge:getPositionX(), y = badge:getPositionY()})
    end
    
    _current = 0
    chooseGroup(tonumber(string.split(worldwardata.playerData.countryId, "_")[2]))
    addChooseTouch()
    refresh()
end

-- 该方法名字每个文件不要重复
function getWWGroupChangeLayer()
	return _layer
end

function createWWGroupChangeLayer()
    _init()

    local function _onEnter()
        addObserver(NOTI_TICK, refreshTime)
        addObserver(NOTI_WW_REFRESH, refresh)
    end

    local function _onExit()
        removeObserver(NOTI_TICK, refreshTime)
        removeObserver(NOTI_WW_REFRESH, refresh)
        _layer = nil
        _current = 1
        _bAni = false
        _badgePos = {}
        helpHeightArray = {}
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