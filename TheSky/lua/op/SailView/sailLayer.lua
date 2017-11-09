local _layer
local bigStageArray
local eBigStageArray
local bigStageTableView
local bigStageSelected
local smallStageTableView
local smallStageCount
local openIndex
local smallStageOffsetY

local DETAIL_BG_HIGHT = 270
local NOR_BG_HIGHT = 120
local DIALOG_BG_HIGHT = 230
local GOTO_HIGHT = 80
local TITLE_HIGHT = 105

local E_DETAIL_BG_HIGHT = 380

local hasSmallLight = false

local lastIndex = 0 -- 上一次展开的索引

local cardType
local CARDTYPE = {
    clearFightCount = 1,
    clearSweepTime = 2,
    openSweep = 3,
    clearSweepTimeVIP = 4,
    clearFightCountVIP = 5,
    buyEvidence = 6, --买掠夺证明
}
local confirmCardStageId
local _sweepType
local _sweepCount
local _stageId
local _evidenceNeed  --掠夺证明所需个数
local _itemEvidence = "item_025" --掠夺证明

local stageOpenNew = false

stageMode = 1
STAGE_MODE = {
    NOR = 1,
    ELITE = 2
}
local location = false

-- 名字不要重复
SailOwner = SailOwner or {}
ccb["SailOwner"] = SailOwner

local StageDialogOwner = StageDialogOwner or {}

local StageEatOwner = StageEatOwner or {}

local StageVideoOwner = StageVideoOwner or {}

local StageGoonOwner = StageGoonOwner or {}

local StageOwner = StageOwner or {}

local StageDetailOwner = StageDetailOwner or {}

local StageMarineOwner = StageMarineOwner or {}

local StageEDetailOwner = StageEDetailOwner or {}
local StageEDialogOwner = StageEDialogOwner or {}
local StageEOwner = StageEOwner or {}

local function playStageTalk()
    local talkArray = storydata:getStageTalk(bigStageSelected)
    if not talkArray or table.getTableCount(talkArray) <= 0 then
        return
    end
    getMainLayer():getParent():addChild(createStageTalkLayer(talkArray))
end

local function videoItemClick()
    playStageTalk()
end
StageVideoOwner["videoItemClick"] = videoItemClick

local function addStoryAwardCallback(url, rtnData)
    storydata.pageData = rtnData.info.storys.pageData 
    runtimeCache.sailTableOffsetY = smallStageTableView:getContentOffset().y
    _layer:refreshSmallStage()
end

local function eatItemClick()
    if storydata:bPageCanEat(bigStageSelected) then
        doActionFun("ADD_STORY_PAGE_AWARD", {string.format("stage_%02d", bigStageSelected)}, addStoryAwardCallback)
    else
        ShowText(HLNSLocalizedString("sail.eat.need3star"))
    end
end
StageEatOwner["eatItemClick"] = eatItemClick

local function refreshSmallStageOffset()
    local _mainLayer = getMainLayer()
    if smallStageTableView:getContentSize().height < winSize.height - (TITLE_HIGHT * retina + _mainLayer:getTitleContentSize().height + _mainLayer:getBroadCastContentSize().height + _mainLayer:getBottomContentSize().height) then
        return
    end
    local d_height = DETAIL_BG_HIGHT
    local bigRecord = tonumber(string.sub(storydata.record, 7, 8))
    if stageMode == STAGE_MODE.ELITE then
        d_height = E_DETAIL_BG_HIGHT
        bigRecord = tonumber(string.sub(elitedata.currentStage, 12, 15))
    end
    if location then
        local y = math.min(winSize.height - (TITLE_HIGHT * retina + _mainLayer:getTitleContentSize().height + _mainLayer:getBroadCastContentSize().height + _mainLayer:getBottomContentSize().height) 
            - smallStageTableView:getContentSize().height + (openIndex - 1) * NOR_BG_HIGHT * retina + DIALOG_BG_HIGHT * retina, 0)
        smallStageTableView:setContentOffsetInDuration(ccp(0, y), 0.2)
        return
    end
    if openIndex == 0 then
        local y = math.min(smallStageOffsetY + d_height * retina, 0)
        smallStageTableView:setContentOffset(ccp(0, y))
    else
        if lastIndex == 0 then
            smallStageTableView:setContentOffset(ccp(0, smallStageOffsetY - d_height * retina))
        else
            smallStageTableView:setContentOffset(ccp(0, smallStageOffsetY))
        end
        local point = (smallStageCount - openIndex) * NOR_BG_HIGHT
        if bigRecord > bigStageSelected then
            point = point + GOTO_HIGHT * 2 + NOR_BG_HIGHT
        end
        point = point * retina + smallStageTableView:getContentOffset().y -- 展开项左下到tableview显示区域左下的偏移
        if point > 0 and -- 能全部展示
         winSize.height - (TITLE_HIGHT * retina + _mainLayer:getTitleContentSize().height + _mainLayer:getBroadCastContentSize().height + _mainLayer:getBottomContentSize().height) - point > (NOR_BG_HIGHT + d_height) * retina -- 留给展开项显示高度足够
            then
            return
        end
        local y = math.min(winSize.height - (TITLE_HIGHT * retina + _mainLayer:getTitleContentSize().height + _mainLayer:getBroadCastContentSize().height + _mainLayer:getBottomContentSize().height) 
            - smallStageTableView:getContentSize().height + (openIndex - 1) * NOR_BG_HIGHT * retina + DIALOG_BG_HIGHT * retina, 0)
        smallStageTableView:setContentOffsetInDuration(ccp(0, y), 0.2)
    end

end

local function storyBattleCallback(url, rtnData)
    runtimeCache.responseData = rtnData["info"]
    -- 不要提
    CCDirector:sharedDirector():replaceScene(CCTransitionFade:create(0.6, FightingScene()))
    
    -- if BattleField.result == RESULT_WIN then
    --     CCDirector:sharedDirector():replaceScene(FightingResultSceneFun(ResultType.SailWin))
    --     -- CCDirector:sharedDirector():replaceScene(CCTransitionFade:create(0.6, FightingResultSceneFun(ResultType.SailWin)))
    -- else
    --     CCDirector:sharedDirector():replaceScene(FightingResultSceneFun(ResultType.SailLose))
    --     -- CCDirector:sharedDirector():replaceScene(CCTransitionFade:create(0.6, FightingResultSceneFun(ResultType.SailLose)))
    -- end
end

local function storyFight(stageId)
    stageOpenNew = stageId == storydata.record
    BattleField.leftName = userdata.name
    BattleField.rightName = storydata:getSmallStage(stageId).npcname
    RandomManager.cursor = RandomManager.randomRange(0, 999)
    local seed = RandomManager.cursor
    BattleField:stageFight(stageId)
    if BattleField.result == RESULT_WIN and storydata:bFirstPageLastStage(bigStageSelected, stageId) then
        print("let's take a mother fucking look")
        runtimeCache.bPlayStageTalk = true
    else
        runtimeCache.bPlayStageTalk = false
    end
    local result = BattleField.result == RESULT_WIN and 4 - BattleField.round or 0
    if runtimeCache.bGuide then
        doActionFun("STORYBATTLE_URL", {stageId, result, 1, seed, runtimeCache.guideStep - 1}, storyBattleCallback) 
    else
        doActionFun("STORYBATTLE_URL", {stageId, result, 1, seed}, storyBattleCallback)
    end
end

local function eliteFight(stageId)
    stageOpenNew = stageId == elitedata.record
    BattleField.leftName = userdata.name
    BattleField.rightName = elitedata:getSmallStage(stageId).npcname
    RandomManager.cursor = RandomManager.randomRange(0, 999)
    local seed = RandomManager.cursor
    BattleField:eliteFight(stageId)
    runtimeCache.bPlayStageTalk = false
    local result = BattleField.result == RESULT_WIN and 4 - BattleField.round or 0
    doActionFun("ELITE_BATTLE", {stageId, result, seed}, storyBattleCallback)
end

