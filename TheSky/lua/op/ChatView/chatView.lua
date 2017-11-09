local _layer
local _allChatView
local _unionChatView
local _campChatView
local skillArray
local _unitTime
local _chatType
local editBox
local campEditBox
local campLayerBg
local isSend = 1
local offsetY
local leagueOffSetY
local tempLabel
local currentQueryTime = -1
local leagueQueryTime = -1
local campQueryTime = -1
local isChange = false -- 是否的页面切换
local allserverLastIn
local leagueLastIn
local announceLayer
local chatContentHeight = 0
ChatType = {
    allServerChat = 0,
    uniteChat = 1,
    campChat = 2,
}
local allCampChatData = {}  -- 阵营聊天数据
local contentData = {}

local allCellHeightArray = {}
local leagueCellHeightArray = {}
local campCellHeightArray = {}

ChatViewLayerOwner = ChatViewLayerOwner or {}
ccb["ChatViewLayerOwner"] = ChatViewLayerOwner

local chatFont = "ccbResources/FZCuYuan-M03S.ttf"

local function refreshCountBg(  )
    local countBg = tolua.cast(ChatViewLayerOwner["countBg"],"CCSprite")
    if _chatType == ChatType.allServerChat then
        countBg:setVisible(true)
    else
        countBg:setVisible(false)
    end 
end

local function setSpriteFrame( sender,bool )
    if bool then
        sender:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_1.png"))
        sender:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_1.png"))
    else
        sender:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_0.png"))
        sender:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_1.png"))
    end
end

local function setCampTopView( data )
    if data then
        allCampChatData = data
        if not (data.myLeaderKey and data.myLeaderKey == 0) then
            campEditBox:setTouchEnabled(false)
        end
        local campAnnounceLabel = tolua.cast(ChatViewLayerOwner["campAnnounceLabel"], "CCLabelTTF")
        if data.notice then
            campAnnounceLabel:setVisible(true)
            campAnnounceLabel:setString(data.notice)
        else
            campAnnounceLabel:setVisible(false)
        end
    end 
end

local function sendAnnounceMsgCallBack( url,rtnData )
    campEditBox:setText("")
    local campAnnounceLabel = tolua.cast(ChatViewLayerOwner["campAnnounceLabel"], "CCLabelTTF")
    if rtnData.info.notice then
        campAnnounceLabel:setVisible(true)
        campAnnounceLabel:setString(rtnData.info.notice)
    else
        campAnnounceLabel:setVisible(false)
    end
end

local function onAnnounceSendTap(  )
    if allCampChatData.myLeaderKey and allCampChatData.myLeaderKey == 0 then
        local message = campEditBox:getText()
        if string.len(tostring(message)) >0 then
            doActionFun("WW_UPDATA_CAMP_ANNOUNCE",{ tostring(message) },sendAnnounceMsgCallBack)
        else
            ShowText(HLNSLocalizedString("亲，不能发空的哦~"))
        end
    else
        ShowText(HLNSLocalizedString("tips.onlyLeaderCanSend"))
    end
end

ChatViewLayerOwner["onAnnounceSendTap"] = onAnnounceSendTap

local function getMessageCallBack( url,rtnData )
    if string.find(url, ActionTable.GET_CAMP_MESSAGE_URL) then
        setCampTopView(rtnData.info)
    end
    
    if getMyTableCount(rtnData.info.result) > 0 then
        if string.find(url, ActionTable.GET_PUBLIC_MESSAGE) then
            runtimeCache.publicChatTime = rtnData.info.time
            
            for i=getMyTableCount(rtnData.info.result) - 1,0,-1 do
                table.insert(runtimeCache.publicChatData,rtnData.info.result[tostring(i)])
            end
            _allChatView:reloadData()
            if _allChatView:getContentSize().height > chatContentHeight then
                _allChatView:setContentOffset(ccp(0,0))
            end
        elseif string.find(url, ActionTable.GET_LEAGUE_MESSAGE) then
            runtimeCache.leagueChatTime = rtnData.info.time
            for i=getMyTableCount(rtnData.info.result) - 1,0,-1 do
                table.insert(runtimeCache.leagueChatData,rtnData.info.result[tostring(i)])
            end
            _unionChatView:reloadData()
            if _unionChatView:getContentSize().height > chatContentHeight then
                _unionChatView:setContentOffset(ccp(0,0))
            end
        elseif string.find(url, ActionTable.GET_CAMP_MESSAGE_URL) then
            runtimeCache.campChatTime = rtnData.info.time
            for i=getMyTableCount(rtnData.info.result) - 1,0,-1 do
                table.insert(runtimeCache.campChatData,rtnData.info.result[tostring(i)])
            end
            _campChatView:reloadData()
            if _campChatView:getContentSize().height > chatContentHeight then
                _campChatView:setContentOffset(ccp(0,0))
            end
        end
    end
    currentQueryTime = -1
    leagueQueryTime = -1
    campQueryTime = -1
