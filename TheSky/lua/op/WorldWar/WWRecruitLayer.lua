local _layer
local _tableView
local _data

-- 名字不要重复
WWRecruitOwner = WWRecruitOwner or {}
ccb["WWRecruitOwner"] = WWRecruitOwner


local function callback(url, rtnData)
    worldwardata:fromDic(rtnData.info)
    postNotification(NOTI_WW_REFRESH, nil)
end

local function refreshItemClick()
    doActionFun("WW_FLUSH_ALLSCIENCE", {}, callback)
end
WWRecruitOwner["refreshItemClick"] = refreshItemClick

local function resetItemClick()
    if worldwardata:getResetCountLeft() == 0 then
        ShowText(HLNSLocalizedString("ww.text.7"))
        return
    end
    doActionFun("WW_RESET_ALLSCIENCE", {}, callback)
end
WWRecruitOwner["resetItemClick"] = resetItemClick

local function addTableView()
    local offset = 1
    if _tableView then
        offset = _tableView:getContentOffset().y
        _tableView:removeFromParentAndCleanup(true)
        _tableView = nil
    end
    _data = worldwardata:getScienceData()

    WWExperimentCellOwner = WWExperimentCellOwner or {}
    ccb["WWExperimentCellOwner"] = WWExperimentCellOwner

    local function refreshOneClick(tag)
        doActionFun("WW_FLUSH_SINGLESCIENC", {tag}, callback)
    end
    WWExperimentCellOwner["refreshOneClick"] = refreshOneClick

    local function useItemClick(tag)
        doActionFun("WW_USE_SCIENCE", {tag}, callback)
    end
    WWExperimentCellOwner["useItemClick"] = useItemClick

    local function openItemClick(tag)
        doActionFun("WW_OPEN_SCIENCE", {}, callback)
    end
    WWExperimentCellOwner["openItemClick"] = openItemClick

    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(winSize.width, 155 * retina)
        elseif fn == "cellAtIndex" then
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end

            local  proxy = CCBProxy:create()
            local  _cell = tolua.cast(CCBReaderLoad("ccbResources/WWExperimentCell.ccbi",proxy,true,"WWExperimentCellOwner"), "CCLayer")
            
            if worldwardata:bCanOpen() and a1 == #_data then
                -- 开通
                local lock = tolua.cast(WWExperimentCellOwner["lock"], "CCSprite")
                lock:setVisible(true)
                local openItem = tolua.cast(WWExperimentCellOwner["openItem"], "CCMenuItem")
                openItem:setVisible(true)
                local openTet = tolua.cast(WWExperimentCellOwner["openTet"], "CCSprite")
                openTet:setVisible(true)
                local goldIcon = tolua.cast(WWExperimentCellOwner["goldIcon"], "CCSprite")
                goldIcon:setVisible(true)
                local gold = tolua.cast(WWExperimentCellOwner["gold"], "CCLabelTTF")
                gold:setVisible(true)
                local conf = worldwardata:getOpenConf()
                gold:setString(conf.gold)
                openItem:setTag(a1 + 1)
            else
                local itemFrame = tolua.cast(WWExperimentCellOwner["itemFrame"], "CCSprite")
                itemFrame:setVisible(true)
                local dic = _data[a1 + 1]
                if dic.status == 0 then
                    -- 未使用
                    local refreshItem = tolua.cast(WWExperimentCellOwner["refreshItem"], "CCMenuItem")
                    refreshItem:setVisible(true)
                    refreshItem:setTag(a1)
                    local useItem = tolua.cast(WWExperimentCellOwner["useItem"], "CCMenuItem")
                    useItem:setVisible(true)
                    useItem:setTag(a1)
                    local refreshText = tolua.cast(WWExperimentCellOwner["refreshText"], "CCSprite")
                    refreshText:setVisible(true)
                    local useText = tolua.cast(WWExperimentCellOwner["useText"], "CCSprite")
                    useText:setVisible(true)
                    local refreshGoldIcon = tolua.cast(WWExperimentCellOwner["refreshGoldIcon"], "CCSprite")
                    refreshGoldIcon:setVisible(true)
                    local refreshGold = tolua.cast(WWExperimentCellOwner["refreshGold"], "CCLabelTTF")
                    refreshGold:setVisible(true)
                    refreshGold:setString(ConfigureStorage.WWItemUse.Refresh.cost)
                else
                    local useTips = tolua.cast(WWExperimentCellOwner["useTips"], "CCLabelTTF")
                    useTips:setVisible(true)
                end
                local name = tolua.cast(WWExperimentCellOwner["name"], "CCLabelTTF")
                name:setString(dic.name)
                name:setVisible(true)
                local desp = tolua.cast(WWExperimentCellOwner["desp"], "CCLabelTTF")
                desp:setString(dic.desp)
                desp:setVisible(true)
                local itemFrame = tolua.cast(WWExperimentCellOwner["itemFrame"], "CCSprite")
                itemFrame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", dic.rank)))
                local icon = tolua.cast(WWExperimentCellOwner["icon"], "CCSprite")
                local texture = CCTextureCache:sharedTextureCache():addImage(string.format("ccbResources/icons/%s.png", dic.icon))
                if texture then
                    icon:setTexture(texture)
                end
            end

            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            _cell:setScale(retina)
            a2:addChild(_cell, 0, 1)

            r = a2
        elseif fn == "numberOfCells" then
            -- Return number of cells
            if worldwardata:bCanOpen() then
                r = #_data + 1
            else
                r = #_data
            end
        -- Cell events:
        elseif fn == "cellTouched" then
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
        local size = CCSizeMake(winSize.width, (winSize.height - 425 * retina 
            - _mainLayer:getBottomContentSize().height))      -- 这里是为了在tableview上面显示一个小空出来
        _tableView = LuaTableView:createWithHandler(h, size)
        _tableView:setBounceable(true)
        _tableView:setAnchorPoint(ccp(0, 0))
        _tableView:setPosition(ccp(0, _mainLayer:getBottomContentSize().height + 175 * retina))
        _tableView:setVerticalFillOrder(0)
        _layer:addChild(_tableView)
    end
    if offset <= 0 then
        _tableView:setContentOffset(ccp(0, offset))
    end
