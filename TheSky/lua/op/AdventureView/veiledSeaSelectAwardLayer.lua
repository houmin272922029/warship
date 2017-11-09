local _layer
local _data
local _lootIndex
local _currentIndex = 1
local _bAni = false
local _gain

-- 名字不要重复
VeiledSeaSelectAwardOwner = VeiledSeaSelectAwardOwner or {}
ccb["VeiledSeaSelectAwardOwner"] = VeiledSeaSelectAwardOwner

local function closeItemClick()
    runtimeCache.veiledSeaState = veiledSeaDataFlag.home
    showVeiledSea()
end
VeiledSeaSelectAwardOwner["closeItemClick"] = closeItemClick

local function gainPopup()
    userdata:popUpGain(_gain, true)
end

local function changeState()
    getVeiledSeaLayer():changeState()
end

local function lootAnimation()
    local function lightAni()
        local cLight = tolua.cast(VeiledSeaSelectAwardOwner["light".._currentIndex], "CCSprite")
        cLight:setVisible(false)
        _currentIndex = _currentIndex % 5 + 1
        local nLight = tolua.cast(VeiledSeaSelectAwardOwner["light".._currentIndex], "CCSprite")
        nLight:setVisible(true)
    end
    local function aniStart()
        _bAni = true 
    end
    local function aniEnd()
        _bAni = false
    end
    _currentIndex = 1
    local array = CCArray:create()
    local light = tolua.cast(VeiledSeaSelectAwardOwner["light1"], "CCSprite")
    light:setVisible(true)
    array:addObject(CCCallFunc:create(aniStart))
    array:addObject(CCDelayTime:create(0.05))
    for i=1,5 * 3 do
        array:addObject(CCCallFunc:create(lightAni))
        array:addObject(CCDelayTime:create(0.05))
    end
    local timer = 0.1
    for i=1,5 do
        array:addObject(CCCallFunc:create(lightAni))
        array:addObject(CCDelayTime:create(timer))
        timer = timer + 0.1
    end
    for i=1,_lootIndex - 1 do
        array:addObject(CCCallFunc:create(lightAni))
        array:addObject(CCDelayTime:create(0.5))
    end
    array:addObject(CCCallFunc:create(aniEnd))
    array:addObject(CCDelayTime:create(0.5))
    array:addObject(CCCallFunc:create(gainPopup))
    array:addObject(CCCallFunc:create(changeState))
    _layer:runAction(CCSequence:create(array))
end

local function freeSelectionClick()
    local function callback(url, rtnData)
        _gain = rtnData.info.gain
        veiledSeaData:fromDic(rtnData["info"])      
        runtimeCache.veiledSeaState = veiledSeaData.data.flag 
        local rewardResult = rtnData.info.rewardResult
        _lootIndex = 1
        if rewardResult.type == "normal" then
            _lootIndex = tonumber(rewardResult.key) + 2
        end
        lootAnimation()
    end
    doActionFun("SEALMIST_GETREWARD", {1}, callback)
end
VeiledSeaSelectAwardOwner["freeSelectionClick"] = freeSelectionClick

local function buyOne(index)
    local bType = "special"
    local key = 0
    if index >= 2 then
        bType = "normal"
        key = index - 2
    end
    local function callback(url, rtnData)
        _gain = rtnData.info.gain
        gainPopup()
        veiledSeaData:fromDic(rtnData["info"])      
        runtimeCache.veiledSeaState = veiledSeaData.data.flag
        changeState()
    end
    doActionFun("SEALMIST_GETREWARD", {2, bType, key}, callback)
end


local function refresh()
    _data = veiledSeaData:getRewardData()

    for i=1,5 do
        local dic = _data[i]

        local contentLayer = tolua.cast(VeiledSeaSelectAwardOwner["contentLayer"..i], "CCLayer")
        local frame = tolua.cast(VeiledSeaSelectAwardOwner["frame"..i], "CCSprite")
        local bigSprite = tolua.cast(VeiledSeaSelectAwardOwner["bigSprite"..i], "CCSprite")
        local chipIcon = tolua.cast(VeiledSeaSelectAwardOwner["chipIcon"..i], "CCSprite")
        local littleSprite = tolua.cast(VeiledSeaSelectAwardOwner["littleSprite"..i], "CCSprite")
        local soulIcon = tolua.cast(VeiledSeaSelectAwardOwner["soulIcon"..i], "CCSprite")
        local countLabel = tolua.cast(VeiledSeaSelectAwardOwner["count"..i], "CCLabelTTF")
        local nameLabel = tolua.cast(VeiledSeaSelectAwardOwner["name"..i], "CCLabelTTF")

        local itemId = dic.itemId
        local count = dic.value
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
                playCustomFrameAnimation( string.format("yingzi_%s_",resDic.icon), contentLayer, ccp(contentLayer:getContentSize().width / 2,contentLayer:getContentSize().height / 2),1,4,shadowData:getColorByColorRank( resDic.rank ) )
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

        -- 设置名字和数量
        countLabel:setString(count)
        nameLabel:setString(resDic.name)
        nameLabel:setColor(shadowData:getColorByColorRank(resDic.rank))
    end
end


-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/VeiledSeaSelectAwardView.ccbi", proxy, true,"VeiledSeaSelectAwardOwner")
    _layer = tolua.cast(node,"CCLayer")

    -- addIslandTouch()
    refresh()
    local cLight = tolua.cast(VeiledSeaSelectAwardOwner["light1"], "CCSprite")
    cLight:setVisible(true)

    local content = tolua.cast(VeiledSeaSelectAwardOwner["content"], "CCLayer")
    local function onTouchBegan(x, y)
        if _bAni then
            return true
        end
        for i=1,5 do
            local rewardLayer = tolua.cast(VeiledSeaSelectAwardOwner["reward"..i], "CCLayer")
            local touchLocation = content:convertToNodeSpace(ccp(x, y))
            local rect = rewardLayer:boundingBox()
            if rect:containsPoint(touchLocation) then
                local dic = _data[i]
                _layer:addChild(createVeiledSeaSelectedLayer(i, dic, buyOne, -140))
                return false
            end
        end
        return false
    end

    local function onTouchMoved(x, y)

    end

    local function onTouchEnded(x, y)

    end

    local function onTouch(eventType, x, y)
        if eventType == "began" then   
            return onTouchBegan(x, y)
        elseif eventType == "moved" then
            return onTouchMoved(x, y)
        elseif eventType == "ended" then
            return onTouchEnded(x, y)
        end
    end
    content:registerScriptTouchHandler(onTouch)
    content:setTouchEnabled(true)
end

-- 该方法名字每个文件不要重复
function getVeiledSeaChallengeLayer()
	return _layer
end

function createVeiledSeaSelectAwardLayer()
    _init()

    local function _onEnter()
        _bAni = false
    end

    local function _onExit()
        _layer = nil
        _data = nil
        _gain = nil
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