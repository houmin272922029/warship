local _layer
local progress
local _data
-- 名字不要重复
StrideServerArenaWorshipViewOwner = StrideServerArenaWorshipViewOwner or {}
ccb["StrideServerArenaWorshipViewOwner"] = StrideServerArenaWorshipViewOwner

StrideServerArenaWorshipCellOwner = StrideServerArenaWorshipCellOwner or {}
ccb["StrideServerArenaWorshipCellOwner"] = StrideServerArenaWorshipCellOwner


-- 膜拜按钮
local function worshipBtnClick(tag)
    local index = tag 
    -- 判断当前玩家是否还有膜拜次数
    local times = 0
    for i=1,getMyTableCount(_data.top32) do
        if _data.top32[tostring(i - 1)].isWorship == true  then
            times = times + 1
        end
    end
    if ConfigureStorage.vipConfig[vipdata:getVipLevel()].crossDualWorship > times  then
        getMainLayer():getParent():addChild(createStrideServerArenaWorshipMakeSureLayer(index))
    else
        ShowText(HLNSLocalizedString("SSA.worshipTimesNotEnough"))
    end
end
StrideServerArenaWorshipCellOwner["worshipBtnClick"] = worshipBtnClick


--返回按钮
local function BackClicked()
    runtimeCache.SSAState = ssaDataFlag.home
    getMainLayer():gotoAdventure()
end
StrideServerArenaWorshipViewOwner["BackClicked"] = BackClicked

-- 查看阵容
local function lookTeamBtnClick(tag)
    local index = tag 
    local dic = _data.top32[tostring(index - 1)] -- 对应得数据
    local data = dic.playerData
    local form = data.form[tostring(0)]
    local heroId = data.heros[tostring(form)].heroId
    playerBattleData:fromDic(data)
    getMainLayer():getParent():addChild(createTeamPopupLayer(-140))
end
StrideServerArenaWorshipCellOwner["lookTeamBtnClick"] = lookTeamBtnClick

--赛事回顾
local function battleLookBackClick()
    -- 回到四皇争霸页面
    print("赛事回顾")
    local timeStatus = {"32to16Begin","16to8Begin","8to4Begin","4to2Begin","2to1Begin"}
    local function callback(url, rtnData)
        ssaData.data = rtnData.info
        _data = ssaData.data
        getMainLayer():gotoSSAFourKing() 
    end
    doActionFun("CROSSSERVERBATTLE_GETBATTLEMAP", {timeStatus[5]}, callback)
end
StrideServerArenaWorshipViewOwner["battleLookBackClick"] = battleLookBackClick