end

local function getAllChatData(  )
    if _chatType == ChatType.allServerChat then
        if runtimeCache.publicChatTime ~= currentQueryTime then
            currentQueryTime = runtimeCache.publicChatTime
            doActionNoLoadingFun("GET_PUBLIC_MESSAGE",{runtimeCache.publicChatTime},getMessageCallBack)
        end
    elseif _chatType == ChatType.uniteChat then
        if runtimeCache.leagueChatTime ~= leagueQueryTime then
            leagueQueryTime = runtimeCache.leagueChatTime
            doActionNoLoadingFun("GET_LEAGUE_MESSAGE",{runtimeCache.leagueChatTime},getMessageCallBack)
        end
    elseif _chatType == ChatType.campChat then
        if runtimeCache.campChatTime ~= campQueryTime then
            campQueryTime = runtimeCache.campChatTime
            doActionNoLoadingFun("GET_CAMP_MESSAGE_URL",{runtimeCache.campChatTime},getMessageCallBack)
        end
    end
end

local function sendMsgCallBack( url,rtnData )
    if rtnData.code == 200 then
        ShowText(HLNSLocalizedString("发送成功"))
        editBox:setText("")
        isSend = 0
        local countLabel = tolua.cast(ChatViewLayerOwner["countLabel"],"CCLabelTTF")
        countLabel:setString(tostring(wareHouseData:getItemCountById( "item_007" )))
        getAllChatData()
    else
        ShowText(HLNSLocalizedString("发送失败"))
    end
end

local function onSenderTaped(  )
    Global:instance():TDGAonEventAndEventData("chat1")
    local message = editBox:getText()
    if string.len(tostring(message)) >0 then
        if _chatType == ChatType.allServerChat then
            if wareHouseData:getItemCountById("item_007") >= 1 then
                doActionFun("SEND_MESSAGE_URL",{ tostring(message) },sendMsgCallBack)
            else
                getMainLayer():addChild(createItemNotEnoughTipsLayer("item_007",HLNSLocalizedString("chatview.phonenotenough"),HLNSLocalizedString("chatview.itemnotenoughtip"),-140))
            end
        elseif _chatType == ChatType.uniteChat then
            doActionFun("SEND_LEAGUE_MESSAGE_URL",{ tostring(message) },sendMsgCallBack)
        elseif _chatType == ChatType.campChat then
            doActionFun("SEND_CAMP_MESSAGE_URL",{ tostring(message) },sendMsgCallBack)
        end
    else
        ShowText(HLNSLocalizedString("亲，不能发空的哦~"))
    end    
end

ChatViewLayerOwner["onSenderTaped"] = onSenderTaped

local function getCellHeight( string,width,fontSize,fontName )
    if not fontName then
        fontName = chatFont
    end
    local tempLabel = CCLabelTTF:create(string,fontName,fontSize,CCSizeMake(width,0),kCCTextAlignmentLeft)
    tempLabel:setVisible(false)
    _layer:addChild(tempLabel,200,8888)
    local height = tempLabel:getContentSize().height
    tempLabel:removeFromParentAndCleanup(true)
    return height
end
local function getSpeaceCount( string,fontSize )
    local tempLabel = CCLabelTTF:create("s", chatFont,fontSize,CCSizeMake(0,0),kCCTextAlignmentLeft)
    _layer:addChild(tempLabel)
    tempLabel:setVisible(false)
    local spaceWidth = tempLabel:getContentSize().width
    tempLabel:removeFromParentAndCleanup(true)
    local tempLabel = CCLabelTTF:create(string,chatFont,fontSize,CCSizeMake(0,0),kCCTextAlignmentLeft)
    _layer:addChild(tempLabel)
    tempLabel:setVisible(false)
    local stringWidth = tempLabel:getContentSize().width
    tempLabel:removeFromParentAndCleanup(true)
    local num = math.ceil(stringWidth / spaceWidth) * 2
    return num
