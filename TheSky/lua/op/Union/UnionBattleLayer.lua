local _layer
local viewType
local ViewType = {
    AttackSelect = 1,   -- 战斗选择
    DefendSelect = 2,   -- 防御选择
    LogSelect = 3,      -- 宿敌
    Attack = 4,         -- 战斗界面
    Defend = 5,         -- 防御界面
    EnemySelect = 6,    -- 选择打谁
    ArmySelect = 7,     -- 部属
}
local _tableView
local _attackInfoList -- 攻击列表
local _defendInfoList -- 防御列表
local _logInfoList -- 宿敌列表
local _enemyList      -- 宣战列表
local _attackBattleInfo -- 盟战攻击数据
local _defendBattleInfo -- 盟战防御数据
local _battleType
local BattleType = {
    attack = 1,
    defend = 2,
}
local bFight = false

local defendFortsCopy -- 防御部属备份

local defendInBattle -- 防御是否开战中

local _selectFort

UnionBattleLayerOwner = UnionBattleLayerOwner or {}
ccb["UnionBattleLayerOwner"] = UnionBattleLayerOwner

UnionBattleSelectCellOwner = UnionBattleSelectCellOwner or {}
ccb["UnionBattleSelectCellOwner"] = UnionBattleSelectCellOwner

UnionEnemySelectCellOwner = UnionEnemySelectCellOwner or {}
ccb["UnionEnemySelectCellOwner"] = UnionEnemySelectCellOwner

UnionBattleCounterCellOwner = UnionBattleCounterCellOwner or {}
ccb["UnionBattleCounterCellOwner"] = UnionBattleCounterCellOwner

local function onExitTaped()
    viewType = ViewType.AttackSelect
    getUnionMainLayer():gotoShowInner()
end
UnionBattleLayerOwner["onExitTaped"] = onExitTaped


local function defendFixClick()
    getMainLayer():getParent():addChild(createUnionBattleFixCard())
end
UnionBattleLayerOwner["defendFixClick"] = defendFixClick

local function _refreshLogInfo()
    local _topLayer = UnionBattleLayerOwner["BSTopLayer"]
    local titleBg = UnionBattleLayerOwner["titleBg"]

    -- @param fn string Callback type
    -- @param table LuaTableView
    -- @param a1 & a2 mixed Difference means for every "fn"
    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(winSize.width, 152 * retina)
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
            _hbCell  = tolua.cast(CCBReaderLoad("ccbResources/UnionBattleCounterCell.ccbi",proxy,true,"UnionBattleCounterCellOwner"),"CCLayer")

            local dic = _logInfoList[a1 + 1]

            local unionName = tolua.cast(UnionBattleCounterCellOwner["unionName"], "CCLabelTTF")
            unionName:setString(dic.leagueName)
            local level = tolua.cast(UnionBattleCounterCellOwner["level"], "CCLabelTTF")
            level:setString(dic.leagueLevel)
            local creator = tolua.cast(UnionBattleCounterCellOwner["creator"], "CCLabelTTF")
            creator:setString(dic.ceoName)
            local memberCount = tolua.cast(UnionBattleCounterCellOwner["memberCount"], "CCLabelTTF")
            memberCount:setString(string.format("%d/%d", dic.memberCount, dic.memberMax))
            local date = tolua.cast(UnionBattleCounterCellOwner["date"], "CCLabelTTF")
            date:setString(DateUtil:formatTime(dic.time))

            local counterItem = tolua.cast(UnionBattleCounterCellOwner["counterItem"], "CCMenuItemImage")
            counterItem:setTag(a1 + 1)
            local battleText = tolua.cast(UnionBattleCounterCellOwner["battleText"], "CCSprite")


            _hbCell:setScale(retina)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            a2:addChild(_hbCell, 0, 1)
            r = a2
        elseif fn == "numberOfCells" then
            -- Return number of cells
            r = #_logInfoList
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
        local size = CCSizeMake(winSize.width, (winSize.height - _topLayer:getContentSize().height 
                - titleBg:getContentSize().height * retina - _mainLayer:getBottomContentSize().height))      -- 这里是为了在tableview上面显示一个小空出来
        _tableView = LuaTableView:createWithHandler(h, size)
        _tableView:setBounceable(true)
        _tableView:setAnchorPoint(ccp(0,0))
        _tableView:setPosition(ccp(0, _mainLayer:getBottomContentSize().height))
        _tableView:setVerticalFillOrder(0)
        _layer:addChild(_tableView) 
    end
end

