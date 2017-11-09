local _layer
local _uiType = 0    -- 0:没选择离队伙伴   1:选择了离队伙伴，显示预览结果   2:送别后的结果展示
local _srcUI = 0     -- 0:从伙伴列表过来的 1:从阵容中的英雄弹框点过来的
local _desHeroUId = nil
local _srcHeroUId = nil
local _desOriHeroInfo = nil         -- 用于送别后的结果展示中，显示原始英雄属性数据
local _SMPType = 1   -- 0:普通生命牌   1:稀有生命牌
local _touchLayer = nil
local _lanboCount = 0       -- 传承获得的蓝波球数量
local _bloodCount = 0

FarewellLayerOwner = FarewellLayerOwner or {}
ccb["FarewellLayerOwner"] = FarewellLayerOwner

local function addTouchLayer()  
    print("addTouchLayer---------------")      
    local function onTouchBegan(x, y)
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

    _touchLayer = CCLayer:create()
    _layer:addChild(_touchLayer)
    _touchLayer:registerScriptTouchHandler(onTouch ,false ,-130 ,true )
    _touchLayer:setTouchEnabled(true)
end

-- 刷新ui
local function _updateFWUI()
    local noSelTipLabel = tolua.cast(FarewellLayerOwner["noSelTip"], "CCLabelTTF")
    local previewFrame = tolua.cast(FarewellLayerOwner["previewFrame"], "CCSprite")
    local resultFrame = tolua.cast(FarewellLayerOwner["reslutLayer"], "CCLayer")
    local figer = tolua.cast(FarewellLayerOwner["breakFiger"], "CCLayer")
    noSelTipLabel:setVisible(false)
    previewFrame:setVisible(false)
    resultFrame:setVisible(false)

    local desHeroInfo = herodata:getHeroInfoByHeroUId(_desHeroUId)
    local srcHeroInfo = herodata:getHeroInfoByHeroUId(_srcHeroUId)
    
    local noSelTip1 = tolua.cast(FarewellLayerOwner["noSelTip1"], "CCLabelTTF")
    local noSelTip2 = tolua.cast(FarewellLayerOwner["noSelTip2"], "CCLabelTTF")
    local srcName = tolua.cast(FarewellLayerOwner["srcName"], "CCLabelTTF")
    local srcLV = tolua.cast(FarewellLayerOwner["srcLV"], "CCLabelTTF")
    local srcLevel = tolua.cast(FarewellLayerOwner["srcLevel"], "CCLabelTTF")
    local desName = tolua.cast(FarewellLayerOwner["desName"], "CCLabelTTF")
    local desLevel = tolua.cast(FarewellLayerOwner["desLevel"], "CCLabelTTF")

    -- 预览框内容
    local preSrcNameLabel = tolua.cast(FarewellLayerOwner["preSrcNameLabel"], "CCLabelTTF")
    local preDesLevelLabel = tolua.cast(FarewellLayerOwner["preDesLevelLabel"], "CCLabelTTF")
    local preSrcExp = tolua.cast(FarewellLayerOwner["preSrcExp"], "CCLabelTTF")
    local preDesLevelOri = tolua.cast(FarewellLayerOwner["preDesLevelOri"], "CCLabelTTF")
    local preDesLevelResult = tolua.cast(FarewellLayerOwner["preDesLevelResult"], "CCLabelTTF")
    local preGetPYDCount = tolua.cast(FarewellLayerOwner["preGetPYDCount"], "CCLabelTTF")
    local preGetBloodCount = tolua.cast(FarewellLayerOwner["preGetBloodCount"], "CCLabelTTF")
    local preSMPName = tolua.cast(FarewellLayerOwner["preSMPName"], "CCLabelTTF")
    local preSMPBtn = tolua.cast(FarewellLayerOwner["smpBtn"], "CCMenuItemImage")
    local preSMPIcon = tolua.cast(FarewellLayerOwner["smpIcon"], "CCSprite")

    -- 结果展示框内容
    local resOriLevel = tolua.cast(FarewellLayerOwner["oriLevel"], "CCLabelTTF")
    local resOriHP = tolua.cast(FarewellLayerOwner["oriHp"], "CCLabelTTF")
    local resOriDef = tolua.cast(FarewellLayerOwner["oriDef"], "CCLabelTTF")
    local resOriAtk = tolua.cast(FarewellLayerOwner["oriAtk"], "CCLabelTTF")
    local resOriInt = tolua.cast(FarewellLayerOwner["oriInt"], "CCLabelTTF")
    local resCurLevel = tolua.cast(FarewellLayerOwner["reslutLevel"], "CCLabelTTF")
    local resCurHP = tolua.cast(FarewellLayerOwner["reslutHp"], "CCLabelTTF")
    local resCurDef = tolua.cast(FarewellLayerOwner["reslutDef"], "CCLabelTTF")
    local resCurAtk = tolua.cast(FarewellLayerOwner["reslutAtk"], "CCLabelTTF")
    local resCurInt = tolua.cast(FarewellLayerOwner["reslutInt"], "CCLabelTTF")
    local resOriPoint = tolua.cast(FarewellLayerOwner["oriPoint"], "CCLabelTTF")
    local resOriBreak = tolua.cast(FarewellLayerOwner["oriBreak"], "CCLabelTTF")
    local resCurPoint = tolua.cast(FarewellLayerOwner["resultPoint"], "CCLabelTTF")
    local resCurBreak = tolua.cast(FarewellLayerOwner["resultBreak"], "CCLabelTTF")
    local resGainLBQCount = tolua.cast(FarewellLayerOwner["gainLBQCount"], "CCLabelTTF")
    local resGainBloodCount = tolua.cast(FarewellLayerOwner["gainBloodCount"], "CCLabelTTF")

    -- avatar
    
    local avatarRight = tolua.cast(FarewellLayerOwner["avatarRight"], "CCSprite")
    if avatarRight then
        avatarRight:setVisible(false)
        figer:setVisible(true)
    end 
    if _uiType == 0 then
        noSelTipLabel:setVisible(true)
        noSelTip1:setVisible(true)
        noSelTip2:setVisible(true)
        srcName:setVisible(false)
        srcLV:setVisible(false) 
        srcLevel:setVisible(false)
    elseif _uiType == 1 then
        previewFrame:setVisible(true)
        noSelTipLabel:setVisible(false)
        noSelTip1:setVisible(false)
        noSelTip2:setVisible(false)
        srcName:setVisible(true)
        srcLV:setVisible(true) 
        srcLevel:setVisible(true)
        srcName:setString(srcHeroInfo.name)
        srcLevel:setString(srcHeroInfo.level)

        preSrcNameLabel:setString(HLNSLocalizedString("%s贡献:", srcHeroInfo.name))
        preDesLevelLabel:setString(HLNSLocalizedString("%s等级:", desHeroInfo.name))
        preSrcExp:setString(_SMPType == 0 and math.floor(srcHeroInfo.exp_all * 0.8) or srcHeroInfo.exp_all)
        preDesLevelOri:setString(desHeroInfo.level)
        local simHeroInfo = herodata:simAddExp(_desHeroUId , _SMPType == 0 and math.floor(srcHeroInfo.exp_all * 0.8) or srcHeroInfo.exp_all)
        preDesLevelResult:setString(simHeroInfo.level)
        _lanboCount = herodata:getFarewellLanBoForHeroUId(_srcHeroUId)
        preGetPYDCount:setString(_lanboCount)
        _bloodCount = math.floor(herodata:getHakiTrainTotalCost(srcHeroInfo.aggress or {kind = 1, layer = 1, base = 0, pre = 0}) 
            * ConfigureStorage.aggress_inheritance[tostring(1 + _SMPType)].getpercent)
        preGetBloodCount:setString(_bloodCount)

        preSMPName:setString(wareHouseData:getItemName(_SMPType == 0 and "item_008" or "item_009"))
        local conf = wareHouseData:getItemResource(_SMPType == 0 and "item_008" or "item_009")
        preSMPBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", conf.rank)))
        if conf.icon then
            preSMPIcon:setTexture(CCTextureCache:sharedTextureCache():addImage(conf.icon))
        end

        -- avatar
        if avatarRight then
            avatarRight:setVisible(true)
            figer:setVisible(false)
            herodata:getAvatarActionByHeroId(avatarRight, srcHeroInfo.heroId )
        end 

    elseif _uiType == 2 then
        resultFrame:setVisible(true)
        noSelTip1:setVisible(true)
        noSelTip2:setVisible(true)
        srcName:setVisible(false)
        srcLV:setVisible(false) 
        srcLevel:setVisible(false)
        resOriLevel:setString(_desOriHeroInfo.level)
        resOriHP:setString(_desOriHeroInfo.hp)
        resOriDef:setString(_desOriHeroInfo.def)
        resOriAtk:setString(_desOriHeroInfo.atk)
        resOriInt:setString(_desOriHeroInfo.mp)
        resOriPoint:setString(_desOriHeroInfo.point)
        resOriBreak:setString(_desOriHeroInfo.oriBreak)
        local attrsInfo = herodata:getHeroBasicAttrsByHeroUId(_desHeroUId)
        resCurLevel:setString(desHeroInfo.level)
        resCurHP:setString(attrsInfo.hp)
        resCurDef:setString(attrsInfo.def)
        resCurAtk:setString(attrsInfo.atk)
        resCurInt:setString(attrsInfo.mp)
        resCurPoint:setString(desHeroInfo.point)
        resCurBreak:setString(desHeroInfo["break"])
        resGainLBQCount:setString(_lanboCount)
        resGainBloodCount:setString(_bloodCount)
    end 

    desName:setString(desHeroInfo.name)
    desLevel:setString(desHeroInfo.level)
