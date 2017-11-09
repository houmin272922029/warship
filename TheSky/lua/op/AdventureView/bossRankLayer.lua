local _layer
local tableView
local _rankArray
local _priority = -134

-- 名字不要重复
BossRankViewOwner = BossRankViewOwner or {}
ccb["BossRankViewOwner"] = BossRankViewOwner


local function closeItemClick()
    _layer:removeFromParentAndCleanup(true)
end
BossRankViewOwner["closeItemClick"] = closeItemClick

local function addTableView()
    -- @param fn string Callback type
    -- @param table LuaTableView
    -- @param a1 & a2 mixed Difference means for every "fn"
    local h = LuaEventHandler:create(function(fn, t, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(winSize.width / retina, 170)
        elseif fn == "cellAtIndex" then
            -- Return CCTableViewCell, a1 is cell index (zero based), a2 is dequeued cell (maybe nil)
            -- Do something to create cell and change the content
            BossRankCellOwner = BossRankCellOwner or {}
            ccb["BossRankCellOwner"] = BossRankCellOwner
            BossDefeatCellOwner = BossDefeatCellOwner or {}
            ccb["BossDefeatCellOwner"] = BossDefeatCellOwner

            local function viewBattleInfo(url, rtnData)
                playerBattleData:fromDic(rtnData.info)
                -- getMainLayer():getParent():addChild(createTeamCompLayer(userdata:getUserBattleInfo(), playerBattleData), 100)
                getMainLayer():getParent():addChild(createTeamPopupLayer(-140))
                _layer:removeFromParentAndCleanup(true)
            end

            local function playerFormItemClick(tag)
                local id = tonumber(_rankArray[tag].id)
                doActionFun("ARENA_GET_BATTLE_INFO", {id}, viewBattleInfo)
            end
            BossRankCellOwner["playerFormItemClick"] = playerFormItemClick
            BossDefeatCellOwner["playerFormItemClick"] = playerFormItemClick

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
            local _cell
            local owner
            local dic = _rankArray[a1 + 1]
            if dic["type"] == 0 then
                _cell = tolua.cast(CCBReaderLoad("ccbResources/BossDefeatCell.ccbi",proxy,true,"BossDefeatCellOwner"),"CCSprite")
                owner = BossDefeatCellOwner
            else
                _cell = tolua.cast(CCBReaderLoad("ccbResources/BossRankCell.ccbi",proxy,true,"BossRankCellOwner"),"CCSprite")
                owner = BossRankCellOwner
                local rankLabel = tolua.cast(owner["rankLabel"], "CCLabelTTF")
                rankLabel:setString(dic["rank"])
            end
            _cell:setAnchorPoint(ccp(0.5, 0.5))
            local contentLayer = BossRankViewOwner["contentLayer"]
            _cell:setPosition(contentLayer:getContentSize().width / 2, 170 / 2)
            a2:addChild(_cell, 0, 1)
            local playerFormItem = owner["playerFormItem"]
            playerFormItem:setTag(a1 + 1)
            local menu = owner["menu"]
            local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCCallFuncN:create(setCellMenuPriority))
            menu:runAction(seq)

            local nameLabel = tolua.cast(owner["nameLabel"], "CCLabelTTF")
            nameLabel:setString(dic.name)
            local levelLabel = tolua.cast(owner["levelLabel"], "CCLabelTTF")
            local level = 0
            if dic.level then
                level = dic.level
            end
            levelLabel:setString(string.format(levelLabel:getString(), level))
            local damageLabel = tolua.cast(owner["damageLabel"], "CCLabelTTF")
            damageLabel:setString(string.format(damageLabel:getString(), dic.damageAll))

            local id = tonumber(dic.id)
            if id == userdata.userId then
                local playerFormText = tolua.cast(owner["playerFormText"], "CCSprite")
                playerFormText:setVisible(false)
                local playerFormItem = tolua.cast(owner["playerFormItem"], "CCMenuItemImage")
                playerFormItem:setVisible(false)
            end
            
            r = a2
        elseif fn == "numberOfCells" then
            r = #_rankArray
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
    local contentLayer = BossRankViewOwner["contentLayer"]
    tableView = LuaTableView:createWithHandler(h, contentLayer:getContentSize())
    tableView:setBounceable(true)
    tableView:setAnchorPoint(ccp(0, 0))
    tableView:setPosition(ccp(0, 0))
    tableView:setVerticalFillOrder(0)
    contentLayer:addChild(tableView, 10, 10)
    tableView:reloadData()
end

local function setMenuPriority()
    local menu = tolua.cast(BossRankViewOwner["menu"], "CCMenu")
    menu:setHandlerPriority(_priority - 1)
    if tableView then
        tableView:setTouchPriority(_priority - 1)
    end
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/BossRankView.ccbi", proxy, true,"BossRankViewOwner")
    _layer = tolua.cast(node,"CCLayer")
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(BossRankViewOwner["infoBg"], "CCSprite")
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
function getBossRankLayer()
	return _layer
end

function createBossRankLayer(priority)
    _init()
    _priority = priority ~= nil and priority or -134

    local function _onEnter()
        print("onEnter")
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
        _rankArray = bossdata:getRank()
        addTableView()
    end

    local function _onExit()
        print("onExit")
        _layer = nil
        tableView = nil
        _priority = -134
        _rankArray = nil
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