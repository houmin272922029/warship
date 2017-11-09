local _layer
local _data
local currentIndex
local _tag
local istrue = false
local selectedIndex
local _state
-- ·名字不要重复
SSAFourKingContendViewOwner = SSAFourKingContendViewOwner or {}
ccb["SSAFourKingContendViewOwner"] = SSAFourKingContendViewOwner
SSAFourKingContendCellOwner = SSAFourKingContendCellOwner or {}
ccb["SSAFourKingContendCellOwner"] = SSAFourKingContendCellOwner

-- 添加tableview
local function _addTableView()
    local contentLayer = tolua.cast(SSAFourKingContendViewOwner["contentLayer"],"CCLayer")  
    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(200, 120)
        elseif fn == "cellAtIndex" then
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            SSAFourKingTurnCellOwner = SSAFourKingTurnCellOwner or {}
            ccb["SSAFourKingTurnCellOwner"] = SSAFourKingTurnCellOwner
            --单条数据
            local  proxy = CCBProxy:create()
            local  _hbCell  = tolua.cast(CCBReaderLoad("ccbResources/SSAFourKingTurnCell.ccbi",proxy,true,"SSAFourKingTurnCellOwner"),"CCLayer")
            local  itemSprite = tolua.cast(SSAFourKingTurnCellOwner["itemSprite"], "CCSprite")
            -- crossServerBattle_getBattleMap  CROSSSERVERBATTLE_GETBATTLEMAP
            if currentIndex - 1 >= a1 then
                itemSprite:setColor(ccc3(255,255,255))
                itemSprite:setScale(1)

                if currentIndex-1 == a1 then
                     HLAddParticleScale( "images/kfz_huoyan.plist", itemSprite, 
                            ccp( itemSprite:getContentSize().width *0.4   , itemSprite:getContentSize().height *0.3),
                             5, 100, 100, 1/retina, 1/retina )
                end

            else
                itemSprite:setColor(ccc3(125,125,125))
                itemSprite:setScale(0.8)
            end

            local betCount = tolua.cast(SSAFourKingTurnCellOwner["betCount"] , "CCLabelTTF")
            betCount:setString(HLNSLocalizedString("SSA.bet." .. (a1 + 1)))
            
            a2:addChild(_hbCell, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            r = a2
        elseif fn == "numberOfCells" then
            r = 5
            --tabelview中cell的行数
            -- r = #_data
        elseif fn == "cellTouched" then  -- A cell was touched, a1 is cell that be touched. This is not necessary.
            local timeStatus = {"32to16Begin","16to8Begin","8to4Begin","4to2Begin","2to1Begin"}
            if currentIndex > a1:getIdx() then -- 可点击
                local current = selectedIndex - 1
                local index = a1:getIdx()
                if index == current  then
                    return 
                else
                    selectedIndex = a1:getIdx() + 1
                    local function callback(url, rtnData)
                        ssaData.data = rtnData.info
                        _data = ssaData.data
                        PrintTable(_data)
                        _tableView2:reloadData()
                    end
                    doActionFun("CROSSSERVERBATTLE_GETBATTLEMAP", {timeStatus[a1:getIdx() + 1]}, callback)
                end
            end
            local contentoffset = _tableView:getContentOffset()
            _tableView:reloadData()
            _tableView:setContentOffset(contentoffset)
        elseif fn == "cellTouchBegan" then      -- A cell is touching, a1 is cell, a2 is CCTouch
        elseif fn == "cellTouchEnded" then      -- A cell was touched, a1 is cell, a2 is CCTouch
        elseif fn == "cellHighlight" then       -- A cell is highlighting, coco2d-x 2.1.3 or above
        elseif fn == "cellUnhighlight" then     -- A cell had been unhighlighted, coco2d-x 2.1.3 or above
        elseif fn == "cellWillRecycle" then     -- A cell will be recycled, coco2d-x 2.1.3 or above
        end
        return r
    end)
    local size = contentLayer:getContentSize()
    _tableView = LuaTableView:createWithHandler(h, size)
    _tableView:setBounceable(true)
    _tableView:setAnchorPoint(ccp(0,0))
    _tableView:setPosition(0,0)
    _tableView:setDirection(0) --横向tableview
    _tableView:setVerticalFillOrder(0)
    contentLayer:addChild(_tableView,1000)
    local  itemSprite = tolua.cast(SSAFourKingTurnCellOwner["itemSprite"], "CCSprite")
    _tableView:setContentOffset(ccp((currentIndex -1) * itemSprite:getContentSize().width * -1 , 0))
