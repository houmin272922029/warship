local _aniLayer
local _parent
local _fragsCount = 3
local _bookId = nil
local _showResult
local _canQuit = false

convOwner = convOwner or {}
ccb["convOwner"] = convOwner

-- 结束，移除这一层
local function remove()
    if _aniLayer then
        _aniLayer:stopAllActions()
        _aniLayer:removeAllChildrenWithCleanup(true)
        _aniLayer:removeFromParentAndCleanup(true)
        -- 主界面的上下按钮移回来
        moveBackTopAndBottom()
    end
end

local  function popupTip()
    userdata:popUpGain(runtimeCache.responseData["gain"], true)
end

local function disappearAndPopup()
    -- 变黑消失
    local array = CCArray:create()
    array:addObject(CCFadeIn:create(0.25))
    array:addObject(CCCallFuncN:create(remove))
    array:addObject(CCDelayTime:create(0.25))
    array:addObject(CCCallFuncN:create(popupTip))
    convOwner["cover"]:setColor(ccc3(0,0,0))
    convOwner["cover"]:runAction(CCSequence:create(array))
end

local function _init()

    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/conv.ccbi",proxy, true,"convOwner")
    _aniLayer = tolua.cast(node,"CCLayer")
    _parent:addChild(_aniLayer, 10000)
end


local function onEnterLayer()

    if _fragsCount == 3 then
        convOwner["sprite6"]:setVisible(true)
        convOwner["sprite2"]:setVisible(true)
        convOwner["sprite4"]:setVisible(true)
        convOwner["rotatingCircle6"]:runAction(CCRepeatForever:create(CCRotateBy:create(1,90)))
        convOwner["rotatingCircle2"]:runAction(CCRepeatForever:create(CCRotateBy:create(1,90)))
        convOwner["rotatingCircle4"]:runAction(CCRepeatForever:create(CCRotateBy:create(1,90)))
        convOwner["frag6Frame"]:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("chapter_1.png"))
        convOwner["frag6"]:setVisible(true)
        convOwner["frag2Frame"]:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("chapter_2.png"))
        convOwner["frag2"]:setVisible(true)
        convOwner["frag4Frame"]:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("chapter_3.png"))
        convOwner["frag4"]:setVisible(true)
    elseif _fragsCount == 4 then
        convOwner["sprite1"]:setVisible(true)
        convOwner["sprite2"]:setVisible(true)
        convOwner["sprite4"]:setVisible(true)
        convOwner["sprite5"]:setVisible(true)
        convOwner["rotatingCircle1"]:runAction(CCRepeatForever:create(CCRotateBy:create(1,90)))
        convOwner["rotatingCircle2"]:runAction(CCRepeatForever:create(CCRotateBy:create(1,90)))
        convOwner["rotatingCircle4"]:runAction(CCRepeatForever:create(CCRotateBy:create(1,90)))
        convOwner["rotatingCircle5"]:runAction(CCRepeatForever:create(CCRotateBy:create(1,90)))
        convOwner["frag1Frame"]:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("chapter_1.png"))
        convOwner["frag1"]:setVisible(true)
        convOwner["frag2Frame"]:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("chapter_2.png"))
        convOwner["frag2"]:setVisible(true)
        convOwner["frag4Frame"]:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("chapter_3.png"))
        convOwner["frag4"]:setVisible(true)
        convOwner["frag5Frame"]:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("chapter_4.png"))
        convOwner["frag5"]:setVisible(true)
    elseif _fragsCount == 6 then
        for i=1, _fragsCount do
            local frag = "frag"..i
            local fragFrame = "frag"..i.."Frame"
            convOwner["sprite"..i]:setVisible(true)
            convOwner["rotatingCircle"..i]:runAction(CCRepeatForever:create(CCRotateBy:create(1,90)))
            convOwner[fragFrame]:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("chapter_"..i..".png"))
            convOwner[frag]:setVisible(true)
        end
    end
    convOwner["sprite7"]:setVisible(true)
    convOwner["rotatingCircle7"]:runAction(CCRepeatForever:create(CCRotateBy:create(1,90)))
end
convOwner["onEnterLayer"] = onEnterLayer


