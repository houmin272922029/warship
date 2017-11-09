local _layer
local _uniqueId
local _allData
local progress
local weaponMaterial
local persentLabel
local count1 = 0
local count2 = 0
local materialValue = 0
local stageValue = 0
local materialTable = {}
local firstWepTable = {}
local currentStage

local shadowLabel1
local shadowLabel2

local attrValue

local _tableView
local scheduler = CCDirector:sharedDirector():getScheduler()
local myschedu
local touchKeeped  = false --触摸后是否一直保持着

-- ·名字不要重复
EquipRefineLayerOwner = EquipRefineLayerOwner or {}
ccb["EquipRefineLayerOwner"] = EquipRefineLayerOwner

local function stopMyschedu(  )
    if myschedu then
        scheduler:unscheduleScriptEntry(myschedu)
        myschedu = nil
    end
end

local function refreshItemVisible(  )
    local flag = currentStage > _allData.stage
    local stageSprite1 = tolua.cast(EquipRefineLayerOwner["stageSprite1"],"CCSprite")
    local stageSprite2 = tolua.cast(EquipRefineLayerOwner["stageSprite2"],"CCSprite")
    local stageLabel1 = tolua.cast(EquipRefineLayerOwner["stageLabel1"],"CCLabelTTF")
    local stageLabel2 = tolua.cast(EquipRefineLayerOwner["stageLabel2"],"CCLabelTTF")
    local nowAttrIcon = EquipRefineLayerOwner["nowAttrIcon"]
    local nextAttrIcon = EquipRefineLayerOwner["nextAttrIcon"]
    local developBaseAttr2 = tolua.cast(EquipRefineLayerOwner["developBaseAttr2"],"CCLabelTTF")
    local developTopAttr2 = tolua.cast(EquipRefineLayerOwner["developTopAttr2"],"CCLabelTTF")
    local secondeLabel = tolua.cast(EquipRefineLayerOwner["secondeLabel"],"CCLabelTTF")
    local tipsLabel = tolua.cast(EquipRefineLayerOwner["tipsLabel"],"CCLabelTTF")
    local arrow1 = tolua.cast(EquipRefineLayerOwner["arrow1"],"CCSprite")
    local arrow2 = tolua.cast(EquipRefineLayerOwner["arrow2"],"CCSprite")
    local arrow3 = tolua.cast(EquipRefineLayerOwner["arrow3"],"CCSprite")
    local scale9sprite1 = tolua.cast(EquipRefineLayerOwner["scale9sprite1"],"CCSprite")
    local scale9sprite2 = tolua.cast(EquipRefineLayerOwner["scale9sprite2"],"CCSprite")
    local nowAttrLabel = tolua.cast(EquipRefineLayerOwner["nowAttrLabel"],"CCLabelTTF")
    local preAttrLabel = tolua.cast(EquipRefineLayerOwner["preAttrLabel"],"CCLabelTTF")
    stageSprite1:setVisible(flag)
    stageSprite2:setVisible(flag)
    stageLabel1:setVisible(flag)
    stageLabel2:setVisible(flag)
    nowAttrIcon:setVisible(flag)
    nextAttrIcon:setVisible(flag)
    developBaseAttr2:setVisible(flag)
    developTopAttr2:setVisible(flag)
    secondeLabel:setVisible(flag)
    tipsLabel:setVisible(flag)
    arrow1:setVisible(flag)
    arrow2:setVisible(flag)
    arrow3:setVisible(flag)
    scale9sprite1:setVisible(flag)
    scale9sprite2:setVisible(flag)
    nowAttrLabel:setVisible(flag)
    preAttrLabel:setVisible(flag)
end

