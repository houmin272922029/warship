

-- 战斗界面
FightingView = {
    getSailorsLayer = nil,
    showHeadIconAnimation = nil,
    showHeadIcon = nil,
    initHeadIcons = nil,
    setHeadIconImageAndName = nil,
    setHeadIconHp = nil,
    setHeadIconColor = nil,
    setHeadIconLevel = nil,
    fightEnd = nil,
    roundFightAnimation = nil,
    updateNumberOnTitle = nil,
    forceAnimation = nil,
    skipVisible = false,
    touchTimer = 0.0,
}
local fightingViewScheduler = nil

FightingBgFuns = {
}

FightingBgFuns[1] = function ()
    return createFightingBg_1_layer()
end
FightingBgFuns[2] = function ()
    return createFightingBg_2_layer()
end
FightingBgFuns[3] = function ()
    return createFightingBg_3_layer()
end
FightingBgFuns[4] = function ()
    return createFightingBg_4_layer()
end
FightingBgFuns[5] = function ()
    return createFightingBg_5_layer()
end
FightingBgFuns[6] = function ()
    return createFightingBg_6_layer()
end

local _fightingLayer = nil

FightingLayerOwner = FightingLayerOwner or {}

local congratulationsLayer = nil

local congratulationsOwner = congratulationsOwner or {}

local gameoverOwner = gameoverOwner or {}

local gameoverLayer = nil

local roundFightLayer = nil
local roundFightOwner = roundFightOwner or {}

local decisiveBattleLayer = nil
local decisiveBattleOwner = decisiveBattleOwner or {}

-- 16个头像的ccbi文件和表    
local _head_left_1 = nil
local _head_left_2 = nil
local _head_left_3 = nil
local _head_left_4 = nil
local _head_left_5 = nil
local _head_left_6 = nil
local _head_left_7 = nil
local _head_left_8 = nil
local _head_right_1 = nil
local _head_right_2 = nil
local _head_right_3 = nil
local _head_right_4 = nil
local _head_right_5 = nil
local _head_right_6 = nil
local _head_right_7 = nil
local _head_right_8 = nil

local head_left_1 = head_left_1 or {}

local head_left_2 = head_left_2 or {}

local head_left_3 = head_left_3 or {}

local head_left_4 = head_left_4 or {}

local head_left_5 = head_left_5 or {}

local head_left_6 = head_left_6 or {}

local head_left_7 = head_left_7 or {}

local head_left_8 = head_left_8 or {}

local head_right_1 = head_right_1 or {}

local head_right_2 = head_right_2 or {}

local head_right_3 = head_right_3 or {}

local head_right_4 = head_right_4 or {}

local head_right_5 = head_right_5 or {}

local head_right_6 = head_right_6 or {}

local head_right_7 = head_right_7 or {}

local head_right_8 = head_right_8 or {}

local function readHeadsFiles()
    
    ccb["head_left_1"] = head_left_1
    ccb["head_left_2"] = head_left_2
    ccb["head_left_3"] = head_left_3
    ccb["head_left_4"] = head_left_4
    ccb["head_left_5"] = head_left_5
    ccb["head_left_6"] = head_left_6
    ccb["head_left_7"] = head_left_7
    ccb["head_left_8"] = head_left_8
    ccb["head_right_1"] = head_right_1
    ccb["head_right_2"] = head_right_2
    ccb["head_right_3"] = head_right_3
    ccb["head_right_4"] = head_right_4
    ccb["head_right_5"] = head_right_5
    ccb["head_right_6"] = head_right_6
    ccb["head_right_7"] = head_right_7
    ccb["head_right_8"] = head_right_8
    _head_left_1 = tolua.cast(CCBReaderLoad("ccbResources/head_left_1.ccbi",CCBProxy:create(),false,"head_left_1"),"CCLayer")
    _head_left_2 = tolua.cast(CCBReaderLoad("ccbResources/head_left_2.ccbi",CCBProxy:create(),false,"head_left_2"),"CCLayer")
    _head_left_3 = tolua.cast(CCBReaderLoad("ccbResources/head_left_3.ccbi",CCBProxy:create(),false,"head_left_3"),"CCLayer")
    _head_left_4 = tolua.cast(CCBReaderLoad("ccbResources/head_left_4.ccbi",CCBProxy:create(),false,"head_left_4"),"CCLayer")
    _head_left_5 = tolua.cast(CCBReaderLoad("ccbResources/head_left_5.ccbi",CCBProxy:create(),false,"head_left_5"),"CCLayer")
    _head_left_6 = tolua.cast(CCBReaderLoad("ccbResources/head_left_6.ccbi",CCBProxy:create(),false,"head_left_6"),"CCLayer")
    _head_left_7 = tolua.cast(CCBReaderLoad("ccbResources/head_left_7.ccbi",CCBProxy:create(),false,"head_left_7"),"CCLayer")
    _head_left_8 = tolua.cast(CCBReaderLoad("ccbResources/head_left_8.ccbi",CCBProxy:create(),false,"head_left_8"),"CCLayer")
    _head_right_1 = tolua.cast(CCBReaderLoad("ccbResources/head_right_1.ccbi",CCBProxy:create(),false,"head_right_1"),"CCLayer")
    _head_right_2 = tolua.cast(CCBReaderLoad("ccbResources/head_right_2.ccbi",CCBProxy:create(),false,"head_right_2"),"CCLayer")
    _head_right_3 = tolua.cast(CCBReaderLoad("ccbResources/head_right_3.ccbi",CCBProxy:create(),false,"head_right_3"),"CCLayer")
    _head_right_4 = tolua.cast(CCBReaderLoad("ccbResources/head_right_4.ccbi",CCBProxy:create(),false,"head_right_4"),"CCLayer")
    _head_right_5 = tolua.cast(CCBReaderLoad("ccbResources/head_right_5.ccbi",CCBProxy:create(),false,"head_right_5"),"CCLayer")
    _head_right_6 = tolua.cast(CCBReaderLoad("ccbResources/head_right_6.ccbi",CCBProxy:create(),false,"head_right_6"),"CCLayer")
    _head_right_7 = tolua.cast(CCBReaderLoad("ccbResources/head_right_7.ccbi",CCBProxy:create(),false,"head_right_7"),"CCLayer")
    _head_right_8 = tolua.cast(CCBReaderLoad("ccbResources/head_right_8.ccbi",CCBProxy:create(),false,"head_right_8"),"CCLayer")
end 

local function setTeamName()
    
    for i=1,5 do
        FightingLayerOwner["teamName_left_"..i]:setString(BattleField.leftName)
        FightingLayerOwner["teamName_right_"..i]:setString(BattleField.rightName)
    end
end

local function setFightingSceneBg()
    local bg = BattleField:getFightBg()
    local bgNode = FightingBgFuns[bg]()
    if bgNode == nil then         
        bgNode = FightingBgFuns[1]()
    end 
    FightingLayerOwner["fightingBgLayer"]:addChild(bgNode)
