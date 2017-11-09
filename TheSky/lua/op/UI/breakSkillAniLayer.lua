local _aniLayer
local _parent
local _materials = {}
local _skillDic = {}
local _canQuit = false
local _breakSucc = true

breakSkillAniOwner = breakSkillAniOwner or {}
ccb["breakSkillAniOwner"] = breakSkillAniOwner

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

local function disappear()
    -- 变黑消失
    local array = CCArray:create()
    array:addObject(CCFadeIn:create(0.25))
    array:addObject(CCCallFuncN:create(remove))
    breakSkillAniOwner["cover"]:setColor(ccc3(0,0,0))
    breakSkillAniOwner["cover"]:runAction(CCSequence:create(array))
end

local function _init()

    local proxy = CCBProxy:create()
    local node
    local m = breakSkillAniOwner["mAnimationManager"]
    if _breakSucc then
        node = CCBReaderLoad("ccbResources/breakSkill.ccbi",proxy, true,"breakSkillAniOwner")
        -- ShowText("奥义突破成功")
    else
        node = CCBReaderLoad("ccbResources/breakSkillFail.ccbi",proxy, true,"breakSkillAniOwner")
        -- ShowText("奥义突破失败")
    end
    _aniLayer = tolua.cast(node,"CCLayer")
    _parent:addChild(_aniLayer)
end


local function onEnterLayer()
    for i=1,5 do
        breakSkillAniOwner["rotatingCircle"..i]:runAction(CCRepeatForever:create(CCRotateBy:create(1,90)))
        local stageIcon = breakSkillAniOwner["stageIcon"..i]
        local avatarIcon = breakSkillAniOwner["avatar"..i]
        if  i <= getMyTableCount(_materials) then
            stageIcon:setVisible(true)
            local j = 1
            for key,value in pairs(_materials) do
                if i == j then
                    stageIcon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%s.png", value.skillConf.rank)))
                    if avatarIcon then
                        local texture = CCTextureCache:sharedTextureCache():addImage(equipdata:getEquipIconByEquipId( value.skillId ))
                        if texture then
                            avatarIcon:setTexture(texture)
                        end
                    end
                    break
                end
                j = j + 1
            end
        end
    end

    local stageIcon = breakSkillAniOwner["topFrame"]
    local avatarIcon = breakSkillAniOwner["topAvatar"]
    local resultFrame = breakSkillAniOwner["resultFrame"]
    stageIcon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%s.png", _skillDic.skillConf.rank)))
    resultFrame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%s.png", _skillDic.skillConf.rank)))
    if avatarIcon then
        local texture = CCTextureCache:sharedTextureCache():addImage(equipdata:getEquipIconByEquipId( _skillDic.skillId ))
        if texture then
            avatarIcon:setTexture(texture)
        end
    end

    breakSkillAniOwner["rotatingCircle6"]:runAction(CCRepeatForever:create(CCRotateBy:create(1,90)))
end
breakSkillAniOwner["onEnterLayer0"] = onEnterLayer
breakSkillAniOwner["onEnterLayer1"] = onEnterLayer


local function onExplosionStarts()
    for i=1,getMyTableCount(_materials) do
        local stageIcon = "stageIcon"..i
        local avatarIcon = "avatar"..i
        HLAddParticleScale( "ccbResources/conv/effect_prt_500.plist", breakSkillAniOwner[stageIcon], ccp(breakSkillAniOwner[stageIcon]:getContentSize().width/2, breakSkillAniOwner[stageIcon]:getContentSize().height * 0.5), 2, 2, 2,1/retina,1/retina)
        breakSkillAniOwner[stageIcon]:runAction(CCFadeOut:create(0.5))
        breakSkillAniOwner[avatarIcon]:runAction(CCFadeOut:create(0.5))
    end
    HLAddParticle( "ccbResources/conv/eff_page_204_2.plist", _aniLayer, ccp(winSize.width/2, winSize.height * 0.36), 2, 2, 2)
    HLAddParticleScale( "ccbResources/conv/eff_page_210_2.plist", breakSkillAniOwner["bgLayer"], ccp(winSize.width/2, winSize.height * 0.36), 2, 2, -1,2.5,2.5)
end
breakSkillAniOwner["onExplosionStarts0"] = onExplosionStarts
breakSkillAniOwner["onExplosionStarts1"] = onExplosionStarts


local function onFallDown()
    local array = CCArray:create()
    array:addObject(CCDelayTime:create(0.55))
    local function showResultIcon()
        breakSkillAniOwner["centerStageIcon"]:setVisible(true)
    end
    array:addObject(CCCallFunc:create(showResultIcon))
    breakSkillAniOwner["centerStageIcon"]:runAction(CCSequence:create(array))

    HLAddParticleScale( "ccbResources/conv/eff_page_206_2.plist", _aniLayer, ccp(winSize.width/2, winSize.height * 1.4), 1, 1, 1,1.5,1.5)