local function _refreshContent(  )
    local nameLabel = tolua.cast(EquipRefineLayerOwner["nameLabel"],"CCLabelTTF")
    nameLabel:setString(_allData["name"])
    
    local levelbgLabel = tolua.cast(EquipRefineLayerOwner["levelbgLabel"],"CCLabelTTF")
    levelbgLabel:setString(tostring(_allData["level"]))
    local levelLabel = tolua.cast(EquipRefineLayerOwner["levelLabel"],"CCLabelTTF")
    levelLabel:setString(tostring(_allData["level"]))

    local levelSprite = tolua.cast(EquipRefineLayerOwner["levelSprite"],"CCSprite")
    levelSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("level_bg_%s.png",_allData["rank"])))
    
    local exitText = tolua.cast(EquipRefineLayerOwner["exitText"],"CCSprite")
    if getMyTableCount(materialTable) > 0 then
        exitText:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("fangqi_text.png"))
    else
        exitText:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tuichu_title.png"))
    end
    currentStage = _allData["stage"]
    materialValue = _allData.expNow
    -- 一个递归，实现增加一个值，多个值同时增加
    local function addMaterial( _currentStage,_materialValue )
        local finalStage = _currentStage
        local nowExp = _materialValue
        local upExp = _allData.refinelv[string.format("%d",finalStage + 1)]
        if upExp and nowExp > upExp then
            nowExp = nowExp - upExp
            finalStage = finalStage + 1
            return addMaterial( finalStage,nowExp )
        else
            local retArray = {}
            retArray[1] = finalStage
            retArray[2] = nowExp
            return retArray
        end
    end

    local contentArray = addMaterial( currentStage,materialValue )

    currentStage = contentArray[1]
    materialValue = contentArray[2]
    
    local persentNum2 = _allData.refinelv[string.format("%d",contentArray[1] + 1)]
    if persentNum2 == nil then   persentNum2 = " 0"    end              
    persentLabel:setString(string.format("%s/%s",contentArray[2],persentNum2 ))
    if contentArray[1] ~= ConfigureStorage.equipStagelMax then
        progress:setPercentage(contentArray[2] / persentNum2 * 100)
    else
        progress:setPercentage(contentArray[2] / 1)
    end

    shadowLabel1:setString(HLNSLocalizedString("%s阶",_allData["stage"]))
    shadowLabel2:setString(HLNSLocalizedString("%s阶",_allData["stage"]))


    local nowAttrIcon = EquipRefineLayerOwner["nowAttrIcon"]
    local nextAttrIcon = EquipRefineLayerOwner["nextAttrIcon"]

    nowAttrIcon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(equipdata:getDisplayFrameByType(equipdata:getEquipAttrType( _allData.id ))))
    nextAttrIcon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(equipdata:getDisplayFrameByType(equipdata:getEquipAttrType( _allData.id ))))

    local stageSprite1 = tolua.cast(EquipRefineLayerOwner["stageSprite1"],"CCSprite")
    local stageSprite2 = tolua.cast(EquipRefineLayerOwner["stageSprite2"],"CCSprite")
    local stageLabel1 = tolua.cast(EquipRefineLayerOwner["stageLabel1"],"CCLabelTTF")
    local stageLabel2 = tolua.cast(EquipRefineLayerOwner["stageLabel2"],"CCLabelTTF")

    stageLabel1:setString(tostring(_allData.stage..HLNSLocalizedString("阶")))
    stageLabel2:setString(tostring(currentStage..HLNSLocalizedString("阶")))

    local nowAttrLabel = tolua.cast(EquipRefineLayerOwner["nowAttrLabel"],"CCLabelTTF")
    nowAttrLabel:setString(equipdata:getOneEquipAttrByLevelAndStage( _allData.equipId,_allData["level"],_allData.stage ))
    local preAttrLabel = tolua.cast(EquipRefineLayerOwner["preAttrLabel"],"CCLabelTTF")
    preAttrLabel:setString(equipdata:getOneEquipAttrByLevelAndStage( _allData.equipId,_allData["level"],currentStage ))

    local developBaseAttr = tolua.cast(EquipRefineLayerOwner["developBaseAttr"],"CCLabelTTF")
    local developTopAttr = tolua.cast(EquipRefineLayerOwner["developTopAttr"],"CCLabelTTF")

    developBaseAttr:setString(_allData.updateEffect)
    developTopAttr:setString("+ "..(_allData.stage * _allData.refine))

    local developBaseAttr2 = tolua.cast(EquipRefineLayerOwner["developBaseAttr2"],"CCLabelTTF")
    local developTopAttr2 = tolua.cast(EquipRefineLayerOwner["developTopAttr2"],"CCLabelTTF")

    developBaseAttr2:setString(_allData.updateEffect)
    developTopAttr2:setString("+ "..(currentStage * _allData.refine))

    refreshItemVisible(  )
