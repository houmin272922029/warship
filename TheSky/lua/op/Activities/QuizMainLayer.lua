local _layer
local _priority = -132
local _tableView
local _data

-- 名字不要重复
QuizMainOwner = QuizMainOwner or {}
ccb["QuizMainOwner"] = QuizMainOwner

local function closeItemClick()
    popUpCloseAction(QuizMainOwner, "infoBg", _layer )
end
QuizMainOwner["closeItemClick"] = closeItemClick


local function _addTableView()
    -- 得到数据
    _data = loginActivityData:getQuizData()

    local content = QuizMainOwner["content"]

    QuizMainCellOwner = QuizMainCellOwner or {}
    ccb["QuizMainCellOwner"] = QuizMainCellOwner

    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(583, 175)
        elseif fn == "cellAtIndex" then
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            --单条数据
            local  proxy = CCBProxy:create()
            local  _hbCell  = tolua.cast(CCBReaderLoad("ccbResources/QuizMainCell.ccbi",proxy,true,"QuizMainCellOwner"),"CCLayer")

            local dic = _data[a1 + 1]

            for i=1,2 do
                local team = tolua.cast(QuizMainCellOwner["team"..i], "CCSprite")
                team:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("%s.png", dic["team"..i].code)))
                local name = tolua.cast(QuizMainCellOwner["name"..i], "CCLabelTTF")
                name:setString(dic["team"..i].name)
            end

            local title = tolua.cast(QuizMainCellOwner["title"], "CCLabelTTF")
            title:setString(dic.name)

            for i=1,3 do
                local state = tolua.cast(QuizMainCellOwner["state"..i], "CCLabelTTF")
                state:setVisible(dic.state == i)
            end

            a2:addChild(_hbCell, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            r = a2
        elseif fn == "numberOfCells" then
            r = #_data
        elseif fn == "cellTouched" then         -- A cell was touched, a1 is cell that be touched. This is not necessary.
            local dic = _data[a1:getIdx() + 1]
            if dic.state == 2 then
                getMainLayer():getParent():addChild(createQuizLayer(dic, _priority - 2), 202)
            elseif dic.state == 1 then
                getMainLayer():getParent():addChild(createQuizListLayer(dic, _priority - 2), 202)
            elseif dic.state == 3 then
                getMainLayer():getParent():addChild(createQuizRewardLayer(dic, _priority - 2), 202)
            end
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
    _addTableView()
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/QuizMainView.ccbi", proxy, true,"QuizMainOwner")
    _layer = tolua.cast(node,"CCLayer")

    _refreshData()
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(QuizMainOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction(QuizMainOwner, "infoBg", _layer)
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
    local menu = tolua.cast(QuizMainOwner["menu"], "CCMenu")
    menu:setTouchPriority(_priority - 2)
    _tableView:setTouchPriority(_priority - 2)
end

function getQuizMainLayer()
	return _layer
end

function createQuizMainLayer(priority)
    _priority = (priority ~= nil) and priority or -132
    _init()

    function _layer:refreshData()
        _data = loginActivityData:getQuizData() 
        _tableView:reloadData()
    end

    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)

        popUpUiAction(QuizMainOwner, "infoBg")
    end

    local function _onExit()
        _layer = nil
        _tableView = nil
        _priority = nil
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


    _layer:registerScriptTouchHandler(onTouch ,false , _priority ,true )
    _layer:setTouchEnabled(true)
    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end