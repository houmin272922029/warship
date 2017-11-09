local _layer
local _currentPage = 0
local pageView
local tableView
local _shadowInfo = {}


local _wAni = false

-- ·名字不要重复
TeamViewOwner = TeamViewOwner or {}
ccb["TeamViewOwner"] = TeamViewOwner


local function formItemClick(tag)
    getMainLayer():addChild(createChangeTeamLayer())
end
TeamViewOwner["formItemClick"] = formItemClick

LalaViewCellOwner = LalaViewCellOwner or {}
ccb["LalaViewCellOwner"] = LalaViewCellOwner

local function openSevenFormCallback( url, rtnData )
    herodata.sevenForm = rtnData.info.form_seven
    _layer:refreshTeamLayer()
    _wAni = true
    pageView:moveToPage(_currentPage)
    _wAni = false
end

local function needItemConfirmClick()
    if not getMainLayer() then
        CCDirector:sharedDirector():replaceScene(mainSceneFun())
    end
    runtimeCache.dailyPageNum = Daily_Worship
    getMainLayer():gotoDaily()
    -- getDailyLayer():gotoDailyByName( Daily_Worship )
    -- local page = dailyData:getDailyPage(Daily_Worship)
    -- runtimeCache.gotoDailyPage = page
    -- getMainLayer():gotoDaily()
end

local function cardCancelAction()
    
end

local function cardConfirmAction()
    if not userdata:formSevenCanOpen(runtimeCache.sevenFormPosition + 1) then
        ShowText(HLNSLocalizedString("lala.open.last"))
    else
        if wareHouseData:getItemCount(ConfigureStorage.openFormSevenItem.itemId) >= ConfigureStorage.openFormSevenItem.amount then
            doActionFun("OPEN_FORM_SEVEN", {runtimeCache.sevenFormPosition}, openSevenFormCallback)
        else
            local name = wareHouseData:getItemConfig(ConfigureStorage.openFormSevenItem.itemId).name
            local text = HLNSLocalizedString("lala.item.need", name, name)
            CCDirector:sharedDirector():getRunningScene():addChild(createSimpleConfirCardLayer(text))
            SimpleConfirmCard.confirmMenuCallBackFun = needItemConfirmClick
            SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction
        end
    end
end


local function lalaItemClick(tag)
    print("lalaItemClick", tag)
    local state = userdata:formSevenState(tag)
    if state == 0 then
        ShowText(HLNSLocalizedString("lala.lock.tip", userdata:getNextFormSevenMax()))
    elseif state == 1 then
        runtimeCache.sevenFormPosition = tag - 1
        if not userdata:formSevenCanOpen(tag) then
            ShowText(HLNSLocalizedString("lala.open.last"))
            return
        end
        local text = HLNSLocalizedString("lala.useItem.open", wareHouseData:getItemConfig(ConfigureStorage.openFormSevenItem.itemId).name)
        _layer:addChild(createSimpleConfirCardLayer(text))
        SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
        SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction
    elseif state == 2 then
        runtimeCache.teamPage = _currentPage
        runtimeCache.isSevenForm = true
        runtimeCache.sevenFormPosition = tag - 1
        getMainLayer():gotoOnForm()
    else
        runtimeCache.teamPage = _currentPage
        runtimeCache.isSevenForm = true
        runtimeCache.sevenFormPosition = tag - 1
        getMainLayer():addChild(createHeroInfoLayer(userdata:getFormSevenByIndex(tag), HeroDetail_Clicked_Team, -135))
    end
end
LalaViewCellOwner["lalaItemClick"] = lalaItemClick

local function headPressed(tag)
    local inFormCount = userdata:getFormMax()
    if tag < inFormCount + 2 then
        pageView:moveToPage(tag)
    else
        ShowText(HLNSLocalizedString("team.lock.next", userdata:getNextFormMax()))
    end
end