end

local function backToLeague(  )
    -- 返回联盟
    getMainLayer():gotoUnion()
end

ChatViewLayerOwner["backToLeague"] = backToLeague

-- 全服聊天

local function _addTableView() 
    local _topLayer = ChatViewLayerOwner["ChatTopLayer"]
    local bottomLayer = ChatViewLayerOwner["bottomLayer"]
    
    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            -- if a1 == 0 then
            --     r = CCSizeMake(winSize.width, 45 * retina)
            -- else
                local message = runtimeCache.publicChatData[a1 +1]
                local cellHeight
                if allCellHeightArray[a1+1] then
                    cellHeight = allCellHeightArray[a1+1]
                else
                    cellHeight = getCellHeight(string.rep(" ",getSpeaceCount(message.name,"23"))..":  "..message.message,620,23,"AmericanTypewriter.ttf") + 20 * retina
                    allCellHeightArray[a1+1] = cellHeight
                end
                r = CCSizeMake(winSize.width, cellHeight * retina)
            -- end
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
            _hbCell = CCLayer:create()

            local message = runtimeCache.publicChatData[a1 + 1]
            local chatContent = string.rep(" ",getSpeaceCount(message.name,"23")) .. ":  " .. message.message
            local cellHeight
            if allCellHeightArray[a1+1] then
                cellHeight = allCellHeightArray[a1+1]
            else
                cellHeight = getCellHeight(chatContent,620,23,chatFont) + 20 * retina
                allCellHeightArray[a1+1] = cellHeight
            end
            _hbCell:setContentSize(CCSizeMake(640,cellHeight))
            _hbCell:setAnchorPoint(ccp(0.5,0))
            _hbCell:setPosition(ccp((winSize.width - _hbCell:getContentSize().width) / 2,0))

            local nameLabel = CCLabelTTF:create(message.name, chatFont, 23, CCSizeMake(620,0), kCCTextAlignmentLeft)
            nameLabel:setAnchorPoint(ccp(0,1))
            nameLabel:setPosition(ccp(10 * retina,cellHeight - 10 * retina))
            _hbCell:addChild(nameLabel)
            nameLabel:setColor(ccc3(255,124,20))

            local temp = CCLabelTTF:create(chatContent, chatFont, 23,CCSizeMake(620,0),kCCTextAlignmentLeft)
            temp:setAnchorPoint(ccp(0,1))
            temp:setPosition(ccp(10 * retina,cellHeight - 10 * retina))
            _hbCell:addChild(temp)
            temp:setColor(ccc3(124,255,0))
                
            _hbCell:setScale(retina)
            a2:addChild(_hbCell, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)

            r = a2
        elseif fn == "numberOfCells" then
            r = getMyTableCount(runtimeCache.publicChatData)
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
        local size = CCSizeMake(winSize.width, (winSize.height - _topLayer:getContentSize().height - _mainLayer:getBottomContentSize().height - bottomLayer:getContentSize().height * retina - 10 * retina)*99/100)      -- 这里是为了在tableview上面显示一个小空出来
        _allChatView = LuaTableView:createWithHandler(h, size)
        _allChatView:setBounceable(true)
        _allChatView:setAnchorPoint(ccp(0,0))
        _allChatView:setPosition(ccp(0, _mainLayer:getBottomContentSize().height + bottomLayer:getContentSize().height * retina + 10 * retina))
        _allChatView:setVerticalFillOrder(0)
        _layer:addChild(_allChatView)
    end
end

