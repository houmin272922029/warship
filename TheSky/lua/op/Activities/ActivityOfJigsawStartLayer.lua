local _layer
local _priority = -132
local _tableView
local _data
local map
local _VipPos
local _bAni = false

--活动主界面 开始拼图
-- 名字不要重复
ActivityOfJigsawStartOwner = ActivityOfJigsawStartOwner or {}
ccb["ActivityOfJigsawStartOwner"] = ActivityOfJigsawStartOwner

local function refresh()
    _data = loginActivityData.activitys[Activity_JigsawPuzzle]
    map = {}
    for i=1,16 do
        local sprite = tolua.cast(ActivityOfJigsawStartOwner["sprite" .. i], "CCSprite")
        sprite:setVisible(false)
    end
    
    if _data.logs and _data.logs.location then
        map = table.allKey(_data.logs.location.locationId) or {}
        if map then
            for k,v in pairs(map) do
               local sprite = tolua.cast(ActivityOfJigsawStartOwner["sprite" .. (tonumber(v) + 1)], "CCSprite")
                sprite:setVisible(true)
            end
            
        end
    end
   
    local SmiplePuzzleNum = tolua.cast(ActivityOfJigsawStartOwner["SmiplePuzzleNum"] , "CCLabelTTF")
    SmiplePuzzleNum:setString(tostring(HLNSLocalizedString("JigSaw_SimPlePuzzleNum") .. tonumber(wareHouseData:getItemCountById(_data.normalJigsaw.itemId))))

    local highPuzzleNum = tolua.cast(ActivityOfJigsawStartOwner["highPuzzleNum"] , "CCLabelTTF")
    highPuzzleNum:setString(tostring(HLNSLocalizedString("JigSaw_HighPuzzleNum") .. tonumber(wareHouseData:getItemCountById(_data.superJigsaw.itemId))))
    local descriptedLv = userdata:getVipLv()
    local descripted = tolua.cast(ActivityOfJigsawStartOwner["descripted"] , "CCLabelTTF")
    descripted:setString(tostring(HLNSLocalizedString("JigSaw_VIPQuickJigSaw", descriptedLv)))

    -- 十八个点亮 显示领取奖励按钮 ，普通碎片 、高级碎片隐藏
    
    local simpleBtn = tolua.cast(ActivityOfJigsawStartOwner["simpleBtn"] , "CCMenuItemImage")
    local superBtn = tolua.cast(ActivityOfJigsawStartOwner["superBtn"] , "CCMenuItemImage")
    local putongsuipian_text = tolua.cast(ActivityOfJigsawStartOwner["putongsuipian_text"] , "CCSprite")
    local gaojisuipian_text = tolua.cast(ActivityOfJigsawStartOwner["gaojisuipian_text"] , "CCSprite")
    local rewardBtn = tolua.cast(ActivityOfJigsawStartOwner["rewardBtn"] , "CCMenuItemImage")
    local linqujiangli_text = tolua.cast(ActivityOfJigsawStartOwner["linqujiangli_text"] , "CCSprite")
    putongsuipian_text:setVisible(tonumber(getMyTableCount(map)) ~= 16)
    simpleBtn:setVisible(tonumber(getMyTableCount(map)) ~= 16)
    superBtn:setVisible(tonumber(getMyTableCount(map)) ~= 16)
    gaojisuipian_text:setVisible(tonumber(getMyTableCount(map)) ~= 16)
    rewardBtn:setVisible(tonumber(getMyTableCount(map)) == 16)
    linqujiangli_text:setVisible(tonumber(getMyTableCount(map)) == 16)
    if tonumber(getMyTableCount(map)) == 0 or tonumber(getMyTableCount(map)) == 16 then
        local voice = tolua.cast(ActivityOfJigsawStartOwner["voice"] , "CCLabelTTF")
        voice:setString(HLNSLocalizedString("JigSaw_JigsawFirstShow"))
        local voice2 = tolua.cast(ActivityOfJigsawStartOwner["voice2"] , "CCLabelTTF")
        voice2:setString(HLNSLocalizedString("JigSaw_JigsawFirstShow"))
    end
end

