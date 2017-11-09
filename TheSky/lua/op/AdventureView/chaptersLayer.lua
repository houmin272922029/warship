local _layer
local _chapters
local _chaptersCount
local _bTableViewTouch
local _selBookId
local tableView = nil

ChaptersViewOwner = ChaptersViewOwner or {}
ccb["ChaptersViewOwner"] = ChaptersViewOwner


local function addTableView()

    -- @param fn string Callback type
    -- @param table LuaTableView
    -- @param a1 & a2 mixed Difference means for every "fn"
    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            local sp = CCSprite:createWithSpriteFrameName("frame_0.png")
            r = CCSizeMake(613, 280)
        elseif fn == "cellAtIndex" then
            -- Return CCTableViewCell, a1 is cell index (zero based), a2 is dequeued cell (maybe nil)
            -- Do something to create cell and change the content
            ChaptersCellOwner = ChaptersCellOwner or {}
            ccb["ChaptersCellOwner"] = ChaptersCellOwner

            local function skillClick(tag)
                local dic = _chapters[tag]
                getMainLayer():getParent():addChild(createChapterDetailInfoLayer(dic.bookId, -134))
            end
            ChaptersCellOwner["skillClick"] = skillClick

            local function getChapterEnemiesCallback(url, rtnData)
                getMainLayer():gotoChapterRob(rtnData["info"], _selBookId) 
            end

            local function robClick(tag)
                local dic = _chapters[tag]
                _selBookId = dic.bookId
                doActionFun("GET_CHAPTER_ENEMIES", {_selBookId}, getChapterEnemiesCallback)
            end
            ChaptersCellOwner["robClick"] = robClick


            local function combineSkillCallback(url,rtnData)
                local conf = skilldata:getSkillConfig(_selBookId)
                palyConvAnimationOnNode(_selBookId,conf.chapternum,true, getAdventureLayer())

                runtimeCache.responseData = rtnData.info
                chapterdata:reduceCombineTime(_selBookId)
                getAdventureLayer():refreshAdventureLayer() 
            end

            local function combineClick(tag)
                local dic = _chapters[tag]
                _selBookId = dic.bookId
                local conf = skilldata:getSkillConfig(_selBookId)
                local flag = chapterdata:skillCanCombine(_selBookId)
                if not flag then
                    ShowText(HLNSLocalizedString("chapter.needBook"))
                else
                    doActionFun("COMBINE_CHAPTER", {_selBookId}, combineSkillCallback)
                end
            end
            ChaptersCellOwner["combineClick"] = combineClick
            
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end

            local proxy = CCBProxy:create()
            local _hbCell = tolua.cast(CCBReaderLoad("ccbResources/ChaptersCell.ccbi",proxy,true,"ChaptersCellOwner"),"CCLayer")
            for i=1,4 do
                local index = a1 * 4 + i
                if index <= _chaptersCount then
                    local dic = _chapters[index]
                    local bookId = dic.bookId
                    local conf = skilldata:getSkillConfig(bookId)

                    local layer = tolua.cast(ChaptersCellOwner["layer_"..i], "CCLayer")
                    layer:setVisible(true)

                    local rankSprite = tolua.cast(ChaptersCellOwner["rankSprite"..i], "CCMenuItemImage")
                    rankSprite:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", conf.rank)))
                    rankSprite:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", conf.rank)))
                    rankSprite:setTag(index)

                    local skillItem = tolua.cast(ChaptersCellOwner["skill"..i], "CCSprite")
                    local res = wareHouseData:getItemResource(bookId)
                    if res.icon then
                        local texture = CCTextureCache:sharedTextureCache():addImage(res.icon)
                        if texture then
                            skillItem:setVisible(true)
                            skillItem:setTexture(texture)
                        end
                    end

                    local robItem = tolua.cast(ChaptersCellOwner["rob"..i], "CCMenuItemImage")
                    local combineItem = tolua.cast(ChaptersCellOwner["combine"..i], "CCMenuItemImage")
                    local robText = tolua.cast(ChaptersCellOwner["rob_t_"..i], "CCSprite")
                    local combineText = tolua.cast(ChaptersCellOwner["combine_t_"..i], "CCSprite")
                    if chapterdata:skillCanCombine(bookId) then
                        combineItem:setVisible(true)
                        combineText:setVisible(true)
                    else
                        robItem:setVisible(true)
                        robText:setVisible(true)
                    end
                    robItem:setTag(index)
                    combineItem:setTag(index)

                    local pro = tolua.cast(ChaptersCellOwner["pro"..i], "CCLabelTTF")
                    pro:setString(string.format("%d/%d", chapterdata:getChapterPro(bookId), conf.chapternum))
                    local name = tolua.cast(ChaptersCellOwner["name"..i], "CCLabelTTF")
                    name:setString(conf.name)

                    local countBg = tolua.cast(ChaptersCellOwner["countBg"..i], "CCSprite")
                    local countLabel = tolua.cast(ChaptersCellOwner["count"..i], "CCLabelTTF")
                    local bookCount = skilldata:getSkillCount(bookId)
                    if bookCount > 0 then
                        countBg:setVisible(true)
                        countLabel:setString(tostring(bookCount))
                    end
                end
            end
            a2:addChild(_hbCell, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            r = a2
        elseif fn == "numberOfCells" then
            return _chaptersCount % 4 == 0 and math.floor(_chaptersCount / 4) or math.floor(_chaptersCount / 4) + 1
        -- Cell events:
        elseif fn == "cellTouched" then         -- A cell was touched, a1 is cell that be touched. This is not necessary.
        elseif fn == "cellTouchBegan" then      -- A cell is touching, a1 is cell, a2 is CCTouch
            getAdventureLayer():pageViewTouchEnabled(true)
            _bTableViewTouch = true
        elseif fn == "cellTouchEnded" then      -- A cell was touched, a1 is cell, a2 is CCTouch
            if _bTableViewTouch then
                getAdventureLayer():pageViewTouchEnabled(true)
                _bTableViewTouch = false
            end
        elseif fn == "cellHighlight" then       -- A cell is highlighting, coco2d-x 2.1.3 or above
        elseif fn == "cellUnhighlight" then     -- A cell had been unhighlighted, coco2d-x 2.1.3 or above
        elseif fn == "cellWillRecycle" then     -- A cell will be recycled, coco2d-x 2.1.3 or above
        elseif fn == "scroll" then
            if _bTableViewTouch then
                getAdventureLayer():pageViewTouchEnabled(false)
            end
        end
        return r
    end)
    local sp = CCSprite:createWithSpriteFrameName("frame_0.png")
    local contentLayer = ChaptersViewOwner["contentLayer"]
    tableView = LuaTableView:createWithHandler(h, contentLayer:getContentSize())
    tableView:setBounceable(true)
    tableView:setAnchorPoint(ccp(0, 0))
    tableView:setPosition(ccp(0, 0))
    tableView:setVerticalFillOrder(0)
    contentLayer:addChild(tableView, 10, 10)
end


-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/ChaptersView.ccbi",proxy, true,"ChaptersViewOwner")
    _layer = tolua.cast(node,"CCLayer")
end


-- 该方法名字每个文件不要重复
function getChaptersLayer()
	return _layer
end

function createChaptersLayer()
    _init()

    local function _onEnter()
        _chapters = chapterdata:getAllChapters()
        _chaptersCount = table.getTableCount(_chapters)
        _bTableViewTouch = false
        addTableView()
    end

    local function _onExit()
        _layer = nil
        _chapters = nil
        _selBookId = nil
        _bTableViewTouch = false
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


    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end