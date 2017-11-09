local _layer
local _talkArray

-- 名字不要重复
StageTalkOwner = StageTalkOwner or {}
ccb["StageTalkOwner"] = StageTalkOwner

local function nextTalk()
    if #_talkArray == 0 then
        return nil
    end
    local dic = deepcopy(_talkArray[1])
    table.remove(_talkArray, 1)
    return dic
end

local function _refreshData(dic)
    for i=0,1 do
        local bust = tolua.cast(StageTalkOwner["bust_"..i], "CCSprite")
        bust:setVisible(false)
        local name = tolua.cast(StageTalkOwner["name_"..i], "CCLabelTTF")
        name:setVisible(false)
        local dialog = tolua.cast(StageTalkOwner["dialog_"..i], "CCLabelTTF")
        dialog:setVisible(false)
    end
    local pos = dic.position
    local bust = tolua.cast(StageTalkOwner["bust_"..pos], "CCSprite")
    bust:setVisible(true)
    local name = tolua.cast(StageTalkOwner["name_"..pos], "CCLabelTTF")
    name:setVisible(true)
    local dialog = tolua.cast(StageTalkOwner["dialog_"..pos], "CCLabelTTF")
    dialog:setVisible(true)

    local hero = herodata:getHero(herodata.heroes[herodata.form["0"]]) -- 首席弟子

    local texture
    if dic.bust == "hero_bust" then
        texture = CCTextureCache:sharedTextureCache():addImage(herodata:getHeroBust1ByHeroId(hero.heroId))
    else
        texture = CCTextureCache:sharedTextureCache():addImage(herodata:getHeroBust1ByHeroId(dic.bust))
    end
    if texture then
        bust:setTexture(texture)
    end
    if dic.name == "hero_name" then
        name:setString(hero.name)
    else
        name:setString(dic.name)
    end
    dialog:setString(dic.content)
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/StageTalkView.ccbi", proxy, true,"StageTalkOwner")
    _layer = tolua.cast(node,"CCLayer")
end

local function onTouchBegan(x, y)
    local dic = nextTalk()
    if not dic then
        getSailLayer():marineGuide()
        _layer:removeFromParentAndCleanup(true)
        return true
    end
    _refreshData(dic)
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
function getStageTalkLayer()
	return _layer
end

function createStageTalkLayer(talkArray)
    _talkArray = talkArray
    _init()

    local function _onEnter()
        _refreshData(nextTalk())
    end

    local function _onExit()
        _layer = nil
        _talkArray = nil
    end

    --onEnter onExit
    local function _layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        end
    end


    _layer:registerScriptTouchHandler(onTouch, false, -200, true)
    _layer:setTouchEnabled(true)
    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end
