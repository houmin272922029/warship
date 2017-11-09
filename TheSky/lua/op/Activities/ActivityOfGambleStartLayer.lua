local _layer
local _priority = -132
local rotation
local _chooseMoney 
local resultStr     -- 摇奖结果编号 1 2 3 ...
local pictureStr = {}
local _bAni = false
local gainGold      -- 获得金币数
local resultype     -- 结果类型 1 、0倍 2、 0.5倍...
local isFirst       -- 是否是活动第一次登陆
local isFirstTime   -- 是否本次重新打开游戏
_logs = {}          -- 上面的提示语


-- 活动主界面 摇摇乐
-- 名字不要重复
ActivityOfGambleStartOwner = ActivityOfGambleStartOwner or {}
ccb["ActivityOfGambleStartOwner"] = ActivityOfGambleStartOwner

local function rollSprite( pos,finalChar )

    if not finalChar then
        finalChar = math.random(1,4)
    end

    local posT = tolua.cast(ActivityOfGambleStartOwner["posT"..pos],"CCSprite")
    local posB = tolua.cast(ActivityOfGambleStartOwner["posB"..pos],"CCSprite")
    local aniSprite0 = tolua.cast(ActivityOfGambleStartOwner[string.format("aniSprite%s0",pos)],"CCSprite")
    local aniSprite1 = tolua.cast(ActivityOfGambleStartOwner[string.format("aniSprite%s1",pos)],"CCSprite")
    local aniSprite2 = tolua.cast(ActivityOfGambleStartOwner[string.format("aniSprite%s2",pos)],"CCSprite")
    local aniSprite3 = tolua.cast(ActivityOfGambleStartOwner[string.format("aniSprite%s3",pos)],"CCSprite")
    local topPos = ccp(posT:getPositionX(),posT:getPositionY())
    local botPos = ccp(posB:getPositionX(),posB:getPositionY())

    local texture0 = CCTextureCache:sharedTextureCache():addImage(string.format("icons/%s.png",pictureStr[tostring(1)]))
    aniSprite0:setTexture(texture0)
    local texture1 = CCTextureCache:sharedTextureCache():addImage(string.format("icons/%s.png",pictureStr[tostring(2)]))
    aniSprite1:setTexture(texture1)
    local texture2 = CCTextureCache:sharedTextureCache():addImage(string.format("icons/%s.png",pictureStr[finalChar]))
    aniSprite2:setTexture(texture2)
    local texture3 = CCTextureCache:sharedTextureCache():addImage(string.format("icons/%s.png",pictureStr[tostring(4)]))
    aniSprite3:setTexture(texture3)

    function move( sprite )
        sprite = tolua.cast(sprite,"CCSprite")
        local actionArray = CCArray:create()

        local numberStr0
        local numberStr1
        local numberStr2
        local numberStr3
        
        function setRollTexture(sprite,numberStr0,numberStr1,numberStr2,numberStr3)
            if sprite == aniSprite0 then
                local texture0 = CCTextureCache:sharedTextureCache():addImage(string.format("icons/%s.png",numberStr0))
                sprite:setTexture(texture0)
            elseif sprite == aniSprite1  then
                local texture1 = CCTextureCache:sharedTextureCache():addImage(string.format("icons/%s.png",numberStr1))
                sprite:setTexture(texture1)
            elseif sprite == aniSprite2 then
                local texture2 = CCTextureCache:sharedTextureCache():addImage(string.format("icons/%s.png",numberStr2))
                sprite:setTexture(texture2)
            elseif sprite == aniSprite3 then
                local texture3 = CCTextureCache:sharedTextureCache():addImage(string.format("icons/%s.png",numberStr3))
                sprite:setTexture(texture3)
            end
        end
        local _speed = 2000
        local _flag = 1
        local currentPos = ccp(sprite:getPositionX(),sprite:getPositionY())

        local function setConstomPos()
            sprite:setPosition(ccp(posT:getPositionX(),posT:getPositionY()))
            numberStr0 = pictureStr[tostring(math.random(1,4))]
            numberStr1 = pictureStr[tostring(math.random(1,4))]
            numberStr2 = pictureStr[finalChar]
            numberStr3 = pictureStr[tostring(math.random(1,4))]
            setRollTexture(sprite,numberStr0,numberStr1,numberStr2,numberStr3)
        end

        for i=1,1000 do
            
            local move1 = CCMoveBy:create((currentPos.y - botPos.y) / _speed,ccp(0, -(currentPos.y - botPos.y)))  -- 移动第一段
            local setPos2 = CCCallFunc:create(setConstomPos)
            local move2 = CCMoveBy:create((topPos.y - currentPos.y) / _speed,ccp(0, -(topPos.y - currentPos.y)))  -- 移动第二段

            actionArray:addObject(move1)
            actionArray:addObject(setPos2)
            actionArray:addObject(move2)
            
            if _speed >= 4000 then    --  保持速度不更改
                _flag = _flag + 1
                if _flag > 4 * (tonumber(pos))+10 then
                    _speed = _speed - 800
                end
            elseif _speed >= 100 then
                if _flag <= 2 then
                    _speed = _speed + 500
                elseif _flag >= 4 then
                    _speed = _speed - 700
                end
            end

            if _speed < 100 then
                break
            end
        end
        -- if pos == 3 and sprite == tolua.cast(ActivityOfGambleStartOwner["aniSprite30"],"CCSprite") then
        -- end
        local seq = CCSequence:create(actionArray)
        actionArray = nil
        sprite:runAction(seq)
    end
    move(aniSprite0)
    move(aniSprite1)
    move(aniSprite2)
    move(aniSprite3)
