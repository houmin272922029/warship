

local _bgLayer = nil

FightingBg_5_LayerOwner = FightingBg_5_LayerOwner or {}
ccb["FightingBg_5_LayerOwner"] = FightingBg_5_LayerOwner

function createFightingBg_5_layer()

    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/FightingBg_5.ccbi",proxy,true,"FightingBg_5_LayerOwner")
    _bgLayer = tolua.cast(node,"CCLayer")

    local clouds = CCSprite:createWithSpriteFrameName("fightingBg_5_clouds.png")
    FightingBg_5_LayerOwner["fightBg_sky"]:addChild(clouds)
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
        HLAddParticleScale( "images/eff_fightingBg5.plist", _bgLayer, ccp(_bgLayer:getContentSize().width / 2,_bgLayer:getContentSize().height), 5, 102, 100,1,1 )
            
    end

    local function _bgLayerOnExit()
        print("_bgLayer_5:onExit")
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
