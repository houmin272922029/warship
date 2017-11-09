local _layer
local _scene
local myschedu
local _dt = 0

-- ·名字不要重复
OPOwner = OPOwner or {}
ccb["OPOwner"] = OPOwner

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    _scene = CCScene:create()
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/OPView.ccbi",proxy, true,"OPOwner")
    _layer = tolua.cast(node,"CCLayer")
    _scene:addChild(_layer)
end

local function _refreshLayer(visible)
    local layer = tolua.cast(OPOwner["layer_"..runtimeCache.opAniStep], "CCLayer")
    layer:setVisible(visible)
    if visible then
        if runtimeCache.opAniStep == 1 then
            playMusic(MUSIC_SOUND_OPANI_1,true)
        elseif runtimeCache.opAniStep == 8 then
            playMusic(MUSIC_SOUND_OPANI_2,true)
        elseif runtimeCache.opAniStep == 11 then
            playMusic(MUSIC_SOUND_OPANI_3,true)
        end 
    end
end

local function onTouchBegan(x, y)
    return true
end

local function nextLayer()
    if runtimeCache.opAniStep < 16 then
        _refreshLayer(false)
        runtimeCache.opAniStep = runtimeCache.opAniStep + 1
        if runtimeCache.opAniStep == 11 then
            if myschedu then
                CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(myschedu)
                myschedu = nil
            end
            _layer:setTouchEnabled(false)
            -- 进演示战斗
            BattleField:OPAniFight()
            CCDirector:sharedDirector():replaceScene(CCTransitionFade:create(0.6, FightingScene()))
            return
        end
        if runtimeCache.opAniStep == 16 then
            -- 选船员
            _layer:setTouchEnabled(false)
            _scene:addChild(createSelectRoleLayer(), 100)
            if myschedu then
                CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(myschedu)
                myschedu = nil
            end
            return
        end
        _refreshLayer(true)
    end
end

local function onTouchEnded(x, y)
    _dt = 0
    nextLayer()
end

local function updateTime(dt)
    _dt = _dt + 1
    if _dt > 4 then
        _dt = 0
        nextLayer()
    end
end

local function onTouch(eventType, x, y)
    if eventType == "began" then   
        return onTouchBegan(x, y)
    elseif eventType == "moved" then
    else
        return onTouchEnded(x, y)
    end
end

local function _addTouchFBLayer()
    -- 添加点击反馈层
    local scene = CCDirector:sharedDirector():getRunningScene()
    if scene then
        scene:addChild(createTouchFeedbackLayer(), 9998, 9998)
    end 
end

-- 该方法名字每个文件不要重复
function getOPLayer()
	return _layer
end

function OPSceneFun()
    _init()

    local function _onEnter()

        local seq2 = CCSequence:createWithTwoActions(CCDelayTime:create(1), CCCallFunc:create(_addTouchFBLayer))
        _layer:runAction(seq2)
        myschedu = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(updateTime, 1, false)
        if runtimeCache.opAniStep < 16 then
            _refreshLayer(true)
        elseif runtimeCache.opAniStep == 16 then
            _layer:setTouchEnabled(false)
            _scene:addChild(createSelectRoleLayer(), 100)
            if myschedu then
                CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(myschedu)
                myschedu = nil
            end
        end
    end

    local function _onExit()
        print("onExit")
        _layer = nil
        _scene = nil
        _dt = 0
        if myschedu then
            CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(myschedu)
            myschedu = nil
        end
    end

    --onEnter onExit
    local function _layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        end
    end


    _layer:registerScriptTouchHandler(onTouch ,false , 0 ,true )
    _layer:setTouchEnabled(true)
    _scene:registerScriptHandler(_layerEventHandler)

    return _scene
end