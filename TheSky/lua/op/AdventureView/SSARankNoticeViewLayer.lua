local _layer
local progress
local _data
-- 名字不要重复
SSARankNoticeViewOwner = SSARankNoticeViewOwner or {}
ccb["SSARankNoticeViewOwner"] = SSARankNoticeViewOwner

SSARankNoticeCellOwner = SSARankNoticeCellOwner or {}
ccb["SSARankNoticeCellOwner"] = SSARankNoticeCellOwner

-- X按钮
local function closeItemClick()
    popUpCloseAction(SSARankNoticeViewOwner, "infoBg", _layer)
end
SSARankNoticeViewOwner["closeItemClick"] = closeItemClick
-- 关闭按钮
local function BackClicked()
    popUpCloseAction(SSARankNoticeViewOwner, "infoBg", _layer)
end
SSARankNoticeViewOwner["BackClicked"] = BackClicked

--查看阵容
local function lookTeamBtnClick(tag)
    local index = tag 
    local dic = _data.rankInfo[tostring(index - 1)] -- 对应得数据
    local data = dic.battleData
    local form = data.form[tostring(0)]
    local heroId = data.heros[tostring(form)].heroId
    playerBattleData:fromDic(data)
    getMainLayer():getParent():addChild(createTeamPopupLayer(-140))
end
SSARankNoticeCellOwner["lookTeamBtnClick"] = lookTeamBtnClick

-- 判断玩家是否上榜
local function RankNoticeYesOrNo()
    for i=1,getMyTableCount(_data.rankInfo) do
        local dic = _data.rankInfo[tostring(i - 1)]
        if userdata.selectServer.serverName == dic.serverName and  userdata.userId == dic.battleData.id then -- 判断玩家是否上榜
            return true   
        end
    end 
    return false
end
-- 玩家自己未上榜数据 往表中添加需要的数据
local function addPlayerOwnerData()
    local rankNoticeYesOrNo = RankNoticeYesOrNo()
    -- if rankNoticeYesOrNo then -- 测试
    if not rankNoticeYesOrNo then 
        local index = getMyTableCount(_data.rankInfo)
        _data.rankInfo[tostring(index)] = "self"
    end
