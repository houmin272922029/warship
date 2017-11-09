marineFightBossLayer = class("marineFightBossLayer", function()
    local proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/MarineBossView.ccbi",proxy, true,"MarineBossViewOwner")
    local layer = tolua.cast(node,"CCLayer")
    return layer
end)

marineFightBossLayer.dic = nil
marineFightBossLayer.bossInfo = nil
marineFightBossLayer.index = nil

MarineBossViewOwner = MarineBossViewOwner or {}
ccb["MarineBossViewOwner"] = MarineBossViewOwner

function marineFightBossLayer:refreshLayer()

    local function marineBossBattleCallback( url,rtnData )
        local huntTreatureData = rtnData.info.huntingTreasure
        marineBranchData:updateSpotDataByIdAndDic( huntTreatureData.stageId,huntTreatureData )
        -- getMarineBranchLayer():refreshMarineBranchLayer()
        -- TODO 跳转战斗
        runtimeCache.responseData = rtnData["info"]
        CCDirector:sharedDirector():replaceScene(CCTransitionFade:create(0.6, FightingScene())) 
    end

    local function onFightBossClick( tag,sender )
        Global:instance():TDGAonEventAndEventData("branch") 
        BattleField.leftName = userdata.name
        BattleField.rightName = self.bossInfo.bossInfo.name
        RandomManager.cursor = RandomManager.randomRange(0, 999)
        local seed = RandomManager.cursor
        BattleField:marineBossFight(self.bossInfo.npcGroupId)
        local result = BattleField.result == RESULT_WIN and 4 - BattleField.round or 0
        doActionFun("MARINE_FIGHT_BOSS", {self.dic["stageId"], "boss_"..self.bossInfo.rank, seed, result}, marineBossBattleCallback)

    end

    local function onExitClick()
        Global:instance():TDGAonEventAndEventData("branch1") 
        showAdventureFromMarine()
    end

    local freeCount = marineBranchData:getSbossLimit(  )

    local tipsLabel = tolua.cast(MarineBossViewOwner["tipsLabel"],"CCLabelTTF")
    local goldIcon = tolua.cast(MarineBossViewOwner["goldIcon"],"CCSprite")
    goldIcon:setVisible(false)
    if self.bossInfo.rank == 4 then
        -- 达到s级了
       local totalTime = self.bossInfo.totalTimes
        if totalTime >= marineBranchData:getCanChallengeTimes(  ) then
            -- 超过最大次数
            local challengeBtn = tolua.cast(MarineBossViewOwner["challengeBtn"], "CCMenuItemImage")
            challengeBtn:setVisible(false)
            local challengeSprite = tolua.cast(MarineBossViewOwner["challengeSprite"], "CCSprite")
            challengeSprite:setVisible(false)
            tipsLabel:setString(HLNSLocalizedString("marine.boss.notEnough"))
        elseif totalTime >= freeCount then
            -- 超过免费次数
            goldIcon:setVisible(true)
            tipsLabel:setString(HLNSLocalizedString("marine.boss.goldTime"))
        else
            -- 免费
            tipsLabel:setString(HLNSLocalizedString("marine.boss.oneTimeGold"))
        end
    else
        tipsLabel:setVisible(false)
    end
    local bossInfo = self.bossInfo
    local challengeBtn = tolua.cast(MarineBossViewOwner["challengeBtn"], "CCMenuItemImage")
    challengeBtn:registerScriptTapHandler(onFightBossClick)

    local exitBtn = tolua.cast(MarineBossViewOwner["exitBtn"], "CCMenuItemImage")
    exitBtn:registerScriptTapHandler(onExitClick)

    local heroAvatar = tolua.cast(MarineBossViewOwner["heroAvatar"], "CCSprite")

    local texture = CCTextureCache:sharedTextureCache():addImage(herodata:getHeroBust1ByHeroId(bossInfo.bossInfo.head))
    if texture then
        heroAvatar:setVisible(true)
        heroAvatar:setTexture(texture)
    end

    local rankSprite = tolua.cast(MarineBossViewOwner["rankSprite"], "CCSprite")
    rankSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("rank_%s_icon.png",bossInfo.rank)))

    local nameLabel = tolua.cast(MarineBossViewOwner["nameLabel"], "CCLabelTTF")
    nameLabel:setString(bossInfo.bossInfo.name)
    local stageConf = marineBranchData:getConfig(self.dic.stageId)
    -- PrintTable(marineBranchData:getConfig(self.dic.stageId))

    -- local itemId
    -- local count
    local despLabel = tolua.cast(MarineBossViewOwner["despLabel"], "CCLabelTTF")
    -- for k,v in pairs(stageConf) do
    --     itemId = k
    --     count = v
    -- end
    local itemContent = wareHouseData:getItemConfig(itemId)
    -- PrintTable(itemContent)
    despLabel:setString(HLNSLocalizedString("marineBranch.desp1",  3))

    local levelSprite = tolua.cast(MarineBossViewOwner["levelSprite"..bossInfo.rank], "CCSprite")
    local selectFrameSprite = tolua.cast(MarineBossViewOwner["selectFrameSprite"], "CCSprite")
    selectFrameSprite:setVisible(true)
    selectFrameSprite:setPosition(ccp(levelSprite:getPositionX(),levelSprite:getPositionY()))



    local function onRewardFrameClick(tag)
        local stageConf = marineBranchData:getConfig(self.dic.stageId)
        local rewards = table.allKey(stageConf.nsaward[1]) 
        CCDirector:sharedDirector():getRunningScene():addChild(createItemDetailInfoLayer(rewards[tag], -160, "n",1), 100)
    end 

    --可能掉落的物品icon图标 lsf
    local rewards = table.allKey(stageConf.nsaward[1]) 
    print("lsf_rewards11")
    PrintTable(rewards)

    for i = 1, 4 do
        local key = "reward" .. i
        local frameKey = "reward" .. i .. "Frame"
        local rewardIcon = tolua.cast(MarineBossViewOwner[key], "CCSprite")
        local rewardFrame = tolua.cast(MarineBossViewOwner[frameKey], "CCMenuItemImage")
        rewardFrame:registerScriptTapHandler(onRewardFrameClick)

        if rewards[i] then
            local stuffItemId = rewards[i]
            print(rstuffItemId  )

            local itemsConfig = ConfigureStorage.item
            local item = itemsConfig[stuffItemId]
            if not item then --如果配置表里没有 stuffItemId 的数据
                item = itemsConfig["item_203"] --月饼
                print( string.format("lsf error:fail to get %s in ConfigureStorage.item " ,stuffItemId))
            end 
            PrintTable(item)

            local itemDic = wareHouseData:getItemConfig( stuffItemId )
            local iconName = itemDic.icon
            local texture = CCTextureCache:sharedTextureCache():addImage(equipdata:getEquipIconByEquipId( iconName ))
            if texture then
                rewardIcon:setVisible(true)
                rewardFrame:setVisible(true)
                rewardIcon:setTexture(texture)
                local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
                rewardFrame:setNormalSpriteFrame(cache:spriteFrameByName(string.format("frame_%d.png", item.rank )))
                rewardFrame:setSelectedSpriteFrame(cache:spriteFrameByName(string.format("frame_%d.png", item.rank )))
            else
                rewardIcon:setVisible(false)
                rewardFrame:setVisible(false)
            end  
            
            if item.rank >= 4  then
                --紫色材料发光
                HLAddParticleScale( "images/purpleEquip.plist", rewardIcon, ccp(rewardIcon:getContentSize().width / 2,rewardIcon:getContentSize().height / 2), 1, 100, 777, 2 / 0.35 / retina, 2 / 0.35 / retina, 1 )
            end

        else
            rewardIcon:setVisible(false)
            rewardFrame:setVisible(false)
        end
    end
    

end

-- 该方法名字每个文件不要重复
function getMarineChallengeBossLayer()
	return _layer
end

function createMarineChallengeBossLayer(index)
    local marineBossLayer = marineFightBossLayer.new()
    marineBossLayer.index = index
    local _marineList = marineBranchData:getMarineData(  )
    marineBossLayer.dic = _marineList[tonumber(index)]
    marineBossLayer.bossInfo = marineBranchData:getMarineBossInfo( _marineList[tonumber(index)] )
    marineBossLayer:refreshLayer()

    local function _onEnter()

    end

    local function _onExit()

    end

    --onEnter onExit
    local function _layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        end
    end


    marineBossLayer:registerScriptHandler(_layerEventHandler)

    return marineBossLayer
end