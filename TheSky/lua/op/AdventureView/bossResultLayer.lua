local _layer
local _priority = -134
local count = 0

-- 名字不要重复
BossResultOwner = BossResultOwner or {}
ccb["BossResultOwner"] = BossResultOwner


local function closeItemClick()
    _layer:removeFromParentAndCleanup(true)
end
BossResultOwner["closeItemClick"] = closeItemClick


local function setMenuPriority()
    local menu = tolua.cast(BossResultOwner["menu"], "CCMenu")
    menu:setHandlerPriority(_priority - 1)
end

local function _updateTimer()
    count = (count + 1) % 4
    local tmp = ""
    for i=1,count do
        tmp = tmp.."."
    end
    local challenging = tolua.cast(BossResultOwner["challenging"], "CCLabelTTF") 
    challenging:setString(HLNSLocalizedString("boss.challenge")..tmp)
end

local function _refresh()
    CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("images/fightingNumber.plist")
    local damageLayer = tolua.cast(BossResultOwner["damageLayer"], "CCLayer")
    damageLayer:removeAllChildrenWithCleanup(true)
    local damage = BattleField.damage.left
    local strings = string.allCharsOfString(damage)
    local pics = {}
    local startPosX = 0
    for i,char in ipairs(strings) do
        local pic = CCSprite:createWithSpriteFrameName("hit_"..char..".png")
        damageLayer:addChild(pic)
        pic:setAnchorPoint(ccp(0,0.5))
        pic:setPosition(ccp(startPosX, damageLayer:getContentSize().height * 0.5))
        startPosX = startPosX + pic:getContentSize().width * 0.9
    end
    local gain = runtimeCache.responseData.gain
    local berryCount = tolua.cast(BossResultOwner["berryCount"], "CCLabelTTF")
    berryCount:setString(gain["silver"])
    local itemId = "item_006"
    local conf = wareHouseData:getItemResource(itemId)
    local itemName = tolua.cast(BossResultOwner["itemName"], "CCLabelTTF")
    itemName:setString(conf.name)
    local itemCount = tolua.cast(BossResultOwner["itemCount"], "CCLabelTTF")
    itemCount:setString(gain["items"][itemId])

    if gain["encounter"] then
        local function _popUpGain()
            local dic = {["encounter"] = gain["encounter"]}
            userdata:popUpGain(dic, true)
        end
        _layer:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.6), CCCallFunc:create(_popUpGain)))
    end

    local challenging = tolua.cast(BossResultOwner["challenging"], "CCLabelTTF")
    if getUDBool(UDefKey.Setting_BossAuto, false) then
        challenging:setVisible(true)
    else
        challenging:setVisible(false)
    end
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/BossResultView.ccbi", proxy, true,"BossResultOwner")
    _layer = tolua.cast(node,"CCLayer")
    _refresh()
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(BossResultOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        _layer:removeFromParentAndCleanup(true)
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

-- 该方法名字每个文件不要重复
function getBossResultLayer()
	return _layer
end

function createBossResultLayer(priority)
    _init()
    _priority = priority ~= nil and priority or -134

    function _layer:refresh()
        _refresh()
    end

    function _layer:close()
        closeItemClick()
    end

    local function _onEnter()
        print("onEnter")
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
        count = 0
        addObserver(NOTI_BOSS_CHALLENGE, _updateTimer)
    end

    local function _onExit()
        print("onExit")
        _layer = nil
        _priority = -134
        removeObserver(NOTI_BOSS_CHALLENGE, _updateTimer)
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