local function addSmallStageTableView()
    local dic = bigStageArray[bigStageSelected]
    smallStageCount = #storydata:getVisSmallStages(bigStageSelected) -- 显示的关卡数
    local h = LuaEventHandler:create(function(fn, t, a1, a2)

        local function clearFightCountCallback(url, rtnData)
            storydata.stageData[confirmCardStageId].times = 0
            runtimeCache.sailTableOffsetY = smallStageTableView:getContentOffset().y
            _layer:refreshSmallStage()
        end

        local function clearSweepTimeCallback(url, rtnData)
            storydata.nextBatchTime = 0
            runtimeCache.sailTableOffsetY = smallStageTableView:getContentOffset().y
            _layer:refreshSmallStage()
        end

        --lsf 快速闯荡回调 写数据 弹框出结果
        local function sweepCallback(url, rtnData) 
            local dic = rtnData["info"]
            storydata.record = dic.storys.record
            storydata.stageData = dic.storys.stageData
            storydata.pageData = dic.storys.pageData
            storydata.nextBatchTime = dic.storys.nextBatchTime
            runtimeCache.sailTableOffsetY = smallStageTableView:getContentOffset().y
            _layer:refreshSmallStage()
            if _sweepType == "tenTimes" then
                getMainLayer():addChild(createSweepInfoLayer(dic,"ten_big", -134), 200)
            elseif _sweepType == "once" then
                getMainLayer():addChild(createSweepInfoLayer(dic,"one_small", -134), 200)
            end
        end


        local function cardConfirmAction()
            if cardType == CARDTYPE.clearFightCount then
                doActionFun("CLEAR_STORY_STAGE_LIMIT", {confirmCardStageId}, clearFightCountCallback)
            -- elseif cardType == CARDTYPE.clearSweepTime then
            --     doActionFun("CLEAR_STORY_BATCH_CDTIME", {}, clearSweepTimeCallback)
            elseif cardType == CARDTYPE.openSweep or cardType == CARDTYPE.clearSweepTimeVIP or cardType == CARDTYPE.clearFightCountVIP then
                CCDirector:sharedDirector():getRunningScene():addChild(createShopRechargeLayer(-400), 100)
            elseif cardType == CARDTYPE.buyEvidence then --确定买掠夺证明后,直接调用扫荡接口,后台自动会扣钱,扣掠夺证明
                print("**lsf buyEvidence _evidenceNeed",_evidenceNeed)
                doActionFun("STORY_BATTLE_NEW", {_stageId, _sweepCount}, sweepCallback)
            end 
        end

        local function cardCancelAction()
        
        end

        -- 清除战斗次数
        local function clearFightCount(stageId)
            confirmCardStageId = stageId
            local text = ""
            if vipdata:getVipLevel() < vipdata:getVipFightingLevel() then
                -- 船长，您今天已经挑战？？次，成为VIP3可以增加战斗次数，快去充值享受贵族待遇吧！
                cardType = CARDTYPE.clearFightCountVIP
                local stageDic = storydata:getSmallStage(stageId)
                text = HLNSLocalizedString("sail.clearFightCountVIP", storydata:getStageConfFightCount(stageDic["type"]),
                                            vipdata:getVipFightingLevel()) 
            else
                -- 船长，不要让您高昂的战意冷却下来，只需要消耗5金币可增加挑战次数，满足您继续战斗下去的愿望！
                cardType = CARDTYPE.clearFightCount
                text = HLNSLocalizedString("sail.clearFightCount", 
                                            ConfigureStorage.storyClearStageLimit.gold) 
            end
            _layer:addChild(createSimpleConfirCardLayer(text), 100)
            SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
            SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction
        end
        --[[  lsf 取消冷却功能
        -- 清除连闯cd
        local function clearSweepTime()
            print("清除cd")  
            local text = ""
            if vipdata:getVipLevel() < vipdata:getVipRaidsCDLevel() then
                -- 船长，您的VIP等级不够，成为VIP6可以清除连闯冷却时间，快去充值享受贵族待遇吧！
                cardType = CARDTYPE.clearSweepTimeVIP

                text = HLNSLocalizedString("sail.clearSweepTimeVIP",
                                            vipdata:getVipRaidsCDLevel())
            else
                -- 船长，不要让您高昂的战意冷却下来，只需要消耗5金币可清除连闯冷却时间，满足您继续战斗下去的愿望吧！
                cardType = CARDTYPE.clearSweepTime
                text = HLNSLocalizedString("sail.clearSweepTime",
                                            ConfigureStorage.storyClearBatchCDTime.gold)

            end
            _layer:addChild(createSimpleConfirCardLayer(text), 100)
            SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
            SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction
        end
        ]]
        -- vip 开启连闯
        local function openSweep()
            cardType = CARDTYPE.openSweep
            --船长，您的VIP等级不够，成为VIP%d可以进行快速战斗，快些充值吧！
            local text = HLNSLocalizedString("newWorld.openSweepOnce", vipdata:getVipRaidsLevel())
            _layer:addChild(createSimpleConfirCardLayer(text), 100)
            SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
            SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction
        end

        local function fightItemClick(tag)
            print("来战", tag)
            local stageId = storydata:getSmallStages(bigStageSelected)[tag]
            local stageDic = storydata:getSmallStage(stageId)
            if storydata:getStageConfFightCount(stageDic["type"]) <= storydata:getStageFightCount(stageId) then
                clearFightCount(stageId)
                return
            end
            storyFight(stageId)
        end
        StageDetailOwner["fightItemClick"] = fightItemClick
        StageOwner["fightItemClick"] = fightItemClick

        local function adventureClick()
            getMainLayer():gotoAdventure()
            getAdventureLayer():showMarine()
        end
        StageMarineOwner["adventureClick"] = adventureClick

        -- lsf 林绍峰 扫荡10次 扫荡1次 的共用函数
        local function sweepItem()
            --vip
            if vipdata:getVipLevel() < vipdata:getVipRaidsLevel() then
                openSweep()
                return
            end
            --体力
            if userdata.strength == 0 then
                CCDirector:sharedDirector():getRunningScene():addChild(createRecoverInfoLayer(0), 100)
                return
            end
            local dic = bigStageArray[bigStageSelected]
            local stageId = dic.pageStage[openIndex]
            _stageId = stageId
            local stageDic = storydata:getSmallStage(stageId)
            --剩余次数
            local sweepCount = math.min(math.min(math.max(storydata:getStageConfFightCount(stageDic["type"]) - storydata:getStageFightCount(stageId), 0), userdata.strength), 10)
            if sweepCount <= 0 then
                clearFightCount(stageId)
                return
            end
            if _sweepType == "once" then
                sweepCount = 1
            end
            _sweepCount = sweepCount

            if wareHouseData:getItemCountById( _itemEvidence ) < sweepCount then -- 掠夺证明不足
                cardType = CARDTYPE.buyEvidence
                local itemCount = wareHouseData:getItemCountById( _itemEvidence )
                _evidenceNeed = sweepCount - itemCount
                _layer:addChild(createSimpleConfirCardLayer(  
                    string.format(HLNSLocalizedString("sail.sweep.lackOfEvidence" ),itemCount,_evidenceNeed) 
                  ),100)
                SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
                SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction
                return
            end      
            runtimeCache.sailTableOffsetY = smallStageTableView:getContentOffset().y
            print("**lsf sweepCallback table")
            doActionFun("STORY_BATTLE_NEW", {stageId, sweepCount}, sweepCallback)
        end
        -- lsf 林绍峰 快速扫荡 扫荡10次
        local function sweepItemClick(tag)
            _sweepType = "tenTimes"
            sweepItem()
        end
        StageDetailOwner["sweepItemClick"] = sweepItemClick

        -- lsf 林绍峰 快速扫荡 扫荡1次
        local function sweepOnceItemClick(tag)
            _sweepType = "once"
            sweepItem()
        end
        StageDetailOwner["sweepOnceItemClick"] = sweepOnceItemClick


        local r
        if fn == "cellSize" then
            if a1 == 0 then
                -- 剧情
                r = CCSizeMake(winSize.width, DIALOG_BG_HIGHT * retina)
            elseif a1 <= smallStageCount then
                -- 小关
                if a1 == openIndex then
                    r = CCSizeMake(winSize.width, (NOR_BG_HIGHT + DETAIL_BG_HIGHT) * retina)
                else
                    r = CCSizeMake(winSize.width, NOR_BG_HIGHT * retina)
                end
            else
                local offset = storydata:bPageAte(bigStageSelected) and 0 or 1
                if not storydata:bPageAte(bigStageSelected) and a1 == smallStageCount + 1 then
                    -- 吃
                    r = CCSizeMake(winSize.width, NOR_BG_HIGHT * retina)
                end
                if storydata:getMarineId(bigStageSelected) and a1 == smallStageCount + offset + 1 then
                    r = CCSizeMake(winSize.width, NOR_BG_HIGHT * retina)
                end
                if storydata:getMarineId(bigStageSelected) then
                    offset = offset + 1
                end
                if a1 == smallStageCount + offset + 1 then
                    -- 剧情重现
                    r = CCSizeMake(winSize.width, GOTO_HIGHT * retina)
                elseif a1 == smallStageCount + offset + 2 then
                    -- 继续
                    r = CCSizeMake(winSize.width, GOTO_HIGHT * retina)
                end
                -- print(a1, r.height)
            end
        elseif fn == "cellAtIndex" then
            -- Return CCTableViewCell, a1 is cell index (zero based), a2 is dequeued cell (maybe nil)
            -- Do something to create cell and change the content
            local proxy = CCBProxy:create()
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            if a1 == 0 then
                -- 剧情
                ccb["StageDialogOwner"] = StageDialogOwner
                local node = CCBReaderLoad("ccbResources/stageDialogView.ccbi",proxy, true,"StageDialogOwner")
                local cell = tolua.cast(node, "CCSprite")
                cell:setScale(retina)
                a2:addChild(cell)
                cell:setAnchorPoint(ccp(0.5, 0.5))
                cell:setPosition(winSize.width / 2, DIALOG_BG_HIGHT * retina / 2)
                local bg = tolua.cast(StageDialogOwner["bg"], "CCSprite")
                if dic.pageBg then
                    local f = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("%s.png", dic.pageBg))
                    if f then
                        bg:setDisplayFrame(f)
                    end
                end
                desp = string.gsub(dic.pageDesp, "[$]", "\r\n")
                local dialogLabel = tolua.cast(StageDialogOwner["dialogLabel"], "CCLabelTTF")
                dialogLabel:setString(desp)
                local dialogLabel_s = tolua.cast(StageDialogOwner["dialogLabel_s"], "CCLabelTTF")
                dialogLabel_s:setString(desp)
                if userdata.eliteClose and userdata.eliteClose == 1 then
                    StageDialogOwner["changeEModeBtn"]:setVisible(false)
                    StageDialogOwner["changeEModeSp"]:setVisible(false)
                end

                --普通模式关卡双倍掉落
                local DoubleDropBg = tolua.cast(StageDialogOwner["experenceItem"], "CCSprite")
                if DoubleDropBg then
                    DoubleDropBg:setVisible(loginActivityData:isDoubleDropOpen())
                end
                
            elseif a1 <= smallStageCount then
                -- 小关
                local stageId = dic.pageStage[a1]
                local stageDic = storydata:getSmallStage(stageId)
                local starCount = storydata:getStageStar(stageId)
                local canFight = storydata:canFight(stageId)
                local node
                if a1 ~= openIndex then
                    ccb["StageOwner"] = StageOwner
                    node  = CCBReaderLoad("ccbResources/StageNorView.ccbi",proxy, true,"StageOwner")
                else
                    ccb["StageDetailOwner"] = StageDetailOwner
                    node  = CCBReaderLoad("ccbResources/StageDetailView.ccbi",proxy, true,"StageDetailOwner")
                end
                local cell = tolua.cast(node, "CCSprite")
                cell:setScale(retina)
                a2:addChild(cell, 1, 100)
                cell:setAnchorPoint(ccp(0.5, 0))
                cell:setPosition(winSize.width / 2, 0)
                local frameName
                local headFrameName
                if stageDic["type"] == 0 then
                    frameName = "bg_nor.png"
                    headFrameName = "frame_1.png"
                elseif stageDic["type"] == 1 then
                    frameName = "bg_sp.png"
                    headFrameName = "frame_2.png"
                else
                    frameName = "bg_boss.png"
                    headFrameName = "frame_3.png"
                end
                local owner
                if a1 ~= openIndex then
                    owner = StageOwner
                else
                    owner = StageDetailOwner
                end
                local stageSp = tolua.cast(owner["stageSp"], "CCSprite")
                stageSp:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(frameName))
                local stageNameLabel = tolua.cast(owner["stageNameLabel"], "CCLabelTTF")
                stageNameLabel:setString(stageDic.stageName)
                local frame = tolua.cast(owner["frame"], "CCSprite")
                frame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(headFrameName))
                local head = tolua.cast(owner["head"], "CCSprite")
                if stageDic.stageHead then
                    local f = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("%s.png", stageDic.stageHead))
                    if f then
                        head:setDisplayFrame(f)
                    else
                        head:setVisible(false)
                    end
                else
                    head:setVisible(false)
                end

                --小关卡掉落
                local DoubleDropBg = tolua.cast(StageDetailOwner["huodong"], "CCSprite")
                if DoubleDropBg then
                    DoubleDropBg:setVisible(loginActivityData:isDoubleDropOpen())
                end

                local goldIcon = tolua.cast(owner["goldIcon"], "CCSprite")
                if storydata:getStageConfFightCount(stageDic["type"]) <= storydata:getStageFightCount(stageId) then
                    goldIcon:setVisible(true)
                end
                if a1 == openIndex then
                    local detailLabel = tolua.cast(owner["detailLabel"], "CCLabelTTF")
                    if stageDic.desp then
                        detailLabel:setString(stageDic.desp)
                    end
                    local challengeTimes = tolua.cast(owner["challengeTimes"], "CCLabelTTF")
                    challengeTimes:setString(string.format("%d/%d", storydata:getStageFightCount(stageId), storydata:getStageConfFightCount(stageDic["type"])))
                    local levelLabel = tolua.cast(owner["levelLabel"], "CCLabelTTF")
                    levelLabel:setString(stageDic.level)
                    local expLabel = tolua.cast(owner["expLabel"], "CCLabelTTF")
                    expLabel:setString(stageDic.exp)
                    local bellyLabel = tolua.cast(owner["bellyLabel"], "CCLabelTTF")
                    bellyLabel:setString(stageDic.silver)
                    local sweepText = tolua.cast(owner["sweepText"], "CCLabelTTF")
                    local sweepCount = math.min(math.min(math.max(storydata:getStageConfFightCount(stageDic["type"]) - storydata:getStageFightCount(stageId), 0), userdata.strength), 10)
                    if sweepCount == 0 then
                        sweepText:setString(HLNSLocalizedString("sail.sweep0"))
                    else
                        sweepText:setString(HLNSLocalizedString("sail.sweep", sweepCount))
                    end
                    local sweepOnceText = tolua.cast(owner["sweepOnceText"], "CCLabelTTF")
                    sweepOnceText:setString(HLNSLocalizedString("sail.sweep1"))
                    local sweepEvidenceCountText = tolua.cast(owner["sweepEvidenceCountText"], "CCLabelTTF")
                    local itemCount =  wareHouseData:getItemCountById(_itemEvidence)
                    if itemCount > 9999 then
                        sweepEvidenceCountText:setString( "1/9999+" )
                    else 
                        sweepEvidenceCountText:setString( "1/" .. tostring(itemCount) )
                    end
                    local sweepEvidenceText = tolua.cast(owner["sweepEvidenceText"], "CCLabelTTF")
                    sweepEvidenceText:setString( HLNSLocalizedString( "sail.sweepEvidence") )
                    if not stageDic.award or table.getTableCount(stageDic.award) == 0 then
                        local rewardTitle = tolua.cast(owner["rewardTitle"], "CCLabelTTF")
                        rewardTitle:setVisible(false)
                    else
                        local index = 1
                        for itemId,v in pairs(stageDic.award) do
                            local awardFrame = tolua.cast(owner["awardFrame"..index], "CCSprite")
                            awardFrame:setVisible(true)
                            local resDic = userdata:getExchangeResource(itemId)

                            local contentLayer = tolua.cast(owner["contentLayer"..index],"CCLayer")
                            local bigSprite = tolua.cast(owner["bigSprite"..index],"CCSprite")
                            local chipIcon = tolua.cast(owner["chipIcon"..index],"CCSprite")
                            local littleSprite = tolua.cast(owner["littleSprite"..index],"CCSprite")
                            local soulIcon = tolua.cast(owner["soulIcon"..index],"CCSprite")

                            if havePrefix(itemId, "weapon_") or havePrefix(itemId, "belt_") or havePrefix(itemId, "armor_") then
                                -- 装备
                                bigSprite:setVisible(true)
                                local texture
                                if haveSuffix(itemId, "_shard") then
                                    chipIcon:setVisible(true)
                                    texture = CCTextureCache:sharedTextureCache():addImage(string.format("ccbResources/icons/%s.png", resDic.icon))
                                else
                                    texture = CCTextureCache:sharedTextureCache():addImage(resDic.icon)
                                end
                                if texture then
                                    bigSprite:setVisible(true)
                                    bigSprite:setTexture(texture)
                                end
                            elseif havePrefix(itemId, "item") then
                                -- 道具
                                bigSprite:setVisible(true)
                                local texture = CCTextureCache:sharedTextureCache():addImage(resDic.icon)
                                if texture then
                                    bigSprite:setVisible(true)
                                    bigSprite:setTexture(texture)
                                end
                            elseif havePrefix(itemId, "shadow") then
                                -- 影子
                                local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
                                cache:addSpriteFramesWithFile("ccbResources/shadow.plist")
                                awardFrame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("s_frame.png"))
                                awardFrame:setPosition(ccp(awardFrame:getPositionX() + 5,awardFrame:getPositionY() - 5))
                                if resDic.icon then
                                    playCustomFrameAnimation( string.format("yingzi_%s_",resDic.icon),contentLayer,ccp(contentLayer:getContentSize().width / 2,contentLayer:getContentSize().height / 2),1,4,shadowData:getColorByColorRank( resDic.rank ) )
                                end
                            elseif havePrefix(itemId, "hero") then
                                -- 魂魄
                                littleSprite:setVisible(true)
                                littleSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(resDic.icon))

                            elseif havePrefix(itemId, "book") then
                                -- 奥义
                                bigSprite:setVisible(true)
                                local texture = CCTextureCache:sharedTextureCache():addImage(resDic.icon)
                                if texture then
                                    bigSprite:setVisible(true)
                                    bigSprite:setTexture(texture)
                                end
                            else
                                -- 金币 银币
                                bigSprite:setVisible(true)
                                local texture = CCTextureCache:sharedTextureCache():addImage(resDic.icon)
                                if texture then
                                    bigSprite:setVisible(true)
                                    bigSprite:setTexture(texture)
                                end
                            end
                            if not havePrefix(itemId, "shadow") then
                                awardFrame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", resDic.rank)))
                            end
                            index = index + 1
                        end
                    end
                    --_updateSweepTime()
                    local expDoubleBg = tolua.cast(owner["expDoubleBg"], "CCSprite")
                    if expDoubleBg then
                        if userdata:hasBattleDouble() then
                            expDoubleBg:setVisible(true)
                            local expDouble = tolua.cast(owner["expDouble"], "CCLabelTTF")
                            expDouble:setString(string.format("×%d", ConfigureStorage.battleDouble.expTimes))
                        end
                    end
                end
                
                for i=1,starCount do
                    local star = tolua.cast(owner["star"..i], "CCSprite")
                    star:setVisible(true)
                end
                local fightItem = tolua.cast(owner["fightItem"], "CCMenuItem")
                local sweepItem = tolua.cast(owner["sweepItem"], "CCMenuItem")
                local sweepText = tolua.cast(owner["sweepText"], "CCLabelTTF")
                local sweepOnceItem = tolua.cast(owner["sweepOnceItem"], "CCMenuItem")
                local sweepOnceText = tolua.cast(owner["sweepOnceText"], "CCLabelTTF")
                local sweepEvidenceCountText = tolua.cast(owner["sweepEvidenceCountText"], "CCLabelTTF")
                local sweepEvidenceText = tolua.cast(owner["sweepEvidenceText"], "CCLabelTTF")


                if not canFight then
                    fightItem:setVisible(false)
                end
                fightItem:setTag(a1)

                -- renzhan
               if bigStageSelected <= 5 and canFight and starCount == 0 then
                    if bigStageSelected <= 5 then
                        local light = fightItem:getChildByTag(300)
                        if not light then
                            light = CCSprite:createWithSpriteFrameName("lightEffect_smallStage_1.png")
                            local animFrames = CCArray:create()
                            for j = 1, 4 do
                                local frameName = string.format("lightEffect_smallStage_%d.png",j)
                                local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(frameName)
                                animFrames:addObject(frame)
                            end
                            local animation = CCAnimation:createWithSpriteFrames(animFrames, 0.1)
                            local animate = CCAnimate:create(animation)
                            light:runAction(CCRepeatForever:create(animate))
                            fightItem:addChild(light,1,300)
                            light:setPosition(ccp(fightItem:getContentSize().width / 2 + 5,fightItem:getContentSize().height / 2 + 2.5))
                        end
                    end
                end
                -- 
                if sweepItem and sweepOnceItem then
                    sweepItem:setTag(a1)
                    sweepOnceItem:setTag(a1)
                    if starCount < 3 then
                        sweepItem:setVisible(false)
                        sweepOnceItem:setVisible(false)
                    end
                end
                if sweepText and sweepOnceText then
                    if starCount < 3 then
                        sweepText:setVisible(false)
                        sweepOnceText:setVisible(false)
                    end
                end
                if sweepEvidenceCountText and sweepEvidenceText then
                    if starCount < 3 then
                        sweepEvidenceCountText:setVisible(false)
                        sweepEvidenceText:setVisible(false)
                    end
                end

            else
                local offset = storydata:bPageAte(bigStageSelected) and 0 or 1
                if not storydata:bPageAte(bigStageSelected) and a1 == smallStageCount + offset then
                    -- 吃
                    ccb["StageEatOwner"] = StageEatOwner
                    local node = CCBReaderLoad("ccbResources/StageEatView.ccbi",proxy, true,"StageEatOwner")
                    local cell = tolua.cast(node, "CCSprite")
                    cell:setScale(retina)
                    a2:addChild(cell)
                    cell:setAnchorPoint(ccp(0.5, 0.5))
                    cell:setPosition(winSize.width / 2, NOR_BG_HIGHT * retina / 2)
                    local eatItem = tolua.cast(StageEatOwner["eatItem"], "CCMenuItem")
                    eatItem:setEnabled(not storydata:bPageAte(bigStageSelected))

                    local light = eatItem:getChildByTag(9888)
                    if light then
                        light:stopAllActions()
                        light:removeFromParentAndCleanup(true)
                    end
                    
                    local light = CCSprite:createWithSpriteFrameName("lightingEffect_recruitBtn_1.png")
                    local animFrames = CCArray:create()
                    for j = 1, 3 do
                        local frameName = string.format("lightingEffect_recruitBtn_%d.png",j)
                        local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(frameName)
                        animFrames:addObject(frame)
                    end
                    local animation = CCAnimation:createWithSpriteFrames(animFrames, 0.2)
                    local animate = CCAnimate:create(animation)
                    light:runAction(CCRepeatForever:create(animate))
                    eatItem:addChild(light,1,9888)
                    light:setPosition(ccp(eatItem:getContentSize().width / 2,eatItem:getContentSize().height / 2 + 2))


                end
                if storydata:getMarineId(bigStageSelected) and a1 == smallStageCount + offset + 1 then
                    local marineId = storydata:getMarineId(bigStageSelected)
                    ccb["StageMarineOwner"] = StageMarineOwner
                    local node = CCBReaderLoad("ccbResources/StageMarineView.ccbi", proxy, true, "StageMarineOwner")
                    local cell = tolua.cast(node, "CCSprite")
                    cell:setScale(retina)
                    a2:addChild(cell)
                    cell:setAnchorPoint(ccp(0.5, 0.5))
                    cell:setPosition(winSize.width / 2, NOR_BG_HIGHT * retina / 2)
                    local marineTips = tolua.cast(StageMarineOwner["marineTips"], "CCLabelTTF")
                    local marineName = marineBranchData:getConfig(marineId).nsname
                    marineTips:setString(string.format(marineTips:getString(), marineName))
                    local marineIcon = tolua.cast(StageMarineOwner["marineIcon"], "CCLabelTTF")

                    local nums = string.split(marineName, "-")[2]
                    local strLen = string.len(nums)
                    local spriteG = CCSprite:createWithSpriteFrameName("num_G.png")
                    local startPointX = (marineIcon:getContentSize().width - (strLen + 1) * spriteG:getContentSize().width) / 2
                    marineIcon:addChild(spriteG)
                    spriteG:setPosition(ccp(startPointX + spriteG:getContentSize().width / 2,spriteG:getContentSize().height / 2))
                    for i=1, strLen do
                        local char = string.sub(nums, i, i)
                        local spriteCount = CCSprite:createWithSpriteFrameName(string.format("num_%s.png", char))
                        marineIcon:addChild(spriteCount)
                        spriteCount:setPosition(ccp(startPointX + spriteG:getContentSize().width * i + spriteG:getContentSize().width / 2,spriteG:getContentSize().height / 2))
                    end
                end
                if storydata:getMarineId(bigStageSelected) then
                    offset = offset + 1
                end
                if a1 == smallStageCount + offset + 1 then
                    -- 剧情重现
                    ccb["StageVideoOwner"] = StageVideoOwner
                    local cell = tolua.cast(CCBReaderLoad("ccbResources/StageVideoView.ccbi",proxy,true,"StageVideoOwner"), "CCLayer")
                    cell:setScale(retina)
                    a2:addChild(cell)
                    a2:setAnchorPoint(ccp(0, 0))
                    a2:setPosition(0, 0)
                elseif a1 == smallStageCount + offset + 2 then
                    -- 继续
                    ccb["StageGoonOwner"] = StageGoonOwner
                    local cell = tolua.cast(CCBReaderLoad("ccbResources/StageGoonView.ccbi",proxy,true,"StageGoonOwner"), "CCLayer")
                    cell:setScale(retina)
                    a2:addChild(cell)
                    a2:setAnchorPoint(ccp(0, 0))
                    a2:setPosition(0, 0)
                end
            end
            r = a2
        elseif fn == "numberOfCells" then
            -- Return number of cells
            r = smallStageCount + 1
            if tonumber(string.sub(storydata.record, 7, 8)) > bigStageSelected then
                r = r + 2
                if not storydata:bPageAte(bigStageSelected) then
                    r = r + 1
                end
                if storydata:getMarineId(bigStageSelected) then
                    r = r + 1
                end
            end
        -- Cell events:
        elseif fn == "cellTouched" then         -- A cell was touched, a1 is cell that be touched. This is not necessary.
            if a1:getIdx() == 0 or a1:getIdx() > smallStageCount then
                return r
            end
            local owner
            local fightItem
            if a1:getIdx() ~= openIndex then
                owner = StageOwner
                fightItem = tolua.cast(a1:getChildByTag(100):getChildByTag(100):getChildByTag(a1:getIdx()), "CCMenuItem")
            else
                owner = StageDetailOwner
                fightItem = tolua.cast(owner["fightItem"], "CCMenuItemImage")
            end
            local sweepItem = tolua.cast(owner["sweepItem"], "CCMenuItem")
            local sweepOnceItem = tolua.cast(owner["sweepOnceItem"], "CCMenuItem")
            if sweepItem and sweepItem:isSelected() then
                return r
            end
            if sweepOnceItem and sweepOnceItem:isSelected() then
                return r
            end
            if fightItem:isSelected() then
                return r
            end
            lastIndex = openIndex
            openIndex = openIndex == a1:getIdx() and 0 or a1:getIdx()
            smallStageOffsetY = smallStageTableView:getContentOffset().y
            smallStageTableView:reloadData()
            refreshSmallStageOffset()
        elseif fn == "cellTouchBegan" then      -- A cell is touching, a1 is cell, a2 is CCTouch
        elseif fn == "cellTouchEnded" then      -- A cell was touched, a1 is cell, a2 is CCTouch
        elseif fn == "cellHighlight" then       -- A cell is highlighting, coco2d-x 2.1.3 or above
        elseif fn == "cellUnhighlight" then     -- A cell had been unhighlighted, coco2d-x 2.1.3 or above
        elseif fn == "cellWillRecycle" then     -- A cell will be recycled, coco2d-x 2.1.3 or above
        end
        return r
    end)
    local _mainLayer = getMainLayer()
    local size = CCSizeMake(winSize.width, winSize.height - (TITLE_HIGHT * retina + _mainLayer:getTitleContentSize().height + _mainLayer:getBroadCastContentSize().height + _mainLayer:getBottomContentSize().height))
    smallStageTableView = LuaTableView:createWithHandler(h, size)
    smallStageTableView:setBounceable(true)
    smallStageTableView:setAnchorPoint(ccp(0, 0))
    smallStageTableView:setPosition(ccp(0, _mainLayer:getBottomContentSize().height))
    smallStageTableView:setVerticalFillOrder(0)
    -- bigStageTableView:setDirection(0)
    _layer:addChild(smallStageTableView, 10, 10)