end

local function computeArrangementInfo()
    
    -- 取十六个头像背景图
    local headsBg = tolua.cast(FightingLayerOwner["bgForHeads"],"CCSprite")
    -- 人物位置最下面一行的位置Y值，取背景图高度的1.05倍
    local yOfBottomLine = headsBg:getContentSize().height * 1.05 * retina
    -- 参考点坐标是屏幕宽度中间值和最下面一行人物位置的Y值
    local referencePoint = ccp(winSize.width / 2,yOfBottomLine)
    -- 中间两个海贼团之间的间隙，共0.06
    FightingLayerOwner["battleFieldCrack"] = 0.06 / 2
    -- 左右两边的位置参考点
    FightingLayerOwner["referencePoint_left"] = ccp(winSize.width * (0.5 - FightingLayerOwner["battleFieldCrack"]),yOfBottomLine)
    FightingLayerOwner["referencePoint_right"] = ccp(winSize.width * (0.5 + FightingLayerOwner["battleFieldCrack"]),yOfBottomLine)
    -- 站位面积的高度：屏幕高度 - 背景图高度的40% - 站位参考点的纵坐标
    FightingLayerOwner["battleFieldHeight"] = winSize.height - 730 * 0.4 * retina - yOfBottomLine

    -- 根据人物数量配置的位置，结构为：横坐标相对位置，纵坐标相对位置，z轴
    FightingLayerOwner["arrangement_1"] = {{0.38,0.5,1}}
    FightingLayerOwner["arrangement_2"] = {{0.28,0.71,1},{0.56,0.3,2}}
    FightingLayerOwner["arrangement_3"] = {{0.5,0.8,1},{0.65,0.21,3},{0.27,0.51,2}}
    FightingLayerOwner["arrangement_4"] = {{0.22,0.4,3},{0.8,0.56,2},{0.37,0.82,1},{0.61,0.16,4}}
    FightingLayerOwner["arrangement_5"] = {{0.16,0.53,3},{0.8,0.32,4},{0.68,0.7,2},{0.46,0.1,5},{0.37,0.86,1}}
    FightingLayerOwner["arrangement_6"] = {{0.13,0.74,2},{0.61,0.17,6},{0.23,0.26,5},{0.62,0.85,1},{0.41,0.5,4},{0.85,0.53,3}}
    FightingLayerOwner["arrangement_7"] = {{0.24,0.23,6},{0.76,0.75,2},{0.82,0.29,5},{0.54,0.49,4},{0.18,0.71,3},{0.45,0.86,1},{0.51,0.15,7}}
    FightingLayerOwner["arrangement_8"] = {{0.08,0.5,5},{0.34,0.68,2},{0.42,0.28,7},{0.69,0.91,1},{0.66,0.12,8},{0.89,0.65,3},{0.93,0.33,6},{0.59,0.51,4}}

end

local function resetSpeed()
    FightAniCtrl.setTheSpeed(1.0)
end

local function updateTouchTimer(dt)
    -- 计时加
    FightingView.touchTimer = FightingView.touchTimer + dt

    -- 1秒钟以上没有点击，并关闭计时器，等待点击屏幕时再开始计时
    if FightingView.touchTimer >= 1.0 then

        -- if userdata:getVipLevel() >= 3 then
            -- 设为正常速度
            resetSpeed()
        -- end
        -- 不再计时，进入等待点击的状态
        if fightingViewScheduler then
            CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(fightingViewScheduler)
            fightingViewScheduler = nil
        end
    end
end

local function onTouchBegan(x, y)
    return true
end

local function onTouchEnded(x, y)
    -- 计时超过1秒钟，则设为点击跳过模式
    if FightingView.touchTimer >= 1.0 then
        -- 更改可见性
        FightingView.skipVisible = not FightingView.skipVisible
        FightingLayerOwner["skipMenu"]:setVisible(FightingView.skipVisible)
        FightingLayerOwner["skipText"]:setVisible(FightingView.skipVisible)
        -- 可见就可用，不可见就不可用
        FightingLayerOwner["skipMenuItem"]:setEnabled(FightingView.skipVisible)
        -- 可见，则响应优先级提前，比触摸层的优先级高
        if FightingView.skipVisible then
            FightingLayerOwner["skipMenu"]:setHandlerPriority(-131)
        else -- 不可见，则则低于触摸层的优先级，即先响应层的触摸
            FightingLayerOwner["skipMenu"]:setHandlerPriority(-129)
        end
    else
        -- 计时不超过1秒钟，即为加速模式，加速并给提示
        -- 不可见，则则低于触摸层的优先级，即先响应层的触摸
        if userdata:getVipLevel() >= 3 then
            FightAniCtrl.speed()
            ShowText(HLNSLocalizedString("fight.clickToSpeed.tip"))
        else
            ShowText(string.format("%s%s","vip3",HLNSLocalizedString("fight.clickToSpeed.tip")))
        end
    end

    -- 船长等级到达4级时才有点击加速功能
    if userdata:getUserLevel() >= 4 then
        -- 无论什么模式，只要点击屏幕，就要重新计时
        if fightingViewScheduler then
            CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(fightingViewScheduler)
            fightingViewScheduler = nil
        end
        FightingView.touchTimer = 0.0
        fightingViewScheduler = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(updateTouchTimer,0, false)
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

local function skipItemClicked()
    Global:instance():TDGAonEventAndEventData("skip")
    if FightingView.enableSkip then
        local resultType = ResultType.SailWin
        local bWin = BattleField.result == RESULT_WIN
        if BattleField.mode == BattleMode.stage or BattleField.mode == BattleMode.chapter or BattleField.mode == BattleMode.arena 
            or BattleField.mode == BattleMode.marineBoss or BattleField.mode == BattleMode.unionBattle or BattleField.mode == BattleMode.worldwar
            or BattleField.mode == BattleMode.veiledSea or BattleField.mode == BattleMode.wwRob or BattleField.mode == BattleMode.SSA 
            or BattleField.mode == BattleMode.racingBattle then
            if bWin then
                resultType = ResultType.SailWin
            else
                resultType = ResultType.SailLose
            end
        elseif BattleField.mode == BattleMode.newWorld then
            if bWin then
                resultType = ResultType.NewWorldWin
            else
                resultType = ResultType.NewWorldLose
            end
        elseif BattleField.mode == BattleMode.boss then
            -- CCDirector:sharedDirector():replaceScene(CCTransitionFade:create(0.6, mainSceneFun()))
            -- getMainLayer():gotoAdventure()
            -- getAdventureLayer():bossFightEnd()
            CCDirector:sharedDirector():replaceScene(FightingResultSceneFun(ResultType.SailWin))
            return
        elseif BattleField.mode == BattleMode.racingBattleBoss then
            CCDirector:sharedDirector():replaceScene(FightingResultSceneFun(ResultType.SailWin))
            return
        elseif BattleField.mode == BattleMode.wwRobVideo then
            CCDirector:sharedDirector():replaceScene(CCTransitionFade:create(0.6, mainSceneFun()))
            getMainLayer():gotoEscortItem()
            return
        elseif BattleField.mode == BattleMode.SSAVideo then
            CCDirector:sharedDirector():replaceScene(CCTransitionFade:create(0.6, mainSceneFun()))
            getMainLayer():gotoSSAFourKing()
            return
        elseif BattleField.mode == BattleMode.hakiFight then
            CCDirector:sharedDirector():replaceScene(CCTransitionFade:create(0.6, mainSceneFun()))
            getMainLayer():gotoTeam()
            return
        end
        CCDirector:sharedDirector():replaceScene(FightingResultSceneFun(resultType))
    else
        ShowText(HLNSLocalizedString("fight.skipping.not.allowed"))
    end
