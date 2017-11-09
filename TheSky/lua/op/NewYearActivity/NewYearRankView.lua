local _layer
local _priority
local _contentLayer 
local _tableView
local _rankData
local _rankDataLen

NewYearRankingListViewOwner = NewYearRankingListViewOwner or {}
ccb["NewYearRankingListViewOwner"] = NewYearRankingListViewOwner

NewYearRankingListCellOwner = NewYearRankingListCellOwner or {}
ccb["NewYearRankingListCellOwner"] = NewYearRankingListCellOwner

local function closeItemClick()
    print("=============wewe111",_layer)
    popUpCloseAction(NewYearRankingListViewOwner, "infoBg", _layer )
end
NewYearRankingListViewOwner["closeItemClick"] = closeItemClick

local rewrdClickedCallback = function(url, rtnData)
    -- body
end
local function getRewrdBtnClick()
    print("print by wuye =============getRewrdBtnClick")
    doActionFun("ACTIVITY_GETRANKREWARDS",{FreeFestivalUid},rewrdClickedCallback)
end
NewYearRankingListViewOwner["getRewrdBtnClick"] = getRewrdBtnClick


local function setMenuPriority()
    local menu = tolua.cast(NewYearRankingListViewOwner["menu"], "CCMenu")
    menu:setTouchPriority(_priority - 2)
    _tableView:setTouchPriority(_priority - 2)
 
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(NewYearRankingListViewOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        print("=============wewe111",_layer)
        popUpCloseAction(NewYearRankingListViewOwner, "infoBg", _layer)
        return true
    end
    return true
end

local function onTouchEnded(x, y)
end

local function onTouch(eventType, x, y)
    print("print by wuye ============newYearRankTouch",newYearRankTouch)
    if newYearRankTouch == true then
        if eventType == "began" then   
            return onTouchBegan(x, y)
        elseif eventType == "moved" then
        else
            return onTouchEnded(x, y)
        end
    end
end

local function rewardViewFormClick(tag)
    print("viewFormClick", tag)
    PrintTable(_rankData)
    local array = _rankData[tostring(tag-1)]["rewards"]
    
    -- Global:instance():TDGAonEventAndEventData("check")
    
    -- if listData[tag].id then
    --     print("11")
    --     print("*** ",listData[tag].id)
    --     id = tostring (listData[tag].id)
    -- elseif listData[tag].playerId then
    --     print("22")
    --     id = tostring(listData[tag].playerId )
    -- end

    -- print("***lsf PlayerId ",listData[tag].id,id)
    -- doActionFun("ARENA_GET_BATTLE_INFO", {id}, viewBattleInfo)
    -- local array = 1
    if getMainLayer() then
        getMainLayer():addChild(createVipPackageDetailLayer(array,nil,-180,true),100)
    end
end
NewYearRankingListCellOwner["rewardViewFormClick"] = rewardViewFormClick

local function _addTableView()
    local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
    cache:addSpriteFramesWithFile("ccbResources/serverPK.plist")

    -- local h = LuaEventHandler:create(function(fn, table, a1, a2)
    --     print("wuye=====================_addTableView")
    -- end)
    print("wuye=============number",#_rankData)

    local h = LuaEventHandler:create(function(fn, table, a1, a2)

        local r
        if fn == "cellSize" then               
            r = CCSizeMake( 595 , 144 )
            --620.176
        elseif fn == "cellAtIndex" then
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            local  proxy = CCBProxy:create()
            local _hbCell = tolua.cast(CCBReaderLoad("ccbResources/NewYearRankingListCell.ccbi",proxy,true,"NewYearRankingListCellOwner"),"CCSprite")
            local owner = NewYearRankingListCellOwner

              -- 设置menu 优先级
            local menu = tolua.cast(owner["menu1"], "CCMenu")
            local function setCellMenuPriority(sender)
                if sender then               
                    local menu = tolua.cast(sender, "CCMenu")
                    menu:setHandlerPriority(_priority - 2)
                end
            end
            local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCCallFuncN:create(setCellMenuPriority))
            menu:runAction(seq)

            local rank4 = tolua.cast(owner["rank4"],"CCLabelTTF")
            local rank4b = tolua.cast(owner["rank4b"],"CCLabelTTF")
            local rank123 = tolua.cast(owner["rank123"],"CCLabelTTF")

            if a1+1 > 3 then        
                rank4:setVisible(true)
                rank4b:setVisible(true)
                rank123:setVisible(false)
                rank4:setString( a1+1 )       
                rank4b:setString( a1+1 )
             
                -- if  a1+1 == #listData    then 
                --     --如果玩家在最后一名， 把排名改成玩家自己的排名，防止玩家在 一千多名以外 然后显示成51 或 31
                --     if tonumber(listData[a1+1].id) == userdata.userId   or  tonumber(listData[a1+1].playerId) ==  userdata.userId then
                       
                --         rank4:setString( rankingListData[_cur_RankingList .. "_PlayersRank"]  )       
                --         rank4b:setString( rankingListData[_cur_RankingList .. "_PlayersRank"] )
                --         _hbCell:setDisplayFrame( cache:spriteFrameByName("palyerOwner_Bg.png"))
                --         --if tonumber(rankingListData[_cur_RankingList .. "_PlayersRank"] ) > #listData  then --51名以后字变小 防止字超出 1253
                --         rank4:setFontSize(50)
                --         rank4b:setFontSize(50)                    
                --     end
                -- end


            else 
                rank123:setVisible(true)
                rank4:setVisible(false)
                rank4b:setVisible(false)   
                rank123:setDisplayFrame(cache:spriteFrameByName(string.format("num%d.png",  a1+1  )))

            end

               --各玩家头像
            local frame = tolua.cast(owner["frame1"], "CCSprite")
            local head = tolua.cast(owner["head1"], "CCSprite")
            PrintTable(_rankData["0"])
            print(a1)
            if _rankData[tostring(a1)].form then  --如果有玩家的英雄头像
                local heroId = _rankData[tostring(a1)].form

                local conf = herodata:getHeroConfig(heroId)
                if conf then
                    
                    frame:setVisible(true)
                    frame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", conf.rank)))
                    local f = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(herodata:getHeroHeadByHeroId(heroId))
                    if f then
                        head:setVisible(true)
                        head:setDisplayFrame(f)
                    end
                end
            end

            local leagueCEO_name = tolua.cast(owner["leagueCEO_name"],"CCLabelTTF")
            leagueCEO_name:setVisible(true)
            leagueCEO_name:setString(  _rankData[tostring(a1)].name   )

            local name = tolua.cast(owner["name"],"CCLabelTTF")
            name:setString( _rankData[tostring(a1)].useTimes )   

            local vip = tolua.cast(owner["vip"], "CCSprite")
            if _rankData[tostring(a1)].vipLevel then       
                vip:setDisplayFrame(cache:spriteFrameByName(string.format("VIP_%d.png",  _rankData[tostring(a1)].vipLevel   )))
            end

            local level = tolua.cast(owner["level"],"CCLabelTTF")
            level:setString( string.format("LV:%d", _rankData[tostring(a1)].level )  )

            local rewardViewForm = tolua.cast(owner["rewardViewForm"], "CCSprite")
            rewardViewForm:setTag(a1 + 1)
            rewardViewForm:setVisible(false)
            if _rankData[tostring(a1)].rewards then
                rewardViewForm:setVisible(true)
                --rewardViewForm:setDisplayFrame(cache:spriteFrameByName(string.format("VIP_001.png")))
            end

            local function viewBattleInfo(url, rtnData)
                playerBattleData:fromDic(rtnData.info)
                -- getMainLayer():getParent():addChild(createTeamCompLayer(userdata:getUserBattleInfo(), playerBattleData), 100)
                getMainLayer():getParent():addChild(createTeamPopupLayer(-140))
                --_layer:removeFromParentAndCleanup(true)
            end

            local function viewFormClick(tag)
                local id = _rankData[tostring(a1)].id
                doActionFun("ARENA_GET_BATTLE_INFO", {id}, viewBattleInfo)
            end
            NewYearRankingListCellOwner["viewFormClick"] = viewFormClick

            -- local rewardViewForm = tolua.cast(owner["viewForm"],"CCMenuItemImage")
            -- rewardViewForm:setTag(a1 + 1)
            
            --_hbCell:setPositionX(250)
            a2:addChild(_hbCell, 1, 1)
            r = a2
            _hbCell:setAnchorPoint(ccp(0.5, 0))
            _hbCell:setPosition( _contentLayer:getContentSize().width / 2, 0)  
        elseif fn == "numberOfCells" then
            --r = table.getTableCount(_rankData)
            -- local i = 0
            -- if _rankData and type(_rankData) == "table" then
            --     for k,v in pairs(_rankData) do
            --         if v then
            --             i = i +1
            --         end
            --     end
            -- end
            r = _rankDataLen
            --print("_addTableView",r )
        end
        return r
    end)

    local size = _contentLayer:getContentSize()
    _tableView = LuaTableView:createWithHandler(h, size)
    _tableView:setBounceable(true)
    _tableView:setAnchorPoint(ccp(0,0))
    _tableView:setPosition(0,0)
    _tableView:setVerticalFillOrder(0)
    _contentLayer:addChild(_tableView,1000)
end

local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/NewYearRankingListView.ccbi",proxy, true,"NewYearRankingListViewOwner")
    _layer = tolua.cast(node,"CCLayer")
    print("=============wewe",_layer)
    _contentLayer = NewYearRankingListViewOwner["contentLayer"]

    local owner = NewYearRankingListViewOwner
    
    local rule_ttf = tolua.cast(owner["ruleTTF"],"CCLabelTTF") --活动规则 4个字
    rule_ttf:setString( HLNSLocalizedString("activity.arena.help.2") )
    
    --三个榜的点击按钮变透明
    local leftListTitleBtn = tolua.cast(owner["leftListTitleBtn"],"CCMenuItemImage")
    leftListTitleBtn:setOpacity (0)
    local curListTitleBtn = tolua.cast(owner["curListTitleBtn"],"CCMenuItemImage")
    curListTitleBtn:setOpacity (0)
    local rightListTitleBtn = tolua.cast(owner["rightListTitleBtn"],"CCMenuItemImage")
    rightListTitleBtn:setOpacity (0)

    --玩家阵容 玩家姓名 船长等级等字样
    ttf2 = tolua.cast(NewYearRankingListViewOwner["2ttf"],"CCLabelTTF") 
    ttf3 = tolua.cast(NewYearRankingListViewOwner["3ttf"],"CCLabelTTF")
    ttf4 = tolua.cast(NewYearRankingListViewOwner["4ttf"],"CCLabelTTF")

    --_curIndex = 1 
    --_refreshData()
    _addTableView()
  

end

function getNewYearRankingListLayer()
    return _layer
end

local function _closeView(  )
    _layer:removeFromParentAndCleanup(true) 
end

function createNewYearRankingListLayer(priority, rankData, isBtnShow) --priority -140
    _priority = (priority ~= nil) and priority or -140
    _rankData = rankData

    local i = 0
    if _rankData and type(_rankData) == "table" then
        for k,v in pairs(_rankData) do
            if v then
                i = i +1
            end
        end
    end
    _rankDataLen = i
    _init()

    local getRewrdBtn = tolua.cast(NewYearRankingListViewOwner["getRewrdBtn"], "CCMenuItem")
    local rewardLabel = tolua.cast(NewYearRankingListViewOwner["rewardLabel"], "CCLabelTTF")

    if isBtnShow == 1 then
        getRewrdBtn:setVisible(true)
        rewardLabel:setVisible(true)
    else
        getRewrdBtn:setVisible(false)
        rewardLabel:setVisible(false)
    end

    function _layer:closeView(  )
        _closeView()
    end

    local function _onEnter()
        print("RankingListView onEnter")
        
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
        
        popUpUiAction(NewYearRankingListViewOwner, "infoBg")
        
    end

    local function _onExit()
        print("RankingListView onExit")
        _layer = nil
        _cellLayer = nil
       
    end

    local function _layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        end
    end

    _layer:registerScriptTouchHandler(onTouch ,false , _priority ,true )
    _layer:setTouchEnabled(true)
    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end