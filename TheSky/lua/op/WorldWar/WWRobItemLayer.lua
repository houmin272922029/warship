local _layer
local _tableView
local _data
local _rankArray
local cellArray = {}

-- 劫镖物资主界面
-- 名字不要重复
WWRobItemOwner = WWRobItemOwner or {}
ccb["WWRobItemOwner"] = WWRobItemOwner

--向服务器发送数据成功 函数回调
local function callback(url, rtnData)
    _data = rtnData.info
    postNotification(NOTI_WW_REFRESH, nil)
    generateCellAction(cellArray,getMyTableCount(_data.robLog))
    cellArray = {}
    --说明文字 若无可被劫镖的 则显示文字信息 当前海域没有玩家进行海运
    local desc = tolua.cast(WWRobItemOwner["Des"], "CCLabelTTF")
    if tonumber(getMyTableCount(_data.robLog)) > 0 then
        desc:setVisible(false)
    end
    for k,v in pairs(_data.robLog) do
        if v and v.result and tonumber(getMyTableCount(_data.robLog)) == 0 then
            desc:setVisible(true)
            desc:setString(HLNSLocalizedString("RobItem.des.1"))
        end
    end
end
-- 刷新按钮回调
local function RefreshClicked()
    doActionFun("GOING_ROBBERY", {}, callback)
end
WWRobItemOwner["RefreshClicked"] = RefreshClicked


-- 返回按钮回调
local function BackClicked()
    if not getMainLayer() then
        CCDirector:sharedDirector():replaceScene(mainSceneFun())
    end
    runtimeCache.dailyPageNum = Daily_Worship
    getMainLayer():gotoWorldWarExperiment()
end
WWRobItemOwner["BackClicked"] = BackClicked


local  function getArrayData()
    local rankArray = {}
    for k,v in pairs(_data.robLog) do
        if v then
            table.insert(rankArray, v)
        end
    end
    return rankArray
end

local function _addTableView()
    local content = WWRobItemOwner["content"]
    WWRobItemCellOwner = WWRobItemCellOwner or {}
    ccb["WWRobItemCellOwner"] = WWRobItemCellOwner
    _rankArray = getArrayData()
    
    local function arenaFightCallback(url, rtnData)
        runtimeCache.responseData = rtnData["info"]
        CCDirector:sharedDirector():replaceScene(CCTransitionFade:create(0.6, FightingScene())) 
    end
    --服务器发送成功回调
    local function getBattleInfoCallback(url, rtnData)
        RandomManager.cursor = RandomManager.randomRange(0, 999)
        local seed = RandomManager.cursor
        playerBattleData:fromDic(rtnData.info)
        PrintTable(playerBattleData.heroes)
        BattleField.leftName = userdata.name
        BattleField.rightName = rtnData.info.name
        BattleField:wwRobFight()
        local result = BattleField.result == RESULT_WIN and 1 or 0
        local enemy = _rankArray[_fightIdx]
        doActionFun("SAVR_ROBLOG", {enemy.player.id, result, seed}, arenaFightCallback)
    end
    -- rob按钮回调 劫货物
    local function RobBtnClicked(tag)
        _fightIdx = tag

         -- doActionFun("GET_ROBBERY_INFO", {_rankArray[tag].player.id}, getBattleInfoCallback)
        if _data.remain > 0 then 
            doActionFun("GET_ROBBERY_INFO", {_rankArray[tag].player.id}, getBattleInfoCallback)
        else
            ShowText(HLNSLocalizedString("RobItem_timesNotEnough"))
        end
    end
    WWRobItemCellOwner["RobBtnClicked"] = RobBtnClicked

    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(winSize.width, 152 * retina)
        elseif fn == "cellAtIndex" then
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            --单条数据
            local  _hbCell 
            local  proxy = CCBProxy:create()
            local  _hbCell  = tolua.cast(CCBReaderLoad("ccbResources/WWRobItemCell.ccbi",proxy,true,"WWRobItemCellOwner"),"CCLayer")

            local RobBtn = tolua.cast(WWRobItemCellOwner["RobBtn"], "CCMenuItemImage")
            RobBtn:setTag(a1 + 1)
            _rankArray = getArrayData()
            local dic = _rankArray[a1 + 1]
            local grade = tolua.cast(WWRobItemCellOwner["grade"], "CCLabelTTF")
            local Level = tolua.cast(WWRobItemCellOwner["Level"], "CCLabelTTF") 
            local HeroName = tolua.cast(WWRobItemCellOwner["HeroName"], "CCLabelTTF") 
            local CurPer = tolua.cast(WWRobItemCellOwner["CurPer"], "CCLabelTTF") 
            grade:setString(HLNSLocalizedString("currentRank" .. tonumber(dic.rank)))
            grade:setColor(HLGetColorWithRank(tonumber(dic.rank)))
            Level:setString(tostring(dic.player.level))
            HeroName:setString(tostring(dic.player.name))
            CurPer:setString(tostring(dic.percent) .. '%')
            for i=1,3 do
                if dic.player.form[tostring(i - 1)] then
                    local heroId = dic.player.heros[dic.player.form[tostring(i - 1)]].heroId
                    local conf = herodata:getHeroConfig(heroId)
                    if conf then
                        local rankFrame = tolua.cast(WWRobItemCellOwner["rankFrame" .. i] , "CCSprite")
                        local icon = tolua.cast(WWRobItemCellOwner["icon" .. i] , "CCSprite")
                        local colorSprite = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", conf.rank))
                        local f = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(herodata:getHeroHeadByHeroId(heroId))
                        if f then
                            icon:setVisible(true)
                            icon:setDisplayFrame(f)
                            rankFrame:setVisible(true)
                            rankFrame:setDisplayFrame(colorSprite)
                        end
                    end 
                end
            end
            _hbCell:setScale(retina)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            a2:addChild(_hbCell, 0, 1)
            cellArray[tostring(a1)] = _hbCell
            r = a2
        elseif fn == "numberOfCells" then
            -- r = #_data
            --tabelview中cell的行数
            r = getMyTableCount(_data.robLog)
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
        -- 算出说明文字与剩余次数之间距离
        local Des = tolua.cast(WWRobItemOwner["Des"], "CCLabelTTF")
        local RobCount = tolua.cast(WWRobItemOwner["RobCount"], "CCLabelTTF")
        local size = CCSizeMake(winSize.width, (Des:getPositionY() - RobCount:getPositionY() - 30 * retina))      -- 这里是为了在tableview上面显示一个小空出来
        _tableView = LuaTableView:createWithHandler(h, size)
        _tableView:setBounceable(true)
        _tableView:setAnchorPoint(ccp(0,0))
        _tableView:setPosition(ccp(0, RobCount:getPositionY() + 15 * retina))
        _tableView:setVerticalFillOrder(0)
        content:addChild(_tableView) 
    end