end
FightingLayerOwner["skipItemClicked"] = skipItemClicked

local function _addTouchFBLayer()
    -- 添加点击反馈层
    local scene = CCDirector:sharedDirector():getRunningScene()
    if scene then
        scene:addChild(createTouchFeedbackLayer(), 9998, 9998)
    end 
end

function FightingScene()
    -- 读取和解析16个头像的ccbi文件
    readHeadsFiles()
    
    ccb["FightingLayerOwner"] = FightingLayerOwner
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/FightingView.ccbi",proxy,true,"FightingLayerOwner")
    _fightingLayer = tolua.cast(node,"CCLayer")
    
    -- 海贼团名字
    setTeamName()

    -- 加载战斗背景：需要根据配置
    setFightingSceneBg()

    -- 计算战场上人物位置的一些数据
    computeArrangementInfo()

    local function _fightingLayerOnEnter()
        print("_fightingLayer:onEnter")
        -- 加载战斗log
        BattleLog.reset()
        BattleLog.convertAnimationLogs()
        FightAniCtrl.clear()
        FightAniCtrl.next()

        -- 播放背景音乐
        if runtimeCache.bGuide then
            if runtimeCache.opAniStep == 11 then
                -- 第一个新手战斗
                playMusic(MUSIC_SOUND_FIGHT_NEWPLAYER,true)
                print("第一个新手战斗")
            elseif runtimeCache.guideStep == (GUIDESTEP.firstStageFight + 1) or runtimeCache.guideStep == (GUIDESTEP.secondStageFight + 1) then
                -- 第二个新手战斗
                playMusic(MUSIC_SOUND_FIGHT_BG,true)
                print("第二个新手战斗")
            else
                -- 这个好像不需要了，因为新手里边只有上边的三个战斗
                playMusic(MUSIC_SOUND_FIGHT_NEWPLAYER,true)
            end
        else
            playMusic(MUSIC_SOUND_FIGHT_BG,true)
        end
    
        -- 关于跳过战斗的按钮和控制
        local skipType = BattleField:getSkipType()
        FightingView.skipVisible = true
        FightingLayerOwner["skipMenu"]:setVisible(FightingView.skipVisible)
        FightingLayerOwner["skipText"]:setVisible(FightingView.skipVisible)
        -- 可见就可用，不可见就不可用
        FightingLayerOwner["skipMenuItem"]:setEnabled(FightingView.skipVisible)
        FightingLayerOwner["skipMenu"]:setHandlerPriority(-131)
        if skipType == 3 then
            FightingView.enableSkip = true
            FightingLayerOwner["skipMenuItem"]:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn2_0.png"))
        elseif skipType == 2 then
            FightingView.enableSkip = false
            FightingLayerOwner["skipMenuItem"]:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn2_2.png"))
            local waitToSkip = CCArray:create()
            waitToSkip:addObject(CCDelayTime:create(15))
            local function enableSkip()
                FightingView.enableSkip = true
                FightingLayerOwner["skipMenuItem"]:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn2_0.png"))
            end
            waitToSkip:addObject(CCCallFunc:create(enableSkip))
            _fightingLayer:runAction(CCSequence:create(waitToSkip))
        elseif skipType == 1 then
            FightingView.enableSkip = false
            FightingLayerOwner["skipMenuItem"]:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn2_2.png"))
        end

        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(1), CCCallFunc:create(_addTouchFBLayer))
        _fightingLayer:runAction(seq)

        -- 开始置为跳过按钮的响应模式
        FightingView.touchTimer = 2

        -- if userdata:getUserLevel() >= 4 then
        --     fightingViewScheduler = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(updateTouchTimer,0, false)
        -- end
    end

    local function _fightingLayerOnExit()
        for k,v in pairs(FightAniCtrl.soldiers) do
            CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile(herodata:getHeroAnimationByResId(v.m_resId))
            v:removeFromParentAndCleanup(true)
        end
        FightAniCtrl.soldiers = {}
        print("_fightingLayer:onExit")
        -- _fightingLayer:removeFromParentAndCleanup(true)
        _fightingLayer = nil
        if fightingViewScheduler then
            CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(fightingViewScheduler)
            fightingViewScheduler = nil
        end
        CCTextureCache:sharedTextureCache():removeUnusedTextures()
    end

    local function _cleanup()
        ccb["head_left_1"] = nil
        ccb["head_left_2"] = nil
        ccb["head_left_3"] = nil
        ccb["head_left_4"] = nil
        ccb["head_left_5"] = nil
        ccb["head_left_6"] = nil
        ccb["head_left_7"] = nil
        ccb["head_left_8"] = nil
        ccb["head_right_1"] = nil
        ccb["head_right_2"] = nil
        ccb["head_right_3"] = nil
        ccb["head_right_4"] = nil
        ccb["head_right_5"] = nil
        ccb["head_right_6"] = nil
        ccb["head_right_7"] = nil
        ccb["head_right_8"] = nil
        ccb["FightingLayerOwner"] = nil
        ccb["congratulationsOwner"] = nil
        ccb["gameoverOwner"] = nil
        ccb["roundFightOwner"] = nil
        ccb["decisiveBattleOwner"] = nil
    end

    --onEnter onExit
    local function layerEventHandler(eventType)
        if eventType == "enter" then
            if _fightingLayerOnEnter then _fightingLayerOnEnter() end
        elseif eventType == "exit" then
            if _fightingLayerOnExit then _fightingLayerOnExit() end
        elseif eventType == "cleanup" then
            if _cleanup then _cleanup() end
        end
    end
    _fightingLayer:registerScriptHandler(layerEventHandler)
    _fightingLayer:registerScriptTouchHandler(onTouch ,false ,-130 ,true )
    _fightingLayer:setTouchEnabled(true)

    local _scene = CCScene:create()
    _scene:addChild(_fightingLayer)
    
    return _scene
end

