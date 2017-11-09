-- 用户数据缓存

userdata = {
    serverList = nil,       -- 服务器列表
    serverListSort = nil,   -- 服务器列表排序后
    selectServer = nil,     -- 选中服务器
    serverCode = nil,       -- 区服编码
    serverCodes = nil,      -- 最近登陆的服务器
    resListDic,             -- 资源
    cdnRoot,                -- cdn url

    sessionId = "",         -- sessionId
    uid = "",               -- uid
    loginTime,              -- 登陆时间
    servConfVersion = "",   -- conf 版本
    newDay = false,

    dCount = 0,             -- 菊花层 统计

    name = nil,
    flag = nil,
    level = 0,
    exp = 0,
    expMax = 0,
    gold = 0,
    berry = 0,
    strength = 0,           -- 体力
    strengthTime = 0,       -- 上次体力恢复时间
    energy = 0,             --
    energyTime = 0,         --上次精力恢复时间
    form = {},
    sevenForm = {},
    userId = 0,

    weiboBindStatus,        -- 微博绑定状态
    weiboId = nil,          -- 微博id
    weiboToken = nil,       -- 微博token

}

-- 判断是否在审核阶段，如果审核阶段，则把UI上的VIP相关信息隐藏
function userdata:getVipAuditState()
    return not ConfigureStorage.vipIsOpen
end

-- 获取体力上限
function userdata:getStrengthMax()
    return ConfigureStorage.energy[tostring(userdata.level)].strength
end

-- 获取精力上限
function userdata:getEnergyMax()
    return ConfigureStorage.energy[tostring(userdata.level)].energy
end

-- 增加 loading 
function userdata:addDCount()
    -- body
    print("addDCount")
    userdata.dCount = userdata.dCount + 1
    if userdata.dCount > 0 then
        local _scene = CCDirector:sharedDirector():getRunningScene()
        if _scene then
            local __loadingLayer = _scene:getChildByTag(9999)
            if not __loadingLayer then
            _scene:addChild(createLoadingLayer(), 10000, 9999)
            end
        end
    end
end

-- 减少 loading 
function userdata:subDCount()
    -- body
    print("subDcount")
    userdata.dCount = userdata.dCount - 1
    if userdata.dCount < 0 then
        userdata.dCount = 0
    end
    if userdata.dCount <= 0 then
        local _scene = CCDirector:sharedDirector():getRunningScene()
        local __loadingLayer = _scene:getChildByTag(9999)
        if __loadingLayer then
            __loadingLayer:removeFromParentAndCleanup(true)
            __loadingLayer = nil
        end
    end
end

function _checkGuideStep()
    runtimeCache.guideStep = runtimeCache.guideStep + 1 -- 从后端取得已完成的步骤，显示下一步
    if runtimeCache.guideStep <= GUIDESTEP.guideEnd then
        runtimeCache.bGuide = true
    else
        runtimeCache.bGuide = false
    end
    if runtimeCache.bGuide then
        if runtimeCache.guideStep == GUIDESTEP.firstFightResult or runtimeCache.guideStep == GUIDESTEP.firstStageFight then
            -- 上一次断在结算页面
            if table.getTableCount(herodata.form) == 2 then
                runtimeCache.guideStep = GUIDESTEP.secondStageFight
            elseif table.getTableCount(herodata.heroes) == 2 then
                runtimeCache.guideStep = GUIDESTEP.firstGotoTeam
            else
                if storydata.record == "stage_01_01" then
                    runtimeCache.guideStep = GUIDESTEP.firstStageFight
                else
                    runtimeCache.guideStep = GUIDESTEP.gotoRogue
                end
            end
        elseif runtimeCache.guideStep == GUIDESTEP.secondFightResult or runtimeCache.guideStep == GUIDESTEP.secondStageFight then
            if herodata.heroes[herodata.form["1"]].equip["0"] then
                -- 如果已经装备上了
                runtimeCache.guideStep = GUIDESTEP.selectNeedUpdateEquip
            else
                if storydata.record == "stage_01_02" then
                    runtimeCache.guideStep = GUIDESTEP.secondStageFight
                else
                    runtimeCache.guideStep = GUIDESTEP.secondGotoTeam
                end
            end
        elseif runtimeCache.guideStep == GUIDESTEP.recruitResult or runtimeCache.guideStep == GUIDESTEP.recruit then
            -- 上一次断在招募结果页面
            if table.getTableCount(herodata.heroes) == 1 then
                runtimeCache.guideStep = GUIDESTEP.gotoRogue
            elseif table.getTableCount(herodata.form) == 2 then
                runtimeCache.guideStep = GUIDESTEP.secondStageFight
            else
                runtimeCache.guideStep = GUIDESTEP.firstGotoTeam
            end
        elseif (runtimeCache.guideStep == GUIDESTEP.selectHero or runtimeCache.guideStep == GUIDESTEP.confirmHeroSelected or runtimeCache.guideStep == GUIDESTEP.secondGotoSail) then 
            if table.getTableCount(herodata.heroes) == 1 then
                runtimeCache.guideStep = GUIDESTEP.gotoRogue
            elseif table.getTableCount(herodata.form) == 1 then
            -- 上次断在确认上阵伙伴的页面，但是未上阵成功
                runtimeCache.guideStep = GUIDESTEP.onForm
            else
                runtimeCache.guideStep = GUIDESTEP.secondStageFight
            end
        elseif (runtimeCache.guideStep == GUIDESTEP.equipWeapon or runtimeCache.guideStep == GUIDESTEP.selectWeapon or runtimeCache.guideStep == GUIDESTEP.confirmWeaponSelected) then
            if table.getTableCount(herodata.heroes) == 1 then
                runtimeCache.guideStep = GUIDESTEP.recruit
            elseif table.getTableCount(herodata.form) == 1 then
                runtimeCache.guideStep = GUIDESTEP.onForm
            elseif not herodata.heroes[herodata.form["1"]].equip["0"] then
                -- 上次断在上武器，但是未成功
                runtimeCache.guideStep = GUIDESTEP.secondGotoTeam
            else
                runtimeCache.guideStep = GUIDESTEP.selectNeedUpdateEquip
            end
        elseif (runtimeCache.guideStep == GUIDESTEP.selectNeedUpdateEquip 
            or runtimeCache.guideStep == GUIDESTEP.selectUpdateEquip 
            or runtimeCache.guideStep == GUIDESTEP.updateEquip) then
            local dic = equipdata.equips[herodata.heroes[herodata.form["1"]].equip["0"]]
            if dic.level == 1 then
            -- 断在升级装备，还没有升级
                runtimeCache.guideStep = GUIDESTEP.selectNeedUpdateEquip
            else
                runtimeCache.guideStep = GUIDESTEP.gotoHome
            end
        elseif runtimeCache.guideStep == GUIDESTEP.selectNewGiftBag
            or runtimeCache.guideStep == GUIDESTEP.takeGiftBag then
            local count = wareHouseData:getItemCountById("box_007")
            if count > 0 then
            -- 断在领取新手礼包，还没有领取
                runtimeCache.guideStep = GUIDESTEP.selectNewGiftBag
            else
                runtimeCache.guideStep = GUIDESTEP.thirdGotoSail
            end
        end
    end
end


