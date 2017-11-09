local hakiCell = class("cell", function()
    local proxy = CCBProxy:create()
    local node = CCBReaderLoad("ccbResources/TeamHakiViewCell.ccbi", proxy, true, "TeamHakiViewCellOwner")
    return node
end)

TeamHakiViewCellOwner = TeamHakiViewCellOwner or {}
ccb["TeamHakiViewCellOwner"] = TeamHakiViewCellOwner

local function _updateLabel(labelStr, string)
    local label
    label = tolua.cast(TeamHakiViewCellOwner[labelStr], "CCLabelTTF")
    label:setString(string)
    label:setVisible(true)
end

function hakiCell:refresh()

    local function showSkill(index)
        print("showSkill" .. index)
        local haki = herodata:getHakiInfo(self.hid)
        getMainLayer():getParent():addChild(createHakiInfoLayer(haki, index))
    end

    local function lockMenuClick()
        getTeamLayer():showTeam()
    end

    local hid = self.hid
    local clv, hlv = userdata:hakiOpenLv()

    local lockLayer = tolua.cast(TeamHakiViewCellOwner["lockLayer"], "CCLayer")
    local lockMenu = tolua.cast(TeamHakiViewCellOwner["lockMenu"], "CCMenuItem")
    lockMenu:registerScriptTapHandler(lockMenuClick)
    local menu1 = tolua.cast(TeamHakiViewCellOwner["menu1"], "CCMenu")
    local menu2 = tolua.cast(TeamHakiViewCellOwner["menu2"], "CCMenu")
    local ballItem = tolua.cast(TeamHakiViewCellOwner["ballItem"], "CCMenuItem")
    ballItem:setOpacity(0)

    if userdata.level < clv then
        -- 战队等级还未开启
        lockLayer:setVisible(true)
        lockMenu:setVisible(true)
        lockMenu:setOpacity(0)
        _updateLabel("lockLabel", HLNSLocalizedString("haki.cell.lock.1", clv))
        menu1:setEnabled(false)
        menu2:setEnabled(false)
    else
        local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
        if hid then
            local hero = herodata:getHero(herodata.heroes[hid])

            local rankBg = tolua.cast(TeamHakiViewCellOwner["rankBg"], "CCSprite")
            rankBg:setDisplayFrame(cache:spriteFrameByName(string.format("hero_bg_%d.png", hero.rank)))
            local avatarSprite = tolua.cast(TeamHakiViewCellOwner["avatarSprite"], "CCSprite")
            if avatarSprite then
                local texture = CCTextureCache:sharedTextureCache():addImage(herodata:getHeroBust1ByHeroId(hero.heroId))
                if texture then
                    avatarSprite:setVisible(true)
                    avatarSprite:setTexture(texture)
                end  
            end
            
            if hero.level < hlv then
                -- 伙伴等级不够
                lockLayer:setVisible(true)
                lockMenu:setVisible(true)
                lockMenu:setOpacity(0)
                _updateLabel("lockLabel", HLNSLocalizedString("haki.cell.lock.2", hlv))
                menu1:setEnabled(false)
                menu2:setEnabled(false)
            else
                -- {kind = 1, layer = 1, base = 0, pre = 0}
                local haki = herodata:getHakiInfo(hero)

                local function statusItemClick()
                    showSkill(math.min(haki.kind, 8))
                end
                local statusItem = tolua.cast(TeamHakiViewCellOwner["statusItem"], "CCMenuItem")
                statusItem:registerScriptTapHandler(statusItemClick)

                local function hakiSkillClick(tag)
                    print("hakiSkillClick" .. tag)
                    if haki.kind - 1 < tag then
                        ShowText(HLNSLocalizedString("haki.train.lock.tips"))
                        return
                    end
                    showSkill(tag)
                end
                for i=1,8 do
                    local skill = tolua.cast(TeamHakiViewCellOwner["skill" .. i], "CCMenuItem")
                    skill:registerScriptTapHandler(hakiSkillClick)
                end

                local function collectItemClick()
                    getMainLayer():gotoAdventure()
                    getAdventureLayer():showUninhabited()
                end
                local collectItem = tolua.cast(TeamHakiViewCellOwner["collectItem"], "CCMenuItem")
                collectItem:registerScriptTapHandler(collectItemClick)

                local function teamItemClick()
                    lockMenuClick()
                end
                local teamItem = tolua.cast(TeamHakiViewCellOwner["teamItem"], "CCMenuItem")
                teamItem:registerScriptTapHandler(teamItemClick)

                local function hakiTrainItemClick()
                    if haki.pre == 0 then
                        if haki.kind > 8 then
                            -- 训练完了
                            ShowText(HLNSLocalizedString("ERR_8001"))
                            return
                        end
                        -- 先对话，后战斗
                        local function endTalk()
                            -- 对话完毕 开始战斗
                            local conf = ConfigureStorage.aggress_npclist[string.format("npclist_%d_%d", haki.kind, haki.layer)]

                            BattleField.leftName = userdata.name
                            BattleField.rightName = herodata:getHeroConfig(conf.animation).name
                            RandomManager.cursor = RandomManager.randomRange(0, 999)
                            local seed = RandomManager.cursor

                            BattleField:hakiFight(hid, haki.kind, haki.layer)
                            local result = BattleField.result == RESULT_WIN and 4 - BattleField.round or 0

                            local function callback(url, rtnData)
                                runtimeCache.hakiGetByOpenBattle = rtnData.info.gain.hotBlood
                                for k,v in pairs(rtnData.info.aggress.training.heros) do
                                    herodata:addHeroByDic(v)
                                end
                                CCDirector:sharedDirector():replaceScene(CCTransitionFade:create(0.6, FightingScene()))
                            end
                            if result > 0 then
                                doActionFun("HAKI_FIGHT", {hid, result}, callback)
                            else
                                CCDirector:sharedDirector():replaceScene(CCTransitionFade:create(0.6, FightingScene()))
                            end
                        end
                        local talkConf = herodata:getHakiTalk(haki)
                        if not talkConf or talkConf.talknum <= 0 then
                            return
                        end
                        getMainLayer():getParent():addChild(createHakiTalkLayer(talkConf, hero, endTalk))
                        
                    else
                        -- 训练
                        if self.moveAni then
                            return
                        end
                        local conmuse = herodata:getHakiTrainCost(haki) or 0
                        if userdata.haki < conmuse then
                            ShowText(HLNSLocalizedString("haki.train.notEnough"))
                            return
                        end

                        local function callback(url, rtnData)
                            local content = tolua.cast(self:getChildByTag(9999), "CCLayer")
                            local halo = tolua.cast(content:getChildByTag(99), "CCSprite")
                            local new = {}
                            local haki = herodata:getHakiInfo(self.hid)
                            local info = herodata:nextBall(haki)
                            for i=1,3 do
                                local ball = tolua.cast(halo:getChildByTag(10 + i), "CCSprite")
                                ball:setVisible(false)
                                if i == 2 then
                                    if self.ps then
                                        self.ps:removeFromParentAndCleanup(true)
                                        self.ps = nil
                                    end
                                    local x, y = ball:getPosition()
                                    local ps = HLAddParticleScale("images/aggr2.plist", halo, ccp(x, y), 1, -1, 99, 1, 1)
                                    -- ps:setDuration(1)
                                end
                            end
                            for i=2,4 do
                                local nb = CCSprite:createWithSpriteFrameName(string.format("blood_%d_%d.png", info.layer == 9 and 1 or info.layer, i - 1))
                                local ball = tolua.cast(halo:getChildByTag(10 + i), "CCSprite")
                                local x, y = ball:getPosition()
                                nb:setPosition(ccp(x, y))
                                halo:addChild(nb)
                                new[i - 1] = nb
                                info = herodata:nextBall(info)
                            end

                            local function move()
                                self.moveAni = true
                                for i=1,3 do
                                    local ball = tolua.cast(halo:getChildByTag(10 + i), "CCSprite")
                                    local x, y = ball:getPosition()
                                    local nb = new[i]
                                    nb:runAction(CCMoveTo:create(0.5, ccp(x, y)))
                                end
                                local ball0 = tolua.cast(halo:getChildByTag(10), "CCSprite")
                                local ball1 = tolua.cast(halo:getChildByTag(11), "CCSprite")

                                local l = haki.layer
                                local b = haki.base
                                l = b == 0 and l - 1 or l
                                l = l == 0 and 8 or l
                                local nb = CCSprite:createWithSpriteFrameName(string.format("blood_%d_%d.png", l == 9 and 1 or l, 1))
                                local x0, y0 = ball0:getPosition()
                                local x1, y1 = ball1:getPosition()
                                nb:setPosition(ccp(x1, y1))
                                halo:addChild(nb)
                                local function remove(sender)
                                    sender:removeFromParentAndCleanup(true)
                                end
                                nb:runAction(CCSequence:createWithTwoActions(CCSpawn:createWithTwoActions(CCFadeOut:create(0.5), CCMoveTo:create(0.5, ccp(x0, y0))), CCCallFuncN:create(remove)))
                            end
                            local function moveEnd()
                                self.moveAni = false
                            end
                            local function refreshData()
                                for k,v in pairs(rtnData.info.aggress.training.heros) do
                                    herodata:addHeroByDic(v)
                                end
                            end
                            local function refresh()
                                getTeamLayer():refresh()
                            end
                            local array = CCArray:create()
                            array:addObject(CCCallFunc:create(move))
                            array:addObject(CCDelayTime:create(1.3))
                            array:addObject(CCCallFunc:create(refreshData))
                            array:addObject(CCCallFunc:create(refresh))
                            self:runAction(CCSequence:create(array))
                        end
                        doActionFun("HAKI_TRAIN", {hid, result}, callback)
                    end
                end
                local hakiTrainItem = tolua.cast(TeamHakiViewCellOwner["hakiTrainItem"], "CCMenuItem")
                hakiTrainItem:registerScriptTapHandler(hakiTrainItemClick)

                ballItem:registerScriptTapHandler(statusItemClick)

                menu1:setEnabled(true)
                menu2:setEnabled(true)

                local hakiName = tolua.cast(TeamHakiViewCellOwner["hakiName"], "CCSprite")
                hakiName:setDisplayFrame(cache:spriteFrameByName(string.format("name_aggskill_%06d.png", math.min(8, haki.kind))))

                local hakiTrainLabel = tolua.cast(TeamHakiViewCellOwner["hakiTrainLabel"], "CCLabelTTF")
                hakiTrainLabel:setString(haki.pre == 0 and HLNSLocalizedString("haki.cell.start") or HLNSLocalizedString("haki.cell.continue"))
                local costIcon = tolua.cast(TeamHakiViewCellOwner["costIcon"], "CCSprite")
                costIcon:setVisible(haki.pre ~= 0)
                local infos = herodata:getHakiBallInfo(haki)
                local conmuse = herodata:getHakiTrainCost(haki)
                local n = herodata:nextBall(haki)
                local attr = herodata:hakiBallAttr(n.kind, n.layer, n.base)
                for i=1,2 do
                    local costLabel = tolua.cast(TeamHakiViewCellOwner["costLabel" .. i], "CCLabelTTF")
                    costLabel:setVisible(haki.pre ~= 0 and conmuse ~= nil)
                    costLabel:setString(conmuse or 0)
                    local attrLabel = tolua.cast(TeamHakiViewCellOwner["attr" .. i], "CCLabelTTF")
                    for k,v in pairs(attr) do
                        if v ~= 0 then
                            attrLabel:setString(HLNSLocalizedString(k) .. "+" .. v)
                            break
                        end
                    end
                end
                for i=1,3 do
                    local info = infos[i]
                    local k = info.kind
                    local l = info.layer
                    local b = info.base
                    l = b == 0 and l - 1 or l
                    l = l == 0 and 8 or l
                    local ball = tolua.cast(TeamHakiViewCellOwner["ball" .. i], "CCSprite")
                    ball:setDisplayFrame(cache:spriteFrameByName(string.format("blood_%d_%d.png", l == 9 and 1 or l, i)))
                    ball:setZOrder(1)
                    if i == 2 then
                        local content = tolua.cast(self:getChildByTag(9999), "CCLayer")
                        local halo = tolua.cast(content:getChildByTag(99), "CCSprite")
                        local x, y = ball:getPosition()
                        self.ps = HLAddParticleScale("images/aggr1.plist", halo, ccp(x, y), 1, 0, 99, 1, 1)
                    end
                end
                _updateLabel("hakiBloodLabel", userdata.haki)
                local attr = herodata:getHakiAttr(haki)
                for k,v in pairs(attr) do
                    _updateLabel(k .. "Label", string.format("+%d", v))
                end
                for i=1,8 do
                    local hakiLock = tolua.cast(TeamHakiViewCellOwner["hakiLock" .. i], "CCSprite")
                    hakiLock:setVisible(haki.kind <= i)
                end

            end
        else
            -- 未上阵
            lockLayer:setVisible(true)
            lockMenu:setVisible(true)
            lockMenu:setOpacity(0)
            _updateLabel("lockLabel", HLNSLocalizedString("haki.cell.lock.3"))
            menu1:setEnabled(false)
            menu2:setEnabled(false)
        end
    end
end


function createHakiCell(hid)
    local _node = hakiCell.new()
    _node.hid = hid
    _node.moveAni = false
    _node:refresh()

    local function hakiRefresh()
        local hakiBloodLabel = tolua.cast(tolua.cast(_node:getChildByTag(9999), "CCLayer"):getChildByTag(9999), "CCLabelTTF")
        hakiBloodLabel:setString(userdata.haki)
    end

    local function _onEnter()
        addObserver(NOTI_HAKI, hakiRefresh)
    end

    local function _onExit()
        removeObserver(NOTI_HAKI, hakiRefresh)
    end

    --onEnter onExit
    local function _layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        end
    end


    _node:registerScriptHandler(_layerEventHandler)

    return _node
end