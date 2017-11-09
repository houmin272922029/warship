

local _bgLayer = nil

FightingBg_3_LayerOwner = FightingBg_3_LayerOwner or {}
ccb["FightingBg_3_LayerOwner"] = FightingBg_3_LayerOwner

function createFightingBg_3_layer()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/FightingBg_3.ccbi",proxy,true,"FightingBg_3_LayerOwner")
    _bgLayer = tolua.cast(node,"CCLayer")

    for i=1,3 do
        local birds = CCSprite:createWithSpriteFrameName("fightingBg_3_birds.png")
        FightingBg_3_LayerOwner["fightBg_land"]:addChild(birds)
        local waitAndFly = CCArray:create()
        waitAndFly:addObject(CCDelayTime:create(6 * i - 6))

        local function birdsFly()
            local actions = CCArray:create()

            local function resetBirds()
                birds:setPosition(ccp(230,570))
                birds:setScale(0.5)
                birds:setOpacity(0)
            end
            actions:addObject(CCCallFunc:create(resetBirds))

            local function activateBirds()
                local birdsSpawn = CCArray:create()
                birdsSpawn:addObject(CCMoveTo:create(15,ccp(540,749)))
                birdsSpawn:addObject(CCScaleTo:create(15,1.2))
                birdsSpawn:addObject(CCFadeTo:create(3,128))
                birds:runAction(CCSpawn:create(birdsSpawn))
            end
            actions:addObject(CCCallFunc:create(activateBirds))

            actions:addObject(CCDelayTime:create(18))
            birds:runAction(CCRepeatForever:create(CCSequence:create(actions)))
        end

        waitAndFly:addObject(CCCallFunc:create(birdsFly))
        birds:runAction(CCSequence:create(waitAndFly))
    end

    local clouds = CCSprite:createWithSpriteFrameName("fightingBg_3_clouds.png")
    FightingBg_3_LayerOwner["fightBg_land"]:addChild(clouds)
    clouds:setAnchorPoint(ccp(1,1))
    clouds:setOpacity(155)
    local cloudsActions = CCArray:create()
    local function resetClouds()
        clouds:setPosition(ccp(0,700))
    end
    cloudsActions:addObject(CCCallFunc:create(resetClouds))
    cloudsActions:addObject(CCMoveBy:create(40,ccp(1310,0)))
    clouds:runAction(CCRepeatForever:create(CCSequence:create(cloudsActions)))

    local function _bgLayerOnEnter()
    end

    local function _bgLayerOnExit()
        print("_bgLayer_3:onExit")
        -- _bgLayer:removeFromParentAndCleanup(true)
        -- _bgLayer = nil
    end

    --onEnter onExit
    local function layerEventHandler(eventType)
        if eventType == "enter" then
            if _bgLayerOnEnter then _bgLayerOnEnter() end
        elseif eventType == "exit" then
            if _bgLayerOnExit then _bgLayerOnExit() end
        end
    end
    _bgLayer:registerScriptHandler(layerEventHandler)
    
    return _bgLayer
end
