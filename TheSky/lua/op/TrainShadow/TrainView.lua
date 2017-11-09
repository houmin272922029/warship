local _layer
local tableContentSprite
local stateArray = {}       -- 存储每一个位置索引的位置信息和缩放比例信息
local luffyPosArray = {}    -- 存储每一个精灵当前所在位置的索引

local shadowArray = {}          -- 所有影子的数据

local _tableView
local isAnimation = false

local SHADOW_QUALITY = {{1,2},{1,2,3},{1,2,3,4},{2,3,4},{3,4,5,0}}
local SHADOW_QUALITY_COUNT = {2,3,4,3,4}

local _haveJianJue = false
-- 名字不要重复
TrainShadowContentOwner = TrainShadowContentOwner or {}
ccb["TrainShadowContentOwner"] = TrainShadowContentOwner

-- TrainShadowContentOwner["recruitAction"] = recruitAction

local function normalTheBtn( btn)
    btn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn3_0.png"))
    btn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName( "btn3_1.png"))
end

local function blackTheBtn( btn)
    btn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn3_2.png"))
    btn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName( "btn3_2.png"))
end
--刷新坚决和拼命两个按钮
local function _refresh_JianJue_PinMing_TwoBtn()
    local btn1 = tolua.cast(TrainShadowContentOwner["trainByHeartBtn"] , "CCMenuItemImage")
    local btn2 = tolua.cast(TrainShadowContentOwner["trainAtFullSplitBtn"] , "CCMenuItemImage")
    local center = shadowData:getCenterIndex()
    print("**lsf 拼命1 callback center",center)
    if center == 4 then
        blackTheBtn( btn1)
    elseif center == 5 then
        print("**lsf center == 5")
        blackTheBtn( btn1)
        blackTheBtn( btn2)
    else
        normalTheBtn( btn1)
        normalTheBtn( btn2)
    end

end

-- 刷新文字显示
local function refreshGoldAndBerryLabels( pos )
    local needBerry = shadowData:getTrainShadowNeedBerry( pos )
    local berryLabel = tolua.cast(TrainShadowContentOwner["berryLabel"],"CCLabelTTF")
    berryLabel:setString(needBerry)
    local needGold = shadowData:getChangeStatusNeedGold(  ) 
    local goldLabel = tolua.cast(TrainShadowContentOwner["goldLabel"],"CCLabelTTF")
    goldLabel:setString(needGold)
end

-- 生成一个动作序列 
local function generateActionSequence( nowPos,desPos,duration )
    local array = CCArray:create()
    local flageNum = nowPos > desPos and -1 or 1
    local time = duration / (desPos - nowPos) * flageNum
    for i=nowPos,desPos - flageNum,flageNum do
        local value = 5 - math.abs(i + flageNum - 5)
        local currentState = stateArray[i]
        local desState = stateArray[i + flageNum]
        local spawn = CCSpawn:createWithTwoActions(CCMoveTo:create(time, desState.pos),CCScaleTo:create( time,desState.scale))
        array:addObject(spawn)
        local function setCustomzorder( sender )
            sender:getParent():reorderChild(sender,value)
        end
        array:addObject(CCCallFuncN:create(setCustomzorder))
    end 
    local function setAnimation(  )
        isAnimation = false 
    end
    array:addObject(CCCallFunc:create(setAnimation))
    return CCSequence:create(array)
end

local function showQuality( center )
    local qualityCount = SHADOW_QUALITY_COUNT[center]
    local shadowQuality = SHADOW_QUALITY[center]

    local qualityBg = tolua.cast(TrainShadowContentOwner["qualityBg"],"CCLayer")
    qualityBg:removeAllChildrenWithCleanup(true)
    
    for i=1,qualityCount do
        local quality = nil
        if shadowQuality[i] > 0 then
            quality = CCSprite:createWithSpriteFrameName(string.format("rank_%d_icon.png", shadowQuality[i]))
            quality:setScale(0.8)
        else
            quality = CCSprite:createWithSpriteFrameName("shadow_icon.png")
            quality:setScale(1)
        end 
        
        quality:setPosition(ccp(qualityBg:getContentSize().width / 2, qualityBg:getContentSize().height / (qualityCount + 1) * i))
        qualityBg:addChild(quality)
    end
