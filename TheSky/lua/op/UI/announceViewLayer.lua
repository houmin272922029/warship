local _layer
local _priority
local tempLabel
local _tableView

-- 名字不要重复
AnnounceLayerViewOwner = AnnounceLayerViewOwner or {}
ccb["AnnounceLayerViewOwner"] = AnnounceLayerViewOwner

local function closeItemClick()
    popUpCloseAction( AnnounceLayerViewOwner,"infoBg",_layer )
end
AnnounceLayerViewOwner["closeItemClick"] = closeItemClick

local function getStringHeight( string,width,fontSize,fontName )
    if not fontName then
        fontName = "ccbResources/FZCuYuan-M03S"
    end
    if tempLabel then
        tempLabel = tolua.cast(tempLabel,"CCLabelTTF")
        if tempLabel then
            tempLabel:removeAllChildrenWithCleanup(true)
            tempLabel = nil
        end
    end

    tempLabel = CCLabelTTF:create(string,fontName,fontSize,CCSizeMake(width,0),kCCTextAlignmentLeft)
    _layer:addChild(tempLabel)
    tempLabel:setVisible(false)
    return (tempLabel:getContentSize().height)
end
local function getCellHeight( array )
    local height = 0
    local contentLayer = AnnounceLayerViewOwner["contentLayer"]
    for i=1,getMyTableCount(array) do
        local height1 = 0
        if i == 1 then
            height1 = 60
        else
            height1 = getStringHeight(array[i],contentLayer:getContentSize().width - 100,24,"ccbResources/FZCuYuan-M03S")
        end
        height = height + height1
    end
    return height
end