local function addTableView()
    -- @param fn string Callback type
    -- @param table LuaTableView
    -- @param a1 & a2 mixed Difference means for every "fn"
    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            local sp = CCSprite:createWithSpriteFrameName("frame_0.png")
            r = CCSizeMake(sp:getContentSize().width * retina * 1.1, sp:getContentSize().height * retina * 1.1)
        elseif fn == "cellAtIndex" then
            -- Return CCTableViewCell, a1 is cell index (zero based), a2 is dequeued cell (maybe nil)
            -- Do something to create cell and change the content
            
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            local item
            local inFormCount = userdata:getFormMax()
            if a1 < inFormCount then
                -- 英雄头像
                local hid = herodata.form[tostring(a1)]
                if hid then
                    local hero = herodata:getHero(herodata.heroes[hid])
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
            item:setPosition(ccp(sp:getContentSize().width * 0.05 * retina, sp:getContentSize().height * 0.05 * retina))
            item:registerScriptTapHandler(headPressed)
            menu = CCMenu:create()
            menu:addChild(item, 1, a1)
            menu:setPosition(ccp(0, 0))
            menu:setAnchorPoint(ccp(0, 0))
            menu:setScale(retina)
            a2:addChild(menu, 1, 10)
            if a1 == _currentPage then
                local sel = CCSprite:createWithSpriteFrameName("selFrame.png")
                item:addChild(sel, -1, 11)
                sel:setPosition(item:getContentSize().width / 2, item:getContentSize().height / 2)
            end

            r = a2
        elseif fn == "numberOfCells" then
            -- Return number of cells
            local inFormCount = userdata:getFormMax()
            local count = inFormCount + 2 -- 后两个是总览和七星阵
            if inFormCount < 8 then
                count = count + 1 -- 加一个提示锁住的
            end
            r = count
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
    local leftArrow = TeamViewOwner["leftArrow"]
    local rightArrow = TeamViewOwner["rightArrow"]
    local sp = CCSprite:createWithSpriteFrameName("frame_0.png")
    local contentLayer = TeamViewOwner["contentLayer"]
    local size = CCSizeMake((rightArrow:getPositionX() - leftArrow:getPositionX() - leftArrow:getContentSize().width * 2 * retina), sp:getContentSize().height * retina * 1.1)
    tableView = LuaTableView:createWithHandler(h, size)
    tableView:setBounceable(true)
    tableView:setAnchorPoint(ccp(0, 0))
    tableView:setPosition(ccp((leftArrow:getPositionX() + leftArrow:getContentSize().width * retina), winSize.height - sp:getContentSize().height * retina * 0.55))
    tableView:setVerticalFillOrder(0)
    tableView:setDirection(0)
    contentLayer:addChild(tableView, 10, 10)
end

local function _addSelFrame()
    print("_addSelFrame", _currentPage)
    local cell = tableView:cellAtIndex(_currentPage)
    if cell then
        local item = tolua.cast(cell:getChildByTag(10):getChildByTag(_currentPage), "CCMenuItemImage")
        if not item:getChildByTag(11) then
            local sel = CCSprite:createWithSpriteFrameName("selFrame.png")
            item:addChild(sel, -1, 11)
            sel:setPosition(item:getContentSize().width / 2, item:getContentSize().height / 2)
        end
    end    
end

local function refreshTableViewOffset()
    local leftArrow = TeamViewOwner["leftArrow"]
    local rightArrow = TeamViewOwner["rightArrow"]
    local width = rightArrow:getPositionX() - leftArrow:getPositionX() - leftArrow:getContentSize().width * 2 * retina
    local sp = CCSprite:createWithSpriteFrameName("frame_0.png")
    local inFormCount = userdata:getFormMax()
    local count = inFormCount + 2 -- 后两个是总览和七星阵
    if inFormCount < 8 then
    end
    if tableView:getContentOffset().x >= -_currentPage * sp:getContentSize().width * 1.1 * retina 
        and tableView:getContentOffset().x < (width - _currentPage * sp:getContentSize().width * 1.1 * retina) then
        -- 如果需要显示的大关cell在显示区域中
        _addSelFrame()
        return
    end

    local x = math.min(_currentPage * sp:getContentSize().width * 1.1 * retina, count * sp:getContentSize().width * 1.1 * retina - width)
    if _wAni then
        tableView:setContentOffset(ccp(-x, 0))
    else
        tableView:setContentOffsetInDuration(ccp(-x, 0), 0.2)
    end
    _layer:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCCallFunc:create(_addSelFrame)))
end

local function changePage(idx)
    local cell = tableView:cellAtIndex(_currentPage)
    if cell then
        local item = tolua.cast(cell:getChildByTag(10):getChildByTag(_currentPage), "CCMenuItemImage")
        if item:getChildByTag(11) then 
            item:removeChildByTag(11, true)
        end
    end
    _currentPage = idx
    runtimeCache.teamPage = idx
    refreshTableViewOffset()
end

