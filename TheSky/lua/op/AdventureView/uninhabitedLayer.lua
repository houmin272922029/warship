local _layer
local ITEM_ID = "item_038"

local lastGet = nil
local newGet = nil

local lastHaki = nil
local newHaki = nil

local scheduler = CCDirector:sharedDirector():getScheduler()

UninhabitedOwner = UninhabitedOwner or {}
ccb["UninhabitedOwner"] = UninhabitedOwner

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local proxy = CCBProxy:create()
    local node = CCBReaderLoad("ccbResources/UninhabitedView.ccbi", proxy, true, "UninhabitedOwner")
    _layer = tolua.cast(node,"CCLayer")
end

local function hakiGetUpdate()
    local hakiGet = tolua.cast(UninhabitedOwner["hakiGet"], "CCLabelTTF")
    if not lastGet or not newGet or lastGet == newGet then
        hakiGet:setScale(1)
        return
    end
    lastGet = math.min(lastGet + 1, newGet)
    hakiGet:setString(lastGet)
    hakiGet:setScale(1.2)
end

local function hakiNowUpdate()
    local haki = tolua.cast(UninhabitedOwner["haki"], "CCLabelTTF")
    if not lastHaki or not newHaki or lastHaki == newHaki then
        haki:setScale(1)
        return
    end
    lastHaki = math.min(lastHaki + 1, newHaki)
    haki:setString(lastHaki)
    haki:setScale(1.2)
end

local function startItemClick()
    local function callback(url, rtnData)
        uninhabitedData.data = rtnData.info
        lastGet = uninhabitedData:getCurBlood()
        newGet = uninhabitedData:getCurBlood()
        _layer:refreshLayer(true)
    end
    doActionFun("UNINHABITED_START", {}, callback)
end
UninhabitedOwner["startItemClick"] = startItemClick

local function enhance(type)
    local function callback(url, rtnData)
        uninhabitedData.data = rtnData.info
        local function showResultLayer(lastType)
            local layer = CCLayerColor:create(ccc4(0, 0, 0, 200))
            layer:setContentSize(CCSizeMake(winSize.width, winSize.height))
            CCDirector:sharedDirector():getRunningScene():addChild(layer)
            local sp1 = CCSprite:createWithSpriteFrameName("result_1_" .. lastType .. ".png")
            local sp2 = CCSprite:createWithSpriteFrameName("result_2_" .. lastType .. ".png")
            sp1:setScale(retina)
            sp2:setScale(retina)
            sp1:setAnchorPoint(ccp(0.5, 0.5))
            sp2:setAnchorPoint(ccp(0.5, 0.5))
            sp1:setPosition(winSize.width + sp1:getContentSize().width / 2, winSize.height / 2 + 52 * retina)
            sp2:setPosition(winSize.width + sp2:getContentSize().width / 2, winSize.height / 2 - 22 * retina)
            local function moveAction(sender)
                local arr = CCArray:create()
                local _, y = sender:getPosition()
                local size = sender:getContentSize()
                arr:addObject(CCEaseBounceOut:create(CCMoveTo:create(0.2, ccp(winSize.width / 2, y))))
                arr:addObject(CCDelayTime:create(1))
                arr:addObject(CCEaseSineOut:create(CCMoveTo:create(0.2, ccp(-size.width / 2, y))))
                sender:runAction(CCSequence:create(arr))
            end
            layer:addChild(sp1)
            layer:addChild(sp2)
            local function move()
                sp1:runAction(CCCallFuncN:create(moveAction))
                sp2:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.1), CCCallFuncN:create(moveAction)))
            end
            local function remove()
                layer:removeFromParentAndCleanup(true)
            end
            local array = CCArray:create()
            array:addObject(CCCallFunc:create(move))
            array:addObject(CCDelayTime:create(1.5))
            array:addObject(CCCallFunc:create(remove))
            layer:runAction(CCSequence:create(array))
            
            local function onTouchBegan(x, y)
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
            layer:registerScriptTouchHandler(onTouch, false, -999, true)
            layer:setTouchEnabled(true)
        end
        local function resultLayer()
            local lastType = uninhabitedData.data.aggress.exercise.lastType
            showResultLayer(lastType)
        end
        local function refresh()
            _layer:refreshLayer(true)
        end
        local array = CCArray:create()
        array:addObject(CCCallFunc:create(resultLayer))
        array:addObject(CCDelayTime:create(1.5))
        array:addObject(CCCallFunc:create(refresh))
        _layer:runAction(CCSequence:create(array))
    end
    doActionFun("UNINHABITED_ENHANCE", {type}, callback)
end

local function continueItemClick()
    enhance(1)
end
UninhabitedOwner["continueItemClick"] = continueItemClick

local function useItemClick()
    enhance(2)
end
UninhabitedOwner["useItemClick"] = useItemClick

local function endItemClick()
    local function callback(url, rtnData)
        uninhabitedData.data = rtnData.info
        _layer:refreshLayer(true)
    end
    doActionFun("UNINHABITED_END", {}, callback)
end
UninhabitedOwner["endItemClick"] = endItemClick

local function gotoItemClick()
    runtimeCache.teamState = 2
    getMainLayer():gotoTeam()
end
UninhabitedOwner["gotoItemClick"] = gotoItemClick