end 

-- 退出
local function onBackClicked()
    print("onBackClicked")
    if getMainLayer() ~= nil then
        if _srcUI == 1 then
            getMainLayer():gotoTeam()
        else 
            getMainLayer():goToHeroes()
        end
    end
end
FarewellLayerOwner["onBackClicked"] = onBackClicked

local function farewellEffect()

        addTouchLayer()
        local avatarLeft = tolua.cast(FarewellLayerOwner["avatarLeft"], "CCSprite")
        local avatarRight = tolua.cast(FarewellLayerOwner["avatarRight"], "CCSprite")
        avatarRight:setVisible(true)
        avatarRight:runAction(CCFadeOut:create(1))

        HLAddParticleScale( "ccbResources/conv/effect_prt_500.plist", avatarRight, ccp(avatarRight:getContentSize().width/2, avatarRight:getContentSize().height * 0.5), 4, 4, 4,1/retina,1/retina)
        HLAddParticleScale( "ccbResources/conv/eff_page_204_4.plist", getMainLayer(), ccp(winSize.width * 0.702, winSize.height * 0.51), 2, 1, 1,0.25,1)

        local delayAndFallDown = CCArray:create()
        delayAndFallDown:addObject(CCDelayTime:create(2))
        local function fallDownParticle()
            HLAddParticleScale( "ccbResources/conv/effect_prt_500.plist", avatarLeft, ccp(avatarLeft:getContentSize().width/2, avatarLeft:getContentSize().height * 0.5), 4, 4, 4,1/retina,1/retina)
            HLAddParticleScale( "ccbResources/conv/eff_page_206_4.plist", getMainLayer(), ccp(winSize.width * 0.267, winSize.height * 1.2), 2, 1, 1,1,1)
        end
        delayAndFallDown:addObject(CCCallFunc:create(fallDownParticle))
        delayAndFallDown:addObject(CCDelayTime:create(1))
        local function fallDownFinished()
            _updateFWUI()
            _desOriHeroInfo = nil
            _touchLayer:removeFromParentAndCleanup(true)
            _touchLayer = nil
        end
        delayAndFallDown:addObject(CCCallFunc:create(fallDownFinished))
        _touchLayer:runAction(CCSequence:create(delayAndFallDown))
