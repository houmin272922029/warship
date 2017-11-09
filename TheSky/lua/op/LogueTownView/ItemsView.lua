local _layer
local shopContent
local _tableView
local cellArray = {}

-- 名字不要重复
ItemsViewOwner = ItemsViewOwner or {}
ccb["ItemsViewOwner"] = ItemsViewOwner

local function buyCallBack( url,rtnData )
    if rtnData["code"] == 200 then
        local ffsetY = _tableView:getContentOffset().y
        _tableView:reloadData()
        _tableView:setContentOffset(ccp(0, ffsetY))
    end
end

local function buyBtnTaped( tag,sender )
    local item = shopContent[tonumber(tag - 99)]
    local itemId = item.item.id
    if itemId == "keybag_004" then--沉船宝箱
        Global:instance():TDGAonEventAndEventData("prop1")
    elseif itemId == "keybag_003" then
        Global:instance():TDGAonEventAndEventData("prop3")
    elseif itemId == "keybag_002" then
        Global:instance():TDGAonEventAndEventData("prop5")
    elseif itemId == "keybag_001" then
        Global:instance():TDGAonEventAndEventData("prop6")
    elseif itemId == "bagkey_003" then
        Global:instance():TDGAonEventAndEventData("prop4")
    elseif itemId == "bagkey_004" then
        Global:instance():TDGAonEventAndEventData("prop2")
    elseif itemId == "item_009" then
        Global:instance():TDGAonEventAndEventData("prop7")
    elseif itemId == "item_008" then
        Global:instance():TDGAonEventAndEventData("prop8")
    elseif itemId == "item_005" then
        Global:instance():TDGAonEventAndEventData("prop9")
    elseif itemId == "item_004" then
        Global:instance():TDGAonEventAndEventData("prop10")
    elseif itemId == "item_003" then
        Global:instance():TDGAonEventAndEventData("prop11")
    elseif itemId == "item_007" then
        Global:instance():TDGAonEventAndEventData("prop12")
    end
    local shopType = "goldShop"
    if getMainLayer() then
        getMainLayer():addChild(createShopBuySomeLayer(itemId))
    end
end

local function _addTableView()
    -- 得到数据
    shopContent = shopData:getItemShopData()
    local _topLayer = ItemsViewOwner["titleLayer"]
    
    ItemTableCellOwner = ItemTableCellOwner or {}
    ccb["ItemTableCellOwner"] = ItemTableCellOwner

    local function onAvatarTaped( tag,sender )
        getMainLayer():addChild(createLogueItemDetailInfoLayer(shopContent[tonumber(tag)].item.id, -135))
    end

    ItemTableCellOwner["onAvatarTaped"] = onAvatarTaped

    ItemTableCellOwner["buyBtnTaped"] = buyBtnTaped
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
            local item = shopContent[a1 + 1]
            local  proxy = CCBProxy:create()
            local  _hbCell  = tolua.cast(CCBReaderLoad("ccbResources/ItemTableCell.ccbi",proxy,true,"ItemTableCellOwner"),"CCLayer")
            local btn = tolua.cast(ItemTableCellOwner["buyBtn"],"CCMenuItemImage")
            btn:setTag(a1 + 100)

            local frameBtn = tolua.cast(ItemTableCellOwner["frameBtn"],"CCMenuItemImage")
            frameBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", item.item.rank)))
            frameBtn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", item.item.rank)))
            frameBtn:setTag(a1 + 1)   
               
            local avatarSprite = tolua.cast(ItemTableCellOwner["avatarSprite"],"CCSprite")
            if avatarSprite then
                local texture = CCTextureCache:sharedTextureCache():addImage(equipdata:getEquipIconByEquipId( item.item.id))
                if texture then
                    avatarSprite:setVisible(true)
                    avatarSprite:setTexture(texture)
                    if item.item.rank == 4 then
                        HLAddParticleScale( "images/purpleEquip.plist", avatarSprite, ccp(avatarSprite:getContentSize().width / 2,avatarSprite:getContentSize().height / 2), 1, 100, 777, 2 / 0.35 / retina, 2 / 0.35 / retina, 1 )
                    end
                end
            end

            local nameLabel = tolua.cast(ItemTableCellOwner["nameLabel"],"CCLabelTTF")
            nameLabel:setString(item.item.name)
            local countSprite = tolua.cast(ItemTableCellOwner["countSprite"],"CCSprite")
            local countLabel = tolua.cast(ItemTableCellOwner["countLabel"],"CCLabelTTF")
            local count = wareHouseData:getItemCountById( item.item.id )
            if tonumber(count) > 0 then
                countLabel:setVisible(true)
                countSprite:setVisible(true)
                countLabel:setString(count)
            else
                countLabel:setVisible(false)
                countSprite:setVisible(false)
            end

            local despLabel = tolua.cast(ItemTableCellOwner["despLabel"],"CCLabelTTF")
            despLabel:setString(item.item.desp)

            local priceLabel = tolua.cast(ItemTableCellOwner["priceLabel"],"CCLabelTTF")
            priceLabel:setString(item.price)

            
            _hbCell:setScale(retina)
            a2:addChild(_hbCell, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            _hbCell:stopAllActions()
            cellArray[tostring(a1)] = _hbCell
            r = a2
        elseif fn == "numberOfCells" then
            -- Return number of cells
            -- r = table.getTableCount(shopContent)
            r = getMyTableCount(shopContent)
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
    local contentBg = ItemsViewOwner["contentBg"]
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
    local  node  = CCBReaderLoad("ccbResources/ItemsView.ccbi",proxy, true,"ItemsViewOwner")
    _layer = tolua.cast(node,"CCLayer")
end

local function refresh(  )
    local ffsetY = _tableView:getContentOffset().y
    _tableView:reloadData()
    _tableView:setContentOffset(ccp(0, ffsetY))
end

-- 该方法名字每个文件不要重复
function getItemsViewLayer()
	return _layer
end

function createItemsViewLayer()
    _init()

	-- public方法写在每个layer的创建的方法内 调用时方法
	-- local layer = getLayer()
	-- layer:refresh()

	function _layer:refresh()
        shopContent = shopData:getItemShopData()
		local ffsetY = _tableView:getContentOffset().y
        _tableView:reloadData()
        _tableView:setContentOffset(ccp(0, ffsetY))
	end

    local function _onEnter()
        print("onEnter")
        cellArray = {}
        _addTableView()
        generateCellAction( cellArray,getMyTableCount(shopContent) )
        cellArray = {}
        addObserver(NOTI_SHOP_BUY_SUCCESS, refresh)
    end

    local function _onExit()
        print("onExit")
        _layer = nil
        shopContent = nil
        _tableView = nil
        cellArray = {}
        removeObserver(NOTI_SHOP_BUY_SUCCESS, refresh)
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