local _layer
local _contentLayer
local _tableView
local _bTableViewTouch
local tipsHero

-- ·名字不要重复
AwakeSecondViewOwner = AwakeSecondViewOwner or {}
ccb["AwakeSecondViewOwner"] = AwakeSecondViewOwner

local function _addTableView()
    
    AwakeSecondInCellOwner = AwakeSecondInCellOwner or {}
    ccb["AwakeSecondInCellOwner"] = AwakeSecondInCellOwner

    local width  = _contentLayer:getContentSize().width 
    local height = _contentLayer:getContentSize().height 
    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(  width , height )
        elseif fn == "cellAtIndex" then
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            local  proxy = CCBProxy:create()
            local  _hbCell  = tolua.cast(CCBReaderLoad("ccbResources/AwakeSecondInCell.ccbi", proxy, true, "AwakeSecondInCellOwner"), "CCLayer")
            
            if awakedata.data.currTaskId and awakedata.data then -- 第一次开始任务对话完显示
                local taskid = awakedata.data.currTaskId  --任务ID
                local heroconf -- 第几个任务配置 下面每条信息均来自本配置
                local heros = herodata:getHeroInfoById(herodata:getHeroIdByUId(awakedata.data.currWakeHero)) -- 获取觉醒伙伴
                if heros and heros.rank == 4 then
                    heroconf = ConfigureStorage.awave_goldmission[tostring(taskid)] --紫卡升金卡配置
                else
                    heroconf = ConfigureStorage.bluemission[tostring(taskid)] --蓝卡升紫卡配置
                end
                local datas
                if awakedata.data.wakeRecord then
                    datas = awakedata.data.wakeRecord[tostring(taskid)].data --物品信息
                    print("-------------datas------------------")
                    PrintTable(datas)
                end 
                local changeConf = heroconf["function"] --目标功能
                local stageId = heroconf.stageID        --关卡
                local times = heroconf.times            --次数
                local stage = heroconf.stage            --阶段
                local stageNum = heroconf.stageNum      --总阶段数
                local specialloot = heroconf.specialloot--掉落
                local taskname = heroconf.missioname    --任务名称
                local tasklabel = tolua.cast(AwakeSecondInCellOwner["tasklabel"], "CCLabelTTF")--任务名称
                tasklabel:setString(HLNSLocalizedString("adventure.awake.taskName"))
                local contentlabel = tolua.cast(AwakeSecondInCellOwner["contentlabel"], "CCLabelTTF")--任务内容
                contentlabel:setString(HLNSLocalizedString("adventure.awake.contName"))
                local rewardlabel = tolua.cast(AwakeSecondInCellOwner["rewardlabel"], "CCLabelTTF")--任务奖励
                rewardlabel:setString(HLNSLocalizedString("adventure.awake.rewardName"))
                local heroRank = tolua.cast(AwakeSecondInCellOwner["heroRank"], "CCSprite")-- 觉醒后的人物 最后一个任务的奖励显示
                local heroSprite = tolua.cast(AwakeSecondInCellOwner["heroSprite"], "CCSprite") 
                heroRank:setVisible(false)
                heroSprite:setVisible(false)
                heroRank:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", heros.rank + 1)))
                local conf = herodata:getHeroConfig(heros.heroId)
                if conf then
                    local f = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(herodata:getHeroHeadByHeroId(heros.heroId))
                    if f then
                        heroSprite:setDisplayFrame(f)
                    end
                end
                
                -- 任务名字
                if taskname then
                    local taskdeclabel = tolua.cast(AwakeSecondInCellOwner["taskdeclabel"], "CCLabelTTF")
                    taskdeclabel:setString(taskname)
                end
                -- 任务内容
                
                if heroconf.type == 1 then
                    local contentdeclabel = tolua.cast(AwakeSecondInCellOwner["contentdeclabel"], "CCLabelTTF")
                    local dic = {}  -- 遍历收集的物品            
                    for k,v in pairs(datas) do
                        dic[v.itemId] = v.taskCount
                    end
                    
                    local collect = HLNSLocalizedString("adventure.awake.ChallengeCount") -- 拼接所有收集的物品及数量
                    for k,v in pairs(specialloot) do
                        local itemName
                        if ConfigureStorage.shadowData[k] then
                            itemName = ConfigureStorage.shadowData[k].name
                        elseif ConfigureStorage.skillConfig[k] then
                            itemName = ConfigureStorage.skillConfig[k].name
                        elseif ConfigureStorage.item[k] then
                            itemName = ConfigureStorage.item[k].name
                        elseif equipdata:getEquipConfig(k) then
                            itemName = equipdata:getEquipConfig(k).name
                        elseif k == "gold" then
                            itemName = HLNSLocalizedString("金币")
                        elseif k == "silver" then
                            itemName = HLNSLocalizedString("贝里")
                        end
                        collect = collect .. v.demand .. HLNSLocalizedString("adventure.awake.Count") .. itemName
                        .. HLNSLocalizedString("adventure.awake.Tasks",dic[k],v.demand)
                    end
                    if changeConf == "Gspot" then
                        local stagename = awakedata:getChallengeNameItem(stageId)
                        contentdeclabel:setString(HLNSLocalizedString("adventure.awake.Gspot",stagename) .. collect)
                    elseif changeConf == "ptstage" then
                        local str = string.split(stageId,"_")
                        local stagename = awakedata:getChallengeNameItem(stageId)
                        contentdeclabel:setString(HLNSLocalizedString("adventure.awake.Ptstage",tonumber(str[2]),tonumber(str[3])) .. collect)
                    elseif changeConf == "Elitestage" then
                        local str =  string.split(stageId, "_")
                        local stagename = awakedata:getChallengeNameItem(stageId)
                        contentdeclabel:setString(HLNSLocalizedString("adventure.awake.Elitestage",tonumber(str[2]),tonumber(str[3])) .. collect)
                    elseif changeConf == "devil" then
                        contentdeclabel:setString(HLNSLocalizedString("adventure.awake.Devil") .. collect)
                    elseif changeConf == "haze" then
                        contentdeclabel:setString(HLNSLocalizedString("adventure.awake.Haze") .. collect)
                    elseif changeConf == "risk" then
                        if stageId == 1 then
                            contentdeclabel:setString(HLNSLocalizedString("adventure.awake.NearRisk") .. collect)
                        elseif stageId == 2 then
                            contentdeclabel:setString(HLNSLocalizedString("adventure.awake.FarRisk") .. collect)
                        else
                            contentdeclabel:setString(HLNSLocalizedString("adventure.awake.GhostRisk") .. collect)
                        end
                    end
                elseif heroconf.type == 2 then
                    local contentdeclabel = tolua.cast(AwakeSecondInCellOwner["contentdeclabel"], "CCLabelTTF")
                    if changeConf == "Gspot" then
                        local stagename = awakedata:getChallengeNameItem(stageId)
                        contentdeclabel:setString(HLNSLocalizedString("adventure.awake.Gspots",stagename,times)
                            .. HLNSLocalizedString("adventure.awake.Tasks",datas.taskCount,times))
                    elseif changeConf == "devil" then
                        contentdeclabel:setString(HLNSLocalizedString("adventure.awake.Devils",times)
                            .. HLNSLocalizedString("adventure.awake.Tasks",datas.taskCount,times))
                    elseif changeConf == "risk" then
                        if stageId == 1 then
                            contentdeclabel:setString(HLNSLocalizedString("adventure.awake.Near.Risks",times)
                                .. HLNSLocalizedString("adventure.awake.Tasks",datas.taskCount,times))
                        elseif stageId == 2 then
                            contentdeclabel:setString(HLNSLocalizedString("adventure.awake.Far.Risks",times)
                                .. HLNSLocalizedString("adventure.awake.Tasks",datas.taskCount,times))
                        else
                            contentdeclabel:setString(HLNSLocalizedString("adventure.awake.Ghost.Risks",times)
                                .. HLNSLocalizedString("adventure.awake.Tasks",datas.taskCount,times))
                        end
                    elseif changeConf == "ptstage" then
                        local str = string.split(stageId,"_")
                        local stagename = awakedata:getChallengeNameItem(stageId)
                        contentdeclabel:setString(HLNSLocalizedString("adventure.awake.Ptstage.Count",tonumber(str[2]),tonumber(str[3]),stagename,times)
                         .. HLNSLocalizedString("adventure.awake.Tasks",datas.taskCount,times))
                    elseif changeConf == "Elitestage" then
                        local str =  string.split(stageId, "_")
                        local stagename = awakedata:getChallengeNameItem(stageId)
                        contentdeclabel:setString(HLNSLocalizedString("adventure.awake.Elitestage.Count",tonumber(str[2]),tonumber(str[3]),stagename,times)
                            .. HLNSLocalizedString("adventure.awake.Tasks",datas.taskCount,times))
                    elseif changeConf == "haze" then
                        contentdeclabel:setString(HLNSLocalizedString("adventure.awake.Haze.Count",times)
                            .. HLNSLocalizedString("adventure.awake.Tasks",datas.taskCount,times))
                    elseif changeConf == "risk" then
                        contentdeclabel:setString(HLNSLocalizedString("adventure.awake.Risk.Count",times)
                            .. HLNSLocalizedString("adventure.awake.Tasks",datas.taskCount,times))
                    end
                elseif heroconf.type == 3 then
                    local dic = {}  -- 遍历收集的物品  
                    for k,v in pairs(datas) do
                        dic[v.itemId] = v.taskCount
                    end

                    local collect = HLNSLocalizedString("adventure.awake.ChallengeCount") -- 拼接所有收集的物品及数量
                    for k,v in pairs(heroconf.collect) do
                        local itemName
                        if ConfigureStorage.shadowData[k] then
                            itemName = ConfigureStorage.shadowData[k].name
                        elseif ConfigureStorage.skillConfig[k] then
                            itemName = ConfigureStorage.skillConfig[k].name
                        elseif ConfigureStorage.item[k] then
                            itemName = ConfigureStorage.item[k].name
                        elseif equipdata:getEquipConfig(k) then
                            itemName = equipdata:getEquipConfig(k).name
                        elseif k == "gold" then
                            itemName = HLNSLocalizedString("金币")
                        elseif k == "silver" then
                            itemName = HLNSLocalizedString("贝里")
                        end
                        collect = collect .. v .. HLNSLocalizedString("adventure.awake.Count") .. itemName
                        .. HLNSLocalizedString("adventure.awake.Tasks",dic[k],v)
                        
                    end
                    local contentdeclabel = tolua.cast(AwakeSecondInCellOwner["contentdeclabel"], "CCLabelTTF")
                    contentdeclabel:setString(collect)
                elseif heroconf.type == 4 then
                    local contentdeclabel = tolua.cast(AwakeSecondInCellOwner["contentdeclabel"], "CCLabelTTF")
                    contentdeclabel:setString(HLNSLocalizedString("adventure.awake.Sing",times)
                        .. HLNSLocalizedString("adventure.awake.Tasks",datas.taskCount,times))
                elseif heroconf.type == 5 then
                    local contentdeclabel = tolua.cast(AwakeSecondInCellOwner["contentdeclabel"], "CCLabelTTF")
                    contentdeclabel:setString(HLNSLocalizedString("adventure.awake.Drink",times)
                        .. HLNSLocalizedString("adventure.awake.Tasks",datas.taskCount,times))
                elseif heroconf.type == 6 then
                    local contentdeclabel = tolua.cast(AwakeSecondInCellOwner["contentdeclabel"], "CCLabelTTF")
                    contentdeclabel:setString(HLNSLocalizedString("adventure.awake.Compose",times)
                        .. HLNSLocalizedString("adventure.awake.Tasks",datas.taskCount,times))
                elseif heroconf.type == 7 then
                    local contentdeclabel = tolua.cast(AwakeSecondInCellOwner["contentdeclabel"], "CCLabelTTF")
                    contentdeclabel:setString(HLNSLocalizedString("adventure.awake.Kiss",times)
                        .. HLNSLocalizedString("adventure.awake.Tasks",datas.taskCount,times))
                end
                -- 任务奖励
                local contentdeclabel = tolua.cast(AwakeSecondInCellOwner["contentdeclabel"], "CCLabelTTF")
                local contentlabel_Height = contentdeclabel:getContentSize().height
                local contentlabelX,contentlabelY= contentdeclabel:getPosition()
                rewardlabel:setPositionY(contentlabelY - contentlabel_Height - 20)
                
                local rewardCount = awakedata:getRewardCount() -- 奖励物品数
                local reward = heroconf.reward                 -- 任务奖励
                
                local rewardkey = {}
                local rewardvalue = {}
                if reward then
                    for k,v in pairs(reward) do
                        local name = wareHouseData:getItemResource(k).name
                        rewardkey[#rewardkey + 1] = name
                        rewardvalue[#rewardvalue + 1] = v
                    end
                end
                
                local rewarddec1label = tolua.cast(AwakeSecondInCellOwner["rewarddec1label"], "CCLabelTTF")
                local rewardX,rewardY = rewardlabel:getPosition()
                rewarddec1label:setPositionY(rewardY)
                heroRank:setPositionY(rewardY - 70)
                heroSprite:setPositionY(rewardY - 70)
                local rewarddec2label = tolua.cast(AwakeSecondInCellOwner["rewarddec2label"], "CCLabelTTF")
                rewarddec2label:setPositionY(rewardY - 30)
                local rewarddec3label = tolua.cast(AwakeSecondInCellOwner["rewarddec3label"], "CCLabelTTF")
                rewarddec3label:setPositionY(rewardY - 60)
                local rewarddec4label = tolua.cast(AwakeSecondInCellOwner["rewarddec4label"], "CCLabelTTF")
                rewarddec4label:setPositionY(rewardY - 90)
                local rewarddec5label = tolua.cast(AwakeSecondInCellOwner["rewarddec5label"], "CCLabelTTF")
                rewarddec5label:setPositionY(rewardY - 120)
                if rewardCount == 5 then
                    rewarddec1label:setString(HLNSLocalizedString("adventure.awake.Reward",rewardkey[1],rewardvalue[1]))
                    rewarddec2label:setString(HLNSLocalizedString("adventure.awake.Reward",rewardkey[2],rewardvalue[2]))
                    rewarddec3label:setString(HLNSLocalizedString("adventure.awake.Reward",rewardkey[3],rewardvalue[3]))
                    rewarddec4label:setString(HLNSLocalizedString("adventure.awake.Reward",rewardkey[4],rewardvalue[4]))
                    rewarddec5label:setString(HLNSLocalizedString("adventure.awake.Reward",rewardkey[5],rewardvalue[5]))
                elseif rewardCount == 3 then
                    rewarddec1label:setString(HLNSLocalizedString("adventure.awake.Reward",rewardkey[1],rewardvalue[1]))
                    rewarddec2label:setString(HLNSLocalizedString("adventure.awake.Reward",rewardkey[2],rewardvalue[2]))
                    rewarddec3label:setString(HLNSLocalizedString("adventure.awake.Reward",rewardkey[3],rewardvalue[3]))
                    rewarddec4label:setString("")
                    rewarddec5label:setString("")
                elseif rewardCount == 4 then
                    rewarddec1label:setString(HLNSLocalizedString("adventure.awake.Reward",rewardkey[1],rewardvalue[1]))
                    rewarddec2label:setString(HLNSLocalizedString("adventure.awake.Reward",rewardkey[2],rewardvalue[2]))
                    rewarddec3label:setString(HLNSLocalizedString("adventure.awake.Reward",rewardkey[3],rewardvalue[3]))
                    rewarddec4label:setString(HLNSLocalizedString("adventure.awake.Reward",rewardkey[4],rewardvalue[4]))
                    rewarddec5label:setString("")
                elseif rewardCount == 0 and awakedata.data.currTaskId ~= 1 then
                    heroRank:setVisible(true)
                    heroSprite:setVisible(true)
                    rewarddec1label:setString(" ")
                    rewarddec2label:setString(" ")
                    rewarddec3label:setString(" ")
                    rewarddec4label:setString(" ")
                    rewarddec5label:setString(" ")
                end
                
                -- 阶段数 任务数 
                local rewardlabelX,rewardlabelY = rewarddec5label:getPosition()
                local stagelabel = tolua.cast(AwakeSecondInCellOwner["stagelabel"], "CCLabelTTF")
                stagelabel:setPositionY(rewardY - 155)
                local heros = herodata:getHeroInfoById(herodata:getHeroIdByUId(awakedata.data.currWakeHero))
                if heros and heros.rank == 4 then           --如果觉醒则更换配置
                    local taskNum = awakedata:getTaskPurpleNum()
                    local missionID = heroconf.missionID    --紫升金第几个任务
                    stagelabel:setString(HLNSLocalizedString("adventure.awake.Awakestage",stage,stageNum,missionID,taskNum))
                else
                    local taskNum = awakedata:getTaskNum()   -- 现阶段的任务数
                    local taskNow = awakedata:getTaskNowNum()-- 当前第几个任务
                    stagelabel:setString(HLNSLocalizedString("adventure.awake.Awakestage",stage,stageNum,taskNow,taskNum))
                end
            end
            a2:addChild(_hbCell, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            r = a2
        elseif fn == "numberOfCells" then
            r = 1
        elseif fn == "cellTouchBegan" then
            getAdventureLayer():pageViewTouchEnabled(true)
            _bTableViewTouch = true
        elseif fn == "cellTouchEnded" then
            if _bTableViewTouch then
                getAdventureLayer():pageViewTouchEnabled(true)
                _bTableViewTouch = false
            end
        elseif fn == "cellHighlight" then
        elseif fn == "cellUnhighlight" then
        elseif fn == "cellWillRecycle" then
        elseif fn == "scroll" then   
            if _bTableViewTouch then
                getAdventureLayer():pageViewTouchEnabled(false)
            end
        end
        return r
    end)
    local size = CCSizeMake( width, height)  
    _tableView = LuaTableView:createWithHandler(h, size)
    _tableView:setBounceable(true)
    _tableView:setAnchorPoint(ccp(0,0))
    _tableView:setPosition(0,0)
    _tableView:setVerticalFillOrder(0)
    _contentLayer:addChild(_tableView,1000)
    _tableView:reloadData()
end

local function refreshawakeSecondLayer()

    -- 刷新判断 任务是否完成
    if awakedata.data.wakeRecord then
        awakedata:isFinishTask()
    end

    if awakedata.data.currWakeHero == "" or awakedata.data == "" then
        local head5 = tolua.cast(AwakeSecondViewOwner["head5"], "CCSprite")
        head5:setVisible(false)
    else
        awakedata.heros = herodata:getHeroInfoByHeroUId(awakedata.data.currWakeHero)
        local head5 = tolua.cast(AwakeSecondViewOwner["head5"], "CCSprite")
        local heroId = awakedata.heros.heroId
        
        local conf = herodata:getHeroConfig(heroId)
        if conf then
            local f = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(herodata:getHeroHeadByHeroId(heroId))
            if f then
                head5:setVisible(true)
                head5:setDisplayFrame(f)
            end
        end
    end
    local closeBtn = tolua.cast(AwakeSecondViewOwner["closeBtn"], "CCMenuItemImage")
    local abandonBtn = tolua.cast(AwakeSecondViewOwner["abandonBtn"],"CCMenuItemImage")
    local beginBtn = tolua.cast(AwakeSecondViewOwner["beginBtn"],"CCMenuItemImage")
    local accomplishBtn = tolua.cast(AwakeSecondViewOwner["accomplishBtn"],"CCMenuItemImage")
    local gotaskBtn = tolua.cast(AwakeSecondViewOwner["gotaskBtn"],"CCMenuItemImage")
    local startSprite = tolua.cast(AwakeSecondViewOwner["startSprite"],"CCSprite")
    local goTaskSprite = tolua.cast(AwakeSecondViewOwner["goTaskSprite"],"CCSprite")
    local finishSprite = tolua.cast(AwakeSecondViewOwner["finishSprite"],"CCSprite")
    local abadonSprite = tolua.cast(AwakeSecondViewOwner["abadonSprite"],"CCSprite")
    
    beginBtn:setVisible(false)
    startSprite:setVisible(false)
    goTaskSprite:setVisible(false)
    finishSprite:setVisible(false) 
    abadonSprite:setVisible(false)
    --任务ID
    local taskid = awakedata.data.currTaskId
    local taskRead
    if awakedata.data.wakeRecord then
        taskRead = awakedata.data.wakeRecord[tostring(taskid)].taskRead
    end
    
    if awakedata.data.currWakeHero == "" or awakedata.data == "" then
        local guide = tolua.cast(AwakeSecondViewOwner["guide"], "CCSprite")
        local chooseLabel = tolua.cast(AwakeSecondViewOwner["chooseLabel"], "CCLabelTTF")
        local headIcon5Btn = tolua.cast(AwakeSecondViewOwner["headIcon5Btn"],"CCMenuItem")
        headIcon5Btn:setEnabled(true)
        guide:setVisible(true) 
        chooseLabel:setVisible(true)
        gotaskBtn:setVisible(false)
        abandonBtn:setVisible(false)
        accomplishBtn:setVisible(false)
        beginBtn:setVisible(false)
    else
        local headIcon5Btn = tolua.cast(AwakeSecondViewOwner["headIcon5Btn"],"CCMenuItem")
        headIcon5Btn:setEnabled(false)
        if not taskRead or taskRead == 0 then -- 任务开始之前
            -- 第一次进入任务栏不显示
            if awakedata.data.currTaskId == 1 then
            _contentLayer:setVisible(false)
            end
            local guide = tolua.cast(AwakeSecondViewOwner["guide"], "CCSprite")
            local chooseLabel = tolua.cast(AwakeSecondViewOwner["chooseLabel"], "CCLabelTTF")
            
            guide:setVisible(false) 
            chooseLabel:setVisible(false)
            _contentLayer:setVisible(true)
            _tableView:reloadData()
            gotaskBtn:setVisible(false)
            abandonBtn:setVisible(false)
            accomplishBtn:setVisible(false)
            beginBtn:setVisible(true)
            startSprite:setVisible(true)
        else
            if awakedata.isTaskSuccess then -- 任务完成
                local guide = tolua.cast(AwakeSecondViewOwner["guide"], "CCSprite")
                local chooseLabel = tolua.cast(AwakeSecondViewOwner["chooseLabel"], "CCLabelTTF")
                guide:setVisible(false)
                chooseLabel:setVisible(false)
                _contentLayer:setVisible(true)
                _tableView:reloadData()
                gotaskBtn:setVisible(false)
                abandonBtn:setVisible(false)
                accomplishBtn:setVisible(true)
                beginBtn:setVisible(false)
                finishSprite:setVisible(true)
            else -- 前往任务 放弃任务
                local guide = tolua.cast(AwakeSecondViewOwner["guide"], "CCSprite")
                local chooseLabel = tolua.cast(AwakeSecondViewOwner["chooseLabel"], "CCLabelTTF")
                guide:setVisible(false)
                chooseLabel:setVisible(false)
                _contentLayer:setVisible(true)
                _tableView:reloadData()
                gotaskBtn:setVisible(true)
                abandonBtn:setVisible(true)
                accomplishBtn:setVisible(false)
                beginBtn:setVisible(false)
                goTaskSprite:setVisible(true)
                abadonSprite:setVisible(true)
            end
        end
    end
end
-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/awakeSecondView.ccbi",proxy, true,"AwakeSecondViewOwner")
    _layer = tolua.cast(node,"CCLayer")
    _contentLayer = tolua.cast(AwakeSecondViewOwner["contentLayer"],"CCLayer")
    _contentLayer:setVisible(false)

    _addTableView()
    
    local showHead = ConfigureStorage.awave_show
    tipsHero = {}
    for k,v in pairs(showHead) do
        tipsHero[#tipsHero + 1] = v
    end

    
    local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
    for i=1,5 do
        local dic = tipsHero[i]
        if dic then
            local conf = herodata:getHeroConfig(dic.ID)
            local item = tolua.cast(AwakeSecondViewOwner["headIcon" .. (i - 1) .. "Btn"], "CCMenuItemImage")
            item:setNormalSpriteFrame(cache:spriteFrameByName(herodata:getHeroHeadByHeroId(dic.ID)))
            item:setSelectedSpriteFrame(cache:spriteFrameByName(herodata:getHeroHeadByHeroId(dic.ID)))
            local frame = tolua.cast(AwakeSecondViewOwner["frame" .. (i - 1)],"CCSprite") 
            frame:setDisplayFrame(cache:spriteFrameByName(string.format("frame_%d.png", 5)))
            item:setTag(i)
        else
            local item = tolua.cast(AwakeSecondViewOwner["headIcon" .. (i - 1) .. "Btn"], "CCMenuItemImage")
            local frame = tolua.cast(AwakeSecondViewOwner["frame" .. (i - 1)],"CCSprite") 
            item:setVisible(false)
            frame:setVisible(false)
        end
    end

    local closeBtn = tolua.cast(AwakeSecondViewOwner["closeBtn"], "CCMenuItemImage")
    local abandonBtn = tolua.cast(AwakeSecondViewOwner["abandonBtn"],"CCMenuItemImage")
    local beginBtn = tolua.cast(AwakeSecondViewOwner["beginBtn"],"CCMenuItemImage")
    local accomplishBtn = tolua.cast(AwakeSecondViewOwner["accomplishBtn"],"CCMenuItemImage")
    local gotaskBtn = tolua.cast(AwakeSecondViewOwner["gotaskBtn"],"CCMenuItemImage")
    local startSprite = tolua.cast(AwakeSecondViewOwner["startSprite"],"CCSprite")
    local goTaskSprite = tolua.cast(AwakeSecondViewOwner["goTaskSprite"],"CCSprite")
    local finishSprite = tolua.cast(AwakeSecondViewOwner["finishSprite"],"CCSprite")
    local abadonSprite = tolua.cast(AwakeSecondViewOwner["abadonSprite"],"CCSprite") 
    local head5 = tolua.cast(AwakeSecondViewOwner["head5"], "CCSprite")
    local guide = tolua.cast(AwakeSecondViewOwner["guide"], "CCSprite")
    
    local array = CCArray:create()
    array:addObject(CCDelayTime:create(0.2))
    array:addObject(CCFadeTo:create(0.05, 255))
    array:addObject(CCDelayTime:create(0.2))
    local move1 = CCMoveBy:create(0.1, ccp(0, 10))
    local move2 = CCMoveBy:create(0.1, ccp(0, -10))
    local fadeOut = CCFadeTo:create(0.05, 240)
    local spawn1 = CCSpawn:createWithTwoActions(move1, fadeOut)
    local spawn2 = CCSpawn:createWithTwoActions(move2, fadeOut)
    array:addObject(spawn1)
    array:addObject(CCDelayTime:create(0.1))
    array:addObject(spawn2)
    guide:runAction(CCRepeatForever:create(CCSequence:create(array)))

    local chooseLabel = tolua.cast(AwakeSecondViewOwner["chooseLabel"], "CCLabelTTF")
    guide:setVisible(true) 
    chooseLabel:setVisible(false)
    head5:setVisible(false) 
    gotaskBtn:setVisible(false)
    abandonBtn:setVisible(false)
    accomplishBtn:setVisible(false)
    beginBtn:setVisible(false)
    startSprite:setVisible(false)
    goTaskSprite:setVisible(false)
    finishSprite:setVisible(false) 
    abadonSprite:setVisible(false)
end

-- 该方法名字每个文件不要重复
function getAwakeSecondLayer()
	return _layer
end
local function headIconClicked(tag, sender)
    local dic = tipsHero[tag]
    getMainLayer():addChild(createHeroInfoLayer(dic.ID, HeroDetail_Clicked_ShowHero, -135), 100)
end
AwakeSecondViewOwner["headIconClicked"] = headIconClicked

-- 详情
local function infoClick()
    local awave_help2 = ConfigureStorage.awave_help2
    local temp = {}
    local decc = {}
    local  function getMyDescription()
        for k,v in pairs(awave_help2) do
            table.insert(decc,k)
        end
        table.sort(decc)
        for k,v in pairs(decc) do
            table.insert(temp,awave_help2[v].said)
        end
        return temp
    end
    description = getMyDescription()
    getMainLayer():getParent():addChild(createCommonHelpLayer(description, -132))
end
AwakeSecondViewOwner["infoClick"] = infoClick
--选择英雄
function onChooseHeroClicked()
    local _herosData = herodata:getAllAwakeHeroes() 
    if #_herosData == 0 and not herodata.heroes[index] then
        local function havaExpcardConfirmAction()
        end
        local function havaExpcardCancelAction()
        end
        getMainLayer():addChild(createSimpleConfirCardLayer(HLNSLocalizedString("adventure.awake.NeedHero"),
                    HLNSLocalizedString("adventure.awake")))
        SimpleConfirmCard.confirmMenuCallBackFun = havaExpcardConfirmAction
        SimpleConfirmCard.cancelMenuCallBackFun = havaExpcardCancelAction
    else
        if getMainLayer() then
            getMainLayer():addChild(createAwakeChooseHeroLayer(-140), 100)
        end
    end
end
AwakeSecondViewOwner["onChooseHeroClicked"] = onChooseHeroClicked

--放弃按钮回调
local function onAbandonCallBack( url,rtnData )
    if rtnData["code"] == 200 then
        awakedata:fromDic(rtnData["info"]["wakeUp"])
        _contentLayer:setVisible(false)
        refreshawakeSecondLayer()
        local head5 = tolua.cast(AwakeSecondViewOwner["head5"], "CCSprite")
        head5:setVisible(false)
    end
end

function onAbandonClicked()
    local conAbandon = false
    local function havaExpcardConfirmAction()
        conAbandon = true
        if conAbandon then
            doActionFun("AWAKEN_GIVEUP",{},onAbandonCallBack)
        end
    end
    local function havaExpcardCancelAction()
    end
    getMainLayer():addChild(createSimpleConfirCardLayer(HLNSLocalizedString("adventure.awake.AbandonDec"),
                HLNSLocalizedString("adventure.awake.Abandon?")))
    SimpleConfirmCard.confirmMenuCallBackFun = havaExpcardConfirmAction
    SimpleConfirmCard.cancelMenuCallBackFun = havaExpcardCancelAction
end
AwakeSecondViewOwner["onAbandonClicked"] = onAbandonClicked

local function onBeginCallBackRead()
    local taskid = awakedata.data.currTaskId
    local talkConf -- 配置
    local heros = herodata:getHeroInfoById(herodata:getHeroIdByUId(awakedata.data.currWakeHero))
    if heros and heros.rank == 4 then
        talkConf = ConfigureStorage.awave_goldmission[tostring(taskid)] --蓝卡觉醒紫卡后英雄的配置
    else
        talkConf = ConfigureStorage.bluemission[tostring(taskid)]
    end

    if not talkConf or talkConf.talknum <= 0 then
        refreshawakeSecondLayer()
        return
    end

    local function readCallback()
        if awakedata.data.wakeRecord then
            awakedata.data.wakeRecord[tostring(taskid)].taskRead = 1
        end
        getMainLayer():getParent():addChild(createAwakeTalkLayer(talkConf, awakedata.heros, 
            refreshawakeSecondLayer))
    end
    doActionFun("AWAKEN_READDIALOGUE",{awakedata.data.currTaskId}, readCallback)
end

--开始按钮回调
local function onBeginCallBack( url,rtnData )
    if rtnData["code"] == 200 then
        awakedata:fromDic(rtnData["info"]["wakeUp"])
        onBeginCallBackRead()
    end
end

function onBeginClicked()
    if awakedata.data.currTaskId then
        refreshawakeSecondLayer()
    end
    if awakedata.data.currTaskId == nil then
        doActionFun("AWAKEN_BEGIN",{awakedata.data.currWakeHero}, onBeginCallBack)
    else
        onBeginCallBackRead()
    end
end
AwakeSecondViewOwner["onBeginClicked"] = onBeginClicked

-- 前往任务
function onGoTaskClicked()
   awakedata:goTaskChallenge()
end
AwakeSecondViewOwner["onGoTaskClicked"] = onGoTaskClicked

--完成按钮回调
local function onFinishCallBack( url,rtnData )
    if rtnData["code"] == 200 then
       awakedata:fromDic(rtnData["info"]["wakeUp"])
       --伙伴召唤门
       local heros = herodata:getHeroInfoById( awakedata.heros.heroId )
       refreshawakeSecondLayer()
       -- 完成全部任务rtnData["info"].awakening >= 1
       if heros and heros.wake ~= 0 and rtnData["info"].awakening ~= 0 then
           _contentLayer:setVisible(false)
           runtimeCache.recruitOption = 1
           palyCallingAnimationOfHeroOnNode2(heros.confId, false, heros.rank, nil, nil, 0, getMainLayer(), false)
       end
    end
end

function onAccomplishClicked()
    doActionFun("AWAKEN_FINISH", {awakedata.data.currTaskId}, onFinishCallBack)
end
AwakeSecondViewOwner["onAccomplishClicked"] = onAccomplishClicked

function closeItemClick()
    showAdventureFromAwake()
end
AwakeSecondViewOwner["closeItemClick"] = closeItemClick

function createAwakeSecondLayer()
    _init()
    function _layer:refreshawakeSecondLayer()
        refreshawakeSecondLayer()
    end
    
    local function _onEnter()
        addObserver(NOTI_AWAKEN_CHOOSE, refreshawakeSecondLayer)
        refreshawakeSecondLayer()
    end

    function _layer:close()
        closeItemClick()
    end

    local function _onExit()
        removeObserver(NOTI_AWAKEN_CHOOSE, refreshawakeSecondLayer)
        if getMainLayer() then
            getMainLayer():TitleBgVisible(true)
        end
        _bTableViewTouch = false
        _layer = nil
        _tableView = nil
        _contentLayer = nil
        tipsHero = nil
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