local function _addTableView() 
    local contentLayer = AnnounceLayerViewOwner["contentLayer"]
    local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
    cache:addSpriteFramesWithFile("ccbResources/publicRes_1.plist")
    local allData = announceData:getAllNotice()
    if getMyTableCount(allData) == 0 then
        local announceLabel = tolua.cast(AnnounceLayerViewOwner["announceLabel"],"CCLabelTTF")
        announceLabel:setVisible(true)
    end
    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            local array = {}
            local oneContent = allData[a1 + 1]
            array[1] = oneContent["title"]
            array[2] = oneContent["content"]
            if oneContent["time"] then
                array[3] = oneContent["time"]
            end
            local height 
            if oneContent["dest"] then
                height = getCellHeight( array ) + 100 + 10 + 20
            else
                height = getCellHeight( array ) + 10 + 40
            end
            r = CCSizeMake(contentLayer:getContentSize().width, height)
        elseif fn == "cellAtIndex" then
            -- Return CCTableViewCell, a1 is cell index (zero based), a2 is dequeued cell (maybe nil)
            -- Do something to create cell  and change the content
            
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            local oneContent = allData[a1 + 1]
            local array = {}
            local string1 = oneContent["title"]
            local string2 = oneContent["time"]
            local string3 = oneContent["content"]

            array[1] = oneContent["title"]
            array[2] = oneContent["content"]
            if oneContent["time"] then
                array[3] = oneContent["time"]
            end
            local height
            if oneContent["dest"] then
                height = getCellHeight( array ) + 100 + 10 + 10
            else
                height = getCellHeight( array ) + 10 + 30
            end

            local cellBg = CCScale9Sprite:createWithSpriteFrameName("gonggaoBg.png")
            cellBg:setContentSize(CCSizeMake(contentLayer:getContentSize().width - 50,height))
            cellBg:setAnchorPoint(ccp(0.5,0.5))
            cellBg:setPosition(ccp(contentLayer:getContentSize().width / 2,height / 2))

            local cellHight = cellBg:getContentSize().height

            local titleLabel = CCLabelTTF:create(string1,"ccbResources/FZCuYuan-M03S",26,CCSizeMake(contentLayer:getContentSize().width - 100,0),kCCTextAlignmentCenter,kCCVerticalTextAlignmentCenter)
            titleLabel:setAnchorPoint(ccp(0,1))
            titleLabel:setPosition(ccp(25,cellHight - 10))
            titleLabel:setColor(ccc3(255,255,0))
            cellBg:addChild(titleLabel)
            if string2 then
                local timeLabel = CCLabelTTF:create(string2,"ccbResources/FZCuYuan-M03S",24,CCSizeMake(contentLayer:getContentSize().width - 100,0),kCCTextAlignmentLeft,kCCVerticalTextAlignmentCenter)
                timeLabel:setAnchorPoint(ccp(0,1))
                timeLabel:setPosition(ccp(25,cellHight - 60 - 10 - 5))
                timeLabel:setColor(ccc3(255,165,0))
                cellBg:addChild(timeLabel)
            end

            local timeLabel = CCLabelTTF:create(string3,"ccbResources/FZCuYuan-M03S",24,CCSizeMake(contentLayer:getContentSize().width - 100,0),kCCTextAlignmentLeft)
            timeLabel:setAnchorPoint(ccp(0,1))
            if string2 then
                timeLabel:setPosition(ccp(25,cellHight - 60 - 10 - 10 - getStringHeight(string2,contentLayer:getContentSize().width - 100,24,"ccbResources/FZCuYuan-M03S")))
            else
                timeLabel:setPosition(ccp(25,cellHight - 60 - 10 - 10))
            end

            cellBg:addChild(timeLabel)
            if oneContent["dest"] then
                local btnLayer = CCLayer:create()
                btnLayer:setContentSize(CCSizeMake(contentLayer:getContentSize().width - 50,80))
                btnLayer:setAnchorPoint(ccp(0,0))
                btnLayer:setPosition(ccp(0,0))
                cellBg:addChild(btnLayer)
                local function gotoAction( tag,sender )
                    local OneMessage = allData[tonumber(tag)]
                    print(OneMessage.dest)
                    if OneMessage.dest == "recruitSoul" then
                        -- 刷将赠魂
                        Global:instance():TDGAonEventAndEventData("a1")
                        if getMainLayer() then
                            getMainLayer():goToLogue()
                        end
                    elseif OneMessage.dest == "refund" then
                        -- 充值返利
                        Global:instance():TDGAonEventAndEventData("h1")
                        if getMainLayer() then
                            getMainLayer():addChild(createShopRechargeLayer( -140 ),1,1)
                        end
                    elseif OneMessage.dest == "eatDumpling" then
                        Global:instance():TDGAonEventAndEventData("h2")
                        if not getMainLayer() then
                            CCDirector:sharedDirector():replaceScene(mainSceneFun())
                        end
                        runtimeCache.dailyPageNum = Daily_EatDumpling
                        getMainLayer():gotoDaily()
                        -- getDailyLayer():gotoDailyByName( Daily_EatDumpling )
                    elseif OneMessage.dest == "playerCharge" then
                        Global:instance():TDGAonEventAndEventData("h3")
                        -- 充值类活动
                        CCDirector:sharedDirector():getRunningScene():addChild(createShopRechargeLayer(-400), 100)
                    elseif OneMessage.dest == "fantasyTeam" then
                        -- 梦幻海贼团
                        Global:instance():TDGAonEventAndEventData("h4")
                        if not getMainLayer() then
                            CCDirector:sharedDirector():replaceScene(mainSceneFun())
                        end
                        runtimeCache.dailyPageNum = Daily_FantasyTeam
                        getMainLayer():gotoDaily()

                        -- getMainLayer():gotoDaily()
                        -- getDailyLayer():gotoDailyByName( Daily_FantasyTeam )
                    elseif OneMessage.dest == "wish" then
                        -- 布鲁克的吟唱
                        Global:instance():TDGAonEventAndEventData("h5")
                        if not getMainLayer() then
                            CCDirector:sharedDirector():replaceScene(mainSceneFun())
                        end
                        runtimeCache.dailyPageNum = Daily_Wish
                        getMainLayer():gotoDaily()

                        -- getMainLayer():gotoDaily()
                        -- getDailyLayer():gotoDailyByName( Daily_Wish )
                    elseif OneMessage.dest == "worship" then
                        -- 亲吻人鱼公主
                        Global:instance():TDGAonEventAndEventData("h6")
                        if not getMainLayer() then
                            CCDirector:sharedDirector():replaceScene(mainSceneFun())
                        end
                        runtimeCache.dailyPageNum = Daily_Worship
                        getMainLayer():gotoDaily()
                        -- getMainLayer():gotoDaily()
                        -- getDailyLayer():gotoDailyByName( Daily_Worship )
                    elseif OneMessage.dest == "qingjiaoTreasure" then
                        -- 青椒的宝藏
                        -- Global:instance():TDGAonEventAndEventData("h6")
                        if not getMainLayer() then
                            CCDirector:sharedDirector():replaceScene(mainSceneFun())
                        end
                        runtimeCache.dailyPageNum = Daily_Qingjiao
                        getMainLayer():gotoDaily()
                        -- getMainLayer():gotoDaily()
                        -- getDailyLayer():gotoDailyByName( Daily_Worship )
                    elseif OneMessage.dest == "yueka" then
                        -- 月卡
                        -- Global:instance():TDGAonEventAndEventData("h6")
                        if not getMainLayer() then
                            CCDirector:sharedDirector():replaceScene(mainSceneFun())
                        end
                        runtimeCache.dailyPageNum = Daily_YUEKA
                        getMainLayer():gotoDaily()
                        -- getMainLayer():gotoDaily()
                        -- getDailyLayer():gotoDailyByName( Daily_Worship )
                    elseif OneMessage.dest == "guessGame" then
                        -- 猜拳
                        Global:instance():TDGAonEventAndEventData("h7")
                        if not getMainLayer() then
                            CCDirector:sharedDirector():replaceScene(mainSceneFun())
                        end
                        runtimeCache.dailyPageNum = Daily_GuessGame
                        getMainLayer():gotoDaily()
                        -- getMainLayer():gotoDaily()
                        -- getDailyLayer():gotoDailyByName( Daily_GuessGame )
                    elseif OneMessage.dest == "alcohol" then
                        -- 玛奇诺的酒吧
                        Global:instance():TDGAonEventAndEventData("h8")
                        -- if not getMainLayer() then
                        --     CCDirector:sharedDirector():replaceScene(mainSceneFun())
                        -- end
                        -- getMainLayer():gotoDaily()
                        -- getDailyLayer():gotoDailyByName( Daily_Worship )
                    elseif OneMessage.dest == "instructHero" then
                        -- 特训
                        Global:instance():TDGAonEventAndEventData("h9")
                        if not getMainLayer() then
                            CCDirector:sharedDirector():replaceScene(mainSceneFun())
                        end
                        runtimeCache.dailyPageNum = Daily_InstructHeroG
                        getMainLayer():gotoDaily()
                        -- getMainLayer():gotoDaily()
                        -- getDailyLayer():gotoDailyByName( Daily_InstructHeroG )
                    elseif OneMessage.dest == "robin" then
                        -- 罗宾的花牌
                        Global:instance():TDGAonEventAndEventData("h10")
                        if not getMainLayer() then
                            CCDirector:sharedDirector():replaceScene(mainSceneFun())
                        end
                        runtimeCache.dailyPageNum = Daily_Robin
                        getMainLayer():gotoDaily()
                        -- getMainLayer():gotoDaily()
                        -- getDailyLayer():gotoDailyByName( Daily_Robin )
                    elseif OneMessage.dest == "treasure" then
                        -- 幸运卡牌
                        Global:instance():TDGAonEventAndEventData("h11")
                        if not getMainLayer() then
                            CCDirector:sharedDirector():replaceScene(mainSceneFun())
                        end
                        runtimeCache.dailyPageNum = Daily_Treasure
                        getMainLayer():gotoDaily()
                        -- getMainLayer():gotoDaily()
                        -- getDailyLayer():gotoDailyByName( Daily_Treasure )
                    elseif OneMessage.dest == "goldenBell" then
                        -- 黄金钟
                        Global:instance():TDGAonEventAndEventData("h12")
                        if not getMainLayer() then
                            CCDirector:sharedDirector():replaceScene(mainSceneFun())
                        end
                        runtimeCache.dailyPageNum = Daily_GoldenBell
                        getMainLayer():gotoDaily()
                        -- getMainLayer():gotoDaily()
                        -- getDailyLayer():gotoDailyByName( Daily_GoldenBell )
                    elseif OneMessage.dest == "upgradeAward" then
                        -- 升级奖励
                        Global:instance():TDGAonEventAndEventData("h13")
                        if not getMainLayer() then
                            CCDirector:sharedDirector():replaceScene(mainSceneFun())
                        end
                        runtimeCache.dailyPageNum = Daily_LevelUpReward
                        getMainLayer():gotoDaily()
                        -- getMainLayer():gotoDaily()
                        -- getDailyLayer():gotoDailyByName( Daily_LevelUpReward )
                    elseif OneMessage.dest == "luoge_recruit" then
                        Global:instance():TDGAonEventAndEventData("h14")
                        if getMainLayer() then
                            getMainLayer():goToLogue()
                            getLogueTownLayer():gotoPageByType( 0 )
                        end
                    elseif OneMessage.dest == "luoge_item" then
                        Global:instance():TDGAonEventAndEventData("h15")
                        if getMainLayer() then
                            getMainLayer():goToLogue()
                            getLogueTownLayer():gotoPageByType( 1 )
                        end
                    elseif OneMessage.dest == "luoge_gift" then
                        Global:instance():TDGAonEventAndEventData("h16")
                        if getMainLayer() then
                            getMainLayer():goToLogue()
                            getLogueTownLayer():gotoPageByType( 2 )
                        end
                    end
                    closeItemClick()
                end
                
                local item1 = CCMenuItemImage:create()
                item1:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn4_0.png"))
                item1:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn4_1.png"))
                

                local menu = CCMenu:create()
                menu:setPosition(ccp(0,0))
                menu:setAnchorPoint(ccp(0,0))
                item1:setPosition(ccp((contentLayer:getContentSize().width - 50) / 2,50))
                menu:addChild(item1,1,a1 + 1)
                item1:registerScriptTapHandler(gotoAction)
                
                local sprite = CCSprite:create()

                if isPlatform(ANDROID_VIETNAM_EN)
                    or isPlatform(ANDROID_VIETNAM_EN_ALL)
                    or isPlatform(IOS_VIETNAM_EN) 
                    or isPlatform(IOS_VIETNAM_ENSAGA)
                    or isPlatform(IOS_MOBNAPPLE_EN)
                    or isPlatform(ANDROID_GV_MFACE_EN)
                    or isPlatform(IOS_GAMEVIEW_EN)
                    or isPlatform(IOS_GVEN_BREAK)
                    or isPlatform(IOS_MOBGAME_SPAIN)
                    or isPlatform(ANDROID_MOBGAME_SPAIN)
                    or isPlatform(WP_VIETNAM_EN) then

                    sprite = CCSprite:createWithSpriteFrameName("qianwang_text.png")
                else
                    sprite = CCSprite:createWithSpriteFrameName("dianjiqianwang_text.png")
                end

                sprite:setPosition(ccp(item1:getContentSize().width / 2,item1:getContentSize().height / 2))
                item1:addChild(sprite)
                btnLayer:addChild(menu)
                local function setMenuPriority1(sender)
                    menu = tolua.cast(sender,"CCMenu")
                    menu:setHandlerPriority(_priority - 4)
                end
                local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFuncN:create(setMenuPriority1))
                menu:runAction(seq)
            end

            a2:addChild(cellBg, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            r = a2
        elseif fn == "numberOfCells" then
            r = getMyTableCount(allData)
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
        local size = CCSizeMake(contentLayer:getContentSize().width, contentLayer:getContentSize().height)      -- 这里是为了在tableview上面显示一个小空出来
        _tableView = LuaTableView:createWithHandler(h, size)
        _tableView:setBounceable(true)
        _tableView:setAnchorPoint(ccp(0,0))
        _tableView:setPosition(ccp(0, 0))
        _tableView:setVerticalFillOrder(0)
        contentLayer:addChild(_tableView)
    end
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/AnnounceLayerView.ccbi", proxy, true,"AnnounceLayerViewOwner")
    _layer = tolua.cast(node,"CCLayer")

end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(AnnounceLayerViewOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then

        popUpCloseAction( AnnounceLayerViewOwner,"infoBg",_layer )
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
    local menu1 = tolua.cast(AnnounceLayerViewOwner["myCloseMenu"], "CCMenu")
    menu1:setHandlerPriority(_priority-1)
    _tableView:setTouchPriority(_priority - 3)
end

-- 该方法名字每个文件不要重复
function getAnnounceLayer()
	return _layer
end

function createAnnounceLayer(priority)
    _priority = (priority ~= nil) and priority or -132
    _init()
    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
        _addTableView()
        popUpUiAction( AnnounceLayerViewOwner,"infoBg" )
    end

    local function _onExit()
        _layer = nil
        _priority = nil
        _tableView = nil
        tempLabel = nil
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