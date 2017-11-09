local _layer

local atkBtn -- 进攻按钮
local fanhuiBtn -- 返回按钮
local GiftBagBtn
local LogueContentLayer

local _mailContent = {}


local _uiType

local _tableView

local cellArray = {}
local _data

SSABattlelogsViewOwner = SSABattlelogsViewOwner or {} 
ccb["SSABattlelogsViewOwner"] = SSABattlelogsViewOwner

local function setSpriteFrame( sender,bool )
    if bool then
        sender:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_1.png"))
        sender:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_1.png"))
    else
        sender:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_0.png"))
        sender:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_1.png"))
    end
end

-- 刷新进攻邮件数目
local function refreshAtkCountLabel(  )
    local countBg = tolua.cast(SSABattlelogsViewOwner["countBg1"],"CCSprite")
    local countLabel = tolua.cast(SSABattlelogsViewOwner["label1"],"CCSprite")
    local sysCount = getMyTableCount(_data.atk)
    if sysCount > 0 then
        countBg:setVisible(true)
        countLabel:setString(sysCount)
    else
        countBg:setVisible(false)
    end
end

-- 刷新防守邮件数目
local function refreshDefCountLabel(  )
    local countBg = tolua.cast(SSABattlelogsViewOwner["countBg2"],"CCSprite")
    local countLabel = tolua.cast(SSABattlelogsViewOwner["label2"],"CCSprite")
    local defCount = getMyTableCount(_data.def)
    if defCount > 0 then
        countBg:setVisible(true)
        countLabel:setString(defCount)
    else
        countBg:setVisible(false)
    end
end

local function refreshCountLabel(  )
    refreshAtkCountLabel()
    refreshDefCountLabel()
end

local function setEmptyLabel( )
    local emptyLabel = tolua.cast(SSABattlelogsViewOwner["emptyLabel"],"CCLabelTTF")
    emptyLabel:setVisible(false)
    if getMyTableCount(_mailContent) <= 0 then
        emptyLabel:setVisible(true)
        if _uiType == 0 then
            emptyLabel:setString(HLNSLocalizedString("SSA.battleLogsDesp1"))
        elseif _uiType == 1 then
            emptyLabel:setString(HLNSLocalizedString("SSA.battleLogsDesp2"))
        elseif _uiType == 2 then
            emptyLabel:setString(HLNSLocalizedString("SSA.battleLogsDesp3"))
        end 
    end
end

-- 根据时间排序
-- local function sortMailContent(  )
--     local function sorFun( a,b )
--         return a.time > b.time
--     end 
--     table.sort( _mailContent,sorFun )
-- end


local function _atkBtnBtnAction( tag,sender )
    setSpriteFrame(atkBtn,true)
    setSpriteFrame(defBtn,false)
    _mailContent = _data.atk
    -- sortMailContent()
    _uiType = 0
    setEmptyLabel()
    cellArray = {}
    _tableView:reloadData()
    generateCellAction( cellArray,getMyTableCount(_mailContent) )
    cellArray = {}
    refreshAtkCountLabel()
end

local function _defBtnAction(  )
    setSpriteFrame(atkBtn,false)
    setSpriteFrame(defBtn,true)
    _uiType = 1
    _mailContent = _data.def
    -- sortMailContent()
    setEmptyLabel()
    cellArray = {}
    _tableView:reloadData()
    generateCellAction( cellArray,getMyTableCount(_mailContent) )
    cellArray = {}
    refreshDefCountLabel()
    
end

--返回按钮
local function _fanhuiBtnAction()
    runtimeCache.SSAState = ssaDataFlag.home
    getMainLayer():gotoAdventure()
end

SSABattlelogsViewOwner["_atkBtnBtnAction"] = _atkBtnBtnAction
SSABattlelogsViewOwner["_defBtnAction"] = _defBtnAction
SSABattlelogsViewOwner["_fanhuiBtnAction"] = _fanhuiBtnAction


