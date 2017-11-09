local _layer
local _priority = -132
local _data
local _betGold = 20
local _betBerry = 50000

local _status -- 当前时间段
local _mapIndex -- 选择的是哪个 就是tag值
local _vsIndex  -- 押注左方还是右方
local _betType   -- 选择的押注方式 金币、贝里
local _amount --押注的数量

local BET_TYPE = {
    gold = "gold",
    silver = "silver",
}

-- 名字不要重复
SSABetViewOwner = SSABetViewOwner or {}
ccb["SSABetViewOwner"] = SSABetViewOwner
-- 关闭
local function closeItemClick()
    popUpCloseAction(SSABetViewOwner, "infoBg", _layer )
end
SSABetViewOwner["closeItemClick"] = closeItemClick
-- 取消
local function cancelClick()
    popUpCloseAction(SSABetViewOwner, "infoBg", _layer )
end
SSABetViewOwner["cancelClick"] = cancelClick

local function _refreshData()
  -- 显示
   for i=1,2 do
        local servers = tolua.cast(SSABetViewOwner["servers" .. i] , "CCLabelTTF")
        local name = tolua.cast(SSABetViewOwner["name" .. i] , "CCLabelTTF")
        local level = tolua.cast(SSABetViewOwner["level" .. i] , "CCLabelTTF")
        servers:setString(_data.battleMap[tostring(_mapIndex)].vs[tostring(i - 1)].serverName)
        name:setString(_data.battleMap[tostring(_mapIndex)].vs[tostring(i - 1)].playerData.name)
        level:setString('LV'.. _data.battleMap[tostring(_mapIndex)].vs[tostring(i - 1)].playerData.level)
        local CCScale9SpriteLight = tolua.cast(SSABetViewOwner["CCScale9SpriteLight" .. i] , "CCSprite")
        if _vsIndex == i then
            CCScale9SpriteLight:setVisible(true)
        else
            CCScale9SpriteLight:setVisible(false)
        end
    end
    local goldBtn = tolua.cast(SSABetViewOwner["goldBtn"], "CCMenuItemImage")
    local silverBtn = tolua.cast(SSABetViewOwner["silverBtn"], "CCMenuItemImage")
    local gainsGoldSprite = tolua.cast(SSABetViewOwner["gainsGoldSprite"] , "CCSprite")
    local betGoldSprite = tolua.cast(SSABetViewOwner["betGoldSprite"] , "CCSprite")
    local bet = tolua.cast(SSABetViewOwner["bet"] , "CCLabelTTF")
    local gains = tolua.cast(SSABetViewOwner["gains"] , "CCLabelTTF")
    local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
    local goldIcon = tolua.cast(SSABetViewOwner["goldIcon"] , "CCSprite")
    local  goldbetLabel = tolua.cast(SSABetViewOwner["goldbetLabel"] , "CCLabelTTF")
    if _data.bet then
        if _data.bet.gold.isOpen == 0 then
            goldBtn:setVisible(false)
            goldbetLabel:setVisible(false)
            goldIcon:setVisible(false)
        end
        if _betType == BET_TYPE.gold then --金币
            -- 按钮状态改变
            goldBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("betChoose1.png"))
            goldBtn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("betChoose2.png"))
            silverBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("betChoose2.png"))
            silverBtn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("betChoose1.png"))
            betGoldSprite:setDisplayFrame(cache:spriteFrameByName("gold.png"))
            gainsGoldSprite:setDisplayFrame(cache:spriteFrameByName("gold.png"))
            bet:setString(_betGold)
            gains:setString(math.ceil(_betGold * _data.bet.gold.per))
            
        else
            goldBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("betChoose2.png"))
            goldBtn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("betChoose1.png"))
            silverBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("betChoose1.png"))
            silverBtn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("betChoose2.png"))
            -- 金币变成贝里 defaultGoldSprite betGoldSprite bet gains
            gainsGoldSprite:setDisplayFrame(cache:spriteFrameByName("berry.png"))
            betGoldSprite:setDisplayFrame(cache:spriteFrameByName("berry.png"))
            bet:setString(_betBerry)
            gains:setString(math.ceil(_betBerry * _data.bet.silver.per))
        end
    end
end

-- 默认金币
local function goldItemClick()
    _betType = BET_TYPE.gold
   _refreshData()
end
SSABetViewOwner["goldItemClick"] = goldItemClick

local function silverItemClick()
   _betType = BET_TYPE.silver
   _refreshData()
end
SSABetViewOwner["silverItemClick"] = silverItemClick

-- 点击的当前玩家
local function betBtnClick(tag)
    _vsIndex = tag   
    _refreshData()
end
SSABetViewOwner["betBtnClick"] = betBtnClick

local function rreduceItemClick()
    if _betType == BET_TYPE.gold then
        if _betGold == 20 then
            return
        end
        _betGold = math.max(20, _betGold - 200)
    else
        if _betBerry == 50000 then
            return
        end
        _betBerry = math.max(50000, _betBerry - 500000)
    end
    _refreshData()
