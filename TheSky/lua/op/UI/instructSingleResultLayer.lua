local _layer
local _priority = -134
local _heroId
local _resp

-- 名字不要重复
InstructSingleResultOwner = InstructSingleResultOwner or {}
ccb["InstructSingleResultOwner"] = InstructSingleResultOwner


local function closeItemClick()
    getMainLayer():gotoDaily()
    getDailyLayer():updateDailyStatus()
    getDailyLayer():refreshDailyLayer()
    popUpCloseAction( InstructSingleResultOwner,"infoBg",_layer )
end
InstructSingleResultOwner["closeItemClick"] = closeItemClick

local function setMenuPriority()
    local menu = tolua.cast(InstructSingleResultOwner["menu"], "CCMenu")
    menu:setHandlerPriority(_priority - 1)
end

local function _refreshData()
    local tFrame = tolua.cast(InstructSingleResultOwner["tFrame"], "CCSprite")
    local conf = herodata:getHeroConfig(_heroId)
    tFrame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", conf.rank)))
    local tHead = tolua.cast(InstructSingleResultOwner["tHead"], "CCSprite")
    local f = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(herodata:getHeroHeadByHeroId(_heroId))
    if f then
        tHead:setVisible(true)
        tHead:setDisplayFrame(f)
    end
    local sayLabel = tolua.cast(InstructSingleResultOwner["sayLabel"], "CCLabelTTF")
    sayLabel:setString(ConfigureStorage.dianbo[_heroId].desp3)
    
    for hid,v in pairs(_resp.heros) do
        local hero = herodata:getHeroInfoByHeroUId(hid)
        local bust = tolua.cast(InstructSingleResultOwner["bust"], "CCSprite")
        local texture = CCTextureCache:sharedTextureCache():addImage(herodata:getHeroBust1ByHeroId(hero.heroId))
        if texture then
            bust:setTexture(texture)
            bust:setVisible(true)
        end
        local rank = tolua.cast(InstructSingleResultOwner["rank"], "CCSprite")
        rank:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("rank_%d_icon.png", hero.rank)))
        local name = tolua.cast(InstructSingleResultOwner["name"], "CCLabelTTF")
        name:setString(hero.name)
        local level = tolua.cast(InstructSingleResultOwner["level"], "CCLabelTTF")
        -- level:setString(string.format("LV%d", hero.level))
        level:setString(v.levelNow)
        local rankBg = tolua.cast(InstructSingleResultOwner["rankBg"], "CCSprite")
        rankBg:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("hero_bg_%d.png", hero.rank)))

        local progressBg = tolua.cast(InstructSingleResultOwner["progressBg"], "CCSprite")
        local progress = CCProgressTimer:create(CCSprite:create("images/bluePro.png"))
        progress:setType(kCCProgressTimerTypeBar)
        progress:setMidpoint(CCPointMake(0, 0))
        progress:setBarChangeRate(CCPointMake(1, 0))
        progress:setPosition(progressBg:getPositionX(), progressBg:getPositionY())
        progressBg:getParent():addChild(progress)
        progress:setPercentage(hero.exp_now / hero.expMax * 100)

        local price = tolua.cast(InstructSingleResultOwner["price"], "CCLabelTTF")
        price:setString(hero.price)

        local attr = herodata:getHeroAttrsByHeroUId(hid) 
        local atk = tolua.cast(InstructSingleResultOwner["atk"], "CCLabelTTF")
        atk:setString(attr.atk)
        local def = tolua.cast(InstructSingleResultOwner["def"], "CCLabelTTF")
        def:setString(attr.def)
        local hp = tolua.cast(InstructSingleResultOwner["hp"], "CCLabelTTF")
        hp:setString(attr.hp)
        local mp = tolua.cast(InstructSingleResultOwner["mp"], "CCLabelTTF")
        mp:setString(attr.mp)
        local ori = tolua.cast(InstructSingleResultOwner["ori"], "CCLabelTTF")
        local now = tolua.cast(InstructSingleResultOwner["now"], "CCLabelTTF")
        ori:setString(v.levelOri)
        now:setString(v.levelNow)
    end
    local exp = tolua.cast(InstructSingleResultOwner["exp"], "CCLabelTTF")
    exp:setString(string.format("EXP+%d", _resp.exp_hero))
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/InstructSingleResultInfoView.ccbi", proxy, true,"InstructSingleResultOwner")
    _layer = tolua.cast(node,"CCLayer")
    _refreshData()
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(InstructSingleResultOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction( InstructSingleResultOwner,"infoBg",_layer )
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


-- 该方法名字每个文件不要重复
function getIntructSingelResultLayer()
	return _layer
end

function createIntructSingleResultLayer(resp, heroId, priority)
    _heroId = heroId
    _resp = resp
    _priority = priority ~= nil and priority or -134
    _init()

    local function _onEnter()
        print("onEnter")
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)

        popUpUiAction( InstructSingleResultOwner,"infoBg" )
    end

    local function _onExit()
        print("onExit")
        _layer = nil
        _priority = -134
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


    _layer:registerScriptTouchHandler(onTouch ,false , _priority ,true )
    _layer:setTouchEnabled(true)
    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end