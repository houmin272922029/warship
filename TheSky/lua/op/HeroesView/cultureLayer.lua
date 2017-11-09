local _layer
local _heroUId = nil
local _adjustUpNode = nil
local _adjustDownNode = nil
local _priority = -132

CultureLayerOwner = CultureLayerOwner or {}
ccb["CultureLayerOwner"] = CultureLayerOwner

local function onBackClicked()
    print("onBackClicked")
    if getMainLayer() ~= nil then
        getMainLayer():goToHeroes()
    end
end
CultureLayerOwner["onBackClicked"] = onBackClicked


-- 刷新UI
local function _updateCulUI()
    -- UI上的label赋值
    local function _updateUILabel( key , value)
        local label = tolua.cast(CultureLayerOwner[key], "CCLabelTTF")
        if label then
            label:setString(value)
        end
    end

    local heroInfo = herodata:getHeroInfoByHeroUId(_heroUId)
    -- PrintTable(heroInfo)
    if heroInfo then
        -- 基本数值
        _updateUILabel("name", heroInfo.name)
        _updateUILabel("point", heroInfo.point)
        _updateUILabel("pydan", wareHouseData:getItemCount("item_006"))
        local rankSprite = tolua.cast(CultureLayerOwner["rank"], "CCSprite")
        if rankSprite then
            rankSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("rank_%d_icon.png", heroInfo.rank)))
        end
        -- 属性值
        local attrsInfo = herodata:getHeroBasicAttrsByHeroUId(_heroUId)
        _updateUILabel("hp", attrsInfo.hp)
        _updateUILabel("atk", attrsInfo.atk)
        _updateUILabel("def", attrsInfo.def)
        _updateUILabel("mp", attrsInfo.mp)
    end

    -- 箭头以及调整值
    local arrow1 = tolua.cast(CultureLayerOwner["arrow1"], "CCLabelTTF")
    local arrow2 = tolua.cast(CultureLayerOwner["arrow2"], "CCLabelTTF")
    local arrow3 = tolua.cast(CultureLayerOwner["arrow3"], "CCLabelTTF")
    local arrow4 = tolua.cast(CultureLayerOwner["arrow4"], "CCLabelTTF")
    local adjust1 = tolua.cast(CultureLayerOwner["adjust1"], "CCLabelTTF")
    local adjust2 = tolua.cast(CultureLayerOwner["adjust2"], "CCLabelTTF")
    local adjust3 = tolua.cast(CultureLayerOwner["adjust3"], "CCLabelTTF")
    local adjust4 = tolua.cast(CultureLayerOwner["adjust4"], "CCLabelTTF")
    arrow1:setVisible(false)
    arrow2:setVisible(false)
    arrow3:setVisible(false)
    arrow4:setVisible(false)
    adjust1:setVisible(false)
    adjust2:setVisible(false)
    adjust3:setVisible(false)
    adjust4:setVisible(false)
    local function _updateArrowFrame( sender, value )
        if value > 0 then 
            _adjustUpNode = sender
            sender:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("arrow_3.png"))
        else 
            _adjustDownNode = sender
            sender:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("arrow_4.png"))
        end
    end 
    if heroInfo.adjust and getMyTableCount(heroInfo.adjust) > 0 then
        CultureLayerOwner["cultureFrame2"]:setVisible(true)
        CultureLayerOwner["cultureFrame1"]:setVisible(false)
    else 
        CultureLayerOwner["cultureFrame1"]:setVisible(true)
        CultureLayerOwner["cultureFrame2"]:setVisible(false)
        -- 船长等级有要求才能开启10倍培养
        if ConfigureStorage.levelOpen and ConfigureStorage.levelOpen.hero_cultivateMult and ConfigureStorage.levelOpen.hero_cultivateMult.level > userdata.level then
            -- 隐藏10次培养按钮
            CultureLayerOwner["culBtn2"]:setVisible(false)
            CultureLayerOwner["culBtn4"]:setVisible(false)
            CultureLayerOwner["culLabel2"]:setVisible(false)
            CultureLayerOwner["culLabel4"]:setVisible(false)
            CultureLayerOwner["gold2"]:setVisible(false)
            CultureLayerOwner["goldLabel2"]:setVisible(false)
            -- 移动一下位置
            CultureLayerOwner["culBtn1"]:setPosition(CultureLayerOwner["cancelBtn"]:getPosition())
            CultureLayerOwner["culLabel1"]:setPosition(CultureLayerOwner["cancelBtn"]:getPosition())
            CultureLayerOwner["culBtn3"]:setPosition(CultureLayerOwner["okBtn"]:getPosition())
            CultureLayerOwner["culLabel3"]:setPosition(CultureLayerOwner["okBtn"]:getPosition())
            CultureLayerOwner["gold1"]:setPositionX(CultureLayerOwner["okBtn"]:getPositionX()-30)
            CultureLayerOwner["goldLabel1"]:setPositionX(CultureLayerOwner["okBtn"]:getPositionX())
        end 
    end 
    for k,v in pairs(heroInfo.adjust) do
        if k == "hp" then
            arrow1:setVisible(true)
            adjust1:setVisible(true)
            _updateUILabel("adjust1", string.format("%s", v>0 and "+"..v or v))
            _updateArrowFrame(arrow1, v)
        end 
        if k == "atk" then
            arrow2:setVisible(true)
            adjust2:setVisible(true)
            _updateUILabel("adjust2", string.format("%s", v>0 and "+"..v or v))
            _updateArrowFrame(arrow2, v)
        end 
        if k == "def" then
            arrow3:setVisible(true)
            adjust3:setVisible(true)
            _updateUILabel("adjust3", string.format("%s", v>0 and "+"..v or v))
            _updateArrowFrame(arrow3, v)
        end 
        if k == "mp" then
            arrow4:setVisible(true)
            adjust4:setVisible(true)
            _updateUILabel("adjust4", string.format("%s", v>0 and "+"..v or v))
            _updateArrowFrame(arrow4, v)
        end 
    end
