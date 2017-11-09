local _layer
local allData
local _tableView
local _topLayer
local _tableView2
local shardDatas
local _priority = -132

local cellArray1 = {}
local cellArray2 = {}

WarehouseViewOwner = WarehouseViewOwner or {}
ccb["WarehouseViewOwner"] = WarehouseViewOwner

WarehouseCellOwner = WarehouseCellOwner or {}
ccb["WarehouseCellOwner"] = WarehouseCellOwner

ShuipianCellOwner = ShuipianCellOwner or {}
ccb["ShuipianCellOwner"] = ShuipianCellOwner


local function setSpriteFrame( sender,bool )
    if bool then
        sender:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_1.png"))
        sender:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_1.png"))
    else
        sender:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_0.png"))
        sender:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_0.png"))
    end
end

local function setTopBtnState( flag1,flag2 )
    local btn1 = tolua.cast(WarehouseViewOwner["btn1"],"CCMenuItemImage")
    local btn2 = tolua.cast(WarehouseViewOwner["btn2"],"CCMenuItemImage")
    setSpriteFrame(btn1,flag1)
    setSpriteFrame(btn2,flag2)
    _tableView:setVisible(flag1)
    _tableView2:setVisible(flag2)
    if flag1 then
        generateCellAction( cellArray1,getMyTableCount(allData) )
    end
    if flag2 then
        generateCellAction( cellArray2,getMyTableCount(shardDatas) )
    end
    if flag2 then
        if getMyTableCount(shardDatas) <= 0 then
            local text = HLNSLocalizedString("shuipian.notenough")
            local function cardConfirmAction(  )
                local _mainLayer = getMainLayer()
                if _mainLayer then
                    _mainLayer:gotoUnion()
                end 
            end
            getMainLayer():getParent():addChild(createSimpleConfirCardLayer(text), 100)
            SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
            local function nilFunc( ... )
                -- body
            end
            SimpleConfirmCard.cancelMenuCallBackFun = nilFunc
        end
    end
end

WarehouseViewOwner["onWeraHouseTaped"] = function ( tag,sender )
    setTopBtnState(true,false)
    
end

WarehouseViewOwner["onShuiPianTaped"] = function ( tag,sender )
    setTopBtnState(false,true)
end

local function _refreshUI(  )
    if _tableView then
        allData = wareHouseData:getAllWareHouseData()
        local offsetY = _tableView:getContentOffset().y
        local contentSizeHeight = _tableView:getContentSize().height
        _tableView:reloadData()
        if _tableView:getContentSize().height <= (winSize.height - _topLayer:getContentSize().height - getMainLayer():getBottomContentSize().height)*99/100 
            or offsetY < _tableView:getContentOffset().y 
            or contentSizeHeight <= (winSize.height - _topLayer:getContentSize().height - getMainLayer():getBottomContentSize().height)*99/100 then
        else
            _tableView:setContentOffset(ccp(0, offsetY))
        end
    end
end

-- 点击Icon
local function onItemClicked(tag,sender)
    print("onItemClicked")
    local content = allData[tag + 1]
    if content.item.type == "delay" then
        getMainLayer():addChild(createDelayBagDetailLayer(content.id, -135))
    else
        getMainLayer():addChild(createItemDetailInfoLayer(content.item.id, -135, 1, 0))
    end
end 
WarehouseCellOwner["onItemClicked"] = onItemClicked

