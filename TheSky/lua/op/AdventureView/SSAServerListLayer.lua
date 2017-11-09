local _layer
local _tableView
local _rankArray 
local _priority = -132
local _data
local helpHeightArray = {}
-- 奖励 套用原来ccb
-- 名字不要重复
SSAServerListViewOwner = SSAServerListViewOwner or {}
ccb["SSAServerListViewOwner"] = SSAServerListViewOwner

local function closeItemClicked(  )
    popUpCloseAction(SSAServerListViewOwner, "infoBg", _layer)
end
SSAServerListViewOwner["closeItemClicked"] = closeItemClicked

local function confirmBtnTap(  )
    popUpCloseAction(SSAServerListViewOwner, "infoBg", _layer)
end
SSAServerListViewOwner["confirmBtnTap"] = confirmBtnTap

local function setMenuPriority()
    local menu = tolua.cast(SSAServerListViewOwner["menu"], "CCMenu")
    menu:setHandlerPriority(_priority - 1)
    if _tableView then
        _tableView:setTouchPriority(_priority - 2)
    end
   
end

local function getMyServerData()
    -- body
    local temp = {}
    for k,v in pairs(_data) do
        if v.serverName and v.serverName ~= "" then
            table.insert(temp,v.serverName)
        end
    end
    return temp
end

local function getCellHeight( string,width,fontSize,fontName )
    if not fontName then
        fontName = "ccbResources/FZCuYuan-M03S.ttf"
    end
    local tempLabel = CCLabelTTF:create(string, fontName, fontSize, CCSizeMake(width, 0), kCCTextAlignmentLeft)
    tempLabel:setVisible(false)
    _layer:addChild(tempLabel, 200, 8888)
    local height = tempLabel:getContentSize().height
    tempLabel:removeFromParentAndCleanup(true)
    return height
end

-- 添加tableview  手写
local function _addTableView()
    SSAServerListViewOwner = SSAServerListViewOwner or {}
    ccb["SSAServerListViewOwner"] = SSAServerListViewOwner
    local containLayer = tolua.cast(SSAServerListViewOwner["containLayer"],"CCLayer")
    _rankArray = getMyServerData()
    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            if _rankArray[a1 +1] then
            local message = _rankArray[a1 +1]
                local cellHeight
                if helpHeightArray[a1+1] then
                    cellHeight = helpHeightArray[a1+1]
                else
                    cellHeight = getCellHeight(message, 120.0, 28,"ccbResources/FZCuYuan-M03S") + 20
                    helpHeightArray[a1+1] = cellHeight 
                end
                r = CCSizeMake(winSize.width+2, cellHeight)
            end

        elseif fn == "cellAtIndex" then
            -- Return CCTableViewCell, a1 is cell index (zero based), a2 is dequeued cell (maybe nil)
            -- Do something to create cell  and change the content
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            -- --单条数据
            local  proxy = CCBProxy:create()
            local  _hbCell
            _hbCell = CCLayer:create()  
            -- 描述信息

            local cellHeight
            for i=1,2 do
                local message = _rankArray[a1 * 2 + i]
                if message then
                    if helpHeightArray[a1 + i] then
                        cellHeight = helpHeightArray[a1 + i]
                    else
                        cellHeight = getCellHeight(message, 120.0, 28, "ccbResources/FZCuYuan-M03S") + 20
                        helpHeightArray[a1 + i] = cellHeight
                    end
                    
                    local temp = CCLabelTTF:create(message, "ccbResources/FZCuYuan-M03S", 26, CCSizeMake(120,10), kCCTextAlignmentLeft)
                    temp:setAnchorPoint(ccp(0.5, 1))
                    temp:setPosition(ccp((i * 2 - 1) / 4 * containLayer:getContentSize().width, cellHeight - 10))
                    _hbCell:addChild(temp)
                    temp:setColor(ccc3(255, 204, 0))
                end
            end

            _hbCell:setContentSize(CCSizeMake(120, cellHeight))
            _hbCell:setAnchorPoint(ccp(0, 0))
            _hbCell:setPosition(ccp(0, 0))
            
            -- _hbCel:setScale(retina)
            a2:addChild(_hbCell, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            r = a2
        elseif fn == "numberOfCells" then
            r = math.ceil(getMyTableCount(_rankArray) / 2)
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
local function refresh()
    -- body
    local myArray = getMyServerData()
    print("myArraymyArraymyArraymyArraymyArray")
    PrintTable(myArray)
    _addTableView()
end
 
-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local proxy = CCBProxy:create()
    local node  = CCBReaderLoad("ccbResources/SSAServerListView.ccbi", proxy, true, "SSAServerListViewOwner")
    _layer = tolua.cast(node,"CCLayer")
    refresh()
end

-- 该方法名字每个文件不要重复
function getSSAServerListViewLayer()
    return _layer
end


local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(SSAServerListViewOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction(SSAServerListViewOwner, "infoBg", _layer)
        return true
    end
    return true
end

local function onTouch(eventType, x, y)
    if eventType == "began" then   
        return onTouchBegan(x, y)
    end
end

function createSSAServerListViewLayer(data)
    _priority = (priority ~= nil) and priority or -132
    _data = data
    _init()
    print("createSSAServerListViewLayerdata")
    PrintTable(_data)
    local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
    _layer:runAction(seq)
    local function _onEnter()
        
    end

    local function _onExit()
        _layer = nil
        _priority = -132
        _tableView = nil
        _data = nil
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