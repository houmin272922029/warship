local _layer
local _priority
local tempLabel
local _tableView

-- 名字不要重复
VipSupportViewOwner = VipSupportViewOwner or {}
ccb["VipSupportViewOwner"] = VipSupportViewOwner

local function closeItemClick()
    popUpCloseAction( VipSupportViewOwner,"infoBg",_layer )
end
VipSupportViewOwner["closeItemClick"] = closeItemClick

local function getStringHeight( string,width,fontSize,fontName )
    if not fontName then
        fontName = "ccbResources/FZCuYuan-M03S"
    end
    if tempLabel then
        tempLabel = tolua.cast(tempLabel,"CCLabelTTF")
        if tempLabel then
            tempLabel:removeAllChildrenWithCleanup(true)
            tempLabel = nil
        end
    end

    tempLabel = CCLabelTTF:create(string,fontName,fontSize,CCSizeMake(width,0),kCCTextAlignmentLeft)
    _layer:addChild(tempLabel)
    tempLabel:setVisible(false)
    return (tempLabel:getContentSize().height)
end
local function getCellHeight( array )
    local height = 0
    local contentLayer = VipSupportViewOwner["contentLayer"]
    for i=1,getMyTableCount(array) do
        local height1 = 0
        if i == 1 then
            height1 = 60
        else
            height1 = getStringHeight(array[i],contentLayer:getContentSize().width - 100,24,"ccbResources/FZCuYuan-M03S")
        end
        height = height + height1
    end
    return height
end

local function _addTableView() 
    local contentLayer = VipSupportViewOwner["contentLayer"]
    local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
    cache:addSpriteFramesWithFile("ccbResources/publicRes_1.plist")

    -- 获得数据
    local function getAllData()
        local ret = {}
        for i=1,table.getTableCount(ConfigureStorage.vipdesp2) do
            local v = ConfigureStorage.vipdesp2[tostring(i)]
            local str = ""
            for j=1,table.getTableCount(v.content) do
                str = str .. v.content[tostring(j)] .. "\r\n"
            end
            local array = {id = v.id, content = str}
            table.insert(ret, array)
        end
        return ret
    end
    local myData = getAllData()
    if getMyTableCount(myData) == 0 then
        local announceLabel = tolua.cast(VipSupportViewOwner["announceLabel"],"CCLabelTTF")
        announceLabel:setVisible(true)
    end
    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            local array = {}
            local oneContent = myData[a1 + 1]
            PrintTable(oneContent)
            array[1] = oneContent["id"]
            array[2] = oneContent["content"]
            local height  = getCellHeight( array ) + 10 + 40
            r = CCSizeMake(contentLayer:getContentSize().width, height)
        elseif fn == "cellAtIndex" then
            -- Return CCTableViewCell, a1 is cell index (zero based), a2 is dequeued cell (maybe nil)
            -- Do something to create cell  and change the content
            
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            local oneContent = myData[a1 + 1]
            PrintTable(oneContent)
            local array = {}
            local string1 = oneContent["id"]
            local string2 = oneContent["content"]

            array[1] = oneContent["id"]
            array[2] = oneContent["content"]
            local height = getCellHeight( array ) + 10 + 30

            local cellBg = CCScale9Sprite:createWithSpriteFrameName("gonggaoBg.png")
            cellBg:setContentSize(CCSizeMake(contentLayer:getContentSize().width - 50,height))
            cellBg:setAnchorPoint(ccp(0.5,0.5))
            cellBg:setPosition(ccp(contentLayer:getContentSize().width / 2,height / 2))
            

            local cellHight = cellBg:getContentSize().height
         
            print(tostring(string1))
            local titleLabel = CCLabelTTF:create(tostring(string1),"ccbResources/FZCuYuan-M03S",26,CCSizeMake(contentLayer:getContentSize().width - 100,0),kCCTextAlignmentCenter,kCCVerticalTextAlignmentCenter)
            local contentlable = CCLabelTTF:create(tostring(string2),"ccbResources/FZCuYuan-M03S",26,CCSizeMake(contentLayer:getContentSize().width - 100,0),kCCTextAlignmentCenter,kCCVerticalTextAlignmentCenter)
           
            titleLabel:setAnchorPoint(ccp(0,1))
            titleLabel:setPosition(ccp(25,cellHight - 10))
            titleLabel:setColor(ccc3(255,255,0))
           

            contentlable:setAnchorPoint(ccp(0,1))
            contentlable:setPosition(ccp(25,cellHight - 60))
            contentlable:setColor(ccc3(255,255,0))
            cellBg:addChild(titleLabel)

            cellBg:addChild(contentlable)
            
           

            a2:addChild(cellBg, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            r = a2
        elseif fn == "numberOfCells" then
            r = getMyTableCount(myData)
        elseif fn == "cellTouched" then         -- A cell was touched, a1 is cell that be touched. This is not necessary.
            -- print("cellTouched",a1:getIdx())
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
        local size = CCSizeMake(contentLayer:getContentSize().width, contentLayer:getContentSize().height)      -- 这里是为了在tableview上面显示一个小空出来
        _tableView = LuaTableView:createWithHandler(h, size)
        _tableView:setBounceable(true)
        _tableView:setAnchorPoint(ccp(0,0))
        _tableView:setPosition(ccp(0, 0))
        _tableView:setVerticalFillOrder(0)
        contentLayer:addChild(_tableView)
    end
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/VipSupportView.ccbi", proxy, true,"VipSupportViewOwner")
    _layer = tolua.cast(node,"CCLayer")

end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(VipSupportViewOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then

        popUpCloseAction( VipSupportViewOwner,"infoBg",_layer )
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
    local menu1 = tolua.cast(VipSupportViewOwner["myCloseMenu"], "CCMenu")
    menu1:setHandlerPriority(_priority-1)
    _tableView:setTouchPriority(_priority - 3)
end

-- 该方法名字每个文件不要重复
function getVipSupportLayer()
	return _layer
end

function createVipSupportLayer(priority)
    _priority = (priority ~= nil) and priority or -132
    _init()
    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
        _addTableView()
        popUpUiAction( VipSupportViewOwner,"infoBg" )
    end

    local function _onExit()
        _layer = nil
        _priority = nil
        _tableView = nil
        tempLabel = nil
    end

    --onEnter onExit
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