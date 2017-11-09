
chapterLayer = class("chapterLayer", function()
    local proxy = CCBProxy:create()
    local node  = CCBReaderLoad("ccbResources/ChapterView.ccbi",proxy, true,"ChapterViewOwner")
    local layer = tolua.cast(node,"CCLayer")
    return layer
end)

chapterLayer.bookId = nil
chapterLayer.chapterId = nil


ChapterViewOwner = ChapterViewOwner or {}
ccb["ChapterViewOwner"] = ChapterViewOwner

-- function chapterLayer.getChapterEnemiesCallback(url, rtnData)
--     getMainLayer():gotoChapterRob(rtnData["info"], chapterLayer.bookId, chapterLayer.chapterId)
-- end

-- function chapterLayer.chapterClick(tag)
--     local chapterPre = string.gsub(self.bookId, "book", "chapter")
--     local chapterId = string.format("%s_%02d", chapterPre, tag)
--     local count = 0
--     if chapterdata.chapters[self.bookId][chapterId] then
--         count = chapterdata.chapters[self.bookId][chapterId]
--     end
--     if count > 0 then
--         ShowText(HLNSLocalizedString("chapter.rob.haveOne"))
--     else
--         self.chapterId = chapterId
--         doActionFun("GET_CHAPTER_ENEMIES", {self.bookId, chapterId}, self.getChapterEnemiesCallback)
--     end
-- end
-- ChapterViewOwner["chapterClick"] = chapterLayer.chapterClick

-- function chapterLayer.combineItemClick()
--     local conf = skilldata:getSkillConfig(self.bookId)
--     local chapterNum = conf.chapternum
--     local flag = true
--     for i=1,chapterNum do
--         local chapterPre = string.gsub(self.bookId, "book", "chapter")
--         local chapterId = string.format("%s_%02d", chapterPre, i)
--         if not chapterdata.chapters[self.bookId][chapterId] or chapterdata.chapters[self.bookId][chapterId] < 1 then
--             flag = false
--             break
--         end
--     end
--     if not flag then
--         ShowText(HLNSLocalizedString("chapter.needBook"))
--     else
--         -- TODO 合成残章
--     end
-- end
-- ChapterViewOwner["combineItemClick"] = chapterLayer.combineItemClick

-- function chapterLayer:skillItemClick()
--     print(self.bookId)
--     getMainLayer():getParent():addChild(createChapterInfoLayer(self.bookId, -134))
-- end


