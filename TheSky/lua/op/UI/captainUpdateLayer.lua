local _layer
local _priority


-- 名字不要重复
CaptainUpdateOwner = CaptainUpdateOwner or {}
ccb["CaptainUpdateOwner"] = CaptainUpdateOwner

local function _close()
    popUpCloseAction( CaptainUpdateOwner,"infoBg",_layer )
    runtimeCache.bLevelGuide = true
    local dic = ConfigureStorage.levelguide[tostring(userdata.level)]
    if dic then
        if not getMainLayer() then
            CCDirector:sharedDirector():replaceScene(mainSceneFun())
        else
            getMainLayer():goToHome()
        end
        local goto = string.split(dic["goto"], ".")[1]
        if goto == "duel" then
            getMainLayer():setBottomBtnOffset(2)
        elseif goto == "league" then
            getMainLayer():showBottomLeague()
        elseif goto == "countryBattle" then
            getMainLayer():showBottomWorldWar()
        end
        getMainLayer():addChild(createLevelGuideLayer(dic), 500)
    end
end

local function closeItemClick(  )
    _close()
end

CaptainUpdateOwner["closeItemClick"] = closeItemClick
CaptainUpdateOwner["confirmMenuClicked"] = closeItemClick

local function onShareClick(  )
    print("onShareClick")
    if CCDirector:sharedDirector():getRunningScene() ~= nil then
        print("升级click")
        -- PrintTable(ConfigureStorage.levelguide[tostring(userdata.level)])
            --2 大图
            local shareInfo = {pic = fileUtil:fullPathForFilename("images/sharePic_3.jpg"), text = string.format(ConfigureStorage.Share[3]["content"],userdata.name), size = 2}
            local share = createShareLayer(shareInfo, _priority - 1)
            CCDirector:sharedDirector():getRunningScene():addChild(share,100)
            -- local dic = herodata:getHeroBasicInfoByHeroId(_hid)  
            -- local shareInfo = {pic = herodata:getHeroBust1ByHeroId(dic.heroId), text = "aaaaaa", size = 1}
            -- CCDirector:sharedDirector():getRunningScene():addChild(createShareLayer(shareInfo, -137))
    end
    _layer:removeFromParentAndCleanup(true)
end

CaptainUpdateOwner["onShareClick"] = onShareClick


-- 添加粒子效果
local function addParticleCallBack()
    -- HLAddParticleScale( "images/levelup.plist", _layer, ccp(winSize.width/2,winSize.height * 0.48), 5, 102, 100,1, 1)

    -- //renzhan
    local x = RandomManager.randomRange(0, 100) * 0.01
    local y = RandomManager.randomRange(0, 100) * 0.01
    HLAddParticleScale( "images/levelup.plist", CaptainUpdateOwner["infoBg"], ccp(CaptainUpdateOwner["infoBg"]:getContentSize().width * x,CaptainUpdateOwner["infoBg"]:getContentSize().height * y), 5, 102, 100, 1 / retina, 1 / retina)
    
end 
CaptainUpdateOwner["addParticleCallBack"] = addParticleCallBack

-- 刷新UI数据
local function _refreshData()
    -- local dic = titleData:getOneTitleByTitleId( _titleId )
    -- if dic == nil then 
    --     return
    -- end
    local levelLabel = tolua.cast(CaptainUpdateOwner["levelLabel"],"CCLabelTTF")
    levelLabel:setString(HLNSLocalizedString("船长等级达到："))
    local level = tolua.cast(CaptainUpdateOwner["level"],"CCLabelTTF")
    level:setString(string.format("%s",userdata.level))

    local shipNubCountLabel = tolua.cast(CaptainUpdateOwner["shipNubCountLabel"],"CCLabelTTF")
    shipNubCountLabel:setString(HLNSLocalizedString("可上阵船员数达到："))
    local sailor = tolua.cast(CaptainUpdateOwner["sailor"],"CCLabelTTF")
    sailor:setString(string.format("%s",userdata:getFormMax()))

    local strengthMaxLabel = tolua.cast(CaptainUpdateOwner["strengthMaxLabel"],"CCLabelTTF")
    strengthMaxLabel:setString(HLNSLocalizedString("体力最大值达到："))
    local strength = tolua.cast(CaptainUpdateOwner["strength"],"CCLabelTTF")
    strength:setString(string.format("%s",userdata:getStrengthMax()))

    local spriteLabel = tolua.cast(CaptainUpdateOwner["spriteLabel"],"CCLabelTTF")
    spriteLabel:setString(HLNSLocalizedString("精力最大值达到："))
    local spirite = tolua.cast(CaptainUpdateOwner["spirite"],"CCLabelTTF")
    spirite:setString(string.format("%s",userdata:getEnergyMax()))


    if not isOpenShare(  ) then
        local  sharebtn = tolua.cast(CaptainUpdateOwner["captainupdatesharebtn"],"CCMenuItemImage")
        local  sharefont = tolua.cast(CaptainUpdateOwner["captainupdatesharefont"],"CCSprite")
        sharebtn:setVisible(false)
        sharefont:setVisible(false)
    end
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer

    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/CaptainUpdateLayer.ccbi",proxy, true,"CaptainUpdateOwner")
    _layer = tolua.cast(node,"CCLayer")
    _refreshData()
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(CaptainUpdateOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        print("1111")
        _close()
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
    local menu1 = tolua.cast(CaptainUpdateOwner["closeMenu"], "CCMenu")
    menu1:setHandlerPriority(_priority - 1)
end

-- 该方法名字每个文件不要重复
function getCaptainUpdateLayer()
	return _layer
end
-- uitype 0:点击全部称号只消失 1：添加全部称号层
function createCaptainUpdateLayer( priority)
    _priority = (priority ~= nil) and priority or -135
    _init()

    local function _onEnter()
        print("onEnter")
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
        
        popUpUiAction( CaptainUpdateOwner,"infoBg" )
    end

    local function _onExit()
        print("WOQUonExit")
        _layer = nil
        _titleId = nil
        _priority = -135
        _uiType = nil
    end

    --onEnter onExit
    local function _layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        end
    end


    _layer:registerScriptTouchHandler(onTouch ,false ,_priority ,true )
    _layer:setTouchEnabled(true)
    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end