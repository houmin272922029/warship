local _layer
local _priority = -134
local _instructDic

-- 名字不要重复
InstructHeroGGetOwner = InstructHeroGGetOwner or {}
ccb["InstructHeroGGetOwner"] = InstructHeroGGetOwner


local function closeItemClick()
    popUpCloseAction( InstructHeroGGetOwner,"infoBg",_layer )
end
InstructHeroGGetOwner["closeItemClick"] = closeItemClick

local function gotoDaily()
    if not getMainLayer() then
        CCDirector:sharedDirector():replaceScene(mainSceneFun())
    end
    getMainLayer():gotoDaily()
    local page = dailyData:getDailyPage(_instructDic.id)
    getDailyLayer():gotoPage(page)
    getDailyLayer():refreshDailyLayer()
    closeItemClick()
    if getBossResultLayer() then
        getBossResultLayer():close()
    end
    if getBossChallengeLayer() then
        getBossChallengeLayer():close()
    end
    if not getMainLayer() then
        CCDirector:sharedDirector():replaceScene(mainSceneFun())
    end
end
InstructHeroGGetOwner["gotoDaily"] = gotoDaily

-- 刷新UI数据
local function _refreshData()
    local frame = tolua.cast(InstructHeroGGetOwner["frame"], "CCSprite")
    local conf = herodata:getHeroConfig(_instructDic.heroId)
    frame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", conf.rank)))
    local head = tolua.cast(InstructHeroGGetOwner["head"], "CCSprite")
    local f = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(herodata:getHeroHeadByHeroId(_instructDic.heroId))
    if f then
        head:setVisible(true)
        head:setDisplayFrame(f)
    end
    local sayLabel = tolua.cast(InstructHeroGGetOwner["sayLabel"], "CCLabelTTF")
    sayLabel:setString(ConfigureStorage.dianbo[_instructDic.heroId].desp1)
    local cdTips = tolua.cast(InstructHeroGGetOwner["cdTips"], "CCLabelTTF")
    cdTips:setString(string.format(cdTips:getString(), _instructDic.instructExp))
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/IntructHeroGGetView.ccbi", proxy, true,"InstructHeroGGetOwner")
    _layer = tolua.cast(node,"CCLayer")
    _refreshData()
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(InstructHeroGGetOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction( InstructHeroGGetOwner,"infoBg",_layer )
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
    local menu = tolua.cast(InstructHeroGGetOwner["menu"], "CCMenu")
    menu:setHandlerPriority(_priority - 1)
end

-- 该方法名字每个文件不要重复
function getInstructHeroGGetLayer()
	return _layer
end

function createInstructHeroGGetLayer(instructDic, priority)
    _instructDic = instructDic
    _priority = (priority ~= nil) and priority or -140
    _init()

    local function _onEnter()
        print("onEnter")
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)

        popUpUiAction( InstructHeroGGetOwner,"infoBg" )
    end

    local function _onExit()
        print("onExit")
        _layer = nil
        _priority = -140
        _instructDic = nil
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