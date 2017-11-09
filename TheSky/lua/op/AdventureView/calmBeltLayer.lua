local _layer
local _data = nil
local _bTableViewTouch
local selectIndex = nil


local progress = nil
local totleTime = 0
local endTime
local isSpeedUpEnd = false -- 是否是加速结束

CalmBeltViewOwner = CalmBeltViewOwner or {}
ccb["CalmBeltViewOwner"] = CalmBeltViewOwner

-- 前往英雄列表页面
local function initAllGradingLayer(  )
    
end
local function refreshTable(  )
    local offset = _tableView:getContentOffset().y
    _tableView:reloadData()
    _tableView:setContentOffset(ccp(0, offset))
end

local function gotoResultPage( heroid,flag )  -- flag代表修炼结果
    local heroListLayer = tolua.cast(CalmBeltViewOwner["heroListLayer"], "CCLayer")
    heroListLayer:setVisible(false)
    local heroInfo = herodata:getHeroInfoByHeroUId( heroid ) 
    local gradeIngLayer = tolua.cast(CalmBeltViewOwner["gradeIngLayer"], "CCLayer")
    gradeIngLayer:setVisible(true)
    local menu = tolua.cast(gradeIngLayer:getChildByTag(1),"CCMenu")

    local avatarBtn = tolua.cast(menu:getChildByTag(1),"CCMenuItemImage")
    avatarBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", heroInfo.rank)))
    avatarBtn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", heroInfo.rank)))


    
    local returnBtn = tolua.cast(menu:getChildByTag(3),"CCMenuItemImage")
    returnBtn:setVisible(true)

    local avatarSprite = tolua.cast(gradeIngLayer:getChildByTag(2),"CCSprite")
    if avatarSprite then
        avatarSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(herodata:getHeroHeadByHeroId(heroInfo.heroId)))
    end 

    local heroLevelLabel = tolua.cast(CalmBeltViewOwner["heroLevelLabel"],"CCLabelTTF")
    heroLevelLabel:setString(heroInfo.level)

    local rankIcon = tolua.cast(CalmBeltViewOwner["rankIcon"],"CCSprite")
    rankIcon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("rank_%d_icon.png", heroInfo.rank)))
                    
    local nameLabel = tolua.cast(CalmBeltViewOwner["nameLabel"],"CCLabelTTF")
    nameLabel:setString(heroInfo.name)

    local grade_bg = tolua.cast(CalmBeltViewOwner["grade_bg"],"CCSprite")
    
    -- 根据结果显示动画
    local gradeLabel = tolua.cast(CalmBeltViewOwner["gradeLabel"],"CCLabelTTF")

    local currentAttr = tolua.cast(CalmBeltViewOwner["currentAttr"],"CCLabelTTF")
    local nextAttrLabel = tolua.cast(CalmBeltViewOwner["nextAttr"],"CCLabelTTF")

    local disciplineData = heroInfo.discipline
    local trainLevelNum = 0
    if disciplineData and getMyTableCount(disciplineData) > 0 then
        trainLevelNum = disciplineData.level
    end
    gradeLabel:setString(trainLevelNum)

    local nowArr
    local nextArr

    if flag then
        nowArr = herodata:getTrainArrByHeroIdAndlevel( heroInfo.heroId,trainLevelNum - 1 )
        nextArr = herodata:getTrainArrByHeroIdAndlevel( heroInfo.heroId,trainLevelNum)
        -- 添加动画并显示
        playCustomFrameAnimation( "grade_frame_",grade_bg,ccp(grade_bg:getContentSize().width / 2,grade_bg:getContentSize().height / 2),1,4 )
    else
        nowArr = herodata:getTrainArrByHeroIdAndlevel( heroInfo.heroId,trainLevelNum)
        nextArr = herodata:getTrainArrByHeroIdAndlevel( heroInfo.heroId,trainLevelNum)
    end

    currentAttr:setString(nowArr["value"])

    nextAttrLabel:setString(nextArr["value"])

    local animationSprite = tolua.cast(CalmBeltViewOwner["animationSprite"],"CCSprite")
    local startSprite = animationSprite:getChildByTag(9888)
    if startSprite then
        startSprite:removeFromParentAndCleanup(true)
    end
    -- playCustomFrameAnimation( "next_frame_",animationSprite,ccp(animationSprite:getContentSize().width / 2,animationSprite:getContentSize().height / 2),1,4 )

    local resultSprite = tolua.cast(CalmBeltViewOwner["resultSprite"],"CCSprite")
    local resultDesp = tolua.cast(CalmBeltViewOwner["resultDesp"],"CCSprite")
    local returnSprite = tolua.cast(CalmBeltViewOwner["returnSprite"],"CCSprite")
    resultSprite:setVisible(true)
    returnSprite:setVisible(true)
    returnSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("confirm_text.png"))
    if flag then
        resultDesp:setVisible(false)
        resultSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("xiulianchenggong_text.png"))
    else
        resultDesp:setVisible(true)
        resultSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("xiulianshibai_text.png"))
    end
    endTime = nil
    local exciseFinish = tolua.cast(CalmBeltViewOwner["exciseFinish"],"CCLabelTTF")
    exciseFinish:setVisible(false)