end

-- 精英小关卡
local function addESmallStageTableView()
    local dic = eBigStageArray[bigStageSelected]
    smallStageCount = #elitedata:getVisSmallStages(bigStageSelected) -- 显示的关卡数
    local h = LuaEventHandler:create(function(fn, t, a1, a2)

        local function clearFightCountCallback(url, rtnData)
            elitedata.record[confirmCardStageId].times = 0
            runtimeCache.sailTableOffsetY = smallStageTableView:getContentOffset().y
            _layer:refreshSmallStage()
        end

        --lsf 快速闯荡回调 写数据 弹框出结果
        local function sweepCallback(url, rtnData) 
            local dic = rtnData["info"]
            elitedata:updateData(dic)
            runtimeCache.sailTableOffsetY = smallStageTableView:getContentOffset().y
            _layer:refreshSmallStage()
            if _sweepType == "tenTimes" then
                getMainLayer():addChild(createSweepInfoLayer(dic,"ten_big", -134), 200)
            elseif _sweepType == "once" then
                getMainLayer():addChild(createSweepInfoLayer(dic,"one_small", -134), 200)
            end
        end


        local function cardConfirmAction()
            if cardType == CARDTYPE.clearFightCount then
                doActionFun("ELITE_RESET", {confirmCardStageId}, clearFightCountCallback)
            elseif cardType == CARDTYPE.openSweep or cardType == CARDTYPE.clearSweepTimeVIP or cardType == CARDTYPE.clearFightCountVIP then
                CCDirector:sharedDirector():getRunningScene():addChild(createShopRechargeLayer(-400), 100)
            elseif cardType == CARDTYPE.buyEvidence then --确定买掠夺证明后,直接调用扫荡接口,后台自动会扣钱,扣掠夺证明
                doActionFun("ELITE_SWEEP", {_stageId, _sweepCount}, sweepCallback)
            end 
        end

        local function cardCancelAction()
        
        end

        -- 清除战斗次数
        local function clearFightCount(stageId)
            confirmCardStageId = stageId
            local text = ""
            if vipdata:getVipLevel() < vipdata:getVipFightingLevel() then
                -- 船长，您今天已经挑战？？次，成为VIP3可以增加战斗次数，快去充值享受贵族待遇吧！
                cardType = CARDTYPE.clearFightCountVIP
                text = HLNSLocalizedString("sail.clearFightCountVIP", elitedata:getStageChallengeCount(stageId),
                                            vipdata:getVipFightingLevel()) 
            else
                -- 船长，不要让您高昂的战意冷却下来，只需要消耗5金币可增加挑战次数，满足您继续战斗下去的愿望！
                cardType = CARDTYPE.clearFightCount
                text = HLNSLocalizedString("sail.clearFightCount", 
                                            elitedata:getResetGold(stageId)) 
            end
            _layer:addChild(createSimpleConfirCardLayer(text), 100)
            SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
            SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction
        end

        -- vip 开启连闯
        local function openSweep()
            cardType = CARDTYPE.openSweep
            --船长，您的VIP等级不够，成为VIP%d可以进行快速战斗，快些充值吧！
            local text = HLNSLocalizedString("newWorld.openSweepOnce", vipdata:getVipRaidsLevel())
            _layer:addChild(createSimpleConfirCardLayer(text), 100)
            SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
            SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction
        end

        local function fightItemClick(tag)
            local stageId = elitedata:getSmallStages(bigStageSelected)[tag]
            local stageDic = elitedata:getSmallStage(stageId)
            if elitedata:getStageChallengeCount(stageId) <= elitedata:getStageFightCount(stageId) then
                clearFightCount(stageId)
                return
            end
            eliteFight(stageId)
        end
        StageEDetailOwner["fightItemClick"] = fightItemClick
        StageEOwner["fightItemClick"] = fightItemClick

        -- lsf 林绍峰 扫荡10次 扫荡1次 的共用函数
        local function sweepItem()
            --vip
            if vipdata:getVipLevel() < vipdata:getVipRaidsLevel() then
                openSweep()
                return
            end
            --体力
            if userdata.strength == 0 then
                CCDirector:sharedDirector():getRunningScene():addChild(createRecoverInfoLayer(0), 100)
                return
            end
            local dic = eBigStageArray[bigStageSelected]
            local stageId = dic.pageStage[openIndex]
            _stageId = stageId
            local stageDic = elitedata:getSmallStage(stageId)
            --剩余次数
            local sweepCount = math.min(math.min(math.max(elitedata:getStageChallengeCount(stageId) - elitedata:getStageFightCount(stageId), 0), math.max(math.floor(userdata.strength / stageDic.pay), 1), 10))
            if sweepCount <= 0 then
                clearFightCount(stageId)
                return
            end
            if _sweepType == "once" then
                sweepCount = 1
            end
            _sweepCount = sweepCount

            if wareHouseData:getItemCountById(_itemEvidence) < sweepCount * 2 then -- 掠夺证明不足
                cardType = CARDTYPE.buyEvidence
                local itemCount = wareHouseData:getItemCountById(_itemEvidence)
                _evidenceNeed = sweepCount * 2 - itemCount
                _layer:addChild(createSimpleConfirCardLayer(  
                    string.format(HLNSLocalizedString("sail.sweep.lackOfEvidence" ), itemCount, _evidenceNeed) 
                  ),100)
                SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
                SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction
                return
            end      
            runtimeCache.sailTableOffsetY = smallStageTableView:getContentOffset().y
            doActionFun("ELITE_SWEEP", {stageId, sweepCount}, sweepCallback)
        end
        -- lsf 林绍峰 快速扫荡 扫荡10次
        local function sweepItemClick(tag)
            _sweepType = "tenTimes"
            sweepItem()
        end
        StageEDetailOwner["sweepItemClick"] = sweepItemClick

        -- lsf 林绍峰 快速扫荡 扫荡1次
        local function sweepOnceItemClick(tag)
            _sweepType = "once"
            sweepItem()
        end
        StageEDetailOwner["sweepOnceItemClick"] = sweepOnceItemClick


        local r
        if fn == "cellSize" then
            if a1 == 0 then
                -- 剧情
                r = CCSizeMake(winSize.width, DIALOG_BG_HIGHT * retina)
            elseif a1 <= smallStageCount then
                -- 小关
                if a1 == openIndex then
                    r = CCSizeMake(winSize.width, (NOR_BG_HIGHT + E_DETAIL_BG_HIGHT) * retina)
                else
                    r = CCSizeMake(winSize.width, NOR_BG_HIGHT * retina)
                end
            else
                r = CCSizeMake(winSize.width, GOTO_HIGHT * retina)
            end
        elseif fn == "cellAtIndex" then
            -- Return CCTableViewCell, a1 is cell index (zero based), a2 is dequeued cell (maybe nil)
            -- Do something to create cell and change the content
            local proxy = CCBProxy:create()
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            if a1 == 0 then
                -- 剧情
                ccb["StageEDialogOwner"] = StageEDialogOwner
                local node = CCBReaderLoad("ccbResources/stageEDialogView.ccbi",proxy, true, "StageEDialogOwner")
                local cell = tolua.cast(node, "CCSprite")
                cell:setScale(retina)
                a2:addChild(cell)
                cell:setAnchorPoint(ccp(0.5, 0.5))
                cell:setPosition(winSize.width / 2, DIALOG_BG_HIGHT * retina / 2)

                local bg = tolua.cast(StageEDialogOwner["bg"], "CCSprite")
                if dic.pageBg then
                    local f = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("%s.png", dic.pageBg))
                    if f then
                        bg:setDisplayFrame(f)
                    end
                end
                desp = string.gsub(dic.pageDesp, "[$]", "\r\n")
                local dialogLabel = tolua.cast(StageEDialogOwner["dialogLabel"], "CCLabelTTF")
                dialogLabel:setString(desp)
                local dialogLabel_s = tolua.cast(StageEDialogOwner["dialogLabel_s"], "CCLabelTTF")
                dialogLabel_s:setString(desp)

                --英雄模式添加双倍掉落
                local DoubleDropBg = tolua.cast(StageEDialogOwner["experenceItem1"], "CCSprite")
                 if DoubleDropBg then
                    DoubleDropBg:setVisible(loginActivityData:isDoubleDropOpen())
                end

            elseif a1 <= smallStageCount then
                -- 小关
                local stageId = dic.pageStage[a1]
                local stageDic = elitedata:getSmallStage(stageId)
                local starCount = elitedata:getStageStar(stageId)
                local canFight = elitedata:canFight(stageId)
                local node
                if a1 ~= openIndex then
                    ccb["StageEOwner"] = StageEOwner
                    node  = CCBReaderLoad("ccbResources/StageENorView.ccbi",proxy, true,"StageEOwner")
                else
                    ccb["StageEDetailOwner"] = StageEDetailOwner
                    node  = CCBReaderLoad("ccbResources/StageEDetailView.ccbi",proxy, true,"StageEDetailOwner")
                end
                local cell = tolua.cast(node, "CCSprite")
                cell:setScale(retina)
                a2:addChild(cell, 1, 100)
                cell:setAnchorPoint(ccp(0.5, 0))
                cell:setPosition(winSize.width / 2, 0)
                local frameName
                local headFrameName
                if stageDic["type"] == 0 then
                    frameName = "bg_nor_e.png"
                    headFrameName = "frame_1.png"
                elseif stageDic["type"] == 1 then
                    frameName = "bg_sp_e.png"
                    headFrameName = "frame_2.png"
                else
                    frameName = "bg_boss_e.png"
                    headFrameName = "frame_3.png"
                end
                local owner
                if a1 ~= openIndex then
                    owner = StageEOwner
                else
                    owner = StageEDetailOwner
                end
                local stageSp = tolua.cast(owner["stageSp"], "CCSprite")
                stageSp:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(frameName))
                local stageNameLabel = tolua.cast(owner["stageNameLabel"], "CCLabelTTF")
                stageNameLabel:setString(stageDic.stageName)
                local frame = tolua.cast(owner["frame"], "CCSprite")
                frame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(headFrameName))
                local head = tolua.cast(owner["head"], "CCSprite")
                if stageDic.stageHead then
                    local f = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("%s.png", stageDic.stageHead))
                    if f then
                        head:setDisplayFrame(f)
                    else
                        head:setVisible(false)
                    end
                else
                    head:setVisible(false)
                end
                local goldIcon = tolua.cast(owner["goldIcon"], "CCSprite")
                if elitedata:getStageChallengeCount(stageId) <= elitedata:getStageFightCount(stageId) then
                    goldIcon:setVisible(true)
                end
                if a1 == openIndex then
                    local strengthCost = tolua.cast(owner["strengthCost"], "CCLabelTTF")
                    strengthCost:setString(stageDic.pay)

                    local detailLabel = tolua.cast(owner["detailLabel"], "CCLabelTTF")
                    if stageDic.desp then
                        detailLabel:setString(stageDic.desp)
                    end
                    local warDesplLabel = tolua.cast(owner["warDesplLabel"], "CCLabelTTF")
                    if stageDic.wardesp then
                        warDesplLabel:setString(stageDic.wardesp)
                    end
                    local challengeTimes = tolua.cast(owner["challengeTimes"], "CCLabelTTF")
                    challengeTimes:setString(string.format("%d/%d", elitedata:getStageFightCount(stageId), elitedata:getStageChallengeCount(stageId)))
                    local levelLabel = tolua.cast(owner["levelLabel"], "CCLabelTTF")
                    levelLabel:setString(stageDic.level)
                    local expLabel = tolua.cast(owner["expLabel"], "CCLabelTTF")
                    expLabel:setString(stageDic.exp)
                    local bellyLabel = tolua.cast(owner["bellyLabel"], "CCLabelTTF")
                    bellyLabel:setString(stageDic.silver)
                    local sweepText = tolua.cast(owner["sweepText"], "CCLabelTTF")
                    local sweepCount = math.min(math.min(math.max(elitedata:getStageChallengeCount(stageId) - elitedata:getStageFightCount(stageId), 0), userdata.strength), 10)
                    if sweepCount == 0 then
                        sweepText:setString(HLNSLocalizedString("sail.sweep0"))
                    else
                        sweepText:setString(HLNSLocalizedString("sail.sweep", sweepCount))
                    end
                    local sweepOnceText = tolua.cast(owner["sweepOnceText"], "CCLabelTTF")
                    sweepOnceText:setString(HLNSLocalizedString("sail.sweep1"))
                    local sweepEvidenceCountText = tolua.cast(owner["sweepEvidenceCountText"], "CCLabelTTF")
                    local itemCount =  wareHouseData:getItemCountById(_itemEvidence)
                    if itemCount > 9999 then
                        sweepEvidenceCountText:setString( "2/9999+" )
                    else 
                        sweepEvidenceCountText:setString( "2/" .. tostring(itemCount) )
                    end
                    local sweepEvidenceText = tolua.cast(owner["sweepEvidenceText"], "CCLabelTTF")
                    sweepEvidenceText:setString(HLNSLocalizedString( "sail.sweepEvidence"))
                    if not stageDic.award or table.getTableCount(stageDic.award) == 0 then
                        local rewardTitle = tolua.cast(owner["rewardTitle"], "CCLabelTTF")
                        rewardTitle:setVisible(false)
                    else
                        local index = 1
                        for k, dic in pairs(stageDic.award) do
                            local itemId = dic.name
                            local awardFrame = tolua.cast(owner["awardFrame"..index], "CCSprite")
                            awardFrame:setVisible(true)
                            local resDic = userdata:getExchangeResource(itemId)

                            local contentLayer = tolua.cast(owner["contentLayer"..index],"CCLayer")
                            local bigSprite = tolua.cast(owner["bigSprite"..index],"CCSprite")
                            local chipIcon = tolua.cast(owner["chipIcon"..index],"CCSprite")
                            local littleSprite = tolua.cast(owner["littleSprite"..index],"CCSprite")
                            local soulIcon = tolua.cast(owner["soulIcon"..index],"CCSprite")

                            if havePrefix(itemId, "weapon_") or havePrefix(itemId, "belt_") or havePrefix(itemId, "armor_") then
                                -- 装备
                                bigSprite:setVisible(true)
                                local texture
                                if haveSuffix(itemId, "_shard") then
                                    chipIcon:setVisible(true)
                                    texture = CCTextureCache:sharedTextureCache():addImage(string.format("ccbResources/icons/%s.png", resDic.icon))
                                else
                                    texture = CCTextureCache:sharedTextureCache():addImage(resDic.icon)
                                end
                                if texture then
                                    bigSprite:setVisible(true)
                                    bigSprite:setTexture(texture)
                                end
                            elseif havePrefix(itemId, "item") then
                                -- 道具
                                bigSprite:setVisible(true)
                                local texture = CCTextureCache:sharedTextureCache():addImage(resDic.icon)
                                if texture then
                                    bigSprite:setVisible(true)
                                    bigSprite:setTexture(texture)
                                end
                            elseif havePrefix(itemId, "shadow") then
                                -- 影子
                                local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
                                cache:addSpriteFramesWithFile("ccbResources/shadow.plist")
                                awardFrame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("s_frame.png"))
                                awardFrame:setPosition(ccp(awardFrame:getPositionX() + 5,awardFrame:getPositionY() - 5))
                                if resDic.icon then
                                    playCustomFrameAnimation( string.format("yingzi_%s_",resDic.icon),contentLayer,ccp(contentLayer:getContentSize().width / 2,contentLayer:getContentSize().height / 2),1,4,shadowData:getColorByColorRank( resDic.rank ) )
                                end
                            elseif havePrefix(itemId, "hero") then
                                -- 魂魄
                                littleSprite:setVisible(true)
                                littleSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(resDic.icon))

                            elseif havePrefix(itemId, "book") then
                                -- 奥义
                                bigSprite:setVisible(true)
                                local texture = CCTextureCache:sharedTextureCache():addImage(resDic.icon)
                                if texture then
                                    bigSprite:setVisible(true)
                                    bigSprite:setTexture(texture)
                                end
                            else
                                -- 金币 银币
                                bigSprite:setVisible(true)
                                local texture = CCTextureCache:sharedTextureCache():addImage(resDic.icon)
                                if texture then
                                    bigSprite:setVisible(true)
                                    bigSprite:setTexture(texture)
                                end
                            end
                            if not havePrefix(itemId, "shadow") then
                                awardFrame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", resDic.rank)))
                            end
                            index = index + 1
                        end
                    end
                    --_updateSweepTime()
                    local expDoubleBg = tolua.cast(owner["expDoubleBg"], "CCSprite")
                    if expDoubleBg then
                        if userdata:hasBattleDouble() then
                            expDoubleBg:setVisible(true)
                            local expDouble = tolua.cast(owner["expDouble"], "CCLabelTTF")
                            expDouble:setString(string.format("×%d", ConfigureStorage.battleDouble.expTimes))
                        end
                    end

                    local DoubleDropBg = tolua.cast(StageEDetailOwner["huodong"], "CCSprite")
                    if DoubleDropBg then
                        DoubleDropBg:setVisible(loginActivityData:isDoubleDropOpen())
                    end

                end
                
                for i=1, starCount do
                    local star = tolua.cast(owner["star"..i], "CCSprite")
                    star:setVisible(true)
                end
                local fightItem = tolua.cast(owner["fightItem"], "CCMenuItem")
                local sweepItem = tolua.cast(owner["sweepItem"], "CCMenuItem")
                local sweepText = tolua.cast(owner["sweepText"], "CCLabelTTF")
                local sweepOnceItem = tolua.cast(owner["sweepOnceItem"], "CCMenuItem")
                local sweepOnceText = tolua.cast(owner["sweepOnceText"], "CCLabelTTF")
                local sweepEvidenceCountText = tolua.cast(owner["sweepEvidenceCountText"], "CCLabelTTF")
                local sweepEvidenceText = tolua.cast(owner["sweepEvidenceText"], "CCLabelTTF")


                if not canFight then
                    fightItem:setVisible(false)
                end
                fightItem:setTag(a1)

                -- renzhan
               if bigStageSelected <= 5 and canFight and starCount == 0 then
                    local light = fightItem:getChildByTag(300)
                    if not light then
                        light = CCSprite:createWithSpriteFrameName("lightEffect_smallStage_1.png")
                        local animFrames = CCArray:create()
                        for j = 1, 4 do
                            local frameName = string.format("lightEffect_smallStage_%d.png",j)
                            local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(frameName)
                            animFrames:addObject(frame)
                        end
                        local animation = CCAnimation:createWithSpriteFrames(animFrames, 0.1)
                        local animate = CCAnimate:create(animation)
                        light:runAction(CCRepeatForever:create(animate))
                        fightItem:addChild(light,1,300)
                        light:setPosition(ccp(fightItem:getContentSize().width / 2 + 5, fightItem:getContentSize().height / 2 + 2.5))
                    end
                end
                -- 
                if sweepItem and sweepOnceItem then
                    sweepItem:setTag(a1)
                    sweepOnceItem:setTag(a1)
                    if starCount < 3 then
                        sweepItem:setVisible(false)
                        sweepOnceItem:setVisible(false)
                    end
                end
                if sweepText and sweepOnceText then
                    if starCount < 3 then
                        sweepText:setVisible(false)
                        sweepOnceText:setVisible(false)
                    end
                end
                if sweepEvidenceCountText and sweepEvidenceText then
                    if starCount < 3 then
                        sweepEvidenceCountText:setVisible(false)
                        sweepEvidenceText:setVisible(false)
                    end
                end

            else
                -- 继续
                ccb["StageGoonOwner"] = StageGoonOwner
                local cell = tolua.cast(CCBReaderLoad("ccbResources/StageGoonView.ccbi",proxy,true,"StageGoonOwner"), "CCLayer")
                cell:setScale(retina)
                a2:addChild(cell)
                a2:setAnchorPoint(ccp(0, 0))
                a2:setPosition(0, 0)
            end
            r = a2
        elseif fn == "numberOfCells" then
            -- Return number of cells
            r = smallStageCount + 1
            if tonumber(string.sub(elitedata.currentStage, 12, 15)) > bigStageSelected then
                r = r + 1
            end
        -- Cell events:
        elseif fn == "cellTouched" then         -- A cell was touched, a1 is cell that be touched. This is not necessary.
            if a1:getIdx() == 0 or a1:getIdx() > smallStageCount then
                return r
            end
            local owner
            local fightItem
            if a1:getIdx() ~= openIndex then
                owner = StageEOwner
                fightItem = tolua.cast(a1:getChildByTag(100):getChildByTag(100):getChildByTag(a1:getIdx()), "CCMenuItem")
            else
                owner = StageEDetailOwner
                fightItem = tolua.cast(owner["fightItem"], "CCMenuItemImage")
            end
            local sweepItem = tolua.cast(owner["sweepItem"], "CCMenuItem")
            local sweepOnceItem = tolua.cast(owner["sweepOnceItem"], "CCMenuItem")
            if sweepItem and sweepItem:isSelected() then
                return r
            end
            if sweepOnceItem and sweepOnceItem:isSelected() then
                return r
            end
            if fightItem and fightItem:isSelected() then
                return r
            end
            lastIndex = openIndex
            openIndex = openIndex == a1:getIdx() and 0 or a1:getIdx()
            smallStageOffsetY = smallStageTableView:getContentOffset().y
            smallStageTableView:reloadData()
            refreshSmallStageOffset()
        elseif fn == "cellTouchBegan" then      -- A cell is touching, a1 is cell, a2 is CCTouch
        elseif fn == "cellTouchEnded" then      -- A cell was touched, a1 is cell, a2 is CCTouch
        elseif fn == "cellHighlight" then       -- A cell is highlighting, coco2d-x 2.1.3 or above
        elseif fn == "cellUnhighlight" then     -- A cell had been unhighlighted, coco2d-x 2.1.3 or above
        elseif fn == "cellWillRecycle" then     -- A cell will be recycled, coco2d-x 2.1.3 or above
        end
        return r
    end)
    local _mainLayer = getMainLayer()
    local size = CCSizeMake(winSize.width, winSize.height - (TITLE_HIGHT * retina + _mainLayer:getTitleContentSize().height + _mainLayer:getBroadCastContentSize().height + _mainLayer:getBottomContentSize().height))
    smallStageTableView = LuaTableView:createWithHandler(h, size)
    smallStageTableView:setBounceable(true)
    smallStageTableView:setAnchorPoint(ccp(0, 0))
    smallStageTableView:setPosition(ccp(0, _mainLayer:getBottomContentSize().height))
    smallStageTableView:setVerticalFillOrder(0)
    -- bigStageTableView:setDirection(0)
    _layer:addChild(smallStageTableView, 10, 10)
