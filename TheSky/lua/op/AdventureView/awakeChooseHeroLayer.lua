
local _layer
local _priority
local _contentLayer 

local _herosData
local _selected = -1
local _tableView

AwakeChooseHeroViewOwner = AwakeChooseHeroViewOwner or {}
ccb["AwakeChooseHeroViewOwner"] = AwakeChooseHeroViewOwner

AwakeChooseHeroCellOwner = AwakeChooseHeroCellOwner or {}
ccb["AwakeChooseHeroCellOwner"] = AwakeChooseHeroCellOwner

local function closeItemClick()
    popUpCloseAction(AwakeChooseHeroViewOwner, "infoBg", _layer )
end
AwakeChooseHeroViewOwner["closeItemClick"] = closeItemClick

local function confirmItemClick(tag)
    if _selected == -1 then
        ShowText( HLNSLocalizedString("adventure.awake.ChoseHero.haventChose"))
    else
        local heroId = _herosData[_selected + 1].id
        awakedata.data.currWakeHero = _herosData[_selected + 1].id
        awakedata.heros = _herosData[_selected + 1]
        postNotification(NOTI_AWAKEN_CHOOSE, nil)
        popUpCloseAction(AwakeChooseHeroViewOwner, "infoBg", _layer )
    end
end
AwakeChooseHeroViewOwner["confirmItemClick"] = confirmItemClick


local function cancelItemClick(tag)
    popUpCloseAction(AwakeChooseHeroViewOwner, "infoBg", _layer )
end
AwakeChooseHeroViewOwner["cancelItemClick"] = cancelItemClick

