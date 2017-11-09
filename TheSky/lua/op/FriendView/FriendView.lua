local _layer

local RecruitBtn
local ItemBtn
local GiftBagBtn
local LogueTitleLayer
local LogueContentLayer

local emptyLabel

local _tableView

local _contentData = {}

local _tabType

local cellArray = {}

FriendViewOwner = FriendViewOwner or {}
ccb["FriendViewOwner"] = FriendViewOwner

local function setSpriteFrame( sender,bool )
    if bool then
        sender:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_1.png"))
        sender:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_1.png"))
    else
        sender:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_0.png"))
        sender:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_1.png"))
    end
end

local function getFriendListCallBack( url,rtnData )
    if rtnData.code == 200 then
        friendData.friends = deepcopy(rtnData["info"])
        _contentData = deepcopy(rtnData["info"])
        emptyLabel:setVisible(false)   
        local friendCountLabel = tolua.cast(FriendViewOwner["friendCountLabel"],"CCLabelTTF")
        friendCountLabel:setString(getMyTableCount(_contentData).." / "..vipdata:getFriendLimitByVipLevel(vipdata:getVipLevel() + 1))
        if getMyTableCount(_contentData) <= 0 then
            emptyLabel:setVisible(true)
            emptyLabel:setString(HLNSLocalizedString("报告船长，您还没有结交任何好友，点击加好友，可以查找其他海贼团！"))
        end
        local function sortFun( a,b )
            
        end
        cellArray = {}
        _tableView:reloadData()
        generateCellAction( cellArray,getMyTableCount(_contentData) )
        cellArray = {}
    end
end

local function getFriendList()
    doActionFun("GET_FRIENDLIST_URL",{},getFriendListCallBack)
end

local function getEnemyListCallBack( url,rtnData )
    if rtnData.code == 200 then
        _contentData = rtnData["info"]
        emptyLabel:setVisible(false)
        if getMyTableCount(_contentData) <= 0 then
            emptyLabel:setVisible(true)
            emptyLabel:setString(HLNSLocalizedString("报告船长，本团暂时还木有仇敌，决斗战斗结束后可添加！"))
        end
        cellArray = {}
        _tableView:reloadData()
        generateCellAction( cellArray,getMyTableCount(_contentData) )
        cellArray = {}
    end
end

local function getFollowListCallBack( url,rtnData )
    if rtnData.code == 200 then
        _contentData = rtnData["info"]
        emptyLabel:setVisible(false)
        if getMyTableCount(_contentData) <= 0 then
            emptyLabel:setVisible(true)
            emptyLabel:setString(HLNSLocalizedString("报告船长，本团暂时还没有关注仇敌，可在仇敌内选择一个海贼团关注，轻松关注ta的一举一动，时机成熟立即消灭！"))
        end
        cellArray = {}
        _tableView:reloadData()
        generateCellAction( cellArray,getMyTableCount(_contentData) )
        cellArray = {}
    end
end

local function getEnemyList(  )
    doActionFun("GET_ENEMYLIST_URL",{},getEnemyListCallBack)
end

local function getFollowList(  )
    doActionFun("GET_FOLLOWLIST_URL",{},getFollowListCallBack)
end

local function _RecruitBtnAction( tag,sender )
    Global:instance():TDGAonEventAndEventData("mutual1")
    setSpriteFrame(RecruitBtn,true)
    setSpriteFrame(ItemBtn,false)
    setSpriteFrame(GiftBagBtn,false)
    getFriendList()
    _tabType = 0
    local friendCountLabel = tolua.cast(FriendViewOwner["friendCountLabel"],"CCLabelTTF")
    friendCountLabel:setVisible(true)
end

local function _itemBtnAction(  )
    Global:instance():TDGAonEventAndEventData("mutual2")
    setSpriteFrame(RecruitBtn,false)
    setSpriteFrame(ItemBtn,true)
    setSpriteFrame(GiftBagBtn,false)
    getEnemyList()
    _tabType = 1
    local friendCountLabel = tolua.cast(FriendViewOwner["friendCountLabel"],"CCLabelTTF")
    friendCountLabel:setVisible(false)