-- 联盟聊天
local function _addUnionTableView() 
    local _topLayer = ChatViewLayerOwner["ChatTopLayer"]
    local bottomLayer = ChatViewLayerOwner["bottomLayer"]

    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            local message = runtimeCache.leagueChatData[a1 +1]
            local cellHeight
            if leagueCellHeightArray[a1+1] then
                cellHeight = leagueCellHeightArray[a1+1]
            else
                cellHeight = getCellHeight(string.rep(" ",getSpeaceCount(message.name,"23"))..":  "..message.message,620,23,"AmericanTypewriter.ttf") + 20 * retina
                leagueCellHeightArray[a1+1] = cellHeight
            end
            
            r = CCSizeMake(winSize.width, cellHeight * retina)
        elseif fn == "cellAtIndex" then
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            
            local  proxy = CCBProxy:create()
            
            local  _hbCell
            _hbCell = CCLayer:create()

            local message = runtimeCache.leagueChatData[a1 + 1]
            local cellHeight
            if leagueCellHeightArray[a1+1] then
                cellHeight = leagueCellHeightArray[a1+1]
            else
                cellHeight = getCellHeight(string.rep(" ",getSpeaceCount(message.name,"23"))..":  "..message.message,620,23,chatFont) + 20 * retina
                leagueCellHeightArray[a1+1] = cellHeight
            end
            _hbCell:setContentSize(CCSizeMake(640,cellHeight))
            _hbCell:setAnchorPoint(ccp(0.5,0))
            _hbCell:setPosition(ccp((winSize.width - _hbCell:getContentSize().width) / 2,0))

            local nameLabel = CCLabelTTF:create(message.name, chatFont, 23, CCSizeMake(620,0), kCCTextAlignmentLeft)
            nameLabel:setAnchorPoint(ccp(0,1))
            nameLabel:setPosition(ccp(10 * retina,cellHeight - 10 * retina))
            _hbCell:addChild(nameLabel)
            nameLabel:setColor(ccc3(255,124,20))

            local temp = CCLabelTTF:create(string.rep(" ",getSpeaceCount(message.name,"23"))..":  "..message.message, chatFont, 23,CCSizeMake(620,0),kCCTextAlignmentLeft)
            temp:setAnchorPoint(ccp(0,1))
            temp:setPosition(ccp(10 * retina,cellHeight - 10 * retina))
            _hbCell:addChild(temp)
            temp:setColor(ccc3(124,255,0))
                
            _hbCell:setScale(retina)
            a2:addChild(_hbCell, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)

            r = a2
        elseif fn == "numberOfCells" then
            r = getMyTableCount(runtimeCache.leagueChatData)
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
        local size = CCSizeMake(winSize.width, (winSize.height - _topLayer:getContentSize().height - _mainLayer:getBottomContentSize().height - bottomLayer:getContentSize().height * retina - 10 * retina)*99/100)      -- 这里是为了在tableview上面显示一个小空出来
        _unionChatView = LuaTableView:createWithHandler(h, size)
        _unionChatView:setBounceable(true)
        _unionChatView:setAnchorPoint(ccp(0,0))
        _unionChatView:setPosition(ccp(0, _mainLayer:getBottomContentSize().height + bottomLayer:getContentSize().height * retina + 10 * retina))
        _unionChatView:setVerticalFillOrder(0)
        _layer:addChild(_unionChatView)
    end
end

-- 阵营聊天