function userdata:fromDictionary(dic)
    userdata.sessionId = dic["sid"]
    userdata.loginTime = dic["now"]
    userdata.newDay = false
    if dic["newday"] then
        userdata.newDay = dic["newday"]
    end
    userdata.servConfVersion = dic["settingVersion"]

    -- 大冒险数据
    blooddata:fromDic(dic["bloodInfo"])

    -- 上方滚动信息
    topRollData:setAllData( dic["publicShareData"] )

    -- renzhan newadd
    loginActivityData.activitys = dic["frontPage"]
    local dicPlayer = dic["player"]
    if not dicPlayer then
        return
    end 

    userdata.userId = dicPlayer.id
    userdata.name = dicPlayer.name
    userdata.level = dicPlayer.level
    userdata.exp = dicPlayer.exp_now
    if not userdata.exp or userdata.exp == "" then
        userdata.exp = 0
    end
    userdata.expMax = dicPlayer.exp_all
    userdata.gold = dicPlayer.gold
    userdata.berry = dicPlayer.silver
    userdata.strength = dicPlayer.strength
    userdata.strengthTime = dicPlayer.strength_time
    userdata.energy = dicPlayer.energy
    userdata.energyTime = dicPlayer.energy_time
    userdata.flag = dicPlayer.flag
    userdata.addEnergyWithGold = {}
    userdata.addItemsWithGold = {}
    if dicPlayer.addEnergyWithGold then
        userdata.addEnergyWithGold = dicPlayer.addEnergyWithGold
    end
    if dicPlayer.addItemsWithGold then
        userdata.addItemsWithGold = dicPlayer.addItemsWithGold
    end
    userdata.firstCashAward1 = dicPlayer.firstCashAward1
    userdata.firstCashAward2 = dicPlayer.firstCashAward2

    -- TODO 其他modula分别调用各自的fromDictionary初始化数据，不缓存在userdata中
    -- 伙伴数据
    herodata.form = dicPlayer.form
    herodata.sevenForm = dicPlayer.form_seven
    herodata.heroes = dicPlayer.heros
    herodata.sevenUpgrade = dicPlayer.seven_upgrade --新增的数据 当前lv等级
    -- 魂魄数据
    heroSoulData.souls = dicPlayer.heroes_soul
    --招募
    recruitData.recruit = dicPlayer.recruit
    -- 关卡
    storydata.record = dicPlayer.storys.record
    storydata.stageData = dicPlayer.storys.stageData
    storydata.pageData = dicPlayer.storys.pageData
    storydata.nextBatchTime = dicPlayer.storys.nextBatchTime
    elitedata:updateData(dicPlayer)
    -- 装备
    equipdata.equips = dicPlayer.equips
    -- 技能
    skilldata.skills = dicPlayer.books

    --仓库数据
    wareHouseData.items = dicPlayer.items
    wareHouseData.equips = dicPlayer.equips
    wareHouseData.books = dicPlayer.books
    if dicPlayer.delayItems then
        wareHouseData.bagDelay = dicPlayer.delayItems
    end

    --战舰
    battleShipData.attrFix = dicPlayer.attrFix

    -- 残章
    chapterdata.chapters = dicPlayer.frags

    -- 称号
    titleData.titles = dicPlayer.titles

    -- 连续登陆奖励
    continueLoginRewardData.data = dicPlayer.login_succession_award

    -- vip
    vipdata.vipScore = dicPlayer.vipScore
    if dicPlayer.vipItems then
        vipdata.vipItems = dicPlayer.vipItems
    else
        vipdata.vipItems = {}
    end

    -- 新增的vip每日奖励
    if dicPlayer.vipDailyItems then
        vipdata.vipDailyItems = dicPlayer.vipDailyItems
    else
        vipdata.vipDailyItems = {}
    end
    
    -- vip礼包
    giftBagData.vipCards = dicPlayer.vipCards

    -- 是否进入新手
    if userdata:getVipAuditState() then
        runtimeCache.guideStep = GUIDESTEP.guideEnd
    else
        runtimeCache.guideStep = not dicPlayer.guideStep and 0 or dicPlayer.guideStep
    end
    _checkGuideStep()
    -- 图鉴
    userdata.roster = dicPlayer.roster

    -- 热气球数据
    hotBalloonData:setHotData(dicPlayer.shakeData)

    -- 邮件
    maildata:fromDic(dicPlayer.mails)

    -- 练影数据
    shadowData.allShadows = dicPlayer.shadows
    shadowData.shadowData = dicPlayer.shadowData

    -- 首充数据
    vipdata.firstCashAward1 = dicPlayer["firstCashAward1"]
    vipdata.firstCashAward2 = dicPlayer["firstCashAward2"]

    marineBranchData.huntTratherData = dicPlayer["huntingTreasure"]
    if dicPlayer["equipShard"] then
        shardData.equipShard = dicPlayer["equipShard"]
    end

    -- 微博数据
    if dicPlayer.shareData and dicPlayer.shareData.weibo then
        userdata.weiboBindStatus = dicPlayer.shareData.weibo.weiboBindStatus
        userdata.weiboId = dicPlayer.shareData.weibo.id
        userdata.weiboToken = dicPlayer.shareData.weibo.token
    end

    -- 月卡的数据
    userdata.monthCardData = dicPlayer.monthCardData
    -- 日常- 弗兰奇之家 装备合成的冷却时间 
    userdata.compoundEquip = dicPlayer.compoundEquip

    userdata.haki = dicPlayer.hotBlood or 0
    -- data = dicPlayer.xx
    -- data.sort = 0
    -- dailyData.daily[Daily_SecretShop] = data
    -- 联盟数据
    -- TODO by lixq

    --talkingdata
    --0,      // 匿名帐户
    --1,     // 显性注册帐户
    --2,      // 新浪微博
    --3,             // QQ帐户
    --4,   // 腾讯微博
    --5,           // 91帐户
    --11,         // 预留1
    --12,         // 预留2
    --13,         // 预留3
    --14,         // 预留4
    --15,         // 预留5
    --16,         // 预留6
    --17,         // 预留7
    Global:instance():TDGAsetAccount(SSOPlatform.GetUid().."_"..userdata.selectServer.serverName.."_"..userdata.userId)
    Global:instance():TDGAsetAccountType(1);
    Global:instance():TDGAsetAccountName(userdata.name);
    Global:instance():TDGAsetLevel(userdata.level)
    Global:instance():TDGAsetGameServer(userdata.selectServer.serverName)

    if isPlatform(IOS_VIETNAM_VI) 
        or isPlatform(IOS_VIETNAM_EN) 
        or isPlatform(IOS_VIETNAM_ENSAGA)
        or isPlatform(IOS_MOBNAPPLE_EN)
        or isPlatform(IOS_MOB_THAI)
        or isPlatform(ANDROID_VIETNAM_MOB_THAI)
        or isPlatform(ANDROID_VIETNAM_VI)
        or isPlatform(ANDROID_VIETNAM_EN)
        or isPlatform(ANDROID_VIETNAM_EN_ALL)
        or isPlatform(IOS_MOBGAME_SPAIN)
        or isPlatform(ANDROID_MOBGAME_SPAIN) then

        Global:instance():setVNUser(userdata.selectServer.id, userdata.selectServer.serverName, userdata.userId, userdata.name)

    end
end
function getWeiboUserid()
    return userdata.weiboId
end
function getWeiboToken()
    return userdata.weiboToken
end
--重置用户数据
function userdata:resetAllData(isNetError)              --   快用平台网络错误的时候重置用户数据添加一个标示，当为1时重设uid，为0 不变
    endTimer()                          --结束定时器
    userdata.resListDic = nil           -- 资源
    userdata.cdnRoot = nil               -- cdn url

    userdata.sessionId = ""         -- sessionId
    userdata.uid = ""              -- uid
    userdata.loginTime = 0            -- 登陆时间
    userdata.servConfVersion = ""   -- conf 版本
    userdata.newDay = false

    userdata.dCount = 0             -- 菊花层 统计

    userdata.name = nil
    userdata.flag = nil
    userdata.level = 0
    userdata.exp = 0
    userdata.expMax = 0
    userdata.gold = 0
    userdata.berry = 0
    userdata.strength = 0
    userdata.strengthTime = 0
    userdata.energy = 0
    userdata.energyTime = 0
    userdata.form = {}
    userdata.sevenForm = {}
    userdata.userId = 0

    userdata.weiboBindStatus = nil
    userdata.weiboId = nil
    userdata.weiboToken = nil

    -- TODO 其他modula分别调用各自的resetAllData初始化数据
    runtimeCache:resetAllData()
    herodata:resetAllData()
    recruitData:resetAllData()
    heroSoulData:resetAllData()
    storydata:resetAllData()
    equipdata:resetAllData()
    skilldata:resetAllData()
    wareHouseData:resetAllData()
    dailyData:resetAllData()
    battleShipData:resetAllData()
    giftBagData:resetAllData()
    blooddata:resetAllData()
    chapterdata:resetAllData()
    arenadata:resetAllData()
    titleData:resetAllData()
    topRollData:resetAllData()
    playerBattleData:resetAllData()
    continueLoginRewardData:resetAllData()
    vipdata:resetAllData()
    announceData:resetAllData()
    hotBalloonData:resetAllData()
    maildata:resetAllData()
    friendData:resetFriendData()
    bossdata:resetAllData()
    marineBranchData:resetAllData(  )
    shadowData:resetAllData()
    unionData:resetAllData()
    shardData:resetAllData()
    worldwardata:resetAllData()
    questdata:resetAllData()
    ssaData:resetAllData()  --退出游戏重置保存跨服战数据
    resetWWAllScore()
    uninhabitedData:resetAllData()

    if isPlatform(IOS_TBT_ZH) or isPlatform(IOS_TBTPARK_ZH) 
        or isPlatform(IOS_PPZS_ZH)
        or isPlatform(IOS_PPZSPARK_ZH) then
        SSOPlatform.setUid("")
    end
    if isPlatform(IOS_KY_ZH) then
        if not isNetError or isNetError ~= 0 then
            SSOPlatform.setUid("")
        end
    end
    stageMode = 1
