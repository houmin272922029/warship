
--装备的合成  合成选择装备
local _layer
local _priority
local _contentLayer 

local AllEquipsData = {}
local _tableView
local _selected = -1
--以上数据在结尾_onExit都已得到处理 

DailyNewDecomposeChooseViewOwner = DailyNewDecomposeChooseViewOwner or {}
ccb["DailyNewDecomposeChooseViewOwner"] = DailyNewDecomposeChooseViewOwner


local function closeItemClick()
    popUpCloseAction(DailyNewDecomposeChooseViewOwner, "infoBg", _layer )
end
DailyNewDecomposeChooseViewOwner["closeItemClick"] = closeItemClick

local function confirmItemClick(tag)
    if _selected == -1 then
        --您还未选择
        ShowText( HLNSLocalizedString("daily.DC.haventChoose") )
    else
        local equipContent = AllEquipsData[_selected + 1]
        
        local function onEnterCallBack( url,rtnData )
            if rtnData["code"] == 200 then
                print("------------------------------------把一件装备放入合成机器接口")
                getDecomposeAndComposeLayer():newComposeChooseFinished(equipContent,rtnData["info"])
                popUpCloseAction(DailyNewDecomposeChooseViewOwner,"infoBg", _layer )
            end
        end

        doActionFun("INTOEQUIP",{equipContent.id},onEnterCallBack)
    end
end
DailyNewDecomposeChooseViewOwner["confirmItemClick"] = confirmItemClick

local function cancelItemClick(tag) 
    popUpCloseAction(DailyNewDecomposeChooseViewOwner, "infoBg", _layer )
end
DailyNewDecomposeChooseViewOwner["cancelItemClick"] = cancelItemClick


local function updataSelectBtnState( sender,bool )
    local sender = tolua.cast(sender,"CCMenuItemImage")
    if bool then
        sender:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("stamp3.png"))
        sender:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("stamp3.png"))
    else
        sender:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("stamp2.png"))
        sender:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("stamp3.png"))
    end
end

