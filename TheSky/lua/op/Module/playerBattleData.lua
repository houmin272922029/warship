-- 其他用户数据缓存 ，暂时只存战斗需要计算的数据

playerBattleData = {
    heroes = {},
    form = {}, -- 阵法中的英雄
    sevenForm = {}, -- 七星阵上阵的英雄
    attrFix = {}, -- 战舰
    equips = {}, -- 装备
    skills = {}, -- 技能书
    shadows = {}, -- 真气
    titles = {}, -- 称号，计算气势值
    level = 0,
    name = nil, 
    extraBuff = {},
}

function playerBattleData:fromDic(info)
    playerBattleData.heroes = info.heros
    playerBattleData.form = info.form
    if info.form_seven then
        playerBattleData.sevenForm = info.form_seven
    else
        playerBattleData.sevenForm = {}
    end
    if info.attrFix then
        playerBattleData.attrFix = info.attrFix
    else
        playerBattleData.attrFix = {}
    end
    if info.equips then
        playerBattleData.equips = info.equips
    else
        playerBattleData.equips = {}
    end
    if info.books then
        playerBattleData.skills = info.books
    else
        playerBattleData.skills = {}
    end
    if info.shadows then
        playerBattleData.shadows = info.shadows
    else
        playerBattleData.shadows = {}
    end
    if info.titles then
        playerBattleData.titles = info.titles
    else
        playerBattleData.titles = {}
    end
    playerBattleData.name = info.name
    playerBattleData.level = info.level
    
    if info.extraBuff then
        playerBattleData.extraBuff = info.extraBuff
    else
        playerBattleData.extraBuff = {}
    end
    if info.seven_upgrade then
        playerBattleData.sevenUpgrade = info.seven_upgrade
    else
        playerBattleData.sevenUpgrade = {}
    end
end

-- 获取英雄身上所有装备的技能
-- 参数 英雄唯一id
function playerBattleData:getHeroSkills(hid)
    local dic = {}
    local hero = playerBattleData.heroes[hid]
    if hero.wake and hero.wake > 0 then
        hero.skill_default.skillId = herodata:getHeroConfig(hero.heroId, hero.wake).skill
    end

    if hero.skill_default then
        dic["0"] = hero.skill_default
    end
    if hero.skills_ex then
        for i=1,3 do
            local sid = hero.skills_ex[tostring(i)]
            if sid then
                dic[tostring(i)] = playerBattleData.skills[sid]
            end
        end
    end
    return dic
end

-- 获取英雄净身价 （除开装备奥义）
function playerBattleData:getHeroAttrPrice(hid)
    local hero = playerBattleData.heroes[hid]
    local price = herodata:getHeroPriceConfig(hero.heroId, hero.wake)
    local heroConfig = herodata:getHeroConfig(hero.heroId, hero.wake)
    local attr = 0
    -- 升级提升属性
    for k,v in pairs(heroConfig.grow) do
        attr = attr + math.floor(v * (hero.level - 1))
    end
    -- 培养的属性
    for k,v in pairs(hero.attrFix) do
        attr = attr + tonumber(v)
    end
    return price + math.floor(attr * 0.75)
end

-- 身价计算
function playerBattleData:getHeroPrice(hid)
    local price = playerBattleData:getHeroAttrPrice(hid) -- 英雄净身价
    local hero = playerBattleData.heroes[hid]
    -- 武器的身价
    for k,eid in pairs(hero.equip) do
        local equip = playerBattleData.equips[eid]
        price = price + equipdata:getEquipPrice(equip.equipId, equip.level)
    end
    -- 技能的身价
    for k,skill in pairs(playerBattleData:getHeroSkills(hid)) do
        price = price + skilldata:getSkillPrice(skill.skillId, skill.level)
    end
    return price
end

--
function playerBattleData:getHero(dic)
    local hero = deepcopy(dic)
    local conf = herodata:getHeroConfig(hero.heroId, hero.wake)
    hero.name = conf.name
    hero.rank = conf.rank
    hero.desp = conf.desp
    hero.expMax = ConfigureStorage.levelExp[tostring(hero.level)].value2 * conf.exp
    hero.price = playerBattleData:getHeroPrice(hero.id)
    return hero
end

