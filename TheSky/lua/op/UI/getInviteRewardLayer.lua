local _layer
local _priority
local _rewardKey
local _tableView


-- 名字不要重复
GetInviteRewardOwner = GetInviteRewardOwner or {}
ccb["GetInviteRewardOwner"] = GetInviteRewardOwner

local function closeItemClick(  )
    popUpCloseAction( GetInviteRewardOwner,"infoBg",_layer )
end

GetInviteRewardOwner["closeItemClick"] = closeItemClick

local function confirmBtnTaped(  )
    popUpCloseAction( GetInviteRewardOwner,"infoBg",_layer ) 
end

GetInviteRewardOwner["confirmBtnTaped"] = confirmBtnTaped
local function _addTableView()

    --获取邀请礼包的数据
    local inviteRewardData = dailyData:getInviteRewardData()
    --获取当前点击礼包的数据
    local rewardData = inviteRewardData[string.format("inviteNumber%d",_rewardKey)]["items"]

    GetSomeRewardCellOwner = GetSomeRewardCellOwner or {}
    ccb["GetSomeRewardCellOwner"] = GetSomeRewardCellOwner

    local containLayer = tolua.cast(GetInviteRewardOwner["containLayer"],"CCLayer")

    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(600, 120)
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
            _hbCell = tolua.cast(CCBReaderLoad("ccbResources/GetSomeBigRewardCell.ccbi",proxy,true,"GetSomeRewardCellOwner"),"CCLayer")

            local rankFrame = tolua.cast(GetSomeRewardCellOwner["rankFrame"],"CCSprite")
            local avatarSprite = tolua.cast(GetSomeRewardCellOwner["avatarSprite"],"CCSprite")
            local itemName = tolua.cast(GetSomeRewardCellOwner["itemName"],"CCLabelTTF")
            local countLabel = tolua.cast(GetSomeRewardCellOwner["countLabel"],"CCLabelTTF")

            --获取资源table
            local res = wareHouseData:getItemResource(rewardData[a1+1]["itemId"])


            if rankFrame then 
                rankFrame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", res["rank"])))
            end

            if avatarSprite then 
                local texture = CCTextureCache:sharedTextureCache():addImage(res["icon"])
                if texture then 
                    avatarSprite:setTexture(texture)
                    avatarSprite:setVisible(true)
                end 
            end

            if itemName then
                itemName:setString(rewardData[a1+1]["name"])
            end

            if countLabel then 
                countLabel:setString(rewardData[a1+1]["amount"])
            end
            
            a2:addChild(_hbCell, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            r = a2
        elseif fn == "numberOfCells" then
            r = getMyTableCount(rewardData)
        -- Cell events:
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

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer

    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/GetInvitePopUp.ccbi",proxy, true,"GetInviteRewardOwner")
    _layer = tolua.cast(node,"CCLayer")

    --更改窗口标题
    local titleLabel = tolua.cast(GetInviteRewardOwner["frameTitle"],"CCLabelTTF")
    titleLabel:setString(HLNSLocalizedString("daily.invite.RewardTipFrame.title"))
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(GetInviteRewardOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction( GetInviteRewardOwner,"infoBg",_layer )
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
    local menu1 = tolua.cast(GetInviteRewardOwner["closeMenu"], "CCMenu")
    menu1:setHandlerPriority(_priority - 1)

    _tableView:setTouchPriority(_priority - 2)
end

-- 该方法名字每个文件不要重复
function getGetInviteRewardLayer()
	return _layer
end

function createGetInviteRewardLayer( rewardKey, priority)
    _rewardKey = rewardKey
    _priority = (priority ~= nil) and priority or -132
    _init()

    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
        _addTableView()

        popUpUiAction( GetInviteRewardOwner,"infoBg" )
    end

    local function _onExit()
        _priority = nil
        _itemArray = nil
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


    _layer:registerScriptTouchHandler(onTouch ,false ,_priority ,true )
    _layer:setTouchEnabled(true)
    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end