MarineBranchMobs = class("MarineBranchMobs", function()

    local proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/MarineBranchMobs.ccbi",proxy, true,"MarineBranchMobsOwner")
    local layer = tolua.cast(node,"CCLayer")
    return layer
end)

MarineBranchMobs.info = nil
MarineBranchMobs.index = nil

MarineBranchMobsOwner = MarineBranchMobsOwner or {}
ccb["MarineBranchMobsOwner"] = MarineBranchMobsOwner

marineDoorAniOwner = marineDoorAniOwner or {}
ccb["marineDoorAniOwner"] = marineDoorAniOwner


function MarineBranchMobs:refreshNavyStatus()
    -- 得到背景框的名字
    local function getBgNameByRank( rank )
        -- body
        if rank == 1 then
            return "whiteFrame.png"
        elseif rank == 2 then
            return "greenFrame.png"
        elseif rank == 3 then
            return "blueFrame.png"
        else
            return "purpleFrame.png"
        end
    end
    -- 返回
    local function onExitClicked(  )
        print("exit")
        showAdventureFromMarine()
    end
    local function rewardCallBack( url, rtnData )
        print("得到宝箱")
        userdata:popUpGain(rtnData.info.gain, true)
        local huntTreatureData = rtnData.info.huntingTreasure
        marineBranchData:updateSpotDataByIdAndDic( huntTreatureData.stageId,huntTreatureData )
        getMarineBranchLayer():refreshMarineBranchLayer()
    end
    local function fightMobsCallBack( url,rtnData )
        local huntTreatureData = rtnData.info.huntingTreasure
        marineBranchData:updateSpotDataByIdAndDic( huntTreatureData.stageId,huntTreatureData )
        getMarineBranchLayer():refreshMarineBranchLayer()
    end

    local dic = self.info.gate
    -- 格子点击事件
    local function onCardClicked( tag )
        print("-- --- --- -- ",tag)
        local marineName = marineBranchData:getConfig(self.info.stageId).nsname
        Global:instance():TDGAonEventAndEventData("branch_"..marineName.."_"..tag)
        local doorI = self.info["gate"][tostring(tag)]
        if doorI.isOpen == 0 then
            ShowText(HLNSLocalizedString("fightNavy.notOpen"))
        elseif self.info["rewardGate"][tostring(tag)] and self.info["rewardGate"][tostring(tag)] ~= nil and self.info["rewardGate"][tostring(tag)].takeReward == 0 then
            print("领宝箱")
            doActionFun("MARINE_MOBS_REWARD", {self.info.stageId, tag}, rewardCallBack)
        elseif doorI.defeated == 1 then
            ShowText(HLNSLocalizedString("fightNavy.defeated"))
        else 
            if getMainLayer() then
                getMainLayer():addChild(createMarineBranchMobsConfirmLayer(self,tag, self.info ,-140), 100)
            end  

        end
    end

    

    local tipLabel1 = tolua.cast(MarineBranchMobsOwner["tipLabel1"],"CCLabelTTF")
    local tipLabel2 = tolua.cast(MarineBranchMobsOwner["tipLabel2"],"CCLabelTTF")
    local countLabel = tolua.cast(MarineBranchMobsOwner["countLabel"],"CCLabelTTF")
    countLabel:setString(string.format("%d/%d",self.info.obtainedScore,self.info.score))

    local starPosOffset = math.floor((21 - self.info.score)/2)
    for i=starPosOffset+1,starPosOffset+self.info.score do        
        MarineBranchMobsOwner["starBg"..i]:setVisible(true)
        if i <= starPosOffset+self.info.obtainedScore then
            MarineBranchMobsOwner["starBg"..i]:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("star.png"))
        end
    end
    marineDoorAniOwner.newScore = self.info.obtainedScore
    if marineDoorAniOwner.newScore and marineDoorAniOwner.currentScore and marineDoorAniOwner.newScore > marineDoorAniOwner.currentScore then
        local lastStar = MarineBranchMobsOwner["starBg"..(starPosOffset+self.info.obtainedScore)]
        lastStar:setScale(1.25)
        local array = CCArray:create()
        array:addObject(CCScaleTo:create(0.25,2))
        array:addObject(CCScaleTo:create(0.5,1))
        lastStar:runAction(CCSequence:create(array))
    end

    for k,gates in pairs(dic) do

        -- print(k)
        -- PrintTable(gates)
        local exitBtn = tolua.cast(MarineBranchMobsOwner["exitBtn"], "CCMenuItemImage")
        exitBtn:registerScriptTapHandler(onExitClicked)
        local card = tolua.cast(MarineBranchMobsOwner[string.format("card%s",k)], "CCSprite")
        local sprBg = tolua.cast(MarineBranchMobsOwner[string.format("sprBg%s",k)], "CCMenuItemImage")
        sprBg:setTag(tonumber(k))
        sprBg:registerScriptTapHandler(onCardClicked)
        local boss = tolua.cast(MarineBranchMobsOwner[string.format("boss%s",k)], "CCSprite")
        local name = tolua.cast(MarineBranchMobsOwner[string.format("name%s",k)],"CCLabelTTF")
        local door = tolua.cast(MarineBranchMobsOwner[string.format("door%s",k)], "CCSprite")
        local shadowLayer = tolua.cast(MarineBranchMobsOwner[string.format("shadowLayer%s",k)], "CCSprite")
        local starLayer = tolua.cast(MarineBranchMobsOwner[string.format("starLayer%s",k)],"CCLayer")
        -- 得到小关卡配置
        local conf = marineBranchData:getGateConfigById(gates.npcGroupId)
        if gates.isOpen == 0 then
            door:setVisible(true) 
        -- 有宝箱
        elseif self.info["rewardGate"][k] and self.info["rewardGate"][k] ~= nil and self.info["rewardGate"][k].takeReward == 0 then
            door:setVisible(false)  
            local rewardBg = CCSprite:createWithSpriteFrameName("goldFrame.png")
            rewardBg:setPosition(card:getContentSize().width / 2,card:getContentSize().height / 2)
            card:addChild(rewardBg)
            for box,v in pairs(self.info["rewardGate"][k]["items"]) do
                local itemContent = userdata:getExchangeResource(box)
                PrintTable(itemContent)
                local rewardBox
                if haveSuffix(box, "_shard") then
                    rewardBox = CCSprite:create(string.format("ccbResources/icons/%s.png",itemContent.icon))
                    rewardBox:setScale(0.6)
                    local chipIcon = CCSprite:createWithSpriteFrameName("itemChip_icon.png")
                    rewardBox:addChild(chipIcon)
                    chipIcon:setAnchorPoint(ccp(1,0))
                    chipIcon:setPosition(ccp(rewardBox:getContentSize().width,0))
                elseif havePrefix(box, "shadow") then    
                    rewardBox = CCSprite:createWithSpriteFrameName("s_frame.png")
                    if itemContent.icon then
                        playCustomFrameAnimation( string.format("yingzi_%s_",itemContent.icon),shadowLayer,ccp(shadowLayer:getContentSize().width / 2,shadowLayer:getContentSize().height / 2),1,4,shadowData:getColorByColorRank( itemContent.rank ) )
                    end
                else
                    rewardBox = CCSprite:create(itemContent.icon)
                    rewardBox:setScale(0.6)
                end
                -- local rewardBox = CCSprite:create(itemContent.icon)
                rewardBox:setPosition(card:getContentSize().width / 2,card:getContentSize().height / 2)
                card:addChild(rewardBox)
            end
        else
            door:setVisible(false)
            card:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(getBgNameByRank(conf.rank)))
            sprBg:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", conf.rank)))

            local f = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(herodata:getHeroHeadByHeroId(conf.head))
            -- print(herodata:getHeroHeadByHeroId(conf.head))
            -- PrintTable(conf)
            if f then
                boss:setDisplayFrame(f)
            else
                boss:setVisible(false)
            end
            name:setString(conf.name)

            -- 显示星星
            starLayer:setVisible(true)
            for j=1,gates.gateScore do
                local starSpr = CCSprite:createWithSpriteFrameName("starBg.png")
                local size = starLayer:getContentSize()
                starSpr:setPosition(size.width * j / (gates.gateScore + 1), size.height / 2)
                starLayer:addChild(starSpr)
            end
            for j=1,gates.obtainedScore do
                local starSpr = CCSprite:createWithSpriteFrameName("star.png")
                local size = starLayer:getContentSize()
                starSpr:setPosition(size.width * j / (gates.gateScore + 1), size.height / 2)
                starLayer:addChild(starSpr)
            end
            if gates.obtainedScore >= gates.gateScore then
                MarineBranchMobsOwner["skull"..k]:setVisible(true)
            end
        end
    end

    if self.info.newlyOpen then
        for k,v in pairs(self.info.newlyOpen) do
            local proxy = CCBProxy:create()
            local  node  = CCBReaderLoad("ccbResources/marine_openDoor.ccbi",proxy, true,"marineDoorAniOwner")
            local openAniLayer = tolua.cast(node,"CCLayer")
            local card = MarineBranchMobsOwner["card"..v]
            card:getParent():addChild(openAniLayer)
            openAniLayer:setAnchorPoint(ccp(0.5,0.5))
            openAniLayer:setPosition(ccp(card:getPositionX(),card:getPositionY()))
        end
    end
end

function getMBMobsLayer()
    return MBMobsLayer
end

function createMBMobsLayer( index ,info )
    local MBMobsLayer = MarineBranchMobs.new()
    MBMobsLayer.index = index
    MBMobsLayer.info = info
    MBMobsLayer:refreshNavyStatus()

    -- local function handler(obj, method)
    --     return function(...)
    --         return method(obj, ...)
    --     end
    -- end
    -- local fn = handler( MBMobsLayer,MBMobsLayer.onCardClickedFight)
    local function _onEnter()
        -- addObserver(NOTI_MBMOBSFIGHT,fn)
    end

    local function _onExit()
        -- removeObserver(NOTI_MBMOBSFIGHT,fn)
    end

    --onEnter onExit
    local function _layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        end
    end

    MBMobsLayer:registerScriptHandler(_layerEventHandler)

    return MBMobsLayer
end