end
-- 查看阵容
local function playerBtnClick(tag)
    print(math.floor(tag / 2) + 1)
    local dic = _data.battleMap[tostring(math.ceil(tag / 2) - 1)] -- 对应得数据
    local index = (tag + 1) % 2 -- 对应左右
    local data = dic.vs[tostring(index)].playerData
    local form = data.form[tostring(0)]
    local heroId = data.heros[tostring(form)].heroId
    playerBattleData:fromDic(data)
    getMainLayer():getParent():addChild(createTeamPopupLayer(-140))
end
SSAFourKingContendCellOwner["playerBtnClick"] = playerBtnClick

-- 点击直接进入押注界面
local function betBtnClick(tag)
    print("betBtn", tag)
    if getMainLayer() then
        getMainLayer():addChild(createSSABetViewLayer(_data, tag)) 
    end
end
SSAFourKingContendCellOwner["betBtnClick"] = betBtnClick

-- 返回
local function BackClicked()
    if ssaData.data.timeStatus == "worshipBegin" then -- 回到膜拜界面
        local function beginCallback(url, rtnData)
            ssaData.data = rtnData.info
            runtimeCache.SSAState = ssaDataFlag.Worship
            getMainLayer():gotoSSAWorship()
        end
        doActionFun("CROSSSERVERBATTLE_BEGIN", {}, beginCallback)
    else
        runtimeCache.SSAState = ssaDataFlag.home
        getMainLayer():gotoAdventure()
    end
end
SSAFourKingContendViewOwner["BackClicked"] = BackClicked

-- 已押注按钮回调  界面
local function StatusBtnClick(tag)
    print("StatusBtnClick", tag)
    -- 按钮控制三个页面
    -- 判断状态 1 已押注 、 2 领取奖励 3、竞猜失败 _state
    local status = {"32to16Begin", "32to16BetEnd", "16to8Begin", "16to8BetEnd", "8to4Begin", "8to4BetEnd", 
            "4to2Begin", "4to2BetEnd", "2to1Begin", "2to1BetEnd", "worshipBegin"}
    local function getIndex(key)
        for i,v in ipairs(status) do
            if v == key then
                return i
            end
        end
        return #status
    end
    local timeIndex = getIndex(ssaData.data.timeStatus)
    local mapIndex = timeIndex
    if ssaData.data.mapStatus then
        mapIndex = getIndex(ssaData.data.mapStatus)
    end

    local state = 1
    if mapIndex + 1 < timeIndex then
        if _data.battleMap[tostring(tag - 1)].betLog.isReward == false then
            if _data.battleMap[tostring(tag - 1)].winner == _data.battleMap[tostring(tag - 1)].betLog.vsIndex then -- 押注正确
                -- 领取奖励按钮 与领取奖励字样
                state = 2
            else
                state = 3
            end
        else
            -- 奖励已领取
            ShowText(HLNSLocalizedString("SSA.statusLabel.getReward"))
            return
        end
    else
        state = 1
    end
    if getMainLayer() then
        getMainLayer():addChild(createSSAMyBetViewLayer(_data, tag, state)) 
    end
end
SSAFourKingContendCellOwner["StatusBtnClick"] = StatusBtnClick

-- 观战按钮
local function fightItemClick(tag)
    print("fightItemClick", tag)
    RandomManager.cursor = _data.battleMap[tostring(tag - 1)].seed
    local left = _data.battleMap[tostring(tag - 1)].vs[tostring(0)].playerData
    local right = _data.battleMap[tostring(tag - 1)].vs[tostring(1)].playerData
    BattleField.leftName = left.name
    BattleField.rightName = right.name
    BattleField:SSAVideo(left, right)
    CCDirector:sharedDirector():replaceScene(CCTransitionFade:create(0.6, FightingScene()))
end
SSAFourKingContendCellOwner["fightItemClick"] = fightItemClick

