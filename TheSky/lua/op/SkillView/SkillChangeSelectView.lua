local _layer
local _tableView = nil
local _heroUId
local _skillUId
local _pos
local _select
local cellArray = {}

-- ·名字不要重复
SkillChangeSelectLayerOwner = SkillChangeSelectLayerOwner or {}
ccb["SkillChangeSelectLayerOwner"] = SkillChangeSelectLayerOwner

local function changeSkillCallBack( url,rtnData )
    if rtnData["code"] == 200 then
        playEffect(MUSIC_SOUND_BOOK_EQUIP)
        for huid,hero in pairs(rtnData["info"]) do
            -- for pos,suid in pairs(table_name) do
            --     skilldata:changeHeroSkillByHuidAndSuid( huid,suid,pos )
            -- end
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

local function confirmBtnClicked(  )
    if _select and _select ~= _skillUId then
        doActionFun("SKILL_CHANGE_URL", { _heroUId, _pos, _select }, changeSkillCallBack)
    else
        if getMainLayer() then
            getMainLayer():gotoTeam()
        end
    end
end

SkillChangeSelectLayerOwner["confirmBtnClicked"] = confirmBtnClicked

local function _addTableView()
    -- 得到数据
    local _topLayer = SkillChangeSelectLayerOwner["EQTopLayer"]
    _allSkillData = skilldata:getCanChangeSkills( _heroUId,_skillUId )
    if getMyTableCount(_allSkillData) <= 0 then
        local text = HLNSLocalizedString("报告船长，您已经没有多余的奥义了，去【罗格镇】买配对的箱子和钥匙可以开出极品奥义噢！")
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
    local function onSelectBtnTap( tag,sender )
        local content = AllEquipsData[tag + 1]
        if selectState[tag + 1] == 0 then
            selectState[tag + 1] = 1
            sellIdArrays[content.id] = content.id
        elseif selectState[tag + 1] == 1 then
            selectState[tag+ 1] = 0
            sellIdArrays[content.id] = nil
        else
            selectState[tag + 1] = 1
            sellIdArrays[content.id] = content.id
        end
        local offsetY = _tableView:getContentOffset().y
        _tableView:reloadData()
        _tableView:setContentOffset(ccp(0, offsetY))
        if getMyTableCount(sellIdArrays) > 0 then
            updataBtnState(true,true,false)
        else
            updataBtnState(false,false,true)
        end 
    end

    SkillChangeSelectCellOwner = SkillChangeSelectCellOwner or {}
    ccb["SkillChangeSelectCellOwner"] = SkillChangeSelectCellOwner

    -- EquipSellSelectCellOwner["onSelectBtnTap"] = onSelectBtnTap
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
            -- local equipContent = AllEquipsData[a1 + 1]
            -- local uniqueId = equipContent["id"]
            -- local equipContent = equipdata:getEquip(uniqueId)
            local  proxy = CCBProxy:create()
            local  _hbCell
            if a1 == 0 then
                _hbCell  = tolua.cast(CCBReaderLoad("ccbResources/TitleTipsLayerView.ccbi",proxy,true,"TitleTipsLayerOwner"),"CCLayer")
                local tipsLabel = tolua.cast(TitleTipsLayerOwner["tipsLabel"],"CCLabelTTF")
                tipsLabel:setString("")
            else
                local skillContent = _allSkillData[a1]
                _hbCell  = tolua.cast(CCBReaderLoad("ccbResources/SkillChangeSelectCellView.ccbi",proxy,true,"SkillChangeSelectCellOwner"),"CCLayer")
                
                local nameLabel = tolua.cast(SkillChangeSelectCellOwner["nameLabel"],"CCLabelTTF")
                nameLabel:setString(skillContent.skillConf.name)
                nameLabel:enableShadow(CCSizeMake(2,-2), 1, 0)

                local frameIcon = tolua.cast(SkillChangeSelectCellOwner["frameIcon"], "CCSprite")
                frameIcon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", skillContent.skillConf.rank)))

                local icon = tolua.cast(SkillChangeSelectCellOwner["icon"], "CCSprite")
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

                local valueLabel = tolua.cast(SkillChangeSelectCellOwner["valueLabel"],"CCLabelTTF")
                valueLabel:setString(skilldata:getSkillPriceBySid(skillContent["id"]))

                local equipOnLabel = tolua.cast(SkillChangeSelectCellOwner["equipOnLabel"],"CCLabelTTF")
                local equipOwner = skilldata:getOwnerBySUid(skillContent.id)

                if equipOwner then
                    equipOnLabel:setString(equipOwner.name)
                else
                    equipOnLabel:setVisible(false)
                end

                local levelLabel = tolua.cast(SkillChangeSelectCellOwner["levelLabel"],"CCLabelTTF")
                levelLabel:setString(string.format("%s",skillContent.level))

                local lvLabel = tolua.cast(SkillChangeSelectCellOwner["lvLabel"],"CCLabelTTF")
                lvLabel:setString("LV")
                lvLabel:enableShadow(CCSizeMake(2,-2), 1, 0)
                
                local rankSprite = tolua.cast(SkillChangeSelectCellOwner["rankSprite"],"CCSprite")
                rankSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("rank_%d_icon.png", skillContent.skillConf.rank)))

                local attrSprite = tolua.cast(SkillChangeSelectCellOwner["attrSprite"],"CCSprite")
                local myType
                local myAttrValue
                for key,value in pairs(skillContent.skillConf.attr) do
                    myType = key
                end
                if equipdata:getDisplayFrameByType(myType) then
                    attrSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(equipdata:getDisplayFrameByType(myType)))
                else
                    attrSprite:setVisible(false)
                end
                local attrLabel = SkillChangeSelectCellOwner["attrLabel"]

                attrLabel:setString(skilldata:getSortDespArrtValueByUid( skillContent.id ))

                local stampSprite = tolua.cast(SkillChangeSelectCellOwner["stampSprite"],"CCSprite")
                local cellBg = tolua.cast(SkillChangeSelectCellOwner["myCellBg"],"CCSprite")
                if _select and _select == skillContent.id then
                    cellBg:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("equipCellSelBg.png"))
                    stampSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("stamp3.png"))
                else
                    cellBg:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("equipCellBg.png"))
                    stampSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("stamp2.png"))
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
            -- Return number of cells
            -- r = 5
            r = getMyTableCount(_allSkillData) + 1
        -- Cell events:
        elseif fn == "cellTouched" then         -- A cell was touched, a1 is cell that be touched. This is not necessary.
            local skillContent = _allSkillData[a1:getIdx()]
            if _select == skillContent.id then
                _select = nil
            else
                local equipOwner = skilldata:getOwnerBySUid(skillContent.id)
                if equipOwner then
                    ShowText(equipOwner.name..HLNSLocalizedString("已装备此奥义"))
                end
                _select = skillContent.id
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
    local  node  = CCBReaderLoad("ccbResources/SkillChangeSelectView.ccbi",proxy, true,"SkillChangeSelectLayerOwner")
    _layer = tolua.cast(node,"CCLayer")
    
end


-- 该方法名字每个文件不要重复
function getSkillChangeSelectLayer()
	return _layer
end

function createSkillChangeSelectLayer(heroUId,pos,skillUId)
    _heroUId = heroUId
    _pos = pos
    if skillUId then
        _skillUId = skillUId
    end
    _init()

	function _layer:refresh()
		
	end

    local function _onEnter()
        cellArray = {}
        _addTableView()
        generateCellAction( cellArray,getMyTableCount(_allSkillData) + 1 )
        cellArray = {}
    end

    local function _onExit()
        _layer = nil
        _tableView = nil
        _heroUId = nil
        _pos = nil
        _skillUId = nil
        _select = nil
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