local function _addTableView()
    -- 得到数据
    AllEquipsData = equipdata:getASREquipData(  )
    local equipsData1 = {}
    local count1 = getMyTableCount(AllEquipsData)
    for i=1,count1 do
        equipsData1[count1+1-i] = AllEquipsData[i]
    end
    AllEquipsData = equipsData1
    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake( 626 , 186)
        elseif fn == "cellAtIndex" then
            
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            --单条数据
            local equipContent = AllEquipsData[a1 + 1]
            local uniqueId = equipContent["id"]
            local equipContent = equipdata:getEquip(uniqueId)
            local  proxy = CCBProxy:create()
            local  _hbCell = tolua.cast(CCBReaderLoad("ccbResources/DailyDecomposeChooseCell.ccbi",proxy,true,"EquipSellSelectCellOwner"),"CCLayer")

            local selectBtn = tolua.cast(EquipSellSelectCellOwner["selectBtn"],"CCMenuItemImage")

            selectBtn:setTag(a1)

            local cellBg = tolua.cast(EquipSellSelectCellOwner["cellBg"],"CCSprite")
            
            if a1 == _selected then
                updataSelectBtnState(selectBtn,true)
                cellBg:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("equipCellSelBg.png"))
            end

            local nameLabel = tolua.cast(EquipSellSelectCellOwner["nameLabel"],"CCLabelTTF")
            nameLabel:setString(equipContent.name)
            nameLabel:enableShadow(CCSizeMake(2,-2), 1, 0)

            local ownerLabel = tolua.cast(EquipSellSelectCellOwner["ownerLabel"],"CCLabelTTF")
            local owner = equipContent["owner"]
            if owner then
                ownerLabel:setVisible(true)
                ownerLabel:setString( owner.name)
            else
                ownerLabel:setVisible(false)
            end

            local stageSprite = tolua.cast(EquipSellSelectCellOwner["stageSprite"],"CCSprite")
            if tonumber(equipContent.stage) > 0 then
                stageSprite:setVisible(true)
            else
                stageSprite:setVisible(false)
            end

            local stageLabel = tolua.cast(EquipSellSelectCellOwner["stageLabel"],"CCLabelTTF")
            stageLabel:setString(equipContent.stage..HLNSLocalizedString(" 阶"))
            
            local levelLabel = tolua.cast(EquipSellSelectCellOwner["levelLabel"],"CCLabelTTF")
            levelLabel:setString(string.format("%s",equipContent.level))

            local lvLabel = tolua.cast(EquipSellSelectCellOwner["lvLabel"],"CCLabelTTF")
            lvLabel:setString("LV")
            lvLabel:enableShadow(CCSizeMake(2,-2), 1, 0)

            local rankFrame = tolua.cast(EquipSellSelectCellOwner["rankFrame"],"CCSprite")
            rankFrame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", equipContent.rank)))
            
            local avatarSprite = tolua.cast(EquipSellSelectCellOwner["avatarSprite"],"CCSprite")
            if avatarSprite then
                local texture = CCTextureCache:sharedTextureCache():addImage(equipdata:getEquipIconByEquipId( equipContent.icon ))
                if texture then
                    avatarSprite:setVisible(true)
                    avatarSprite:setTexture(texture)
                end  
            end

            local rankSprite = tolua.cast(EquipSellSelectCellOwner["rankSprite"],"CCSprite")
            rankSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("rank_%d_icon.png", equipContent.rank)))

             -- 装备-符文标签
            local runeSprite = tolua.cast(EquipSellSelectCellOwner["runeSprite"],"CCSprite")
            if equipContent.nature and tonumber(equipContent.nature)>0 then
                runeSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("nature_%d.png",equipContent.nature)))
                runeSprite:setVisible(true)
            elseif equipContent.equip and equipContent.equip.nature and tonumber(equipContent.equip.nature)>0 then
                runeSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("nature_%d.png",equipContent.equip.nature)))
                runeSprite:setVisible(true)
            else
                runeSprite:setVisible(false)
            end

            local attrSprite = tolua.cast(EquipSellSelectCellOwner["attrSprite"],"CCSprite")
            attrSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(equipdata:getDisplayFrameByType(equipdata:getEquipAttrType(equipContent.id))))
            
            local attrLabel = tolua.cast(EquipSellSelectCellOwner["attrLabel"],"CCLabelTTF")
            attrLabel:setString(string.format("+%d",equipdata:getEquipAttrValue( equipContent.id )))

            
            local valueLabel = tolua.cast(EquipSellSelectCellOwner["valueLabel"],"CCLabelTTF")
            valueLabel:setString(equipdata:getEquipValue( uniqueId ))

            local itemLacked = tolua.cast(EquipSellSelectCellOwner["itemLacked"],"CCLabelTTF") --材料不足 合成界面的东西
            local inCoolDown = tolua.cast(EquipSellSelectCellOwner["inCoolDown"],"CCLabelTTF") --冷却中 合成界面的东西
            if itemLacked and inCoolDown then
                itemLacked:setVisible(false)
                inCoolDown:setVisible(false)
            end

            -- 装备-合成等级
            local composeSprite = tolua.cast(EquipSellSelectCellOwner["composeSprite"],"CCSprite")
            if equipContent.composeLevel then
                if equipContent.composeLevel == -1 then
                    composeSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("m_level_max.png"))
                elseif equipContent.composeLevel == 0 then
                        composeSprite:setVisible(false)    
                else
                    composeSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("m_level_%d.png",equipContent.composeLevel)))
                end
            else
                composeSprite:setVisible(false)
            end
    
            _hbCell:stopAllActions()  
            a2:addChild(_hbCell, 0, 100)
            _hbCell:setAnchorPoint(ccp(0.5, 0))
            _hbCell:setPosition( _contentLayer:getContentSize().width / 2, 0)  

            r = a2
        elseif fn == "numberOfCells" then
            r = getMyTableCount(AllEquipsData)
        elseif fn == "cellTouched" then 

            _selected = _selected == a1:getIdx() and -1 or a1:getIdx()
            print("**lsf _selected" ,_selected)
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
    local infoBg = tolua.cast(DailyNewDecomposeChooseViewOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction(DailyNewDecomposeChooseViewOwner, "infoBg", _layer)
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
    local menu = tolua.cast(DailyNewDecomposeChooseViewOwner["menu"], "CCMenu")
    menu:setTouchPriority(_priority - 2)
   _tableView:setTouchPriority(_priority - 2)
end

function getDailyNewcomposeChooseLayer()
    return _layer
end

local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/DailyDrinkChoseHeroView.ccbi",proxy, true,"DailyNewDecomposeChooseViewOwner")
    _layer = tolua.cast(node,"CCLayer")
    _contentLayer = tolua.cast(DailyNewDecomposeChooseViewOwner["contentLayer"], "CCLayer")
    local title = tolua.cast(DailyNewDecomposeChooseViewOwner["title"], "CCLabelTTF")
    title:setString( HLNSLocalizedString("daily.DC.pleaseChooseCompose"))
end

function createNewcomposeChooseLayer(priority) --priority -140
    _priority = (priority ~= nil) and priority or -140
    _init()
    function _layer:confirmItemClick()
        confirmItemClick() 
    end

    local function _onEnter()
        print("NewcomposeChooseLayer onEnter")
  
        _addTableView()     
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
        popUpUiAction(DailyNewDecomposeChooseViewOwner, "infoBg")
        
    end

    local function _onExit()
        print("NewcomposeChooseLayer onExit")
        _layer = nil
        _tableView = nil
        AllEquipsData = {}
        _selected = -1
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

 