local _layer
local _priority
local _itemArray
local _tableView
local _flag
newYearRankTouch = true

-- 名字不要重复
VipGiftDetailViewOwner = VipGiftDetailViewOwner or {}
ccb["VipGiftDetailViewOwner"] = VipGiftDetailViewOwner

local function closeItemClick(  )
   popUpCloseAction( VipGiftDetailViewOwner,"infoBg",_layer )
end

VipGiftDetailViewOwner["closeItemClick"] = closeItemClick

local function confirmBtnTaped(  )
    popUpCloseAction( VipGiftDetailViewOwner,"infoBg",_layer )
end

VipGiftDetailViewOwner["confirmBtnTaped"] = confirmBtnTaped
local function _addTableView()

    GetSomeRewardCellOwner = GetSomeRewardCellOwner or {}
    ccb["GetSomeRewardCellOwner"] = GetSomeRewardCellOwner

    GetSomeShadowCellOwner = GetSomeShadowCellOwner or {}
    ccb["GetSomeShadowCellOwner"] = GetSomeShadowCellOwner

    local containLayer = tolua.cast(VipGiftDetailViewOwner["containLayer"],"CCLayer")

    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(600, 120)
        elseif fn == "cellAtIndex" then
            -- Return CCTableViewCell, a1 is cell index (zero based), a2 is dequeued cell (maybe nil)
            -- Do something to create cell  and change the content
            
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            --单条数据
            -- local arrayContent = _itemArray[a1 + 1]
            local itemId
            local count
            local j = 1
            if _flag ~= Daily_Qingjiao then 
                for k,v in pairs(_itemArray) do
                    if j == a1 + 1 then
                        itemId = k
                        count = v
                        break  
                    end
                    j = j + 1
                end
            else
                for i=0,getMyTableCount(_itemArray) - 1 do
                    v = _itemArray[tostring(i)]
                    if j == a1 + 1 then
                        itemId = v.itemId
                        count = v.amount
                        break  
                    end
                    j = j + 1
                end
                -- for k,v in pairs(_itemArray) do
                --     if j == a1 + 1 then
                --         itemId = v.itemId
                --         count = v.amount
                --         break  
                --     end
                --     j = j + 1
                -- end
            end          
            -- if itemId == "silver" then
            --     itemId = "berry"
            -- end
            local tempContent
            local  proxy = CCBProxy:create()
            local  _hbCell 
            if havePrefix(itemId, "equip") then
                _hbCell = tolua.cast(CCBReaderLoad("ccbResources/GetSomeBigRewardCell.ccbi",proxy,true,"GetSomeRewardCellOwner"),"CCLayer")
                tempContent = equipdata:getEquip(itemId)
                local rankFrame = tolua.cast(GetSomeRewardCellOwner["rankFrame"],"CCSprite")
                local avatarSprite = tolua.cast(GetSomeRewardCellOwner["avatarSprite"],"CCSprite")
                local itemName = tolua.cast(GetSomeRewardCellOwner["itemName"],"CCLabelTTF")
                local countLabel = tolua.cast(GetSomeRewardCellOwner["countLabel"],"CCLabelTTF")

                itemName:setString(tempContent.name)
                countLabel:setString("1")
                if tempContent.icon then
                    local texture = CCTextureCache:sharedTextureCache():addImage(equipdata:getEquipIconByEquipId( tempContent.icon ))
                    if texture then
                        avatarSprite:setVisible(true)
                        avatarSprite:setTexture(texture)
                        if tempContent.rank == 4 then
                            HLAddParticleScale( "images/purpleEquip.plist", avatarSprite, ccp(avatarSprite:getContentSize().width / 2,avatarSprite:getContentSize().height / 2), 1, 100, 777, 2 / 0.35 / retina, 2 / 0.35 / retina, 1 )
                        end
                    end
                end
                rankFrame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", tempContent.rank)))
            elseif havePrefix(itemId, "title_") then
                _hbCell = tolua.cast(CCBReaderLoad("ccbResources/GetSomeBigRewardCell.ccbi",proxy,true,"GetSomeRewardCellOwner"),"CCLayer")
                tempContent = titleData:getOneTitleByTitleId( itemId )

                local rankFrame = tolua.cast(GetSomeRewardCellOwner["rankFrame"],"CCSprite")
                local avatarSprite = tolua.cast(GetSomeRewardCellOwner["avatarSprite"],"CCSprite")
                local itemName = tolua.cast(GetSomeRewardCellOwner["itemName"],"CCLabelTTF")
                local countLabel = tolua.cast(GetSomeRewardCellOwner["countLabel"],"CCLabelTTF")

                itemName:setString(tempContent.conf.name)
                countLabel:setString("1")
                if tempContent.title.id then
                    local texture = CCTextureCache:sharedTextureCache():addImage(equipdata:getEquipIconByEquipId( tempContent.title.id ))
                    if texture then
                        avatarSprite:setVisible(true)
                        avatarSprite:setTexture(texture)
                        if tempContent.conf.colorRank == 4 then
                            HLAddParticleScale( "images/purpleEquip.plist", avatarSprite, ccp(avatarSprite:getContentSize().width / 2,avatarSprite:getContentSize().height / 2), 1, 100, 777, 2 / 0.35 / retina, 2 / 0.35 / retina, 1 )
                        end
                    end
                end
                rankFrame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", tempContent.conf.colorRank)))
            elseif havePrefix(itemId, "shadow") then
                _hbCell = tolua.cast(CCBReaderLoad("ccbResources/GetSomeShadowCell.ccbi",proxy,true,"GetSomeShadowCellOwner"),"CCLayer")
                tempContent = shadowData:getOneShadowConf( itemId )

                local rankSprite = tolua.cast(GetSomeShadowCellOwner["rankLayer"],"CCLayer")
                -- local attrIcon = tolua.cast(GetSomeShadowCellOwner["attrIcon"],"CCSprite")
                local itemName = tolua.cast(GetSomeShadowCellOwner["itemName"],"CCLabelTTF")
                local levelIconTTF = tolua.cast(GetSomeShadowCellOwner["levelIconTTF"],"CCLabelTTF")
                -- local attrLabel = tolua.cast(GetSomeShadowCellOwner["attrLabel"],"CCLabelTTF")

                itemName:setString(tempContent.name)
                if tempContent.icon then
                    playCustomFrameAnimation( string.format("yingzi_%s_",tempContent.icon),rankSprite,ccp(rankSprite:getContentSize().width / 2,rankSprite:getContentSize().height / 2),1,4,shadowData:getColorByColorRank( tempContent.rank ) )
                end
                -- levelIconTTF:setString(tempContent.shadow.level)
                
                local attrLable = tolua.cast(GetSomeShadowCellOwner["attrLable"],"CCLabelTTF")
                attrLable:setString(count)

                local attSprite = tolua.cast(GetSomeShadowCellOwner["attrIcon"],"CCSprite")
                -- attSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(equipdata:getDisplayFrameByType(attrArray.type)))
                attSprite:setVisible(false) 
                local countName = tolua.cast(GetSomeShadowCellOwner["countName"],"CCLabelTTF")
                countName:setVisible(true)

            elseif havePrefix(itemId, "hero_") then
                tempContent = wareHouseData:getItemResource(itemId)
                _hbCell = tolua.cast(CCBReaderLoad("ccbResources/GetSomeRewardCell.ccbi",proxy,true,"GetSomeRewardCellOwner"),"CCLayer")
            
                local rankFrame = tolua.cast(GetSomeRewardCellOwner["rankFrame"],"CCSprite")
                local avatarSprite = tolua.cast(GetSomeRewardCellOwner["avatarSprite"],"CCSprite")
                local itemName = tolua.cast(GetSomeRewardCellOwner["itemName"],"CCLabelTTF")
                local countLabel = tolua.cast(GetSomeRewardCellOwner["countLabel"],"CCLabelTTF")

                itemName:setString(tempContent.name)
                countLabel:setString(count)

                rankFrame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", tempContent.rank)))
                avatarSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(tempContent.icon))   
            elseif havePrefix(itemId, "heroes_soul") then
                itemId = string.sub( itemId, 12, -1 )
                tempContent = wareHouseData:getItemResource(itemId)
                _hbCell = tolua.cast(CCBReaderLoad("ccbResources/GetSomeRewardCell.ccbi",proxy,true,"GetSomeRewardCellOwner"),"CCLayer")
            
                local rankFrame = tolua.cast(GetSomeRewardCellOwner["rankFrame"],"CCSprite")
                local avatarSprite = tolua.cast(GetSomeRewardCellOwner["avatarSprite"],"CCSprite")
                local itemName = tolua.cast(GetSomeRewardCellOwner["itemName"],"CCLabelTTF")
                local countLabel = tolua.cast(GetSomeRewardCellOwner["countLabel"],"CCLabelTTF")
                local soulIcon = tolua.cast(GetSomeRewardCellOwner["soulIcon"],"CCSprite")

                itemName:setString(tempContent.name)
                countLabel:setString(count)
                soulIcon:setVisible(true)

                rankFrame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", tempContent.rank)))
                if CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(tempContent.icon) then
                    avatarSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(tempContent.icon))   
                end
            elseif haveSuffix( itemId,"_shard" ) then
                print(itemId)
                _hbCell = tolua.cast(CCBReaderLoad("ccbResources/GetSomeBigRewardCell.ccbi",proxy,true,"GetSomeRewardCellOwner"),"CCLayer")
                -- local shardId = string.sub(itemId,1,-1)

                local shardConf = shardData:getShardConf( itemId )
                local rankFrame = tolua.cast(GetSomeRewardCellOwner["rankFrame"],"CCSprite")
                local avatarSprite = tolua.cast(GetSomeRewardCellOwner["avatarSprite"],"CCSprite")
                local itemName = tolua.cast(GetSomeRewardCellOwner["itemName"],"CCLabelTTF")
                local countLabel = tolua.cast(GetSomeRewardCellOwner["countLabel"],"CCLabelTTF")

                itemName:setString(shardConf.name)
                countLabel:setString(count)
                if shardConf.icon then
                    local texture = CCTextureCache:sharedTextureCache():addImage(equipdata:getEquipIconByEquipId( shardConf.icon ))
                    if texture then
                        avatarSprite:setVisible(true)
                        avatarSprite:setTexture(texture)
                        if shardConf.rank == 4 then
                            HLAddParticleScale( "images/purpleEquip.plist", avatarSprite, ccp(avatarSprite:getContentSize().width / 2,avatarSprite:getContentSize().height / 2), 1, 100, 777, 2 / 0.35 / retina, 2 / 0.35 / retina, 1 )
                        end
                    end
                end
                local chipIcon = tolua.cast(GetSomeRewardCellOwner["chipIcon"],"CCSprite")
                chipIcon:setVisible(true)
                rankFrame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", shardConf.rank)))

            else
                _hbCell = tolua.cast(CCBReaderLoad("ccbResources/GetSomeBigRewardCell.ccbi",proxy,true,"GetSomeRewardCellOwner"),"CCLayer")
                tempContent = wareHouseData:getItemResource(itemId)
                local rankFrame = tolua.cast(GetSomeRewardCellOwner["rankFrame"],"CCSprite")
                local avatarSprite = tolua.cast(GetSomeRewardCellOwner["avatarSprite"],"CCSprite")
                local itemName = tolua.cast(GetSomeRewardCellOwner["itemName"],"CCLabelTTF")
                local countLabel = tolua.cast(GetSomeRewardCellOwner["countLabel"],"CCLabelTTF")

                itemName:setString(tempContent.name)
                countLabel:setString(count)
                if tempContent.icon then
                    local texture = CCTextureCache:sharedTextureCache():addImage(tempContent.icon)
                    if texture then
                        avatarSprite:setVisible(true)
                        avatarSprite:setTexture(texture)
                        if tempContent.rank == 4 then
                            HLAddParticleScale( "images/purpleEquip.plist", avatarSprite, ccp(avatarSprite:getContentSize().width / 2,avatarSprite:getContentSize().height / 2), 1, 100, 777, 2 / 0.35 / retina, 2 / 0.35 / retina, 1 )
                        end
                    end
                end
                rankFrame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", tempContent.rank)))
            end
             

            -- _hbCell:setScale(retina)
            a2:addChild(_hbCell, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            r = a2
        elseif fn == "numberOfCells" then
            r = getMyTableCount(_itemArray)
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
    local size = CCSizeMake(containLayer:getContentSize().width, containLayer:getContentSize().height)  -- 这里是为了在tableview上面显示一个小空出来
    _tableView = LuaTableView:createWithHandler(h, size)
    _tableView:setBounceable(true)
    _tableView:setAnchorPoint(ccp(0,0))
    _tableView:setPosition(0,0)
    _tableView:setVerticalFillOrder(0)
    containLayer:addChild(_tableView,1000)
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer

    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/VipGiftDetailView.ccbi",proxy, true,"VipGiftDetailViewOwner")
    _layer = tolua.cast(node,"CCLayer")
    -- _refreshData()
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(VipGiftDetailViewOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction( VipGiftDetailViewOwner,"infoBg",_layer )
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
    local menu1 = tolua.cast(VipGiftDetailViewOwner["closeMenu"], "CCMenu")
    menu1:setHandlerPriority(_priority - 1)

    _tableView:setTouchPriority(_priority - 2)
end

-- 该方法名字每个文件不要重复
function getVipPackageDetailLayer()
	return _layer
end

function createVipPackageDetailLayer( itemsIdArray, type , priority, isNewYearRank)
    -- print("=== = = == = = = == =")
    -- PrintTable(itemsIdArray)
    -- print("_______-----______")
    _itemArray = itemsIdArray
    _flag = type
    _priority = (priority ~= nil) and priority or -132
    _init()

    local gift_label = tolua.cast(VipGiftDetailViewOwner["gift_label"], "CCLabelTTF")
    if isNewYearRank then
        gift_label:setVisible(false)
    else
        gift_label:setVisible(true)
    end

    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
        _addTableView()
        newYearRankTouch = false
        popUpUiAction( VipGiftDetailViewOwner,"infoBg" )
    end

    local function _onExit()
        newYearRankTouch = true
        _layer = nil
        _priority = -132
        _itemArray = nil
        _tableView = nil
        _flag = nil
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