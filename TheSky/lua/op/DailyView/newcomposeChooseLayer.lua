--林绍峰  
--装备的分解  选择装备
local _layer
local _priority
local _contentLayer 

local AllEquipsData = {}
local selectState = {} 
local sellIdArrays = {}
local sellIdArrays2 = {}

local _tableView
local cellArray = {} --暂时没用
--以上数据在结尾_onExit都已得到处理

DailyDecomposeChooseViewOwner = DailyDecomposeChooseViewOwner or {}
ccb["DailyDecomposeChooseViewOwner"] = DailyDecomposeChooseViewOwner


local function closeItemClick()
    print("closeItemClick1")
    popUpCloseAction(DailyDecomposeChooseViewOwner, "infoBg", _layer )
end
DailyDecomposeChooseViewOwner["closeItemClick"] = closeItemClick

local function confirmItemClick(tag)
    if getMyTableCount(sellIdArrays) ==0 then
        --您还未选择
        ShowText( HLNSLocalizedString("daily.DC.haventChoose") )
    else
        local haveA  = 0 
        for k,v in pairs(sellIdArrays2) do
            if v.equip["rank"] >=3 then
                haveA  = 1
                local function cardConfirmAction(  )
                    getDecomposeAndComposeLayer():decomposeChooseFinished( sellIdArrays2)
                    popUpCloseAction(DailyDecomposeChooseViewOwner, "infoBg", _layer )
                end
                local function cardCancelAction(  )

                end
                --船长，您选择了A级以上的装备，确定吗？
                getMainLayer():getParent():addChild(createSimpleConfirCardLayer(HLNSLocalizedString("daily.DC.sureChooseA")))

                SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
                SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction
                print("lsf1")
                break
            end
            print("lsf2")
        end

        if haveA  == 0 then --没有A以上的装备
            getDecomposeAndComposeLayer():decomposeChooseFinished( sellIdArrays2)
            popUpCloseAction(DailyDecomposeChooseViewOwner, "infoBg", _layer )
        end
        
    end
end
DailyDecomposeChooseViewOwner["confirmItemClick"] = confirmItemClick


local function cancelItemClick(tag) --
    popUpCloseAction(DailyDecomposeChooseViewOwner, "infoBg", _layer )
end
DailyDecomposeChooseViewOwner["cancelItemClick"] = cancelItemClick


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

    AllEquipsData = equipdata:getAllEquipData(  )
    local equipsData1 = {}
    local count1 = getMyTableCount(AllEquipsData)
    for i=1,count1 do
        equipsData1[count1+1-i] = AllEquipsData[i]
    end
    AllEquipsData = equipsData1
    
    -- EquipSellSelectCellOwner["onSelectBtnTap"] = onSelectBtnTap
    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake( 626 , 186)
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
            local  _hbCell = tolua.cast(CCBReaderLoad("ccbResources/DailyDecomposeChooseCell.ccbi",proxy,true,"EquipSellSelectCellOwner"),"CCLayer")

            local selectBtn = tolua.cast(EquipSellSelectCellOwner["selectBtn"],"CCMenuItemImage")

            selectBtn:setTag(a1)

            local cellBg = tolua.cast(EquipSellSelectCellOwner["cellBg"],"CCSprite")
            
            if selectState  then
                print("**lsf selectState[a1 + 1] ",a1+1, selectState[a1 + 1] )
            end
            if selectState[a1 + 1]  then
                if  selectState[a1 + 1] == 1 then
                updataSelectBtnState(selectBtn,true)
                cellBg:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("equipCellSelBg.png"))
                else
                    updataSelectBtnState(selectBtn,false)
                    cellBg:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("equipCellBg.png"))
                end
            end

            local nameLabel = tolua.cast(EquipSellSelectCellOwner["nameLabel"],"CCLabelTTF")
            nameLabel:setString(equipContent.name)
            nameLabel:enableShadow(CCSizeMake(2,-2), 1, 0)

            local ownerLabel = tolua.cast(EquipSellSelectCellOwner["ownerLabel"],"CCLabelTTF")
            local owner = equipContent["owner"]
            if owner then
                --print("**lsf owner",owner)
                --PrintTable(owner)
                --ownerLabel:setString(string.format(HLNSLocalizedString("装备于%s"),owner.name))
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

             -- 装备新添加了符文标签
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
    
            _hbCell:stopAllActions()  
            a2:addChild(_hbCell, 0, 100)
            _hbCell:setAnchorPoint(ccp(0.5, 0))
            _hbCell:setPosition( _contentLayer:getContentSize().width / 2, 0)  

            
            --cellArray[tostring(a1)] = _hbCell
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
                    sellIdArrays2[content.id] = nil
                else

                    if content.owner then 
                        ----"该装备已装备于英雄,请卸下装备后再进行分解""
                        ShowText( HLNSLocalizedString("daily.DC.haveEquiped") ) --
                    else
                        selectState[tag + 1] = 1
                        sellIdArrays[content.id] = content.id
                        sellIdArrays2[content.id] = content

                    end
                end
                local offsetY = _tableView:getContentOffset().y
                _tableView:reloadData()
                _tableView:setContentOffset(ccp(0, offsetY))
                if getMyTableCount(sellIdArrays) > 0 then
                    --updataBtnState(true,true,false)
                else
                    --updataBtnState(false,false,true)
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
    local infoBg = tolua.cast(DailyDecomposeChooseViewOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction(DailyDecomposeChooseViewOwner, "infoBg", _layer)
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
    local menu = tolua.cast(DailyDecomposeChooseViewOwner["menu"], "CCMenu")
    menu:setTouchPriority(_priority - 2)
   _tableView:setTouchPriority(_priority - 2)
 
end

function getDailyNewComposeChooseLayer()
    return _layer
end


local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/DailyDrinkChoseHeroView.ccbi",proxy, true,"DailyDecomposeChooseViewOwner")
    _layer = tolua.cast(node,"CCLayer")
    _contentLayer = tolua.cast(DailyDecomposeChooseViewOwner["contentLayer"], "CCLayer")
    local title = tolua.cast(DailyDecomposeChooseViewOwner["title"], "CCLabelTTF")
    title:setString( HLNSLocalizedString("common.pleaseChoose-multi")  )

end


function createNewComposeChooseLayer(priority) --priority -140
    _priority = (priority ~= nil) and priority or -140
    _init()
    function _layer:confirmItemClick()
        confirmItemClick() 
    end

    local function _onEnter()
        print("newcomposeChooseLayer onEnter")

        sellIdArrays = {}
        sellIdArrays2 = {}
        selectState = {}   
        _addTableView()     
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
        popUpUiAction(DailyDecomposeChooseViewOwner, "infoBg")
        
    end

    local function _onExit()
        print("DecomposeChooseLayer onExit")
        _layer = nil
        _tableView = nil
        AllEquipsData = {}
        selectState = nil
        sellIdArrays = {} 
        sellIdArrays2 = {} 
       
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

 