end

-- 获取阵容上限
function userdata:getFormMax()
    local amount = 0
    for i,v in ipairs(table.sortKey(ConfigureStorage.formMax, true)) do
        if userdata.level < tonumber(v.key) then
            break
        end
        amount = v.value
    end
    return amount
end

-- 获取下一个阵容开启等级
function userdata:getNextFormMax()
    local level = -1
    for i,v in ipairs(table.sortKey(ConfigureStorage.formMax, true)) do
        if userdata.level < tonumber(v.key) then
            level = tonumber(v.key)
            break
        end
    end
    return level
end

function userdata:getFormSevenMax()
    local amount = 0
    for i,v in ipairs(table.sortKey(ConfigureStorage.formSevenMax, true)) do
        if userdata.level < tonumber(v.key) then
            break
        end
        amount = v.value
    end
    return amount
end

-- 获取下一个七星阵阵眼开启等级
function userdata:getNextFormSevenMax()
    local level = -1
    for i,v in ipairs(table.sortKey(ConfigureStorage.formSevenMax, true)) do
        if userdata.level < tonumber(v.key) then
            level = tonumber(v.key)
            break
        end
    end
    return level
end

function userdata:getFormSevenByIndex(index)
    return herodata.sevenForm[tostring(index - 1)]
end

-- 七星阵状态 0 等级未到锁住 1 未使用道具开启 2 开启未上阵 3 已上阵英雄
function userdata:formSevenState(index)
    local sevenFormMax = userdata:getFormSevenMax()
    if index > sevenFormMax then
        return 0
    else
        local hid = userdata:getFormSevenByIndex(index)
        if not hid then
            return 1
        elseif hid == "" then
            return 2
        else
            return 3
        end
    end
end

-- 是否可以激活该七星阵
function userdata:formSevenCanOpen(index)
    if index == 1 then
        return true
    end
    local state = userdata:formSevenState(index - 1)
    return state > 1
end

-- 获取当前啦啦队插槽等级
function userdata:getFormSevenLv(index)
    -- body  herodata.sevenUpgrade 
    --herodata.sevenUpgrade[tostring(index - 1)] == nil or 
    if herodata.sevenUpgrade == nil or herodata.sevenUpgrade[tostring(index - 1)] == nil then
        return 0
    else
        return herodata.sevenUpgrade[tostring(index - 1)]
    end
end

-- 当前船长等级可以让啦啦队插槽升级几次
function userdata:getFormSevenUpgradeMax(index)
    local conf = ConfigureStorage.formSevenLv[index]
    for i=#conf, 1, -1 do  -- 倒序
        if userdata.level > conf[i] then
            return i - 1
        end
    end
    return 0
end

-- 啦啦队是否可以升级
function userdata:formSevenCanUpgrade(index)
    -- 取index啦啦队等级
    local level = userdata:getFormSevenLv(index)
    -- 当前船长等级可以让啦啦队插槽升级几次 
    local max = userdata:getFormSevenUpgradeMax(index)
    print("---------maxIsThis--------",max)
    return level < max
end
-- 获取vip等级
function userdata:getGold()
    return userdata.gold
end

-- 获取vip等级
function userdata:getVipLevel()
    return vipdata:getVipLevel()
end

-- 获取用户等级
function userdata:getUserLevel()
    return userdata.level
end

-- 获取分享页面上提示的可获得银币数
function userdata:getShareSilver(  )
    if ConfigureStorage.shareAward then
        if ConfigureStorage.shareAward.silverBase and ConfigureStorage.shareAward.silverEffect then
            return ConfigureStorage.shareAward.silverBase + (userdata.level-1)*ConfigureStorage.shareAward.silverEffect
        end 
    end 
    return 0
end

local function _userUpgrade()
    -- 船长升级引发伙伴升级 (新版本，船长升级不再触发船员升级，代码检查先留着，以备出错查询)
    herodata:upgradeHeroes()

    playEffect(MUSIC_SOUND_FIGHT_LEVELUP)

    local _scene = CCDirector:sharedDirector():getRunningScene()
    _scene:addChild(createCaptainUpdateLayer(-140), 99)
end

-- 增加船长经验
function userdata:addExp(exp)
    userdata.exp = userdata.exp + exp
    userdata.expMax = userdata.expMax + exp
    local addLevel = 0
    while true do
        local expMax = ConfigureStorage.levelExp[tostring(userdata.level)].value1
        if userdata.level >= ConfigureStorage.playerlevelMax then
            if tonumber(userdata.exp) > tonumber(expMax) then
                userdata.exp = tonumber(expMax) - 1
            end
            break
        end
        if not expMax then
            break
        end

        if tonumber(userdata.exp) < tonumber(expMax) then
            break
        end
        userdata.exp = userdata.exp - expMax
        userdata.level = userdata.level + 1
        addLevel = addLevel + 1
    end
    if addLevel > 0 then
        -- 船长升级
        _userUpgrade()
        postNotification(NOTI_LEVELUP, nil)

        if isPlatform(IOS_INFIPLAY_RUS) then
            if userdata.level == 2 or userdata.level == 5 or userdata.level == 10 or userdata.level == 15 or userdata.level == 18 or userdata.level == 20
            or  userdata.level == 25 or userdata.level == 30 or userdata.level == 35 or userdata.level == 40 then 
            Global:instance():AFTrackEvent("level_reached","Level:"..userdata.level)
            -- Global:instance():ADjustEvent("level_reached","Level:"..userdata.level)
            end
        end
        if isPlatform(ANDROID_INFIPLAY_RUS) then
            Global:instance():ADjustEvent("level",userdata.level)
        end
    end
    postNotification(NOTI_EXP, nil)
end

-- 获取掉落中的特殊物品，去除经验银币金币
function userdata:getSpecialGain(gain)
    if not gain or table.getTableCount(gain) <= 0 then
        return nil
    end
    local array = deepcopy(gain)
    if array["exp_player"] then
        array["exp_player"] = nil
    end
    if array["exp_hero"] then
        array["exp_hero"] = nil
    end
    if array["silver"] then
        array["silver"] = nil
    end
    return array
end