end

-- 摇杆回调
local function clickHandleCallBack( url,rtnData )
    if rtnData["code"] == 200 then
        local menu = tolua.cast(ActivityOfGambleStartOwner["beginRoll"], "CCMenuItemImage")
        menu:setEnabled(false)
        resultStr = rtnData.info
        local goldNow
        if rtnData.info.gain then
            gainGold = rtnData.info.gain.gold
            goldNow = userdata.gold - rtnData.info.gain.gold
        else
            gainGold = 0
            goldNow = userdata.gold
        end
        resultype = rtnData.info.suibian
        table.insert(_logs, resultype)

        local userTimesLabel = tolua.cast(ActivityOfGambleStartOwner["userTimesLabel"],"CCLabelTTF")
        userTimesLabel:setString(rtnData.info.frontPage.yaoyaoHappy.haveTimes.."/"..rtnData.info.frontPage.yaoyaoHappy.times)
        local currentGold = tolua.cast(ActivityOfGambleStartOwner["currentGold"],"CCLabelTTF")
        currentGold:setString(goldNow)

        local actionArray = CCArray:create()

        local function aniStart()
            _bAni = true
            local menu = tolua.cast(ActivityOfGambleStartOwner["beginRoll"], "CCMenuItemImage")
            menu:setEnabled(false)
        end

        local function aniEnd()
            _bAni = false
            local menu = tolua.cast(ActivityOfGambleStartOwner["beginRoll"], "CCMenuItemImage")
            menu:setEnabled(true)
        end
        actionArray:addObject(CCCallFunc:create(aniStart))
        for i=1,3 do
            local function roll()
                local finalStr = string.format("%d",resultStr.pictrue[tostring(i - 1)])
                rollSprite(i, finalStr)
            end
            actionArray:addObject(CCCallFunc:create(roll))
            actionArray:addObject(CCDelayTime:create(0.2))
        end
        actionArray:addObject(CCDelayTime:create(5.8))
        actionArray:addObject(CCCallFunc:create(refresh))
        if gainGold > 0 then
            local function resetResultStr( )
                gainGold = 0 
            end
            -- 掉落金币的粒子效果
            local function addHLFax()
                local _scene = CCDirector:sharedDirector():getRunningScene()
                if gainGold < 20 then
                    HLAddParticleScale( "images/goldDrop_1.plist", _scene, ccp(winSize.width / 2,winSize.height), 1, 1, 1,1,1)
                elseif gainGold >= 20 and gainGold < 50 then
                    HLAddParticleScale( "images/goldDrop_2.plist", _scene, ccp(winSize.width / 2,winSize.height), 1, 1, 1,1,1)
                elseif gainGold >= 50 and gainGold < 300 then
                    HLAddParticleScale( "images/goldDrop_3.plist", _scene, ccp(winSize.width / 2,winSize.height), 1, 1, 1,1,1)
                else
                    HLAddParticleScale( "images/goldDrop_4.plist", _scene, ccp(winSize.width / 2,winSize.height), 1, 1, 1,1,1)
                end 
            end
            actionArray:addObject(CCCallFunc:create(addHLFax))
            actionArray:addObject(CCDelayTime:create(3))
            actionArray:addObject(CCCallFunc:create(resetResultStr))
        else
        end
        actionArray:addObject(CCDelayTime:create(1))
        actionArray:addObject(CCCallFunc:create(aniEnd))
        local seq = CCSequence:create(actionArray)
        _layer:runAction(seq)
    end