function chapterLayer:refresh()

    local function getChapterEnemiesCallback(url, rtnData)
        getMainLayer():gotoChapterRob(rtnData["info"], self.bookId, self.chapterId)
    end

    local function chapterClick(tag)
        Global:instance():TDGAonEventAndEventData("adventure11")
        local chapterPre = string.gsub(self.bookId, "book", "chapter")
        local chapterId = string.format("%s_%02d", chapterPre, tag)

        local count = 0
        if chapterdata.chapters[self.bookId][chapterId] then
            count = chapterdata.chapters[self.bookId][chapterId]
        end
        if count > 0 then
            ShowText(HLNSLocalizedString("chapter.rob.haveOne"))
        else
            self.chapterId = chapterId
            doActionFun("GET_CHAPTER_ENEMIES", {self.bookId, chapterId}, getChapterEnemiesCallback)
        end
    end

    local function skillItemClick(tag, sender)
        getMainLayer():getParent():addChild(createChapterInfoLayer(self.bookId, -134))
    end

    local function combineSkillCallback(url,rtnData)
        runtimeCache.responseData = rtnData.info
        chapterdata:reduceCombineTime(self.bookId)
        getAdventureLayer():refreshAdventureLayer() 
        getMainLayer():gotoAdventure()
        local conf = skilldata:getSkillConfig(self.bookId)
        palyConvAnimationOnNode(self.bookId,conf.chapternum,true, getAdventureLayer())
    end

    local function getChaptersCallback(url, rtnData)
        if table.getTableCount(rtnData.info) then
            for k,v in pairs(rtnData.info) do
                chapterdata.chapters[k] = v
            end
        end
        getAdventureLayer():refreshAdventureLayer()
    end

    local function combineErrorCallback(url, rtnCode)
        if rtnCode == ErrorCodeTable.ERR_1106 then
            doActionFun("GET_BOOK_CHAPTER", {self.bookId}, getChaptersCallback)
        end
    end

    local function combineItemClick()
        Global:instance():TDGAonEventAndEventData("adventure10")
        local conf = skilldata:getSkillConfig(self.bookId)
        local flag = chapterdata:skillCanCombine(self.bookId)
        if not flag then
            ShowText(HLNSLocalizedString("chapter.needBook"))
        else
            doActionFun("COMBINE_CHAPTER", {self.bookId}, combineSkillCallback, combineErrorCallback)
        end
    end

    local combineItem = tolua.cast(ChapterViewOwner["combineItem"], "CCMenuItemImage")
    combineItem:registerScriptTapHandler(combineItemClick)

    local conf = skilldata:getSkillConfig(self.bookId)
    local skillName = tolua.cast(ChapterViewOwner["skillName"], "CCLabelTTF")
    skillName:setString(conf.name)

    local skillFrame = tolua.cast(ChapterViewOwner["skillFrame"], "CCMenuItemImage")
    skillFrame:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", conf.rank)))
    skillFrame:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", conf.rank)))
    skillFrame:registerScriptTapHandler(skillItemClick)

    local skillIcon = tolua.cast(ChapterViewOwner["skillIcon"], "CCSprite")
    skillIcon:setVisible(false)
    local res = wareHouseData:getItemResource(self.bookId)
    if res.icon then
        local texture = CCTextureCache:sharedTextureCache():addImage(res.icon)
        if texture then
            skillIcon:setTexture(texture)
            skillIcon:setVisible(true)
        end
    end


    local chapterNum = conf.chapternum
    local layer = tolua.cast(ChapterViewOwner["layer_"..chapterNum], "CCLayer")
    layer:setVisible(true)
    local menu = tolua.cast(ChapterViewOwner["menu_"..chapterNum], "CCMenu")
    menu:setVisible(true)

    for i=1,chapterNum do
        local label = tolua.cast(ChapterViewOwner[string.format("%d_%d_count", chapterNum, i)], "CCLabelTTF")
        local count = 0
        local chapterPre = string.gsub(self.bookId, "book", "chapter")
        if chapterdata.chapters[self.bookId][string.format("%s_%02d", chapterPre, i)] then
            count = chapterdata.chapters[self.bookId][string.format("%s_%02d", chapterPre, i)]
        end
        label:setString(tostring(count))
        local item = tolua.cast(ChapterViewOwner[string.format("%d_%d_chapterItem", chapterNum, i)], "CCMenuItemImage")
        item:registerScriptTapHandler(chapterClick)
        -- renzhan
        if count == 0 then
            local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
            cache:addSpriteFramesWithFile("ccbResources/treasureCard.plist")
            local light = CCSprite:createWithSpriteFrameName("treasureCard_roundFrame_1.png")
            local animFrames = CCArray:create()
            for j = 1, 3 do
                local frameName = string.format("treasureCard_roundFrame_%d.png",j)
                local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(frameName)
                animFrames:addObject(frame)
            end
            local animation = CCAnimation:createWithSpriteFrames(animFrames, 0.2)
            local animate = CCAnimate:create(animation)
            light:runAction(CCRepeatForever:create(animate))
            item:addChild(light)
            light:setPosition(ccp(item:getContentSize().width / 2,item:getContentSize().height / 2))
        end
        -- 
    end

end

function createChapterLayer(bookId)
    local _chapterLayer = chapterLayer.new()
    _chapterLayer.bookId = bookId
    _chapterLayer:refresh()


    local function _onEnter()
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


    _chapterLayer:registerScriptHandler(_layerEventHandler)

    return _chapterLayer
end