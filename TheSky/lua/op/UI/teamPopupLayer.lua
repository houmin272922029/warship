local _layer
local _uiType = 0
local _priority = -132
local _currentPage = 0
local tableView

local TeamUIType = {
    equip = 0,
    shadow = 1,
}

-- 名字不要重复
TeamPopupOwner = TeamPopupOwner or {}
ccb["TeamPopupOwner"] = TeamPopupOwner


local function closeItemClick()
    if getAdventureLayer() then
        getAdventureLayer():pageViewTouchEnabled(true)
    end
    popUpCloseAction(TeamPopupOwner, "infoBg", _layer)
    -- _layer:removeFromParentAndCleanup(true)
end
TeamPopupOwner["closeItemClick"] = closeItemClick


local function changePage(idx)
    _currentPage = idx
end

-- 新增的刷新函数 用来控制 点击相应hero头像刷新不同的页面数据
local function pressDownRefreshData(page)
    -- if _currentPage == page then
    --     return
    -- end
    TeamViewCellOwner = TeamViewCellOwner or {}
    ccb["TeamViewCellOwner"] = TeamViewCellOwner

    TeamAllViewCellOwner = TeamAllViewCellOwner or {}
    ccb["TeamAllViewCellOwner"] = TeamAllViewCellOwner

    AwakeTeamViewCellOwner = AwakeTeamViewCellOwner or {}
    ccb["AwakeTeamViewCellOwner"] = AwakeTeamViewCellOwner

    shadowViewCellOwner = shadowViewCellOwner or {}
    ccb["shadowViewCellOwner"] = shadowViewCellOwner

    _currentPage = page
    
    local content = tolua.cast(TeamPopupOwner["content"], "CCLayer")
    content:removeAllChildrenWithCleanup(true)
    local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
    cache:addSpriteFramesWithFile("ccbResources/team.plist")
    local sp = CCSprite:createWithSpriteFrameName("team_hero_bg.png")


    local inFormCount = table.getTableCount(playerBattleData.form)
    local pagesCount = inFormCount + 2 -- 后两个是总览和七星阵

    local function _updateLabel(labelStr, string, awake)    
        local label
        if _uiType == TeamUIType.equip then
            local owner = awake and AwakeTeamViewCellOwner or TeamViewCellOwner
            label = tolua.cast(owner[labelStr], "CCLabelTTF")
        else
            label = tolua.cast(shadowViewCellOwner[labelStr], "CCLabelTTF")
        end
        label:setString(string)
        label:setVisible(true)
    end

    local inFormCount = getMyTableCount(playerBattleData.form)
    
    
    
    local function huobanItemClick( tag )
        _uiType = TeamUIType.equip
        _layer:refreshLayer()
        -- pageView:moveToPage(_currentPage)
    end
    shadowViewCellOwner["huobanItemClick"] = huobanItemClick

    local function shadowItemClick(tag)
        _uiType = TeamUIType.shadow
        _layer:refreshLayer()
        -- pageView:moveToPage(_currentPage)
    end
    AwakeTeamViewCellOwner["shadowItemClick"] = shadowItemClick
    TeamViewCellOwner["shadowItemClick"] = shadowItemClick


    local function setCellMenuPriority(sender)
        if sender then
            local menu = tolua.cast(sender, "CCMenu")
            menu:setHandlerPriority(_priority - 1)
        end
    end

    local proxy = CCBProxy:create()
    local node
    local i = _currentPage + 1
    if i <= inFormCount then
        if _uiType == TeamUIType.shadow then
            node = CCBReaderLoad("ccbResources/shadowViewCell.ccbi",proxy, true,"shadowViewCellOwner")
            local huoban = tolua.cast(shadowViewCellOwner["huobanItem"], "CCMenuItem")
            huoban:setEnabled(true)
            huoban:setVisible(true)
            -- local huobanLabel = tolua.cast(shadowViewCellOwner["huobanLabel"], "CCSprite")
            -- huobanLabel:setVisible(true)

            local menu = shadowViewCellOwner["menu"]
            local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCCallFuncN:create(setCellMenuPriority))
            menu:runAction(seq)

            local heroItem = tolua.cast(shadowViewCellOwner["heroItem"], "CCMenuItem")
            heroItem:setEnabled(false)

            local hid = playerBattleData.form[tostring(i - 1)]        
            if hid then
                local hero = playerBattleData:getHero(playerBattleData.heroes[hid])
                local attr = playerBattleData:getHeroCultAttr(hid)
                local rankBg = tolua.cast(shadowViewCellOwner["rankBg"], "CCSprite")
                rankBg:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("hero_bg_%d.png", hero.rank)))
                local rankIcon = tolua.cast(shadowViewCellOwner["rankIcon"], "CCSprite")
                rankIcon:setVisible(true)
                rankIcon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("rank_%d_icon.png", hero.rank)))
                local breakLevel = tolua.cast(shadowViewCellOwner["breakLevel"],"CCSprite")
                local breakLevelFnt = tolua.cast(shadowViewCellOwner["breakLevelFnt"], "CCLabelBMFont")
                local breakValue = hero["break"]
                if breakLevel and breakValue ~= 0 then 
                    breakLevel:setVisible(true)
                    breakLevelFnt:setString(breakValue)
                end 
                _updateLabel("nameLabel", hero.name)
                _updateLabel("levelLabel", string.format("LV%d", hero.level))
                _updateLabel("priceLabel", hero.price)
                _updateLabel("hpLabel", attr.hp)
                _updateLabel("atkLabel", attr.atk)
                _updateLabel("defLabel", attr.def)
                _updateLabel("mpLabel", attr.mp)
                -- avatarSprite 
                local avatarSprite = tolua.cast(shadowViewCellOwner["avatarSprite"], "CCSprite")
                if avatarSprite then
                    local texture = CCTextureCache:sharedTextureCache():addImage(herodata:getHeroBust1ByHeroId(hero.heroId))
                    if texture then
                        avatarSprite:setVisible(true)
                        avatarSprite:setTexture(texture)
                    end  
                end 
                -- 经验
                local progressBg = tolua.cast(shadowViewCellOwner["progressBg"], "CCSprite")
                progressBg:setVisible(true)
                local progress = CCProgressTimer:create(CCSprite:create("images/bluePro.png"))
                progress:setType(kCCProgressTimerTypeBar)
                progress:setMidpoint(CCPointMake(0, 0))
                progress:setBarChangeRate(CCPointMake(1, 0))
                progress:setPosition(progressBg:getPositionX(), progressBg:getPositionY())
                progress:setScale(retina)
                progressBg:getParent():addChild(progress)
                progress:setPercentage(hero.exp_now / hero.expMax * 100)
                -- 六个影子位置
                local shadows = hero.shadows
                if not shadows then
                    shadows = {}
                end
                for i=1,6 do
                    local shadowItem = tolua.cast(shadowViewCellOwner["shadowItem"..i], "CCMenuItem")
                    shadowItem:setTag(i)
                    shadowItem:setEnabled(false)
                    
                    if not shadowData:IsShadowOpen(hero.level, i) then
                        local shadowBg = tolua.cast(shadowViewCellOwner["shadowBg"..i],"CCLayer")
                        local lock = CCSprite:createWithSpriteFrameName("shadowLock.png")
                        lock:setPosition(shadowBg:getContentSize().width / 2, shadowBg:getContentSize().height / 2)
                        shadowBg:addChild(lock)
                        shadowBg:setVisible(true)
                    else
                        local sid = shadows[tostring(i - 1)]
                        if sid then
                            local shadow = playerBattleData.shadows[sid]
                            local conf = shadowData:getOneShadowConf(shadow.shadowId)
                            local shadowBg = tolua.cast(shadowViewCellOwner["shadowBg"..i],"CCLayer")
                            if conf.icon then
                                playCustomFrameAnimation( string.format("yingzi_%s_",conf.icon),shadowBg,ccp(shadowBg:getContentSize().width / 2,shadowBg:getContentSize().height / 2),1,4,shadowData:getColorByColorRank(conf.rank) )  
                                shadowBg:setVisible(true)
                            end

                            local shadowName = tolua.cast(shadowViewCellOwner["shadowName"..i],"CCLabelTTF")
                            shadowName:setString(conf.name)
                            shadowName:setVisible(true)
                            shadowName:setColor(ccc3(255, 255, 255))
                            
                            local levelBg = tolua.cast(shadowViewCellOwner["levelBg"..i],"CCSprite")
                            levelBg:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("shadow_level_bg.png"))
                            levelBg:setVisible(true)
                             
                            local level = tolua.cast(shadowViewCellOwner["level"..i],"CCLabelTTF")
                            level:setString(shadow.level)
                            level:setVisible(true)

                            local comboLabel = tolua.cast(shadowViewCellOwner["combo"..i], "CCLabelTTF")
                            local attrArray = shadowData:getShadowAttrByLevelAndCid(shadow.level, shadow.shadowId )
                            comboLabel:setString(string.format("%s%s%s",conf.propertyName," + ", attrArray.value))
                            comboLabel:setVisible(true)
                        end
                    end
                end
                local huoban = tolua.cast(shadowViewCellOwner["huobanItem"], "CCMenuItem")
                huoban:setEnabled(true)
                huoban:setVisible(true)
                -- local huobanLabel = tolua.cast(shadowViewCellOwner["huobanLabel"], "CCSprite")
                -- huobanLabel:setVisible(true)
            else
                for i=1,6 do
                    local shadowItem = tolua.cast(shadowViewCellOwner["shadowItem"..i], "CCMenuItem")
                    shadowItem:setEnabled(false)
                end
                local body = tolua.cast(shadowViewCellOwner["bodyItem"], "CCMenuItem")
                body:setEnabled(false)
                local huoban = tolua.cast(shadowViewCellOwner["huobanItem"], "CCMenuItem")
                huoban:setEnabled(true)
                huoban:setVisible(true)
                -- local huobanLabel = tolua.cast(shadowViewCellOwner["huobanLabel"], "CCSprite")
                -- huobanLabel:setVisible(true)
            end
        else

            local bAwake = false
            --local hid = herodata.form[tostring(i - 1)] --当前玩家的上阵英雄
            local hid =playerBattleData.form[tostring(i - 1)] --被点击玩家的上阵伙伴
            -- 作当前英雄觉醒判断
            if hid then
                local heros =playerBattleData.heroes[hid] --herodata:getHero(herodata.heroes[hid])
                if heros.wake and heros.wake == 2 then
                    PrintTable(hid)
                    bAwake = true
                end
            end

            node = bAwake and CCBReaderLoad("ccbResources/AwakeTeamViewCell.ccbi",proxy, true,"AwakeTeamViewCellOwner") 
                    or CCBReaderLoad("ccbResources/TeamViewCell.ccbi",proxy, true,"TeamViewCellOwner")
            local owner = bAwake and AwakeTeamViewCellOwner or TeamViewCellOwner
            local menu = owner["menu"]
            local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCCallFuncN:create(setCellMenuPriority))
            menu:runAction(seq)
            local heroItem = tolua.cast(owner["heroItem"], "CCMenuItem")
            heroItem:setEnabled(false)
            local hid = playerBattleData.form[tostring(_currentPage)]  -- 修改
            local hero = playerBattleData:getHero(playerBattleData.heroes[hid])
            if bAwake then
                local nature = ConfigureStorage.heroConfig3[hero.heroId].nature
                local runeSprite = tolua.cast(owner["runeSprite"], "CCSprite")
                runeSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("nature_%d.png",nature)))
            end
            if hid then
                local hero = playerBattleData:getHero(playerBattleData.heroes[hid])
                local attr = playerBattleData:getHeroCultAttr(hid)
                local rankBg = tolua.cast(owner["rankBg"], "CCSprite")
                rankBg:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("hero_bg_%d.png", hero.rank)))
                local rankIcon = tolua.cast(owner["rankIcon"], "CCSprite")
                rankIcon:setVisible(true)
                rankIcon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("rank_%d_icon.png", hero.rank)))
                local breakLevel = tolua.cast(owner["breakLevel"],"CCSprite")
                local breakLevelFnt = tolua.cast(owner["breakLevelFnt"], "CCLabelBMFont")
                local breakValue = hero["break"]
                if breakLevel and breakValue ~= 0 then 
                    breakLevel:setVisible(true)
                    breakLevelFnt:setString(breakValue)
                end 
                
                _updateLabel("nameLabel", hero.name, bAwake)
                _updateLabel("levelLabel", string.format("LV%d", hero.level), bAwake)
                _updateLabel("priceLabel", hero.price, bAwake)
                _updateLabel("hpLabel", attr.hp, bAwake)
                _updateLabel("atkLabel", attr.atk, bAwake)
                _updateLabel("defLabel", attr.def, bAwake)
                _updateLabel("mpLabel", attr.mp, bAwake)
                local trainLevel = playerBattleData:getOneHeroTrainLevel( hero.id )
                local heroTrainBg = tolua.cast(owner["heroTrainBg"], "CCSprite")
                if heroTrainBg then
                    if trainLevel > 0 then
                        heroTrainBg:setVisible(true)
                        _updateLabel("heroTrainLevel", trainLevel, bAwake)
                    else
                        heroTrainBg:setVisible(false)
                    end
                end
                -- avatarSprite 
                local avatarSprite = tolua.cast(owner["avatarSprite"], "CCSprite")
                if avatarSprite then
                    local texture = CCTextureCache:sharedTextureCache():addImage(herodata:getHeroBust1ByHeroId(hero.heroId))
                    if texture then
                        avatarSprite:setVisible(true)
                        avatarSprite:setTexture(texture)
                    end  
                end 
                local combos = playerBattleData:getComboByHid(hid)
                for j,combo in ipairs(combos) do
                    if j == 7 then
                        break
                    end
                    if j == 6 and #combos > 6 then
                        local combo6 = tolua.cast(owner["combo6"], "CCLabelTTF")
                        combo6:setString("......")
                        combo6:setVerticalAlignment(kCCVerticalTextAlignmentCenter)
                        combo6:setVisible(true)
                    else
                        local comboLabel = tolua.cast(owner["combo"..j], "CCLabelTTF")
                        comboLabel:setString(combo.name)
                        comboLabel:setVisible(true)
                        if not combo.flag then
                            comboLabel:setColor(ccc3(120, 120, 120))
                        end
                        -- zhaoyanqiu,20140701:连携总是超框，如果超出宽度范围，则宽度缩小到框的宽度
                        local comboLabelWidth = comboLabel:getContentSize().width
                        local widthLimit = 110
                        if comboLabelWidth > widthLimit then
                            comboLabel:setScaleX(widthLimit / comboLabelWidth * retina)
                        end
                    end
                end
                -- 经验
                local progressBg = tolua.cast(owner["progressBg"], "CCSprite")
                progressBg:setVisible(true)
                local progress = CCProgressTimer:create(CCSprite:create("images/bluePro.png"))
                progress:setType(kCCProgressTimerTypeBar)
                progress:setMidpoint(CCPointMake(0, 0))
                progress:setBarChangeRate(CCPointMake(1, 0))
                progress:setPosition(progressBg:getPositionX(), progressBg:getPositionY())
                progress:setScale(retina)
                progressBg:getParent():addChild(progress)
                progress:setPercentage(hero.exp_now / hero.expMax * 100)
                -- 技能
                local skills = playerBattleData:getHeroSkills(hid)
                local m = bAwake and 3 or 2
                for j=0,m do
                    local dic = skills[tostring(j)]
                    local skillBg = tolua.cast(owner["skill"..(j + 1)], "CCMenuItemImage")
                    if dic then
                        local skillId = dic.skillId
                        local level = dic.level
                        local skill = skilldata:getSkill(skillId, level, hero.heroId)
                        local skillText = tolua.cast(owner["skillText"..(j + 1)], "CCSprite")
                        skillText:setVisible(false)
                        local skillName = tolua.cast(owner["skillName"..(j + 1)], "CCLabelTTF")
                        skillName:setVisible(true)
                        skillName:setString(skill.skillName)
                        skillName:setColor(ccc3(255, 255, 255))
                        skillBg:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", skill.skillRank)))
                        skillBg:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", skill.skillRank)))
                        local skillSprite = tolua.cast(owner["skillBg"..(j + 1)],"CCSprite")
                        if skillSprite then
                            local texture = CCTextureCache:sharedTextureCache():addImage(equipdata:getEquipIconByEquipId( skill.skillId ))
                            if texture then
                                skillSprite:setVisible(true)
                                skillSprite:setTexture(texture)
                            end
                        end
                        local skillLevelBg = tolua.cast(owner["skillLevelBg"..(j + 1)], "CCSprite")
                        skillLevelBg:setVisible(true)
                        skillLevelBg:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("level_bg_%d.png", skill.skillRank)))
                        local skillLevel = tolua.cast(owner["skillLevel"..(j + 1)], "CCLabelTTF")
                        skillLevel:setVisible(true)
                        skillLevel:setString(tostring(level))
                    end
                    skillBg:setEnabled(false)
                end
                -- 装备
                local equips = playerBattleData.heroes[hid].equip
                if equips then
                    local n = bAwake and 3 or 2
                    for j=0,n do
                        local eid = equips[tostring(j)]
                        local equipBtn = tolua.cast(owner["equip"..(j + 1)], "CCMenuItemImage")
                        if eid then
                            local equip = playerBattleData.equips[eid]
                            local conf = equipdata:getEquipConfig(equip.equipId)
                            local equipRank
                            if equip.advanced and equip.advanced > 0 then
                                local advanced = equip.advanced
                                if conf.rank == 3 then
                                    equipRank = ConfigureStorage.equip_blue_awave[tostring(advanced)].awaverank
                                elseif conf.rank == 4 then
                                    equipRank = ConfigureStorage.equip_pur_awave[tostring(advanced)].awaverank
                                elseif conf.rank == 5 then
                                    equipRank = ConfigureStorage.equip_gold_awave[tostring(advanced)].awaverank
                                end
                            else
                                equipRank = conf.rank
                            end
                            local equipText = tolua.cast(owner["equipText"..(j + 1)], "CCSprite")
                            equipText:setVisible(false)

                            local equipName = tolua.cast(owner["equipName"..(j + 1)], "CCLabelTTF")
                            equipName:setVisible(true)
                            equipName:setString(conf.name)
                            equipName:setColor(ccc3(255, 255, 255))
                            equipBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", equipRank)))
                            equipBtn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", equipRank)))
                            
                            local equipSprite = tolua.cast(owner["equipSprite"..j],"CCSprite")
                            if equipSprite then
                                equipSprite:setVisible(true)
                                local texture = CCTextureCache:sharedTextureCache():addImage(equipdata:getEquipIconByEquipId( conf.icon ))
                                if texture then
                                    equipSprite:setTexture(texture)
                                end
                            end
                            local equipLevelBg = tolua.cast(owner["equipLevelBg"..(j + 1)], "CCSprite")
                            equipLevelBg:setVisible(true)
                            equipLevelBg:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("level_bg_%d.png", equipRank)))
                            local equipLevel = tolua.cast(owner["equipLevel"..(j + 1)], "CCLabelTTF")
                            equipLevel:setVisible(true)
                            equipLevel:setString(tostring(equip.level))
                        end
                        equipBtn:setEnabled(false)
                    end
                end
                if playerBattleData:bOpenShadowFun() then
                    local shadow = tolua.cast(owner["shadowItem"], "CCMenuItem")
                    shadow:setVisible(true)
                    local shadowSpr = tolua.cast(owner["shadowSpr"], "CCSprite")
                    shadowSpr:setVisible(true)
                else
                    local shadow = tolua.cast(owner["shadowItem"], "CCMenuItem")
                    shadow:setVisible(false)
                    local shadowSpr = tolua.cast(owner["shadowSpr"], "CCSprite")
                    shadowSpr:setVisible(false)
                end

        -- end
            else
                local max = bAwake and 4 or 3
                for i=1,max do
                    local skill = tolua.cast(owner["skill"..i], "CCMenuItem")
                    skill:setEnabled(false)
                    local equip = tolua.cast(owner["equip"..i], "CCMenuItem")
                    equip:setEnabled(false)
                end
                local body = tolua.cast(owner["bodyItem"], "CCMenuItem")
                body:setEnabled(false)
                local shadow = tolua.cast(owner["shadowItem"], "CCMenuItem")
                shadow:setEnabled(false)
            end
        end
    elseif i == inFormCount + 1 then
        node = CCBReaderLoad("ccbResources/TeamAllViewCell.ccbi",proxy, true,"TeamAllViewCellOwner")
        local price = 0
        for j=1,table.getTableCount(playerBattleData.form) do
            local hid = playerBattleData.form[tostring(j - 1)]
            local hero = playerBattleData:getHero(playerBattleData.heroes[hid])
            local hBg = tolua.cast(TeamAllViewCellOwner["hero"..j], "CCSprite")
            local name = tolua.cast(TeamAllViewCellOwner["name"..j], "CCLabelTTF")
            local rank = tolua.cast(TeamAllViewCellOwner["rank"..j], "CCSprite")
            local level = tolua.cast(TeamAllViewCellOwner["level"..j], "CCLabelTTF")
            hBg:setVisible(true)
            name:setVisible(true)
            name:setString(hero.name)
            rank:setVisible(true)
            rank:setVisible(true)
            rank:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("rank_%d_icon.png", hero.rank)))
            level:setVisible(true)
            level:setString(string.format("LV %d", hero.level))
            price = price + hero.price
        end
        local topData= playerBattleData:getDefalutTitles()
        for i=1,getMyTableCount(topData) do
            local titleLabel = tolua.cast(TeamAllViewCellOwner["title"..i], "CCLabelTTF")
            titleLabel:setString(topData[i].conf.name)
            local shadowLayer = tolua.cast(TeamAllViewCellOwner["shadow"..i],"CCLayer")
            local frameSprite = tolua.cast(TeamAllViewCellOwner["frame"..i],"CCMenuItemImage")
            local avatarSprite = tolua.cast(TeamAllViewCellOwner["titleSprite"..i],"CCSprite")
            if topData[i].title then
                if topData[i].title.obtainFlag == 2 then
                    if topData[i].conf.expire == 24 then
                        shadowLayer:setVisible(true)
                        frameSprite:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%s.png",topData[i].conf.colorRank)))
                        frameSprite:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%s.png",topData[i].conf.colorRank)))
                        titleLabel:setString(topData[i].conf.name)
                        if avatarSprite then
                            local texture = CCTextureCache:sharedTextureCache():addImage(equipdata:getEquipIconByEquipId( topData[i].title.titleId ))
                            if texture then
                                avatarSprite:setVisible(true)
                                avatarSprite:setTexture(texture)
                            end
                        end
                    else
                        -- 显示锁的图标
                        frameSprite:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("frame_lock.png"))
                        frameSprite:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("frame_lock.png"))
                        titleLabel:setVisible(false)
                        -- frameSprite:setEnabled(false)
                    end
                else
                    -- 点亮
                    if avatarSprite then
                        local texture = CCTextureCache:sharedTextureCache():addImage(equipdata:getEquipIconByEquipId( topData[i].title.titleId ))
                        if texture then
                            avatarSprite:setVisible(true)
                            avatarSprite:setTexture(texture)
                        end
                    end
                    frameSprite:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%s.png",topData[i].conf.colorRank)))
                    frameSprite:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%s.png",topData[i].conf.colorRank)))
                    titleLabel:setString(topData[i].conf.name)
                end
            else
                frameSprite:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("frame_lock.png"))
                frameSprite:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("frame_lock.png"))
                titleLabel:setVisible(false)
            end
            
        end
        local allPrice = tolua.cast(TeamAllViewCellOwner["allPrice"], "CCLabelTTF")
        allPrice:setString(price)
        local fameLabel = tolua.cast(TeamAllViewCellOwner["fameLabel"], "CCLabelTTF")
        fameLabel:setString(playerBattleData:getAllFame())

    elseif i == inFormCount + 2 then
        node = CCBReaderLoad("ccbResources/LalaViewCell.ccbi",proxy, true,"LalaViewCellOwner")
        for j=1,7 do
            local lala = tolua.cast(LalaViewCellOwner["lala"..j], "CCMenuItemImage")
            local head = tolua.cast(LalaViewCellOwner["head"..j], "CCSprite")
            local lalaLabel = tolua.cast(LalaViewCellOwner["lalaLabel"..j], "CCSprite")
            local lalaIcon = tolua.cast(LalaViewCellOwner["lalaIcon"..j], "CCSprite")
            local lalaMenu = tolua.cast(LalaViewCellOwner["lalaMenu"..j], "CCMenuItemImage")
            lalaMenu:setOpacity(0)
            local state = playerBattleData:formSevenState(j)
            if state ~= 3 then
                lalaIcon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("lala%d_0.png", j)))
            else
                lalaIcon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("lala%d_1.png", j)))
            end
            if state == 0 then
                -- 等级未到
            elseif state == 1 then
                -- 未使用道具开启
                lala:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("lalaView.png"))
                lala:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("lalaView.png"))
            elseif state == 2 then
                -- 未上阵
                lala:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("frame_0.png"))
                lala:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("frame_0.png"))
                lalaLabel:setVisible(true)
            else
                -- 上阵
                local hid = playerBattleData:getFormSevenByIndex(j)
                local hero = playerBattleData:getHero(playerBattleData.heroes[hid])
                lala:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", hero.rank)))
                lala:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", hero.rank)))
                local f = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(herodata:getHeroHeadByHeroId(hero.heroId))
                if f then
                    head:setDisplayFrame(f)
                    head:setVisible(true)
                end
            end
            --设置啦啦队界面中剪影的Lv等级
            local lalaLable = tolua.cast(LalaViewCellOwner["lalaLable"..j], "CCLabelTTF") 
            local sevenLv = playerBattleData:getFormSevenLv(j)
            sevenLv = (sevenLv == 5) and "Max" or sevenLv
            lalaLable:setString("Lv." .. sevenLv)
            lalaLable:setColor(ccc3(255, 120, 0))
            lalaLable:setVisible(state > 1)

            -- 显示隐藏的箭头动画
            local lalaLSprite = tolua.cast(LalaViewCellOwner["lalaLSprite"..j], "CCSprite") 
            lalaLSprite:setVisible(state > 1 and playerBattleData:getFormSevenLv(j) < playerBattleData:getFormSevenUpgradeMax(j))
            if playerBattleData:getFormSevenLv(j) == 5 then
                lalaLSprite:setVisible(false)
            end
        end
        local attr = playerBattleData:getSevenFormAttr()
        local lala_atk_label = tolua.cast(LalaViewCellOwner["lala_atk_label"], "CCLabelTTF")
        if attr["atk"] then
            lala_atk_label:setString(string.format("+%d", attr["atk"]))
        else
            lala_atk_label:setString("+0")
        end

        local lala_def_label = tolua.cast(LalaViewCellOwner["lala_def_label"], "CCLabelTTF")
        if attr["def"] then
            lala_def_label:setString(string.format("+%d", attr["def"]))
        else
            lala_def_label:setString("+0")
        end

        local lala_hp_label = tolua.cast(LalaViewCellOwner["lala_hp_label"], "CCLabelTTF")
        if attr["hp"] then
            lala_hp_label:setString(string.format("+%d", attr["hp"]))
        else
            lala_hp_label:setString("+0")
        end

        local lala_mp_label = tolua.cast(LalaViewCellOwner["lala_mp_label"], "CCLabelTTF")
        if attr["mp"] then
            lala_mp_label:setString(string.format("+%d", attr["mp"]))
        else
            lala_mp_label:setString("+0")
        end

    end
    local layer = tolua.cast(node, "CCLayer")
    local scl = 0.9
    layer:setScale(scl / retina)
    layer:setAnchorPoint(ccp(0, 0))
    layer:setPosition(ccp((content:getContentSize().width - layer:getContentSize().width * scl) / 2, 
        (content:getContentSize().height - layer:getContentSize().height * scl) / 2))
    local n = CCNode:create()
    n:addChild(layer)
    content:addChild(n)
