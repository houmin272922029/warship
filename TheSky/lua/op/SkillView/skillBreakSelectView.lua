local _layer
local _allSkillData
local selectState
local sellIdArrays = {}
local selectBtnArray = {}
local _tableView
local _id
local _skillDic
local cellArray = {}

-- ·名字不要重复
BreakSkillSelectLayerOwner = BreakSkillSelectLayerOwner or {}
ccb["BreakSkillSelectLayerOwner"] = BreakSkillSelectLayerOwner

local function updataBtnState( bool1,bool2,bool3 )
    local quitBtn = BreakSkillSelectLayerOwner["quitBtn"]  --放弃按钮
    local giveupLabel = BreakSkillSelectLayerOwner["giveupLabel"]
    local exitLable = BreakSkillSelectLayerOwner["exitLable"]
    local confirLabel = BreakSkillSelectLayerOwner["confirLabel"]
    local confirmBtn = BreakSkillSelectLayerOwner["confirmBtn"]
    local exitBtn = BreakSkillSelectLayerOwner["exitBtn"]
    quitBtn:setVisible(bool1)
    giveupLabel:setVisible(bool1)
    confirmBtn:setVisible(bool2)
    confirLabel:setVisible(bool2)
    exitBtn:setVisible(bool3)
    exitLable:setVisible(bool3)
end

local function updataSelectBtnState( sender,bool )
    local sender = tolua.cast(sender,"CCMenuItemImage")
    if bool then
        sender:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("stamp3.png"))
        sender:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("stamp3.png"))
    else
        sender:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("stamp2.png"))
        sender:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("stamp3.png"))
    end
end

local function quitBtnClicked(  )
    if runtimeCache.skillUpdateMaterialArray[_id] then
        runtimeCache.skillUpdateMaterialArray[_id] = {}
    end
    updataBtnState(false,false,true)
    local offsetY = _tableView:getContentOffset().y
    _tableView:reloadData()
    _tableView:setContentOffset(ccp(0, offsetY))
end

local function sellConfirmCallBack( url,rtnData )
    if rtnData["code"] == 200 then
        updataBtnState(false,false,true)
    end
end

local function confirmBtnClicked(  )
    if getMainLayer() then
        getMainLayer():gotoBreakSkillView(_skillDic)
    end
end

local function exitBtnClicked(  )
    if getMainLayer() then
        getMainLayer():gotoBreakSkillView(_skillDic)
    end
end

BreakSkillSelectLayerOwner["quitBtnClicked"] = quitBtnClicked
BreakSkillSelectLayerOwner["confirmBtnClicked"] = confirmBtnClicked
BreakSkillSelectLayerOwner["exitBtnClicked"] = exitBtnClicked

