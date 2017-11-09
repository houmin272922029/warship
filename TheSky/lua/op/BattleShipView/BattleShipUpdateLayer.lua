local _layer
local _type
local _currentLevel
local _nextLevel
local _nextAttr
local _allInfo
local _name
local allHeroInfo
local allSoulInfo
local progress
local asNubmer = 0

local currentEXP = 0
local nextEXP = 0
local allEXP = 0

local tempLevel    

local _tableView1
local _tableView2
local Table1OffsetY
local Table2OffsetY

local destroyHeros = {}
local destroySouls = {}
local heroBtnState = {}
local soulBtnState = {}

local isFirstIn = 0

local currentPersent = 0


-- ·名字不要重复
BattleShipUpdateLayerOwner = BattleShipUpdateLayerOwner or {}
ccb["BattleShipUpdateLayerOwner"] = BattleShipUpdateLayerOwner

ShipUpgradeCellOwner = ShipUpgradeCellOwner or {}
ccb["ShipUpgradeCellOwner"] = ShipUpgradeCellOwner

local function updataBtnFrame()
    local sprite = tolua.cast(BattleShipUpdateLayerOwner["exitSprite"],"CCSprite")
    if getMyTableCount(destroySouls) + getMyTableCount(destroyHeros) > 0 then
        sprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("fangqi_text.png"))
    else
        sprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tuichu_title.png"))
    end
end

local function getAllInfo()
    _name = battleShipData:getShipNameByType(_type)
    _allInfo = battleShipData:getBattleShipInfoByType(_type)
    _currentLevel = _allInfo.level
    _nextLevel = _allInfo.level + 1
    currentEXP = _allInfo.expNow
    allEXP = _allInfo.expNow
    _nextAttr = battleShipData:getAttrByTypeAndLevel(_type, _nextLevel)
end

local function setContentInfo()
    local nameLabel = tolua.cast(BattleShipUpdateLayerOwner["nameLabel"],"CCLabelTTF")
    nameLabel:setString(_name)

    local cache = CCSpriteFrameCache:sharedSpriteFrameCache()

    local avatarIcon = tolua.cast(BattleShipUpdateLayerOwner["avatarIcon"], "CCSprite")
    local attrSprite1 = tolua.cast(BattleShipUpdateLayerOwner["attSprite1"], "CCSprite")
    local attrSprite2 = tolua.cast(BattleShipUpdateLayerOwner["attSprite2"], "CCSprite")

    avatarIcon:setDisplayFrame(cache:spriteFrameByName(string.format("battleship_%s.png", _type)))
    attrSprite1:setDisplayFrame(cache:spriteFrameByName(equipdata:getDisplayFrameByType(_type)))
    attrSprite2:setDisplayFrame(cache:spriteFrameByName(equipdata:getDisplayFrameByType(_type)))

    local levelLabel = tolua.cast(BattleShipUpdateLayerOwner["levelLabel"],"CCLabelTTF")
    levelLabel:setString(string.format(HLNSLocalizedString("Lv:%s"), _allInfo["level"]))
    tempLevel = _allInfo["level"]
    local centerLvLabel = tolua.cast(BattleShipUpdateLayerOwner["centerLvLabel"],"CCLabelTTF")
    centerLvLabel:setString(_allInfo["level"])
    local currentAttr = tolua.cast(BattleShipUpdateLayerOwner["currentAttr"],"CCLabelTTF")
    local attr = _allInfo.attr
    local nAttr = battleShipData:getAttrByTypeAndLevel(_type, _allInfo["level"] + 1)
    if tostring(math.floor(attr)) == tostring(attr) then
        currentAttr:setString(string.format("+%s", attr))
    else
        currentAttr:setString(string.format("+%s%%", tostring(attr * 100)))
    end
    local nextAttr = tolua.cast(BattleShipUpdateLayerOwner["nextAttr"], "CCLabelTTF")
    if tostring(math.floor(nAttr)) == tostring(nAttr) then
        nextAttr:setString(string.format("+%s", nAttr))
    else
        nextAttr:setString(string.format("+%s%%", tostring(nAttr * 100)))
    end
    local persentLabel = tolua.cast(BattleShipUpdateLayerOwner["persentLabel"],"CCLabelTTF")
    persentLabel:setString(string.format("%s/%s", _allInfo["expNow"], battleShipData:getNeedEXPByShipLevel(_allInfo["level"])))

    progress:setPercentage((_allInfo["expNow"] / battleShipData:getNeedEXPByShipLevel(_allInfo["level"])) * 100)