local function animation(index)
    local function aniStart()
        _bAni = true
        local menu = tolua.cast(ActivityOfJigsawStartOwner["menu"], "CCMenu")
        menu:setTouchEnabled(false)
    end

    local function aniEnd()
        _bAni = false
        local menu = tolua.cast(ActivityOfJigsawStartOwner["menu"], "CCMenu")
        menu:setTouchEnabled(true)
    end

    local sprite = tolua.cast(ActivityOfJigsawStartOwner["sprite" .. index], "CCSprite")
    sprite:setVisible(true)
    sprite:setOpacity(0)

    local array = CCArray:create()
    array:addObject(CCCallFunc:create(aniStart))
    array:addObject(CCRepeat:create(CCSequence:createWithTwoActions(CCFadeIn:create(0.5), CCFadeOut:create(0.5)), 2))
    array:addObject(CCCallFunc:create(refresh))
    array:addObject(CCFadeIn:create(0.2))
    array:addObject(CCCallFunc:create(aniEnd))
    sprite:runAction(CCSequence:create(array))
end

local function closeItemClick()
    popUpCloseAction(ActivityOfJigsawStartOwner, "infoBg", _layer )
end
ActivityOfJigsawStartOwner["closeItemClick"] = closeItemClick

--高级碎片不足 ，购买并使用
local function needItemConfirmClick()
    --接口 refreshEscortCost
    local function callback(url, rtnData)
        local jigsawDic = rtnData.info.jigsawPuzzle
        for k,v in pairs(jigsawDic) do
            loginActivityData.activitys[Activity_JigsawPuzzle].logs = v
        end
        local data = loginActivityData.activitys[Activity_JigsawPuzzle].logs.location.locationId
        local temp = loginActivityData.activitys[Activity_JigsawPuzzle].logs
        local current = loginActivityData.activitys[Activity_JigsawPuzzle].logs.location.current
    
        if current then  --可以点亮
            -- TODO animation
            animation(tonumber(current) + 1)
            -- 拼接成功提示
            ShowText(HLNSLocalizedString("JigSaw_Suc"))
            local voice = tolua.cast(ActivityOfJigsawStartOwner["voice"] , "CCLabelTTF")
            voice:setString(HLNSLocalizedString("JigSaw_Suc_Chopper"))
            local voice2 = tolua.cast(ActivityOfJigsawStartOwner["voice2"] , "CCLabelTTF")
            voice2:setString(HLNSLocalizedString("JigSaw_Suc_Chopper"))
        end
    end
    --向服务器发送成功领取消息  uid 以及 id
    doActionFun("ACTIVITY_JIGSAWPUZZLE_HIGHTFLAGMENT", {_data.uid}, callback)
end

--VIP立即拼接 ，消耗金币购买
local function VipNeedItemConfirmClick()
    local function callback(url, rtnData)
        local jigsawDic = rtnData.info.jigsawPuzzle
        for k,v in pairs(jigsawDic) do
            loginActivityData.activitys[Activity_JigsawPuzzle].logs = v
        end
        --刷新页面
        refresh()
        -- 拼接成功提示
        ShowText(HLNSLocalizedString("JigSaw_Suc"))
        local voice = tolua.cast(ActivityOfJigsawStartOwner["voice"] , "CCLabelTTF")
        voice:setString(HLNSLocalizedString("JigSaw_Suc_Chopper"))
        local voice2 = tolua.cast(ActivityOfJigsawStartOwner["voice2"] , "CCLabelTTF")
        voice2:setString(HLNSLocalizedString("JigSaw_Suc_Chopper"))
    end
    --向服务器发送成功领取消息  uid 以及 position 
    doActionFun("ACTIVITY_JIGSAWPUZZLE_VIPFLAGMENT", {_data.uid , _VipPos}, callback)
end

--普通碎片
local function simpleBtnTaped()

    --接口 refreshEscortCost
    local function callback(url, rtnData)
        local jigsawDic = rtnData.info.jigsawPuzzle
        for k,v in pairs(jigsawDic) do
            loginActivityData.activitys[Activity_JigsawPuzzle].logs = v
        end
        local data = loginActivityData.activitys[Activity_JigsawPuzzle].logs.location.locationId
        local temp = loginActivityData.activitys[Activity_JigsawPuzzle].logs
        local current = loginActivityData.activitys[Activity_JigsawPuzzle].logs.location.current
    
        if current then  --可以点亮
            -- TODO animation
            animation(tonumber(current) + 1)
            -- 拼接成功提示
            ShowText(HLNSLocalizedString("JigSaw_Suc"))
            local voice = tolua.cast(ActivityOfJigsawStartOwner["voice"] , "CCLabelTTF")
            voice:setString(HLNSLocalizedString("JigSaw_Suc_Chopper"))
            local voice2 = tolua.cast(ActivityOfJigsawStartOwner["voice2"] , "CCLabelTTF")
            voice2:setString(HLNSLocalizedString("JigSaw_Suc_Chopper"))
        else
            local voice = tolua.cast(ActivityOfJigsawStartOwner["voice"] , "CCLabelTTF")
            voice:setString(HLNSLocalizedString("JigSaw_Fai_Chopper"))
            local voice2 = tolua.cast(ActivityOfJigsawStartOwner["voice2"] , "CCLabelTTF")
            voice2:setString(HLNSLocalizedString("JigSaw_Fai_Chopper"))
            refresh()
        end
    end
    --向服务器发送成功领取消息  uid 以及 id
    doActionFun("ACTIVITY_JIGSAWPUZZLE_FLAGMENT", {_data.uid}, callback)
