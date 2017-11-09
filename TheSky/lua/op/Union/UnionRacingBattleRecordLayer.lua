local _layer
local _data
local _tableView1
local _tableView2
local _Type
local TAP_TYPE = {
    owner = "owner",
    team = "team",
}
-- 战绩
unionRacingBattleRecordViewOwner = unionRacingBattleRecordViewOwner or {}
ccb["unionRacingBattleRecordViewOwner"] = unionRacingBattleRecordViewOwner

-- 个人战绩 cell
unionRacingBattleOwnerRecordCellOwner = unionRacingBattleOwnerRecordCellOwner or {}
ccb["unionRacingBattleOwnerRecordCellOwner"] = unionRacingBattleOwnerRecordCellOwner

-- 联盟战绩 cell
unionRacingBattleTeamRecordCellOwner = unionRacingBattleTeamRecordCellOwner or {}
ccb["unionRacingBattleTeamRecordCellOwner"] = unionRacingBattleTeamRecordCellOwner  

--返回
local function onExitTaped(  ) 
    print("返回")   
    -- getUnionMainLayer():gotoShowInner()
    getUnionMainLayer():gotoRacingBattle()
end
unionRacingBattleRecordViewOwner["onExitTaped"] = onExitTaped

-- 添加个人奖励
local function _addTableView1()
    local containLayer = tolua.cast(unionRacingBattleRecordViewOwner["containLayer"],"CCLayer")
    
    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(380, 125)
        elseif fn == "cellAtIndex" then
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            --单条数据
            local  _hbCell 
            local  proxy = CCBProxy:create()
            local  _hbCell  = tolua.cast(CCBReaderLoad("ccbResources/unionRacingBattleOwnerRecordCell.ccbi",proxy,true,"unionRacingBattleOwnerRecordCellOwner"),"CCLayer")
            
           
            -- 显示相应的信息
            if _data and _data.playerRankList then
                local dic = _data.playerRankList[tostring(a1)]

                local nameOwner = tolua.cast(unionRacingBattleOwnerRecordCellOwner["nameOwner"], "CCLabelTTF")
                local LVOwner = tolua.cast(unionRacingBattleOwnerRecordCellOwner["LVOwner"], "CCLabelTTF")
                local rankOwner = tolua.cast(unionRacingBattleOwnerRecordCellOwner["rankOwner"], "CCLabelTTF")
                local raceOwner = tolua.cast(unionRacingBattleOwnerRecordCellOwner["raceOwner"], "CCLabelTTF")
                local vipOwnerSprite = tolua.cast(unionRacingBattleOwnerRecordCellOwner["vipOwnerSprite"], "CCSprite")
                local cache = CCSpriteFrameCache:sharedSpriteFrameCache()

                local function getVipLevel()
                    for i,v in ipairs(ConfigureStorage.vipConfig) do
                        if dic.vipScore < v.score then
                            return i - 1 - 1        -- i从1开始
                        end
                    end
                    return #ConfigureStorage.vipConfig - 1
                end

                nameOwner:setString(dic.playerName)
                LVOwner:setString('LV:' .. dic.level)
                rankOwner:setString(a1 + 1)
                raceOwner:setString(dic.mark)
                vipOwnerSprite:setDisplayFrame(cache:spriteFrameByName(string.format("VIP_%d.png", getVipLevel())))
                -- vipOwnerSprite:setString()
            end


            -- _hbCell:setScale(retina)
            a2:setAnchorPoint(ccp(0, 0))
            _hbCell:setPosition(ccp(10, 0))
            a2:addChild(_hbCell, 0, 1)
            r = a2
        elseif fn == "numberOfCells" then
            r = getMyTableCount( _data.playerRankList)
        elseif fn == "cellTouched" then         -- A cell was touched, a1 is cell that be touched. This is not necessary.
        elseif fn == "cellTouchBegan" then      -- A cell is touching, a1 is cell, a2 is CCTouch
        elseif fn == "cellTouchEnded" then      -- A cell was touched, a1 is cell, a2 is CCTouch
        elseif fn == "cellHighlight" then       -- A cell is highlighting, coco2d-x 2.1.3 or above
        elseif fn == "cellUnhighlight" then     -- A cell had been unhighlighted, coco2d-x 2.1.3 or above
        elseif fn == "cellWillRecycle" then     -- A cell will be recycled, coco2d-x 2.1.3 or above
        end
        return r
    end)
    local size = CCSizeMake(containLayer:getContentSize().width, containLayer:getContentSize().height)  -- 这里是为了在tableview上面显示一个小空出来
    _tableView1 = LuaTableView:createWithHandler(h, size)
    _tableView1:setBounceable(true)
    _tableView1:setAnchorPoint(ccp(0,0))
    _tableView1:setPosition(0,0)
    _tableView1:setVerticalFillOrder(0)
    containLayer:addChild(_tableView1,1000)
end

