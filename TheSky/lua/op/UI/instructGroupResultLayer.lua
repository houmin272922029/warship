local _layer
local _priority = -134
local _heroId
local _resp

-- 名字不要重复
InstructGroupResultOwner = InstructGroupResultOwner or {}
ccb["InstructGroupResultOwner"] = InstructGroupResultOwner


local function closeItemClick()
    getMainLayer():gotoDaily()
    getDailyLayer():updateDailyStatus()
    getDailyLayer():refreshDailyLayer()
    _layer:removeFromParentAndCleanup(true)
end
InstructGroupResultOwner["closeItemClick"] = closeItemClick

local function setMenuPriority()
    local menu = tolua.cast(InstructGroupResultOwner["menu"], "CCMenu")
    menu:setHandlerPriority(_priority - 1)
end

local function _refreshData()
    local tFrame = tolua.cast(InstructGroupResultOwner["tFrame"], "CCSprite")
    local conf = herodata:getHeroConfig(_heroId)
    tFrame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", conf.rank)))
    local tHead = tolua.cast(InstructGroupResultOwner["tHead"], "CCSprite")
    local f = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(herodata:getHeroHeadByHeroId(_heroId))
    if f then
        tHead:setVisible(true)
        tHead:setDisplayFrame(f)
    end
    local sayLabel = tolua.cast(InstructGroupResultOwner["sayLabel"], "CCLabelTTF")
    sayLabel:setString(ConfigureStorage.dianbo[_heroId].desp3)
    for i=0,table.getTableCount(herodata.form) - 1 do
        local hid = herodata.form[tostring(i)]
        local hero = herodata:getHero(herodata.heroes[hid])
        local heroLayer = tolua.cast(InstructGroupResultOwner["hero"..i + 1], "CCLayer")
        heroLayer:setVisible(true)
        local frame = tolua.cast(InstructGroupResultOwner["frame"..i + 1], "CCSprite")
        frame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", hero.rank)))
        local head = tolua.cast(InstructGroupResultOwner["head"..i + 1], "CCSprite")
        local f = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(herodata:getHeroHeadByHeroId(hero.heroId))
        if f then
            head:setVisible(true)
            head:setDisplayFrame(f)
        end
        local name = tolua.cast(InstructGroupResultOwner["name"..i + 1], "CCLabelTTF")
        name:setString(hero.name)
        local rank = tolua.cast(InstructGroupResultOwner["rank"..i + 1], "CCSprite")
        rank:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("rank_%d_icon.png", hero.rank)))
        local expLabel = tolua.cast(InstructGroupResultOwner["exp"..i + 1], "CCLabelTTF")
        local exp = _resp.exp_hero
        local flag = false
        if _resp["extraReward"] and _resp["extraReward"]["exp_hero"] > 0 then
            for k,id in pairs(_resp["extraReward"]["heros"]) do
                if id == hid then
                    flag = true
                    exp = exp + _resp["extraReward"]["exp_hero"]
                end 
            end
        end
        expLabel:setString(string.format("EXP+%d", exp))
        if flag then
            expLabel:setColor(ccc3(150, 212, 71))
            local cri = tolua.cast(InstructGroupResultOwner["cri"..i + 1], "CCSprite")
            cri:setVisible(true)
        end
        local ori = tolua.cast(InstructGroupResultOwner["ori"..i + 1], "CCLabelTTF")
        local now = tolua.cast(InstructGroupResultOwner["now"..i + 1], "CCLabelTTF")
        local to = tolua.cast(InstructGroupResultOwner["to"..i + 1], "CCSprite")
        ori:setString(_resp.heros[hid].levelOri)
        now:setString(_resp.heros[hid].levelNow)
        if _resp.heros[hid].levelNow > _resp.heros[hid].levelOri then
            now:setVisible(true)
            to:setVisible(true)
        end
    end
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/InstructGroupResultInfoView.ccbi", proxy, true,"InstructGroupResultOwner")
    _layer = tolua.cast(node,"CCLayer")
    _refreshData()
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(InstructGroupResultOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        _layer:removeFromParentAndCleanup(true)
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
function getIntructResultLayer()
	return _layer
end

function createIntructResultLayer(resp, heroId, priority)
    _heroId = heroId
    _resp = resp
    _priority = priority ~= nil and priority or -133
    _init()

    local function _onEnter()
        print("onEnter")
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
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