-- 通过服务器返回的Gain和Pay字段修改用户数据，包括包括道具,装备,金币,银币,荣誉,精力 VIP成长值等
-- TODO 返回值待定
function userdata:updateUserDataWithGainAndPay( gainData,payData)
    local itemConfig = ConfigureStorage.item        -- 道具配置
    -- 获得数据处理
    if gainData and table.getTableCount(gainData) > 0 then
        if gainData["heroes_soul"] then
            --得到魂魄
            heroSoulData:addHeroSoulByDic(gainData["heroes_soul"])
        end
        if gainData["shadows"] then
            --得到影子
            for k,v in pairs(gainData["shadows"]) do
                shadowData:updateShadowByDic( k,v )
            end
        end  
        if gainData["equipShard"] then
            --得到影子
            for k,v in pairs(gainData["equipShard"]) do
                shardData:addShardByIdAndCount( k,v )
            end
        end 
        if gainData["heros"] then
            --得到英雄
            for k,v in pairs(gainData["heros"]) do
                herodata:addHeroByDic( v )
            end
        end
        if gainData["items"] then
            --得到装备
            for k,v in pairs(gainData["items"]) do
                wareHouseData:addItemByIdAndCount(k,v)
            end
        end
        if gainData["exp_player"] then
            -- 获得船长经验
            userdata:addExp(gainData["exp_player"])
            postNotification(NOTI_EXP, nil)
        end
        if gainData["vipScore"] then
            -- 获得船长经验
            vipdata.vipScore = vipdata.vipScore + gainData["vipScore"]
            postNotification(NOTI_VIPSCORE, nil)
        end
        if gainData["exp_hero"] then
            -- 获得伙伴经验
            herodata:addExpInForm(gainData["exp_hero"])
        end
        if gainData["shadowCoin"] then
            -- 获得金币
            postNotification(NOTI_REFRESH_COIN, nil)
        end
        if gainData["gold"] then
            -- 获得金币
            userdata.gold = userdata.gold + gainData["gold"]
            postNotification(NOTI_GOLD, nil)
        end
        if gainData["silver"] then
            -- 获得贝里
            userdata.berry = userdata.berry + gainData["silver"]
            postNotification(NOTI_BERRY, nil)
        end
        if gainData["strength"] then
            -- 获得体力
            userdata.strength = userdata.strength + gainData["strength"]
            postNotification(NOTI_STRENGTH, nil)
        end 
        if gainData["energy"] then
            userdata.energy = userdata.energy + gainData["energy"]
            postNotification(NOTI_ENERGY, nil)
        end
        if gainData["arena_time"] then
            --挑战次数
        end
        if gainData["frags"] then
            for k,v in pairs(gainData["frags"]) do
                chapterdata:addChapters(k, v)
            end
        end
        if gainData["titles"] then
            for k,v in pairs(gainData["titles"]) do
                titleData:updateOneTitleByIdanddic( k,v )
            end
        end
        if gainData["books"] then
            for k,v in pairs(gainData["books"]) do
                skilldata:addSkill(k, v)
            end
        end
        if gainData["equips"] then
            for k,v in pairs(gainData["equips"]) do
                equipdata:addEquip(k, v)
            end
        end
        if gainData["instruct"] then
            for hid,v in pairs(gainData["instruct"]["heros"]) do
                herodata:addExpByHeroUId(hid, gainData["instruct"]["exp_hero"])
            end
            if gainData["instruct"]["extraReward"] and gainData["instruct"]["extraReward"]["exp_hero"] > 0 then
                for k,hid in pairs(gainData["instruct"]["extraReward"]["heros"]) do
                    herodata:addExpByHeroUId(hid, gainData["instruct"]["extraReward"]["exp_hero"])
                end
            end
        end
        if gainData["treasureTimes"] then
            dailyData.daily[Daily_Treasure].times = dailyData.daily[Daily_Treasure].times + gainData["treasureTimes"]
        end
        if gainData["delayItems"] then
            for k,v in pairs(gainData["delayItems"]) do
                wareHouseData.bagDelay[k] = v
            end
        end
        if gainData["hotBlood"] then
            userdata.haki = userdata.haki + gainData["hotBlood"]
            postNotification(NOTI_HAKI, nil)
        end
    end
    -- 消耗数据处理
    if payData and table.getTableCount(payData) > 0 then
        if payData["heroes_soul"] then
            --消耗魂魄
            for k,v in pairs(payData["heroes_soul"]) do
                heroSoulData:reduceSoul(k,v)
            end 
        end
        if payData["equipShard"] then
            --消耗装备碎片
            for k,v in pairs(payData["equipShard"]) do
                shardData:reduceShardByIdAndCount( k,v )
            end 
        end
        if payData["shadows"] then
            --消耗影子
            for k,v in pairs(payData["shadows"]) do
                shadowData:updateShadowByDic( k,nil )
            end 
        end
        if payData["heros"] then
            --消耗英雄
            for k,v in pairs(payData["heros"]) do
                print(k, v)
                herodata:reduceHeroByUId(k)
            end
        end
        
        if payData["books"] then
            if payData["books"] then
                for skillUniqueID,count in pairs(payData["books"]) do
                    for key,value in pairs(skilldata.skills) do
                        if skillUniqueID == key then
                            skilldata.skills[key] = nil
                            break
                        end
                    end
                    for k,hid in pairs(herodata.form) do
                        local hero = herodata:getHero(herodata.heroes[hid])
                        for index,v in pairs(hero.skills_ex) do
                            if v == skillUniqueID then
                                herodata.heroes[hid].skills_ex[tostring(index)] = nil
                            end 
                        end
                    end
                end
            end
        end
        if payData["equips"] then
            --消耗道具   以前方法 
            for k,v in pairs(payData["equips"]) do
                equipdata:reduceEquipByID( k )
            end
        end
        if payData["items"] then
            --消耗道具   以前方法 
            for k,v in pairs(payData["items"]) do
                wareHouseData:reduceUserItem(k,v)
            end
        end
        if payData["gold"] then
            -- 消耗金币
            userdata.gold = userdata.gold - payData["gold"]
            postNotification(NOTI_GOLD, nil)
        end
        if payData["silver"] then
            -- 获得贝里
            userdata.berry = userdata.berry - payData["silver"]
            postNotification(NOTI_BERRY, nil)
        end
        if payData["frags"] then
            -- 残章
            for k,v in pairs(payData["frags"]) do
                chapterdata:removeChapters(k, v)
            end
        end
        if payData["strength"] then
            -- 体力
            userdata.strength = math.max(userdata.strength - payData["strength"], 0)
            if userdata:getStrengthMax() - userdata.strength == 1 then
                userdata.strengthTime = userdata.loginTime
            end
            postNotification(NOTI_STRENGTH, nil)
        end
        if payData["energy"] then
            -- 精力
            userdata.energy = math.max(userdata.energy - payData["energy"], 0)
            if userdata:getEnergyMax() - userdata.energy == 1 then
                userdata.energyTime = userdata.loginTime
            end
            postNotification(NOTI_ENERGY, nil)
        end

        if payData["treasureTimes"] then
            -- 探宝次数
            dailyData.daily[Daily_Treasure].times = math.max(dailyData.daily[Daily_Treasure].times - payData["treasureTimes"], 0)
        end

        if payData["hotBlood"] then
            userdata.haki = userdata.haki - payData["hotBlood"]
            postNotification(NOTI_HAKI, nil)
        end
    end
end

local function _lootCount(dic)
    local count = 0
    for key,v in pairs(dic) do
        if key == "silver" or key == "gold" or key == "arena_time" or key == "strength" or key == "energy" or key == "shadowCoin" then
            count = count + 1
        end
        if key == "shadows" or key == "items" or key == "equipShard" or key == "books" or key == "heroes_soul" 
            or key == "equips" or key == "frags" or key == "titles" or key == "delayItems" then
            count = count + table.getTableCount(v)
        end
    end
    return count
end

