local _layer
local contentData
local _tableView
local _bTableViewTouch

LevelUpAwaraOwner = LevelUpAwaraOwner or {}
ccb["LevelUpAwaraOwner"] = LevelUpAwaraOwner


local function _addTableView()
    -- 得到数据
    contentData = dailyData:getUpdateAwardData()
    local contentLayer = LevelUpAwaraOwner["contentLayer"]

    LevelUpdateAwardCellOwner = LevelUpdateAwardCellOwner or {}
    ccb["LevelUpdateAwardCellOwner"] = LevelUpdateAwardCellOwner  

    LevelUpdateAwardTopDespCellOwner = LevelUpdateAwardTopDespCellOwner or {}
    ccb["LevelUpdateAwardTopDespCellOwner"] = LevelUpdateAwardTopDespCellOwner

    local function getUpdateAwardCallBack( url,rtnData )
        if rtnData.code == 200 then
            dailyData:updateLevelUpAwardData(rtnData.info.list)
            postNotification(NOTI_DAILY_STATUS, nil)
            contentData = dailyData:getUpdateAwardData()
            _tableView:reloadData()
        end
    end

    local function onGetBtnTaped( tag,sender )
        local oneContent = contentData[tostring(tag)]
        if oneContent["isCondition"] == 0 then
            ShowText(string.format(HLNSLocalizedString("level.update.reward") ,oneContent.leve))
        else
            local level = 0
            if oneContent.leve == 3 then
                level = 1
            elseif oneContent.leve == 5 then
                level = 2
            elseif oneContent.leve == 10 then
                level = 3
            elseif oneContent.leve == 15 then
                level = 4
            elseif oneContent.leve == 7 then
                level = 5
            end
            Global:instance():TDGAonEventAndEventData("get"..level)
            doActionFun("UPDATE_LEVEL_AWARD",{ tostring(tag) }, getUpdateAwardCallBack)
        end
    end 

    LevelUpdateAwardCellOwner["onGetBtnTaped"] = onGetBtnTaped
    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            if a1 == 0 then
                r = CCSizeMake(contentLayer:getContentSize().width, 100 * retina)
            else
                r = CCSizeMake(contentLayer:getContentSize().width, 140 * retina)
            end
        elseif fn == "cellAtIndex" then
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            --单条数据

            local  _hbCell
            local  proxy = CCBProxy:create()
            if a1 == 0 then
                _hbCell = tolua.cast(CCBReaderLoad("ccbResources/LevelUpdateAwardTopDespCell.ccbi",proxy,true,"LevelUpdateAwardTopDespCellOwner"),"CCLayer")
            else
                local itemContent = contentData[tostring(a1 - 1)]
                _hbCell = tolua.cast(CCBReaderLoad("ccbResources/LevelUpdateAwardCell.ccbi",proxy,true,"LevelUpdateAwardCellOwner"),"CCLayer")
                local label1 = tolua.cast(LevelUpdateAwardCellOwner["label1"],"CCLabelTTF")
                local label2 = tolua.cast(LevelUpdateAwardCellOwner["label2"],"CCLabelTTF")
                local label3 = tolua.cast(LevelUpdateAwardCellOwner["label3"],"CCLabelTTF")
                local label4 = tolua.cast(LevelUpdateAwardCellOwner["label4"],"CCLabelTTF")
                local goldIcon1 = tolua.cast(LevelUpdateAwardCellOwner["goldIcon1"],"CCSprite")
                local goldIcon2 = tolua.cast(LevelUpdateAwardCellOwner["goldIcon2"],"CCSprite")
                local vipIcon = tolua.cast(LevelUpdateAwardCellOwner["vipIcon"],"CCSprite")
                local selectIcon1 = tolua.cast(LevelUpdateAwardCellOwner["selectIcon1"],"CCSprite")
                local selectIcon2 = tolua.cast(LevelUpdateAwardCellOwner["selectIcon2"],"CCSprite")
                local getSprite = tolua.cast(LevelUpdateAwardCellOwner["getSprite"],"CCSprite")
                local btn = tolua.cast(LevelUpdateAwardCellOwner["btn"],"CCMenuItemImage")

                btn:setTag(a1 - 1)
                
                label1:setString(HLNSLocalizedString("升级到 %s 级,送",itemContent["leve"]))

                if itemContent["VIP"] then
                    -- vipIcon:setVisible(true)
                    -- selectIcon1:setVisible(true)
                    -- vipIcon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("VIP_%d.png", itemContent["VIP"])))
                    -- if itemContent["gold"] then
                    --     selectIcon2:setVisible(true)
                    --     goldIcon2:setVisible(true)
                    --     label3:setVisible(true)
                    --     label3:setString(itemContent["gold"])
                    -- end
                    -- renzhan
                    vipIcon:setVisible(true)
                    selectIcon2:setVisible(true)
                    vipIcon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("VIP_%d.png", itemContent["VIP"])))
                    if itemContent["gold"] then
                        selectIcon1:setVisible(true)
                        goldIcon1:setVisible(true)
                        label2:setVisible(true)
                        label2:setString(itemContent["gold"])
                    end
                else
                    if itemContent["gold"] then
                        selectIcon1:setVisible(true)
                        goldIcon1:setVisible(true)
                        label2:setVisible(true)
                        label2:setString(itemContent["gold"])
                    end
                end

                if itemContent["isCondition"] == 0 then
                    btn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn3_1.png"))
                    btn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn3_1.png"))
                else
                    btn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn3_0.png"))
                    btn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn3_1.png"))
                end

                if itemContent["isGet"] == 0 then
                    btn:setVisible(true)
                    getSprite:setVisible(true)
                    label4:setVisible(false)
                else
                    btn:setVisible(false)
                    label4:setVisible(true)
                    getSprite:setVisible(false)
                    label4:setString(HLNSLocalizedString("已领取"))
                end
            end
            _hbCell:setAnchorPoint(ccp(0,0))
            _hbCell:setPosition(ccp(0,0))
            _hbCell:setScale(retina)
            a2:addChild(_hbCell, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            r = a2
        elseif fn == "numberOfCells" then
            if contentData.shouldShine then
                r = getMyTableCount(contentData)-1
            else
                r = getMyTableCount(contentData)
            end
        -- Cell events:
        elseif fn == "cellTouched" then         -- A cell was touched, a1 is cell that be touched. This is not necessary.
            
        elseif fn == "cellTouchBegan" then      -- A cell is touching, a1 is cell, a2 is CCTouch
            getDailyLayer():pageViewTouchEnabled(true)
            _bTableViewTouch = true
        elseif fn == "cellTouchEnded" then      -- A cell was touched, a1 is cell, a2 is CCTouch
            if _bTableViewTouch then
                getDailyLayer():pageViewTouchEnabled(true)
                _bTableViewTouch = false
            end
        elseif fn == "cellHighlight" then       -- A cell is highlighting, coco2d-x 2.1.3 or above
        elseif fn == "cellUnhighlight" then     -- A cell had been unhighlighted, coco2d-x 2.1.3 or above
        elseif fn == "cellWillRecycle" then     -- A cell will be recycled, coco2d-x 2.1.3 or above
        elseif fn == "scroll" then
            if _bTableViewTouch then
                getDailyLayer():pageViewTouchEnabled(false)
            end
        end
        return r
    end)
    local size = CCSizeMake(contentLayer:getContentSize().width, contentLayer:getContentSize().height)  -- 这里是为了在tableview上面显示一个小空出来
    _tableView = LuaTableView:createWithHandler(h, size)
    _tableView:setBounceable(true)
    _tableView:setAnchorPoint(ccp(0,0))
    _tableView:setPosition(ccp(0,0))
    _tableView:setVerticalFillOrder(0)
    contentLayer:addChild(_tableView,1000)
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/DailyLevelUpAward.ccbi",proxy, true,"LevelUpAwaraOwner")
    _layer = tolua.cast(node,"CCLayer")
end

-- 该方法名字每个文件不要重复
function getUpgrateAwardLayer()
	return _layer
end

function createUpgrateAwardLayer()
    _init()

    local function _onEnter()
        _addTableView()
    end

    local function _onExit()
        _layer = nil
        contentData = nil
        _tableView = nil
        _bTableViewTouch = false
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