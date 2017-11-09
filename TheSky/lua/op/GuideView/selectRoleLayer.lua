local _layer
local _current
local _heroIds = {}
local _roleSprites = {}
local _heroDesps = {}
local _heroNames = {}
-- renzhan
local btnPositionXs = {}
local btnPositionYs = {}

local KTAG_ATTR = 987

local KTAG_BLACKLAYER = 997

local buttonLayer
-- 

local HERO_ATTACK_FRAMECOUNT = {
    hero_000338 = 33,
    hero_000304 = 30,
    hero_000303 = 32,
}

local HERO_STAND_FRAMECOUNT = {
    hero_000338 = 4,
    hero_000304 = 4,
    hero_000303 = 4,
}

-- ·名字不要重复
SelectRoleOwner = SelectRoleOwner or {}
ccb["SelectRoleOwner"] = SelectRoleOwner

local function _getActionAnimation(resId,action,frameCount)
    local animFrames = CCArray:create()
    for j = 1, frameCount do
        local frameName = string.format("sel_%s_%s_%04d.png", resId, action, j)
        
        local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(frameName)
        animFrames:addObject(frame)
    end
    local animation = CCAnimation:createWithSpriteFrames(animFrames, 0.1)
    return animation
end


local function _selectRole(tag)
    if _current == tag then
        return
    end

    playMusic("audio/sound"..(153-tag)..".mp3",false)

    -- renzhan
    for i=1,3 do
        SelectRoleOwner["roleBtn"..i]:getChildByTag(KTAG_BLACKLAYER):setVisible(false)
        -- 禁用按钮
        SelectRoleOwner["roleBtn"..i]:setEnabled(false)
    end

    -- 缩小
    local item = SelectRoleOwner["roleBtn".._current]
    local despText = _heroDesps[_current]
    local nameLabel = _heroNames[_current]
    if item then
        item:setZOrder(1)
        item:runAction(CCScaleTo:create(0.3, retina))
        item:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("role_btn_%d_0.png", _current)))

        local Attr = item:getChildByTag(KTAG_ATTR)
        Attr:setVisible(false)
        despText:setVisible(true)
    end
    if despText then
        despText:runAction(CCMoveBy:create(0.3, ccp(0, 50)))
    end
    if nameLabel then
        nameLabel:runAction(CCMoveBy:create(0.3, ccp(0, -50)))
    end

    local roleSprite = _roleSprites[_current]
    if roleSprite then
        roleSprite:stopAllActions()
        local animation = _getActionAnimation(_heroIds[_current], "stand", HERO_STAND_FRAMECOUNT[_heroIds[_current]])
        roleSprite:runAction(CCRepeatForever:create(CCAnimate:create(animation)))
    end

    --  放大
    _current = tag
    item = SelectRoleOwner["roleBtn".._current]
    despText =  _heroDesps[_current]
    nameLabel = _heroNames[_current]
    if item then
        item:setZOrder(3)
        -- item:setScale(1.5 * retina)
        item:runAction(CCScaleTo:create(0.3, 1.32 * retina))
        item:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("role_btn_%d_1.png", _current)))

        local Attr = item:getChildByTag(KTAG_ATTR)
        Attr:setVisible(true)
        despText:setVisible(false)

    end
    if despText then
        despText:runAction(CCMoveBy:create(0.3, ccp(0, -50)))
    end
    if nameLabel then
        nameLabel:runAction(CCMoveBy:create(0.3, ccp(0, 50)))
    end

    roleSprite = _roleSprites[_current]
    if roleSprite then
        roleSprite:stopAllActions()
        local array = CCArray:create()
        local animation1 = _getActionAnimation(_heroIds[_current], "stand", HERO_STAND_FRAMECOUNT[_heroIds[_current]])
        array:addObject(CCAnimate:create(animation1))
        local animation2 = _getActionAnimation(_heroIds[_current], "stand", HERO_STAND_FRAMECOUNT[_heroIds[_current]])
        array:addObject(CCAnimate:create(animation2))  
        local animation3 = _getActionAnimation(_heroIds[_current], "attack", HERO_ATTACK_FRAMECOUNT[_heroIds[_current]])
        array:addObject(CCAnimate:create(animation3))
        roleSprite:runAction(CCRepeatForever:create(CCSequence:create(array)))
    end

    item:runAction(CCMoveTo:create(0.3,ccp(btnPositionXs[2] , btnPositionYs[2])))

    local next1 = (_current + 1) <= 3 and (_current + 1) or _current + 1 - 3
    local next2 = (_current + 2) <= 3 and (_current + 2) or _current + 2 - 3
    SelectRoleOwner["roleBtn"..next1]:runAction(CCMoveTo:create(0.3, ccp(btnPositionXs[3], btnPositionYs[3])))
    SelectRoleOwner["roleBtn"..next2]:runAction(CCMoveTo:create(0.3, ccp(btnPositionXs[1], btnPositionYs[1])))


    local function blackLayerShow( )
        for i=1,3 do
            if i ~= _current then

                SelectRoleOwner["roleBtn"..i]:getChildByTag(KTAG_BLACKLAYER):setVisible(true)
                -- 解除禁用
                SelectRoleOwner["roleBtn"..i]:setEnabled(true)
                SelectRoleOwner["roleBtn"..i]:setEnabled(true)
            end
        end
    end 

    local blackArray = CCArray:create()
    blackArray:addObject(CCDelayTime:create(0.3))
    blackArray:addObject(CCCallFunc:create(blackLayerShow))
    _layer:runAction(CCSequence:create(blackArray))

