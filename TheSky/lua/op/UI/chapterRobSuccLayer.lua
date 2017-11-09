local _layer
local _priority = -134
local otherCaptain = nil


function setTheOtherCaptainName(a)
    -- body
    otherCaptain = a;
end
-- 名字不要重复
ChapterRobSuccViewOwner = ChapterRobSuccViewOwner or {}
ccb["ChapterRobSuccViewOwner"] = ChapterRobSuccViewOwner


local function closeItemClick()
    popUpCloseAction( ChapterRobSuccViewOwner,"infoBg",_layer )
end
ChapterRobSuccViewOwner["closeItemClick"] = closeItemClick

local function shareItemClick()
    local dic = herodata:getHeroBasicInfoByHeroId(_hid)  
    
    local chapterId = runtimeCache.chapterFight.info.frag
    local bookId = string.gsub(string.sub(chapterId, 0, 14), "chapter", "book")
    local shareInfo = {pic = fileUtil:fullPathForFilename(wareHouseData:getItemResource(bookId).icon), text = string.format(ConfigureStorage.Share[4]["content"],otherCaptain,skilldata:getSkillConfig(bookId).name), size = 1}
    local  sharelayer = createShareLayer(shareInfo, -137)
    CCDirector:sharedDirector():getRunningScene():addChild(sharelayer,100)
    popUpCloseAction( ChapterRobSuccViewOwner,"infoBg",_layer )
end
ChapterRobSuccViewOwner["shareItemClick"] = shareItemClick

-- 刷新UI数据
local function _refreshData()
    local chapterId = runtimeCache.chapterFight.info.frag
    local bookId = string.gsub(string.sub(chapterId, 0, 14), "chapter", "book")
    local conf = wareHouseData:getItemConfig(chapterId)
    local bookConf = skilldata:getSkillConfig(bookId)

    local title = tolua.cast(ChapterRobSuccViewOwner["title"], "CCLabelTTF")
    title:setString(string.format(title:getString(), bookConf.name, bookConf.name))

    local chapterName = tolua.cast(ChapterRobSuccViewOwner["chapterName"], "CCLabelTTF")
    chapterName:setString(conf.name)

    local desp1 = tolua.cast(ChapterRobSuccViewOwner["desp1"], "CCLabelTTF")
    desp1:setString(bookConf.intro1)

    local desp2 = tolua.cast(ChapterRobSuccViewOwner["desp2"], "CCLabelTTF")
    desp2:setString(string.format(desp2:getString(), conf.name, bookConf.name, bookConf.chapternum))

    local icon = tolua.cast(ChapterRobSuccViewOwner["icon"], "CCSprite")
    icon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("chapter_%d.png", tonumber(string.sub(chapterId, 16, string.len(chapterId))))))

    if not isOpenShare( ) then
        local  sharebtn = tolua.cast(ChapterRobSuccViewOwner["robsharebtn"],"CCMenuItemImage")
        local  sharefont = tolua.cast(ChapterRobSuccViewOwner["robsharefont"],"CCSprite")
        sharebtn:setVisible(false)
        sharefont:setVisible(false)
    end
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/ChapterRobSuccView.ccbi", proxy, true,"ChapterRobSuccViewOwner")
    _layer = tolua.cast(node,"CCLayer")
    _refreshData()
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(ChapterRobSuccViewOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction( ChapterRobSuccViewOwner,"infoBg",_layer )
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
    local menu = tolua.cast(ChapterRobSuccViewOwner["menu"], "CCMenu")
    menu:setHandlerPriority(_priority - 1)
end

-- 该方法名字每个文件不要重复
function getChapterRobSuccLayer()
	return _layer
end

function createChapterRobSuccLayer(priority)
    _priority = (priority ~= nil) and priority or -134
    _init()

    local function _onEnter()
        print("onEnter")
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)

        popUpUiAction( ChapterRobSuccViewOwner,"infoBg" )
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