local function addPageView()
    local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
    cache:addSpriteFramesWithFile("ccbResources/team.plist")
    local sp = CCSprite:createWithSpriteFrameName("team_hero_bg.png")
    local topBg = TeamViewOwner["teamTopBg"]

    --  pageview滴创建需要3个参数，第一个ccrect用来设置触摸区域，第二个ccsize，用来设置中间的显示区域，如果只需要显示单页，设置为和第一个参数相同，第三个参数是floot，用来设置缩放比率，当小于等于1滴时候可以缩放，大于1滴时候不能缩放
    pageView = PageView:create(
                                CCRect(0, 0, winSize.width, sp:getContentSize().height * retina),
                                CCSizeMake(winSize.width, sp:getContentSize().height * retina), 
                                2
                            )
    local _mainLayer = getMainLayer()
    local y = (winSize.height - _mainLayer:getBroadCastContentSize().height + _mainLayer:getBottomContentSize().height -
     topBg:getContentSize().height * retina - sp:getContentSize().height * retina) / 2
    pageView:setPosition(0, y)
    pageView:setAnchorPoint(ccp(0, 0))
    pageView:registerScriptHandler(changePage)
    
    local inFormCount = userdata:getFormMax()
    print("inFormCount", inFormCount)
    local pagesCount = inFormCount + 2 -- 后两个是总览和七星阵

        -- 显示伙伴属性信息
    local function _updateLabel(labelStr, string, awake)
        local label
        if runtimeCache.teamState == 0 then
            local owner = awake and AwakeTeamViewCellOwner or TeamViewCellOwner
            label = tolua.cast(owner[labelStr], "CCLabelTTF")
        elseif runtimeCache.teamState == 1 then
            label = tolua.cast(shadowViewCellOwner[labelStr], "CCLabelTTF")
        end
        label:setString(string)
        label:setVisible(true)
    end

    for i = 1, pagesCount do


        TeamViewCellOwner = TeamViewCellOwner or {}
        ccb["TeamViewCellOwner"] = TeamViewCellOwner

        AwakeTeamViewCellOwner = AwakeTeamViewCellOwner or {}
        ccb["AwakeTeamViewCellOwner"] = AwakeTeamViewCellOwner

        TeamAllViewCellOwner = TeamAllViewCellOwner or {}
        ccb["TeamAllViewCellOwner"] = TeamAllViewCellOwner

        shadowViewCellOwner = shadowViewCellOwner or {}
        ccb["shadowViewCellOwner"] = shadowViewCellOwner

        local function huobanItemClick( tag )
            -- body
            print("huobanItemClick ----- ",tag)
            runtimeCache.teamState = 2
            _layer:refreshTeamLayer()
            pageView:moveToPage(_currentPage)
        end
        
        shadowViewCellOwner["huobanItemClick"] = huobanItemClick

        -- 某位置是否有影子，获取其信息
        local function getPosShadowInfo( info ,tag )
            -- body
            if info and getMyTableCount(info) > 0 then
                for j=1,getMyTableCount(info) do
                    if info[j].pos and tonumber(info[j].pos) + 1 == tag then
                        return info[j]
                    end
                end
                return nil 
            else
                return nil
            end
        end

        local function realShadowItemClick( tag )
            -- body
            local hid = herodata.form[tostring(_currentPage)]
            local info = shadowData:getShadowConfByHid( hid )
            local hero = herodata:getHero(herodata.heroes[hid])
            -- PrintTable(info)
            if not shadowData:IsShadowOpen(hero.level, tag) then
                ShowText(HLNSLocalizedString("shadow.levelnotenough",shadowData:getShadowLevelByIndex(tag)))
            else
                if getPosShadowInfo(info ,tag) then
                    getMainLayer():getParent():addChild(createShadowPopupLayer(getPosShadowInfo(info ,tag), hid, tag-1, -132),100)
                else
                    getMainLayer():gotoChangeShadowLayer(hid, tag-1)
                end
            end
        end

        shadowViewCellOwner["shadowItemClick"] = realShadowItemClick
