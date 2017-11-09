local _layer
local shopContent
local _tableView
local shadowArray = {}
local cellArray = {}

-- 名字不要重复
ShadowWaveViewOwner = ShadowWaveViewOwner or {}
ccb["ShadowWaveViewOwner"] = ShadowWaveViewOwner

local function refreshContent(  )
    local breakShadowCount = tolua.cast(ShadowWaveViewOwner["breakShadowCount"],"CCLabelTTF")
    breakShadowCount:setString(shadowData:getShadowCoin())
end

local function shadowBuyCallBack( url,rtnData )
    if rtnData.code == 200 then
        shadowData.shadowData = rtnData.info.shadowData
        -- postNotification(NOTI_REFRESH_COIN, nil)
        refreshContent()
    end
end

local function _addTableView()
    -- 得到数据
    shadowArray = shadowData:getWaveConfigData()

    local _topLayer = ShadowWaveViewOwner["titleLayer"]
    local topTitleLayer = ShadowWaveViewOwner["topTitleLayer"]
    
    ShadowWaveTableCell = ShadowWaveTableCell or {}
    ccb["ShadowWaveTableCell"] = ShadowWaveTableCell

    local function onAvatarTaped( tag,sender )
        local item = shadowArray[tonumber(tag)]
        CCDirector:sharedDirector():getRunningScene():addChild(createShadowPopupLayer(item, nil, nil, -132, 1),100)
    end

    ShadowWaveTableCell["onAvatarTaped"] = onAvatarTaped

    local function chargeBtnTaped( tag,sender )
        local item = shadowArray[tonumber(tag)]
        if item.conf.coin <= shadowData:getShadowCoin() then
            doActionFun("SHADOW_BUY_URL",{ item.id },shadowBuyCallBack)
        else
            ShowText(HLNSLocalizedString("ERR_1802"))
        end
    end

    ShadowWaveTableCell["chargeBtnTaped"] = chargeBtnTaped
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
            local  _hbCell  = tolua.cast(CCBReaderLoad("ccbResources/ShadowWaveTableCell.ccbi",proxy,true,"ShadowWaveTableCell"),"CCLayer")

            local chargeBtn = tolua.cast(ShadowWaveTableCell["chargeBtn"],"CCMenuItemImage")

            chargeBtn:setTag(a1 + 1)

            local frameBtn = tolua.cast(ShadowWaveTableCell["frameBtn"],"CCMenuItemImage")
            frameBtn:setTag(a1 + 1)

            local rankLayer = tolua.cast(ShadowWaveTableCell["rankSprite"],"CCLayer")
            if item.conf.icon then
                playCustomFrameAnimation( string.format("yingzi_%s_",item.conf.icon),rankLayer,ccp(rankLayer:getContentSize().width / 2,rankLayer:getContentSize().height / 2),1,4,shadowData:getColorByColorRank( item.conf.rank ) )
            end

            local nameLabel = tolua.cast(ShadowWaveTableCell["nameLabel"],"CCLabelTTF")
            if item.conf.name then
                nameLabel:setString(item.conf.name)
            end

            local rankIcon = tolua.cast(ShadowWaveTableCell["rankIcon"],"CCSprite")
            rankIcon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("rank_%d_icon.png", item.conf.rank)))
            local attrArray = shadowData:getShadowAttrByLevelAndCid( 1,item.id )

            local attrLabel = tolua.cast(ShadowWaveTableCell["attrLabel"],"CCLabelTTF")
            attrLabel:setString(attrArray.value)

            local attSprite = tolua.cast(ShadowWaveTableCell["attrIcon"],"CCSprite")
            attSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(equipdata:getDisplayFrameByType(attrArray.type)))

            local priceLabel = tolua.cast(ShadowWaveTableCell["priceLabel"],"CCLabelTTF")
            if item.conf.coin then
                priceLabel:setString(item.conf.coin)
            end

            
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
        local size = CCSizeMake(winSize.width, (winSize.height - topTitleLayer:getContentSize().height * retina - _topLayer:getContentSize().height - _mainLayer:getBottomContentSize().height)*99/100)
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
    local  node  = CCBReaderLoad("ccbResources/ShadowWaveView.ccbi",proxy, true,"ShadowWaveViewOwner")
    _layer = tolua.cast(node,"CCLayer")
end

-- 该方法名字每个文件不要重复
function getShadowWaveLayer()
	return _layer
end

function createShadowWaveLayer()
    _init()


    local function _onEnter()
        cellArray = {}
        _addTableView()
        refreshContent()
        generateCellAction( cellArray,getMyTableCount(shadowArray) )
        cellArray = {}
        addObserver(NOTI_REFRESH_COIN, refreshContent)
    end

    local function _onExit()
        removeObserver(NOTI_REFRESH_COIN, refreshContent)
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