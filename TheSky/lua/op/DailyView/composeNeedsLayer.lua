
--林绍峰 
--装备的合成所需材料界面

local _layer = nil
local _priority = -132
local _tableView
local _equipContent --choose界面传过来的参数
local _unDataCount  --所需材料中非材料的东西 现在是money wastes
local _compoundItems = {
    "whitecost",
    "greencost",
    "bluecost",
    "purplecost",
    "purplecostes",
}
local _lackingItems = {}  --所缺的材料
local _containLayer --tableView所在的Layer
local composeNeeds
--以上数据在结尾_onExit都已得到处理

DailyComposeNeedViewOwner = DailyComposeNeedViewOwner or {}
ccb["DailyComposeNeedViewOwner"] = DailyComposeNeedViewOwner
local _owner = DailyComposeNeedViewOwner

local function onItemTaped( tag )

end 

local function closeItemClick()
    print("closeItemClick1")
    popUpCloseAction(_owner, "infoBg", _layer )
end
_owner["closeItemClick"] = closeItemClick

local function confirmItemClick(tag)
    print("**lsf userdata.berry composeNeeds.money",userdata.berry,composeNeeds.money)
    if getMyTableCount(_lackingItems) > 0  then
        ShowText( HLNSLocalizedString("daily.DC.lackOfCompoundItem") )  --"您的材料不足"
    elseif userdata.berry < composeNeeds.money then
        ShowText( HLNSLocalizedString("daily.DC.lackOfBerry") )  --"您的贝里不足"
    else
        getDecomposeAndComposeLayer():composeChooseFinished(_equipContent )
        popUpCloseAction(_owner, "infoBg", _layer )
        getDailyComposeChooseLayer():removeFromParentAndCleanup(true) --关闭composeChooseLayer
    end
end
_owner["confirmItemClick"] = confirmItemClick


local function cancelItemClick(tag) --
    popUpCloseAction(_owner, "infoBg", _layer )
end
_owner["cancelItemClick"] = cancelItemClick



