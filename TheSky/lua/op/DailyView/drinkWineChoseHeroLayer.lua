--林绍峰  

local _layer
local _priority
local _contentLayer 

local _herosData
local _selected = -1
local _tableView

DailyDrinkChoseHeroViewOwner = DailyDrinkChoseHeroViewOwner or {}
ccb["DailyDrinkChoseHeroViewOwner"] = DailyDrinkChoseHeroViewOwner

DailyDrinkChoseHeroCellOwner = DailyDrinkChoseHeroCellOwner or {}
ccb["DailyDrinkChoseHeroCellOwner"] = DailyDrinkChoseHeroCellOwner


local function onFormCallback(url, rtnData)
   
end


local function closeItemClick()
    popUpCloseAction(DailyDrinkChoseHeroViewOwner, "infoBg", _layer )
end
DailyDrinkChoseHeroViewOwner["closeItemClick"] = closeItemClick

local function confirmItemClick(tag)
    if _selected == -1 then

        ShowText( HLNSLocalizedString("daily.drinkW.ChoseHero.haventChose") )
    else
        local heroUId = _herosData[_selected + 1].id
        PrintTable(_herosData[_selected + 1].heroId)
        getDailyDrinkWineViewLayer():changeState("main",heroUId)
        
        popUpCloseAction(DailyDrinkChoseHeroViewOwner, "infoBg", _layer )
    end
end
DailyDrinkChoseHeroViewOwner["confirmItemClick"] = confirmItemClick



local function cancelItemClick(tag) --
    popUpCloseAction(DailyDrinkChoseHeroViewOwner, "infoBg", _layer )
end
DailyDrinkChoseHeroViewOwner["cancelItemClick"] = cancelItemClick




local function _addTableView()
    local function onHeadIconClicked(tag)
        local heroUid = _herosData[tag + 1]
        if heroUid then
            -- 显示英雄信息
            getMainLayer():addChild(createHeroInfoLayer(heroUid, HeroDetail_Clicked_SelectHero, _priority-4 ))
        end 
    end
    DailyDrinkChoseHeroCellOwner["onHeadIconClicked"] = onHeadIconClicked   


    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake( 620,165 )
        elseif fn == "cellAtIndex" then
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            local  proxy = CCBProxy:create()
            local  _hbCell = tolua.cast(CCBReaderLoad("ccbResources/DailyDrinkChoseHeroCell.ccbi",proxy,true, "DailyDrinkChoseHeroCellOwner"),"CCSprite")

            local hero = _herosData[a1 + 1]
            --local hero = herodata:getHero(herodata.heroes[hid])
            local frame = tolua.cast(DailyDrinkChoseHeroCellOwner["frame"], "CCSprite")
            frame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", hero.rank)))
            local headIconBtn = tolua.cast(DailyDrinkChoseHeroCellOwner["headIconBtn"], "CCMenuItemImage")
            if headIconBtn then
                headIconBtn:setTag(a1)
                local headSpr = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(herodata:getHeroHeadByHeroId(hero.heroId))
                if headSpr then
                    headIconBtn:setNormalSpriteFrame(headSpr)
                end
            end 
            local breakLevel = DailyDrinkChoseHeroCellOwner["breakLevel"]
            local breakLevelFnt = tolua.cast(DailyDrinkChoseHeroCellOwner["breakLevelFnt"], "CCLabelBMFont")
            local breakValue = hero["break"]
            if breakLevel and breakValue ~= 0 then 
                breakLevel:setVisible(true)
                breakLevelFnt:setString(breakValue)
            end 
            local name = tolua.cast(DailyDrinkChoseHeroCellOwner["name"], "CCLabelTTF")
            name:setString(hero.name)
            local rank = tolua.cast(DailyDrinkChoseHeroCellOwner["rank"], "CCSprite")
            rank:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("rank_%d_icon.png", hero.rank)))
            local level = tolua.cast(DailyDrinkChoseHeroCellOwner["level"], "CCLabelTTF")
            level:setString(hero.level)
            
            local stamp = tolua.cast(DailyDrinkChoseHeroCellOwner["stamp"], "CCSprite")
            local bg = tolua.cast(DailyDrinkChoseHeroCellOwner["bg"], "CCSprite")
            if a1 == _selected then
                stamp:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("stamp3.png"))
                bg:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("huobanCellBg_sel.png"))
            end
            --是否已上阵
            local ifOnForm = tolua.cast(DailyDrinkChoseHeroCellOwner["ifOnForm"], "CCLabelTTF")
            if hero.form  == 1 then
                ifOnForm:setString( HLNSLocalizedString("daily.drinkW.ChoseHero.onform")  )
            elseif hero.form == 0 then
                ifOnForm:setString(" ")
            end

            -- 字样 喝酒已增加潜力：
            local AddedPoint = tolua.cast(DailyDrinkChoseHeroCellOwner["AddedPoint"], "CCLabelTTF")
            AddedPoint:setString(HLNSLocalizedString("daily.drinkW.ChoseHero.AddedPoint" ))
            
            --饮酒增加的潜力值和 max潜力值
            local _curHeroUId = _herosData[a1 + 1].id
            local  _cSdrink_rank  =   ConfigureStorage.Drink_rank  
            local rank = herodata:getHeroInfoByHeroUId(_curHeroUId).rank
            local rankInfo = _cSdrink_rank[tostring(rank)]
            local maxPointDrink = math.ceil(rankInfo.base + rankInfo.grow * (herodata.heroes[_curHeroUId].level-1) )  --最大潜力值= 基础+当前等级*系数 , 向上取整，c 1级是 53.5 -》54
            local pointDrink
            if herodata.heroes[_curHeroUId].pointDrink == nil then --如果是空，说明饮酒增加的潜力为0
                pointDrink = 0
            else
                pointDrink = herodata.heroes[_curHeroUId].pointDrink 
            end
            local playersPotentialInfo = tolua.cast(DailyDrinkChoseHeroCellOwner["playersPotentialInfo"], "CCLabelTTF")
            playersPotentialInfo:setString(  string.format("%d/%d", pointDrink , maxPointDrink) ) 

            a2:addChild(_hbCell, 0, 100)
            _hbCell:setAnchorPoint(ccp(0.5, 0))
            _hbCell:setPosition( _contentLayer:getContentSize().width / 2, 0)  

            r = a2
        elseif fn == "numberOfCells" then
            -- Return number of cells
            r = #_herosData
        -- Cell events:
        elseif fn == "cellTouched" then         -- A cell was touched, a1 is cell that be touched. This is not necessary.
            local headIconBtn = tolua.cast(a1:getChildByTag(100):getChildByTag(100):getChildByTag(100):getChildByTag(a1:getIdx()), "CCMenuItemImage")
            if headIconBtn:isSelected() then
                return r
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


    local size = _contentLayer:getContentSize()
    _tableView = LuaTableView:createWithHandler(h, size)
    _tableView:setBounceable(true)
    _tableView:setAnchorPoint(ccp(0,0))
    _tableView:setPosition(0,0)
    _tableView:setVerticalFillOrder(0)
    _contentLayer:addChild(_tableView,1000)