end

local function gotoHeroListView(  )
    local heroListLayer = tolua.cast(CalmBeltViewOwner["heroListLayer"], "CCLayer")
    heroListLayer:setVisible(true)
    local gradeIngLayer = tolua.cast(CalmBeltViewOwner["gradeIngLayer"], "CCLayer")
    gradeIngLayer:setVisible(false)
    heroDic = herodata:getCanTrainHeros( )
    refreshTable()
    local heroListRaftCount = tolua.cast(CalmBeltViewOwner["heroListRaftCount"],"CCLabelTTF")
    heroListRaftCount:setString(wareHouseData:getItemCount( "item_010" ))
    heroListRaftCount:enableShadow(CCSizeMake(3,-3), 2, 0)
    local heroListWindLabel = tolua.cast(CalmBeltViewOwner["heroListWindLabel"],"CCLabelTTF")
    heroListWindLabel:setString(wareHouseData:getItemCount( "item_016" ))
    heroListWindLabel:enableShadow(CCSizeMake(3,-3), 2, 0)
end

local function refeshTimeLabel(  )
    if endTime then
        local timeLabel = tolua.cast(CalmBeltViewOwner["timeLabel"],"CCLabelTTF") 
        local gradeIngLayer = tolua.cast(CalmBeltViewOwner["gradeIngLayer"], "CCLayer")
        gradeIngLayer:setVisible(true)
        local menu = tolua.cast(gradeIngLayer:getChildByTag(1),"CCMenu")
        local speedBtn = tolua.cast(menu:getChildByTag(2),"CCMenuItemImage")
        speedBtn:setVisible(true)
        local returnBtn = tolua.cast(menu:getChildByTag(3),"CCMenuItemImage")
        
        local exciseFinish = tolua.cast(CalmBeltViewOwner["exciseFinish"],"CCLabelTTF")
        local speedSprite = tolua.cast(CalmBeltViewOwner["speedSprite"],"CCSprite")
        local progressSprite = tolua.cast(CalmBeltViewOwner["progressBg"],"CCSprite")
        local windcowry = tolua.cast(CalmBeltViewOwner["windcowry"],"CCSprite")
        local windcowryCount = tolua.cast(CalmBeltViewOwner["windcowryCount"],"CCLabelTTF")
        windcowryCount:setString(wareHouseData:getItemCount( "item_016" ))
        local needGoldIcon = tolua.cast(CalmBeltViewOwner["needGoldIcon"],"CCSprite")
        local needGoldLabel = tolua.cast(CalmBeltViewOwner["needGoldLabel"],"CCLabelTTF")
        if wareHouseData:getItemCount( "item_016" ) == 0 then
            speedSprite:setPosition(ccp(515,217))
            needGoldIcon:setVisible(true)
            needGoldLabel:setVisible(true)
        else
            speedSprite:setPosition(ccp(515,194))
            needGoldIcon:setVisible(false)
            needGoldLabel:setVisible(false)
        end
        local returnSprite = tolua.cast(CalmBeltViewOwner["returnSprite"],"CCSprite")
        local duration = (endTime - userdata.loginTime)
        if duration > 0 then
            timeLabel:setVisible(true)
            timeLabel:setString(HLNSLocalizedString("beltTime.refresh",DateUtil:second2dhms(duration)))
            speedBtn:setVisible(true)
            speedSprite:setVisible(true)
            exciseFinish:setVisible(false)
            progressSprite:setVisible(true)
            windcowry:setVisible(true)
            windcowryCount:setVisible(true)
            returnBtn:setVisible(false)
            returnSprite:setVisible(false)
        else
            exciseFinish:setVisible(true)
            timeLabel:setVisible(false)
            speedBtn:setVisible(false)
            speedSprite:setVisible(false)
            progressSprite:setVisible(false)
            windcowry:setVisible(false)
            windcowryCount:setVisible(false)
            returnBtn:setVisible(true)
            returnSprite:setVisible(true)
            needGoldIcon:setVisible(false)
            needGoldLabel:setVisible(false)
            returnSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("huigui_text.png"))
            local animationSprite = tolua.cast(CalmBeltViewOwner["animationSprite"],"CCSprite")
            local startSprite = animationSprite:getChildByTag(9888)
            if startSprite then
                startSprite:removeFromParentAndCleanup(true)
            end
        end
        progress:stopAllActions()
        local pre = progress:getPercentage()
        progress:runAction(CCProgressFromTo:create(0.3,pre,duration / totleTime * 100))
    end
