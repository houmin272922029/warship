local _layer
local _priority
local _tableView

local FONT_PIC = {
    {
        "haizeiwang_text.png",
        "sihuang_text.png",
        "sihuang_text.png",
        "chaoxinxing_text.png",
        "chaoxinxing_text.png",
        "chaoxinxing_text.png",
        "chaoxinxing_text.png",
    },
    {
        "yuanshuai_text.png",
        "dajiang_text.png",
        "dajiang_text.png",
        "zhongjiang_text.png",
        "zhongjiang_text.png",
        "zhongjiang_text.png",
        "zhongjiang_text.png",
    },
    {
        "siling_text.png",
        "canmouzhang_text.png",
        "canmouzhang_text.png",
        "xianfeng_text.png",
        "xianfeng_text.png",
        "xianfeng_text.png",
        "xianfeng_text.png",
    },
}

WWJobChangeOwner = WWJobChangeOwner or {}
ccb["WWJobChangeOwner"] = WWJobChangeOwner

-- 关闭
local function closeItemClick()
    popUpCloseAction(WWJobChangeOwner, "infoBg", _layer)
end
WWJobChangeOwner["closeItemClick"] = closeItemClick


local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(WWJobChangeOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction(WWJobChangeOwner, "infoBg", _layer)
        return true
    end
    return true
end

local function onTouch(eventType, x, y)
    if eventType == "began" then   
        return onTouchBegan(x, y)
    end
end

-- 修改 按钮优先级
local function setMenuPriority()
    local menu = tolua.cast(WWJobChangeOwner["menu"], "CCMenu")
    menu:setHandlerPriority(_priority - 1)
    _tableView:setTouchPriority(_priority - 1)
end


local function addTableView()

    WWJobChangeCellOwner = WWJobChangeCellOwner or {}
    ccb["WWJobChangeCellOwner"] = WWJobChangeCellOwner

    local function changeItemClick(tag)
        local function callback(url, rtnData)
            local ranks = rtnData.info.scoreRank
            local array = {}
            if ranks then
                for k,v in pairs(ranks) do
                    table.insert(array, v)     
                end
                local function sortFun(a, b)
                    return a.score > b.score
                end
                table.sort(array, sortFun)
            end
            getMainLayer():getParent():addChild(createWWJobSelectLayer(array, tag, _priority - 2))
            closeItemClick()
        end
        doActionFun("WW_GET_CANDIDATE", {}, callback)
    end
    WWJobChangeCellOwner["changeItemClick"] = changeItemClick
    
    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(585, 100)
        elseif fn == "cellAtIndex" then
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            --单条数据
            local  proxy = CCBProxy:create()
            local  _hbCell  = tolua.cast(CCBReaderLoad("ccbResources/WWJobChangeCell.ccbi",proxy,true,"WWJobChangeCellOwner"),"CCLayer")

            local function setCellMenuPriority(sender)
                if sender then
                    local menu = tolua.cast(sender, "CCMenu")
                    menu:setHandlerPriority(_priority - 1)
                end
            end

            local menu = WWJobChangeCellOwner["menu"]
            local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCCallFuncN:create(setCellMenuPriority))
            menu:runAction(seq)

            local job
            if worldwardata.playerData.leaderKey == 0 then
                job = a1 + 1
            else
                job = a1 + 3
            end
            local changeItem = tolua.cast(WWJobChangeCellOwner["changeItem"], "CCMenuItem")
            changeItem:setTag(job)

            local jobSp = tolua.cast(WWJobChangeCellOwner["job"], "CCSprite")
            local index = tonumber(string.split(worldwardata.playerData.countryId, "_")[2])
            jobSp:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(FONT_PIC[index][job + 1]))
            local dic = _data[tostring(job)]
            local name = tolua.cast(WWJobChangeCellOwner["name"], "CCLabelTTF")
            local vip = tolua.cast(WWJobChangeCellOwner["vip"], "CCSprite")
            if dic then
                name:setString(dic.name)
                vip:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("VIP_%d.png", dic.vip)))
            else
                name:setVisible(false)
                vip:setVisible(false)
            end

            a2:addChild(_hbCell, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            r = a2
        elseif fn == "numberOfCells" then
            if worldwardata.playerData.leaderKey == 0 then
                r = 6
            else
                r = 4
            end
        elseif fn == "cellTouched" then         -- A cell was touched, a1 is cell that be touched. This is not necessary.
        elseif fn == "cellTouchBegan" then      -- A cell is touching, a1 is cell, a2 is CCTouch
        elseif fn == "cellTouchEnded" then      -- A cell was touched, a1 is cell, a2 is CCTouch
        elseif fn == "cellHighlight" then       -- A cell is highlighting, coco2d-x 2.1.3 or above
        elseif fn == "cellUnhighlight" then     -- A cell had been unhighlighted, coco2d-x 2.1.3 or above
        elseif fn == "cellWillRecycle" then     -- A cell will be recycled, coco2d-x 2.1.3 or above
        end
        return r
    end)
    local content = tolua.cast(WWJobChangeOwner["content"], "CCLayer")
    local size = content:getContentSize()
    _tableView = LuaTableView:createWithHandler(h, size)
    _tableView:setBounceable(true)
    _tableView:setAnchorPoint(ccp(0,0))
    _tableView:setPosition(0,0)
    _tableView:setVerticalFillOrder(0)
    content:addChild(_tableView,1000)
end

local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/WWJobChange.ccbi", proxy, true, "WWJobChangeOwner")
    _layer = tolua.cast(node, "CCLayer")

    addTableView()
end

function createWWJobChangeLayer(data, priority)
    _data = data
    _priority = (priority ~= nil) and priority or -132

    _init()

    local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
    _layer:runAction(seq)

    local function _onEnter()
        popUpUiAction(WWJobChangeOwner, "infoBg")
    end

    local function _onExit()
        _priority = -132
        _layer = nil
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