local _layer
local _contentLayer
local _tableView

MarineEntranceViewOwner = MarineEntranceViewOwner or {}
ccb["MarineEntranceViewOwner"] = MarineEntranceViewOwner


--合成界面底下的玩家材料黑框
local function _addTableView()
    local dic = marineBranchData:getTotalReward() -- dic 海军支部的所有奖励表. dic's data is like ["stuff_020","item_016","item_006","stuff_019"]
    if not dic then
        print("lsf error: marineBranchData:getTotalReward fail!") 
        return
    end 
    -- print("lsf_TableView11") 
    local width  = _contentLayer:getContentSize().width 
    local height = _contentLayer:getContentSize().height 
    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(  width / 4.5 , height )
        elseif fn == "cellAtIndex" then
            -- Return CCTableViewCell, a1 is cell index (zero based), a2 is dequeued cell (maybe nil)
            -- Do something to create cell  and change the content  
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            --

            local stuffItemId = dic[a1+1] -- data like "item_006"
            local itemDic = wareHouseData:getItemConfig(stuffItemId)
            local iconName = itemDic.icon  -- iconName's data like "item_006",but sametimes it's diff from Id  --林
            print("**lsf stuffItemId iconName" , stuffItemId, iconName)
            local icon
            icon = CCSprite:create(equipdata:getEquipIconByEquipId(iconName))
            icon:setScale(0.36)

            local itemsConfig = ConfigureStorage.item
            local item = itemsConfig[stuffItemId]
            if not item then --如果配置表里没有 stuffItemId 的数据
                item = itemsConfig["item_203"] --月饼
                print( string.format("lsf error:fail to get %s in ConfigureStorage.item " ,stuffItemId))
            end 
            
            if item.rank >= 4  then
                --紫色材料发光
                HLAddParticleScale( "images/purpleEquip.plist", icon, ccp(icon:getContentSize().width / 2,icon:getContentSize().height / 2), 1, 100, 777, 2 / 0.35 / retina, 2 / 0.35 / retina, 1 )
            end

            local frame = CCSprite:createWithSpriteFrameName(string.format("frame_%d.png", item.rank))
            frame:setAnchorPoint(ccp( 0.5,0.5))
            frame:setPosition(ccp( (width/4.5)/2, height *0.6))

            frame:addChild(icon)
            local frameSize = frame:getContentSize()
            icon:setAnchorPoint(ccp( 0.5,0.5))
            icon:setPosition(ccp(frameSize.width / 2, frameSize.height *0.5))
            
            --添加文字
            local labelTextSize = 16
            if isPlatform(IOS_VIETNAM_VI) 
                or isPlatform(IOS_VIETNAM_EN) 
                or isPlatform(IOS_VIETNAM_ENSAGA) 
                or isPlatform(IOS_MOBNAPPLE_EN)
                or isPlatform(IOS_MOB_THAI)
                or isPlatform(ANDROID_VIETNAM_VI)
                or isPlatform(ANDROID_VIETNAM_EN)
                or isPlatform(WP_VIETNAM_EN) then
                labelTextSize = 6 
            end
            -- labelTextSize = labelTextSize /0.36 

            --label2 材料名称
            local label2 = CCLabelTTF:create("", "ccbResources/FZCuYuan-M03S.ttf", labelTextSize, CCSizeMake(frameSize.width * 1.2,0), kCCTextAlignmentCenter)
            local itemName = item.name
            label2:setString( itemName )
            label2:setPosition(frame:getContentSize().width / 2, - labelTextSize*1.2)
            
            -- label2:setPosition(frame:getContentSize().width / 2,  frame:getContentSize().height )
            label2:setColor(ccc3(221,233,73))
            frame:addChild(label2)
            

            a2:addChild(frame, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            r = a2
        elseif fn == "numberOfCells" then
            r = #dic --    除3意思是3个一行
        -- Cell events:
        elseif fn == "cellTouched" then         -- A cell was touched, a1 is cell that be touched. This is not necessary.
            local tag = a1:getIdx() + 1
            local stuffItemId = dic[tag]
            --ItemDetailInfo 物品详情弹框
            CCDirector:sharedDirector():getRunningScene():addChild(createItemDetailInfoLayer(stuffItemId, -160, "n",1), 100)
            
        elseif fn == "cellTouchBegan" then      -- A cell is touching, a1 is cell, a2 is CCTouch
        elseif fn == "cellTouchEnded" then      -- A cell was touched, a1 is cell, a2 is CCTouch
        elseif fn == "cellHighlight" then       -- A cell is highlighting, coco2d-x 2.1.3 or above
        elseif fn == "cellUnhighlight" then     -- A cell had been unhighlighted, coco2d-x 2.1.3 or above
        elseif fn == "cellWillRecycle" then     -- A cell will be recycled, coco2d-x 2.1.3 or above
        end
        return r
    end)
    local size = CCSizeMake( width, height)  -- 这里是为了在tableview上面显示一个小空出来
    _tableView = LuaTableView:createWithHandler(h, size)
    _tableView:setBounceable(true)
    _tableView:setAnchorPoint(ccp(0,0))
    _tableView:setPosition(0,0)
    _tableView:setVerticalFillOrder(0)
    _tableView:setDirection(0)
    _contentLayer:addChild(_tableView,1000)
    _tableView:reloadData() 
