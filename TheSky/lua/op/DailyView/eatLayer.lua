local _layer
local _data = nil

EatViewOwner = EatViewOwner or {}
ccb["EatViewOwner"] = EatViewOwner

-- 刷新UI
local function _refreshUI()
    local eatBg2 = tolua.cast(EatViewOwner["eatBg2"], "CCSprite")
    local eatBg3 = tolua.cast(EatViewOwner["eatBg3"], "CCSprite")
    eatBg2:setVisible(false)
    eatBg3:setVisible(false)

    local eatBtn1 = tolua.cast(EatViewOwner["eatBtn1"], "CCMenuItemImage")
    local eatBtn2 = tolua.cast(EatViewOwner["eatBtn2"], "CCMenuItemImage")
    local kaichiLabel1 = tolua.cast(EatViewOwner["kaichiLabel1"], "CCSprite")
    local kaichiLabel2 = tolua.cast(EatViewOwner["kaichiLabel2"], "CCSprite")
    eatBtn1:setVisible(false)
    eatBtn2:setVisible(false)
    kaichiLabel1:setVisible(false)
    kaichiLabel2:setVisible(false)

    local layer1 = tolua.cast(EatViewOwner["layer1"], "CCLayer") -- 吃第一轮UI
    local layer2 = tolua.cast(EatViewOwner["layer2"], "CCLayer") -- 吃第二轮UI
    local menu1 = tolua.cast(EatViewOwner["menu1"], "CCMenu")   -- 吃第一轮menu
    local menu2 = tolua.cast(EatViewOwner["menu2"], "CCMenu")   -- 吃第二轮menu

    -- 判断是否显示第二轮
    local flag = (_data.status1 == 1 and _data.eatDumplingStatus["0"] == 1 and _data.eatDumplingStatusGold["0"] == 0) 
        or (_data.status2 == 1 and _data.eatDumplingStatus["1"] == 1 and _data.eatDumplingStatusGold["1"] == 0)
    layer1:setVisible(not flag)
    layer2:setVisible(flag)
    menu1:setVisible(not flag)
    menu2:setVisible(flag)

    if _data.status1 == 1 or _data.status2 == 1 then
        -- 有东西吃了
        eatBg3:setVisible(true)
    else 
        -- 还在做饭中
        eatBg2:setVisible(true)
    end 

    for i=0,1 do
        local str = tolua.cast(EatViewOwner["str"..(i + 1)], "CCLabelTTF")
        str:setString(HLNSLocalizedString("extra.str", _data.eatWithGold[tostring(i)].add))
        local gold = tolua.cast(EatViewOwner["gold"..(i + 1)], "CCLabelTTF")
        gold:setString(_data.eatWithGold[tostring(i)].gold)
        local vip = tolua.cast(EatViewOwner["vip"..(i + 1)], "CCSprite")
        local vipLimit = _data.eatWithGold[tostring(i)].vipLimit
        vip:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("VIP_%d.png", vipLimit)))
    end

    local eatLabel1 = tolua.cast(EatViewOwner["eatLabel1"], "CCLabelTTF")
    local eatLabel2 = tolua.cast(EatViewOwner["eatLabel2"], "CCLabelTTF")
    if _data.status1 == 1 and _data.eatDumplingStatus["0"] == 0 then
        -- 中午开饭时间到了,并且没吃
        eatBtn1:setVisible(true)
        kaichiLabel1:setVisible(true)
    else
        if _data.eatDumplingStatus["0"] == 1 then
            eatLabel1:setString(HLNSLocalizedString("吃过了"))
        else 
            if _data.status1 == 0 then
                eatLabel1:setString(HLNSLocalizedString("还没开饭"))
            elseif _data.status1 == 2 then
                eatLabel1:setString(HLNSLocalizedString("时间过了"))
            end
        end 
    end 
    if _data.status2 == 1 and _data.eatDumplingStatus["1"] == 0 then
        -- 中午开饭时间到了,并且没吃
        eatBtn2:setVisible(true)
        kaichiLabel2:setVisible(true)
    else
        if _data.eatDumplingStatus["1"] == 1 then
            eatLabel2:setString(HLNSLocalizedString("吃过了"))
        else 
            if _data.status2 == 0 then
                eatLabel2:setString(HLNSLocalizedString("还没开饭"))
            elseif _data.status2 == 2 then
                eatLabel2:setString(HLNSLocalizedString("时间过了"))
            end
        end 
    end 
end

-- 通知的回调函数
local function _updateUIStatus()
    _data = dailyData:getEatData()
    if _data then
        _refreshUI()
    end
    postNotification(NOTI_DAILY_STATUS, nil)
end

local function eatCallBack( url,rtnData )
    if rtnData["info"]["eatDumpling"] then
        dailyData:updateEatData(rtnData["info"][Daily_EatDumpling])
    end
    _updateUIStatus()
end 

-- 点击中午开吃按钮
local function onClickedEat1()
    print("onClickedEat1")
    Global:instance():TDGAonEventAndEventData("eating")
    doActionFun("DAILY_EAT_URL", {}, eatCallBack)
end
EatViewOwner["onClickedEat1"] = onClickedEat1

-- 点击晚上开吃按钮
local function onClickedEat2()
    print("onClickedEat2")
    Global:instance():TDGAonEventAndEventData("eating")
    doActionFun("DAILY_EAT_URL", {}, eatCallBack)
end
EatViewOwner["onClickedEat2"] = onClickedEat2

-- 额外美食
local function goldEatClick(tag)
    local vipLimit = tonumber(_data.eatWithGold[tostring(tag - 1)].vipLimit)
    if vipdata:getVipLevel() < vipLimit then
        ShowText(HLNSLocalizedString("extra.vip", vipLimit))
        return
    end
    local gold = tonumber(_data.eatWithGold[tostring(tag - 1)].gold)
    if gold > userdata.gold then
        ShowText(HLNSLocalizedString("ERR_1101"))
        getMainLayer():addChild(createShopRechargeLayer(-140), 100)
        return
    end
    doActionFun("DAILY_EAT_URL", {tag - 1}, eatCallBack)
end
EatViewOwner["goldEatClick"] = goldEatClick

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/EatView.ccbi",proxy, true,"EatViewOwner")
    _layer = tolua.cast(node,"CCLayer")

    _updateUIStatus()
end

-- 该方法名字每个文件不要重复
function getEatLayer()
	return _layer
end

function createEatLayer()
    _init()

    -- function _layer:showLayer()
    --     _changeState(runtimeCache.newWorldState)
    -- end

    local function _onEnter()
    	-- _changeState(runtimeCache.newWorldState)
        addObserver(NOTI_EAT_CD, _updateUIStatus)
    end

    local function _onExit()
        _layer = nil
        _data = nil
        removeObserver(NOTI_EAT_CD, _updateUIStatus)
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