end 

-- 1：要居中显示的路飞位置索引  2：动画的时间间隔
local function animationAction( spriteIndex,duration )
    isAnimation = true
    refreshGoldAndBerryLabels(spriteIndex)
    local offset = 5 - luffyPosArray[tonumber(spriteIndex)]
    if offset == 0 then
        isAnimation = false
        return
    end
    for i=1,5 do
        local nowPos = luffyPosArray[i]
        local aniLuffySprite = tolua.cast(TrainShadowContentOwner["aniLuffySprite"..i],"CCSprite")
        aniLuffySprite:runAction(generateActionSequence( nowPos,nowPos + offset,duration))
        luffyPosArray[i] = nowPos + offset
    end
    -- 更新中间文字显示
    local function setFontAction(  )
        local luffyDespWord = tolua.cast(TrainShadowContentOwner["luffyDespWord"],"CCSprite")
        luffyDespWord:getParent():reorderChild(luffyDespWord,6)
        luffyDespWord:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("lianying_text_%d.png", spriteIndex)))
    end
    _layer:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(duration), CCCallFunc:create(setFontAction)))

    showQuality(spriteIndex)
end

-- 刷新table的偏移量，当影子多国一个页面的时候让最下边的能够显示
local function refreshShadowTableContentOffSet(  )
    local contentHeight = _tableView:getContentSize().height
    local viewHeight =  tableContentSprite:getContentSize().height * retina
    if contentHeight > viewHeight then
        _tableView:setContentOffset(ccp(0,0))
    end
end

local function getIconPos(  )
    -- local cell = _tableView:cellAtIndex(math.ceil(getMyTableCount(shadowArray) / 5) - 1) 
    -- -- -- local item = cell:getChildByTag(100)
    -- -- local cell = _tableView:cellAtIndex(6)
    -- if cell then
    --     -- print("位置信息",cell:getPositionY(),cell,getPositionX())
    --     -- cell:setVisible(false)
    -- end
    -- local offset = _tableView:getContentOffset().y
    -- 155 * retina * (math.ceil(getMyTableCount(shadowArray) / 5) - math.ceil(getMyTableCount(shadowArray) / 5),)
end

