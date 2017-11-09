local _layer
local _bookId
local _priority = -134

-- 名字不要重复
ChapterInfoViewOwner = ChapterInfoViewOwner or {}
ccb["ChapterInfoViewOwner"] = ChapterInfoViewOwner


local function closeItemClick()
    popUpCloseAction( ChapterInfoViewOwner,"infoBg",_layer )
end
ChapterInfoViewOwner["closeItemClick"] = closeItemClick

-- 刷新UI数据
local function _refreshData()
    local conf = skilldata:getSkillConfig(_bookId)
    local desp = tolua.cast(ChapterInfoViewOwner["desp"], "CCLabelTTF")
    desp:setString(conf.intro1)

    local skillIcon = tolua.cast(ChapterInfoViewOwner["skillIcon"], "CCSprite")
    local res = wareHouseData:getItemResource(_bookId)
    local texture = CCTextureCache:sharedTextureCache():addImage(res.icon)
    if texture then
        skillIcon:setTexture(texture)
    else
        skillIcon:setVisible(false)
    end


    local name_s = tolua.cast(ChapterInfoViewOwner["name_s"], "CCLabelTTF")
    local name = tolua.cast(ChapterInfoViewOwner["name"], "CCLabelTTF")
    name:setString(conf.name)
    name_s:setString(conf.name)

    local attrIcon = tolua.cast(ChapterInfoViewOwner["attrIcon"], "CCSprite")
    local attrType = tolua.cast(ChapterInfoViewOwner["attrType"], "CCLabelTTF")
    local attrValue = tolua.cast(ChapterInfoViewOwner["attrValue"], "CCLabelTTF")
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
            if skillType == 5 then
                attrValue:setString("+"..v)
            else
                attrValue:setString(string.format("+%d%%", v * 100))
            end
        end
    end

    local rank = tolua.cast(ChapterInfoViewOwner["rank"], "CCSprite")
    rank:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("rank_%d_icon.png", conf.rank)))

    local itemRankBg = tolua.cast(ChapterInfoViewOwner["itemRankBg"], "CCSprite")
    itemRankBg:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("itemInfoBg_2_%d.png", conf.rank)))

    local countLabel = tolua.cast(ChapterInfoViewOwner["countLabel"], "CCLabelTTF")
    countLabel:setString(string.format(countLabel:getString(), skilldata:getSkillCount(_bookId)))

end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/ChapterInfoView.ccbi", proxy, true,"ChapterInfoViewOwner")
    _layer = tolua.cast(node,"CCLayer")
    _refreshData()
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(ChapterInfoViewOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction( ChapterInfoViewOwner,"infoBg",_layer )
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
    local menu = tolua.cast(ChapterInfoViewOwner["menu"], "CCMenu")
    menu:setHandlerPriority(_priority - 1)
end

-- 该方法名字每个文件不要重复
function getChapterInfoLayer()
	return _layer
end

function createChapterInfoLayer(bookId, priority)
    _priority = (priority ~= nil) and priority or -134
    _bookId = bookId
    _init()

    local function _onEnter()
        print("onEnter")
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)

        popUpUiAction( ChapterInfoViewOwner,"infoBg" )
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


    _layer:registerScriptTouchHandler(onTouch, false, _priority, true )
    _layer:setTouchEnabled(true)
    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end