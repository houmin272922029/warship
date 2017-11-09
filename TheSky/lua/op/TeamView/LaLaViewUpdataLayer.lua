local _layer
local _priority = -132
local _tableView
local _data
local _index
local _confUpCost

--活动主界面 竞技场争霸赛活动
-- 名字不要重复
LaLaViewUpdataOwner = LaLaViewUpdataOwner or {}
ccb["LaLaViewUpdataOwner"] = LaLaViewUpdataOwner

--关闭按钮的回调
local function closeItemClick()
    popUpCloseAction(LaLaViewUpdataOwner, "infoBg", _layer)
end
LaLaViewUpdataOwner["closeItemClick"] = closeItemClick

-- 退出按钮的回调   OnExitClicked
local function OnExitClicked()
    popUpCloseAction(LaLaViewUpdataOwner, "infoBg", _layer)
end
LaLaViewUpdataOwner["OnExitClicked"] = OnExitClicked

local function needItemConfirmClick()
    if not getMainLayer() then
        CCDirector:sharedDirector():replaceScene(mainSceneFun())
    end
    runtimeCache.dailyPageNum = Daily_Worship
    getMainLayer():gotoDaily()
end

--升级按钮的回调  UpdataClicked
local function UpdataClicked()
       --当前船长等级不足  提升升级所需等级不足，船长快去努力升级
    if ConfigureStorage.formSevenLv[_index] == nil then
    else
        if userdata:getFormSevenLv(_index) >= userdata:getFormSevenUpgradeMax(_index) then
            local text = HLNSLocalizedString("LaLa.levelnotenough")
            CCDirector:sharedDirector():getRunningScene():addChild(createSimpleConfirCardLayer(text))
            SimpleConfirmCard.confirmMenuCallBackFun = nil
            SimpleConfirmCard.cancelMenuCallBackFun = nil
            return
        end
    end
    
    --当前玩家助威卡小于此次消耗答助威卡 弹出亲吻美人鱼  
    if wareHouseData:getItemCountById("item_014") < _confUpCost[userdata:getFormSevenLv(_index) + 1] then
        local name = wareHouseData:getItemConfig(ConfigureStorage.openFormSevenItem.itemId).name
        local text = HLNSLocalizedString("lala.item.need", name, name)
        CCDirector:sharedDirector():getRunningScene():addChild(createSimpleConfirCardLayer(text))
        SimpleConfirmCard.confirmMenuCallBackFun = needItemConfirmClick
        SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction
        return 
    end 
    local function callback(url, rtnData)
        herodata.sevenUpgrade = rtnData.info.seven_upgrade
        getTeamLayer():refreshLaLa()
        -- popUpCloseAction(LaLaViewUpdataOwner, "infoBg", _layer)
        _layer:removeFromParentAndCleanup(true)
    end
    --向服务器发送成功领取消息  uid 以及 id
    doActionFun("FORMSEVEN_UPGRADE", {_index - 1}, callback)
end
LaLaViewUpdataOwner["UpdataClicked"] = UpdataClicked