-- 刷新防御列表
local function _refreshDefendInfo()
    local _topLayer = UnionBattleLayerOwner["BSTopLayer"]
    local titleBg = UnionBattleLayerOwner["titleBg"]

    -- @param fn string Callback type
    -- @param table LuaTableView
    -- @param a1 & a2 mixed Difference means for every "fn"
    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(winSize.width, 152 * retina)
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
            _hbCell  = tolua.cast(CCBReaderLoad("ccbResources/UnionBattleSelectCell.ccbi",proxy,true,"UnionBattleSelectCellOwner"),"CCLayer")

            local battleIcon = tolua.cast(UnionBattleSelectCellOwner["battleIcon"], "CCSprite")
            local battleType = tolua.cast(UnionBattleSelectCellOwner["battleType"], "CCSprite")
            local desp = tolua.cast(UnionBattleSelectCellOwner["desp"], "CCLabelTTF")
            local battleText = tolua.cast(UnionBattleSelectCellOwner["battleText"], "CCSprite")
            local battleItem = tolua.cast(UnionBattleSelectCellOwner["battleItem"], "CCMenuItemImage")

            battleItem:setTag(a1 + 1)
            local dic = _defendInfoList[a1 + 1]
            if dic.key == "leagueBattle" then
                -- 盟战
                battleIcon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("battle_1.png"))
                battleType:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("mengzhan_text.png"))
                desp:setString(dic.desp)
                if not dic.battleInfoId or dic.battleInfoId == "" then
                    -- 未开战 查看
                    battleText:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("chakan_text.png"))
                else
                    battleText:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("canzhan_text.png"))
                end
            end

            _hbCell:setScale(retina)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            a2:addChild(_hbCell, 0, 1)
            r = a2
        elseif fn == "numberOfCells" then
            -- Return number of cells
            r = #_defendInfoList
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
        local size = CCSizeMake(winSize.width, (winSize.height - _topLayer:getContentSize().height 
                - titleBg:getContentSize().height * retina - _mainLayer:getBottomContentSize().height))      -- 这里是为了在tableview上面显示一个小空出来
        _tableView = LuaTableView:createWithHandler(h, size)
        _tableView:setBounceable(true)
        _tableView:setAnchorPoint(ccp(0,0))
        _tableView:setPosition(ccp(0, _mainLayer:getBottomContentSize().height))
        _tableView:setVerticalFillOrder(0)
        _layer:addChild(_tableView) 
    end
end

-- 刷新进攻列表
local function _refreshAttackInfo()
    local _topLayer = UnionBattleLayerOwner["BSTopLayer"]
    local titleBg = UnionBattleLayerOwner["titleBg"]

    -- @param fn string Callback type
    -- @param table LuaTableView
    -- @param a1 & a2 mixed Difference means for every "fn"
    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(winSize.width, 152 * retina)
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
            _hbCell  = tolua.cast(CCBReaderLoad("ccbResources/UnionBattleSelectCell.ccbi",proxy,true,"UnionBattleSelectCellOwner"),"CCLayer")

            local battleIcon = tolua.cast(UnionBattleSelectCellOwner["battleIcon"], "CCSprite")
            local battleType = tolua.cast(UnionBattleSelectCellOwner["battleType"], "CCSprite")
            local desp = tolua.cast(UnionBattleSelectCellOwner["desp"], "CCLabelTTF")
            local battleText = tolua.cast(UnionBattleSelectCellOwner["battleText"], "CCSprite")
            local battleItem = tolua.cast(UnionBattleSelectCellOwner["battleItem"], "CCMenuItemImage")

            battleItem:setTag(a1 + 1)
            local dic = _attackInfoList[a1 + 1]
            if dic.key == "leagueBattle" then
                -- 盟战
                battleIcon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("battle_1.png"))
                battleType:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("mengzhan_text.png"))
                desp:setString(dic.desp)
                if not unionData:isCreator() or (dic.battleInfoId and dic.battleInfoId ~= "") then
                    -- 非盟主或者已开战替换为 参战
                    battleText:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("canzhan_text.png"))
                end
            end

            _hbCell:setScale(retina)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            a2:addChild(_hbCell, 0, 1)
            r = a2
        elseif fn == "numberOfCells" then
            -- Return number of cells
            r = #_attackInfoList
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
        local size = CCSizeMake(winSize.width, (winSize.height - _topLayer:getContentSize().height 
                - titleBg:getContentSize().height * retina - _mainLayer:getBottomContentSize().height))      -- 这里是为了在tableview上面显示一个小空出来
        _tableView = LuaTableView:createWithHandler(h, size)
        _tableView:setBounceable(true)
        _tableView:setAnchorPoint(ccp(0,0))
        _tableView:setPosition(ccp(0, _mainLayer:getBottomContentSize().height))
        _tableView:setVerticalFillOrder(0)
        _layer:addChild(_tableView) 
    end
end