end

-- 点击摇杆
local function beginRollClick()
    if userdata.gold < _chooseMoney then
        local function cardConfirmAction( )
            _layer:addChild(createShopRechargeLayer(-400), 100)
        end
        local function cardCancelAction( )
        end
        _layer:addChild(createSimpleConfirCardLayer(HLNSLocalizedString("activity.Activity_Gamble.notmoregold")))
        SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
        SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction
    elseif loginActivityData.activitys[Activity_Gamble].isFirst and isFirst == 1 then
        isFirst = 0
        local function cardConfirmAction( )
        end
        local function cardCancelAction( )
        end
        _layer:addChild(createSimpleConfirCardLayer(HLNSLocalizedString("activity.Activity_Gamble.warn")))
        SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
        SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction
    elseif loginActivityData.activitys[Activity_Gamble].haveTimes == 0 then
        local function cardConfirmAction( )
        end
        local function cardCancelAction( )
        end
        _layer:addChild(createSimpleConfirCardLayer(HLNSLocalizedString("activity.Activity_Gamble.haveNotTimes")))
        SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
        SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction
    else
        doActionFun("YAO_YAO_HAPPY",{loginActivityData.activitys[Activity_Gamble].uid,_chooseMoney},clickHandleCallBack)
    end
end
ActivityOfGambleStartOwner["beginRollClick"] = beginRollClick

-- 查看奖励
local function showRewardClick()
    getMainLayer():addChild(createActivityOfGambleHelp(-136), 200)
end
ActivityOfGambleStartOwner["showRewardClick"] = showRewardClick

local function closeItemClick()
    popUpCloseAction(ActivityOfGambleStartOwner, "infoBg", _layer)
end
ActivityOfGambleStartOwner["closeItemClick"] = closeItemClick

-- 选择押注
local function chooseGoldClick()
    local choosemoney = tolua.cast(ActivityOfGambleStartOwner["choosemoney"],"CCSprite")
    rotation = rotation==180 and 0 or 180 
    choosemoney:setRotation(rotation)

    if rotation == 0 then
        _chooseMoney = loginActivityData.activitys[Activity_Gamble].goldx[tostring(0)]
    else
        _chooseMoney = loginActivityData.activitys[Activity_Gamble].goldx[tostring(1)]
    end
end
ActivityOfGambleStartOwner["chooseGoldClick"] = chooseGoldClick

function refresh()
    local currentGold = tolua.cast(ActivityOfGambleStartOwner["currentGold"],"CCLabelTTF")
    currentGold:setString(userdata.gold)
    
    if isFirstTime then
        isFirstTime = false
        for i=1,3 do
            local logLabel = tolua.cast(ActivityOfGambleStartOwner["log"..i], "CCLabelTTF")
            logLabel:setString(" ")
            logLabel:setVisible(false)
        end
    end

    if #_logs > 3 then
        table.remove(_logs, 1)
    end
    for i,v in ipairs(_logs) do
        local logLabel = tolua.cast(ActivityOfGambleStartOwner["log"..i], "CCLabelTTF")
        if v then
            logLabel:setString(HLNSLocalizedString("activity.Activity_Gamble.rewardTimes"..v))
            if gainGold > 0 then
                ShowText(HLNSLocalizedString("activity.Activity_Gamble.rewardGold",gainGold))
            end
        end
        logLabel:setVisible(true)
    end
end