end 

local function culCallBack( url,rtnData )
    for k,v in pairs(rtnData["info"]) do
        if havePrefix(k, "hero") then
            herodata:addHeroByDic(v)
        end
    end 
    _updateCulUI()
end 

local function cardConfirmAction(  )
    if getMainLayer() then
        getMainLayer():goToLogue()
    end
end

local function cardCancelAction(  )
    
end
-- 普通培养1次
local function onCulture1Clicked()
    print("onCulture1Clicked")
    Global:instance():TDGAonEventAndEventData("Culture1")
    if wareHouseData:getItemCount( "item_006" ) < 5 then
        -- local text = HLNSLocalizedString("船长，您存储的蓝波球已用完，前往【罗格镇】购买配套的箱子和钥匙可以有机会获得")
        -- _layer:addChild(createSimpleConfirCardLayer(text))
        -- SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
        -- SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction

        --新的实现 进入蓝波球购买计划界面
        getMainLayer():addChild(createThePlanOfBuyBallOwnerLayer(_priority - 2))
    else
        doActionFun("CULTIVATE_URL", { _heroUId,"1" }, culCallBack)
    end
end
CultureLayerOwner["onCulture1Clicked"] = onCulture1Clicked

-- 普通培养10次
local function onCulture2Clicked()
    print("onCulture2Clicked")
    Global:instance():TDGAonEventAndEventData("Culture2")
    if wareHouseData:getItemCount( "item_006" ) < 50 then
        -- local text = HLNSLocalizedString("船长，您存储的蓝波球已用完，前往【罗格镇】购买配套的箱子和钥匙可以有机会获得")
        -- _layer:addChild(createSimpleConfirCardLayer(text))
        -- SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
        -- SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction

        --新的实现 进入蓝波球购买计划界面
        getMainLayer():addChild(createThePlanOfBuyBallOwnerLayer(_priority - 2))
    else
        doActionFun("CULTIVATE_URL", { _heroUId,"2" }, culCallBack)
    end
end
CultureLayerOwner["onCulture2Clicked"] = onCulture2Clicked

-- 精心培养
local function onCulture3Clicked()
    print("onCulture3Clicked")
    Global:instance():TDGAonEventAndEventData("Culture3")
    if wareHouseData:getItemCount( "item_006" ) < 5 then
        -- local text = HLNSLocalizedString("船长，您存储的蓝波球已用完，前往【罗格镇】购买配套的箱子和钥匙可以有机会获得")
        -- _layer:addChild(createSimpleConfirCardLayer(text))
        -- SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
        -- SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction

        --新的实现 进入蓝波球购买计划界面
        getMainLayer():addChild(createThePlanOfBuyBallOwnerLayer(_priority - 2))
    else
        doActionFun("CULTIVATE_URL", { _heroUId,"3" }, culCallBack)
    end
end
CultureLayerOwner["onCulture3Clicked"] = onCulture3Clicked

