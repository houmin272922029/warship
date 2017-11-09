
-- 工匠-合成-合成器升级页面

local _layer
local _composeMachine
local _priority = -132
local _contentLayer

local equip_machine
local _tableView
local _compoundItems = {
    "whitecost",
    "greencost",
    "bluecost",
    "purplecost",
    "purplecostes",
}
local itemDic = {}
local stuffCount = {}
local _stuffCount = {}
local startExpAll = 0
local cacheExpAll = 0 -- 缓冲经验
local nextEXP = 0
local startlevel = 0
local ExpAll = 0
local array = {}
local templevel = 0 
local dic
local _exp


local centerLvLabel
local persentLabelBg
local persentLabel
local progress
local soulBtnState = {}

-- 名字不要重复
DailyComposeUpdataViewOwner = DailyComposeUpdataViewOwner or {}
ccb["DailyComposeUpdataViewOwner"] = DailyComposeUpdataViewOwner

DailyComposeUpdataCellOwner = DailyComposeUpdataCellOwner or {}
ccb["DailyComposeUpdataCellOwner"] = DailyComposeUpdataCellOwner

local function stopMyschedu()
    if myschedu then
        scheduler:unscheduleScriptEntry(myschedu)
        myschedu = nil
    end
end

local function closeItemClick()
    _layer:removeFromParentAndCleanup(true)
end
DailyComposeUpdataViewOwner["closeItemClick"] = closeItemClick

 local function canceClick()
    -- centerLvLabel:setString(startlevel)
    -- persentLabelBg:setString(_exp.."/"..equip_machine[tostring(startlevel+1)].needexp)
    -- persentLabel:setString(_exp.."/"..equip_machine[tostring(startlevel+1)].needexp)
    -- progress:setPercentage(_exp / equip_machine[tostring(startlevel+1)].needexp * 100)
    -- refreshData()
    -- Table1OffsetY = _tableView:getContentOffset().y
    -- _tableView:reloadData()
    -- _tableView:setContentOffset(ccp(0, Table1OffsetY))
--     _layer:removeFromParentAndCleanup(true)
 end
 DailyComposeUpdataViewOwner["canceClick"] = canceClick

local function confirmClick()
    local function updateCallBack(url, rtnData)
        if rtnData["code"] == 200 then
            if templevel > _composeMachine.level then
                ShowText( HLNSLocalizedString("daily.DC.composeMachineSuccess") )  --"合成器升级成功"
            else
                ShowText( HLNSLocalizedString("daily.DC.composeMachineNotSuccess") )  --"合成器还未升级，请继续放入材料。"
            end
            cacheExpAll = 0
            array = {}
        end
    end
    local tempArray = {}
    table.insert(tempArray, array)
    doActionFun("UPMACHINE", tempArray, updateCallBack)
end
DailyComposeUpdataViewOwner["confirmClick"] = confirmClick

local function updateContentInfo()
    
    centerLvLabel:setString(templevel)
    persentLabelBg:setString(_exp.."/"..nextEXP)
    persentLabel:setString(_exp.."/"..nextEXP)

    progress:stopAllActions()
    local actionArray = CCArray:create()
    local changeLabel = templevel - startlevel
    if changeLabel > 0 then
        actionArray:addObject(CCProgressFromTo:create(1 / (changeLabel + 2), progress:getPercentage(), 100))
        if changeLabel > 1 then
            for i=2,changeLabel do
                actionArray:addObject(CCProgressFromTo:create(1 / (changeLabel + 2), 0, 100))
            end
        end
        actionArray:addObject(CCProgressFromTo:create(1 / (changeLabel + 2), 0, (_exp / nextEXP) * 100))
    else
        actionArray:addObject(CCProgressFromTo:create(0.5, progress:getPercentage(), (_exp / nextEXP) * 100))
    end
    local function setPercentageZero()
        currentPersent = 0 
    end
    actionArray:addObject(CCCallFunc:create(setPercentageZero))

    currentPersent = (_exp / nextEXP) * 100
    progress:runAction(CCSequence:create(actionArray))

    startlevel = templevel
end