end



-- 前往trainginglayer
local function gotoTrainLayer( heroInfo )
    local gradeIngLayer = tolua.cast(CalmBeltViewOwner["gradeIngLayer"], "CCLayer")
    gradeIngLayer:setVisible(true)
    local heroListLayer = tolua.cast(CalmBeltViewOwner["heroListLayer"], "CCLayer")
    heroListLayer:setVisible(false)
    local menu = tolua.cast(gradeIngLayer:getChildByTag(1),"CCMenu")

    local avatarBtn = tolua.cast(menu:getChildByTag(1),"CCMenuItemImage")
    avatarBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", heroInfo.rank)))
    avatarBtn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", heroInfo.rank)))
    
    local returnBtn = tolua.cast(menu:getChildByTag(3),"CCMenuItemImage")
    returnBtn:setVisible(true)

    local avatarSprite = tolua.cast(gradeIngLayer:getChildByTag(2),"CCSprite")
    if avatarSprite then
        avatarSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(herodata:getHeroHeadByHeroId(heroInfo.heroId)))
    end 

    local heroLevelLabel = tolua.cast(CalmBeltViewOwner["heroLevelLabel"],"CCLabelTTF")
    heroLevelLabel:setString(heroInfo.level)

    local rankIcon = tolua.cast(CalmBeltViewOwner["rankIcon"],"CCSprite")
    rankIcon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("rank_%d_icon.png", heroInfo.rank)))
                    
    local nameLabel = tolua.cast(CalmBeltViewOwner["nameLabel"],"CCLabelTTF")
    nameLabel:setString(heroInfo.name)

    local grade_bg = tolua.cast(CalmBeltViewOwner["grade_bg"],"CCSprite")
    local gradeLabel = tolua.cast(CalmBeltViewOwner["gradeLabel"],"CCLabelTTF")

    local currentAttr = tolua.cast(CalmBeltViewOwner["currentAttr"],"CCLabelTTF")
    local nextAttrLabel = tolua.cast(CalmBeltViewOwner["nextAttr"],"CCLabelTTF")

    local disciplineData = heroInfo.discipline
    local trainLevelNum = 0
    if disciplineData and getMyTableCount(disciplineData) > 0 then
        trainLevelNum = disciplineData.level
    end
    gradeLabel:setString(trainLevelNum + 1)
    gradeLabel:enableStroke(ccc3(0,0,0), 0.5)

    local nowArr = herodata:getTrainArrByHeroIdAndlevel( heroInfo.heroId,trainLevelNum )
    local nextArr = herodata:getTrainArrByHeroIdAndlevel( heroInfo.heroId,trainLevelNum + 1 )

    currentAttr:setString(nowArr["value"])

    nextAttrLabel:setString(nextArr["value"])

    local attrDespLabel1 = tolua.cast(CalmBeltViewOwner["attrDespLabel1"],"CCLabelTTF")
    local attrDespLabel2 = tolua.cast(CalmBeltViewOwner["attrDespLabel2"],"CCLabelTTF")
    attrDespLabel1:setString(HLNSLocalizedString(nowArr["type"])..":")
    attrDespLabel2:setString(HLNSLocalizedString(nextArr["type"])..":")

    local animationSprite = tolua.cast(CalmBeltViewOwner["animationSprite"],"CCSprite")
    playCustomFrameAnimation( "next_frame_",animationSprite,ccp(animationSprite:getContentSize().width / 2,animationSprite:getContentSize().height / 2),1,4 )

    local resultSprite = tolua.cast(CalmBeltViewOwner["resultSprite"],"CCSprite")
    local resultDesp = tolua.cast(CalmBeltViewOwner["resultDesp"],"CCSprite")
    local returnSprite = tolua.cast(CalmBeltViewOwner["returnSprite"],"CCSprite")
    resultSprite:setVisible(false)
    resultDesp:setVisible(false)
