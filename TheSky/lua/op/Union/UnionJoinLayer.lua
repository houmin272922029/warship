local _UnionJoinLayer
local _unionMainView
local _tableView
local _editBox
local _edixBg

UnionJoinLayerOwner = UnionJoinLayerOwner or {}
ccb["UnionJoinLayerOwner"] = UnionJoinLayerOwner

-- 返回
local function backBtnFun( )
    -- body
    _editBox:setText("")
    _unionMainView:refreshUnion()
end
UnionJoinLayerOwner["backBtnFun"] = backBtnFun

-- 搜索 callBack
local function searchBtnCallBack( url, rtnData )
    -- body
    print(" Print By lixq ---- searchBtnCallBack ", rtnData.code)
    if rtnData.code == 200 then
        _editBox:setText("")
        unionData.rank = rtnData.info
        _tableView:reloadData()
    end
end

-- 搜索
local function searchBtnFun( )
    -- body
    local searchUnionName = _editBox:getText()
    doActionFun("QUERY_UNION_MAIN_INFO", {searchUnionName}, searchBtnCallBack)
end
UnionJoinLayerOwner["searchBtnFun"] = searchBtnFun

-- 显示加入选项
local function unionJoinInfo( tag )
    local unionJoinInfoLayer = createUnionJoinInfoLayer(tag, -135)
    getMainLayer():addChild(unionJoinInfoLayer, 2000)
end