local function getHeadIcon(side,posIndex)
    local hSide = side == battleCamp.left and "left" or "right"    
    local h = ccb["head_"..hSide.."_"..posIndex]
    return h
end

local function turnHeadGrey(side,posIndex)
    local h = getHeadIcon(side,posIndex)
    if h["headBg"] then
        local function turnGrey()
            h["headBg"]:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("headBg_grey.png"))
            h["deadIcon1"]:setVisible(true)
            h["deadIcon2"]:setVisible(true)
        end
        local array = CCArray:create()
        array:addObject(CCDelayTime:create(1))
        array:addObject(CCCallFunc:create(turnGrey))
        local headBgSpeed = CCSpeed:create(CCSequence:create(array),FightAniCtrl.aniSpeed)
        h["headBg"]:runAction(headBgSpeed)
    end
end

function FightingView.getSailorsLayer()
    return FightingLayerOwner["sailorsLayer"]
end

function FightingView.showHeadIconAnimation(side,posIndex,animationName)
    local h = getHeadIcon(side,posIndex)

    local function resetLeftArrow(sender)
        sender:setPosition(ccp(0, 55))
    end
    local function resetRightArrow(sender)
        sender:setPosition(ccp(171, 55)) 
    end
    if animationName == "attackAnimation" then
        -- 攻击动画
        local sweepArrow = tolua.cast(h["sweepArrow"], "CCSprite")
        local highLight = tolua.cast(h["highLight"], "CCSprite")
        local array1 = CCArray:create()
        if side == battleCamp.left then
            array1:addObject(CCCallFuncN:create(resetLeftArrow))
        else
            array1:addObject(CCCallFuncN:create(resetRightArrow))
        end
        array1:addObject(CCDelayTime:create(0.3))
        if side == battleCamp.left then
            array1:addObject(CCMoveTo:create(4/15, ccp(171, 55)))
        else
            array1:addObject(CCMoveTo:create(4/15, ccp(0, 55)))
        end
        if side == battleCamp.left then
            array1:addObject(CCCallFuncN:create(resetLeftArrow))
        else
            array1:addObject(CCCallFuncN:create(resetRightArrow))
        end
        local seq1 = CCSequence:create(array1)
        local array2 = CCArray:create()
        array2:addObject(CCDelayTime:create(0.3))
        array2:addObject(CCFadeTo:create(1/30, 255))
        array2:addObject(CCDelayTime:create(1/5))
        array2:addObject(CCFadeTo:create(1/30, 0))
        local seq2 = CCSequence:create(array2)
        local spawn_arrow = CCSpawn:createWithTwoActions(seq1, seq2)
        -- sweepArrow:runAction(spawn_arrow)
        -- renzhan
        local sweepArrowSpeed = CCSpeed:create(spawn_arrow,FightAniCtrl.aniSpeed)
        sweepArrow:runAction(sweepArrowSpeed)


        local array3 = CCArray:create()
        highLight:setScale(0)
        array3:addObject(CCScaleTo:create(1/6, 1.1))
        array3:addObject(CCScaleTo:create(2/15, 1.0))
        array3:addObject(CCDelayTime:create(17/30))
        array3:addObject(CCScaleTo:create(1/15, 1.1))
        array3:addObject(CCScaleTo:create(1/15, 1.0))
        local seq3 = CCSequence:create(array3)
        local array4 = CCArray:create()
        highLight:setOpacity(0)
        array4:addObject(CCFadeTo:create(1/6, 255))
        array4:addObject(CCDelayTime:create(23/30))
        array4:addObject(CCFadeTo:create(1/15, 0))
        local seq4 = CCSequence:create(array4)
        local spawn_highLight = CCSpawn:createWithTwoActions(seq3, seq4)
        -- highLight:runAction(spawn_highLight)
        -- renzhan
        local highLightSpeed = CCSpeed:create(spawn_highLight,FightAniCtrl.aniSpeed)
        highLight:runAction(highLightSpeed)

    else
        -- 被攻击动画
        local heroHead = tolua.cast(h["heroHead"], "CCSprite")
        local array1 = CCArray:create()
        array1:addObject(CCDelayTime:create(19/30))
        array1:addObject(CCMoveTo:create(1/15, ccp(-1.0, 55)))
        array1:addObject(CCMoveTo:create(1/15, ccp(2.0, 42)))
        array1:addObject(CCMoveTo:create(1/15, ccp(-1.0, 54)))
        array1:addObject(CCMoveTo:create(1/15, ccp(-1.0, 43)))
        array1:addObject(CCMoveTo:create(1/15, ccp(0, 45)))
        local seq1 = CCSequence:create(array1)
        local array2 = CCArray:create()
        array2:addObject(CCDelayTime:create(19/30))
        array2:addObject(CCRotateTo:create(1/15, 5.0))
        array2:addObject(CCRotateTo:create(1/15, -5.0))
        array2:addObject(CCRotateTo:create(1/15, 5.0))
        array2:addObject(CCRotateTo:create(1/15, -4.0))
        array2:addObject(CCRotateTo:create(1/15, 0.0))
        local seq2 = CCSequence:create(array2)
        local spawn_head = CCSpawn:createWithTwoActions(seq1, seq2)
        -- heroHead:runAction(spawn_head)
        -- renzhan
        local heroHeadSpeed = CCSpeed:create(spawn_head,FightAniCtrl.aniSpeed)
        heroHead:runAction(heroHeadSpeed)


        local headFrame = tolua.cast(h["headFrame"], "CCSprite")
        local array3 = CCArray:create()
        array3:addObject(CCDelayTime:create(19/30))
        array3:addObject(CCMoveTo:create(1/15, ccp(84, 59)))
        array3:addObject(CCMoveTo:create(1/15, ccp(87, 59)))
        array3:addObject(CCMoveTo:create(1/15, ccp(84, 58)))
        array3:addObject(CCMoveTo:create(1/15, ccp(87, 58)))
        array3:addObject(CCMoveTo:create(1/15, ccp(86, 55)))
        local seq3 = CCSequence:create(array3)
        local array4 = CCArray:create()
        array4:addObject(CCDelayTime:create(19/30))
        array4:addObject(CCRotateTo:create(1/15, 5.0))
        array4:addObject(CCRotateTo:create(1/15, -5.0))
        array4:addObject(CCRotateTo:create(1/15, 5.0))
        array4:addObject(CCRotateTo:create(1/15, -4.0))
        array4:addObject(CCRotateTo:create(1/15, 0.0))
        local seq4 = CCSequence:create(array4)
        local spawn_frame = CCSpawn:createWithTwoActions(seq3, seq4)
        -- headFrame:runAction(spawn_frame)
        -- renzhan
        local heroHeadSpeed = CCSpeed:create(spawn_frame,FightAniCtrl.aniSpeed)
        headFrame:runAction(heroHeadSpeed)



        local highLight = tolua.cast(h["highLight"], "CCSprite")
        local array5 = CCArray:create()
        highLight:setScale(0)
        array5:addObject(CCScaleTo:create(1/6, 1.1))
        array5:addObject(CCScaleTo:create(2/15, 1.0))
        array5:addObject(CCDelayTime:create(17/30))
        array5:addObject(CCScaleTo:create(1/15, 1.1))
        array5:addObject(CCScaleTo:create(1/15, 1.0))
        local seq5 = CCSequence:create(array5)
        local array6 = CCArray:create()
        highLight:setOpacity(0)
        array6:addObject(CCFadeTo:create(1/6, 255))
        array6:addObject(CCDelayTime:create(23/30))
        array6:addObject(CCFadeTo:create(1/15, 0))
        local seq6 = CCSequence:create(array6)
        local spawn_highLight = CCSpawn:createWithTwoActions(seq5, seq6)
        -- highLight:runAction(spawn_highLight)
        -- renzhan
        local highLightSpeed = CCSpeed:create(spawn_highLight,FightAniCtrl.aniSpeed)
        highLight:runAction(highLightSpeed)


    end
    -- local m = h["mAnimationManager"]
    -- if m then
    --     m:runAnimationsForSequenceNamedTweenDuration(animationName, 0)
    -- end