local function _addTableView()
    shadowArray = shadowData:getAllShadowData(  )
    TrainShadowCellOwner = TrainShadowCellOwner or {}
    ccb["TrainShadowCellOwner"] = TrainShadowCellOwner

    local function shadowBtnAction( tag,sender )
        local item = shadowArray[tonumber(tag)]
        CCDirector:sharedDirector():getRunningScene():addChild(createShadowPopupLayer(item, nil, nil, -132, 1),100)
    end

    TrainShadowCellOwner["shadowBtnAction"] = shadowBtnAction

    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            -- r = CCSizeMake(tableContentSprite:getContentSize().width , 155)
            r = CCSizeMake(winSize.width,155 * retina)
        elseif fn == "cellAtIndex" then
            -- Return CCTableViewCell, a1 is cell index (zero based), a2 is dequeued cell (maybe nil)
            -- Do something to create cell  and change the content
            
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            local  proxy = CCBProxy:create()
            local _hbCell  = tolua.cast(CCBReaderLoad("ccbResources/TrainShadowCell.ccbi",proxy,true,"TrainShadowCellOwner"),"CCLayer")
            
            for i=1,5 do
                if a1 * 5 + i <= getMyTableCount(shadowArray) then
                    local item = shadowArray[a1 * 5 + i]
                    local nameLabel = tolua.cast(TrainShadowCellOwner[string.format("nameLabel%d",i)],"CCLabelTTF")
                    nameLabel:setString(item.conf.name)

                    local rankSprite = tolua.cast(TrainShadowCellOwner[string.format("rankSprite%d",i)],"CCLayer")
                    if item.conf.icon then
                        playCustomFrameAnimation( string.format("yingzi_%s_",item.conf.icon),rankSprite,ccp(rankSprite:getContentSize().width / 2,rankSprite:getContentSize().height / 2),1,4,shadowData:getColorByColorRank( item.conf.rank ) )
                    end

                    local avatarBtn = tolua.cast(TrainShadowCellOwner[string.format("avatarBtn%d",i)],"CCMenuItemImage")
                    avatarBtn:setTag(a1 * 5 + i)

                    local levelTTF = tolua.cast(TrainShadowCellOwner["levelTTF"..i],"CCLabelTTF")
                    levelTTF:setString(item.level)
                else
                    local nameLabel = tolua.cast(TrainShadowCellOwner[string.format("nameLabel%d",i)],"CCLabelTTF")
                    nameLabel:setVisible(false)
                    local rankSprite = tolua.cast(TrainShadowCellOwner[string.format("rankSprite%d",i)],"CCLayer")
                    rankSprite:setVisible(false)
                    local avatarBtn = tolua.cast(TrainShadowCellOwner[string.format("avatarBtn%d",i)],"CCMenuItemImage")
                    avatarBtn:setVisible(false)
                    avatarBtn:setEnabled(false)
                end
            end

            _hbCell:setScale(retina)
            a2:addChild(_hbCell, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            r = a2
        elseif fn == "numberOfCells" then
            r = math.ceil(getMyTableCount(shadowArray) / 5)
        -- Cell events:
        elseif fn == "cellTouched" then         -- A cell was touched, a1 is cell that be touched. This is not necessary.
            -- print(a1:getIdx())
        elseif fn == "cellTouchBegan" then      -- A cell is touching, a1 is cell, a2 is CCTouch
        elseif fn == "cellTouchEnded" then      -- A cell was touched, a1 is cell, a2 is CCTouch
        elseif fn == "cellHighlight" then       -- A cell is highlighting, coco2d-x 2.1.3 or above
        elseif fn == "cellUnhighlight" then     -- A cell had been unhighlighted, coco2d-x 2.1.3 or above
        elseif fn == "cellWillRecycle" then     -- A cell will be recycled, coco2d-x 2.1.3 or above
        end
        return r
    end)
        local size = CCSizeMake(winSize.width,tableContentSprite:getContentSize().height * retina)
        _tableView = LuaTableView:createWithHandler(h, size)
        _tableView:setBounceable(true)
        local topLayer = tolua.cast( TrainShadowContentOwner["topLayer"], "CCLayer" )
        _tableView:setAnchorPoint(ccp(0,0))
        _tableView:setPosition(0,winSize.height - topLayer:getContentSize().height - tableContentSprite:getContentSize().height * retina - 10)
        _tableView:setVerticalFillOrder(0)
        _layer:addChild(_tableView)
end   

local function initLuffyPos( posArray )
    local center = shadowData:getCenterIndex()
    refreshGoldAndBerryLabels( center )
    for i=1,5 do
        luffyPosArray[i] = i + 5 - center   -- 5 - center 是偏移量     得到每个的位置索引
        local nowPos = stateArray[luffyPosArray[i]].pos
        local scale = stateArray[luffyPosArray[i]].scale
        local aniLuffySprite = tolua.cast(TrainShadowContentOwner["aniLuffySprite"..i],"CCSprite")
        aniLuffySprite:setPosition(nowPos)
        aniLuffySprite:setScale(scale)
        -- 重设各个的z值
        local value = 5 - math.abs(i - center)
        aniLuffySprite:getParent():reorderChild(aniLuffySprite,value)
    end
    local luffyDespWord = tolua.cast(TrainShadowContentOwner["luffyDespWord"],"CCSprite")
    luffyDespWord:getParent():reorderChild(luffyDespWord,6)
    luffyDespWord:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("lianying_text_%d.png", center)))

    showQuality(center)
end