function userdata:showGainText(dic)
    if not dic then
        return
    end
    if dic["heroes_soul"] then
        --得到魂魄
        for k,v in pairs(dic["heroes_soul"]) do
            local conf = herodata:getHeroConfig(k)
            ShowText(HLNSLocalizedString("gain.text.soul", v, conf.name))
        end
    end
    if dic["shadows"] then
        --得到影子
        for k,v in pairs(dic["shadows"]) do
            local conf = shadowData:getOneShadowConf(k)
            ShowText(HLNSLocalizedString("gain.text.shadow", v, conf.name))
        end
    end  
    if dic["equipShard"] then
        --得到影子
        for k,v in pairs(dic["equipShard"]) do
            local conf = userdata:getExchangeResource(k)
            ShowText(HLNSLocalizedString("gain.text.item", v, conf.name))
        end
    end 
    if dic["heros"] then
        --得到英雄
        for k,v in pairs(dic["heros"]) do
            local conf = herodata:getHeroConfig(k)
            ShowText(HLNSLocalizedString("gain.text.item", v, conf.name))
        end
    end
    if dic["items"] then
        --得到装备
        for k,v in pairs(dic["items"]) do
            local conf = userdata:getExchangeResource(k)
            ShowText(HLNSLocalizedString("gain.text.item", v, conf.name))
        end
    end
    if dic["gold"] then
        -- 获得金币
        ShowText(HLNSLocalizedString("gain.text.default", HLNSLocalizedString("gain.gold", dic["gold"])))
    end
    if dic["silver"] then
        -- 获得贝里
        ShowText(HLNSLocalizedString("boss.result.silver", dic["silver"]))
    end
    if dic["frags"] then
        for k,v in pairs(dic["frags"]) do
            local conf = userdata:getExchangeResource(k)
            ShowText(HLNSLocalizedString("gain.text.item", v, conf.name))
        end
    end
    if dic["books"] then
        for k,v in pairs(dic["books"]) do
            local conf = userdata:getExchangeResource(k)
            ShowText(HLNSLocalizedString("gain.text.book", v, conf.name))
        end
    end
    if dic["equips"] then
        for k,v in pairs(dic["equips"]) do
            local conf = userdata:getExchangeResource(k)
            ShowText(HLNSLocalizedString("gain.text.item", v, conf.name))
        end
    end
    if dic["hotBlood"] then
        ShowText(HLNSLocalizedString("gain.text.default", HLNSLocalizedString("gain.haki", temp["hotBlood"])))
    end
end

-- 弹出掉落道具框
-- @param:gain 掉落列表
-- @param:bAllType 是否展示全部所得
function userdata:popUpGain(gain, bAllType)
    local temp = deepcopy(gain)
    if not bAllType then
        temp = userdata:getSpecialGain(gain)
    end
    if temp and getMyTableCount(temp) > 0 then
        -- 有掉落
        if _lootCount(temp) == 1 then
            -- 单个掉落
            if temp["heroes_soul"] then
                --得到魂魄   heroes_soul
                for k,v in pairs(temp["heroes_soul"]) do
                    local _scene = CCDirector:sharedDirector():getRunningScene()
                    _scene:addChild(createSingSongSuccessLayer( k,v,-998,"" ), 998)
                end
            end
            if temp["shadows"] then
                local _scene = CCDirector:sharedDirector():getRunningScene()
                for k,v in pairs(temp["shadows"]) do
                    _scene:addChild(createShadowGetPopUpLayer(k,-998), 998)
                end
            end
            if temp["equipShard"] then
                local _scene = CCDirector:sharedDirector():getRunningScene()
                for k,v in pairs(temp["equipShard"]) do
                    -- _scene:addChild(createShadowGetPopUpLayer(k,-140))
                    local sharConf = shardData:getShardConf( k )
                    local array = {}
                    array["count"] = v
                    array["shardId"] = k
                    _scene:addChild(createEquipInfoLayer(sharConf.equip, 3, -998,array), 998)
                end
            end
            if temp["titles"] then
                -- 获得新称号
                for k,v in pairs(temp["titles"]) do
                    local _scene = CCDirector:sharedDirector():getRunningScene()
                    if v.level > 1 then
                        _scene:addChild(createCaptainGetNewTitleLayer(k, -999,HLNSLocalizedString("称号升级")), 999)
                    else
                        _scene:addChild(createCaptainGetNewTitleLayer(k, -999), 999)
                    end
                end
            end
            if temp["arena_time"] then
                -- 挑战次数
                ShowText(HLNSLocalizedString("挑战次数增加%s次",temp["arena_time"]))
            end
            if temp["shadowCoin"] then
                ShowText(HLNSLocalizedString("获得%s个影纹",temp["shadowCoin"]))
            end
            if temp["items"] then
                --得到装备
                for itemId,v in pairs(temp["items"]) do
                    if getItemDetailInfoLayer() then
                        getItemDetailInfoLayer():removeFromParentAndCleanup(true)
                    end
                    CCDirector:sharedDirector():getRunningScene():addChild(createItemDetailInfoLayer(itemId, -998, v), 998)
                end
            end
            if temp["delayItems"] then
                for bid,bag in pairs(temp["delayItems"]) do
                    if getItemDetailInfoLayer() then
                        getItemDetailInfoLayer():removeFromParentAndCleanup(true)
                    end
                    CCDirector:sharedDirector():getRunningScene():addChild(createItemDetailInfoLayer(bag.itemId, -998, 1, 1), 998)
                end
            end
            if temp["frags"] then
                for chapterId,count in pairs(temp["frags"]) do
                    local _scene = CCDirector:sharedDirector():getRunningScene()
                    _scene:addChild(createGetSkillStampLayer( chapterId, -998), 998)
                end
            end
            if temp["books"] then
                for sid,v in pairs(temp["books"]) do
                    local _scene = CCDirector:sharedDirector():getRunningScene()
                    local skillContent = skilldata:getOneSkillByUniqueID( sid )
                    _scene:addChild(createSkillDetailLayer(skillContent,1, -998), 998)  
                end
            end
            if temp["equips"] then
                for eid,v in pairs(temp["equips"]) do
                    local _scene = CCDirector:sharedDirector():getRunningScene()
                    _scene:addChild(createEquipInfoLayer(eid,0, -998), 998)
                end
            end
            if temp["strength"] then
                ShowText(HLNSLocalizedString("获得%s点体力",temp["strength"]))
            end
            if temp["energy"] then
                ShowText(HLNSLocalizedString("获得%s点精力",temp["energy"]))
            end
            if temp["gold"] then
                playEffect(MUSIC_SOUND_CURRENCY)
                local _scene = CCDirector:sharedDirector():getRunningScene()
                local goldNumber = temp["gold"]
                if goldNumber < 20 then
                    HLAddParticleScale( "images/goldDrop_1.plist", _scene, ccp(winSize.width / 2,winSize.height), 1, 1, 1,1,1)
                elseif goldNumber >= 20 and goldNumber < 50 then
                    HLAddParticleScale( "images/goldDrop_2.plist", _scene, ccp(winSize.width / 2,winSize.height), 1, 1, 1,1,1)
                elseif goldNumber >= 50 and goldNumber < 300 then
                    HLAddParticleScale( "images/goldDrop_3.plist", _scene, ccp(winSize.width / 2,winSize.height), 1, 1, 1,1,1)
                else
                    HLAddParticleScale( "images/goldDrop_4.plist", _scene, ccp(winSize.width / 2,winSize.height), 1, 1, 1,1,1)
                end 
                ShowText(HLNSLocalizedString("获得%s金币",temp["gold"]))
                
            end
            if temp["silver"] then
                playEffect(MUSIC_SOUND_CURRENCY)
                local _scene = CCDirector:sharedDirector():getRunningScene()
                local silverNumber = temp["silver"]
                if silverNumber < 5000 then
                    HLAddParticleScale( "images/silverDrop_1.plist", _scene, ccp(winSize.width / 2,winSize.height), 1, 1, 1,1,1)
                elseif silverNumber >= 5000 and silverNumber < 20000 then
                    HLAddParticleScale( "images/silverDrop_2.plist", _scene, ccp(winSize.width / 2,winSize.height), 1, 1, 1,1,1)
                elseif silverNumber >= 20000 and silverNumber < 50000 then
                    HLAddParticleScale( "images/silverDrop_3.plist", _scene, ccp(winSize.width / 2,winSize.height), 1, 1, 1,1,1)
                else
                    HLAddParticleScale( "images/silverDrop_4.plist", _scene, ccp(winSize.width / 2,winSize.height), 1, 1, 1,1,1)
                end
                ShowText(HLNSLocalizedString("获得%s贝里",temp["silver"]))
               
            end
            if temp["hotBlood"] then
                ShowText(HLNSLocalizedString("gain.text.default", HLNSLocalizedString("gain.haki", temp["hotBlood"])))
            end
        elseif _lootCount(temp) > 1 then
            -- 多个掉落
            -- local titleCount = 0
            local array = {}
            if temp["heroes_soul"] then
                for k,v in pairs(temp["heroes_soul"]) do
                    if array["heroes_soul"..k] then
                        array["heroes_soul"..k] = array["heroes_soul"..k] + v
                    else
                        array["heroes_soul"..k] = v
                    end
                end
            end
            if temp["items"] then
                for k,v in pairs(temp["items"]) do
                    if array[k] then
                        array[k] = array[k] + v
                    else
                        array[k] = v
                    end
                end
            end
            if temp["delayItems"] then
                for bid,bag in pairs(temp["delayItems"]) do
                    if array[bag.itemId] then
                        array[bag.itemId] = array[bag.itemId] + 1
                    else
                        array[bag.itemId] = 1
                    end
                end
            end
            if temp["titles"] then
                for k,v in pairs(temp["titles"]) do
                    if v.level > 1 then
                        -- titleCount = titleCount + 1
                        local _scene = CCDirector:sharedDirector():getRunningScene()
                        _scene:addChild(createCaptainGetNewTitleLayer(k, -999,HLNSLocalizedString("称号升级")), 999)
                    else
                        if array[k] then
                            array[k] = array[k] + v
                        else
                            array[k] = v
                        end
                    end
                end
            end
            if temp["shadowCoin"] then
                ShowText(HLNSLocalizedString("获得%s个影纹",temp["shadowCoin"]))
            end
            if temp["frags"] then
                for k,v in pairs(temp["frags"]) do
                    if array[k] then
                        array[k] = array[k] + v
                    else
                        array[k] = v
                    end
                end
            end
            if temp["books"] then
                for k,v in pairs(temp["books"]) do
                    if array[v.skillId] then
                        array[v.skillId] = array[v.skillId] + 1
                    else
                        array[v.skillId] = 1
                    end
                end
            end

            if temp["equipShard"] then
                for k,v in pairs(temp["equipShard"]) do
                    if array["shard_"..k] then
                        array["shard_"..k] = array["shard_"..k] + v
                    else
                        array["shard_"..k] = v
                    end
                end
            end

            if temp["shadows"] then
                for k,v in pairs(temp["shadows"]) do
                    array[v.id] = 1
                end
            end
            if temp["equips"] then
                for k,v in pairs(temp["equips"]) do
                    if array[v.equipId] then
                        array[v.equipId] = array[v.equipId] + 1
                    else
                        array[v.equipId] = 1
                    end
                end
            end
            if temp["silver"] then
                if array["silver"] then
                    array["silver"] = array["silver"] + temp["silver"]
                else
                    array["silver"] = temp["silver"]
                end
            end
            if temp["gold"] then
                if array["gold"] then
                    array["gold"] = array["gold"] + temp["gold"]
                else
                    array["gold"] = temp["gold"]
                end
            end

            if temp["hotBlood"] then
                ShowText(HLNSLocalizedString("gain.text.default", HLNSLocalizedString("gain.haki", temp["hotBlood"])))
            end

            local _scene = CCDirector:sharedDirector():getRunningScene()
            -- if (_lootCount(temp) - titleCount) == 1 then
                
            -- else
            _scene:addChild(createGetSomeRewardLayer(array, -998),998)
            -- end
        end
    end
    -- 单独处理活动高人特效掉落
    if gain and gain["encounter"] then
        for key,dic in pairs(gain["encounter"]) do
            if string.find(key, Daily_InstructHeroG) then
                -- 高人点拨掉落
                local instructDic = deepcopy(dic)
                instructDic.id = key
                local scene = CCDirector:sharedDirector():getRunningScene()
                if getInstructHeroGGetLayer() then
                    getInstructHeroGGetLayer():removeFromParentAndCleanup(true)
                end
                scene:addChild(createInstructHeroGGetLayer(instructDic, -161), 101)
            elseif key == Daily_InstructHeroS then
                local array = {}
                for k,v in pairs(dic) do
                    if k ~= "sort" then
                        table.insert(array, deepcopy(v))
                    end
                end
                local scene = CCDirector:sharedDirector():getRunningScene()
                if getInstructHeroSGetLayer() then
                    getInstructHeroSGetLayer():removeFromParentAndCleanup(true)
                end
                scene:addChild(createInstructHeroSGetLayer(array, -162), 102)
            end
        end
    end
