-- 用户数据缓存

skilldata = {
    skills
}

local pairs = pairs

function skilldata:getOwnerBySUid(sid)
    local form = herodata.form
    for k,hid in pairs(form) do
        local hero = deepcopy(herodata.heroes[hid])
        if hero.skills_ex then
            for i=1,3 do
                local suid = hero.skills_ex[tostring(i)]
                if suid and suid == sid then
                    hero["name"] = herodata:getHeroConfig(hero.heroId).name
                    return hero
                end
            end
        end
    end
    return nil
end

function skilldata:getSkillCountById( skillid )
    local skills = deepcopy(skilldata.skills)
    local count = 0
    for k,v in pairs(skills) do
        if v.skillId == skillid then
            if not skilldata:getOwnerBySUid(k) then
                count = count + 1
            end
        end
    end
    return count
end

function skilldata:getSkillConfig(skillId) -- 参数 : 技能配置id book_000101
    return deepcopy(ConfigureStorage.skillConfig[skillId])
end

function skilldata:getSkill(skillId, level, heroId)
    local conf = skilldata:getSkillConfig(skillId)
    local skill = {}
    skill.skillId = skillId
    skill.skillType = conf.type -- 1:百分比buff 2:群体攻击all 3:single  4:全体buff  5： 固定值buff
    skill.skillName = conf.name
    skill.skillLevel = level
    skill.skillRank = conf.rank
    skill.attr = {}
    for k,v in pairs(conf.attr) do
    	skill.attr[k] = v + conf.attrlv * (level - 1)
    end
    skill.per = conf.trigger
    if heroId and conf.link and conf.link[heroId] then
        skill.per = skill.per + conf.link[heroId]
    end
    if conf.range then
        skill.range = conf.range -- 1:近战 2:远程
    end
    return skill
end

-- 获取英雄的天赋技能的基本配置信息
-- 参数 英雄id
function skilldata:getHeroInnateSkillByHeroId( heroId ,awake)
    local heroConf = herodata:getHeroConfig(heroId,awake)
    if heroConf then
        return skilldata:getSkillConfig(heroConf.skill)
    end 
    return nil
end

-- 获取英雄身上所有装备的技能
-- 参数 英雄唯一id
function skilldata:getHeroSkills(hid)
    local dic = {}
    local hero = herodata.heroes[hid]
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
                dic[tostring(i)] = skilldata.skills[sid]
            end
        end
    end
    return dic
end

-- 英雄是否装备了指定技能
function skilldata:bskillOnHero(skillId, hid)
    for k,skill in pairs(skilldata:getHeroSkills(hid)) do
        if skill.skillId == skillId then
            return true
        end
    end
    return false
end

-- 获取英雄身上某条装备技能详细信息
-- 参数 英雄装备技能字典 
function skilldata:getEquipedSkillByDic( skillContent )
    local skillArray = {}
    local skillId = skillContent["skillId"]
    local conf = skilldata:getSkillConfig(skillId)
    skillArray["skillConf"] = conf
    skillArray["id"] = skillContent["id"] 
    skillArray["exp"] = skillContent["exp"] 
    skillArray["skillId"] = skillContent["skillId"] 
    skillArray["level"] = skillContent["level"]
    for key,value in pairs(conf.attr) do
        local attArray = {}
        attArray[key] = value + (skillContent["level"] - 1) * conf.attrlv
        skillArray["attr"] = attArray
    end
    return skillArray
end

--根据唯一id得到技能属性类型

--得到武林谱中奥义信息
function skilldata:getAllHandBookSkills(  )
    local retArray = {}
    local skillsConfig = ConfigureStorage.skillConfig
    local mySkills = userdata.roster.books

    for skillId,skillContent in pairs(skillsConfig) do
        local tempArray = {}
        tempArray["isOpen"] = 0
        for k,v in pairs(mySkills) do
            if v == skillId then
                tempArray["isOpen"] = 1
            end
        end
        tempArray["content"] = skillContent
        tempArray["skillId"] = skillId
        
        table.insert(retArray,tempArray)
    end

    local function sortFun( a,b )
        if a.content.rank == b.content.rank then
            return a.skillId < b.skillId
        else
            return a.content.rank > b.content.rank
        end
    end
    table.sort( retArray,sortFun )
    return retArray