end

local function roleClick(tag)
    _selectRole(tag)
end
SelectRoleOwner["roleClick"] = roleClick

local function confirmClick()
    local heroId = _heroIds[_current]
    if heroId then
        _layer:getParent():addChild(createCreateNameLayer(heroId, -135)) 
    end
end
SelectRoleOwner["confirmClick"] = confirmClick

local function _addRoleAnimations()
    for i=1,3 do
        -- local aniRes = string.format("%s_stand_0001.png",_heroIds[i])
         local aniRes = string.format("sel_%s_stand_0001.png", _heroIds[i])
        local roleSprite = CCSprite:createWithSpriteFrameName(aniRes)
        local animation = _getActionAnimation(_heroIds[i], "stand", HERO_STAND_FRAMECOUNT[_heroIds[i]])
        local item = SelectRoleOwner["roleBtn"..i]
        item:addChild(roleSprite,4)
        roleSprite:setScaleX(-1.2)
        roleSprite:setScaleY(1.2)
        roleSprite:setPosition(ccp(item:getContentSize().width * 0.5, item:getContentSize().height * 0.5))
        roleSprite:runAction(CCRepeatForever:create(CCAnimate:create(animation)))
        if i == 1 then
            roleSprite:setFlipX(true)
        end
        table.insert(_roleSprites, roleSprite)
    end
end

local function _addRoleInfos()
    for i=1,3 do
        local item = SelectRoleOwner["roleBtn"..i]
        local despRes = _heroDesps[i]
        local despSprite = CCSprite:createWithSpriteFrameName(despRes)
        item:addChild(despSprite, 5)
        despSprite:setPosition(ccp(item:getContentSize().width * 0.5,item:getContentSize().height * 0.75))
        _heroDesps[i] = despSprite

        local nameRes = _heroNames[i]
        local nameSprite = CCSprite:createWithSpriteFrameName(nameRes)
        item:addChild(nameSprite, 5)
        nameSprite:setPosition(ccp(item:getContentSize().width * 0.5,item:getContentSize().height * 0.23))
        _heroNames[i] = nameSprite
    end
end