end

local function refresh()
    local refreshGold = tolua.cast(WWRecruitOwner["refreshGold"], "CCLabelTTF")
    print(ConfigureStorage.WWItemUse.Refresh.cost)
    refreshGold:setString(ConfigureStorage.WWItemUse.Refresh.cost)

    local resetGold = tolua.cast(WWRecruitOwner["resetGold"], "CCLabelTTF")
    local resetCost = ConfigureStorage.WWItemUse.Reset.cost
    local discount = 1
    if worldwardata.yesterdayRank and type(worldwardata.yesterdayRank) == "table" then
        for i=0,2 do
            local dic = worldwardata.yesterdayRank[tostring(i)]
            if dic and dic.countryId == worldwardata.playerData.countryId then
                discount = ConfigureStorage.WWReward[i + 1].Reset or 1
                break
            end
        end
    end
    resetCost = math.floor(resetCost * discount)
    resetGold:setString(resetCost)

    local resetTips = tolua.cast(WWRecruitOwner["resetTips"], "CCLabelTTF")
    resetTips:setString(HLNSLocalizedString("ww.exp.reset.tips", worldwardata:getResetCountLeft()))

    addTableView()

    local itemCount = wareHouseData:getItemCountById("itemcamp_010")

    local resetGoldIcon = tolua.cast(WWRecruitOwner["resetGoldIcon"], "CCSprite")
    local resetGold = tolua.cast(WWRecruitOwner["resetGold"], "CCLabelTTF")
    local expTipsIcon = tolua.cast(WWRecruitOwner["expTipsIcon"], "CCSprite")
    local expTips = tolua.cast(WWRecruitOwner["expTips"], "CCLabelTTF")
    resetGoldIcon:setVisible(itemCount <= 0)
    resetGold:setVisible(itemCount <= 0)
    expTipsIcon:setVisible(itemCount > 0)
    expTips:setVisible(itemCount > 0)

end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/WWRecruitView.ccbi",proxy, true,"WWRecruitOwner")
    _layer = tolua.cast(node,"CCLayer")

    refresh()
end

-- 该方法名字每个文件不要重复
function getWWRecruitLayer()
	return _layer
end

function createWWRecruitLayer()
    _init()
    local function _onEnter()
        addObserver(NOTI_WW_REFRESH, refresh)
    end

    local function _onExit()
        removeObserver(NOTI_WW_REFRESH, refresh)
        _tableView = nil
        _data = nil
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