end



local function _addTableView()
    -- 得到数据
    heroDic = herodata:getCanTrainHeros( )
    CalmBeltHeroListCellOwner = CalmBeltHeroListCellOwner or {}
    ccb["CalmBeltHeroListCellOwner"] = CalmBeltHeroListCellOwner
    local heroNotEnoughTips = tolua.cast(CalmBeltViewOwner["heroNotEnoughTips"],"CCLabelTTF")
    if getMyTableCount(heroDic) <= 0 then
        heroNotEnoughTips:setVisible(true)
    else
        heroNotEnoughTips:setVisible(false)
    end
    local function heroAvatarTaped( tag,sender )
        if not selectIndex or selectIndex ~= tag then
            local hero = heroDic[tag]
            local disciplineData = hero.discipline
            local trainLevelNum = 0
            if disciplineData and getMyTableCount(disciplineData) > 0 then
                trainLevelNum = disciplineData.level
            end
            local conditionArray = herodata:getUpgrateConditionByLevel( trainLevelNum + 1 )
            
            if hero.level < conditionArray["herolevel"] then
                ShowText(HLNSLocalizedString("nowind.condition.tips",conditionArray["herolevel"]))
                return
            end
            if wareHouseData:getItemCount( "item_010" ) < conditionArray["lifebelt"] then
                local function ConfirmAction(  )
                    if getAdventureLayer() then
                        getAdventureLayer():showMarine()
                    end
                end
                local function CancelAction(  )
                    
                end
                CCDirector:sharedDirector():getRunningScene():addChild(createSimpleConfirCardLayer(HLNSLocalizedString("calmbelt.nomorraft",conditionArray["lifebelt"] - wareHouseData:getItemCount( "item_010" ))))
                SimpleConfirmCard.confirmMenuCallBackFun = ConfirmAction
                SimpleConfirmCard.cancelMenuCallBackFun = CancelAction
                return
            end
            selectIndex = tag
        else
            selectIndex = nil
        end
        refreshTable()
    end

    CalmBeltHeroListCellOwner["heroAvatarTaped"] = heroAvatarTaped


    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
                r = CCSizeMake(575 * retina, 214)
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
            local  _hbCell = tolua.cast(CCBReaderLoad("ccbResources/CalmBeltHeroListCell.ccbi",proxy,true,"CalmBeltHeroListCellOwner"),"CCLayer")
            
            for i=1,3 do
                local item = tolua.cast(CalmBeltHeroListCellOwner["btn"..i],"CCMenuItemImage")
                local contentLayer = tolua.cast(CalmBeltHeroListCellOwner["contentLayer"..i],"CCLayer")
                if a1 * 3 + i <= getMyTableCount(heroDic) then
                    local hero = heroDic[a1 * 3 + i]
                    -- PrintTable(hero)
                    item:setTag(a1 * 3 + i)
                    -- local spriteName = ""
                    local selectSprite = tolua.cast(contentLayer:getChildByTag(10),"CCSprite")
                    if selectIndex and selectIndex == (a1 * 3 + i) then
                        selectSprite:setVisible(true)
                    else
                        selectSprite:setVisible(false)
                    end
                    -- item:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(spriteName))
                    -- item:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(spriteName))

                    local rankFrame = tolua.cast(contentLayer:getChildByTag(1),"CCSprite")
                    rankFrame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", hero.rank)))
                    local avatarSprite = tolua.cast(rankFrame:getChildByTag(2),"CCSprite")
                    if avatarSprite then
                        if CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(herodata:getHeroHeadByHeroId(hero.heroId)) then
                            avatarSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(herodata:getHeroHeadByHeroId(hero.heroId)))
                        else
                            avatarSprite:setVisible(false)
                        end
                    end
                    local disciplineData = hero.discipline

                    local trainLevel = tolua.cast(rankFrame:getChildByTag(4),"CCLabelTTF")

                    local trainLevelNum = 0
                    if disciplineData and getMyTableCount(disciplineData) > 0 then
                        trainLevelNum = disciplineData.level
                    end
                    trainLevel:setString(trainLevelNum)
                    -- trainLevel:enableShadow(CCSizeMake(3,-3), 2, 0)
                    trainLevel:enableStroke(ccc3(0,0,0), 0.5)

                    local nowArr = herodata:getTrainArrByHeroIdAndlevel( hero.heroId,trainLevelNum )
                    local nextArr = herodata:getTrainArrByHeroIdAndlevel( hero.heroId,trainLevelNum + 1 )
                    local nameLabel = tolua.cast(contentLayer:getChildByTag(7),"CCLabelTTF")
                    nameLabel:setString(HLNSLocalizedString(nowArr["type"]))

                    local attrLabel = tolua.cast(contentLayer:getChildByTag(8),"CCLabelTTF")
                    attrLabel:setString(string.format("%s→%s",nowArr.value,nextArr.value))
                    
                    local conditionArray = herodata:getUpgrateConditionByLevel( trainLevelNum + 1 )
                    local countLabel = tolua.cast(contentLayer:getChildByTag(9),"CCLabelTTF")
                    countLabel:setString(conditionArray["lifebelt"])

                    if wareHouseData:getItemCount( "item_010" ) < conditionArray["lifebelt"] then
                        countLabel:setColor(ccc3(255,0,0))
                    end

                    local levelLabel = tolua.cast(rankFrame:getChildByTag(6),"CCLabelTTF")
                    levelLabel:setString(hero.level)
                    if hero.level < conditionArray["herolevel"] then
                        levelLabel:setColor(ccc3(255,0,0))
                    end
                else
                    item:setVisible(false)
                    contentLayer:setVisible(false)
                end
            end

            a2:addChild(_hbCell, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            r = a2
        elseif fn == "numberOfCells" then
            r = math.ceil(getMyTableCount(heroDic) / 3)
        elseif fn == "cellTouched" then         -- A cell was touched, a1 is cell that be touched. This is not necessary.
            
        elseif fn == "cellTouchBegan" then      -- A cell is touching, a1 is cell, a2 is CCTouch
            getAdventureLayer():pageViewTouchEnabled(true)
            _bTableViewTouch = true
        elseif fn == "cellTouchEnded" then      -- A cell was touched, a1 is cell, a2 is CCTouch
            if _bTableViewTouch then
                getAdventureLayer():pageViewTouchEnabled(true)
                _bTableViewTouch = false
            end
        elseif fn == "cellHighlight" then       -- A cell is highlighting, coco2d-x 2.1.3 or above
        elseif fn == "cellUnhighlight" then     -- A cell had been unhighlighted, coco2d-x 2.1.3 or above
        elseif fn == "cellWillRecycle" then     -- A cell will be recycled, coco2d-x 2.1.3 or above
        elseif fn == "scroll" then
            if _bTableViewTouch then
                getAdventureLayer():pageViewTouchEnabled(false)
            end
        end
        return r
    end)
    local contentView = tolua.cast(CalmBeltViewOwner["tableViewContent"],"CCLayer")
    local _mainLayer = getMainLayer()
    local size = CCSizeMake(contentView:getContentSize().width, contentView:getContentSize().height)
    _tableView = LuaTableView:createWithHandler(h, size)
    _tableView:setBounceable(true)
    _tableView:setAnchorPoint(ccp(0,0))
    _tableView:setPosition(0,0)
    _tableView:setVerticalFillOrder(0)
    contentView:addChild(_tableView,1000)
