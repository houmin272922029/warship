local _layer
local contenData
local selectId = nil
local selectTag = 1

UnionUpgrateLayerOwner = UnionUpgrateLayerOwner or {}
ccb["UnionUpgrateLayerOwner"] = UnionUpgrateLayerOwner

local function onExitTaped(  )
    getUnionMainLayer():gotoShowInner()
end

UnionUpgrateLayerOwner["onExitTaped"] = onExitTaped

UnionUpgrateLayerOwner["onBuildingHelpTaped"] = function (  )
    local array = {}
    for i=1,table.getTableCount(ConfigureStorage.buildingHelp) do
        table.insert(array, ConfigureStorage.buildingHelp[tostring(i)].explain)
    end
    CCDirector:sharedDirector():getRunningScene():addChild(createCommonHelpLayer( array ))

end

local function refreshContent( item )
    local selFrame = tolua.cast(UnionUpgrateLayerOwner["selFrame"],"CCSprite")
    local menu = tolua.cast(UnionUpgrateLayerOwner["topMenu"], "CCMenu")
    local upgrateFrame = tolua.cast(menu:getChildByTag(selectTag),"CCMenuItemImage") 
    selFrame:setPosition(upgrateFrame:getPositionX(),upgrateFrame:getPositionY())
    local nameLabel = tolua.cast(UnionUpgrateLayerOwner["nameLabel"],"CCLabelTTF")
    nameLabel:setString(item.conf.name)
    local despLable = tolua.cast(UnionUpgrateLayerOwner["despLable"],"CCLabelTTF")
    if item.id == "leagueshop" then
        despLable:setString(string.format(item.conf.introduce,item.content.level))
    elseif item.id == "leaguedepot" then
        local attrArray = unionData:getDepotAttrAddByLevel( item.content.level,item.id )
        despLable:setString(string.format(item.conf.introduce,item.content.level,attrArray[1],attrArray[2],attrArray[3]))
    else
        local attrArray = unionData:getAttrAddByLevel( item.content.level,item.id )
        despLable:setString(string.format(item.conf.introduce,item.content.level,attrArray[1] * 100,attrArray[2] * 100))
    end
    local bottomIcon = tolua.cast(UnionUpgrateLayerOwner["bottomIcon"],"CCSprite")

    if bottomIcon then
        bottomIcon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName( item.conf.icon..".png" ))
    end 

    local textIcon = tolua.cast(UnionUpgrateLayerOwner["textIcon"],"CCSprite")
    local icon = item.conf.icon
    if havePrefix(icon,"huo") then
        textIcon:setVisible(true)
        textIcon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName( "huo_text.png" ))
    elseif havePrefix(icon,"lei") then
        textIcon:setVisible(true)
        textIcon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName( "lei_text.png" ))
    elseif havePrefix(icon,"di") then
        textIcon:setVisible(true)
        textIcon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName( "di_text.png" ))
    elseif havePrefix(icon,"shui") then
        textIcon:setVisible(true)
        textIcon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName( "shui_text.png" ))
    elseif havePrefix(icon,"feng") then
        textIcon:setVisible(true)
        textIcon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName( "feng_text.png" ))
    else
        textIcon:setVisible(false)
    end

    local levelLabel = tolua.cast(UnionUpgrateLayerOwner["levelLabel"],"CCLabelTTF")
    levelLabel:setString(HLNSLocalizedString("union.currentLevel",tostring(item.content.level)))

    local needLabel = tolua.cast(UnionUpgrateLayerOwner["needLabel"],"CCLabelTTF")
    needLabel:setString(unionData:getNeedCountByLevelAndKey( item.content.level,item.id ))
end

UnionUpgrateLayerOwner["onDistributeTaped"] = function (  )
    getUnionMainLayer():gotoCandyLayer(  )
end

UnionUpgrateLayerOwner["onContributeTaped"] = function (  )
    -- 获得捐赠数据
    local function refreshCallBack( url,rtnData )
        unionData:fromDic(rtnData.info)
        getUnionMainLayer():refreshData()
        CCDirector:sharedDirector():getRunningScene():addChild(createUnionContributionLayer())
    end
    doActionFun("REFRESH_CONTRIBUTE_INFO",{},refreshCallBack)
end

local function upgrateBuildingCallBack( url,rtnData )
    -- renzhan newAdd
    local menu = tolua.cast(UnionUpgrateLayerOwner["topMenu"], "CCMenu")
    local upgrateFrame = menu:getChildByTag(selectTag)
    HLAddParticleScale( "images/eff_unionUpgrateFire.plist", UnionUpgrateLayerOwner["avatarsContentLayer"], ccp(upgrateFrame:getPositionX() , upgrateFrame:getPositionY()), 5, 100, 100, 0.75/retina, 0.75/retina )
    -- 
    unionData:fromDic(rtnData.info)
    getUnionMainLayer():refreshData()
    contenData = unionData:getAllBuildingUpgrateData(  )
    local item = contenData[selectTag]
    selectId = item.id 
    refreshContent(item)
end