-- 添加联盟奖励
local function _addTableView2()
    local containLayer = tolua.cast(unionRacingBattleRecordViewOwner["containLayer"],"CCLayer")
    
    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(380, 120)
        elseif fn == "cellAtIndex" then
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            --单条数据
            local  _hbCell 
            local  proxy = CCBProxy:create()
            local  _hbCell  = tolua.cast(CCBReaderLoad("ccbResources/unionRacingBattleTeamRecordCell.ccbi",proxy,true,"unionRacingBattleTeamRecordCellOwner"),"CCLayer")
        
            -- 显示相应的信息
            if _data and _data.leagueRankList then
                local dic = _data.leagueRankList[tostring(a1)]

                local nameTeam = tolua.cast(unionRacingBattleTeamRecordCellOwner["nameTeam"], "CCLabelTTF")
                local LVTeam = tolua.cast(unionRacingBattleTeamRecordCellOwner["LVTeam"], "CCLabelTTF")
                local rankTeam = tolua.cast(unionRacingBattleTeamRecordCellOwner["rankTeam"], "CCLabelTTF")
                local raceTeam = tolua.cast(unionRacingBattleTeamRecordCellOwner["raceTeam"], "CCLabelTTF")

                nameTeam:setString(dic.leagueName)
                LVTeam:setString('LV:' .. dic.level)
                rankTeam:setString(a1 + 1)
                raceTeam:setString(dic.mark)
            end

            --    
            -- _hbCell:setScale(retina)
            a2:setAnchorPoint(ccp(0, 0))
            _hbCell:setPosition(ccp(10, 0))
            a2:addChild(_hbCell, 0, 1)
            r = a2
        elseif fn == "numberOfCells" then
            r = getMyTableCount(_data.leagueRankList)
        elseif fn == "cellTouched" then         -- A cell was touched, a1 is cell that be touched. This is not necessary.
        elseif fn == "cellTouchBegan" then      -- A cell is touching, a1 is cell, a2 is CCTouch
        elseif fn == "cellTouchEnded" then      -- A cell was touched, a1 is cell, a2 is CCTouch
        elseif fn == "cellHighlight" then       -- A cell is highlighting, coco2d-x 2.1.3 or above
        elseif fn == "cellUnhighlight" then     -- A cell had been unhighlighted, coco2d-x 2.1.3 or above
        elseif fn == "cellWillRecycle" then     -- A cell will be recycled, coco2d-x 2.1.3 or above
        end
        return r
    end)
    local size = CCSizeMake(containLayer:getContentSize().width, containLayer:getContentSize().height)  -- 这里是为了在tableview上面显示一个小空出来
    _tableView2 = LuaTableView:createWithHandler(h, size)
    _tableView2:setBounceable(true)
    _tableView2:setAnchorPoint(ccp(0,0))
    _tableView2:setPosition(0,0)
    _tableView2:setVerticalFillOrder(0)
    containLayer:addChild(_tableView2,1000)
end

local function _refreshData()
    local tabBtn1 = tolua.cast(unionRacingBattleRecordViewOwner["tabBtn1"], "CCMenuItemImage")
    local tabBtn2 = tolua.cast(unionRacingBattleRecordViewOwner["tabBtn2"], "CCMenuItemImage")

    local raceLabel = tolua.cast(unionRacingBattleRecordViewOwner["raceLabel"], "CCLabelTTF")
    local nameLabel = tolua.cast(unionRacingBattleRecordViewOwner["nameLabel"], "CCLabelTTF")
    local rankLabel = tolua.cast(unionRacingBattleRecordViewOwner["rankLabel"], "CCLabelTTF")

    raceLabel:setString(HLNSLocalizedString("union.racingBattle.getRace")) 
    
    if _Type == TAP_TYPE.owner then -- 个人
        -- 按钮状态改变
        tabBtn1:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_1.png"))
        tabBtn2:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_0.png"))

        nameLabel:setString(HLNSLocalizedString("union.racingBattle.playerRank"))
        rankLabel:setString(HLNSLocalizedString("union.racingBattle.playerRace")) 

        _addTableView1()
        if _tableView2 then
            _tableView2:removeFromParentAndCleanup(true)
            _tableView2 = nil
        end
    else
        tabBtn2:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_1.png"))
        tabBtn1:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_0.png"))

        nameLabel:setString(HLNSLocalizedString("union.racingBattle.teamRank"))
        rankLabel:setString(HLNSLocalizedString("union.racingBattle.teamName")) 

        _addTableView2()  
        if _tableView1 then
            _tableView1:removeFromParentAndCleanup(true)
            _tableView1 = nil
        end
    end

    -- 显示相应的信息
    local ownerRace = tolua.cast(unionRacingBattleRecordViewOwner["ownerRace"], "CCLabelTTF")
    local teamRace = tolua.cast(unionRacingBattleRecordViewOwner["teamRace"], "CCLabelTTF")
    local ownerRank = tolua.cast(unionRacingBattleRecordViewOwner["ownerRank"], "CCLabelTTF")
    local teamRank = tolua.cast(unionRacingBattleRecordViewOwner["teamRank"], "CCLabelTTF")

    ownerRace:setString(_data.mySelfRankList.myMark)
    ownerRank:setString(_data.mySelfRankList.myRank)
    
    teamRace:setString(_data.mySelfRankList.myLeagueMark)
    teamRank:setString(_data.mySelfRankList.myLeagueRank)

end

-- 点击联盟
local function teamClick(  ) 
    if _Type == TAP_TYPE.team then
        return
    else
        _Type = TAP_TYPE.team
        _refreshData()
    end
end
unionRacingBattleRecordViewOwner["teamClick"] = teamClick

-- 点击个人
local function ownerClick(  ) 
    if _Type == TAP_TYPE.owner then
        return
    else
        _Type = TAP_TYPE.owner
        _refreshData()
    end
end
unionRacingBattleRecordViewOwner["ownerClick"] = ownerClick

local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/unionRacingBattleRecordView.ccbi",proxy, true,"unionRacingBattleRecordViewOwner")
    _layer = tolua.cast(node,"CCLayer")
    _refreshData() 
end

local function setMenuPriority()
    
end

function getUnionRacingBattleRecordViewLayer()
    return _layer
end

function createUnionRacingBattleRecordViewLayer( data)

    _Type = TAP_TYPE.owner
    _data = data
    _init()

    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
    end

    local function _onExit()
        _layer = nil
        _Type = nil
        _tableView1 = nil
        _tableView2 = nil
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