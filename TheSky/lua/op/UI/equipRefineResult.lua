local _layer
local _priority
local _attrValue
local _eid
local _allDic

-- 名字不要重复
EquipRefineResultOwner = EquipRefineResultOwner or {}
ccb["EquipRefineResultOwner"] = EquipRefineResultOwner

local function closeItemClick(  )
    popUpCloseAction( EquipRefineResultOwner,"infoBg",_layer )
end

local function onConfirmTaped(  )
    popUpCloseAction( EquipRefineResultOwner,"infoBg",_layer )
end
EquipRefineResultOwner["closeItemClick"] = closeItemClick
EquipRefineResultOwner["onConfirmTaped"] = onConfirmTaped

-- 刷新UI数据
local function _refreshData()
    local frameSprite = tolua.cast(EquipRefineResultOwner["frameSprite"], "CCSprite") 
    frameSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", _allDic.rank)))
    
    local avatarSprite = tolua.cast(EquipRefineResultOwner["avatarSprite"], "CCSprite") 
    if avatarSprite then
        local texture = CCTextureCache:sharedTextureCache():addImage(equipdata:getEquipIconByEquipId( _allDic.icon ))
        if texture then
            avatarSprite:setVisible(true)
            avatarSprite:setTexture(texture)
        end  
    end

    local nameLabel = tolua.cast(EquipRefineResultOwner["nameLabel"],"CCLabelTTF")
    nameLabel:setString(_allDic["name"])

    local stageLabel = tolua.cast(EquipRefineResultOwner["stageLabel"],"CCLabelTTF")
    stageLabel:setString(HLNSLocalizedString("%s阶",_allDic["stage"]))

    local attrSprite1 = tolua.cast(EquipRefineResultOwner["attrSprite1"],"CCSprite")
    local attrSprite2 = tolua.cast(EquipRefineResultOwner["attrSprite2"],"CCSprite")
    local attrSprite3 = tolua.cast(EquipRefineResultOwner["attrSprite3"],"CCSprite")
    local myType
    local myAttrValue
    for key,value in pairs(_allDic.attr) do
        myType = key
        myAttrValue = value
    end
    attrSprite1:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(equipdata:getDisplayFrameByType(myType)))
    attrSprite2:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(equipdata:getDisplayFrameByType(myType)))
    attrSprite3:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(equipdata:getDisplayFrameByType(myType)))

    local attrLabel1 = tolua.cast(EquipRefineResultOwner["attrLabel1"],"CCLabelTTF")
    attrLabel1:setString("+"..(_allDic["refine"] * 10 ))

    local attrLabel2 = tolua.cast(EquipRefineResultOwner["attrLabel2"],"CCLabelTTF")
    attrLabel2:setString("+"..tostring(_attrValue))

    local attrLabel3 = tolua.cast(EquipRefineResultOwner["attrLabel3"],"CCLabelTTF")
    attrLabel3:setString("+"..myAttrValue)

    

end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer

    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/EquipRefineResult.ccbi",proxy, true,"EquipRefineResultOwner")
    _layer = tolua.cast(node,"CCLayer")
    _allDic = equipdata:getEquip(_eid)
    _refreshData()
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(EquipRefineResultOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction( EquipRefineResultOwner,"infoBg",_layer )
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
    local menu1 = tolua.cast(EquipRefineResultOwner["closeMenu"], "CCMenu")
    menu1:setHandlerPriority(_priority - 1)
end

-- 该方法名字每个文件不要重复
function getEquipRefinResultLayer()
	return _layer
end
-- uitype 0:点击全部称号只消失 1：添加全部称号层
function createEquipRefinResultLayer( eid,attrValue,priority)
    _attrValue = attrValue
    _eid = eid
    _priority = (priority ~= nil) and priority or -132
    _init()

    local function _onEnter()
        print("onEnter")
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)

        popUpUiAction( EquipRefineResultOwner,"infoBg" )
    end

    local function _onExit()
        _layer = nil
        _priority = -132
        _attrValue = nil
        _eid = nil
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