end

--劫镖成功物品
function userdata:PopUpRobSucGain(gain, bAllType)
    local temp = {}
    if gain["items"] then
      for k,v in pairs(gain["items"]) do
            table.insert(temp, {itemId = k, count = v})
        end
    end
    if gain["silver"] then
        table.insert(temp, {itemId = "silver", count = gain.silver})
    end
     if gain["gold"] then
        table.insert(temp, {itemId = "gold", count = gain.gold})
    end
    return temp
end


-- 获取用户大冒险列表信息
function userdata:getUserAdventureList()
    local array = {}
    -- 跨服决斗  测试SSA 跨服决斗缩写
    
    -- 优先判断血战
    if blooddata.data and table.getTableCount(blooddata.data) > 0 then
        table.insert(array, "blood")
    end
    if userdata.level >= ConfigureStorage.crossDual_sundry.lv then
        table.insert(array, "SSA")
    end
    -- boss战
    if userdata.level >= ConfigureStorage.levelOpen.boss.level then
        table.insert(array, "boss")
    end
    if userdata.level >= ConfigureStorage.levelOpen.seaMist.level then
        table.insert(array, "veiledSea")
    end
    --觉醒
    if (not userdata.wakeClose or userdata.wakeClose == 0) and
        ConfigureStorage.levelOpen.awave and userdata.level >= ConfigureStorage.levelOpen.awave.level then
        table.insert(array, "awake")
    end
    if userdata.level >= ConfigureStorage.aggress_lv["1"].openlv then
        table.insert(array, "uninhabited")
    end
    -- 无风带
    if herodata:isCalmBeltOpen() then
        table.insert(array, "calmbelt")
    end
    -- 寻宝
    if marineBranchData:isMarineOpen() then
        table.insert(array, "xunbao")
    end
    -- 残章
    if chapterdata.chapters then
        if table.getTableCount(chapterdata.chapters) >= 8 then
            table.insert(array, "chapters")
        else
            for k,v in pairs(chapterdata.chapters) do
                table.insert(array, k)
            end
        end
    end
    return array
end

--[[
霸气开启等级
@return 战队开启等级
@return 伙伴开启训练等级
]] 
function userdata:hakiOpenLv()
    return ConfigureStorage.aggress_lv["1"].openlv, ConfigureStorage.aggress_lv["2"].openlv
end

-- 获取海军支部的页码
function userdata:getMarinePage()
    local page = 0
    
    if blooddata.data and table.getTableCount(blooddata.data) > 0 then
        page = page + 1
    end
    if userdata.level >= ConfigureStorage.crossDual_sundry.lv then
        page = page + 1
    end
    if userdata.level >= ConfigureStorage.levelOpen.boss.level then
        page = page + 1
    end
    if userdata.level >= ConfigureStorage.levelOpen.seaMist.level then
        page = page + 1
    end
    if userdata.level >= ConfigureStorage.aggress_lv["1"].openlv then
        page = page + 1
    end
    if (not userdata.wakeClose or userdata.wakeClose == 0) and 
        userdata.level >= ConfigureStorage.levelOpen.awave.level then
        page = page + 1
    end
    if herodata:isCalmBeltOpen() then
        page = page + 1
    end
    return page
end

-- 获取迷雾之海的页码
function userdata:getHazePage()
    local page = 0
    if blooddata.data and table.getTableCount(blooddata.data) > 0 then
        page = page + 1
    end
    if userdata.level >= ConfigureStorage.crossDual_sundry.lv then
        page = page + 1
    end
    if userdata.level >= ConfigureStorage.levelOpen.boss.level then
        page = page + 1
    end
    return page