-- 添加tableview2
local function _addTableView2()
    local containLayer = tolua.cast(SSAFourKingContendViewOwner["containLayer"],"CCLayer")  
    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(620 , 180)
        elseif fn == "cellAtIndex" then
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            --单条数据
            local  proxy = CCBProxy:create()
            local  _hbCell  = tolua.cast(CCBReaderLoad("ccbResources/SSAFourKingContendCell.ccbi",proxy,true,"SSAFourKingContendCellOwner"),"CCLayer")
            local dic = _data.battleMap[tostring(a1)]
            -- 服务器名称、玩家名、lv等级 servers1 name1 level1 
            for i=1,2 do
                local servers = tolua.cast(SSAFourKingContendCellOwner["servers" .. i] , "CCLabelTTF")
                local name = tolua.cast(SSAFourKingContendCellOwner["name" .. i] , "CCLabelTTF")
                local level = tolua.cast(SSAFourKingContendCellOwner["level" .. i] , "CCLabelTTF")
                servers:setString(dic.vs[tostring(i - 1)].serverName)
                name:setString(dic.vs[tostring(i - 1)].playerData.name)
                level:setString('LV'.. dic.vs[tostring(i - 1)].playerData.level)
            end
            local playerBtn1 = tolua.cast(SSAFourKingContendCellOwner["playerBtn1"], "CCMenuItem")
            local playerBtn2 = tolua.cast(SSAFourKingContendCellOwner["playerBtn2"], "CCMenuItem")
            playerBtn1:setTag(a1 * 2 + 1)
            playerBtn2:setTag(a1 * 2 + 2)
            local fail1 = tolua.cast(SSAFourKingContendCellOwner["fail1"], "CCSprite")
            local fail2 = tolua.cast(SSAFourKingContendCellOwner["fail2"], "CCSprite")

            -- 判断失败或成功

            if _data.battleMap[tostring(a1)].winner then
                if _data.battleMap[tostring(a1)].winner == 1 then
                    fail1:setVisible(true)
                    playerBtn1:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("playerUnderFrameBg_1.png"))
                    playerBtn1:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("playerUnderFrameBg_1.png"))
                else
                    fail2:setVisible(true)
                    playerBtn2:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("playerUnderFrameBg_1.png"))
                    playerBtn2:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("playerUnderFrameBg_1.png"))
                end
            end

            --betBtn 押注按钮  StatusBtn 三种状态按钮、已押注、 领取奖励 、竞猜失败 
            local betBtn = tolua.cast(SSAFourKingContendCellOwner["betBtn"], "CCMenuItemImage")
            betBtn:setTag(a1 + 1)

            local StatusBtn = tolua.cast(SSAFourKingContendCellOwner["StatusBtn"], "CCMenuItemImage")
            StatusBtn:setTag(a1 + 1)
            
            -- 设置优先级
            local menu = tolua.cast(SSAFourKingContendCellOwner["menu"], "CCMenu")
            local function setCellMenuPriority(sender)
                if sender then
                    local menu = tolua.cast(sender, "CCMenu")
                    menu:setHandlerPriority(-130)
                end
            end
            local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCCallFuncN:create(setCellMenuPriority))
            menu:runAction(seq)
            -- 显示三种状态下的消息
            local statusLabel = tolua.cast(SSAFourKingContendCellOwner["statusLabel"], "CCLabelTTF")
            
            -- 观战按钮 未开始label  guanzhanText rewardLabel
            local fightItem = tolua.cast(SSAFourKingContendCellOwner["fightItem"], "CCMenuItemImage")
            local notStartLabel = tolua.cast(SSAFourKingContendCellOwner["notStartLabel"], "CCLabelTTF")
            local guanzhanText = tolua.cast(SSAFourKingContendCellOwner["guanzhanText"], "CCSprite")
            fightItem:setTag(a1 + 1)
            local betLable = tolua.cast(SSAFourKingContendCellOwner["betLable"], "CCLabelTTF")
            local betEndLabel = tolua.cast(SSAFourKingContendViewOwner["betEndLabel"], "CCLabelTTF")
            local timeEnd = tolua.cast(SSAFourKingContendViewOwner["timeEnd"], "CCLabelTTF")
            local status = {"32to16Begin", "32to16BetEnd", "16to8Begin", "16to8BetEnd", "8to4Begin", "8to4BetEnd", 
                "4to2Begin", "4to2BetEnd", "2to1Begin", "2to1BetEnd", "worshipBegin"}
            local function getIndex(key)
                for i,v in ipairs(status) do
                    if v == key then
                        return i
                    end
                end
                return #status
            end
            local timeIndex = getIndex(ssaData.data.timeStatus)
            local mapIndex = timeIndex
            if ssaData.data.mapStatus then
                mapIndex = getIndex(ssaData.data.mapStatus)
            end

            timeEnd:setVisible(mapIndex + 1 >= timeIndex)
            betEndLabel:setVisible(mapIndex + 1 < timeIndex)

            fightItem:setVisible(mapIndex + 1 < timeIndex)
            guanzhanText:setVisible(mapIndex + 1 < timeIndex)
            notStartLabel:setVisible(mapIndex + 1 >= timeIndex)
            StatusBtn:setVisible(getMyTableCount(_data.battleMap[tostring(a1)].betLog) > 0)
            statusLabel:setVisible(getMyTableCount(_data.battleMap[tostring(a1)].betLog) > 0)

            if mapIndex + 1 < timeIndex then
                betBtn:setVisible(false)
                betLable:setVisible(false) 
                fightItem:setVisible(true)  -- 可以观战
                guanzhanText:setVisible(true)
                if _data.battleMap[tostring(a1)].betLog.isReward == false then
                    if _data.battleMap[tostring(a1)].winner == _data.battleMap[tostring(a1)].betLog.vsIndex then -- 押注正确
                        -- 领取奖励按钮 与领取奖励字样
                        statusLabel:setString(HLNSLocalizedString("SSA.statusLabel.reward"))
                    else
                        statusLabel:setString(HLNSLocalizedString("SSA.statusLabel.fail"))
                        statusLabel:setColor(ccc3(217,217,217))

                        StatusBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("betFailBtn.png"))
                        StatusBtn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("betFailBtn.png"))

                    end
                else
                    -- 奖励已领取
                    statusLabel:setString(HLNSLocalizedString("SSA.statusLabel.getReward"))
                end
            else
                if  _data.bet then
                    betBtn:setVisible(mapIndex == timeIndex and getMyTableCount(_data.battleMap[tostring(a1)].betLog) == 0 and _data.bet.silver.isOpen == 1)
                    betLable:setVisible(mapIndex == timeIndex and getMyTableCount(_data.battleMap[tostring(a1)].betLog) == 0 and _data.bet.silver.isOpen == 1)
                else
                    betBtn:setVisible(mapIndex == timeIndex and getMyTableCount(_data.battleMap[tostring(a1)].betLog) == 0)
                    betLable:setVisible(mapIndex == timeIndex and getMyTableCount(_data.battleMap[tostring(a1)].betLog) == 0)
                end
                

                if mapIndex == timeIndex then
                    if getMyTableCount(_data.battleMap[tostring(a1)].betLog) == 0 then -- 若玩家没有押注
                    else
                        -- 押注方确定
                        if _data.battleMap[tostring(a1)].betLog.vsIndex == 0 then -- 已押左方    
                            statusLabel:setString(HLNSLocalizedString("SSA.statusLabel.left"))
                        else
                            statusLabel:setString(HLNSLocalizedString("SSA.statusLabel.right"))
                        end 
                    end
                end
            end

            local finalLabel  = tolua.cast(SSAFourKingContendCellOwner["finalLabel"] , "CCLabelTTF")
            local vsSprite  = tolua.cast(SSAFourKingContendCellOwner["vsSprite"] , "CCSprite")
            if mapIndex == 9 or mapIndex == 10 then
                finalLabel:setVisible(true)
                if a1 == 0 then
                    vsSprite:setScale(0.3)
                    finalLabel:setString(HLNSLocalizedString("SSA.finalLabel1"))
                else
                    vsSprite:setScale(0.3)
                    finalLabel:setString(HLNSLocalizedString("SSA.finalLabel2"))
                end
            else
                finalLabel:setVisible(false)
            end
            a2:addChild(_hbCell, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            r = a2
        elseif fn == "numberOfCells" then
            r = getMyTableCount(_data.battleMap)
            --tabelview中cell的行数
            -- r = #_data
        elseif fn == "cellTouched" then  -- A cell was touched, a1 is cell that be touched. This is not necessary.
        elseif fn == "cellTouchBegan" then      -- A cell is touching, a1 is cell, a2 is CCTouch
        elseif fn == "cellTouchEnded" then      -- A cell was touched, a1 is cell, a2 is CCTouch
        elseif fn == "cellHighlight" then       -- A cell is highlighting, coco2d-x 2.1.3 or above
        elseif fn == "cellUnhighlight" then     -- A cell had been unhighlighted, coco2d-x 2.1.3 or above
        elseif fn == "cellWillRecycle" then     -- A cell will be recycled, coco2d-x 2.1.3 or above
        end
        return r
    end)
    local size = containLayer:getContentSize()
    _tableView2 = LuaTableView:createWithHandler(h, size)
    _tableView2:setBounceable(true)
    _tableView2:setAnchorPoint(ccp(0,0))
    _tableView2:setPosition(0,0)
    _tableView2:setVerticalFillOrder(0)
    containLayer:addChild(_tableView2,1000)