end

local function addTableView()
    if tableView then
        tableView:reloadData();
        return
    end
    -- @param fn string Callback type
    -- @param table LuaTableView
    -- @param a1 & a2 mixed Difference means for every "fn"
    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            local sp = CCSprite:createWithSpriteFrameName("frame_0.png")
            r = CCSizeMake(sp:getContentSize().width * 1.1, sp:getContentSize().height * 1.1)
        elseif fn == "cellAtIndex" then
            -- Return CCTableViewCell, a1 is cell index (zero based), a2 is dequeued cell (maybe nil)
            -- Do something to create cell and change the content
            
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            local item
            local inFormCount = getMyTableCount(playerBattleData.form)
            if a1 < inFormCount then
                -- 英雄头像
                -- local hid = herodata.form[tostring(a1)]
                local hid = playerBattleData.form[tostring(a1)]
                if hid then
                    local hero = playerBattleData:getHero(playerBattleData.heroes[hid])
                    local norSp = CCSprite:createWithSpriteFrameName(string.format("frame_%d.png", hero.rank))
                    local selSp = CCSprite:createWithSpriteFrameName(string.format("frame_%d.png", hero.rank))
                    item = CCMenuItemSprite:create(norSp, selSp)
                    local f = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(herodata:getHeroHeadByHeroId(hero.heroId))
                    if f then
                        local sp = CCSprite:createWithSpriteFrame(f)
                        item:addChild(sp, 1, 10)
                        sp:setPosition(ccp(item:getContentSize().width / 2, item:getContentSize().height / 2))
                    end
                else
                    local norSp = CCSprite:createWithSpriteFrameName("frame_0.png")
                    local selSp = CCSprite:createWithSpriteFrameName("frame_0.png")
                    item = CCMenuItemSprite:create(norSp, selSp)
                end
            elseif a1 == inFormCount then
                -- 总览
                local norSp = CCSprite:createWithSpriteFrameName("allView.png")
                local selSp = CCSprite:createWithSpriteFrameName("allView.png")
                item = CCMenuItemSprite:create(norSp, selSp)
            elseif a1 == inFormCount + 1 then
                -- 七星阵
                local norSp = CCSprite:createWithSpriteFrameName("lalaView.png")
                local selSp = CCSprite:createWithSpriteFrameName("lalaView.png")
                item = CCMenuItemSprite:create(norSp, selSp)
            else
                -- 锁住
                local norSp = CCSprite:createWithSpriteFrameName("frame_lock.png")
                local selSp = CCSprite:createWithSpriteFrameName("frame_lock.png")
                item = CCMenuItemSprite:create(norSp, selSp)
            end
            local sp = CCSprite:createWithSpriteFrameName("frame_0.png")
            item:setAnchorPoint(ccp(0, 0))
            item:setPosition(ccp(sp:getContentSize().width * 0.05, sp:getContentSize().height * 0.05))
            -- item:registerScriptTapHandler(headPressed)
            local menu = CCMenu:create()
            menu:addChild(item, 1, a1)
            menu:setPosition(ccp(0, 0))
            menu:setAnchorPoint(ccp(0, 0))
            a2:addChild(menu, 1, 10)
            if a1 == _currentPage then
                local sel = CCSprite:createWithSpriteFrameName("selFrame.png")
                item:addChild(sel, -1, 11)
                sel:setPosition(item:getContentSize().width / 2, item:getContentSize().height / 2)
            end

            r = a2
        elseif fn == "numberOfCells" then
            -- Return number of cells
            local inFormCount = getMyTableCount(playerBattleData.form)
            local count = inFormCount + 2 -- 后两个是总览和七星阵
            r = count
        -- Cell events:
        elseif fn == "cellTouched" then 
            -- A cell was touched, a1 is cell that be touched. This is not necessary.
            -- 新增一个刷新函数 ，传入相应的_currentPage
            pressDownRefreshData(a1:getIdx())
            local contentoffset = tableView:getContentOffset()
            tableView:reloadData()
            tableView:setContentOffset(contentoffset)

        elseif fn == "cellTouchBegan" then      -- A cell is touching, a1 is cell, a2 is CCTouch
        elseif fn == "cellTouchEnded" then      -- A cell was touched, a1 is cell, a2 is CCTouch
        elseif fn == "cellHighlight" then       -- A cell is highlighting, coco2d-x 2.1.3 or above
        elseif fn == "cellUnhighlight" then     -- A cell had been unhighlighted, coco2d-x 2.1.3 or above
        elseif fn == "cellWillRecycle" then     -- A cell will be recycled, coco2d-x 2.1.3 or above
        end
        return r
    end)
    local leftArrow = TeamPopupOwner["leftArrow"]
    local rightArrow = TeamPopupOwner["rightArrow"]
    local sp = CCSprite:createWithSpriteFrameName("frame_0.png")
    local contentLayer = TeamPopupOwner["contentLayer"]
    tableView = LuaTableView:createWithHandler(h, contentLayer:getContentSize())
    tableView:setBounceable(true)
    tableView:setAnchorPoint(ccp(0, 0))
    tableView:setPosition(ccp(0, 0))
    tableView:setVerticalFillOrder(0)
    tableView:setDirection(0)
    contentLayer:addChild(tableView, 10, 10)
