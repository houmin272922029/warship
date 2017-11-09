local _layer
local AllEquipsData
local selectState
local sellIdArrays = {}
local selectBtnArray = {}
local _tableView
local _type
local cellArray = {}

-- ·名字不要重复
EquipSellLayerOwner = EquipSellLayerOwner or {}
ccb["EquipSellLayerOwner"] = EquipSellLayerOwner

EquipSellSelectCellOwner = EquipSellSelectCellOwner or {}
ccb["EquipSellSelectCellOwner"] = EquipSellSelectCellOwner

local function updataBtnState( bool1,bool2,bool3 )
    local quitBtn = EquipSellLayerOwner["quitBtn"]  --放弃按钮
    local giveupLabel = EquipSellLayerOwner["giveupLabel"]
    local exitLable = EquipSellLayerOwner["exitLable"]
    local confirLabel = EquipSellLayerOwner["confirLabel"]
    local confirmBtn = EquipSellLayerOwner["confirmBtn"]
    local exitBtn = EquipSellLayerOwner["exitBtn"]
    quitBtn:setVisible(bool1)
    giveupLabel:setVisible(bool1)
    confirmBtn:setVisible(bool2)
    confirLabel:setVisible(bool2)
    exitBtn:setVisible(bool3)
    exitLable:setVisible(bool3)
end

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

local function quitBtnClicked(  )
    sellIdArrays = {}
    selectState = {}
    updataBtnState(false,false,true)
    local offsetY = _tableView:getContentOffset().y
    _tableView:reloadData()
    _tableView:setContentOffset(ccp(0, offsetY))
end

local function sellConfirmCallBack( url,rtnData )
    if rtnData["code"] == 200 then
        sellIdArrays = {}
        selectState = {}
        updataBtnState(false,false,true)

        if _type == EquipSellType.AllEquip then
            AllEquipsData = equipdata:getCanSellAllEquipData(  )
        elseif _type == EquipSellType.Weapons then
            AllEquipsData = equipdata:getCanSellAllWeaponsData(  )
        elseif _type == EquipSellType.Clothing then
            AllEquipsData = equipdata:getCanSellAllArmorData(  )
        elseif _type == EquipSellType.Decoration then
            AllEquipsData = equipdata:getCanSellAllBeltData(  )
        elseif _type == EquipSellType.Rune then
            AllEquipsData = equipdata:getCanSellAllRuneData(  )
        end
        _tableView:reloadData()
    end
end

local function confirmBtnClicked(  )
    print("点击了确认")
    local array = {}
    for key,value in pairs(sellIdArrays) do
        if value then
            table.insert(array,value)
        end
    end
    doActionFun("SELL_EQUIP_URL", { array }, sellConfirmCallBack)
end

local function exitBtnClicked(  )
    print("点击了退出按钮")
    if getMainLayer() then
        getMainLayer():gotoEquipmentsLayer()
    end
end

EquipSellLayerOwner["quitBtnClicked"] = quitBtnClicked
EquipSellLayerOwner["confirmBtnClicked"] = confirmBtnClicked
EquipSellLayerOwner["exitBtnClicked"] = exitBtnClicked

