local _layer
local _tableView = nil
local _heroUId
local _equipUId
local _selectEId
local _pos

local _allEquipData
local cellArray = {}

-- ·名字不要重复
EquipChangeSelectLayerOwner = EquipChangeSelectLayerOwner or {}
ccb["EquipChangeSelectLayerOwner"] = EquipChangeSelectLayerOwner

local function changeSkillCallBack( url,rtnData )
    if rtnData["code"] == 200 then
        playEffect(MUSIC_SOUND_WEAPON_CHANGE)
        for huid,hero in pairs(rtnData["info"]) do
            for k,v in pairs(herodata.heroes) do
                if k == huid then
                    herodata.heroes[k] = hero
                end
            end
        end
        if getMainLayer() then
            getMainLayer():gotoTeam()
        end
    end
end

local function confirmBtnClicked()
    if _selectEId and _selectEId ~= _equipUId then
        doActionFun("EQUIP_CHANGE_URL", { _heroUId,_pos,_selectEId }, changeSkillCallBack)
    else
        if getMainLayer() then
            getMainLayer():gotoTeam()
        end
    end
end

EquipChangeSelectLayerOwner["confirmBtnClicked"] = confirmBtnClicked

local function _addTableView()
    -- 得到数据
    local _topLayer = EquipChangeSelectLayerOwner["EQTopLayer"]
    local myType
    if _pos == 0 then
        myType = "weapon"
    elseif _pos == 1 then
        myType = "armor"
    elseif _pos == 2 then
        myType = "belt"  
    elseif _pos == 3 then
        myType = "rune"
    end
    _allEquipData = equipdata:getCanChangeEquipByUidAndTypeAndEuid( _heroUId,myType,_equipUId )
    
    if getMyTableCount(_allEquipData) <= 0 then
        local text = HLNSLocalizedString("报告船长，您已经没有多余的装备了，去【罗格镇】买配对的箱子和钥匙可以开出极品装备噢！")
        local function cardCancelAction(  )
            
        end
        local function cardConfirmAction(  )
            _layer:removeFromParentAndCleanup(true) 
            if getMainLayer() then
                getMainLayer():goToLogue()
                getLogueTownLayer():gotoPageByType( 1 )
            end
        end
        getMainLayer():addChild(createSimpleConfirCardLayer(text), 100)
        SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
        SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction
    end
    EquipChangeSelectCellOwner = EquipChangeSelectCellOwner or {}
    ccb["EquipChangeSelectCellOwner"] = EquipChangeSelectCellOwner

    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            if a1 == 0 then
                r = CCSizeMake(winSize.width, 45 * retina)
            else
                r = CCSizeMake(winSize.width, 190 * retina)
            end
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
            local  _hbCell
            if a1 == 0 then
                _hbCell  = tolua.cast(CCBReaderLoad("ccbResources/TitleTipsLayerView.ccbi",proxy,true,"TitleTipsLayerOwner"),"CCLayer")
                local tipsLabel = tolua.cast(TitleTipsLayerOwner["tipsLabel"],"CCLabelTTF")
                tipsLabel:setString("")
            else
                local equipContent = _allEquipData[a1]
                _hbCell  = tolua.cast(CCBReaderLoad("ccbResources/EquipChangSelectCell.ccbi",proxy,true,"EquipChangeSelectCellOwner"),"CCLayer")
                
                local nameLabel = tolua.cast(EquipChangeSelectCellOwner["nameLabel"],"CCLabelTTF")
                nameLabel:setString(equipContent.equip.name)
                nameLabel:enableShadow(CCSizeMake(2,-2), 1, 0)   

                local ownerLabel = tolua.cast(EquipChangeSelectCellOwner["ownerLabel"],"CCLabelTTF")
                local owner = equipContent["owner"]
                -- local owner = equipdata:getOwnerByEUid(equipContent["id"])
                if owner then
                    ownerLabel:setString(owner.name)
                else
                    ownerLabel:setVisible(false)
                end

                local stageSprite = tolua.cast(EquipChangeSelectCellOwner["stageSprite"],"CCSprite")
                if tonumber(equipContent.stage) > 0 then
                    stageSprite:setVisible(true)
                else
                    stageSprite:setVisible(false)
                end

                local stageLabel = tolua.cast(EquipChangeSelectCellOwner["stageLabel"],"CCLabelTTF")
                stageLabel:setString(equipContent.stage..HLNSLocalizedString(" 阶"))

                -- 符文标签
                local runeSprite = tolua.cast(EquipChangeSelectCellOwner["runeSprite"], "CCSprite")
                if equipContent.equip.nature and tonumber(equipContent.equip.nature)>0 then
                    runeSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("nature_%d.png",equipContent.equip.nature)))
                    runeSprite:setVisible(true)
                else
                    runeSprite:setVisible(false)
                end

                -- 合成等级
                local composeLevel = tolua.cast(EquipChangeSelectCellOwner["composeLevel"], "CCSprite")
                if equipContent.equip.composeLevel then
                    composeLevel:setVisible(true)
                    if equipContent.equip.composeLevel == -1 then
                        composeLevel:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("m_level_max.png"))
                    elseif equipContent.equip.composeLevel == 0 then
                        composeLevel:setVisible(false)
                    else
                        composeLevel:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("m_level_%d.png",equipContent.equip.composeLevel)))
                    end
                end
                

                local cellBg = tolua.cast(EquipChangeSelectCellOwner["cellBg"],"CCSprite")
                local stampSprite = tolua.cast(EquipChangeSelectCellOwner["stampSprite"],"CCSprite")

                if _selectEId and _selectEId == equipContent.id then
                    cellBg:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("equipCellSelBg.png"))
                    stampSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("stamp3.png"))
                else
                    cellBg:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("equipCellBg.png"))
                    stampSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("stamp2.png"))
                end


                local avatarSprite = tolua.cast(EquipChangeSelectCellOwner["avatarSprite"],"CCSprite")
                if avatarSprite then
                    local texture = CCTextureCache:sharedTextureCache():addImage(equipdata:getEquipIconByEquipId( equipContent.equip.icon ))
                    if texture then
                        avatarSprite:setVisible(true)
                        avatarSprite:setTexture(texture)
                        if equipContent.equip.rank == 4 then
                            HLAddParticleScale( "images/purpleEquip.plist", avatarSprite, ccp(avatarSprite:getContentSize().width / 2,avatarSprite:getContentSize().height / 2), 1, 100, 777, 2 / 0.35 / retina, 2 / 0.35 / retina, 1 )
                        elseif equipContent.equip.rank == 5 then
                            HLAddParticleScale( "images/goldEquip.plist", avatarSprite, ccp(avatarSprite:getContentSize().width / 2,avatarSprite:getContentSize().height / 2), 1, 100, 777, 2 / 0.35 / retina, 2 / 0.35 / retina, 1 )    
                        end
                    end  
                end
                
                local avatarRankSprite = tolua.cast(EquipChangeSelectCellOwner["avatarRankSprite"],"CCSprite")
                -- avatarBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", equipContent.equip.rank)))
                -- avatarBtn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", equipContent.equip.rank)))
                avatarRankSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", equipContent.equip.rank)))

                local rankSprite = tolua.cast(EquipChangeSelectCellOwner["rankSprite"],"CCSprite")
                rankSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("rank_%d_icon.png", equipContent.equip.rank)))

                local levelLabel = tolua.cast(EquipChangeSelectCellOwner["levelLabel"],"CCLabelTTF")
                levelLabel:setString(string.format("%s",equipContent.level))

                local lvLabel = tolua.cast(EquipChangeSelectCellOwner["lvLabel"],"CCLabelTTF")
                lvLabel:setString("LV")
                lvLabel:enableShadow(CCSizeMake(2,-2), 1, 0)                
                
                local attrSprite = tolua.cast(EquipChangeSelectCellOwner["attrSprite"],"CCSprite")
                local myType
                local myAttrValue
                for key,value in pairs(equipContent.equip.initial) do
                    myType = key
                    myAttrValue = value
                end
                attrSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(equipdata:getDisplayFrameByType(myType)))
                -- local refine
                -- if equipContent.equip.refine then
                --     refine =equipContent.equip.refine
                -- else
                --     refine = 0
                -- end
                -- local finalValue = myAttrValue + (equipContent.equip.updateEffect + refine * equipContent.stage) * (equipContent.level - 1)
                local attrLabel = tolua.cast(EquipChangeSelectCellOwner["attrLabel"],"CCLabelTTF")
                attrLabel:setString(equipdata:getEquipAttrValue( equipContent.id ))

                local valueLabel = tolua.cast(EquipChangeSelectCellOwner["valueLabel"],"CCLabelTTF")
                valueLabel:setString(100)
            end
            _hbCell:setScale(retina)
            a2:addChild(_hbCell, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            _hbCell:stopAllActions()
            a2:setPosition(0, 0)
            cellArray[tostring(a1)] = _hbCell
            r = a2
        elseif fn == "numberOfCells" then
            -- Return number of cells
            -- r = 5
            r = getMyTableCount(_allEquipData) + 1
        -- Cell events:
        elseif fn == "cellTouched" then         -- A cell was touched, a1 is cell that be touched. This is not necessary.
            local equipContent = _allEquipData[a1:getIdx()]
            if _selectEId and _selectEId == equipContent.id then
                _selectEId = nil
            else
                if equipContent["owner"] then
                    ShowText(HLNSLocalizedString("%s已装备此装备", equipContent["owner"].name))
                end
                _selectEId = equipContent.id
            end
            local offsetY = _tableView:getContentOffset().y
            _tableView:reloadData()
            _tableView:setContentOffset(ccp(0, offsetY))
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
        -- print(size.width.." "..size.height)
        _tableView = LuaTableView:createWithHandler(h, size)
        _tableView:setBounceable(true)
        _tableView:setAnchorPoint(ccp(0,0))
        _tableView:setPosition(0,_mainLayer:getBottomContentSize().height)
        _tableView:setVerticalFillOrder(0)
        _layer:addChild(_tableView,1000)
    end
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/EquipChangeSeclectView.ccbi",proxy, true,"EquipChangeSelectLayerOwner")
    _layer = tolua.cast(node,"CCLayer")
    
end


-- 该方法名字每个文件不要重复
function getEquipChangeSelectLayer()
	return _layer
end

function createEquipChangeSelectLayer(heroUId,pos,equipUId)
    _heroUId = heroUId
    _pos = pos
    if equipUId then
        _equipUId = equipUId
    end
    _init()

    function _layer:confirmBtnClicked()
        confirmBtnClicked()
    end

    function _layer:selectEquip(index)
        local equipContent = _allEquipData[index]
        if _selectEId and _selectEId == equipContent.id then
            _selectEId = nil
        else
            local owner = equipdata:getOwnerByEUid(equipContent["id"])
            if owner then
                ShowText(HLNSLocalizedString("%s已装备此装备", owner.name))
            end
            _selectEId = equipContent.id
        end
        local offsetY = _tableView:getContentOffset().y
        _tableView:reloadData()
        _tableView:setContentOffset(ccp(0, offsetY))
    end

    function _layer:changeSkillCallBack( url,rtnData )
        changeSkillCallBack(url, rtnData)
    end

	function _layer:refresh()
		
	end

    local function _onEnter()
        print("onEnter") 
        cellArray = {}
        _addTableView()
        generateCellAction( cellArray,getMyTableCount(_allEquipData) + 1 )
        cellArray = {}
    end

    local function _onExit()
        print("onExit")
        _layer = nil
        _tableView = nil
        _heroUId = nil
        _pos = nil
        _equipUId = nil
        _selectEId = nil
        _allEquipData = nil
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