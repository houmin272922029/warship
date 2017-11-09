local _layer
local _tableView = nil
local _type = 0         -- 0:伙伴  1:魂魄
local _data = nil 
local _selIdx = 0       -- 选择的cell index
local _huoBanBtn = nil
local _hunPoBtn = nil
local cellArray = {}

HeroesLayerOwner = HeroesLayerOwner or {}
ccb["HeroesLayerOwner"] = HeroesLayerOwner

HeroesLayer = HeroesLayer or {}
ccb["HeroesLayer"] = HeroesLayer

HuoBanCellOwner = HuoBanCellOwner or {}
ccb["HuoBanCellOwner"] = HuoBanCellOwner

HunPoCellOwner = HunPoCellOwner or {}
ccb["HunPoCellOwner"] = HunPoCellOwner

GotoLogueCellOwner = GotoLogueCellOwner or {}
ccb["GotoLogueCellOwner"] = GotoLogueCellOwner

local function _setSpriteFrame( sender,bool )
    if bool then
        sender:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_1.png"))
        sender:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_0.png"))
    else
        sender:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_0.png"))
        sender:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_1.png"))
    end
end

local function onHuoBanClicked()
    print("onHuoBanClicked")
    if _type ~= 0 then
        _setSpriteFrame(_huoBanBtn,true)
        _setSpriteFrame(_hunPoBtn,false)

        _type = 0
        _data = herodata:getAllHeroes()
        cellArray = {}
        
        _tableView:reloadData()

        generateCellAction( cellArray,#_data + 1 )
        cellArray = {}
    end
end
HeroesLayerOwner["onHuoBanClicked"] = onHuoBanClicked

local function onHunPoClicked()
    print("onHunPoClicked")
    if _type ~= 1 then
        _setSpriteFrame(_huoBanBtn,false)
        _setSpriteFrame(_hunPoBtn,true)

        _type = 1
        _data = heroSoulData:getAllSoulsInfo()
        cellArray = {}
        
        _tableView:reloadData()

        generateCellAction( cellArray,#_data + 1 )
        cellArray = {}
    end
end
HeroesLayerOwner["onHunPoClicked"] = onHunPoClicked

-- 商城
local function onGotoLogueClicked()
    print("onGotoLogueClicked")
    if getMainLayer() ~= nil then
        getMainLayer():goToLogue()
    end
end
GotoLogueCellOwner["onGotoLogueClicked"] = onGotoLogueClicked

-- 培养
local function onCultureClicked()
    print("onCultureClicked")
    Global:instance():TDGAonEventAndEventData("Culture")
    runtimeCache.huobanTableOffsetY = _tableView:getContentOffset().y
    local heroInfo = _data[_selIdx+1]
    if heroInfo then
        if getMainLayer() ~= nil then
            getMainLayer():goToCulture(heroInfo.id)
        end
    end 
end
HuoBanCellOwner["onCultureClicked"] = onCultureClicked

-- 送别
local function onFarewellClicked()
    print("onFarewellClicked")
    Global:instance():TDGAonEventAndEventData("inherit")
    runtimeCache.huobanTableOffsetY = _tableView:getContentOffset().y
    local heroInfo = _data[_selIdx+1]
    if getMainLayer() ~= nil then
        getMainLayer():goToFarewell(heroInfo.id, nil, 0)
    end
end
HuoBanCellOwner["onFarewellClicked"] = onFarewellClicked

-- 点击头像
local function onHuoBanHeadClicked()
    print("onHuoBanHeadClicked")
    local heroInfo = _data[_selIdx+1]
    if heroInfo then
        -- 显示英雄信息
        getMainLayer():addChild(createHeroInfoLayer(heroInfo.id, HeroDetail_Clicked_HuoBan, -135))
    end
end 
HuoBanCellOwner["onHuoBanHeadClicked"] = onHuoBanHeadClicked

-- 用魂魄招募英雄
local function onRecuitClicked()
    print("onRecuitClicked")
    _layer:recruitHero()
end
HunPoCellOwner["onRecuitClicked"] = onRecuitClicked

local function onBreakClicked()
    print("onBreakClicked")
    -- _layer:breakHero()
    local heroInfo = _data[_selIdx+1]
    if getMainLayer() ~= nil then
        getMainLayer():goToBreak(heroInfo.id)
    end
end 
HunPoCellOwner["onBreakClicked"] = onBreakClicked

-- 点击头像
local function onHunPoHeadClicked()
    print("onHunPoHeadClicked")
    local hunPoInfo = _data[_selIdx+1]
    if hunPoInfo then
        local uiType = HeroDetail_Clicked_HunPo_Null
        if hunPoInfo.state == "recruit" then
            if hunPoInfo.canRecruit == 1 then
                -- 可招募状态
                uiType = HeroDetail_Clicked_HunPo_Recruit
            end
        else
            if hunPoInfo.canBreak == 1 then
                -- 可突破状态
                uiType = HeroDetail_Clicked_HunPo_Break
            end 
        end
        -- 显示英雄信息
        getMainLayer():addChild(createHeroInfoLayer(hunPoInfo.id, uiType, -135))
    end
end 
HunPoCellOwner["onHunPoHeadClicked"] = onHunPoHeadClicked

local function _addTableView()
    local _topLayer = HeroesLayerOwner["HBTopLayer"]

    -- @param fn string Callback type
    -- @param table LuaTableView
    -- @param a1 & a2 mixed Difference means for every "fn"
    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            if a1 == #_data then
                r = CCSizeMake(winSize.width, 80 * retina)
            else
                r = CCSizeMake(winSize.width, 170 * retina)
            end
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
            if a1 == #_data then 
                _hbCell  = tolua.cast(CCBReaderLoad("ccbResources/GoToLogueCell.ccbi",proxy,true,"GotoLogueCellOwner"),"CCLayer")
                a2:setAnchorPoint(ccp(0, 0))
                a2:setPosition(0, 0)
            else
                if _type == 0 then
                    _hbCell  = tolua.cast(CCBReaderLoad("ccbResources/HuoBanCell.ccbi",proxy,true,"HuoBanCellOwner"),"CCSprite")
                elseif _type == 1 then
                    _hbCell  = tolua.cast(CCBReaderLoad("ccbResources/HunPoCell.ccbi",proxy,true,"HunPoCellOwner"),"CCSprite")
                end
                _hbCell:setAnchorPoint(ccp(0.5, 0.5))
                _hbCell:setPosition(winSize.width/2, 170 * retina/2)

                local function _updateBaseInfo( key )
                    if key == "rank" then
                        local rankSprite = tolua.cast((_type == 0) and HuoBanCellOwner[key] or HunPoCellOwner[key], "CCSprite")
                        if rankSprite then
                            rankSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("rank_%d_icon.png", _data[a1+1][key])))
                        end
                    else 
                        local label = tolua.cast((_type == 0) and HuoBanCellOwner[key] or HunPoCellOwner[key], "CCLabelTTF")
                        if label then
                            if _type == 1 and key == "name" then
                                label:setString(string.format("%s", _data[a1+1][key]))
                            else
                                label:setString(_data[a1+1][key])
                            end
                        end
                    end
                end 
                if _type == 0 then
                    _updateBaseInfo("name")
                    _updateBaseInfo("rank")
                    _updateBaseInfo("level")
                    -- _updateBaseInfo("price")
                    local label = tolua.cast(HuoBanCellOwner["price"], "CCLabelTTF")
                    -- PrintTable(_data[a1+1])
                    label:setString(herodata:getHeroAttrPrice(_data[a1+1].id))
                elseif _type == 1 then
                    _updateBaseInfo("name")
                    _updateBaseInfo("rank")
                    _updateBaseInfo("amount")
                end
                local iconBgMenuItem = tolua.cast((_type == 0) and HuoBanCellOwner["iconBg"] or HunPoCellOwner["iconBg"], "CCMenuItemImage")
                if iconBgMenuItem then
                    iconBgMenuItem:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", _data[a1+1]["rank"])))
                end 
                local headIcon = tolua.cast((_type == 0) and HuoBanCellOwner["headIcon"] or HunPoCellOwner["headIcon"], "CCSprite")
                if headIcon then
                    local headSpr = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(herodata:getHeroHeadByHeroId((_type == 0) and _data[a1+1]["heroId"] or _data[a1+1]["id"]))
                    if headSpr then
                        headIcon:setDisplayFrame(headSpr)
                    end 
                end 
                if _type == 0 then
                    local breakLevel = tolua.cast(HuoBanCellOwner["breakLevel"],"CCSprite")
                    local breakLevelFnt = tolua.cast(HuoBanCellOwner["breakLevelFnt"], "CCLabelBMFont")
                    local breakValue = _data[a1+1]["break"] 
                    if breakLevel and breakValue ~= 0 then 
                        breakLevel:setVisible(true)
                        breakLevelFnt:setString(breakValue)
                    end 
                end
                -- 已上阵标签
                if _type == 0 then 
                    local inFormTipLabel = tolua.cast(HuoBanCellOwner["inFormTip"], "CCLabelTTF")
                    inFormTipLabel:setVisible((_data[a1+1].form == 1) and true or false)
                end

                -- 处理魂魄页面不同的显示内容
                local recruitBtn = tolua.cast(HunPoCellOwner["recruitBtn"], "CCLabelTTF")
                local recruitLabel = tolua.cast(HunPoCellOwner["recruitTitle"], "CCLabelTTF")
                local breakBtn = tolua.cast(HunPoCellOwner["breakBtn"], "CCLabelTTF")
                local breakLabel = tolua.cast(HunPoCellOwner["breakTitle"], "CCLabelTTF")
                local amountTipLabel = tolua.cast(HunPoCellOwner["amountTipTitle"], "CCLabelTTF")
                local function _clearHunPoCellBtnInfo()
                    recruitBtn:setVisible(false)
                    recruitLabel:setVisible(false)
                    breakBtn:setVisible(false)
                    breakLabel:setVisible(false)
                    amountTipLabel:setVisible(false)
                end 
                if _type == 1 then
                    _clearHunPoCellBtnInfo()
                    if _data[a1+1].state == "recruit" then
                        -- 招募状态
                        if _data[a1+1].canRecruit == 1 then
                            recruitBtn:setVisible(true)
                            recruitLabel:setVisible(true)
                        else 
                            amountTipLabel:setString(string.format(HLNSLocalizedString("加%d可招募"), _data[a1+1].recCount))
                            amountTipLabel:setVisible(true)
                        end 
                    else
                        -- 突破状态
                        if _data[a1+1]["break"] ~= 0 then
                            local breakLevel = tolua.cast(HunPoCellOwner["breakLevel"],"CCSprite")
                            local breakLevelFnt = tolua.cast(HunPoCellOwner["breakLevelFnt"], "CCLabelBMFont")
                            if breakLevel then 
                                breakLevel:setVisible(true)
                                breakLevelFnt:setString(_data[a1+1]["break"])
                            end 
                        end
                        if _data[a1+1].canBreak == 1 then
                            breakBtn:setVisible(true)
                            breakLabel:setVisible(true)
                        else 
                            amountTipLabel:setString(string.format(HLNSLocalizedString("加%d可突破"), _data[a1+1].breCount))
                            amountTipLabel:setVisible(true)
                        end 
                    end
                end
            end
            _hbCell:setScale(retina)
            a2:addChild(_hbCell, 0, 1)
            _hbCell:stopAllActions()
            cellArray[tostring(a1)] = _hbCell

            r = a2
        elseif fn == "numberOfCells" then
            -- Return number of cells
            r = #_data + 1
        -- Cell events:
        elseif fn == "cellTouched" then         -- A cell was touched, a1 is cell that be touched. This is not necessary.
            print("cellTouched",a1:getIdx())
            _selIdx = a1:getIdx()
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
        local size = CCSizeMake(winSize.width, (winSize.height - _topLayer:getContentSize().height - _mainLayer:getBottomContentSize().height)*99/100)      -- 这里是为了在tableview上面显示一个小空出来
        print(size.width.." "..size.height)
        _tableView = LuaTableView:createWithHandler(h, size)
        _tableView:setBounceable(true)
        _tableView:setAnchorPoint(ccp(0,0))
        _tableView:setPosition(ccp(0, _mainLayer:getBottomContentSize().height))
        _tableView:setVerticalFillOrder(0)
        _layer:addChild(_tableView)
    end
