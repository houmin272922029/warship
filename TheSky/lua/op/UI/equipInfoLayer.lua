local _layer
local _equipUId = nil
local _uiType = 0
local _priority = -132
local _huid
local _pos
local _count

-- 名字不要重复
EquipInfoOwner = EquipInfoOwner or {}
ccb["EquipInfoOwner"] = EquipInfoOwner

EquipInfoCellOwner = EquipInfoCellOwner or {}
ccb["EquipInfoCellOwner"] = EquipInfoCellOwner

local function closeItemClick()
    popUpCloseAction( EquipInfoOwner,"infoBg",_layer )
end
EquipInfoOwner["closeItemClick"] = closeItemClick

local function cellCloseAction(  )
    if _uiType == 1 then
        if getMainLayer then
            getMainLayer():getoEquipChangeSelectView(_huid,_pos,_equipUId)
        end
    end
    popUpCloseAction( EquipInfoOwner,"infoBg",_layer )
end
EquipInfoCellOwner["closeItemClick"] = cellCloseAction

local function qianghuaItemClick()
    if _uiType == 0 then
        local content = equipdata:getEquip(_equipUId)
        if content.updateSilver > userdata.berry then
            ShowText(HLNSLocalizedString("强化需要%s贝利，你滴贝利不够", content.updateSilver))
        else
            if not getMainLayer() then
                CCDirector:sharedDirector():replaceScene(mainSceneFun())
            end
            getMainLayer():gotoEquipUpdateLayer(content)
        end
    elseif _uiType == 1 then
        runtimeCache.equipFromeTeam = 1
        local content = equipdata:getEquip(_equipUId)
        if content.updateSilver > userdata.berry then
            ShowText(HLNSLocalizedString("强化需要%s贝利，你滴贝利不够", content.updateSilver))
        else
            -- _layer:removeFromParentAndCleanup(true)
            if not getMainLayer() then
                CCDirector:sharedDirector():replaceScene(mainSceneFun())
            end
            getMainLayer():gotoEquipUpdateLayer(content)
        end
    elseif _uiType == 2 then
        Global:instance():TDGAonEventAndEventData("share2")
        local dic = equipdata:getEquipConfig(_equipUId)  
        local shareInfo = {pic = fileUtil:fullPathForFilename(equipdata:getEquipIconByEquipId( dic.icon )), text = string.format(ConfigureStorage.Share[7]["content"],dic.name,dic.desp), size = 1}
        local sharelayer = createShareLayer(shareInfo, _priority - 1)
        CCDirector:sharedDirector():getRunningScene():addChild(sharelayer,100)
    elseif _uiType == 3 then
        if not getMainLayer() then
            CCDirector:sharedDirector():replaceScene(mainSceneFun())
        end
        getMainLayer():TitleBgVisible(true)
        getMainLayer():gotoWareHouseLayer(1)
    elseif _uiType == 4 then
        Global:instance():TDGAonEventAndEventData("share2")
        local dic = equipdata:getEquipConfig(_equipUId)  
        local shareInfo = {pic = fileUtil:fullPathForFilename(equipdata:getEquipIconByEquipId( dic.icon )), text = string.format(ConfigureStorage.Share[7]["content"],dic.name,dic.desp), size = 1}
        local sharelayer = createShareLayer(shareInfo, _priority - 1)
        CCDirector:sharedDirector():getRunningScene():addChild(sharelayer,100)
    end
    popUpCloseAction( EquipInfoOwner,"infoBg",_layer )
end
EquipInfoCellOwner["qianghuaItemClick"] = qianghuaItemClick