local function _addCampTableView() 
    local _topLayer = ChatViewLayerOwner["ChatTopLayer"]
    local bottomLayer = ChatViewLayerOwner["bottomLayer"]
    local announceLayer = ChatViewLayerOwner["announceLayer"]
    
    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            local message = runtimeCache.campChatData[a1 +1]
            local cellHeight
            if campCellHeightArray[a1+1] then
                cellHeight = campCellHeightArray[a1+1]
            else
                cellHeight = getCellHeight(string.rep(" ",getSpeaceCount(message.name,"23"))..":  "..message.message..
                    "     "..DateUtil:second2dhms(userdata.loginTime - message["time"]%1000)..
                    HLNSLocalizedString("news.ago"),620,23,"AmericanTypewriter.ttf") + 20 * retina
                campCellHeightArray[a1+1] = cellHeight
            end
            r = CCSizeMake(winSize.width, cellHeight * retina)
        elseif fn == "cellAtIndex" then
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            
            local  proxy = CCBProxy:create()
            
            local  _hbCell
            _hbCell = CCLayer:create()

            local message = runtimeCache.campChatData[a1 + 1]
            local cellHeight
            if _chatType == ChatType.allServerChat then
                if allCellHeightArray[a1+1] then
                    cellHeight = allCellHeightArray[a1+1]
                else
                    cellHeight = getCellHeight(string.rep(" ", getSpeaceCount(message.name,"23"))..
                        ":  "..message.message.."     "..
                        DateUtil:second2dhms(userdata.loginTime - math.floor(message["time"] / 1000))..
                        HLNSLocalizedString("news.ago"), 620, 23, 
                        chatFont) + 20 * retina
                    allCellHeightArray[a1+1] = cellHeight
                end
            else
                if leagueCellHeightArray[a1+1] then
                    cellHeight = leagueCellHeightArray[a1+1]
                else
                    cellHeight = getCellHeight(string.rep(" ",getSpeaceCount(message.name,"23"))..":  "..message.message.."     "..
                        DateUtil:second2dhms(userdata.loginTime - math.floor(message["time"] / 1000))..
                        HLNSLocalizedString("news.ago"),620,23,chatFont) + 20 * retina
                    leagueCellHeightArray[a1+1] = cellHeight
                end
            end
            _hbCell:setContentSize(CCSizeMake(640,cellHeight))
            _hbCell:setAnchorPoint(ccp(0.5,0))
            _hbCell:setPosition(ccp((winSize.width - _hbCell:getContentSize().width) / 2,0))

            local nameLabel = CCLabelTTF:create(message.name, chatFont, 23, CCSizeMake(620,0), kCCTextAlignmentLeft)
            nameLabel:setAnchorPoint(ccp(0,1))
            nameLabel:setPosition(ccp(10 * retina,cellHeight - 10 * retina))
            _hbCell:addChild(nameLabel)
            nameLabel:setColor(ccc3(255,124,20))
            local temp = CCLabelTTF:create(string.rep(" ",getSpeaceCount(message.name,"23"))..":  "..message.message..
                "     "..DateUtil:second2dhms(userdata.loginTime - math.floor(message["time"] / 1000))..
                HLNSLocalizedString("news.ago"), chatFont, 23,CCSizeMake(620,0),kCCTextAlignmentLeft)
            temp:setAnchorPoint(ccp(0,1))
            temp:setPosition(ccp(10 * retina,cellHeight - 10 * retina))
            _hbCell:addChild(temp)
            if message.leaderKey then
                temp:setColor(ccc3(255,0,51))
            else
                temp:setColor(ccc3(124,255,0))
            end
                
            _hbCell:setScale(retina)
            a2:addChild(_hbCell, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)

            r = a2
        elseif fn == "numberOfCells" then
            r = getMyTableCount(runtimeCache.campChatData)
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
        local size = CCSizeMake(winSize.width, (winSize.height - _topLayer:getContentSize().height - announceLayer:getContentSize().height * retina - _mainLayer:getBottomContentSize().height - bottomLayer:getContentSize().height * retina - 10 * retina)*99/100)      -- 这里是为了在tableview上面显示一个小空出来
        _campChatView = LuaTableView:createWithHandler(h, size)
        _campChatView:setBounceable(true)
        _campChatView:setAnchorPoint(ccp(0,0))
        _campChatView:setPosition(ccp(0, _mainLayer:getBottomContentSize().height + bottomLayer:getContentSize().height * retina + 10 * retina))
        _campChatView:setVerticalFillOrder(0)
        _layer:addChild(_campChatView)
    end
end

local function setTopBtnState( flag1,flag2,flag3 )
    local btn1 = tolua.cast(ChatViewLayerOwner["btn1"],"CCMenuItemImage")
    local btn2 = tolua.cast(ChatViewLayerOwner["btn2"],"CCMenuItemImage")
    local btn3 = tolua.cast(ChatViewLayerOwner["btn4"],"CCMenuItemImage")
    setSpriteFrame(btn1,flag1)
    setSpriteFrame(btn2,flag2)
    setSpriteFrame(btn3,flag3)
    if _allChatView then
        _allChatView:setVisible(flag1)
    elseif flag1 then
        _addTableView()
    end
    if _unionChatView then
        _unionChatView:setVisible(flag2)
    elseif flag2 then
        _addUnionTableView()
    end
    if _campChatView then
        _campChatView:setVisible(flag3) 
        announceLayer:setVisible(flag3)
    elseif flag3 then
        _addCampTableView()
        -- 添加阵容聊天框
        local campEditBg = ChatViewLayerOwner["campEditBg"]
        local editBg = CCScale9Sprite:createWithSpriteFrameName("chat_bg.png")
        campEditBox = CCEditBox:create(CCSize(campEditBg:getContentSize().width,campEditBg:getContentSize().height),editBg)
        campEditBox:setPosition(ccp(campEditBg:getContentSize().width / 2,campEditBg:getContentSize().height / 2))
        campEditBox:setFont(chatFont,16)
        campEditBg:addChild(campEditBox)   
        campEditBox:setPlaceHolder(HLNSLocalizedString("tips.onlyLeaderCanSend"))
        announceLayer:setVisible(true)
    end
end

function onAllServerChatClicked(  )
    if _chatType ~= ChatType.allServerChat then
        _chatType = ChatType.allServerChat
        setTopBtnState(true,false,false)
        refreshCountBg()
        getAllChatData()
    end