-- 添加联盟列表
local function addTableView()

    UnionRankTableCellOwner = UnionRankTableCellOwner or {}
    ccb["UnionRankTableCellOwner"] = UnionRankTableCellOwner

    local h = LuaEventHandler:create(function (fn, table, a1, a2)
        -- body

        local r
        if fn == "cellSize" then
            local sp = CCSprite:createWithSpriteFrameName("union_cellBg_0.png")
            r = CCSizeMake(sp:getContentSize().width * retina* 1.1,sp:getContentSize().height * retina * 1.1)
        elseif fn == "cellAtIndex" then
            if a2 then 
                a2:removeAllChildrenWithCleanup(true)
            else
                a2 = CCTableViewCell:create()
            end

            local proxy = CCBProxy:create()
            local _tbCell 
            local unionOwnerName
            local unionName
            local unionLevel
            local unionMemberNum
            local unionMemberMaxNum
            local unionRank

            _tbCell = tolua.cast(CCBReaderLoad("ccbResources/UnionRankTableSelfCell.ccbi", proxy, true, "UnionRankTableCellOwner"), "CCLayer")
            
            unionRank = a1
            print(" Print By lixq ---- index ", unionRank)
            unionOwnerName = unionData.rank[tostring(unionRank)]["ceoName"]
            -- print("会长名字：",unionOwnerName)
            unionName = unionData.rank[tostring(unionRank)]["name"]
            -- local unionName = "联盟名称"
            -- print("联盟名称：",unionName)
            unionLevel = unionData.rank[tostring(unionRank)]["level"]
            -- print("联盟等级：",unionLevel)
            unionMemberNum = unionData.rank[tostring(unionRank)]["membersCount"]
            -- print("成员数量：",unionMemberNum)
            unionMemberMaxNum = unionData.rank[tostring(unionRank)]["memberMax"]

            local unionRankLabel = tolua.cast(UnionRankTableCellOwner["unionRankNum"], "CCLabelTTF")
            unionRankLabel:setString(unionRank + 1)
            local unionNameLabel = tolua.cast(UnionRankTableCellOwner["unionName"], "CCLabelTTF")
            unionNameLabel:setString(unionName)
            local unionOwnerNameLabel = tolua.cast(UnionRankTableCellOwner["unionOwnerName"], "CCLabelTTF")
            unionOwnerNameLabel:setString(unionOwnerName)
            local unionLevelLabel = tolua.cast(UnionRankTableCellOwner["unionLevel"], "CCLabelTTF")
            unionLevelLabel:setString(unionLevel)
            local unionMemberNumLabel = tolua.cast(UnionRankTableCellOwner["unionMemberNum"], "CCLabelTTF")
            unionMemberNumLabel:setString(HLNSLocalizedString("union.rank.membersCount",unionMemberNum,unionMemberMaxNum))
           
            _tbCell:setScale(retina)
            a2:addChild(_tbCell, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            r = a2

        elseif fn == "numberOfCells" then

             r = getMyTableCount(unionData.rank)

        elseif fn == "cellTouched" then         -- A cell was touched, a1 is cell that be touched. This is not necessary.
            local tag = a1:getIdx()
            print(" Print By lixq ---- cellTouched inx = ", tag)
            unionJoinInfo(tag)
        elseif fn == "cellTouchBegan" then      -- A cell is touching, a1 is cell, a2 is CCTouch
        elseif fn == "cellTouchEnded" then      -- A cell was touched, a1 is cell, a2 is CCTouch
        elseif fn == "cellHighlight" then       -- A cell is highlighting, coco2d-x 2.1.3 or above
        elseif fn == "cellUnhighlight" then     -- A cell had been unhighlighted, coco2d-x 2.1.3 or above
        elseif fn == "cellWillRecycle" then     -- A cell will be recycled, coco2d-x 2.1.3 or above
        end
        return r
    end)

    local SearchLayer = UnionJoinLayerOwner["SearchLayer"]
    local TopLayer = UnionJoinLayerOwner["TopLayer"]
    local _mainLayer = getMainLayer()
    if _mainLayer then
        print(" Print By lixq ---- UnionJoinLayer ", winSize.height, TopLayer:getContentSize().height, _mainLayer:getBottomContentSize().height, SearchLayer:getContentSize().height * retina)
        local size = CCSizeMake(winSize.width, (winSize.height - TopLayer:getContentSize().height * retina - _mainLayer:getBottomContentSize().height - SearchLayer:getContentSize().height * retina) * 99 / 100)  -- 这里是为了在tableview上面显示一个小空出来
        _tableView = LuaTableView:createWithHandler(h, size)
        _tableView:setBounceable(true)
        _tableView:setAnchorPoint(ccp(0, 0))
        _tableView:setPosition(0, _mainLayer:getBottomContentSize().height)
        _tableView:setVerticalFillOrder(0)
        _UnionJoinLayer:addChild(_tableView, 1000)
    end
end

local function getUnionListCallBack( url, rtnData )
    -- body
    if rtnData["code"] == 200 then 
        unionData.rank = rtnData["info"]
        addTableView()
    end
end

local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/UnionJoinLayer.ccbi", proxy, true, "UnionJoinLayerOwner")
    _UnionJoinLayer = tolua.cast(node, "CCLayer")

    _edixBg = tolua.cast(UnionJoinLayerOwner["searchUnionBg"], "CCLayer")
    local editBg = CCScale9Sprite:createWithSpriteFrameName("chat_bg.png")
    _editBox = CCEditBox:create(CCSize(_edixBg:getContentSize().width, _edixBg:getContentSize().height), editBg)
    _editBox:setPlaceHolder(HLNSLocalizedString("union.printUnionName"))
    _editBox:setAnchorPoint(ccp(0.5,0.5))
    _editBox:setPosition(ccp(_edixBg:getPositionX(), _edixBg:getPositionY()))
    _editBox:setFont("ccbResources/FZCuYuan-M03S.ttf", 26 * retina)
    _edixBg:getParent():addChild(_editBox)
end

function createUnionJoinLayer( unionMainView )
    _init()

    _unionMainView = unionMainView

    local function _onEnter()
        -- 请求联盟列表
        doActionFun("QUERY_UNION_MAIN_INFO", {}, getUnionListCallBack)
    end

    local function _onExit()
        print("onExit")
        _unionMainView = nil
        _UnionJoinLayer = nil
    end

    --onEnter onExit
    local function _layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        end
    end

    _UnionJoinLayer:registerScriptHandler(_layerEventHandler)

    return _UnionJoinLayer
end