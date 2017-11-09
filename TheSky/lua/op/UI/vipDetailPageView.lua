local SCALE9_WIDTH = 585
local DESP_LABEL_WIDTH = 550
local REWARD_HEIGHT = 230
local DESP_LABEL_ADD = 80
local PAGE_WIDTH = 613


vipDetailPageView = class("vipDetailPageView", function()
    local layer = CCLayer:create()
    layer:setContentSize(CCSizeMake(613, 490))
    return layer
end)

vipDetailPageView.vipLevel = nil
vipDetailPageView.priority = nil
vipDetailPageView.tableView = nil
vipDetailPageView.bTableViewTouch = false


function vipDetailPageView:refresh()

    vipDetailSelCellOwner = vipDetailSelCellOwner or {}
    ccb["vipDetailSelCellOwner"] = vipDetailSelCellOwner

    local function getStringHeight(string, width, fontSize, fontName)
        if not fontName then
            fontName = "ccbResources/FZCuYuan-M03S"
        end
        if tempLabel then
            tempLabel = tolua.cast(tempLabel,"CCLabelTTF")
            if tempLabel then
                tempLabel:removeAllChildrenWithCleanup(true)
                tempLabel = nil
            end
        end

        tempLabel = CCLabelTTF:create(string, fontName, fontSize, CCSizeMake(width, 0), kCCTextAlignmentLeft)
        self:addChild(tempLabel)
        tempLabel:setVisible(false)
        return (tempLabel:getContentSize().height)
    end


    local function itemClick(tag)
        local awards = vipdata:getVipAward(self.vipLevel)
        local award = awards[tag]
        local itemId = award.itemId
        if havePrefix(itemId, "weapon_") or havePrefix(itemId, "belt_") or havePrefix(itemId, "armor_") then
            -- 装备
            getMainLayer():getParent():addChild(createEquipInfoLayer(itemId, 2, self.priority - 2), 101)
        elseif havePrefix(itemId, "item") or havePrefix(itemId, "key") or havePrefix(itemId, "stuff") then
            -- 道具
            getMainLayer():getParent():addChild(createItemDetailInfoLayer(itemId, self.priority - 2, 1, 1), 101)
        elseif havePrefix(itemId, "shadow") then
            -- 影子
            local dic = {}
            local item = shadowData:getOneShadowConf(itemId)
            dic.conf = item
            dic.id = itemId
            getMainLayer():getParent():addChild(createShadowPopupLayer(dic, nil, nil, self.priority - 2, 1), 101)
        elseif havePrefix(itemId, "hero") then
            -- 魂魄
            getMainLayer():getParent():addChild(createHeroInfoLayer(itemId, HeroDetail_Clicked_Handbook, self.priority - 2), 101)
        elseif havePrefix(itemId, "book") then
            -- 奥义
            getMainLayer():getParent():addChild(createHandBookSkillDetailLayer(itemId, self.priority - 2), 101) 
        elseif havePrefix(itemId, "chapter_") then
            -- 残章
            local bookId = string.format("book_%s", string.split(itemId, "_")[2])
            getMainLayer():getParent():addChild(createHandBookSkillDetailLayer(bookId, self.priority - 2), 101) 
        else
            -- 金币 银币
        end
    end

    local function getRewardCallback(url, rtnData)
        vipdata.vipItems = rtnData.info.vipItems
        getVipDetailLayer():refreshLayer()
        if getShpRechargeLayer() then
            getShpRechargeLayer():updateVipLevelReward()
        end
        ----首页上方title的 vip头像框高亮效果
        if getMainLayer() then
            getMainLayer():updateVipLevelReward()
        end
        if getMainLayer() then
            getMainLayer():updateRecruitBtmState()
        end
        if getLogueTownLayer() then
            getLogueTownLayer():updateVipLevelReward()
        end
    end

    local function rewardItemClick()
        if vipdata:getVipLevel() < self.vipLevel then
            -- vip等级不够
            ShowText(HLNSLocalizedString("vip.award.need", self.vipLevel))
        else
            -- 领取
            doActionFun("GET_VIP_LEVEL_REWARD", { self.vipLevel }, getRewardCallback)
        end
    end

    local function _addTableView() 
        local h = LuaEventHandler:create(function(fn, table, a1, a2)
            local r
            if fn == "cellSize" then
                local height
                if a1 == 0 then
                    height = REWARD_HEIGHT
                else
                    height = getStringHeight(vipdata:getVipDesp(self.vipLevel), DESP_LABEL_WIDTH, 24,
                     "ccbResources/FZCuYuan-M03S") + DESP_LABEL_ADD + 10
                end
                r = CCSizeMake(PAGE_WIDTH, height)
            elseif fn == "cellAtIndex" then
                -- Return CCTableViewCell, a1 is cell index (zero based), a2 is dequeued cell (maybe nil)
                -- Do something to create cell  and change the content

                local function setCellMenuPriority(sender)
                    if sender then
                        menu = tolua.cast(sender,"CCMenu")
                        menu:setHandlerPriority(self.priority - 1)
                    end
                end
                
                local cell

                if a2 then
                    a2:removeAllChildrenWithCleanup(true)
                else 
                    a2 = CCTableViewCell:create()
                end
                
                if a1 == 0 then
                    local awards = vipdata:getVipAward(self.vipLevel)

                    local proxy = CCBProxy:create()
                    cell = tolua.cast(CCBReaderLoad("ccbResources/vipDetailSelCell.ccbi",proxy,true,"vipDetailSelCellOwner"),"CCLayer")

                    local giftTitle = tolua.cast(vipDetailSelCellOwner["giftTitle"], "CCLabelTTF")
                    giftTitle:setString(HLNSLocalizedString("vip.gift.title", self.vipLevel))

                    local rewardItem = tolua.cast(vipDetailSelCellOwner["rewardItem"], "CCMenuItem")
                    rewardItem:registerScriptTapHandler(rewardItemClick)
                    local rewardText = tolua.cast(vipDetailSelCellOwner["rewardText"], "CCSprite")
                    if vipdata.vipItems and vipdata.vipItems[tostring(self.vipLevel)] and tonumber(vipdata.vipItems[tostring(self.vipLevel)]) == 1 then
                        -- 已领取
                        rewardItem:setVisible(false)
                        rewardText:setVisible(false)
                    elseif vipdata:getVipLevel() < self.vipLevel then
                        -- 不可领取
                        rewardItem:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn2_2.png"))
                        rewardItem:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn2_2.png"))
                    else
                        -- 加光圈
                        local light = CCSprite:createWithSpriteFrameName("lightingEffect_recruitBtn_1.png")
                        local animFrames = CCArray:create()
                        for j = 1, 3 do
                            local frameName = string.format("lightingEffect_recruitBtn_%d.png",j)
                            local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(frameName)
                            animFrames:addObject(frame)
                        end
                        local animation = CCAnimation:createWithSpriteFrames(animFrames, 0.3)
                        local animate = CCAnimate:create(animation)
                        light:runAction(CCRepeatForever:create(animate))
                        light:setPosition(ccp(rewardItem:getContentSize().width / 2, rewardItem:getContentSize().height / 2 + 2))
                        rewardItem:addChild(light, 1, 9888)
                    end

                    local menu = tolua.cast(vipDetailSelCellOwner["menu"], "CCMenu")

                    local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCCallFuncN:create(setCellMenuPriority))
                    menu:runAction(seq)

                    for i=1,4 do
                        local itemBtn = tolua.cast(vipDetailSelCellOwner["itemBtn"..i], "CCMenuItem")
                        itemBtn:setTag(i)
                        itemBtn:registerScriptTapHandler(itemClick)
                        local contentLayer = tolua.cast(vipDetailSelCellOwner["contentLayer"..i], "CCLayer")
                        local nameLabel = tolua.cast(vipDetailSelCellOwner["nameLabel"..i], "CCLabelTTF")
                        local countLabel = tolua.cast(vipDetailSelCellOwner["countLabel"..i], "CCLabelTTF")
                        local bigSprite = tolua.cast(vipDetailSelCellOwner["bigSprite"..i], "CCSprite")
                        local littleSprite = tolua.cast(vipDetailSelCellOwner["littleSprite"..i], "CCSprite")
                        local soulIcon = tolua.cast(vipDetailSelCellOwner["soulIcon"..i], "CCSprite")

                        local award = awards[i]
                        if not award then
                            contentLayer:setVisible(false)
                            itemBtn:setVisible(false)
                        else
                            contentLayer:setVisible(true)
                            itemBtn:setVisible(true)

                            local itemId = award.itemId
                            local count = award.amount

                            local resDic = userdata:getExchangeResource(itemId)

                            if havePrefix(itemId, "weapon_") or havePrefix(itemId, "belt_") or havePrefix(itemId, "armor_") then
                                -- 装备
                                bigSprite:setVisible(true)
                                local texture = CCTextureCache:sharedTextureCache():addImage(resDic.icon)
                                if texture then
                                    bigSprite:setVisible(true)
                                    bigSprite:setTexture(texture)
                                end

                            elseif havePrefix(itemId, "item") then
                                -- 道具
                                bigSprite:setVisible(true)
                                local texture = CCTextureCache:sharedTextureCache():addImage(resDic.icon)
                                if texture then
                                    bigSprite:setVisible(true)
                                    bigSprite:setTexture(texture)
                                end
                            elseif havePrefix(itemId, "shadow") then
                                -- 影子
                                rebateItem:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("s_frame.png"))
                                rebateItem:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("s_frame.png"))

                                rebateItem:setPosition(ccp(rebateItem:getPositionX() + 5,rebateItem:getPositionY() - 5))
                                if resDic.icon then
                                    playCustomFrameAnimation( string.format("yingzi_%s_",resDic.icon),contentLayer,ccp(contentLayer:getContentSize().width / 2,contentLayer:getContentSize().height / 2),1,4,shadowData:getColorByColorRank( resDic.rank ) )
                                end
                            elseif havePrefix(itemId, "hero") then
                                -- 魂魄
                                littleSprite:setVisible(true)
                                littleSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(resDic.icon))

                            elseif havePrefix(itemId, "book") then
                                -- 奥义
                                bigSprite:setVisible(true)
                                local texture = CCTextureCache:sharedTextureCache():addImage(resDic.icon)
                                if texture then
                                    bigSprite:setVisible(true)
                                    bigSprite:setTexture(texture)
                                end
                            else
                                -- 金币 银币
                                bigSprite:setVisible(true)
                                local texture = CCTextureCache:sharedTextureCache():addImage(resDic.icon)
                                if texture then
                                    bigSprite:setVisible(true)
                                    bigSprite:setTexture(texture)
                                end
                            end
                            if not havePrefix(itemId, "shadow") then
                                itemBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", resDic.rank)))
                                itemBtn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", resDic.rank)))
                            end

                            -- 设置名字和数量

                            countLabel:setString(count)
                            nameLabel:setString(resDic.name)
                        end
                    end
                else
                    local despStr = vipdata:getVipDesp(self.vipLevel)
                    local height = getStringHeight(despStr, DESP_LABEL_WIDTH, 24, "ccbResources/FZCuYuan-M03S")
                    cell = CCLayer:create()
                    local cellSize = CCSizeMake(PAGE_WIDTH, height + DESP_LABEL_ADD + 10)
                    cell:setContentSize(cellSize)

                    local cellBg = CCScale9Sprite:create("images/grayBg.png")
                    cellBg:setContentSize(CCSizeMake(SCALE9_WIDTH, height + DESP_LABEL_ADD))
                    cellBg:setAnchorPoint(ccp(0.5,0.5))
                    cellBg:setPosition(ccp(cellSize.width / 2, cellSize.height / 2))
                    cell:addChild(cellBg)

                    local title = CCLabelTTF:create(HLNSLocalizedString("vip.right.title", self.vipLevel), "ccbResources/FZCuYuan-M03S", 30)
                    title:setAnchorPoint(ccp(0.5, 1))
                    title:setPosition(cellBg:getContentSize().width / 2, cellBg:getContentSize().height - 10)
                    cellBg:addChild(title)

                    local despLabel = CCLabelTTF:create(despStr, "ccbResources/FZCuYuan-M03S", 24, CCSizeMake(DESP_LABEL_WIDTH, 0), kCCTextAlignmentLeft)
                    despLabel:setAnchorPoint(ccp(0.5, 1))
                    despLabel:setPosition(cellBg:getContentSize().width / 2, title:getPositionY() - title:getContentSize().height - 5)
                    cellBg:addChild(despLabel)
                end

                a2:addChild(cell, 0, 1)
                a2:setAnchorPoint(ccp(0, 0))
                a2:setPosition(0, 0)
                r = a2
            elseif fn == "numberOfCells" then
                r = 2
            elseif fn == "cellTouched" then         -- A cell was touched, a1 is cell that be touched. This is not necessary.
                -- print("cellTouched",a1:getIdx())
            elseif fn == "cellTouchBegan" then      -- A cell is touching, a1 is cell, a2 is CCTouch
                getVipDetailLayer():pageViewTouchEnabled(true)
                self.bTableViewTouch = true
            elseif fn == "cellTouchEnded" then      -- A cell was touched, a1 is cell, a2 is CCTouch
                if self.bTableViewTouch then
                    getVipDetailLayer():pageViewTouchEnabled(true)
                    self.bTableViewTouch = false
                end
            elseif fn == "cellHighlight" then       -- A cell is highlighting, coco2d-x 2.1.3 or above
            elseif fn == "cellUnhighlight" then     -- A cell had been unhighlighted, coco2d-x 2.1.3 or above
            elseif fn == "cellWillRecycle" then     -- A cell will be recycled, coco2d-x 2.1.3 or above
            elseif fn == "scroll" then
                if self.bTableViewTouch then
                    getVipDetailLayer():pageViewTouchEnabled(false)
                end
            end
            return r
        end)
        
        local size = self:getContentSize()
        self.tableView = LuaTableView:createWithHandler(h, size)
        self.tableView:setBounceable(true)
        self.tableView:setAnchorPoint(ccp(0,0))
        self.tableView:setPosition(ccp(0, 0))
        self.tableView:setVerticalFillOrder(0)
        self:addChild(self.tableView)
    end

    _addTableView()
end

function vipDetailPageView:setPriority()
    local function setMenuPriority()
         self.tableView:setTouchPriority(self.priority - 1)
    end
    local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCCallFunc:create(setMenuPriority))
    self:runAction(seq)
end

function createVipPageViewLayer(vipLevel, priority)
    local _layer = vipDetailPageView.new()
    _layer.vipLevel = vipLevel
    _layer.priority = priority
    _layer.bTableViewTouch = false
    _layer:refresh()

    local function _onEnter()
        _layer:setPriority()
    end

    local function _onExit()

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