end
ActivityOfJigsawStartOwner["simpleBtnTaped"] = simpleBtnTaped

-- 高级碎片
local function advancedBtnTaped()

    --判断玩家是否有高级碎片 ,弹出是否购买并使用窗口

    -- 通过itemId 获得该物品的数量
    if tonumber(wareHouseData:getItemCount(_data.superJigsaw.itemId)) - tonumber(_data.superJigsaw.amount) < 0 then
        local name = wareHouseData:getItemConfig(ConfigureStorage.openFormSevenItem.itemId).name
        local goldSpend = _data.superJigsaw.gold
        local text = HLNSLocalizedString("JigSaw_BuyAndSpend",goldSpend,name, name)
        CCDirector:sharedDirector():getRunningScene():addChild(createSimpleConfirCardLayer(text))
        SimpleConfirmCard.confirmMenuCallBackFun = needItemConfirmClick
        SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction 
    else

        --接口 refreshEscortCost
        local function callback(url, rtnData)
            local jigsawDic = rtnData.info.jigsawPuzzle
            for k,v in pairs(jigsawDic) do
                loginActivityData.activitys[Activity_JigsawPuzzle].logs = v
            end
            local temp = loginActivityData.activitys[Activity_JigsawPuzzle].logs
            local current = loginActivityData.activitys[Activity_JigsawPuzzle].logs.location.current
        
            if current then  --可以点亮
                -- TODO animation
                animation(tonumber(current) + 1)
                -- 拼接成功提示
                ShowText(HLNSLocalizedString("JigSaw_Suc"))
                local voice = tolua.cast(ActivityOfJigsawStartOwner["voice"] , "CCLabelTTF")
                voice:setString(HLNSLocalizedString("JigSaw_Suc_Chopper"))
                local voice2 = tolua.cast(ActivityOfJigsawStartOwner["voice2"] , "CCLabelTTF")
                voice2:setString(HLNSLocalizedString("JigSaw_Suc_Chopper"))

            end
        end
        --向服务器发送成功领取消息  uid 以及 id
        doActionFun("ACTIVITY_JIGSAWPUZZLE_HIGHTFLAGMENT", {_data.uid}, callback)
    end
end
ActivityOfJigsawStartOwner["advancedBtnTaped"] = advancedBtnTaped

--领取奖励
local function rewardBtnTaped()
    --接口 refreshEscortCost
    local function callback(url, rtnData)
        local jigsawDic = rtnData.info.jigsawPuzzle
        for k,v in pairs(jigsawDic) do
            loginActivityData.activitys[Activity_JigsawPuzzle].logs = v
        end
        refresh()
    end
    --向服务器发送成功领取消息  uid 以及 id
    doActionFun("ACTIVITY_JIGSAWPUZZLE_REWARD", {_data.uid}, callback)
end
ActivityOfJigsawStartOwner["rewardBtnTaped"] = rewardBtnTaped


local function setMenuPriority()
    local menu = tolua.cast(ActivityOfJigsawStartOwner["menu"], "CCMenu")
    menu:setTouchPriority(_priority - 2)
end