local function _init()
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/ActivityOfGambleStartView.ccbi", proxy, true,"ActivityOfGambleStartOwner")
    _layer = tolua.cast(node,"CCLayer")
    local userTimesLabel = tolua.cast(ActivityOfGambleStartOwner["userTimesLabel"],"CCLabelTTF")
    userTimesLabel:setString(loginActivityData.activitys[Activity_Gamble].haveTimes.."/"..loginActivityData.activitys[Activity_Gamble].times)

    for i=1,2 do
        local smallGold = tolua.cast(ActivityOfGambleStartOwner["smallGold"..i],"CCLabelTTF")
        local bigGold = tolua.cast(ActivityOfGambleStartOwner["bigGold"..i],"CCLabelTTF")
        smallGold:setString(loginActivityData.activitys[Activity_Gamble].goldx[tostring(0)])
        bigGold:setString(loginActivityData.activitys[Activity_Gamble].goldx[tostring(1)])
    end
    _chooseMoney = loginActivityData.activitys[Activity_Gamble].goldx[tostring(0)]
    isFirst = loginActivityData.activitys[Activity_Gamble].isFirst

    for i=1,3 do
        local aniSprite0 = tolua.cast(ActivityOfGambleStartOwner[string.format("aniSprite%s0",i)],"CCSprite")
        local aniSprite1 = tolua.cast(ActivityOfGambleStartOwner[string.format("aniSprite%s1",i)],"CCSprite")
        local aniSprite2 = tolua.cast(ActivityOfGambleStartOwner[string.format("aniSprite%s2",i)],"CCSprite")
        local aniSprite3 = tolua.cast(ActivityOfGambleStartOwner[string.format("aniSprite%s3",i)],"CCSprite")
        for k,v in pairs(ConfigureStorage.Picture_Contrast) do
            pictureStr[k] = v.ID
        end

        local texture0 = CCTextureCache:sharedTextureCache():addImage(string.format("icons/%s.png",pictureStr[tostring(1)]))
        aniSprite0:setTexture(texture0)
        local texture1 = CCTextureCache:sharedTextureCache():addImage(string.format("icons/%s.png",pictureStr[tostring(2)]))
        aniSprite1:setTexture(texture1)
        local texture2 = CCTextureCache:sharedTextureCache():addImage(string.format("icons/%s.png",pictureStr[tostring(3)]))
        aniSprite2:setTexture(texture2)
        local texture3 = CCTextureCache:sharedTextureCache():addImage(string.format("icons/%s.png",pictureStr[tostring(4)]))
        aniSprite3:setTexture(texture3)
    end
    local beginRoll = tolua.cast(ActivityOfGambleStartOwner["beginRoll"],"CCMenuItemImage")
    beginRoll:setEnabled(true)

    refresh()
end

local function setMenuPriority()
    local menu1 = tolua.cast(ActivityOfGambleStartOwner["closeMenu"], "CCMenu")
    menu1:setHandlerPriority(_priority - 1)
end

local function onTouchBegan(x, y)
    if _bAni then
        return true
    end
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(ActivityOfGambleStartOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction(ActivityOfGambleStartOwner, "infoBg", _layer)
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

function getActivityOfGambleStartLayer()
    return _layer
end

function createActivityOfGambleStartLayer(priority)
    if getLoginActivityLayer() then
        getLoginActivityLayer():removeFromParentAndCleanup(true)
    end

    _priority = (priority ~= nil) and priority or -132
    _init()

    function _layer:refresh()
        refresh() 
    end
    
    local function _onEnter()
        _logs = {}
        isFirstTime = true
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
        addObserver(NOTI_WW_REFRESH, refresh)
        popUpUiAction(ActivityOfGambleStartOwner, "infoBg")
    end

    local function _onExit()
        removeObserver(NOTI_WW_REFRESH, refresh)
        _layer = nil
        _priority = nil
        rotation = nil
        _chooseMoney = nil
        resultStr = nil
        _bAni = false
        resultype = nil
        isFirst = nil
        isFirstTime = nil
    end

    --onEnter onExit
    local function _layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        end
    end
    _layer:registerScriptTouchHandler(onTouch, false, _priority, true)
    _layer:setTouchEnabled(true)
    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end