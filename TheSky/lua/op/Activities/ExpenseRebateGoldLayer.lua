local _layer
local _priority = -132
local _tableView
local _rebateData

-- 名字不要重复
ExpenseRebateGoldOwner = ExpenseRebateGoldOwner or {}
ccb["ExpenseRebateGoldOwner"] = ExpenseRebateGoldOwner

local function closeItemClick()
    -- _layer:removeFromParentAndCleanup(true)
    popUpCloseAction( ExpenseRebateGoldOwner,"infoBg", _layer )
end
ExpenseRebateGoldOwner["closeItemClick"] = closeItemClick


local function _addTableView()
    -- 得到数据
    _rebateData = loginActivityData:getExpenseRebateGoldData()

    ExpenseRebateCellOwner = ExpenseRebateCellOwner or {}
    ccb["ExpenseRebateCellOwner"] = ExpenseRebateCellOwner

    local content = ExpenseRebateGoldOwner["content"]

    local function rebateItemClick(tag)
        print("rebateItemClick", tag)
        local dic = _rebateData[tag]
        local text = HLNSLocalizedString("expenseRebateGold.tips", loginActivityData:getRebateDateWithIndex(tag ), 
            dic.goldCost, math.floor(dic.goldCost * loginActivityData.activitys[Activity_Rebate3].refundRate / 100))
        getMainLayer():getParent():addChild(createSimpleConfirCardLayer(text), 100)
        SimpleConfirmCard.confirmMenuCallBackFun = nil
        SimpleConfirmCard.cancelMenuCallBackFun = nil
    end
    ExpenseRebateCellOwner["rebateItemClick"] = rebateItemClick

    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(583, 115)
        elseif fn == "cellAtIndex" then
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            --单条数据
            local  proxy = CCBProxy:create()
            local  _hbCell  = tolua.cast(CCBReaderLoad("ccbResources/ExpenseRebateCell.ccbi",proxy,true,"ExpenseRebateCellOwner"),"CCLayer")

            local function setCellMenuPriority(sender)
                if sender then
                    local menu = tolua.cast(sender, "CCMenu")
                    menu:setHandlerPriority(_priority - 1)
                end
            end

            local menu = ExpenseRebateCellOwner["menu"]
            local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCCallFuncN:create(setCellMenuPriority))
            menu:runAction(seq)

            for i=1,5 do
                local index = a1 * 5 + i - 1
                local avatarBtn = tolua.cast(ExpenseRebateCellOwner["avatarBtn"..i], "CCMenuItem")
                local rebate = tolua.cast(ExpenseRebateCellOwner["rebate"..i], "CCSprite")
                local date = tolua.cast(ExpenseRebateCellOwner["date"..i], "CCLabelTTF")

                local dic = _rebateData[index + 1]
                if not dic then
                    avatarBtn:setVisible(false)
                    rebate:setVisible(false)
                    date:setVisible(false)
                else
                    avatarBtn:setVisible(true)
                    rebate:setVisible(true)
                    date:setVisible(true)
                    avatarBtn:setTag(index + 1)
                    if tonumber(dic.canTake) <= 0 then
                        -- 未领取或者还不能领取
                        rebate:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("rebate1.png"))
                    else
                        -- 已领取
                        rebate:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("rebate2.png"))
                    end
                    date:setString(loginActivityData:getRebateDateWithIndex(index+1))
                end
            end
            

            a2:addChild(_hbCell, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            r = a2
        elseif fn == "numberOfCells" then
            r = #_rebateData % 5 == 0 and #_rebateData / 5 or #_rebateData / 5 + 1
        elseif fn == "cellTouched" then         -- A cell was touched, a1 is cell that be touched. This is not necessary.
        elseif fn == "cellTouchBegan" then      -- A cell is touching, a1 is cell, a2 is CCTouch
        elseif fn == "cellTouchEnded" then      -- A cell was touched, a1 is cell, a2 is CCTouch
        elseif fn == "cellHighlight" then       -- A cell is highlighting, coco2d-x 2.1.3 or above
        elseif fn == "cellUnhighlight" then     -- A cell had been unhighlighted, coco2d-x 2.1.3 or above
        elseif fn == "cellWillRecycle" then     -- A cell will be recycled, coco2d-x 2.1.3 or above
        end
        return r
    end)

    local size = content:getContentSize()
    _tableView = LuaTableView:createWithHandler(h, size)
    _tableView:setBounceable(true)
    _tableView:setAnchorPoint(ccp(0,0))
    _tableView:setPosition(0,0)
    _tableView:setVerticalFillOrder(0)
    content:addChild(_tableView,1000)