-- 宣战联盟
local function _refreshEnemySelect()
     local _topLayer = UnionBattleLayerOwner["BSTopLayer"]

    -- @param fn string Callback type
    -- @param table LuaTableView
    -- @param a1 & a2 mixed Difference means for every "fn"
    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(winSize.width, 152 * retina)
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
            _hbCell  = tolua.cast(CCBReaderLoad("ccbResources/UnionEnemySelectCell.ccbi",proxy,true,"UnionEnemySelectCellOwner"),"CCLayer")

            local enemyItem = tolua.cast(UnionEnemySelectCellOwner["enemyItem"], "CCMenuItemImage")
            enemyItem:setTag(a1 + 1)
            local dic = _enemyList[a1 + 1]

            local unionLevel = tolua.cast(UnionEnemySelectCellOwner["unionLevel"], "CCLabelTTF")
            unionLevel:setString(dic.level)
            local unionName = tolua.cast(UnionEnemySelectCellOwner["unionName"], "CCLabelTTF")
            unionName:setString(dic.name)
            local creator = tolua.cast(UnionEnemySelectCellOwner["creator"], "CCLabelTTF")
            if dic.ceoVipLevel and dic.ceoVipLevel > 0 then
                creator:setString(string.format("%s(V%d)", dic.ceoName, dic.ceoVipLevel))
            else
                creator:setString(dic.ceoName)
            end
            local member = tolua.cast(UnionEnemySelectCellOwner["member"], "CCLabelTTF")
            member:setString(dic.membersCount)
            local candy = tolua.cast(UnionEnemySelectCellOwner["candy"], "CCLabelTTF")
            candy:setString(dic.sweetCount)

            _hbCell:setScale(retina)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            a2:addChild(_hbCell, 0, 1)
            r = a2
        elseif fn == "numberOfCells" then
            -- Return number of cells
            r = #_enemyList
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
        local size = CCSizeMake(winSize.width, (winSize.height - _topLayer:getContentSize().height 
                 - _mainLayer:getBottomContentSize().height) * 99 / 100)      -- 这里是为了在tableview上面显示一个小空出来
        _tableView = LuaTableView:createWithHandler(h, size)
        _tableView:setBounceable(true)
        _tableView:setAnchorPoint(ccp(0,0))
        _tableView:setPosition(ccp(0, _mainLayer:getBottomContentSize().height))
        _tableView:setVerticalFillOrder(0)
        _layer:addChild(_tableView) 
    end
end

-- 刷新进攻界面的ui
local function _refreshAttackLayer()
    for i=1,5 do
        local fortId = string.format("fort_%02d", i)
        local fortDic = _attackBattleInfo.forts[fortId]
        for j=0, 1 do
            local attack_loss = tolua.cast(UnionBattleLayerOwner[string.format("attack_loss_%d_%d", i, j)], "CCLabelTTF") 
            if fortDic.durability then
                attack_loss:setString(string.format("%d%%", fortDic.durability))
            else
                attack_loss:setString(string.format("%d%%", 100))
            end
        end    
        local attack_defend = tolua.cast(UnionBattleLayerOwner[string.format("attack_defend_%d", i)], "CCLabelTTF")
        if fortDic.playerName and fortDic.playerName ~= "" then
            attack_defend:setVisible(true)
            if fortDic.leagueId and fortDic.leagueId == _attackBattleInfo.attackId then
                attack_defend:setString(fortDic.playerName)
            else
                attack_defend:setString("?????")
            end
        else
            attack_defend:setVisible(false)
        end
        local attack_price = tolua.cast(UnionBattleLayerOwner[string.format("attack_price_%d", i)], "CCLabelTTF")
        if fortDic.playerId and fortDic.playerId ~= "" then
            attack_price:setVisible(true)
            -- attack_price:setString(fortDic.worth)
            attack_price:setString("?????")
        else
            attack_price:setVisible(false)
        end
        local attack_capture = tolua.cast(UnionBattleLayerOwner[string.format("attack_capture_%d", i)], "CCSprite")
        attack_capture:setVisible(fortDic.leagueId and fortDic.leagueId == _attackBattleInfo.attackId)
    end 
end

-- 刷新战斗中防御界面 ui
local function _refreshDefendLayerInBattle()
    for i=1,5 do
        local fortId = string.format("fort_%02d", i)
        local fortDic = _defendBattleInfo.forts[fortId]
        for j=0, 1 do
            local defend_loss = tolua.cast(UnionBattleLayerOwner[string.format("defend_loss_%d_%d", i, j)], "CCLabelTTF") 
            defend_loss:setString(string.format("%d%%", fortDic.durability))
        end    
        local defend_defend = tolua.cast(UnionBattleLayerOwner[string.format("defend_defend_%d", i)], "CCLabelTTF")
        if fortDic.playerName and fortDic.playerName ~= "" then
            defend_defend:setVisible(true)
            defend_defend:setString(fortDic.playerName)
        else
            defend_defend:setVisible(false)
        end
        local defend_price = tolua.cast(UnionBattleLayerOwner[string.format("defend_price_%d", i)], "CCLabelTTF")
        if fortDic.playerId and fortDic.playerId ~= "" then
            defend_price:setVisible(true)
            -- defend_price:setString(fortDic.worth)
            defend_price:setString("?????")
        else
            defend_price:setVisible(false)
        end
        local defend_capture = tolua.cast(UnionBattleLayerOwner[string.format("defend_capture_%d", i)], "CCSprite")
        defend_capture:setVisible(fortDic.leagueId and tonumber(fortDic.leagueId) == tonumber(_defendBattleInfo.attackId))
    end
    local defendRefresh = tolua.cast(UnionBattleLayerOwner["defendRefresh"], "CCMenuItemImage")
    defendRefresh:setVisible(true)
    local defendFix = tolua.cast(UnionBattleLayerOwner["defendFix"], "CCMenuItemImage")
    defendFix:setVisible(false)
    local defendRefreshText = tolua.cast(UnionBattleLayerOwner["defendRefreshText"], "CCSprite")
    defendRefreshText:setVisible(true)
    local fixText = tolua.cast(UnionBattleLayerOwner["fixText"], "CCSprite")
    fixText:setVisible(false)