local function onItemTaped(tag, sender)
    
    if _stuffCount[tag] > 0 then
        
        _stuffCount[tag] = _stuffCount[tag] - 1
        local itemId = itemDic[tag].id
        
        array[itemId] = stuffCount[tag] - _stuffCount[tag]
        cacheExpAll = cacheExpAll + ConfigureStorage.equip_exp[tostring(tag)].exp
        local exp = cacheExpAll + ExpAll
        templevel = _composeMachine.level
        local level = templevel

        if equip_machine[tostring(level + 1)] then
            while exp >= equip_machine[tostring(level + 1)].needexp do
                local upExp = equip_machine[tostring(level + 1)].needexp
                exp = exp - upExp
                level = level + 1
                if not equip_machine[tostring(level + 1)] then
                    break
                end
            end
        end
        
        _exp = exp
        templevel = level
        nextEXP = equip_machine[tostring(templevel + 1)].needexp
        updateContentInfo()
        if _stuffCount[tag] == 0 then
            _stuffCount[tag] = 0
        end
        Table1OffsetY = _tableView:getContentOffset().y
        _tableView:reloadData()
        _tableView:setContentOffset(ccp(0, Table1OffsetY))
        
    else
        ShowText(HLNSLocalizedString("您的仓库里没有此材料，去起航\n闯关可以有机会获得喔！"))
    end
end

DailyComposeUpdataCellOwner["onItemTaped"] = onItemTaped


local function _addTableView()
    if not dic then
        return
    end
    local width  = _contentLayer:getContentSize().width 
    local height = _contentLayer:getContentSize().height 
    
    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(  width , height * 0.5 )
        elseif fn == "cellAtIndex" then
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            
            local proxy = CCBProxy:create()
            local _hbCell = tolua.cast(CCBReaderLoad("ccbResources/DailyComposeUpdataCell.ccbi", proxy, true, 
                "DailyComposeUpdataCellOwner"), "CCLayer")

            local function setCellMenuPriority(sender)
                if sender then
                    local menu = tolua.cast(sender, "CCMenu")
                    menu:setHandlerPriority(_priority - 2)
                end
            end

            local menu = DailyComposeUpdataCellOwner["menu"]
            local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCCallFuncN:create(setCellMenuPriority))
            menu:runAction(seq)

            for i=1,2 do
                local item = tolua.cast(DailyComposeUpdataCellOwner[string.format("item%d", i)], "CCMenuItemImage")
                local nameLabel = tolua.cast(DailyComposeUpdataCellOwner[string.format("nameLabel%d", i)], "CCLabelTTF")
                local itemsprite = tolua.cast(DailyComposeUpdataCellOwner["itemsprite" .. i], "CCSprite")
                local countLabel = tolua.cast(DailyComposeUpdataCellOwner[string.format("countLabel%d", i)], "CCLabelTTF")
                local shadowLayer = tolua.cast(DailyComposeUpdataCellOwner["shadowLayer" .. i], "CCLayer")
                if a1 * 2 + i <= getMyTableCount(_compoundItems) then
                    local itemContent = itemDic[a1 * 2 + i]
                    local count = _stuffCount[a1 * 2 + i]
                    item:setTag(a1 * 2 + i)
                    local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
                    item:setNormalSpriteFrame(cache:spriteFrameByName(string.format("frame_%d.png", itemContent.rank)))
                    item:setSelectedSpriteFrame(cache:spriteFrameByName(string.format("frame_%d.png", itemContent.rank)))
                    nameLabel:setString(itemContent["name"])
                    local texture = CCTextureCache:sharedTextureCache():addImage(string.format("icons/%s.png",itemContent.icon))
                    itemsprite:setTexture(texture)
                    itemsprite:setVisible(true)
                    
                    if itemContent.rank == 4  then
                        HLAddParticleScale( "images/purpleEquip.plist", itemsprite, ccp(itemsprite:getContentSize().width / 2,
                            itemsprite:getContentSize().height / 2), 1, 100, 777, 2 / 0.35 / retina, 2 / 0.35 / retina, 1 )
                    elseif itemContent.rank == 5 then
                        HLAddParticleScale( "images/goldEquip.plist", itemsprite, ccp(itemsprite:getContentSize().width / 2,
                            itemsprite:getContentSize().height / 2), 1, 100, 777, 2 / 0.35 / retina, 2 / 0.35 / retina, 1 )
                    end
                    countLabel:setString( "x" .. tostring(count))
                    if count > 999999 then
                        countLabel:setString("x999999+")
                    end
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
                    itemsprite:setVisible(false)
                    countLabel:setVisible(false)
                end
            end
            
            a2:addChild(_hbCell, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            r = a2
        elseif fn == "numberOfCells" then
            r = math.ceil(getMyTableCount(_compoundItems) / 2)
        elseif fn == "cellTouched" then         -- A cell was touched, a1 is cell that be touched. This is not necessary.
        elseif fn == "cellTouchBegan" then      -- A cell is touching, a1 is cell, a2 is CCTouch
        elseif fn == "cellTouchEnded" then      -- A cell was touched, a1 is cell, a2 is CCTouch
        elseif fn == "cellHighlight" then       -- A cell is highlighting, coco2d-x 2.1.3 or above
        elseif fn == "cellUnhighlight" then     -- A cell had been unhighlighted, coco2d-x 2.1.3 or above
        elseif fn == "cellWillRecycle" then     -- A cell will be recycled, coco2d-x 2.1.3 or above
        end
        return r
    end)
    local size = CCSizeMake( width, height)  -- 这里是为了在tableview上面显示一个小空出来
    _tableView = LuaTableView:createWithHandler(h, size)
    _tableView:setBounceable(true)
    _tableView:setAnchorPoint(ccp(0,0))
    _tableView:setPosition(0,0)
    _tableView:setVerticalFillOrder(0)
    _contentLayer:addChild(_tableView,1000)
    _tableView:reloadData()
    _tableView:reloadData()