end

local function updateContentInfo()
    local levelLabel = tolua.cast(BattleShipUpdateLayerOwner["levelLabel"],"CCLabelTTF")
    levelLabel:setString(string.format(HLNSLocalizedString("Lv:%s"), _currentLevel))
    local centerLvLabel = tolua.cast(BattleShipUpdateLayerOwner["centerLvLabel"],"CCLabelTTF")
    centerLvLabel:setString(_currentLevel)
    local currentAttr = tolua.cast(BattleShipUpdateLayerOwner["currentAttr"],"CCLabelTTF")
    local attr = battleShipData:getAttrByTypeAndLevel(_type, _currentLevel)
    if tostring(math.floor(attr)) == tostring(attr) then
        currentAttr:setString(string.format("+%s", attr))
    else
        currentAttr:setString(string.format("+%s%%", tostring(attr * 100)))
    end
    local nextAttr = tolua.cast(BattleShipUpdateLayerOwner["nextAttr"],"CCLabelTTF")
    attr = battleShipData:getAttrByTypeAndLevel(_type, _nextLevel)
    if tostring(math.floor(attr)) == tostring(attr) then
        nextAttr:setString(string.format("+%s", attr))
    else
        nextAttr:setString(string.format("+%s%%", tostring(attr * 100)))
    end
    
    local persentLabel = tolua.cast(BattleShipUpdateLayerOwner["persentLabel"],"CCLabelTTF")
    persentLabel:setString(string.format("%s/%s",currentEXP,nextEXP))

    progress:stopAllActions()
    local actionArray = CCArray:create()
    local changeLabel = _currentLevel - tempLevel
    if changeLabel > 0 then
        actionArray:addObject(CCProgressFromTo:create(1 / (changeLabel + 2), progress:getPercentage(), 100))
        if changeLabel > 1 then
            for i=2,changeLabel do
                actionArray:addObject(CCProgressFromTo:create(1 / (changeLabel + 2), 0, 100))
            end
        end
        actionArray:addObject(CCProgressFromTo:create(1 / (changeLabel + 2), 0, (currentEXP / nextEXP) * 100))
    else
        actionArray:addObject(CCProgressFromTo:create(0.5, progress:getPercentage(), (currentEXP / nextEXP) * 100))
    end
    local function setPercentageZero()
        currentPersent = 0 
    end
    actionArray:addObject(CCCallFunc:create(setPercentageZero))

    currentPersent = (currentEXP / nextEXP) * 100
    progress:runAction(CCSequence:create(actionArray))
    tempLevel = _currentLevel
end



local function updateShipCallBack(url, rtnData)
    if rtnData["code"] == 200 then
        battleShipData.attrFix[_type] = rtnData.info.attrFix
        getAllInfo()
        setContentInfo()

        destroyHeros = {}
        destroySouls = {}
        heroBtnState = {}
        soulBtnState = {}

        allHeroInfo = herodata:getBattleShipStuffHeroes()
        allSoulInfo = heroSoulData:getAllSoulsInfo(1)

        _tableView1:reloadData()
        _tableView2:reloadData()
        asNubmer = 0
        -- renzhan
        local avatar = tolua.cast(BattleShipUpdateLayerOwner["avatarFrame"], "CCSprite")
        HLAddParticleScale("images/eff_refineEquip_1.plist", avatar, ccp(avatar:getContentSize().width / 2, 
            avatar:getContentSize().height * 0.5), 1, 1, 1, 0.75 / retina, 0.75 / retina)
        HLAddParticleScale("images/eff_refineEquip_2.plist", avatar, ccp(avatar:getContentSize().width / 2, 
            avatar:getContentSize().height * 0.5), 1, 1, 1, 1.5 / retina, 1.5 / retina)
    else
        ShowText(HLNSLocalizedString("升级失败"))
    end
    updataBtnFrame()
end

local function cardConfirmAction()
    if getMyTableCount(destroySouls) + getMyTableCount(destroyHeros) == 0 then
        ShowText(HLNSLocalizedString("你没有选择伙伴或者魂魄"))
    else
        local array = {_type, destroyHeros, destroySouls}
        doActionFun("UPDATE_SHIP_URL", array, updateShipCallBack)
    end
end

local function cardCancelAction()
    
end

