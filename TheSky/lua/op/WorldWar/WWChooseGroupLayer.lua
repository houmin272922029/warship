local _layer
local _current = 1
local _bAni = false
local _touchPos = {x = 0, y = 0}
local _badgePos = {}
local _recmd = 1


-- 名字不要重复
WWChooseGroupOwner = WWChooseGroupOwner or {}
ccb["WWChooseGroupOwner"] = WWChooseGroupOwner


local function menuEnable(sender)
    sender:setEnabled(true)
end

local function menuDisable(sender)
    sender:setEnabled(false) 
end

local function aniEnd()
    _bAni = false 
end

local function changeText()
    for i=0,1 do
        local groupName = tolua.cast(WWChooseGroupOwner["groupName"..i], "CCLabelTTF")
        groupName:setString(HLNSLocalizedString("ww.group.".._current))
    end
    local recmdBg = tolua.cast(WWChooseGroupOwner["recmdBg"], "CCSprite")
    local recmdLabel0 = tolua.cast(WWChooseGroupOwner["recmdLabel0"], "CCLabelTTF")
    local recmdLabel1 = tolua.cast(WWChooseGroupOwner["recmdLabel1"], "CCLabelTTF")
    recmdBg:setVisible(_current == _recmd)
    recmdLabel0:setVisible(_current == _recmd)
    recmdLabel1:setVisible(_current == _recmd)
end

local function joinCallback(url, rtnData)
    getMainLayer():gotoWorldWar()
end

local function chooseItemClick()
    doActionFun("WW_JOIN_GROUP", {string.format("camp_%02d", _current)}, joinCallback)
end
WWChooseGroupOwner["chooseItemClick"] = chooseItemClick

local function chooseGroup(index)
    if index == _current then
        return
    end
    _current = index
    _bAni = true
    local duration = 0.2
    -- index move pos.1, scale to 1, color to ccc3(255, 255, 255)
    local badge1 = tolua.cast(WWChooseGroupOwner["badge"..index], "CCSprite")
    if badge1 then
        local array = CCArray:create()
        array:addObject(CCMoveTo:create(duration, ccp(_badgePos[1].x, _badgePos[1].y)))
        array:addObject(CCScaleTo:create(duration, 1))
        array:addObject(CCTintTo:create(duration, 255, 255, 255))
        badge1:runAction(CCSpawn:create(array))
    end
    -- index+1 move pos.2, scale to 0.6, color to ccc3(138, 138, 138)
    local n = index % 3 + 1
    badge2 = tolua.cast(WWChooseGroupOwner["badge"..n], "CCSprite")
    if badge2 then
        local array = CCArray:create()
        array:addObject(CCMoveTo:create(duration, ccp(_badgePos[2].x, _badgePos[2].y)))
        array:addObject(CCScaleTo:create(duration, 0.6))
        array:addObject(CCTintTo:create(duration, 138, 138, 138))
        badge2:runAction(CCSpawn:create(array))
    end
    -- index-1 move pos.3, scale to 0.6, color to ccc3(138, 138, 138) 
    local l = index % 3 - 1
    l = l > 0 and l or l + 3 
    badge3 = tolua.cast(WWChooseGroupOwner["badge"..l], "CCSprite")
    if badge3 then
        local array = CCArray:create()
        array:addObject(CCMoveTo:create(duration, ccp(_badgePos[3].x, _badgePos[3].y)))
        array:addObject(CCScaleTo:create(duration, 0.6))
        array:addObject(CCTintTo:create(duration, 138, 138, 138))
        badge3:runAction(CCSpawn:create(array))
    end
    _layer:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(duration), 
        CCSpawn:createWithTwoActions(CCCallFunc:create(changeText), CCCallFunc:create(aniEnd))))
end

local function addChooseTouch()

    local function onTouchBegan(x, y)
        local chooseLayer = tolua.cast(WWChooseGroupOwner["chooseLayer"], "CCLayer")
        local touchLocation = chooseLayer:convertToNodeSpace(ccp(x, y))
        local rect = chooseLayer:boundingBox()
        rect = CCRectMake(0, 0, rect.size.width, rect.size.height)
        if rect:containsPoint(touchLocation) then
            _touchPos = {x = x, y = y}
            return true
        end
        return false
    end

    local function onTouchEnded(x, y)
        if math.abs(x - _touchPos.x) > 50 * retina then
            local index = _current % 3 + math.floor(x - _touchPos.x) / math.abs(math.floor(x - _touchPos.x))
            index = index > 0 and index or index + 3
            chooseGroup(index)
            return
        end
        local chooseLayer = tolua.cast(WWChooseGroupOwner["chooseLayer"], "CCLayer")
        for i=1,3 do
            local badge = tolua.cast(WWChooseGroupOwner["badge"..i], "CCSprite")
            local touchLocation = chooseLayer:convertToNodeSpace(ccp(x, y))
            local rect = badge:boundingBox()
            if rect:containsPoint(touchLocation) then
                chooseGroup(badge:getTag())
                break
            end
        end

    end

    local function onTouch(eventType, x, y)
        if eventType == "began" then   
            return onTouchBegan(x, y)
        elseif eventType == "moved" then
        elseif eventType == "ended" then
            return onTouchEnded(x, y)
        end
    end

    local chooseLayer = tolua.cast(WWChooseGroupOwner["chooseLayer"], "CCLayer")
    chooseLayer:registerScriptTouchHandler(onTouch)
    chooseLayer:setTouchEnabled(true)
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/WWChooseGroupView.ccbi", proxy, true,"WWChooseGroupOwner")
    _layer = tolua.cast(node,"CCLayer")
    local chooseLayer = tolua.cast(WWChooseGroupOwner["chooseLayer"], "CCLayer")
    for i=1,3 do
        local badge = tolua.cast(WWChooseGroupOwner["badge"..i], "CCSprite")
        table.insert(_badgePos, {x = badge:getPositionX(), y = badge:getPositionY()})
    end
    _current = 1
    -- addChooseTouch()
    _recmd = worldwardata:getRecommendGroup()
    chooseGroup(_recmd)
end

-- 该方法名字每个文件不要重复
function getWWChooseGroupLayer()
	return _layer
end



function createWWChooseGroupLayer()
    _init()

    local function _onEnter()
        _bAni = false
    end

    local function _onExit()
        _layer = nil
        _bAni = false
    end

    --onEnter onExit
    local function _layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        end
    end

    local function onTouchBegan(x, y)
        if _bAni then
            print("layer touch")
            return true
        end
        return false
    end

    local function onTouchEnded(x, y)
    end

    local function onTouch(eventType, x, y)
        if eventType == "began" then   
            return onTouchBegan(x, y)
        elseif eventType == "moved" then
        elseif eventType == "ended" then
        end
    end
    _layer:registerScriptTouchHandler(onTouch, false, -300, true)
    _layer:setTouchEnabled(true)
    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end