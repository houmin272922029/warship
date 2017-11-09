local _layer
local _priority = -140
local _contentDic
local _tableView
local helpHeightArray = {}

-- 名字不要重复
TrainShadowTrainOtherOwner = TrainShadowTrainOtherOwner or {}
ccb["TrainShadowTrainOtherOwner"] = TrainShadowTrainOtherOwner

local function getCellHeight( string,width,fontSize,fontName )
    if not fontName then
        fontName = "ccbResources/FZCuYuan-M03S.ttf"
    end
    local tempLabel = CCLabelTTF:create(string,fontName,fontSize,CCSizeMake(width,0),kCCTextAlignmentLeft)
    tempLabel:setVisible(false)
    _layer:addChild(tempLabel,200,8888)
    local height = tempLabel:getContentSize().height
    tempLabel:removeFromParentAndCleanup(true)
    return height
end

local function _addTableView() 
    local tableViewContentView = TrainShadowTrainOtherOwner["tableViewContentView"]

    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
                local message = _contentDic[a1 +1]
                local cellHeight
                if helpHeightArray[a1+1] then
                    cellHeight = helpHeightArray[a1+1]
                else
                    cellHeight = getCellHeight(message,300.0,23,"ccbResources/FZCuYuan-M03S") + 20 * retina
                    helpHeightArray[a1+1] = cellHeight 
                end
                
                r = CCSizeMake(300, cellHeight)
            -- end
        elseif fn == "cellAtIndex" then
            -- Return CCTableViewCell, a1 is cell index (zero based), a2 is dequeued cell (maybe nil)
            -- Do something to create cell  and change the content
            
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            
            local  proxy = CCBProxy:create()
            
            local  _hbCell
            -- _hbCell = CCLayerColor:create(ccc4(255,255,3,255))
            _hbCell = CCLayer:create()

            local message = _contentDic[a1 +1]
            local cellHeight
            if helpHeightArray[a1+1] then
                cellHeight = helpHeightArray[a1+1]
            else
                cellHeight = getCellHeight(message,300.0,23,"ccbResources/FZCuYuan-M03S") + 20 * retina
                helpHeightArray[a1+1] = cellHeight
            end
            _hbCell:setContentSize(CCSizeMake(300,cellHeight))
            _hbCell:setAnchorPoint(ccp(0,0))
            _hbCell:setPosition(ccp(0,0))

            local temp = CCLabelTTF:create(message, "ccbResources/FZCuYuan-M03S", 23,CCSizeMake(300,0),kCCTextAlignmentLeft)
            temp:setAnchorPoint(ccp(0,1))
            temp:setPosition(ccp(0,cellHeight - 10 * retina))
            _hbCell:addChild(temp)
            temp:setColor(ccc3(255,204,0))
                
            -- _hbCell:setScale(retina)
            a2:addChild(_hbCell, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)

            r = a2
        elseif fn == "numberOfCells" then
            r = getMyTableCount(_contentDic)
        elseif fn == "cellTouched" then         -- A cell was touched, a1 is cell that be touched. This is not necessary.
            -- print("cellTouched",a1:getIdx())
        elseif fn == "cellTouchBegan" then      -- A cell is touching, a1 is cell, a2 is CCTouch
        elseif fn == "cellTouchEnded" then      -- A cell was touched, a1 is cell, a2 is CCTouch
        elseif fn == "cellHighlight" then       -- A cell is highlighting, coco2d-x 2.1.3 or above
        elseif fn == "cellUnhighlight" then     -- A cell had been unhighlighted, coco2d-x 2.1.3 or above
        elseif fn == "cellWillRecycle" then     -- A cell will be recycled, coco2d-x 2.1.3 or above
        end
        return r
    end)
    
    local _mainLayer = getMainLayer()
    if _mainLayer then
        local size = CCSizeMake(tableViewContentView:getContentSize().width,tableViewContentView:getContentSize().height)      -- 这里是为了在tableview上面显示一个小空出来
        _tableView = LuaTableView:createWithHandler(h, size)
        _tableView:setBounceable(true)
        _tableView:setAnchorPoint(ccp(0,0))
        _tableView:setPosition(ccp(0, 0))
        _tableView:setVerticalFillOrder(0)
        tableViewContentView:addChild(_tableView)
    end
end

local function closeItemClick(  )
    _layer:removeFromParentAndCleanup(true) 
end

TrainShadowTrainOtherOwner["closeItemClick"] = closeItemClick

-- 炼百次
local function trainHundredTimesCallBack( url,rtnData )
    if rtnData.code == 200 then
        shadowData.shadowExercise = rtnData.info.shadowExercise
        shadowData.shadowData = rtnData.info.shadowData
        getTrainLayer():refreshTableView()
    end
end

local function trainHundredTimesShadow(  )
    doActionFun("SHADOW_TRAIN_URL", { 100 }, trainHundredTimesCallBack )
end
TrainShadowTrainOtherOwner["trainHundredTimesShadow"] = trainHundredTimesShadow