end



local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(DailyDrinkChoseHeroViewOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction(DailyDrinkChoseHeroViewOwner, "infoBg", _layer)
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
    local menu = tolua.cast(DailyDrinkChoseHeroViewOwner["menu"], "CCMenu")
    menu:setTouchPriority(_priority - 2)
   _tableView:setTouchPriority(_priority - 2)
 
end

function getDailyDrinkChoseHeroLayer()
    return _layer
end



local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/DailyDrinkChoseHeroView.ccbi",proxy, true,"DailyDrinkChoseHeroViewOwner")
    _layer = tolua.cast(node,"CCLayer")
    _contentLayer = DailyDrinkChoseHeroViewOwner["contentLayer"]

    local title = tolua.cast(DailyDrinkChoseHeroViewOwner["title"], "CCLabelTTF")
    title:setString( HLNSLocalizedString("daily.drinkW.ChoseHero.choseHero")   ) 
   
    -- _refreshData()
    _herosData = herodata:getAllHeroes() 
    if #_herosData == 0 and not herodata.heroes[index] then
        local text = HLNSLocalizedString("team.need.partner")
        _layer:addChild(createSimpleConfirCardLayer(text), 100)
        SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
        SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction
    end
    
    _addTableView()
    _tableView:reloadData()
    
end

local function cardConfirmAction()
    getMainLayer():goToLogue() 
end
local function cardCancelAction()

end

function createDailyDrinkChoseHeroLayer(priority) --priority -140
    _priority = (priority ~= nil) and priority or -140

    _init()
    print("**lsf _selected",_selected)
    function _layer:selectHero(index)
        _selected = index
        local offsetY = _tableView:getContentOffset().y
        _tableView:reloadData()
        _tableView:setContentOffset(ccp(0, offsetY))
    end

    function _layer:confirmItemClick()
        confirmItemClick() 
    end

    function _layer:onFormCallback(url, rtnData)
        onFormCallback(url, rtnData)
    end

    local function _onEnter()
        print("DailyDrinkChoseHeroView onEnter")        
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
        popUpUiAction(DailyDrinkChoseHeroViewOwner, "infoBg")
        
    end

    local function _onExit()
        print("DailyDrinkChoseHeroView onExit")
        _layer = nil
       
        _selected = -1
        _tableView = nil
       
    end

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