end
breakSkillAniOwner["onFallDown"] = onFallDown


local function onLastExplosion()
    HLAddParticleScale( "ccbResources/conv/eff_page_207_2.plist", _aniLayer, ccp(winSize.width/2, winSize.height * 0.36), 1, 2, 2,2,2)      
    HLAddParticleScale( "ccbResources/conv/eff_page_208_2.plist", _aniLayer, ccp(winSize.width/2, winSize.height * 0.36), 1, 2, 2,2,2)
end
breakSkillAniOwner["onLastExplosion"] = onLastExplosion


local function onTurnWhite1()
    for i=1,11 do
        local itemKey = "sprite"..i
        local item = breakSkillAniOwner[itemKey]
        item:setVisible(false)
    end

    -- 按钮图像换成召唤到的任务形象
    local res = equipdata:getEquipIconByEquipId( _skillDic.skillId )
    local texture = CCTextureCache:sharedTextureCache():addImage(equipdata:getEquipIconByEquipId( _skillDic.skillId ))
    if texture then
        breakSkillAniOwner["resultIcon"]:setTexture(texture)
    end
    breakSkillAniOwner["resultStageIcon"]:setVisible(true)
    breakSkillAniOwner["rotatingColorCircle"]:runAction(CCRepeatForever:create(CCRotateBy:create(1,30)))
    -- 三个幻影
    for i=1,3 do
        local shadow = CCSprite:create(res)
        breakSkillAniOwner["resultIcon"]:addChild(shadow)
        shadow:setAnchorPoint(ccp(0.5,0.5))
        shadow:setPosition(ccp(breakSkillAniOwner["resultIcon"]:getContentSize().width / 2,breakSkillAniOwner["resultIcon"]:getContentSize().height * 0.5))
        shadow:setOpacity(100)
        shadow:setScale(2+i)
        shadow:runAction(CCScaleTo:create(0.5,1))
        shadow:runAction(CCFadeOut:create(0.5))
    end     
    HLAddParticleScale( "ccbResources/conv/eff_page_203_11.plist", _aniLayer, ccp(winSize.width/2, winSize.height * 0.85), 1,  2, 2,1,1)    
    HLAddParticleScale( "ccbResources/conv/eff_page_209_2.plist", _aniLayer, ccp(winSize.width/2, winSize.height * 0.4), 1, 2, -1,2,2)
end
breakSkillAniOwner["onTurnWhite1"] = onTurnWhite1

local function onTurnWhite0()
    for i=1,11 do
        local itemKey = "sprite"..i
        local item = breakSkillAniOwner[itemKey]
        item:setVisible(false)
    end
    breakSkillAniOwner["rotatingColorCircle"]:runAction(CCRepeatForever:create(CCRotateBy:create(1,30)))
    breakSkillAniOwner["resultStageIcon"]:setVisible(false)
    HLAddParticleScale( "ccbResources/conv/eff_page_203_11.plist", _aniLayer, ccp(winSize.width/2, winSize.height * 0.85), 1,  2, 2,1,1)    
    HLAddParticleScale( "ccbResources/conv/eff_page_209_2.plist", _aniLayer, ccp(winSize.width/2, winSize.height * 0.4), 1, 2, -1,2,2)
end
breakSkillAniOwner["onTurnWhite0"] = onTurnWhite0


local function onShowingDone()
    _canQuit = true
end
breakSkillAniOwner["onShowingDone0"] = onShowingDone
breakSkillAniOwner["onShowingDone1"] = onShowingDone


local function onStartRotating()
    breakSkillAniOwner["rotatingColorCircle"]:runAction(CCRepeatForever:create(CCRotateBy:create(1,30)))
end
breakSkillAniOwner["onStartRotating0"] = onStartRotating
breakSkillAniOwner["onStartRotating1"] = onStartRotating


local function onTouchBegan(x, y)
    return true
end

local function onTouchEnded(x, y)
    if _canQuit then
        disappear()
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
function palyBreakAnimationOnNode(skillDic,materials,breakSucc,node)
    _parent = node
    _skillDic = skillDic
    _materials = materials
    -- 主界面的上下菜单移走
    moveOutTopAndBottom()
    _canQuit = false
    if breakSucc == "0" then
        _breakSucc = false
    else
        _breakSucc = true
    end
    
    _init()
    _aniLayer:registerScriptTouchHandler(onTouch ,false ,-133 ,true)
    _aniLayer:setTouchEnabled(true)
end

