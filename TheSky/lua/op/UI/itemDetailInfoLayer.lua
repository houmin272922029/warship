
local _layer
local _itemId
local _priority = -132
local _uiType = 0      
local _count

-- 名字不要重复
ItemDetailInfoOwner = ItemDetailInfoOwner or {}
ccb["ItemDetailInfoOwner"] = ItemDetailInfoOwner

local function closerAction()
    -- 分享
    local dic = wareHouseData:getItemConfig(_itemId)
    --1是道具掉落
    local shareInfo = {pic = fileUtil:fullPathForFilename(equipdata:getEquipIconByEquipId(dic.icon)), text = string.format(ConfigureStorage.Share[1]["content"],dic.name,dic.desp), size = 1}
    local  sharelayer = createShareLayer(shareInfo,  _priority - 1)
    CCDirector:sharedDirector():getRunningScene():addChild(sharelayer,100)

    popUpCloseAction( ItemDetailInfoOwner,"infoBg",_layer )
end
ItemDetailInfoOwner["closerAction"] = closerAction

local function useAction()
    local function useCallBack( url,rtnData )
        if rtnData["code"] == 200 then
            if getItemsViewLayer() then
                getItemsViewLayer():refresh()
            end
            if getWareHouseLayer() then
                getWareHouseLayer():refresh()
            end
        end
    end

    local dic = wareHouseData:getItemConfig(_itemId)
    --   首先按type分类   然后按跳转类型

    if dic["type"] == "add" then   -- 添加经历
        local array = { dic.id,"1" }
        doActionFun("ITEM_USE_URL",array,useCallBack)
        popUpCloseAction( ItemDetailInfoOwner,"infoBg",_layer )
    elseif dic["type"] == "drawing" then
            local needCount = wareHouseData:getOneDrawingNeedCount( dic.id )
            local itemContent = wareHouseData:getItemCountById( dic.id )
            if itemContent >= needCount then
                local array = { dic.id,"1" }
                doActionFun("ITEM_USE_URL",array,useCallBack)
            else
                ShowText(HLNSLocalizedString("drawing.notEnoughTips",needCount - itemContent))
            end
    elseif dic["type"] == "item" then   -- item类

        if getExpenseRebateLayer() then
            getExpenseRebateLayer():close()
        end
        
        if dic["id"] == "item_005" then
            local function useGengMingLingConfirmCallBack(  )
                
            end
            local function useGengMingLingCancelCallBack(  )
                
            end
            -- if not getMainLayer() then
            --     CCDirector:sharedDirector():replaceScene(mainSceneFun())
            -- end
            local _scene = CCDirector:sharedDirector():getRunningScene()
            _scene:addChild(createConfirmCardWithTitleAndEditBoxLayer(),101)
            ConfirmCardWithTitleAndEditBox.confirmMenuCallBackFun = useGengMingLingConfirmCallBack
            ConfirmCardWithTitleAndEditBox.cancelMenuCallBackFun = useGengMingLingCancelCallBack
            popUpCloseAction( ItemDetailInfoOwner,"infoBg",_layer )
        elseif dic["id"] == "item_028" or  dic["id"] == "item_029" or dic["id"] == "item_030" or dic["id"] == "item_031" or dic["id"] == "item_032"  then
            --  进入装备合成页面
            if not getMainLayer() then
                CCDirector:sharedDirector():replaceScene(mainSceneFun())
            end
            runtimeCache.dailyPageNum = Daily_Compose
            getMainLayer():gotoDaily()
            getDecomposeAndComposeLayer():changeState( "compose")
            popUpCloseAction( ItemDetailInfoOwner,"infoBg",_layer )         

        elseif dic["id"] == "item_006" then
            --  进入伙伴页面
            if not getMainLayer() then
                CCDirector:sharedDirector():replaceScene(mainSceneFun())
            end
            if getDailyDrinkCapExchangeLayer() then
                getDailyDrinkCapExchangeLayer():close()
            end
            getMainLayer():TitleBgVisible(true)
            getMainLayer():goToHeroes()
            popUpCloseAction( ItemDetailInfoOwner,"infoBg",_layer )
        elseif dic["id"] == "item_007" then    -- 电话虫
            -- 跳转到聊天
            if not getChatLayer() then
                if not getMainLayer() then
                    CCDirector:sharedDirector():replaceScene(mainSceneFun())
                end
                getMainLayer():TitleBgVisible(true)
                getMainLayer():gotoChatLayer()
            end
            popUpCloseAction( ItemDetailInfoOwner,"infoBg",_layer )
        elseif dic["id"] == "item_008" or dic["id"] == "item_009" then     -- 生命牌 
            if not getFarewellLayer() or getFarewellLayer() == nil then
                if not getMainLayer() then
                    CCDirector:sharedDirector():replaceScene(mainSceneFun())
                end
                getMainLayer():TitleBgVisible(true)
                getMainLayer():goToHeroes()  
                popUpCloseAction( ItemDetailInfoOwner,"infoBg",_layer )
            else
                setSMPType(dic["id"] == "item_008" and 0 or 1)
                popUpCloseAction( ItemDetailInfoOwner,"infoBg",_layer )
            end
        elseif dic["id"] == "item_010" then        --  救生圈
            --进入无风带页面
            if not getMainLayer() then
                CCDirector:sharedDirector():replaceScene(mainSceneFun())
            end
            getMainLayer():gotoAdventure()
            getAdventureLayer():showCalmBelt(  )
            popUpCloseAction( ItemDetailInfoOwner,"infoBg",_layer )
        elseif dic["id"] == "itemcamp_002" or dic["id"] == "itemcamp_003" or dic["id"] == "itemcamp_004" or
            dic["id"] == "itemcamp_005" or dic["id"] == "itemcamp_006" then
            -- 进入海战页面
            if not getMainLayer() then
                CCDirector:sharedDirector():replaceScene(mainSceneFun())
            end
            getMainLayer():gotoWorldWar()
            popUpCloseAction( ItemDetailInfoOwner,"infoBg",_layer )
        else                                          --   直接使用
            local array = { dic.id,"1" }
            doActionFun("ITEM_USE_URL",array,useCallBack)
            popUpCloseAction( ItemDetailInfoOwner,"infoBg",_layer )
        end
    elseif dic["type"] == "stuff_01" or dic["type"] == "stuff_02" or dic["type"] == "stuff_03" then
            -- 前往装备页面
            if not getMainLayer() then
                CCDirector:sharedDirector():replaceScene(mainSceneFun())
            end
            popUpCloseAction( ItemDetailInfoOwner,"infoBg",_layer )
            getMainLayer():TitleBgVisible(true)
            getMainLayer():gotoEquipmentsLayer()
    elseif dic["type"] == "keybag" then
        local needCount = wareHouseData:getNeedCountByKeyBagIDAndCount( dic.id,1 )
        if needCount > 0 then
            local needId = wareHouseData:getNeedItemIdByItemId( dic.id )
            local itemContent = wareHouseData:getItemConfig(needId)
            if needId == "keybag_001" or needId == "keybag_002" then
                local text = HLNSLocalizedString("船长，您需要 %s 才能使用此钥匙，去新世界冒险可以有机会得到此箱子，快去试试吧！",itemContent.name)
                local function cardConfirmAction(  )
                    -- 去大冒险
                    if not getMainLayer() then
                        CCDirector:sharedDirector():replaceScene(mainSceneFun())
                    end
                    getMainLayer():gotoAdventure()
                    popUpCloseAction( ItemDetailInfoOwner,"infoBg",_layer )
                end
                local function cardCancelAction(  )
                    
                end
                CCDirector:sharedDirector():getRunningScene():addChild(createSimpleConfirCardLayer(text, nil, _priority - 2), 999)
                SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
                SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction
            else
                
                local titleStr
                local tipsStr
                if wareHouseData:stringHasPrix(needId,"bag") then
                    titleStr = HLNSLocalizedString("钥匙不足")
                    tipsStr = string.format(HLNSLocalizedString("船长，您需要购买 %s 把 %s 才能打开此箱子，不然得不到里面的财宝，有付出才能有大收获哦！"),needCount,itemContent.name)
                else
                    titleStr = HLNSLocalizedString("箱子不足")
                    tipsStr = string.format(HLNSLocalizedString("船长，您需要购买 %s 个 %s 才能使用这把钥匙，不然得不到里面的财宝，有付出才能有大收获哦！"),needCount,itemContent.name)
                end
                popUpCloseAction( ItemDetailInfoOwner,"infoBg",_layer )
                CCDirector:sharedDirector():getRunningScene():addChild(createItemNotEnoughTipsLayer(needId,titleStr,tipsStr,-140),100)
            end
        else
            local array = { dic.id,"1" }
            doActionFun("ITEM_USE_URL",array,useCallBack)
            popUpCloseAction( ItemDetailInfoOwner,"infoBg",_layer )
        end
    elseif dic["type"] == "soulbag" or dic["type"] == "boxrandom" or dic["type"] == "boxrandom1" then
        local array = { dic.id,"1" }
        doActionFun("ITEM_USE_URL",array,useCallBack)
        popUpCloseAction( ItemDetailInfoOwner,"infoBg",_layer )
    elseif dic["type"] == "vip" then
        --   两个打开按钮
        local array = { dic.id,"1" }
        doActionFun("ITEM_USE_URL",array,useCallBack)
        popUpCloseAction( ItemDetailInfoOwner,"infoBg",_layer )
    elseif dic["type"] == "box" then
        --   两个打开按钮
        local array = { dic.id,"1" }
        doActionFun("ITEM_USE_URL",array,useCallBack)
        popUpCloseAction( ItemDetailInfoOwner,"infoBg",_layer )
    end
