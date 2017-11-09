local _layer
local _priority
local _chapterId

-- 名字不要重复
GetSkillStampOwner = GetSkillStampOwner or {}
ccb["GetSkillStampOwner"] = GetSkillStampOwner

local function closeItemClick(  )
    popUpCloseAction( GetSkillStampOwner,"infoBg",_layer )
end 

GetSkillStampOwner["closeItemClick"] = closeItemClick

local function onCloseBtnTaped(  )
    popUpCloseAction( GetSkillStampOwner,"infoBg",_layer )
end 

local function onGotoAdventer(  )
    if not getMainLayer() then
        CCDirector:sharedDirector():replaceScene(mainSceneFun())
    end
    getMainLayer():gotoAdventure() 
    popUpCloseAction( GetSkillStampOwner,"infoBg",_layer ) 
end

GetSkillStampOwner["onGotoAdventer"] = onGotoAdventer

GetSkillStampOwner["onCloseBtnTaped"] = onCloseBtnTaped

local function confirmBtnTaped(  )
    popUpCloseAction( GetSkillStampOwner,"infoBg",_layer ) 
end

GetSkillStampOwner["confirmBtnTaped"] = confirmBtnTaped

local function _refreshData(  )
    local bookId = string.gsub(string.sub(_chapterId, 0, 14), "chapter", "book")
    local conf = wareHouseData:getItemConfig(_chapterId)
    local bookConf = skilldata:getSkillConfig(bookId) 

    local topLabel = tolua.cast(GetSkillStampOwner["topLabel"],"CCLabelTTF")
    topLabel:setString(HLNSLocalizedString("恭喜船长获得了%s残页，其他奥义残页可能被其他海贼团获得，可以立即前往夺取。",bookConf.name))

    local nameLabel = tolua.cast(GetSkillStampOwner["nameLabel"],"CCLabelTTF")
    nameLabel:setString(conf.name)

    local despLabel = tolua.cast(GetSkillStampOwner["despLabel"],"CCLabelTTF")
    despLabel:setString(bookConf.intro1)

    local countLabel = tolua.cast(GetSkillStampOwner["countLabel"],"CCLabelTTF")
    countLabel:setString(chapterdata:getChapterCount(_chapterId))

    local bottomLabel = tolua.cast(GetSkillStampOwner["bottomLabel"],"CCLabelTTF")
    bottomLabel:setString(string.format(HLNSLocalizedString("%s是%s奥义的一部分，收集齐%s份残页即可得到此奥义"),conf.name,bookConf.name,bookConf.chapternum))

    local avatarSprite = tolua.cast(GetSkillStampOwner["avatarSprite"], "CCSprite")
    local res = wareHouseData:getItemResource(bookConf.icon)
    if res.icon then
        local texture = CCTextureCache:sharedTextureCache():addImage(res.icon)
        if texture then
            avatarSprite:setVisible(true)
            avatarSprite:setTexture(texture)
        end
    end

    local rankSprite = tolua.cast(GetSkillStampOwner["rankSprite"],"CCSprite")
    rankSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", bookConf.rank)))
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/GetSkillStampView.ccbi",proxy, true,"GetSkillStampOwner")
    _layer = tolua.cast(node,"CCLayer")
    _refreshData()
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(GetSkillStampOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction( GetSkillStampOwner,"infoBg",_layer )
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
    local menu1 = tolua.cast(GetSkillStampOwner["closeMenu"], "CCMenu")
    menu1:setHandlerPriority(_priority - 1)
end

-- 该方法名字每个文件不要重复
function getGetSkillStampLayer()
	return _layer
end

function createGetSkillStampLayer( chapterId, priority)
    _chapterId = chapterId
    _priority = (priority ~= nil) and priority or -132
    _init()

    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)

        popUpUiAction( GetSkillStampOwner,"infoBg" )
    end

    local function _onExit()
        _layer = nil
        _priority = -132
        _chapterId = nil
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