end

-- 得到一条技能内容
-- 唯一id
function skilldata:getSkillContentByUid( uniqueId )
    local skillContent
    if skilldata.skills then
        skillContent = skilldata.skills[tostring(uniqueId)]
        if skillContent then
            return skillContent
        end
    end
    local form = herodata.form
    for k,hid in pairs(form) do
        local hero = herodata.heroes[hid]
        local id = hero.skill_default.id
        if hero.wake and hero.wake > 0 then
            hero.skill_default.skillId = herodata:getHeroConfig(hero.heroId, hero.wake).skill
        end
        if id == uniqueId then
            skillContent = hero.skill_default
            return skillContent
        end
    end
    local sevenForm = herodata.sevenForm
    for k,hid in pairs(sevenForm) do
        local hero = herodata.heroes[hid]
        if hero then
            local id = hero.skill_default.id
            if hero.wake and hero.wake > 0 then
                id = herodata:getHeroConfig(hero.heroId, hero.wake).id
                hero.skill_default.skillId = herodata:getHeroConfig(hero.heroId, hero.wake).skill
            end
            if id == uniqueId then
                skillContent = hero.skill_default
                return skillContent
            end
        end
    end
    local offFormHero = herodata:getHeroOffForm()
    for i=1,getMyTableCount(offFormHero) do
        local hid = offFormHero[i]
        local hero = herodata.heroes[hid]
        local id = hero.skill_default.id
        if hero.wake and hero.wake > 0 then
            id = herodata:getHeroConfig(hero.heroId, hero.wake).id
            hero.skill_default.skillId = herodata:getHeroConfig(hero.heroId, hero.wake).skill
        end
        if id == uniqueId then
            skillContent = hero.skill_default
            return skillContent
        end
    end
    return skillContent
end

function skilldata:getSkillIdByUniqueId( uniqueId )
    local skillContent = skilldata:getSkillContentByUid( uniqueId )
    return skillContent.skillId
end

--根据唯一id得到一条skill信息
function skilldata:getOneSkillByUniqueID( uniqueId )
    local skillArray = {}
    local skillContent = skilldata:getSkillContentByUid( uniqueId )
    local skillId = skillContent.skillId
    local conf = skilldata:getSkillConfig(skillId)
    skillArray["skillConf"] = conf
    skillArray["id"] = skillContent["id"] 
    skillArray["exp"] = skillContent["exp"] 
    skillArray["skillId"] = skillContent["skillId"] 
    skillArray["level"] = skillContent["level"]
    for key,value in pairs(conf.attr) do
        local attArray = {}
        attArray[key] = value + (skillContent["level"] - 1) * conf.attrlv
        skillArray["attr"] = attArray
    end
    return skillArray
end

--根据技能唯一id和等级得到属性增加数组
function skilldata:getSkillAttrByLevelAndUID( level,uniqueId )
    local skillId = skilldata:getSkillIdByUniqueId( uniqueId )
    local conf = skilldata:getSkillConfig(skillId)
    local retArray = {}
    for key,value in pairs(conf.attr) do
        retArray[key] = value + conf.attrlv * level
    end
    return retArray
end

