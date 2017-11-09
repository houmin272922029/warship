local _layer
local progress
local _uid
local initContentInfo = {} -- 存储初始的内容信息
local tempContentInfo = {} -- 存储临时的内容信息
local materialArray = {} -- 被选为材料的id数组
local materialInfo         -- 所有可以被用来使用的材料数组
local selectStateArray = {} -- 记录选中的状态 0 未选中  1 选中
local _tableView1
-- ·名字不要重复
ShadowUpdateLayerOwner = ShadowUpdateLayerOwner or {}
ccb["ShadowUpdateLayerOwner"] = ShadowUpdateLayerOwner

local function setExitBtnState(  )
    local sprite = tolua.cast(ShadowUpdateLayerOwner["exitSprite"],"CCSprite")
    for i,v in ipairs(selectStateArray) do
        if v == 1 then
            sprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("fangqi_text.png"))
            return
        end
    end
    sprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tuichu_title.png"))
end

local function setCenterPersent( nowexp,nextexp )
    local persentLabel = tolua.cast(ShadowUpdateLayerOwner["persentLabel"],"CCLabelTTF") 
    persentLabel:setString(nowexp.."/"..nextexp)
    progress:setPercentage(nowexp / nextexp * 100)
end

local function setContentInfo(  )
    local shadowContent = tempContentInfo
    local nameLabel = tolua.cast(ShadowUpdateLayerOwner["nameLabel"],"CCLabelTTF")
    nameLabel:setString(shadowContent.conf.name)
    local rankLayer = tolua.cast(ShadowUpdateLayerOwner["rankLayer"],"CCLayer")
    if shadowContent.conf.icon then
        playCustomFrameAnimation( string.format("yingzi_%s_",shadowContent.conf.icon),rankLayer,ccp(rankLayer:getContentSize().width / 2,rankLayer:getContentSize().height / 2),1,4,shadowData:getColorByColorRank( shadowContent.conf.rank ) )
    end
    local shadowRankSprite = tolua.cast(ShadowUpdateLayerOwner["shadowRankSprite"],"CCSprite")
    shadowRankSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("rank_%d_icon.png", shadowContent.conf.rank)))

    local levelLabel = tolua.cast(ShadowUpdateLayerOwner["levelLabel"],"CCLabelTTF")
    levelLabel:setString(string.format("LV:%s",shadowContent.shadow["level"]))


    -- tempLevel = _allInfo["level"]
    local levelIconTTF = tolua.cast(ShadowUpdateLayerOwner["levelIconTTF"],"CCLabelTTF")
    levelIconTTF:setString( shadowContent.shadow["level"] )
    local currentAttr = tolua.cast(ShadowUpdateLayerOwner["currentAttr"],"CCLabelTTF")
    local currentData = shadowData:getShadowAttrByLevelAndCid( shadowContent.shadow["level"],shadowContent.shadow.shadowId )
    currentAttr:setString(string.format("+%s",currentData.value))
    local nextAttr = tolua.cast(ShadowUpdateLayerOwner["nextAttr"],"CCLabelTTF")
    local nextData = shadowData:getShadowAttrByLevelAndCid( shadowContent.shadow["level"] + 1,shadowContent.shadow.shadowId )
    nextAttr:setString(string.format("+%s",nextData.value))
    
    local attSprite1 = tolua.cast(ShadowUpdateLayerOwner["attSprite1"],"CCSprite")
    local attSprite2 = tolua.cast(ShadowUpdateLayerOwner["attSprite2"],"CCSprite")
    attSprite1:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(equipdata:getDisplayFrameByType(currentData.type)))
    attSprite2:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(equipdata:getDisplayFrameByType(nextData.type)))
end

local function refreshTableView(  )
    local offsetY = _tableView1:getContentOffset().y
    _tableView1:reloadData()
    local tableViewContent = tolua.cast(ShadowUpdateLayerOwner["tableViewContent"],"CCLayer")
    if (_tableView1:getContentSize().height - tableViewContent:getContentSize().height + 10) >= math.abs(offsetY) then
        _tableView1:setContentOffset(ccp(0,offsetY))
    end
end

