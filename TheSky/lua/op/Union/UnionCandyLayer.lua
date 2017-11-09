local _layer
local _tableView
local unionMerberList
local selectArray = {}
local editBox

UnionCandyLayerOwner = UnionCandyLayerOwner or {}
ccb["UnionCandyLayerOwner"] = UnionCandyLayerOwner

local function onExitTaped(  )
    getUnionMainLayer():gotoBuild()
end

UnionCandyLayerOwner["onExitTaped"] = onExitTaped

UnionCandyLayerOwner["nextRefreshTaped"] = function (  )
    CCDirector:sharedDirector():getRunningScene():addChild(createRefreshPreviewLayer(-133))
end

local function distributeCallBack( url,rtnData )
    ShowText(HLNSLocalizedString("联盟糖果发放成功"))
    unionData:fromDic(rtnData.info)
    unionMerberList = unionData:getMembers(  )
    local offset = _tableView:getContentOffset().y
    _tableView:reloadData()
    _tableView:setContentOffset(ccp(0, offset))
    getUnionMainLayer():refreshData()
end

UnionCandyLayerOwner["onDistributeTaped"] = function ( )
    if unionData:getUnionCandyTime(  ) > 0 then
        ShowText(HLNSLocalizedString("distributeCandy.noTime"))
        return
    end
    local count = editBox:getText()
    if type(tonumber(count)) == "number" then
        local idArray = {}
        for k,v in pairs(selectArray) do
            if v == 1 then
                table.insert(idArray,k)
            end
        end
        if getMyTableCount(idArray) > 0 then
            
            doActionFun("UNION_DISTRIBUTE_CANDY",{idArray,count},distributeCallBack)
        else
            ShowText(HLNSLocalizedString("请选择联盟成员"))
        end
    else
        ShowText(HLNSLocalizedString("请输入数字"))
    end
end

local function _addTableView()
    unionMerberList = unionData:getMembers(  )
    local _topLayer = UnionCandyLayerOwner["BSTopLayer"]
    local _titleLayer = UnionCandyLayerOwner["titleBg"]
    local bottomLayer = UnionCandyLayerOwner["bottomLayer"]
 
    UnionDistributeCellOwner = UnionDistributeCellOwner or {}
    ccb["UnionDistributeCellOwner"] = UnionDistributeCellOwner

    UnionDistributeCellOwner["onCellBgClicked"] = function ( tag,sender )
        local item = unionMerberList[tonumber(tag)]
        if selectArray[item.playerId] and selectArray[item.playerId] == 1 then
            selectArray[item.playerId] = 0
        else
            selectArray[item.playerId] = 1
        end
        local offset = _tableView:getContentOffset().y
        _tableView:reloadData()
        _tableView:setContentOffset(ccp(0, offset))
    end

    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
                r = CCSizeMake(winSize.width, 105 * retina)
        elseif fn == "cellAtIndex" then
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            -- local item = unionShopData[a1 + 1]
            local  proxy = CCBProxy:create()
            local _hbCell = tolua.cast(CCBReaderLoad("ccbResources/UnionDistributeCell.ccbi",proxy,true,"UnionDistributeCellOwner"),"CCLayer")
            local member = unionMerberList[a1 + 1]
            local cellBg = tolua.cast(UnionDistributeCellOwner["cellBg"],"CCMenuItemImage")
            cellBg:setTag(a1 + 1)
            if selectArray[member.playerId] and selectArray[member.playerId] == 1 then
                -- 高亮显示
                cellBg:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("union_cellBg_0.png"))
                cellBg:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("union_cellBg_0.png"))
            else
                cellBg:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("union_cellBg_1.png"))
                cellBg:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("union_cellBg_1.png"))
            end
            local name = tolua.cast(UnionDistributeCellOwner["name"],"CCLabelTTF")
            local str = member.name
            -- print(str,a1)-- string.format("草帽海贼团%d",a1) 
            name:setString(str)
            local identity = tolua.cast(UnionDistributeCellOwner["identity"],"CCLabelTTF")
            str = unionData:getNameByDuty(member.duty) 
            identity:setString(str)

            local level = tolua.cast(UnionDistributeCellOwner["level"],"CCLabelTTF")
            str = member.level
            level:setString(str)

            -- local rank = tolua.cast(UnionDistributeCellOwner["rank"],"CCLabelTTF")
            -- str = unionMerberList[tostring(a1)].arenaRank
            -- rank:setString(str)
            local contribute = tolua.cast(UnionDistributeCellOwner["contribute"],"CCLabelTTF")
            str = member.sweetCount
            if str then
                contribute:setString(str)
            end


            _hbCell:setScale(retina)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            a2:addChild(_hbCell, 0, 1)
            r = a2
        elseif fn == "numberOfCells" then
            -- Return number of cells
            r = getMyTableCount(unionMerberList)
            -- r = 5
        -- Cell events:
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
        -- 创建tableview
        local size = CCSizeMake(winSize.width, (winSize.height - bottomLayer:getContentSize().height * retina - _topLayer:getContentSize().height * retina - _mainLayer:getBottomContentSize().height) - _titleLayer:getContentSize().height)
        print(size.width.." "..size.height)
        _tableView = LuaTableView:createWithHandler(h, size)
        _tableView:setBounceable(true)
        _tableView:setAnchorPoint(ccp(0,0))
        _tableView:setPosition(ccp(0, _mainLayer:getBottomContentSize().height + bottomLayer:getContentSize().height * retina))
        _tableView:setVerticalFillOrder(0)
        _layer:addChild(_tableView) 
    end
