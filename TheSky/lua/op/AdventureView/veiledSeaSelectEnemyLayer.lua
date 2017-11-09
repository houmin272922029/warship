local _layer
local bossIdArray

-- 名字不要重复
VeiledSeaSelectEnemyOwner = VeiledSeaSelectEnemyOwner or {}
ccb["VeiledSeaSelectEnemyOwner"] = VeiledSeaSelectEnemyOwner

local function closeItemClick(  )
    runtimeCache.veiledSeaState = veiledSeaDataFlag.home
    showVeiledSea()
end

VeiledSeaSelectEnemyOwner["closeItemClick"] = closeItemClick

local function addAward( )
    for i=1,table.getTableCount(bossIdArray) do
        local bossId = bossIdArray[i]
        local contentLayer = tolua.cast(VeiledSeaSelectEnemyOwner["contentLayer"..i],"CCLayer")
        local bigSprite = tolua.cast(VeiledSeaSelectEnemyOwner["bigSprite"..i],"CCSprite")
        local chipIcon = tolua.cast(VeiledSeaSelectEnemyOwner["chipIcon"..i],"CCSprite")
        local littleSprite = tolua.cast(VeiledSeaSelectEnemyOwner["littleSprite"..i],"CCSprite")
        local soulIcon = tolua.cast(VeiledSeaSelectEnemyOwner["soulIcon"..i],"CCSprite")
        local frame = tolua.cast(VeiledSeaSelectEnemyOwner["frame"..i],"CCSprite")
        local awardName = tolua.cast(VeiledSeaSelectEnemyOwner["awardName"..i],"CCSprite")
        
        local lootArray = ConfigureStorage.SeaMiBossGroup[bossId].loot
        local itemId = nil
        for k,v in pairs(lootArray) do
            itemId = k
        end
        local count = lootArray[itemId].value

        local resDic = userdata:getExchangeResource(itemId)

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
                if resDic.rank == 4 then
                    HLAddParticleScale( "images/purpleEquip.plist", bigSprite, ccp(bigSprite:getContentSize().width / 2,
                        bigSprite:getContentSize().height / 2), 1, 100, 777, 2 / 0.35 / retina, 2 / 0.35 / retina, 1 )
                end
            end

        elseif havePrefix(itemId, "item") then
            -- 道具
            bigSprite:setVisible(true)
            local texture = CCTextureCache:sharedTextureCache():addImage(resDic.icon)
            if texture then
                bigSprite:setVisible(true)
                bigSprite:setTexture(texture)
                if resDic.rank == 4 then
                    HLAddParticleScale( "images/purpleEquip.plist", bigSprite, ccp(bigSprite:getContentSize().width / 2,
                        bigSprite:getContentSize().height / 2), 1, 100, 777, 2 / 0.35 / retina, 2 / 0.35 / retina, 1 )
                end
            end
        elseif havePrefix(itemId, "shadow") then
            -- 影子
            local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
            cache:addSpriteFramesWithFile("ccbResources/shadow.plist")
            frame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("s_frame.png"))
            frame:setPosition(ccp(frame:getPositionX() + 5,frame:getPositionY() - 5))
            if resDic.icon then
                playCustomFrameAnimation( string.format("yingzi_%s_",resDic.icon),contentLayer,ccp(contentLayer:getContentSize().width / 2,contentLayer:getContentSize().height / 2),1,4,shadowData:getColorByColorRank( resDic.rank ) )
                if resDic.icon then
                    playCustomFrameAnimation( string.format("yingzi_%s_",resDic.icon), contentLayer, ccp(contentLayer:getContentSize().width / 2,contentLayer:getContentSize().height / 2),1,4,shadowData:getColorByColorRank( resDic.rank ) )
                end
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
                if resDic.rank == 4 then
                    HLAddParticleScale( "images/purpleEquip.plist", bigSprite, ccp(bigSprite:getContentSize().width / 2,
                        bigSprite:getContentSize().height / 2), 1, 100, 777, 2 / 0.35 / retina, 2 / 0.35 / retina, 1)
                end
            end
        else
            -- 金币 银币
            bigSprite:setVisible(true)
            local texture = CCTextureCache:sharedTextureCache():addImage(resDic.icon)
            if texture then
                bigSprite:setVisible(true)
                bigSprite:setTexture(texture)
                if resDic.rank == 4 then
                    HLAddParticleScale( "images/purpleEquip.plist", bigSprite, ccp(bigSprite:getContentSize().width / 2,
                        bigSprite:getContentSize().height / 2), 1, 100, 777, 2 / 0.35 / retina, 2 / 0.35 / retina, 1 )
                end
            end
        end
        if not havePrefix(itemId, "shadow") then
            frame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", resDic.rank)))
        end
        awardName:setString(resDic.name.." × "..count)
    end 
end

