GUIDESTEP = {
    firstGotoSail = 1, -- 第一次进入起航
    firstStageFight = 2, -- 第一关战斗
    firstFightResult = 3, -- 第一关战斗结算
    gotoRogue = 4, -- 进入罗格镇
    recruit = 5, -- 刷将
    recruitResult = 6, -- 刷将结算页面
    firstGotoTeam = 7, -- 第一次进入阵容
    onForm = 8, -- 上阵
    selectHero = 9, -- 选择上阵伙伴
    confirmHeroSelected = 10, -- 确认上阵伙伴
    secondGotoSail = 11, -- 第二次进入起航
    secondStageFight = 12, -- 第二关战斗
    secondFightResult = 13, -- 第二关战斗结算
    secondGotoTeam = 14, -- 第二次进入阵容装备武器
    equipWeapon = 15, -- 装备武器
    selectWeapon = 16, -- 选择武器
    confirmWeaponSelected = 17, -- 确认武器选择
    -- gotoHome = 18, -- 
    -- gotoPackage = 19, -- 去背包
    -- thirdGotoSail = 20, -- 第三次去起航
    -- guideEnd = 21, -- 结束

    selectNeedUpdateEquip = 18, -- 选择需要强化的武器
    selectUpdateEquip = 19, -- 选择强化武器
    updateEquip = 20, -- 强化武器
    gotoHome = 21, -- 回到首页
    gotoPackage = 22, -- 去背包
    selectNewGiftBag = 23, -- 选择使用新手礼包 
    takeGiftBag = 24, -- 收取礼包
    thirdGotoSail = 25, -- 第三次去起航
    guideEnd = 26, -- 结束
}

local _layer

-- ·名字不要重复
GuideOwner = GuideOwner or {}
ccb["GuideOwner"] = GuideOwner

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/GuideView.ccbi",proxy, true,"GuideOwner")
    _layer = tolua.cast(node,"CCLayer")
end

local function _refreshLayer(visible)
    local layer = tolua.cast(GuideOwner["guide"..runtimeCache.guideStep], "CCLayer")
    layer:setVisible(visible)
end

local function onTouchBegan(x, y)
    return true
end

local function recruitActionCallBack( url,rtnData )
    recruitData.cdTimes[3] = ConfigureStorage.freeRecruitCDTime[3]
    getRecruitLayer():recruitActionCallBack(url, rtnData)
    _layer:removeFromParentAndCleanup(true)
    -- doActionFun("SET_GUIDE_STEP", {runtimeCache.guideStep - 1})
    runtimeCache.guideStep = runtimeCache.guideStep + 1
end

local function onFormCallback( url, rtnData )
    getOnFormLayer():onFormCallback(url, rtnData)
    -- doActionFun("SET_GUIDE_STEP", {runtimeCache.guideStep - 1})
    runtimeCache.guideStep = runtimeCache.guideStep + 1
    _refreshLayer(true)
end

local function changeSkillCallBack( url, rtnData )
    getEquipChangeSelectLayer():changeSkillCallBack(url, rtnData) 
    -- doActionFun("SET_GUIDE_STEP", {runtimeCache.guideStep - 1})
    runtimeCache.guideStep = runtimeCache.guideStep + 1
    _refreshLayer(true)
end

-- 强化装备回调
local function updateCallBack( url, rtnData )
    getEquipUpdateLayer():updateCallBack(url, rtnData)
    runtimeCache.guideStep = runtimeCache.guideStep + 1
    _refreshLayer(true)
end

-- 领取新手礼包回调
local function useCallBack( url, rtnData )
    getWareHouseLayer():useCallBack(url, rtnData)
    runtimeCache.guideStep = runtimeCache.guideStep + 1
    _refreshLayer(true)
end

local function errorClick()
    userdata:resetAllData()
    local scene = CCDirector:sharedDirector():getRunningScene()
    scene:addChild(createLoginErrorPopUpLayer(-1000), 10000)
end

local function guideError()
    local text = HLNSLocalizedString("guide.error")
    _layer:getParent():addChild(createSimpleConfirCardLayer(text), 1000)
    SimpleConfirmCard.confirmMenuCallBackFun = errorClick
    SimpleConfirmCard.cancelMenuCallBackFun = errorClick
    _layer:removeFromParentAndCleanup(true)
end