end

-- 刷新小关数据
local function refreshSmallStage()
    if smallStageTableView then
        smallStageTableView:removeFromParentAndCleanup(true)
        smallStageTableView = nil
    end
    if stageMode == STAGE_MODE.NOR then
        addSmallStageTableView()
    elseif stageMode == STAGE_MODE.ELITE then
        addESmallStageTableView()
    end
end

-- 刷新小关数据 同时位移
local function _refreshSmallStageWithOffset()
    runtimeCache.sailTableOffsetY = smallStageTableView:getContentOffset().y
    refreshSmallStage()
    if runtimeCache.sailTableOffsetY then
        smallStageTableView:setContentOffset(ccp(0, runtimeCache.sailTableOffsetY))
    end
end

local function refreshBigStageOffset()
    local sp = CCSprite:createWithSpriteFrameName("stage_0.png")
    if bigStageTableView:getContentOffset().x >= -(bigStageSelected) * sp:getContentSize().width * 1.1 * retina 
        and bigStageTableView:getContentOffset().x < (winSize.width - (bigStageSelected - 1) * sp:getContentSize().width * 1.1 * retina) then
        -- 如果需要显示的大关cell在显示区域中
        return
    end
    local x = math.min((bigStageSelected - 1) * sp:getContentSize().width * 1.1 * retina, #bigStageArray * sp:getContentSize().width * 1.1 * retina - winSize.width)
    bigStageTableView:setContentOffset(ccp(-x, 0))
end

local function changeBigStage(selected, openNew)
    if bigStageSelected then
        local cell = bigStageTableView:cellAtIndex(bigStageSelected - 1)
        if cell then
            local item = tolua.cast(cell:getChildByTag(10):getChildByTag(bigStageSelected), "CCMenuItemImage")
            item:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("stage_0.png"))
        end
    end
    bigStageSelected = selected
    local cell = bigStageTableView:cellAtIndex(bigStageSelected - 1)
    if cell then
        local item = tolua.cast(cell:getChildByTag(10):getChildByTag(bigStageSelected), "CCMenuItemImage")
        item:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("stage_1.png"))
    end
    local dic
    if stageMode == STAGE_MODE.NOR then
        dic = bigStageArray[bigStageSelected]
    else
        dic = eBigStageArray[bigStageSelected]
    end
    stageOpenNew = openNew or stageOpenNew
    if stageOpenNew then
        for i,stageId in ipairs(dic.pageStage) do
            local starCount
            local canFight
            if stageMode == STAGE_MODE.NOR then
                starCount = storydata:getStageStar(stageId)
                canFight = storydata:canFight(stageId)
            elseif stageMode == STAGE_MODE.ELITE then
                starCount = elitedata:getStageStar(stageId)
                canFight = elitedata:canFight(stageId)
            end
            if not runtimeCache.bGuide and canFight and starCount == 0 then
                openIndex = i
                break
            end
        end
    end

    refreshSmallStage()
    refreshBigStageOffset()
