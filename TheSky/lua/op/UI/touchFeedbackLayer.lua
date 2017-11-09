local _layer

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    _layer = CCLayer:create()
end

local function onTouchBegan(x, y)
    playEffect(MUSIC_SOUND_TOUCH)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))

    local function _removeSprite(sprite)
        if sprite then
            sprite:removeFromParentAndCleanup(true)
        end 
    end 

    local sprite = CCSprite:create("images/touchFB.png")
    sprite:setAnchorPoint(ccp(0.5, 0.5))
    sprite:setPosition(touchLocation)
    sprite:setScale(retina)
    sprite:runAction(CCSequence:createWithTwoActions(CCFadeOut:create(0.8), CCCallFuncN:create(_removeSprite)))
    _layer:addChild(sprite, 1)

    return false
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
function getTouchFeedbackLayer()
	return _layer
end

function createTouchFeedbackLayer()
    _init()

    local function _onEnter()
        print("onEnter")
    end

    local function _onExit()
        print("onExit")
        _layer = nil
    end

    --onEnter onExit
    local function _layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        end
    end


    _layer:registerScriptTouchHandler(onTouch ,false ,-999 ,true )
    _layer:setTouchEnabled(true)
    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end