UnionUpgrateLayerOwner["onUpgrateTaped"] = function (  )
    if selectId ~= nil then
        -- 等级限制
        local item = contenData[selectTag]
        if selectId == "leagueshop" then
            if not unionData:isShopBuildingCanUpgrate() then
                ShowText(HLNSLocalizedString("union.shopLimit"))
                return
            end
        else
            if item.content.level >= unionData.detail["level"] then
                ShowText(HLNSLocalizedString("union.shopLimit"))
                return
            end
        end
        -- 糖果不足的提示
        local needCandy = unionData:getNeedCountByLevelAndKey( item.content.level,item.id )
        if needCandy > unionData.depot.sweetCount then
            local function CandyConfirmAction(  )
                UnionUpgrateLayerOwner["onContributeTaped"]()
            end
            local function CandyCancelAction(  )
                
            end
            CCDirector:sharedDirector():getRunningScene():addChild(createSimpleConfirCardLayer(HLNSLocalizedString("union.candyNotEngouth")))
            SimpleConfirmCard.confirmMenuCallBackFun = CandyConfirmAction
            SimpleConfirmCard.cancelMenuCallBackFun = CandyCancelAction
            return
        end
        doActionFun("LEAGUE_UPGRATE_BUILDING",{selectId},upgrateBuildingCallBack)
    end
end

UnionUpgrateLayerOwner["oneOptionTaped"] = function ( tag,sender )
    local item = contenData[tag]
    selectTag = tag
    selectId = item.id 
    refreshContent(item)
end

local function onTopItemTaped( tag,sender )

end



local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/UnionUpgrateLayer.ccbi",proxy, true,"UnionUpgrateLayerOwner")
    _layer = tolua.cast(node,"CCLayer")
    local cutOffLine = tolua.cast(UnionUpgrateLayerOwner["cutOffLine"],"CCSprite")
    local BSTopLayer = tolua.cast(UnionUpgrateLayerOwner["BSTopLayer"],"CCLayer")

    local avatarsContentLayer = tolua.cast(UnionUpgrateLayerOwner["avatarsContentLayer"],"CCLayer")
    local bottomLayer = tolua.cast(UnionUpgrateLayerOwner["bottomLayer"],"CCLayer")
    local height = winSize.height - BSTopLayer:getContentSize().height - getMainLayer():getBottomContentSize().height - bottomLayer:getContentSize().height * retina
    bottomLayer:setPosition(ccp(bottomLayer:getPositionX(),getMainLayer():getBottomContentSize().height))
    avatarsContentLayer:setContentSize(CCSizeMake(avatarsContentLayer:getContentSize().width,height / retina))
    avatarsContentLayer:setPosition(ccp(avatarsContentLayer:getPositionX(),getMainLayer():getBottomContentSize().height + bottomLayer:getContentSize().height * retina))
    local width = avatarsContentLayer:getContentSize().width
    local height = avatarsContentLayer:getContentSize().height
    local topMenu = tolua.cast(UnionUpgrateLayerOwner["topMenu"],"CCMenu")
    for y=1,3 do
        local item
        local avatar
        local posX = 0
        local posY = 0
        if y == 1 then
            posY = 1
        elseif y == 2 then
            posY = 3
        elseif y == 3 then
            posY = 5
        end
        for x=1,4 do
            item = tolua.cast(UnionUpgrateLayerOwner[string.format("topBtn%s%s",x,y)],"CCMenuItemImage")
            item:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("frame_1.png"))
            item:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("frame_1.png"))
            avatar = tolua.cast(UnionUpgrateLayerOwner[string.format("avatar%s%s",x,y)],"CCSprite")
            if not avatar then
                item:setVisible(false)
            end
            if x == 1 then
                posX = 1
            elseif x == 2 then
                posX = 3
            elseif x == 3 then
                posX = 5
            elseif x == 4 then
                posX = 7
            end

            item:setPosition(ccp(width * posX / 8,height * (posY / 6)))
            if avatar then
                avatar:setPosition(ccp(width * posX / 8,height * (posY / 6)))
            end
        end
    end

    local previewIcon = tolua.cast(UnionUpgrateLayerOwner["previewIcon"],"CCSprite")
    previewIcon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("frame_1.png"))
    
    for i=1,11 do
        local avatar = tolua.cast(avatarsContentLayer:getChildByTag(i),"CCSprite")
        if avatar then
            avatar:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName( contenData[tonumber(i)].conf.icon..".png" ))
        end
    end
    -- refreshContent()
    if unionData:isCreator( ) then
        local candyBtn = tolua.cast(UnionUpgrateLayerOwner["candyBtn"],"CCMenuItemImage")
        local upgrateBtn = tolua.cast(UnionUpgrateLayerOwner["upgrateBtn"],"CCMenuItemImage")
        local candySprite = tolua.cast(UnionUpgrateLayerOwner["candySprite"],"CCSprite")
        local upgrateSprite = tolua.cast(UnionUpgrateLayerOwner["upgrateSprite"],"CCSprite")
        upgrateBtn:setVisible(true)
        candyBtn:setVisible(true)
        candySprite:setVisible(true)
        upgrateSprite:setVisible(true)
    end
end

local function getUnionDataCallBack( url,rtnData )
    
end

local function getUnionShopData(  )
    doActionFun("GET_UNION_SHOPDATA",{ }, getUnionDataCallBack)
end

function getUnionUpgrateLayer()
	return _layer
end

function createUnionUpgrateLayer( )
    contenData = unionData:getAllBuildingUpgrateData(  )
    _init()


    local function _onEnter()
        
        local item = contenData[1]
        selectId = item.id
        selectTag = 1
        refreshContent( item )
    end

    local function _onExit()
        _layer = nil
        contenData = nil
        selectId = nil
        selectTag = 1
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