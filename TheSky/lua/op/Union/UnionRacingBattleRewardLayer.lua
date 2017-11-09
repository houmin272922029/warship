local _layer
local _tableView1
local _tableView2
local _Type
local TAP_TYPE = {
    owner = "owner",
    team = "team",
}
unionRacingBattleRewardViewOwner = unionRacingBattleRewardViewOwner or {}
ccb["unionRacingBattleRewardViewOwner"] = unionRacingBattleRewardViewOwner

unionRacingBattleRewardCellOwner = unionRacingBattleRewardCellOwner or {}
ccb["unionRacingBattleRewardCellOwner"] = unionRacingBattleRewardCellOwner

unionRacingBattleOwnerRewardCellOwner = unionRacingBattleOwnerRewardCellOwner or {}
ccb["unionRacingBattleOwnerRewardCellOwner"] = unionRacingBattleOwnerRewardCellOwner

--返回
local function onExitTaped(  ) 
    print("返回")   
    -- getUnionMainLayer():gotoShowInner()
    getUnionMainLayer():gotoRacingBattle()
end
unionRacingBattleRewardViewOwner["onExitTaped"] = onExitTaped

-- 添加个人奖励
local function _addTableView1()
    local containLayer = tolua.cast(unionRacingBattleRewardViewOwner["containLayer"],"CCLayer")
    
    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(600, 140)
        elseif fn == "cellAtIndex" then
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            --单条数据
            local  _hbCell 
            local  proxy = CCBProxy:create()
            local  _hbCell  = tolua.cast(CCBReaderLoad("ccbResources/unionRacingBattleOwnerRewardCell.ccbi",proxy,true,"unionRacingBattleOwnerRewardCellOwner"),"CCLayer")
            local owner = ConfigureStorage.CSRB_personaloot[tostring(a1 + 1)].Bloot
            
            local  index = 0
            for k,v in pairs(owner) do
                local itemId = k
                local amount = v
                -- 显示代码
                local resDic = userdata:getExchangeResource(itemId)
                local rankBtn = tolua.cast(unionRacingBattleOwnerRewardCellOwner["rankBtn"..index + 1],"CCMenuItemImage")
                local contentLayer = tolua.cast(unionRacingBattleOwnerRewardCellOwner["contentLayer"..index + 1],"CCLayer")
                --根据是否存在奖励物品，显示相应的物品
                rankBtn:setVisible(true)
                -- rankBtn:setTag(a1 * 10000 + i)
                contentLayer:setVisible(true)
                local bigSprite = tolua.cast(unionRacingBattleOwnerRewardCellOwner["bigSprite"..index + 1],"CCSprite")
                local littleSprite = tolua.cast(unionRacingBattleOwnerRewardCellOwner["littleSprite"..index + 1],"CCSprite")
                local soulIcon = tolua.cast(unionRacingBattleOwnerRewardCellOwner["soulIcon"..index + 1],"CCSprite")
                local chip_icon = tolua.cast(unionRacingBattleOwnerRewardCellOwner["chip_icon"..index + 1],"CCSprite")
                local countLabel = tolua.cast(unionRacingBattleOwnerRewardCellOwner["countLabel"..index + 1],"CCLabelTTF")
                chip_icon:setVisible(false)
                --代码整理
                --判断魂魄、影子单独处理
                if havePrefix(itemId, "hero") then
                    -- 魂魄
                    littleSprite:setVisible(true)
                    soulIcon:setVisible(true)
                    littleSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(resDic.icon))
                elseif havePrefix(itemId, "shadow") then
                    -- 影子
                    rankBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("s_frame.png"))
                    rankBtn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("s_frame.png"))

                    rankBtn:setPosition(ccp(rankBtn:getPositionX() + 5,rankBtn:getPositionY() - 5))
                    if resDic.icon then
                        playCustomFrameAnimation(string.format("yingzi_%s_", resDic.icon), contentLayer, ccp(contentLayer:getContentSize().width / 2,
                            contentLayer:getContentSize().height / 2), 1, 4, shadowData:getColorByColorRank(resDic.rank))
                    end
                else
                    -- 道具，装备，技能，货币
                    local texture
                    if haveSuffix(itemId, "_shard") then
                        -- 装备碎片
                        texture = CCTextureCache:sharedTextureCache():addImage(string.format("ccbResources/icons/%s.png",resDic.icon))
                        chip_icon:setVisible(true)
                    else
                        texture = CCTextureCache:sharedTextureCache():addImage(resDic.icon)
                    end
                    if texture then
                        bigSprite:setVisible(true)
                        bigSprite:setTexture(texture)
                        if resDic.rank == 4 then
                            HLAddParticleScale( "images/purpleEquip.plist", bigSprite, ccp(bigSprite:getContentSize().width / 2,bigSprite:getContentSize().height / 2), 
                                1, 100, 777, 2 / 0.35 / retina, 2 / 0.35 / retina, 1 )
                        end
                    end 
                end
                if not havePrefix(itemId, "shadow") then
                    rankBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", resDic.rank)))
                    rankBtn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", resDic.rank)))
                end
                -- 设置数量
                countLabel:setString(amount)
                index = index + 1
            end
            local bLootRank = tolua.cast(unionRacingBattleOwnerRewardCellOwner["bLootRank"],"CCLabelTTF")
            bLootRank:setString(HLNSLocalizedString("union.racingBattleReward.bLook" , a1 + 1))
            if a1 + 1 == 11 then
                bLootRank:setString(HLNSLocalizedString("union.racingBattleReward.pLookReward"))
            end
            -- _hbCell:setScale(retina)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            _hbCell:setPosition(ccp(10, 0))
            a2:addChild(_hbCell, 0, 1)
            r = a2
        elseif fn == "numberOfCells" then
            r = getMyTableCount(ConfigureStorage.CSRB_leagueloot)
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
    local containLayer = tolua.cast(unionRacingBattleRewardViewOwner["containLayer"],"CCLayer")
    
    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(600, 240)
        elseif fn == "cellAtIndex" then
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            --单条数据
            local  _hbCell 
            local  proxy = CCBProxy:create()
            local  _hbCell  = tolua.cast(CCBReaderLoad("ccbResources/unionRacingBattleRewardCell.ccbi",proxy,true,"unionRacingBattleRewardCellOwner"),"CCLayer")
            local pLoot = ConfigureStorage.CSRB_leagueloot[tostring(a1 + 1)].Ploot
            local bLoot = ConfigureStorage.CSRB_leagueloot[tostring(a1 + 1)].Bloot
            local  index = 0
            for k,v in pairs(bLoot) do
                local itemId = k
                local amount = v
                -- 显示代码
                local resDic = userdata:getExchangeResource(itemId)
                local rankBtn = tolua.cast(unionRacingBattleRewardCellOwner["rankBtn"..index + 1],"CCMenuItemImage")
                local contentLayer = tolua.cast(unionRacingBattleRewardCellOwner["contentLayer"..index + 1],"CCLayer")
                --根据是否存在奖励物品，显示相应的物品
                rankBtn:setVisible(true)
                -- rankBtn:setTag(a1 * 10000 + i)
                contentLayer:setVisible(true)
                local bigSprite = tolua.cast(unionRacingBattleRewardCellOwner["bigSprite"..index + 1],"CCSprite")
                local littleSprite = tolua.cast(unionRacingBattleRewardCellOwner["littleSprite"..index + 1],"CCSprite")
                local soulIcon = tolua.cast(unionRacingBattleRewardCellOwner["soulIcon"..index + 1],"CCSprite")
                local chip_icon = tolua.cast(unionRacingBattleRewardCellOwner["chip_icon"..index + 1],"CCSprite")
                local countLabel = tolua.cast(unionRacingBattleRewardCellOwner["countLabel"..index + 1],"CCLabelTTF")
                chip_icon:setVisible(false)
                --代码整理
                --判断魂魄、影子单独处理
                if havePrefix(itemId, "hero") then
                    -- 魂魄
                    littleSprite:setVisible(true)
                    soulIcon:setVisible(true)
                    littleSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(resDic.icon))
                elseif havePrefix(itemId, "shadow") then
                    -- 影子
                    rankBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("s_frame.png"))
                    rankBtn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("s_frame.png"))

                    rankBtn:setPosition(ccp(rankBtn:getPositionX() + 5,rankBtn:getPositionY() - 5))
                    if resDic.icon then
                        playCustomFrameAnimation(string.format("yingzi_%s_", resDic.icon), contentLayer, ccp(contentLayer:getContentSize().width / 2,
                            contentLayer:getContentSize().height / 2), 1, 4, shadowData:getColorByColorRank(resDic.rank))
                    end
                else
                    -- 道具，装备，技能，货币
                    local texture
                    if haveSuffix(itemId, "_shard") then
                        -- 装备碎片
                        texture = CCTextureCache:sharedTextureCache():addImage(string.format("ccbResources/icons/%s.png",resDic.icon))
                        chip_icon:setVisible(true)
                    else
                        texture = CCTextureCache:sharedTextureCache():addImage(resDic.icon)
                    end
                    if texture then
                        bigSprite:setVisible(true)
                        bigSprite:setTexture(texture)
                        if resDic.rank == 4 then
                            HLAddParticleScale( "images/purpleEquip.plist", bigSprite, ccp(bigSprite:getContentSize().width / 2,bigSprite:getContentSize().height / 2), 
                                1, 100, 777, 2 / 0.35 / retina, 2 / 0.35 / retina, 1 )
                        end
                    end 
                end
                if not havePrefix(itemId, "shadow") then
                    rankBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", resDic.rank)))
                    rankBtn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", resDic.rank)))
                end
                -- 设置数量
                countLabel:setString(amount)
                index = index + 1
            end
            local pos = 0
            for k,v in pairs(pLoot) do
                local itemId = k
                local amount = v
                -- 显示代码
                local resDic = userdata:getExchangeResource(itemId)
                local rankBtn = tolua.cast(unionRacingBattleRewardCellOwner["BlootRankBtn"..pos + 1],"CCMenuItemImage")
                local contentLayer = tolua.cast(unionRacingBattleRewardCellOwner["bLootContentLayer"..pos + 1],"CCLayer")
                --根据是否存在奖励物品，显示相应的物品
                rankBtn:setVisible(true)
                -- rankBtn:setTag(a1 * 10000 + i)
                contentLayer:setVisible(true)
                local bigSprite = tolua.cast(unionRacingBattleRewardCellOwner["bLootBigSprite"..pos + 1],"CCSprite")
                local littleSprite = tolua.cast(unionRacingBattleRewardCellOwner["bLootLittleSprite"..pos + 1],"CCSprite")
                local soulIcon = tolua.cast(unionRacingBattleRewardCellOwner["bLootSoulIcon"..pos + 1],"CCSprite")
                local chip_icon = tolua.cast(unionRacingBattleRewardCellOwner["bLookChip_icon"..pos + 1],"CCSprite")
                local countLabel = tolua.cast(unionRacingBattleRewardCellOwner["bLootCountLabel"..pos + 1],"CCLabelTTF")
                chip_icon:setVisible(false)
                --代码整理
                --判断魂魄、影子单独处理
                if havePrefix(itemId, "hero") then
                    -- 魂魄
                    littleSprite:setVisible(true)
                    soulIcon:setVisible(true)
                    littleSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(resDic.icon))
                elseif havePrefix(itemId, "shadow") then
                    -- 影子
                    rankBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("s_frame.png"))
                    rankBtn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("s_frame.png"))

                    rankBtn:setPosition(ccp(rankBtn:getPositionX() + 5,rankBtn:getPositionY() - 5))
                    if resDic.icon then
                        playCustomFrameAnimation(string.format("yingzi_%s_", resDic.icon), contentLayer, ccp(contentLayer:getContentSize().width / 2,
                            contentLayer:getContentSize().height / 2), 1, 4, shadowData:getColorByColorRank(resDic.rank))
                    end
                else
                    -- 道具，装备，技能，货币
                    local texture
                    if haveSuffix(itemId, "_shard") then
                        -- 装备碎片
                        texture = CCTextureCache:sharedTextureCache():addImage(string.format("ccbResources/icons/%s.png",resDic.icon))
                        chip_icon:setVisible(true)
                    else
                        texture = CCTextureCache:sharedTextureCache():addImage(resDic.icon)
                    end
                    if texture then
                        bigSprite:setVisible(true)
                        bigSprite:setTexture(texture)
                        if resDic.rank == 4 then
                            HLAddParticleScale( "images/purpleEquip.plist", bigSprite, ccp(bigSprite:getContentSize().width / 2,bigSprite:getContentSize().height / 2), 
                                1, 100, 777, 2 / 0.35 / retina, 2 / 0.35 / retina, 1 )
                        end
                    end 
                end
                if not havePrefix(itemId, "shadow") then
                    rankBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", resDic.rank)))
                    rankBtn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", resDic.rank)))
                end
                -- 设置数量
                countLabel:setString(amount)
                pos = pos + 1
            end
            -- for i = index, 4 do
            --     local idx = i + 1
            --     -- "littleSprite" .. idx
            --     -- 隐藏index为i的cell
            -- end
            local pLootRank = tolua.cast(unionRacingBattleRewardCellOwner["pLootRank"],"CCLabelTTF")
            pLootRank:setString(HLNSLocalizedString("union.racingBattleReward.pLook" , a1 + 1))
            if a1 + 1 == 11 then
                pLootRank:setString(HLNSLocalizedString("union.racingBattleReward.pLookReward"))
            end
            -- _hbCell:setScale(retina)
            a2:setAnchorPoint(ccp(0, 0))
            _hbCell:setPosition(ccp(10, 0))
            a2:addChild(_hbCell, 0, 1)
            r = a2
        elseif fn == "numberOfCells" then
            r = getMyTableCount(ConfigureStorage.CSRB_leagueloot)
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