-- 根据heroid查询是否上阵
function playerBattleData:bHeroOnFormByHeroId(heroId)
    for k,id in pairs(playerBattleData.form) do
        if id and id ~= "" and playerBattleData.heroes[id].heroId == heroId then
            return true
        end
    end
    for k,id in pairs(playerBattleData.sevenForm) do
        if id and id ~= "" and playerBattleData.heroes[id].heroId == heroId then
            return true
        end
    end
    return false
end

-- 身价计算
function playerBattleData:getEquipPrice(eid) -- 参数 : 装备唯一id
    return 0
end

-- 得到装备所在hero
function playerBattleData:getOwnerByEUid(eid)
    for k,hid in pairs(playerBattleData.form) do
        local hero = playerBattleData:getHero(playerBattleData.heroes[hid])
        if hero.equip then
            for i=0,2 do
                local suid = hero.equip[tostring(i)]
                if suid and suid == eid then
                    return hero
                end
            end
        end
    end
    return nil
end

-- 好友数据是否开启影子
function playerBattleData:bOpenShadowFun()
    if ConfigureStorage.levelOpen["shadow"] then
        return playerBattleData.level >= ConfigureStorage.levelOpen["shadow"].level
    end
    return false
end

-- 得到称号页面默认显示称号
function playerBattleData:getDefalutTitles(  )
    local outerDic = {}
    for k,v in pairs(ConfigureStorage.titleConfig) do
        if v.outer ~= 0 then
            table.insert(outerDic,k)
        end
    end
    local retArray = {}
    for i=1,getMyTableCount(outerDic) do
        local tempArray = {}
        local titleConf = titleData:getTitleConfigById( outerDic[i] )
        local titleContent = deepcopy(playerBattleData.titles[outerDic[i]]) 
        tempArray["conf"] = titleConf
        tempArray["title"] = titleContent
        table.insert(retArray,tempArray)
    end
    local function sorFun( a,b )
        return a.conf.outer < b.conf.outer
    end
    table.sort(retArray,sorFun)
    return retArray
end

function playerBattleData:getFormSevenMax()
    local amount = 0
    for i,v in ipairs(table.sortKey(ConfigureStorage.formSevenMax, true)) do
        if playerBattleData.level < tonumber(v.key) then
            break
        end
        amount = v.value
    end
    return amount
end

-- 获取当前啦啦队插槽等级
function playerBattleData:getFormSevenLv(index)
    if playerBattleData.sevenUpgrade == nil or playerBattleData.sevenUpgrade[tostring(index - 1)] == nil then
        return 0
    else
        return playerBattleData.sevenUpgrade[tostring(index - 1)]
    end
end

-- 当前船长等级可以让啦啦队插槽升级几次
function playerBattleData:getFormSevenUpgradeMax(index)
    local conf = ConfigureStorage.formSevenLv[index]
    for i=#conf, 1, -1 do  -- 倒序
        if playerBattleData.level > conf[i] then
            return i - 1
        end
    end
    return 0
end

function playerBattleData:getFormSevenByIndex(index)
    return playerBattleData.sevenForm[tostring(index - 1)]
end

-- 七星阵状态 0 等级未到锁住 1 未使用道具开启 2 开启未上阵 3 已上阵英雄
function playerBattleData:formSevenState(index)
    local sevenFormMax = playerBattleData:getFormSevenMax()
    if index > sevenFormMax then
        return 0
    else
        local hid = playerBattleData:getFormSevenByIndex(index)
        if not hid then
            return 1
        elseif hid == "" then
            return 2
        else
            return 3
        end
    end
end

-- 获取装备信息
function playerBattleData:getEquip(eid)
    local equip = deepcopy(playerBattleData.equips[eid])
    local conf = equipdata:getEquipConfig(equip.equipId)
    equip.rank = conf.rank
    equip.name = conf.name
    equip.updateSilver = conf.updateSilver
    equip.icon = conf.icon
    equip.updateEffect = conf.updateEffect
    equip["type"] = conf["type"]
    equip.desp = conf.desp
    local level = equip.level
    local stage = equip.stage
    local attr = {}
    for k,v in pairs(conf.initial) do
        local value
        if conf.refine then
            value = v + math.floor((conf.updateEffect + conf.refine * stage) * (level - 1))
        else
            value = v + math.floor(conf.updateEffect * (level - 1))
        end
        if attr[k] then
            attr[k] = attr[k] + value
        else
            attr[k] = value
        end
    end
    equip.attr = attr
    equip.refinelv = conf.refinelv
    equip.price = playerBattleData:getEquipPrice(eid)
    equip.owner = playerBattleData:getOwnerByEUid(eid)
    return equip