local function helpItemClick()
    --弹出帮助界面
    local desc = ConfigureStorage.aggress_desp1
    local array = {}
    for i = 1, table.getTableCount(desc) do
        array[#array + 1] = desc["aggdesp_" .. i].desp
    end
    getMainLayer():getParent():addChild(createCommonHelpLayer(array, -140))
end
UninhabitedOwner["helpItemClick"] = helpItemClick

-- 该方法名字每个文件不要重复
function getUninhabitedLayer()
	return _layer
end

local function refreshHaki()
end

local function refreshLayer(ani)
    -- {"info":{"aggress":{"exercise":{"isExing":0,"exTimes":0,"lastType":0,"curBlood":"","enhance":0}}},"code":200}

    local gold = tolua.cast(UninhabitedOwner["gold"], "CCLabelTTF")
    gold:setString(userdata.gold)
    gold:setVisible(true)
    local haki = tolua.cast(UninhabitedOwner["haki"], "CCLabelTTF")
    haki:setVisible(true)
    local hakiGet = tolua.cast(UninhabitedOwner["hakiGet"], "CCLabelTTF")
    if not ani then
        hakiGet:setString(uninhabitedData:getCurBlood())
        lastGet = uninhabitedData:getCurBlood()
        haki:setString(userdata.haki)
        lastHaki = userdata.haki
    else
        newGet = uninhabitedData:getCurBlood()
        newHaki = userdata.haki
    end

    local state = uninhabitedData:getState()
    
    local startLayer = tolua.cast(UninhabitedOwner["startLayer"], "CCLayer")
    local startItem = tolua.cast(UninhabitedOwner["startItem"], "CCMenuItem")
    startLayer:setVisible(state == 0)
    startItem:setVisible(state == 0)
    local endLayer = tolua.cast(UninhabitedOwner["endLayer"], "CCLayer")
    local endItem = tolua.cast(UninhabitedOwner["endItem"], "CCMenuItem")
    endLayer:setVisible(state == 2)
    endItem:setVisible(state == 2)
    local trainLayer = tolua.cast(UninhabitedOwner["trainLayer"], "CCLayer")
    local stopItem = tolua.cast(UninhabitedOwner["stopItem"], "CCMenuItem")
    local continueItem = tolua.cast(UninhabitedOwner["continueItem"], "CCMenuItem")
    local useItem = tolua.cast(UninhabitedOwner["useItem"], "CCMenuItem")
    trainLayer:setVisible(state == 1)
    stopItem:setVisible(state == 1)
    continueItem:setVisible(state == 1)
    useItem:setVisible(state == 1)

    local status = tolua.cast(UninhabitedOwner["status"], "CCLayer")
    status:setVisible(state ~= 0)


    if state == 0 then
        local time, cost = uninhabitedData:getStartCost()
        local startCostIcon = tolua.cast(UninhabitedOwner["startCostIcon"], "CCSprite")
        startCostIcon:setVisible(cost ~= 0)
        for i=1,2 do
            local base = tolua.cast(UninhabitedOwner["base" .. i], "CCLabelTTF")
            base:setString(uninhabitedData:getCurBlood())
            local free = tolua.cast(UninhabitedOwner["free" .. i], "CCLabelTTF")
            free:setVisible(cost == 0)
            local startCost = tolua.cast(UninhabitedOwner["startCost" .. i], "CCLabelTTF")
            startCost:setVisible(cost ~= 0)
            if cost == 0 then
                free:setString(string.format("%d/%d", time, uninhabitedData:getStartFreeCount()))
            else
                startCost:setString(cost)
            end
        end
    elseif state == 1 then
        local itemCount = wareHouseData:getItemCount(ITEM_ID)
        useItem:setVisible(itemCount > 0)
        local useIcon = tolua.cast(UninhabitedOwner["useIcon"], "CCSprite")
        useIcon:setVisible(itemCount > 0)
        for i=1,2 do
            local useLabel = tolua.cast(UninhabitedOwner["useLabel" .. i], "CCLabelTTF")
            local uCost = tolua.cast(UninhabitedOwner["uCost" .. i], "CCLabelTTF")
            useLabel:setVisible(itemCount > 0)
            uCost:setVisible(itemCount > 0)
            local cCost = tolua.cast(UninhabitedOwner["cCost" .. i], "CCLabelTTF")
            cCost:setString(uninhabitedData:getEnhanceCost())
        end

    end
end

-- 刷新无人岛数据
local function getUninhabitedInfo()
    local function callback(url, rtnData)
        uninhabitedData.data = rtnData.info
        _layer:refreshLayer()
    end
    doActionFun("UNINHABITED_INFO", {}, callback) 
end

function createUninhabitedLayer()
    _init()
    local hakiGetUpdateFun = scheduler:scheduleScriptFunc(hakiGetUpdate, 0.01, false)
    local hakiNowUpdateFun = scheduler:scheduleScriptFunc(hakiNowUpdate, 0.01, false)

    function _layer:getInfo()
        getUninhabitedInfo()
    end

    function _layer:refreshLayer(ani)
        refreshLayer(ani)
    end

    local function _onEnter()

    end

    local function _onExit()
        _layer = nil
        lastGet = nil
        newGet = nil
        lastHaki = nil
        newHaki = nil
        scheduler:unscheduleScriptEntry(hakiGetUpdateFun)
        hakiGetUpdateFun = nil
        scheduler:unscheduleScriptEntry(hakiNowUpdateFun)
        hakiNowUpdateFun = nil
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