end

function onUniteChatClicked(  )
    if _chatType ~= ChatType.uniteChat then
        _chatType = ChatType.uniteChat
        setTopBtnState(false,true,false)
        refreshCountBg()
        getAllChatData()
    end
end

function onCampChatClicked(  )
    if _chatType ~= ChatType.campChat then
        _chatType = ChatType.campChat
        setTopBtnState(false,false,true)
        refreshCountBg()
        getAllChatData()
    end
end

ChatViewLayerOwner["onAllServerChatClicked"] = onAllServerChatClicked
ChatViewLayerOwner["onUniteChatClicked"] = onUniteChatClicked
ChatViewLayerOwner["onCampChatClicked"] = onCampChatClicked

local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/ChatView.ccbi",proxy, true,"ChatViewLayerOwner")
    _layer = tolua.cast(node,"CCLayer")
    local bottomLayer = ChatViewLayerOwner["bottomLayer"]
    local _topLayer = ChatViewLayerOwner["ChatTopLayer"]
    local chat_Bg = ChatViewLayerOwner["chat_Bg"]
    local editBg = CCScale9Sprite:createWithSpriteFrameName("chat_bg.png")
    editBox = CCEditBox:create(CCSize(chat_Bg:getContentSize().width,chat_Bg:getContentSize().height),editBg)
    editBox:setPosition(ccp(chat_Bg:getPositionX(),chat_Bg:getPositionY()))
    editBox:setFont(chatFont,30*retina)
    bottomLayer:addChild(editBox)
    bottomLayer:setPosition(ccp(winSize.width / 2,getMainLayer():getBottomContentSize().height + 10 * retina))
    local countLabel = tolua.cast(ChatViewLayerOwner["countLabel"],"CCLabelTTF")
    countLabel:setString(tostring(wareHouseData:getItemCountById( "item_007" ))) 

    announceLayer = ChatViewLayerOwner["announceLayer"]
    announceLayer:setVisible(false)
end

local function _refreshUI(  )
    if runtimeCache.buySuccessItemId == "item_007" then
        local countLabel = tolua.cast(ChatViewLayerOwner["countLabel"],"CCLabelTTF")
        countLabel:setString(tostring(wareHouseData:getItemCountById( "item_007" )))
    end
end


function getChatLayer()
	return _layer
end
--[[
    @param bUnit 是否是联盟跳转的聊天窗口
]]
function createChatLayer(bUnit)
    _init()

    local function _onEnter()
        local bottomLayer = ChatViewLayerOwner["bottomLayer"]
        local _topLayer = ChatViewLayerOwner["ChatTopLayer"]
        chatContentHeight = (winSize.height - _topLayer:getContentSize().height - getMainLayer():getBottomContentSize().height - bottomLayer:getContentSize().height * retina - 10 * retina)*99/100

        addObserver(NOTI_REFRESH_ALLCHATDATA, getAllChatData)
        addObserver(NOTI_SHOP_BUY_SUCCESS, _refreshUI)
    end

    function _layer:gotoChatByType( uitype )
        _chatType = uitype
        if _chatType == ChatType.allServerChat then
            setTopBtnState(true,false,false)
        elseif _chatType == ChatType.uniteChat then
            setTopBtnState(false,true,false)
        elseif _chatType == ChatType.campChat then
            setTopBtnState(false,false,true)
        end
        if unionData:isHaveUnion() and bUnit then
            local btn3 = tolua.cast(ChatViewLayerOwner["btn3"],"CCMenuItemImage")
            local sprite3 = tolua.cast(ChatViewLayerOwner["sprite3"],"CCSprite")
            sprite3:setVisible(true)
            btn3:setVisible(true)
        end
        refreshCountBg()
        getAllChatData()
    end

    local function _onExit()
        _layer = nil
        skillArray = nil
        _allChatView = nil
        _unionChatView = nil
        _campChatView = nil
        _chatType = nil
        isSend = 1
        contentData = {}
        offsetY = nil
        _unitTime = nil
        currentQueryTime = -1
        allCellHeightArray = {}
        leagueCellHeightArray = {}
        campCellHeightArray = {}
        leagueQueryTime = -1
        campQueryTime = -1
        removeObserver(NOTI_REFRESH_ALLCHATDATA, getAllChatData)
        removeObserver(NOTI_SHOP_BUY_SUCCESS, _refreshUI)
        allCampChatData = {}
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