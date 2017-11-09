local _layer
local _conf
local _callback = nil
local _hero
local _index = 1

-- 名字不要重复
StageTalkOwner = StageTalkOwner or {}
ccb["StageTalkOwner"] = StageTalkOwner

local function nextTalk()
    if _index > _conf.talknum then
        return nil
    end
    local talk = _conf["talk" .. _index]
    _index = _index + 1
    return talk
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
    local pos = dic.target - 1
    local bust = tolua.cast(StageTalkOwner["bust_"..pos], "CCSprite")
    bust:setVisible(true)
    local name = tolua.cast(StageTalkOwner["name_"..pos], "CCLabelTTF")
    name:setVisible(true)
    local dialog = tolua.cast(StageTalkOwner["dialog_"..pos], "CCLabelTTF")
    dialog:setVisible(true)

    local texture
    if pos == 0 then
        texture = CCTextureCache:sharedTextureCache():addImage(herodata:getHeroBust1ByHeroId(_hero.heroId))
        name:setString(_hero.name)
    else
        texture = CCTextureCache:sharedTextureCache():addImage(herodata:getHeroBust1ByHeroId(_conf.target))
        name:setString(herodata:getHeroConfig(_conf.target).name)
    end
    if texture then
        bust:setTexture(texture)
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
        if _callback then
            _callback()
        end
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
function getHakiTalkLayer()
	return _layer
end

function createHakiTalkLayer(conf, hero, callback)
    _conf = conf
    _hero = hero
    _callback = callback
    _index = 1
    _init()

    local function _onEnter()
        _refreshData(nextTalk())
    end

    local function _onExit()
        _layer = nil
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