--刷新时间显示函数
local function refreshTimeLabel()
    local timerLabel = tolua.cast(unionRacingBattleRewardViewOwner["timeEndLable"], "CCLabelTTF")
    if _data.awardTime.period == "ready" then
        timerLabel:setString("00:00:00")
    else
        local timer = _data.awardTime.nextTime - userdata.loginTime
        if timer < 0 then
            timer = 0
        end
        local day, hour, min, sec = DateUtil:secondGetdhms(timer)
        if day > 0 then
            timerLabel:setString(HLNSLocalizedString("timer.tips.1", day, hour, min, sec))
        elseif hour > 0 then
            timerLabel:setString(HLNSLocalizedString("timer.tips.2", hour, min, sec))
        else
            timerLabel:setString(HLNSLocalizedString("timer.tips.3", min, sec))
        end
    end
end

local function _refreshData()
    local tabBtn1 = tolua.cast(unionRacingBattleRewardViewOwner["tabBtn1"], "CCMenuItemImage")
    local tabBtn2 = tolua.cast(unionRacingBattleRewardViewOwner["tabBtn2"], "CCMenuItemImage")
    
    local rankCount = tolua.cast(unionRacingBattleRewardViewOwner["rankCount"],"CCLabelTTF")
    local raceCount = tolua.cast(unionRacingBattleRewardViewOwner["raceCount"],"CCLabelTTF")
    local RankLabel = tolua.cast(unionRacingBattleRewardViewOwner["RankLabel"],"CCLabelTTF")
    local RaceLabel = tolua.cast(unionRacingBattleRewardViewOwner["RaceLabel"],"CCLabelTTF")

    if _Type == TAP_TYPE.owner then -- 个人
        -- 按钮状态改变
        tabBtn1:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_1.png"))
        tabBtn2:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_0.png"))
        _addTableView1()

        RankLabel:setString(HLNSLocalizedString("union.racingBattle.myRank"))
        RaceLabel:setString(HLNSLocalizedString("union.racingBattle.myRace"))

        raceCount:setString(_data.mySelfRank.myMark)
        rankCount:setString(_data.mySelfRank.myRank)

        if _tableView2 then
            _tableView2:removeFromParentAndCleanup(true)
            _tableView2 = nil
        end
    else
        tabBtn2:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_1.png"))
        tabBtn1:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_0.png"))
        _addTableView2()  

        RankLabel:setString(HLNSLocalizedString("union.racingBattle.teamRank"))
        RaceLabel:setString(HLNSLocalizedString("union.racingBattle.teamRace"))

        raceCount:setString(_data.mySelfRank.myLeagueMark)
        rankCount:setString(_data.mySelfRank.myLeagueRank)

        if _tableView1 then
            _tableView1:removeFromParentAndCleanup(true)
            _tableView1 = nil
        end
    end

    refreshTimeLabel()
    -- 三个状态 1、ready 不倒计时，不能领取 2、in 可以领取、倒计时 3、before 倒计时、不可领取
    local timeLableStatu = tolua.cast(unionRacingBattleRewardViewOwner["timeLableStatu"],"CCLabelTTF")
    local getRewardBtn = tolua.cast(unionRacingBattleRewardViewOwner["getRewardBtn"],"CCMenuItemImage")
    timeLableStatu:setString(HLNSLocalizedString("union.racingBattle.RewardEnd"))  

    if  _data.awardTime.period == "in" then
        
        -- 已经领取
        -- 
        if _Type == TAP_TYPE.owner then  -- 当前状态  在个人
            if _data.awardStatus.personal == 1 then -- 成功领取
                print("成功领取")
                 getRewardBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn7_2.png"))
                getRewardBtn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn7_2.png"))
            else
                print("个人奖励未领取")
                getRewardBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn7_0.png"))
                getRewardBtn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn7_1.png"))
            end
        else
            if _data.awardStatus.league == 1 then -- 成功领取
                print("成功领取")
                getRewardBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn7_2.png"))
                getRewardBtn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn7_2.png"))

            elseif _data.mySelfRank.myMark == 0 and _data.awardStatus.league == 0 then
                print("联盟有奖励，但是个人没有参与")
                getRewardBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn7_2.png"))
                getRewardBtn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn7_2.png"))
            else
                print("联盟奖励未领取" , _data.awardStatus.league)
                getRewardBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn7_0.png"))
                getRewardBtn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn7_1.png"))
            end
        end
    else
        if _data.awardTime.period == "before" then
            timeLableStatu:setString(HLNSLocalizedString("union.racingBattle.RewardStart"))
        end
        getRewardBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn7_2.png"))
        getRewardBtn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn7_2.png"))
    end
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
unionRacingBattleRewardViewOwner["teamClick"] = teamClick

