local _layer
local _tableView
local _data
local _rankArray 
local _priority = -132

-- 劫镖者查看  界面
-- 名字不要重复
WWEscortItemAboutViewOwner = WWEscortItemAboutViewOwner or {}
ccb["WWEscortItemAboutViewOwner"] = WWEscortItemAboutViewOwner


local function closeItemClick(  )
    popUpCloseAction(WWEscortItemAboutViewOwner, "infoBg", _layer)
end
WWEscortItemAboutViewOwner["closeItemClick"] = closeItemClick

local function confirmBtnTaped(  )
    popUpCloseAction(WWEscortItemAboutViewOwner, "infoBg", _layer)
end
WWEscortItemAboutViewOwner["confirmBtnTaped"] = confirmBtnTaped

local  function getArrayData()
    local rankArray = {}
    for k,v in pairs(_data.robLog) do
        if v and v.result then
            table.insert(rankArray, v)
        end
    end
    return rankArray
    
end


local function _addTableView()
    WWEscortItemAboutCellOwner = WWEscortItemAboutCellOwner or {}
    ccb["WWEscortItemAboutCellOwner"] = WWEscortItemAboutCellOwner
    local containLayer = tolua.cast(WWEscortItemAboutViewOwner["containLayer"],"CCLayer")
    _rankArray = getArrayData()
    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(600, 120)
        elseif fn == "cellAtIndex" then
            -- Return CCTableViewCell, a1 is cell index (zero based), a2 is dequeued cell (maybe nil)
            -- Do something to create cell  and change the content
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            --单条数据
            local proxy = CCBProxy:create()
            local _hbCell = tolua.cast(CCBReaderLoad("ccbResources/WWEscortItemAboutCell.ccbi",
                proxy, true, "WWEscortItemAboutCellOwner"), "CCLayer")
            
            _rankArray = getArrayData()
            local dic = _rankArray[a1 + 1]
            local battleAgainBtn = tolua.cast(WWEscortItemAboutCellOwner["battleAgainBtn"], "CCMenuItemImage")
            battleAgainBtn:setTag(a1 + 1)

            local function wwRobFightedCallback(url, rtnData)
                RandomManager.cursor = rtnData.info.seed
                local left = rtnData.info.ememyInfo
                local right = rtnData.info.playerInfo
                BattleField.leftName = left.name
                BattleField.rightName = right.name
                BattleField:wwRobFightVideo(left, right)
                CCDirector:sharedDirector():replaceScene(CCTransitionFade:create(0.6, FightingScene()))
            end
            local menu2 = tolua.cast(WWEscortItemAboutCellOwner["menu2"], "CCMenu")
            if menu2 then
                --设置菜单优先级，确保点击tabelview以及menu的时候正常滑动
                menu2:setTouchPriority(_priority - 2)
            end
            
             -- 战斗回放按钮
            local function battleAgainClicked(tag)
                doActionFun("PLAYE_BACK_ESCORT", {dic.ememyInfo.id}, wwRobFightedCallback)
            end
            WWEscortItemAboutCellOwner["battleAgainClicked"] = battleAgainClicked

            local win = tolua.cast(WWEscortItemAboutCellOwner["win"], "CCLabelTTF")
            local fail = tolua.cast(WWEscortItemAboutCellOwner["fail"], "CCLabelTTF") 
            local heroName = tolua.cast(WWEscortItemAboutCellOwner["heroName"], "CCLabelTTF")
            local Level = tolua.cast(WWEscortItemAboutCellOwner["Level"], "CCLabelTTF")  
            local describe = tolua.cast(WWEscortItemAboutCellOwner["describe"], "CCLabelTTF") 
            heroName:setString(tostring(dic.ememyInfo.name))
            Level:setString(tostring('Lv' .. dic.ememyInfo.level))
            -- 显示描述
            local describe = tolua.cast(WWEscortItemAboutCellOwner["describe"], "CCLabelTTF")
            describe:setString(tostring(dic.desc_2))

            if tonumber(dic.result) == 0 then -- 失败
                win:setVisible(true)
            else
                fail:setVisible(true)
            end
            if dic.ememyInfo.form[tostring(0)] then
                local heroId = dic.ememyInfo.heros[dic.ememyInfo.form[tostring(0)]].heroId
                local conf = herodata:getHeroConfig(heroId)
                if conf then
                    local rankFrame1 = tolua.cast(WWEscortItemAboutCellOwner["rankFrame1"] , "CCSprite")
                    local icon1 = tolua.cast(WWEscortItemAboutCellOwner["icon1"] , "CCSprite")
                    local f = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(herodata:getHeroHeadByHeroId(heroId))
                    if f then
                        icon1:setVisible(true)
                        icon1:setDisplayFrame(f)
                        rankFrame1:setVisible(true)
                        rankFrame1:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", 2)))
                    end
                end 
            end

            -- _hbCell:setScale(retina)
            a2:addChild(_hbCell, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            r = a2
        elseif fn == "numberOfCells" then
            r = getMyTableCount(_data.robLog)
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


local function _refreshData()
    _addTableView()
end


local function setMenuPriority()
    local menu = tolua.cast(WWEscortItemAboutViewOwner["menu"], "CCMenu")
    menu:setHandlerPriority(_priority - 1)
    if _tableView then
        _tableView:setTouchPriority(_priority - 2)
    end
    --_tableView:setTouchPriority(_priority - 2)
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer

    local proxy = CCBProxy:create()
    local node  = CCBReaderLoad("ccbResources/WWEscortItemAboutView.ccbi", proxy, true, "WWEscortItemAboutViewOwner")
    _layer = tolua.cast(node,"CCLayer")
    _refreshData()
end



-- 该方法名字每个文件不要重复
function getWWEscortItemAboutLayer()
    return _layer
end


local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(WWEscortItemAboutViewOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction(WWEscortItemAboutViewOwner, "infoBg", _layer)
        return true
    end
    return true
end

local function onTouch(eventType, x, y)
    if eventType == "began" then   
        return onTouchBegan(x, y)
    end
end

function createWWEscortItemAboutLayer(data, _priority)
    _data = data
    _priority = (priority ~= nil) and priority or -132
    _init()
    local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
    _layer:runAction(seq)
    local function _onEnter()
        
    end

    local function _onExit()
        _layer = nil
        _priority = -132
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

    _layer:registerScriptTouchHandler(onTouch, false, _priority, true)
    _layer:setTouchEnabled(true)
    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end