local function _addTableView()

    local width = _containLayer:getContentSize().width

    composeNeeds = ConfigureStorage.equip_made[_equipContent.id] --所需材料的所有数据  形如{ "greencost": 12, "money": 10000, "wastes": 24, "whitecost": 45 },
    local dic = ConfigureStorage.equip_compoundItems --data is like {"greencost": { "itemId":"item_001"},"bluecost": { "itemId":"item_001" },}
    _unDataCount = getMyTableCount(composeNeeds) --先等于一共需要多少
    
    local costStuffArray = {} -- 按顺序排列的所需材料, 形如 { "greencost","bluecost"} 

    local tip = tolua.cast(_owner["tip"], "CCLabelTTF")
    tip:setString(  HLNSLocalizedString("daily.DC.yourMaterialLacking"))
    tip:setVisible(false) -- 先隐藏 "您的材料不足"
    local confirmItem = tolua.cast(_owner["confirmItem"], "CCMenuItemImage") --合成按钮

    for i=1, getMyTableCount(_compoundItems) do  -- 遍历白绿蓝紫紫加5种类型,如果所需材料中有  放进costStuffArray中 用于tableView显示
        if composeNeeds[_compoundItems[i]] then
            _unDataCount = _unDataCount - 1
            table.insert(costStuffArray,_compoundItems[i])

            local itemId = dic[_compoundItems[i]].itemId
            if wareHouseData:getItemCountById( itemId ) < composeNeeds[_compoundItems[i]] then  --如果仓库里的材料数量小于所需数量
                _lackingItems[_compoundItems[i]] = 1 --物品名称放入 匮乏数组 中
                tip:setVisible(true) --显示您的材料不足
                --制造按钮变灰
                -- if confirmItem then
                    confirmItem:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn4_2.png"))
                    confirmItem:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName( "btn4_2.png"))
                -- end
            end

        end  
    end
    local dataCount = getMyTableCount(composeNeeds)-_unDataCount  --所需材料种类数
    -- print("lsf1 ")
    --   


    local berryNeededNum = tolua.cast(_owner["berryNeededNum"], "CCLabelTTF")
    berryNeededNum:setString( tonumber(composeNeeds["money"]))
    if userdata.berry < composeNeeds.money then
        berryNeededNum:setColor(ccc3(171,33,0))
    else 
        berryNeededNum:setColor(ccc3(221,233,73))
    end

    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            local norSp = CCSprite:createWithSpriteFrameName("loginBtn2.png")
            r = CCSizeMake(width, _containLayer:getContentSize().height / 3)
        elseif fn == "cellAtIndex" then
            -- Return CCTableViewCell, a1 is cell index (zero based), a2 is dequeued cell (maybe nil)
            -- Do something to create cell  and change the content  
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
             local  _hbCell
            _hbCell = CCLayer:create()
            -- _hbCell = CCLayerColor:create(ccc4(255,0,0,255))

            _hbCell:setContentSize(CCSizeMake(width,120))
            _hbCell:setAnchorPoint(ccp(0,0))
            _hbCell:setPosition(ccp(0,0))

            local infoBg = DailyComposeNeedViewOwner["infoBg"]

            local icon3 = CCSprite:create()

            for i = 1,3 do
                if dataCount >= (a1 * 3 + i) then
                    local costStuff = costStuffArray[a1 * 3 + i]  --costStuff data like "greencost"
                    local stuffItemId = dic[costStuff].itemId 
                    local itemDic = wareHouseData:getItemConfig(stuffItemId)
                    local iconName = itemDic.icon
                    print("**lsf costStuff stuffItemId iconName" ,costStuff, stuffItemId,iconName)
                    
                    
                    local itemsConfig = ConfigureStorage.item
                    local item = itemsConfig[stuffItemId]
                    if not item then --如果配置表里没有 stuffItemId 的数据
                        item = itemsConfig["item_203"] --月饼
                        print( string.format("lsf error:fail to get %s in ConfigureStorage.item " ,stuffItemId))
                    end 
                    PrintTable(item)
                    
                    local frame = CCSprite:createWithSpriteFrameName(string.format("frame_%d.png", item.rank))
                    frame:setAnchorPoint(ccp( 0.5,0.5))
                    frame:setPosition(ccp((2 * i - 1) * width / 6, _hbCell:getContentSize().height * 0.65))
                    -- frame:setPosition(ccp( (width/4.5)/2, height/2))
                    icon3:addChild(frame)

                    local icon
                    icon = CCSprite:create(equipdata:getEquipIconByEquipId(iconName))
                    icon:setScale(0.36)
                    icon:setAnchorPoint(ccp(0.5, 0.5))
                    icon:setPosition(ccp((2 * i - 1) * width / 6, _hbCell:getContentSize().height * 0.65))
                    icon3:addChild(icon, 1, a1 * 3 + i)
                    if item.rank >= 4  then
                        --紫色材料发光
                        HLAddParticleScale( "images/purpleEquip.plist", icon, ccp(icon:getContentSize().width / 2,icon:getContentSize().height / 2), 1, 100, 777, 2 / 0.35 / retina, 2 / 0.35 / retina, 1 )
                    end

                    --添加文字
                    local labelTextSize = 24
                    if isPlatform(IOS_VIETNAM_VI) 
                        or isPlatform(IOS_VIETNAM_EN)
                        or isPlatform(IOS_MOBNAPPLE_EN) 
                        or isPlatform(IOS_VIETNAM_ENSAGA) 
                        or isPlatform(IOS_MOB_THAI)
                        or isPlatform(ANDROID_VIETNAM_MOB_THAI)
                        or isPlatform(ANDROID_VIETNAM_VI)
                        or isPlatform(ANDROID_VIETNAM_EN)
                        or isPlatform(ANDROID_VIETNAM_EN_ALL)
                        or isPlatform(IOS_MOBGAME_SPAIN)
                        or isPlatform(ANDROID_MOBGAME_SPAIN)
			or isPlatform(WP_VIETNAM_EN) then
                        labelTextSize = 14 
                    end
                    labelTextSize = labelTextSize /0.36 
                    --label  材料数量
                    local label = CCLabelTTF:create("", "ccbResources/FZCuYuan-M03S.ttf", labelTextSize)
                    label:setString( "x" .. tostring(composeNeeds[costStuff] ))
                    label:setColor(ccc3(221,233,73))
                    if _lackingItems[costStuff] then
                        label:setColor(ccc3(171,33,0))
                    end
                    label:setPosition(icon:getContentSize().width / 2, - icon:getContentSize().height *0.2)
                    
                    icon:addChild(label)

                    --label2 材料名称
                    local label2 = CCLabelTTF:create("", "ccbResources/FZCuYuan-M03S.ttf", labelTextSize)
                    local itemsConfig = ConfigureStorage.item
                    local item = itemsConfig[stuffItemId]
                    local itemName = item.name
                    label2:setString( itemName )
                    label2:setPosition(icon:getContentSize().width / 2,  icon:getContentSize().height *1.2 )
                    label2:setColor(ccc3(221,233,73))
                    icon:addChild(label2)

                end
            end

            icon3:setPosition(ccp(0,0))
            icon3:setAnchorPoint(ccp(0.5,0.5))
            
            _hbCell:addChild(icon3)
            a2:addChild(_hbCell, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)

            r = a2
        elseif fn == "numberOfCells" then
            r = math.ceil( dataCount/3 )  --    除3意思是3个一行
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
    local size = CCSizeMake(_containLayer:getContentSize().width, _containLayer:getContentSize().height)  -- 这里是为了在tableview上面显示一个小空出来
    _tableView = LuaTableView:createWithHandler(h, size)
    _tableView:setBounceable(true)
    _tableView:setAnchorPoint(ccp(0,0))
    _tableView:setPosition(0,0)
    _tableView:setVerticalFillOrder(0)
    _containLayer:addChild(_tableView,1000)
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(DailyComposeNeedViewOwner["infoBg"], "CCSprite")
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
    local menu = tolua.cast(DailyComposeNeedViewOwner["menu"], "CCMenu")
    menu:setTouchPriority(_priority - 2)
   _tableView:setTouchPriority(_priority - 2)
