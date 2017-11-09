--林绍峰  
--装备的分解  选择装备
local _layer
local _priority
local _tag
local _gates
local _info
local _MBMobsLayer


MarineBranchMobsConfirmOwner = MarineBranchMobsConfirmOwner or {}
ccb["MarineBranchMobsConfirmOwner"] = MarineBranchMobsConfirmOwner


local function closeItemClick()
    print("closeItemClick1")
    popUpCloseAction(MarineBranchMobsConfirmOwner, "infoBg", _layer )
end
MarineBranchMobsConfirmOwner["closeItemClick"] = closeItemClick

local function confirmItemClick()

    function onCardClickedFight( MBMobsLayer,tag )
        print("onCardClickedFight==============")
        local doorI = MBMobsLayer.info["gate"][tostring(tag)]

        local function marineBossBattleCallback( url,rtnData )
            print("===========================", url)
            local huntTreatureData = rtnData.info.huntingTreasure
            marineBranchData:updateSpotDataByIdAndDic( huntTreatureData.stageId,huntTreatureData )
            runtimeCache.responseData = rtnData["info"]
            CCDirector:sharedDirector():replaceScene(CCTransitionFade:create(0.6, FightingScene())) 
        end
        local conf = marineBranchData:getGateConfigById(doorI.npcGroupId)
        BattleField.leftName = userdata.name
        BattleField.rightName = conf.name
        RandomManager.cursor = RandomManager.randomRange(0, 999)
        local seed = RandomManager.cursor
        BattleField:marineBossFight(doorI.npcGroupId)
        local result = BattleField.result == RESULT_WIN and 4 - BattleField.round or 0            

        marineDoorAniOwner.currentScore = MBMobsLayer.info.obtainedScore
        doActionFun("MARINE_FIGHT_BOSS", {MBMobsLayer.info["stageId"], tag, seed, result}, marineBossBattleCallback)

    end
    onCardClickedFight(_MBMobsLayer,_tag)
    popUpCloseAction(MarineBranchMobsConfirmOwner, "infoBg", _layer )
end
MarineBranchMobsConfirmOwner["confirmItemClick"] = confirmItemClick


local function cancelItemClick(tag) --
    popUpCloseAction(MarineBranchMobsConfirmOwner, "infoBg", _layer )
end
MarineBranchMobsConfirmOwner["cancelItemClick"] = cancelItemClick


local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(MarineBranchMobsConfirmOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction(MarineBranchMobsConfirmOwner, "infoBg", _layer)
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

local function setMenuPriority()
    local menu = tolua.cast(MarineBranchMobsConfirmOwner["menu"], "CCMenu")
    menu:setTouchPriority(_priority - 2)
end

function getMarineBranchMobsConfirmLayer()
    return _layer
end

local function _refreshNavyStatus()
    local gates = _gates
    local name = tolua.cast(MarineBranchMobsConfirmOwner["name"], "CCLabelTTF")
    local boss = tolua.cast(MarineBranchMobsConfirmOwner["boss"], "CCSprite")
    local sprBg = tolua.cast(MarineBranchMobsConfirmOwner["sprBg"], "CCMenuItemImage")
    local conf = marineBranchData:getGateConfigById(gates.npcGroupId)

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

    print("看看lsf_refreshNavyStatus")
    local stageConf = marineBranchData:getConfig(_info.stageId)
    -- stageConf.nsaward[3]["1"]["expect"] --白色小怪期望奖励 "1"白色
    -- PrintTable(stageConf.nsaward[3]["1"])
    --expect
    local rewards ={}
    local rewards1 = table.allKey( stageConf.nsaward[3][ tostring(conf.rank) ]["expect"] )
    for i,v in ipairs(rewards1) do
        table.insert(rewards,v )
    end
    PrintTable(rewards)
    local rewards2 = table.allKey( stageConf.nsaward[3][ tostring(conf.rank) ]["result"] )
    for i,v in ipairs(rewards2) do
        if v ~= "silver" then
            table.insert(rewards,v )
        end
    end
    PrintTable(rewards)

    local function onRewardFrameClick(tag)
        CCDirector:sharedDirector():getRunningScene():addChild(createItemDetailInfoLayer(rewards[tag], -160, "n",1), 100)
    end 
    -- 3个奖励的显示
    for i=1,3 do
        local key = "reward" .. i
        local frameKey = "reward" .. i .. "Frame"
        local rewardIcon = tolua.cast(MarineBranchMobsConfirmOwner[key], "CCSprite")
        local rewardFrame = tolua.cast(MarineBranchMobsConfirmOwner[frameKey], "CCMenuItemImage")
        rewardFrame:setTag(i)
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
            --PrintTable(item)

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

local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/MarineBranchMobsConfirm.ccbi",proxy, true,"MarineBranchMobsConfirmOwner")
    _layer = tolua.cast(node,"CCLayer")
    local title = tolua.cast(MarineBranchMobsConfirmOwner["title"], "CCLabelTTF")
    -- title:setString( HLNSLocalizedString("common.pleaseChoose-multi")  )
    _refreshNavyStatus()
end


function createMarineBranchMobsConfirmLayer(MBMobsLayer,tag,info,priority) --priority -140
    _MBMobsLayer = MBMobsLayer
    _priority = (priority ~= nil) and priority or -140
    _info = info
    _tag = tag
    local dic = _info.gate
    _gates = dic[tostring(_tag)]
    _init()
    
    local function _onEnter()
        print("MarineBranchMobsConfirmLayer onEnter")   
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
        popUpUiAction(MarineBranchMobsConfirmOwner, "infoBg")
        
    end

    local function _onExit()
        print("MarineBranchMobsConfirmLayer onExit")
        _layer = nil
        _priority = nil
        _tag = nil
        _gates = nil
        _info = nil
        _MBMobsLayer = nil
    end

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

 