end

--刷新时间显示函数
local function refreshTimeLabel()
    local timeEnd = tolua.cast(SSAFourKingContendViewOwner["timeEnd"], "CCLabelTTF")
    local timer = _data.nextTime - userdata.loginTime
    if timer < 0 then
        timer = 0
    end
    local day, hour, min, sec = DateUtil:secondGetdhms(timer)

    local timeStatus = {"32to16Begin","16to8Begin","8to4Begin","4to2Begin","2to1Begin"}
    local betEnd = {"32to16BetEnd","16to8BetEnd","8to4BetEnd","4to2BetEnd","2to1BetEnd"}
    if _data.timeStatus == timeStatus[currentIndex] then
        if day > 0 then
            timeEnd:setString(HLNSLocalizedString("SSA.betEndTime") .. HLNSLocalizedString("timer.tips.1", day, hour, min, sec)) 
        elseif hour > 0 then
            timeEnd:setString(HLNSLocalizedString("SSA.betEndTime") .. HLNSLocalizedString("timer.tips.2", hour, min, sec))
        else
            timeEnd:setString(HLNSLocalizedString("SSA.betEndTime") .. HLNSLocalizedString("timer.tips.3", min, sec))
        end
    end
    if _data.timeStatus == betEnd[currentIndex] then
        if day > 0 then
            timeEnd:setString(HLNSLocalizedString("SSA.ResultsEndTime") .. HLNSLocalizedString("timer.tips.1", day, hour, min, sec)) 
        elseif hour > 0 then
            timeEnd:setString(HLNSLocalizedString("SSA.ResultsEndTime") .. HLNSLocalizedString("timer.tips.2", hour, min, sec))
        else
            timeEnd:setString(HLNSLocalizedString("SSA.ResultsEndTime") .. HLNSLocalizedString("timer.tips.3", min, sec))
        end
    end

    
