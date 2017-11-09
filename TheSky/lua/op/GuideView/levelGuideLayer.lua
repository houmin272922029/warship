local _layer
local _dic
local step

-- ·名字不要重复
LevelGuideOwner = LevelGuideOwner or {}
ccb["LevelGuideOwner"] = LevelGuideOwner

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/LevelGuideView.ccbi",proxy, true,"LevelGuideOwner")
    _layer = tolua.cast(node,"CCLayer")
    step = 1
end

local function closeGuide()
    _layer:removeFromParentAndCleanup(true)
    runtimeCache.bLevelGuide = false
end

local function _refreshLayer()
    local goto = string.split(_dic["goto"], ".")[1]
    local layer = tolua.cast(LevelGuideOwner[goto], "CCLayer")
    layer:setVisible(true)
    local desp = tolua.cast(LevelGuideOwner["desp_"..goto], "CCLabelTTF")
    desp:setString(_dic["des1"])
    if goto == "partner" or goto == "equip" or goto == "warship" then
        local posLayer = tolua.cast(LevelGuideOwner["posLayer_"..goto], "CCLayer")
        posLayer:setContentSize(CCSizeMake(posLayer:getContentSize().width, posLayer:getContentSize().height * retina))
    end
end

local function onTouchBegan(x, y)
    return true
end

local function getBloodInfoCallback( url,rtnData )
    blooddata:fromDic(rtnData["info"]["bloodInfo"])
    runtimeCache.newWorldState = blooddata.data.flag
    getMainLayer():gotoAdventure()
    local guide1 = tolua.cast(LevelGuideOwner["guide1"], "CCLayer")
    guide1:setVisible(false)
    if _dic["des2"] then
        local guide2 = tolua.cast(LevelGuideOwner["guide2"], "CCLayer")
        guide2:setVisible(true)
        local desp2 = tolua.cast(LevelGuideOwner["desp2"], "CCLabelTTF")
        desp2:setString(_dic["des2"])
    else
        closeGuide()
    end
end

local function refreshBloodInfo()
    doActionFun("GET_BLOOD_INFO", {}, getBloodInfoCallback)
end

local function onTouchEnded(x, y)
    if step == 2 then
        if not (userdata.eliteClose and userdata.eliteClose == 1) and userdata.level == 8 then
            local text = HLNSLocalizedString("stage.elite.unlock")
            _layer:addChild(createSimpleConfirCardLayer(text), 100)
            SimpleConfirmCard.confirmMenuCallBackFun = function()
                getMainLayer():goToSail()
                closeGuide()  
            end
            SimpleConfirmCard.cancelMenuCallBackFun = function()
                closeGuide()    
            end
        else
            closeGuide()
        end
        return
    end
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local gotos = string.split(_dic["goto"], ".")
    if gotos[2] then
        runtimeCache.levelGuideNext = gotos[2]
    end
    local infoBg = tolua.cast(LevelGuideOwner["touch_"..gotos[1]], "CCLayer")
    local rect = infoBg:boundingBox()
    if gotos[1] == "partner" or gotos[1] == "equip" or gotos[1] == "warship" then
        local posLayer = tolua.cast(LevelGuideOwner["posLayer_"..gotos[1]], "CCLayer")
        local pos = ccp(rect.origin.x, winSize.height - posLayer:getContentSize().height - rect.size.height / 2)
        rect = CCRectMake(pos.x, pos.y, rect.size.width, rect.size.height)
    end
    if rect:containsPoint(touchLocation) then
        if gotos[1] == "team" then
            getMainLayer():gotoTeam()
        elseif gotos[1] == "duel" then
            getMainLayer():gotoArena()
        elseif gotos[1] == "daily" then
            getMainLayer():gotoDaily()
        elseif gotos[1] == "partner" then
            getMainLayer():goToHeroes()
        elseif gotos[1] == "equip" then
            getMainLayer():gotoEquipmentsLayer()
        elseif gotos[1] == "adventure" then
            if gotos[2] == "chapter" then
                getMainLayer():gotoAdventure()
            else
                refreshBloodInfo()
                step = step + 1
                return
            end
        elseif gotos[1] == "warship" then
            getMainLayer():gotoBattleShipLayer()
        elseif gotos[1] == "league" then
            getMainLayer():gotoUnion()
        elseif gotos[1] == "countryBattle" then
            getMainLayer():gotoWorldWar()
        end
        step = step + 1
        local guide1 = tolua.cast(LevelGuideOwner["guide1"], "CCLayer")
        guide1:setVisible(false)
        if _dic["des2"] then
            local guide2 = tolua.cast(LevelGuideOwner["guide2"], "CCLayer")
            guide2:setVisible(true)
            local desp2 = tolua.cast(LevelGuideOwner["desp2"], "CCLabelTTF")
            desp2:setString(_dic["des2"])
        else
            closeGuide()
        end
    end
end

local function onTouch(eventType, x, y)
    if eventType == "began" then   
        return onTouchBegan(x, y)
    elseif eventType == "moved" then
    else
        return onTouchEnded(x, y)
    end
end


-- 该方法名字每个文件不要重复
function getLevelGuideLayer()
	return _layer
end

function createLevelGuideLayer(dic)
    _dic = dic
    _init()


    local function _onEnter()
        _refreshLayer()
    end

    local function _onExit()
        print("onExit")
        _layer = nil
        _dic = nil
    end

    --onEnter onExit
    local function _layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        end
    end


    _layer:registerScriptTouchHandler(onTouch ,false ,-300 ,true )
    _layer:setTouchEnabled(true)
    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end