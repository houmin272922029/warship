local _layer
local index = 0

local function _init()
    _layer = CCLayer:create()

    local box = CCScale9Sprite:create("ccbResources/grayBg.png")
    local fnt = "ccbResources/FZCuYuan-M03S.ttf"
    local fntSize = HLFontSize(28)
    box:setContentSize(CCSizeMake(420 * retina,320 * retina))
    box:setAnchorPoint(ccp(0.5, 0.5))
    box:setPosition(ccp(winSize.width / 2,winSize.height / 2))
    _layer:addChild(box)

    -- 添加动画
    CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/LoadingAni.plist")

    local avatar = CCSprite:createWithSpriteFrameName("Chopper_1.png")
    avatar:setPosition(ccp(box:getContentSize().width / 2, 200 * retina))
    avatar:setScale(retina)

    local standFrame = CCArray:create()
    for i = 1, 8 do
        local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("Chopper_%d.png", i))
        if not frame then
            return 
        end
        standFrame:addObject(frame)
    end

    local standAnimation = CCAnimation:createWithSpriteFrames(standFrame, 0.1)
    local standAction = CCAnimate:create(standAnimation)
    local repeatStand = CCRepeatForever:create(standAction)
    avatar:runAction(repeatStand)
    box:addChild(avatar)

    local label3
    if isPlatform(IOS_INFIPLAY_RUS) or isPlatform(ANDROID_INFIPLAY_RUS) then
        label3 = CCLabelTTF:create("Загрузка...", fnt, HLFontSize(22))
    elseif isPlatform(IOS_MOBGAME_SPAIN) or isPlatform(ANDROID_MOBGAME_SPAIN) then
        label3 = CCLabelTTF:create("Cargando...", fnt, HLFontSize(22))
    else
        label3 = CCLabelTTF:create("Loading...", fnt, HLFontSize(22))
    end
    label3:setAnchorPoint(ccp(0, 0.5))
    label3:setPosition(ccp(box:getContentSize().width / 2 - label3:getContentSize().width / 2, 100 * retina))
    box:addChild(label3)
    
    -- local label1 = CCLabelTTF:create("Loading.", fnt, HLFontSize(37))
    -- label1:setAnchorPoint(ccp(0, 0.5))
    -- label1:setPosition(ccp(box:getContentSize().width / 2 - label3:getContentSize().width / 2, 75 * retina))
    -- box:addChild(label1)

    -- local label2 = CCLabelTTF:create("Loading..", fnt, HLFontSize(37))
    -- label2:setAnchorPoint(ccp(0, 0.5))
    -- label2:setPosition(ccp(box:getContentSize().width / 2 - label3:getContentSize().width / 2, 75 * retina))
    -- box:addChild(label2)

    

    -- local function setLabelString(  )
    --     label1:setVisible(false)
    --     label2:setVisible(false)
    --     label3:setVisible(false)
    --     if index == 0 then
    --         label1:setVisible(true)
    --         -- label:setString("Loading.")
    --     elseif index == 1 then
    --         label2:setVisible(true)
    --         -- label:setString("Loading..")
    --     elseif index == 2 then
    --         label3:setVisible(true)
    --         -- label:setString("Loading...")
    --     end
    --     index = (index + 1) % 3
    -- end
    -- local seq = CCSequence:createWithTwoActions(CCCallFunc:create(setLabelString), CCDelayTime:create(0.5))
    -- local labelRepect = CCRepeatForever:create(seq)
    -- _layer:runAction(labelRepect)

    local btmLabel = CCLabelTTF:create("", fnt, HLFontSize(20), CCSizeMake(box:getContentSize().width * 98 / 100, 90 * retina),kCCTextAlignmentCenter,kCCVerticalTextAlignmentCenter)
    btmLabel:setAnchorPoint(ccp(0.5, 0.5))
    btmLabel:setPosition(ccp(box:getContentSize().width / 2, 45 * retina))
    box:addChild(btmLabel)
    local function changeLoadingLabel(  )
        local str = getLoadingString(  )
        if str then
            btmLabel:setString(str)
        else
            btmLabel:setString("")
        end
    end
    changeLoadingLabel()
    -- local seq = CCSequence:createWithTwoActions(CCCallFunc:create(changeLoadingLabel), CCDelayTime:create(2))
    -- local labelRepect = CCRepeatForever:create(seq)
    -- _layer:runAction(labelRepect)
end

local function onTouchBegan(x, y)
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

function getLoadingLayer()
	return _layer
end

function createLoadingLayer( )
    _init()

    local function _onEnter()
        index = 0
    end

    local function _onExit()
        _layer = nil
        index = 0
    end

    --onEnter onExit
    local function _layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        end
    end


    _layer:registerScriptTouchHandler(onTouch ,false ,-100000 ,true )
    _layer:setTouchEnabled(true)
    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end