end

-- 获取大冒险的页码
function userdata:getAdventurePage()
    local page = 0
    return page
end

-- 获取boss战的页码 
function userdata:getBossPage()
    local page = 0
    if blooddata.data and table.getTableCount(blooddata.data) > 0 then
        page = page + 1
    end
    if userdata.level >= ConfigureStorage.crossDual_sundry.lv then
        page = page + 1
    end
    return page
end
-- 无人岛的页码
function userdata:getUninhabitedPage()
    local page = 0
    if blooddata.data and table.getTableCount(blooddata.data) > 0 then
        page = page + 1
    end
    if userdata.level >= ConfigureStorage.crossDual_sundry.lv then
        page = page + 1
    end
    if userdata.level >= ConfigureStorage.levelOpen.boss.level then
        page = page + 1
    end
    if userdata.level >= ConfigureStorage.levelOpen.seaMist.level then
        page = page + 1
    end
    if (not userdata.wakeClose or userdata.wakeClose == 0) and 
        userdata.level >= ConfigureStorage.levelOpen.awave.level then
        page = page + 1
    end
    return page
end

-- 获取无风带的页码
function userdata:getCalmBeltPage(  )
    local page = 0
    
    if blooddata.data and table.getTableCount(blooddata.data) > 0 then
        page = page + 1
    end
    if userdata.level >= ConfigureStorage.crossDual_sundry.lv then
        page = page + 1
    end
    if userdata.level >= ConfigureStorage.levelOpen.boss.level then
        page = page + 1
    end
    if userdata.level >= ConfigureStorage.levelOpen.seaMist.level then
        page = page + 1
    end
    if (not userdata.wakeClose or userdata.wakeClose == 0) and 
        userdata.level >= ConfigureStorage.levelOpen.awave.level then
        page = page + 1
    end
    if userdata.level >= ConfigureStorage.aggress_lv["1"].openlv then
        page = page + 1
    end
    return page
end

-- 获得奥义残页索引
function userdata:getSkillChapterIndex()
    local chaptesArray = userdata:getUserAdventureList()
    for i = 1, getMyTableCount(chaptesArray) do
        if chaptesArray[i] == "chapters" or wareHouseData:stringHasPrix(chaptesArray[i], "book") then
            return i - 1
        end
    end
    return 0
end

-- 获取奖励
function userdata:getBloodAward()
    local award = {}
    local berry = (blooddata.data.thisRecord - blooddata.data.historyRecord) * blooddata.data.awardConfig.perstar
    if blooddata.data.award["5star"] then
        berry = berry + blooddata.data.award["5star"]
    end
    table.insert(award, {key = "berry", value = berry})
    local items = {}
    if blooddata.data.award["15star"] then
        for k,v in pairs(blooddata.data.award["15star"]) do
            if items[k] then
                items[k] = items[k] + v
            else
                items[k] = v
            end
        end
    end
    if blooddata.data.award["30star"] then
        for k,v in pairs(blooddata.data.award["30star"]) do
            if items[k] then
                items[k] = items[k] + v
            else
                items[k] = v
            end
        end  
    end
    for k,v in pairs(items) do
        table.insert(award, {key = k, value = v})
    end
    if blooddata.data.award["45star"] then
        table.insert(award, {key = "gold", value = blooddata.data.award["45star"]})
    end
    return award
end

-- 获取下次恢复体力剩余时间
function userdata:getNextStrengthTime()
    if userdata.strength >= userdata:getStrengthMax() then
        return 0
    end
    return ConfigureStorage.strengthRecoverTime - (userdata.loginTime - userdata.strengthTime) % ConfigureStorage.strengthRecoverTime
end

-- 获取下次精力恢复时间
function userdata:getNextEnergyTime()
    if userdata.energy >= userdata:getEnergyMax() then
        return 0
    end
    return ConfigureStorage.energyRecoverTime - (userdata.loginTime - userdata.energyTime) % ConfigureStorage.energyRecoverTime
end

-- 获取恢复满体力所需时间
function userdata:getAllStrengthTime()
    if userdata.strength >= userdata:getStrengthMax() then
        return 0
    end
    return (userdata:getStrengthMax() - userdata.strength - 1) * ConfigureStorage.strengthRecoverTime + userdata:getNextStrengthTime()
end

-- 获取恢复满精力所需时间
function userdata:getAllEnergyTime()
    if userdata.energy >= userdata:getEnergyMax() then
        return 0
    end
    return (userdata:getEnergyMax() - userdata.energy - 1) * ConfigureStorage.energyRecoverTime + userdata:getNextEnergyTime()
end

-- 获取用户自己的战斗对比数据
function userdata:getUserBattleInfo()
    local info = {}
    info.level = userdata.level
    info.name = userdata.name
    info.heroes = deepcopy(herodata.heroes)
    info.form = deepcopy(herodata.form) -- 阵法中的英雄
    if herodata.sevenForm then
        info.sevenForm = deepcopy(herodata.sevenForm) -- 七星阵上阵的英雄
    else
        info.sevenForm = {}
    end
    if battleShipData.attrFix then
        info.attrFix = deepcopy(battleShipData.attrFix)
    else
        info.attrFix = {}
    end
    if equipdata.equips then
        info.equips = deepcopy(equipdata.equips)
    else
        info.equips = {}
    end
    if skilldata.skills then
        info.skills = deepcopy(skilldata.skills)
    else
        info.skills = {}
    end
    -- TODO 真气
    info.shadows = {} -- 真气
    if titleData.titles then
        info.titles = deepcopy(titleData.titles)
    else
        info.titles = {}
    end
    return info
end

-- 使用金币恢复体力次数
function userdata:getRecoverStrengthTime()
    if userdata.addEnergyWithGold and userdata.addEnergyWithGold.strength then
        return userdata.addEnergyWithGold.strength.times
    end
    return 0
end

-- 使用金币恢复精力次数
function userdata:getRecoverEnergyTime()
    if userdata.addEnergyWithGold and userdata.addEnergyWithGold.energy then
        return userdata.addEnergyWithGold.energy.times
    end
    return 0
end

function userdata:getRecoverConfig(time)
    return ConfigureStorage.energyAddWithGold[tostring(time)]
end

function userdata:recoverStrengthSucc()
    if not userdata.addEnergyWithGold then
        userdata.addEnergyWithGold = {}
    end
    if not userdata.addEnergyWithGold.strength then
        userdata.addEnergyWithGold.strength = {}
    end
    if not userdata.addEnergyWithGold.strength.times then
        userdata.addEnergyWithGold.strength.times = 1
    else
        userdata.addEnergyWithGold.strength.times = userdata.addEnergyWithGold.strength.times + 1
    end
end


function userdata:recoverEnergySucc()
    if not userdata.addEnergyWithGold then
        userdata.addEnergyWithGold = {}
    end
    if not userdata.addEnergyWithGold.energy then
        userdata.addEnergyWithGold.energy = {}
    end
    if not userdata.addEnergyWithGold.energy.times then
        userdata.addEnergyWithGold.energy.times = 1
    else
        userdata.addEnergyWithGold.energy.times = userdata.addEnergyWithGold.energy.times + 1
    end
end

-- 是否参与首次充值活动
function userdata:bFirstCashAward()
    if not userdata.firstCashAward1 then
        return false
    end
    local key
    for k,v in pairs(ConfigureStorage.firstCashAward1) do
        key = k
        break
    end
    for k,v in pairs(userdata.firstCashAward1) do
        if tonumber(key) == tonumber(k) then
            return true
        end
    end
    return false
end

-- 获得首充活动金币翻倍
function userdata:getFirstAwardGoldMult()
    for k,v in pairs(ConfigureStorage.firstCashAward1) do
        return v.multiple
    end
    return 1
end