local function _addTableView()
    -- 得到数据
    materialInfo = shadowData:getCanUserShadowMaterialByUid(_uid)

    ShadowUpdateMaterialCellOwner = ShadowUpdateMaterialCellOwner or {}
    ccb["ShadowUpdateMaterialCellOwner"] = ShadowUpdateMaterialCellOwner

    local function shadowBtnAction(tag, sender)
        local item = materialInfo[tag]
        -- 把id加入材料数组
        local canGaveEXP = shadowData:oneShadowCanGaveEXP(item.shadow.shadowId, item.conf.rank, item.shadow.level) + item.shadow.expNow
        if selectStateArray[tag] == 1 then
            -- 取消选中状态
            selectStateArray[tag] = 0 
            canGaveEXP = 0 - canGaveEXP
        elseif selectStateArray[tag] == 0 then
            -- 选中动作
            selectStateArray[tag] = 1
        end
        -- tempContentInfo
        local pastExp = tempContentInfo.shadow.expNow
        local nowExp = 0
        
        local function addExp(expPool, level, nowHave)
            if expPool >= 0 then
                local needExp = shadowData:getNeedEXPToNextLevel(level, tempContentInfo.conf.rank)
                if not needExp then
                    return {expPool + nowHave, level}
                end
                if expPool + nowHave >= needExp then
                    return addExp(expPool + nowHave - needExp, level + 1, 0)
                else
                    return {expPool + nowHave, level}
                end
            else
                if nowHave + expPool < 0 then
                    local needExp = shadowData:getNeedEXPToNextLevel(level - 1, tempContentInfo.conf.rank)
                    if nowHave + expPool + needExp < 0 then
                        return addExp( expPool + nowHave + needExp,level - 1,0 )
                    else
                        return {nowHave + expPool + needExp,level - 1}
                    end 
                else
                    return {nowHave + expPool,level}
                end
            end
        end
        local finalResult = addExp( canGaveEXP,tempContentInfo.shadow.level,pastExp )
        tempContentInfo.shadow.level = finalResult[2]
        tempContentInfo.shadow.expNow = finalResult[1]
        setCenterPersent(tempContentInfo.shadow.expNow, shadowData:getNeedEXPToNextLevel(tempContentInfo.shadow.level, tempContentInfo.conf.rank))
        setContentInfo()
        refreshTableView()
        setExitBtnState()    --- 刷新退出按钮的显示
        -- 修改状态数组
        -- 刷新tableview
    end
    ShadowUpdateMaterialCellOwner["shadowBtnAction"] = shadowBtnAction
    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
                r = CCSizeMake(winSize.width,155 * retina)
        elseif fn == "cellAtIndex" then
            -- Return CCTableViewCell, a1 is cell index (zero based), a2 is dequeued cell (maybe nil)
            -- Do something to create cell  and change the content
            
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            --单条数据
            
            local  proxy = CCBProxy:create()
            local  _hbCell = tolua.cast(CCBReaderLoad("ccbResources/ShadowUpdateMaterialCell.ccbi",proxy,true,"ShadowUpdateMaterialCellOwner"),"CCLayer")
            for i=1,5 do
                if a1 * 5 + i <= getMyTableCount(materialInfo) then
                    local item = materialInfo[a1 * 5 + i]
                    -- PrintTable(item)
                    local nameLabel = tolua.cast(ShadowUpdateMaterialCellOwner[string.format("nameLabel%d",i)],"CCLabelTTF")
                    nameLabel:setString(item.conf.name)

                    local rankSprite = tolua.cast(ShadowUpdateMaterialCellOwner[string.format("rankSprite%d",i)],"CCLayer")
                    if item.conf.icon then
                        playCustomFrameAnimation( string.format("yingzi_%s_",item.conf.icon),rankSprite,ccp(rankSprite:getContentSize().width / 2,rankSprite:getContentSize().height / 2),1,4,shadowData:getColorByColorRank( item.conf.rank ) )
                    end

                    local avatarBtn = tolua.cast(ShadowUpdateMaterialCellOwner[string.format("avatarBtn%d",i)],"CCMenuItemImage")
                    avatarBtn:setTag(a1 * 5 + i)

                    local levelTTF = tolua.cast(ShadowUpdateMaterialCellOwner["levelTTF"..i],"CCLabelTTF")
                    levelTTF:setString(item.shadow.level) 

                    -- local shadowLayer = tolua.cast(ShadowUpdateMaterialCellOwner[string.format("shadowLayer%d",i)],"CCLayer")
                    local shadowSprite = tolua.cast(rankSprite:getChildByTag(9888),"CCSprite")
                    if not selectStateArray[a1 * 5 + i] and shadowSprite then
                        -- shadowLayer:setVisible(false)
                        shadowSprite:setColor(shadowData:getColorByColorRank( item.conf.rank ))
                        selectStateArray[a1 * 5 + i] = 0
                    else
                        if selectStateArray[a1 * 5 + i] == 0 and shadowSprite then
                            -- 未选中
                            shadowSprite:setColor(shadowData:getColorByColorRank( item.conf.rank ))
                            -- shadowLayer:setVisible(false)
                        elseif selectStateArray[a1 * 5 + i] == 1 and shadowSprite then
                            -- 已选中
                            shadowSprite:setColor(ccc3(102,102,102))
                            -- shadowLayer:setVisible(true)
                        end
                    end
                else
                    local nameLabel = tolua.cast(ShadowUpdateMaterialCellOwner[string.format("nameLabel%d",i)],"CCLabelTTF")
                    nameLabel:setVisible(false)
                    local rankSprite = tolua.cast(ShadowUpdateMaterialCellOwner[string.format("rankSprite%d",i)],"CCLayer")
                    rankSprite:setVisible(false)
                    local avatarBtn = tolua.cast(ShadowUpdateMaterialCellOwner[string.format("avatarBtn%d",i)],"CCMenuItemImage")
                    avatarBtn:setVisible(false)
                    avatarBtn:setEnabled(false)
                end
            end

            _hbCell:setScale(retina)
            a2:addChild(_hbCell, 0, 1)
            a2:setAnchorPoint(ccp(200, 0))
            a2:setPosition(0, 0)
            r = a2
        elseif fn == "numberOfCells" then
            r = math.ceil(getMyTableCount(materialInfo) / 5)
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
    local tableViewContent = tolua.cast(ShadowUpdateLayerOwner["tableViewContent"],"CCLayer")
    local size = CCSizeMake(winSize.width, tableViewContent:getContentSize().height - 10)
    _tableView1 = LuaTableView:createWithHandler(h, size)
    _tableView1:setBounceable(true)
    _tableView1:setAnchorPoint(ccp(0,0))
    _tableView1:setPosition(0, getMainLayer():getBottomContentSize().height + 125 * retina)
    _tableView1:setVerticalFillOrder(0)
    _layer:addChild(_tableView1,1000)
