--林绍峰 排行榜

local _layer
local _priority
local _cur_RankingList
local _cur_PlayersRank
local _curIndex  --当前榜的索引
local _contentLayer 
local allRankingList = {
    "playerLevelRankingList",
    "arenaRankingList",
    "bossDamageRankingList",
    "seaMistRankingList",
    "leagueLevelRankingList",
}
local listData
local _flag_HaveNotWriteNewDataYet = true
local configureStorageRankingWords  --活动规则配置

local ttf2 --玩家阵容 玩家姓名 船长等级等字样
local ttf3 
local ttf4 

RankingListViewOwner = RankingListViewOwner or {}
ccb["RankingListViewOwner"] = RankingListViewOwner

RankingListCellOwner = RankingListCellOwner or {}
ccb["RankingListCellOwner"] = RankingListCellOwner


local function closeItemClick()
    popUpCloseAction(RankingListViewOwner, "infoBg", _layer )
end
RankingListViewOwner["closeItemClick"] = closeItemClick


local function curListTitleBtnClick()  
end
RankingListViewOwner["curListTitleBtnClick"] = curListTitleBtnClick




--listData 指向当前榜数据
local function changeListDataToCur()
 
        if _cur_RankingList == "playerLevelRankingList" then
            listData = rankingListData.playerLevelRankingList
        elseif _cur_RankingList == "leagueLevelRankingList" then
            print("***lsf写入数据 listData = rankingListData.leagueLevelRankingList")
            listData = rankingListData.leagueLevelRankingList
        elseif _cur_RankingList == "seaMistRankingList" then
            print("***lsf写入数据 listData = rankingListData.seaMistRankingList")
            listData = rankingListData.seaMistRankingList        
        elseif _cur_RankingList == "arenaRankingList" then
            print("***lsf写入数据 listData = rankingListData.arenaRankingList")
            listData = rankingListData.arenaRankingList      
        elseif _cur_RankingList == "bossDamageRankingList" then
            print("***lsf写入数据 listData = rankingListData.bossDamageRankingList")
            listData = rankingListData.bossDamageRankingList  
        end   

end



local function getGoodCurIndex(index) --排行榜数组 形成一个循环 圆环
    if  index == 0 then 
        index =  #allRankingList 
    end
    if  index == #allRankingList+1  then 
        index =  1 
    end
    return index 
end


local function _refreshThreeTitle() -- 根据curindex 更换显示3个排行榜的名称
   
    local curListTitle = tolua.cast(RankingListViewOwner["curListTitle"],"CCLabelTTF")
    curListTitle:setString( HLNSLocalizedString( "RankingList." .. _cur_RankingList ) )
    local leftListTitle = tolua.cast(RankingListViewOwner["leftListTitle"],"CCLabelTTF")
    leftListTitle:setString( HLNSLocalizedString( "RankingList." .. allRankingList[ getGoodCurIndex(_curIndex-1) ]   ))
    local rightListTitle = tolua.cast(RankingListViewOwner["rightListTitle"],"CCLabelTTF")
    rightListTitle:setString( HLNSLocalizedString( "RankingList." .. allRankingList[ getGoodCurIndex(_curIndex+1) ]  ) )

end