end

function refreshCandyTiem(  )
    local distributeCandyTime = tolua.cast(UnionCandyLayerOwner["distributeCandyTime"],"CCLabelTTF")
    if unionData:getUnionCandyTime(  ) > 0 then
        distributeCandyTime:setVisible(true)
        distributeCandyTime:setString(DateUtil:second2hms(unionData:getUnionCandyTime(  )))
    else
        if distributeCandyTime then
            distributeCandyTime:setVisible(false)
        end
    end
end

local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/UnionCandyLayer.ccbi",proxy, true,"UnionCandyLayerOwner")
    _layer = tolua.cast(node,"CCLayer")
    local titleBg = tolua.cast(UnionCandyLayerOwner["titleBg"],"CCLayer")
    local chat_Bg = UnionCandyLayerOwner["textBoxBg"]
    local editBg = CCScale9Sprite:createWithSpriteFrameName("popUpFrame_15.png")
    editBox = CCEditBox:create(CCSize(chat_Bg:getContentSize().width,chat_Bg:getContentSize().height),editBg)
    editBox:setPosition(ccp(chat_Bg:getContentSize().width / 2,chat_Bg:getContentSize().height / 2))
    editBox:setFont("ccbResources/FZCuYuan-M03S.ttf",27*retina)
    chat_Bg:addChild(editBox)
    local bottomLayer = tolua.cast(UnionCandyLayerOwner["bottomLayer"],"CCLayer")
    bottomLayer:setPosition(ccp(bottomLayer:getPositionX(),getMainLayer():getBottomContentSize().height))

    refreshCandyTiem(  )
end


local function setMenuPriority(  )
    local candyMenu = tolua.cast(UnionCandyLayerOwner["candyMenu"],"CCMenu")
    candyMenu:setHandlerPriority(-129)
end 

function getUnionCandyLayer()
	return _layer
end

function createUnionCandyLayer( )
    _init()


    local function _onEnter()
        _addTableView()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.3), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
        addObserver(NOTI_TITLE_INFO, refreshCandyTiem)
    end
    
    local function _onExit()
        _layer = nil
        _tableView = nil
        unionShopData = nil
        editBox = nil
        removeObserver(NOTI_TITLE_INFO, refreshCandyTiem)
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