end

function FightingView.updateBloodBar(side,posIndex,dstScale)
    if side == battleCamp.right and BattleField.mode == BattleMode.boss then
        return
    end
    if side == battleCamp.right and BattleField.mode == BattleMode.racingBattleBoss then
        return
    end
    local h = getHeadIcon(side,posIndex)
    local bloodBar = h["bloodBar"]
    local array = CCArray:create()
    array:addObject(CCDelayTime:create(0.5))
    array:addObject(CCScaleTo:create(0.5,dstScale,1))
    -- bloodBar:runAction(CCSequence:create(array))
    -- renzhan
    local bloodBarSpeed = CCSpeed:create(CCSequence:create(array),FightAniCtrl.aniSpeed)
    bloodBar:runAction(bloodBarSpeed)

    if dstScale == 0 then
        turnHeadGrey(side,posIndex)
    end
end

function FightingView.showHeadIcon(side,posIndex,bVisible)
    local h = getHeadIcon(side,posIndex)["node"]
    h:setVisible(bVisible)
end

function FightingView.initHeadIcons()   
    for i=1,8 do
        getHeadIcon(battleCamp.left,i)["bloodBar"]:setScaleX(1)
        getHeadIcon(battleCamp.right,i)["bloodBar"]:setScaleX(1)
        getHeadIcon(battleCamp.left,i)["deadIcon1"]:setVisible(false)
        getHeadIcon(battleCamp.left,i)["deadIcon2"]:setVisible(false)
        getHeadIcon(battleCamp.right,i)["deadIcon1"]:setVisible(false)
        getHeadIcon(battleCamp.right,i)["deadIcon2"]:setVisible(false)
        FightingView.showHeadIcon(battleCamp.left,i,false)
        FightingView.showHeadIcon(battleCamp.right,i,false)
    end   
end

function FightingView.setHeadIconImageAndName(side,posIndex,heroId,name)
    local h = getHeadIcon(side,posIndex)
    if h["heroHead"] then
        local f = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(herodata:getHeroHeadByHeroId(heroId))
        h["heroHead"]:setDisplayFrame(f)
    end
    if h["nameLabel"] then
        h["nameLabel"]:setString(name)
        for i = 1, 4 do
            h["nameLabel_"..i]:setString(name)
        end
    end
end

function FightingView.setHeadIconHp(side,posIndex,curHP,maxHP)
    local h = getHeadIcon(side,posIndex)

    if (side == battleCamp.right and BattleField.mode == BattleMode.boss) or (side == battleCamp.right and BattleField.mode == BattleMode.racingBattleBoss)  then
        if h["hpLabel"] then
            h["hpLabel"]:setString("?????/?????")
            for i = 1, 4 do
                h["hpLabel_"..i]:setString("?????/?????")
            end
        end
        if h["bloodBar"] then
            h["bloodBar"]:setScaleX(curHP/maxHP)
        end
    else
        if h["hpLabel"] then
            h["hpLabel"]:setString(curHP.."/"..maxHP)
            for i = 1, 4 do
                h["hpLabel_"..i]:setString(curHP.."/"..maxHP)
            end
        end
        if h["bloodBar"] then
            h["bloodBar"]:setScaleX(curHP/maxHP)
        end
    end
end

function FightingView.setHeadIconColor(side,posIndex,rank)
    local color = "grey"
    if rank == 1 then
        color = "grey"
    elseif
        rank == 2 then
        color = "green"
    elseif
        rank == 3 then
        color = "blue"
    elseif
        rank == 4 then
        color = "purple"
    elseif rank == 5 then
        color = "gold"
    end
    local h = getHeadIcon(side,posIndex)
    if h["headBg"] then
        h["headBg"]:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("headBg_"..color..".png"))
    end
end

function FightingView.setHeadIconLevel(side,posIndex,level)
    local h = getHeadIcon(side,posIndex)

    if (side == battleCamp.right and BattleField.mode == BattleMode.boss) or (side == battleCamp.right and BattleField.mode == BattleMode.racingBattleBoss) then
        
        if h["levelLabel"] then
            h["levelLabel"]:setString("LV  ???")
            for i = 1, 4 do
                h["levelLabel_"..i]:setString("LV  ???")
            end
        end
    else
        if h["levelLabel"] then
            h["levelLabel"]:setString("LV  "..level)
            for i = 1, 4 do
                h["levelLabel_"..i]:setString("LV  "..level)
            end
        end
    end
end

local function congratulationsAnimation(resultType)
    playEffect(MUSIC_SOUND_FIGHT_WIN)

    ccb["congratulationsOwner"] = congratulationsOwner
    local function animationFinished()
        congratulationsLayer:removeFromParentAndCleanup(true)
        congratulationsLayer = nil
        CCDirector:sharedDirector():replaceScene(FightingResultSceneFun(resultType))
    end
    congratulationsOwner["animationFinished"] = animationFinished
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/congratulations.ccbi",proxy,true,"congratulationsOwner")
    congratulationsLayer = tolua.cast(node,"CCLayer")
    _fightingLayer:addChild(congratulationsLayer,100)
    congratulationsLayer:setPosition(winSize.width / 2,(winSize.height + FightingLayerOwner["bgForHeads"]:getContentSize().height * retina - 100 * retina)  * 0.5)
    congratulationsLayer:setAnchorPoint(ccp(0.5,0.5))
    congratulationsLayer:setScale(retina)
end