end
-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/SSAFourKingContendView.ccbi",proxy, true,"SSAFourKingContendViewOwner")
    _layer = tolua.cast(node,"CCLayer")
    _data = ssaData.data
    _addTableView()

    _addTableView2()
    refreshTimeLabel()
    local fourKingLabel = tolua.cast(SSAFourKingContendViewOwner["fourKingLabel"] , "CCLabelTTF")
    if currentIndex == 5 then
        fourKingLabel:setString(HLNSLocalizedString("SSA.firstOneLabel"))
    else
        fourKingLabel:setString(HLNSLocalizedString("SSA.fourKingLabel"))
    end

end

-- 该方法名字每个文件不要重复
function getSSAFourKingContendViewLayer()
    return _layer
end

function createSSAFourKingContendViewLayer(index)
    currentIndex = index
    selectedIndex = index
    _init()
    function _layer:_refresh()
        _data = ssaData.data
        local contentoffset = _tableView2:getContentOffset()
        _tableView2:reloadData()
        _tableView2:setContentOffset(contentoffset)
    end
   local function _onEnter()
        addObserver(NOTI_TICK, refreshTimeLabel)
    end
    
    local function _onExit()
        removeObserver(NOTI_TICK, refreshTimeLabel)
        _layer = nil
        istrue = nil
        currentIndex = nil
        _tag = nil
        selectedIndex = nil
        _state = nil
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