local _layer
local _skillContent
local _priority = -132
local _huid
local _pos

-- 名字不要重复
SkillDetailCanChangeOwner = SkillDetailCanChangeOwner or {}
ccb["SkillDetailCanChangeOwner"] = SkillDetailCanChangeOwner

SkillDetailCanChangeCellOwner = SkillDetailCanChangeCellOwner or {}
ccb["SkillDetailCanChangeCellOwner"] = SkillDetailCanChangeCellOwner

local function closeItemClick()
    popUpCloseAction( SkillDetailCanChangeOwner,"infoBg",_layer )
end

local function changeSkillTaped(  )
    Global:instance():TDGAonEventAndEventData("profound3")
    if getMainLayer then
        getMainLayer():getoSkillChangeSelectView(_huid,_pos,_skillContent.id)
    end
    popUpCloseAction( SkillDetailCanChangeOwner,"infoBg",_layer )
end

SkillDetailCanChangeOwner["closeItemClick"] = closeItemClick
SkillDetailCanChangeCellOwner["changeSkillTaped"] = changeSkillTaped

local function _updateLabelString(labelStr, string)
    local label = tolua.cast(SkillDetailCanChangeCellOwner[labelStr], "CCLabelTTF")
    label:setString(string)
    label:setVisible(true)
end
local function breakSkillTaped( tag,sender )
    Global:instance():TDGAonEventAndEventData("profound4")
    local _mainLayer = getMainLayer()
    
    if _mainLayer then
        runtimeCache.breakSkillType = 1
        _mainLayer:gotoBreakSkillView(_skillContent)
    end
    popUpCloseAction( SkillDetailCanChangeOwner,"infoBg",_layer )
end

SkillDetailCanChangeCellOwner["breakSkillTaped"] = breakSkillTaped

local function refreshData()
    -- local dic = skilldata:getOneSkillByUniqueID( _sid )
    local dic = _skillContent
    _updateLabelString("nameLabel", dic.skillConf.name)
    _updateLabelString("levelLabel", dic.level)
    _updateLabelString("despLabel", dic.skillConf.intro1)
    _updateLabelString("valuelabel", skilldata:getSkillPriceBySid(dic["id"]))
    local rankSprite = tolua.cast(SkillDetailCanChangeCellOwner["rankSprite"], "CCSprite")
    rankSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("rank_%d_icon.png",dic.skillConf.rank)))
    local attrSprite = tolua.cast(SkillDetailCanChangeCellOwner["attrSprite"],"CCSprite")

    local itemBg = tolua.cast(SkillDetailCanChangeCellOwner["itemBg"], "CCSprite")
    itemBg:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("itemInfoBg_2_%d.png", dic.skillConf.rank)))

    local myType
    local myAttrValue
    for key,value in pairs(dic.attr) do
        myType = key
        myAttrValue = value
    end

    attrSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("%s_icon.png",(myType == "mp") and "int" or myType)))
    
    local attrLabel = tolua.cast(SkillDetailCanChangeCellOwner["attrLabel"],"CCLabelTTF")
    attrLabel:setString(skilldata:getSkillAttrValueByUid( dic.id ))

    local addLabel = tolua.cast(SkillDetailCanChangeCellOwner["addLabel"],"CCLabelTTF")
    addLabel:setString(skilldata:getSkillDespArrtValueByUid( dic.id ))

    local icon = tolua.cast(SkillDetailCanChangeCellOwner["icon"], "CCSprite")
    local res = wareHouseData:getItemResource(dic.skillId)
    if res.icon then
        local texture = CCTextureCache:sharedTextureCache():addImage(res.icon)
        if texture then
            icon:setVisible(true)
            icon:setTexture(texture)
        end
    end
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/SkillDetailInfoView2.ccbi", proxy, true,"SkillDetailCanChangeOwner")
    _layer = tolua.cast(node,"CCLayer")
    refreshData()
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(SkillDetailCanChangeOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction( SkillDetailCanChangeOwner,"infoBg",_layer )
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
    local sv = tolua.cast(SkillDetailCanChangeOwner["sv"], "CCScrollView") 
    sv:setTouchPriority(_priority-2)
    local menu1 = tolua.cast(SkillDetailCanChangeOwner["menu"], "CCMenu")
    menu1:setHandlerPriority(_priority-1)
    local menu2 = tolua.cast(SkillDetailCanChangeCellOwner["menu"], "CCMenu")
    menu2:setHandlerPriority(_priority-1)
end

-- 该方法名字每个文件不要重复
function getSkillDetailLayer()
	return _layer
end

function createSkillDetailCanChangeLayer(skillContent,huid,pos,priority)
    _skillContent = skillContent
    _huid = huid
    _pos = pos
    _priority = (priority ~= nil) and priority or -132
    _init()

    

    local function _onEnter()
        print("onEnter")
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)

        popUpUiAction( SkillDetailCanChangeOwner,"infoBg" )
    end

    local function _onExit()
        print("onExit")
        _layer = nil
        _priority = nil
        _sid = nil
        _huid = nil
        _pos = nil
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