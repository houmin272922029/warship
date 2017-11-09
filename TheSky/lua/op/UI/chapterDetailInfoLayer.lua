local _layer
local _priority = -134
local _bookId

-- 名字不要重复
ChapterDetailInfoViewOwner = ChapterDetailInfoViewOwner or {}
ccb["ChapterDetailInfoViewOwner"] = ChapterDetailInfoViewOwner

ChapterDetailInfoCellOwner = ChapterDetailInfoCellOwner or {}
ccb["ChapterDetailInfoCellOwner"] = ChapterDetailInfoCellOwner

local function closeItemClick()
    popUpCloseAction( ChapterDetailInfoViewOwner,"infoBg",_layer )
end
ChapterDetailInfoViewOwner["closeItemClick"] = closeItemClick

local function closeItemClick()
    popUpCloseAction( ChapterDetailInfoViewOwner,"infoBg",_layer )
end
ChapterDetailInfoCellOwner["closeItemClick"] = closeItemClick

local function combineSkillCallback(url,rtnData)
    local conf = skilldata:getSkillConfig(_bookId)
    palyConvAnimationOnNode(_bookId, conf.chapternum, true, getAdventureLayer())
    
    chapterdata:reduceCombineTime(_bookId)
    getAdventureLayer():refreshAdventureLayer()
    popUpCloseAction( ChapterDetailInfoViewOwner,"infoBg",_layer )

end

local function combineItemClick()
    local conf = skilldata:getSkillConfig(_bookId)
    local flag = chapterdata:skillCanCombine(_bookId)
    if not flag then
        ShowText(HLNSLocalizedString("chapter.needBook"))
    else
        doActionFun("COMBINE_CHAPTER", {_bookId}, combineSkillCallback)
    end
end
ChapterDetailInfoCellOwner["combineItemClick"] = combineItemClick

-- 刷新UI数据
local function _refreshData()
    local conf = skilldata:getSkillConfig(_bookId)
    local desp = tolua.cast(ChapterDetailInfoCellOwner["desp"], "CCLabelTTF")
    desp:setString(conf.intro1)

    local skillIcon = tolua.cast(ChapterDetailInfoCellOwner["skillIcon"], "CCSprite")

    local res = wareHouseData:getItemResource(_bookId)
    if res.icon then
        local texture = CCTextureCache:sharedTextureCache():addImage(res.icon)
        if texture then
            skillIcon:setTexture(texture)
        end
    end

    local name_s = tolua.cast(ChapterDetailInfoCellOwner["name_s"], "CCLabelTTF")
    local name = tolua.cast(ChapterDetailInfoCellOwner["name"], "CCLabelTTF")
    name:setString(conf.name)
    name_s:setString(conf.name)

    local attrIcon = tolua.cast(ChapterDetailInfoCellOwner["attrIcon"], "CCSprite")
    local attrType = tolua.cast(ChapterDetailInfoCellOwner["attrType"], "CCLabelTTF")
    local attrValue = tolua.cast(ChapterDetailInfoCellOwner["attrValue"], "CCLabelTTF")
    local skillType = conf.type
    if skillType == 2 then
        -- 群体攻击，单体攻击
        attrType:setVisible(true)
        attrType:setString(HLNSLocalizedString("attrType.all"))
        attrValue:setString(tostring(conf.attr.atk))
    elseif skillType == 3 then
        attrType:setVisible(true)
        attrType:setString(HLNSLocalizedString("attrType.single"))
        attrValue:setString(tostring(conf.attr.atk))
    else
        for k,v in pairs(conf.attr) do
            if k == "mp" then
                attrIcon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("int_icon.png")) 
            else
                attrIcon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("%s_icon.png", k))) 
            end
            if skillType == 5 or skillType == 1 then
                attrValue:setString(string.format("+%d%%", v * 100))
            else
                attrValue:setString("+"..v)
            end
        end
    end

    local rank = tolua.cast(ChapterDetailInfoCellOwner["rank"], "CCSprite")
    rank:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("rank_%d_icon.png", conf.rank)))

    local itemInfoBg = tolua.cast(ChapterDetailInfoCellOwner["itemInfoBg"], "CCSprite")
    itemInfoBg:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("itemInfoBg_2_%d.png", conf.rank)))

    local countLabel = tolua.cast(ChapterDetailInfoCellOwner["countLabel"], "CCLabelTTF")
    countLabel:setString(string.format(countLabel:getString(), skilldata:getSkillCount(_bookId)))

    local chapterNum = conf.chapternum
    local layer = tolua.cast(ChapterDetailInfoCellOwner["layer_"..chapterNum], "CCLayer")
    layer:setVisible(true)
    for i=1,chapterNum do
        local label = tolua.cast(ChapterDetailInfoCellOwner[string.format("%d_%d_count", chapterNum, i)], "CCLabelTTF")
        local count = 0
        local chapterPre = string.gsub(_bookId, "book", "chapter")
        if chapterdata.chapters[_bookId][string.format("%s_%02d", chapterPre, i)] then
            count = chapterdata.chapters[_bookId][string.format("%s_%02d", chapterPre, i)]
        end
        label:setString(tostring(count))
        local countBg = tolua.cast(ChapterDetailInfoCellOwner[string.format("%d_%d_countBg", chapterNum, i)], "CCSprite")
        countBg:setVisible(true)
    end
end

local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/ChapterDetailInfoView.ccbi", proxy, true,"ChapterDetailInfoViewOwner")
    _layer = tolua.cast(node,"CCLayer")
    _refreshData()
    local sv = tolua.cast(ChapterDetailInfoViewOwner["sv"], "CCScrollView")
    sv:setContentOffset(ccp(0, -160))
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(ChapterDetailInfoViewOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction( ChapterDetailInfoViewOwner,"infoBg",_layer )
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
    local sv = tolua.cast(ChapterDetailInfoViewOwner["sv"], "CCScrollView") 
    sv:setTouchPriority(_priority - 2)
    local menu1 = tolua.cast(ChapterDetailInfoViewOwner["menu"], "CCMenu")
    menu1:setHandlerPriority(_priority - 1)
    local menu2 = tolua.cast(ChapterDetailInfoCellOwner["menu"], "CCMenu")
    menu2:setHandlerPriority(_priority - 1)
end

-- 该方法名字每个文件不要重复
function getChapterDetailInfoLayer()
	return _layer
end
--  uitype 0：强化  1：更换装备   2：分享  array { heroid:herouid,pos:_pos}
function createChapterDetailInfoLayer(bookId, priority)
    _bookId = bookId
    _priority = (priority ~= nil) and priority or -134
    _init()

    local function _onEnter()
        print("onEnter")
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)

        popUpUiAction( ChapterDetailInfoViewOwner,"infoBg" )
    end

    local function _onExit()
        print("onExit")
        _layer = nil
        _bookId = nil
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