local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/TrainShadowContentView.ccbi",proxy, true,"TrainShadowContentOwner")
    _layer = tolua.cast(node,"CCLayer") 
    local topLayer = tolua.cast( TrainShadowContentOwner["topLayer"], "CCLayer" )  
    local bottomContentLayer = tolua.cast( TrainShadowContentOwner["bottomContentLayer"], "CCLayer" ) 
    tableContentSprite = tolua.cast( TrainShadowContentOwner["tableContentSprite"], "CCSprite")
    local height = winSize.height - topLayer:getContentSize().height - bottomContentLayer:getContentSize().height * retina - getMainLayer():getBottomContentSize().height - 10
    tableContentSprite:setContentSize(CCSizeMake(tableContentSprite:getContentSize().width,height / retina * 0.98))
    tableContentSprite:setPosition(ccp(winSize.width / 2,winSize.height - topLayer:getContentSize().height - 10))
    bottomContentLayer:setPosition(ccp(bottomContentLayer:getPositionX(),getMainLayer():getBottomContentSize().height))
    local luffyNormal = tolua.cast(TrainShadowContentOwner["luffy5"],"CCSprite")
    for i=1,9 do
        local luffySprite = tolua.cast(TrainShadowContentOwner["luffy"..i],"CCSprite")
        local array = {}
        array.pos = ccp(luffySprite:getPositionX(),luffySprite:getPositionY())
        array.scale = luffySprite:getScale()
        table.insert(stateArray,array)
    end
    initLuffyPos()      -- 初始化路飞的位置
    _refresh_JianJue_PinMing_TwoBtn() --刷新坚决和拼命两个按钮
end

-- 刷新时间ttf
local function refreshTimeLabel(  )
    local timeLablel = tolua.cast(TrainShadowContentOwner["timeLablel"],"CCLabelTTF") 
    local duration = shadowData:getTimeDurationNextFreeTime(  )
    if duration > 0 then
        timeLablel:setVisible(true)
        timeLablel:setString(DateUtil:second2dhms(duration))
    end
end

local function trainShadowCallBack( url,rtnData )
    if rtnData["code"] == 200 then
        _haveJianJue = false
        shadowData.shadowExercise = rtnData.info.shadowExercise
        shadowData.shadowData = rtnData.info.shadowData
        _refresh_JianJue_PinMing_TwoBtn()
        animationAction( shadowData:getCenterIndex(), 0.3 )
        _layer:refreshTableView()
    end
end

-- 练影十次
local function trainShadowTenTimes(  )
    if isAnimation then
        return
    end
    doActionFun("SHADOW_TRAIN_URL", { 10 }, trainShadowCallBack )
end

TrainShadowContentOwner["trainShadowTenTimesAction"] = trainShadowTenTimes

-- 练影一次
local function trainShadowAction(  )
    if isAnimation then
        return
    end
    doActionFun("SHADOW_TRAIN_URL", { 1 }, trainShadowCallBack )
end

TrainShadowContentOwner["trainShadowAction"] = trainShadowAction




-- 坚决
local function trainShadowByHeartCallBack( url,rtnData )
    if rtnData.code == 200 then
        
        _haveJianJue = true
        shadowData.shadowData = rtnData.info.shadowData
        _refresh_JianJue_PinMing_TwoBtn()
        animationAction( shadowData:getCenterIndex(), 0.5 )
        _layer:refreshTableView()
    end
end
local function trainByHeartAction(  )
    if isAnimation then
        return
    end
    if userdata.gold < 200 then
        ShowText(HLNSLocalizedString("ERR_1101"))
        return
    end 
    
    local function sureJianJue(text)
        
        local function cardConfirmAction(  )
            doActionFun("SHADOW_CHANGE_STATUS",{ 4 },trainShadowByHeartCallBack)
        end
        local function cardCancelAction(  )
            
        end
        CCDirector:sharedDirector():getRunningScene():addChild(createSimpleConfirCardLayer(text), 100)
        SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
        SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction
        return
    end

    if shadowData:getCenterIndex() == 5 then
        ShowText(HLNSLocalizedString("shadow.hadReachedTheHighest")) --"已经到达最高级炼影了",
        return
        -- local function cardConfirmAction( )
        --     sureJianJue() 
        --     -- doActionFun("SHADOW_CHANGE_STATUS",{ 4 },trainShadowByHeartCallBack)
        -- end
        -- local function cardCancelAction( )
            
        -- end
        -- getMainLayer():addChild(createSimpleConfirCardLayer(HLNSLocalizedString("pingming.tip")))
        -- SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
        -- SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction
        -- return
    
    elseif shadowData:getCenterIndex() == 4 then
        ShowText(HLNSLocalizedString("shadow.hadReachedTheJianJue")) --"已经到达“坚决”了",
        return

    elseif shadowData:getCenterIndex() ~= 4 then
        local moneyNeed = 200
        local text = HLNSLocalizedString("sureCostGold?",moneyNeed  )  --["sureCostGold?"]  =  "将消耗金币%d，是否继续?",
        sureJianJue(text) 
        -- doActionFun("SHADOW_CHANGE_STATUS",{ 4 },trainShadowByHeartCallBack)
    end