end

ItemDetailInfoOwner["useAction"] = useAction

local function closeItemClick()
    popUpCloseAction( ItemDetailInfoOwner,"infoBg",_layer )
end
ItemDetailInfoOwner["closeItemClick"] = closeItemClick


local function _updateLabelString(labelStr, string)
        print("labelStr",labelStr)
        local label = tolua.cast(ItemDetailInfoOwner[labelStr], "CCLabelTTF")
        label:setString(string)
        label:setVisible(true)
    end
local function setFontSprite( sprite,flag )
    if flag == 0 then
        --开启
        sprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("kaiqi_text.png"))
    elseif flag == 1 then
        sprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("shiyong_text.png"))
    elseif flag == 2 then
        sprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("pinghe_text.png"))
    end 
end

local function _refreshData()
    local dic = wareHouseData:getItemConfig(_itemId)
    if dic == nil then
        return
    end
    _updateLabelString("nameLabel", dic.name)
    local nameLabel = tolua.cast(ItemDetailInfoOwner["nameLabel"],"CCLabelTTF")
    nameLabel:enableShadow(CCSizeMake(3,-3), 2, 0)

    local rankSprite = tolua.cast(ItemDetailInfoOwner["rankSprite"], "CCSprite")
    rankSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("rank_%s_icon.png", dic.rank)))

    local itemBg = tolua.cast(ItemDetailInfoOwner["itemBg"], "CCSprite")
    itemBg:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("itemInfoBg_2_%d.png", dic.rank)))

    -- 半身像
    local bustSpr = tolua.cast(ItemDetailInfoOwner["itemIcon"], "CCSprite")
    if not havePrefix(dic.id , "vip_") then
        if dic.icon then
            if bustSpr then
                local texture = CCTextureCache:sharedTextureCache():addImage(equipdata:getEquipIconByEquipId( dic.icon ))
                if texture then
                    bustSpr:setTexture(texture)
                end     
            end 
        end
    else
        if dic.icon then
            if bustSpr then 
                local texture = CCTextureCache:sharedTextureCache():addImage(equipdata:getEquipIconByEquipId( "vip_001" ))
                if texture then
                    bustSpr:setTexture(texture)
                end     
            end 
        end
    end

    -- 简介
    local desp = tolua.cast(ItemDetailInfoOwner["despLabel"], "CCLabelTTF")
    if desp then
        desp:setString(dic.desp)
    end 

    -- 获得数量
    if not _uiType then
        local countLabel = tolua.cast(ItemDetailInfoOwner["countLabel"],"CCLabelTTF")
        countLabel:setVisible(true)
        countLabel:enableShadow(CCSizeMake(3,-3), 2, 0)
        countLabel:setString(HLNSLocalizedString("数量：%s",_count))
    end


    local usebtn = tolua.cast(ItemDetailInfoOwner["useBtn"],"CCMenuItemImage")
    local closeBtn = tolua.cast(ItemDetailInfoOwner["closeBtn"],"CCMenuItemImage")
    local useBtn1 = tolua.cast(ItemDetailInfoOwner["useBtn1"],"CCMenuItemImage")

    -- local openTenBtn = tolua.cast(ItemDetailInfoOwner["openTenBtn"],"CCMenuItemImage")

    local useText = tolua.cast(ItemDetailInfoOwner["useText"],"CCSprite")
    local closeText = tolua.cast(ItemDetailInfoOwner["closeText"],"CCSprite")
    local closeText1 = tolua.cast(ItemDetailInfoOwner["closeText1"],"CCSprite")

    if dic["type"] == "soulbag" or dic["type"] == "boxrandom" or dic["type"] == "boxrandom1" or dic["type"] == "keybag" or dic["type"] == "vip" or dic["type"] == "box" then
        --开启
        setFontSprite(useText,0)
    elseif dic["type"] == "item" then
        if dic["id"] == "item_004" or dic["id"] == "item_016" or dic["id"] == "item_011" or dic["id"] == "item_012" or dic["id"] == "item_013" or dic["id"] == "item_014" or dic["id"] == "itemcamp_011" then 
            useText:setVisible(false)
            usebtn:setVisible(false)
            closeBtn:setVisible(false)
            closeText:setVisible(false)
            useBtn1:setVisible(true)
            closeText1:setVisible(true)
        else
            setFontSprite(useText,1)
        end
        
    elseif dic["type"] == "add" then
        if dic["id"] == "itemcamp_001" then
            useText:setVisible(false)
            usebtn:setVisible(false)
            closeBtn:setVisible(false)
            closeText:setVisible(false)
            useBtn1:setVisible(true)
            closeText1:setVisible(true)
        else 
            setFontSprite(useText,1)
        end
    elseif dic["type"] == "drawing" then
        setFontSprite(useText,2)
    elseif dic["type"] == "stuff_01" or dic["type"] == "stuff_02" or dic["type"] == "stuff_03" then
        setFontSprite(useText,1)
    elseif dic["type"] == "chapter" then
        useText:setVisible(false)
        usebtn:setVisible(false)
    -- elseif dic["type"] == "box" then
        -- useText:setVisible(false)
        -- usebtn:setVisible(false)
        -- closeBtn:setVisible(false)
        -- closeText:setVisible(false)
        -- useBtn1:setVisible(true)
        -- closeText1:setVisible(true)
    end

    if not isOpenShare(  ) then
        closeBtn:setVisible(false)
        closeText:setVisible(false)
    end

    if _uiType == 1 then
        useText:setVisible(false)
        usebtn:setVisible(false)
        closeBtn:setVisible(false)
        closeText:setVisible(false)
        if not isOpenShare(  ) then
            useBtn1:setVisible(false)
            closeText1:setVisible(false)
        else
            useBtn1:setVisible(true)
            closeText1:setVisible(true)
        end
    else
        useBtn1:setVisible(false)
        closeText1:setVisible(false)
    end
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/ItemDetailInfoView.ccbi", proxy, true,"ItemDetailInfoOwner")
    _layer = tolua.cast(node,"CCLayer")

    _refreshData()
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(ItemDetailInfoOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction( ItemDetailInfoOwner,"infoBg",_layer )
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
    local menu1 = tolua.cast(ItemDetailInfoOwner["menu"], "CCMenu")
    menu1:setHandlerPriority(_priority-1)
end

-- 该方法名字每个文件不要重复
function getItemDetailInfoLayer()
	return _layer
end
-- uitype : 1 只显示中间分享有奖按钮  0 只显示上边两个的按钮
function createItemDetailInfoLayer(itemId, priority,count,uiType)
    _itemId = itemId
    _uiType = uiType
    _count = count
    _priority = (priority ~= nil) and priority or -132
    _init()

    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)

        popUpUiAction( ItemDetailInfoOwner,"infoBg" )
    end

    local function _onExit()
        _itemId = nil
        _count = nil
        _uiType = 0
        _layer = nil
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