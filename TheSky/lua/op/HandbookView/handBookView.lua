local _layer

local RecruitBtn
local ItemBtn
local GiftBagBtn
local LogueTitleLayer
local LogueContentLayer

local _contentData
local _contentType
local _addFriendBtnState
local _tableView

local pageType

HandBookViewOwner = HandBookViewOwner or {}
ccb["HandBookViewOwner"] = HandBookViewOwner


local function setSpriteFrame( sender,bool )
    if bool then
        sender:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_1.png"))
        sender:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_1.png"))
    else
        sender:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_0.png"))
        sender:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_1.png"))
    end
end

local function _RecruitBtnAction( tag,sender )
    Global:instance():TDGAonEventAndEventData("illustrated2")
    pageType = 1
    setSpriteFrame(RecruitBtn,true)
    setSpriteFrame(ItemBtn,false)
    setSpriteFrame(GiftBagBtn,false)
    _contentData = herodata:getAllHandBookHeros()
    
    _tableView:reloadData()
end

local function _itemBtnAction(  )
    Global:instance():TDGAonEventAndEventData("illustrated3")
    pageType = 2
    setSpriteFrame(RecruitBtn,false)
    setSpriteFrame(ItemBtn,true)
    setSpriteFrame(GiftBagBtn,false)
    _contentData = equipdata:getAllHandBookEquips()
    
    _tableView:reloadData()
end

local function _GiftBagBtnAction(  )
    Global:instance():TDGAonEventAndEventData("illustrated4")
    pageType = 3
    setSpriteFrame(RecruitBtn,false)
    setSpriteFrame(ItemBtn,false)
    setSpriteFrame(GiftBagBtn,true)
    _contentData = skilldata:getAllHandBookSkills()
    _tableView:reloadData()
end

local function _payBtnAction(  )
    
end

HandBookViewOwner["_RecruitBtnAction"] = _RecruitBtnAction
HandBookViewOwner["_itemBtnAction"] = _itemBtnAction
HandBookViewOwner["_GiftBagBtnAction"] = _GiftBagBtnAction
HandBookViewOwner["_payBtnAction"] = _payBtnAction

local function heroBookBtnAction( tag,sender )
    if pageType == 1 then
        if _contentData[tag]["isOpen"] == 1 then
            if getMainLayer() then
                getMainLayer():addChild(createHeroInfoLayer(_contentData[tag].content.heroId, HeroDetail_Clicked_Handbook, -135),10)
            end
        else
            ShowText(HLNSLocalizedString("此槽里锁着是神秘的宝贝，需要您多多\n战斗和冒险才有几率得到ta哦！"))
        end
    elseif pageType == 2 then
        local content = _contentData[tag]
        if content["isOpen"] == 1 then
            local equipLayer = createEquipInfoLayer(content.equipId, 2, -135)
            getMainLayer():addChild(equipLayer)
        else
            ShowText(HLNSLocalizedString("此槽里锁着是神秘的宝贝，需要您多多\n战斗和冒险才有几率得到ta哦！"))
        end
    elseif pageType == 3 then
        local skillContent = _contentData[tag]
        if skillContent["isOpen"] == 1 then
            getMainLayer():addChild(createHandBookSkillDetailLayer(skillContent.skillId,-135)) 
        else
            ShowText(HLNSLocalizedString("此槽里锁着是神秘的宝贝，需要您多多\n战斗和冒险才有几率得到ta哦！"))
        end
    end
end