local function _addTableView()
    -- 得到数据
    local _topLayer = EquipSellLayerOwner["EQTopLayer"]
    
    if _type == EquipSellType.AllEquip then
        AllEquipsData = equipdata:getCanSellAllEquipData(  )
    elseif _type == EquipSellType.Weapons then
        AllEquipsData = equipdata:getCanSellAllWeaponsData(  )
    elseif _type == EquipSellType.Clothing then
        AllEquipsData = equipdata:getCanSellAllArmorData(  )
    elseif _type == EquipSellType.Decoration then
        AllEquipsData = equipdata:getCanSellAllBeltData(  )
    elseif _type == EquipSellType.Rune then
            AllEquipsData = equipdata:getCanSellAllRuneData(  )
    end
    -- EquipSellSelectCellOwner["onSelectBtnTap"] = onSelectBtnTap
    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(winSize.width, 190 * retina)
        elseif fn == "cellAtIndex" then
            -- Return CCTableViewCell, a1 is cell index (zero based), a2 is dequeued cell (maybe nil)
            -- Do something to create cell  and change the content
            
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
            local  _hbCell = tolua.cast(CCBReaderLoad("ccbResources/EquipmentsCellSelectTableCell.ccbi",proxy,true,"EquipSellSelectCellOwner"),"CCLayer")

            local selectBtn = tolua.cast(EquipSellSelectCellOwner["selectBtn"],"CCMenuItemImage")

            selectBtn:setTag(a1)

            local cellBg = tolua.cast(EquipSellSelectCellOwner["cellBg"],"CCSprite")

            if selectState[a1 + 1] and selectState[a1 + 1] == 1 then
                updataSelectBtnState(selectBtn,true)
                cellBg:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("equipCellSelBg.png"))
            else
                updataSelectBtnState(selectBtn,false)
                cellBg:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("equipCellBg.png"))
            end

            local nameLabel = tolua.cast(EquipSellSelectCellOwner["nameLabel"],"CCLabelTTF")
            nameLabel:setString(equipContent.name)
            nameLabel:enableShadow(CCSizeMake(2,-2), 1, 0)

            local ownerLabel = tolua.cast(EquipSellSelectCellOwner["ownerLabel"],"CCLabelTTF")
            local owner = equipContent["owner"]
            if owner then
                ownerLabel:setString(string.format(HLNSLocalizedString("装备于%s"),owner))
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

            -- 符文标签
            local runeSprite = tolua.cast(EquipSellSelectCellOwner["runeSprite"], "CCSprite")
            if equipContent.nature and tonumber(equipContent.nature)>0 then
                runeSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("nature_%d.png",equipContent.nature)))
                runeSprite:setVisible(true)
            else
                runeSprite:setVisible(false)
            end

            -- 合成等级
            local composeLevel = tolua.cast(EquipSellSelectCellOwner["composeLevel"], "CCSprite")
            if equipContent.composeLevel then
                composeLevel:setVisible(true)
                if equipContent.composeLevel == -1 then
                    composeLevel:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("m_level_max.png"))
                elseif equipContent.composeLevel == 0 then
                    composeLevel:setVisible(false)
                else
                    composeLevel:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("m_level_%d.png",equipContent.composeLevel)))
                end
            end
            
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

            local attrSprite = tolua.cast(EquipSellSelectCellOwner["attrSprite"],"CCSprite")
            attrSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(equipdata:getDisplayFrameByType(equipdata:getEquipAttrType(equipContent.id))))
            
            local attrLabel = tolua.cast(EquipSellSelectCellOwner["attrLabel"],"CCLabelTTF")
            attrLabel:setString(string.format("+%d",equipdata:getEquipAttrValue( equipContent.id )))

            
            local valueLabel = tolua.cast(EquipSellSelectCellOwner["valueLabel"],"CCLabelTTF")
            valueLabel:setString(equipdata:getEquipValue( uniqueId ))

            _hbCell:setScale(retina)
            a2:addChild(_hbCell, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            _hbCell:stopAllActions()
            a2:setPosition(0, 0)
            cellArray[tostring(a1)] = _hbCell
            r = a2
        elseif fn == "numberOfCells" then
            -- Return number of cells
            -- r = 5
            r = getMyTableCount(AllEquipsData)
        -- Cell events:
        elseif fn == "cellTouched" then         -- A cell was touched, a1 is cell that be touched. This is not necessary.

            local tag = a1:getIdx()
            local content = AllEquipsData[tag + 1]
                if selectState[tag + 1] == 1 then
                    selectState[tag+ 1] = 0
                    sellIdArrays[content.id] = nil
                else
                    if tonumber(content.equip["rank"]) >= 3 then
                        local function cardConfirmAction(  )
                            selectState[tag + 1] = 1
                            sellIdArrays[content.id] = content.id
                            local offsetY = _tableView:getContentOffset().y
                            _tableView:reloadData()
                            _tableView:setContentOffset(ccp(0, offsetY))
                            if getMyTableCount(sellIdArrays) > 0 then
                                updataBtnState(true,true,false)
                            else
                                updataBtnState(false,false,true)
                            end 
                        end
                        local function cardCancelAction(  )
                            
                        end

                        _layer:addChild(createSimpleConfirCardLayer(HLNSLocalizedString("船长，您选择了A级以上的装备出售，舍得吗？")))

                        SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
                        SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction
                    else
                        selectState[tag + 1] = 1
                        sellIdArrays[content.id] = content.id
                    end
                end
                local offsetY = _tableView:getContentOffset().y
                _tableView:reloadData()
                _tableView:setContentOffset(ccp(0, offsetY))
                if getMyTableCount(sellIdArrays) > 0 then
                    updataBtnState(true,true,false)
                else
                    updataBtnState(false,false,true)
                end 
            -- end 
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
        local size = CCSizeMake(winSize.width, (winSize.height - _topLayer:getContentSize().height - _mainLayer:getBottomContentSize().height)*99/100)  -- 这里是为了在tableview上面显示一个小空出来
        print(size.width.." "..size.height)
        _tableView = LuaTableView:createWithHandler(h, size)
        _tableView:setBounceable(true)
        _tableView:setAnchorPoint(ccp(0,0))
        _tableView:setPosition(0,_mainLayer:getBottomContentSize().height)
        _tableView:setVerticalFillOrder(0)
        _layer:addChild(_tableView)
    end
end

local function setMenuPriority()
    local topMenu = tolua.cast(EquipSellLayerOwner["topMenu"],"CCMenu")
    -- topMenu:setVisible(false)
    topMenu:setHandlerPriority(-136)
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/EquipSellView.ccbi",proxy, true,"EquipSellLayerOwner")
    _layer = tolua.cast(node,"CCLayer")
end


-- 该方法名字每个文件不要重复
function getEquipSellLayer()
	return _layer
end

function createEquipSellLayer(type)
    _type = type
    _init()

	-- public方法写在每个layer的创建的方法内 调用时方法
	-- local layer = getLayer()
	-- layer:refresh()

	function _layer:refresh()
		
	end

    local function _onEnter()
        print("onEnter")
        cellArray = {}
        sellIdArrays = {}
        selectState = {}
        selectBtnArray = {}
        updataBtnState(false,false,true)
        _addTableView()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
        generateCellAction( cellArray,getMyTableCount(AllEquipsData) )
        cellArray = {}
    end

    local function _onExit()
        print("onExit")
        _layer = nil
        AllEquipsData = nil
        selectState = nil
        sellIdArrays = nil
        cellArray = {}
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