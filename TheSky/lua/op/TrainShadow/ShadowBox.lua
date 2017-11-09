local _layer
local shopContent
local _tableView
local shadowArray
local cellArray = {}

-- 名字不要重复
ShadowBoxViewOwner = ShadowBoxViewOwner or {}
ccb["ShadowBoxViewOwner"] = ShadowBoxViewOwner


local function _addTableView()
    -- 得到数据
    shadowArray = shadowData:getAllShadowData( ShadowSortType.SortByOwnerAndRankAndLevel )
    local _topLayer = ShadowBoxViewOwner["titleLayer"]
    
    ShadowBoxTableCellOwner = ShadowBoxTableCellOwner or {}
    ccb["ShadowBoxTableCellOwner"] = ShadowBoxTableCellOwner

    local function onAvatarTaped( tag,sender )
        local item = shadowArray[tonumber(tag)]
        CCDirector:sharedDirector():getRunningScene():addChild(createShadowPopupLayer(item, nil, nil, -132, 1),100)
    end

    ShadowBoxTableCellOwner["onAvatarTaped"] = onAvatarTaped

    local function updateBtnAction( tag,sender )
        local item = shadowArray[tonumber(tag)]
        getMainLayer():gotoShadowUpdateLayer(shadowArray[tonumber(tag)].suid)
    end

    ShadowBoxTableCellOwner["updateBtnAction"] = updateBtnAction
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
            local item = shadowArray[a1 + 1]
            -- PrintTable(item)
            local  proxy = CCBProxy:create()
            local  _hbCell  = tolua.cast(CCBReaderLoad("ccbResources/ShadowBoxTableCell.ccbi",proxy,true,"ShadowBoxTableCellOwner"),"CCLayer")
            
            local updateBtn = tolua.cast(ShadowBoxTableCellOwner["updateBtn"],"CCMenuItemImage")
            updateBtn:setTag(a1 + 1)

            local avatarBtn = tolua.cast(ShadowBoxTableCellOwner["avatarBtn"],"CCMenuItemImage")
            avatarBtn:setTag(a1 + 1)   
               
            local rankLayer = tolua.cast(ShadowBoxTableCellOwner["rankLayer"],"CCLayer")
            if item.conf.icon then
                playCustomFrameAnimation( string.format("yingzi_%s_",item.conf.icon),rankLayer,ccp(rankLayer:getContentSize().width / 2,rankLayer:getContentSize().height / 2),1,4,shadowData:getColorByColorRank( item.conf.rank ) )
            end


            local nameLabel = tolua.cast(ShadowBoxTableCellOwner["nameLabel"],"CCLabelTTF")
            nameLabel:setString(item.conf.name)

            local ownerLabel = tolua.cast(ShadowBoxTableCellOwner["ownerLabel"],"CCLabelTTF")
            if not item.owner then
                ownerLabel:setVisible(false)
            else
                ownerLabel:setString(item.owner.name)
            end
            local levelTTF = tolua.cast(ShadowBoxTableCellOwner["levelTTF"],"CCLabelTTF")
            levelTTF:setString(item.level)
            
            local levelLabel = tolua.cast(ShadowBoxTableCellOwner["levelLabel"],"CCLabelTTF")
            levelLabel:setString("LV:"..item.level)
            
            local attrArray = shadowData:getShadowAttrByLevelAndCid( item.level,item.id )

            local attrLable = tolua.cast(ShadowBoxTableCellOwner["attrLable"],"CCLabelTTF")
            attrLable:setString(attrArray.value)

            local attSprite = tolua.cast(ShadowBoxTableCellOwner["attrIcon"],"CCSprite")
            attSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(equipdata:getDisplayFrameByType(attrArray.type)))

            local rankSprite = tolua.cast(ShadowBoxTableCellOwner["rankSprite"],"CCSprite")
            rankSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("rank_%d_icon.png", item.conf.rank)))

            
            _hbCell:setScale(retina)
            a2:addChild(_hbCell, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            _hbCell:stopAllActions()
            cellArray[tostring(a1)] = _hbCell
            r = a2
        elseif fn == "numberOfCells" then
            -- Return number of cells
            r = getMyTableCount(shadowArray)
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
    local contentBg = ShadowWaveViewOwner["contentBg"]
    local _mainLayer = getMainLayer()
    local x = 1
    if _mainLayer then
        local size = CCSizeMake(winSize.width, (winSize.height - _topLayer:getContentSize().height - _mainLayer:getBottomContentSize().height)*99/100)
        _tableView = LuaTableView:createWithHandler(h, size)
        _tableView:setBounceable(true)
        _tableView:setAnchorPoint(ccp(0,0))
        _tableView:setPosition(0,_mainLayer:getBottomContentSize().height)
        _tableView:setVerticalFillOrder(0)
        _layer:addChild(_tableView,1000)
    end
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/ShadowBoxView.ccbi",proxy, true,"ShadowBoxViewOwner")
    _layer = tolua.cast(node,"CCLayer")
end

local function refresh(  )
    local ffsetY = _tableView:getContentOffset().y
    _tableView:reloadData()
    _tableView:setContentOffset(ccp(0, ffsetY))
end

-- 该方法名字每个文件不要重复
function getShadowBoxLayer()
    return _layer
end

function createShadowBoxLayer()
    _init()


    local function _onEnter()
        cellArray = {}
        _addTableView()
        generateCellAction( cellArray,getMyTableCount(shadowArray) )
        cellArray = {}
    end

    local function _onExit()
        cellArray = {}
        shadowArray = nil
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