end
TrainShadowContentOwner["trainByHeartAction"] = trainByHeartAction



-- 拼命
local function trainShadowAtFullSplitCallBack( url,rtnData )
    if rtnData.code == 200 then
        print("**lsf 拼命 callback")
        shadowData.shadowData = rtnData.info.shadowData
        _refresh_JianJue_PinMing_TwoBtn()
        animationAction( shadowData:getCenterIndex(), 0.5 )
        _layer:refreshTableView()
    end
end
local function trainAtFullSplitAction(  )
    if isAnimation then
        return
    end
    if userdata.gold < 500 then
        ShowText(HLNSLocalizedString("ERR_1101"))
        return
    end 
    if shadowData:getCenterIndex() == 5 then
        ShowText(HLNSLocalizedString("shadow.hadReachedTheHighest"))
        return
        --[[  
        local function cardConfirmAction( )
            doActionFun("SHADOW_CHANGE_STATUS",{ 4 },trainShadowByHeartCallBack)
        end
        local function cardCancelAction( )
            
        end
        getMainLayer():addChild(createSimpleConfirCardLayer(HLNSLocalizedString("pingming.tip")))
        SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
        SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction
        return
        ]]
    end


    local function surePingMing(text)
        local function cardConfirmAction(  )
            doActionFun("SHADOW_CHANGE_STATUS",{ 5 },trainShadowAtFullSplitCallBack)
        end
        local function cardCancelAction(  )
            
        end
        CCDirector:sharedDirector():getRunningScene():addChild(createSimpleConfirCardLayer(text), 100)
        SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
        SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction
        return
    end
    local moneyNeed = 500
    if shadowData:getCenterIndex() == 4 then
        if _haveJianJue then --是坚决上4的
            local text = HLNSLocalizedString("shadow.surePingMingWithJianJue?")  --"是否放弃“坚决”炼影？将消耗500金币“拼命”炼影",
            surePingMing(text)
            return
        end
    end

    if shadowData:getCenterIndex() ~= 5 then
        local text = HLNSLocalizedString("sureCostGold?",moneyNeed  ) --"确定消耗%d金币吗?",
        surePingMing(text)
        
        -- doActionFun("SHADOW_CHANGE_STATUS",{ 5 },trainShadowAtFullSplitCallBack)
    end
end
TrainShadowContentOwner["trainAtFullSplitAction"] = trainAtFullSplitAction

-- 炼其他
local function trainShadowTrainOtherTimes(  )
    getMainLayer():addChild(createTrainShadowOtherTimesLayer( -140 ))
end
TrainShadowContentOwner["trainShadowTrainOtherTimes"] = trainShadowTrainOtherTimes

-- 该方法名字每个文件不要重复
function getTrainLayer()
    return _layer
end

function createTrainView()
    _init()

    function _layer:refreshTableView()
        shadowArray = shadowData:getAllShadowData(  )
        _tableView:reloadData()
        refreshShadowTableContentOffSet()
    end

    function _layer:refresh()
        
    end

    local function _onEnter()
        _addTableView()
        refreshTimeLabel()
        refreshShadowTableContentOffSet()
        getIconPos()
        addObserver(NOTI_TRINGSHADOW_CD_TIME, refreshTimeLabel)
    end

    local function _onExit()
        tableContentSprite = nil
        stateArray = {}
        _tableView = nil
        isAnimation = false
        _haveJianJue = false
        removeObserver(NOTI_TRINGSHADOW_CD_TIME, refreshTimeLabel)

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