--------------------------- 阵容的方法 ---------------------------
        local function skillItemClick(tag)
                      
            print("page = ".._currentPage, "skill = "..tag)
            Global:instance():TDGAonEventAndEventData("profound")
            if tag > 1 then
                --可跟换奥义
                local hid = herodata.form[tostring(_currentPage)]
                local skills = skilldata:getHeroSkills(hid)
                local dic = skills[tostring(tag - 1)]
                
                print("tag-------------",tag)
                if dic then
                    local skillContent = skilldata:getEquipedSkillByDic( dic )
                    getMainLayer():addChild(createSkillDetailCanChangeLayer(skillContent, hid, tag - 1, -135))
                else
                    --前往技能选择界面
                    if getMainLayer then
                        getMainLayer():getoSkillChangeSelectView(hid, tag - 1)
                    end
                end
            else
                --不可更换奥义
                local hid = herodata.form[tostring(_currentPage)]
                local skills = skilldata:getHeroSkills(hid)
                local dic = skills[tostring(tag - 1)]
                if dic then
                    local skillContent = skilldata:getEquipedSkillByDic( dic )
                    getMainLayer():addChild(createSkillDetailLayer(skillContent,0, -135)) 
                    runtimeCache.breakSkillType = 1
                end
            end
        end

        AwakeTeamViewCellOwner["skillItemClick"] = skillItemClick
        TeamViewCellOwner["skillItemClick"] = skillItemClick

        local function equipItemClick(tag)

            print("page = ".._currentPage, "equip = "..tag)
            local hid = herodata.form[tostring(_currentPage)]
            if hid then
                local equips = equipdata:getHeroEquips(hid)
                local dic = equips[tostring(tag - 1)]
                if dic then
                    local array = {}
                    array["heroUid"] = hid
                    array["pos"] = tag - 1
                    local equipLayer = createEquipInfoLayer(dic["id"], 1, -135,array)
                    getMainLayer():addChild(equipLayer, 10)
                else
                    --进入武器选择页面
                    if getMainLayer then
                        getMainLayer():getoEquipChangeSelectView(hid,tag - 1)
                    end
                end
            end
        end
        AwakeTeamViewCellOwner["equipItemClick"] = equipItemClick
        TeamViewCellOwner["equipItemClick"] = equipItemClick

        local function bodyItemClick(tag)
            print("page = ".._currentPage, "body click")
        end
        AwakeTeamViewCellOwner["bodyItemClick"] = bodyItemClick
        TeamViewCellOwner["bodyItemClick"] = bodyItemClick
        shadowViewCellOwner["bodyItemClick"] = bodyItemClick

        local function shadowItemClick(tag)
            print("page = ".._currentPage, "shadow click = ")
            runtimeCache.teamState = 1
            _layer:refreshTeamLayer()
            pageView:moveToPage(_currentPage)
            -- getMainLayer():getParent():addChild(createShadowPopupLayer(),100)
        end
        AwakeTeamViewCellOwner["shadowItemClick"] = shadowItemClick
        TeamViewCellOwner["shadowItemClick"] = shadowItemClick

        local function heroItemClick(tag)
            print("heroItemClick")
            local hid = herodata.form[tostring(_currentPage)]
            if hid then
                -- 显示英雄信息
                runtimeCache.teamPage = _currentPage
                getMainLayer():addChild(createHeroInfoLayer(hid, HeroDetail_Clicked_Team, -135), 100)
            else
                -- 上阵
                runtimeCache.teamPage = _currentPage
                getMainLayer():gotoOnForm()
            end
        end
        AwakeTeamViewCellOwner["heroItemClick"] = heroItemClick
        TeamViewCellOwner["heroItemClick"] = heroItemClick
        shadowViewCellOwner["heroItemClick"] = heroItemClick

        local function titleItemClick(tag)
            local titlesArray= titleData:getDefalutTitles()
            local finalArr = titlesArray[tonumber(tag)]
            if finalArr.title.obtainFlag == 2 then
                if finalArr.conf.expire == 24 then
                    -- 变暗的图标
                    ShowText(HLNSLocalizedString("您的航海经历还不够丰富，多去冒险\n战斗，会有意外成就收获噢！"))
                else
                    -- 显示锁的图标
                    ShowText(HLNSLocalizedString("您的航海经历还不够丰富，多去冒险\n战斗，会有意外成就收获噢！"))
                end
            else
                -- 点亮的图标
                if getTitleInfoLayer() then
                    getTitleInfoLayer():removeFromParentAndCleanup(true)
                end
                CCDirector:sharedDirector():getRunningScene():addChild(createTitleInfoLayer( finalArr["title"]["id"],0,-142),130) 
            end
        end
        TeamAllViewCellOwner["titleItemClick"] = titleItemClick

        local function allTitleItemClick(tag)
            print("allTitleItemClick")
            CCDirector:sharedDirector():getRunningScene():addChild(createAllTitleInfoLayer(-142),130)
        end
        TeamAllViewCellOwner["allTitleItemClick"] = allTitleItemClick

        local function lalaIconClick(tag)

            --userdata:formSevenCanUpgrade(tag) and userdata:getFormSevenUpgradeMax(tag) > 0 
            local state = userdata:formSevenState(tag)
            if state > 1 then     -- 判断是否可以升级
                _layer:addChild(createLaLaViewUpdataLayer(tag , -134))
            else
                local conf = ConfigureStorage.formSevenAttr[tag]
                local text = HLNSLocalizedString("lalaIcon.tips", conf.name, HLNSLocalizedString(conf.attr), HLNSLocalizedString(conf.attr))
                _layer:addChild(createSimpleConfirCardLayer(text), 100)
                SimpleConfirmCard.confirmMenuCallBackFun = nil
                SimpleConfirmCard.cancelMenuCallBackFun = nil
            end
        end
        LalaViewCellOwner["lalaIconClick"] = lalaIconClick
        -----------  方法^ ----------- 代码v ------

        local proxy = CCBProxy:create()
        local node
        -- inFormCount 0表示伙伴 1表示影子 2表示训练
        if i <= inFormCount then
            if runtimeCache.teamState == 1 then
                -- print("------ 影子 ------",isShadow)
                if i <= inFormCount then
                    node = CCBReaderLoad("ccbResources/shadowViewCell.ccbi",proxy, true,"shadowViewCellOwner")
                    local hid = herodata.form[tostring(i - 1)]        
                    if hid then
                        local hero = herodata:getHero(herodata.heroes[hid])
                        local attr = herodata:getHeroAttrsByHeroUId(hid)
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
                        for i=1,6 do
                            local shadowItem = tolua.cast(shadowViewCellOwner["shadowItem"..i], "CCMenuItem")
                            shadowItem:setTag(i)
                            
                            if not shadowData:IsShadowOpen(hero.level, i) then
                                local shadowBg = tolua.cast(shadowViewCellOwner["shadowBg"..i],"CCLayer")
                                local lock = CCSprite:createWithSpriteFrameName("shadowLock.png")
                                lock:setPosition(shadowBg:getContentSize().width / 2, shadowBg:getContentSize().height / 2)
                                shadowBg:addChild(lock)
                                shadowBg:setVisible(true)
                            else
                                local sid = shadows[tostring(i - 1)]
                                if sid then
                                    local shadow = shadowData.allShadows[sid]
                                    local conf = shadowData:getOneShadowConf(shadow.shadowId)
                                    local shadowBg = tolua.cast(shadowViewCellOwner["shadowBg"..i],"CCLayer")
                                    if conf.icon then
                                        playCustomFrameAnimation( string.format("yingzi_%s_",conf.icon),shadowBg,ccp(shadowBg:getContentSize().width / 2,shadowBg:getContentSize().height / 2),1,4,shadowData:getColorByColorRank(conf.rank) )  
                                        shadowBg:setVisible(true)
                                    end

                                    local shadowName = tolua.cast(shadowViewCellOwner["shadowName"..i],"CCLabelTTF")
                                    shadowName:setString(conf.name)
                                    shadowName:setVisible(true)
                                    
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
                    end
                end
            elseif runtimeCache.teamState == 2 then
                local hid = herodata.form[tostring(i - 1)]
                node = createHakiCell(hid)
            else
                -- 0 伙伴页面 

                local bAwake = false
                print("觉醒判断 上阵伙伴",i)
                local hid = herodata.form[tostring(i - 1)] --上阵的英雄
                -- 作当前英雄觉醒判断
                if hid then
                    local heros = herodata:getHero(herodata.heroes[hid])
                    if heros.wake and heros.wake == 2 then
                        PrintTable(hid)
                        bAwake = true
                    end
                end
                
                node = bAwake and CCBReaderLoad("ccbResources/AwakeTeamViewCell.ccbi",proxy, true,"AwakeTeamViewCellOwner") 
                    or CCBReaderLoad("ccbResources/TeamViewCell.ccbi",proxy, true,"TeamViewCellOwner")
                local owner = bAwake and AwakeTeamViewCellOwner or TeamViewCellOwner
                
                if hid then
                    local hero = herodata:getHero(herodata.heroes[hid])
                    local attr = herodata:getHeroAttrsByHeroUId(hid)
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
                    if hero.rank == 5 then
                        local nature = ConfigureStorage.heroConfig3[hero.heroId].nature
                        local runeSprite = tolua.cast(owner["runeSprite"], "CCSprite")
                        runeSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("nature_%d.png",nature)))
                    end

                    _updateLabel("nameLabel", hero.name, bAwake)
                    _updateLabel("levelLabel", string.format("LV%d", hero.level), bAwake)
                    _updateLabel("priceLabel", hero.price, bAwake)
                    _updateLabel("hpLabel", attr.hp, bAwake)
                    _updateLabel("atkLabel", attr.atk, bAwake)
                    _updateLabel("defLabel", attr.def, bAwake)
                    _updateLabel("mpLabel", attr.mp, bAwake)
                    local trainLevel = herodata:getOneHeroTrainLevel( hero.id )
                    local heroTrainBg = tolua.cast(owner["heroTrainBg"], "CCSprite")
                    if heroTrainBg then
                        if trainLevel > 0 then
                            heroTrainBg:setVisible(true)
                            _updateLabel("heroTrainLevel", herodata:getOneHeroTrainLevel(hero.id), bAwake)
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
                    local combos = herodata:getComboByHid(hid)
                    
                    for j,combo in ipairs(combos) do
                        if j == 7 then
                            break
                        end
                        if j == 6 and #combos > 6 then
                            local combo6 = tolua.cast(owner["combo6"], "CCLabelTTF")
                            combo6:setString("...")
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
                    local skills = skilldata:getHeroSkills(hid)
                    local m = bAwake and 3 or 2
                    for j=0,m do
                        local dic = skills[tostring(j)]
                        if dic then
                            local skillId = dic.skillId
                            local level = dic.level
                            local skill = skilldata:getSkill(skillId, level, hero.heroId)
                            local skillText = tolua.cast(owner["skillText"..(j + 1)], "CCSprite")
                            skillText:setVisible(false)
                            local skillName = tolua.cast(owner["skillName"..(j + 1)], "CCLabelTTF")
                            skillName:setVisible(true)
                            skillName:setString(skill.skillName)
                            local skillBg = tolua.cast(owner["skill"..(j + 1)], "CCMenuItemImage")
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

                            if skill.skillRank == 4 then
                                HLAddParticleScale( "images/purpleEquip.plist", skillSprite, ccp(skillSprite:getContentSize().width / 2,skillSprite:getContentSize().height / 2), 1, 100, 777, 2 / 0.35 / retina, 2 / 0.35 / retina, 1 )
                            elseif skill.skillRank == 5 then
                                HLAddParticleScale( "images/goldEquip.plist", skillSprite, ccp(skillSprite:getContentSize().width / 2,skillSprite:getContentSize().height / 2), 1, 100, 777, 2 / 0.35 / retina, 2 / 0.35 / retina, 1 )
                            end

                            local skillLevelBg = tolua.cast(owner["skillLevelBg"..(j + 1)], "CCSprite")
                            skillLevelBg:setVisible(true)
                            skillLevelBg:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("level_bg_%d.png", skill.skillRank)))
                            local skillLevel = tolua.cast(owner["skillLevel"..(j + 1)], "CCLabelTTF")
                            skillLevel:setVisible(true)
                            skillLevel:setString(tostring(level))
                        end
                    end
                    -- 装备
                    local equips = herodata.heroes[hid].equip
                    if equips then
                        local n = bAwake and 3 or 2
                        for j=0,n do
                            local eid = equips[tostring(j)]
                            if eid then
                                -- local equip = equipdata:getEquip(dic.id)
                                --local equip = equipdata.equips[eid]
                                local trustEquip = equipdata:getEquip(eid)
                                --local conf = equipdata:getEquipConfig(equip.equipId)
                                local equipText = tolua.cast(owner["equipText"..(j + 1)], "CCSprite")
                                equipText:setVisible(false)

                                local equipName = tolua.cast(owner["equipName"..(j + 1)], "CCLabelTTF")
                                equipName:setVisible(true)
                                equipName:setString(trustEquip.name)
                                local equipBtn = tolua.cast(owner["equip"..(j + 1)], "CCMenuItemImage")
                                equipBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", trustEquip.rank)))
                                equipBtn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", trustEquip.rank)))
                                
                                local equipSprite = tolua.cast(owner["equipSprite"..j],"CCSprite")
                                if equipSprite then
                                    equipSprite:setVisible(true)
                                    local texture = CCTextureCache:sharedTextureCache():addImage(equipdata:getEquipIconByEquipId( trustEquip.icon ))
                                    -- local texture = CCTextureCache:sharedTextureCache():addImage("ccbResources/icons/armor_000208.png")
                                    if texture then
                                        equipSprite:setTexture(texture)
                                    end
                                end
                                local equipLevelBg = tolua.cast(owner["equipLevelBg"..(j + 1)], "CCSprite")
                                equipLevelBg:setVisible(true)
                                equipLevelBg:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("level_bg_%d.png", trustEquip.rank)))
                                equipLevelBg:setAnchorPoint(ccp(0.5,0.5))
                                if trustEquip.rank == 4 then
                                    HLAddParticleScale( "images/purpleEquip.plist", equipSprite, ccp(equipSprite:getContentSize().width / 2,equipSprite:getContentSize().height / 2), 1, 100, 777, 2 / 0.35 / retina, 2 / 0.35 / retina, 1 )
                                elseif trustEquip.rank == 5 then
                                    HLAddParticleScale( "images/goldEquip.plist", equipSprite, ccp(equipSprite:getContentSize().width / 2,equipSprite:getContentSize().height / 2), 1, 100, 777, 2 / 0.35 / retina, 2 / 0.35 / retina, 1 )
                                end
                                local equipLevel = tolua.cast(owner["equipLevel"..(j + 1)], "CCLabelTTF")
                                equipLevel:setVisible(true)
                                equipLevel:setString(tostring(trustEquip.level))
                            end
                        end
                    end
                    if shadowData:bOpenShadowFun() then
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
            for j=1,table.getTableCount(herodata.form) do
                local hid = herodata.form[tostring(j - 1)]
                local hero = herodata:getHero(herodata.heroes[hid])
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
            local topData= titleData:getDefalutTitles()
            for i=1,getMyTableCount(topData) do
                local titleLabel = tolua.cast(TeamAllViewCellOwner["title"..i], "CCLabelTTF")
                titleLabel:setString(topData[i].conf.name)
                local shadowLayer = tolua.cast(TeamAllViewCellOwner["shadow"..i],"CCLayer")
                local frameSprite = tolua.cast(TeamAllViewCellOwner["frame"..i],"CCMenuItemImage")
                local avatarSprite = tolua.cast(TeamAllViewCellOwner["titleSprite"..i],"CCSprite")

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
            end
            local allPrice = tolua.cast(TeamAllViewCellOwner["allPrice"], "CCLabelTTF")
            allPrice:setString(price)
            local fameLabel = tolua.cast(TeamAllViewCellOwner["fameLabel"], "CCLabelTTF")
            fameLabel:setString(titleData:getAllFame())

        elseif i == inFormCount + 2 then
            node = CCBReaderLoad("ccbResources/LalaViewCell.ccbi",proxy, true,"LalaViewCellOwner")
            for j=1,7 do
                local lala = tolua.cast(LalaViewCellOwner["lala"..j], "CCMenuItemImage")
                local head = tolua.cast(LalaViewCellOwner["head"..j], "CCSprite")
                local lalaLabel = tolua.cast(LalaViewCellOwner["lalaLabel"..j], "CCSprite")
                local lalaIcon = tolua.cast(LalaViewCellOwner["lalaIcon"..j], "CCSprite")
                local lalaMenu = tolua.cast(LalaViewCellOwner["lalaMenu"..j], "CCMenuItemImage")
                lalaMenu:setOpacity(0)
                local state = userdata:formSevenState(j)
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
                    local hid = userdata:getFormSevenByIndex(j)
                    local hero = herodata:getHero(herodata.heroes[hid])
                    lala:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", hero.rank)))
                    lala:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", hero.rank)))
                    local f = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(herodata:getHeroHeadByHeroId(hero.heroId))
                    if f then
                        head:setDisplayFrame(f)
                        -- if hero.rank == 4 then
                        --     HLAddParticleScale( "images/purpleEquip.plist", head, ccp(head:getContentSize().width / 2,head:getContentSize().height / 2), 1, 100, 777, 2 / retina, 2 / retina, 1 )
                        -- end
                        head:setVisible(true)
                    end
                end
                --设置啦啦队界面中剪影的Lv等级
                local lalaLable = tolua.cast(LalaViewCellOwner["lalaLable"..j], "CCLabelTTF") 
                local sevenLv = userdata:getFormSevenLv(j)
                sevenLv = (sevenLv == 5) and "Max" or sevenLv
                lalaLable:setString("Lv." .. sevenLv)
                lalaLable:setColor(ccc3(255, 120, 0))
                lalaLable:setVisible(state > 1)

                -- 显示隐藏的箭头动画
                local lalaLSprite = tolua.cast(LalaViewCellOwner["lalaLSprite"..j], "CCSprite") 
                lalaLSprite:setVisible(state > 1 and userdata:getFormSevenLv(j) < userdata:getFormSevenUpgradeMax(j))
                if userdata:getFormSevenLv(j) == 5 then
                    lalaLSprite:setVisible(false)
                end
        
            end
            local attr = herodata:getSevenFormAttr()
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
        layer:setAnchorPoint(ccp(0, 0))
        layer:setPosition(ccp((winSize.width - layer:getContentSize().width * retina) / 2, 0))
        local n = CCNode:create()
        n:addChild(layer)
        pageView:addPageView(i - 1, n)
    end

    _layer:addChild(pageView)
    pageView:updateView()
    if runtimeCache.bGuide then
        local step = -1
        if runtimeCache.guideStep == GUIDESTEP.equipWeapon 
            or runtimeCache.guideStep == GUIDESTEP.selectNeedUpdateEquip then
            step = runtimeCache.guideStep
        elseif runtimeCache.guideStep + 1 == GUIDESTEP.equipWeapon 
            or runtimeCache.guideStep + 1 == GUIDESTEP.selectNeedUpdateEquip then
            step = runtimeCache.guideStep + 1
        end
        if step ~= -1 then
            local touchLayer = tolua.cast(GuideOwner["touch"..step], "CCLayer")
            local ghLayer = tolua.cast(GuideOwner["ghLayer"..step], "CCLayer")
            if touchLayer and ghLayer then
                local y = (winSize.height - _mainLayer:getBroadCastContentSize().height + _mainLayer:getBottomContentSize().height -
                         topBg:getContentSize().height * retina - sp:getContentSize().height * retina) / 2 + 559 * retina
                local x = 568 * retina + (winSize.width - 640 * retina) / 2
                touchLayer:setPosition(ccp(x, y))
                ghLayer:setPosition(ccp(x, y))
            end
        end
    end
