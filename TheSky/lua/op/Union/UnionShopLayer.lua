local _layer
local _tableView
local unionShopData

UnionShopViewLayerOwner = UnionShopViewLayerOwner or {}
ccb["UnionShopViewLayerOwner"] = UnionShopViewLayerOwner

local function onExitTaped(  )
    getUnionMainLayer():gotoShowInner()
end

UnionShopViewLayerOwner["onExitTaped"] = onExitTaped

UnionShopViewLayerOwner["nextRefreshTaped"] = function (  )
    CCDirector:sharedDirector():getRunningScene():addChild(createRefreshPreviewLayer(-133))
end

local function unionBuyActionCallBack( url,rtnData )
    unionData:fromDic(rtnData.info)
    getUnionMainLayer():refreshData()
    unionShopData = unionData:getUnionData(  )
    _tableView:reloadData()
end

local function _addTableView()

    unionShopData = unionData:getUnionData(  )
    local _topLayer = UnionShopViewLayerOwner["BSTopLayer"]
    local _titleLayer = UnionShopViewLayerOwner["titleBg"]
 
    UnionShopTableViewCellOwner = UnionShopTableViewCellOwner or {}
    ccb["UnionShopTableViewCellOwner"] = UnionShopTableViewCellOwner

    UnionShopTableViewCellOwner["onBuyBtnTaped"] = function ( tag,sender )
        local item = unionShopData[tag]
        if not unionData:getOneItemCanBuy( tag ) then
            ShowText(HLNSLocalizedString("超过最大购买次数"))
            return
        end
        local needLevel = unionData:getNeedLevelByIndex( tag )
        if needLevel > unionData:getShopLevel(  ) then
            ShowText(HLNSLocalizedString("需要商城达到%s级才可以购买",needLevel))
            return
        end
        doActionFun("UNION_BUY_ACTION",{item.level},unionBuyActionCallBack)
    end

    UnionShopTableViewCellOwner["onAvatarTaped"] = function ( tag,sender )
        
    end

    local function updateLabel( labelName,string )
        local label = tolua.cast(UnionShopTableViewCellOwner[labelName],"CCLabelTTF")
        label:setVisible(true)
        label:setString(string)
    end

    -- unionMemberCellOwner["onCellBgClicked"] = onCellBgClicked
    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
                r = CCSizeMake(winSize.width, 190 * retina)
        elseif fn == "cellAtIndex" then
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            local item = unionShopData[a1 + 1]
            PrintTable(item)
            local  proxy = CCBProxy:create()
            local _hbCell = tolua.cast(CCBReaderLoad("ccbResources/UnionShopTableViewCell.ccbi",proxy,true,"UnionShopTableViewCellOwner"),"CCLayer")

            local buyBtn = tolua.cast(UnionShopTableViewCellOwner["buyBtn"], "CCMenuItemImage")
            local shadowContent = tolua.cast(UnionShopTableViewCellOwner["shadowContent"],"CCLayer")
            if not unionData:getOneItemCanBuy( a1 + 1 ) then
                buyBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn2_2.png"))
                buyBtn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn2_2.png"))
            end
            buyBtn:setTag(a1 + 1)
            updateLabel( "nameLabel",item.conf.name)
            updateLabel( "countLabel",item.daily)
            updateLabel( "costLabel",item.cost)
            updateLabel( "buyCount",unionData:getOneItemCanBuyTime( a1 + 1 )) 
            if item.type == "shadow" then
                local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
                cache:addSpriteFramesWithFile("ccbResources/shadow.plist")
                if item.conf.icon then
                    playCustomFrameAnimation( string.format("yingzi_%s_",item.conf.icon),shadowContent,ccp(shadowContent:getContentSize().width / 2,shadowContent:getContentSize().height / 2),1,4,shadowData:getColorByColorRank( item.conf.rank ) )
                end
            elseif item.type == "soul" then
                local smallAvatarSprite = tolua.cast(UnionShopTableViewCellOwner["smallAvatarSprite"],"CCSprite")
                smallAvatarSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("rank_%d_icon.png", item.conf.rank)))
                if smallAvatarSprite then
                    local headSpr = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(herodata:getHeroHeadByHeroId(item.id))
                    if headSpr then
                        smallAvatarSprite:setVisible(true)
                        smallAvatarSprite:setDisplayFrame(headSpr)
                    end 
                end
            else
                local bigAvatarSprite = tolua.cast(UnionShopTableViewCellOwner["bigAvatarSprite"],"CCSprite")
                if bigAvatarSprite then
                    local texture
                    if equipdata:getEquipIconByEquipId( item.conf.icon ) then
                        texture = CCTextureCache:sharedTextureCache():addImage(equipdata:getEquipIconByEquipId( item.conf.icon ))
                    end
                    if texture then
                        bigAvatarSprite:setVisible(true)
                        bigAvatarSprite:setTexture(texture)
                        if item.type == "shard" then
                            local chipIcon = tolua.cast(UnionShopTableViewCellOwner["chipIcon"],"CCSprite")
                            chipIcon:setVisible(true)
                        end
                    end  
                end
            end

            local rankSprite = tolua.cast(UnionShopTableViewCellOwner["rankSprite"],"CCSprite")
            rankSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("rank_%d_icon.png", item.conf.rank)))

            local avatarBtn = tolua.cast(UnionShopTableViewCellOwner["avatarBtn"],"CCMenuItemImage")
            if item.type == "shadow" then
                avatarBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("s_frame.png"))
                avatarBtn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("s_frame.png"))
                avatarBtn:setPosition(ccp(avatarBtn:getPositionX() + 3 , avatarBtn:getPositionY() - 5))
            else
                avatarBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", item.conf.rank)))
                avatarBtn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", item.conf.rank)))
            end
    
            local condition2Label = tolua.cast(UnionShopTableViewCellOwner["condition2Label"],"CCLabelTTF")
            local needLevel = unionData:getNeedLevelByIndex( a1 + 1 )
            if needLevel <= unionData:getShopLevel(  ) then
                condition2Label:setVisible(false)
            else
                condition2Label:setVisible(true)
                condition2Label:setString(HLNSLocalizedString("shopNeedLv.string",needLevel))
                buyBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn2_2.png"))
                buyBtn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn2_2.png"))
            end

            _hbCell:setScale(retina)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            a2:addChild(_hbCell, 0, 1)
            r = a2
        elseif fn == "numberOfCells" then
            -- Return number of cells
            r = getMyTableCount(unionShopData)
            -- r = 5
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
    local _mainLayer = getMainLayer()
    if _mainLayer then
        -- 创建tableview
        local size = CCSizeMake(winSize.width, (winSize.height - _topLayer:getContentSize().height - _mainLayer:getBottomContentSize().height) - _titleLayer:getContentSize().height * retina)
        print(size.width.." "..size.height)
        _tableView = LuaTableView:createWithHandler(h, size)
        _tableView:setBounceable(true)
        _tableView:setAnchorPoint(ccp(0,0))
        _tableView:setPosition(ccp(0, _mainLayer:getBottomContentSize().height))
        _tableView:setVerticalFillOrder(0)
        _layer:addChild(_tableView) 
    end
