local _layer
local _priority = -132
local _contentDic
local helpHeightArray = {}

-- 名字不要重复
CommonHelpViewOwner = CommonHelpViewOwner or {}
ccb["CommonHelpViewOwner"] = CommonHelpViewOwner

local function closeItemClick(  )
    popUpCloseAction( CommonHelpViewOwner,"infoBg",_layer )
end

CommonHelpViewOwner["closeItemClick"] = closeItemClick

local function getCellHeight( string,width,fontSize,fontName )
    if not fontName then
        fontName = "ccbResources/FZCuYuan-M03S.ttf"
    end
    local tempLabel = CCLabelTTF:create(string,fontName,fontSize,CCSizeMake(width,0),kCCTextAlignmentLeft)
    tempLabel:setVisible(false)
    _layer:addChild(tempLabel,200,8888)
    local height = tempLabel:getContentSize().height
    tempLabel:removeFromParentAndCleanup(true)
    return height
end

local function _addTableView() 
    local tableViewContentView = CommonHelpViewOwner["tableViewContentView"]

    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
                local message = _contentDic[a1 +1]
                local cellHeight
                if helpHeightArray[a1+1] then
                    cellHeight = helpHeightArray[a1+1]
                else
                    cellHeight = getCellHeight(message,580.0,23,"ccbResources/FZCuYuan-M03S") + 20 * retina
                    helpHeightArray[a1+1] = cellHeight 
                end
                
                r = CCSizeMake(winSize.width, cellHeight)
            -- end
        elseif fn == "cellAtIndex" then
            -- Return CCTableViewCell, a1 is cell index (zero based), a2 is dequeued cell (maybe nil)
            -- Do something to create cell  and change the content
            
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            
            local  proxy = CCBProxy:create()
            
            local  _hbCell
            -- _hbCell = CCLayerColor:create(ccc4(255,255,3,255))
            _hbCell = CCLayer:create()

            local message = _contentDic[a1 +1]
            local cellHeight
            if helpHeightArray[a1+1] then
                cellHeight = helpHeightArray[a1+1]
            else
                cellHeight = getCellHeight(message,580.0,23,"ccbResources/FZCuYuan-M03S") + 20 * retina
                helpHeightArray[a1+1] = cellHeight
            end
            _hbCell:setContentSize(CCSizeMake(580,cellHeight))
            _hbCell:setAnchorPoint(ccp(0,0))
            _hbCell:setPosition(ccp(0,0))

            local temp = CCLabelTTF:create(message, "ccbResources/FZCuYuan-M03S", 23,CCSizeMake(0,0),kCCTextAlignmentLeft)
            if temp:getContentSize().width > 580 then
                temp = CCLabelTTF:create(message, "ccbResources/FZCuYuan-M03S", 23,CCSizeMake(580,0),kCCTextAlignmentLeft)
            end
            local tempContentSize = temp:getContentSize()
            temp = CCLabelTTF:create(message, "ccbResources/FZCuYuan-M03S", 23,CCSizeMake(580,tempContentSize.height * 1.1),kCCTextAlignmentLeft)
            temp:setAnchorPoint(ccp(0,1))
            temp:setPosition(ccp(0,cellHeight - 10 * retina))
            _hbCell:addChild(temp)
            temp:setColor(ccc3(255,204,0))
                
            -- _hbCell:setScale(retina)
            a2:addChild(_hbCell, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)

            r = a2
        elseif fn == "numberOfCells" then
            r = getMyTableCount(_contentDic)
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
        local size = CCSizeMake(tableViewContentView:getContentSize().width,tableViewContentView:getContentSize().height)      -- 这里是为了在tableview上面显示一个小空出来
        _tableView = LuaTableView:createWithHandler(h, size)
        _tableView:setBounceable(true)
        _tableView:setAnchorPoint(ccp(0,0))
        _tableView:setPosition(ccp(0, 0))
        _tableView:setVerticalFillOrder(0)
        tableViewContentView:addChild(_tableView)
    end
end


-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/CommonHelpView.ccbi",proxy, true,"CommonHelpViewOwner")
    _layer = tolua.cast(node,"CCLayer")

end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(CommonHelpViewOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        _layer:removeFromParentAndCleanup(true)
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
    local menu1 = tolua.cast(CommonHelpViewOwner["closeMenu"], "CCMenu")
    menu1:setHandlerPriority(_priority - 1)

    _tableView:setTouchPriority(_priority - 1)
end

-- 该方法名字每个文件不要重复
function getCommonHelpLayer()
	return _layer
end
-- uitype 0 可升级的弹框  1 影子详情弹框
function createCommonHelpLayer( contentDic, priority )
    _contentDic = contentDic
    _priority = (priority ~= nil) and priority or -132
    _init()

    local function _onEnter()
        _addTableView()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)

        popUpUiAction( CommonHelpViewOwner,"infoBg" )
    end

    local function _onExit()
        _layer = nil
        _priority = -132
        _contentDic = nil
        helpHeightArray = {}
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