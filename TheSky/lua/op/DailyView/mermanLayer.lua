local _layer
local _data = nil

MermanViewOwner = MermanViewOwner or {}
ccb["MermanViewOwner"] = MermanViewOwner

-- 刷新UI
local function _refreshUI()
    if _data == nil then
        return
    end 

    local kissCount = tolua.cast(MermanViewOwner["kissCount"], "CCLabelTTF")
    if kissCount then
        kissCount:setString(HLNSLocalizedString("已亲吻%d/%d次", _data.successionDays, _data.worshipDays))
    end 

    local kissBtn = tolua.cast(MermanViewOwner["mouthBtn"], "CCMenuItemImage")

    -- renzhan
    local particleOnMouth = MermanViewOwner["mouthBtn"]:getChildByTag(321)
    if particleOnMouth then
        particleOnMouth:removeFromParentAndCleanup(true)
    end
    
    if _data.worshiped ~= 1 then
        HLAddParticleScale( "images/eff_onMouth.plist", MermanViewOwner["mouthBtn"], ccp(MermanViewOwner["mouthBtn"]:getContentSize().width / 2,MermanViewOwner["mouthBtn"]:getContentSize().height / 2), 5, 102, 321, 1/retina, 1/retina)
    else
        MermanViewOwner["mouthBtn"]:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("mouthBtn_2.png"))
        MermanViewOwner["mouthBtn"]:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("mouthBtn_2.png"))
    end
    -- 

    if _data.successionDays == _data.worshipDays then
        if kissBtn then
            kissBtn:setEnabled(false)
        end 
    end
end

MermanAnimation_LayerOwner = MermanAnimation_LayerOwner or {}
ccb["MermanAnimation_LayerOwner"] = MermanAnimation_LayerOwner

-- 嘴唇亲完美人鱼回到原位
local function onLipReturns()
    print("onLipReturns")
    _refreshUI()
    MermanViewOwner["mouthBtn"]:setEnabled(true)
    MermanViewOwner["mouthBtn"]:setDisabledSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("mouthBtn_2.png"))
    if _data.worshiped == 1 then
        MermanAnimation_LayerOwner["lip"]:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("mouthBtn_2.png"))
    end
end
MermanAnimation_LayerOwner["onlipReturns"] = onLipReturns

local function kissCallBack( url,rtnData )
    -- renzhan
    -- if _data.worshipStatus ~= 1 then
    --     ShowText(HLNSLocalizedString("连续不断的亲吻下去，公主一定不会辜负你，\r\n小小的努力会换来巨大的收获噢！"))
    -- end
    -- 
    -- renzhan newAdd
    if _data.worshipStatus ~= 1 then
        if _data.worshipDays == 3 and _data.successionDays == 0 then
            ShowText(HLNSLocalizedString("距离获得奖励还有两天！"))
        elseif _data.worshipDays == 3 and _data.successionDays == 1 then
            ShowText(HLNSLocalizedString("明天再亲一次即可获得奖励！"))
        else
            local randomNum = RandomManager.randomRange(0, 2)
            if randomNum == 0 then
                ShowText(HLNSLocalizedString("公主对你有好感了!保持住！"))
            elseif randomNum == 1 then
                ShowText(HLNSLocalizedString("害羞的公主你见过吗？明天试试？"))
            else
                ShowText(HLNSLocalizedString("据说亲吻越多奖励越丰厚！"))
            end            
        end
    end
    -- 

    if rtnData["info"]["worship"] then
        dailyData:updateMermanData(rtnData["info"][Daily_Worship])
    end
    _data = dailyData:getMermanData()
    postNotification(NOTI_DAILY_STATUS, nil)
    _refreshUI()

    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/DialyMermanAnimationView.ccbi",proxy,true,"MermanAnimation_LayerOwner")
    _layer:addChild(node)

    MermanViewOwner["mouthBtn"]:setEnabled(false)
    MermanViewOwner["mouthBtn"]:setDisabledSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("mouthBtn_0.png"))
end 

-- 点击中午开吃按钮
local function onKissClicked()
    Global:instance():TDGAonEventAndEventData("kiss")
    -- if _data.worshiped == 1 then 
    --     ShowText(HLNSLocalizedString("公主今天已经休息了，想见她就明天再来吧！"))     
    --     return
    -- else
    --     if _data.worshipStatus == 1 then
    --         ShowText(HLNSLocalizedString("你昨天没来吧？公主好像忘了你亲过几次了！\r\n请重头再来吧！"))
    --     end
    -- end 

    -- renzhan newAdd
    if _data.worshiped == 1 then
        local randomNum = RandomManager.randomRange(0, 2)
        if randomNum == 0 then
            ShowText(HLNSLocalizedString("不要再占公主便宜啦！"))
        elseif randomNum == 1 then
            ShowText(HLNSLocalizedString("公主害羞了，放过她吧！"))
        else
            ShowText(HLNSLocalizedString("亲多了公主会生气哦！"))
        end
        
        return
    end
    if _data.worshipStatus == 1 then
        ShowText(HLNSLocalizedString("公主生气了，重头再来吧！")) 
    end
    -- 

    doActionFun("DAILY_WORSHIP_URL", {}, kissCallBack)
end
MermanViewOwner["onKissClicked"] = onKissClicked

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/DailyMermanView.ccbi",proxy, true,"MermanViewOwner")
    _layer = tolua.cast(node,"CCLayer")

    _data = dailyData:getMermanData()
    _refreshUI()
end

-- 该方法名字每个文件不要重复
function getMermanLayer()
	return _layer
end

function createMermanLayer()
    _init()

    local function _onEnter()
    end

    local function _onExit()
        _layer = nil
        _data = nil
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

    return _layer
end