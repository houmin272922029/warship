local _layer
local _leftInfo
local _rightInfo

-- 名字不要重复
TeamCompOwner = TeamCompOwner or {}
ccb["TeamCompOwner"] = TeamCompOwner

LeftTeamOwner = LeftTeamOwner or {}
ccb["LeftTeamOwner"] = LeftTeamOwner

RightTeamOwner = RightTeamOwner or {}
ccb["RightTeamOwner"] = RightTeamOwner

local function closeItemClick()
    popUpCloseAction( TeamCompOwner,"infoBg",_layer )
end
TeamCompOwner["closeItemClick"] = closeItemClick

local function viewItemClick(tag)
end
LeftTeamOwner["viewItemClick"] = viewItemClick
RightTeamOwner["viewItemClick"] = viewItemClick

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/TeamCompInfoView.ccbi", proxy, true,"TeamCompOwner")
    _layer = tolua.cast(node,"CCLayer")

    local sv1 = tolua.cast(TeamCompOwner["sv1"], "CCScrollView") 
    sv1:setContentOffset(ccp(0, 590 - 1250))
    local sv2 = tolua.cast(TeamCompOwner["sv2"], "CCScrollView") 
    sv2:setContentOffset(ccp(0, 590 - 1250))
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(TeamCompOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction( TeamCompOwner,"infoBg",_layer )
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
    local sv1 = tolua.cast(TeamCompOwner["sv1"], "CCScrollView") 
    sv1:setTouchPriority(-452)
    local sv2 = tolua.cast(TeamCompOwner["sv2"], "CCScrollView") 
    sv2:setTouchPriority(-452)
    local menu = tolua.cast(TeamCompOwner["menu"], "CCMenu")
    menu:setHandlerPriority(-451)
    for i=1,8 do
        local menu1 = tolua.cast(LeftTeamOwner["heroMenu"..i], "CCMenu")
        menu1:setHandlerPriority(-451)
        local menu2 = tolua.cast(RightTeamOwner["heroMenu"..i], "CCMenu")
        menu2:setHandlerPriority(-451)
    end
end

local function _refreshScrollView(info, owner)
    for i=0,table.getTableCount(info.form) - 1 do
        local hid = info.form[tostring(i)]
        if hid then
            local heroLayer = tolua.cast(owner["hero"..i + 1], "CCLayer")
            heroLayer:setVisible(true)
            local hero = info.heroes[info.form[tostring(i)]]
            local conf = herodata:getHeroConfig(hero.heroId, hero.wake)
            local frame = tolua.cast(owner["frame"..i + 1], "CCMenuItemImage")
            frame:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", herodata:fixRank(conf.rank, hero.wake))))
            frame:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", herodata:fixRank(conf.rank, hero.wake))))
            local head = tolua.cast(owner["head"..i + 1], "CCSprite")
            local f = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(herodata:getHeroHeadByHeroId(hero.heroId))
            if f then
                head:setVisible(true)
                head:setDisplayFrame(f)
            end
            local name = tolua.cast(owner["name"..i + 1], "CCLabelTTF")
            name:setString(conf.name)
            local rank = tolua.cast(owner["rank"..i + 1], "CCSprite")
            rank:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("rank_%d_icon.png", conf.rank)))
            local level = tolua.cast(owner["level"..i + 1], "CCLabelTTF")
            level:setString(string.format(level:getString(), hero.level))
        end
    end
    local titleLayer = tolua.cast(owner["titleLayer"], "CCLayer")
    titleLayer:setPosition(ccpAdd(ccp(titleLayer:getPositionX(), titleLayer:getPositionY()), ccp(0, (8 - table.getTableCount(info.form)) * 106)))

    local count = 0
    for k,v in pairs(info.titles) do
        if count == 12 then
            break
        end
        if v.level > 0 then
            count = count + 1
            local title = tolua.cast(owner["title"..count], "CCSprite")
            title:setVisible(true)
            local titleLevel = tolua.cast(owner["titleLevel"..count], "CCLabelTTF")
            titleLevel:setString(v.level)
            local titleIcon = tolua.cast(owner["titleIcon"..count], "CCLabelTTF")
            local texture = CCTextureCache:sharedTextureCache():addImage(equipdata:getEquipIconByEquipId(v.id))
            if texture then
                titleIcon:setTexture(texture)
            else
                titleIcon:setVisible(false)
            end
        end
    end
end

local function _refreshData()
    local name1 = tolua.cast(TeamCompOwner["name1"], "CCLabelTTF")
    name1:setString(_leftInfo.name)
    local name2 = tolua.cast(TeamCompOwner["name2"], "CCLabelTTF")
    name2:setString(_rightInfo.name)
    local level1 = tolua.cast(TeamCompOwner["level1"], "CCLabelTTF")
    level1:setString(string.format(level1:getString(), _leftInfo.level))
    local level2 = tolua.cast(TeamCompOwner["level2"], "CCLabelTTF")
    level2:setString(string.format(level2:getString(), _rightInfo.level))
    _refreshScrollView(_leftInfo, LeftTeamOwner)
    _refreshScrollView(_rightInfo, RightTeamOwner)
end

-- 该方法名字每个文件不要重复
function getTeamCompLayer()
	return _layer
end

function createTeamCompLayer(leftInfo, rightInfo)
    _leftInfo = leftInfo
    _rightInfo = rightInfo
    _init()
    _refreshData()

    local function _onEnter()
        print("onEnter")
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)

        popUpUiAction( TeamCompOwner,"infoBg" )
    end

    local function _onExit()
        print("onExit")
        _layer = nil
        _leftInfo = nil
        _rightInfo = nil
    end

    --onEnter onExit
    local function _layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        end
    end


    _layer:registerScriptTouchHandler(onTouch ,false ,-450 ,true )
    _layer:setTouchEnabled(true)
    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end