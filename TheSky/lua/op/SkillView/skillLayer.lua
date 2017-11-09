local _layer
local _tableView
local skillArray
local cellArray = {}

SkillViewLayerOwner = SkillViewLayerOwner or {}
ccb["SkillViewLayerOwner"] = SkillViewLayerOwner

local function breakBtnTaped( tag,sender )
    Global:instance():TDGAonEventAndEventData("profound1")
    local skillContent = skillArray[tag]
    local _mainLayer = getMainLayer()
    if _mainLayer then
        _mainLayer:gotoBreakSkillView(skillContent)
    end
end

local function _addTableView() 
    local _topLayer = SkillViewLayerOwner["SkillTopLayer"]
    skillArray = skilldata:getAllSkills()
    -- @param fn string Callback type
    -- @param table LuaTableView
    -- @param a1 & a2 mixed Difference means for every "fn"
    SkillViewCellOwner = SkillViewCellOwner or {}
    ccb["SkillViewCellOwner"] = SkillViewCellOwner

    GotoDaMaoXianCellOwner = GotoDaMaoXianCellOwner or {}
    ccb["GotoDaMaoXianCellOwner"] = GotoDaMaoXianCellOwner
    
    TitleTipsLayerOwner = TitleTipsLayerOwner or {}
    ccb["TitleTipsLayerOwner"] = TitleTipsLayerOwner

    local function gotoDamaoxian(  )
        local _mainLayer = getMainLayer()
        if _mainLayer then
            _mainLayer:gotoAdventure()
            getAdventureLayer():moveToPage(userdata:getSkillChapterIndex())
        end 
    end

    local function onSkillTaped( tag,sender )
        local skillContent = skillArray[tag]
        getMainLayer():addChild(createSkillDetailLayer(skillContent,0,-135)) 
    end

    GotoDaMaoXianCellOwner["gotoDamaoxian"] = gotoDamaoxian
    SkillViewCellOwner["breakBtnTaped"] = breakBtnTaped
    SkillViewCellOwner["onSkillTaped"] = onSkillTaped
    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            if a1 == getMyTableCount(skillArray) + 1 then
                r = CCSizeMake(winSize.width, 80 * retina)
            elseif a1 == 0 then
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
            local  proxy = CCBProxy:create()
            local  _hbCell
            if a1 == getMyTableCount(skillArray) + 1 then
                _hbCell  = tolua.cast(CCBReaderLoad("ccbResources/GoToDaMaoXian.ccbi",proxy,true,"GotoDaMaoXianCellOwner"),"CCLayer")
            elseif a1 == 0 then
                _hbCell  = tolua.cast(CCBReaderLoad("ccbResources/TitleTipsLayerView.ccbi",proxy,true,"TitleTipsLayerOwner"),"CCLayer")
                local tipsLabel = tolua.cast(TitleTipsLayerOwner["tipsLabel"],"CCLabelTTF")
                tipsLabel:setString(HLNSLocalizedString("突破奥义，提升奥义的属性值，使伙伴变得更强。"))
            else
                _hbCell  = tolua.cast(CCBReaderLoad("ccbResources/SkillTableViewCell.ccbi",proxy,true,"SkillViewCellOwner"),"CCLayer")
                local skillContent = skillArray[a1]
                local nameLabel = SkillViewCellOwner["nameLabel"]
                nameLabel:setString(skillContent["skillConf"]["name"])
                nameLabel:enableShadow(CCSizeMake(2,-2), 1, 0)

                local itemBtn = tolua.cast(SkillViewCellOwner["itemBtn"],"CCMenuItemImage")
                itemBtn:setTag(a1)
                
                local levelLabel = SkillViewCellOwner["levelLabel"]
                levelLabel:setString(string.format("%d",skillContent["level"]))

                local lvLabel = tolua.cast(SkillViewCellOwner["lvLabel"],"CCLabelTTF")
                lvLabel:setString("LV")
                lvLabel:enableShadow(CCSizeMake(2,-2), 1, 0)
                
                local ownerLabel = SkillViewCellOwner["ownerLabel"]
                if skillContent["owner"] then
                    ownerLabel:setString(skillContent["owner"].name)
                else
                    ownerLabel:setVisible(false)
                end

                local refineBtn = tolua.cast(SkillViewCellOwner["refineBtn"],"CCMenuItemImage")
                refineBtn:setTag(a1)

                local valueLabel = tolua.cast(SkillViewCellOwner["valueLabel"],"CCLabelTTF")
                valueLabel:setString(skilldata:getSkillPriceBySid(skillContent["id"]))
                
                local itemBtn = tolua.cast(SkillViewCellOwner["itemBtn"], "CCMenuItemImage")
                itemBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", skillContent.skillConf.rank)))
                itemBtn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", skillContent.skillConf.rank)))

                local icon = tolua.cast(SkillViewCellOwner["icon"], "CCSprite")
                local res = wareHouseData:getItemResource(skillContent.skillId)
                if res.icon then
                    local texture = CCTextureCache:sharedTextureCache():addImage(res.icon)
                    if texture then
                        icon:setVisible(true)
                        icon:setTexture(texture)
                        if skillContent.skillConf.rank == 4 then
                            HLAddParticleScale( "images/purpleEquip.plist", icon, ccp(icon:getContentSize().width / 2,icon:getContentSize().height / 2), 1, 100, 777, 2 / 0.35 / retina, 2 / 0.35 / retina, 1 )
                        elseif skillContent.skillConf.rank == 5 then
                            HLAddParticleScale( "images/goldEquip.plist", icon, ccp(icon:getContentSize().width / 2,icon:getContentSize().height / 2), 1, 100, 777, 2 / 0.35 / retina, 2 / 0.35 / retina, 1 )
                        end
                    end
                end

                local rankSprite = tolua.cast(SkillViewCellOwner["rankSprite"],"CCSprite")
                rankSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("rank_%d_icon.png", skillContent.skillConf.rank)))
                
                local attrSprite = tolua.cast(SkillViewCellOwner["attrSprite"],"CCSprite")
                local myType
                for key,value in pairs(skillContent.attr) do
                    myType = key
                end
                if equipdata:getDisplayFrameByType(myType) then
                    attrSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(equipdata:getDisplayFrameByType(myType)))
                else
                    attrSprite:setVisible(false)
                end
                local attrLabel = SkillViewCellOwner["attrLabel"]
                attrLabel:setString(skilldata:getSortDespArrtValueByUid( skillContent.id ))
            end
            _hbCell:setScale(retina)
            a2:addChild(_hbCell, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            
            _hbCell:stopAllActions()
            cellArray[tostring(a1)] = _hbCell
            r = a2
        elseif fn == "numberOfCells" then
            r = getMyTableCount(skillArray) + 2
        elseif fn == "cellTouched" then         -- A cell was touched, a1 is cell that be touched. This is not necessary.
            -- print("cellTouched",a1:getIdx())
        elseif fn == "cellTouchBegan" then      -- A cell is touching, a1 is cell, a2 is CCTouch
        elseif fn == "cellTouchEnded" then      -- A cell was touched, a1 is cell, a2 is CCTouch
        elseif fn == "cellHighlight" then       -- A cell is highlighting, coco2d-x 2.1.3 or above
        elseif fn == "cellUnhighlight" then     -- A cell had been unhighlighted, coco2d-x 2.1.3 or above
        elseif fn == "cellWillRecycle" then     -- A cell will be recycled, coco2d-x 2.1.3 or above
        end
        return r
    end)
    
    local _mainLayer = getMainLayer()
    if _mainLayer then
        local size = CCSizeMake(winSize.width, (winSize.height - _topLayer:getContentSize().height - _mainLayer:getBottomContentSize().height)*99/100)      -- 这里是为了在tableview上面显示一个小空出来
        _tableView = LuaTableView:createWithHandler(h, size)
        _tableView:setBounceable(true)
        _tableView:setAnchorPoint(ccp(0,0))
        _tableView:setPosition(ccp(0, _mainLayer:getBottomContentSize().height))
        _tableView:setVerticalFillOrder(0)
        _layer:addChild(_tableView)
        if runtimeCache.skillViewOffSetY then
            _tableView:setContentOffset(ccp(0, runtimeCache.skillViewOffSetY))
        end
    end
end

local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/SkillView.ccbi",proxy, true,"SkillViewLayerOwner")
    _layer = tolua.cast(node,"CCLayer")
end


function getSkillLayer()
	return _layer
end

function createSkillLayer()
    _init()


    local function _onEnter()
        cellArray = {}
        _addTableView()
        
        generateCellAction( cellArray,getMyTableCount(skillArray) + 2 )
        cellArray = {}
    end

    local function _onExit()
        _layer = nil
        skillArray = nil
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