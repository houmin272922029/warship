local _UnionManageLayer
local _unionMainView
local _tableView
local _selectedOrderType
local _orderType = {
    levelOrder = "level",
    DuelOrder = "arenaRank",
}
local _applicantsData = {}

UnionManageLayerOwner = UnionManageLayerOwner or {}
ccb["UnionManageLayerOwner"] = UnionManageLayerOwner

local function _orderApplicants()
    
    local tmpTable = HLSortDicInArray( _applicantsData, _selectedOrderType, false)
    _applicantsData = {}
    for k,data in pairs(tmpTable) do
        table.insert(_applicantsData,data.v)
    end
    -- PrintTable(_applicantsData)
end

-- 返回联盟
local function applyBtnClicked( )
    -- body
end
UnionManageLayerOwner["applyBtnClicked"] = applyBtnClicked

-- 返回联盟
local function backToUnionFun( )
    -- body
    _unionMainView:gotoShowInner()
end
UnionManageLayerOwner["backUnionBtnClicked"] = backToUnionFun

local function _agreeOrDenyAskForJoinCallBack(url,rtnData)
    if rtnData.code == 200 then
        _applicantsData = rtnData.info.ask
        _orderApplicants()
        _tableView:reloadData()
    end
end

-- 返回联盟
local function rejectAllBtnClicked( )
    local allIds = {}
    for i,v in ipairs(_applicantsData) do
        table.insert(allIds,v.id)
    end
    
    doActionFun("UNION_AGREE_OR_DENY_URL",{allIds,false},_agreeOrDenyAskForJoinCallBack)
end
UnionManageLayerOwner["rejectAllBtnClicked"] = rejectAllBtnClicked

-- 返回联盟
local function levelRankBtnClicked( )
    if _selectedOrderType == _orderType.levelOrder then
        return
    else
        _selectedOrderType = _orderType.levelOrder
        _orderApplicants()
        _tableView:reloadData()
    end
end
UnionManageLayerOwner["levelRankBtnClicked"] = levelRankBtnClicked

-- 返回联盟
local function DuelRankBtnClicked( )
    if _selectedOrderType == _orderType.DuelOrder then
        return
    else
        _selectedOrderType = _orderType.DuelOrder
        _orderApplicants()
        _tableView:reloadData()
    end
end
UnionManageLayerOwner["DuelRankBtnClicked"] = DuelRankBtnClicked

local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/UnionManageLayer.ccbi", proxy, true, "UnionManageLayerOwner")
    _UnionManageLayer = tolua.cast(node, "CCLayer")
end




local function _addTableView()
    -- 得到数据
    local tableViewLayer = UnionManageLayerOwner["tableLayer"]

    UnionApplicantCellOwner = UnionApplicantCellOwner or {}
    ccb["UnionApplicantCellOwner"] = UnionApplicantCellOwner

    local function applicantCellClicked(tag)
        local UnionCententLayer = UnionMainViewOwner["UnionCententLayer"]
        UnionCententLayer:addChild(createUnionAcceptLayer(_applicantsData[tag],_UnionManageLayer))
    end
    UnionApplicantCellOwner["applicantCellClicked"] = applicantCellClicked

    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local returnValue
        if fn == "cellSize" then
            returnValue = CCSizeMake(622 , 103)
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
            _hbCell  = tolua.cast(CCBReaderLoad("ccbResources/UnionApplicantCell.ccbi",proxy,true,"UnionApplicantCellOwner"),"CCLayer")

            local applicantData = _applicantsData[a1 + 1]
            if applicantData then
                local captainNameLabel = tolua.cast(UnionApplicantCellOwner["captainNameLabel"],"CCLabelTTF")
                if applicantData["vipLevel"] and applicantData["vipLevel"] > 0 then
                    captainNameLabel:setString(string.format("%s(V%d)", applicantData["name"], applicantData["vipLevel"]))
                else
                    captainNameLabel:setString(applicantData["name"])
                end

                local levelRankLabel = tolua.cast(UnionApplicantCellOwner["levelRankLabel"],"CCLabelTTF")
                levelRankLabel:setString(applicantData["level"])

                local DuelRankLabel = tolua.cast(UnionApplicantCellOwner["DuelRankLabel"],"CCLabelTTF")
                DuelRankLabel:setString(applicantData["arenaRank"])

                a2:addChild(_hbCell, 0, 1)
                a2:setAnchorPoint(ccp(0, 0))
                a2:setPosition(0, 0)            
                UnionApplicantCellOwner["cellBtn"]:setTag(a1 + 1)
            end
            returnValue = a2
        elseif fn == "numberOfCells" then
            -- Return number of cells
            returnValue = #_applicantsData
        -- Cell events:
        elseif fn == "cellTouched" then         -- A cell was touched, a1 is cell that be touched. This is not necessary.
        elseif fn == "cellTouchBegan" then      -- A cell is touching, a1 is cell, a2 is CCTouch
            print("touch began")
        elseif fn == "cellTouchEnded" then      -- A cell was touched, a1 is cell, a2 is CCTouch
        elseif fn == "cellHighlight" then       -- A cell is highlighting, coco2d-x 2.1.3 or above
        elseif fn == "cellUnhighlight" then     -- A cell had been unhighlighted, coco2d-x 2.1.3 or above
        elseif fn == "cellWillRecycle" then     -- A cell will be recycled, coco2d-x 2.1.3 or above
        end
        return returnValue
    end)
    local _mainLayer = getMainLayer()
    local x = 1
    if _mainLayer then
        local size = CCSizeMake(tableViewLayer:getContentSize().width, tableViewLayer:getContentSize().height * 99 / 100)  -- 这里是为了在tableview上面显示一个小空出来
        print(size.width.." "..size.height)
        _tableView = LuaTableView:createWithHandler(h, size)
        _tableView:setBounceable(false)
        tableViewLayer:addChild(_tableView,1000)
        _tableView:setAnchorPoint(ccp(0,0))
        _tableView:setPosition(0,0)
        _tableView:setVerticalFillOrder(0)
    end
end

local function _requestApplicantsData()
    doActionFun("QUERY_UNION_APPLICANTS_URL",{},_agreeOrDenyAskForJoinCallBack)
end


function createUnionManageLayer( unionMainView )
    _init()

    _unionMainView = unionMainView

    function _UnionManageLayer:refreshTable(url,rtnData)
        _agreeOrDenyAskForJoinCallBack(url,rtnData)
    end

    local function _onEnter()
        _selectedOrderType = _orderType.levelOrder
        _addTableView()
        _requestApplicantsData()
    end

    local function _onExit()
        print("onExit")
        _UnionManageLayer = nil
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


    _UnionManageLayer:registerScriptHandler(_layerEventHandler)

    return _UnionManageLayer
end