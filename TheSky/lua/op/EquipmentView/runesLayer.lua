local _layer
local RunesArray
local _tableView
local cellArray = {}

-- ·名字不要重复
RunesViewOwner = RunesViewOwner or {}
ccb["RunesViewOwner"] = RunesViewOwner

local function _addTableView()
    -- 得到数据
    
    local _topLayer = RunesViewOwner["titleLayer"]
    RunesArray = equipdata:getAllRunesData()
    
    EquipmentsTableCellOwner = EquipmentsTableCellOwner or {}
    ccb["EquipmentsTableCellOwner"] = EquipmentsTableCellOwner

    -- local function refineCallBack( url,rtnData )
    --     if rtnData["code"] == 200 then
    --         local equips = rtnData["info"]["equips"]
    --         for uniqueId,content in pairs(equips) do
    --             equipdata:updateEquipByUniqueId(uniqueId,content)
    --         end
    --         RunesArray = equipdata:getAllRunesData(  )
    --         _tableView:reloadData()
    --     end
    -- end

    -- local function updateCallBack( url,rtnData )
    --     if rtnData["code"] == 200 then
    --         local equips = rtnData["info"]["equips"]
    --         for uniqueId,content in pairs(equips) do
    --             equipdata:updateEquipByUniqueId(uniqueId,content)
    --         end
    --         RunesArray = equipdata:getAllRunesData(  )
    --         _tableView:reloadData()
    --     end
    -- end
    local function refineBtnTaped( tag,sender )
        local uniqueId = RunesArray[tag]["id"]

        if getMainLayer() ~= nil then
            runtimeCache.runesTableOffsetY = _tableView:getContentOffset().y
            getMainLayer():getoEquipRefineLayer(uniqueId)
        end
    end

    local function updateBtnTaped( tag,sender )
        local content = RunesArray[tag]
        if getMainLayer() ~= nil then
            runtimeCache.runesTableOffsetY = _tableView:getContentOffset().y
            getMainLayer():gotoEquipUpdateLayer(content)
        end
    end
    local function onAvatarBtnTap( tag,sender )
        local content = RunesArray[tag]
        if content then
            local equipLayer = createEquipInfoLayer(content["id"], 0, -135)
            getMainLayer():addChild(equipLayer, 10)
        end
    end

    EquipmentsTableCellOwner["onAvatarBtnTap"] = onAvatarBtnTap
    EquipmentsTableCellOwner["refineBtnTaped"] = refineBtnTaped
    EquipmentsTableCellOwner["updateBtnTaped"] = updateBtnTaped

    EquipSellCellOwner = EquipSellCellOwner or {}
    ccb["EquipSellCellOwner"] = EquipSellCellOwner

    local function onEquipSell5Click()
        print("onEquipSellClick")
        if getMainLayer() ~= nil then
            getMainLayer():gotoEquipSellLayer(EquipSellType.Rune)
        end
    end

    EquipSellCellOwner["onEquipSellClick"] = onEquipSell5Click

    local function gotoQihang(  )
        local _mainLayer = getMainLayer()
        if _mainLayer then
            _mainLayer:goToSail()
        end 
    end

    GotoQihangCellOwner = GotoQihangCellOwner or {}
    ccb["GotoQihangCellOwner"] = GotoQihangCellOwner

    GotoQihangCellOwner["gotoQihang"] = gotoQihang

    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            if a1 == getMyTableCount(RunesArray) + 1 then
                r = CCSizeMake(winSize.width, 80 * retina)
            elseif a1 == 0 then
                r = CCSizeMake(winSize.width, 100 * retina)
            else
                r = CCSizeMake(winSize.width, 190 * retina)
            end
        elseif fn == "cellAtIndex" then
            
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            --单条数据
            local equipContent = RunesArray[a1]
            local  proxy = CCBProxy:create()
            local  _hbCell 
            if a1 == 0 then
                _hbCell  = tolua.cast(CCBReaderLoad("ccbResources/EquipSellCell.ccbi",proxy,true,"EquipSellCellOwner"),"CCLayer")
                --符文页面取消开箱获得装备的提示
                -- local topLabel = tolua.cast(EquipSellCellOwner["topLabel"],"CCLabelTTF")
                -- topLabel:setString(HLNSLocalizedString("开金银沉船宝箱可以获得S、A、B级符文。"))
            else 
                _hbCell = tolua.cast(CCBReaderLoad("ccbResources/EquipmentsTableCell.ccbi",proxy,true,"EquipmentsTableCellOwner"),"CCLayer")
                local refineBtn = tolua.cast(EquipmentsTableCellOwner["refineBtn"],"CCMenuItemImage")
                refineBtn:setTag(a1)
                local updateBtn = tolua.cast(EquipmentsTableCellOwner["updateBtn"],"CCMenuItemImage")
                updateBtn:setTag(a1)

                local avatarBtn = tolua.cast(EquipmentsTableCellOwner["avatarBtn"],"CCMenuItemImage")
                avatarBtn:setTag(a1)
                --avatarSprite装备图片
                local avatarSprite = tolua.cast(EquipmentsTableCellOwner["avatarSprite"],"CCSprite")
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
                avatarBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", equipContent.equip.rank)))
                avatarBtn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", equipContent.equip.rank)))

                local nameLabel = tolua.cast(EquipmentsTableCellOwner["nameLabel"],"CCLabelTTF")
                nameLabel:setString(equipContent.equip.name)
                nameLabel:enableShadow(CCSizeMake(2,-2), 1, 0)

                local owner = equipContent["owner"]
                local ownerLabel = tolua.cast(EquipmentsTableCellOwner["ownerLabel"],"CCLabelTTF")
                if owner then
                    ownerLabel:setString(owner.name)
                else
                    ownerLabel:setVisible(false)
                end

                local stageSprite = tolua.cast(EquipmentsTableCellOwner["stageSprite"],"CCSprite")
                if tonumber(equipContent.stage) > 0 then
                    stageSprite:setVisible(true)
                else
                    stageSprite:setVisible(false)
                end

                local stageLabel = tolua.cast(EquipmentsTableCellOwner["stageLabel"],"CCLabelTTF")
                stageLabel:setString(equipContent.stage..HLNSLocalizedString(" 阶"))

                local rankSprite = tolua.cast(EquipmentsTableCellOwner["rankSprite"],"CCSprite")
                rankSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("rank_%d_icon.png", equipContent.equip.rank)))

                local levelLabel = tolua.cast(EquipmentsTableCellOwner["levelLabel"],"CCLabelTTF")
                levelLabel:setString(string.format("%s",equipContent.level))

                -- 符文标签
                local runeSprite = tolua.cast(EquipmentsTableCellOwner["runeSprite"], "CCSprite")
                if equipContent.equip.nature and tonumber(equipContent.equip.nature)>0 then
                    runeSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("nature_%d.png",equipContent.equip.nature)))
                    runeSprite:setVisible(true)
                else
                    runeSprite:setVisible(false)
                end

                -- 合成等级
                local composeLevel = tolua.cast(EquipmentsTableCellOwner["composeLevel"], "CCSprite")
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

                local lvLabel = tolua.cast(EquipmentsTableCellOwner["lvLabel"],"CCLabelTTF")
                lvLabel:setString("LV")
                lvLabel:enableShadow(CCSizeMake(2,-2), 1, 0)

                local attrSprite = tolua.cast(EquipmentsTableCellOwner["attrSprite"],"CCSprite")
                local myType
                local myAttrValue
                for key,value in pairs(equipContent.equip.initial) do
                    myType = key
                    myAttrValue = value
                end
                attrSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(equipdata:getDisplayFrameByType(myType)))
               
                local attrLabel = tolua.cast(EquipmentsTableCellOwner["attrLabel"],"CCLabelTTF")
                attrLabel:setString(string.format("+%d",equipdata:getEquipAttrValue( equipContent.id )))

                local valueLabel = tolua.cast(EquipmentsTableCellOwner["valueLabel"],"CCLabelTTF")
                valueLabel:setString(equipdata:getEquipPriceByEid( equipContent.id ))

                local refineTitle = tolua.cast(EquipmentsTableCellOwner["refineTitle"],"CCSprite")
                local updateTitle = tolua.cast(EquipmentsTableCellOwner["updateTitle"],"CCSprite")
                if equipContent.equip.rank >= 3 then
                    refineTitle:setVisible(true)
                    refineBtn:setVisible(true)
                else
                    refineTitle:setVisible(false)
                    refineBtn:setVisible(false)
                end

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
            r = getMyTableCount(RunesArray) + 1
        -- Cell events:
        elseif fn == "cellTouched" then         -- A cell was touched, a1 is cell that be touched. This is not necessary.
        elseif fn == "cellTouchBegan" then      -- A cell is touching, a1 is cell, a2 is CCTouch
        elseif fn == "cellTouchEnded" then      -- A cell was touched, a1 is cell, a2 is CCTouch
        elseif fn == "cellHighlight" then       -- A cell is highlighting, coco2d-x 2.1.3 or above
        elseif fn == "cellUnhighlight" then     -- A cell had been unhighlighted, coco2d-x 2.1.3 or above
        elseif fn == "cellWillRecycle" then     -- A cell will be recycled, coco2d-x 2.1.3 or above
        end
        return r
    end)
    local contentBg = ItemsViewOwner["contentBg"]
    local _mainLayer = getMainLayer()
    local x = 1
    if _mainLayer then

        local size = CCSizeMake(winSize.width, (winSize.height - _topLayer:getContentSize().height - _mainLayer:getBottomContentSize().height)*99/100)  -- 这里是为了在tableview上面显示一个小空出来
        print(size.width.." "..size.height)
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
    local  node  = CCBReaderLoad("ccbResources/RunesView.ccbi",proxy, true,"RunesViewOwner")
    _layer = tolua.cast(node,"CCLayer")
end


-- 该方法名字每个文件不要重复
function getRunesLayer()
	return _layer
end

function createRunesLayer()
    _init()

	function _layer:refresh()
		
	end

    local function _onEnter()
        cellArray = {}
        _addTableView()
        if runtimeCache.runesTableOffsetY then
            _tableView:setContentOffset(ccp(0, runtimeCache.runesTableOffsetY))
            runtimeCache.runesTableOffsetY = nil
        end
        generateCellAction( cellArray,getMyTableCount(RunesArray) + 2 )
        cellArray = {}
    end

    local function _onExit()
        _layer = nil
        RunesArray = nil
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