end

local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/HeroesView.ccbi",proxy, true,"HeroesLayer")
    _layer = tolua.cast(node,"CCLayer")

    _huoBanBtn = tolua.cast(HeroesLayerOwner["HuoBanBtn"],"CCMenuItemImage")
    _hunPoBtn = tolua.cast(HeroesLayerOwner["HunPoBtn"],"CCMenuItemImage")
    _setSpriteFrame(_huoBanBtn,true)
    _setSpriteFrame(_hunPoBtn,false)
end

local function setMenuPriority()
    local menu = tolua.cast(HeroesLayer["heroTopMenu"], "CCMenu")
    menu:setHandlerPriority(-300)
end


function getHeroesLayer()
	return _layer   
end

function createHeroesLayer(page)
    _type = page ~= nil and page or 0 
    _init()

    -- 招募选择的英雄
    function _layer:recruitHero(  )
        local function recSoulCallBack( url,rtnData )
            local heroSoulId = ""
            for k,v in pairs(rtnData["info"]) do
                if havePrefix(k, "hero") then
                    herodata:addHeroByDic(v)
                    heroSoulId = v.heroId
                end
            end 
            local heroRank = herodata:getHeroConfig(heroSoulId).rank
            -- 为了招募时不出现再刷十次的按钮
            runtimeCache.recruitOption = 1
            palyCallingAnimationOfHeroOnNode(heroSoulId,false, heroRank,nil,nil,0,_layer,false)

            _data = heroSoulData:getAllSoulsInfo()
            cellArray = {}
            
            _tableView:reloadData()

            generateCellAction( cellArray,#_data + 1 )
            cellArray = {}
        end 
        local hunPoInfo = _data[_selIdx+1]
        if hunPoInfo then 
            doActionFun("RECRUITSOUL_URL", { hunPoInfo.id }, recSoulCallBack)
        end 
    end

    function _layer:clickHunPo(  )
        _setSpriteFrame(_huoBanBtn,false)
        _setSpriteFrame(_hunPoBtn,true)
    end
    -- 突破选择的英雄
    function _layer:breakHero(  )
        local function breakCallBack( url,rtnData )
            for k,v in pairs(rtnData["info"]) do
                if havePrefix(k, "hero") then
                    herodata:addHeroByDic(v)
                end
            end 

            _data = heroSoulData:getAllSoulsInfo()
            cellArray = {}
            
            _tableView:reloadData()

            generateCellAction( cellArray,#_data + 1 )
            cellArray = {}
        end 
        local hunPoInfo = _data[_selIdx+1]
        if hunPoInfo then 
            doActionFun("BREAKHERO_URL", { hunPoInfo.id }, breakCallBack)
        end 
    end

    local function _onEnter()
        print("HeroesLayer onEnter")
        cellArray = {}
        if _type == 0 then
            _data = herodata:getAllHeroes()
        else
            _data = heroSoulData:getAllSoulsInfo()
        end
        _addTableView()
        _tableView:reloadData()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.3), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
        if runtimeCache.huobanTableOffsetY ~= nil then
            _tableView:setContentOffset(ccp(0, runtimeCache.huobanTableOffsetY))
        end
        runtimeCache.huobanTableOffsetY = nil
        
        generateCellAction( cellArray,#_data + 1 )
        cellArray = {}
        if runtimeCache.levelGuideNext and runtimeCache.levelGuideNext == "soul" then
            onHunPoClicked()
        end
    end

    local function _onExit()
        print("HeroesLayer onExit")
        _layer = nil
        _tableView = nil
        _type = 0
        _selIdx = 0
        runtimeCache.levelGuideNext = nil
        cellArray = {}
    end

    --onEnter onExit
    local function _layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        end
    end


    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end