end

-- 选择大关
local function selectBigStage(selected)
    if bigStageSelected == selected then
        return
    end
    openIndex = 0
    changeBigStage(selected, true)
end

local function goonItemClick()
    if stageMode == STAGE_MODE.ELITE and not elitedata:checkBigStage(string.format("elitestage_%04d", bigStageSelected + 1)) then
        return
    end
    selectBigStage(bigStageSelected + 1)
end
StageGoonOwner["goonItemClick"] = goonItemClick

local function bigStagePressed(tag)
    selectBigStage(tag)
end

local function bigStageLock(tag)
    if stageMode == STAGE_MODE.NOR then
        ShowText(HLNSLocalizedString("stage.lock")) 
    elseif stageMode == STAGE_MODE.ELITE then
        elitedata:checkBigStage(string.format("elitestage_%04d", tag))
    end
end

local function addBigStageTableView()
    -- @param fn string Callback type
    -- @param table LuaTableView
    -- @param a1 & a2 mixed Difference means for every "fn"
    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            local sp = CCSprite:createWithSpriteFrameName("stage_0.png")
            r = CCSizeMake(sp:getContentSize().width * 1.1 * retina, sp:getContentSize().height * retina)
        elseif fn == "cellAtIndex" then
            -- Return CCTableViewCell, a1 is cell index (zero based), a2 is dequeued cell (maybe nil)
            -- Do something to create cell and change the content
            
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            local dic = bigStageArray[a1 + 1]
            local norSp = CCSprite:createWithSpriteFrameName("stage_0.png")
            if a1 + 1 == bigStageSelected then
                norSp = CCSprite:createWithSpriteFrameName("stage_1.png")
            end
            local selSp = CCSprite:createWithSpriteFrameName("stage_1.png")
            if dic.lock then
                norSp = CCSprite:createWithSpriteFrameName("stage_lock.png")
                selSp = CCSprite:createWithSpriteFrameName("stage_lock.png")
            end
            local item = CCMenuItemSprite:create(norSp, selSp)
            if dic.lock then
                -- item:setEnabled(false)
                item:registerScriptTapHandler(bigStageLock)
            else
                item:registerScriptTapHandler(bigStagePressed)
            end
            item:setAnchorPoint(ccp(0, 0))
            item:setPosition(ccp(norSp:getContentSize().width * 0.05 * retina, 0))
            local label = CCLabelTTF:create(dic.pageName, "ccbResources/FZCuYuan-M03S.ttf", 25, CCSizeMake(150*retina, 0), kCCTextAlignmentCenter)
            label:setPosition(ccp((item:getContentSize().width + 40) / 2, item:getContentSize().height / 2))
            item:addChild(label, 1, 10000)

            if a1 + 1 <= 5 then 
                if not dic.lock and bigStageArray[a1 + 2].lock then
                    local bigStagelight = item:getChildByTag(301)
                    if not bigStagelight then

                        bigStagelight = CCSprite:createWithSpriteFrameName("lightEffect_bigStage_1.png")
                        local lightActions = CCArray:create()
                        local function visibleLight()
                            bigStagelight:setVisible(true)
                        end
                        lightActions:addObject(CCCallFunc:create(visibleLight))
                        local animFrames = CCArray:create()
                        for j = 1, 5 do
                            local frameName = string.format("lightEffect_bigStage_%d.png",j)
                            local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(frameName)
                            animFrames:addObject(frame)
                        end
                        local animation = CCAnimation:createWithSpriteFrames(animFrames, 0.06)
                        local animate = CCAnimate:create(animation)
                        lightActions:addObject(animate)
                        local function invisibleLight()
                            bigStagelight:setVisible(false)
                        end
                        lightActions:addObject(CCCallFunc:create(invisibleLight))
                        lightActions:addObject(CCDelayTime:create(1.5))
                        bigStagelight:runAction(CCRepeatForever:create(CCSequence:create(lightActions)))
                        item:addChild(bigStagelight,5,301)
                        bigStagelight:setPosition(ccp(item:getContentSize().width / 2,item:getContentSize().height / 2))
                    end
                end
            end
            menu = CCMenu:create()
            menu:addChild(item, 1, a1 + 1)
            menu:setPosition(ccp(0, 0))
            menu:setAnchorPoint(ccp(0, 0))
            menu:setScale(retina)
            a2:addChild(menu, 1, 10)
            local function setCellMenuPriority(sender)
                if sender then
                    local menu = tolua.cast(sender, "CCMenu")
                    menu:setHandlerPriority(-131)
                end
            end
            local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCCallFuncN:create(setCellMenuPriority))
            menu:runAction(seq)
            r = a2
        elseif fn == "numberOfCells" then
            -- Return number of cells
            r = #bigStageArray
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
    local sp = CCSprite:createWithSpriteFrameName("stage_0.png")
    local sailBgLayer = tolua.cast(SailOwner["sailBgLayer"], "CCLayer")
    local size = CCSizeMake(winSize.width, sp:getContentSize().height * retina)
    bigStageTableView = LuaTableView:createWithHandler(h, size)
    bigStageTableView:setBounceable(true)
    bigStageTableView:setAnchorPoint(ccp(0, 0))
    bigStageTableView:setPosition(ccp(0, winSize.height - sp:getContentSize().height * retina * 1.15))
    bigStageTableView:setVerticalFillOrder(0)
    bigStageTableView:setDirection(0)
    sailBgLayer:addChild(bigStageTableView, 10, 10)
    bigStageTableView:setTouchPriority(-132)


    