end

-- 刷新非战斗中防御界面 ui
local function _refreshDefendLayer()
    local needFix = false
    for i=1,5 do
        local defendFont = tolua.cast(UnionBattleLayerOwner["defendFont"..i], "CCMenuItemImage")
        defendFont:setEnabled(unionData:isCreator())
        local fortId = string.format("fort_%02d", i)
        local fortDic = defendFortsCopy[fortId]
        if fortDic.durability < 100 then
            needFix = true
        end
        for j=0,1 do
            local defend_loss = tolua.cast(UnionBattleLayerOwner[string.format("defend_loss_%d_%d", i, j)], "CCLabelTTF") 
            defend_loss:setString(string.format("%d%%", fortDic.durability))
        end
        local defend_defend = tolua.cast(UnionBattleLayerOwner[string.format("defend_defend_%d", i)], "CCLabelTTF")
        if fortDic.playerName and fortDic.playerName ~= "" then
            defend_defend:setVisible(true)
            defend_defend:setString(fortDic.playerName)
        else
            defend_defend:setVisible(false)
        end
        local defend_price = tolua.cast(UnionBattleLayerOwner[string.format("defend_price_%d", i)], "CCLabelTTF")
        if fortDic.playerId and fortDic.playerId ~= "" then
            defend_price:setVisible(true)
            -- defend_price:setString(fortDic.worth)
            defend_price:setString("?????")
        else
            defend_price:setVisible(false)
        end
        local defend_capture = tolua.cast(UnionBattleLayerOwner[string.format("defend_capture_%d", i)], "CCSprite")
        defend_capture:setVisible(false)
    end
    local defendRefresh = tolua.cast(UnionBattleLayerOwner["defendRefresh"], "CCMenuItemImage")
    defendRefresh:setVisible(false)
    local defendFix = tolua.cast(UnionBattleLayerOwner["defendFix"], "CCMenuItemImage")
    defendFix:setVisible(unionData:isCreator() and needFix)
    local defendRefreshText = tolua.cast(UnionBattleLayerOwner["defendRefreshText"], "CCSprite")
    defendRefreshText:setVisible(false)
    local fixText = tolua.cast(UnionBattleLayerOwner["fixText"], "CCSprite")
    fixText:setVisible(unionData:isCreator() and needFix)
    local flag = false
    for k,v in pairs(defendFortsCopy) do
        if v.playerId ~= unionData.forts[k].playerId then
            flag = true
            break
        end
    end
    local defendSave = tolua.cast(UnionBattleLayerOwner["defendSave"], "CCMenuItemImage")
    defendSave:setVisible(flag)
    local saveText = tolua.cast(UnionBattleLayerOwner["saveText"], "CCMenuItemImage")
    saveText:setVisible(flag)
end

-- 成功获取进攻界面数据
local function attackInfoCallback(url, rtnData)
    _attackInfoList = {}
    local warAttack = rtnData.info.warAttack
    if warAttack then
        local function sortFun(a, b)
            return a.sort < b.sort
        end
        for k,v in pairs(warAttack) do
            local dic = deepcopy(v)
            dic.key = k
            table.insert(_attackInfoList, dic)
        end
        table.sort( _attackInfoList, sortFun )
        _refreshAttackInfo()
    end
end

-- 成功获取防御界面数据
local function defendInfoCallback(url, rtnData)
    _defendInfoList = {}
    local warDefend = rtnData.info.warDefend
    if warDefend then
        local function sortFun(a, b)
            return a.sort < b.sort
        end
        for k,v in pairs(warDefend) do
            local dic = deepcopy(v)
            dic.key = k
            table.insert(_defendInfoList, dic)
        end
        table.sort(_defendInfoList, sortFun)
        _refreshDefendInfo()
    end
end

local function logInfoCallback(url, rtnData)
    _logInfoList = {}
    local function sortFun(a, b)
        return a.time > b.time 
    end
    for k,v in pairs(rtnData.info) do
        local dic = deepcopy(v) 
        table.insert(_logInfoList, dic)
    end
    if #_logInfoList > 0 then
        table.sort(_logInfoList, sortFun)
        _refreshLogInfo()
    end
end