end
local function refreshContentView(  )

    local offset = _tableView:getContentOffset().y
    _tableView:reloadData()
    _tableView:setContentOffset(ccp(0, offset)) 
end
local function _closeView(  )
    _layer:removeFromParentAndCleanup(true) 
end
-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/DailyComposeNeedView.ccbi",proxy,true,"DailyComposeNeedViewOwner")
    _layer = tolua.cast(node,"CCLayer")
    _containLayer = tolua.cast(DailyComposeNeedViewOwner["containLayer"],"CCLayer")
    local berryNeededTTF = tolua.cast(DailyComposeNeedViewOwner["berryNeededTTF"],"CCLabelTTF")
    berryNeededTTF:setString(  HLNSLocalizedString("daily.DC.berryNeeded")) --需要贝里


end

function getComposeNeedLayer(  )
    return _layer
end

function createComposeNeedLayer(priority,equipContent) 
    _equipContent = equipContent -- data is 标准的装备物品数据结构
    PrintTable(_equipContent)
    _priority = (priority ~= nil) and priority or -132
    _init()

    function _layer:refresh(  )
        refreshContentView()
    end

    function _layer:closeView(  )
        _closeView()
    end

    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
        _addTableView()
        popUpUiAction(_owner, "infoBg")

    end

    local function _onExit()
        _layer = nil
        _priority = -132
        _tableView = nil
        allActivity = nil
        _lackingItems = {} 
        composeNeeds = nil
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