-- 获得loading页面显示的字符串
function getLoadingString(  )
    if ConfigureStorage.loading then
        local conf = ConfigureStorage.loading
        local num = math.random(102, 140)
        if conf[tostring(num)] then
            return conf[tostring(num)]["content"]
        else
            return nil
        end
    else
        return nil
    end
end

-- 获得服务器个数 
function getServerListCount(  )
    return getMyTableCount(userdata.serverList)
end

-- 有战斗双倍经验活动
function userdata:hasBattleDouble(mode)
    if not ConfigureStorage.battleDouble then
        return false
    end
    if userdata.level < ConfigureStorage.battleDouble.level then
        return false
    end
    if userdata.loginTime < ConfigureStorage.battleDouble.activityOpenTime or
        userdata.loginTime > ConfigureStorage.battleDouble.activityEndTime then
        return false
    end
    -- 赵艳秋20150819：关卡中不传mode，用之前的判断即可；看结果时传入战斗模式，用战斗模式判断是否是后台打钩的模式
    if not mode then
        return true
    end
    if ConfigureStorage.battleDouble.effectModules and (
            ConfigureStorage.battleDouble.effectModules.frags and ConfigureStorage.battleDouble.effectModules.frags == 1 and mode == BattleMode.chapter
            or ConfigureStorage.battleDouble.effectModules.huntingTreasure and ConfigureStorage.battleDouble.effectModules.huntingTreasure == 1 and mode == BattleMode.marineBoss
            or ConfigureStorage.battleDouble.effectModules.arena and ConfigureStorage.battleDouble.effectModules.arena == 1 and mode == BattleMode.arena
            or ConfigureStorage.battleDouble.effectModules.eliteStage and ConfigureStorage.battleDouble.effectModules.eliteStage == 1 and mode == BattleMode.hakiFight
            or ConfigureStorage.battleDouble.effectModules.storys and ConfigureStorage.battleDouble.effectModules.storys == 1 and mode == BattleMode.stage) then
        return true
    end
            
    return false
end

function userdata:getExchangeResource(itemId)
    local conf = {}
    if itemId == "silver" or itemId == "berry" then
        conf.rank = 1
        conf.icon = "ccbResources/icons/berryIcon.png"
        conf.name = HLNSLocalizedString("贝里")
        conf.count = userdata.berry
    elseif itemId == "gold" then
        conf.rank = 4
        conf.icon = "ccbResources/icons/goldIcon.png"
        conf.name = HLNSLocalizedString("金币")
        conf.count = userdata.gold
    elseif havePrefix(itemId, "hero_") then
        local config = herodata:getHeroConfig(itemId)
        conf.rank = config.rank
        conf.icon = herodata:getHeroHeadByHeroId( itemId )
        conf.name = config.name
        conf.count = heroSoulData:getSoulCountByHeroId( itemId )
    elseif havePrefix(itemId, "shadow") then
        local config = shadowData:getOneShadowConf( itemId )
        conf.rank = config.rank
        conf.icon = config.icon
        conf.name = config.name
        conf.count = shadowData:getShadowCountById( itemId )
    elseif haveSuffix(itemId, "_shard") then
        local config = shardData:getShardConf( itemId )
        conf.rank = config.rank
        conf.icon = config.icon
        conf.name = config.name
        conf.count = shardData:getOneShardCount( itemId )
    else
        local config = wareHouseData:getItemConfig(itemId)
        if config then
            conf.count = wareHouseData:getItemCountById( itemId )
        end
        if not config then
            config = equipdata:getEquipConfig(itemId)
            if config then
                conf.count = equipdata:getEquipCountById( itemId )
            end
        end
        if not config then
            config = skilldata:getSkillConfig(itemId)
            if config then
                conf.count = skilldata:getSkillCountById( itemId )
            end
        end
        if not config then
            conf.rank = 1
            conf.icon = nil
            conf.name = ""
            conf.count = 0
        else
            if havePrefix(itemId,"chapter") then
                conf.icon = string.format("ccbResources/icons/%s.png", config.params)
            else
                conf.icon = string.format("ccbResources/icons/%s.png", config.icon)
            end
            -- conf.icon = string.format("ccbResources/icons/%s.png", config.icon)
            conf.rank = config.rank
            conf.name = config.name
        end

    end
    conf.id = itemId
    return conf
end

-- 已经购买蓝波球的次数
function userdata:getEnergyAddWithGoldTime()
    if userdata.addItemsWithGold and userdata.addItemsWithGold.items then
        return userdata.addItemsWithGold.items.item_006.times
    end
    return 0
end

--数据返回成功
function userdata:addItemsWithGoldSucc()
    if not userdata.addItemsWithGold then
        userdata.addItemsWithGold = {}
    end
    if not userdata.addItemsWithGold.items then
        userdata.addItemsWithGold.items = {}
    end
    if not userdata.addItemsWithGold.items.item_006 then
        userdata.addItemsWithGold.items.item_006 = {}
    end
    if not userdata.addItemsWithGold.items.item_006.times then
        userdata.addItemsWithGold.items.item_006.times = 1
    else
        userdata.addItemsWithGold.items.item_006.times = userdata.addItemsWithGold.items.item_006.times + 1
    end
end

--[[
获取蓝波球购买页面所需的金币数
buyBallTimes: 当天已购买次数
]]
function userdata:getEnergyAddWithGoldOfGold(buyBallTimes)
    if ConfigureStorage.energyAddWithGold then
        -- if buyBallTimes == 0 then 
        --     buyBallTimes = buyBallTimes + 1
        -- end
        local conf = ConfigureStorage.energyAddWithGold[tostring(buyBallTimes + 1)]
        local item_006_gold = conf.item_006_gold
        return item_006_gold 
    end
    return nil
end

--[[
获取蓝波球购买页面的蓝波球个数
buyBallTimes: 当天已购买次数
]]
function userdata:getEnergyAddWithGoldOfAdd(buyBallTimes)
    if ConfigureStorage.energyAddWithGold then
        if buyBallTimes == 0 then 
            buyBallTimes = buyBallTimes + 1
        end
        local conf = ConfigureStorage.energyAddWithGold[tostring(buyBallTimes + 1 )]
        local item_006_add = conf.item_006_add
        return item_006_add
    end
    return nil
end

--新增功能关于数量过大缩写 
function userdata:getFunctionOfNumberAcronym(count)
    -- body
    --金币 userdata.gold 贝里 userdata.berry
    --中文版 百万为单位 HLNSLocalizedString("NumberAcronym_wan")
    if langType() == LANG_TYPE.zh then
        if tonumber(count) <= 999999 then
            return tostring(count)
        else
            if tonumber(count) >= 10 ^ 8 then
                if tonumber(count % 10 ^ 8) == 0 then
                    return tostring(count / 10 ^ 8 .. HLNSLocalizedString("NumberAcronym_yi"))
                else
                    return tostring (math.floor(tonumber(count / 10 ^ 8)) .. HLNSLocalizedString("NumberAcronym_yi") .. '+') 
                end 
            else
                if tonumber(count % 10 ^ 4) == 0 then
                    return tostring(count / 10 ^ 4 .. HLNSLocalizedString("NumberAcronym_wan"))
                else
                    return tostring (math.floor(tonumber(count / 10 ^ 4)) .. HLNSLocalizedString("NumberAcronym_wan") .. '+') 
                end 
            end
        end
    else
         -- 英文版 百万为单位
        if tonumber(count) < 999999 then
            return tostring(count)
        else
            if tonumber(count % 1000000) == 0 then
                return tostring(count/1000000 .. 'M')
            else
                return tostring (math.floor(tonumber(count/1000000)) .. 'M' .. '+') 
            end 
        end
    end
end
-- 拼图游戏中 通过vip配置获得能vip直接点击地图的当前vip 
function userdata:getVipLv()
    -- body
    local vipLv
    for i=1,getMyTableCount(ConfigureStorage.vipConfig) do
        if ConfigureStorage.vipConfig[i].SP ==0  and ConfigureStorage.vipConfig[i + 1].SP > 0 then
            vipLv = i
        end
    end
    return vipLv
end