local function _changeTab()
    for i=1,3 do
        local item = tolua.cast(UnionBattleLayerOwner["tabBtn"..i], "CCMenuItemImage")
        item:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_0.png"))
    end 
    if viewType == ViewType.AttackSelect or viewType == ViewType.Attack or viewType == ViewType.EnemySelect then
        local item = tolua.cast(UnionBattleLayerOwner["tabBtn1"], "CCMenuItemImage")
        item:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_1.png"))
    elseif viewType == ViewType.DefendSelect or viewType == ViewType.Defend then
        local item = tolua.cast(UnionBattleLayerOwner["tabBtn2"], "CCMenuItemImage")
        item:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_1.png"))
    else
        local item = tolua.cast(UnionBattleLayerOwner["tabBtn3"], "CCMenuItemImage")
        item:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_1.png"))
    end
end

-- 刷新页面
local function _refreshLayer()
    _changeTab()
    if _tableView then
        _tableView:removeFromParentAndCleanup(true)
        _tableView = nil
    end
    local titleBg = tolua.cast(UnionBattleLayerOwner["titleBg"], "CCLayer")
    local attackLayer = tolua.cast(UnionBattleLayerOwner["attackLayer"], "CCLayer")
    local defendLayer = tolua.cast(UnionBattleLayerOwner["defendLayer"], "CCLayer")
    local attackMenu = tolua.cast(UnionBattleLayerOwner["attackMenu"], "CCMenu")
    local defendMenu = tolua.cast(UnionBattleLayerOwner["defendMenu"], "CCMenu")
    local helpItem = tolua.cast(UnionBattleLayerOwner["helpItem"], "CCMenuItemImage")
    if viewType == ViewType.AttackSelect then
        titleBg:setVisible(true)
        attackLayer:setVisible(false)
        defendLayer:setVisible(false)
        attackMenu:setVisible(false)
        defendMenu:setVisible(false)
        helpItem:setVisible(true)
        doActionFun("LEAGUE_ATTACK_INFO", {}, attackInfoCallback)
    elseif viewType == ViewType.DefendSelect then
        titleBg:setVisible(true)
        attackLayer:setVisible(false)
        defendLayer:setVisible(false)
        attackMenu:setVisible(false)
        defendMenu:setVisible(false)
        helpItem:setVisible(true)
        doActionFun("LEAGUE_DEFEND_INFO", {}, defendInfoCallback)
    elseif viewType == ViewType.LogSelect then
        titleBg:setVisible(true)
        attackLayer:setVisible(false)
        defendLayer:setVisible(false)
        attackMenu:setVisible(false)
        defendMenu:setVisible(false)
        helpItem:setVisible(true)
        doActionFun("LEAGUE_BATTLE_ENEMY_INFO", {}, logInfoCallback)
    elseif viewType == ViewType.Attack then
        titleBg:setVisible(false)
        attackLayer:setVisible(true)
        defendLayer:setVisible(false)
        attackMenu:setVisible(true)
        defendMenu:setVisible(false)
        helpItem:setVisible(false)
        _refreshAttackLayer()
    elseif viewType == ViewType.Defend then
        titleBg:setVisible(false)
        attackLayer:setVisible(false)
        defendLayer:setVisible(true)
        attackMenu:setVisible(false)
        defendMenu:setVisible(true)
        helpItem:setVisible(false)
        if defendInBattle then
            -- 防御战
            _refreshDefendLayerInBattle()
        else
            -- 查看
            defendFortsCopy = deepcopy(unionData.forts)
            _refreshDefendLayer()
        end
    elseif viewType == ViewType.EnemySelect then
        titleBg:setVisible(false)
        attackLayer:setVisible(false)
        defendLayer:setVisible(false)
        attackMenu:setVisible(false)
        defendMenu:setVisible(false)
        helpItem:setVisible(false)
    elseif viewType == ViewType.ArmySelect then
        titleBg:setVisible(false)
        attackLayer:setVisible(false)
        defendLayer:setVisible(false)
        attackMenu:setVisible(false)
        defendMenu:setVisible(false)
        helpItem:setVisible(false)
    end
end

-- 进攻界面 点艹
local function attackFontClick(tag)
    local fortId = string.format("fort_%02d", tag)
    local fortDic = _attackBattleInfo.forts[fortId]
    if fortDic.leagueId and fortDic.leagueId == _attackBattleInfo.attackId then
        ShowText(HLNSLocalizedString("attack.capture.tips"))
    else
        getMainLayer():getParent():addChild(createUnionBattlePreviewCard(fortId, fortDic.playerName, BattleType.attack))
    end
end
UnionBattleLayerOwner["attackFontClick"] = attackFontClick

-- 防御界面 点艹
local function defendFontClick(tag)
    local fortId = string.format("fort_%02d", tag)
    if defendInBattle then
        local fortDic = _defendBattleInfo.forts[fortId]
        if not fortDic.playerId or fortDic.playerId == "" then
            -- 没人不让自己站上去
            return
        end
        if fortDic.leagueId and tonumber(fortDic.leagueId) == tonumber(_defendBattleInfo.defendId) then
        else
            getMainLayer():getParent():addChild(createUnionBattlePreviewCard(fortId, fortDic.playerName, BattleType.defend))
        end
    else
        local fortDic = unionData.forts[fortId]
        -- 派遣
        getMainLayer():getParent():addChild(createUnionArmySelectLayer(fortId))
    end 