end

local function updateProgressLabel(  )
    
end

local function onMaterialTaped( tag,sender )
    print(tag)
    local materialCountLabel = tolua.cast(EquipRefineLayerOwner[string.format("materialCountLabel%s",tag)],"CCLabelTTF")
    local string = materialCountLabel:getString()
    local finalStr
    if string - 1 < 0 then
        finalStr = 0
        return
    else 
        finalStr = string - 1
    end
    materialCountLabel:setString(finalStr)
    local material = weaponMaterial[tag]
    local matValue = material.item.params
    materialValue = materialValue + material.item.params
    
    local finalStage = currentStage + 1
    local upStageValue = _allData.refinelv[string.format("%d",finalStage)]
    if materialValue > upStageValue then
        materialValue = materialValue - upStageValue
        upStageValue = _allData.refinelv[string.format("%d",finalStage + 1)]
        currentStage = currentStage + 1
        finalStage = finalStage + 1
    end
    persentLabel:setString(string.format("%s/%s",materialValue,upStageValue))
    progress:setPercentage(materialValue / upStageValue * 100)

    -- local stageLabel1 = tolua.cast(EquipRefineLayerOwner["stageLabel1"],"CCLabelTTF")
    -- local stageLabel2 = tolua.cast(EquipRefineLayerOwner["stageLabel2"],"CCLabelTTF")

    -- if currentStage + 1 > 1 then
    --     -- stageSprite2:setVisible(true)
    --     stageLabel2:setVisible(true)
    -- end

    -- stageLabel1:setString(_allData["stage"])
    -- stageLabel2:setString(finalStage)

    if materialTable[string.format("%s",material.item.id)] then
        materialTable[string.format("%s",material.item.id)] = materialTable[string.format("%s",material.item.id)] + 1
    else
        materialTable[string.format("%s",material.item.id)] = 1
    end

end

EquipRefineLayerOwner["onMaterialTaped"] = onMaterialTaped

local function refineCallBack( url,rtnData )
    if rtnData["code"] == 200 then
        
        playEffect(MUSIC_SOUND_WEAPON_REFINE)

        -- 字体方式弹出强化效果
        -- _popUpRefineValue(value)

        local avatar = tolua.cast(EquipRefineLayerOwner["avatarFrame"], "CCSprite")
        HLAddParticleScale( "images/eff_refineEquip_1.plist", avatar, ccp(avatar:getContentSize().width / 2,avatar:getContentSize().height * 0.5), 1, 1, 1,0.6/retina,0.6/retina)
        HLAddParticleScale( "images/eff_refineEquip_2.plist", avatar, ccp(avatar:getContentSize().width / 2,avatar:getContentSize().height * 0.5), 1, 1, 1,1.2/retina,1.2/retina)

        for k,v in pairs(rtnData["info"]["equips"]) do
             equipdata.equips[k] = v
        end 
        materialTable = {}
        local firstStage = _allData["stage"]
        _allData = equipdata:getEquip(_uniqueId)
        _refreshContent()
        if _allData["stage"] > firstStage then  
            if getMainLayer() then
                getMainLayer():addChild(createEquipRefinResultLayer(_uniqueId,attrValue))
            end
        end
    end
