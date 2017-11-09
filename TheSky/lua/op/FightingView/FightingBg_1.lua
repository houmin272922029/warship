

local _bgLayer = nil
local _bgAnimationLayer = nil

FightingBg_1_LayerOwner = FightingBg_1_LayerOwner or {}
ccb["FightingBg_1_LayerOwner"] = FightingBg_1_LayerOwner

fightingBg_1_AnimationOwner = fightingBg_1_AnimationOwner or {}
ccb["fightingBg_1_AnimationOwner"] = fightingBg_1_AnimationOwner

function createFightingBg_1_layer()
    _bgAnimationLayer = tolua.cast(CCBReaderLoad("ccbResources/fightingBg_1_Animation.ccbi",CCBProxy:create(),true,"fightingBg_1_AnimationOwner"),"CCLayer")

    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/FightingBg_1.ccbi",proxy,true,"FightingBg_1_LayerOwner")
    _bgLayer = tolua.cast(node,"CCLayer")

    for i=1,3 do
        local birds = CCSprite:createWithSpriteFrameName("fightingBg_1_birds.png")
        FightingBg_1_LayerOwner["fightBg_sea"]:addChild(birds)
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

    -- local clouds0 = CCMotionStreak:create(10,10,20,ccc3(255,0,0),"ccbResources/fightingBg_ship.png")
    local clouds = CCSprite:createWithSpriteFrameName("fightingBg_1_cloud.png")
    -- clouds:addChild(clouds0)
    -- clouds0:setPosition(ccp(0,0))
    FightingBg_1_LayerOwner["fightBg_sea"]:addChild(clouds)
    clouds:setAnchorPoint(ccp(1,1))
    clouds:setOpacity(155)
    local cloudsActions = CCArray:create()
    local function resetClouds()
        clouds:setPosition(ccp(0,730))
    end
    cloudsActions:addObject(CCCallFunc:create(resetClouds))
    cloudsActions:addObject(CCMoveBy:create(40,ccp(1310,0)))
    clouds:runAction(CCRepeatForever:create(CCSequence:create(cloudsActions)))

    -- local s = CCMotionStreak:create(1,16,160,ccc3(255,255,0),"ccbResources/fightingBg_birds.png")
    -- FightingLayerOwner["fightBg_sea"]:addChild(s,1000)
    -- s:setPosition(ccp(230,450))
    -- s:runAction(CCMoveBy:create(0.5,ccp(200,0)))

    local function _bgLayerOnEnter()
    end

    local function _bgLayerOnExit()
        print("_bgLayer_1:onExit")
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