local function _addTableView()
    local function onHeadIconClicked(tag)
        local heroUid = _herosData[tag + 1]
        if heroUid then
            -- 显示英雄信息
            getMainLayer():addChild(createHeroInfoLayer(heroUid, HeroDetail_Clicked_SelectHero, _priority-4 ))
        end
    end
    AwakeChooseHeroCellOwner["onHeadIconClicked"] = onHeadIconClicked   

    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake( 620,165 )
        elseif fn == "cellAtIndex" then
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            local  proxy = CCBProxy:create()
            local  _hbCell = tolua.cast(CCBReaderLoad("ccbResources/AwakeChooseHeroCell.ccbi",proxy,true, "AwakeChooseHeroCellOwner"),"CCSprite")

            local hero = _herosData[a1 + 1]
            local rankNumber = hero.rank
            if herodata:getHeroInfoById(hero.heroId) then
                rankNumber = herodata:getHeroInfoById(hero.heroId).rank
            end
            local frame = tolua.cast(AwakeChooseHeroCellOwner["frame"], "CCSprite")
            frame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", rankNumber)))
            local headIconBtn = tolua.cast(AwakeChooseHeroCellOwner["headIconBtn"], "CCMenuItemImage")
            if headIconBtn then
                headIconBtn:setTag(a1)
                local headSpr = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(herodata:getHeroHeadByHeroId(hero.heroId))
                if headSpr then
                    headIconBtn:setNormalSpriteFrame(headSpr)
                end
            end 
            local breakLevel = AwakeChooseHeroCellOwner["breakLevel"]
            local breakLevelFnt = tolua.cast(AwakeChooseHeroCellOwner["breakLevelFnt"], "CCLabelBMFont")
            local breakValue = hero["break"]
            if breakLevel and breakValue ~= 0 then
                breakLevel:setVisible(true)
                breakLevelFnt:setString(breakValue)
            end 
            local name = tolua.cast(AwakeChooseHeroCellOwner["name"], "CCLabelTTF")
            name:setString(hero.name)

            local rank = tolua.cast(AwakeChooseHeroCellOwner["rank"], "CCSprite")
            rank:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("rank_%d_icon.png", rankNumber)))
            local level = tolua.cast(AwakeChooseHeroCellOwner["level"], "CCLabelTTF")
            level:setString(hero.level)
            
            local stamp = tolua.cast(AwakeChooseHeroCellOwner["stamp"], "CCSprite")
            local bg = tolua.cast(AwakeChooseHeroCellOwner["bg"], "CCSprite")
            if a1 == _selected then
                stamp:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("stamp3.png"))
                bg:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("huobanCellBg_sel.png"))
            end
            --是否已上阵
            local ifOnForm = tolua.cast(AwakeChooseHeroCellOwner["ifOnForm"], "CCLabelTTF")
            if hero.form  == 1 then
                ifOnForm:setString( HLNSLocalizedString("daily.drinkW.ChoseHero.onform")  )
            elseif hero.form == 0 then
                ifOnForm:setString(" ")
            end

            -- 字样 觉醒已完成阶段：
            local AddedPoint = tolua.cast(AwakeChooseHeroCellOwner["AddedPoint"], "CCLabelTTF")
            AddedPoint:setString(HLNSLocalizedString("adventure.awake.stage" ))
            
            local _curHeroUId = _herosData[a1 + 1].id
            --PrintTable(herodata:getHeroInfoByHeroUId(_curHeroUId))
            local stage = 0    -- 阶段
            local stageNum = 0 -- 总阶段
            local changeConf
            local heros = herodata:getHeroInfoById(herodata:getHeroIdByUId(_curHeroUId))
            if heros and heros.rank == 4 then --如果觉醒则更换配置
                changeConf = ConfigureStorage.awave_goldmission
            else
                changeConf = ConfigureStorage.bluemission
            end
            
            if heros.giveUpId then
                stage = changeConf[tostring(heros.giveUpId)].stage
                stageNum = changeConf[tostring(heros.giveUpId)].stageNum
            end
            local playerStageInfo = tolua.cast(AwakeChooseHeroCellOwner["playerStageInfo"], "CCLabelTTF")
            playerStageInfo:setString(  string.format("%d/%d", stage , stageNum) ) 

            a2:addChild(_hbCell, 0, 100)
            _hbCell:setAnchorPoint(ccp(0.5, 0))
            _hbCell:setPosition( _contentLayer:getContentSize().width / 2, 0)  

            r = a2
        elseif fn == "numberOfCells" then
            r = #_herosData
        elseif fn == "cellTouched" then         
            local headIconBtn = tolua.cast(a1:getChildByTag(100):getChildByTag(100):getChildByTag(100):getChildByTag(a1:getIdx()), "CCMenuItemImage")
            if headIconBtn:isSelected() then
                return r
            end
            _selected = _selected == a1:getIdx() and -1 or a1:getIdx()
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
    local infoBg = tolua.cast(AwakeChooseHeroViewOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction(AwakeChooseHeroViewOwner, "infoBg", _layer)
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
    local menu = tolua.cast(AwakeChooseHeroViewOwner["menu"], "CCMenu")
    menu:setTouchPriority(_priority - 2)
   _tableView:setTouchPriority(_priority - 2)
 
end

function getAwakeChooseHeroLayer()
    return _layer
end

local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/AwakeChooseHeroView.ccbi",proxy, true,"AwakeChooseHeroViewOwner")
    _layer = tolua.cast(node,"CCLayer")
    _contentLayer = AwakeChooseHeroViewOwner["contentLayer"]

    local title = tolua.cast(AwakeChooseHeroViewOwner["title"], "CCLabelTTF")
    title:setString( HLNSLocalizedString("adventure.awake.ChoseHero"))
   
    _herosData = herodata:getAllAwakeHeroes() 
    -- 如果没有伙伴就提示前往招募
    -- if #_herosData == 0 and not herodata.heroes[index] then
    --     local function cardConfirmAction()
    --         _layer:removeFromParentAndCleanup(true) 
    --         if getMainLayer() then
    --             getMainLayer():goToLogue()
    --             getLogueTownLayer():gotoPageByType( 0 )
    --         end
    --     end
    --     local function cardCancelAction()
    --     end
    --     local text = HLNSLocalizedString("adventure.awake.NeedHero")
    --     _layer:addChild(createSimpleConfirCardLayer(text), 100)
    --     SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
    --     SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction
    -- end
    
    _addTableView()
    _tableView:reloadData()
end



function createAwakeChooseHeroLayer(priority) --priority -140
    _priority = (priority ~= nil) and priority or -140

    _init()
    function _layer:selectHero(index)
        _selected = index
        local offsetY = _tableView:getContentOffset().y
        _tableView:reloadData()
        _tableView:setContentOffset(ccp(0, offsetY))
    end

    function _layer:confirmItemClick()
        confirmItemClick()
    end

    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
        popUpUiAction(AwakeChooseHeroViewOwner, "infoBg")
    end

    local function _onExit()
        _layer = nil
        _selected = -1
        _tableView = nil
       
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