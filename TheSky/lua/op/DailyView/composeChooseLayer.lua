--林绍峰  
--装备的合成  选择装备
local _layer
local _priority
local _contentLayer 

local AllEquipsData = {}
local selectState = {}  --暂时没用到
local sellIdArrays = {} --暂时没用到
local sellIdArrays2 = {} --暂时没用到
local _selected = -1

local _tableView
local cellArray = {} --暂时没用到 做进入动画用的
local _compoundItems = {
    "whitecost",
    "greencost",
    "bluecost",
    "purplecost",
    "purplecostes",
}
local _lackingItems = {}  --所缺的材料
local _equipInCool = {} --冷却中的装备
--以上数据在结尾_onExit都已得到处理 

DailyComposeChooseViewOwner = DailyComposeChooseViewOwner or {}
ccb["DailyComposeChooseViewOwner"] = DailyComposeChooseViewOwner


local function closeItemClick()
    print("closeItemClick1")
    popUpCloseAction(DailyComposeChooseViewOwner, "infoBg", _layer )
end
DailyComposeChooseViewOwner["closeItemClick"] = closeItemClick

local function confirmItemClick(tag)
    if _selected == -1 then
        --您还未选择
        ShowText( HLNSLocalizedString("daily.DC.haventChoose") )
    else
        if _equipInCool[_selected] then 
            ShowText( HLNSLocalizedString("composeEquipments.inCD") )
        else
            if getMainLayer() then
                --所需材料
                local equipContent = AllEquipsData[_selected + 1]
                getMainLayer():addChild(createComposeNeedLayer(-142,equipContent), 100) --第二个弹窗 装备合成所需材料
            end 
        end
    end
end
DailyComposeChooseViewOwner["confirmItemClick"] = confirmItemClick


local function cancelItemClick(tag) --
    popUpCloseAction(DailyComposeChooseViewOwner, "infoBg", _layer )