end

local function refresh()
    -- 显示 name lv vip 
    local name = tolua.cast(WWRobItemOwner["name"], "CCLabelTTF")
    local level = tolua.cast(WWRobItemOwner["level"], "CCLabelTTF")
    local vip = tolua.cast(WWRobItemOwner["vip"], "CCSprite")
    name:setString(userdata.name)
    level:setString(string.format("LV:%d", userdata.level))
    vip:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("VIP_%d.png", vipdata:getVipLevel())))
    --说明文字 若无可被劫镖的 则显示文字信息 当前海域没有玩家进行海运
    local Des = tolua.cast(WWRobItemOwner["Des"], "CCLabelTTF")
    if tonumber(getMyTableCount(_data.robLog)) == 0 then
        Des:setVisible(true)
        Des:setString(HLNSLocalizedString("RobItem.des.1"))
         if _tableView then 
            _tableView:removeFromParentAndCleanup(true)  --清除tableview
            _tableView = nil
        end

    else
        if _tableView then 
            _tableView:reloadData()
        else
            _addTableView()
        end
    end
    --今日劫镖剩余次数 RobCount
    local RobCount = tolua.cast(WWRobItemOwner["RobCount"], "CCLabelTTF")
    RobCount:setString(_data.remain .. '/'.._data.total)

    local titleBadge = tolua.cast(WWRobItemOwner["titleBadge"], "CCSprite")
    local index = tonumber(string.split(worldwardata.playerData.countryId, "_")[2])
    local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("badge_%d.png", index))
    titleBadge:setDisplayFrame(frame)
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/WWRobItemView.ccbi",proxy, true,"WWRobItemOwner")
    _layer = tolua.cast(node,"CCLayer")
    refresh()
end

-- 该方法名字每个文件不要重复
function getWWRobItemLayer()
	return _layer
end

function createWWRobItemLayer(data , priority)
    _data = data
    _init()

    function _layer:popupResult()
        local bWin = BattleField.result == RESULT_WIN
        if  bWin  then
            --跳转劫镖成功界面
            getMainLayer():getParent():addChild(createWWRobItemSucLayer(priority))
        else
            --跳转劫镖失败界面
            getMainLayer():getParent():addChild(createWWRobItemFailedViewLayer(priority))
        end
    end

    local function _onEnter()
        addObserver(NOTI_WW_REFRESH, refresh)
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