local function _refreshData()
    local conf_Attr = ConfigureStorage.formSevenAttr[_index] -- 当前剪影属性
    local conf_Lv = ConfigureStorage.formSevenLv[_index] -- 啦啦队等级升到下一级所需的船长等级
    _confUpCost = ConfigureStorage.formSevenLvUpCost[_index] -- 啦啦队Lv升级消耗
    local confUpgrade = ConfigureStorage.formSevenUpgrade[_index] --升级属性配置加成
    if userdata:getFormSevenLv(_index) == #confUpgrade - 1 then  --当lv等级达到最大
        local PercentBefore = tolua.cast(LaLaViewUpdataOwner["PercentBefore"], "CCLabelTTF")
        local PercentAfter = tolua.cast(LaLaViewUpdataOwner["PercentAfter"], "CCLabelTTF")
        local LvBefore = tolua.cast(LaLaViewUpdataOwner["LvBefore"], "CCLabelTTF")
        local LvAfter = tolua.cast(LaLaViewUpdataOwner["LvAfter"], "CCLabelTTF")
        local cardNeed = tolua.cast(LaLaViewUpdataOwner["cardNeed"], "CCLabelTTF")
        local cardOwn = tolua.cast(LaLaViewUpdataOwner["cardOwn"], "CCLabelTTF")
        LvBefore:setVisible(false)
        LvAfter:setVisible(false)
        PercentBefore:setVisible(false)
        PercentAfter:setVisible(false)
        cardNeed:setVisible(false)
        cardOwn:setVisible(false)
        local cardUpNeed = tolua.cast(LaLaViewUpdataOwner["cardUpNeed"], "CCLabelTTF")
        cardUpNeed:setVisible(false)
        local cardUpSpend = tolua.cast(LaLaViewUpdataOwner["cardUpSpend"], "CCLabelTTF")
        cardUpSpend:setVisible(false)
        local arrow1 = tolua.cast(LaLaViewUpdataOwner["arrow1"], "CCLabelTTF")
        arrow1:setVisible(false)
        local arrow2 = tolua.cast(LaLaViewUpdataOwner["arrow2"], "CCLabelTTF")
        arrow2:setVisible(false)
        local Icon1 = tolua.cast(LaLaViewUpdataOwner["Icon1"], "CCLabelTTF")
        Icon1:setVisible(false)

        --显示Lv.Max 界面
        local LvMax = tolua.cast(LaLaViewUpdataOwner["LvMax"], "CCLabelTTF")
        LvMax:setVisible(true) 
        local percentMax = tolua.cast(LaLaViewUpdataOwner["percentMax"], "CCLabelTTF")
        percentMax:setVisible(true)
        percentMax:setString("+".. confUpgrade[userdata:getFormSevenLv(_index) + 1] * 100 .."%")
        local Icon2 = tolua.cast(LaLaViewUpdataOwner["Icon2"], "CCSprite")
        Icon2:setVisible(true)
        local icon = conf_Attr.attr == "mp" and "int" or conf_Attr.attr
        Icon2:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("%s_icon.png", icon)))
        local TopLvUp = tolua.cast(LaLaViewUpdataOwner["TopLvUp"], "CCLabelTTF")
        TopLvUp:setVisible(true) 

        --items隐藏
        local SureBtn = tolua.cast(LaLaViewUpdataOwner["SureBtn"], "CCMenuItemImage")
        SureBtn:setVisible(false)
        local LvUpSprite = tolua.cast(LaLaViewUpdataOwner["LvUpSprite"], "CCSprite")
        LvUpSprite:setVisible(false)
        local Icon1 = tolua.cast(LaLaViewUpdataOwner["Icon1"], "CCSprite")
        Icon1:setVisible(false)
    else
        --获得 升级前的属性加成百分比
        local PercentBefore = tolua.cast(LaLaViewUpdataOwner["PercentBefore"], "CCLabelTTF")
        PercentBefore:setString("+" .. confUpgrade[userdata:getFormSevenLv(_index) + 1] * 100 .. "%")
        --获得 升级后的属性加成百分比
        local PercentAfter = tolua.cast(LaLaViewUpdataOwner["PercentAfter"], "CCLabelTTF")
        PercentAfter:setString("+" .. confUpgrade[userdata:getFormSevenLv(_index) + 2] * 100 .. "%")
        --获得 升级前Lv等级 LvBefore
        local LvBefore = tolua.cast(LaLaViewUpdataOwner["LvBefore"], "CCLabelTTF")
        --LvBefore:setString(HLNSLocalizedString('LaLaUpdateLv_'..userdata:getFormSevenLv(tag)))
        local BeforeLvCount = userdata:getFormSevenLv(_index)
        BeforeLvCount= (BeforeLvCount == #confUpgrade - 1) and "Max" or BeforeLvCount
        LvBefore:setString("Lv." .. BeforeLvCount)
        --获得 升级后Lv等级 LvAfter 
        local LvAfter = tolua.cast(LaLaViewUpdataOwner["LvAfter"], "CCLabelTTF")
        local AfterLvCount = userdata:getFormSevenLv(_index) + 1
        AfterLvCount= (AfterLvCount == #confUpgrade - 1) and "Max" or AfterLvCount
        LvAfter:setString("Lv." .. AfterLvCount)
         --获得此次消耗的助威卡  
        local cardNeed = tolua.cast(LaLaViewUpdataOwner["cardNeed"], "CCLabelTTF")
        cardNeed:setString(_confUpCost[userdata:getFormSevenLv(_index) + 1])
        --获得当前玩家拥有的助威卡
        local cardOwn = tolua.cast(LaLaViewUpdataOwner["cardOwn"], "CCLabelTTF")
        cardOwn:setString(wareHouseData:getItemCountById("item_014")) 

        --显示当前玩家点击剪影显示的属性加成图片 conf_Attr
        local Icon1 = tolua.cast(LaLaViewUpdataOwner["Icon1"], "CCSprite")
        local icon = conf_Attr.attr == "mp" and "int" or conf_Attr.attr
        Icon1:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("%s_icon.png", icon)))

    end
    --船长等级不足
    if userdata:getFormSevenLv(_index) >= userdata:getFormSevenUpgradeMax(_index) then
        --按钮为灰色
        local SureBtn = tolua.cast(LaLaViewUpdataOwner["SureBtn"], "CCMenuItemImage")
        SureBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn2_2.png"))
        SureBtn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn2_2.png"))
    end
    -- 显示 相应的信息
    -- 获得 合体基座名称    SubstrateName 
    local SubstrateName = tolua.cast(LaLaViewUpdataOwner["SubstrateName"], "CCLabelTTF")
    SubstrateName:setString(conf_Attr.name)
    --LightIconSprite
    local LightIconSprite = tolua.cast(LaLaViewUpdataOwner["LightIconSprite"], "CCSprite")
    LightIconSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("lala0%d_icon.png", _index)))
    -- 获得 当前Lv等级 LvName
    local LvName = tolua.cast(LaLaViewUpdataOwner["LvName"], "CCLabelTTF")
    local NameLvCount = userdata:getFormSevenLv(_index)
    NameLvCount= (NameLvCount == 5) and "Max" or NameLvCount
    LvName:setString("Lv." .. NameLvCount)
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/LaLaViewUpdata.ccbi", proxy, true, "LaLaViewUpdataOwner")
    _layer = tolua.cast(node,"CCLayer")

    _refreshData()
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(LaLaViewUpdataOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction(LaLaViewUpdataOwner, "infoBg", _layer)
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
    local menu = tolua.cast(LaLaViewUpdataOwner["menu"], "CCMenu")
    menu:setTouchPriority(_priority - 2)
end

function getLaLaViewUpdataOwnerLayer()
    return _layer
end

function createLaLaViewUpdataLayer(index , priority)
    _priority = (priority ~= nil) and priority or -132
    _index = index
    _init()

    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
        popUpUiAction(LaLaViewUpdataOwner, "infoBg")
    end

    local function _onExit()
        _layer = nil
        _priority = nil
        _index = nil
    end

    --onEnter onExit
    local function _layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        end
    end

    _layer:registerScriptTouchHandler(onTouch ,false , _priority ,true )
    _layer:setTouchEnabled(true)
    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end