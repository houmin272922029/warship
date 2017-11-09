local _layer
local _priority = -132
local _type
local _func
local _choose
local _data
local _betGold = 20
local _betBerry = 50000
local BET_TYPE = {
    gold = "gold",
    silver = "silver",
}

-- 名字不要重复
QuizBetOwner = QuizBetOwner or {}
ccb["QuizBetOwner"] = QuizBetOwner

local function closeItemClick()
    popUpCloseAction(QuizBetOwner, "infoBg", _layer )
end
QuizBetOwner["closeItemClick"] = closeItemClick

local function _refreshData()
    local tips = tolua.cast(QuizBetOwner["tips"], "CCLabelTTF")
    tips:setString(HLNSLocalizedString("quiz.bet.tips.".._type))
    local balance = tolua.cast(QuizBetOwner["balance"], "CCLabelTTF")
    local total = tolua.cast(QuizBetOwner["total"], "CCLabelTTF")
    local bet = tolua.cast(QuizBetOwner["bet"], "CCLabelTTF")
    local gains = tolua.cast(QuizBetOwner["gains"], "CCLabelTTF")
    if _type == BET_TYPE.gold then
        for i=1,4 do
            local icon = tolua.cast(QuizBetOwner["icon"..i], "CCSprite")
            icon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("gold.png"))
        end
        balance:setString(userdata.gold)
        local totalGold = 0
        if _data.guessLogs and _data.guessLogs ~= "" and _data.guessLogs[_choose] and _data.guessLogs[_choose].gold then
            totalGold = _data.guessLogs[_choose].gold
        end
        total:setString(totalGold)
        bet:setString(_betGold)
        gains:setString(math.floor((_betGold + totalGold) * _data[_choose].odds))
    else
        for i=1,4 do
            local icon = tolua.cast(QuizBetOwner["icon"..i], "CCSprite")
            icon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("berry.png"))
        end
        balance:setString(userdata.berry)
        local totalBerry = 0
        if _data.guessLogs and _data.guessLogs ~= "" and _data.guessLogs[_choose] and _data.guessLogs[_choose].silver then
            totalBerry = _data.guessLogs[_choose].silver
        end
        total:setString(totalBerry)
        bet:setString(_betBerry)
        gains:setString(math.floor((_betBerry + totalBerry) * _data[_choose].odds))
    end
end

local function rreduceItemClick()
    if _type == BET_TYPE.gold then
        if _betGold == 20 then
            return
        end
        _betGold = math.max(20, _betGold - 200)
    else
        if _betBerry == 50000 then
            return
        end
        _betBerry = math.max(50000, _betBerry - 500000)
    end
    _refreshData()
end
QuizBetOwner["rreduceItemClick"] = rreduceItemClick

local function reduceItemClick()
    if _type == BET_TYPE.gold then
        if _betGold == 20 then
            return
        end
        _betGold = math.max(20, _betGold - 20)
    else
        if _betBerry == 50000 then
            return
        end
        _betBerry = math.max(50000, _betBerry - 50000)
    end
    _refreshData()
end
QuizBetOwner["reduceItemClick"] = reduceItemClick

local function menuAni()
    local function disable()
        local menu = tolua.cast(QuizBetOwner["menu"], "CCMenu")
        menu:setTouchEnabled(false)
    end 
    local function enable()
        local menu = tolua.cast(QuizBetOwner["menu"], "CCMenu")
        menu:setTouchEnabled(true)
    end
    local array = CCArray:create()
    array:addObject(CCCallFunc:create(disable))
    array:addObject(CCDelayTime:create(1))
    array:addObject(CCCallFunc:create(enable))
    _layer:runAction(CCSequence:create(array))
end

local function addItemClick()
    if _type == BET_TYPE.gold then
        if _betGold + 20 > userdata.gold then
            HLNSLocalizedString("ERR_1101")
            menuAni()
            getMainLayer():getParent():addChild(createShopRechargeLayer(_priority - 2), 210)
            return
        end
        _betGold = _betGold + 20
    else
        if _betBerry + 50000 > userdata.berry then
            HLNSLocalizedString("ERR_1102")
            return
        end
        _betBerry = _betBerry + 50000
    end
    _refreshData()
end
QuizBetOwner["addItemClick"] = addItemClick

local function aaddItemClick()
    if _type == BET_TYPE.gold then
        if _betGold + 200 > userdata.gold then
            ShowText(HLNSLocalizedString("ERR_1101"))
            menuAni()
            getMainLayer():getParent():addChild(createShopRechargeLayer(_priority - 2), 210)
            return
        end
        _betGold = _betGold + 200
    else
        if _betBerry + 500000 > userdata.berry then
            ShowText(HLNSLocalizedString("ERR_1102"))
            return
        end
        _betBerry = _betBerry + 500000
    end
    _refreshData()
end
QuizBetOwner["aaddItemClick"] = aaddItemClick

local function betItemClick()
    local price
    if _type == BET_TYPE.gold then
        if _betGold > userdata.gold then
            ShowText(HLNSLocalizedString("ERR_1101"))
            menuAni()
            getMainLayer():getParent():addChild(createShopRechargeLayer(_priority - 2), 210)
            return
        end
        price = _betGold
    else
        if _betBerry > userdata.berry then
            ShowText(HLNSLocalizedString("ERR_1102"))
            return
        end
        price = _betBerry
    end
    _func(price, _type, _choose)
    closeItemClick()
end
QuizBetOwner["betItemClick"] = betItemClick


-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/QuizBetView.ccbi", proxy, true,"QuizBetOwner")
    _layer = tolua.cast(node,"CCLayer")
    _betGold = 20
    _betBerry = 50000
    _refreshData()
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(QuizBetOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction(QuizBetOwner, "infoBg", _layer)
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
    local menu = tolua.cast(QuizBetOwner["menu"], "CCMenu")
    menu:setTouchPriority(_priority - 2)
end

function getQuizBetLayer()
	return _layer
end

function createQuizBetLayer(data, bType, func, choose, priority)
    _data = data
    _type = bType
    _func = func
    _choose = choose
    _priority = (priority ~= nil) and priority or -132
    _init()

    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)

        popUpUiAction(QuizBetOwner, "infoBg")
    end

    local function _onExit()
        _layer = nil
        _priority = nil
        _data = nil
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