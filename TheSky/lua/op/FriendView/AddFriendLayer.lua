local _layer
local _tableView = nil
local editBox

local addFriendLabel

local firendArray = {}

local inviateState = {}   -- 0 未邀请，1 已邀请

local cellArray = {}

AddFrienndLayerOwner = AddFrienndLayerOwner or {}
ccb["AddFrienndLayerOwner"] = AddFrienndLayerOwner

local function onExitBtnTaped(  )
    local _mainLayer = getMainLayer()
    if _mainLayer then
        _mainLayer:gotoFriendViewLayer()
    end
end

AddFrienndLayerOwner["onExitBtnTaped"] = onExitBtnTaped

local function searchByNameCallBack( url,rtnData )
    if rtnData["code"] == 200 then
        inviateState = {}
        firendArray = rtnData["info"]
        if getMyTableCount(firendArray) <= 0 then
            addFriendLabel:setString(HLNSLocalizedString("报告船长，无此团踪迹，请船长检查是否输入有误。"))
        else
            addFriendLabel:setString("")
        end
        _tableView:reloadData()
    end
end

local function getFriendByName( name )
    doActionFun("SEARCH_PLAYER",{ name },searchByNameCallBack)
end

local function onConfirmTaped(  )
    local nameStr = editBox:getText()
    getFriendByName(nameStr)
end

AddFrienndLayerOwner["onConfirmTaped"] = onConfirmTaped

local function _addTableView()
    local _topLayer = AddFrienndLayerOwner["BSTopLayer"]
    local editBoxBg = tolua.cast(AddFrienndLayerOwner["editBoxBg"],"CCLayer") 
    AddFriendViewCellOwner = AddFriendViewCellOwner or {}
    ccb["AddFriendViewCellOwner"] = AddFriendViewCellOwner



    local function addFriendTaped( tag,sender )
        local friend = firendArray[tostring(tag)] 

        local function inviteFriendCallBack( url,rtnData )
            if rtnData.code == 200 then
                inviateState[tonumber(tag + 1)] = 1
                local Table1OffsetY = _tableView:getContentOffset().y
                _tableView:reloadData()
                _tableView:setContentOffset(ccp(0, Table1OffsetY))
            else

            end
        end
        if friendData:getFriendCount( ) >= vipdata:getFriendLimitByVipLevel(vipdata:getVipLevel() + 1) then
            local text = HLNSLocalizedString("船长，您目前已有 %s 名好友，成为 VIP%s ，可以拥有 %s 名好友，快去提高VIP的等级，结交更多好友，提高您的知名度吧！",friendData:getFriendCount( ),vipdata:getVipLevel() + 1,vipdata:getFriendLimitByVipLevel(vipdata:getVipLevel() + 2))
            local function cardConfirmAction(  )
                CCDirector:sharedDirector():getRunningScene():addChild(createShopRechargeLayer(-400), 100)
            end
            local function cardCancelAction(  )
                
            end
            _layer:addChild(createSimpleConfirCardLayer(text), 100)
            SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
            SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction
        else
            doActionFun("INVITE_FRIEND_URL",{ friend.id },inviteFriendCallBack)
        end
    end

    AddFriendViewCellOwner["addFriendTaped"] = addFriendTaped

    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
                r = CCSizeMake(winSize.width, 180 * retina)
        elseif fn == "cellAtIndex" then
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            
            local friend = firendArray[tostring(a1)]
            local  proxy = CCBProxy:create()
            local  _hbCell
                _hbCell  = tolua.cast(CCBReaderLoad("ccbResources/AddFriendViewCell.ccbi",proxy,true,"AddFriendViewCellOwner"),"CCLayer")
                
                local nameLabel = tolua.cast(AddFriendViewCellOwner["nameLabel"],"CCLabelTTF")
                nameLabel:setString(friend.name)

                local levelLabel = tolua.cast(AddFriendViewCellOwner["levelLabel"],"CCLabelTTF")
                levelLabel:setString(HLNSLocalizedString("LV:")..friend.level)

                
                local addTitle = tolua.cast(AddFriendViewCellOwner["addTitle"],"CCSprite")

                local inviateBtn = tolua.cast(AddFriendViewCellOwner["addFriendBtn"],"CCMenuItemImage")
                inviateBtn:setTag(a1)

                local isInvited = tolua.cast(AddFriendViewCellOwner["isInvited"],"CCLabelTTF")
                if friend.isInvited == 0 then
                    if not inviateState[tonumber(a1 + 1)] then
                        inviateBtn:setVisible(true)
                        inviateState[tonumber(a1 + 1)] = 0
                        addTitle:setVisible(true)
                        isInvited:setVisible(false)
                    else
                        if inviateState[tonumber(a1 + 1)] == 0 then
                            inviateBtn:setVisible(true)
                            addTitle:setVisible(true)
                            isInvited:setVisible(false)
                        elseif inviateState[tonumber(a1 + 1)] == 1 then
                            inviateBtn:setVisible(false)
                            addTitle:setVisible(false)
                            isInvited:setVisible(true)
                        end
                    end
                else
                    isInvited:setVisible(true)
                    inviateBtn:setVisible(false)
                    addTitle:setVisible(false)
                end

                if friendData:isFriend( friend.id ) == 1 then
                    inviateBtn:setVisible(false)
                    addTitle:setVisible(false)
                    isInvited:setVisible(true)
                    isInvited:setString(HLNSLocalizedString("friend.alreadyFriend"))
                else
                    print("不是你的好友")
                end

            _hbCell:setScale(retina)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            a2:addChild(_hbCell, 0, 1)
            _hbCell:stopAllActions()
            cellArray[tostring(a1)] = _hbCell
            r = a2
        elseif fn == "numberOfCells" then
            -- Return number of cells
            r = getMyTableCount(firendArray)
        -- Cell events:
        elseif fn == "cellTouched" then         -- A cell was touched, a1 is cell that be touched. This is not necessary.
            print("cellTouched",a1:getIdx())
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
        local size = CCSizeMake(winSize.width, (winSize.height - _topLayer:getContentSize().height - editBoxBg:getContentSize().height  * retina - _mainLayer:getBottomContentSize().height))      -- 这里是为了在tableview上面显示一个小空出来
        _tableView = LuaTableView:createWithHandler(h, size)
        _tableView:setBounceable(true)
        _tableView:setAnchorPoint(ccp(0,0))
        _tableView:setPosition(ccp(0, _mainLayer:getBottomContentSize().height))
        _tableView:setVerticalFillOrder(0)
        _layer:addChild(_tableView) 
    end
