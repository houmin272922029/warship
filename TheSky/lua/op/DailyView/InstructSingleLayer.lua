local _layer
local _bTableViewTouch
local _instructInfo
local _instructCount
local tableView

InstructSingleOwner = InstructSingleOwner or {}
ccb["InstructSingleOwner"] = InstructSingleOwner


local function addTableView()

    -- @param fn string Callback type
    -- @param table LuaTableView
    -- @param a1 & a2 mixed Difference means for every "fn"
    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(613, 110)
        elseif fn == "cellAtIndex" then
            -- Return CCTableViewCell, a1 is cell index (zero based), a2 is dequeued cell (maybe nil)
            -- Do something to create cell and change the content
            InstructCellOwner = InstructCellOwner or {}
            ccb["InstructCellOwner"] = InstructCellOwner

            local function itemClick(tag)
                local layer = createInstructSelectHeroLayer(_instructInfo[tag].id, -134)
                getMainLayer():addChild(layer, 100)
            end
            InstructCellOwner["itemClick"] = itemClick
            
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end

            local proxy = CCBProxy:create()
            local _hbCell = tolua.cast(CCBReaderLoad("ccbResources/InstructHeroCellView.ccbi",proxy,true,"InstructCellOwner"),"CCLayer")
            for i=1,4 do
                local index = a1 * 4 + i
                if index <= _instructCount then
                    local dic = _instructInfo[index]
                    local conf = herodata:getHeroConfig(dic.heroId)

                    local frame = tolua.cast(InstructCellOwner["frame"..i], "CCMenuItemImage")
                    frame:setVisible(true)

                    frame:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", conf.rank)))
                    frame:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", conf.rank)))
                    frame:setTag(index)

                    local head = tolua.cast(InstructCellOwner["head"..i], "CCSprite")
                    local f = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(herodata:getHeroHeadByHeroId(dic.heroId))
                    if f then
                        head:setVisible(true)
                        head:setDisplayFrame(f)
                        -- renzhan
                        local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
                        cache:addSpriteFramesWithFile("ccbResources/treasureCard.plist")
                        local light = CCSprite:createWithSpriteFrameName("treasureCard_roundFrame_1.png")
                        local animFrames = CCArray:create()
                        for j = 1, 3 do
                            local frameName = string.format("treasureCard_roundFrame_%d.png",j)
                            local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(frameName)
                            animFrames:addObject(frame)
                        end
                        local animation = CCAnimation:createWithSpriteFrames(animFrames, 0.2)
                        local animate = CCAnimate:create(animation)
                        light:runAction(CCRepeatForever:create(animate))
                        head:addChild(light)
                        light:setPosition(ccp(head:getContentSize().width / 2,head:getContentSize().height / 2))
                        -- 
                    end
                end
            end
            a2:addChild(_hbCell, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            r = a2
        elseif fn == "numberOfCells" then
            return _instructCount % 4 == 0 and math.floor(_instructCount / 4) or math.floor(_instructCount / 4) + 1
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
    local contentLayer = InstructSingleOwner["contentLayer"]
    tableView = LuaTableView:createWithHandler(h, contentLayer:getContentSize())
    tableView:setBounceable(true)
    tableView:setAnchorPoint(ccp(0, 0))
    tableView:setPosition(ccp(0, 0))
    tableView:setVerticalFillOrder(0)
    contentLayer:addChild(tableView, 100, 100)
end


-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/InstructHeroSView.ccbi",proxy, true,"InstructSingleOwner")
    _layer = tolua.cast(node,"CCLayer")
end


-- 该方法名字每个文件不要重复
function getInstructSingleLayer()
	return _layer
end

function createInstructSingleLayer()
    _init()

    local function _onEnter()
        _instructInfo = dailyData:getSingleInstructInfo()
        _instructCount = table.getTableCount(_instructInfo)
        print("count", _instructCount)
        _bTableViewTouch = false
        addTableView()
    end

    local function _onExit()
        _layer = nil
        _instructInfo = nil
        _bTableViewTouch = false
        tableView = nil
        --getDailyLayer():refreshDailyLayer()
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