end
-- 添加tableview
local function _addTableView()
    local containLayer = tolua.cast(SSARankNoticeViewOwner["containLayer"],"CCLayer")
    -- 添加数据
    addPlayerOwnerData()

    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(595, 175)
        elseif fn == "cellAtIndex" then
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            --单条数据
            local  _hbCell 
            local  proxy = CCBProxy:create()
            
            local  _hbCell  = tolua.cast(CCBReaderLoad("ccbResources/SSARankNoticeCell.ccbi",proxy,true,"SSARankNoticeCellOwner"),"CCLayer")
            local dic = _data.rankInfo[tostring(a1)]
            if type(dic) == "string" and dic == "self" then
                -- 判断得出自己
                local lookTeamBtn = tolua.cast(SSARankNoticeCellOwner["lookTeamBtn"], "CCMenuItemImage")
                local chakanzhenrongLabel = tolua.cast(SSARankNoticeCellOwner["chakanzhenrongLabel"], "CCLabelTTF")
                lookTeamBtn:setTag(a1 + 1)
                local function getVipLevel()
                    for i,v in ipairs(ConfigureStorage.vipConfig) do
                        if vipdata.vipScore < v.score then
                            return i - 1 - 1        -- i从1开始
                        end
                    end
                    return #ConfigureStorage.vipConfig - 1
                end
                --name level scoreLabel
                local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
                local name = tolua.cast(SSARankNoticeCellOwner["name"], "CCLabelTTF")
                local level = tolua.cast(SSARankNoticeCellOwner["level"], "CCLabelTTF")
                local server = tolua.cast(SSARankNoticeCellOwner["server"], "CCLabelTTF")
                local scoreLabel = tolua.cast(SSARankNoticeCellOwner["scoreLabel"], "CCLabelTTF") -- 玩家积分数量
                local vip = tolua.cast(SSARankNoticeCellOwner["vip"], "CCSprite")
                name:setString(userdata.name)
                level:setString('LV' .. userdata.level)
                server:setString(userdata.selectServer.serverName)
                vip:setDisplayFrame(cache:spriteFrameByName(string.format("VIP_%d.png", getVipLevel())))
                scoreLabel:setString(_data.myData.score)
                
                local ranking = tolua.cast(SSARankNoticeCellOwner["ranking"], "CCLabelTTF")
                local chaoxinxingLabel = tolua.cast(SSARankNoticeCellOwner["chaoxinxingLabel"], "CCLabelTTF") -- 超新星
                local rankLabel1 = tolua.cast(SSARankNoticeCellOwner["rankLabel1"], "CCLabelTTF")
                local rankSprite = tolua.cast(SSARankNoticeCellOwner["rankSprite"], "CCSprite")
                local bgSprite = tolua.cast(SSARankNoticeCellOwner["bgSprite"], "CCSprite") -- 背景图片

                local rankOneSprite = tolua.cast(SSARankNoticeCellOwner["rankOneSprite"], "CCSprite") -- 前3排名图
                local rankThreeSprite = tolua.cast(SSARankNoticeCellOwner["rankThreeSprite"], "CCSprite")
                local rankTwoSprite = tolua.cast(SSARankNoticeCellOwner["rankTwoSprite"], "CCSprite")

                bgSprite:setDisplayFrame(cache:spriteFrameByName("palyerOwner_Bg.png"))
                chaoxinxingLabel:setVisible(false)
                lookTeamBtn:setVisible(false)
                chakanzhenrongLabel:setVisible(false)


                ranking:setVisible(false)
                rankSprite:setVisible(false)
                rankLabel1:setVisible(false)
                -- ranking:setString(HLNSLocalizedString("SSA.RankNotice.UnRank"))

                local form = herodata.form
                for i=1,3 do
                    local hid = herodata.form[tostring(i - 1)]
                    local hero = herodata.heroes[hid]
                    local heroId = hero.heroId
                    local conf = herodata:getHeroConfig(heroId)
                    if conf then
                        local frame = tolua.cast(SSARankNoticeCellOwner["frame" .. i], "CCSprite") 
                        local head = tolua.cast(SSARankNoticeCellOwner["head" .. i], "CCSprite")
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
            else
                local lookTeamBtn = tolua.cast(SSARankNoticeCellOwner["lookTeamBtn"], "CCMenuItemImage")
                lookTeamBtn:setTag(a1 + 1)

                 -- 设置优先级
                local menu = tolua.cast(SSARankNoticeCellOwner["menu"], "CCMenu")
                local function setCellMenuPriority(sender)
                    if sender then
                        local menu = tolua.cast(sender, "CCMenu")
                        menu:setHandlerPriority(_priority - 2)
                    end
                end
                local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCCallFuncN:create(setCellMenuPriority))
                menu:runAction(seq)
                
                local function getVipLevel()
                    for i,v in ipairs(ConfigureStorage.vipConfig) do
                        if dic.battleData.vipScore < v.score then
                            return i - 1 - 1        -- i从1开始
                        end
                    end
                    return #ConfigureStorage.vipConfig - 1
                end
                --name level scoreLabel
                local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
                local name = tolua.cast(SSARankNoticeCellOwner["name"], "CCLabelTTF")
                local level = tolua.cast(SSARankNoticeCellOwner["level"], "CCLabelTTF")
                local server = tolua.cast(SSARankNoticeCellOwner["server"], "CCLabelTTF")
                local scoreLabel = tolua.cast(SSARankNoticeCellOwner["scoreLabel"], "CCLabelTTF") -- 玩家积分数量
                local vip = tolua.cast(SSARankNoticeCellOwner["vip"], "CCSprite")
                name:setString(dic.battleData.name)
                level:setString('LV' .. dic.battleData.level)
                server:setString(dic.serverName)
                vip:setDisplayFrame(cache:spriteFrameByName(string.format("VIP_%d.png", getVipLevel())))
                scoreLabel:setString(dic.score)
                print("userdata.selectServer.serverName" , userdata.selectServer.serverName)
                local ranking = tolua.cast(SSARankNoticeCellOwner["ranking"], "CCLabelTTF")
                local chaoxinxingLabel = tolua.cast(SSARankNoticeCellOwner["chaoxinxingLabel"], "CCLabelTTF") -- 超新星
                local rankLabel1 = tolua.cast(SSARankNoticeCellOwner["rankLabel1"], "CCLabelTTF")
                local rankSprite = tolua.cast(SSARankNoticeCellOwner["rankSprite"], "CCSprite")
                local bgSprite = tolua.cast(SSARankNoticeCellOwner["bgSprite"], "CCSprite") -- 背景图片

                local rankOneSprite = tolua.cast(SSARankNoticeCellOwner["rankOneSprite"], "CCSprite") -- 前3排名图
                local rankTwoSprite = tolua.cast(SSARankNoticeCellOwner["rankTwoSprite"], "CCSprite")
                local rankThreeSprite = tolua.cast(SSARankNoticeCellOwner["rankThreeSprite"], "CCSprite")

                for i=1,getMyTableCount(_data.rankInfo) do
                    ranking:setString(a1 + 1)
                    if a1 + 1 > 32 then
                        chaoxinxingLabel:setVisible(false)
                        ranking:setVisible(true)
                        rankSprite:setVisible(true)
                        rankLabel1:setVisible(true)
                        bgSprite:setDisplayFrame(cache:spriteFrameByName("unRank_Bg.png"))
                    else
                        bgSprite:setDisplayFrame(cache:spriteFrameByName("supernova_Bg.png"))
                        if a1 + 1 == 1 then
                            rankOneSprite:setVisible(true)
                        elseif a1 + 1 == 2 then
                            rankTwoSprite:setVisible(true)
                        elseif a1 + 1 == 3 then
                            rankThreeSprite:setVisible(true)
                        else
                            ranking:setVisible(true)
                            rankSprite:setVisible(true)
                            rankLabel1:setVisible(true)
                        end
                    end
                end
                for i=1,3 do
                    if dic.battleData.heros  and dic.battleData.heros[dic.battleData.form[tostring(i - 1)]] then 
                        local hero = dic.battleData.heros[dic.battleData.form[tostring(i - 1)]]
                        local heroId = hero.heroId
                        local conf = herodata:getHeroConfig(heroId)
                        if conf then
                            local frame = tolua.cast(SSARankNoticeCellOwner["frame" .. i], "CCSprite") 
                            local head = tolua.cast(SSARankNoticeCellOwner["head" .. i], "CCSprite")
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
                if userdata.selectServer.serverName ==dic.serverName and  userdata.userId == dic.battleData.id then -- 判断玩家是否上榜
                    -- 已上榜
                    bgSprite:setDisplayFrame(cache:spriteFrameByName("palyerOwner_Bg.png"))
                end
            end
            -- _hbCell:setScale(retina)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            a2:addChild(_hbCell, 0, 1)
            r = a2
        elseif fn == "numberOfCells" then
            r = getMyTableCount(_data.rankInfo)  
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
    local rankLabel = tolua.cast(SSARankNoticeViewOwner["rankLabel"], "CCLabelTTF")
    local scoreCountLabel = tolua.cast(SSARankNoticeViewOwner["scoreCountLabel"], "CCLabelTTF")
    scoreCountLabel:setString(HLNSLocalizedString("SSA.RankNotice.RankScore", _data.myData.score)) -- 积分
    if _data.myData.index == nil or _data.myData.index == "" then
        rankLabel:setString(HLNSLocalizedString("SSA.RankNotice.UnRank")) -- 未上榜
    else
        rankLabel:setString(HLNSLocalizedString("SSA.RankNotice.Rank", _data.myData.index + 1)) -- 排名
    end
end
local function refreshData()
    refresh()
    _addTableView()
end



local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(SSARankNoticeViewOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction(SSARankNoticeViewOwner, "infoBg", _layer)
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
    local menu = tolua.cast(SSARankNoticeViewOwner["menu"], "CCMenu")
    menu:setTouchPriority(_priority - 2)
    _tableView:setTouchPriority(_priority - 2)
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/SSARankNoticeView.ccbi", proxy, true,"SSARankNoticeViewOwner")
    _layer = tolua.cast(node,"CCLayer")
    refreshData()
end

-- 该方法名字每个文件不要重复
function getSSARankNoticeViewLayer()
    return _layer
end

function createSSARankNoticeViewLayer(data, priority)
    _priority = (priority ~= nil) and priority or -132
    _data = data
    _init()
    function _layer:_refresh()
        refresh()
        _tableView:reloadData() 
    end

    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
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

    _layer:registerScriptTouchHandler(onTouch ,false , _priority ,true )
    _layer:setTouchEnabled(true)
    _layer:registerScriptHandler(_layerEventHandler)
    return _layer
end