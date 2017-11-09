local _layer
local _tableView
local _UnionMainView
local _members

unionMemberLayerOwner = unionMemberLayerOwner or {}
ccb["unionMemberLayerOwner"] = unionMemberLayerOwner

local function onExitTaped(  )
    _UnionMainView:gotoShowInner()
end

unionMemberLayerOwner["onExitTaped"] = onExitTaped
function unionMember_freshData(  )
    if _tableView then
        _members = unionData.members
        _tableView:reloadData()
    end
end

local function _addTableView()

    local function onCellBgClicked( tag,sender )
        -- print("我该弹框了",tag)
        local function quitCallBack( url, rtnData )
            -- 退出联盟
            if rtnData.code == 200 then
                ShowText(string.format(HLNSLocalizedString("您已退出联盟【%s】"),unionData.detail.name))
                unionData:resetAllData()
                _UnionMainView:refreshUnion( )
            end
        end

        local function deleteCallBack( url, rtnData )
            -- 解散联盟         
            if rtnData.info.result == true then
                ShowText(string.format(HLNSLocalizedString("联盟【%s】已解散"),unionData.detail.name))
                unionData:resetAllData()
                _UnionMainView:refreshUnion( )
            end
        end
        -- 发请求
        local function cardConfirmAction(  )
            if unionData.selfMemberInfo.duty == 1 then
                doActionFun("LEAGUE_DELETE",{ },deleteCallBack)
            else
                doActionFun("LEAGUE_QUIT",{ },quitCallBack) 
            end
        end
        local function cardCancelAction(  )
            -- body
        end
        -- 第二次弹框
        local function confirmUnionCard(  )
            -- if unionData.selfMemberInfo.duty == 1 then 
            -- 是否有权限解散联盟
            if unionData:IsPermitted(unionData.selfMemberInfo.duty, UNION_DISMISS) then
                _layer:addChild(createSimpleConfirCardLayer(string.format(HLNSLocalizedString("确定解散联盟【%s】？"),unionData.detail.name)))
                SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
                SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction
            else
                _layer:addChild(createSimpleConfirCardLayer(string.format(HLNSLocalizedString("确定退出联盟【%s】？"),unionData.detail.name)))
                SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
                SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction
            end
        end
        -- 点击自己
        if userdata.userId == _members[tostring(tag)].playerId then
            print(_members[tostring(tag)].playerId)
            -- 第一个弹框确认
            _layer:addChild(createUnionConfirmCard(unionData.selfMemberInfo.duty))
            UnionConfirmCard.confirmMenuCallBackFun = confirmUnionCard
        else
            if getMainLayer() then
                getMainLayer():addChild(createUnionMemberMenu(_members[tostring(tag)]))
            end
        end
    end

    local _topLayer = unionMemberLayerOwner["BSTopLayer"]
    local _titleLayer = unionMemberLayerOwner["titleBg"]
 
    unionMemberCellOwner = unionMemberCellOwner or {}
    ccb["unionMemberCellOwner"] = unionMemberCellOwner

    unionMemberCellOwner["onCellBgClicked"] = onCellBgClicked
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
            local  proxy = CCBProxy:create()
            local _hbCell = tolua.cast(CCBReaderLoad("ccbResources/unionMemberCell.ccbi",proxy,true,"unionMemberCellOwner"),"CCLayer")
            
            local cellBg = tolua.cast(unionMemberCellOwner["cellBg"],"CCMenu")
            cellBg:setTag(a1)
            local name = tolua.cast(unionMemberCellOwner["name"],"CCLabelTTF")
            PrintTable(_members[tostring(a1)])
            if _members[tostring(a1)].vipLevel and _members[tostring(a1)].vipLevel > 0 then
                name:setString(string.format("%s(V%d)", _members[tostring(a1)].name, _members[tostring(a1)].vipLevel))
            else
                name:setString(_members[tostring(a1)].name)
            end
            local identity = tolua.cast(unionMemberCellOwner["identity"],"CCLabelTTF")
            str = unionData:getNameByDuty(_members[tostring(a1)].duty) 
            identity:setString(str)
            local level = tolua.cast(unionMemberCellOwner["level"],"CCLabelTTF")
            str = _members[tostring(a1)].level
            level:setString(str)
            local rank = tolua.cast(unionMemberCellOwner["rank"],"CCLabelTTF")
            str = _members[tostring(a1)].arenaRank
            rank:setString(str)
            local contribute = tolua.cast(unionMemberCellOwner["contribute"],"CCLabelTTF")
            str = _members[tostring(a1)].contribution
            contribute:setString(str)

            _hbCell:setScale(retina)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            a2:addChild(_hbCell, 0, 1)
            r = a2
        elseif fn == "numberOfCells" then
            -- Return number of cells
            r = getMyTableCount(_members)
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
        -- 提示信息
        local countLabel = tolua.cast(unionMemberLayerOwner["countLabel"], "CCLabelTTF")
        countLabel:setString(string.format(HLNSLocalizedString("成员数 %d/%d"),getMyTableCount(_members),unionData.detail.memberMax))
        countLabel:setPosition(winSize.width * 3 / 100, _mainLayer:getBottomContentSize().height)
        local tipsLabel = tolua.cast(unionMemberLayerOwner["tipsLabel"], "CCLabelTTF")
        tipsLabel:setString(HLNSLocalizedString("见习会员24小时自动变为普通会员"))
        tipsLabel:setPosition(winSize.width * 97 / 100, _mainLayer:getBottomContentSize().height)
        local high = countLabel:getContentSize().height      -- 提示信息的高度
        -- 创建tableview
        local size = CCSizeMake(winSize.width, (winSize.height - high * retina - _topLayer:getContentSize().height - _mainLayer:getBottomContentSize().height) - _titleLayer:getContentSize().height * retina)      -- 这里是为了在tableview上面显示一个小空出来
        print(size.width.." "..size.height)
        _tableView = LuaTableView:createWithHandler(h, size)
        _tableView:setBounceable(true)
        _tableView:setAnchorPoint(ccp(0,0))
        _tableView:setPosition(ccp(0, _mainLayer:getBottomContentSize().height + high * retina))
        _tableView:setVerticalFillOrder(0)
        _layer:addChild(_tableView) 
    end
end


local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/unionMemberLayer.ccbi",proxy, true,"unionMemberLayerOwner")
    _layer = tolua.cast(node,"CCLayer")
end


function getUnionMemberLayer()
	return _layer
end

function createUnionMemberLayer( unionMainView )

    _init()
    _UnionMainView = unionMainView


    local function _onEnter()
        _members = unionData.members
        _addTableView()
    end

    local function _onExit()
        _layer = nil
        _tableView = nil
        _members = nil
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