end
SSABetViewOwner["rreduceItemClick"] = rreduceItemClick

local function reduceItemClick()
    if _betType == BET_TYPE.gold then
        if _betGold == 20 then
            return
        end
        _betGold = math.max(20, _betGold - 20)
    else
        if _betBerry == 50000 then
            return
        end
        _betBerry = math.max(50000, _betBerry - 50000)
    end
    _refreshData()
end
SSABetViewOwner["reduceItemClick"] = reduceItemClick

local function addItemClick()
    if _betType == BET_TYPE.gold then
        if _betGold + 20 > userdata.gold then
            HLNSLocalizedString("ERR_1101")
            getMainLayer():getParent():addChild(createShopRechargeLayer(_priority - 2), 210)
            return
        end
        if _betGold + 20 > 1000 then
            ShowText(HLNSLocalizedString("SSA.betLimited"))
            _betGold = 1000
            _refreshData()
            return
        end
        _betGold = _betGold + 20
    else
        if _betBerry + 50000 > userdata.berry then
            HLNSLocalizedString("ERR_1102")
            return
        end
        if _betBerry + 50000 > 10000000 then
            ShowText(HLNSLocalizedString("SSA.betLimited"))
            _betBerry = 10000000
            _refreshData()
            return
        end
        _betBerry = _betBerry + 50000
    end
    _refreshData()
end
SSABetViewOwner["addItemClick"] = addItemClick

local function aaddItemClick()
    if _betType == BET_TYPE.gold then
        if _betGold + 200 > userdata.gold then
            ShowText(HLNSLocalizedString("ERR_1101"))
            getMainLayer():getParent():addChild(createShopRechargeLayer(_priority - 2), 210)
            return
        end
        if _betGold + 200 > 1000 then
            ShowText(HLNSLocalizedString("SSA.betLimited"))
            _betGold = 1000
            _refreshData()
            return
        end
        _betGold = _betGold + 200
    else
        if _betBerry + 500000 > userdata.berry then
            ShowText(HLNSLocalizedString("ERR_1102"))
            return
        end
        if _betBerry + 500000 > 10000000 then
            ShowText(HLNSLocalizedString("SSA.betLimited"))
            _betBerry = 10000000
            _refreshData()
            return
        end
        _betBerry = _betBerry + 500000
    end
    _refreshData()
end
SSABetViewOwner["aaddItemClick"] = aaddItemClick


-- 下注按钮回调
local function betItemClick()
    -- status mapIndex vsIndex betType amount 传入的四个数据
    if not _vsIndex then
        ShowText(HLNSLocalizedString("SSA.betShoose.noWin"))
        return
    end
    if _betType == BET_TYPE.gold then
        if _betGold > userdata.gold then
            ShowText(HLNSLocalizedString("ERR_1101"))
            getMainLayer():getParent():addChild(createShopRechargeLayer(_priority - 2), 210)
            return
        end
        _amount = _betGold
    else
        if _betBerry > userdata.berry then
            ShowText(HLNSLocalizedString("ERR_1102"))
            return
        end
        _amount = _betBerry
    end
    local function Callback(url, rtnData)
        print("下注成功了呀")
        ssaData.data = rtnData.info
        closeItemClick()
        getSSAFourKingContendViewLayer():_refresh()
    end
    doActionFun("CROSSSERVERBATTLE_BET",{_data.timeStatus ,_mapIndex , _vsIndex - 1 , _betType , _amount}, Callback)
    
end
SSABetViewOwner["betItemClick"] = betItemClick


-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/SSABetView.ccbi", proxy, true,"SSABetViewOwner")
    _layer = tolua.cast(node,"CCLayer")
    _betGold = 20
    _betBerry = 50000
    _refreshData()
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(SSABetViewOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction(SSABetViewOwner, "infoBg", _layer)
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
    local menu = tolua.cast(SSABetViewOwner["menu"], "CCMenu")
    menu:setTouchPriority(_priority - 2)
end

function getSSABetViewLayer()
	return _layer
end

function createSSABetViewLayer(data , tag)
    _data = data
    _betType = BET_TYPE.gold
    _mapIndex = tag - 1
    print("我的竞猜是出于哪个地图上",_mapIndex)
    PrintTable(_data)

    _priority = (priority ~= nil) and priority or -132
    _init()
    silverItemClick()

    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)

        popUpUiAction(SSABetViewOwner, "infoBg")
    end

    local function _onExit()
        _layer = nil
        _priority = nil
        _data = nil

        _betGold = nil
        _betBerry = nil

        _status  = nil-- 当前时间段
        _mapIndex = nil -- 选择的是哪个 就是tag值
        _vsIndex  = nil-- 押注左方还是右方
        _betType  = nil -- 选择的押注方式 金币、贝里
        _amount = nil--押注的数量
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