end

local function refresh()
    
end

local function refreshData()
    for i=1, getMyTableCount(_compoundItems) do
        local costStuff = _compoundItems[i]
        local stuffItemId = dic[costStuff].itemId
        itemDic[i] = wareHouseData:getItemConfig(stuffItemId)
        stuffCount[i] = wareHouseData:getItemCountById(stuffItemId)
    end
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    equip_machine = ConfigureStorage.equip_machine
    dic = ConfigureStorage.equip_compoundItems
    
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/DailyComposeUpdata.ccbi",proxy, true,"DailyComposeUpdataViewOwner")
    _layer = tolua.cast(node,"CCLayer")

    _contentLayer  = tolua.cast(DailyComposeUpdataViewOwner["tableViewContentView"], "CCLayer")

    -- 工匠-合成器升级经验条
    local progressBg = tolua.cast(DailyComposeUpdataViewOwner["progressBg"], "CCSprite")
    progressBg:setVisible(true)

    progress = CCProgressTimer:create(CCSprite:create("images/blueBattleShip.png"))
    progress:setType(kCCProgressTimerTypeBar)
    progress:setMidpoint(CCPointMake(0, 0))
    progress:setScaleX(0.87)
    progress:setBarChangeRate(CCPointMake(1, 0))
    
    progressBg:addChild(progress,0)
    progress:setRotation(-90)
    progress:setPosition(ccp(progressBg:getContentSize().width / 2.07, progressBg:getContentSize().height / 2.29))

    centerLvLabel = tolua.cast(DailyComposeUpdataViewOwner["centerLvLabel"], "CCLabelTTF")
    centerLvLabel:setString(_composeMachine.level)
    persentLabelBg = tolua.cast(DailyComposeUpdataViewOwner["persentLabelBg"], "CCLabelTTF")
    persentLabel = tolua.cast(DailyComposeUpdataViewOwner["persentLabel"], "CCLabelTTF")
    startlevel = _composeMachine.level
    startExpAll = _composeMachine.expAll

    if startlevel > 1 then
        for i=1,startlevel - 1 do
            ExpAll = startExpAll - equip_machine[tostring(i)].needexp
        end
    else
        ExpAll = startExpAll
    end
    local needexp
    if startlevel == getMyTableCount(equip_machine) then
        ExpAll = 0
        needexp = 0
    else
        needexp = equip_machine[tostring(startlevel+1)].needexp
    end
    persentLabelBg:setString(ExpAll.."/"..needexp)
    persentLabel:setString(ExpAll.."/"..needexp)
    progress:setPercentage(ExpAll / needexp * 100)

    refreshData()
    _stuffCount = deepcopy(stuffCount)
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(DailyComposeUpdataViewOwner["infoBg"], "CCSprite")
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
    local menu1 = tolua.cast(DailyComposeUpdataViewOwner["closeMenu"], "CCMenu")
    menu1:setHandlerPriority(_priority - 1)
    _tableView:setTouchPriority(_priority - 2)
end

-- 该方法名字每个文件不要重复
function getComposeUpdataLayer()
	return _layer
end

function createComposeUpdataLayer( composeMachine,priority )

    _composeMachine = composeMachine
    
    _priority = (priority ~= nil) and priority or -132
    _init()

    local function _onEnter()
        _addTableView()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)

        popUpUiAction( DailyComposeUpdataViewOwner,"infoBg" )
    end

    local function _onExit()
        _layer = nil
        _priority = -132
        _composeMachine = nil
        equip_machine = nil
        _tableView = nil
        _contentLayer = {}
        startExpAll = nil
        startlevel = nil 
        ExpAll = nil
        array = {}
        dic = nil
        soulBtnState = {}
        _exp = nil
        _stuffCount = {}
        stuffCount = {}
        cacheExpAll = 0
        --persentLabelBg = nil
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