local function addProperty()
    local attr = {hp = 0, atk = 0, def = 0, mp = 0}

    if veiledSeaData.data.bossSelected and table.getTableCount(veiledSeaData.data.bossSelected) ~= 0 then
        for k,v in pairs(veiledSeaData.data.bossSelected) do
            local conf = ConfigureStorage.SeaMiBossGroup[v].attr
            if conf then
                for key,value in pairs(conf) do
                    attr[key] = attr[key] + value
                end
            end 
        end
    end
    for k,v in pairs(attr) do
        local label = tolua.cast(VeiledSeaSelectEnemyOwner[k], "CCLabelTTF")
        str = "%d%%"
        if v > 0 then
            label:setColor(ccc3(0,255,0))
            str = "+%d%%"
        elseif v < 0 then
            label:setColor(ccc3(255, 0, 0))
        else
            label:setColor(ccc3(255, 255, 255))
        end
        label:setString(string.format(str, math.ceil(v * 100)))
    end
end

local function refreshData()
    bossIdArray = veiledSeaData:getBossId()
    for i=1,table.getTableCount(bossIdArray) do
        local head = tolua.cast(VeiledSeaSelectEnemyOwner["head"..i], "CCSprite")
        local nameLabel = tolua.cast(VeiledSeaSelectEnemyOwner["nameLabel"..i], "CCLabelTTF")
        local bossId = bossIdArray[i]
        local boss = ConfigureStorage.SeaMiBossGroup[bossId].boss
        nameLabel:setString(boss.name)
        if havePrefix(boss.head, "hero_") then
            if CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(herodata:getHeroHeadByHeroId( boss.head )) then 
                head:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(herodata:getHeroHeadByHeroId( boss.head )))
            end
        end
        local contentLayer = tolua.cast(VeiledSeaSelectEnemyOwner["infoLayer"..i], "CCLayer")
        if ConfigureStorage.SeaMiBossGroup[bossId].attr then
            local attr = ConfigureStorage.SeaMiBossGroup[bossId].attr
            PrintTable(attr)
            local index = 1
            for k,v in pairs(attr) do
                local propertyName = CCLabelTTF:create("", "ccbResources/FZCuYuan-M03S.ttf", 20)
                propertyName:setPosition(contentLayer:getContentSize().width * 0.37, contentLayer:getContentSize().height * (0.53 - index * 0.07))
                propertyName:setColor(ccc3(255,255,255))
                contentLayer:addChild(propertyName)
                propertyName:setString(HLNSLocalizedString(k))

                local propertyNum = CCLabelTTF:create("", "ccbResources/FZCuYuan-M03S.ttf", 20)
                propertyNum:setPosition(contentLayer:getContentSize().width * 0.6, contentLayer:getContentSize().height * (0.53 - index * 0.07))
                contentLayer:addChild(propertyNum)
                if v > 0 then
                    propertyNum:setColor(ccc3(0, 255, 0))
                    propertyNum:setString("+"..(v * 100).."%")
                else
                    propertyNum:setColor(ccc3(255, 0, 0))
                    propertyNum:setString((v * 100).."%")
                end
                index = index + 1
            end
        end
        addAward()
        addProperty()
    end
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/VeiledSeaSelectEnemyView.ccbi", proxy, true,"VeiledSeaSelectEnemyOwner")
    _layer = tolua.cast(node,"CCLayer")

    local function selectedBossCallback( url, rtnData )
        if rtnData.code == 200 then 
            veiledSeaData:seaMistDataFromDic(rtnData["info"]["seaMist"])
            runtimeCache.veiledSeaState = veiledSeaData.data.flag
            -- getVeiledSeaLayer():_changeVeiledSeaState()
            showVeiledSea()
        end
    end

    local touchLayer = tolua.cast(VeiledSeaSelectEnemyOwner["touchLayer"], "CCLayer")
    local function onTouchBegan(x, y)
        local touchLocation = touchLayer:convertToNodeSpace(ccp(x, y))
        for i=1,2 do
            local infoLayer = tolua.cast(VeiledSeaSelectEnemyOwner["infoLayer"..i], "CCLayer")
            if infoLayer:boundingBox():containsPoint(touchLocation) then
                infoLayer:setScale(1.05)
            end
        end
        return true
    end

    local function onTouchMoved(x, y)
        local touchLocation = touchLayer:convertToNodeSpace(ccp(x, y))
        for i=1,2 do
            local infoLayer = tolua.cast(VeiledSeaSelectEnemyOwner["infoLayer"..i], "CCLayer")
            if not infoLayer:boundingBox():containsPoint(touchLocation) then
                infoLayer:setScale(1)
            else
                infoLayer:setScale(1.05)
            end
        end
    end

    local function onTouchEnded(x, y)
        local touchLocation = touchLayer:convertToNodeSpace(ccp(x, y))
        for i=1,2 do
            local infoLayer = tolua.cast(VeiledSeaSelectEnemyOwner["infoLayer"..i], "CCLayer")
            infoLayer:setScale(1)
            if infoLayer:boundingBox():containsPoint(touchLocation) then
                doActionFun("SEALMIST_SELECTBOSS",{bossIdArray[i]}, selectedBossCallback)
            end
        end
    end

    local function onTouch(eventType, x, y)
        if eventType == "began" then   
            return onTouchBegan(x, y)
        elseif eventType == "moved" then
            return onTouchMoved(x, y)
        else
            return onTouchEnded(x, y)
        end
    end
    touchLayer:registerScriptTouchHandler(onTouch)
    touchLayer:setTouchEnabled(true)
end

function createVeiledSeaSelectEnemyLayer()
    _init()

    local function _onEnter()
        refreshData()
    end

    local function _onExit()
        _layer = nil
        bossIdArray = nil
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