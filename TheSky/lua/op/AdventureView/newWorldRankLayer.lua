local _layer
local _currentTag = 0
local tableView
local _priority = -134
local _rankInfo

-- 名字不要重复
NewWorldRankViewOwner = NewWorldRankViewOwner or {}
ccb["NewWorldRankViewOwner"] = NewWorldRankViewOwner


local function closeItemClick()
    _layer:removeFromParentAndCleanup(true)
end
NewWorldRankViewOwner["closeItemClick"] = closeItemClick

local function addTableView(dic)
    if not dic or table.getTableCount(dic) <= 0 then
        return
    end
    -- @param fn string Callback type
    -- @param table LuaTableView
    -- @param a1 & a2 mixed Difference means for every "fn"
    local h = LuaEventHandler:create(function(fn, t, a1, a2)
        local r
        if fn == "cellSize" then
            local sp = CCSprite:createWithSpriteFrameName("frame_0.png")
            r = CCSizeMake(winSize.width / retina, 170)
        elseif fn == "cellAtIndex" then
            -- Return CCTableViewCell, a1 is cell index (zero based), a2 is dequeued cell (maybe nil)
            -- Do something to create cell and change the content
            newWorldRankCellOwner = newWorldRankCellOwner or {}
            ccb["newWorldRankCellOwner"] = newWorldRankCellOwner

            local function viewBattleInfo(url, rtnData)
                playerBattleData:fromDic(rtnData.info)
                -- getMainLayer():getParent():addChild(createTeamCompLayer(userdata:getUserBattleInfo(), playerBattleData), 100)
                getMainLayer():getParent():addChild(createTeamPopupLayer(-140))
                _layer:removeFromParentAndCleanup(true)
            end

            local function playerFormItemClick(tag)
                local id = tonumber(dic[tostring(tag - 1)].id)
                doActionFun("ARENA_GET_BATTLE_INFO", {id}, viewBattleInfo)
            end
            newWorldRankCellOwner["playerFormItemClick"] = playerFormItemClick

            local function setCellMenuPriority(sender)
                if sender then
                    local menu = tolua.cast(sender, "CCMenu")
                    menu:setHandlerPriority(_priority - 1)
                end
            end

            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            local proxy = CCBProxy:create()
            local _hbCell = tolua.cast(CCBReaderLoad("ccbResources/newWorldRankCell.ccbi",proxy,true,"newWorldRankCellOwner"),"CCSprite")
            _hbCell:setAnchorPoint(ccp(0.5, 0.5))
            local contentLayer = NewWorldRankViewOwner["contentLayer"]
            _hbCell:setPosition(contentLayer:getContentSize().width / 2, 170 / 2)
            a2:addChild(_hbCell, 0, 1)
            local playerFormItem = newWorldRankCellOwner["playerFormItem"]
            playerFormItem:setTag(a1 + 1)
            local menu = newWorldRankCellOwner["menu"]
            local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCCallFuncN:create(setCellMenuPriority))
            menu:runAction(seq)

            local rankLabel = tolua.cast(newWorldRankCellOwner["rankLabel"], "CCLabelTTF")
            rankLabel:setString(tostring(a1 + 1))

            local rankInfo = dic[tostring(a1)]

-- {"5":[],"6":[],"7":[],"8":[{"id":"8","name":"name524563","level":50,"bestOutpostNum":"1","bestRecord":3,"succession":0}],"id":"2013-10-03"}
            local nameLabel = tolua.cast(newWorldRankCellOwner["nameLabel"], "CCLabelTTF")
            nameLabel:setString(rankInfo.name)
            local stageLabel = tolua.cast(newWorldRankCellOwner["stageLabel"], "CCLabelTTF")
            stageLabel:setString(tostring(rankInfo.bestOutpostNum))
            local lainxuLabel = tolua.cast(newWorldRankCellOwner["lainxuLabel"], "CCLabelTTF")
            if rankInfo.succession == 0 then
                lainxuLabel:setVisible(false)
            else
                lainxuLabel:setString(string.format(lainxuLabel:getString(), rankInfo.succession))
            end
            local levelLabel = tolua.cast(newWorldRankCellOwner["levelLabel"], "CCLabelTTF")
            levelLabel:setString(string.format(levelLabel:getString(), rankInfo.level))
            local starLabel = tolua.cast(newWorldRankCellOwner["starLabel"], "CCLabelTTF")
            starLabel:setString(string.format(starLabel:getString(), rankInfo.bestRecord))

            local id = tonumber(rankInfo.id)
            if id == userdata.userId then
                local playerFormText = tolua.cast(newWorldRankCellOwner["playerFormText"], "CCSprite")
                playerFormText:setVisible(false)
                local playerFormItem = tolua.cast(newWorldRankCellOwner["playerFormItem"], "CCMenuItemImage")
                playerFormItem:setVisible(false)
            end
            
            r = a2
        elseif fn == "numberOfCells" then
            r = table.getTableCount(dic)
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
    local contentLayer = NewWorldRankViewOwner["contentLayer"]
    tableView = LuaTableView:createWithHandler(h, contentLayer:getContentSize())
    tableView:setBounceable(true)
    tableView:setAnchorPoint(ccp(0, 0))
    tableView:setPosition(ccp(0, 0))
    tableView:setVerticalFillOrder(0)
    contentLayer:addChild(tableView, 10, 10)