end

local function _refreshData()
    _addTableView()

    local tips = tolua.cast(ExpenseRebateGoldOwner["tips"], "CCLabelTTF")
    tips:setString(loginActivityData.activitys[Activity_Rebate3].description["0"])

    local rewardLabel = tolua.cast(ExpenseRebateGoldOwner["rewardLabel"], "CCLabelTTF")
    if loginActivityData.activitys[Activity_Rebate3].rewardRecord.canTake == 1 then 
        rewardLabel:setString(0)
    else
        rewardLabel:setString(loginActivityData.activitys[Activity_Rebate3].rewardRecord.refundGold)
    end

    local title0 = tolua.cast(ExpenseRebateGoldOwner["title0"], "CCLabelTTF")
    local title1 = tolua.cast(ExpenseRebateGoldOwner["title1"], "CCLabelTTF")
    title0:setString(loginActivityData.activitys[Activity_Rebate3].name)
    title1:setString(loginActivityData.activitys[Activity_Rebate3].name)
end

local function consumeRefundCallback(url, rtnData)
    loginActivityData.activitys[Activity_Rebate3] = rtnData.info.consumeRefund
     _rebateData = loginActivityData:getExpenseRebateGoldData()
    local offset = _tableView:getContentOffset().y
    _tableView:reloadData()
    _tableView:setContentOffset(ccp(0, offset)) 
    local rewardLabel = tolua.cast(ExpenseRebateGoldOwner["rewardLabel"], "CCLabelTTF")
    if loginActivityData.activitys[Activity_Rebate3].rewardRecord.canTake == 1 then 
        rewardLabel:setString(0)
    else
        rewardLabel:setString(loginActivityData.activitys[Activity_Rebate3].rewardRecord.refundGold)
    end
end

local function rewardItemClick()
    local refundGold = loginActivityData.activitys[Activity_Rebate3].rewardRecord.refundGold
    if refundGold <= 0 then
        ShowText(HLNSLocalizedString("expenseRebateGold.noGold"))
    else
        doActionFun("CONSUME_REFUND", {}, consumeRefundCallback)
    end
end
ExpenseRebateGoldOwner["rewardItemClick"] = rewardItemClick

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/ExpenseRebateGoldView.ccbi", proxy, true,"ExpenseRebateGoldOwner")
    _layer = tolua.cast(node,"CCLayer")

    _refreshData()
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(ExpenseRebateGoldOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        -- _layer:removeFromParentAndCleanup(true)
        
        popUpCloseAction( ExpenseRebateGoldOwner,"infoBg", _layer )
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
    
    local menu = tolua.cast(ExpenseRebateGoldOwner["menu"], "CCMenu")
    menu:setTouchPriority(_priority - 2)

    _tableView:setTouchPriority(_priority - 2)
end

function getExpenseRebateGoldLayer()
	return _layer
end

function createExpenseRebateGoldLayer(priority)
    _priority = (priority ~= nil) and priority or -132
    _init()

    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
        
        popUpUiAction( ExpenseRebateGoldOwner,"infoBg" )
    end

    local function _onExit()
        _layer = nil
        _tableView = nil
        _priority = nil
        _rebateData = nil
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