local function _addTableView()
    -- 得到数据
    -- _mailContent = _sysMailData
    -- sortMailContent()
    local _topLayer = SSABattlelogsViewOwner["NewsTitleLayer"]
    SSABattleLogsCellOwner = SSABattleLogsCellOwner or {}
    ccb["SSABattleLogsCellOwner"] = SSABattleLogsCellOwner
    
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
            local oneMail = _mailContent[tostring(getMyTableCount(_mailContent) - a1 - 1)]
            local  proxy = CCBProxy:create()
            local  _hbCell  = tolua.cast(CCBReaderLoad("ccbResources/SSABattleLogsCell.ccbi",proxy,true,"SSABattleLogsCellOwner"),"CCLayer")
           
            local contentLabel = tolua.cast(SSABattleLogsCellOwner["contentLabel"],"CCLabelTTF")
            local timeLabel = tolua.cast(SSABattleLogsCellOwner["timeLabel"],"CCLabelTTF")
            local battleLogDesp = tolua.cast(SSABattleLogsCellOwner["battleLogDesp"],"CCLabelTTF")
            timeLabel:setVisible(true)
            timeLabel:setString(DateUtil:second2dhms(userdata.loginTime - oneMail.time)..HLNSLocalizedString("news.ago"))
            contentLabel:setVisible(true)
            contentLabel:setString(oneMail.desp)

            if oneMail.exp then
                if oneMail.exp <= 0 then
                else
                    battleLogDesp:setVisible(true)
                    if _uiType == 0 then
                        battleLogDesp:setString(HLNSLocalizedString("SSA.battleLogAdd") .. oneMail.exp)
                    else
                        battleLogDesp:setString(HLNSLocalizedString("SSA.battleLogReduce") .. math.abs(oneMail.exp))
                    end
                end
            end
            
            _hbCell:setScale(retina)
            a2:addChild(_hbCell, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            _hbCell:stopAllActions()
            cellArray[tostring(a1)] = _hbCell
            r = a2
        elseif fn == "numberOfCells" then
            r = getMyTableCount(_mailContent)
        -- Cell events:
        elseif fn == "cellTouched" then         -- A cell was touched, a1 is cell that be touched. This is not necessary.
            -- print(a1:getIdx())
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
        local size = CCSizeMake(winSize.width, (winSize.height - _topLayer:getContentSize().height - _mainLayer:getBottomContentSize().height)*99/100)  -- 这里是为了在tableview上面显示一个小空出来
        print(size.width.." "..size.height)
        _tableView = LuaTableView:createWithHandler(h, size)
        _tableView:setBounceable(true)
        _tableView:setAnchorPoint(ccp(0,0))
        _tableView:setPosition(0,_mainLayer:getBottomContentSize().height)
        _tableView:setVerticalFillOrder(0)
        _layer:addChild(_tableView,1000)
    end
end

local function refreshMails()
    
    setEmptyLabel()
    cellArray = {}
    _addTableView()
    generateCellAction( cellArray,getMyTableCount(_mailContent) )  --生成tableview每条cell的滑动效果
    cellArray = {}
    refreshCountLabel()
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/SSABattlelogsView.ccbi",proxy, true,"SSABattlelogsViewOwner")
    _layer = tolua.cast(node,"CCLayer")
    LogueContentLayer = tolua.cast(SSABattlelogsViewOwner["FriendContentLayer"],"CCLayer")

    atkBtn = tolua.cast(SSABattlelogsViewOwner["atkBtn"],"CCMenuItemImage") -- 进攻
    defBtn = tolua.cast(SSABattlelogsViewOwner["defBtn"],"CCMenuItemImage") -- 领奖
    fanhuiBtn = tolua.cast(SSABattlelogsViewOwner["fanhuiBtn"],"CCMenuItemImage") --返回
    setSpriteFrame(atkBtn,true) 
    setSpriteFrame(defBtn,false)
end


function getSSABattlelogsViewOwnerLayer()
    return _layer
end

function createSSABattlelogsViewOwnerLayer()
    _init()
    _data = ssaData.data
    _mailContent = _data.atk
    
    -- public方法写在每个layer的创建的方法内 调用时方法
    -- local layer = getLayer()
    -- layer:refresh()

    function _layer:refresh()
        
    end

    local function _onEnter()
        _uiType = 0
        refreshMails()
        maildata:setCheckTime(maildata:getNewMailTime())
    end

    local function _onExit()
        _layer = nil
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