local _layer
local _selected = 0
local _form

-- 名字不要重复
ChangeTeamViewOwner = ChangeTeamViewOwner or {}
ccb["ChangeTeamViewOwner"] = ChangeTeamViewOwner

local function refresh()
    for i=1,8 do
        local hero = tolua.cast(ChangeTeamViewOwner["hero"..i], "CCMenuItem")
        hero:setVisible(false)
        local cp = tolua.cast(ChangeTeamViewOwner["changePos"..i], "CCMenuItem")
        cp:setVisible(false)
        local ch = tolua.cast(ChangeTeamViewOwner["changeHero"..i], "CCMenuItem")
        ch:setVisible(false)
        local frame = tolua.cast(ChangeTeamViewOwner["frame"..i], "CCSprite")
        frame:setVisible(false)
        local name = tolua.cast(ChangeTeamViewOwner["name"..i], "CCLabelTTF")
        name:setVisible(false)
        local rank = tolua.cast(ChangeTeamViewOwner["rank"..i], "CCSprite")
        rank:setVisible(false)
        local level = tolua.cast(ChangeTeamViewOwner["level"..i], "CCLabelTTF")
        level:setVisible(false)
        local cpt = tolua.cast(ChangeTeamViewOwner["cpt"..i], "CCSprite")
        cpt:setVisible(false)
        local cht = tolua.cast(ChangeTeamViewOwner["cht"..i], "CCSprite")
        cht:setVisible(false)
        local head = tolua.cast(ChangeTeamViewOwner["head"..i], "CCSprite")
        head:setVisible(false)
    end
    for i=1,table.getTableCount(_form) do
        local hid = _form[tostring(i - 1)]
        local hero = herodata:getHero(herodata.heroes[hid])
        local h = tolua.cast(ChangeTeamViewOwner["hero"..i], "CCMenuItemImage")
        h:setVisible(true)
        local cp = tolua.cast(ChangeTeamViewOwner["changePos"..i], "CCMenuItem")
        local ch = tolua.cast(ChangeTeamViewOwner["changeHero"..i], "CCMenuItem")
        local cpt = tolua.cast(ChangeTeamViewOwner["cpt"..i], "CCSprite")
        local cht = tolua.cast(ChangeTeamViewOwner["cht"..i], "CCSprite")
        if _selected == i then
            h:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("cellBg_1.png"))
            h:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("cellBg_1.png"))
            ch:setVisible(true)
            cht:setVisible(true)
        else
            if _selected ~= 0 then
                cp:setVisible(true)
                cpt:setVisible(true)
            end
            h:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("cellBg_0.png"))
            h:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("cellBg_0.png"))
        end
        local frame = tolua.cast(ChangeTeamViewOwner["frame"..i], "CCSprite")
        frame:setVisible(true)
        frame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", hero.rank)))
        local name = tolua.cast(ChangeTeamViewOwner["name"..i], "CCLabelTTF")
        name:setVisible(true)
        name:setString(hero.name)
        local rank = tolua.cast(ChangeTeamViewOwner["rank"..i], "CCSprite")
        rank:setVisible(true)
        rank:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("rank_%d_icon.png", hero.rank)))
        local level = tolua.cast(ChangeTeamViewOwner["level"..i], "CCLabelTTF")
        level:setVisible(true)
        level:setString(string.format("LV %d", hero.level))
        local head = tolua.cast(ChangeTeamViewOwner["head"..i], "CCSprite")
        local f = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(herodata:getHeroHeadByHeroId(hero.heroId))
        if f then
            head:setDisplayFrame(f)
            head:setVisible(true)
        end
    end
end

local function heroItemClick(tag)
    _selected = _selected == tag and 0 or tag
    refresh()
end
ChangeTeamViewOwner["heroItemClick"] = heroItemClick

local function changePosItemClick(tag)
    _form[tostring(tag - 1)], _form[tostring(_selected - 1)] = _form[tostring(_selected - 1)], _form[tostring(tag - 1)]
    _selected = 0
    refresh()
end
ChangeTeamViewOwner["changePosItemClick"] = changePosItemClick

local function changeHeroItemClick(tag)
    runtimeCache.teamPage = tag - 1
    getMainLayer():gotoOnForm()
    _layer:removeFromParentAndCleanup(true)
end
ChangeTeamViewOwner["changeHeroItemClick"] = changeHeroItemClick

local function cancelClick(tag)
    _layer:removeFromParentAndCleanup(true)
end
ChangeTeamViewOwner["cancelClick"] = cancelClick

local function changeFormCallback(url, rtnData)
    herodata.form = rtnData.info.form
    getTeamLayer():refreshTeamLayer()
    _layer:removeFromParentAndCleanup(true)
end

local function confirmClick(tag)
    print("confirmClick")
    doActionFun("CHANGE_FORM", {_form}, changeFormCallback)
end
ChangeTeamViewOwner["confirmClick"] = confirmClick

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/ChangeTeamView.ccbi", proxy, true,"ChangeTeamViewOwner")
    _layer = tolua.cast(node,"CCLayer")
end

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

local function setMenuPriority()
    local menu1 = tolua.cast(ChangeTeamViewOwner["menu1"], "CCMenu")
    menu1:setHandlerPriority(-140)
    local menu2 = tolua.cast(ChangeTeamViewOwner["menu2"], "CCMenu")
    menu2:setHandlerPriority(-140)
end

-- 该方法名字每个文件不要重复
function getChangeTeamLayer()
	return _layer
end

function createChangeTeamLayer()
    _init()

    local function _onEnter()
        print("onEnter")
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.1), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
        _form = deepcopy(herodata.form)
        refresh()
    end

    local function _onExit()
        print("onExit")
        _layer = nil
        _selected = 0
        _form = nil
    end

    --onEnter onExit
    local function _layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        end
    end


    _layer:registerScriptTouchHandler(onTouch ,false ,-130 ,true )
    _layer:setTouchEnabled(true)
    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end