--获得玩家所有技能信息
function skilldata:getAllSkills()
    local skills = skilldata.skills
    local retArray = {}
    local owners = {}
    for k,hid in pairs(herodata.form) do
        local hero = herodata.heroes[hid]
        local name = herodata:getHeroConfig(hero.heroId).name
        if hero.wake and hero.wake > 0 then
            hero.skill_default.skillId = herodata:getHeroConfig(hero.heroId, hero.wake).skill
        end
        if hero.skill_default then
            owners[hero.skill_default.id] = name
        end
        if hero.skills_ex then
            for i=1,3 do
                local sid = hero.skills_ex[tostring(i)]
                if sid then
                    local ownerTable = {}
                    ownerTable["name"] = name
                    ownerTable["pos"] = k
                    owners[sid] = ownerTable
                end
            end
        end
    end
    for skillUniqueId,skillContent in pairs(skills) do
        local skillArray = {}
        local skillId = skillContent.skillId
        local conf = skilldata:getSkillConfig(skillId)
        skillArray["skillConf"] = conf
        skillArray["id"] = skillContent["id"] 
        skillArray["exp"] = skillContent["exp"] 
        skillArray["skillId"] = skillContent["skillId"] 
        skillArray["level"] = skillContent["level"]
        skillArray["owner"] = owners[skillUniqueId]
        for key,value in pairs(conf.attr) do
            local attArray = {}
            attArray[key] = value + (skillContent["level"] - 1) * conf.attrlv
            skillArray["attr"] = attArray
        end
        table.insert(retArray,skillArray)
    end
    local function sortFun( a,b )
        if (a.owner and b.owner) then
            if a.owner.pos == b.owner.pos then
                if a.skillConf.rank == b.skillConf.rank then
                    return a.level > b.level
                end
                return a.skillConf.rank > b.skillConf.rank
            end
            return a.owner.pos < b.owner.pos
        elseif (a.owner == nil and b.owner == nil) then
            if a.skillConf.rank == b.skillConf.rank then
                if a.skillId == b.skillId then
                    return a.level > b.level
                end
                return a.skillId < b.skillId
            end
            return a.skillConf.rank > b.skillConf.rank
        else
            return a.owner ~= nil
        end
    end
    table.sort( retArray,sortFun )
    return retArray
end
--根据技能的id判断是否是英雄的默认技能
function compare( Id )
    for k,hid in pairs(herodata.form) do
        local hero = herodata.heroes[hid]
        local skillId = hero.skill_default.id

        if Id == skillId then
            return false
        end
    end
    return true
end

--根据唯一ID得到其他技能
function skilldata:getOtherSkillsWithUniquieId( uniqueId )
    local retArray = {}
    local owners = {}
    for k,hid in pairs(herodata.form) do
        local hero = herodata.heroes[hid]
        local name = herodata:getHeroConfig(hero.heroId,hero.wake).name
        if hero.wake and hero.wake > 0 then
            hero.skill_default.skillId = herodata:getHeroConfig(hero.heroId, hero.wake).skill
        end
        if hero.skill_default then
            owners[hero.skill_default.id] = name
        end
        if hero.skills_ex then
            for i=1,3 do
                local sid = hero.skills_ex[tostring(i)]
                if sid then
                    local ownerTable = {}
                    ownerTable["name"] = name
                    ownerTable["pos"] = k
                    owners[sid] = ownerTable
                end
            end
        end
    end
    for skillUniqueId,skillContent in pairs(skilldata.skills) do
        if skillUniqueId ~= uniqueId and compare( skillContent.id ) then
            local skillArray = {}
            local skillId = skillContent.skillId
            local conf = skilldata:getSkillConfig(skillId)
            skillArray["skillConf"] = conf
            skillArray["id"] = skillContent["id"] 
            skillArray["exp"] = skillContent["exp"] 
            skillArray["skillId"] = skillContent["skillId"] 
            skillArray["level"] = skillContent["level"] 
            skillArray["owner"] = owners[skillUniqueId]
            for key,value in pairs(conf.attr) do
                local attArray = {}
                attArray[key] = value + (skillContent["level"] - 1) * conf.attrlv
                skillArray["attr"] = attArray
            end
            table.insert(retArray,skillArray)
        end
    end

    local function sortFun( a,b )
        if (a.owner and b.owner)then
            if a.owner.pos == b.owner.pos then
                if a.level == b.level then
                    return a.skillConf.rank < b.skillConf.rank
                end
                return a.level < b.level
            end
            return a.owner.pos > b.owner.pos
        elseif (a.owner == nil and b.owner == nil) then
            if a.skillConf.rank == b.skillConf.rank then
                return a.skillId > b.skillId
            end
            return a.skillConf.rank < b.skillConf.rank
        else
            return a.owner == nil
        end
    end
    table.sort( retArray,sortFun )

    return retArray
