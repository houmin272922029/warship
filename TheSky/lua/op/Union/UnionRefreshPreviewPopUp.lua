local _layer
local _priority
local _itemArray
local _tableView

-- 名字不要重复
RefreshPreViewOwner = RefreshPreViewOwner or {}
ccb["RefreshPreViewOwner"] = RefreshPreViewOwner

local function closeItemClick(  )
    _layer:removeFromParentAndCleanup(true) 
end

RefreshPreViewOwner["closeItemClick"] = closeItemClick

local function confirmBtnTaped(  )
    _layer:removeFromParentAndCleanup(true) 
end

local function avatarTaped( tag,sender )
    print(tag) 
end

RefreshPreViewOwner["confirmBtnTaped"] = confirmBtnTaped
local function _addTableView()

    local containLayer = tolua.cast(RefreshPreViewOwner["containLayer"],"CCLayer")
    _itemArray = unionData:getNextRefreshUnionData(  )
    UnionGiftPreviewCellOwner = UnionGiftPreviewCellOwner or {}
    ccb["UnionGiftPreviewCellOwner"] = UnionGiftPreviewCellOwner
    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(600, 120)
        elseif fn == "cellAtIndex" then
            -- Return CCTableViewCell, a1 is cell index (zero based), a2 is dequeued cell (maybe nil)
            -- Do something to create cell  and change the content
            
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            --单条数据
            local item
            local  proxy = CCBProxy:create()
            local _hbCell  = tolua.cast(CCBReaderLoad("ccbResources/UnionGiftPreviewCell.ccbi",proxy,true,"UnionGiftPreviewCellOwner"),"CCLayer")
            local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
            cache:addSpriteFramesWithFile("ccbResources/shadow.plist")
            for i=1,4 do
                if (a1 * 4 + i <= getMyTableCount(_itemArray)) then
                    item = _itemArray[tonumber(a1 * 4 + i)]
                    PrintTable(item)
                    local countLabel = tolua.cast(UnionGiftPreviewCellOwner["countLabel"..i],"CCLabelTTF")
                    countLabel:setString(item.daily)

                    local rankSprite = tolua.cast(UnionGiftPreviewCellOwner["rankFrame"..i],"CCSprite")
                    if item.type == "shadow" then
                        rankSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("s_frame.png"))                       
                        rankSprite:setPosition(ccp(rankSprite:getPositionX() + 3 , rankSprite:getPositionY() - 5))
                    else
                        rankSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", item.conf.rank)))
                    end

                    local shadowContent = tolua.cast(UnionGiftPreviewCellOwner["shadowContent"..i],"CCLayer")

                    if item.type == "shadow" then
                        local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
                        cache:addSpriteFramesWithFile("ccbResources/shadow.plist")
                        if item.conf.icon then
                            playCustomFrameAnimation( string.format("yingzi_%s_",item.conf.icon),shadowContent,ccp(shadowContent:getContentSize().width / 2,shadowContent:getContentSize().height / 2),1,4,shadowData:getColorByColorRank( item.conf.rank ) )
                        end
                    elseif item.type == "soul" then
                        local smallAvatarSprite = tolua.cast(UnionGiftPreviewCellOwner["avatarSprite"..i],"CCSprite")
                        smallAvatarSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("rank_%d_icon.png", item.conf.rank)))
                        if smallAvatarSprite then
                            local headSpr = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(herodata:getHeroHeadByHeroId(item.id))
                            if headSpr then
                                smallAvatarSprite:setVisible(true)
                                smallAvatarSprite:setDisplayFrame(headSpr)
                            end 
                        end
                    else
                        local bigAvatarSprite = tolua.cast(UnionGiftPreviewCellOwner["bigAvatarSprite"..i],"CCSprite")
                        if bigAvatarSprite then
                            local texture
                            if equipdata:getEquipIconByEquipId( item.conf.icon ) then
                                texture = CCTextureCache:sharedTextureCache():addImage(equipdata:getEquipIconByEquipId( item.conf.icon ))
                            end
                            if texture then
                                bigAvatarSprite:setVisible(true)
                                bigAvatarSprite:setTexture(texture)
                                if item.type == "shard" then
                                    local chipIcon = tolua.cast(UnionGiftPreviewCellOwner["chipIcon"..i],"CCSprite")
                                    chipIcon:setVisible(true)
                                end
                            end  
                        end
                    end
                else
                    local rankFrame = tolua.cast(UnionGiftPreviewCellOwner["rankFrame"..i],"CCSprite")
                    rankFrame:setVisible(false)
                end
            end

            a2:addChild(_hbCell, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            r = a2
        elseif fn == "numberOfCells" then
            -- r = getMyTableCount(_itemArray)
            r = math.ceil(getMyTableCount(_itemArray) / 4)
        -- Cell events:
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

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer

    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/UnionGiftRefreshPreviewPopUp.ccbi",proxy, true,"RefreshPreViewOwner")
    _layer = tolua.cast(node,"CCLayer")
    -- _refreshData()
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(RefreshPreViewOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        _layer:removeFromParentAndCleanup(true)
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
    local menu1 = tolua.cast(RefreshPreViewOwner["closeMenu"], "CCMenu")
    menu1:setHandlerPriority(_priority - 1)

    _tableView:setTouchPriority(_priority - 2)
end

-- 该方法名字每个文件不要重复
function getRefreshPreviewLayer()
	return _layer
end

function createRefreshPreviewLayer( priority)
    _priority = (priority ~= nil) and priority or -132
    _init()

    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
        _addTableView()
    end

    local function _onExit()
        _layer = nil
        _priority = -132
        _tableView = nil
    end

    --onEnter onExit
    local function _layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        end
    end


    _layer:registerScriptTouchHandler(onTouch ,false ,_priority ,true )
    _layer:setTouchEnabled(true)
    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end