local function updateShipAction()
    if asNubmer > 0 then
        _layer:addChild(createSimpleConfirCardLayer(HLNSLocalizedString("船长，你选择了消耗A级以上的伙伴或魂魄，这不是太可惜了吗，您舍得吗？")))
        SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
        SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction
    else
        if getMyTableCount(destroySouls) + getMyTableCount(destroyHeros) == 0 then
            ShowText(HLNSLocalizedString("你没有选择伙伴或者魂魄"))
        else
            local array = {_type, destroyHeros, destroySouls}
            doActionFun("UPDATE_SHIP_URL", array, updateShipCallBack)
        end
    end
end 
BattleShipUpdateLayerOwner["updateShipAction"] = updateShipAction


local function onItemTaped(tag, sender)
    if currentPersent ~= 0 and currentPersent ~= progress:getPercentage() then
        progress:stopAllActions()
        progress:setPercentage(currentPersent)
    end
    if tag > 2000 then
        if allSoulInfo[tag - 2000]["amount"] > 0 then
            allSoulInfo[tag - 2000]["amount"] = allSoulInfo[tag - 2000]["amount"] - 1
            local soulContent = allSoulInfo[tag - 2000]
            if soulContent.rank >= 3 then
                asNubmer = asNubmer + 1
            end

            if destroySouls[soulContent["id"]] then
                destroySouls[soulContent["id"]] = destroySouls[soulContent["id"]] + 1
            else
                destroySouls[soulContent["id"]] = 1
            end

            allEXP = allEXP + heroSoulData:soulCanGetEXPById(soulContent["id"])
            nextEXP = battleShipData:getNeedEXPByShipLevel(_nextLevel - 1)
            currentEXP = currentEXP + heroSoulData:soulCanGetEXPById(soulContent["id"])

            local function getEXPS()
                if currentEXP >= nextEXP then
                    currentEXP = currentEXP - nextEXP
                    _currentLevel = _nextLevel
                    _nextLevel = _nextLevel + 1
                    
                    nextEXP = battleShipData:getNeedEXPByShipLevel(_nextLevel - 1)
                    getEXPS( )
                end
            end

            getEXPS()
            updateContentInfo()
            if allSoulInfo[tag - 2000]["amount"] == 0 then
                soulBtnState[tag - 2000] = 0
            end
            Table1OffsetY = _tableView2:getContentOffset().y
            _tableView2:reloadData()
            _tableView2:setContentOffset(ccp(0, Table1OffsetY))
            updataBtnFrame()
        else
            ShowText(HLNSLocalizedString("你的魂魄不够了"))
        end
    else
        local heroContent = allHeroInfo[tag]
        if heroContent["exp_now"] <= 0 then
            if heroContent.rank >= 3 then
                asNubmer = asNubmer + 1
            end
            table.insert(destroyHeros, heroContent.id)
            allEXP = allEXP + battleShipData:heroCanGetEXPById(heroContent.id)
            nextEXP = battleShipData:getNeedEXPByShipLevel(_nextLevel - 1)
            currentEXP = currentEXP + battleShipData:heroCanGetEXPById(heroContent.id)

            local function getEXPS()
                if currentEXP >= nextEXP then
                    currentEXP = currentEXP - nextEXP
                    _currentLevel = _nextLevel
                    _nextLevel = _nextLevel + 1

                    nextEXP = battleShipData:getNeedEXPByShipLevel(_nextLevel - 1)
                    getEXPS()
                end
            end

            getEXPS()
            updateContentInfo()
            heroBtnState[tag] = 0
            Table1OffsetY = _tableView1:getContentOffset().y
            updataBtnFrame()
            _tableView1:reloadData()
            _tableView1:setContentOffset(ccp(0, Table1OffsetY))
        else
            local function havaExpcardConfirmAction()
                if heroContent.rank >= 3 then
                    asNubmer = asNubmer + 1
                end
                table.insert(destroyHeros, heroContent.id)
                allEXP = allEXP + battleShipData:heroCanGetEXPById(heroContent.id)
                nextEXP = battleShipData:getNeedEXPByShipLevel(_nextLevel - 1)
                currentEXP = currentEXP + battleShipData:heroCanGetEXPById(heroContent.id)

                local function getEXPS()
                    if currentEXP >= nextEXP then
                        currentEXP = currentEXP - nextEXP
                        _currentLevel = _nextLevel
                        _nextLevel = _nextLevel + 1

                        nextEXP = battleShipData:getNeedEXPByShipLevel(_nextLevel - 1)
                        getEXPS()
                    end
                end

                getEXPS()
                updateContentInfo()
                heroBtnState[tag] = 0
                Table1OffsetY = _tableView1:getContentOffset().y
                updataBtnFrame()
                _tableView1:reloadData()
                _tableView1:setContentOffset(ccp(0, Table1OffsetY))
            end
            local function havaExpcardCancelAction()
                
            end
            _layer:addChild(createSimpleConfirCardLayer(HLNSLocalizedString("该伙伴拥有经验,你确定要消耗它吗？"),
                HLNSLocalizedString("强化确认")))
            SimpleConfirmCard.confirmMenuCallBackFun = havaExpcardConfirmAction
            SimpleConfirmCard.cancelMenuCallBackFun = havaExpcardCancelAction
        end
    end 