local function _addTableView()
    _topLayer = WarehouseViewOwner["titleLayer"]


    local function useCallBack( url,rtnData )
        if rtnData["code"] == 200 then
            if rtnData.info.delayItems then
                wareHouseData.bagDelay = rtnData.info.delayItems
            end
            _refreshUI()
        end
    end

    local function _useBtnTaped( tag,sender )
        local content = allData[tag + 1]
        --   首先按type分类   然后按跳转类型
        local itemid = content.item.id
        local number = -1
        if itemid == "keybag_001" or itemid == "bagkey_001" then --青苔木桶
            number = 5
        elseif itemid == "keybag_004" or itemid == "bagkey_004" then --沉船金箱
            number = 3
        elseif itemid == "keybag_003" or itemid == "bagkey_003" then --珊瑚银柜
            number = 1
        elseif itemid == "keybag_002" or itemid == "bagkey_002" then --扇贝铜罐
            number = 7
        end
        Global:instance():TDGAonEventAndEventData("warehouse"..number)
        
        if content.item["type"] == "add" then   -- 添加经历
            local array = { content.item.id,"1" }
            doActionFun("ITEM_USE_URL",array,useCallBack)
        elseif content.item["type"] == "drawing" then
            local needCount = wareHouseData:getOneDrawingNeedCount( content.item.id )
            if content.count >= needCount then
                local array = { content.item.id,"1" }
                doActionFun("ITEM_USE_URL",array,useCallBack)
            else
                ShowText(HLNSLocalizedString("drawing.notEnoughTips",needCount - content.count))
            end
        elseif content.item["type"] == "item" then   -- item类
            if content.item["id"] == "item_005" then
                local function useGengMingLingConfirmCallBack(  )
                    
                end
                local function useGengMingLingCancelCallBack(  )
                    
                end
                _layer:addChild(createConfirmCardWithTitleAndEditBoxLayer())
                ConfirmCardWithTitleAndEditBox.confirmMenuCallBackFun = useGengMingLingConfirmCallBack
                ConfirmCardWithTitleAndEditBox.cancelMenuCallBackFun = useGengMingLingCancelCallBack
            elseif content.item["id"] == "item_006" or content.item["id"] == "item_008" or content.item["id"] == "item_009" then
                --  进入伙伴页面
                if not getMainLayer() then
                    CCDirector:sharedDirector():replaceScene(mainSceneFun())
                end
                getMainLayer():goToHeroes()

            elseif content.item["id"] == "item_028" or  content.item["id"] == "item_029" or content.item["id"] == "item_030" or content.item["id"] == "item_031" or content.item["id"] == "item_032"  then
                --  进入装备合成页面
                if not getMainLayer() then
                    CCDirector:sharedDirector():replaceScene(mainSceneFun())
                end
                runtimeCache.dailyPageNum = Daily_Compose
                getMainLayer():gotoDaily()
                getDecomposeAndComposeLayer():changeState( "compose")
                popUpCloseAction( ItemDetailInfoOwner,"infoBg",_layer )  
                
            elseif content.item["id"] == "item_007" then    --电话虫
                -- 跳转到聊天
                if not getMainLayer() then
                    CCDirector:sharedDirector():replaceScene(mainSceneFun())
                end
                getMainLayer():gotoChatLayer()
            elseif content.item["id"] == "item_010" then        --  救生圈
                --进入无风带页面
                if not getMainLayer() then
                    CCDirector:sharedDirector():replaceScene(mainSceneFun())
                end
                getMainLayer():gotoAdventure()
                getAdventureLayer():showCalmBelt(  )
            elseif content.item["id"] == "item_013" then

            elseif content.item["id"] == "item_022" then    --普通碎片
                -- 跳转到拼图游戏
                if getMainLayer() and loginActivityData.activitys then
                    getMainLayer():goToHome()
                    getMainLayer():addChild(createActivityOfJigsawLayer(_priority), 300) --拼图游戏
                else
                    local function havaExpcardConfirmAction()
                    end
                    local function havaExpcardCancelAction()
                    end
                    getMainLayer():addChild(createSimpleConfirCardLayer(HLNSLocalizedString("报告船长，拼图任务目前没有开启，等开启之后再来吧！"),
                                HLNSLocalizedString(" ")))
                    SimpleConfirmCard.confirmMenuCallBackFun = havaExpcardConfirmAction
                    SimpleConfirmCard.cancelMenuCallBackFun = havaExpcardCancelAction
                end
            elseif content.item["id"] == "item_023" then    --高级碎片
                -- 跳转到拼图游戏
                if getMainLayer() and loginActivityData.activitys then
                    getMainLayer():goToHome()
                    getMainLayer():addChild(createActivityOfJigsawLayer(_priority), 300) --拼图游戏
                else
                    local function havaExpcardConfirmAction()
                    end
                    local function havaExpcardCancelAction()
                    end
                    getMainLayer():addChild(createSimpleConfirCardLayer(HLNSLocalizedString("报告船长，拼图任务目前没有开启，等开启之后再来吧！"),
                                HLNSLocalizedString(" ")))
                    SimpleConfirmCard.confirmMenuCallBackFun = havaExpcardConfirmAction
                    SimpleConfirmCard.cancelMenuCallBackFun = havaExpcardCancelAction
                end
            elseif content.item["id"] == "itemcamp_002" or content.item["id"] == "itemcamp_003" or content.item["id"] == "itemcamp_004" or  content.item["id"] == "itemcamp_005" or content.item["id"] == "itemcamp_006" then
                getMainLayer():gotoWorldWar()
            elseif content.item["id"] == "itemcamp_009" then
                -- todo
            else                                                --   直接使用
                local array = { content.item.id,"1" }
                doActionFun("ITEM_USE_URL",array,useCallBack)
            end
        elseif content.item["type"] == "stuff_01" or content.item["type"] == "stuff_02" or content.item["type"] == "stuff_03" then
                -- 前往装备页面
            if getMainLayer() then
                getMainLayer():gotoEquipmentsLayer()
            end
        elseif content.item["type"] == "keybag" then
            --  两个打开按钮
        elseif content.item["type"] == "vip" then
            --   一个打开按钮
                local function openBagCallBack( url,rtnData )
                    if rtnData["code"] == 200 then
                        _refreshUI()
                    end
                end
            local array = { content.item.id,"1" }
            doActionFun("ITEM_USE_URL",array,openBagCallBack)
        elseif content.item["type"] == "box" then
            local array = { content.item.id,"1" }
            doActionFun("ITEM_USE_URL",array,useCallBack)
        elseif content.item.type == "delay" then
            -- 延时礼包使用
            doActionFun("USE_DELAY_ITEM", {content.id}, useCallBack)
        elseif content.item.type == "boxrandom1" then
            if content["id"] == "boxrandom1_043" then
                local function openBagCallBack( url,rtnData )
                    if rtnData["code"] == 200 then
                        _refreshUI()
                    end
                end
                local array = { content.id,"1" }
                doActionFun("ITEM_USE_URL",array,openBagCallBack)
            end
        end
    end

    local function openBagCallBack( url,rtnData )
        if rtnData["code"] == 200 then
            _refreshUI()
        end
    end

    local function openOneBtnTaped( tag,sender )
        local content = allData[tag + 1]
        if content.item.type == "keybag" then
            local  number1 = -1
            if itemid == "item_001" then--牛排
                number = 17
            elseif itemid == "item_002" then--宾酒
                number = 16
            elseif itemid == "item_005" then--换名
                number = 15
            elseif itemid == "item_006" then--蓝波球
                number = 14
            elseif itemid == "item_009" then--稀有生命牌
                number = 13
            elseif itemid == "stuff_001" then--一级铁云
                number = 9
            elseif itemid == "stuff_002" then--二级铁云、
                number = 10
            elseif itemid == "stuff_009" then--一级鲨纱
                number = 11
            elseif itemid == "stuff_010" then--二级鲨纱
                number = 12
            elseif itemid == "keybag_001" or itemid == "bagkey_001" then --青苔木桶
                number = 6
            elseif itemid == "keybag_004" or itemid == "bagkey_004" then --沉船金箱
                number = 4
            elseif itemid == "keybag_003" or itemid == "bagkey_003" then --珊瑚银柜
                number = 2
            elseif itemid == "keybag_002" or itemid == "bagkey_002" then --扇贝铜罐
                number = 8
            end
            Global:instance():TDGAonEventAndEventData("warehouse"..number1)
            local needCount = wareHouseData:getNeedCountByKeyBagIDAndCount( content.item.id,1 )
            if needCount > 0 then
                local needId = wareHouseData:getNeedItemIdByItemId( content.item.id )
                local itemContent = wareHouseData:getItemConfig(needId)
                if needId == "keybag_002" or needId == "keybag_001" then
                    local text = HLNSLocalizedString("船长，您需要 %s 才能使用此钥匙，去新世界冒险可以有机会得到此箱子，快去试试吧！",itemContent.name)
                    local function cardConfirmAction(  )
                        -- 去大冒险
                        if not getMainLayer() then
                            CCDirector:sharedDirector():replaceScene(mainSceneFun())
                        end
                        getMainLayer():gotoAdventure()
                    end
                    local function cardCancelAction(  )
                        
                    end
                    CCDirector:sharedDirector():getRunningScene():addChild(createSimpleConfirCardLayer(text), 100)
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
                    getMainLayer():addChild(createItemNotEnoughTipsLayer(needId,titleStr,tipsStr,-140))
                end 
            else
                local array = { content.item.id,"1" }
                doActionFun("ITEM_USE_URL",array,openBagCallBack)
            end
        elseif content.item.type == "soulbag" or content.item.type == "boxrandom" or content.item.type == "boxrandom1" then
            local array = { content.item.id,"1" }
            doActionFun("ITEM_USE_URL",array,openBagCallBack)
        end
    end

    local function openTenBtnTaped( tag,sender )
        if vipdata:getVipLevel() >= vipdata:getBox10Level() then
            local content = allData[tag + 1]
            if content.item.type == "keybag" then
                local itemCount = wareHouseData:getItemCountById( content.item.id )
                if itemCount >= 10 then
                    local needCount = wareHouseData:getNeedCountByKeyBagIDAndCount( content.item.id,10 )
                    if needCount > 0 then
                        local needId = wareHouseData:getNeedItemIdByItemId( content.item.id )
                        local itemContent = wareHouseData:getItemConfig(needId)
                        if needId == "keybag_002" or needId == "keybag_001" then
                            local text = HLNSLocalizedString("船长，您需要 %s 才能使用此钥匙，去新世界冒险可以有机会得到此箱子，快去试试吧！",itemContent.name)
                            local function cardConfirmAction(  )
                                -- 去大冒险
                                if not getMainLayer() then
                                    CCDirector:sharedDirector():replaceScene(mainSceneFun())
                                end
                                getMainLayer():gotoAdventure()
                                _layer:removeFromParentAndCleanup(true)
                            end
                            local function cardCancelAction(  )
                                
                            end
                            CCDirector:sharedDirector():getRunningScene():addChild(createSimpleConfirCardLayer(text), 100)
                            SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
                            SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction
                        else
                            local titleStr
                            local tipsStr
                            if wareHouseData:stringHasPrix(needId,"bag") then
                                titleStr = HLNSLocalizedString("钥匙不足")
                                tipsStr = HLNSLocalizedString("船长，您需要购买 %s 把 %s 才能打开此箱子，不然得不到里面的财宝，有付出才能有大收获哦！",needCount,itemContent.name)
                            else
                                titleStr = HLNSLocalizedString("箱子不足")
                                tipsStr = HLNSLocalizedString("船长，您需要购买 %s 个 %s 才能使用这把钥匙，不然得不到里面的财宝，有付出才能有大收获哦！",needCount,itemContent.name)
                            end
                            getMainLayer():addChild(createItemNotEnoughTipsLayer(needId,titleStr,tipsStr,-140))
                        end
                    else
                        local array = { content.item.id,"10" }
                        doActionFun("ITEM_USE_URL",array,openBagCallBack)
                    end
                else
                    local needCount = 10 - itemCount
                    if content.item.id == "keybag_002" or content.item.id == "keybag_001" then
                        local text = HLNSLocalizedString("船长，您的 %s 不够，去新世界冒险可以有机会得到此箱子，快去试试吧！",content.item.name)
                        local function cardConfirmAction(  )
                            -- 去大冒险
                            if not getMainLayer() then
                                CCDirector:sharedDirector():replaceScene(mainSceneFun())
                            end
                            getMainLayer():gotoAdventure()
                            _layer:removeFromParentAndCleanup(true)
                        end
                        local function cardCancelAction(  )
                            
                        end
                        CCDirector:sharedDirector():getRunningScene():addChild(createSimpleConfirCardLayer(text), 100)
                        SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
                        SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction
                    else
                        local titleStr
                        local tipsStr
                        if wareHouseData:stringHasPrix(content.item.id,"bag") then
                            titleStr = HLNSLocalizedString("钥匙不足")
                            tipsStr = HLNSLocalizedString("船长，您需要购买 %s 把 %s 才能使用该功能，不然得不到里面的财宝，有付出才能有大收获哦！",needCount,content.item.name)
                        else
                            titleStr = HLNSLocalizedString("箱子不足")
                            tipsStr = HLNSLocalizedString("船长，您需要购买 %s 个 %s 才能使用该功能，不然得不到里面的财宝，有付出才能有大收获哦！",needCount,content.item.name)
                        end
                        getMainLayer():addChild(createItemNotEnoughTipsLayer(content.item.id,titleStr,tipsStr,-140))
                    end
                end
            elseif content.item.type == "soulbag" or content.item.type == "boxrandom" or content.item.type == "boxrandom1" then
                local array = { content.item.id,"10" }
                doActionFun("ITEM_USE_URL",array,openBagCallBack)
            end
        else
            ShowText(string.format(HLNSLocalizedString("需要VIP等级%s"),vipdata:getBox10Level()))
        end
    end



    WarehouseCellOwner["useBtnTaped"] = _useBtnTaped
    WarehouseCellOwner["openOneBtnTaped"] = openOneBtnTaped
    WarehouseCellOwner["openTenBtnTaped"] = openTenBtnTaped

    allData = wareHouseData:getAllWareHouseData()
    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(winSize.width, 170 * retina)
        elseif fn == "cellAtIndex" then
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            local singleContent = allData[a1 + 1]
            local  proxy = CCBProxy:create()
            local  _hbCell  = tolua.cast(CCBReaderLoad("ccbResources/WarehouseCell.ccbi",proxy,true,"WarehouseCellOwner"),"CCLayer")
            
            local usebtn = tolua.cast(WarehouseCellOwner["useBtn"],"CCMenuItemImage")
            local openOneBtn = tolua.cast(WarehouseCellOwner["openOneBtn"],"CCMenuItemImage")
            local openTenBtn = tolua.cast(WarehouseCellOwner["openTenBtn"],"CCMenuItemImage")

            local openOneTitle1 = tolua.cast(WarehouseCellOwner["useBtnTitle1"],"CCSprite")
            local openOneTitle2 = tolua.cast(WarehouseCellOwner["openOneTitle3"],"CCSprite")
            local openOneTitle3 = tolua.cast(WarehouseCellOwner["openTenTitle2"],"CCSprite")

            local levelSprite = tolua.cast(WarehouseCellOwner["levelSprite"],"CCSprite")
            local rbLabel = tolua.cast(WarehouseCellOwner["rbLabel"],"CCLabelTTF")

            local countTitle = tolua.cast(WarehouseCellOwner["countTitle"], "CCLabelTTF")
            local countLabel = tolua.cast(WarehouseCellOwner["countLabel"], "CCLabelTTF")
            local nextUseTip = tolua.cast(WarehouseCellOwner["nextUseTip"], "CCLabelTTF")
            local useTImeTitle = tolua.cast(WarehouseCellOwner["useTImeTitle"], "CCLabelTTF")
            local useTitleLabel = tolua.cast(WarehouseCellOwner["useTitleLabel"], "CCLabelTTF")

            local function updateBtnState( bool1,bool2,bool3 )
                 usebtn:setVisible(bool1)
                 openOneTitle1:setVisible(bool1)
                 openOneBtn:setVisible(bool2)
                 openOneTitle2:setVisible(bool2)
                 openTenBtn:setVisible(bool3)
                 openOneTitle3:setVisible(bool3)
            end
            if singleContent.item["type"] == "keybag" then
                updateBtnState(false,true,true)
            elseif singleContent.item["type"] == "soulbag" or singleContent.item["type"] == "boxrandom" or singleContent.item["type"] == "boxrandom1" then
                if singleContent["id"] == "boxrandom1_043" then
                    updateBtnState(true,false,false)
                else
                    updateBtnState(false,true,true)
                end
            elseif singleContent.item["type"] == "item" then
                --"item_028","item_029","item_030","item_031","item_032",
                local dontDis = { "item_025","item_024" ,"item_004",
                 "item_016", "item_011",  "item_012", "item_013", "item_014", "itemcamp_009", "itemcamp_011" }
                local btnHaveChanged = false 
          
                -- if table.ContainsObject(dontDis, singleContent.item["id"] )  then
                --     updateBtnState(false,false,false) --没有使用按钮
                -- else 
                --     updateBtnState(true,false,false) 
                -- end

                for i=1,#dontDis do
                    if singleContent.item["id"] == dontDis[i] then
                        updateBtnState(false,false,false) --没有使用按钮
                        btnHaveChanged = true
                        break
                    end
                end
                if not btnHaveChanged then
                    updateBtnState(true,false,false) 
                end

                -- if singleContent.item["id"] == "item_025" or singleContent.item["id"] == "item_024" or singleContent.item["id"] == "item_004" or singleContent.item["id"] == "item_016" or singleContent.item["id"] == "item_011" or singleContent.item["id"] == "item_012" or singleContent.item["id"] == "item_013" or singleContent.item["id"] == "item_014" or singleContent.item["id"] == "itemcamp_009" or singleContent.item["id"] == "itemcamp_011" then 
                --     updateBtnState(false,false,false) 
                -- else
                --     updateBtnState(true,false,false) 
                -- end
            elseif singleContent.item["type"] == "vip" then
                updateBtnState(true,false,false)
                openOneTitle1:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("kaiqi_text.png"))
            elseif singleContent.item["type"] == "add" then
                if singleContent.item["id"] == "itemcamp_001" then
                    updateBtnState(false,false,false)
                else
                    updateBtnState(true,false,false)
                end
            elseif singleContent.item["type"] == "stuff_01" or singleContent.item["type"] == "stuff_02" or singleContent.item["type"] == "stuff_03" then
                updateBtnState(true,false,false)
                levelSprite:setVisible(true)
                rbLabel:setString(singleContent.item.sort)
                levelSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("level_bg_%s.png",singleContent.item.rank)))
            elseif singleContent.item["type"] == "chapter" then
                updateBtnState(false,false,false)
            elseif singleContent.item["type"] == "box" then
                updateBtnState(true,false,false)
            elseif singleContent.item["type"] == "drawing" then
                updateBtnState(true,false,false)
                openOneTitle1:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("pinghe_text.png"))
            elseif singleContent.item["type"] == "delay" then
                countTitle:setVisible(false)
                countLabel:setVisible(false)
                useTImeTitle:setVisible(true)
                useTitleLabel:setVisible(true)
            end
            usebtn:setTag(a1)
            openOneBtn:setTag(a1)
            openTenBtn:setTag(a1)
            local nameLabel = tolua.cast(WarehouseCellOwner["nameLabel"],"CCLabelTTF")
            nameLabel:setString(singleContent.item.name)
            local despLabel = tolua.cast(WarehouseCellOwner["despLabel"],"CCLabelTTF")
            despLabel:setString(singleContent.item.desp)
            if singleContent.item["type"] ~= "delay" then
                local priceLabel = tolua.cast(WarehouseCellOwner["countLabel"],"CCLabelTTF")
                priceLabel:setString(singleContent.count)
            else
                if singleContent.bag.lastTime and DateUtil:beginDay(singleContent.bag.lastTime) == DateUtil:beginDay(userdata.loginTime) then
                    updateBtnState(false,false,false)
                    nextUseTip:setVisible(true)
                else
                    updateBtnState(true,false,false)
                    nextUseTip:setVisible(false)
                end
                local count = wareHouseData:getBagDelayLastTime(singleContent.id)
                useTitleLabel:setString(HLNSLocalizedString("bagDelay.cnt", count))
            end
            local rankFrame = tolua.cast(WarehouseCellOwner["rankFrame"],"CCMenuItemImage")
            rankFrame:setTag(a1)
            local avatarSprite = tolua.cast(WarehouseCellOwner["avatarSprite"],"CCSprite")
            if avatarSprite then
                local texture
                if equipdata:getEquipIconByEquipId( singleContent.item.icon ) then
                    texture = CCTextureCache:sharedTextureCache():addImage(equipdata:getEquipIconByEquipId( singleContent.item.icon ))
                end
                if texture then
                    avatarSprite:setVisible(true)
                    avatarSprite:setTexture(texture)
                    if singleContent.item.rank == 4 then
                        HLAddParticleScale( "images/purpleEquip.plist", avatarSprite, ccp(avatarSprite:getContentSize().width / 2,avatarSprite:getContentSize().height / 2), 1, 100, 777, 2 / 0.35 / retina, 2 / 0.35 / retina, 1 )
                    end
                end  
            end
            rankFrame:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", singleContent.item.rank)))
            rankFrame:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", singleContent.item.rank)))

            _hbCell:setScale(retina)
            a2:addChild(_hbCell, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            _hbCell:stopAllActions()
            cellArray1[tostring(a1)] = _hbCell
            r = a2
        elseif fn == "numberOfCells" then
            r = getMyTableCount(allData)
            -- r = 2
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
    local _mainLayer = getMainLayer()
    local x = 1
    if _mainLayer then

        local size = CCSizeMake(winSize.width, (winSize.height - _topLayer:getContentSize().height - _mainLayer:getBottomContentSize().height)*99/100)  -- 这里是为了在tableview上面显示一个小空出来
        _tableView = LuaTableView:createWithHandler(h, size)
        _tableView:setBounceable(true)
        _tableView:setAnchorPoint(ccp(0,0))
        _tableView:setPosition(0,_mainLayer:getBottomContentSize().height)
        _tableView:setVerticalFillOrder(0)
        _layer:addChild(_tableView)
    end
end

local function refreshContent(  )
    if _tableView2 then
        shardDatas = shardData:getAllShard()
        local offsetY = _tableView2:getContentOffset().y
        local contentSizeHeight = _tableView2:getContentSize().height
        _tableView2:reloadData()
        if _tableView2:getContentSize().height <= (winSize.height - _topLayer:getContentSize().height - getMainLayer():getBottomContentSize().height)*99/100 
            or offsetY < _tableView2:getContentOffset().y 
            or contentSizeHeight <= (winSize.height - _topLayer:getContentSize().height - getMainLayer():getBottomContentSize().height)*99/100 then
        else
            _tableView2:setContentOffset(ccp(0, offsetY))
        end
    end
end

local function _addTableView2()
    _topLayer = WarehouseViewOwner["titleLayer"]
    shardDatas = shardData:getAllShard()

    -- WarehouseCellOwner["openTenBtnTaped"] = openTenBtnTaped

    local function onShuiPianAvatarTaped( tag,sender )
        local shardContent = shardDatas[tonumber(tag)]
        -- PrintTable(shardContent)
        local equipLayer = createEquipInfoLayer(shardContent.shardConf.equip, 2, -135)
        -- local array = {}
        -- array.shardId = shardContent.id
        -- array.count = shardContent.count
        -- local equipLayer = createEquipInfoLayer(shardContent.shardConf.equip, 4, -135,array)
        getMainLayer():addChild(equipLayer) 
    end

    ShuipianCellOwner["onShuiPianAvatarTaped"] = onShuiPianAvatarTaped

    local function mergeCallBack( url,rtnData )
        refreshContent(  )
    end

    local function onBuildBtnTaped( tag,sender )
        local shardContent = shardDatas[tonumber(tag)]
        if shardContent.shardConf.num > shardContent.count then
            ShowText(HLNSLocalizedString("ERR_1604"))
        else
            doActionFun("MERGE_SHARD_URL",{shardContent.id},mergeCallBack) 
        end
    end

    ShuipianCellOwner["onBuildBtnTaped"] = onBuildBtnTaped

    allData = wareHouseData:getAllWareHouseData()
    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(winSize.width, 170 * retina)
        elseif fn == "cellAtIndex" then
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            local shardContent = shardDatas[a1 + 1]
            local  proxy = CCBProxy:create()
            local  _hbCell  = tolua.cast(CCBReaderLoad("ccbResources/ShuiPianCellView.ccbi",proxy,true,"ShuipianCellOwner"),"CCLayer")
            
            local buildBtn = tolua.cast(ShuipianCellOwner["buildBtn"],"CCMenuItemImage")
            buildBtn:setTag(a1 + 1)

            -- local levelSprite = tolua.cast(WarehouseCellOwner["levelSprite"],"CCSprite")
            -- local rbLabel = tolua.cast(WarehouseCellOwner["rbLabel"],"CCLabelTTF")

          
            -- usebtn:setTag(a1)
            local nameLabel = tolua.cast(ShuipianCellOwner["nameLabel"],"CCLabelTTF")
            nameLabel:setString(shardContent.shardConf.name)

            local rank = tolua.cast(ShuipianCellOwner["rank"], "CCSprite")
            rank:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("rank_%d_icon.png", shardContent.shardConf.rank)))

            local haoxiangni = tolua.cast(ShuipianCellOwner["avatarSprite"], "CCSprite")
            if haoxiangni then
                local texture = CCTextureCache:sharedTextureCache():addImage(equipdata:getEquipIconByEquipId( shardContent.shardConf.icon ))
                if texture then
                    haoxiangni:setVisible(true)
                    haoxiangni:setTexture(texture)
                    if shardContent.shardConf.rank == 4 then
                        HLAddParticleScale( "images/purpleEquip.plist", haoxiangni, ccp(haoxiangni:getContentSize().width / 2,haoxiangni:getContentSize().height / 2), 1, 100, 777, 2 / 0.35 / retina, 2 / 0.35 / retina, 1 )
                    end
                end  
            end
            local rankFrame = tolua.cast(ShuipianCellOwner["rankFrame"],"CCMenuItemImage")
            rankFrame:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", shardContent.shardConf.rank)))
            rankFrame:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", shardContent.shardConf.rank)))
            rankFrame:setTag(a1 + 1)

            local attrIcon = tolua.cast(ShuipianCellOwner["attrIcon"], "CCSprite")
            local myType
            local myAttrValue
            for key,value in pairs(shardContent.equipConf.initial) do
                myType = key
                myAttrValue = value
            end
            attrIcon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("%s_icon.png",(myType == "mp") and "int" or myType)))
            
            local attr = tolua.cast(ShuipianCellOwner["attrLabel"],"CCLabelTTF")
            if myAttrValue < 1 then
                attr:setString(string.format("+ %d%%",myAttrValue * 100))
            else
                attr:setString(string.format("+ %d",myAttrValue))
            end

            local price = tolua.cast(ShuipianCellOwner["valueLabel"], "CCLabelTTF")
            price:setString(equipdata:getEquipPriceConfig(shardContent.equipConf.id))

            local countLabel = tolua.cast(ShuipianCellOwner["countLabel"],"CCLabelTTF")
            countLabel:setString(shardContent.count)
            local despLabel = tolua.cast(ShuipianCellOwner["despLabel"],"CCLabelTTF")

            if shardContent.shardConf.num > shardContent.count then
                countLabel:setColor(ccc3(255,0,0))
                despLabel:setString(HLNSLocalizedString("缺少%d个",shardContent.shardConf.num - shardContent.count))
            else
                despLabel:setString(HLNSLocalizedString("可打造!"))
            end
            
            local needCountLabel = tolua.cast(ShuipianCellOwner["needCountLabel"],"CCLabelTTF")
            needCountLabel:setString("/"..shardContent.shardConf.num)
            _hbCell:setScale(retina)
            a2:addChild(_hbCell, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            _hbCell:stopAllActions()
            cellArray2[tostring(a1)] = _hbCell
            r = a2
        elseif fn == "numberOfCells" then
            r = getMyTableCount(shardDatas)
            -- r = 2
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
    local _mainLayer = getMainLayer()
    local x = 1
    if _mainLayer then

        local size = CCSizeMake(winSize.width, (winSize.height - _topLayer:getContentSize().height - _mainLayer:getBottomContentSize().height)*99/100)  -- 这里是为了在tableview上面显示一个小空出来
        _tableView2 = LuaTableView:createWithHandler(h, size)
        _tableView2:setBounceable(true)
        _tableView2:setAnchorPoint(ccp(0,0))
        _tableView2:setPosition(0,_mainLayer:getBottomContentSize().height)
        _tableView2:setVerticalFillOrder(0)
        _layer:addChild(_tableView2)
    end
end

local function setMenuPriority()
    local menu = tolua.cast(WarehouseViewOwner["topMenu"], "CCMenu")
    menu:setHandlerPriority(-129)
end

local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/WarehouseView.ccbi",proxy, true,"WarehouseViewOwner")
    _layer = tolua.cast(node,"CCLayer")
end

function getWareHouseLayer()
	return _layer
end

function createWareHouseLayer()
    _init()

    -- 使用礼包的回调
    function _layer:useCallBack( url,rtnData )
        if rtnData["code"] == 200 then
            if rtnData.info.delayItems then
                wareHouseData.bagDelay = rtnData.info.delayItems
            end
            _refreshUI()
        end
    end

	function _layer:refresh()
		_refreshUI()
	end

    function _layer:gotoPageByType( mytype )
        if mytype == 0 then
            setTopBtnState(true,false)
        else
            setTopBtnState(false,true)
        end
    end

    local function _onEnter()
        _addTableView()
        _addTableView2()
        _layer:gotoPageByType(0)
        addObserver(NOTI_SHOP_BUY_SUCCESS, _refreshUI)
        addObserver(NOTI_MERGE_SHUIPIAN_SUCCESS, refreshContent)
        addObserver(NOTI_RENAME_SUCCESS, _refreshUI)
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
    end

    local function _onExit()
        print("onExit")
        _topLayer = nil
        _layer = nil
        allData = nil
        _tableView = nil
        _tableView2 = nil
        shardDatas = nil
        _priority = nil
        cellArray1 = {}
        cellArray2 = {}
        removeObserver(NOTI_SHOP_BUY_SUCCESS, _refreshUI)
        removeObserver(NOTI_MERGE_SHUIPIAN_SUCCESS, refreshContent)
        removeObserver(NOTI_RENAME_SUCCESS, _refreshUI)
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