

local _bgLayer = nil

FightingBg_6_LayerOwner = FightingBg_6_LayerOwner or {}
ccb["FightingBg_6_LayerOwner"] = FightingBg_6_LayerOwner

function createFightingBg_6_layer()

    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/FightingBg_6.ccbi",proxy,true,"FightingBg_6_LayerOwner")
    _bgLayer = tolua.cast(node,"CCLayer")

    local clouds = CCSprite:createWithSpriteFrameName("fightingBg_6_clouds.png")
    FightingBg_6_LayerOwner["fightBg_bg"]:addChild(clouds)
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
        HLAddParticleScale( "images/eff_fightingBg6.plist", _bgLayer, ccp(_bgLayer:getContentSize().width / 2 ,_bgLayer:getContentSize().height  * 0.75 ), 5, 102, 100, 1, 1 )       
    end

    local function _bgLayerOnExit()
        print("_bgLayer_6:onExit")
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