end

local function refreshContentView(  )
    local heroInfo = herodata:isTrainingHeroUID(  )
    if heroInfo then
        -- 有英雄正在修炼
        gotoTrainLayer( heroInfo )
        endTime = heroInfo.discipline.endTime
        if isSpeedUpEnd then
            -- 添加加速粒子效果
            local progressSprite = tolua.cast(CalmBeltViewOwner["progressBg"],"CCSprite")
            local progressBg = tolua.cast(progressSprite:getChildByTag(1),"CCLayer")
            local pre = progress:getPercentage()
            local posX = progressBg:getContentSize().width * pre / 100
            local posY = progressBg:getContentSize().height / 2
            HLAddParticleScale("images/nowindbar.plist", progressBg, ccp(posX,posY), 0.4, 1, 100, 1.5 / retina, 1.5 / retina)
            isSpeedUpEnd = false
        end
        refeshTimeLabel()
    else
        -- 没有英雄正在修炼
        gotoHeroListView(  )
        endTime = nil
    end
end

local function backCallBack( url,rtnData )
    if rtnData.code == 200 then
        -- 更新英雄数据
        local heroID
        for k,v in pairs(rtnData.info.heros) do
            for huid,hero in pairs(herodata.heroes) do
                if huid == k then
                    herodata.heroes[k] = v
                    heroID = k
                end
            end
        end
        -- 修改页面状态
        gotoResultPage(heroID,rtnData.info.result)
    end