end

-- 点击送别按钮
local function onFareWellClicked()
    print("onFareWellClicked")
    local function transferCallBack( url,rtnData )
        for k,v in pairs(rtnData["info"]) do
            if havePrefix(k, "hero") then
                herodata:addHeroByDic(v)
            end
        end 
        _uiType = 2
        _srcHeroUId = nil
        farewellEffect()
    end 

    if _uiType == 0 then
        if getMainLayer() ~= nil then
            Global:instance():TDGAonEventAndEventData("lineage")
            getMainLayer():gotoSelHeroFarewell(_desHeroUId)
        end
    elseif _uiType == 1 then 
        Global:instance():TDGAonEventAndEventData("lineage1")
        if wareHouseData:getItemCount("item_008") == 0 and wareHouseData:getItemCount("item_009") == 0 then
            -- 没有生命牌
            ShowText(HLNSLocalizedString("您的生命牌不足,请选择购买"))
            getMainLayer():addChild(createSelectSMPLayer(-135))
            return
        end 
        _desOriHeroInfo = herodata:getHeroBasicAttrsByHeroUId(_desHeroUId)         -- 保存下原始英雄数据
        local desHeroInfo = herodata:getHeroInfoByHeroUId(_desHeroUId)
        _desOriHeroInfo.level = desHeroInfo.level
        _desOriHeroInfo.point = desHeroInfo.point
        _desOriHeroInfo.oriBreak = desHeroInfo["break"]

        if _SMPType == 1 then
            doActionFun("TRANSFER_URL", { _desHeroUId, _srcHeroUId, "2" }, transferCallBack)
        elseif _SMPType == 0 then
            doActionFun("TRANSFER_URL", { _desHeroUId, _srcHeroUId, "1" }, transferCallBack)
        end 
    else
        if getMainLayer() ~= nil then
            getMainLayer():gotoSelHeroFarewell(_desHeroUId)
        end
    end
