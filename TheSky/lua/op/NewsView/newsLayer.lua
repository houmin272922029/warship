local _layer

local RecruitBtn
local ItemBtn
local GiftBagBtn
local LogueTitleLayer
local LogueContentLayer

local _contentData
local _contentType
local _addFriendBtnState

local _currentTime

local _mailContent = {}

local  _sysMailData = {}
local _rewardMailData = {}
local _msgMailData = {}

local _uiType

local _tableView

local cellArray = {}

NewsViewOwner = NewsViewOwner or {} 
ccb["NewsViewOwner"] = NewsViewOwner

local function setSpriteFrame( sender,bool )
    if bool then
        sender:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_1.png"))
        sender:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_1.png"))
    else
        sender:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_0.png"))
        sender:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_1.png"))
    end
end

-- 刷新邮件数目
local function refreshSysCountLabel(  )
    local countBg = tolua.cast(NewsViewOwner["countBg1"],"CCSprite")
    local countLabel = tolua.cast(NewsViewOwner["label1"],"CCSprite")
    local sysCount = maildata:getSysNewMail(  )
    if sysCount > 0 then
        countBg:setVisible(true)
        countLabel:setString(sysCount)
    else
        countBg:setVisible(false)
    end
end

local function refreshAwardCountLabel(  )
    local countBg = tolua.cast(NewsViewOwner["countBg2"],"CCSprite")
    local countLabel = tolua.cast(NewsViewOwner["label2"],"CCSprite")
    local awardCount = maildata:getAwardNewMail(  )
    if awardCount > 0 then
        countBg:setVisible(true)
        countLabel:setString(awardCount)
    else
        countBg:setVisible(false)
    end
end

local function refreshMsgCountLabel(  )
    local countBg = tolua.cast(NewsViewOwner["countBg3"],"CCSprite")
    local countLabel = tolua.cast(NewsViewOwner["label3"],"CCSprite")
    local msgCount = maildata:getMesgNewMail(  )
    if msgCount > 0 then
        countBg:setVisible(true)
        countLabel:setString(msgCount)
    else
        countBg:setVisible(false)
    end
end

local function refreshCountLabel(  )
    refreshSysCountLabel()
    refreshAwardCountLabel()
    refreshMsgCountLabel()
end

local function setEmptyLabel( )
    local emptyLabel = tolua.cast(NewsViewOwner["emptyLabel"],"CCLabelTTF")
    emptyLabel:setVisible(false)
    if getMyTableCount(_mailContent) <= 0 then
        emptyLabel:setVisible(true)
        if _uiType == 0 then
            emptyLabel:setString(HLNSLocalizedString("报告船长，最近没有收到任何新闻，我们一直在风平浪静的海面上航行着，一切正常！"))
        elseif _uiType == 1 then
            emptyLabel:setString(HLNSLocalizedString("报告船长，本团没有收到任何领奖信息，快去冒险战斗，提高威望，获得奖励吧！"))
        elseif _uiType == 2 then
            emptyLabel:setString(HLNSLocalizedString("报告船长，您的威望还没有远播，快去战斗，干出一番惊天的事迹吧！"))
        end 
    end
end

local function sortMailContent(  )
    local function sorFun( a,b )
        return a.time > b.time
    end 
    table.sort( _mailContent,sorFun )
end


local function _RecruitBtnAction( tag,sender )
    Global:instance():TDGAonEventAndEventData("news1")
    setSpriteFrame(RecruitBtn,true)
    setSpriteFrame(ItemBtn,false)
    setSpriteFrame(GiftBagBtn,false)
    _mailContent = _sysMailData
    sortMailContent()
    _uiType = 0
    setEmptyLabel()
    cellArray = {}
    _tableView:reloadData()
    generateCellAction( cellArray,getMyTableCount(_mailContent) )
    cellArray = {}
    refreshSysCountLabel()
end

local function _itemBtnAction(  )
    Global:instance():TDGAonEventAndEventData("news2")
    setSpriteFrame(RecruitBtn,false)
    setSpriteFrame(ItemBtn,true)
    setSpriteFrame(GiftBagBtn,false)
    _uiType = 1
    _mailContent = _rewardMailData
    sortMailContent()
    setEmptyLabel()
    cellArray = {}
    _tableView:reloadData()
    generateCellAction( cellArray,getMyTableCount(_mailContent) )
    cellArray = {}
    refreshAwardCountLabel()