end

local function backAction(  )
    local heroInfo = herodata:isTrainingHeroUID(  )
    if heroInfo then
        doActionFun("CALME_BELT_EXERCISEFINISHED",{},backCallBack)
    else
        -- 移除掉发光效果
        local grade_bg = tolua.cast(CalmBeltViewOwner["grade_bg"],"CCSprite")
        local startSprite = grade_bg:getChildByTag(9888)
        if startSprite then
            startSprite:stopAllActions()
            startSprite:removeFromParentAndCleanup(true)
        end
        local animationSprite = tolua.cast(CalmBeltViewOwner["animationSprite"],"CCSprite")
        local startSprite = animationSprite:getChildByTag(9888)
        if startSprite then
            startSprite:stopAllActions()
            startSprite:removeFromParentAndCleanup(true)
        end
        refreshContentView(  )
    end
end
CalmBeltViewOwner["backAction"] = backAction

local function speedCallBack( url,rtnData )
    if rtnData.code == 200 then
        -- 更新英雄数据
        local heroID
        for k,v in pairs(rtnData.info.heros) do
            for huid,hero in pairs(herodata.heroes) do
                if huid == k then
                    herodata.heroes[k] = v
                    heroID = k
                end
            end
        end
        if rtnData.info.now then
            userdata.loginTime = rtnData.info.now
        end
        isSpeedUpEnd = true
        isSpeedUpEnd = true
        refreshContentView()
    end