local function addSpriteTouch()
    local touchLayer = tolua.cast(ActivityOfJigsawStartOwner["touchLayer"], "CCLayer")

    local function onTouchBegan(x, y)
        if _bAni then
            return true
        end
        local touchLocation = touchLayer:convertToNodeSpace(ccp(x, y))
        for i=1,16 do
            local layer = tolua.cast(ActivityOfJigsawStartOwner["layer" .. i], "CCSprite")
            local rect = layer:boundingBox()
            if rect:containsPoint(touchLocation) then
                -- 点击位置 调用vip直接点亮接口
                --1 、判断玩家vip等级大于3
                local vipLv = userdata:getVipLv()
                if userdata.level >= tonumber(vipLv) then
                    -- 2、查看立即拼接次数
                     _data = loginActivityData.activitys[Activity_JigsawPuzzle]
                    if _data.logs and _data.logs.location then
                        local times = _data.logs.vipConfig.availableTimes
                        _VipPos = i - 1
                        amount = _data.logs.location.amount
                        local vipPrices = tonumber(_data.vipPrices[tostring(amount)])
                        if tonumber(times) > 0 then
                            --[[
                                vipPrices 当前vip拼接点击消耗金币数量
                                vipTimes vip能拼接次数
                                nextVip  当前玩家vip等级 + 1
                                nextVipTimes  下一vip等级能拼接次数
                            ]]
                            local vipTimes
                            local nextVipTimes
                            local nextVip
                            if _data.logs and _data.logs.vipConfig then
                                availableTimes = tonumber(_data.logs.vipConfig.availableTimes) 
                                nextVip = userdata:getVipLevel()                              
                                if tonumber(nextVip) == tonumber(getMyTableCount(ConfigureStorage.vipConfig) - 1) then
                                    nextVip = tonumber(getMyTableCount(ConfigureStorage.vipConfig) - 1)
                                    nextVipTimes = ConfigureStorage.vipConfig[nextVip + 1].SP
                                else
                                    nextVip = nextVip + 1
                                    -- modified by 赵艳秋20150825，vipConfig是个从0开始的数组，取等级次数时要先把等级加1，
                                    -- 比如取VIP10的次数，要取数组的第11个值
                                    -- nextVipTimes = ConfigureStorage.vipConfig[nextVip].SP
                                    nextVipTimes = ConfigureStorage.vipConfig[nextVip + 1].SP
                                end
                            else
                                vipTimes = 0
                            end
                            print("vipPrices",vipPrices)
                            print("vipTimes",availableTimes)
                            print("nextVip",nextVip)
                            print("nextVipTimes",nextVipTimes)
                            print("tonumber(getMyTableCount(ConfigureStorage.vipConfig) - 1)",tonumber(getMyTableCount(ConfigureStorage.vipConfig) - 1))
                            -- 弹出对话框 是否使用立即拼接功能？需消耗金币
                            local name = wareHouseData:getItemConfig(ConfigureStorage.openFormSevenItem.itemId).name
                            local text = HLNSLocalizedString("JigSaw_VipJigsawFunction",vipPrices,availableTimes,nextVip,nextVipTimes,name, name)
                            CCDirector:sharedDirector():getRunningScene():addChild(createSimpleConfirCardLayer(text))
                            SimpleConfirmCard.confirmMenuCallBackFun = VipNeedItemConfirmClick
                            SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction   
                        else
                            --vip 立即拼接次数已用完
                            ShowText(HLNSLocalizedString("ERR_2254"))
                            local voice = tolua.cast(ActivityOfJigsawStartOwner["voice"] , "CCLabelTTF")
                            voice:setString(HLNSLocalizedString("ERR_2254"))
                            local voice2 = tolua.cast(ActivityOfJigsawStartOwner["voice2"] , "CCLabelTTF")
                            voice2:setString(HLNSLocalizedString("ERR_2254"))
                        end      
                    end
                else
                    -- vip等级不足
                    ShowText(HLNSLocalizedString("JigSaw_vipLvNotEnough",vipLv)) 
                end
                break
            end
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

    touchLayer:registerScriptTouchHandler(onTouch, false, _priority - 1, false)
    touchLayer:setTouchEnabled(true)
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/ActivityOfJigsawStartView.ccbi", proxy, true,"ActivityOfJigsawStartOwner")
    _layer = tolua.cast(node,"CCLayer")

    refresh()
    addSpriteTouch()
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(ActivityOfJigsawStartOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction(ActivityOfJigsawStartOwner, "infoBg", _layer)
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

function getActivityOfJigsawStartLayer()
    return _layer
end

function createActivityOfJigsawStartLayer(priority)
    _priority = (priority ~= nil) and priority or -132
    _init()
    function _layer:refresh()
        refresh() 
    end
    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
        addObserver(NOTI_WW_REFRESH, refresh)
        popUpUiAction(ActivityOfJigsawStartOwner, "infoBg")
    end
    local function _onExit()
        removeObserver(NOTI_WW_REFRESH, refresh)
        _layer = nil
        _tableView = nil
        _priority = nil
        _data = nil
        _VipPos = nil
        _bAni = false
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