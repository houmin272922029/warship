local _layer
local _priority = -150    
local _haki
local _index

-- 名字不要重复
HakiSkillOwner = HakiSkillOwner or {}
ccb["HakiSkillOwner"] = HakiSkillOwner

HakiSkillCellOwner = HakiSkillCellOwner or {}
ccb["HakiSkillCellOwner"] = HakiSkillCellOwner

local function closeItemClick()
    popUpCloseAction(HakiSkillOwner, "infoBg", _layer)
end
HakiSkillOwner["closeItemClick"] = closeItemClick
HakiSkillCellOwner["closeItemClick"] = closeItemClick

local function detailItemClick()
    popUpCloseAction(HakiSkillOwner, "infoBg", _layer)
    getMainLayer():getParent():addChild(createHakiDetailLayer(_haki, _index, _priority - 3))
end
HakiSkillCellOwner["detailItemClick"] = detailItemClick

local function _refreshData()
    local conf = ConfigureStorage.aggress_skill["aggskill_00000" .. _index]
    local icon = tolua.cast(HakiSkillCellOwner["icon"], "CCSprite")
    local texture = CCTextureCache:sharedTextureCache():addImage(string.format("ccbResources/icons/aggskill_%06d.png", _index))
    if texture then
        icon:setVisible(true)
        icon:setTexture(texture)
    end
    local nameLabel = tolua.cast(HakiSkillCellOwner["nameLabel"], "CCLabelTTF")
    nameLabel:setString(conf.name)
    local despLabel = tolua.cast(HakiSkillCellOwner["despLabel"], "CCLabelTTF")
    local level = 1
    local function getParam()
        local ret = {}
        local param = conf["param" .. level] 
        local multi = conf.multi
        for i,v in ipairs(param) do
            ret[i] = v * multi[i]
        end
        return unpack(ret)
    end
    local words = string.format(conf.words, getParam())
    despLabel:setString(words)
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node = CCBReaderLoad("ccbResources/HakiSkillView.ccbi", proxy, true, "HakiSkillOwner")
    _layer = tolua.cast(node,"CCLayer")
    local sv = tolua.cast(HakiSkillOwner["sv"], "CCScrollView") 

    _refreshData()
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(HakiSkillOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction(HakiSkillOwner, "infoBg", _layer)
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
    local sv = tolua.cast(HakiSkillOwner["sv"], "CCScrollView") 
    sv:setTouchPriority(_priority - 2)
    local menu = tolua.cast(HakiSkillOwner["menu"], "CCMenu")
    menu:setHandlerPriority(_priority - 1)
    local cellMenu = tolua.cast(HakiSkillCellOwner["menu"], "CCMenu")
    cellMenu:setHandlerPriority(_priority - 1)
end

-- 该方法名字每个文件不要重复
function getHakiInfoLayer()
	return _layer
end

function createHakiInfoLayer(haki, index)
    _haki = haki
    _index = index
    _init()

    local function _onEnter()
        print("onEnter")
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.1), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)

        popUpUiAction(HakiSkillOwner, "infoBg")
    end

    local function _onExit()
        print("onExit")
        _layer = nil
        _haki = nil
        _index = nil
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