-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/selectRole.plist")
    CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/selectRoleRobin.plist")
    CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/selectRoleSanji.plist")
    CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/selectRoleZoro.plist")
    CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("fontPic.plist")
    _scene = CCScene:create()
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/SelectRoleView.ccbi", proxy, true,"SelectRoleOwner")
    
    _layer = tolua.cast(node, "CCLayer")
    _scene:addChild(_layer)
    _addRoleAnimations()
    _addRoleInfos()
    SelectRoleOwner["confirmItem"]:setZOrder(10)

    for i = 1,3 do
        btnPositionXs[i] = SelectRoleOwner["roleBtn"..i]:getPositionX()
        btnPositionYs[i] = SelectRoleOwner["roleBtn"..i]:getPositionY()

        local heroConfig = herodata:getHeroConfig(_heroIds[i])
        local hp = heroConfig.attr.hp
        local atk = heroConfig.attr.atk
        local def = heroConfig.attr.def
        local mp = heroConfig.attr.mp

        local hpFrame = CCSprite:createWithSpriteFrameName("attr_bg.png")
        SelectRoleOwner["roleBtn"..i]:addChild(hpFrame, 4, KTAG_ATTR)

        local aniRes = string.format("sel_%s_stand_0001.png", _heroIds[i])

        local roleSprite = CCSprite:createWithSpriteFrameName(aniRes)
        hpFrame:setPosition(ccp(SelectRoleOwner["roleBtn"..i]:getContentSize().width * 0.5, 
            SelectRoleOwner["roleBtn"..i]:getContentSize().height * 0.71))

        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/publicRes.plist")
        local hpIcon = CCSprite:createWithSpriteFrameName("hp_icon.png")
        hpFrame:addChild(hpIcon)
        hpIcon:setPosition(ccp(30,hpFrame:getContentSize().height / 4 * 3))
        local hpLabel = CCLabelTTF:create(hp, "ccbResources/FZCuYuan-M03S.ttf", 25)
        hpFrame:addChild(hpLabel)
        hpLabel:setAnchorPoint(ccp(0,0.5))
        hpLabel:setPosition(ccp(48,hpFrame:getContentSize().height / 4 * 3))

        local atkIcon = CCSprite:createWithSpriteFrameName("atk_icon.png")
        hpFrame:addChild(atkIcon)
        atkIcon:setPosition(ccp(115,hpFrame:getContentSize().height / 4 * 3))
        local atkLabel = CCLabelTTF:create(atk, "ccbResources/FZCuYuan-M03S.ttf", 25)
        hpFrame:addChild(atkLabel)
        atkLabel:setAnchorPoint(ccp(0,0.5))
        atkLabel:setPosition(ccp(133,hpFrame:getContentSize().height / 4 * 3))

        local defIcon = CCSprite:createWithSpriteFrameName("def_icon.png")
        hpFrame:addChild(defIcon)
        defIcon:setPosition(ccp(30,hpFrame:getContentSize().height / 4))
        local defLabel = CCLabelTTF:create(def, "ccbResources/FZCuYuan-M03S.ttf", 25)
        hpFrame:addChild(defLabel)
        defLabel:setAnchorPoint(ccp(0,0.5))
        defLabel:setPosition(ccp(48,hpFrame:getContentSize().height / 4))

        local mpIcon = CCSprite:createWithSpriteFrameName("int_icon.png")
        hpFrame:addChild(mpIcon)
        mpIcon:setPosition(ccp(115,hpFrame:getContentSize().height / 4))
        local mpLabel = CCLabelTTF:create(mp, "ccbResources/FZCuYuan-M03S.ttf", 25)
        hpFrame:addChild(mpLabel)
        mpLabel:setAnchorPoint(ccp(0,0.5))
        mpLabel:setPosition(ccp(133,hpFrame:getContentSize().height / 4))
        hpFrame:setVisible(false)
        hpFrame:setScale(0.8)
        hpFrame:setOpacity(150)
    end

    -- 添加灰色遮罩
    for i=1,3 do
        local blackLayerBg = CCLayerColor:create(ccc4(0, 0, 0, 150),SelectRoleOwner["roleBtn"..i]:getContentSize().width,SelectRoleOwner["roleBtn"..i]:getContentSize().height)

        SelectRoleOwner["roleBtn"..i]:addChild(blackLayerBg, 6, KTAG_BLACKLAYER)
        blackLayerBg:setVisible(false)
    end
-- 
end


-- 该方法名字每个文件不要重复
function getSelectRoleLayer()
	return _layer
end

function createSelectRoleLayer()
    _heroIds[1] = "hero_000338"
    _heroIds[2] = "hero_000303"
    _heroIds[3] = "hero_000304"

    _heroDesps[1] = "robin_desp_text.png"
    _heroDesps[2] = "sanji_desp_text.png"
    _heroDesps[3] = "zoro_desp_text.png"
    _heroNames[1] = "robin_text.png"
    _heroNames[2] = "sanji_text.png"
    _heroNames[3] = "zoro_text.png"

    _init()
    _current = 0
    -- _selectRole(1)

    local function _onEnter()
    end

    local function _onExit()
        print("onExit")
        for i,v in ipairs(_roleSprites) do
            v:stopAllActions()
            v:removeFromParentAndCleanup(true)
            v = nil
        end
        _roleSprites = {}
        _heroIds = {}
        _heroDesps = {}
        _heroNames = {}
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
    _layer:registerScriptHandler(_layerEventHandler)
    
    return _scene
end