-- 添加tableview
local function _addTableView()
    local containLayer = tolua.cast(StrideServerArenaWorshipViewOwner["containLayer"],"CCLayer")
    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(620, 175)
        elseif fn == "cellAtIndex" then
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            --单条数据
            local  _hbCell 
            local  proxy = CCBProxy:create()
            local  _hbCell  = tolua.cast(CCBReaderLoad("ccbResources/StrideServerArenaWorshipCell.ccbi",proxy,true,"StrideServerArenaWorshipCellOwner"),"CCLayer")
            local dic = _data.top32[tostring(a1)]
            local worshipBtn = tolua.cast(StrideServerArenaWorshipCellOwner["worshipBtn"], "CCMenuItemImage")
            worshipBtn:setTag(a1 + 1)
            local lookTeamBtn = tolua.cast(StrideServerArenaWorshipCellOwner["lookTeamBtn"], "CCMenuItemImage")
            lookTeamBtn:setTag(a1 + 1)
            
            --name level scoreLabel
            local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
            local name = tolua.cast(StrideServerArenaWorshipCellOwner["name"], "CCLabelTTF")
            local level = tolua.cast(StrideServerArenaWorshipCellOwner["level"], "CCLabelTTF")
            local server = tolua.cast(StrideServerArenaWorshipCellOwner["server"], "CCLabelTTF")
            local vip = tolua.cast(StrideServerArenaWorshipCellOwner["vip"], "CCSprite")
            name:setString(dic.playerData.name)

            local function getVipLevel()
                for i,v in ipairs(ConfigureStorage.vipConfig) do
                    if dic.playerData.vipScore < v.score then
                        return i - 1 - 1        -- i从1开始
                    end
                end
                return #ConfigureStorage.vipConfig - 1
            end

            level:setString('LV' .. dic.playerData.level)
            server:setString( dic.serverName)
            vip:setDisplayFrame(cache:spriteFrameByName(string.format("VIP_%d.png", getVipLevel())))
            local ranking = tolua.cast(StrideServerArenaWorshipCellOwner["ranking"], "CCLabelTTF")
            local rank1 = tolua.cast(StrideServerArenaWorshipCellOwner["rank1"], "CCSprite") -- 海上霸主图标
            local fourKing = tolua.cast(StrideServerArenaWorshipCellOwner["fourKing"], "CCSprite") -- 四皇图标
            local chaoxinxingLabel = tolua.cast(StrideServerArenaWorshipCellOwner["chaoxinxingLabel"], "CCLabelTTF") -- 超新星
            local rankLabel1 = tolua.cast(StrideServerArenaWorshipCellOwner["rankLabel1"], "CCLabelTTF")
            local rankSprite = tolua.cast(StrideServerArenaWorshipCellOwner["rankSprite"], "CCSprite")
            for i=1,getMyTableCount(_data.top32) do
                ranking:setString(a1 + 1)
                if a1 + 1 > 4 then
                    chaoxinxingLabel:setVisible(true)
                    ranking:setVisible(false)
                    rankSprite:setVisible(false)
                    rankLabel1:setVisible(false)
                else
                    if a1 + 1 == 1 then
                        rank1:setVisible(true)
                    else
                        fourKing:setVisible(true) 
                    end
                end
            end
            local haveWorship = tolua.cast(StrideServerArenaWorshipCellOwner["haveWorship"], "CCLabelTTF")
            local worship_text = tolua.cast(StrideServerArenaWorshipCellOwner["worship_text"], "CCSprite")
            if dic.isWorship == true or a1 + 1 > 4 then
                worshipBtn:setVisible(false)
                worship_text:setVisible(false)
                if a1 + 1 <= 4 then
                    haveWorship:setVisible(true)
                end
                
            else
                worshipBtn:setVisible(true)
                worship_text:setVisible(true)
            end
            for i=1,3 do
                if dic.playerData.heros  and dic.playerData.heros[dic.playerData.form[tostring(i - 1)]] then 
                    local hero = dic.playerData.heros[dic.playerData.form[tostring(i - 1)]]
                    local heroId = hero.heroId
                    local conf = herodata:getHeroConfig(heroId)
                    if conf then
                        local frame = tolua.cast(StrideServerArenaWorshipCellOwner["frame" .. i], "CCSprite") 
                        local head = tolua.cast(StrideServerArenaWorshipCellOwner["head" .. i], "CCSprite")
                        local colorSprite = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", herodata:fixRank(conf.rank, hero.wake)))
                        local f = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(herodata:getHeroHeadByHeroId(heroId))
                        if f then
                            head:setVisible(true)
                            frame:setVisible(true)
                            head:setDisplayFrame(f)
                            frame:setDisplayFrame(colorSprite)
                        end
                    end      
                end
                
            end
            -- _hbCell:setScale(retina)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            a2:addChild(_hbCell, 0, 1)
            r = a2
        elseif fn == "numberOfCells" then
            -- r = #_data
            --tabelview中cell的行数
            r = getMyTableCount(_data.top32)
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

local function refresh()
     _data = ssaData.data

    local times = 0
    for i=1,getMyTableCount(_data.top32) do
        if _data.top32[tostring(i - 1)].isWorship == true  then
            times = times + 1
        end
    end
    local count = tolua.cast(StrideServerArenaWorshipViewOwner["count"] , "CCLabelTTF")
    count:setString(HLNSLocalizedString("SSA.worshipTimes") .. ConfigureStorage.vipConfig[vipdata:getVipLevel()].crossDualWorship - times .. '/' .. ConfigureStorage.vipConfig[vipdata:getVipLevel()].crossDualWorship)
end
local function refreshData()
    refresh()
    _addTableView()
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/StrideServerArenaWorshipView.ccbi", proxy, true,"StrideServerArenaWorshipViewOwner")
    _layer = tolua.cast(node,"CCLayer")
    refreshData()
end

-- 该方法名字每个文件不要重复
function getStrideServerArenaWorshipViewLayer()
    return _layer
end

function createStrideServerArenaWorshipViewLayer()
    _init()
    function _layer:_refresh()
        refresh()
        _tableView:reloadData() 
    end

    local function _onEnter()
        
    end
    local function _onExit()
        _layer = nil
        progress = nil
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