-- 刷新UI数据
local function _refreshData()
    local dic
    if _uiType == 2 then

        dic = equipdata:getEquipConfig(_equipUId)
    elseif _uiType == 4 or _uiType == 3 then
        dic = equipdata:getEquipConfig(_equipUId)
        dic["shard"] = shardData:getShardConf( _shardID )
    else
        dic = equipdata:getEquip(_equipUId)
    end
    if dic == nil then 
        return
    end 
    PrintTable(dic)
    local rank = tolua.cast(EquipInfoCellOwner["rank"], "CCSprite")
    rank:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("rank_%d_icon.png", dic.rank)))

    local itemBg = tolua.cast(EquipInfoCellOwner["itemBg"], "CCSprite")
    itemBg:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("itemInfoBg_2_%d.png", dic.rank)))

    local chipIcon = tolua.cast(EquipInfoCellOwner["chipIcon"],"CCSprite")
    if _uiType == 3 or _uiType == 4 then
        chipIcon:setVisible(true)
    else
        chipIcon:setVisible(false)
    end
    
    local fontSprite = tolua.cast(EquipInfoCellOwner["fontSprite"], "CCSprite")
    local closeSprite = tolua.cast(EquipInfoCellOwner["closeSprite"], "CCSprite")
    if _uiType == 0 then
        --显示强化
        fontSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("qianghua_title.png"))
    elseif _uiType == 1 then
        --显示更换装备
        closeSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("genghuanzhuangbei_text.png"))
        fontSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("qianghua_title.png"))
    elseif _uiType == 2 or _uiType == 4 then
        --武林普分享
        if not isOpenShare( ) then
            local qianghuaItem = tolua.cast(EquipInfoCellOwner["qianghuaItem"],"CCMenuItemImage")
            qianghuaItem:setVisible(false)
            fontSprite:setVisible(false)
        end
        fontSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("fenxiangyoujiang_text.png"))
    elseif _uiType == 3 then
        fontSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("dazao_text.png"))
    end

    local levelBg = tolua.cast(EquipInfoCellOwner["levelBg"], "CCSprite")
    local composeLevel = tolua.cast(EquipInfoCellOwner["composeLevel"], "CCSprite")
    if dic.composeLevel then
        composeLevel:setVisible(true)
        if dic.composeLevel == -1 then
            composeLevel:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("m_level_max.png"))
        elseif dic.composeLevel == 0 then
            composeLevel:setVisible(false)
        else
            composeLevel:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("m_level_%d.png",dic.composeLevel)))
        end
    end
    local haoxiangni = tolua.cast(EquipInfoCellOwner["haoxiangni"], "CCSprite")
    if haoxiangni then
        local texture = CCTextureCache:sharedTextureCache():addImage(equipdata:getEquipIconByEquipId( dic.icon ))
        if texture then
            haoxiangni:setVisible(true)
            haoxiangni:setTexture(texture)
        end  
    end
    
    local name = tolua.cast(EquipInfoCellOwner["name"], "CCLabelTTF")
    if _uiType == 3 or _uiType == 4 then
        name:setString(dic.shard.name)
    else 
        name:setString(dic.name)
    end
    local level = tolua.cast(EquipInfoCellOwner["level"], "CCLabelTTF")
    if _uiType ==  2 or _uiType == 3 or _uiType == 4 then
        level:setVisible(false)
        levelBg:setVisible(false)
    else
        level:setString(string.format("LV:%d", dic.level))
    end
    local attrIcon = tolua.cast(EquipInfoCellOwner["attrIcon"], "CCSprite")
    local myType
    local myAttrValue
    if _uiType == 2 or _uiType == 3 or _uiType == 4 then
        for key,value in pairs(dic.initial) do
            myType = key
            myAttrValue = value
        end
    else
        for key,value in pairs(dic.attr) do
            myType = key
            myAttrValue = value
        end
    end
    attrIcon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("%s_icon.png",(myType == "mp") and "int" or myType)))
    
    local attr = tolua.cast(EquipInfoCellOwner["attr"],"CCLabelTTF")
    if myAttrValue < 1 then
        attr:setString(string.format("+ %d%%",myAttrValue * 100))
    else
        attr:setString(string.format("+ %d",myAttrValue))
    end

    if _uiType == 3 or _uiType == 4 then
        local countLabel = tolua.cast(EquipInfoCellOwner["countLabel"],"CCLabelTTF")
        countLabel:setString(HLNSLocalizedString("数量：%s",_count))
        countLabel:setVisible(true)
        attr:setVisible(false)
        attrIcon:setVisible(false)
    end

    local desp = tolua.cast(EquipInfoCellOwner["desp"], "CCLabelTTF")
    desp:setString(dic.desp)
    local price = tolua.cast(EquipInfoCellOwner["price"], "CCLabelTTF")
    if _uiType == 2 or _uiType == 3 or _uiType == 4 then
        price:setString(equipdata:getEquipPriceConfig(_equipUId))
    else
        price:setString(dic.price)
    end
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/EquipInfoView.ccbi", proxy, true,"EquipInfoOwner")
    _layer = tolua.cast(node,"CCLayer")
    _refreshData()
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(EquipInfoOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction( EquipInfoOwner,"infoBg",_layer )
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
    local sv = tolua.cast(EquipInfoOwner["sv"], "CCScrollView") 
    sv:setTouchPriority(_priority - 2)
    local menu1 = tolua.cast(EquipInfoOwner["menu"], "CCMenu")
    menu1:setHandlerPriority(_priority - 1)
    local menu2 = tolua.cast(EquipInfoCellOwner["menu"], "CCMenu")
    menu2:setHandlerPriority(_priority - 1)
end

-- 该方法名字每个文件不要重复
function getEquipInfoLayer()
    return _layer
end
--  uitype 0：强化  1：更换装备   2：分享  3: 打造碎片掉落  4: 碎片详情  array { heroid:herouid,pos:_pos}
function createEquipInfoLayer(equipUId, uiType, priority,array)
    _equipUId = equipUId
    _uiType = uiType
    if array then
        _huid = array.heroUid
        _pos = array.pos
        _count = array["count"]
        _shardID = array["shardId"]
        if _pos == 0 then
            Global:instance():TDGAonEventAndEventData("intensify3")
        elseif _pos == 1 then
            Global:instance():TDGAonEventAndEventData("intensify4")
        else
            Global:instance():TDGAonEventAndEventData("intensify5")
        end
    end
    _priority = (priority ~= nil) and priority or -132
    _init()

    -- 点击强化按钮
    function _layer:qianghuaItemClick( )
        qianghuaItemClick( )
    end

    local function _onEnter()
        print("onEnter")
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)

        popUpUiAction( EquipInfoOwner,"infoBg" )
    end

    local function _onExit()
        print("onExit")
        _layer = nil
        _equipUId = nil
        _priority = -132
        _shardID = nil
        _count = nil
        _uiType = 0
        _huid = nil
        _pos = nil
    end

    --onEnter onExit
    local function _layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        end
    end


    _layer:registerScriptTouchHandler(onTouch ,false ,_priority ,true )
    _layer:setTouchEnabled(true)
    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end