end
UnionBattleLayerOwner["defendFontClick"] = defendFontClick

-- 获取可以宣战的联盟
local function battleQueryCallback(url, rtnData)
    _enemyList = {}
    if not rtnData.info or table.getTableCount(rtnData.info) <= 0 then
        ShowText(HLNSLocalizedString("leagueBattle.empty.enemy"))
        return
    end
    for k,v in pairs(rtnData.info) do
        table.insert(_enemyList, deepcopy(v))
    end
    viewType = ViewType.EnemySelect
    _refreshLayer()
    _refreshEnemySelect()
end

-- 刷新盟战数据
local function attackBattleInfoCallback(url, rtnData)
    _attackBattleInfo = rtnData.info.battleInfo
    if _attackBattleInfo.endFlag and _attackBattleInfo.endFlag == 1 then
        viewType = ViewType.AttackSelect
        local text = _attackBattleInfo.msg
        if not getMainLayer():getParent():getChildByTag(100) then
            getMainLayer():getParent():addChild(createSimpleConfirCardLayer(text), 100, 100)
            SimpleConfirmCard.confirmMenuCallBackFun = nil
            SimpleConfirmCard.cancelMenuCallBackFun = nil
        end
    else
        viewType = ViewType.Attack
    end
    _refreshLayer()
    getUnionMainLayer():refreshData()
end

local function defendBattleInfoCallback(url, rtnData)
    _defendBattleInfo = rtnData.info.battleInfo
    if _defendBattleInfo.endFlag and _defendBattleInfo.endFlag == 1 then
        viewType = ViewType.DefendSelect
        local text = _defendBattleInfo.msg
        if not getMainLayer():getParent():getChildByTag(100) then
            getMainLayer():getParent():addChild(createSimpleConfirCardLayer(text), 100, 100)
            SimpleConfirmCard.confirmMenuCallBackFun = nil
            SimpleConfirmCard.cancelMenuCallBackFun = nil
        end
    else
        viewType = ViewType.Defend
    end
    _refreshLayer()
    getUnionMainLayer():refreshData()
end

-- 进攻界面点刷新
local function attackRefreshClick()
    doActionFun("LEAGUE_BATTLE_BATTLE_INFO", {_attackBattleInfo.id}, attackBattleInfoCallback)
end
UnionBattleLayerOwner["attackRefreshClick"] = attackRefreshClick

-- 选择战斗
local function battleClick(tag)
    if viewType == ViewType.AttackSelect then
        local dic = _attackInfoList[tag]
        if dic.key == "leagueBattle" then
            if not dic.battleInfoId or dic.battleInfoId == "" then
                if not unionData:isCreator() then
                    ShowText(HLNSLocalizedString("leagueBattle.close.member.tips"))
                else
                    doActionFun("LEAGUE_BATTLE_QUERY", {}, battleQueryCallback)
                end
            else
                doActionFun("LEAGUE_BATTLE_BATTLE_INFO", {dic.battleInfoId}, attackBattleInfoCallback)
            end
        end
    elseif viewType == ViewType.DefendSelect then
        local dic = _defendInfoList[tag]
        if dic.key == "leagueBattle" then
            if not dic.battleInfoId or dic.battleInfoId == "" then
                defendInBattle = false
                viewType = ViewType.Defend
                _refreshLayer()
            else
                defendInBattle = true
                doActionFun("LEAGUE_BATTLE_BATTLE_INFO", {dic.battleInfoId}, defendBattleInfoCallback)
            end
        end
    end
end
UnionBattleSelectCellOwner["battleClick"] = battleClick

local function battleTypeClick(tag)
    if (tag == 1 and (viewType == ViewType.AttackSelect or viewType == ViewType.Attack or viewType == ViewType.EnemySelect)) or
    (tag == 2 and (viewType == ViewType.DefendSelect or viewType == ViewType.Defend or viewType == ViewType.ArmySelect)) then
        return
    end
    viewType = tag
    _refreshLayer()
end
UnionBattleLayerOwner["battleTypeClick"] = battleTypeClick

-- 宣战
local function battleDeclareCallback(url, rtnData)
    _attackBattleInfo = rtnData.info.battleInfo
    unionData:fromDic(rtnData.info)
    viewType = ViewType.Attack
    _refreshLayer()
end

local function enemyClick(tag)
    local dic = _enemyList[tag]
    if unionData.recordPointer.count > 0 then
        getMainLayer():getParent():addChild(createUnionBattleConfirmCard(dic.id, dic.name))
    else
        getMainLayer():getParent():addChild(createUnionBattlePayCard(dic.id, dic.name))
    end
end
UnionEnemySelectCellOwner["enemyClick"] = enemyClick

local function counterClick(tag)
    local dic = _logInfoList[tag]
    if unionData.recordPointer.count > 0 then
        getMainLayer():getParent():addChild(createUnionBattleConfirmCard(dic.leagueId, dic.leagueName))
    else
        getMainLayer():getParent():addChild(createUnionBattlePayCard(dic.leagueId, dic.leagueName))
    end