end

local function speedAction(  )
    doActionFun("CALME_BELT_REDUCETIME",{},speedCallBack)
end
CalmBeltViewOwner["speedAction"] = speedAction

local function exerciseCallBack( url,rtnData )
    if rtnData.code == 200 then
        for k,v in pairs(rtnData.info.heros) do
            for huid,hero in pairs(herodata.heroes) do
                if huid == k then
                    herodata.heroes[k] = v
                end
            end
        end
        if rtnData.info.now then
            userdata.loginTime = rtnData.info.now
        end
        selectIndex = nil
        refreshTable()
        refreshContentView()
    end
end

local function excriseAction(  )
    if selectIndex then
        local hero = heroDic[selectIndex]
        
        doActionFun("CALME_BELT_EXERCISE",{ hero.id },exerciseCallBack) 
    else
        ShowText(HLNSLocalizedString("calmbelt.huobannotselect"))
    end
end
CalmBeltViewOwner["excriseAction"] = excriseAction
-- private方法如果没有上下调用关系可以写在createLayer外面

local function setMenuPriority( )
    local trainMenu = tolua.cast(CalmBeltViewOwner["trainMenu"],"CCMenu") 
    trainMenu:setHandlerPriority(-135)
end
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/CalmBeltView.ccbi",proxy, true,"CalmBeltViewOwner")
    _layer = tolua.cast(node,"CCLayer")

    local progressSprite = tolua.cast(CalmBeltViewOwner["progressBg"],"CCSprite")
    local progressBg = tolua.cast(progressSprite:getChildByTag(1),"CCLayer")

    -- local progressBg = tolua.cast(ShadowUpdateLayerOwner["progressBg"],"CCLayer")
    progressBg:setVisible(true)

    progress = CCProgressTimer:create(CCSprite:create("images/blueBattleShip.png"))
    progress:setType(kCCProgressTimerTypeBar)
    progress:setMidpoint(CCPointMake(0, 0))
    progress:setBarChangeRate(CCPointMake(1, 0))
    
    progressBg:addChild(progress,0)
    progress:setPercentage(0)
    progress:setPosition(ccp(progressBg:getContentSize().width / 2, progressBg:getContentSize().height / 2))

    totleTime = herodata:getcalmBeltTimeTotle(  )

    local trainTipsLabel = tolua.cast(CalmBeltViewOwner["trainTipsLabel"],"CCLabelTTF")
    trainTipsLabel:setString(HLNSLocalizedString("calmbelt.traintime"))
    -- trainTipsLabel:enableStroke(ccc3(0,0,0), 0.5)
    trainTipsLabel:enableShadow(CCSizeMake(3,-3), 2, 0)
end

-- 该方法名字每个文件不要重复
function getCalmBeltLayer()
	return _layer
end

function createCalmBeltLayer()
    _init()

    -- function _layer:showLayer()
    --     _changeState(runtimeCache.newWorldState)
    -- end

    local function _onEnter()
    	-- _changeState(runtimeCache.newWorldState)
        addObserver(NOTI_CALMBELT_CD, refeshTimeLabel)
        _addTableView()
        refreshContentView()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
    end

    local function _onExit()
        _layer = nil
        removeObserver(NOTI_CALMBELT_CD, refeshTimeLabel)
        _bTableViewTouch = false
        selectIndex = nil
        isSpeedUpEnd = false
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