end

local function shadowUpdateCallBack( url,rtnData )
    if rtnData.code == 200 then
        for k,v in pairs(rtnData.info.shadows) do
            shadowData:updateShadowByDic(k,v)
        end
        if rtnData.info.heros then
            for k,v in pairs(rtnData.info.heros) do
                if herodata.heroes[k] then
                    herodata.heroes[k] = v
                end     
            end
        end
        materialInfo = shadowData:getCanUserShadowMaterialByUid(_uid)
        selectStateArray = {}
        initContentInfo = deepcopy(shadowData:getOneShadowByUID(_uid))
        tempContentInfo = initContentInfo
        setCenterPersent( tempContentInfo.shadow.expNow, shadowData:getNeedEXPToNextLevel(tempContentInfo.shadow.level, tempContentInfo.conf.rank))
        setContentInfo()
        refreshTableView()
        setExitBtnState()
    end
end

local function updateShadowAction(  )
    materialArray = {}
    for i,v in ipairs(selectStateArray) do
        if v == 1 then
            local item = materialInfo[i]
            table.insert(materialArray, item.shadow.id)
        end
    end
    if getMyTableCount(materialArray) > 0 then
        local array = {_uid, materialArray}
        doActionFun("SHADOW_UPDATE_URL",array,shadowUpdateCallBack)
    end
end
ShadowUpdateLayerOwner["updateShadowAction"] = updateShadowAction

local function exitBtnAction(  )
    for i,v in ipairs(selectStateArray) do
        if v == 1 then
            -- 执行放弃所有动作
            selectStateArray = {}
            tempContentInfo = initContentInfo
            setCenterPersent(tempContentInfo.shadow.expNow, shadowData:getNeedEXPToNextLevel(tempContentInfo.shadow.level, tempContentInfo.conf.rank))
            setContentInfo()
            refreshTableView()
            setExitBtnState() 
            return
        end
    end
    if getMainLayer() then
        getMainLayer():gotoTrainShadowView( 2 )
    end
