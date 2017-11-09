local _unionMainView
local _unionRankLayer


UnionRankLayerOwner = UnionRankLayerOwner or {}
ccb["UnionRankLayerOwner"] = UnionRankLayerOwner



local function showUnionInfo(tag)

    local unionRankInfoLayer = createUnionRankInfoLayer(tag, -135)
    getMainLayer():addChild(unionRankInfoLayer, 2000)
end

--获取自己公会的信息
local function getSelfUnionRankData()

    local  unionRankData  = unionData.rank
    local unionId = unionData.detail["id"]

    for k,v in pairs(unionRankData) do
        if v["id"] == unionId then 
            v["rank"] = k+1
            return v
        end
    end
    return nil
end

local function addTableView()

    local unionRankData = unionData.rank

   
    -- getSelfUnionRankData()

    UnionRankTableCellOwner = UnionRankTableCellOwner or {}
    ccb["UnionRankTableCellOwner"] = UnionRankTableCellOwner

    local h= LuaEventHandler:create(function (fn,table,a1,a2)
        -- body

        local r
        if fn == "cellSize" then
            local sp = CCSprite:createWithSpriteFrameName("union_cellBg_0.png")
            r = CCSizeMake(sp:getContentSize().width * retina* 1.1,sp:getContentSize().height * retina * 1.1)

            if a1 == 1 then
                r = CCSizeMake(sp:getContentSize().width * retina* 1.1,(sp:getContentSize().height +10) * retina * 1.1)
            end

        elseif fn == "cellAtIndex" then
            if a2 then 
                a2:removeAllChildrenWithCleanup(true)
            else
                a2 = CCTableViewCell:create()
            end


            local  proxy = CCBProxy:create()
            local  _tbCell 
            local index  = 0
            local unionOwnerName
            local unionName
            local unionLevel
            local unionMemberNum
            local unionMemberMaxNum
            local unionRank

            if a1 == 0 then     --显示本公会信息
                index = 0
                _tbCell = tolua.cast(CCBReaderLoad("ccbResources/UnionRankTableSelfCell.ccbi",proxy,true,"UnionRankTableCellOwner"),"CCLayer")
                
                local selfData = getSelfUnionRankData()
                if selfData then 
                    unionRank = selfData["rank"]
                    unionOwnerName = selfData["ceoName"]
                    unionName = selfData["name"]
                    unionLevel = selfData["level"]
                    unionMemberNum = selfData["membersCount"]
                    unionMemberMaxNum = selfData["memberMax"]
                end
            else
                index = a1 -1 
                _tbCell = tolua.cast(CCBReaderLoad("ccbResources/UnionRankTableCell.ccbi",proxy,true,"UnionRankTableCellOwner"),"CCLayer")
                
                unionRank = index + 1
                unionOwnerName = unionRankData[string.format("%d",index)]["ceoName"]
                -- print("会长名字：",unionOwnerName)
                unionName = unionRankData[string.format("%d",index)]["name"]
                -- local unionName = "联盟名称"
                -- print("联盟名称：",unionName)
                unionLevel = unionRankData[string.format("%d",index)]["level"]
                -- print("联盟等级：",unionLevel)
                unionMemberNum = unionRankData[string.format("%d",index)]["membersCount"]
                -- print("成员数量：",unionMemberNum)
                unionMemberMaxNum = unionRankData[string.format("%d",index)]["memberMax"]
            end 

            local unionRankLabel = tolua.cast(UnionRankTableCellOwner["unionRankNum"],"CCLabelTTF")
            unionRankLabel:setString(unionRank)
            local unionNameLabel = tolua.cast(UnionRankTableCellOwner["unionName"],"CCLabelTTF")
            unionNameLabel:setString(unionName)
            local unionOwnerNameLabel = tolua.cast(UnionRankTableCellOwner["unionOwnerName"],"CCLabelTTF")
            unionOwnerNameLabel:setString(unionOwnerName)
            local unionLevelLabel = tolua.cast(UnionRankTableCellOwner["unionLevel"],"CCLabelTTF")
            unionLevelLabel:setString(unionLevel)
            local unionMemberNumLabel = tolua.cast(UnionRankTableCellOwner["unionMemberNum"],"CCLabelTTF")
            unionMemberNumLabel:setString(HLNSLocalizedString("union.rank.membersCount",unionMemberNum,unionMemberMaxNum))
           
           _tbCell:setScale(retina)
            a2:addChild(_tbCell, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            r = a2

        elseif fn == "numberOfCells" then

             r = getMyTableCount(unionRankData) +1 

        elseif fn == "cellTouched" then         -- A cell was touched, a1 is cell that be touched. This is not necessary.
            if getTeamPopupLayer() then
                return
            end
            local tag = a1:getIdx()
            -- print(tag)
            if tag == 0 then 
                 local selfData = getSelfUnionRankData()
                if selfData then 
                    showUnionInfo(selfData["rank"]-1)
                end
            else
                showUnionInfo(tag-1)
            end
        elseif fn == "cellTouchBegan" then      -- A cell is touching, a1 is cell, a2 is CCTouch
        elseif fn == "cellTouchEnded" then      -- A cell was touched, a1 is cell, a2 is CCTouch
        elseif fn == "cellHighlight" then       -- A cell is highlighting, coco2d-x 2.1.3 or above
        elseif fn == "cellUnhighlight" then     -- A cell had been unhighlighted, coco2d-x 2.1.3 or above
        elseif fn == "cellWillRecycle" then     -- A cell will be recycled, coco2d-x 2.1.3 or above
        end
        return r
    end)

    local unionLine = UnionRankLayerOwner["unionLine"]
    local _topLayer = UnionRankLayerOwner["titleLayer"]
    local _mainLayer = getMainLayer()
    if _mainLayer then
        local size = CCSizeMake(winSize.width, (winSize.height - _topLayer:getContentSize().height - _mainLayer:getBottomContentSize().height + unionLine:getPositionY())*99/100)  -- 这里是为了在tableview上面显示一个小空出来
        _tableView = LuaTableView:createWithHandler(h, size)
        _tableView:setBounceable(true)
        _tableView:setAnchorPoint(ccp(0,0))
        _tableView:setPosition(0,_mainLayer:getBottomContentSize().height)
        _tableView:setVerticalFillOrder(0)
        _unionRankLayer:addChild(_tableView,1000)
    end
end




local function refreshUI()
    local unionRankBtn = UnionRankLayerOwner["unionRankBtn"]
    local unionRankItem = tolua.cast(unionRankBtn,"CCMenuItemSprite")
    unionRankItem:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_1.png"))
end


local function unionRankBtnClicked()
    -- body
    print("Union Rank")
end
UnionRankLayerOwner["unionRankBtnClicked"] = unionRankBtnClicked

local function backToUnionBtnClicked( ) --回联盟
    -- body
    _unionMainView:gotoShowInner()
end
UnionRankLayerOwner["backToUnionBtnClicked"] = backToUnionBtnClicked


local function _init()

    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/UnionRankView.ccbi", proxy, true, "UnionRankLayerOwner")
    _unionRankLayer = tolua.cast(node, "CCLayer")

    refreshUI()
end


local function getUnionRankInfoCallback(url,rtnData)
    -- body
    if rtnData["code"] == 200 then 
        unionData.rank = rtnData["info"]
        addTableView()
    end
end


function createUnionRankLayer( unionMainView )

    _init()

    _unionMainView = unionMainView

    local function _onEnter()
        -- queryLeaguesMainInfo
        doActionFun("QUERY_UNION_MAIN_INFO", {}, getUnionRankInfoCallback)
    end

    local function _onExit()
        print("onExit")
        _unionRankLayer = nil
    end

    --onEnter onExit
    local function _layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        end
    end

    _unionRankLayer:registerScriptHandler(_layerEventHandler)

    return _unionRankLayer
end