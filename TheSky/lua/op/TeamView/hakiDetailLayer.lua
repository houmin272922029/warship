local _layer
local _priority = -153
local _haki
local _index
local attrSp = nil

-- 名字不要重复
HakiDetailOwner = HakiDetailOwner or {}
ccb["HakiDetailOwner"] = HakiDetailOwner

HakiDetailCellOwner = HakiDetailCellOwner or {}
ccb["HakiDetailCellOwner"] = HakiDetailCellOwner

local function closeItemClick()
    popUpCloseAction(HakiDetailOwner, "infoBg", _layer)
end
HakiDetailOwner["closeItemClick"] = closeItemClick

local function collectItemClick()
    getMainLayer():gotoAdventure()
    getAdventureLayer():showUninhabited()
    popUpCloseAction(HakiDetailOwner, "infoBg", _layer)
end
HakiDetailOwner["collectItemClick"] = collectItemClick

local function _refreshData()
    -- {kind = 8, layer = 5, base = 20} index = 8
    local kind, layer, base = _index, _index < _haki.kind and 8 or _haki.layer, _index < _haki.kind and 30 or _haki.base

    local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
    local name = tolua.cast(HakiDetailOwner["name"], "CCSprite")
    name:setDisplayFrame(cache:spriteFrameByName(string.format("name_aggskill_%06d.png", kind)))
    local skillLayer = tolua.cast(HakiDetailCellOwner["skill" .. kind], "CCLayer")
    skillLayer:setVisible(true)
    local step = tolua.cast(HakiDetailCellOwner["step"], "CCLabelTTF")
    step:setString(string.format(HLNSLocalizedString("haki.detail.stage"), HLNSLocalizedString("characters." .. layer)))
    local icon = tolua.cast(HakiDetailCellOwner["icon"], "CCSprite")
    local texture = CCTextureCache:sharedTextureCache():addImage(string.format("ccbResources/icons/aggskill_%06d.png", kind))
    if texture then
        icon:setVisible(true)
        icon:setTexture(texture)
    end
    local conf = ConfigureStorage.aggress_skill["aggskill_00000" .. kind]
    name = tolua.cast(HakiDetailCellOwner["name"], "CCLabelTTF")
    name:setString(conf.name)
    local desp = tolua.cast(HakiDetailCellOwner["desp"], "CCLabelTTF")
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
    desp:setString(words)

    for i=1,8 do
        local step_label = tolua.cast(HakiDetailCellOwner["step_" .. i], "CCLabelTTF")
        step_label:setString(herodata:getTrainAttr(kind, i))
        if i < layer or (i == layer and base == 30) then
            step_label:setColor(ccc3(0, 255, 0))
        else
            step_label:setColor(ccc3(140, 140, 140))
        end
    end
    for i = 1, 29 do
        local line = tolua.cast(HakiDetailCellOwner[string.format("line_%d_%d", kind, i)], "CCSprite")
        if i < base then
            line:setDisplayFrame(cache:spriteFrameByName("haki_line_1.png"))
        end
    end
    local menu = tolua.cast(HakiDetailCellOwner["menu"], "CCMenu")
    for i = 1, 30 do
        local ball = tolua.cast(HakiDetailCellOwner[string.format("ball_%d_%d", kind, i)], "CCSprite")
        ball:setVisible(false)
        ball:getParent():setScale(0.8)
        local x, y = ball:getParent():getPosition()
        local item
        if i <= base then
            local norSp = CCSprite:createWithSpriteFrameName(string.format("blood_%d_1.png", layer))
            local selSp = CCSprite:createWithSpriteFrameName(string.format("blood_%d_1.png", layer))
            item = CCMenuItemSprite:create(norSp, selSp)
        else
            if layer > 1 then
                local norSp = CCSprite:createWithSpriteFrameName(string.format("blood_%d_1.png", layer - 1))
                local selSp = CCSprite:createWithSpriteFrameName(string.format("blood_%d_1.png", layer - 1))
                item = CCMenuItemSprite:create(norSp, selSp)
            end
        end
        if item then
            item:setPosition(ccp(x, y + 1))
            item:setScale(0.85)
            menu:addChild(item, 1, i)
            local function click(tag)
                local attr = herodata:getBallAttr(kind, tag <= base and layer or layer - 1, tag)
                local strs = {}
                for k,v in pairs(attr) do
                    if v > 0 then
                        local str = HLNSLocalizedString(k) .. "+" .. v
                        strs[#strs + 1] = str
                    end
                end
                local tipsLayer = tolua.cast(HakiDetailCellOwner["tipsLayer"], "CCLabelTTF")
                local function tips()
                    local fnt = "ccbResources/FZCuYuan-M03S.ttf"
                    local fntSize = 20
                    local width = 0
                    local temp
                    for i, v in ipairs(strs) do
                        if temp then
                            temp:removeFromParentAndCleanup(true)
                            temp = nil
                        end
                        local label = CCLabelTTF:create(v, fnt, fntSize)
                        width = math.max(label:getContentSize().width, width)
                    end
                    if temp then
                        temp:removeFromParentAndCleanup(true)
                        temp = nil
                    end
                    local padding = 5
                    local box = CCLayerColor:create(ccc4(0, 0, 0, 190), width + padding * 2, (fntSize + 2) * #strs + padding * 2)
                    for i, v in ipairs(strs) do
                        local label = CCLabelTTF:create(v, fnt, fntSize)
                        label:setAnchorPoint(ccp(0, 1))
                        label:setPosition(ccp(padding, box:getContentSize().height - (fntSize + 2) * (i - 1)))
                        box:addChild(label)
                    end
                    return box
                end
                if attrSp then
                    attrSp:stopAllActions()
                    attrSp:removeFromParentAndCleanup(true)
                    attrSp = nil
                end
                attrSp = tips()
                attrSp:setAnchorPoint(ccp(0.5, 1))
                attrSp:setPosition(ccp(x - attrSp:getContentSize().width / 2, y - ball:getContentSize().height))
                local tipsLayer = tolua.cast(HakiDetailCellOwner["tipsLayer"], "CCLabelTTF")
                tipsLayer:addChild(attrSp)
                local function remove()
                    attrSp:removeFromParentAndCleanup(true)
                    attrSp = nil
                end
                local array = CCArray:create()
                array:addObject(CCDelayTime:create(1.5))
                array:addObject(CCFadeOut:create(0.5))
                array:addObject(CCCallFunc:create(remove))
                attrSp:runAction(CCSequence:create(array))
            end
            item:registerScriptTapHandler(click)
        end
    end
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node = CCBReaderLoad("ccbResources/HakiDetailView.ccbi", proxy, true, "HakiDetailOwner")
    _layer = tolua.cast(node,"CCLayer")
    local sv = tolua.cast(HakiDetailOwner["sv"], "CCScrollView") 
    sv:setContentOffset(ccp(0, -420))
    _refreshData()
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(HakiDetailOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction(HakiDetailOwner, "infoBg", _layer)
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
    local sv = tolua.cast(HakiDetailOwner["sv"], "CCScrollView") 
    sv:setTouchPriority(_priority - 2)
    local menu = tolua.cast(HakiDetailOwner["menu"], "CCMenu")
    menu:setHandlerPriority(_priority - 1)
    local cellMenu = tolua.cast(HakiDetailCellOwner["menu"], "CCMenu")
    cellMenu:setHandlerPriority(_priority - 1)
end

-- 该方法名字每个文件不要重复
function getHaikiDetailLayer()
	return _layer
end

function createHakiDetailLayer(haki, index, priority)
    _haki = haki
    _index = index
    _priority = priority or -153
    _init()

    local function _onEnter()
        print("onEnter")
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.1), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)

        popUpUiAction(HakiDetailOwner, "infoBg")
    end

    local function _onExit()
        print("onExit")
        _layer = nil
        _haki = nil
        _index = nil
        _priority = -153
        attrSp = nil
    end

    --onEnter onExit
    local function _layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        end
    end

    _layer:registerScriptTouchHandler(onTouch, false, _priority, true)
    _layer:setTouchEnabled(true)
    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end