end

-- 添加精英大关卡
local function addEBigStageTableView()
    -- @param fn string Callback type
    -- @param table LuaTableView
    -- @param a1 & a2 mixed Difference means for every "fn"
    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            local sp = CCSprite:createWithSpriteFrameName("stage_0.png")
            r = CCSizeMake(sp:getContentSize().width * 1.1 * retina, sp:getContentSize().height * retina)
        elseif fn == "cellAtIndex" then
            -- Return CCTableViewCell, a1 is cell index (zero based), a2 is dequeued cell (maybe nil)
            -- Do something to create cell and change the content
            
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            local dic = eBigStageArray[a1 + 1]
            local norSp = CCSprite:createWithSpriteFrameName("stage_0.png")
            if a1 + 1 == bigStageSelected then
                norSp = CCSprite:createWithSpriteFrameName("stage_1.png")
            end
            local selSp = CCSprite:createWithSpriteFrameName("stage_1.png")
            if dic.lock then
                norSp = CCSprite:createWithSpriteFrameName("stage_lock.png")
                selSp = CCSprite:createWithSpriteFrameName("stage_lock.png")
            end
            local item = CCMenuItemSprite:create(norSp, selSp)
            if dic.lock then
                -- item:setEnabled(false)
                item:registerScriptTapHandler(bigStageLock)
            else
                item:registerScriptTapHandler(bigStagePressed)
            end
            item:setAnchorPoint(ccp(0, 0))
            item:setPosition(ccp(norSp:getContentSize().width * 0.05 * retina, 0))
            local label = CCLabelTTF:create(dic.pageName, "ccbResources/FZCuYuan-M03S.ttf", 25, CCSizeMake(150*retina, 0), kCCTextAlignmentCenter)
            label:setPosition(ccp((item:getContentSize().width + 40) / 2, item:getContentSize().height / 2))
            item:addChild(label, 1, 10000)

            if a1 + 1 <= 5 then 
                if not dic.lock and eBigStageArray[a1 + 2] and eBigStageArray[a1 + 2].lock then
                    local bigStagelight = item:getChildByTag(301)
                    if not bigStagelight then

                        bigStagelight = CCSprite:createWithSpriteFrameName("lightEffect_bigStage_1.png")
                        local lightActions = CCArray:create()
                        local function visibleLight()
                            bigStagelight:setVisible(true)
                        end
                        lightActions:addObject(CCCallFunc:create(visibleLight))
                        local animFrames = CCArray:create()
                        for j = 1, 5 do
                            local frameName = string.format("lightEffect_bigStage_%d.png",j)
                            local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(frameName)
                            animFrames:addObject(frame)
                        end
                        local animation = CCAnimation:createWithSpriteFrames(animFrames, 0.06)
                        local animate = CCAnimate:create(animation)
                        lightActions:addObject(animate)
                        local function invisibleLight()
                            bigStagelight:setVisible(false)
                        end
                        lightActions:addObject(CCCallFunc:create(invisibleLight))
                        lightActions:addObject(CCDelayTime:create(1.5))
                        bigStagelight:runAction(CCRepeatForever:create(CCSequence:create(lightActions)))
                        item:addChild(bigStagelight,5,301)
                        bigStagelight:setPosition(ccp(item:getContentSize().width / 2,item:getContentSize().height / 2))
                    end
                end
            end
            menu = CCMenu:create()
            menu:addChild(item, 1, a1 + 1)
            menu:setPosition(ccp(0, 0))
            menu:setAnchorPoint(ccp(0, 0))
            menu:setScale(retina)
            a2:addChild(menu, 1, 10)
            local function setCellMenuPriority(sender)
                if sender then
                    local menu = tolua.cast(sender, "CCMenu")
                    menu:setHandlerPriority(-131)
                end
            end
            local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCCallFuncN:create(setCellMenuPriority))
            menu:runAction(seq)
            r = a2
        elseif fn == "numberOfCells" then
            -- Return number of cells
            r = #eBigStageArray
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
    local sp = CCSprite:createWithSpriteFrameName("stage_0.png")
    local sailBgLayer = tolua.cast(SailOwner["sailBgLayer"], "CCLayer")
    local size = CCSizeMake(winSize.width, sp:getContentSize().height * retina)
    bigStageTableView = LuaTableView:createWithHandler(h, size)
    bigStageTableView:setBounceable(true)
    bigStageTableView:setAnchorPoint(ccp(0, 0))
    bigStageTableView:setPosition(ccp(0, winSize.height - sp:getContentSize().height * retina * 1.15))
    bigStageTableView:setVerticalFillOrder(0)
    bigStageTableView:setDirection(0)
    sailBgLayer:addChild(bigStageTableView, 10, 10)
    bigStageTableView:setTouchPriority(-132)