end

local function _GiftBagBtnAction(  )
    Global:instance():TDGAonEventAndEventData("news3")
    setSpriteFrame(RecruitBtn,false)
    setSpriteFrame(ItemBtn,false)
    setSpriteFrame(GiftBagBtn,true)
    _mailContent = _msgMailData
    _uiType = 2
    setEmptyLabel()
    sortMailContent()
    cellArray = {}
    _tableView:reloadData()
    generateCellAction( cellArray,getMyTableCount(_mailContent) )
    cellArray = {}
    refreshMsgCountLabel()
end

NewsViewOwner["_RecruitBtnAction"] = _RecruitBtnAction
NewsViewOwner["_itemBtnAction"] = _itemBtnAction
NewsViewOwner["_GiftBagBtnAction"] = _GiftBagBtnAction


local function _addTableView()
    -- 得到数据
    _mailContent = _sysMailData
    sortMailContent()
    _uiType = 0
    local _topLayer = NewsViewOwner["NewsTitleLayer"]
    NewsCellOwner = NewsCellOwner or {}
    ccb["NewsCellOwner"] = NewsCellOwner
    local function leaveMessageAction( tag,sender )
    end
    local function onFightTaped( tag,sender )
        local mail = _mailContent[tag]

        local function refuseFriendCallBack( url,rtnData )
            if rtnData.code == 200 then
                local id = mail.id
                maildata.mails[id] = nil
                table.remove(_msgMailData, tag)
                _mailContent = _msgMailData
                local offsetY = _tableView:getContentOffset().y
                _tableView:reloadData()
                if _tableView:getContentSize().height <= (winSize.height - _topLayer:getContentSize().height - getMainLayer():getBottomContentSize().height)*99/100  or offsetY < _tableView:getContentOffset().y then
                else
                    _tableView:setContentOffset(ccp(0, offsetY))
                end
            end
        end

        local function getRewardCallBack( url,rtnData )
            if rtnData.code == 200 then
                _rewardMailData[tag] = rtnData.info.mail
                _mailContent = _rewardMailData
                sortMailContent()
                maildata.mails[rtnData.info.mail.id] = rtnData.info.mail
                local offsetY = _tableView:getContentOffset().y
                _tableView:reloadData()
                _tableView:setContentOffset(ccp(0,offsetY))
                refreshAwardCountLabel()
            end
        end

        if mail["type"] == 0 then
            if mail["state"] == 0 then
                doActionFun("REFUSE_FRIEND_INVITAION",{ mail.id }, refuseFriendCallBack)
            elseif mail["state"] == 1 then
                getMainLayer():addChild(createLeaveMessageLayer(mail["playerName"],mail["playerId"],-500))
            end
        elseif mail["type"] == 1 or mail["type"] == 2 then
            getMainLayer():addChild(createLeaveMessageLayer(mail["playerName"],mail["playerId"],-500))
        elseif mail["type"] == 3 then
            -- 跳转到论剑界面
            getMainLayer():gotoArena()
        elseif mail["type"] == 4 then
            
        elseif mail["type"] == 5 then

        elseif mail["type"] == 6 then
            -- 跳转到抢残障页面
            getMainLayer():gotoAdventure()
        elseif mail["type"] == 8 then
            doActionFun("GET_MAIL_REWARD_URL",{ mail.id }, getRewardCallBack)
        elseif mail["type"] == 10 then
            if mail["state"] == 0 then
                --跳转进入
                getMainLayer():addChild(createFeedbackLayer())
            end
          
        elseif mail["type"] == 999 then
            doActionFun("GET_MAIL_REWARD_URL",{ mail.id }, getRewardCallBack)
        end
        if _uiType == 0 then
        elseif _uiType == 1 then
        elseif _uiType == 2 then
        end
    end
    
    NewsCellOwner["onFightTaped"] = onFightTaped

    

    local function onConfirmTaped( tag,sender )
        local mail = _mailContent[tag]
        local function acceptFriendCallBack( url,rtnData )
            if rtnData.code == 200 then
                if _uiType == 0 then

                elseif _uiType == 1 then
                elseif _uiType == 2 then
                    _msgMailData[tag] = rtnData["info"]
                    _mailContent = _msgMailData
                    maildata.mails[mail.id] = rtnData["info"]
                    sortMailContent()
                    Table1OffsetY = _tableView:getContentOffset().y
                    _tableView:reloadData()
                    _tableView:setContentOffset(ccp(0, Table1OffsetY))
                end

            end
        end
        if mail["type"] == 0 then
            doActionFun("ACCEPT_FRIEND_INVITAION",{ mail.id },acceptFriendCallBack)
        end
        
    end
    
    NewsCellOwner["onConfirmTaped"] = onConfirmTaped

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
            local oneMail = _mailContent[a1 + 1]
            local  proxy = CCBProxy:create()
            local  _hbCell  = tolua.cast(CCBReaderLoad("ccbResources/NewsViewTableCell.ccbi",proxy,true,"NewsCellOwner"),"CCLayer")
            local contentLabel = tolua.cast(NewsCellOwner["contentLabel"],"CCLabelTTF")
            if oneMail["type"] == 7 then
                contentLabel:setVisible(true)
                contentLabel:setString(oneMail["content"])
            end
            local fightBtn = tolua.cast(NewsCellOwner["fightBtn"],"CCMenuItemImage")
            fightBtn:setTag(a1 + 1)
            local fightSprite = tolua.cast(NewsCellOwner["fightSprite"],"CCSprite")

            
            local confirmBtn = tolua.cast(NewsCellOwner["confirmBtn"],"CCMenuItemImage")
            local confirmLabel = tolua.cast(NewsCellOwner["confirmLabel"],"CCSprite")
            local lingQuLabel = tolua.cast(NewsCellOwner["lingQuLabel"],"CCLabelTTF")

            confirmBtn:setTag(a1 + 1)

            local fightResult = tolua.cast(NewsCellOwner["fightResult"],"CCLabelTTF")
            local nameLabel = tolua.cast(NewsCellOwner["nameLabel"],"CCLabelTTF")

            local tongYiLabel = tolua.cast(NewsCellOwner["tongYiLabel"],"CCLabelTTF")
            if oneMail["type"] == 0 then
                --别人对你的好友请求
                nameLabel:setVisible(true)
                nameLabel:setString(oneMail["playerName"])
                fightResult:setVisible(true)
                fightResult:setString(string.format(ConfigureStorage.message[tostring(0)]["content"],oneMail["playerName"]))
                if oneMail["state"] == 0 then
                    fightBtn:setVisible(true)
                    fightSprite:setVisible(true)
                    fightSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("jujue_title.png"))
                    confirmBtn:setVisible(true)
                    confirmLabel:setVisible(true)
                    tongYiLabel:setVisible(false)
                elseif oneMail["state"] == 1 then
                    fightBtn:setVisible(true)
                    fightSprite:setVisible(true)
                    fightSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("liuyan_title.png"))
                    confirmBtn:setVisible(false)
                    confirmLabel:setVisible(false)
                    tongYiLabel:setVisible(true)
                end
            elseif oneMail["type"] == 1 then
                --接受了好友请求
                nameLabel:setVisible(true)
                nameLabel:setString(oneMail["playerName"])
                fightResult:setVisible(true)
                fightResult:setString(string.format(ConfigureStorage.message[tostring(1)]["content"],oneMail["playerName"]))
                fightBtn:setVisible(true)
                fightSprite:setVisible(true)
                fightSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("liuyan_title.png"))
            elseif oneMail["type"] == 2 then
                 nameLabel:setVisible(true)
                nameLabel:setString(oneMail["playerName"])
                fightResult:setVisible(true)
                fightResult:setString(oneMail["content"])
                fightBtn:setVisible(true)
                fightSprite:setVisible(true)
                fightSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("liuyan_title.png"))
            elseif oneMail["type"] == 3 then
                fightResult:setVisible(true)
                fightResult:setString(string.format(ConfigureStorage.message[tostring(3)]["content"],oneMail["playerName"],oneMail["content"]))
                fightBtn:setVisible(true)
                fightSprite:setVisible(true)
                fightSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("juedou_title.png"))
            elseif oneMail["type"] == 4 then
                fightResult:setVisible(true)
                fightResult:setString(string.format(ConfigureStorage.message[tostring(4)]["content"],oneMail["playerName"]))
            elseif oneMail["type"] == 5 then
                fightResult:setVisible(true)
                fightResult:setString(string.format(ConfigureStorage.message[tostring(5)]["content"],oneMail["playerName"]))
            elseif oneMail["type"] == 6 then
                fightResult:setVisible(true)
                fightResult:setString(string.format(ConfigureStorage.message[tostring(6)]["content"],oneMail["playerName"]))
                fightBtn:setVisible(true)
                fightSprite:setVisible(true)
                fightSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("fanji_title.png"))
            elseif oneMail["type"] == 7 then
                -- 领奖
                
            elseif oneMail["type"] == 8 then
                contentLabel:setVisible(true)
                if oneMail["state"] == 1 then
                    fightBtn:setVisible(true)
                    fightSprite:setVisible(true)
                    fightSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("lingjiang_title.png"))
                    if a1 == 1 then
                        fightBtn:setVisible(false)
                        fightSprite:setVisible(false)
                        if a1 == 0 then
                            if oneMail["content"] then
                            contentLabel:setString(string.format(ConfigureStorage.message[tostring(8)]["content"], oneMail["content"][tostring(0)],oneMail["content"][tostring(1)],oneMail["content"][tostring(2)],oneMail["content"][tostring(3)]))
                            end
                        end
                        lingQuLabel:setVisible(true)
                        lingQuLabel:setString(HLNSLocalizedString("已领取"))
                    end
                else
                    if oneMail["content"] then
                        contentLabel:setString(string.format(ConfigureStorage.message[tostring(8)]["content"], oneMail["content"][tostring(0)],oneMail["content"][tostring(1)],oneMail["content"][tostring(2)],oneMail["content"][tostring(3)]))
                    end
                end
                elseif oneMail["type"] == 10 then
                    contentLabel:setVisible(true)
                    if oneMail["content"] then
                        fightBtn:setVisible(true)
                        fightSprite:setVisible(false)
                        local replySprite = tolua.cast(NewsCellOwner["replySprite"],"CCSprite")
                        replySprite:setVisible(true)
                        contentLabel:setString(tostring(oneMail.content))
                    end
                   
            elseif oneMail["type"] == 999 then
                if oneMail["state"] == 1 then
                    contentLabel:setVisible(true)
                    contentLabel:setString(oneMail["content"])
                    fightBtn:setVisible(false)
                    fightSprite:setVisible(false)
                    lingQuLabel:setVisible(true)
                    lingQuLabel:setString(HLNSLocalizedString("已领取"))
                else
                    contentLabel:setVisible(true)
                    contentLabel:setString(oneMail["content"])
                    fightBtn:setVisible(true)
                    fightSprite:setVisible(true)
                    fightSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("lingjiang_title.png"))
                end
            end
            local timeLabel = tolua.cast(NewsCellOwner["timeLabel"],"CCLabelTTF")
            timeLabel:setVisible(true)
            timeLabel:setString(DateUtil:second2dhms(userdata.loginTime - oneMail["time"])..HLNSLocalizedString("news.ago"))

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
    for k,v in pairs(maildata.mails) do
        if v.position == 0 then
            table.insert(_sysMailData, v)
        elseif v.position == 1 then
            table.insert(_rewardMailData, v)
        elseif v.position == 2 then
            table.insert(_msgMailData, v)
        end
    end
    _mailContent = _sysMailData
    sortMailContent()
    setEmptyLabel()
    cellArray = {}
    _addTableView()
    generateCellAction( cellArray,getMyTableCount(_mailContent) )
    cellArray = {}
    refreshCountLabel()
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/NewsView.ccbi",proxy, true,"NewsViewOwner")
    _layer = tolua.cast(node,"CCLayer")
    LogueContentLayer = tolua.cast(NewsViewOwner["FriendContentLayer"],"CCLayer")

    RecruitBtn = tolua.cast(NewsViewOwner["RecruitBtn"],"CCMenuItemImage")
    ItemBtn = tolua.cast(NewsViewOwner["ItemBtn"],"CCMenuItemImage")
    GiftBagBtn = tolua.cast(NewsViewOwner["GiftBagBtn"],"CCMenuItemImage")
    setSpriteFrame(RecruitBtn,true)
    setSpriteFrame(ItemBtn,false)
    setSpriteFrame(GiftBagBtn,false)
end


function getNewViewLayer()
    return _layer
end

function createNewsViewLayer()
    _init()

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
        _sysMailData = {}
        _rewardMailData = {}
        _msgMailData = {}
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