local function _refreshTableViewOffset()

    if tonumber(rankingListData[_cur_RankingList .. "_PlayersRank"]) >3 then  --前3名不偏移
        if tonumber(rankingListData[_cur_RankingList .. "_PlayersRank"]) >50 then
            _tableView:setContentOffset(ccp(0, 0 ))
        else -- 4-50名
            _tableView:setContentOffset(ccp(0, ( #listData- tonumber(rankingListData[_cur_RankingList .. "_PlayersRank"])) *  144* -1   ))   
        end
    end
end


local function changeFrontEndData()

    _cur_RankingList = allRankingList[_curIndex]
    _refreshThreeTitle()  --刷新左中右 3个大榜标题
    changeListDataToCur() 

    _tableView:reloadData() 
    _refreshTableViewOffset() --偏移

    local ruleComment = tolua.cast(RankingListViewOwner["ruleComment"],"CCLabelTTF") --不同榜不同活动规则
    ruleComment:setString( configureStorageRankingWords["RankingPG_" .. _curIndex].words )


    if _cur_RankingList == "playerLevelRankingList" or  _cur_RankingList == "arenaRankingList" then
        ttf2:setString( HLNSLocalizedString( "RankingList.form" ) ) --玩家阵容
        ttf3:setString( HLNSLocalizedString( "RankingList.playerInfo" ) ) --玩家信息
        ttf4:setString( HLNSLocalizedString( "RankingList.captainsLevel" ) ) --船长等级
        --联盟的跟其他的都不一样
    elseif _cur_RankingList == "leagueLevelRankingList"  then  
        ttf2:setString( HLNSLocalizedString( "RankingList.leagueInfo" ) ) --联盟信息
        ttf3:setString( HLNSLocalizedString( "RankingList.leagueCEO" ) ) --盟主
        ttf4:setString( HLNSLocalizedString( "RankingList.numberOfLeague" ) ) --联盟人数
    elseif _cur_RankingList == "seaMistRankingList" then
        ttf2:setString( HLNSLocalizedString( "RankingList.form" ) ) --玩家阵容
        ttf3:setString( HLNSLocalizedString( "RankingList.playerInfo" ) ) --玩家信息
        ttf4:setString( HLNSLocalizedString( "RankingList.TheHighestStage" ) ) --最高闯关
    elseif _cur_RankingList == "bossDamageRankingList" then
        ttf2:setString( HLNSLocalizedString( "RankingList.form" ) ) --玩家阵容
        ttf3:setString( HLNSLocalizedString( "RankingList.playerInfo" ) ) --玩家信息
        ttf4:setString( HLNSLocalizedString( "RankingList.SingleMaximumDamage" ) ) --单次最高伤害

    end


end

local function leftListTitleBtnClick()

    _curIndex = getGoodCurIndex(_curIndex-1)     
    print("**lsf _curIndex",_curIndex)
    changeFrontEndData()  
end
RankingListViewOwner["leftListTitleBtnClick"] = leftListTitleBtnClick


local function rightListTitleBtnClick()
    _curIndex = getGoodCurIndex(_curIndex+1) 
    print("**lsf _curIndex",_curIndex) 
    changeFrontEndData()
end
RankingListViewOwner["rightListTitleBtnClick"] = rightListTitleBtnClick


-- 查看玩家阵容  by点击头像                    
local function viewBattleInfo(url, rtnData)
    playerBattleData:fromDic(rtnData.info)
    getMainLayer():getParent():addChild(createTeamPopupLayer(_priority - 3))
end
-- 查看玩家阵容  by点击头像   
local function viewFormClick(tag)
    print("viewFormClick", tag)
    Global:instance():TDGAonEventAndEventData("check")
    
    if listData[tag].id then
        print("11")
        print("*** ",listData[tag].id)
        id = tostring (listData[tag].id)
    elseif listData[tag].playerId then
        print("22")
        id = tostring(listData[tag].playerId )
    end

    print("***lsf PlayerId ",listData[tag].id,id)
    doActionFun("ARENA_GET_BATTLE_INFO", {id}, viewBattleInfo)
end
RankingListCellOwner["viewFormClick"] = viewFormClick



local function _addTableView()

    local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
    cache:addSpriteFramesWithFile("ccbResources/serverPK.plist")
     
   
    listData = rankingListData.playerLevelRankingList
   

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
            
            print("***lsf cellAtIndex",a1+1)

            local  proxy = CCBProxy:create()
            local _hbCell = tolua.cast(CCBReaderLoad("ccbResources/RankingListCell.ccbi",proxy,true,"RankingListCellOwner"),"CCSprite")
            local owner = RankingListCellOwner


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

            ---*********************以下是 几个榜的公共区域   给tableView数据 ****************************
            ---*********************以下是 几个榜的公共区域   给tableView数据 ****************************

            local rank4 = tolua.cast(owner["rank4"],"CCLabelTTF")
            local rank4b = tolua.cast(owner["rank4b"],"CCLabelTTF")
            local rank123 = tolua.cast(owner["rank123"],"CCLabelTTF")

            --排名数字12345....的显示
            if a1+1 > 3 then        
                rank4:setVisible(true)
                rank4b:setVisible(true)
                rank123:setVisible(false)
                rank4:setString( a1+1 )       
                rank4b:setString( a1+1 )
             
                if  a1+1 == #listData    then 
                    --如果玩家在最后一名， 把排名改成玩家自己的排名，防止玩家在 一千多名以外 然后显示成51 或 31
                    if tonumber(listData[a1+1].id) == userdata.userId   or  tonumber(listData[a1+1].playerId) ==  userdata.userId then
                       
                        rank4:setString( rankingListData[_cur_RankingList .. "_PlayersRank"]  )       
                        rank4b:setString( rankingListData[_cur_RankingList .. "_PlayersRank"] )
                        _hbCell:setDisplayFrame( cache:spriteFrameByName("palyerOwner_Bg.png"))
                        --if tonumber(rankingListData[_cur_RankingList .. "_PlayersRank"] ) > #listData  then --51名以后字变小 防止字超出 1253
                        rank4:setFontSize(50)
                        rank4b:setFontSize(50)                    
                    end
                end


            else 
                rank123:setVisible(true)
                rank4:setVisible(false)
                rank4b:setVisible(false)   
                rank123:setDisplayFrame(cache:spriteFrameByName(string.format("num%d.png",  a1+1  )))

            end


            local attributeFontsLayer3 = tolua.cast(RankingListViewOwner["attributeFontsLayer3"],"CCLayer")
            local attributeFontsLayer4 = tolua.cast(RankingListViewOwner["attributeFontsLayer4"],"CCLayer")


            local name = tolua.cast(owner["name"],"CCLabelTTF")
            name:setString( listData[a1+1].name )   

            local vip = tolua.cast(owner["vip"], "CCSprite")
            if listData[a1+1].vipLevel then       
                vip:setDisplayFrame(cache:spriteFrameByName(string.format("VIP_%d.png",  listData[a1+1].vipLevel   )))
            end
            vip:setVisible(not userdata:getVipAuditState())

            --各玩家头像
            local frame = tolua.cast(owner["frame1"], "CCSprite")
            local head = tolua.cast(owner["head1"], "CCSprite")
            if listData[a1+1].form then  --如果有玩家的英雄头像
                local heroId = listData[a1+1].form
                local conf = herodata:getHeroConfig(heroId)
                if conf then
                    local rank      -- 加入觉醒功能后伙伴的背景框需要判断 wake值
                    if listData[a1+1].wake and listData[a1+1].wake == 2 then
                        rank = 5
                    elseif listData[a1+1].wake and listData[a1+1].wake == 1 then
                        rank = 3
                    else
                        rank = conf.rank
                    end
                    --local hero = herodata:getHeroInfoById(heroId)
                    -- if hero then
                    --     rank = hero.rank
                    -- end
                    frame:setVisible(true)
                    frame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", rank)))
                    local f = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(herodata:getHeroHeadByHeroId(heroId))
                    if f then
                        head:setVisible(true)
                        head:setDisplayFrame(f)
                    end
                end
            end

            local level = tolua.cast(owner["level"],"CCLabelTTF")
            level:setString( string.format("LV:%d", listData[a1+1].level )  )

            local viewForm = tolua.cast(owner["viewForm"],"CCMenuItemImage")
            viewForm:setTag(a1 + 1)


            --如果是玩家本人，改换背景
            if _cur_RankingList == "playerLevelRankingList" or _cur_RankingList == "arenaRankingList"  or 
                _cur_RankingList == "bossDamageRankingList"  then
                
                if   tonumber(listData[a1+1].id) == userdata.userId  then
                    _hbCell:setDisplayFrame( cache:spriteFrameByName("palyerOwner_Bg.png"))
                end
            end


            ------------------------------------------------------------------------------------------------------------------------
            ---------------------------------------------以下是 船长排行榜-----------------------------------------------------------

            if _cur_RankingList == "playerLevelRankingList" then     
                print("***lsf  if  _cur_RankingList is playerLevelRankingList ")   
  
            -----------------------------------以下 联盟排行榜-----------------------------------
            
            elseif _cur_RankingList == "leagueLevelRankingList" then
                print("***lsf  if  _cur_RankingList is leagueLevelRankingList ")          
                
                frame:setVisible(false)
                head:setVisible(false)
                viewForm:setVisible(false)
          
                name:setPositionX( ttf2:getPositionX() )
                name:setPositionY( _hbCell:getContentSize().height * 0.62 )
                name:setFontSize(30)                                
               
                level:setPositionX( ttf2:getPositionX() )
                level:setPositionY( _hbCell:getContentSize().height * 0.3)
                level:setColor( name:getColor() )

                local leagueCEO_name = tolua.cast(owner["leagueCEO_name"],"CCLabelTTF")
                leagueCEO_name:setVisible(true)
                leagueCEO_name:setString(  listData[a1+1].ceoName   )

                if listData[a1+1].ceoVipLevel then       
                    vip:setDisplayFrame(cache:spriteFrameByName(string.format("VIP_%d.png",  listData[a1+1].ceoVipLevel   )))
                end
                vip:setVisible(not userdata:getVipAuditState())
                local league_member = tolua.cast(owner["league_member"],"CCLabelTTF")
                league_member:setVisible(true)
                if listData[a1+1].total and listData[a1+1].total ~= "" then
                    league_member:setString( string.format("%d/%d",listData[a1+1].member, listData[a1+1].total  ) )
                else
                    league_member:setVisible(false)
                end

                 --高亮背景 ， 如果是玩家的联盟，  
                if   a1+1 == rankingListData.leagueLevelRankingList_PlayersRank  then             
                    _hbCell:setDisplayFrame( cache:spriteFrameByName("palyerOwner_Bg.png"))
                end

            -----------------------------------以下是 迷雾之海排行榜-----------------------------------

            elseif _cur_RankingList == "seaMistRankingList" then
                print("***lsf  if  _cur_RankingList is seaMistRankingList ")

                -- -- 三合一 名字 等级 vip -- -- 
                name:setPositionY( _hbCell:getContentSize().height * 0.71 )
                name:setFontSize(25)  

                level:setPositionX( ttf3:getPositionX() )
                level:setPositionY( _hbCell:getContentSize().height * 0.45)
                level:setColor( name:getColor() )

                vip:setPositionY( _hbCell:getContentSize().height * 0.29)
                ----  三合一 名字 等级 vip -- -- 
                
                -- 最高闯关
                local stage = tolua.cast(owner["stage"],"CCLabelTTF")
                stage:setString(  listData[a1+1].stage  )
                stage:setVisible(true)
                --自己高亮
                if   tonumber(listData[a1+1].playerId) == userdata.userId  then
                    _hbCell:setDisplayFrame( cache:spriteFrameByName("palyerOwner_Bg.png"))
                end

            -----------------------------------以下是 决斗排行榜-----------------------------------
            elseif _cur_RankingList == "arenaRankingList" then
                print("***lsf  if  _cur_RankingList is arena RankingList ")
        

            -----------------------------------以下是 boos恶魔谷排行榜-----------------------------------
            elseif _cur_RankingList == "bossDamageRankingList" then
                print("***lsf  if  _cur_RankingList is bossDamage RankingList ")
                
                -- -- 玩家信息 三合一 ，名字 等级 vip -- -- 
                name:setPositionY( _hbCell:getContentSize().height * 0.71 )
                name:setFontSize(25)  

                level:setPositionX( ttf3:getPositionX() )
                level:setPositionY( _hbCell:getContentSize().height * 0.45)
                level:setColor( name:getColor() )

                vip:setPositionY( _hbCell:getContentSize().height * 0.29)
                ---- 玩家信息 三合一 名字 等级 vip -- -- 

                local damage = tolua.cast(owner["stage"],"CCLabelTTF")
                damage:setString(  listData[a1+1].damage  )
                damage:setVisible(true)
               
            end
     
            a2:addChild(_hbCell, 1, 1)
            _hbCell:setAnchorPoint(ccp(0.5, 0))
            _hbCell:setPosition( _contentLayer:getContentSize().width / 2, 0)  
              
            
            
            r = a2
        elseif fn == "numberOfCells" then
            --print("***lsf GetNumberOfCells")
  
            
            r = #listData
            
        elseif fn == "cellTouched" then         -- A cell was touched, a1 is cell that be touched. This is not necessary.
        elseif fn == "cellTouchBegan" then      -- A cell is touching, a1 is cell, a2 is CCTouch
        elseif fn == "cellTouchEnded" then      -- A cell was touched, a1 is cell, a2 is CCTouch
        elseif fn == "cellHighlight" then       -- A cell is highlighting, coco2d-x 2.1.3 or above
        elseif fn == "cellUnhighlight" then     -- A cell had been unhighlighted, coco2d-x 2.1.3 or above
        elseif fn == "cellWillRecycle" then     -- A cell will be recycled, coco2d-x 2.1.3 or above
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

   _refreshTableViewOffset()
end


local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(RankingListViewOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction(RankingListViewOwner, "infoBg", _layer)
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
    local menu = tolua.cast(RankingListViewOwner["menu"], "CCMenu")
    menu:setTouchPriority(_priority - 2)
    _tableView:setTouchPriority(_priority - 2)
 
end

function getRankingListLayer()
    return _layer
end



-- 刷新 取后台数据
local function _refreshData()

    local owner = RankingListViewOwner

    configureStorageRankingWords = ConfigureStorage.RankingWords
    print("xiangqing  RankingWords")
    PrintTable(configureStorageRankingWords)
    
    
    local ruleComment = tolua.cast(owner["ruleComment"],"CCLabelTTF")
    ruleComment:setString( configureStorageRankingWords["RankingPG_" .. _curIndex].words )

    
    -- 玩家自己未上榜 往表中添加  --公共数据
    local temp = {}
    local function addCommonPlayerOwnerData()
        
        print("**lsf addPlayerOwnerData")
        temp = {}
        temp.name = userdata.name
        temp.id = userdata.userId 
        temp.level = userdata.level 
        temp.vipLevel = userdata:getVipLevel()
        temp.form = herodata.heroes[herodata.form["0"]].heroId
     
    end

    if  rankingListData.playerLevelRankingList_PlayersRank > #rankingListData.playerLevelRankingList   then 
        addCommonPlayerOwnerData()--
        table.insert(rankingListData.playerLevelRankingList,  temp)                   
    end 

    if  rankingListData.arenaRankingList_PlayersRank > #rankingListData.arenaRankingList   then    
        addCommonPlayerOwnerData()--
        table.insert(rankingListData.arenaRankingList,  temp)      
    end  

    if  rankingListData.bossDamageRankingList_PlayersRank > #rankingListData.bossDamageRankingList   then 
        addCommonPlayerOwnerData()
        temp.damage = rankingListData.bossDamageRankingList_PlayersDamage
        table.insert(rankingListData.bossDamageRankingList,  temp)                   
    end       
 
    if  rankingListData.seaMistRankingList_PlayersRank > #rankingListData.seaMistRankingList   then 
        addCommonPlayerOwnerData()
        if rankingListData.seaMistRankingList_PlayersStage then
            temp.stage = rankingListData.seaMistRankingList_PlayersStage
        else
            temp.stage = "--"
        end
        
        table.insert(rankingListData.seaMistRankingList,  temp)   
        print("**lsf now insert players own data")
        PrintTable(rankingListData.seaMistRankingList )                
    end      

    if  rankingListData.leagueLevelRankingList_PlayersRank > #rankingListData.leagueLevelRankingList   then       
        local  info = rankingListData.leagueLevelRankingList_PlayersLeagueInfo
        temp.name =  info.name
        temp.level =  info.level 
        temp.ceoName =  info.ceoName
        temp.ceoVipLevel =  info.ceoVipLevel
        temp.member =   info.member
        temp.total =  info.total
        table.insert(rankingListData.leagueLevelRankingList,  temp)                   
    end         
   
    
    _cur_RankingList = allRankingList[_curIndex] --取现在榜的名字
    _refreshThreeTitle() --刷新左中右3个大榜 标题

end

local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/RankingListView.ccbi",proxy, true,"RankingListViewOwner")
    _layer = tolua.cast(node,"CCLayer")
    _contentLayer = RankingListViewOwner["contentLayer"]

    local owner = RankingListViewOwner
    
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
    ttf2 = tolua.cast(RankingListViewOwner["2ttf"],"CCLabelTTF") 
    ttf3 = tolua.cast(RankingListViewOwner["3ttf"],"CCLabelTTF")
    ttf4 = tolua.cast(RankingListViewOwner["4ttf"],"CCLabelTTF")

    _curIndex = 1 
    _refreshData()
    _addTableView()
  

end


function createRankingListLayer(priority) --priority -140
    _priority = (priority ~= nil) and priority or -140

    _init()

    local function _onEnter()
        print("RankingListView onEnter")
        
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
        
        popUpUiAction(RankingListViewOwner, "infoBg")
        
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