local _layer
local _skillContent
local _priority = -132
local _uiType

-- 名字不要重复
SkillDetailOwner = SkillDetailOwner or {}
ccb["SkillDetailOwner"] = SkillDetailOwner

SkillDetailCellOwner = SkillDetailCellOwner or {}
ccb["SkillDetailCellOwner"] = SkillDetailCellOwner

local function closeItemClick()
    runtimeCache.breakSkillType = 0
    popUpCloseAction( SkillDetailOwner,"infoBg",_layer )
end
SkillDetailOwner["closeItemClick"] = closeItemClick
local function closeClick(  )
    if _uiType == 0 then
        runtimeCache.breakSkillType = 0
    elseif _uiType == 1 then
        if not getMainLayer() then
            CCDirector:sharedDirector():replaceScene(mainSceneFun())
        end
        getMainLayer():gotoBreakSkillView(_skillContent)
    end
    popUpCloseAction( SkillDetailOwner,"infoBg",_layer )
end 
SkillDetailCellOwner["closeClick"] = closeClick

local function _updateLabelString(labelStr, string)
    local label = tolua.cast(SkillDetailCellOwner[labelStr], "CCLabelTTF")
    label:setString(string)
    label:setVisible(true)
end
local function breakSkillTaped( tag,sender )
    if _uiType == 0 then
        if getHeroInfoLayer() then
            getHeroInfoLayer():removeFromParentAndCleanup(true)
        end
        local _mainLayer = getMainLayer()
        if _mainLayer then
            _mainLayer:gotoBreakSkillView(_skillContent)
        end
    elseif _uiType == 1 then
        -- 分享有奖
        local dic = _skillContent 
        --8是分享奥义掉落
        local shareInfo = {pic = fileUtil:fullPathForFilename(wareHouseData:getItemResource(dic.skillId).icon), text = string.format(ConfigureStorage.Share[8]["content"],wareHouseData:getItemResource(dic.skillId).name), size = 1}
        -- print("daoju"..equipdata:getEquipConfig(_equipUId).icon)
        local  sharelayer = createShareLayer(shareInfo, -137)
        CCDirector:sharedDirector():getRunningScene():addChild(sharelayer,100)
    
    end
    popUpCloseAction( SkillDetailOwner,"infoBg",_layer )
end

SkillDetailCellOwner["breakSkillTaped"] = breakSkillTaped

local function refreshData()
    -- local dic = skilldata:getOneSkillByUniqueID( _sid )
    local dic = _skillContent
    _updateLabelString("nameLabel", dic.skillConf.name)
    _updateLabelString("levelLabel", dic.level)
    _updateLabelString("despLabel", dic.skillConf.intro1)
    -- local despLabel = tolua.cast(SkillDetailCellOwner["despLabel"], "CCLabelTTF")
    -- -- _updateLabelString("despLabel", dic.skillConf.intro1)
    -- despLabel:setString(dic.skillConf.intro1)
    -- _updateLabelString("priceLabel", dic.price)
    local rankSprite = tolua.cast(SkillDetailCellOwner["rankSprite"], "CCSprite")
    rankSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("rank_%d_icon.png",dic.skillConf.rank)))
    local itemBg = tolua.cast(SkillDetailCellOwner["itemBg"], "CCSprite")
    itemBg:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("itemInfoBg_2_%d.png", dic.skillConf.rank)))
    -- local attr = herodata:getHeroAtrsByHeroUId(_hid)
    -- _updateLabelString("hpLabel", attr.hpt)
    local icon = tolua.cast(SkillDetailCellOwner["icon"], "CCSprite")
    local res = wareHouseData:getItemResource(dic.skillId)
    if res.icon then
        local texture = CCTextureCache:sharedTextureCache():addImage(res.icon)
        if texture then
            icon:setVisible(true)
            icon:setTexture(texture)
        end
    end

    local attrSprite = tolua.cast(SkillDetailCellOwner["attrSprite"],"CCSprite")
    local myType
    local myAttrValue
    for key,value in pairs(dic.attr) do
        myType = key
        myAttrValue = value
    end
    attrSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("%s_icon.png",(myType == "mp") and "int" or myType)))

    local addLabel = tolua.cast(SkillDetailCellOwner["addLabel"],"CCLabelTTF")
    local attrLabel = tolua.cast(SkillDetailCellOwner["attrLabel"],"CCLabelTTF")

    attrLabel:setString(skilldata:getSkillAttrValueByUid( dic.id ))
    addLabel:setString(skilldata:getSkillDespArrtValueByUid( dic.id ))
    
    local valuelabel = tolua.cast(SkillDetailCellOwner["valuelabel"],"CCLabelTTF")
    valuelabel:setString(skilldata:getSkillPriceBySid(dic.id))

    local tupoSprite = tolua.cast(SkillDetailCellOwner["tupoSprite"],"CCSprite")
    local closeSprite = tolua.cast(SkillDetailCellOwner["closeSprite"],"CCSprite")
    if _uiType == 0 then
        tupoSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tupo_title.png"))
        closeSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("guanbi_text.png"))
    elseif _uiType == 1 then
        if not isOpenShare(  ) then
            local tupoSprite = tolua.cast(SkillDetailCellOwner["tupoSprite"],"CCSprite")
            local tupofont = tolua.cast(SkillDetailCellOwner["qianghuaItem"],"CCMenuItemImage")
            tupofont:setVisible(false)
            tupoSprite:setVisible(false)
        end
        tupoSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("fenxiangyoujiang_text.png"))
        closeSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tupo_title.png"))
    end
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/SkillDetailInfoView.ccbi", proxy, true,"SkillDetailOwner")
    _layer = tolua.cast(node,"CCLayer")
    refreshData()
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(SkillDetailOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        runtimeCache.breakSkillType = 0
        popUpCloseAction( SkillDetailOwner,"infoBg",_layer )
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
    local sv = tolua.cast(SkillDetailOwner["sv"], "CCScrollView") 
    sv:setTouchPriority(_priority-2)
    local menu1 = tolua.cast(SkillDetailOwner["menu"], "CCMenu")
    menu1:setHandlerPriority(_priority-1)
    local menu2 = tolua.cast(SkillDetailCellOwner["menu"], "CCMenu")
    menu2:setHandlerPriority(_priority-1)
end

-- 该方法名字每个文件不要重复
function getSkillDetailLayer()
	return _layer
end
-- uitype --  0  突破    1    分享
function createSkillDetailLayer(skillContent, uitype, priority)
    _skillContent = skillContent
    _uiType = uitype
    _priority = (priority ~= nil) and priority or -132
    _init()
    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)

        popUpUiAction( SkillDetailOwner,"infoBg" )
    end

    local function _onExit()
        _layer = nil
        _priority = nil
        _sid = nil
        _uiType = nil
    end

    --onEnter onExit
    local function _layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        end
    end


    _layer:registerScriptTouchHandler(onTouch ,false , _priority ,true )
    _layer:setTouchEnabled(true)
    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end