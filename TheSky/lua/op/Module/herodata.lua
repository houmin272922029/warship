-- 用户数据缓存

--                            _ooOoo_   
--                           o8888888o   
--                           88" . "88   
--                           (| -_- |)   
--                            O\ = /O   
--                        ____/`---'\____   
--                      .   ' \\| |//    `.   
--                     / \\|||   :   |||// \   
--                    /  _||||| -:- |||||-  \   
--                   |    | \\\  -  /// |    |   
--                   |  \_|  ''\---/''  |    |   
--                   \   .-\__  `-` ___/-.   /   
--                 ___`.  .'  /--.--\  `.  .'___   
--                ."" '< `.___\_<|>_/___. '>' "".   
--               | | : `- \`.;`\ _ /`;.`/ - ` : | |   
--               \ \ `-.   \_ __\ /__ _/   .-`  / /   
--         ======`-.____`-.___\_____/___.-`____.-'======   
--                            `=---='   
--   
--         .............................................   
--                  佛祖镇楼                  BUG辟易   


herodata = {
    heroes = {},
    form = {}, -- 阵法中的英雄
    sevenForm = {}, -- 七星阵上阵的英雄
}

local pairs = pairs

function herodata:getHeroConfig(heroId, awake)
    local conf = ConfigureStorage.heroConfig
    if awake then
        if awake == 1 then
            conf = ConfigureStorage.heroConfig2
        elseif awake == 2 then
            conf = ConfigureStorage.heroConfig3
        end
    end
    return conf[heroId]
end

function herodata:getAllConfigHeros(  )
    return ConfigureStorage.heroConfig
end

function herodata:getAllHandBookHeros(  )
    local retArray = {}
    local herosConfig = ConfigureStorage.heroConfig
    local myHeros = userdata.roster.heros
    local roster = {}
    for k,v in pairs(myHeros) do
        roster[v] = true
    end

    for heroId,heroContent in pairs(herosConfig) do
        local tempArray = {}
        tempArray["isOpen"] = 0
        if roster[heroId] then
            tempArray["isOpen"] = 1
            tempArray["wake"] = herodata:getHeroInfoById(heroId) ~= nil and 
                herodata:getHeroInfoById(heroId).wake or nil 
        end
        tempArray["content"] = heroContent
        table.insert(retArray,tempArray)
    end
    local function sortFu(a, b)
        if a.content.rank == b.content.rank then
            return a.content.heroId < b.content.heroId
        end
        return a.content.rank > b.content.rank
    end
    table.sort( retArray,sortFu )
    return retArray
end

-- 伙伴加经验
function herodata:addExp(hero, exp)
    hero.exp_now = hero.exp_now + exp
    hero.exp_all = hero.exp_all + exp
    local conf = herodata:getHeroConfig(hero.heroId, hero.wake)
    while true do
        local expMax = ConfigureStorage.levelExp[tostring(hero.level)].value2 * conf.exp
        if hero.level >= userdata.level * 3 then
            if hero.exp_now > expMax then
                local overExp = hero.exp_now - expMax + 1
                hero.exp_now = expMax - 1
                hero.exp_all = hero.exp_all - overExp
            end
            break
        end
        if hero.exp_now < expMax then
            break
        end
        hero.exp_now = hero.exp_now - expMax
        hero.level = hero.level + 1
        hero.point = hero.point + ConfigureStorage.heroRecuit[tostring(conf.rank)].capacity
    end
end

-- 伙伴升级
function herodata:upgradeHeroes()
    for k,hero in pairs(herodata.heroes) do
        herodata:addExp(hero, 0)
    end
end

function herodata:addExpByHeroUId(hid, exp)
    local hero = herodata.heroes[hid]
    herodata:addExp(hero, exp)
end

-- 增加上阵伙伴经验
function herodata:addExpInForm(exp)
    for k,hid in pairs(herodata.form) do
        herodata:addExpByHeroUId(hid, exp)
    end
end

-- 模拟伙伴加经验
-- 返回模拟升级后的数据
function herodata:simAddExp(heroUId ,exp)
    local hero = deepcopy(herodata.heroes[heroUId])
    herodata:addExp(hero, exp)
    return hero
end

-- 获取英雄初始身价
function herodata:getHeroPriceConfig(heroId, awake)
    local conf = herodata:getHeroConfig(heroId, awake)
    if not conf or not conf.worth then
        return 0
    end
    return conf.worth
end

-- 获取英雄净身价 （除开装备奥义）
function herodata:getHeroAttrPrice(hid)
    local hero = herodata.heroes[hid]
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
function herodata:getHeroPrice(hid)
    local price = herodata:getHeroAttrPrice(hid) -- 英雄净身价
    local hero = herodata.heroes[hid]
    -- 武器的身价
    for k,eid in pairs(hero.equip) do
        price = price + equipdata:getEquipPriceByEid(eid)
    end
    -- 技能的身价
    for k,skill in pairs(skilldata:getHeroSkills(hid)) do
        price = price + skilldata:getSkillPrice(skill.skillId, skill.level)
    end
    return price
end


-- 获取英雄缘分
function herodata:getComboByHid(hid)
    local hero = herodata.heroes[hid]
    local heroId = hero.heroId
    local array = {}
    local combo = deepcopy(ConfigureStorage.combo[heroId])
    if not combo then
        return array
    end
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
                if not herodata:bHeroOnFormByHeroId(v) then
                    flag = false
                    break
                else
                    flag = true
                end
            end
        elseif conf.type == 2 then
            -- 装备
            for i,v in ipairs(conf.equips) do
                if not equipdata:bEquipOnHero(v, hid) then
                    flag = false
                    break
                else
                    flag = true
                end
            end
        elseif conf.type == 3 then
            -- 技能
            for j,v in ipairs(conf.books) do
                if not skilldata:bskillOnHero(v, hid) then
                    flag = false
                    break
                else
                    flag = true
                end
            end
            local dic  = 1
        end
        local dic = {["name"] = conf.name, ["flag"] = flag, ["param"] = conf.param}
        table.insert(array, dic)
    end
    return array
end

-- 获取缘分信息
function herodata:getComboInfoByHeroId(heroId, awake)
    local ret = ""
    local combo = deepcopy(ConfigureStorage.combo[heroId])
    if awake and awake == 2 then
        local combo5 = ConfigureStorage.combo5[heroId] 
        for i,v in ipairs(combo5) do
            combo[#combo + 1] = v;
        end
    end
    if not combo then
        return ret
    end
    for i,conf in ipairs(combo) do
        if conf.type == 1 then
            local name = ""
            for j,id in ipairs(conf.heroes) do
                local config = herodata:getHeroConfig(id)
                name = name..config.name
                if j < #conf.heroes then
                    name = name..","
                end
            end
            local key
            local value
            for k,v in pairs(conf.param) do
                key = k
                value = v * 100
            end
            ret = HLNSLocalizedString("combo.text", ret, conf.name, HLNSLocalizedString("combo.heroes", name), HLNSLocalizedString(key), value)
        elseif conf.type == 2 then
            local name = ""
            for j,id in ipairs(conf.equips) do
                local config = equipdata:getEquipConfig(id)
                name = name..config.name
                if j < #conf.equips then
                    name = name..","
                end
            end
            local key
            local value
            for k,v in pairs(conf.param) do
                key = k
                value = v * 100
            end
            ret = HLNSLocalizedString("combo.text", ret, conf.name, HLNSLocalizedString("combo.equips", name), HLNSLocalizedString(key), value)
        elseif conf.type == 3 then
            local name = ""
            for j,id in ipairs(conf.books) do
                local config = skilldata:getSkillConfig(id)
                name = name..config.name
                if j < #conf.books then
                    name = name..","
                end
            end
            local key
            local value
            for k,v in pairs(conf.param) do
                key = k
                value = v * 100
            end
            ret = HLNSLocalizedString("combo.text", ret, conf.name, HLNSLocalizedString("combo.equips", name), HLNSLocalizedString(key), value)
        end
        ret = string.format("%s\r\n", ret)
    end
    return ret
end

function herodata:fixRank(rank, awake)
    if not awake or awake < 1 then
        return rank
    end
    if awake == 1 then
        rank = 4
    elseif awake == 2 then
        rank = 5
    end
    return rank
end

-- 获得英雄 对觉醒 rank 作了处理
function herodata:getHero(dic)
    local hero = deepcopy(dic)
    local conf = herodata:getHeroConfig(hero.heroId, hero.wake)
    hero.name = conf.name
    hero.confId = conf.heroId
    hero.rank = conf.rank
    hero.skill_default.skill_default = conf.skill
    if hero.wake then
        if hero.wake == 1 then
            hero.rank = 4
        elseif hero.wake == 2 then
            hero.rank = 5
        end
    end 
    hero.desp = conf.desp
    hero.expMax = ConfigureStorage.levelExp[tostring(hero.level)].value2 * conf.exp
    hero.price = herodata:getHeroPrice(hero.id)
    return hero
end

-- 根据英雄id获取英雄的基本数据
-- 参数：英雄id
function herodata:getHeroBasicInfoByHeroId(heroId, awake)
    if nil == heroId or string.len(heroId) == 0 then
        return nil
    end
    return herodata:getHeroConfig(heroId, awake)
end

-- 删除某个英雄
function herodata:reduceHeroByUId( heroUId )
    if nil == heroUId or string.len(heroUId) == 0 or herodata.heroes[heroUId] == nil then
        return
    end
    herodata.heroes[heroUId] = nil
end

-- 新增或修改英雄数据
function herodata:addHeroByDic( dic )
    herodata.heroes[dic["id"]] = dic
end

-- 获取突破属性成长
function herodata:getHeroBreakAttrUp(heroId, awake)
    -- body
    local conf = herodata:getHeroConfig(heroId, awake)
    return conf.breakattr
end

-- 获取英雄基础属性数值， 不包含装备等加成
-- 参数：英雄uid
-- 返回：英雄属性数值
function herodata:getHeroBasicAttrsByHeroUId(heroUId)
    if nil == heroUId or string.len(heroUId) == 0 then
        return nil
    end
    local hero = herodata.heroes[heroUId]
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
    for k,v in pairs(herodata.heroes[heroUId].attrFix) do
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
function herodata:getSevenFormAttr()
    local attr = {}
    for i=1,7 do
        local state = userdata:formSevenState(i)
        if state == 3 then
            local confUpgrade = ConfigureStorage.formSevenUpgrade[i]
            local hid = userdata:getFormSevenByIndex(i)
            local key = ConfigureStorage.formSevenAttr[i].attr
            local per = confUpgrade[userdata:getFormSevenLv(i) + 1]
            local base = herodata:getHeroBasicAttrsByHeroUId(hid)
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



-- 获取英雄属性数值和附加属性，供后续计算
-- 参数：英雄uid
-- 返回：英雄属性数值
function herodata:getHeroAttrsAndAddByHeroUId(heroUId) 
    if nil == heroUId or string.len(heroUId) == 0 then
        return nil
    end
    local hero = herodata.heroes[heroUId]
    local heroId = hero.heroId
    if nil == heroId or string.len(heroId) == 0 then
        return nil
    end
    local heroConfig = herodata:getHeroConfig(heroId, hero.wake)

    local attr = herodata:getHeroBasicAttrsByHeroUId(heroUId) -- 基础属性
    local addAttr = {} -- 缘分附加属性百分比
    -- 闭关属性
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
        local equipId = equipdata.equips[id]["equipId"]
        local level = equipdata.equips[id]["level"]
        local refineLevel = equipdata.equips[id].stage
        local equipConfig = equipdata:getEquipConfig(equipId)
        local value = 0
        if equipdata.equips[id].advanced and equipdata.equips[id].advanced > 0 then
            local advanced = equipdata.equips[id].advanced
            local equipType
            if equipConfig.type == 0 then
                equipType = "weapon"
            elseif equipConfig.type == 1 then
                equipType = "belt"
            elseif equipConfig.type == 2 then
                equipType = "armor"
            elseif equipConfig.type == 3 then
                equipType = "rune"
            end
            
            local cCfg = nil
            if equipConfig.rank == 3 then
                cCfg = ConfigureStorage.equip_blue_awave
            elseif equipConfig.rank == 4 then
                cCfg = ConfigureStorage.equip_pur_awave
            elseif equipConfig.rank == 5 then
                cCfg = ConfigureStorage.equip_gold_awave
            end
            
            if cCfg then
                for i=1,equipdata.equips[id].advanced do
                    value = value + cCfg[tostring(advanced)].typeawaveplus[equipType]
                end
            end
        end

        

        if equipConfig.initial and type(equipConfig.initial) == "table" then
            for k,v in pairs(equipConfig.initial) do
                if equipConfig.refine then
                    v = v + math.floor((equipConfig.updateEffect + equipConfig.refine * refineLevel) * (level - 1))
                else
                    v = v + math.floor(equipConfig.updateEffect * (level - 1))
                end
                if attr[k] then
                    attr[k] = attr[k] + v + value
                else
                    attr[k] = v + value
                end
            end
        end
    end
     -- 战舰
    for k,v in pairs(battleShipData.attrFix) do
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
    -- 七星阵
    for k,v in pairs(herodata:getSevenFormAttr()) do
        if attr[k] then
            attr[k] = attr[k] + v
        else
            attr[k] = v
        end
    end
    -- 真气
    if hero.shadows then
        for k,v in pairs(hero.shadows) do
            local shadow = shadowData.allShadows[v]
            local dic = shadowData:getShadowAttrByLevelAndCid( shadow.level, shadow.shadowId )
            if attr[dic["type"]] then
                attr[dic["type"]] = attr[dic["type"]] + dic["value"]
            else
                attr[dic["type"]] = dic["value"]
            end
        end
    end

    -- 缘分
    local combos = herodata:getComboByHid(heroUId)
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
    local skills = skilldata:getHeroSkills(heroUId)
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
    local haki = herodata:getHakiInfo(hero)
    local hakiAttr = herodata:getHakiAttr(haki)
    for k,v in pairs(hakiAttr) do
        if attr[k] then
            attr[k] = attr[k] + v
        else
            attr[k] = v
        end
    end

    -- 属性加成不计算
    -- for k,v in pairs(addAttr) do
    --     if attr[k] then
    --         attr[k] = math.floor(attr[k] * (1 + v))
    --     end
    -- end
    return attr, addAttr
end

-- 获取英雄属性数值
-- 参数：英雄uid
-- 返回：英雄属性数值
function herodata:getHeroAttrsByHeroUId( heroUId ) 
    local attr, addAttr = herodata:getHeroAttrsAndAddByHeroUId(heroUId)
    -- 属性加成
    for k,v in pairs(addAttr) do
        if attr[k] then
            attr[k] = math.floor(attr[k] * (1 + v))
        end
    end
    return attr
end

-- 获取英雄数据
-- 参数：英雄uid
-- 返回：英雄数据
function herodata:getHeroInfoByHeroUId( heroUId ) 
    if nil == heroUId or string.len(heroUId) == 0 then
        return nil
    end
    return herodata:getHero(herodata.heroes[heroUId])
end

-- 获取英雄数据
-- 参数：英雄id
-- 返回：英雄数据
function herodata:getHeroInfoById( heroId ) 
    if nil == heroId or string.len(heroId) == 0 then
        return nil
    end
    for k,v in pairs(herodata.heroes) do
        local heroInfo = v
        if heroId == heroInfo["heroId"] then
            return herodata:getHero(heroInfo)
        end
    end

    return nil
end

-- 获取英雄id通过英雄UID
function herodata:getHeroIdByUId( heroUId )
    local heroInfo = herodata:getHeroInfoByHeroUId( heroUId ) 
    if heroInfo then
        return heroInfo.heroId
    end 
    return nil
end

-- 判断英雄列表是否存在某个英雄
-- 参数：英雄id
-- 返回：true/false
function herodata:isHeroById( heroId ) 
    if nil == heroId or string.len(heroId) == 0 then
        return false
    end
    for k,v in pairs(herodata.heroes) do
        if heroId == v.heroId then
            return true
        end
    end

    return false
end

-- 获取可以觉醒的英雄
-- 返回：按顺序返回伙伴列表中显示所需数据
function herodata:getAllAwakeHeroes()
    local awakeablehero = ConfigureStorage.awave_Onornot
    local heroes = {}
    for k,v in pairs(herodata.heroes) do
        local hero = herodata:getHero(v)
        if awakeablehero[hero.confId] and awakeablehero[hero.confId].onornot > 0 and v.level >= 80 and hero.rank < 5 then
            hero.form = table.ContainsObject(herodata.form, hero.id) and 1 or 0
            table.insert(heroes, hero)
        end
    end
    local function sortFun(a, b)
        -- 1. 上阵优先
        if a.form == b.form then
            -- 2. 品质降序
            if a.rank == b.rank then
                -- 3. 等级降序
                if a.level == b.level then
                    -- 4. 身价降序
                    if a.price == b.price then
                        -- 5. 名字升序
                        return a.name < b.name
                    end
                    return a.price > b.price
                end
                return a.level > b.level
            end
            return a.rank > b.rank
        end
        return a.form > b.form
    end
    table.sort( heroes, sortFun )
    
    return heroes
end
-- 获取所有的弟子
-- 返回：按顺序返回伙伴列表中显示所需数据
function herodata:getAllHeroes()
    local heroes = {}
    for k,v in pairs(herodata.heroes) do
        local hero = herodata:getHero(v)
        hero.form = table.ContainsObject(herodata.form, hero.id) and 1 or 0
        table.insert(heroes, hero)
    end
    local function sortFun(a, b)
        -- 1. 上阵优先
        if a.form == b.form then
            -- 2. 品质降序
            if a.rank == b.rank then
                -- 3. 等级降序
                if a.level == b.level then
                    -- 4. 身价降序
                    if a.price == b.price then
                        -- 5. 名字升序
                        return a.name < b.name
                    end
                    return a.price > b.price
                end
                return a.level > b.level
            end
            return a.rank > b.rank
        end
        return a.form > b.form
    end
    table.sort( heroes, sortFun )

    return heroes
end

-- 根据herouid查询是否上阵
function herodata:bHeroOnForm(hid)
    for k,id in pairs(herodata.form) do
        if id and id ~= "" and id == hid then
            return true
        end
    end
    for k,id in pairs(herodata.sevenForm) do
        if id and id ~= "" and id == hid then
            return true
        end
    end
    return false
end

-- 根据heroid查询是否上阵
function herodata:bHeroOnFormByHeroId(heroId)
    for k,id in pairs(herodata.form) do
        if id and id ~= "" and herodata.heroes[id].heroId == heroId then
            return true
        end
    end
    for k,id in pairs(herodata.sevenForm) do
        if id and id ~= "" and herodata.heroes[id].heroId == heroId then
            return true
        end
    end
    return false
end

-- 获取未上阵英雄
function herodata:getHeroOffForm()
    local array = {}
    for hid,dic in pairs(herodata.heroes) do
        if not herodata:bHeroOnForm(hid) then
            table.insert(array, hid)
        end
    end
    local function sortFun(a, b)
        local ha = herodata:getHeroInfoByHeroUId(a)
        local hb = herodata:getHeroInfoByHeroUId(b)
        if ha.level == hb.level then
            if ha.rank == hb.rank then
                return ha.price > hb.price
            end
            return ha.rank > hb.rank
        end
        return ha.level > hb.level
    end
    table.sort( array,sortFun )
    return array
end

-- 获取上阵英雄
function herodata:getHeroOnForm()
    local array = {}
    for k,hid in pairs(herodata.form) do
        table.insert(array, herodata:getHeroInfoByHeroUId(hid))
    end
    local function sortFun(a, b)
        if a.rank == b.rank then
            return a.level > b.level
        end
        return a.rank > b.rank
    end
    table.sort(array, sortFun)
    return array
end

-- 上阵且可特训的英雄
function herodata:getHeroOnFormCanInstruct()
    local array = {}
    for k,hid in pairs(herodata.form) do
        local hero = herodata:getHeroInfoByHeroUId(hid)
        local conf = herodata:getHeroConfig(hero.heroId, hero.wake)
        local expMax = ConfigureStorage.levelExp[tostring(hero.level)].value2 * conf.exp
        if hero.level == userdata.level * 3 and hero.exp_now == expMax - 1 then
            -- 不可特训
        else
            table.insert(array, hero)
        end
    end
    local function sortFun(a, b)
        if a.rank == b.rank then
            return a.level > b.level
        end
        return a.rank > b.rank 
    end
    table.sort(array, sortFun)
    return array
end

-- 获得可以送别的弟子
function herodata:getCanFarewellHeroes(desHeroUId)
    local array = {}
    local heroes = herodata.heroes
    for heroUId,dic in pairs(heroes) do
        if dic.level > 1 and not herodata:bHeroOnForm(heroUId) and desHeroUId ~= heroUId then
            table.insert(array, heroUId)
        end
    end
    local function sortFun(a, b)
        local ha = herodata:getHeroInfoByHeroUId(a)
        local hb = herodata:getHeroInfoByHeroUId(b)
        if ha.level == hb.level then
            if ha.rank == hb.rank then
                return ha.price > hb.price
            end
            return ha.rank > hb.rank
        end
        return ha.level > hb.level
    end
    table.sort( array,sortFun )
    return array
end

-- 根据品阶获得英雄uid数组
-- 参数 rank
function herodata:getHeroUIdArrByRank( rank )
    local array = {}
    local heroes = herodata.heroes
    for heroUId,dic in pairs(heroes) do
        local conf = herodata:getHeroConfig(dic.heroId)
        if tonumber(conf.rank) == rank then
            table.insert(array, heroUId)
        end
    end
    return array
end

-- 根据高于品阶获得英雄uid数组
-- 参数 rank
function herodata:getHeroUIdArrByThanRank( rank )
    local array = {}
    local heroes = herodata.heroes
    for heroUId,dic in pairs(heroes) do
        local conf = herodata:getHeroInfoById(dic.heroId)
        if tonumber(conf.rank) >= rank then
            table.insert(array, heroUId)
        end
    end
    return array
end

-- 获得战舰升级可用英雄的数据
-- 返回：战舰升级ui显示所需信息
function herodata:getBattleShipStuffHeroes()
    local array = {}
    local heroes = herodata.heroes
    for heroUId,v in pairs(heroes) do
        if not herodata:bHeroOnForm(heroUId) then
            local hero = herodata:getHero(v)
            table.insert(array, hero)
        end
    end
    local function sortFun(a, b)
        -- 2. 品质降序
        if a.rank == b.rank then
            -- 3. 等级降序
            if a.level == b.level then
                -- 4. 身价降序
                if a.price == b.price then
                    -- 5. 名字升序
                    return a.name < b.name
                end
                return a.price < b.price
            end
            return a.level < b.level
        end
        return a.rank < b.rank
    end
    table.sort( array,sortFun )
    return array
end

-- 获得送别返回蓝波球数量
function herodata:getFarewellLanBoForHeroUId(heroUId)
    local heroInfo = herodata:getHeroInfoByHeroUId(heroUId)
    if heroInfo ~= nil then
        local point = 0
        for k,v in pairs(heroInfo.attrFix) do
            point = point + v 
        end
        return math.floor(point * 0.8)
    end 
    return 0
end

-- 获得英雄头像名称
function herodata:getHeroHeadByHeroId( heroId )
    local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
    cache:addSpriteFramesWithFile("ccbResources/hero_head2.plist")
    if nil == heroId or string.len(heroId) == 0 then
        return nil
    end
    -- if isPlatform(IOS_APPLE_ZH) and (heroId == "hero_000304" or heroId == "hero_000307") then
    --     local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
    --     cache:addSpriteFramesWithFile("ccbResources/appstore_replace.plist")
    --     return string.format("%s_head_appstore.png", heroId)
    -- else
        return string.format("%s_head.png", heroId)
    -- end
end

-- 获得英雄大半身像名称
function herodata:getHeroBust1ByHeroId( heroId )
    if nil == heroId or string.len(heroId) == 0 then
        return nil
    end
    if isPlatform(IOS_APPLE_ZH) and (heroId == "hero_000304" or heroId == "hero_000307") then
        return string.format("ccbResources/hero_bust_1/%s_bust_1_appstore.png", heroId)
    else
        return string.format("ccbResources/hero_bust_1/%s_bust_1.png", heroId)
    end
end

-- 获得英雄小半身像名称
function herodata:getHeroBust2ByHeroId(heroId)
    if nil == heroId or string.len(heroId) == 0 then
        return nil
    end
    if isPlatform(IOS_APPLE_ZH) and (heroId == "hero_000304" or heroId == "hero_000307") then
        return string.format("ccbResources/hero_bust_2/%s_bust_2_appstore.png", heroId)
    else
        return string.format("ccbResources/hero_bust_2/%s_bust_2.png", heroId)
    end
end

-- 获得英雄动作的plist
function herodata:getHeroAnimationByHeroId( heroId )
    if nil == heroId or string.len(heroId) == 0 then
        return nil
    end
    return string.format("ccbResources/hero_Animation/%s.plist", heroId)
end

-- 获得英雄攻击时的粒子效果
function herodata:getHeroAttackingEffectByResId( resId )
    if nil == resId or string.len(resId) == 0 then
        return nil
    end
    local aniConf = ConfigureStorage.animation[resId]
    if aniConf and aniConf.eff then
        return string.format("images/%s", aniConf.eff)
    else
        return nil
    end
end

-- 获得英雄攻击时的粒子效果
function herodata:getHeroAttackingEffectOffsetByResId( resId )
    if nil == resId or string.len(resId) == 0 then
        return nil
    end
    local aniConf = ConfigureStorage.animation[resId]
    if aniConf and aniConf.offset then
        return aniConf.offset
    else
        return {0,0}
    end
end

-- 获得英雄动作的plist
function herodata:getHeroAnimationByResId( resId )
    if nil == resId or string.len(resId) == 0 then
        return nil
    end
    local aniConf = ConfigureStorage.animation[resId]
    if aniConf and aniConf.animation then
        return string.format("ccbResources/hero_Animation/%s", aniConf.animation)
    else
        return nil
    end
end

-- 获得avatar的动作action
function herodata:getAvatarActionByHeroId( avatar, heroId )
    if avatar then
        tolua.cast(avatar, "CCSprite"):stopAllActions()
    end
    CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(herodata:getHeroAnimationByHeroId(heroId))
    local aniRes = string.format("%s_stand_0001.png", heroId)
    local heroStandFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(aniRes)
    if heroStandFrame == nil then
        return 
    end 
    avatar:setDisplayFrame(heroStandFrame)

    local standFrame = CCArray:create()
    for i = 1, 4 do
        local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("%s_stand_000%d.png", heroId, i))
        if not frame then
            return 
        end
        standFrame:addObject(frame)
    end

    local standAnimation = CCAnimation:createWithSpriteFrames(standFrame, 0.1)
    local standAction = CCAnimate:create(standAnimation)
    local repeatStand = CCRepeatForever:create(standAction)
    avatar:runAction(repeatStand)
end

--重置用户数据
function herodata:resetAllData()
    herodata.heroes = {}
    herodata.form = {}
    herodata.sevenForm = {}
end

-- 无风带相关
-- 返回一个英雄的无风带数据
function herodata:getDisciplineDataByUid( uid )
    local heroDic = herodata:getHeroInfoByHeroUId( k ) 
    if heroDic.discipline then
        return heroDic.discipline
    end
    return nil
end
-- 判断是否有英雄正在修炼
function herodata:isTrainingHeroUID(  )
    for k,v in pairs(herodata.heroes) do
        if v.discipline then
            if v.discipline.on and v.discipline.on == 1 then
                return herodata:getHeroInfoByHeroUId( k ) 
            end
        end
    end
    return nil
end
-- 获得可以去无风带的英雄  
function herodata:getCanTrainHeros(  )
    local retArray = {}
    for k,v in pairs(herodata.heroes) do
        if v.level >= ConfigureStorage.nowindUpdate["1"].herolevel then
            local heroDic = herodata:getHeroInfoByHeroUId( k ) 
            table.insert(retArray,heroDic)
        end
    end  
    local function sortFun( a,b )
        if a.rank == b.rank then
            if a.disciplineLv == b.disciplineLv then
                return a.level > b.level
            end
            return a.disciplineLv > b.disciplineLv
        end
        return a.rank > b.rank
    end
    table.sort( retArray,sortFun )
    return retArray
end
-- 根据英雄配置id和训练等级得到属性值
function herodata:getTrainArrByHeroIdAndlevel(heroId, level, awake)
    local arr = {}
    local hero = herodata:getHeroConfig(heroId, awake)
    if not hero then
        print("ConfigureStorage isn't have this hero   ",heroId)
    elseif not hero.specialadd then
        print("specialadd is not exist")
    else
        arr["type"] = hero.specialadd["attr"]
        if level >= 1 then
            arr["value"] = math.floor(hero.specialadd["value"] + hero.specialadd.lv * (level - 1)) 
        else
            arr["value"] = 0
        end
    end
    return arr
end

-- 获取英雄的修炼等级
-- 参数：英雄唯一id
-- 返回：英雄的训练等级
function herodata:getOneHeroTrainLevel( heroUId )
    local trainLevel = 0
    if nil == heroUId or string.len(heroUId) == 0 then
        print("uid is error",heroUId)
        return 0
    end
    local hero = herodata.heroes[heroUId]
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

-- 获取一个英雄的训练条件
-- 参数：英雄的训练等级
function herodata:getUpgrateConditionByLevel( level )
    local retArray = {}
    local conf = ConfigureStorage.nowindUpdate[tostring(level)]
    if conf then
        retArray["lifebelt"] = conf.lifebelt
        retArray["herolevel"] = conf.herolevel
    end
    return retArray
end

function herodata:isCalmBeltOpen(  )
    -- return false
    if ConfigureStorage.levelOpen.nowind and userdata.level >= ConfigureStorage.levelOpen.nowind.level then
        return true
    end
    return false
end

-- 获得无风带总时长
function herodata:getcalmBeltTimeTotle(  )
    return ConfigureStorage.nowindtime["1"]["maxHour"] * 60 * 60
end

function herodata:getEachTimeSortTime(  )
    return ConfigureStorage.nowindtime["1"]["shortenHour"]
end

function herodata:getcalmBeltMinTime(  )
    return ConfigureStorage.nowindtime["1"]["minHour"]
end

-- 获得英雄霸气信息
function herodata:getHakiInfo(hero)
    local aggress
    if type(hero) == "string" then
        hero = herodata.heroes[hero]
    end
    local aggress = hero.aggress or {kind = 1, layer = 1, base = 0, pre = 0}
    return aggress
end

function herodata:nextBall(t)
    local k = t.kind
    local l = t.layer
    local b = t.base + 1
    local p = t.pre
    l = b > 30 and l + 1 or l
    k = l > 8 and k + 1 or k
    l = l > 8 and l - 8 or l
    b = b > 30 and b - 30 or b
    p = b == 0 and 0 or p
    return {kind = k, layer = l, base = b, pre = p}
end

-- 获取霸气球的信息
-- {kind = 1, layer = 1, base = 0, pre = 0}
function herodata:getHakiBallInfo(haki)
    local array = {}
    local pre = deepcopy(haki)
    array[1] = pre
    array[2] = herodata:nextBall(array[1])
    array[3] = herodata:nextBall(array[2])
    return array
end

-- 获取霸气训练消耗热血值
function herodata:getHakiTrainCost(haki)
    local k = haki.kind
    local l = haki.layer
    local b = haki.base + 1
    local conf = ConfigureStorage.aggress_data[string.format("data_%d_%d_%d", k, l, b)] or {}
    return conf.conmuse
end

-- 获取霸气训练消耗总热血值
function herodata:getHakiTrainTotalCost(haki)
    local total = 0
    local base, layer, kind = haki.base, haki.layer, haki.kind
    local k, l, b = 1, 1, 1
    while true do
        if b > base and k >= kind and l >= layer then
            break
        end
        local conf = ConfigureStorage.aggress_data[string.format("data_%d_%d_%d", k, l, b)] or {}
        total = total + (conf.conmuse or 0)
        b = b + 1
        if b > 30 then
            b = 1
            l = l + 1
        end
        if l > 8 then
            l = 1
            k = k + 1
        end
    end
    return total
end
-- 获取已获得的霸气属性值
function herodata:getHakiAttr(haki)
    local attr = {hp = 0, atk = 0, def = 0, mp = 0, cri = 0, dod = 0, parry = 0, resi = 0, hit = 0, cnt = 0}
    local base = haki.base
    local layer = haki.layer
    local kind = haki.kind
    local k, l, b = 1, 1, 1
    while true do
        if b > base and k >= kind and l >= layer then
            break
        end
        local conf = ConfigureStorage.aggress_data[string.format("data_%d_%d_%d", k, l, b)]
        for key,v in pairs(attr) do
            attr[key] = attr[key] + conf[key]
        end
        b = b + 1
        if b > 30 then
            b = 1
            l = l + 1
        end
        if l > 8 then
            l = 1
            k = k + 1
        end
    end

    layer = layer - 1
    kind = layer == 0 and kind - 1 or kind
    layer = layer == 0 and 8 or layer
    local add = {hp = 0, atk = 0, def = 0, mp = 0, cri = 0, dod = 0, parry = 0, resi = 0, hit = 0, cnt = 0}
    for i = 1, kind do
        for j = 1, layer do
            local conf = ConfigureStorage.aggress_roundattr["roundattr_" .. i .. "_" .. j]
            for k,v in pairs(add) do
                add[k] = v + (conf[k] or 0)
            end
        end
    end
    for k,v in pairs(attr) do
        attr[k] = math.floor(v * (1 + add[k]))
    end
    return attr
end

-- 获得霸气开启战斗前的对话
function herodata:getHakiTalk(haki)
    return deepcopy(ConfigureStorage.aggress_roundtalk[string.format("rtalk_%d_%d", haki.kind, haki.layer)])
end

-- 获取每种训练获得的加成
function herodata:getTrainAttr(kind, layer)
    return ConfigureStorage.aggress_roundattr["roundattr_" .. kind .. "_" .. layer].said
end

function herodata:hakiBallAttr(kind, layer, base)
    local conf = ConfigureStorage.aggress_data[string.format("data_%d_%d_%d", kind, layer, base)] or {}
    local attr = {hp = 0, atk = 0, def = 0, mp = 0, cri = 0, dod = 0, parry = 0, resi = 0, hit = 0, cnt = 0}
    for key,v in pairs(attr) do
        attr[key] = attr[key] + (conf[key] or 0)
    end
    return attr
end

-- 获取单个球已获得的属性
function herodata:getBallAttr(kind, layer, base)
    local attr = {hp = 0, atk = 0, def = 0, mp = 0, cri = 0, dod = 0, parry = 0, resi = 0, hit = 0, cnt = 0}
    for i = 1, layer do
        local a = herodata:hakiBallAttr(kind, i, base)
        for key,v in pairs(a) do
            attr[key] = attr[key] + v
        end
    end
    return attr
end

function herodata:getNextAttr(haki)
    local n = herodata:nextBall(haki)
    return herodata:hakiBallAttr(n.kind, n.layer, n.base)
end