end

local function onRefineBtnTap(  )
    if userdata.level >= 18 then
        if getMyTableCount(materialTable) <= 0 then
            ShowText(HLNSLocalizedString("请点选精炼材料"))
        else
            doActionFun("REFINE_EQUIP_URL",{_allData.id,materialTable},refineCallBack)
        end
    else
        ShowText(HLNSLocalizedString("船长等级超过18级才可精炼装备"))
    end
end

local function onExitBtnTap(  )
    if getMyTableCount(materialTable) > 0 then
        stopMyschedu()
        materialTable = {}
        local exitText = tolua.cast(EquipRefineLayerOwner["exitText"],"CCSprite")
        if getMyTableCount(materialTable) > 0 then
            exitText:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("fangqi_text.png"))
        else
            exitText:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tuichu_title.png"))
        end
        _allData = equipdata:getEquip(_uniqueId)
        weaponMaterial = deepcopy(firstWepTable)
        _refreshContent()
        local ffsetX = _tableView:getContentOffset().x
        _tableView:reloadData()
        _tableView:setContentOffset(ccp(ffsetX, 0))
    else
        if getMainLayer() then
            getMainLayer():gotoEquipmentsLayer()
        end
    end
end

EquipRefineLayerOwner["onRefineBtnTap"] = onRefineBtnTap
EquipRefineLayerOwner["onExitBtnTap"] = onExitBtnTap

