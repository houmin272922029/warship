local _layer
local _tableView
local _rankArray 
local _priority = -132

-- 奖励 套用原来ccb
-- 名字不要重复
SSARewardViewOwner = SSARewardViewOwner or {}
ccb["SSARewardViewOwner"] = SSARewardViewOwner

SSARewardCellOwner = SSARewardCellOwner or {}
ccb["SSARewardCellOwner"] = SSARewardCellOwner

local function closeItemClick()
    popUpCloseAction(SSARewardViewOwner, "infoBg", _layer)
end
SSARewardViewOwner["closeItemClick"] = closeItemClick

local function confirmBtnTaped(  )
    popUpCloseAction(SSARewardViewOwner, "infoBg", _layer)
end
SSARewardViewOwner["confirmBtnTaped"] = confirmBtnTaped

local function setMenuPriority()
    local menu = tolua.cast(SSARewardViewOwner["menu"], "CCMenu")
    menu:setHandlerPriority(_priority - 1)
    if _tableView then
        _tableView:setTouchPriority(_priority - 2)
    end
end

local function getMyData()
        -- body
    local temp = {}
    if _data.reward.rankIn32 then
        _data.reward.rankIn32["rankIn32"] = "rankIn32"
        table.insert(temp, _data.reward.rankIn32)
    end
    if _data.reward.rankIn50 then
        _data.reward.rankIn50["rankIn50"] = "rankIn50"
        table.insert(temp, _data.reward.rankIn50)
    end
    if _data.reward.day then
        for k,v in pairs(_data.reward.day) do
            table.insert(temp, v)
        end
    end
    return temp
end

-- 领奖按钮
local function rewardBtnClick(tag)
    local rankArray = getMyData()
    local function callback(url, rtnData)
        print("积分奖励")
        ssaData.data.reward = rtnData.info.reward
        _rankArray = getMyData()
        _tableView:reloadData()
    end
    if rankArray[tag].date then
        doActionFun("CROSSSERVERBATTLE_GETDAILYREWARD", {rankArray[tag].date}, callback)
    elseif rankArray[tag].rankIn50 then  -- 50名的排行榜奖励接口
        doActionFun("CROSSSERVERBATTLE_GETRANKREWARD50", {}, callback)
    else
        doActionFun("CROSSSERVERBATTLE_GETRANKREWARD", {}, callback)
    end
end
SSARewardCellOwner["rewardBtnClick"] = rewardBtnClick

-- 点击物品按钮
local function itemBtnClick(tag)
    local rankArray = getMyData()
    local array = {}
    for k,v in pairs(rankArray[tag].items) do
        table.insert(array, {itemId = k, count = v})
    end
    getMainLayer():getParent():addChild(createMultiItemLayer(array, _priority - 2), 100)  
end
SSARewardCellOwner["itemBtnClick"] = itemBtnClick

