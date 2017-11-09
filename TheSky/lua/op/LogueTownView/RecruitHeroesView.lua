local _layer
local _priority
local _tableView

-- 名字不要重复
RecruitHeroesOwner = RecruitHeroesOwner or {}
ccb["RecruitHeroesOwner"] = RecruitHeroesOwner

local function closeItemClick(  )
   popUpCloseAction(RecruitHeroesOwner, "infoBg", _layer)
end
RecruitHeroesOwner["closeItemClick"] = closeItemClick

local RecruitHeroesCellOwner = RecruitHeroesCellOwner or {}
local RecruitHeroesTipsCellOwner = RecruitHeroesTipsCellOwner or {}

local function _addTableView(heroes, bonus)
    -- 得到数据

    local function heroClick(tag)
        getMainLayer():getParent():addChild(createHeroInfoLayer(heroes[tag].heroId, HeroDetail_Clicked_Handbook, _priority - 2), 10)
    end

    local function bonusClick(tag)
        getMainLayer():getParent():addChild(createHeroInfoLayer(bonus[tag], HeroDetail_Clicked_Handbook, _priority - 2), 10)
    end

    local function heroBookBtnAction()
        
    end
    RecruitHeroesCellOwner["heroBookBtnAction"] = heroBookBtnAction

    local containLayer = tolua.cast(RecruitHeroesOwner["containLayer"], "CCLayer")
    local heroCellCount = 0
    if (#heroes % 5) == 0 then
        heroCellCount = math.floor(#heroes / 5)
    else
        heroCellCount = math.floor(#heroes / 5) + 1
    end
    local bonusCellCount = 0
    if bonus then
        if (#bonus % 5) == 0 then
            bonusCellCount = math.floor(#bonus / 5)
        else
            bonusCellCount = math.floor(#bonus / 5) + 1
        end
    end

    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            if a1 == 0 or a1 == heroCellCount + 1 then
                r = CCSizeMake(600, 40)
            else
                r = CCSizeMake(600, 155)
            end
        elseif fn == "cellAtIndex" then
            -- Return CCTableViewCell, a1 is cell index (zero based), a2 is dequeued cell (maybe nil)
            -- Do something to create cell  and change the content
            
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            local proxy = CCBProxy:create()
            local cell
            if a1 == 0 or a1 == heroCellCount + 1 then
                ccb["RecruitHeroesTipsCellOwner"] = RecruitHeroesTipsCellOwner
                local node = CCBReaderLoad("ccbResources/RecruitHeroesTipsCell.ccbi", proxy, true, "RecruitHeroesTipsCellOwner")
                cell = tolua.cast(node, "CCLayer")
                if a1 == 0 then
                    RecruitHeroesTipsCellOwner["tips"]:setString(HLNSLocalizedString("recruit.heroes.expect"))
                else
                    RecruitHeroesTipsCellOwner["tips"]:setString(HLNSLocalizedString("recruit.heroes.bonus"))
                end
            else
                ccb["RecruitHeroesCellOwner"] = RecruitHeroesCellOwner
                local node = CCBReaderLoad("ccbResources/RecruitHeroesCell.ccbi", proxy, true, "RecruitHeroesCellOwner")
                cell = tolua.cast(node, "CCLayer")

                local function setCellMenuPriority(sender)
                    if sender then
                        local menu = tolua.cast(sender, "CCMenu")
                        menu:setHandlerPriority(_priority - 2)
                    end
                end

                local menu = RecruitHeroesCellOwner["cellMenu"]
                local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCCallFuncN:create(setCellMenuPriority))
                menu:runAction(seq)

                for i = 1, 5 do
                    local hero
                    local index
                    if a1 <= heroCellCount then
                        index = (a1 - 1) * 5 + i
                        hero = heroes[index]
                    else
                        local idx = a1 - heroCellCount - 2
                        index = idx * 5 + i
                        heroId = bonus[index]
                        if heroId then
                            hero = herodata:getHeroConfig(heroId)
                        end
                    end
                    if hero then
                        local nameLabel = tolua.cast(RecruitHeroesCellOwner[string.format("nameLabel%d",i)],"CCLabelTTF")
                        nameLabel:setString(hero.name)

                        local avatarBtn = tolua.cast(RecruitHeroesCellOwner[string.format("avatarBtn%d",i)],"CCMenuItemImage")
                        avatarBtn:setTag(index)
                        if a1 <= heroCellCount then
                            avatarBtn:registerScriptTapHandler(heroClick)
                        else
                            avatarBtn:registerScriptTapHandler(bonusClick)
                        end
                        avatarBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", hero.rank)))
                        avatarBtn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", hero.rank)))
                            
                        local rankSprite = tolua.cast(RecruitHeroesCellOwner[string.format("rankSprite%d",i)],"CCSprite")
                        rankSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(herodata:getHeroHeadByHeroId(hero.heroId)))

                    else
                        local nameLabel = tolua.cast(RecruitHeroesCellOwner[string.format("nameLabel%d",i)],"CCLabelTTF")
                        nameLabel:setVisible(false)
                        local rankSprite = tolua.cast(RecruitHeroesCellOwner[string.format("rankSprite%d",i)],"CCSprite")
                        rankSprite:setVisible(false)
                        local avatarBtn = tolua.cast(RecruitHeroesCellOwner[string.format("avatarBtn%d",i)],"CCMenuItemImage")
                        avatarBtn:setVisible(false)
                    end
                end
            end
            

            a2:addChild(cell, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            r = a2
        elseif fn == "numberOfCells" then
            r = heroCellCount + 1
            if bonusCellCount > 0 then
                r = r + 1 + bonusCellCount
            end
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

    local proxy = CCBProxy:create()
    local node = CCBReaderLoad("ccbResources/RecruitHeroesView.ccbi", proxy, true, "RecruitHeroesOwner")
    _layer = tolua.cast(node,"CCLayer")
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(RecruitHeroesOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction(RecruitHeroesOwner, "infoBg", _layer)
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
    local menu = tolua.cast(RecruitHeroesOwner["closeMenu"], "CCMenu")
    menu:setHandlerPriority(_priority - 1)
    _tableView:setTouchPriority(_priority - 2)
end

-- 该方法名字每个文件不要重复
function getRecruitHeroesLayer()
	return _layer
end

function createRecruitHeroesLayer(heroes, bonus)
    _priority = -135
    _init()

    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
        _addTableView(heroes, bonus)
        popUpUiAction(RecruitHeroesOwner, "infoBg")
    end

    local function _onExit()
        _layer = nil
        _priority = -135
    end

    --onEnter onExit
    local function _layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        end
    end

    _layer:registerScriptTouchHandler(onTouch, false, _priority, true)
    _layer:setTouchEnabled(true)
    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end