end
FarewellLayerOwner["onFareWellClicked"] = onFareWellClicked

-- 点击生命牌按钮
local function onClickedSMP()
    print("onClickedSMP")
    getMainLayer():addChild(createSelectSMPLayer(-135))
end
FarewellLayerOwner["onClickedSMP"] = onClickedSMP

-- 点击选择伙伴底座按钮
local function onClickedPedestal()
    print("onClickedPedestal")
    
    if getMainLayer() ~= nil then
        getMainLayer():gotoSelHeroFarewell(_desHeroUId)
    end
end 
FarewellLayerOwner["onClickedPedestal"] = onClickedPedestal

-- 设置生命牌类型
function setSMPType(smpType)
    _SMPType = smpType
    _updateFWUI()
end 

local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/FarewellView.ccbi",proxy, true,"FarewellLayerOwner")
    _layer = tolua.cast(node,"CCLayer")

    if wareHouseData:getItemCount("item_009") > 0 then
        _SMPType = 1
    elseif wareHouseData:getItemCount("item_008") > 0 then
        _SMPType = 0
    else 
        _SMPType = 1
    end 
    _updateFWUI()
    local desHeroInfo = herodata:getHeroInfoByHeroUId(_desHeroUId)
    local avatarLeft = tolua.cast(FarewellLayerOwner["avatarLeft"], "CCSprite")
    if avatarLeft then
        herodata:getAvatarActionByHeroId(avatarLeft, desHeroInfo.heroId )
    end 
end

function getFarewellLayer()
    return _layer
end


function createFarewellLayer(desHeroUId, srcHeroUId, uiType, srcUI)
    _desHeroUId = desHeroUId
    _srcHeroUId = srcHeroUId
    _uiType = uiType
    _srcUI = srcUI
    _init()


    local function _onEnter()
        print("FarewellLayer onEnter")
    end

    local function _onExit()
        print("FarewellLayer onExit")
        _layer = nil
        _uiType = 0
        _srcUI = 0
        _desHeroUId = nil
        _srcHeroUId = nil
        _desOriHeroInfo = nil
        _lanboCount = 0
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