end

-- 获取英雄身上所有装备的技能
-- 参数 英雄唯一id
function playerBattleData:getHeroEquips(hid)
    local dic = {}
    local hero = playerBattleData:getHero(playerBattleData.heroes[hid])
    for i=0,2 do
        local eid = hero.equip[tostring(i)]
        if eid then
            dic[tostring(i)] = playerBattleData:getEquip(eid)
        end
    end
    return dic
end

-- 英雄是否穿了指定的装备
function playerBattleData:bEquipOnHero(equipId, hid)
    local equips = playerBattleData.heroes[hid].equip
    for k,eid in pairs(equips) do
        if playerBattleData.equips[eid].equipId == equipId then
            return true
        end
    end
    return false
end

-- 英雄是否装备了指定技能
function playerBattleData:bskillOnHero(skillId, hid)
    for k,skill in pairs(playerBattleData:getHeroSkills(hid)) do
        if skill.skillId == skillId then
            return true
        end
    end
    return false
end

-- 获取英雄缘分
function playerBattleData:getComboByHid(hid)
    local hero = playerBattleData.heroes[hid]
    local heroId = hero.heroId
    local array = {}
    local combo = deepcopy(ConfigureStorage.combo[heroId])

    if hero.wake and hero.wake == 2 then
        local combo5 = ConfigureStorage.combo5[heroId] 
        for i,v in ipairs(combo5) do
            combo[#combo + 1] = v;
        end
    end

    for i,conf in ipairs(combo) do
        local flag = false
        if conf.type == 1 then
            -- 英雄
            for j,v in ipairs(conf.heroes) do
                if not playerBattleData:bHeroOnFormByHeroId(v) then
                    flag = false
                    break
                else
                    flag = true
                end
            end
        elseif conf.type == 2 then
            -- 装备
            for i,v in ipairs(conf.equips) do
                if not playerBattleData:bEquipOnHero(v, hid) then
                    flag = false
                    break
                else
                    flag = true
                end
            end
        elseif conf.type == 3 then
            -- 技能
            for j,v in ipairs(conf.books) do
                if not playerBattleData:bskillOnHero(v, hid) then
                    flag = false
                    break
                else
                    flag = true
                end
            end
        end
        local dic = {["name"] = conf.name, ["flag"] = flag, ["param"] = conf.param}
        table.insert(array, dic)
    end
    return array
end

-- 获取英雄基础属性数值， 不包含装备等加成
-- 参数：英雄uid
-- 返回：英雄属性数值
function playerBattleData:getHeroBasicAttrsByHeroUId(heroUId)
    if nil == heroUId or string.len(heroUId) == 0 then
        return nil
    end
    local hero = playerBattleData.heroes[heroUId]
    local heroId = hero.heroId
    if nil == heroId or string.len(heroId) == 0 then
        return nil
    end
    local heroConfig = herodata:getHeroConfig(heroId, hero.wake)
    local attr = deepcopy(heroConfig.attr)
    -- 升级提升属性
    for k,v in pairs(heroConfig.grow) do
        if attr[k] then
            attr[k] = attr[k] + math.floor(v * (hero.level - 1))
        else
            attr[k] = math.floor(v * (hero.level - 1))
        end
    end
    -- 培养的属性
    for k,v in pairs(playerBattleData.heroes[heroUId].attrFix) do
        if attr[k] then
            attr[k] = attr[k] + tonumber(v)
        else
            attr[k] = tonumber(v)
        end
    end
    -- 突破获得属性提升
    if hero["break"] and hero["break"] > 0 then
        local bAttr = herodata:getHeroBreakAttrUp(heroId, hero.wake)
        for k,v in pairs(bAttr) do
            if attr[k] then
                attr[k] = attr[k] + v * hero["break"]
            else
                attr[k] = v * hero["break"]
            end
        end
    end
    return attr
end

-- 获得七星阵属性
function playerBattleData:getSevenFormAttr()
    local attr = {}
    if not playerBattleData.sevenForm then
        return attr
    end
    for i=1,7 do
        local state = playerBattleData:formSevenState(i)
        if state == 3 then
            local confUpgrade = ConfigureStorage.formSevenUpgrade[i]
            local hid = playerBattleData:getFormSevenByIndex(i)
            local key = ConfigureStorage.formSevenAttr[i].attr
            local per = confUpgrade[playerBattleData:getFormSevenLv(i) + 1]
            local base = playerBattleData:getHeroBasicAttrsByHeroUId(hid)
            local value = 0
            if base[key] then
                value = math.max(math.floor(base[key] * per), 1)
            end
            if attr[key] then
                attr[key] = attr[key] + value
            else
                attr[key] = value
            end
        end
    end
    return attr
end

-- 获得总气势值
function playerBattleData:getAllFame()
    local fame = 0
    local famePer = 0
    for k,v in pairs(playerBattleData.titles) do
        if v.level > 0 then
            local conf = titleData:getTitleConfigById(k)
            if conf.baseValue < 1 then
                if conf.targetID then
                    for i,id in ipairs(conf.targetID) do
                        local data = playerBattleData.titles[id]
                        if data then
                            local targetConf = titleData:getTitleConfigById(id)
                            local targetFame = targetConf.baseValue + targetConf.updateValue * (data.level - 1)
                            fame = fame + math.floor(targetFame * (conf.baseValue + conf.updateValue * (v.level - 1)))
                        end
                    end
                else
                    famePer = famePer + conf.baseValue + conf.updateValue * (v.level - 1)
                end
            else
                fame = fame + conf.baseValue + conf.updateValue * (v.level - 1)    
            end
        end
    end
    fame = math.floor(fame * (1 + famePer))
    return fame
end

-- 通过等级和配置id得到一个影子的属性数组
function playerBattleData:getShadowAttrByLevelAndCid( level,cid )
    local shadowConf = shadowData:getOneShadowConf( cid )
    local retArray = {}
    retArray["type"] = shadowConf.property
    retArray["value"] = shadowConf.level[tostring(level)]
    return retArray
end

-- 获取英雄的修炼等级
-- 参数：英雄唯一id
-- 返回：英雄的训练等级
function playerBattleData:getOneHeroTrainLevel( heroUId )
    local trainLevel = 0
    if nil == heroUId or string.len(heroUId) == 0 then
        print("uid is error",heroUId)
        return 0
    end
    local hero = playerBattleData.heroes[heroUId]
    if not hero then
        print("hero do not exist")
        return 0
    end
    local disciplineData = hero.discipline
    if not disciplineData or getMyTableCount(disciplineData) == 0 then
        return 0
    end
    return disciplineData.level
end

-- 获取英雄属性数值
-- 参数：英雄uid
-- 返回：英雄属性数值
function playerBattleData:getHeroAttrsByHeroUId( heroUId ) 
    if nil == heroUId or string.len(heroUId) == 0 then
        return nil
    end
    local hero = playerBattleData.heroes[heroUId]
    local heroId = hero.heroId
    if nil == heroId or string.len(heroId) == 0 then
        return nil
    end
    local heroConfig = herodata:getHeroConfig(heroId, hero.wake)

    local attr = playerBattleData:getHeroBasicAttrsByHeroUId(heroUId) -- 基础属性
    local addAttr = {} -- 缘分附加属性百分比

    -- TODO 闭关属性
    if hero.discipline and hero.discipline.level and hero.discipline.level > 0 then
        local value = math.floor(heroConfig.specialadd["value"] + (hero.discipline.level - 1) * heroConfig.specialadd["lv"])
        if attr[heroConfig.specialadd["attr"]] then
            attr[heroConfig.specialadd["attr"]] = attr[heroConfig.specialadd["attr"]] + value
        else
            attr[heroConfig.specialadd["attr"]] = value
        end
    end
    -- 装备
    for i,id in pairs(hero.equip) do
        if playerBattleData.equips then
            local equipId = playerBattleData.equips[id]["equipId"]
            local level = playerBattleData.equips[id]["level"]
            local refineLevel = playerBattleData.equips[id].stage
            local equipConfig = equipdata:getEquipConfig(equipId)
            if equipConfig.initial and type(equipConfig.initial) == "table" then
                for k,v in pairs(equipConfig.initial) do
                    if equipConfig.refine then
                        v = v + math.floor((equipConfig.updateEffect + equipConfig.refine * refineLevel) * (level - 1))
                    else
                        v = v + math.floor(equipConfig.updateEffect * (level - 1))
                    end
                    if attr[k] then
                        attr[k] = attr[k] + v
                    else
                        attr[k] = v
                    end
                end
            end
        end
    end
    -- 战舰
    if playerBattleData.attrFix then
        for k,v in pairs(playerBattleData.attrFix) do
            local add = battleShipData:getAttrByTypeAndLevel(k, v.level)
            if tostring(math.floor(add)) == tostring(add) then
                -- 数值型
                if attr[k] then
                    attr[k] = attr[k] + add
                else
                    attr[k] = add
                end
            else
                -- 百分比型
                if addAttr[k] then
                    addAttr[k] = addAttr[k] + add
                else
                    addAttr[k] = add
                end
            end
        end
    end
    -- 七星阵
    for k,v in pairs(playerBattleData:getSevenFormAttr()) do
        if attr[k] then
            attr[k] = attr[k] + v
        else
            attr[k] = v
        end
    end
    -- 真气
    if hero.shadows then
        for k,v in pairs(hero.shadows) do
            local shadow = playerBattleData.shadows[v]
            local dic = playerBattleData:getShadowAttrByLevelAndCid( shadow.level,shadow.shadowId )
            if attr[dic["type"]] then
                attr[dic["type"]] = attr[dic["type"]] + dic["value"]
            else
                attr[dic["type"]] = dic["value"]
            end
        end
    end
    -- 缘分
    local combos = playerBattleData:getComboByHid(heroUId)
    for i,combo in ipairs(combos) do
        if combo.flag then
            for k,v in pairs(combo.param) do
                if addAttr[k] then
                    addAttr[k] = addAttr[k] + v
                else
                    addAttr[k] = v
                end
            end
        end
    end

    -- 天赋技能

    local skills = playerBattleData:getHeroSkills(heroUId)
    for j=0,3 do
        local dic = skills[tostring(j)]
        if dic then
            local skillId = dic.skillId
            local level = dic.level
            local skill = skilldata:getSkill(skillId, level, hero.heroId)
            if skill.skillType == 1 then
                -- buff技能
                for k,v in pairs(skill.attr) do
                    if addAttr[k] then
                        addAttr[k] = addAttr[k] + v
                    else
                        addAttr[k] = v
                    end
                end
            elseif skill.skillType == 5 then
                for k,v in pairs(skill.attr) do
                    if attr[k] then
                        attr[k] = attr[k] + v
                    else
                        attr[k] = v
                    end
                end
            end
        end
    end

    -- 霸气
    local haki = hero.aggress or {kind = 1, layer = 1, base = 0, pre = 0}
    local hakiAttr = herodata:getHakiAttr(haki)
    for k,v in pairs(hakiAttr) do
        if attr[k] then
            attr[k] = attr[k] + v
        else
            attr[k] = v
        end
    end

    -- 属性加成
    -- for k,v in pairs(addAttr) do
    --     if attr[k] then
    --         attr[k] = math.floor(attr[k] * (1 + v))
    --     end
    -- end
    return attr, addAttr
end

-- 获取计算后的属性
function playerBattleData:getHeroCultAttr(heroUId)
    local attr, addAttr = playerBattleData:getHeroAttrsByHeroUId(heroUId)
    -- 属性加成
    for k,v in pairs(addAttr) do
        if attr[k] then
            attr[k] = math.floor(attr[k] * (1 + v))
        end
    end
    return attr
end

--重置用户数据
function playerBattleData:resetAllData()
    playerBattleData.heroes = {}
    playerBattleData.form = {} -- 阵法中的英雄
    playerBattleData.sevenForm = {} -- 七星阵上阵的英雄
    playerBattleData.attrFix = {} -- 战舰
    playerBattleData.equips = {} -- 装备
    playerBattleData.skills = {} -- 技能书
    playerBattleData.shadows = {} -- 真气
    playerBattleData.titles = {} -- 称号，计算气势值 
    playerBattleData.level = 0
    playerBattleData.name = nil
end