-- 添加tableview
local function _addTableView()
    local containLayer = tolua.cast(SSARewardViewOwner["containLayer"],"CCLayer")
    _rankArray = getMyData()
    print("修改后的数据")
    PrintTable(_rankArray)
    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(620, 175)
        elseif fn == "cellAtIndex" then
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            --单条数据
            local  _hbCell 
            local  proxy = CCBProxy:create()
            local  _hbCell  = tolua.cast(CCBReaderLoad("ccbResources/SSARewardCell.ccbi",proxy,true,"SSARewardCellOwner"),"CCLayer")
            -- 如果打进32强，存在数据
            local dic = _rankArray[a1 + 1]
            local contentLabel = tolua.cast(SSARewardCellOwner["contentLabel"], "CCLabelTTF")
            contentLabel:setString(dic.desp)
            contentLabel:setVisible(true)
            local rewardBtn = tolua.cast(SSARewardCellOwner["rewardBtn"], "CCMenuItemImage")
            local itemBtn = tolua.cast(SSARewardCellOwner["itemBtn"], "CCMenuItemImage")
            itemBtn:setTag(a1 + 1)
            local rewardLabel = tolua.cast(SSARewardCellOwner["rewardLabel"], "CCLabelTTF")
            rewardBtn:setTag(a1 + 1)
            if dic.date then
                rewardLabel:setString(HLNSLocalizedString("SSA.paiweiReward"))
            elseif dic.rankIn50 then -- 五十名的奖励
                rewardLabel:setString(HLNSLocalizedString("SSA.RankNotice.Reward"))
            else
                rewardLabel:setString(HLNSLocalizedString("SSA.zhibuReward"))
            end
            -- 设置优先级
            local menu = tolua.cast(SSARewardCellOwner["menu"], "CCMenu")
            local function setCellMenuPriority(sender)
                if sender then
                    local menu = tolua.cast(sender, "CCMenu")
                    menu:setHandlerPriority(_priority - 1)
                end
            end
            local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCCallFuncN:create(setCellMenuPriority))
            menu:runAction(seq)
            -- contentLabel 描述文字 rewardBtnClick rewardBtn itemBtn itemBtnClick

            local rewardBtn = tolua.cast(SSARewardCellOwner["rewardBtn"], "CCMenuItem")
            local rewardText = tolua.cast(SSARewardCellOwner["rewardText"], "CCSprite")
            local isReward = tolua.cast(SSARewardCellOwner["isReward"], "CCLabelTTF")
            if dic.isReward and dic.isReward == true then
                rewardBtn:setVisible(false)
                rewardText:setVisible(false)
                isReward:setVisible(true)
            else
                rewardBtn:setVisible(true)
                rewardText:setVisible(true)
                isReward:setVisible(false)
            end
    
            -- _hbCell:setScale(retina)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            a2:addChild(_hbCell, 0, 1)
            r = a2
        elseif fn == "numberOfCells" then
           
            r = getMyTableCount(_rankArray)    
        elseif fn == "cellTouched" then         -- A cell was touched, a1 is cell that be touched. This is not necessary.
        elseif fn == "cellTouchBegan" then      -- A cell is touching, a1 is cell, a2 is CCTouch
        elseif fn == "cellTouchEnded" then      -- A cell was touched, a1 is cell, a2 is CCTouch
        elseif fn == "cellHighlight" then       -- A cell is highlighting, coco2d-x 2.1.3 or above
        elseif fn == "cellUnhighlight" then     -- A cell had been unhighlighted, coco2d-x 2.1.3 or above
        elseif fn == "cellWillRecycle" then     -- A cell will be recycled, coco2d-x 2.1.3 or above
        end
        return r
    end)
    local size = CCSizeMake(containLayer:getContentSize().width, containLayer:getContentSize().height)  -- 这里是为了在tableview上面显示一个小空出来
    _tableView = LuaTableView:createWithHandler(h, size)
    _tableView:setBounceable(true)
    _tableView:setAnchorPoint(ccp(0,0))
    _tableView:setPosition(0,0)
    _tableView:setVerticalFillOrder(0)
    containLayer:addChild(_tableView,1000)
end

local function refresh()
    -- body
    _data = ssaData.data
    print("奖励数据")
    PrintTable(_data)
    _addTableView()
end
-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local proxy = CCBProxy:create()
    local node  = CCBReaderLoad("ccbResources/SSARewardView.ccbi", proxy, true, "SSARewardViewOwner")
    _layer = tolua.cast(node,"CCLayer")
    
    refresh()
end

-- 该方法名字每个文件不要重复
function getSSARewardLayer()
    return _layer
end


local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(SSARewardViewOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction(SSARewardViewOwner, "infoBg", _layer)
        return true
    end
    return true
end

local function onTouch(eventType, x, y)
    if eventType == "began" then   
        return onTouchBegan(x, y)
    end
end

function createSSARewardLayer(priority)
    _priority = (priority ~= nil) and priority or -132
    _init()
    local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
    _layer:runAction(seq)
    local function _onEnter()
        
    end
    local function _onExit()
        _layer = nil
        _priority = -132
        _tableView = nil
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