local function _addTableView()
    -- 得到数据
    _contentData = herodata:getAllHandBookHeros()
    local _topLayer = HandBookViewOwner["handBookTitleLayer"]
    local j = 1
    HandBookCellOwner = HandBookCellOwner or {}
    ccb["HandBookCellOwner"] = HandBookCellOwner

    HandBookCellOwner["heroBookBtnAction"] = heroBookBtnAction

    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(winSize.width, 160 * retina)
        elseif fn == "cellAtIndex" then
            -- Return CCTableViewCell, a1 is cell index (zero based), a2 is dequeued cell (maybe nil)
            -- Do something to create cell  and change the content
            
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            local  proxy = CCBProxy:create()
            local _hbCell 
            if pageType == 1 then
                _hbCell  = tolua.cast(CCBReaderLoad("ccbResources/HandBookCell.ccbi",proxy,true,"HandBookCellOwner"),"CCLayer")
            elseif pageType == 2 then
                _hbCell  = tolua.cast(CCBReaderLoad("ccbResources/HandBookEquipCell.ccbi",proxy,true,"HandBookCellOwner"),"CCLayer")
            elseif pageType == 3 then
                _hbCell  = tolua.cast(CCBReaderLoad("ccbResources/HandBookEquipCell.ccbi",proxy,true,"HandBookCellOwner"),"CCLayer")
            end
            for i=1,5 do
                local index = math.min(a1 * 5 + i ,getMyTableCount(_contentData))

                if a1 * 5 + i <= getMyTableCount(_contentData) then
                    local item = _contentData[a1 * 5 + i]
                    local nameLabel = tolua.cast(HandBookCellOwner[string.format("nameLabel%d",i)],"CCLabelTTF")
                    nameLabel:setString(item.content.name)

                    local rankSprite = tolua.cast(HandBookCellOwner[string.format("rankSprite%d",i)],"CCSprite")

                    local avatarBtn = tolua.cast(HandBookCellOwner[string.format("avatarBtn%d",i)],"CCMenuItemImage")
                    avatarBtn:setTag(a1 * 5 + i)
                    if item.isOpen == 0 then

                        avatarBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("frame_lock.png"))
                        avatarBtn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("frame_lock.png"))
                        nameLabel:setVisible(false)
                        rankSprite:setVisible(false)
                    else
                        avatarBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", herodata:fixRank(item.content.rank,item.wake))))
                        avatarBtn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", herodata:fixRank(item.content.rank,item.wake))))
                        
                        avatarBtn:setVisible(true)
                        if pageType == 1 then
                            local headSpr = herodata:getHeroHeadByHeroId(item.content.heroId)
                            
                            if CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(headSpr) then
                                rankSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(headSpr))
                            end
                        elseif pageType == 2 then
                            avatarBtn:setVisible(true)
                            
                            if rankSprite then
                                local texture = CCTextureCache:sharedTextureCache():addImage(equipdata:getEquipIconByEquipId( item.content.icon ))
                                if texture then
                                    rankSprite:setTexture(texture)
                                    if item.content.rank == 4 then
                                        HLAddParticleScale( "images/purpleEquip.plist", rankSprite, ccp(rankSprite:getContentSize().width / 2,rankSprite:getContentSize().height / 2), 1, 100, 777, 2 / 0.35 / retina, 2 / 0.35 / retina, 1 )
                                    elseif item.content.rank == 5 then
                                        HLAddParticleScale( "images/goldEquip.plist", rankSprite, ccp(rankSprite:getContentSize().width / 2,rankSprite:getContentSize().height / 2), 1, 100, 777, 2 / 0.35 / retina, 2 / 0.35 / retina, 1 )
                                    end
                                end  
                            end
                        elseif pageType == 3 then
                            avatarBtn:setVisible(true)
                            if rankSprite then
                                local texture = CCTextureCache:sharedTextureCache():addImage(equipdata:getEquipIconByEquipId( item.content.icon ))
                                if texture then
                                    rankSprite:setTexture(texture)
                                    if item.content.rank == 4 then
                                        HLAddParticleScale( "images/purpleEquip.plist", rankSprite, ccp(rankSprite:getContentSize().width / 2,rankSprite:getContentSize().height / 2), 1, 100, 777, 2 / 0.35 / retina, 2 / 0.35 / retina, 1 )
                                    elseif item.content.rank == 5 then
                                        HLAddParticleScale( "images/goldEquip.plist", rankSprite, ccp(rankSprite:getContentSize().width / 2,rankSprite:getContentSize().height / 2), 1, 100, 777, 2 / 0.35 / retina, 2 / 0.35 / retina, 1 )
                                    end
                                end  
                            end
                        end
                        avatarBtn:setEnabled(true)
                        nameLabel:setVisible(true)
                    end
                else
                    local nameLabel = tolua.cast(HandBookCellOwner[string.format("nameLabel%d",i)],"CCLabelTTF")
                    nameLabel:setVisible(false)
                    local rankSprite = tolua.cast(HandBookCellOwner[string.format("rankSprite%d",i)],"CCSprite")
                    rankSprite:setVisible(false)
                    local avatarBtn = tolua.cast(HandBookCellOwner[string.format("avatarBtn%d",i)],"CCMenuItemImage")
                    avatarBtn:setVisible(false)
                    avatarBtn:setEnabled(false)
                end
            end

            _hbCell:setScale(retina)
            a2:addChild(_hbCell, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            r = a2
        elseif fn == "numberOfCells" then
            if (getMyTableCount(_contentData) % 5) == 0 then
                r = math.floor(getMyTableCount(_contentData) / 5)
            else
                r = math.floor(getMyTableCount(_contentData) / 5) + 1
            end
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
    local  node  = CCBReaderLoad("ccbResources/HandBookView.ccbi",proxy, true,"HandBookViewOwner")
    _layer = tolua.cast(node,"CCLayer")
    LogueContentLayer = tolua.cast(HandBookViewOwner["HandBookContentLayer"],"CCLayer")

    RecruitBtn = tolua.cast(HandBookViewOwner["RecruitBtn"],"CCMenuItemImage")
    ItemBtn = tolua.cast(HandBookViewOwner["ItemBtn"],"CCMenuItemImage")
    GiftBagBtn = tolua.cast(HandBookViewOwner["GiftBagBtn"],"CCMenuItemImage")
    setSpriteFrame(RecruitBtn,true)
    setSpriteFrame(ItemBtn,false)
    setSpriteFrame(GiftBagBtn,false)
end

local function setMenuPriority()
    local menu = tolua.cast(HandBookViewOwner["myCCMenu"], "CCMenu")
    menu:setHandlerPriority(-139)
    print("怎么会这样")
end

function getHandBookViewLayer()
    return _layer
end

function createHandBookViewLayer()
    _init()

    -- public方法写在每个layer的创建的方法内 调用时方法
    -- local layer = getLayer()
    -- layer:refresh()

    function _layer:refresh()
        
    end

    local function _onEnter()
        -- LogueContentLayer:addChild(createRecruitViewNode())
        _contentData = herodata:getAllHandBookHeros()
        pageType = 1
        _addTableView()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
    end

    local function _onExit()
        _layer = nil
        RecruitBtn = nil
        ItemBtn = nil
        GiftBagBtn = nil
        LogueTitleLayer = nil
        LogueContentLayer = nil

        _contentData = nil
        _contentType = nil
        _addFriendBtnState = nil
        _tableView = nil
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