end

ShipUpgradeCellOwner["onItemTaped"] = onItemTaped

local function _addTableView1()
    -- 得到数据
    allHeroInfo = herodata:getBattleShipStuffHeroes()
    ShipUpgradeCellOwner["refineBtnTaped"] = refineBtnTaped
    local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
                r = CCSizeMake(250 * retina, 140)
        elseif fn == "cellAtIndex" then
            -- Return CCTableViewCell, a1 is cell index (zero based), a2 is dequeued cell (maybe nil)
            -- Do something to create cell  and change the content
            
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            --单条数据
            local proxy = CCBProxy:create()
            local _hbCell = tolua.cast(CCBReaderLoad("ccbResources/ShipUpgrateCell.ccbi", proxy, true, 
                "ShipUpgradeCellOwner"), "CCLayer")
            
            for i = 1, 2 do
                local item = tolua.cast(ShipUpgradeCellOwner[string.format("item%d", i)], "CCMenuItemImage")
                local nameLabel = tolua.cast(ShipUpgradeCellOwner[string.format("nameLabel%d", i)], "CCLabelTTF")
                local CountBg = tolua.cast(ShipUpgradeCellOwner[string.format("CountBg%d", i)], "CCSprite")
                local heroHead = tolua.cast(ShipUpgradeCellOwner["heroHead" .. i], "CCSprite")
                local soulSprite = tolua.cast(ShipUpgradeCellOwner["soulSprite" .. i], "CCSprite")
                local countLabel = tolua.cast(ShipUpgradeCellOwner[string.format("countLabel%d", i)], "CCLabelTTF")
                local shadowLayer = tolua.cast(ShipUpgradeCellOwner["shadowLayer" .. i], "CCLayer")
                local rankSprite = tolua.cast(ShipUpgradeCellOwner[string.format("rankSprite%d", i)], "CCSprite")
                if a1 * 2 + i <= getMyTableCount(allHeroInfo) then
                    local itemContent = allHeroInfo[a1 * 2 + i]
                    item:setTag(a1 * 2 + i)
                    item:setNormalSpriteFrame(cache:spriteFrameByName(string.format("frame_%d.png", itemContent.rank)))
                    item:setSelectedSpriteFrame(cache:spriteFrameByName(string.format("frame_%d.png", itemContent.rank)))

                    nameLabel:setString(itemContent["name"])

                    CountBg:setVisible(false)

                    local headSpr = herodata:getHeroHeadByHeroId(itemContent.heroId)
                    local frame = cache:spriteFrameByName(headSpr)
                    if frame then
                        heroHead:setVisible(true)
                        heroHead:setDisplayFrame(frame)
                    end

                    rankSprite:setVisible(true)
                    rankSprite:setDisplayFrame(cache:spriteFrameByName(string.format("rank_%d_icon.png", itemContent.rank)))
                    if not heroBtnState[a1 * 2 + i] then
                        item:setEnabled(true)
                        shadowLayer:setVisible(false)
                        heroBtnState[a1 * 2 + i] = 1
                    elseif heroBtnState[a1 * 2 + i] == 1 then
                        item:setEnabled(true)
                        shadowLayer:setVisible(false)
                    elseif heroBtnState[a1 * 2 + i] == 0 then
                        item:setEnabled(false)
                        shadowLayer:setVisible(true)
                    end

                else
                    item:setVisible(false)
                    nameLabel:setVisible(false)
                    heroHead:setVisible(false)
                    CountBg:setVisible(false)
                    rankSprite:setVisible(false)
                end
            end

            a2:addChild(_hbCell, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            r = a2
        elseif fn == "numberOfCells" then
            r = math.ceil(getMyTableCount(allHeroInfo) / 2)
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
    local contentView1 = tolua.cast(BattleShipUpdateLayerOwner["TableViewContent1"], "CCLayer")
    local _mainLayer = getMainLayer()
    local x = 1
    if _mainLayer then
        local size = CCSizeMake(contentView1:getContentSize().width, contentView1:getContentSize().height)
        _tableView1 = LuaTableView:createWithHandler(h, size)
        _tableView1:setBounceable(true)
        _tableView1:setAnchorPoint(ccp(0, 0))
        _tableView1:setPosition(0, 0)
        _tableView1:setVerticalFillOrder(0)
        contentView1:addChild(_tableView1, 1000)
    end
end

local function _addTableView2()
    -- 得到数据
    
    allSoulInfo = heroSoulData:getAllSoulsInfo(1)
    ShipUpgradeCellOwner["refineBtnTaped"] = refineBtnTaped
    local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
                r = CCSizeMake(250 * retina, 140)
        elseif fn == "cellAtIndex" then
            -- Return CCTableViewCell, a1 is cell index (zero based), a2 is dequeued cell (maybe nil)
            -- Do something to create cell  and change the content
            
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            --单条数据
            local proxy = CCBProxy:create()
            local _hbCell = tolua.cast(CCBReaderLoad("ccbResources/ShipUpgrateCell.ccbi", proxy, true, 
                "ShipUpgradeCellOwner"), "CCLayer")
            
            for i = 1, 2 do
                local item = tolua.cast(ShipUpgradeCellOwner[string.format("item%d", i)], "CCMenuItemImage")
                local nameLabel = tolua.cast(ShipUpgradeCellOwner[string.format("nameLabel%d", i)], "CCLabelTTF")
                local CountBg = tolua.cast(ShipUpgradeCellOwner[string.format("CountBg%d", i)], "CCSprite")
                local heroHead = tolua.cast(ShipUpgradeCellOwner["heroHead" .. i], "CCSprite")
                local soulSprite = tolua.cast(ShipUpgradeCellOwner["soulSprite" .. i], "CCSprite")
                local countLabel = tolua.cast(ShipUpgradeCellOwner[string.format("countLabel%d", i)], "CCLabelTTF")
                local shadowLayer = tolua.cast(ShipUpgradeCellOwner["shadowLayer" .. i], "CCLayer")
                local rankSprite = tolua.cast(ShipUpgradeCellOwner[string.format("rankSprite%d", i)], "CCSprite")
                if a1 * 2 + i <= getMyTableCount(allSoulInfo) then
                    local itemContent = allSoulInfo[a1 * 2 + i]
                    item:setTag(a1 * 2 + i + 2000)
                    item:setNormalSpriteFrame(cache:spriteFrameByName(string.format("frame_%d.png", itemContent.rank)))
                    item:setSelectedSpriteFrame(cache:spriteFrameByName(string.format("frame_%d.png", itemContent.rank)))
                    
                    nameLabel:setString(itemContent["name"])
                    CountBg:setVisible(true)

                    soulSprite:setVisible(true)

                    local headSpr = herodata:getHeroHeadByHeroId(itemContent.id)
                    local frame = cache:spriteFrameByName(headSpr)
                    if frame then
                        heroHead:setVisible(true)
                        heroHead:setDisplayFrame(frame)
                    end

                    countLabel:setString(itemContent["amount"])

                    rankSprite:setVisible(true)
                    rankSprite:setDisplayFrame(cache:spriteFrameByName(string.format("rank_%d_icon.png", itemContent.rank)))
                    if not soulBtnState[a1 * 2 + i] then
                        shadowLayer:setVisible(false)
                        soulBtnState[a1 * 2 + i] = 1
                        item:setEnabled(true)
                    elseif soulBtnState[a1 * 2 + i] == 1 then
                        shadowLayer:setVisible(false)
                        item:setEnabled(true)
                    elseif soulBtnState[a1 * 2 + i] == 0 then
                        shadowLayer:setVisible(true)
                        item:setEnabled(false)
                    end
                else
                    item:setVisible(false)
                    nameLabel:setVisible(false)
                    heroHead:setVisible(false)
                    CountBg:setVisible(false)
                    rankSprite:setVisible(false)
                end
            end

            a2:addChild(_hbCell, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            r = a2
        elseif fn == "numberOfCells" then
            r = math.ceil(getMyTableCount(allSoulInfo) / 2)
        elseif fn == "cellTouched" then         -- A cell was touched, a1 is cell that be touched. This is not necessary.
        elseif fn == "cellTouchBegan" then      -- A cell is touching, a1 is cell, a2 is CCTouch
        elseif fn == "cellTouchEnded" then      -- A cell was touched, a1 is cell, a2 is CCTouch
        elseif fn == "cellHighlight" then       -- A cell is highlighting, coco2d-x 2.1.3 or above
        elseif fn == "cellUnhighlight" then     -- A cell had been unhighlighted, coco2d-x 2.1.3 or above
        elseif fn == "cellWillRecycle" then     -- A cell will be recycled, coco2d-x 2.1.3 or above
        end
        return r
    end)
    local contentView1 = tolua.cast(BattleShipUpdateLayerOwner["TableViewContent2"], "CCLayer")
    local _mainLayer = getMainLayer()
    local x = 1
    if _mainLayer then
        local size = CCSizeMake(contentView1:getContentSize().width, contentView1:getContentSize().height)
        _tableView2 = LuaTableView:createWithHandler(h, size)
        _tableView2:setBounceable(true)
        _tableView2:setAnchorPoint(ccp(0, 0))
        _tableView2:setPosition(0, 0)
        _tableView2:setVerticalFillOrder(0)
        contentView1:addChild(_tableView2, 1000)
    end
end

local function exitBtnAction()
    if getMyTableCount(destroyHeros) > 0 or getMyTableCount(destroySouls) > 0 then
        destroyHeros = {}
        destroySouls = {}
        heroBtnState = {}
        soulBtnState = {}
        asNubmer = 0
        getAllInfo()
        setContentInfo()

        allHeroInfo = herodata:getBattleShipStuffHeroes()
        allSoulInfo = heroSoulData:getAllSoulsInfo(1)

        Table1OffsetY = _tableView1:getContentOffset().y
        _tableView1:reloadData()
        _tableView1:setContentOffset(ccp(0, Table1OffsetY))

        Table1OffsetY = _tableView2:getContentOffset().y
        _tableView2:reloadData()
        _tableView2:setContentOffset(ccp(0, Table1OffsetY))
        updataBtnFrame()
    else
        local _mainLayer = getMainLayer()
        if _mainLayer then
            _mainLayer:gotoBattleShipLayer()
        end
    end
end

BattleShipUpdateLayerOwner["exitBtnAction"] = exitBtnAction

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/BattleShipUpdateView.ccbi",proxy, true,"BattleShipUpdateLayerOwner")
    _layer = tolua.cast(node,"CCLayer")

    local progressBg = tolua.cast(BattleShipUpdateLayerOwner["nishabi"],"CCLayer")
    progressBg:setVisible(true)

    local SB = tolua.cast(BattleShipUpdateLayerOwner["progressBg"], "CCSprite")

    progress = CCProgressTimer:create(CCSprite:create("images/blueBattleShip.png"))
    progress:setType(kCCProgressTimerTypeBar)
    progress:setMidpoint(CCPointMake(0, 0))
    progress:setBarChangeRate(CCPointMake(1, 0))
    
    progressBg:addChild(progress,0)
    -- progress:setPercentage(0)
    progressBg:setRotation(-90)
    progress:setPosition(ccp(progressBg:getContentSize().width / 2, progressBg:getContentSize().height / 2))

    getAllInfo()
    setContentInfo()
end


-- 该方法名字每个文件不要重复
function getBattleShipLayer()
	return _layer
end

function createBattleShipUpdateLayer(uniqueId)
    _type = uniqueId

    _init()

	-- public方法写在每个layer的创建的方法内 调用时方法
	-- local layer = getLayer()
	-- layer:refresh()

	function _layer:refresh()
		
	end

    local function _onEnter()
        isFirstIn = 0
        currentPersent = 0
        _addTableView1()
        _addTableView2()
        
    end

    local function _onExit()
        print("onExit")
        _layer = nil
        isFirstIn = 0
        _tableView1 = nil
        _tableView2 = nil
        Table1OffsetY = nil
        Table2OffsetY = nil
        destroyHeros = {}
        destroySouls = {}
        heroBtnState = {}
        soulBtnState = {}
        asNubmer = 0
        currentPersent = 0
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