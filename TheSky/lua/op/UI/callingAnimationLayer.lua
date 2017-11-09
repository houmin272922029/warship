local _aniLayer
local _parent
local _heroId
local _heroRank
local _bTransfered = false
local _firstShow

local _giftSouls = {}
local _resultSoul = {}
local _sendSoulsCount = 0
local _targetIndex = 1
local _rollSprite = nil
local _startshine = nil
local _currentIndex = 0
local _starshineIndex = 0
local _canQuit = false
local _bTenCalls = false

topAndBottomNormalPosition = true

callingRoleOwner = callingRoleOwner or {}

function moveOutTopAndBottom()
    -- 主界面的上下菜单移走
    MainSceneOwner["titleBg"]:runAction(CCMoveBy:create(0.5,ccp(0,150 * retina)))
    MainSceneOwner["broadcastBg"]:runAction(CCMoveBy:create(0.5,ccp(0,150 * retina)))
    MainSceneOwner["bottomBg"]:runAction(CCMoveBy:create(0.5,ccp(0,-150 * retina)))
    MainSceneOwner["menu"]:runAction(CCMoveBy:create(0.5,ccp(0,-150 * retina)))
    getButtonsView():runAction(CCMoveBy:create(0.5,ccp(0,-150 * retina)))
    topAndBottomNormalPosition = false
end

local function setTextColor()
    local blend1 = ccBlendFunc:new()
    blend1.src = GL_ONE
    blend1.dst = GL_ONE
    local owner = callingRoleOwner
    for i=1,5 do
        local textureG = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("call_".._heroRank.."_"..i..".png")
        owner["callText_"..i]:setDisplayFrame(textureG)
        owner["callTextAdd_"..i]:setDisplayFrame(textureG)
        owner["callTextAdd_"..i]:setBlendFunc(blend1)
    end
end

local function setGateColor()
    local blend1 = ccBlendFunc:new()
    blend1.src = GL_ONE_MINUS_DST_ALPHA
    blend1.dst = GL_ONE
    local texture = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("gate_".._heroRank..".png")
    local texture1 = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("openGate_".._heroRank..".png")
    local owner = callingRoleOwner
    for i=1,3 do
        owner["gate"..i]:setDisplayFrame(texture)
        owner["gateReflection"..i]:setDisplayFrame(texture)
        owner["gateReflection"..i]:setBlendFunc(blend1)
    end
    owner["openGate"]:setDisplayFrame(texture1)
    owner["gateBtn"]:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("gate_".._heroRank..".png"))
end

local function setCircleColor()
    local owner = callingRoleOwner
    local texture2 = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("outlineRing_".._heroRank..".png")
    local texture3 = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("bgCircle_".._heroRank..".png")
    owner["scaleHaloRing"]:setDisplayFrame(texture2)
    owner["bgCircle"]:setDisplayFrame(texture3)
end

-- private方法如果没有上下调用关系可以写在外面
local function _init()
    ccb["callingRoleOwner"] = callingRoleOwner
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/GET!!.ccbi",proxy, true,"callingRoleOwner")
    _aniLayer = tolua.cast(node,"CCLayer")
    setTextColor()
    setGateColor()
    setCircleColor()
    _parent:addChild(_aniLayer)
end

function getCallingAnimationLayer()
    return _aniLayer
end

-- 点击门时
local function gateBtnPressed()
    palyCallingAnimationOfHeroOnNode2(_heroId,_bTransfered,_heroRank,_giftSouls,_resultSoul,_sendSoulsCount,_parent,_bTenCalls)
    _aniLayer:removeFromParentAndCleanup(true)
end
callingRoleOwner["gateBtnPressed"] = gateBtnPressed 


-- 开始时，门按钮是不可以点击的，手型出现以后设为可用状态，并设置优先级高于本层
local function onHandShows()
    callingRoleOwner["gateBtn"]:setEnabled(true)
    callingRoleOwner["gateMenu"]:setHandlerPriority(-133)
end
callingRoleOwner["onHandShows"] = onHandShows

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

local function getTargetIndex()
    local index = 0
    for k,v in pairs(_giftSouls) do
        if v.getFlag and v.getFlag == 1 then
            index = k - 1
            break
        end
    end
    return index
end



function palyCallingAnimationOfHeroOnNode(heroId,bTransfered,heroRank,giftSouls,sendSoul,sendSoulsCount,node,bTenCalls)
    _heroId = heroId
    _bTransfered = bTransfered
    _sendSoulsCount = sendSoulsCount
    _parent = node
    _heroRank = heroRank
    _firstShow = true
    _canQuit = false
    _bTenCalls = bTenCalls

    -- 有送的魂
    if giftSouls then
        _giftSouls = giftSouls
        _targetIndex = getTargetIndex()
        _resultSoul = sendSoul
        _currentIndex = 5
        _starshineIndex = 4
    else
        _giftSouls = nil
        _resultSoul = nil
        _targetIndex = 0
        _currentIndex = 5
        _starshineIndex = 4        
    end

    -- 召唤层移走，使得按钮不可点击
    moveOutTopAndBottom()
    
    _init()
    _aniLayer:registerScriptTouchHandler(onTouch ,false ,-132 ,true )
    _aniLayer:setTouchEnabled(true)

end


