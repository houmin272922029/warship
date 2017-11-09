local _layer
local _priority

-- 名字不要重复
ChapterRobFailViewOwner = ChapterRobFailViewOwner or {}
ccb["ChapterRobFailViewOwner"] = ChapterRobFailViewOwner

local function closeItemClick()
    popUpCloseAction( ChapterRobFailViewOwner,"infoBg",_layer )
end
ChapterRobFailViewOwner["closeItemClick"] = closeItemClick

local function chapterFightCallback(url,rtnData)
    runtimeCache.chapterFight.result = rtnData.info.result
    runtimeCache.responseData = rtnData["info"]
    CCDirector:sharedDirector():replaceScene(CCTransitionFade:create(0.6, FightingScene()))
end

local function fightItemClick()
    Global:instance():TDGAonEventAndEventData("adventure13")
    RandomManager.cursor = RandomManager.randomRange(0, 999)
    local seed = RandomManager.cursor
    local info = runtimeCache.chapterFight.info
    BattleField:chapterFight()
    local result = BattleField.result == RESULT_WIN and 4 - BattleField.round or 0
    doActionFun("CHAPTER_BATTLE", {info.id, info.frag, result, seed}, chapterFightCallback)
end
ChapterRobFailViewOwner["fightItemClick"] = fightItemClick


-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/ChapterRobFailView.ccbi", proxy, true,"ChapterRobFailViewOwner")
    _layer = tolua.cast(node,"CCLayer")
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(ChapterRobFailViewOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
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
    local menu = tolua.cast(ChapterRobFailViewOwner["menu"], "CCMenu")
    menu:setHandlerPriority(_priority - 1)
end

-- 该方法名字每个文件不要重复
function getChapterRobFailLayer()
	return _layer
end

function createChapterRobFailLayer(layerTypes, priority)
    _priority = (priority ~= nil) and priority or -134
    _init()

    local failText = tolua.cast(ChapterRobFailViewOwner["fail_text_"..layerTypes], "CCLabelTTF")
    failText:setVisible(true)

    local function _onEnter()
        print("onEnter")
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)

        popUpUiAction( ChapterRobFailViewOwner,"infoBg" )
    end

    local function _onExit()
        print("onExit")
        _layer = nil
        _priority = -134
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