end
DailyComposeChooseViewOwner["cancelItemClick"] = cancelItemClick


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
            print("**lsf a1",a1)
            local equipContent = AllEquipsData[a1 + 1]
            local  proxy = CCBProxy:create()
            local  _hbCell = tolua.cast(CCBReaderLoad("ccbResources/DailyDecomposeChooseCell.ccbi",proxy,true,"EquipSellSelectCellOwner"),"CCLayer")
            local owner = EquipSellSelectCellOwner
            local selectBtn = tolua.cast(owner["selectBtn"],"CCMenuItemImage")

            selectBtn:setTag(a1)
            local cellBg = tolua.cast(owner["cellBg"],"CCSprite")
         
            if a1 == _selected then
                updataSelectBtnState(selectBtn,true)
                cellBg:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("equipCellSelBg.png"))
            end

            local nameLabel = tolua.cast(owner["nameLabel"],"CCLabelTTF")
            nameLabel:setString(equipContent.name)
            nameLabel:enableShadow(CCSizeMake(2,-2), 1, 0)

            local ownerLabel = tolua.cast(owner["ownerLabel"],"CCLabelTTF")
            ownerLabel:setVisible(false)

            local stageSprite = tolua.cast(owner["stageSprite"],"CCSprite")
            stageSprite:setVisible(false)
            
            local levelLabel = tolua.cast(owner["levelLabel"],"CCLabelTTF")
            levelLabel:setString("1")

            local lvLabel = tolua.cast(owner["lvLabel"],"CCLabelTTF")
            lvLabel:setString("LV")
            lvLabel:enableShadow(CCSizeMake(2,-2), 1, 0)

            local rankFrame = tolua.cast(owner["rankFrame"],"CCSprite")
            rankFrame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", equipContent.rank)))
            
            local avatarSprite = tolua.cast(owner["avatarSprite"],"CCSprite")
            if avatarSprite then
                local texture = CCTextureCache:sharedTextureCache():addImage(equipdata:getEquipIconByEquipId( equipContent.icon ))
                if texture then
                    avatarSprite:setVisible(true)
                    avatarSprite:setTexture(texture)
                end  
            end

            local rankSprite = tolua.cast(owner["rankSprite"],"CCSprite")
            rankSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("rank_%d_icon.png", equipContent.rank)))

            -- 装备新添加了符文标签
            local runeSprite = tolua.cast(owner["runeSprite"], "CCSprite")
            if equipContent.nature and tonumber(equipContent.nature)>0 then
                runeSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("nature_%d.png",equipContent.nature)))
                runeSprite:setVisible(true)
            elseif equipContent.equip and equipContent.equip.nature and tonumber(equipContent.equip.nature)>0 then
                runeSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("nature_%d.png",equipContent.equip.nature)))
                runeSprite:setVisible(true)
            else
                runeSprite:setVisible(false)
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

            local equipAttrType -- atk or def?
            local equipAttrValue -- 装备数值 如 神官长袍 "def": 64  即 +防御64 
            for key,value in pairs(equipContent.initial) do
                equipAttrType = key 
                equipAttrValue = value
            end

            local attrSprite = tolua.cast(owner["attrSprite"],"CCSprite")
            attrSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(
                equipdata:getDisplayFrameByType( equipAttrType )))
            
            local attrLabel = tolua.cast(owner["attrLabel"],"CCLabelTTF")
            attrLabel:setString(string.format("+%d",equipAttrValue))

            local valueLabel = tolua.cast(owner["valueLabel"],"CCLabelTTF")
            valueLabel:setString( equipContent.silver )

            _lackingItems = {}
            -- 判断是否缺少材料 判断是否显示 "材料不足"
            local composeNeeds = ConfigureStorage.equip_made[equipContent.id] --所需材料的所有数据  形如{ "greencost": 12, "money": 10000, "wastes": 24, "whitecost": 45 },
            local dic = ConfigureStorage.equip_compoundItems --data is like {"greencost": { "itemId":"item_001"},"bluecost": { "itemId":"item_001" },}
            for i=1, getMyTableCount(_compoundItems) do  -- 遍历白绿蓝紫紫加5种类型,如果所需材料中有  放进costStuffArray中 用于tableView显示
                if composeNeeds[_compoundItems[i]] then  -- 当i=1时 意思就是如果需要白色材料 
                    local itemId = dic[_compoundItems[i]].itemId
                    if wareHouseData:getItemCountById( itemId ) < composeNeeds[_compoundItems[i]] then  --如果仓库里的材料数量小于所需数量
                        _lackingItems[_compoundItems[i]] = 1 --物品名称放入 匮乏数组 中
                    end

                end  
            end
            local itemLacked = tolua.cast(owner["itemLacked"],"CCLabelTTF")  --"材料不足" 字样
            -- print("**lsf _lackingItems count",getMyTableCount(_lackingItems))
            if getMyTableCount(_lackingItems) > 0 or userdata.berry < composeNeeds.money then  --匮乏数组大于0 或者没钱
                itemLacked:setVisible(true)
                if getMyTableCount(_lackingItems) > 0 then --如果是材料不足或者二者皆不足 显示材料不足
                    itemLacked:setString( HLNSLocalizedString("daily.DC.itemLacked") )  --"材料不足"
                else 
                    itemLacked:setString( HLNSLocalizedString("daily.DC.berryLacked")  ) -- "贝里不足"
                end
            else 
                itemLacked:setVisible(false)
            end

            local inCoolDown = tolua.cast(owner["inCoolDown"],"CCLabelTTF")
            local equipCool = dailyData.daily.compose.compoundEquip  --装备的冷却时间
            print("**lsf equipCool in choose ")
            PrintTable(equipCool)
            
            if equipCool and equipCool[equipContent.id] then --该装备带有冷却时间数据块
                local equipCoolData  = equipCool[equipContent.id]
                
                local durTime  = os.time() - equipCoolData.lastTime  --从玩家合成该装备到现在的持续时间 秒数
                local restTime = composeNeeds.wastes - math.floor(durTime/3600 )   -- 剩余冷却时间
                print("**lsf os.time lastTime durTime",os.time(),equipCoolData.lastTime,durTime)
                print("**lsf composeNeeds.wastes  durTime2 restTime", composeNeeds.wastes ,math.floor(durTime/3600 ) , restTime)

                if restTime > 0 then  -- 冷却时间大于0
                    _equipInCool[a1] = 1 
                    inCoolDown:setVisible(true)
                    inCoolDown:setString( HLNSLocalizedString("daily.DC.inCoolDownRestTime",restTime) )   --"剩余冷却:%d小时",

                else
                    inCoolDown:setVisible(false)
                end
                
            else
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
    local infoBg = tolua.cast(DailyComposeChooseViewOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction(DailyComposeChooseViewOwner, "infoBg", _layer)
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
    local menu = tolua.cast(DailyComposeChooseViewOwner["menu"], "CCMenu")
    menu:setTouchPriority(_priority - 2)
   _tableView:setTouchPriority(_priority - 2)
 
end

function getDailyComposeChooseLayer()
    return _layer
end


local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/DailyDrinkChoseHeroView.ccbi",proxy, true,"DailyComposeChooseViewOwner")
    _layer = tolua.cast(node,"CCLayer")
    _contentLayer = tolua.cast(DailyComposeChooseViewOwner["contentLayer"], "CCLayer")

    
    -- 得到数据
    local desc = ConfigureStorage.equip_made
    print(" xiangqing")
    PrintTable(ConfigureStorage.equip_made)
    PrintTable(ConfigureStorage.equip_compoundItems)
    print("**lsf AllEquipsData")
    --local  equipsData 
    for k,v in pairs(desc) do
        local  conf = equipdata:getEquipConfig( k ) 
        if conf then
            table.insert(AllEquipsData,conf)
        end
    end
    
    local function sortFun(a, b) 
        if (a.silver and b.silver) then
            return a.silver  < b.silver
        end
    end
    table.sort( AllEquipsData, sortFun )
    PrintTable(AllEquipsData)

    print("**lsf heroData")

end


function createComposeChooseLayer(priority) --priority -140
    
    if not ConfigureStorage.equip_made  or not ConfigureStorage.equip_compoundItems then
        ShowText("ConfigureStorage info error\n后台配置错误")
        print("lsf error:fail to get ConfigureStorage.equip_made or ConfigureStorage.equip_compoundItems")
        return
    end

    _priority = (priority ~= nil) and priority or -140
    _init()
    function _layer:confirmItemClick()
        confirmItemClick() 
    end

    local function _onEnter()
        print("ComposeChooseLayer onEnter")

        sellIdArrays = {}
        sellIdArrays2 = {}
        selectState = {}   
        _addTableView()     
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
        popUpUiAction(DailyComposeChooseViewOwner, "infoBg")
        
    end

    local function _onExit()
        print("ComposeChooseLayer onExit")
        _layer = nil
        _tableView = nil
        AllEquipsData = {}
        selectState = {}
        sellIdArrays = {}
        sellIdArrays2 = {}
        _selected = -1
        _lackingItems = {} 
        _equipInCool = {}
       
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

 