end



local function searchByLevelCallBack( url,rtnData )
    
    if rtnData["code"] == 200 then
        inviateState = {}
        firendArray = rtnData["info"]
        if getMyTableCount(firendArray) <= 0 then
            addFriendLabel:setString(HLNSLocalizedString("报告船长，无同等级海贼团踪迹"))
        end
        cellArray = {}
        _tableView:reloadData()
        generateCellAction( cellArray,getMyTableCount(firendArray) )
        cellArray = {}
    end
end

local function getFriendByLevel( level )
    doActionFun("SEARCH_BY_LEVEL",{ level },searchByLevelCallBack)
end

local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/AddFriendLayer.ccbi",proxy, true,"AddFrienndLayerOwner")
    _layer = tolua.cast(node,"CCLayer")
    addFriendLabel = tolua.cast(AddFrienndLayerOwner["addFriendLabel"],"CCLabelTTF")
    addFriendLabel:setString("")
    local editBoxBg = tolua.cast(AddFrienndLayerOwner["editBoxBg"],"CCLayer") 
    local confirmBtn = tolua.cast(AddFrienndLayerOwner["confirmBtn"],"CCMenuItemImage")
    local editBg = CCScale9Sprite:createWithSpriteFrameName("chat_bg.png")
    editBox = CCEditBox:create(CCSize(editBoxBg:getContentSize().width - confirmBtn:getContentSize().width - 40,editBoxBg:getContentSize().height - 10),editBg)
    editBox:setPosition(ccp(20,editBoxBg:getContentSize().height / 2))
    editBox:setAnchorPoint(ccp(0,0.5))
    editBox:setFont("ccbResources/FZCuYuan-M03S.ttf",30*retina)
    editBoxBg:addChild(editBox)
    editBox:setText(userdata.level)
    -- editBox:setPlaceHolder(userdata.level)
end


function getAddFriendLayer()
	return _layer
end

function createAddFriendLayer()
    _init()


    local function _onEnter()
        print("createAddFriendLayer onEnter")
        addFriendLabel:setString("")
        _addTableView()
        getFriendByLevel(userdata.level)
    end

    local function _onExit()
        print("createAddFriendLayer onExit")
        _layer = nil
        _tableView = nil
        inviateState = {}
        addFriendLabel = nil
        cellArray = {}
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