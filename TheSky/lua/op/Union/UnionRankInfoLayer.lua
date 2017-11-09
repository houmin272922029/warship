local _layer
local _unionId = nil
local _priority = -132
local _unionInfo = nil
-- 名字不要重复
UnionInfoViewOwner = UnionInfoViewOwner or {}
ccb["UnionInfoViewOwner"] = UnionInfoViewOwner



local function addTableView()
    -- body
    local unionMemberContentLayer = UnionInfoViewOwner["unionMemberContentLayer"]
    unionMemberContentLayer = tolua.cast(unionMemberContentLayer, "CCLayer")
    local membersData = _unionInfo["league"]["members"]

    UnionRankMemberInfoCellViewOwner = UnionRankMemberInfoCellViewOwner or {}
    ccb["UnionRankMemberInfoCellViewOwner"] = UnionRankMemberInfoCellViewOwner

    if membersData then
        local h= LuaEventHandler:create(function (fn,table,a1,a2)
        -- body
        local r
        if fn == "cellSize" then
            r = CCSizeMake(unionMemberContentLayer:getContentSize().width,35 )

        elseif fn == "cellAtIndex" then
            if a2 then 
                a2:removeAllChildrenWithCleanup(true)
            else
                a2 = CCTableViewCell:create()
            end


            local  proxy = CCBProxy:create()
            local  _tbCell = tolua.cast(CCBReaderLoad("ccbResources/UnionRankMemberInfoCellView.ccbi",proxy,true,"UnionRankMemberInfoCellViewOwner"),"CCLayer")

            if a1%2 == 0 then

                local cellBg = tolua.cast(UnionRankMemberInfoCellViewOwner["lightColorLayer"],"CCLayerColor")
                cellBg:setVisible(false)
            else
                local cellBg = tolua.cast(UnionRankMemberInfoCellViewOwner["deepColorLayer"],"CCLayerColor")
                cellBg:setVisible(false)
            end
            -- 获取成员信息
            
            -- if membersData[string.format("%d",1)] then 

            local memberName = membersData[string.format("%d",a1)]["name"]
            local memberDuty = membersData[string.format("%d",a1)]["duty"]
            local memberLevel = membersData[string.format("%d",a1)]["level"]
            local memberArenaRank = membersData[string.format("%d",a1)]["arenaRank"]
            --显示成员信息
            local memberNameLabel = tolua.cast(UnionRankMemberInfoCellViewOwner["memberName"],"CCLabelTTF")
            memberNameLabel:setString(memberName)
            local dutyLabel = tolua.cast(UnionRankMemberInfoCellViewOwner["duty"],"CCLabelTTF")
            local duty = ConfigureStorage.leagueDuty[tostring(memberDuty)].name
            dutyLabel:setString(duty)
            local levelLabel = tolua.cast(UnionRankMemberInfoCellViewOwner["level"],"CCLabelTTF")
            levelLabel:setString(memberLevel)
            local arenaRankLabel = tolua.cast(UnionRankMemberInfoCellViewOwner["arenaRank"],"CCLabelTTF")
            arenaRankLabel:setString(memberArenaRank)

            -- end 
            -- --添加到TableCell
            a2:addChild(_tbCell, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            r = a2

        elseif fn == "numberOfCells" then

             r = getMyTableCount(membersData)
        elseif fn == "cellTouched" then         -- A cell was touched, a1 is cell that be touched. This is not necessary.
            local tag = a1:getIdx()
        elseif fn == "cellTouchBegan" then      -- A cell is touching, a1 is cell, a2 is CCTouch
        elseif fn == "cellTouchEnded" then      -- A cell was touched, a1 is cell, a2 is CCTouch
        elseif fn == "cellHighlight" then       -- A cell is highlighting, coco2d-x 2.1.3 or above
        elseif fn == "cellUnhighlight" then     -- A cell had been unhighlighted, coco2d-x 2.1.3 or above
        elseif fn == "cellWillRecycle" then     -- A cell will be recycled, coco2d-x 2.1.3 or above
        end
        return r
    end)

    local unionLine = UnionInfoViewOwner["unionLine"]
    local _tableLayer = tolua.cast(UnionInfoViewOwner["tablePosition"],"CCLayer")
    local layerColor = tolua.cast(UnionInfoViewOwner["layerColor"],"CCLayerColor")
    local _mainLayer = getMainLayer()
    local backBg = tolua.cast(UnionInfoViewOwner["backBg"],"CCLayer")
    if _mainLayer then
        _tableView = LuaTableView:createWithHandler(h, unionMemberContentLayer:getContentSize())
        _tableView:setBounceable(true)
        _tableView:setAnchorPoint(ccp(0, 0))
        _tableView:setPosition(ccp(0, 0))
        _tableView:setVerticalFillOrder(0)
        _tableView:setTouchPriority(_priority -2)
        unionMemberContentLayer:addChild(_tableView,1000)
    end

    end
end

local function closeItemClick()
    _layer:removeFromParentAndCleanup(true)
end
--点击页面中关闭按钮
UnionInfoViewOwner["closeItemClick"] = closeItemClick
--点击左上角关闭按钮
UnionInfoViewOwner["unionInfoCloseItemBtnClick"] = closeItemClick


local function _getBattleInfoCallback(url,rtnData)
    if rtnData.code == 200 then
        playerBattleData:fromDic(rtnData.info)
        -- getMainLayer():getParent():addChild(createTeamCompLayer(userdata:getUserBattleInfo(), playerBattleData))
        getMainLayer():getParent():addChild(createTeamPopupLayer(-140))
        _layer:removeFromParentAndCleanup(true)
    end
end


local function hzzrBtnClick()
    local ceoId = _unionInfo["league"]["ceoId"]
    doActionFun("ARENA_GET_BATTLE_INFO", {ceoId}, _getBattleInfoCallback)
end
--点击会长阵容
UnionInfoViewOwner["hzzrBtnClick"] = hzzrBtnClick


-- 刷新UI数据
local function _refreshUI()

    local unionDetailInfo = _unionInfo

    local unionRank = _unionId+1
    local unionName = unionDetailInfo["league"]["name"]
    local unionMembers = getMyTableCount(unionDetailInfo["league"]["members"])
    local unionMemberMax = unionDetailInfo["league"]["memberMax"]
    local unionNotice = unionDetailInfo["league"]["notice"]

    local unionRankLabel = tolua.cast(UnionInfoViewOwner["unionRankLabel"],"CCLabelTTF")
    unionRankLabel:setString(string.format("%d",unionRank))
    local unionNameLabel = tolua.cast(UnionInfoViewOwner["unionNameLabel"],"CCLabelTTF")
    unionNameLabel:setString(unionName)
    local unionMemberLabel = tolua.cast(UnionInfoViewOwner["unionMemebersLabel"],"CCLabelTTF")
    unionMemberLabel:setString(HLNSLocalizedString("union.rank.membersCount_info",unionMembers,unionMemberMax))


    local unionNoticeArea = tolua.cast(UnionInfoViewOwner["noticeArea"],"CCLayerColor")
    local noticeLabel = CCLabelTTF:create(unionNotice,"ccbResources/FZCuYuan-M03S",20,unionNoticeArea:getContentSize(),kCCTextAlignmentLeft)
    
    noticeLabel:setAnchorPoint(ccp(0,1))
    noticeLabel:setPosition(ccp(0,unionNoticeArea:getContentSize().height))
    unionNoticeArea:addChild(noticeLabel)


    addTableView()
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/UnionInfoView.ccbi", proxy, true,"UnionInfoViewOwner")
    _layer = tolua.cast(node,"CCLayer")

end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(UnionInfoViewOwner["infoBg"], "CCSprite")
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

    local menu1 = tolua.cast(UnionInfoViewOwner["menu"], "CCMenu")
    menu1:setHandlerPriority(_priority - 1)
end


local function getUnionDetailInfoCallback(url,rtnData)
    -- body
    if rtnData["code"] == 200 then
        _unionInfo = rtnData["info"]
        _refreshUI()
    else
        print("获取联盟信息失败，联盟id:",_unionId)
    end
end

-- 该方法名字每个文件不要重复
function getUnionRankInfoLayer()
    return _layer
end

--创建联盟信息层
function createUnionRankInfoLayer(unionId,priority)
    _unionId = unionId
    _priority = (priority ~= nil) and priority or -132
    _init()

    local function _onEnter()
        print("onEnter")
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)

        local unionId = unionData.rank[string.format("%d",_unionId)]["id"]
        doActionFun("GET_UNION_DETAIL_INFO", {unionId}, getUnionDetailInfoCallback)
    end

    local function _onExit()
        print("onExit")
        _layer = nil
        unionId = nil
        _priority = -132
        _unionInfo = nil
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