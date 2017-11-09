local _layer
local _priority = -132
local _tableView 
local allData
local _selectId

-- 名字不要重复
BluckSingSelectOwner = BluckSingSelectOwner or {}
ccb["BluckSingSelectOwner"] = BluckSingSelectOwner

local function closeItemClick()

    popUpCloseAction( BluckSingSelectOwner,"infoBg",_layer )
    -- _layer:removeFromParentAndCleanup(true)
end
BluckSingSelectOwner["closeItemClick"] = closeItemClick

local function onConfirmTaped()
    runtimeCache.singSelectHeroId = _selectId
    getBluckSingLayer():refresh(  )
    _layer:removeFromParentAndCleanup(true)
end
BluckSingSelectOwner["onConfirmTaped"] = onConfirmTaped

local function onExitTaped()
    _layer:removeFromParentAndCleanup(true)
end
BluckSingSelectOwner["onExitTaped"] = onExitTaped

local function _addTableView()
    -- 得到数据
    local contentLayer = BluckSingSelectOwner["contentLayer"]

    allData = herodata:getHeroUIdArrByThanRank( 4 )
    if getMyTableCount(allData) <= 0 then
        local function cardConfirmAction(  )
            if getMainLayer() then
                _layer:removeFromParentAndCleanup(true)
                getMainLayer():goToLogue()
                getLogueTownLayer():gotoPageByType( 0 )
            end
        end
        local function cardCancelAction(  )
            
        end
        getMainLayer():addChild(createSimpleConfirCardLayer(HLNSLocalizedString("bluck_sing.notenoughheros")))
        SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
        SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction
    end
    SingHeroSelectCellOwner = SingHeroSelectCellOwner or {}
    ccb["SingHeroSelectCellOwner"] = SingHeroSelectCellOwner

    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(600, 170)
        elseif fn == "cellAtIndex" then
            -- Return CCTableViewCell, a1 is cell index (zero based), a2 is dequeued cell (maybe nil)
            -- Do something to create cell  and change the content
            
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            --单条数据
            local heroUid = allData[tonumber(a1 + 1)]
            local hero = herodata:getHeroInfoByHeroUId( heroUid ) 
            local heroConfig = herodata:getHeroConfig(hero.heroId)

            local  proxy = CCBProxy:create()
            local  _hbCell = tolua.cast(CCBReaderLoad("ccbResources/SingHeroSelectCell.ccbi",proxy,true,"SingHeroSelectCellOwner"),"CCLayer")

            local cellBg = tolua.cast(SingHeroSelectCellOwner["cellBg"],"CCSprite")
            local stampSprite = tolua.cast(SingHeroSelectCellOwner["stampSprite"],"CCSprite")

            if _selectId and _selectId == heroUid then
                stampSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("stamp3.png"))
                cellBg:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("popUpFrame_11.png"))
            else
                stampSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("stamp2.png"))
                cellBg:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("popupFrame_3.png"))
            end
            local nameLabel = tolua.cast(SingHeroSelectCellOwner["nameLabel"],"CCLabelTTF")
            nameLabel:setString(hero.name)

            local ownerLabel = tolua.cast(SingHeroSelectCellOwner["ownerLabel"],"CCLabelTTF")
            if herodata:bHeroOnForm(heroUid) then
                ownerLabel:setVisible(true)
            else
                ownerLabel:setVisible(false)
            end 
            local canSingLabel = tolua.cast(SingHeroSelectCellOwner["canSingLabel"],"CCLabelTTF")
            if dailyData:getWishHeroIDbyId( heroConfig.heroId ) then
                canSingLabel:setVisible(false)
            else
                canSingLabel:setVisible(true)
            end
            local levelLabel = tolua.cast(SingHeroSelectCellOwner["levelLabel"],"CCLabelTTF")
            levelLabel:setString(string.format("LV:%s",hero.level))

            local rankFrame = tolua.cast(SingHeroSelectCellOwner["rankFrame"],"CCSprite")
            rankFrame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", hero.rank)))
            
            local avatarSprite = tolua.cast(SingHeroSelectCellOwner["avatarSprite"],"CCSprite")
            local headSpr = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(herodata:getHeroHeadByHeroId(hero.heroId))
            if headSpr then
                avatarSprite:setVisible(true)
                avatarSprite:setDisplayFrame(headSpr)
            end 

            local rankSprite = tolua.cast(SingHeroSelectCellOwner["rankSprite"],"CCSprite")
            rankSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("rank_%d_icon.png", hero.rank)))

            -- _hbCell:setScale(retina)
            a2:addChild(_hbCell, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            r = a2
        elseif fn == "numberOfCells" then
            -- Return number of cells
            -- r = 5
            r = getMyTableCount(allData)
        -- Cell events:
        elseif fn == "cellTouched" then         -- A cell was touched, a1 is cell that be touched. This is not necessary.
            local heroUid = allData[tonumber(a1:getIdx() + 1)]
            local hero = herodata:getHeroInfoByHeroUId( heroUid ) 
            if not dailyData:getWishHeroIDbyId( hero.confId ) then
                ShowText(HLNSLocalizedString("该英雄无法吟唱"))
            else
                _selectId = heroUid
                local offsetY = _tableView:getContentOffset().y
                _tableView:reloadData()
                _tableView:setContentOffset(ccp(0, offsetY))
            end
        elseif fn == "cellTouchBegan" then      -- A cell is touching, a1 is cell, a2 is CCTouch
        elseif fn == "cellTouchEnded" then      -- A cell was touched, a1 is cell, a2 is CCTouch
        elseif fn == "cellHighlight" then       -- A cell is highlighting, coco2d-x 2.1.3 or above
        elseif fn == "cellUnhighlight" then     -- A cell had been unhighlighted, coco2d-x 2.1.3 or above
        elseif fn == "cellWillRecycle" then     -- A cell will be recycled, coco2d-x 2.1.3 or above
        end
        return r
    end)
    local _mainLayer = getMainLayer()
    local x = 1
    if _mainLayer then
        local size = CCSizeMake(contentLayer:getContentSize().width, contentLayer:getContentSize().height) 
        _tableView = LuaTableView:createWithHandler(h, size)
        _tableView:setBounceable(true)
        _tableView:setAnchorPoint(ccp(0,0))
        _tableView:setPosition(0,0)
        _tableView:setVerticalFillOrder(0)
        contentLayer:addChild(_tableView)
    end
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/SingFriendChoseView.ccbi", proxy, true,"BluckSingSelectOwner")
    _layer = tolua.cast(node,"CCLayer")
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(BluckSingSelectOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        -- _layer:removeFromParentAndCleanup(true)
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
    local menu1 = tolua.cast(BluckSingSelectOwner["menu"], "CCMenu")
    menu1:setHandlerPriority(_priority-1)
    _tableView:setTouchPriority(_priority - 2)
end

-- 该方法名字每个文件不要重复
function getSingHeroSelectLayer()
	return _layer
end

function createSingHeroSelectLayer(priority)
    _priority = (priority ~= nil) and priority or -132
    _init()

    

    local function _onEnter()
        print("onEnter")
        _selectId = runtimeCache.singSelectHeroId
        _addTableView()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
        
        popUpUiAction( BluckSingSelectOwner,"infoBg" )
    end

    local function _onExit()
        print("onExit")
        _layer = nil
        _priority = nil
        _tableView = nil
        allData = nil
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