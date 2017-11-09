local _layer
local _priority = -134
local _resultType

-- 跳转权重
local goto_weight = {
    ["1"] = 3,  -- 装备强化
    ["2"] = 3,  -- 伙伴培养
    ["3"] = 2,  -- 奥义突破
    ["4"] = 2,  -- 战舰强化
    ["5"] = 1,  -- 伙伴突破
    ["6"] = 1,  -- 炼影
}

local GOTO_TAG = {
    REFINE = 1,
    CULTURE = 2,
    SKILL = 3,
    BATTLESHIP = 4,
    BREAK = 5,
    SHADOW = 6,
    RECRUIT = 7,
    BOX = 8,
}

-- 名字不要重复
NewWorldSweepInfoOwner = NewWorldSweepInfoOwner or {}
ccb["NewWorldSweepInfoOwner"] = NewWorldSweepInfoOwner

local function _close()
    _layer:removeFromParentAndCleanup(true)

    if _resultType == RESULT_WIN then
        runtimeCache.newWorldState = blooddata.data.flag
        getMainLayer():gotoAdventure()
    elseif _resultType == RESULT_LOSE then
        runtimeCache.newWorldThirdSweep = true 
        getMainLayer():addChild(createNewWorldOverLayer(), 200)
        --_scene:addChild(createNewWorldOverLayer(), 100)
    end

end


local function closeItemClick()
    _close()
end
NewWorldSweepInfoOwner["closeItemClick"] = closeItemClick



local function getBloodInfoCallback( url,rtnData )
    blooddata:fromDic(rtnData["info"]["bloodInfo"])
    if blooddata and blooddata.data then
        print("**lsf gotoItemClick doActionFun getBloodInfo")
        runtimeCache.newWorldState = blooddata.data.flag
    end
end


local function gotoItemClick(tag)
    
    doActionFun("GET_BLOOD_INFO", {}, getBloodInfoCallback) --lsf 重新取一下数据 防止关卡数据异常
    
    if tag == GOTO_TAG.REFINE then
        _layer:removeFromParentAndCleanup(true)
        getMainLayer():gotoEquipmentsLayer()
    elseif tag == GOTO_TAG.CULTURE then
        _layer:removeFromParentAndCleanup(true)
        getMainLayer():goToHeroes(0)
    elseif tag == GOTO_TAG.SKILL then
        _layer:removeFromParentAndCleanup(true)
        getMainLayer():gotoSkillViewLayer()
    elseif tag == GOTO_TAG.BATTLESHIP then
        _layer:removeFromParentAndCleanup(true)
        getMainLayer():gotoBattleShipLayer()
    elseif tag == GOTO_TAG.BREAK then
        _layer:removeFromParentAndCleanup(true)
        getMainLayer():goToHeroes(1)
    elseif tag == GOTO_TAG.SHADOW then
        if shadowData:bOpenShadowFun() then
            _layer:removeFromParentAndCleanup(true)
            getMainLayer():gotoTrainShadowView()
        else
            if shadowData:openLevel() then
                ShowText(HLNSLocalizedString("shadow.open.tips", shadowData:openLevel()))
            else
                ShowText(HLNSLocalizedString("component.close"))
            end
        end
    elseif tag == GOTO_TAG.RECRUIT then
        _layer:removeFromParentAndCleanup(true)
        getMainLayer():goToLogue()
    elseif tag == GOTO_TAG.BOX then
        _layer:removeFromParentAndCleanup(true)
        getMainLayer():goToLogue()
        local function changePage()
            getLogueTownLayer():gotoPageByType(1)
        end
        getLogueTownLayer():runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(changePage)))
    end
end
NewWorldSweepInfoOwner["gotoItemClick"] = gotoItemClick