end

local function setMenuPriority()
    local menu = tolua.cast(NewWorldRankViewOwner["menu"], "CCMenu")
    menu:setHandlerPriority(_priority - 1)
    if tableView then
        tableView:setTouchPriority(_priority - 1)
    end
end

local function _changeRank(index)
    local dic = _rankInfo[tostring(index + 4)]
    if NewWorldRankViewOwner["tab".._currentTag] then
        local item = tolua.cast(NewWorldRankViewOwner["tab".._currentTag], "CCMenuItemImage")
        item:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_0.png"))
    end
    _currentTag = index
    if NewWorldRankViewOwner["tab".._currentTag] then
        item = tolua.cast(NewWorldRankViewOwner["tab".._currentTag], "CCMenuItemImage")
        item:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_1.png"))
    end
    if tableView then
        tableView:removeFromParentAndCleanup(true)
        tableView = nil
    end
    addTableView(dic)
    local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCCallFunc:create(setMenuPriority))
    _layer:runAction(seq)

    local rankTitleLabel = tolua.cast(NewWorldRankViewOwner["rankTitleLabel"], "CCLabelTTF")
    local rankLabel = tolua.cast(NewWorldRankViewOwner["rankLabel"], "CCLabelTTF")
    local todayTitleLabel = tolua.cast(NewWorldRankViewOwner["todayTitleLabel"], "CCLabelTTF")
    local todayLabel = tolua.cast(NewWorldRankViewOwner["todayLabel"], "CCLabelTTF")

    if index ~= userdata:getFormMax() - 4 then
        rankTitleLabel:setVisible(false)
        rankLabel:setVisible(false)
        todayTitleLabel:setVisible(false)
        todayLabel:setVisible(false)
    else
        rankTitleLabel:setVisible(true)
        rankLabel:setVisible(true)
        todayTitleLabel:setVisible(true)
        todayLabel:setVisible(true)
        local rank = -1
        if dic then
            for k,v in pairs(dic) do
                if tonumber(v.id) == userdata.userId then
                    rank = tonumber(k) + 1
                    break
                end
            end
        end
        if rank > 0 then
            rankLabel:setString(tostring(rank))
        else
            rankLabel:setString(HLNSLocalizedString("newworld.outofrank"))
        end
        if not blooddata.data.todayRank or blooddata.data.todayRank == "" then
            todayLabel:setString(HLNSLocalizedString("newworld.outofrank"))
        else
            todayLabel:setString(tostring(blooddata.data.todayRank))
        end
    end
end

local function formItemClick(tag)
    if tag == _currentTag then
        return
    end
    _changeRank(tag)
end
NewWorldRankViewOwner["formItemClick"] = formItemClick

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/NewWorldRankView.ccbi", proxy, true,"NewWorldRankViewOwner")
    _layer = tolua.cast(node,"CCLayer")
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(NewWorldRankViewOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        _layer:removeFromParentAndCleanup(true)
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


-- 该方法名字每个文件不要重复
function getNewWorldRankLayer()
	return _layer
end

local function rankInfoCallback(url, rtnData)
    _rankInfo = rtnData.info.yesterdayRankInfo
    _currentTag = userdata:getFormMax() - 4
    _changeRank(_currentTag)
end

function createNewWorldRankLayer(priority)
    _init()
    _priority = priority ~= nil and priority or -134

    local function _onEnter()
        print("onEnter")
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
        doActionFun("NEWWORLD_RANKINFO", {}, rankInfoCallback)
        -- _currentTag = 1
        -- _changeRank(_currentTag)
    end

    local function _onExit()
        print("onExit")
        _layer = nil
        _currentTag = 0
        tableView = nil
        _priority = -134
        _rankInfo = nil
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