end

local function refreshBigStage()
    if bigStageTableView then
        bigStageTableView:removeFromParentAndCleanup(true)
        bigStageTableView = nil
    end
    if stageMode == STAGE_MODE.NOR then
        addBigStageTableView()
    elseif stageMode == STAGE_MODE.ELITE then
        addEBigStageTableView()
    end
end

local function _initSailLayer()
    local record
    if stageMode == STAGE_MODE.NOR then 
        record = storydata:getBigStageRecord()
    elseif stageMode == STAGE_MODE.ELITE then
        record = elitedata:getBigStageRecord()
    end
    if not bigStageSelected or bigStageSelected > record then
        bigStageSelected = record
    end
end

local function resetSail()
    _initSailLayer()
    refreshBigStage()
    bigStageTableView:reloadData()
    changeBigStage(bigStageSelected)
    if location then
        refreshSmallStageOffset()
        return
    end
end

local function changeEMode()
    local record = elitedata:getBigStageRecord()
    if record == 0 then
        ShowText(HLNSLocalizedString("stage.elite.lock.stage", ConfigureStorage.pageConfig.stage_01.pageName))
        return
    end
    if userdata.level < 8 then
        ShowText(HLNSLocalizedString("stage.elite.lock"))
        return
    end
    stageMode = STAGE_MODE.ELITE
    resetSail()