local function onTouchEnded(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(GuideOwner["touch"..runtimeCache.guideStep], "CCLayer")
    local rect = infoBg:boundingBox()
    if runtimeCache.guideStep == GUIDESTEP.firstStageFight 
        or runtimeCache.guideStep == GUIDESTEP.selectHero 
        or runtimeCache.guideStep == GUIDESTEP.confirmHeroSelected 
        or runtimeCache.guideStep == GUIDESTEP.secondStageFight 
        or runtimeCache.guideStep == GUIDESTEP.selectWeapon 
        or runtimeCache.guideStep == GUIDESTEP.confirmWeaponSelected 
        or runtimeCache.guideStep == GUIDESTEP.selectNewGiftBag then

        local posLayer = tolua.cast(GuideOwner["posLayer"..runtimeCache.guideStep], "CCLayer")
        local pos = ccp((winSize.width + posLayer:getContentSize().width - rect.size.width) / 2, 
            winSize.height - posLayer:getContentSize().height - rect.size.height / 2)
        rect = CCRectMake(pos.x, pos.y, rect.size.width, rect.size.height)

    elseif runtimeCache.guideStep == GUIDESTEP.selectUpdateEquip 
        or runtimeCache.guideStep == GUIDESTEP.takeGiftBag then

        local posLayer = tolua.cast(GuideOwner["posLayer"..runtimeCache.guideStep], "CCLayer")
        local pos = ccp((winSize.width - posLayer:getContentSize().width * retina) / 2 + rect.origin.x * retina, 
            (winSize.height - posLayer:getContentSize().height * retina) / 2 + rect.origin.y * retina)
        rect = CCRectMake(pos.x, pos.y, rect.size.width * retina, rect.size.height * retina)
    end
    if rect:containsPoint(touchLocation) then
        _refreshLayer(false)
        if runtimeCache.guideStep == GUIDESTEP.firstGotoSail 
            or runtimeCache.guideStep == GUIDESTEP.secondGotoSail 
            or runtimeCache.guideStep == GUIDESTEP.thirdGotoSail then
            getMainLayer():goToSail()
        elseif runtimeCache.guideStep == GUIDESTEP.firstStageFight then
            -- 进入战斗 stage_01_01
            --CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile("ccbResources/selectRole.plist")
            --CCSpriteFrameCache:sharedSpriteFrameCache():removeUnusedSpriteFrames()
            getSailLayer():storyFight("stage_01_01")
            -- doActionFun("SET_GUIDE_STEP", {runtimeCache.guideStep - 1})
            runtimeCache.guideStep = runtimeCache.guideStep + 1
            _layer:removeFromParentAndCleanup(true)
            return true
        elseif runtimeCache.guideStep == GUIDESTEP.secondStageFight then
            getSailLayer():storyFight("stage_01_02")
            -- doActionFun("SET_GUIDE_STEP", {runtimeCache.guideStep - 1})
            runtimeCache.guideStep = runtimeCache.guideStep + 1
            _layer:removeFromParentAndCleanup(true)
            return true
        elseif runtimeCache.guideStep == GUIDESTEP.firstFightResult or runtimeCache.guideStep == GUIDESTEP.secondFightResult then
            
                CCSpriteFrameCache:sharedSpriteFrameCache():removeUnusedSpriteFrames()
                CCTextureCache:sharedTextureCache():removeUnusedTextures()
            CCDirector:sharedDirector():replaceScene(mainSceneFun())
            getMainLayer():goToSail()
        elseif runtimeCache.guideStep == GUIDESTEP.gotoRogue then
            getMainLayer():goToLogue()
        elseif runtimeCache.guideStep == GUIDESTEP.recruit then
            -- TODO 暂时跳过，刷将结算页面
            -- _layer:removeFromParentAndCleanup(true)
            -- getRecruitLayer():recruitAction(103)
            doActionFun("RECRUITHERO_URL", {3, runtimeCache.guideStep - 1}, recruitActionCallBack, guideError)
            return true
        elseif runtimeCache.guideStep == GUIDESTEP.recruitResult then
            -- 阵容移出来
            getCallingAnimationLayer2():layerTouch(false)
            getCallingAnimationLayer2():clearLayer()
            getMainLayer():reloadBottomBtn()
        elseif runtimeCache.guideStep == GUIDESTEP.firstGotoTeam or runtimeCache.guideStep == GUIDESTEP.secondGotoTeam then
            getMainLayer():gotoTeam()
        elseif runtimeCache.guideStep == GUIDESTEP.onForm then
            runtimeCache.teamPage = 1
            getMainLayer():gotoOnForm()
        elseif runtimeCache.guideStep == GUIDESTEP.selectHero then
            getOnFormLayer():selectHero(0)
        elseif runtimeCache.guideStep == GUIDESTEP.confirmHeroSelected then
            -- getOnFormLayer():confirmItemClick()
            local _offForm = herodata:getHeroOffForm()
            local hid = _offForm[1]
            doActionFun("ON_FORM", {runtimeCache.teamPage, hid, runtimeCache.guideStep - 1}, onFormCallback, guideError)
            return true
        elseif runtimeCache.guideStep == GUIDESTEP.equipWeapon then
            getTeamLayer():equipItemClick(1)
        elseif runtimeCache.guideStep == GUIDESTEP.selectWeapon then
            local hid = herodata.form["1"]
            local _allEquipData = equipdata:getCanChangeEquipByUidAndTypeAndEuid(hid, "weapon", nil)
            local equipContent = _allEquipData[1]
            if not equipContent then
                guideError()
                _layer:removeFromParentAndCleanup(true)
                return true
            end
            getEquipChangeSelectLayer():selectEquip(1)
        elseif runtimeCache.guideStep == GUIDESTEP.confirmWeaponSelected then
            -- getEquipChangeSelectLayer():confirmBtnClicked()
            local hid = herodata.form["1"]
            local _allEquipData = equipdata:getCanChangeEquipByUidAndTypeAndEuid(hid, "weapon", nil)
            local equipContent = _allEquipData[1]
            doActionFun("EQUIP_CHANGE_URL", {hid, 0, equipContent.id, runtimeCache.guideStep - 1}, changeSkillCallBack, guideError)
            return true
        elseif runtimeCache.guideStep == GUIDESTEP.gotoHome then
            getMainLayer():goToHome()
        elseif runtimeCache.guideStep == GUIDESTEP.gotoPackage then
            getMainLayer():gotoWareHouseLayer()
        elseif runtimeCache.guideStep == GUIDESTEP.selectNeedUpdateEquip then
            getTeamLayer():equipItemClick(1)
        elseif runtimeCache.guideStep == GUIDESTEP.selectUpdateEquip then
            getEquipInfoLayer():qianghuaItemClick()
        elseif runtimeCache.guideStep == GUIDESTEP.updateEquip then
            local hid = herodata.form["1"]
            doActionFun("UPDATE_EQUIP_URL",{herodata.heroes[hid].equip["0"],runtimeCache.guideStep - 1}, updateCallBack, guideError) 
            return true
        elseif runtimeCache.guideStep == GUIDESTEP.selectNewGiftBag then
            local count = wareHouseData:getItemCountById("box_007")
            if count > 0 then
                local array = {"box_007", "1", runtimeCache.guideStep - 1}
                if array then
                    doActionFun("ITEM_USE_URL", array, useCallBack, guideError)
                end
                return true
            end
        elseif runtimeCache.guideStep == GUIDESTEP.takeGiftBag then
            if getGetSomeRewardLayer() then
                getGetSomeRewardLayer():confirmBtnTaped()
            end
        elseif runtimeCache.guideStep == GUIDESTEP.guideEnd then
            doActionFun("SET_GUIDE_STEP", {runtimeCache.guideStep})
            _layer:removeFromParentAndCleanup(true)
            runtimeCache.bGuide = false
            getMainLayer():goToHome()
            return true
        end
        -- 发送 已完成的步骤
        if runtimeCache.guideStep == GUIDESTEP.guideEnd then
            doActionFun("SET_GUIDE_STEP", {runtimeCache.guideStep})
        end

        runtimeCache.guideStep = runtimeCache.guideStep + 1
        _refreshLayer(true)
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


-- 该方法名字每个文件不要重复
function getGuideLayer()
	return _layer
end

function createGuideLayer()
    _init()

    local function _onEnter()
        _refreshLayer(true)
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


    _layer:registerScriptTouchHandler(onTouch ,false , -99999 ,true )
    _layer:setTouchEnabled(true)
    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end