end

function _removeRewardView()
    if _tableView then
        _tableView:removeFromParentAndCleanup(true)
        _tableView = nil
    end
end

local function _refreshLayer(  )
    local titleConf = titleData:getOneTitleByTitleId( "title_000107" )
    local titleFrame = tolua.cast(MarineEntranceViewOwner["titleFrame"],"CCMenuItemImage")
    local titleAvatarSprite = tolua.cast(MarineEntranceViewOwner["titleAvatarSprite"],"CCSprite")
    if titleAvatarSprite then
        local texture = CCTextureCache:sharedTextureCache():addImage(equipdata:getEquipIconByEquipId( "title_000107" ))
        if texture then
            titleAvatarSprite:setVisible(true)
            titleAvatarSprite:setTexture(texture)
        end
    end
    titleFrame:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", titleConf.conf.colorRank)))
    titleFrame:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", titleConf.conf.colorRank)))
    local titleName = tolua.cast(MarineEntranceViewOwner["titleName"],"CCLabelTTF")
    titleName:setString(titleConf.conf.name)
    local levelLabel = tolua.cast(MarineEntranceViewOwner["levelLabel"],"CCLabelTTF")
    if titleConf.title.level > 0 then
        levelLabel:setVisible(true)
        levelLabel:setString("LV"..titleConf.title.level)
    else
        levelLabel:setVisible(false)
    end
    local updateCondition = tolua.cast(MarineEntranceViewOwner["updateCondition"],"CCLabelTTF")
    updateCondition:setString(titleConf.title.desc)
    local despLabel = tolua.cast(MarineEntranceViewOwner["despLabel"],"CCLabelTTF")
    -- despLabel:setString(titleConf.name)
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/MarineEntranceView.ccbi",proxy, true,"MarineEntranceViewOwner")
    _layer = tolua.cast(node,"CCLayer")
    _contentLayer = tolua.cast(MarineEntranceViewOwner["contentLayer"],"CCLayer")

     -- marineBranchData:getTotalReward(  )
end

-- 该方法名字每个文件不要重复
function getMarineBranchEntranceLayer()
	return _layer
end

local function onEnterCallBack( url,rtnData )
    if rtnData["code"] == 200 then
        marineBranchData.huntTratherData = rtnData.info.huntingTreasure
        getMainLayer():gotoMarineBranchLayer(  )
    end
end

local function onEnterClick()
    doActionFun("RETRIEVE_HUNTINFO",{},onEnterCallBack)
end
MarineEntranceViewOwner["onEnterClick"] = onEnterClick

local function onTitleClick()
    if getTitleInfoLayer() then
        getTitleInfoLayer():removeFromParentAndCleanup(true)
    end
    CCDirector:sharedDirector():getRunningScene():addChild(createTitleInfoLayer( "title_000107",0,-142),130) 
end
MarineEntranceViewOwner["onTitleClick"] = onTitleClick

function createMarineBranchEntranceLayer()
    _init()
    function _layer:refreshLayer()
        _refreshLayer()
    end

    function _layer:addRewardView()
        if not _tableView then
            _addTableView()
        end
    end

    function _layer:removeRewardView()
        _removeRewardView()
    end

    local function _onEnter()
        -- 开始倒计时通知
        -- addObserver(NOTI_BOSS_BEGIN, _updateTimer)
        _layer:addRewardView()
        _refreshLayer()
    end

    local function _onExit()
        _layer = nil
        _contentLayer = nil
        _tableView = nil
        -- removeObserver(NOTI_BOSS_BEGIN, _updateTimer)
    end

    --onEnter onExit
    local function _layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        end
    end

    local function onTouchBegan(x, y)

        if  bAni then
            return true
        end
        
        -- 触摸到tableview区域 禁止pageview的滑动
        local width = _contentLayer:getContentSize().width  * retina
        local height = _contentLayer:getContentSize().height * retina
        local cx = _contentLayer:getPositionX() * retina
        local cy = _contentLayer:getPositionY() * retina
        

        local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
        local rect = CCRectMake( cx, cy , width, height)  
        print("**lsf rect",  cx, cy , width, height)
        print("**lsf touchPoint", touchLocation.x ,touchLocation.y)
        print(x,y)
        if  rect:containsPoint(touchLocation) then --如果在_contentLayer里,则禁止pageview的触摸
            getAdventureLayer():pageViewTouchEnabled(false)
            print("return1")
        else 
            getAdventureLayer():pageViewTouchEnabled(true)
            print("return2")
        end
        

        return false
    end

    local function onTouchEnded(x, y)
    end

    local function onTouch(eventType, x, y)
        if eventType == "began" then   
            return onTouchBegan(x, y)
        elseif eventType == "moved" then
        elseif eventType == "ended" then
        end
    end
    _layer:registerScriptTouchHandler(onTouch, false, -300, true)
    _layer:setTouchEnabled(true)

    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end