end

ShadowUpdateLayerOwner["exitBtnAction"] = exitBtnAction

local function chooseRankClick(tag)
    tempContentInfo = deepcopy(initContentInfo)
    local nextExp = shadowData:getNeedEXPToNextLevel(tempContentInfo.shadow.level, tempContentInfo.conf.rank)
    local nowExp = tempContentInfo.shadow.expNow
    local need = nextExp - nowExp
    selectStateArray = {}
    local total = 0
    for i,item in ipairs(materialInfo) do
        selectStateArray[i] = 0
        if item.shadow.level == 1 and item.conf.rank == tag then
            local exp = shadowData:oneShadowCanGaveEXP(item.shadow.shadowId, item.conf.rank, item.shadow.level)
            total = total + exp
            need = need - exp
            selectStateArray[i] = 1
        end
        if need <= 0 then
            break
        end
    end
    tempContentInfo.shadow.expNow = nowExp + total
    if tempContentInfo.shadow.expNow >= nextExp and shadowData:getNeedEXPToNextLevel(tempContentInfo.shadow.level + 1, tempContentInfo.conf.rank) then
        tempContentInfo.shadow.level = tempContentInfo.shadow.level + 1
        tempContentInfo.shadow.expNow = tempContentInfo.shadow.expNow - nextExp
    end
    setCenterPersent(tempContentInfo.shadow.expNow, shadowData:getNeedEXPToNextLevel(tempContentInfo.shadow.level, tempContentInfo.conf.rank))
    setContentInfo()
    refreshTableView()
    setExitBtnState() 
end
ShadowUpdateLayerOwner["chooseRankClick"] = chooseRankClick

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/ShadowUpdateView.ccbi",proxy, true,"ShadowUpdateLayerOwner")
    _layer = tolua.cast(node,"CCLayer")

    -- 初始化进度条
    local progressBg = tolua.cast(ShadowUpdateLayerOwner["progressBg"],"CCLayer")
    progressBg:setVisible(true)

    progress = CCProgressTimer:create(CCSprite:create("images/blueBattleShip.png"))
    progress:setType(kCCProgressTimerTypeBar)
    progress:setMidpoint(CCPointMake(0, 0))
    progress:setBarChangeRate(CCPointMake(1, 0))
    
    progressBg:addChild(progress,0)
    progress:setPercentage(50)
    progress:setPosition(ccp(progressBg:getContentSize().width / 2, progressBg:getContentSize().height / 2))

    -- 设置内容
    -- getAllInfo()
    -- setContentInfo()

    -- 初始化表格背景图大小
    local tableViewBg = tolua.cast(ShadowUpdateLayerOwner["tableViewBg"],"CCScale9Sprite")
    local height = tableViewBg:getPositionY() - getMainLayer():getBottomContentSize().height - 120 * retina
    tableViewBg:setContentSize(CCSizeMake(tableViewBg:getContentSize().width,height / retina))
    local tableViewContent = tolua.cast(ShadowUpdateLayerOwner["tableViewContent"],"CCLayer")
    tableViewContent:setContentSize(CCSizeMake(tableViewBg:getContentSize().width, height))

    initContentInfo = deepcopy(shadowData:getOneShadowByUID(_uid))
    tempContentInfo = deepcopy(initContentInfo)

    setContentInfo()
    local nextNeedEXP = shadowData:getNeedEXPToNextLevel(initContentInfo.shadow.level, initContentInfo.conf.rank)
    
    setCenterPersent(initContentInfo.shadow.expNow,nextNeedEXP)
end

local function setMenuPriority()
    local menu = tolua.cast(ShadowUpdateLayerOwner["menu"], "CCMenu")
    menu:setHandlerPriority(-130)
end

-- 该方法名字每个文件不要重复
function getShadowLayer()
    return _layer
end

function createShadowUpdateLayer(shadowUID)
    _uid = shadowUID

    _init()

    function _layer:refresh()
        
    end

    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
        _addTableView()
    end

    local function _onExit()
        -- _layer = nil
        progress = nil
        _uid = nil
        selectStateArray = {}
        initContentInfo = {}
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