-- 点击个人
local function ownerClick(  ) 
    if _Type == TAP_TYPE.owner then
        return
    else
        _Type = TAP_TYPE.owner
        _refreshData()
    end
end
unionRacingBattleRewardViewOwner["ownerClick"] = ownerClick


-- 领取奖励
local function getRewardBtnTaped(  ) 
    local getRewardBtn = tolua.cast(unionRacingBattleRewardViewOwner["getRewardBtn"],"CCMenuItemImage")
    if  _data.awardTime.period == "in" then

        local function callBack( url,rtnData )
            -- 成功领取
            _data = rtnData.info
            getRewardBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn7_2.png"))
            getRewardBtn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn7_2.png"))
        end

        local myType
        if _Type == TAP_TYPE.owner then
            myType = 0  -- 个人
            if _data.mySelfRank.myMark ~= 0 and _data.awardStatus.personal == 0 then  -- 未领取奖励

                doActionFun("CROSSSERVERRACEBATTLE_GETMARKRANKAWARD", {myType}, callBack)  -- 参数 type 0 个人 、1 联盟
            else
                getRewardBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn7_2.png"))
                getRewardBtn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn7_2.png"))
                ShowText(HLNSLocalizedString("union.racingBattle.haveNotReward"))
                return
            end
        else
            myType = 1  -- 联盟
            if _data.mySelfRank.myMark ~= 0 and _data.awardStatus.league == 0 then  -- 未领取奖励

                doActionFun("CROSSSERVERRACEBATTLE_GETMARKRANKAWARD", {myType}, callBack)  -- 参数 type 0 个人 、1 联盟
            else
                getRewardBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn7_2.png"))
                getRewardBtn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn7_2.png"))
                ShowText(HLNSLocalizedString("union.racingBattle.haveNotReward"))
                return
            end
        end
    else
        ShowText(HLNSLocalizedString("union.racingBattle.haveNotReward"))
    end