-- 刷新新世界战斗胜利界面
local function _refreshNewWorldWinLayer()
    local resp = runtimeCache.responseData
    local gain = {}
    if resp.gain then
        gain = resp.gain
    end
    local pay = {}
    if resp.pay then
        pay = resp.pay
    end
    if not runtimeCache.bVideo then
        userdata:updateUserDataWithGainAndPay(gain, pay)
    end

    local resultLabel = tolua.cast(NewWorldSweepInfoOwner["resultLabel"], "CCSprite")
    local result = 4 - BattleField.round
    resultLabel:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("win_%d.png", result)))
    for i=1,result do
        local star = tolua.cast(NewWorldSweepInfoOwner["star"..i], "CCSprite")
        star:setVisible(true)
    end
    local roundLabel = tolua.cast(NewWorldSweepInfoOwner["roundLabel"], "CCLabelTTF")
    roundLabel:setString(string.format(roundLabel:getString(), BattleField.round))
    local starLabel = tolua.cast(NewWorldSweepInfoOwner["starLabel"], "CCLabelTTF")
    starLabel:setString(string.format(starLabel:getString(), result, runtimeCache.newWorldGrade))
    local attrLabel = tolua.cast(NewWorldSweepInfoOwner["attrLabel"], "CCLabelTTF")
    if runtimeCache.newWorldOutpostNum % 3 == 0 then
        attrLabel:setString(string.format(attrLabel:getString(), 0))
    else
        attrLabel:setString(string.format(attrLabel:getString(), 3 - runtimeCache.newWorldOutpostNum % 3))
    end
    local rewardLabel = tolua.cast(NewWorldSweepInfoOwner["rewardLabel"], "CCLabelTTF")
    if runtimeCache.newWorldOutpostNum % 5 == 0 then
        rewardLabel:setString(string.format(rewardLabel:getString(), 0))
    else
        rewardLabel:setString(string.format(rewardLabel:getString(), 5 - runtimeCache.newWorldOutpostNum % 5))
    end
    
end

local function _refreshNewWorldLoseLayer()
    local resp = runtimeCache.responseData
    local gain = {}
    if resp.gain then
        gain = resp.gain
    end
    local pay = {}
    if resp.pay then
        pay = resp.pay
    end
    if not runtimeCache.bVideo then
        userdata:updateUserDataWithGainAndPay(gain, pay)
    end
    local resultLabel = tolua.cast(NewWorldSweepInfoOwner["resultLabel"], "CCSprite")
    local result = BattleField.round
    resultLabel:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("lose_%d.png", result)))
    
    local tipsLabel = tolua.cast(NewWorldSweepInfoOwner["tipsLabel"], "CCLabelTTF")
    tipsLabel:setString(HLNSLocalizedString("deadGuide.tips."..RandomManager.randomRange(1, 4)))
    local gotos = {}
    while(#gotos < 2) do
        local rand = RandomManager.prob(goto_weight)
        if not table.ContainsObject(gotos, rand) then
            table.insert(gotos, rand)
        end   
    end
    for i=1,2 do
        local gotoItem = tolua.cast(NewWorldSweepInfoOwner["gotoItem"..i], "CCMenuItem")
        gotoItem:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("btn_goto_%s_0.png", gotos[i])))
        gotoItem:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("btn_goto_%s_1.png", gotos[i])))
        gotoItem:setTag(tonumber(gotos[i]))

        local gotoLabel = tolua.cast(NewWorldSweepInfoOwner["gotoLabel"..i], "CCLabelTTF")
        gotoLabel:setString(HLNSLocalizedString(string.format("deadGuide.goto."..gotos[i])))
    end
end



-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  node 
    local  proxy = CCBProxy:create()

    if _resultType == RESULT_WIN then
        node  = CCBReaderLoad("ccbResources/NewWorldSweepWinView.ccbi", proxy, true,"NewWorldSweepInfoOwner")
        _refreshNewWorldWinLayer()

    elseif _resultType == RESULT_LOSE then
        node  = CCBReaderLoad("ccbResources/NewWorldSweepLoseView.ccbi", proxy, true,"NewWorldSweepInfoOwner")
        _refreshNewWorldLoseLayer()
    end
    _layer = tolua.cast(node,"CCLayer")
 



end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(NewWorldSweepInfoOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        _close()
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

local function setMenuPriority()
    local menu = tolua.cast(NewWorldSweepInfoOwner["menu"], "CCMenu")
    menu:setHandlerPriority(_priority - 2)
    local menu1 = tolua.cast(NewWorldSweepInfoOwner["menu1"], "CCMenu")
    menu1:setHandlerPriority(_priority - 2)
end

-- 该方法名字每个文件不要重复
function getNewWorldSweepInfoLayer()
    return _layer
end

function createNewWorldSweepInfoLayer( resultType, priority)
  
    _priority = (priority ~= nil) and priority or -134
    _resultType = resultType
    _init()
    

    local function _onEnter()
        print("onEnter")
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
    end

    local function _onExit()
        print("onExit")
        _layer = nil
        tableView = nil
        _priority = -134
        _storyResult = nil
    end

    --onEnter onExit
    local function _layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        end
    end


    _layer:registerScriptTouchHandler(onTouch ,false ,_priority ,true )
    _layer:setTouchEnabled(true)
    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end