local function onExplosionStarts()
    for i=1,6 do
        local frag = "frag"..i
        local fragFrame = "frag"..i.."Frame"
        HLAddParticle( "ccbResources/conv/effect_prt_500.plist", convOwner[frag], ccp(convOwner[frag]:getContentSize().width/2, convOwner[frag]:getContentSize().height * 0.5), 2, 2, 2)
        convOwner[frag]:runAction(CCFadeOut:create(0.5))
        convOwner[fragFrame]:runAction(CCFadeOut:create(0.5))
    end
    HLAddParticle( "ccbResources/conv/eff_page_204_2.plist", _aniLayer, ccp(winSize.width/2, winSize.height * 0.36), 2, 2, 2)
    HLAddParticleScale( "ccbResources/conv/eff_page_205_2.plist", convOwner["bgLayer"], ccp(winSize.width/2, winSize.height * 0.36), 2, 2, -1,2.5,2.5)
end
convOwner["onExplosionStarts"] = onExplosionStarts


local function onFallDown()
    HLAddParticleScale( "ccbResources/conv/eff_page_206_2.plist", _aniLayer, ccp(winSize.width/2, winSize.height * 1.4), 1, 1, 1,1.5,1.5)
end
convOwner["onFallDown"] = onFallDown


local function onLastExplosion()
    convOwner["centerFrag"]:setVisible(true)
    HLAddParticleScale( "ccbResources/conv/eff_page_207_2.plist", _aniLayer, ccp(winSize.width/2, winSize.height * 0.36), 1, 2, 2,2,2)      
    HLAddParticleScale( "ccbResources/conv/eff_page_208_2.plist", _aniLayer, ccp(winSize.width/2, winSize.height * 0.36), 1, 2, 2,2,2)
end
convOwner["onLastExplosion"] = onLastExplosion


local function onTurnWhite()
    for i=1,12 do
        local itemKey = "sprite"..i
        local item = convOwner[itemKey]
        item:setVisible(false)
    end

    -- 按钮图像换成召唤到的任务形象
    local res = wareHouseData:getItemResource(_bookId).icon
    local icon = CCSprite:create(res)
    convOwner["resultFrame"]:setVisible(true)
    local conf = skilldata:getSkillConfig(_bookId)
    convOwner["resultIcon"]:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("frame_"..conf.rank..".png"))
    convOwner["resultIcon"]:addChild(icon)
    icon:setAnchorPoint(ccp(0.5,0.5))
    icon:setPosition(ccp(convOwner["resultIcon"]:getContentSize().width / 2,convOwner["resultIcon"]:getContentSize().height / 2))
    icon:setScale(0.35)
    -- 三个幻影
    for i=1,3 do
        local shadow = CCSprite:create(res)
        convOwner["resultIcon"]:addChild(shadow)
        shadow:setAnchorPoint(ccp(0.5,0.5))
        shadow:setPosition(ccp(convOwner["resultIcon"]:getContentSize().width / 2,convOwner["resultIcon"]:getContentSize().height * 0.5))
        shadow:setOpacity(100)
        shadow:setScale(2+i)
        shadow:runAction(CCScaleTo:create(0.5,1))
        shadow:runAction(CCFadeOut:create(0.5))
    end     
    HLAddParticleScale( "ccbResources/conv/eff_page_203_11.plist", _aniLayer, ccp(winSize.width/2, winSize.height * 0.85), 1,  2, 2,1,1)    
    HLAddParticleScale( "ccbResources/conv/eff_page_209_2.plist", _aniLayer, ccp(winSize.width/2, winSize.height * 0.4), 1, 2, -1,2,2)
end
convOwner["onTurnWhite"] = onTurnWhite


local function onShowingDone()
    print("onShowingDone ---------------")
    _canQuit = true
end
convOwner["onShowingDone"] = onShowingDone


local function onStartRotating()
    convOwner["rotatingColorCircle"]:runAction(CCRepeatForever:create(CCRotateBy:create(1,30)))
end
convOwner["onStartRotating"] = onStartRotating



local function onConvFinished()
    if not _showResult then
        remove()
    end
end
convOwner["onConvFinished"] = onConvFinished


local function onTouchBegan(x, y)
    return true
end

local function onTouchEnded(x, y)
    if _canQuit then
        disappearAndPopup()
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
function palyConvAnimationOnNode(bookId,fragsCount,showResult,node)
    _parent = node
    _showResult = showResult
    _bookId = bookId
    _fragsCount = fragsCount
    -- 主界面的上下菜单移走
    moveOutTopAndBottom()
    _canQuit = false
    
    _init()
    _aniLayer:registerScriptTouchHandler(onTouch ,false ,-133 ,true )
    _aniLayer:setTouchEnabled(true)
end