end
local function refreshPage(  )
    unionShopData = unionData:getUnionData(  )
    _tableView:reloadData()
end

local function getUnionShopDataCallBack( url,rtnData )
    unionData.shopData = rtnData.info.league.shop
    refreshPage()
end

local function getUnionShopData(  )
    doActionFun("GET_UNION_SHOPDATA",{},getUnionShopDataCallBack)
end

local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/unionShopViewLayer.ccbi",proxy, true,"UnionShopViewLayerOwner")
    _layer = tolua.cast(node,"CCLayer")
    local shopLevelTTF = tolua.cast(UnionShopViewLayerOwner["shopLevelTTF"],"CCLabelTTF")
    shopLevelTTF:setString(HLNSLocalizedString("商城等级:%s",unionData:getShopLevel()))
end

local function setMenuPriority()
    local menu1 = tolua.cast(UnionShopViewLayerOwner["backUinonMenu"], "CCMenu")
    menu1:setHandlerPriority(-130)
    local menu1 = tolua.cast(UnionShopViewLayerOwner["refreshMenu"], "CCMenu")
    menu1:setHandlerPriority(-130)
end

function getUnionShopLayer()
	return _layer
end

function createUnionShopLayer( )

    _init()


    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
        _addTableView()
        getUnionShopData()
    end

    local function _onExit()
        _layer = nil
        _tableView = nil
        -- unionData.shopData = {}
        unionShopData = nil
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