end
UnionBattleCounterCellOwner["counterClick"] = counterClick

local function deployCallback(url, rtnData)
    unionData:fromDic(rtnData.info)
    _refreshDefendLayer()
end

local function defendSaveClick()
    local param = {}
    for k,v in pairs(defendFortsCopy) do
        if v.playerId and v.playerId ~= "" then
            param[k] = v.playerId
        else
            param[k] = ""
        end
    end
    doActionFun("LEAGUE_DEPLOY_FORT", {param}, deployCallback)
end
UnionBattleLayerOwner["defendSaveClick"] = defendSaveClick


local function attackRefreshClick()
    doActionFun("LEAGUE_BATTLE_BATTLE_INFO", {_attackBattleInfo.id}, attackBattleInfoCallback)
end
UnionBattleLayerOwner["attackRefreshClick"] = attackRefreshClick

local function defendRefreshClick()
    doActionFun("LEAGUE_BATTLE_BATTLE_INFO", {_defendBattleInfo.id}, defendBattleInfoCallback)
end
UnionBattleLayerOwner["defendRefreshClick"] = defendRefreshClick

local function helpItemClick()
    if viewType == ViewType.AttackSelect then
        local array = {}
        for i=1,table.getTableCount(ConfigureStorage.fightHelp) do
            table.insert(array, ConfigureStorage.fightHelp[tostring(i)].explain)
        end
        getMainLayer():getParent():addChild(createCommonHelpLayer(array, -140))
    elseif viewType == ViewType.DefendSelect then
        local array = {}
        for i=1,table.getTableCount(ConfigureStorage.guardHelp) do
            table.insert(array, ConfigureStorage.guardHelp[tostring(i)].explain)
        end
        getMainLayer():getParent():addChild(createCommonHelpLayer(array, -140))
    elseif viewType == ViewType.LogSelect then
        local array = {}
        for i=1,table.getTableCount(ConfigureStorage.enemyHelp) do
            table.insert(array, ConfigureStorage.enemyHelp[tostring(i)].explain)
        end
        getMainLayer():getParent():addChild(createCommonHelpLayer(array, -140))
    end
end
UnionBattleLayerOwner["helpItemClick"] = helpItemClick


local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/UnionBattleLayer.ccbi", proxy, true, "UnionBattleLayerOwner")
    _layer = tolua.cast(node, "CCLayer")

    for i=1,5 do
        local attackFont = tolua.cast(UnionBattleLayerOwner["attackFont"..i], "CCMenuItemImage")
        attackFont:setOpacity(0)
        local defendFont = tolua.cast(UnionBattleLayerOwner["defendFont"..i], "CCMenuItemImage")
        defendFont:setOpacity(0)
    end
    local cursorLabel = tolua.cast(UnionBattleLayerOwner["cursorLabel"], "CCLabelTTF")
    cursorLabel:setString(string.format("%d/%d", unionData.recordPointer.count, ConfigureStorage.leagueBattleRecordPointer.max))


    local _topLayer = UnionBattleLayerOwner["BSTopLayer"]
    local attackLayer = tolua.cast(UnionBattleLayerOwner["attackLayer"], "CCLayer")
    local defendLayer = tolua.cast(UnionBattleLayerOwner["defendLayer"], "CCLayer")
    local pos = ccp(winSize.width / 2, (winSize.height - _topLayer:getContentSize().height - getMainLayer():getBottomContentSize().height) / 2 
        + getMainLayer():getBottomContentSize().height - 26 * retina)
    attackLayer:setPosition(pos)
    defendLayer:setPosition(pos)
end

local function leagueBattleFightCallback(url, rtnData)
    unionData:fromDic(rtnData.info)
    runtimeCache.responseData = rtnData.info
    if viewType == ViewType.Attack then
        _attackBattleInfo = rtnData.info.battleInfo
    elseif viewType == ViewType.Defend then
        _defendBattleInfo = rtnData.info.battleInfo
    end
    if rtnData.info.battleInfo.battleStatus and (tonumber(rtnData.info.battleInfo.battleStatus) == 0 
        or (not bFight and tonumber(rtnData.info.battleInfo.battleStatus) == 1)) then
        -- 战斗被别人打结束了，不进战斗
        runtimeCache.unionBattleInFight = false
        if viewType == ViewType.Attack then
            viewType = ViewType.AttackSelect
        elseif viewType == ViewType.Defend then
            viewType = ViewType.DefendSelect
        end
        local text = rtnData.info.battleInfo.msg
        if not getMainLayer():getParent():getChildByTag(100) then
            getMainLayer():getParent():addChild(createSimpleConfirCardLayer(text), 100, 100)
            SimpleConfirmCard.confirmMenuCallBackFun = nil
            SimpleConfirmCard.cancelMenuCallBackFun = nil
        end
        _refreshLayer()
        getUnionMainLayer():refreshData()
        return
    end
    runtimeCache.unionBattleInFight = bFight
    if bFight then
        CCDirector:sharedDirector():replaceScene(CCTransitionFade:create(0.6, FightingScene()))
    else
        _refreshLayer()
        getUnionMainLayer():refreshData()
    end