end

-- 根据技能唯一id和英雄唯一id获得可以更换的所有技能

function skilldata:getCanChangeSkills( heroUId,skillUId )
    local hero = herodata.heroes[heroUId]
    local allSkillArray = deepcopy(skilldata.skills)
    local defaultSkillId = hero.skill_default.skillId
    local otherSkillID
    for k,v in pairs(hero.skills_ex) do
        if v ~= skillUId then
            local oneSkill = skilldata:getOneSkillByUniqueID(v)
            otherSkillID = oneSkill.skillId
        end
    end
    for k,v in pairs(allSkillArray) do
        if v.skillId == defaultSkillId then
            allSkillArray[k] = nil
        end
        if otherSkillID then
            if v.skillId == otherSkillID then
                allSkillArray[k] = nil
            end
            -- if k == otherSkillID then
            --     allSkillArray[k] = nil
            -- end
        end
    end
    if skillUId then
        if allSkillArray[skillUId] then
            allSkillArray[skillUId] = nil
        end
    end
    local retArray = {}
    local owners = {}
    for k,hid in pairs(herodata.form) do
        local hero = herodata.heroes[hid]
        local name = herodata:getHeroConfig(hero.heroId).name
        if hero.skill_default then
            owners[hero.skill_default.id] = name
        end
        if hero.skills_ex then
            for i=1,3 do
                local sid = hero.skills_ex[tostring(i)]
                if sid then
                    owners[sid] = name
                end
            end
        end
    end
    for skillUniqueId,skillContent in pairs(allSkillArray) do
        local skillArray = {}
        local skillId = skillContent.skillId
        local conf = skilldata:getSkillConfig(skillId)
        skillArray["skillConf"] = conf
        skillArray["id"] = skillContent["id"] 
        skillArray["exp"] = skillContent["exp"] 
        skillArray["skillId"] = skillContent["skillId"] 
        skillArray["level"] = skillContent["level"]
        skillArray["owner"] = owners[skillUniqueId]
        for key,value in pairs(conf.attr) do
            local attArray = {}
            attArray[key] = value + (skillContent["level"] - 1) * conf.attrlv
            skillArray["attr"] = attArray
        end
        table.insert(retArray,skillArray)
    end
    local function sortFun( a,b )
        if a.skillConf.rank == b.skillConf.rank then
            if a.skillId == b.skillId then
                return a.level > b.level
            end
            return a.skillId < b.skillId
        end
        return a.skillConf.rank > b.skillConf.rank
    end
    table.sort( retArray,sortFun )
    return retArray
end

-- 根据技能品质和等级得到升级所需经验
function skilldata:getSkillEXPByRankAndLevel( rank,level )
    local skillLv = ConfigureStorage.skillLv
    local baseNeed = skillLv[tostring(rank)].exp
    return math.ldexp(baseNeed, level - 1)
end

-- 获取技能初始身价
function skilldata:getSkillPriceConfig(skillId)
    local conf = skilldata:getSkillConfig(skillId)
    if not conf or not conf.worth then
        return 0
    end
    return conf.worth
end

-- 技能身价
function skilldata:getSkillPrice(skillId, level)
    local price = skilldata:getSkillPriceConfig(skillId)
    local conf = skilldata:getSkillConfig(skillId)
    if not conf or not conf.worthgrow then
        return price
    end
    return price + math.floor(conf.worthgrow * (level - 1))