local function addMaterialTable()

    local materialLayer = tolua.cast(EquipRefineLayerOwner["materialLayer"],"CCLayer")

    local weaponType = equipdata:getEquipTypeValue( _allData.id )
    if weaponType == "weapon" then
        weaponMaterial = wareHouseData:getWeaponRefineItem(  )
    elseif weaponType == "armor" then
        weaponMaterial = wareHouseData:getClothRefineItem(  )
    elseif weaponType == "belt" then
        weaponMaterial = wareHouseData:getDecoratRefineItem(  )
    elseif weaponType == "rune" then
        weaponMaterial = wareHouseData:getRuneRefineItem(  )
    end
    firstWepTable = deepcopy(weaponMaterial)
    
    EquipRefineMaterialCellOwner = EquipRefineMaterialCellOwner or {}
    ccb["EquipRefineMaterialCellOwner"] = EquipRefineMaterialCellOwner
    -- @param fn string Callback type
    -- @param table LuaTableView
    -- @param a1 & a2 mixed Difference means for every "fn"
    local touchBeganTime --触摸开始的时间

    local function myAddMaterial( tag)
        -- body
        if weaponMaterial[tag]["count"] >= 1 then

                local function addMaterial( _currentStage,_materialValue )
                    local finalStage = _currentStage
                    local nowExp = _materialValue
                    print("看看n",_allData.refinelv[string.format("%d",finalStage + 1)])

                    if finalStage == ConfigureStorage.equipStagelMax then
                        ShowText( HLNSLocalizedString("equipRefine.hadReachedTheHighest") )  --"已经到达最高阶,不能再增加经验了",
                        stopMyschedu()
                        return 
                    end

                    local function makeRetArray( )
                        local retArray = {}
                        retArray[1] = finalStage
                        retArray[2] = nowExp
                        return retArray
                    end

                    if nowExp >= _allData.refinelv[string.format("%d",finalStage + 1)] then
                        nowExp = nowExp - _allData.refinelv[string.format("%d",finalStage + 1)]
                        finalStage = finalStage + 1
                        if finalStage == ConfigureStorage.equipStagelMax then
                            stopMyschedu()
                            return makeRetArray( )
                        end
                        return addMaterial( finalStage,nowExp )
                    else
                        return makeRetArray( )
                    end
                end

                local tempMaterial = materialValue
                local tempStage = currentStage

                local material = weaponMaterial[tag]
                materialValue = materialValue + material.item.params

                local finalArray = addMaterial( currentStage,materialValue )
                if finalArray and finalArray[1] <= ConfigureStorage.equipStagelMax then
                    currentStage = finalArray[1]
                    materialValue = finalArray[2]
                    
                    weaponMaterial[tag]["count"] = weaponMaterial[tag]["count"] - 1
                    local persentNum2
                    if finalArray[1] ~= ConfigureStorage.equipStagelMax then
                        persentNum2 = _allData.refinelv[string.format("%d",finalArray[1] + 1)]
                    elseif finalArray[1] == ConfigureStorage.equipStagelMax then
                        persentNum2 = " 0"
                    end
                    persentLabel:setString(string.format("%s/%s",finalArray[2], persentNum2))
                    if finalArray[1] ~= ConfigureStorage.equipStagelMax then
                        progress:setPercentage(finalArray[2] / persentNum2 * 100)
                    else
                        progress:setPercentage(finalArray[2] / 1)
                    end
                    shadowLabel1:setString(currentStage..HLNSLocalizedString("阶"))
                    shadowLabel2:setString(currentStage..HLNSLocalizedString("阶"))

                    local stageSprite1 = tolua.cast(EquipRefineLayerOwner["stageSprite1"],"CCSprite")
                    local stageSprite2 = tolua.cast(EquipRefineLayerOwner["stageSprite2"],"CCSprite")
                    local stageLabel1 = tolua.cast(EquipRefineLayerOwner["stageLabel1"],"CCLabelTTF")
                    local stageLabel2 = tolua.cast(EquipRefineLayerOwner["stageLabel2"],"CCLabelTTF")

                    stageLabel1:setString(tostring(_allData.stage..HLNSLocalizedString("阶")))
                    stageLabel2:setString(tostring(currentStage..HLNSLocalizedString("阶")))

                    local nowAttrLabel = tolua.cast(EquipRefineLayerOwner["nowAttrLabel"],"CCLabelTTF")
                    nowAttrLabel:setString(equipdata:getOneEquipAttrByLevelAndStage( _allData.equipId,_allData["level"],_allData["stage"] ))
                    local preAttrLabel = tolua.cast(EquipRefineLayerOwner["preAttrLabel"],"CCLabelTTF")
                    preAttrLabel:setString(equipdata:getOneEquipAttrByLevelAndStage( _allData.equipId,_allData["level"],currentStage ))

                    local developBaseAttr2 = tolua.cast(EquipRefineLayerOwner["developBaseAttr2"],"CCLabelTTF")
                    local developTopAttr2 = tolua.cast(EquipRefineLayerOwner["developTopAttr2"],"CCLabelTTF")

                    developBaseAttr2:setString(_allData.updateEffect)
                    developTopAttr2:setString("+ "..(currentStage * _allData.refine))

                    refreshItemVisible(  )

                    if materialTable[string.format("%s",material.item.id)] then
                        materialTable[string.format("%s",material.item.id)] = materialTable[string.format("%s",material.item.id)] + 1
                    else
                        materialTable[string.format("%s",material.item.id)] = 1
                    end

                    local exitText = tolua.cast(EquipRefineLayerOwner["exitText"],"CCSprite")
                    if getMyTableCount(materialTable) > 0 then
                        exitText:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("fangqi_text.png"))
                    else
                        exitText:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tuichu_title.png"))
                    end

                    local ffsetX = _tableView:getContentOffset().x
                    _tableView:reloadData()
                    _tableView:setContentOffset(ccp(ffsetX, 0))

                elseif finalArray and finalArray[1] > ConfigureStorage.equipStagelMax then
                    ShowText(HLNSLocalizedString("装备能升最大阶为%d",ConfigureStorage.equipStagelMax))
                end
        else
            ShowText(HLNSLocalizedString("您的仓库里没有此材料，去起航\n闯关可以有机会获得喔！"))
            touchKeeped  = false
            stopMyschedu(  )
        end

    end
    --local function  end

    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(105, 105)
        elseif fn == "cellAtIndex" then
            -- Return CCTableViewCell, a1 is cell index (zero based), a2 is dequeued cell (maybe nil)
            -- Do something to create cell and change the content
            
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            local  proxy = CCBProxy:create()
            local _hbCell  = tolua.cast(CCBReaderLoad("ccbResources/EquipRefineMaterialCell.ccbi",proxy,true,"EquipRefineMaterialCellOwner"),"CCLayer")
            
            local frame = tolua.cast(EquipRefineMaterialCellOwner["frame"],"CCMenuItemImage")
            local materialCountLabel = tolua.cast(EquipRefineMaterialCellOwner["materialCountLabel"],"CCLabelTTF")
            local materialBtn = tolua.cast(EquipRefineMaterialCellOwner["frame"],"CCMenuItemImage")
            local equipIcon = tolua.cast(EquipRefineMaterialCellOwner["equipIcon"],"CCSprite")
            materialCountLabel:setString(weaponMaterial[a1 + 1]["count"])
            
            materialBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", weaponMaterial[a1 + 1].item.rank)))
            materialBtn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", weaponMaterial[a1 + 1].item.rank)))
            if equipIcon then
                local texture = CCTextureCache:sharedTextureCache():addImage(equipdata:getEquipIconByEquipId( weaponMaterial[a1 + 1].item.icon ))
                if texture then
                    equipIcon:setVisible(true)
                    equipIcon:setTexture(texture)
                end  
            end

            local levelBg = tolua.cast(EquipRefineMaterialCellOwner["levelBg"],"CCSprite")
            levelBg:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("level_bg_%s.png",weaponMaterial[a1 + 1].item.rank)))

            local levelLabel = tolua.cast(EquipRefineMaterialCellOwner["levelLabel"],"CCLabelTTF")
            levelLabel:setString(weaponMaterial[a1 + 1].item.sort)

            local colorLayer = tolua.cast(EquipRefineMaterialCellOwner["colorLayer"],"CCLayer")
            if weaponMaterial[a1 + 1]["count"] > 0 then
                colorLayer:setVisible(false)
            else
                colorLayer:setVisible(true)
            end

            -- _hbCell:setScale(retina)
            a2:addChild(_hbCell, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            r = a2
        elseif fn == "numberOfCells" then
            r = getMyTableCount(weaponMaterial)
        elseif fn == "cellTouched" then         -- A cell was touched, a1 is cell that be touched. This is not necessary.
            print("cellTouched")
            local tag = a1:getIdx() + 1
            myAddMaterial( tag) --加材料一次

            touchKeeped  = false
            stopMyschedu(  )

        elseif fn == "cellTouchBegan" then      -- A cell is touching, a1 is cell, a2 is CCTouch
            print("cellTouchBegan")
            local tag = a1:getIdx() + 1
            
            local function mySchedulerFunc(  )
                print("**lsf desTime",os.time() - touchBeganTime)
                if os.time() - touchBeganTime > 0.5  and touchKeeped then --一直摁着超过1s
                    print("**lsf dosomething")
                    myAddMaterial( tag)
                end
            end
            touchBeganTime = os.time() --touchBeganTime ,tableView里的局部变量
            touchKeeped  = true
            stopMyschedu(  )
            myschedu = scheduler:scheduleScriptFunc(mySchedulerFunc, 0.1, false)
            -- return true
        elseif fn == "cellTouchEnded" then      -- A cell was touched, a1 is cell, a2 is CCTouch
            print("cellTouchEnded")
            touchKeeped  = false
            stopMyschedu(  )

        elseif fn == "cellHighlight" then       -- A cell is highlighting, coco2d-x 2.1.3 or above
        elseif fn == "cellUnhighlight" then     -- A cell had been unhighlighted, coco2d-x 2.1.3 or above
        elseif fn == "cellWillRecycle" then     -- A cell will be recycled, coco2d-x 2.1.3 or above
        elseif fn == "scroll" then
                
        end
        return r
    end)
    
    local size = CCSizeMake(materialLayer:getContentSize().width , materialLayer:getContentSize().height)
    _tableView = LuaTableView:createWithHandler(h, size)
    _tableView:setBounceable(true)
    _tableView:setAnchorPoint(ccp(0,0))
    _tableView:setPosition(ccp(0, 0))
    _tableView:setDirection(0)
    _tableView:setVerticalFillOrder(0)
    materialLayer:addChild(_tableView)
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()

    local  node  = CCBReaderLoad("ccbResources/EquipRefineView.ccbi",proxy, true,"EquipRefineLayerOwner")
    _layer = tolua.cast(node,"CCLayer")
    persentLabel = tolua.cast(EquipRefineLayerOwner["persentLabel"],"CCLabelTTF")
    shadowLabel1 = tolua.cast(EquipRefineLayerOwner["expectLabel"],"CCLabelTTF")
    shadowLabel2 = tolua.cast(EquipRefineLayerOwner["expectShadowLabel"],"CCLabelTTF")
    local progressBg = tolua.cast(EquipRefineLayerOwner["progressBg"], "CCSprite")
    progressBg:setVisible(true)

    progress = CCProgressTimer:create(CCSprite:create("images/bluePro_refine.png"))
    progress:setType(kCCProgressTimerTypeBar)
    progress:setMidpoint(CCPointMake(0, 0))
    progress:setBarChangeRate(CCPointMake(1, 0))
    progress:setPosition(progressBg:getPositionX(), progressBg:getPositionY())

    progressBg:setVisible(false)
    persentLabel:getParent():reorderChild(persentLabel,100)
    progressBg:getParent():addChild(progress,0)
    progress:setPercentage(0)

    _allData = equipdata:getEquip(_uniqueId)
    for key,value in pairs(_allData.attr) do
        attrValue = value
    end

    local avatarFrame = tolua.cast(EquipRefineLayerOwner["avatarFrame"], "CCSprite") 
    avatarFrame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", _allData.rank)))
    
    local equipIcon = tolua.cast(EquipRefineLayerOwner["equipIcon"], "CCSprite") 
    if equipIcon then
        local texture = CCTextureCache:sharedTextureCache():addImage(equipdata:getEquipIconByEquipId( _allData.icon ))
        if texture then
            equipIcon:setVisible(true)
            equipIcon:setTexture(texture)
            if _allData.rank == 4 then
                HLAddParticleScale( "images/purpleEquip.plist", equipIcon, ccp(equipIcon:getContentSize().width / 2,equipIcon:getContentSize().height / 2), 1, 100, 777, 2 / 0.35 / retina, 2 / 0.35 / retina, 1 )
            elseif _allData.rank == 5 then
                HLAddParticleScale( "images/goldEquip.plist", equipIcon, ccp(equipIcon:getContentSize().width / 2,equipIcon:getContentSize().height / 2), 1, 100, 777, 2 / 0.35 / retina, 2 / 0.35 / retina, 1 )    
            end
        end  
    end
    addMaterialTable()
    _refreshContent()
end


-- 该方法名字每个文件不要重复
function getEquipRefineLayer()
	return _layer
end

function createEquipRefineLayer(uniqueId)
    _uniqueId = uniqueId
    _init()

	function _layer:refresh()
		
	end

    local function _onEnter()
    end

    local function _onExit()
        _layer = nil
        _uniqueId = nil
        _allData = nil
        progress = nil
        weaponMaterial = nil
        persentLabel = nil
        count1 = 0
        count2 = 0
        materialValue = 0
        stageValue = 0
        materialTable = {}
        currentStage = nil
        shadowLabel2 = nil
        shadowLabel1 = nil
        touchKeeped = false
        stopMyschedu(  )
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