end

local function setMenuPriority()
    local menu = tolua.cast(TeamPopupOwner["menu"], "CCMenu")
    menu:setHandlerPriority(_priority - 1)
    tableView:setTouchPriority(_priority - 2)
    -- pageView:setTouchPriority(_priority - 2)
    -- pageView:setTouchEnabled(true)
end


local function refreshTableViewOffset()
    local contentLayer = TeamPopupOwner["contentLayer"]
    local width = contentLayer:getContentSize().width
    local sp = CCSprite:createWithSpriteFrameName("frame_0.png")
    local inFormCount = getMyTableCount(playerBattleData.form)
    local count = inFormCount + 2 -- 后两个是总览和七星阵
    if inFormCount < 8 then
    end
    local x = math.min(_currentPage * sp:getContentSize().width * 1.1 , count * sp:getContentSize().width * 1.1 - width)
    
    tableView:setContentOffset(ccp(-x, 0))
end

-- 点击左边箭头
local function teamLeftBtnClick()
    local page = _currentPage - 1
    print("page" , page)
    if page < 0 then
        page = getMyTableCount(playerBattleData.form) + 1
    end 
    _currentPage = page
    pressDownRefreshData(page)
    refreshTableViewOffset()

end
TeamPopupOwner["teamLeftBtnClick"] = teamLeftBtnClick