end

local function _GiftBagBtnAction(  )
    Global:instance():TDGAonEventAndEventData("mutual3")
    setSpriteFrame(RecruitBtn,false)
    setSpriteFrame(ItemBtn,false)
    setSpriteFrame(GiftBagBtn,true)
    getFollowList()
    _tabType = 2
    local friendCountLabel = tolua.cast(FriendViewOwner["friendCountLabel"],"CCLabelTTF")
    friendCountLabel:setVisible(false)
end

local function _payBtnAction(  )
    local _mainLayer = getMainLayer()
    if _mainLayer then
        _mainLayer:gotoAddFriendLayer()
    end
end

FriendViewOwner["_RecruitBtnAction"] = _RecruitBtnAction
FriendViewOwner["_itemBtnAction"] = _itemBtnAction
FriendViewOwner["_GiftBagBtnAction"] = _GiftBagBtnAction
FriendViewOwner["_payBtnAction"] = _payBtnAction


local function _addTableView()
    -- 得到数据
    local _topLayer = FriendViewOwner["FriendTitleLayer"]

    FriendTableCellOwner = FriendTableCellOwner or {}
    ccb["FriendTableCellOwner"] = FriendTableCellOwner

    local function rightBtnAction( tag,sender )
        local item = _contentData[tostring(tag)]
        if _tabType == 0 then
            getMainLayer():addChild(createLeaveMessageLayer(item["name"],item["id"],-500))
        elseif _tabType == 1 then
            if item.from == 0 then
                -- 前往论剑
                getMainLayer():gotoArena()
            elseif item.from ==  1 then
                -- 前往残障
                getMainLayer():gotoAdventure()
            end
        end
    end 

    FriendTableCellOwner["rightBtnAction"] = rightBtnAction

    local function onBgTaped( tag,sender )
        local item = _contentData[tostring(tag)]
        if item.from then
            getMainLayer():addChild(createFriendOptionLayer(item["name"],item["id"],_tabType,-400,item.from),10)
        else
            getMainLayer():addChild(createFriendOptionLayer(item["name"],item["id"],_tabType,-400),10)
        end
        friendPopUpCallBackFun.successFun = getFriendList
        friendPopUpCallBackFun.unFollowFun = getFollowList
    end

    FriendTableCellOwner["onBgTaped"] = onBgTaped
    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(winSize.width, 170 * retina)
        elseif fn == "cellAtIndex" then
            -- Return CCTableViewCell, a1 is cell index (zero based), a2 is dequeued cell (maybe nil)
            -- Do something to create cell  and change the content
            
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            --单条数据
            local item = _contentData[tostring(a1)]
            local  proxy = CCBProxy:create()
            local  _hbCell  = tolua.cast(CCBReaderLoad("ccbResources/FriendViewCell.ccbi",proxy,true,"FriendTableCellOwner"),"CCLayer")
            local nameLabel = tolua.cast(FriendTableCellOwner["nameLabel"],"CCLabelTTF")
            nameLabel:setString(item.name)

            local levelLabel = tolua.cast(FriendTableCellOwner["levelLabel"],"CCLabelTTF")
        
            levelLabel:setString(HLNSLocalizedString("Lv:%s",item.level))
           

            local bgBtn = tolua.cast(FriendTableCellOwner["bgBtn"],"CCMenuItemImage")
            bgBtn:setTag(a1)

            local rightBtn = tolua.cast(FriendTableCellOwner["rightBtn"],"CCMenuItemImage")
            local rightSprite = tolua.cast(FriendTableCellOwner["rightTitle"],"CCSprite")
            rightBtn:setTag(a1)
            if _tabType == 0 then
                rightBtn:setVisible(true)
                rightSprite:setVisible(true)
                rightBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn4_0.png"))
                rightBtn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn4_1.png"))
                rightSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("liuyan_title.png"))
            elseif _tabType == 1 then
                rightBtn:setVisible(true)
                rightSprite:setVisible(true)
                rightBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn2_0.png"))
                rightBtn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn2_1.png"))
                local enemyFromLable = tolua.cast(FriendTableCellOwner["enemyFromLable"],"CCLabelTTF")
                enemyFromLable:setVisible(true)
                if item.from == 0 then
                    -- 论剑
                    rightSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("juedou_title.png"))
                    enemyFromLable:setString(HLNSLocalizedString("决斗仇敌"))
                else
                    -- 残障
                    rightSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("fanji_title.png"))
                    enemyFromLable:setString(HLNSLocalizedString("日常仇敌"))
                end
                
            elseif _tabType == 2 then
                rightBtn:setVisible(false)
                rightSprite:setVisible(false)
            end

            _hbCell:setScale(retina)
            a2:addChild(_hbCell, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            _hbCell:stopAllActions()
            cellArray[tostring(a1)] = _hbCell
            r = a2
        elseif fn == "numberOfCells" then
            -- Return number of cells
            -- r = table.getTableCount(shopContent)
            r = getMyTableCount(_contentData)
        -- Cell events:
        elseif fn == "cellTouched" then         -- A cell was touched, a1 is cell that be touched. This is not necessary.
            print(a1:getIdx())
        elseif fn == "cellTouchBegan" then      -- A cell is touching, a1 is cell, a2 is CCTouch
        elseif fn == "cellTouchEnded" then      -- A cell was touched, a1 is cell, a2 is CCTouch
        elseif fn == "cellHighlight" then       -- A cell is highlighting, coco2d-x 2.1.3 or above
        elseif fn == "cellUnhighlight" then     -- A cell had been unhighlighted, coco2d-x 2.1.3 or above
        elseif fn == "cellWillRecycle" then     -- A cell will be recycled, coco2d-x 2.1.3 or above
        end
        return r
    end)
    local _mainLayer = getMainLayer()
    local x = 1
    if _mainLayer then

        local size = CCSizeMake(winSize.width, (winSize.height - _topLayer:getContentSize().height - _mainLayer:getBottomContentSize().height)*99/100)  -- 这里是为了在tableview上面显示一个小空出来
        print(size.width.." "..size.height)
        _tableView = LuaTableView:createWithHandler(h, size)
        _tableView:setBounceable(true)
        _tableView:setAnchorPoint(ccp(0,0))
        _tableView:setPosition(0,_mainLayer:getBottomContentSize().height)
        _tableView:setVerticalFillOrder(0)
        _layer:addChild(_tableView)
    end
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/FriendView.ccbi",proxy, true,"FriendViewOwner")
    _layer = tolua.cast(node,"CCLayer")
    LogueContentLayer = tolua.cast(FriendViewOwner["FriendContentLayer"],"CCLayer")

    RecruitBtn = tolua.cast(FriendViewOwner["RecruitBtn"],"CCMenuItemImage")
    ItemBtn = tolua.cast(FriendViewOwner["ItemBtn"],"CCMenuItemImage")
    GiftBagBtn = tolua.cast(FriendViewOwner["GiftBagBtn"],"CCMenuItemImage")
    setSpriteFrame(RecruitBtn,true)
    setSpriteFrame(ItemBtn,false)
    setSpriteFrame(GiftBagBtn,false)
    local friendCountLabel = tolua.cast(FriendViewOwner["friendCountLabel"],"CCLabelTTF")
    friendCountLabel:setVisible(true)
    friendCountLabel:setPosition(ccp(friendCountLabel:getPositionX(),getMainLayer():getBottomContentSize().height + 20))
    _layer:reorderChild(LogueContentLayer,100)
    emptyLabel = tolua.cast(FriendViewOwner["emptyLabel"],"CCLabelTTF")
end

local function setMenuPriority()
    local myCCMenu = tolua.cast(FriendViewOwner["myCCMenu"],"CCMenu")
    myCCMenu:setHandlerPriority(-129)
end


function getFriendViewLayer()
    return _layer
end


function createFriendViewLayer()
    _init()

    -- public方法写在每个layer的创建的方法内 调用时方法
    -- local layer = getLayer()
    -- layer:refresh()

    function _layer:refresh()
        
    end

    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
        _addTableView()
        getFriendList()
        _tabType = 0
    end

    local function _onExit()
        _layer = nil
        _contentData = {}
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