local function _addTableView()
    -- 得到数据
    local _topLayer = BreakSkillSelectLayerOwner["EQTopLayer"]
    
    _allSkillData = skilldata:getOtherSkillsWithUniquieId(_id)
    
    if getMyTableCount(_allSkillData) <= 0 then
        local text = HLNSLocalizedString("船长，您已没有多余的奥义，到罗格镇开金银宝箱可以获得噢！")
        local function cardConfirmAction()
           if getMainLayer() then
                getMainLayer():goToLogue()
                getLogueTownLayer():gotoPageByType( 1 )
            end
        end
        local function cardCancelAction()
            
        end
        getMainLayer():addChild(createSimpleConfirCardLayer(text), 100)
        SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
        SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction
    end
    SkillSelectCellOwner = SkillSelectCellOwner or {}
    ccb["SkillSelectCellOwner"] = SkillSelectCellOwner

    -- EquipSellSelectCellOwner["onSelectBtnTap"] = onSelectBtnTap
    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            if a1 == 0 then
                r = CCSizeMake(winSize.width, 45 * retina)
            else
                r = CCSizeMake(winSize.width, 170 * retina)
            end
        elseif fn == "cellAtIndex" then
            
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            local  proxy = CCBProxy:create()
            local  _hbCell
            if a1 == 0 then
                _hbCell  = tolua.cast(CCBReaderLoad("ccbResources/TitleTipsLayerView.ccbi",proxy,true,"TitleTipsLayerOwner"),"CCLayer")
                local tipsLabel = tolua.cast(TitleTipsLayerOwner["tipsLabel"],"CCLabelTTF")
                tipsLabel:setString(HLNSLocalizedString("数量越多（最多5个）或选择同种奥义，成功的概率越大。"))
            else
                local skillContent = _allSkillData[a1]
                _hbCell  = tolua.cast(CCBReaderLoad("ccbResources/SkillSelectCell.ccbi",proxy,true,"SkillSelectCellOwner"),"CCLayer")
                
                local nameLabel = tolua.cast(SkillSelectCellOwner["nameLabel"],"CCLabelTTF")
                nameLabel:setString(skillContent.skillConf.name)

                local frameIcon = tolua.cast(SkillSelectCellOwner["frameIcon"],"CCSprite")
                frameIcon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%s.png", skillContent.skillConf.rank)))
                
                local avatarIcon = tolua.cast(SkillSelectCellOwner["avatarIcon"],"CCSprite")
                if avatarIcon then
                    local texture = CCTextureCache:sharedTextureCache():addImage(equipdata:getEquipIconByEquipId( skillContent.skillId ))
                    if texture then
                        avatarIcon:setVisible(true)
                        avatarIcon:setTexture(texture)
                        if skillContent.skillConf.rank == 4 then
                            HLAddParticleScale( "images/purpleEquip.plist", avatarIcon, ccp(avatarIcon:getContentSize().width / 2,avatarIcon:getContentSize().height / 2), 1, 100, 777, 2 / 0.35 / retina, 2 / 0.35 / retina, 1 )
                        elseif skillContent.skillConf.rank == 5 then
                            HLAddParticleScale( "images/goldEquip.plist", avatarIcon, ccp(avatarIcon:getContentSize().width / 2,avatarIcon:getContentSize().height / 2), 1, 100, 777, 2 / 0.35 / retina, 2 / 0.35 / retina, 1 )
                        end
                    end
                end

                local valueLabel = tolua.cast(SkillSelectCellOwner["valueLabel"],"CCLabelTTF")
                valueLabel:setString(skilldata:getSkillPriceBySid(skillContent["id"]))

                local equipOnLabel = tolua.cast(SkillSelectCellOwner["equipOnLabel"],"CCLabelTTF")
                if skillContent.owner then
                    equipOnLabel:setString(skillContent.owner.name)
                else
                    equipOnLabel:setVisible(false)
                end

                local levelLabel = tolua.cast(SkillSelectCellOwner["levelLabel"],"CCLabelTTF")
                levelLabel:setString(string.format("%s",skillContent.level))

                local lvLabel = tolua.cast(SkillSelectCellOwner["lvLabel"],"CCLabelTTF")
                lvLabel:setString("LV")
                lvLabel:enableShadow(CCSizeMake(2,-2), 1, 0)

                -- local attrLabel = tolua.cast(SkillSelectCellOwner["attrLabel"],"CCLabelTTF")
                -- attrLabel:setString(skillContent.skillConf.name)
                
                local rankSprite = tolua.cast(SkillSelectCellOwner["rankSprite"],"CCSprite")
                rankSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("rank_%d_icon.png", skillContent.skillConf.rank)))

                local attrSprite = tolua.cast(SkillSelectCellOwner["attrSprite"],"CCSprite")
                local myType
                for key,value in pairs(skillContent.skillConf.attr) do
                    myType = key
                end
                if equipdata:getDisplayFrameByType(myType) then
                    attrSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(equipdata:getDisplayFrameByType(myType)))
                end
                local attrLabel = SkillSelectCellOwner["attrLabel"]
                
                attrLabel:setString(skilldata:getSortDespArrtValueByUid( skillContent.id ))



                local stampSprite = tolua.cast(SkillSelectCellOwner["stampSprite"],"CCSprite")
                local cellBg = tolua.cast(SkillSelectCellOwner["cellBg"],"CCSprite")
                if runtimeCache.skillUpdateMaterialArray[_id] then
                    if runtimeCache.skillUpdateMaterialArray[_id][skillContent.id] then
                        stampSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("stamp3.png"))
                        cellBg:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("huobanCellBg_sel.png"))
                    else
                        stampSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("stamp2.png"))
                        cellBg:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("huobanCellBg.png"))
                    end
                end
            end
            _hbCell:setScale(retina)
            a2:addChild(_hbCell, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            _hbCell:stopAllActions()
            cellArray[tostring(a1)] = _hbCell
            r = a2
        elseif fn == "numberOfCells" then
            r = getMyTableCount(_allSkillData) + 1
        elseif fn == "cellTouched" then         -- A cell was touched, a1 is cell that be touched. This is not necessary.
            if not runtimeCache.skillUpdateMaterialArray[_id] or getMyTableCount(runtimeCache.skillUpdateMaterialArray[_id]) <= 4 then
                local tag = a1:getIdx()
                local content = _allSkillData[tag]
                local function addFun(  )
                    if runtimeCache.skillUpdateMaterialArray[_id] == nil then
                        if content.owner then
                            ShowText(HLNSLocalizedString("%s已装备于%s",content.skillConf.name,content.owner.name))
                        end
                        runtimeCache.skillUpdateMaterialArray[_id] = {}
                        runtimeCache.skillUpdateMaterialArray[_id][content.id] = content
                    else
                        if not runtimeCache.skillUpdateMaterialArray[_id][content.id] then
                            if content.owner then
                                ShowText(HLNSLocalizedString("%s已装备于%s",content.skillConf.name,content.owner.name))
                            end
                            runtimeCache.skillUpdateMaterialArray[_id][content.id] = content
                        else
                            runtimeCache.skillUpdateMaterialArray[_id][content.id] = nil
                        end
                    end
                end
                if runtimeCache.skillUpdateMaterialArray[_id] == nil then
                    if content.skillConf.rank >= 3 then
                        local function cardConfirmAction(  )
                            addFun()
                            local offsetY = _tableView:getContentOffset().y
                            _tableView:reloadData()
                            _tableView:setContentOffset(ccp(0, offsetY))
                            if runtimeCache.skillUpdateMaterialArray[_id] and getMyTableCount(runtimeCache.skillUpdateMaterialArray[_id]) > 0 then
                                updataBtnState(true,true,false)
                            else
                                updataBtnState(false,false,true)
                            end 
                        end
                        local function cardCancelAction(  )
                            
                        end
                        _layer:addChild(createSimpleConfirCardLayer(HLNSLocalizedString("船长，你选择了A级以上的奥义做突破材料，这不是太可惜了吗，您舍得吗？")))

                        SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
                        SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction
                    else
                        addFun()
                    end
                else
                    if runtimeCache.skillUpdateMaterialArray[_id][content.id] then
                        runtimeCache.skillUpdateMaterialArray[_id][content.id] = nil
                    else
                        if content.skillConf.rank >= 3 then
                            local function cardConfirmAction(  )
                                addFun()
                                local offsetY = _tableView:getContentOffset().y
                                _tableView:reloadData()
                                _tableView:setContentOffset(ccp(0, offsetY))
                                if runtimeCache.skillUpdateMaterialArray[_id] and getMyTableCount(runtimeCache.skillUpdateMaterialArray[_id]) > 0 then
                                    updataBtnState(true,true,false)
                                else
                                    updataBtnState(false,false,true)
                                end 
                            end
                            local function cardCancelAction(  )
                                
                            end
                            _layer:addChild(createSimpleConfirCardLayer(HLNSLocalizedString("船长，你选择了A级以上的奥义做突破材料，这不是太可惜了吗，您舍得吗？")))

                            SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
                            SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction
                        else
                            addFun()
                        end
                    end 
                end 
            else
                local tag = a1:getIdx()
                local content = _allSkillData[tag]
                if runtimeCache.skillUpdateMaterialArray[_id][content.id] then
                    runtimeCache.skillUpdateMaterialArray[_id][content.id] = nil
                else 
                    ShowText(HLNSLocalizedString("最多选5个奥义"))
                end
            end

            local offsetY = _tableView:getContentOffset().y
            _tableView:reloadData()
            _tableView:setContentOffset(ccp(0, offsetY))
            if runtimeCache.skillUpdateMaterialArray[_id] and getMyTableCount(runtimeCache.skillUpdateMaterialArray[_id]) > 0 then
                updataBtnState(true,true,false)
            else
                updataBtnState(false,false,true)
            end 
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

local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/BreakSkillSelectView.ccbi",proxy, true,"BreakSkillSelectLayerOwner")
    _layer = tolua.cast(node,"CCLayer")
    
end


-- 该方法名字每个文件不要重复
function getSkillBreakSelectLayer()
	return _layer
end

function createSkillBreakSelectLayer(type,dic)
    _id = type
    _skillDic = dic
    _init()

	function _layer:refresh()
		
	end

    local function _onEnter()
        sellIdArrays = {}
        selectState = {}
        selectBtnArray = {}
        if runtimeCache.skillUpdateMaterialArray[_id] and getMyTableCount(runtimeCache.skillUpdateMaterialArray[_id]) > 0 then
            updataBtnState(true,true,false)
        else
            updataBtnState(false,false,true)
        end 
        cellArray = {}
        _addTableView()
        generateCellAction( cellArray,getMyTableCount(_allSkillData) + 1 )
        cellArray = {}
    end

    local function _onExit()
        _layer = nil
        AllEquipsData = nil
        selectState = nil
        sellIdArrays = nil
        _id = nil
        _skillDic = nil
        _tableView = nil
        cellArray = {}
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