-- 点击右边箭头
local function teamRightBtnClick()
    local page = _currentPage + 1
    if page > getMyTableCount(playerBattleData.form) + 1 then
        page = 0
    end 
    _currentPage = page
    pressDownRefreshData(page)
    refreshTableViewOffset()
end
TeamPopupOwner["teamRightBtnClick"] = teamRightBtnClick

-- 刷新UI数据
local function _refreshData()
    addTableView()
    tableView:reloadData()
    pressDownRefreshData(0)
    tableView:reloadData()
    local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCCallFunc:create(setMenuPriority))
    _layer:runAction(seq)
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/TeamPopupView.ccbi", proxy, true,"TeamPopupOwner")
    _layer = tolua.cast(node,"CCLayer")
    _refreshData()
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(TeamPopupOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        closeItemClick()
        -- _layer:removeFromParentAndCleanup(true)
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

-- 该方法名字每个文件不要重复
function getTeamPopupLayer()
    return _layer
end

function createTeamPopupLayer(priority)
    _uiType = TeamUIType.equip
    _currentPage = -1
    _priority = (priority ~= nil) and priority or -132
    _init()

    function _layer:refreshLayer()
        _refreshData()
    end

    local function _onEnter()
        print("onEnter")

        popUpUiAction(TeamPopupOwner, "infoBg")
    end

    local function _onExit()
        print("onExit")
        _layer = nil
        _priority = -132
        _uiType = TeamUIType.equip
        _currentPage = 0
        pageView = nil
        tableView = nil
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