--"将消耗金币%d，贝里%d，是否继续?",
local function _surePingMing( goldNeed,berryNeed,times ,callback )
    local text = HLNSLocalizedString("sureCostGoldAndBerry?",goldNeed,berryNeed)  --"将消耗金币%d，贝里%d，是否继续?",
    local function cardConfirmAction(  )
        doActionFun("SHADOWEXERCISEWITHSTATUS_URL", { 5, times }, callback )
    end
    local function cardCancelAction(  )
        
    end
    CCDirector:sharedDirector():getRunningScene():addChild(createSimpleConfirCardLayer(text), 100)
    SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
    SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction
end

-- 拼命炼十次
local function trainTenTimesCallBack( url,rtnData )
    if rtnData.code == 200 then
        shadowData.shadowExercise = rtnData.info.shadowExercise
        shadowData.shadowData = rtnData.info.shadowData
        getTrainLayer():refreshTableView()
    end
end

local function trainTenTimesShadow(  )
    if userdata.berry < 600000 then
        ShowText(HLNSLocalizedString("ERR_1102"))
        return
    end
    if userdata.gold < 5000 then
        ShowText(HLNSLocalizedString("ERR_1101"))
        return
    end

    
    _surePingMing( 5000,600000,10,trainTenTimesCallBack)

    -- doActionFun("SHADOWEXERCISEWITHSTATUS_URL", { 5, 10 }, trainTenTimesCallBack )
end
TrainShadowTrainOtherOwner["trainTenTimesShadow"] = trainTenTimesShadow

-- 拼命炼三十次
local function trainThirtyTimesCallBack( url,rtnData )
    if rtnData.code == 200 then
        shadowData.shadowExercise = rtnData.info.shadowExercise
        shadowData.shadowData = rtnData.info.shadowData
        getTrainLayer():refreshTableView()
    end
end

local function trainThirtyTimesShadow(  )
    if userdata.berry < 1800000 then
        ShowText(HLNSLocalizedString("ERR_1102"))
        return
    end
    if userdata.gold < 15000 then
        ShowText(HLNSLocalizedString("ERR_1101"))
        return
    end
    _surePingMing( 15000,1800000,30,trainThirtyTimesCallBack)

    -- doActionFun("SHADOWEXERCISEWITHSTATUS_URL", { 5, 30 }, trainThirtyTimesCallBack )
end
TrainShadowTrainOtherOwner["trainThirtyTimesShadow"] = trainThirtyTimesShadow

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/TrainShadowTrainOther.ccbi",proxy, true,"TrainShadowTrainOtherOwner")
    _layer = tolua.cast(node,"CCLayer")
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(TrainShadowTrainOtherOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        _layer:removeFromParentAndCleanup(true)
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
    local menu1 = tolua.cast(TrainShadowTrainOtherOwner["closeMenu"], "CCMenu")
    menu1:setHandlerPriority(_priority - 1)

    _tableView:setTouchPriority(_priority - 1)
end

-- 根据vip决定是否显示拼命炼影按钮
local function showTrainBtn(  )
    local vipLavel = vipdata:getVipLevel()
    local trainTenTimesBtn = tolua.cast(TrainShadowTrainOtherOwner["trainTenTimesBtn"],"CCMenuItemImage")
    local trainThirtyTimesBtn = tolua.cast(TrainShadowTrainOtherOwner["trainThirtyTimesBtn"],"CCMenuItemImage")
    local trainTenTimesLabel = tolua.cast(TrainShadowTrainOtherOwner["trainTenTimesLabel"],"CCLabelTTF") 
    local trainTenTimesLabelBg = tolua.cast(TrainShadowTrainOtherOwner["trainTenTimesLabelBg"],"CCLabelTTF") 
    local trainThirtyTimesLabel = tolua.cast(TrainShadowTrainOtherOwner["trainThirtyTimesLabel"],"CCLabelTTF")
    local trainThirtyTimesLabelBg = tolua.cast(TrainShadowTrainOtherOwner["trainThirtyTimesLabelBg"],"CCLabelTTF")
    
    local pinMingTen = vipdata:getVipPinMingTenLevel()
    local pinMingThirty = vipdata:getVipPinMingThirtyLevel()
    if vipLavel >= pinMingTen then
        trainTenTimesBtn:setVisible(true)
        trainTenTimesLabel:setVisible(true)
        trainTenTimesLabelBg:setVisible(true)
        if vipLavel >= pinMingThirty then
            trainThirtyTimesBtn:setVisible(true)
            trainThirtyTimesLabel:setVisible(true)
            trainThirtyTimesLabelBg:setVisible(true)
        else
            trainThirtyTimesBtn:setVisible(false)
            trainThirtyTimesLabel:setVisible(false)
            trainThirtyTimesLabelBg:setVisible(false)
        end
    else
        trainTenTimesBtn:setVisible(false)
        trainTenTimesLabel:setVisible(false)
        trainTenTimesLabelBg:setVisible(false)
    end
end

function createTrainShadowOtherTimesLayer( priority)
    _priority = (priority ~= nil) and priority or -140
    _init()
    showTrainBtn()
    _contentDic = shadowData:trainShadowRule()

    local function _onEnter()
        print("onEnter")
        _addTableView()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
    end

    local function _onExit()
        _layer = nil
        _priority = -140
        _contentDic = nil
        _tableView = nil
        helpHeightArray = {}
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