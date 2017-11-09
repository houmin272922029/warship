local _layer
local _priority = -132
local _data
local _tableView

-- 名字不要重复
QuizListOwner = QuizListOwner or {}
ccb["QuizListOwner"] = QuizListOwner

local function closeItemClick()
    popUpCloseAction(QuizListOwner, "infoBg", _layer )
end
QuizListOwner["closeItemClick"] = closeItemClick

local function _addTableView()
    -- 得到数据
    local function getData()
        local array = {} 
        for k,v in pairs(_data.guessLogs) do
            for bType,count in pairs(v) do
                local dic = {["bType"] = bType, ["count"] = count, ["key"] = k}
                table.insert(array, dic)
            end
        end
        local function sortFun(a, b)
            if a.bType == b.bType then
                return a.count > b.count
            end 
            return a.bType < b.bType
        end
        table.sort(array, sortFun)
        return array
    end

    local array = getData()

    local content = QuizListOwner["content"]

    QuizListCellOwner = QuizListCellOwner or {}
    ccb["QuizListCellOwner"] = QuizListCellOwner

    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(583, 145)
        elseif fn == "cellAtIndex" then
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            --单条数据
            local  proxy = CCBProxy:create()
            local  _hbCell  = tolua.cast(CCBReaderLoad("ccbResources/QuizListCell.ccbi",proxy,true,"QuizListCellOwner"),"CCLayer")

            local dic = array[a1 + 1]

            local team = tolua.cast(QuizListCellOwner["team"], "CCSprite")
            local name = tolua.cast(QuizListCellOwner["name"], "CCLabelTTF")
            local draw = tolua.cast(QuizListCellOwner["draw"], "CCLabelTTF")
            if dic.key == "draw" then
                draw:setVisible(true)
                name:setVisible(false)
                team:setVisible(false)
            else
                team:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("%s.png", _data[dic.key].code)))
                name:setString(_data[dic.key].name)
            end
            local icon = tolua.cast(QuizListCellOwner["icon"], "CCSprite")
            local resDic = userdata:getExchangeResource(dic.bType)
            local texture = CCTextureCache:sharedTextureCache():addImage(resDic.icon)
            if texture then
                icon:setTexture(texture)
            end

            local bet = tolua.cast(QuizListCellOwner["bet"], "CCLabelTTF")
            bet:setString(dic.count)

            a2:addChild(_hbCell, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            r = a2
        elseif fn == "numberOfCells" then
            r = #array
        elseif fn == "cellTouched" then         -- A cell was touched, a1 is cell that be touched. This is not necessary.
        elseif fn == "cellTouchBegan" then      -- A cell is touching, a1 is cell, a2 is CCTouch
        elseif fn == "cellTouchEnded" then      -- A cell was touched, a1 is cell, a2 is CCTouch
        elseif fn == "cellHighlight" then       -- A cell is highlighting, coco2d-x 2.1.3 or above
        elseif fn == "cellUnhighlight" then     -- A cell had been unhighlighted, coco2d-x 2.1.3 or above
        elseif fn == "cellWillRecycle" then     -- A cell will be recycled, coco2d-x 2.1.3 or above
        end
        return r
    end)

    local size = content:getContentSize()
    _tableView = LuaTableView:createWithHandler(h, size)
    _tableView:setBounceable(true)
    _tableView:setAnchorPoint(ccp(0,0))
    _tableView:setPosition(0,0)
    _tableView:setVerticalFillOrder(0)
    content:addChild(_tableView,1000)
end

local function _refreshData()
    for i=0,1 do
        local title = tolua.cast(QuizListOwner["title"..i], "CCLabelTTF")
        title:setString(_data.title)
    end
    if _data.guessLogs and _data.guessLogs ~= "" then
        _addTableView()
    else
        local tips = tolua.cast(QuizListOwner["tips"], "CCLabelTTF")
        tips:setVisible(true)
    end
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/QuizListView.ccbi", proxy, true, "QuizListOwner")
    _layer = tolua.cast(node,"CCLayer")

    _refreshData()
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(QuizListOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction(QuizListOwner, "infoBg", _layer)
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
    local menu = tolua.cast(QuizListOwner["menu"], "CCMenu")
    menu:setTouchPriority(_priority - 2)
    if _tableView then
        _tableView:setTouchPriority(_priority - 2)
    end
end

function getQuizListLayer()
	return _layer
end

function createQuizListLayer(data, priority)
    _data = data
    _priority = (priority ~= nil) and priority or -132
    _init()

    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)

        popUpUiAction(QuizListOwner, "infoBg")
    end

    local function _onExit()
        _layer = nil
        _priority = nil
        _data = nil
        _tableView = nil
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