local function gameoverAnimation(resultType)
    playEffect(MUSIC_SOUND_FIGHT_LOSE)
    ccb["gameoverOwner"] = gameoverOwner
    local function gameoverFinished()
        gameoverLayer = nil
        CCDirector:sharedDirector():replaceScene(FightingResultSceneFun(resultType))
    end
    gameoverOwner["gameoverFinished"] = gameoverFinished
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/gameover.ccbi",proxy,true,"gameoverOwner")
    gameoverLayer = tolua.cast(node,"CCLayer")
    _fightingLayer:addChild(gameoverLayer,100)
    gameoverLayer:setPosition(0,0)
end

function FightingView.fightEnd()
    print("战斗结束了")
    stopMusic()
    local resultType = ResultType.SailWin
    local bWin = BattleField.result == RESULT_WIN
    if BattleField.mode == BattleMode.stage or BattleField.mode == BattleMode.chapter or BattleField.mode == BattleMode.arena 
        or BattleField.mode == BattleMode.marineBoss or BattleField.mode == BattleMode.unionBattle or BattleField.mode == BattleMode.worldwar
        or BattleField.mode == BattleMode.veiledSea or BattleField.mode == BattleMode.wwRob or BattleField.mode == BattleMode.SSA 
        or BattleField.mode == BattleMode.racingBattle then
        if bWin then
            resultType = ResultType.SailWin
            congratulationsAnimation(resultType)
        else
            resultType = ResultType.SailLose
            gameoverAnimation(resultType)
        end
    elseif BattleField.mode == BattleMode.newWorld then
        if bWin then
            resultType = ResultType.NewWorldWin
            congratulationsAnimation(resultType)
        else
            resultType = ResultType.NewWorldLose
            gameoverAnimation(resultType)
        end
    elseif BattleField.mode == BattleMode.opAni then
        CCDirector:sharedDirector():replaceScene(CCTransitionFade:create(0.6, OPSceneFun()))
    elseif BattleField.mode == BattleMode.boss then
        -- CCDirector:sharedDirector():replaceScene(CCTransitionFade:create(0.6, mainSceneFun()))
        -- getMainLayer():gotoAdventure()
        -- getAdventureLayer():bossFightEnd()

        CCDirector:sharedDirector():replaceScene(FightingResultSceneFun(ResultType.SailWin))

    elseif BattleField.mode == BattleMode.racingBattleBoss then
        
        CCDirector:sharedDirector():replaceScene(FightingResultSceneFun(ResultType.SailWin))
    elseif BattleField.mode == BattleMode.wwRobVideo then
        CCDirector:sharedDirector():replaceScene(CCTransitionFade:create(0.6, mainSceneFun()))
        getMainLayer():gotoEscortItem()
    elseif BattleField.mode == BattleMode.SSAVideo then
        CCDirector:sharedDirector():replaceScene(CCTransitionFade:create(0.6, mainSceneFun()))
        getMainLayer():gotoSSAFourKing()
    elseif BattleField.mode == BattleMode.hakiFight then
        CCDirector:sharedDirector():replaceScene(CCTransitionFade:create(0.6, mainSceneFun()))
        getMainLayer():gotoTeam()
    end
end

function FightingView.roundFightAnimation(roundCount)
    playEffect(MUSIC_SOUND_FIGHT_ROUND)

    ccb["roundFightOwner"] = roundFightOwner
    local function roundShowFinished()
        roundFightLayer:setVisible(false)
        local array = CCArray:create()
        if roundCount == 1 then
            array:addObject(CCDelayTime:create(FightAniCtrl.buffCount * 1.5))
        end
        local function nextLog()
            FightAniCtrl.next()
            roundFightLayer:removeFromParentAndCleanup(true)
            roundFightLayer = nil
        end
        array:addObject(CCCallFunc:create(nextLog))
        roundFightLayer:runAction(CCSequence:create(array))
    end
    roundFightOwner["roundShowFinished"] = roundShowFinished
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/roundFight.ccbi",proxy,true,"roundFightOwner")
    roundFightLayer = tolua.cast(node,"CCLayer")

    local blend = ccBlendFunc:new()
    blend.src = GL_ONE
    blend.dst = GL_ONE

    local texture1 = CCTextureCache:sharedTextureCache():addImage("ccbResources/roundFight/roundColor_"..roundCount..".png")
    roundFightOwner["roundColor_1"]:setTexture(texture1)
    roundFightOwner["roundColor_1"]:setTextureRect(CCRectMake(0, 0, texture1:getContentSize().width, texture1:getContentSize().height))
    roundFightOwner["roundColor_2"]:setTexture(texture1)
    roundFightOwner["roundColor_2"]:setTextureRect(CCRectMake(0, 0, texture1:getContentSize().width, texture1:getContentSize().height))
    roundFightOwner["roundColor_2"]:setBlendFunc(blend)

    local texture2 = CCTextureCache:sharedTextureCache():addImage("ccbResources/roundFight/roundNum_"..roundCount..".png")
    roundFightOwner["roundNum"]:setTexture(texture2)
    roundFightOwner["roundNum"]:setTextureRect(CCRectMake(0, 0, texture2:getContentSize().width, texture2:getContentSize().height))
    roundFightOwner["roundNum"]:setBlendFunc(blend)

    _fightingLayer:addChild(roundFightLayer,101)
    roundFightLayer:setAnchorPoint(ccp(0.5,0.5))
    roundFightLayer:setPosition(winSize.width / 2,(winSize.height + FightingLayerOwner["bgForHeads"]:getContentSize().height * retina - 100 * retina) * 0.5)

end

function FightingView.updateNumberOnTitle(currentLeft,currentRight)
    currentNumbers = {currentLeft,currentRight}
    totalNumbers = {FightAniCtrl.leftTotalSoldiers,FightAniCtrl.rightTotalSoldiers}
    for side=1,2 do
        for label=1,5 do
            FightingLayerOwner["rolesNumber_"..side.."_"..label]:setString(currentNumbers[side].."/"..totalNumbers[side])
        end
    end
    FightingLayerOwner["bloodBarOnTitle_left"]:setScaleX(currentLeft / FightAniCtrl.leftTotalSoldiers)
    FightingLayerOwner["bloodBarOnTitle_right"]:setScaleX(currentRight / FightAniCtrl.rightTotalSoldiers)
end