end
StageDialogOwner["changeEMode"] = changeEMode

local function changeNMode()
    stageMode = STAGE_MODE.NOR
    resetSail()
end
StageEDialogOwner["changeNMode"] = changeNMode

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/SailView.ccbi",proxy, true,"SailOwner")
    _layer = tolua.cast(node,"CCLayer")
    
    local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
    cache:addSpriteFramesWithFile("ccbResources/hero_head2.plist")
end


-- 该方法名字每个文件不要重复
function getSailLayer()
	return _layer
end

function createSailLayer(stageId, mode)
    _init()
    stageMode = mode or stageMode
    if stageId then
        local strs = string.split(stageId, "_")
        bigStageSelected = tonumber(strs[2])
        openIndex = tonumber(strs[3])
        stageOpenNew = false
        location = true
    end

    -- 海军支部引导
    function _layer:marineGuide()
        local marineId = storydata:getMarineId(bigStageSelected)
        if marineId then
            local conf = marineBranchData:getConfig(marineId)
            local dic = {
                goto = "marine",
                des1 = HLNSLocalizedString("marine.open.tips", conf.nsname)
            }
            getMainLayer():getParent():addChild(createLevelGuideLayer(dic), 500)
        end
    end

    function _layer:selectBigStage(stage)
        selectBigStage(stage)
    end

    function _layer:refreshSmallStage()
        refreshSmallStage()
        if runtimeCache.sailTableOffsetY then
            smallStageTableView:setContentOffset(ccp(0, runtimeCache.sailTableOffsetY))
        end
    end

    function _layer:playStageTalk()
        playStageTalk()
    end

    -- 供新手引导调用, 其他地方慎用
    function _layer:storyFight(stageId)
        storyFight(stageId)
    end

    local function _onEnter()
        bigStageArray = storydata:getBigStages()
        eBigStageArray = elitedata:getBigStages()
        resetSail()
        if not runtimeCache.bGuide and runtimeCache.sailTableOffsetY then
            smallStageTableView:setContentOffset(ccp(0, runtimeCache.sailTableOffsetY))
        end
        addObserver(NOTI_SAIL_SWEEP, _updateSweepTime)
        addObserver(NOTI_SAIL_SWEEP_FINISH, _refreshSmallStageWithOffset)
        
    end

    local function _onExit()
        if smallStageTableView then
            runtimeCache.sailTableOffsetY = smallStageTableView:getContentOffset().y
        end
        _layer = nil
        bigStageArray = nil
        eBigStageArray = nil
        bigStageTableView = nil
        smallStageTableView = nil
        lastIndex = 0
        smallStageOffsetY = nil
        confirmCardStageId = nil
        removeObserver(NOTI_SAIL_SWEEP, _updateSweepTime)
        removeObserver(NOTI_SAIL_SWEEP_FINISH, _refreshSmallStageWithOffset)
        ccb["StageDialogOwner"] = nil
        ccb["StageEatOwner"] = nil
        ccb["StageVideoOwner"] = nil
        ccb["StageGoonOwner"] = nil
        ccb["StageDetailOwner"] = nil
        ccb["StageOwner"] = nil
        ccb["StageMarineOwner"] = nil
        ccb["StageEDetailOwner"] = nil
        ccb["stageEDialogView"] = nil
        ccb["StageEOwner"] = nil
        location = false
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