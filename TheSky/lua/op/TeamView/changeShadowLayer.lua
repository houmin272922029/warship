local _layer
local _offShadow
local _selected = -1
local _tableView
local _pos
local _heroId
local cellArray = {}

-- 名字不要重复
ShadowChangeOwner = ShadowChangeOwner or {}
ccb["ShadowChangeOwner"] = ShadowChangeOwner

ShadowChangeCellOwner = ShadowChangeCellOwner or {}
ccb["ShadowChangeCellOwner"] = ShadowChangeCellOwner

local function onFormCallback(url, rtnData)
    for k,v in pairs(rtnData.info) do
        herodata:addHeroByDic( v )
    end
    getMainLayer():gotoTeam()
end


local function confirmBtnClicked()
    print("confirmBtnClicked",_selected)
    if _selected == -1 then
        getMainLayer():gotoTeam()
    else
        local shadowId = _offShadow[_selected + 1].suid
        print(_heroId,_pos,shadowId)
        doActionFun("SHADOW_CHANGE", {_heroId, _pos, shadowId}, onFormCallback)
    end
end
ShadowChangeOwner["confirmBtnClicked"] = confirmBtnClicked

local function _addTableView()
    -- local function onHeadIconClicked(tag)
    --     print("OnFormCellOwner onHeadIconClicked")
    --     PrintTable(_offShadow)
    --     local heroUid = _offShadow[tag + 1]
    --     if heroUid then
    --         -- 显示英雄信息
    --         getMainLayer():addChild(createHeroInfoLayer(heroUid, HeroDetail_Clicked_SelectHero, -135))
    --     end 
    -- end
    -- OnFormCellOwner["onHeadIconClicked"] = onHeadIconClicked
    
    local _topLayer = ShadowChangeOwner["TopLayer"]
    -- @param fn string Callback type
    -- @param table LuaTableView
    -- @param a1 & a2 mixed Difference means for every "fn"
    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(winSize.width, 175 * retina)
        elseif fn == "cellAtIndex" then
            -- Return CCTableViewCell, a1 is cell index (zero based), a2 is dequeued cell (maybe nil)
            -- Do something to create cell  and change the content
            
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            local  proxy = CCBProxy:create()
            local  _hbCell = tolua.cast(CCBReaderLoad("ccbResources/ShadowChangeCell.ccbi",proxy,true, "ShadowChangeCellOwner"),"CCSprite")
            _hbCell:setAnchorPoint(ccp(0.5, 0.5))
            _hbCell:setPosition(winSize.width / 2, 175 * retina / 2)
            _hbCell:setScale(retina)
            -- PrintTable(_offShadow)
            local conf = _offShadow[a1 + 1].conf
            -- PrintTable(conf)
            -- local hero = herodata:getHero(herodata.heroes[hid])
            local frameBtn = tolua.cast(ShadowChangeCellOwner["frameBtn"], "CCMenuItemImage")
            if frameBtn then
                frameBtn:setTag(a1)
            end 
            local avatarSprite = tolua.cast(ShadowChangeCellOwner["avatarSprite"], "CCLayer")
            if conf.icon then
                playCustomFrameAnimation( string.format("yingzi_%s_",conf.icon),avatarSprite,ccp(avatarSprite:getContentSize().width / 2,avatarSprite:getContentSize().height / 2),1,4,shadowData:getColorByColorRank( conf.rank ) )
            end
            local name = tolua.cast(ShadowChangeCellOwner["nameLabel"], "CCLabelTTF")
            name:setString(conf.name)
            local rankLabel = tolua.cast(ShadowChangeCellOwner["rankLabel"], "CCSprite")
            rankLabel:setString(HLNSLocalizedString("品质："))
            local level = tolua.cast(ShadowChangeCellOwner["level"], "CCLabelTTF")
            local attrArray
            if _offShadow[a1 + 1].level then
                level:setString(string.format(HLNSLocalizedString("LV:%d"),_offShadow[a1 + 1].level))
                attrArray = shadowData:getShadowAttrByLevelAndCid( _offShadow[a1 + 1].level,_offShadow[a1 + 1].id )
            else
                level:setVisible(false)
                attrArray = shadowData:getShadowAttrByLevelAndCid( 1,_offShadow[a1 + 1].id )
            end
            local bufLabel = tolua.cast(ShadowChangeCellOwner["bufLabel"], "CCLabelTTF")
            bufLabel:setString("+"..attrArray.value)
            local status = tolua.cast(ShadowChangeCellOwner["status"], "CCLabelTTF")
            if _offShadow[a1 + 1].owner then
                status:setString(string.format(HLNSLocalizedString("装备于%s"),_offShadow[a1 + 1].owner.name))
                status:setVisible(true)
            end
            local rankSpr = tolua.cast(ShadowChangeCellOwner["rankSpr"], "CCSprite")
            rankSpr:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("rank_%d_icon.png", conf.rank)))
            local bufSpr = tolua.cast(ShadowChangeCellOwner["bufSpr"], "CCSprite")
            bufSpr:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(equipdata:getDisplayFrameByType(conf.property)))--, conf.property)))
            
            local bg = tolua.cast(ShadowChangeCellOwner["bg"], "CCSprite")
            if a1 == _selected then
                -- stamp:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("stamp3.png"))
                bg:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("huobanCellBg_sel.png"))
            end

            a2:addChild(_hbCell, 0, 100)

            _hbCell:stopAllActions()
            cellArray[tostring(a1)] = _hbCell
            r = a2
        elseif fn == "numberOfCells" then
            -- Return number of cells
            r = #_offShadow
        -- Cell events:
        elseif fn == "cellTouched" then         -- A cell was touched, a1 is cell that be touched. This is not necessary.
            local index = a1:getIdx()
            if _offShadow[index + 1].owner and _selected ~= a1:getIdx() then
                ShowText(string.format(HLNSLocalizedString("%s已装备此影子"), _offShadow[index + 1].owner.name))
            end
            _selected = _selected == a1:getIdx() and -1 or a1:getIdx()
            local offsetY = _tableView:getContentOffset().y
            _tableView:reloadData()
            _tableView:setContentOffset(ccp(0, offsetY))
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
        local size = CCSizeMake(winSize.width, (winSize.height - _topLayer:getContentSize().height - _mainLayer:getBottomContentSize().height)*97/100)      -- 这里是为了在tableview上面显示一个小空出来
        -- print(size.width.." "..size.height)
        _tableView = LuaTableView:createWithHandler(h, size)
        _tableView:setBounceable(true)
        _tableView:setAnchorPoint(ccp(0,0))
        _tableView:setPosition(ccp(0, _mainLayer:getBottomContentSize().height))
        _tableView:setVerticalFillOrder(0)
        _layer:addChild(_tableView)
    end
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/ShadowChangeView.ccbi", proxy, true,"ShadowChangeOwner")
    _layer = tolua.cast(node,"CCLayer")
end

-- 该方法名字每个文件不要重复
function getChangeShadowLayer()
    return _layer
end

local function cardConfirmAction()
    local _mainLayer = getMainLayer()
    if _mainLayer then
        _mainLayer:gotoTrainShadowView(1)
    end
    _layer:removeFromParentAndCleanup(true) 
end
local function cardCancelAction()

end

function createChangeShadowLayer( heroId, pos, shadowInfo )

    _pos = pos
    _heroId = heroId
    _init()



    local function _onEnter()
        cellArray = {}
        _offShadow = shadowData:getOffShadowByPropertyAndHid( heroId, shadowInfo )
        _addTableView()
        _tableView:reloadData()
        generateCellAction( cellArray,#_offShadow )
        cellArray = {}
        if #_offShadow == 0 then        -- and not herodata.heroes[index] 
            local text = HLNSLocalizedString("shadow.notEnough")
            _layer:addChild(createSimpleConfirCardLayer(text), 100)
            SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
            SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction
        end
    end

    local function _onExit()
        print("onExit")
        _layer = nil
        _offShadow = nil
        _selected = -1
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
    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end