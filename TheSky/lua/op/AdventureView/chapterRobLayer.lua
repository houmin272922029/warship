local _layer
local _robDic
local _chapterId
local _bookId

-- ·名字不要重复
ChapterRobViewOwner = ChapterRobViewOwner or {}
ccb["ChapterRobViewOwner"] = ChapterRobViewOwner


local function _refresh()
    for i=1,3 do

        local dic = _robDic[tostring(i - 1)]
        local enemy = tolua.cast(ChapterRobViewOwner["enemy"..i], "CCSprite")
        if dic then
            enemy:setVisible(true)
            local name = tolua.cast(ChapterRobViewOwner["name"..i], "CCLabelTTF")
            name:setString(dic.name)

            local level = tolua.cast(ChapterRobViewOwner["level"..i], "CCLabelTTF")
            level:setString(string.format("LV:%d", dic.level))

            local chapterLabel = tolua.cast(ChapterRobViewOwner["chapter"..i], "CCLabelTTF")
            
            local chapterId = dic.frag
            local chapterName = wareHouseData:getItemConfig(chapterId).name
            
            chapterLabel:setString(HLNSLocalizedString("chapter.name", string.sub(chapterId, -1)))
            for j=0,2 do
                local hid = dic.info.form[tostring(j)]
                if hid then
                    local hero = dic.info.heros[hid]
                    local conf = herodata:getHeroConfig(hero.heroId)
                    local frame = tolua.cast(ChapterRobViewOwner[string.format("%d_%d_frame", i, j + 1)], "CCSprite")
                    frame:setVisible(true)
                    frame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", herodata:fixRank(conf.rank, hero.wake))))
                    local head = tolua.cast(ChapterRobViewOwner[string.format("%d_%d_head", i, j + 1)], "CCSprite")
                    local f = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(herodata:getHeroHeadByHeroId(hero.heroId))
                    if f then
                        head:setDisplayFrame(f)
                    else
                        head:setVisible(false)
                    end
                end
            end
        end
    end
end

local function backClick()
    getMainLayer():gotoAdventure()
end
ChapterRobViewOwner["backClick"] = backClick

local function chapterFightCallback(url,rtnData)
    runtimeCache.chapterFight.result = rtnData.info.result
    runtimeCache.responseData = rtnData["info"]
    -- local resultType = ResultType.SailWin
    -- local bWin = BattleField.result == RESULT_WIN
    -- if bWin then
    --     resultType = ResultType.SailWin
    -- else
    --     resultType = ResultType.SailLose
    -- end
    -- BattleField.mode = BattleMode.chapter
    -- CCDirector:sharedDirector():replaceScene(CCTransitionFade:create(0.6, FightingResultSceneFun(resultType)))
    CCDirector:sharedDirector():replaceScene(CCTransitionFade:create(0.6, FightingScene()))
end

local function fightClcik(tag)
    RandomManager.cursor = RandomManager.randomRange(0, 999)
    local seed = RandomManager.cursor
    local info = _robDic[tostring(tag - 1)]
    BattleField.leftName = userdata.name
    BattleField.rightName = info.name
    setTheOtherCaptainName(info.name)
    playerBattleData:fromDic(info.info)
    BattleField:chapterFight()
    -- BattleField.result = RESULT_WIN
    local result = BattleField.result == RESULT_WIN and 4 - BattleField.round or 0
    runtimeCache.chapterFight.info = deepcopy(info)
    doActionFun("CHAPTER_BATTLE", {info.id, info.frag, result, seed}, chapterFightCallback)
end
ChapterRobViewOwner["fightClcik"] = fightClcik

local function getChapterEnemiesCallback(url, rtnData)
    _robDic = rtnData["info"]
    _refresh()
end

local function changeClick()
    local array = {_bookId}
    if _chapterId then
        table.insert(array, _chapterId)
    end
    doActionFun("GET_CHAPTER_ENEMIES", array, getChapterEnemiesCallback)
end
ChapterRobViewOwner["changeClick"] = changeClick

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/ChapterRobView.ccbi",proxy, true,"ChapterRobViewOwner")
    _layer = tolua.cast(node,"CCLayer")
end


-- 该方法名字每个文件不要重复
function getChapterRobLayer()
	return _layer
end

function createChapterRobLayer(dic, bookId, chapterId)
    _robDic = dic
    _bookId = bookId
    _chapterId = chapterId
    _init()
    _refresh()

    local function _onEnter()
        print("onEnter")
    end

    local function _onExit()
        print("onExit")
        _layer = nil
        _robDic = nil
        _bookId = nil
        _chapterId = nil
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