-- 超强培养
local function onCulture4Clicked()
    print("onCulture4Clicked")
    Global:instance():TDGAonEventAndEventData("Culture4")
    if wareHouseData:getItemCount( "item_006" ) < 50 then
        -- local text = HLNSLocalizedString("船长，您存储的蓝波球已用完，前往【罗格镇】购买配套的箱子和钥匙可以有机会获得")
        -- _layer:addChild(createSimpleConfirCardLayer(text))
        -- SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
        -- SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction
        
        --新的实现 进入蓝波球购买计划界面
        getMainLayer():addChild(createThePlanOfBuyBallOwnerLayer(_priority - 2))
    else
        doActionFun("CULTIVATE_URL", { _heroUId,"4" }, culCallBack)
    end
end
CultureLayerOwner["onCulture4Clicked"] = onCulture4Clicked

-- 确认培养结果
local function onConfirmClicked()
    print("onConfirmClicked")
    local function confirmCallBack( url,rtnData )
        for k,v in pairs(rtnData["info"]) do
            if havePrefix(k, "hero") then
                herodata:addHeroByDic(v)
            end
        end 
        _updateCulUI()

        local array1 = CCArray:create()
        array1:addObject(CCDelayTime:create(0.3))
        array1:addObject(CCMoveTo:create(0.3, ccp(CultureLayerOwner["pedestal"]:getPositionX(),CultureLayerOwner["pedestal"]:getPositionY() + 62)))
        local move1 = CCSequence:create(array1)

        local array2 = CCArray:create()
        array2:addObject(CCDelayTime:create(0.3))
        array2:addObject(CCMoveTo:create(0.3, ccp(_adjustUpNode:getPositionX(),_adjustUpNode:getPositionY())))
        local move2 = CCSequence:create(array2)

        HLAddParticleScaleWithAction( "images/cultivate_suc.plist", CultureLayerOwner["cultureFrame"], ccp(CultureLayerOwner["pedestal"]:getPositionX(),CultureLayerOwner["pedestal"]:getPositionY() + 62), 0.6, 10, 100,1,1,move2)

        HLAddParticleScaleWithAction( "images/cultivate_suc.plist", CultureLayerOwner["cultureFrame"], ccp(_adjustDownNode:getPositionX(),_adjustDownNode:getPositionY()), 0.6, 10, 100,1,1,move1)
    end 
    doActionFun("CONFIRM_CULTIVATE_URL", { _heroUId,"1" }, confirmCallBack)
end
CultureLayerOwner["onConfirmClicked"] = onConfirmClicked

-- 取消培养结果
local function onCancelClicked()
    print("onCancelClicked")
    local function cancelCallBack( url,rtnData )
        for k,v in pairs(rtnData["info"]) do
            if havePrefix(k, "hero") then
                herodata:addHeroByDic(v)
            end
        end 
        _updateCulUI()

        local darkLayer = CCLayerColor:create(ccc4(255, 255, 255, 255*0.4), 612, 291)
        local particlePos = ccp(250,190)
        darkLayer:setPosition(0,0)
        CultureLayerOwner["cultureFrame"]:addChild(darkLayer,10)
        local darkActions = CCArray:create()
        darkActions:addObject(CCDelayTime:create(1))
        darkActions:addObject(CCFadeOut:create(0.5))
        local function darkLayerRemove(  )
            darkLayer:removeFromParentAndCleanup(true)
        end 
        local removeDarkLayer = CCCallFunc:create(darkLayerRemove)
        darkActions:addObject(removeDarkLayer)
        darkLayer:runAction(CCSequence:create(darkActions))
        HLAddParticleScale("images/cultivate_cancel.plist", CultureLayerOwner["cultureFrame"], ccp(306,145.5), 10, 10, 100,4,4)
    end 
    doActionFun("CONFIRM_CULTIVATE_URL", { _heroUId,"0" }, cancelCallBack)
end
CultureLayerOwner["onCancelClicked"] = onCancelClicked

local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/CultureView.ccbi",proxy, true,"CultureLayerOwner")
    _layer = tolua.cast(node,"CCLayer")

    _updateCulUI()
    
    -- avatar
    local heroInfo = herodata:getHeroInfoByHeroUId(_heroUId)
    local avatar = tolua.cast(CultureLayerOwner["avatar"], "CCSprite")
    if avatar then
        herodata:getAvatarActionByHeroId(avatar, heroInfo.heroId )
    end 
end


function getCultureLayer()
    return _layer
end

function createCultureLayer(heroUId)
    print("heroUId =", heroUId)
    _heroUId = heroUId
    _init()

    function _layer:updateCulUI()
        _updateCulUI()
    end

    local function _onEnter()
        print("CultureLayer onEnter")
    end

    local function _onExit()
        print("CultureLayer onExit")
        _layer = nil
        _heroId = nil
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