end
unionRacingBattleRewardViewOwner["getRewardBtnTaped"] = getRewardBtnTaped


local function getUnionRacingBattleDataCallBack( url,rtnData )
    _data = rtnData.info
    print("-------------------------")
    PrintTable(_data)
    _refreshData()
end

local function getUnionRacingBattleRewardData()
    doActionFun("CROSSSERVERRACEBATTLE_GETAWARDINFO",{},getUnionRacingBattleDataCallBack)
end

local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/unionRacingBattleRewardView.ccbi",proxy, true,"unionRacingBattleRewardViewOwner")
    _layer = tolua.cast(node,"CCLayer")
end

local function setMenuPriority()
    local menu = tolua.cast(unionRacingBattleRewardViewOwner["menu"], "CCMenu")
    menu:setHandlerPriority(-133)
    local refreshMenu = tolua.cast(unionRacingBattleRewardViewOwner["refreshMenu"], "CCMenu")
    refreshMenu:setHandlerPriority(-133)

end

function getUnionRacingBattleRewardViewLayer()
	return _layer
end

function createUnionRacingBattleRewardViewLayer( )

    _Type = TAP_TYPE.owner
    _init()

    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
        getUnionRacingBattleRewardData()
        addObserver(NOTI_TICK, refreshTimeLabel)
    end

    local function _onExit()
        removeObserver(NOTI_TICK, refreshTimeLabel)
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