end

-- 身价计算
function skilldata:getSkillPriceBySid(sid) -- 参数 : 技能唯一id
    local skill = skilldata:getSkillContentByUid( sid )
    return skilldata:getSkillPrice(skill.skillId, skill.level)
end
-- 根据技能唯一id，显示属性加成字符串
function skilldata:getSkillAttrValueByUid( uid )
    local dic = skilldata:getOneSkillByUniqueID( uid )
    local myType
    local myAttrValue
    for key,value in pairs(dic.attr) do
        myType = key
        myAttrValue = value
    end
    if myAttrValue < 1 and myAttrValue > 0 then
        return string.format("+ %d%%",myAttrValue * 100)
    elseif myAttrValue >= 1 then
        return string.format("+ %d",myAttrValue)
    elseif myAttrValue <= 0 and myAttrValue >= -1 then
        return string.format("- %d%%",0 - myAttrValue * 100)
    elseif myAttrValue < -1 then
        return string.format("- %d",0 - myAttrValue * 100)
    end
end
-- 根据技能id获得技能属性值字符串
function skilldata:getSkillAttrStringByUid( uid )
    local dic = skilldata:getOneSkillByUniqueID( uid )
    local myType
    local myAttrValue
    for key,value in pairs(dic.attr) do
        myType = key
        myAttrValue = value
    end

    local attString
    
    if myAttrValue < 1 and myAttrValue > 0 then
        attString = myAttrValue * 100
    elseif myAttrValue >= 1 then
        attString = myAttrValue
    elseif myAttrValue <= 0 and myAttrValue >= -1 then
        attString = 0 - myAttrValue * 100
    elseif myAttrValue < -1 then
        attString = 0 - myAttrValue
    end
    return attString
end

-- 根据技能唯一id，显示属性加成描述字符串
function skilldata:getSkillDespArrtValueByUid( uid )
    local dic = skilldata:getOneSkillByUniqueID( uid )
    return string.format(dic.skillConf.intro2,skilldata:getSkillAttrStringByUid(uid))
end
-- 获得技能加成的精简描述
function skilldata:getSortDespArrtValueByUid( uid )
    local dic = skilldata:getOneSkillByUniqueID( uid )
    return string.format(dic.skillConf.intro3,skilldata:getSkillAttrStringByUid(uid))
end

--重置用户数据
function skilldata:resetAllData()
    skilldata.skills = {}
end

function skilldata:getSkillCount(skillId)
    local count = 0
    for k,v in pairs(skilldata.skills) do
        if v.skillId == skillId then
            count = count + 1
        end
    end
    return count
end

function skilldata:addSkill(sid, dic)
    skilldata.skills[sid] = dic
end

-- 获得技能突破上限值
function skilldata:getSkillBreakMaxLevel()
    return ConfigureStorage.skill_max_level == nil and 7 or ConfigureStorage.skill_max_level;
end

-- 获取奥义的名字和数量
-- xx本xx奥义
function skilldata:gainSkillString(skills)
    local dic = {}
    for sid,skill in pairs(skills) do
        local lv = skill.level
        local conf = skilldata:getSkillConfig(skill.skillId)
        if not dic[conf.name] then
            dic[conf.name] = {}
        end
        if not dic[conf.name][lv..""] then
            dic[conf.name][lv..""] = 0
        end
        dic[conf.name][lv..""] = dic[conf.name][lv..""] + 1
    end
    local str = ""
    for name, v in pairs(dic) do
        for lv, cnt in pairs(v) do
            if cnt > 0 then
                print(name, lv, cnt)
                str = string.format("%s%s", str, HLNSLocalizedString("treasure.getAward.books", cnt, tonumber(lv), name))
                str = str.."\r\n"
            end
        end
    end
    return str
end