end

local function getBattleInfoCallback(url, rtnData)
    RandomManager.cursor = RandomManager.randomRange(0, 999)
    local seed = RandomManager.cursor
    playerBattleData:fromDic(rtnData.info.player)
    BattleField.leftName = userdata.name
    BattleField.rightName = rtnData.info.player.name
    BattleField:unionBattle(unionData:getAttackBuff())

    local result = BattleField.result == RESULT_WIN and 1 or 0
    bFight = true
    local id
    if viewType == ViewType.Attack then
        id = _attackBattleInfo.id
    elseif viewType == ViewType.Defend then
        id = _defendBattleInfo.id
    end
    doActionFun("LEAGUE_BATTLE_FIGHTING", {id, _selectFort, result}, leagueBattleFightCallback)
end

local function _updateTimer()
    if viewType == ViewType.Attack then
        local timer = _attackBattleInfo.endTime - userdata.loginTime
        if timer == 0 then
            doActionFun("LEAGUE_BATTLE_BATTLE_INFO", {_attackBattleInfo.id}, attackBattleInfoCallback)
        else
            timer = math.max(timer, 0)
            local attackLeftTime = tolua.cast(UnionBattleLayerOwner["attackLeftTime"], "CCLabelTTF")
            attackLeftTime:setString(DateUtil:second2hms(timer))
        end 
    elseif viewType == ViewType.Defend then
        if defendInBattle then
            local timer = _defendBattleInfo.endTime - userdata.loginTime
            if timer == 0 then
                doActionFun("LEAGUE_BATTLE_BATTLE_INFO", {_defendBattleInfo.id}, defendBattleInfoCallback)
            else
                timer = math.max(timer, 0)
                local defendLeftTime = tolua.cast(UnionBattleLayerOwner["defendLeftTime"], "CCLabelTTF")
                defendLeftTime:setString(DateUtil:second2hms(timer))
            end
        end
    end 
end

function getUnionBattleLayer()
    return _layer
end

function createUnionBattleLayer()
    _init()

    -- 宣战
    function _layer:declare(id)
        doActionFun("LEAGUE_BATTLE_DECLARE", {id}, battleDeclareCallback)
    end

    function _layer:refreshBattleInfo()
        if viewType == ViewType.Attack then
            doActionFun("LEAGUE_BATTLE_BATTLE_INFO", {_attackBattleInfo.id}, attackBattleInfoCallback)
        elseif viewType == ViewType.Defend then
            doActionFun("LEAGUE_BATTLE_BATTLE_INFO", {_defendBattleInfo.id}, defendBattleInfoCallback)
        end
    end

    -- 攻占据点
    function _layer:attackFort(fortId)
        local fortDic = _attackBattleInfo.forts[fortId]  
        _selectFort = fortId 
        if fortDic.playerId and fortDic.playerId ~= "" then
            -- 取战斗数据打
            doActionFun("LEAGUE_BATTLE_GET_BATTLEINFO", {_attackBattleInfo.id, fortId}, getBattleInfoCallback)
        else
            -- 直接占领
            doActionFun("LEAGUE_BATTLE_FIGHTING", {_attackBattleInfo.id, fortId, 1}, leagueBattleFightCallback)
        end
    end

    -- 防御据点
    function _layer:defendFort(fortId)
        local fortDic = _defendBattleInfo.forts[fortId]
        _selectFort = fortId
        if fortDic.playerId and fortDic.playerId ~= "" then
            -- 取战斗数据打
            doActionFun("LEAGUE_BATTLE_GET_BATTLEINFO", {_defendBattleInfo.id, fortId}, getBattleInfoCallback)
        end
    end

    function _layer:selectArmy(fortId, dic)
        for k,v in pairs(defendFortsCopy) do
            if v.playerId == dic.playerId then
                v.playerId = ""
                v.playerName = nil
                v.worth = nil
                break
            end
        end
        defendFortsCopy[fortId].playerId = dic.playerId
        defendFortsCopy[fortId].playerName = dic.name
        defendFortsCopy[fortId].worth = dic.worth
        _refreshDefendLayer()
        ShowText(HLNSLocalizedString("defend.selectArmy.tips"))
    end

    -- 刷新页面
    function _layer:refreshLayer()
        _refreshLayer()
    end

    local function _onEnter()
        getUnionMainLayer():titleVisible(false)
        if not viewType then
            viewType = ViewType.AttackSelect
        end
        _refreshLayer()
        addObserver(NOTI_UNION_BATTLE, _updateTimer)
    end

    local function _onExit()
        _layer = nil
        _tableView = nil
        _attackInfoList = nil
        _defendInfoList = nil
        _logInfoList = nil
        _enemyList = nil
        _defendFortsCopy = nil
        removeObserver(NOTI_UNION_BATTLE, _updateTimer)
        bFight = false
        _selectFort = nil
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