function FightingView.forceAnimation(leftInnerPower,rightInnerPower,leftSpirit,rightSpirit)

    local leftValue = leftInnerPower + leftSpirit
    local rightValue = rightInnerPower + rightSpirit
    local leftTime = leftValue < rightValue and 6 or (6 / rightValue * leftValue)
    local rightTime = rightValue < leftValue and 6 or (6 / leftValue * rightValue)
    local leftIPBTime = leftTime * leftInnerPower / leftValue
    local rightIPBTime = rightTime * rightInnerPower / rightValue
    local leftSPBTime = leftTime * leftSpirit / leftValue
    local rightSPBTime = rightTime * rightSpirit / rightValue

    local roles = {}
    local function startToFadeIn()
        local i_left = 1
        local c_left = 1
        local i_right = 1
        local c_right = 1
        for sid,s in pairs(FightAniCtrl.soldiers) do
            local role = CCSprite:createWithSpriteFrameName(string.format("%s_stand_0001.png",s.m_resId))
            decisiveBattleOwner["rolesLayer"]:addChild(role,s:getZOrder())
            role:setAnchorPoint(ccp(0.5,0.5))
            local roleTb = {}
            roleTb.resId = s.m_resId
            roleTb.side = s.m_side
            roleTb.sprite = role
            table.insert(roles,roleTb)
            local dstPosX = 0
            local dstPosY = 0
            if s.m_side == 1 then
                dstPosX = winSize.width * 0.4 - winSize.width * 0.05 * (c_left - 1)
                dstPosY = winSize.height * 0.5 + ((c_left + 1) * 0.5 - i_left) * 25
                i_left = i_left + 1
                if i_left > c_left then
                    i_left = 1
                    c_left = c_left + 1
                end
            else
                dstPosX = winSize.width * 0.6 + winSize.width * 0.05 * (c_right - 1)
                dstPosY = winSize.height * 0.5 + ((c_right + 1) * 0.5 - i_right) * 25
                i_right = i_right + 1
                if i_right > c_right then
                    i_right = 1
                    c_right = c_right + 1
                end
            end
            role:setPosition(ccp(s:getPositionX(),s:getPositionY() - 162 * retina))
            role:setOpacity(0)
            role:setScaleX(s.m_side * retina)
            role:setScaleY(retina)
            role:runAction(CCFadeIn:create(1))
            local anis = CCArray:create()
            anis:addObject(CCMoveTo:create(0.4,ccp(dstPosX,dstPosY)))

            local animFrames = CCArray:create()
            for j = 0, 10 do
                local frameName = string.format("%s_attack_000%d.png",s.m_resId, math.mod(j,6) + 1)
                local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(frameName)
                animFrames:addObject(frame)
            end
            local ani = CCAnimation:createWithSpriteFrames(animFrames, 0.15)
            anis:addObject(CCAnimate:create(ani))
            for i=1,5 do
                local d = RandomManager.randomRange(-10, 10)
                anis:addObject(CCJumpBy:create(0.6,ccp(d * retina,0),5 * retina,6))
                anis:addObject(CCJumpBy:create(0.6,ccp(-d * retina,0),5 * retina,6))
            end
            role:runAction(CCSequence:create(anis))
        end
    end
    decisiveBattleOwner["startToFadeIn"] = startToFadeIn

    local function tbLinesShow()
        HLAddParticleScaleWithAction( "images/eff_page_504.plist", decisiveBattleOwner["rolesLayer"], ccp(0,winSize.height * 0.65), 10, 10, 100,0.75,0.15,nil)
        HLAddParticleScaleWithAction( "images/eff_page_504.plist", decisiveBattleOwner["rolesLayer"], ccp(winSize.width,winSize.height * 0.3), 10, 10, 100,-0.75,0.15,nil)
        HLAddParticleScale( "images/eff_decisiveBattle_4.plist", decisiveBattleOwner["blackLayer"], ccp(0,winSize.height * 0.72), 5, 102, 100, 1, 1)
        HLAddParticleScale( "images/eff_decisiveBattle_4.plist", decisiveBattleOwner["blackLayer"], ccp(winSize.width,winSize.height * 0.37), 5, 102, 100,-1, 1)
    end
    decisiveBattleOwner["tbLinesShow"] = tbLinesShow

    local function startFire()
        HLAddParticleScale( "images/eff_decisiveBattle_2.plist", decisiveBattleOwner["rolesLayer"], ccp(winSize.width/2,winSize.height * 0.48), 5, 102, 100,1, 1)
        HLAddParticleScale( "images/eff_decisiveBattle_5.plist", decisiveBattleOwner["rolesLayer"], ccp(winSize.width/2,winSize.height * 0.48), 5, 102, 505,1, 1)
    end
    decisiveBattleOwner["startFire"] = startFire

    local function startForcing()
        local innerPowerBar_left = decisiveBattleOwner["innerPowerBar_left"]
        local innerPowerBar_right = decisiveBattleOwner["innerPowerBar_right"]
        local spiritBar_left = decisiveBattleOwner["spiritBar_left"]
        local spiritBar_right = decisiveBattleOwner["spiritBar_right"]

        HLAddParticleScaleWithAction( "images/eff_decisiveBattle_1.plist", decisiveBattleOwner["blackLayer"], ccp(innerPowerBar_left:getPositionX(),innerPowerBar_left:getPositionY()), leftIPBTime, 102, 501, 1, 1,CCMoveBy:create(leftIPBTime,ccp(252 * retina * 0.75,0)))
        HLAddParticleScaleWithAction( "images/eff_decisiveBattle_1.plist", decisiveBattleOwner["blackLayer"], ccp(innerPowerBar_right:getPositionX(),innerPowerBar_right:getPositionY()), rightIPBTime, 102, 502,1, 1,CCMoveBy:create(rightIPBTime,ccp(-252 * retina * 0.75,0)))
    
        local leftIPBActions = CCArray:create()
        leftIPBActions:addObject(CCMoveBy:create(leftIPBTime,ccp(252 * retina * 0.75,0)))
        local function leftSPBAction()
            for i,roleTb in ipairs(roles) do
                if roleTb.side == 1 then
                    roleTb.sprite:setColor(ccc3(255,0,0))
                end
            end
            decisiveBattleOwner["label_left"]:setString(HLNSLocalizedString("fight.force.bone"))
            HLAddParticleScaleWithAction( "images/eff_decisiveBattle_1.plist", decisiveBattleOwner["blackLayer"], ccp(spiritBar_left:getPositionX(),spiritBar_left:getPositionY()), leftSPBTime, 102, 503, 1, 1,CCMoveBy:create(leftSPBTime,ccp(252 * retina * 0.75,0)))
            local leftSPBActions = CCArray:create()
            leftSPBActions:addObject(CCMoveBy:create(leftSPBTime,ccp(252 * retina * 0.75,0)))
            local function stopRightActions()
                innerPowerBar_right:stopAllActions()
                spiritBar_right:stopAllActions()

                HLAddParticleScaleWithAction( "images/eff_force_blood.plist", decisiveBattleOwner["blackLayer"], ccp(decisiveBattleOwner["brightBoundary"]:getPositionX() - 50 * retina,decisiveBattleOwner["brightBoundary"]:getPositionY()), 1.5, 1002, 503, -0.75, 0.75,nil)

                local rightPar_1 = decisiveBattleOwner["blackLayer"]:getChildByTag(502)
                if rightPar_1 then
                    rightPar_1:stopAllActions()
                    rightPar_1:removeFromParentAndCleanup(true)
                end
                local rightPar_2 = decisiveBattleOwner["blackLayer"]:getChildByTag(504)
                if rightPar_2 then
                    rightPar_2:stopAllActions()
                    rightPar_2:removeFromParentAndCleanup(true)
                end
                local Par_3 = decisiveBattleOwner["rolesLayer"]:getChildByTag(505)
                if Par_3 then
                    Par_3:stopAllActions()
                    Par_3:removeFromParentAndCleanup(true)
                end
                for i,roleTb in ipairs(roles) do
                    if roleTb.side == 1 then
                        roleTb.sprite:stopAllActions()
                        roleTb.sprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("%s_defend_0001.png",roleTb.resId)))
                        local jumps = CCArray:create()
                        jumps:addObject(CCJumpBy:create(2,ccp(-winSize.width * 0.3 * (1 + 0.02 * i),75 * retina * (1 - 0.1 * i)),100 * retina * (1 - 0.1 * i),1))
                        jumps:addObject(CCJumpBy:create(1,ccp(-30 * retina,0),40 * retina,1))
                        jumps:addObject(CCJumpBy:create(0.5,ccp(-15 * retina,0),15 * retina,1))
                        roleTb.sprite:runAction(CCSequence:create(jumps))
                        roleTb.sprite:runAction(CCRotateBy:create(2,-50))
                    end
                end
                for sid,s in pairs(FightAniCtrl.soldiers) do
                    if s.m_side == 1 then
                        s:stopAllActions()
                        s.m_actionSpeed = nil
                        s:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("%s_dead_0001.png",s.m_resId)))
                    end
                end
            end
            if leftValue < rightValue then
                leftSPBActions:addObject(CCCallFunc:create(stopRightActions))
                leftSPBActions:addObject(CCDelayTime:create(2.5))
                local function removeForcing()
                    decisiveBattleLayer:stopAllActions()
                    -- decisiveBattleLayer:removeFromParentAndCleanup(true)
                    FightAniCtrl.next()
                end
                leftSPBActions:addObject(CCCallFunc:create(removeForcing))
            end
            spiritBar_left:runAction(CCSequence:create(leftSPBActions))

        end
        leftIPBActions:addObject(CCCallFunc:create(leftSPBAction))
        innerPowerBar_left:runAction(CCSequence:create(leftIPBActions))
        
        local rightIPBActions = CCArray:create()
        rightIPBActions:addObject(CCMoveBy:create(rightIPBTime,ccp(-252 * retina * 0.75,0)))
        local function rightSPBAction()
            for i,roleTb in ipairs(roles) do
                if roleTb.side == -1 then
                    roleTb.sprite:setColor(ccc3(255,0,0))
                end
            end
            decisiveBattleOwner["label_right"]:setString(HLNSLocalizedString("fight.force.bone"))

            HLAddParticleScaleWithAction( "images/eff_decisiveBattle_1.plist", decisiveBattleOwner["blackLayer"], ccp(spiritBar_right:getPositionX(),spiritBar_right:getPositionY()), rightSPBTime, 102, 504, 1, 1,CCMoveBy:create(rightSPBTime,ccp(-252 * retina * 0.75,0)))
            local rightSPBActions = CCArray:create()
            rightSPBActions:addObject(CCMoveBy:create(rightSPBTime,ccp(-252 * retina * 0.75,0)))
            local function stopLeftActions()
                innerPowerBar_left:stopAllActions()
                spiritBar_left:stopAllActions()
                HLAddParticleScaleWithAction( "images/eff_force_blood.plist", decisiveBattleOwner["blackLayer"], ccp(decisiveBattleOwner["brightBoundary"]:getPositionX() + 50 * retina,decisiveBattleOwner["brightBoundary"]:getPositionY()), 1.5, 1002, 503, 0.75, 0.75,nil)
            
                local rightPar_1 = decisiveBattleOwner["blackLayer"]:getChildByTag(501)
                if rightPar_1 then
                    rightPar_1:stopAllActions()
                    rightPar_1:removeFromParentAndCleanup(true)
                end
                local rightPar_2 = decisiveBattleOwner["blackLayer"]:getChildByTag(503)
                if rightPar_2 then
                    rightPar_2:stopAllActions()
                    rightPar_2:removeFromParentAndCleanup(true)
                end
                local Par_3 = decisiveBattleOwner["rolesLayer"]:getChildByTag(505)
                if Par_3 then
                    Par_3:stopAllActions()
                    Par_3:removeFromParentAndCleanup(true)
                end
                for i,roleTb in ipairs(roles) do
                    if roleTb.side == -1 then
                        roleTb.sprite:stopAllActions()
                        roleTb.sprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("%s_defend_0001.png",roleTb.resId)))
                        local jumps = CCArray:create()
                        jumps:addObject(CCJumpBy:create(2,ccp(winSize.width * 0.3 * (1 + 0.02 * i),75 * retina * (1 - 0.1 * i)),100 * retina * (1 + 0.1 * i),1))
                        jumps:addObject(CCJumpBy:create(1,ccp(30 * retina,0),40 * retina,1))
                        jumps:addObject(CCJumpBy:create(0.5,ccp(15 * retina,0),15 * retina,1))
                        roleTb.sprite:runAction(CCSequence:create(jumps))
                        roleTb.sprite:runAction(CCRotateBy:create(2,50))
                    end
                end
                for sid,s in pairs(FightAniCtrl.soldiers) do
                    if s.m_side == -1 then
                        s:stopAllActions()
                        s.m_actionSpeed = nil
                        s:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("%s_dead_0001.png",s.m_resId)))
                    end
                end
            end
            if rightValue < leftValue then
                rightSPBActions:addObject(CCCallFunc:create(stopLeftActions))
                rightSPBActions:addObject(CCDelayTime:create(2.5))
                local function removeForcing()
                    decisiveBattleLayer:stopAllActions()
                    -- decisiveBattleLayer:removeFromParentAndCleanup(true)
                    FightAniCtrl.next()
                end
                rightSPBActions:addObject(CCCallFunc:create(removeForcing))
            end
            spiritBar_right:runAction(CCSequence:create(rightSPBActions))
        end
        rightIPBActions:addObject(CCCallFunc:create(rightSPBAction))
        innerPowerBar_right:runAction(CCSequence:create(rightIPBActions))
    end
    decisiveBattleOwner["startForcing"] = startForcing

    ccb["decisiveBattleOwner"] = decisiveBattleOwner
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/decisiveBattle.ccbi",proxy,true,"decisiveBattleOwner")
    decisiveBattleLayer = tolua.cast(node,"CCLayer")

    FightingLayerOwner["fightEffectLayer"]:addChild(decisiveBattleLayer)
    decisiveBattleLayer:setPosition(ccp(0,0))
    decisiveBattleOwner["blackLayer"]:setPosition(ccp(winSize.width / 2,(winSize.height - 500 * retina) / 2 + 412 * retina))
end