end

local function refreshTeamLayer()
    if pageView then
        pageView:removeFromParentAndCleanup(true)
        pageView = nil
    end
    if tableView then
        tableView:removeFromParentAndCleanup(true)
        tableView = nil
    end
    addPageView()
    addTableView()
    tableView:reloadData() 
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/TeamView.ccbi",proxy, true,"TeamViewOwner")
    _layer = tolua.cast(node,"CCLayer")
end

local function _showTeam()
    runtimeCache.teamState = 0
    _layer:refreshTeamLayer()
    pageView:moveToPage(_currentPage)
end

-- 该方法名字每个文件不要重复
function getTeamLayer()
	return _layer
end

function createTeamLayer()
    _init()
    function _layer:showTeam()
        _showTeam()
    end

    function _layer:refresh()
        _layer:refreshTeamLayer()
        pageView:moveToPage(_currentPage)
    end

    function _layer:equipItemClick(tag)
        if tag == 1 then
            Global:instance():TDGAonEventAndEventData("weapon")
        elseif tag == 2 then
            Global:instance():TDGAonEventAndEventData("armor")
        elseif tag == 3 then
            Global:instance():TDGAonEventAndEventData("ornament")
        elseif tag == 4 then
            Global:instance():TDGAonEventAndEventData("rune")
        end
        local hid = herodata.form[tostring(_currentPage)]
        if hid then
            local equips = equipdata:getHeroEquips(hid)
            local dic = equips[tostring(tag - 1)]
            if dic then
                local array = {}
                array["heroUid"] = hid
                array["pos"] = tag - 1
                local equipLayer = createEquipInfoLayer(dic["id"], 1, -135,array)
                getMainLayer():addChild(equipLayer, 10)
            else
                --进入武器选择页面
                if getMainLayer then
                    getMainLayer():getoEquipChangeSelectView(hid,tag - 1)
                end
            end
        end
    end

    function _layer:refreshLaLa()
        refreshTeamLayer()
        pageView:moveToPage(userdata:getFormMax() + 1)
    end

    function _layer:refreshTeamLayer()
        _wAni = true
        refreshTeamLayer()
        _wAni = false
    end

    local function _onEnter()
        refreshTeamLayer()
        if runtimeCache.levelGuideNext and runtimeCache.levelGuideNext == "cheer" then
            pageView:moveToPage(userdata:getFormMax() + 1)
        elseif runtimeCache.teamPage then
            pageView:moveToPage(runtimeCache.teamPage)
        end
        _layer:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCCallFunc:create(_addSelFrame)))
        runtimeCache.isSevenForm = false
        if runtimeCache.hakiGetByOpenBattle > 0 then
            ShowText(HLNSLocalizedString("gain.text.default", HLNSLocalizedString("gain.haki", runtimeCache.hakiGetByOpenBattle)))
            runtimeCache.hakiGetByOpenBattle = 0
        end
    end

    local function _onExit()
        getMainLayer():TitleBgVisible(true)
        _layer = nil
        _currentPage = 0
        pageView = nil
        tableView = nil
        _wAni = false
        runtimeCache.levelGuideNext = nil
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