battledata = {}

local function getPer(value, threshold)
    local last = 0
    local per = 0
    for i,dic in ipairs(threshold) do
        per = value / dic["v"] + last
        if i == #threshold then
            break
        end
        local n = threshold[i + 1]
        if per > n["per"] then
            value = value - dic["v"] * (n["per"] - last)
            last = n["per"]
        else
            break
        end
    end
    per = math.min(per, 100)
    return per
end

-- 整合技能
-- skills 战斗技能
-- buffSkills buff技能
-- fieldSkills 战场全体buff技能
-- attr属性
local function _fixSkillData(skillId, level, heroId, skills, buffSkills, fieldSkills)
    local skill = skilldata:getSkill(skillId, level, heroId)
    if skill.skillType == 2 or skill.skillType == 3 then
        -- 非buff技能
        skills[skillId] = skill
    elseif skill.skillType == 4 then
        -- 战场buff
        fieldSkills[skillId] = skill
    else
        table.insert(buffSkills, skill)
    end 
end

-- playerCount 战斗英雄数
-- extraBuff 额外buff
function battledata:getPlayerBattleInfo(playerCount, extraBuff)
    if not playerCount then 
        playerCount = table.getTableCount(herodata.form)
    end
    playerCount = math.min(playerCount, table.getTableCount(herodata.form))
    local fame = titleData:getAllFame()
    local array = {}
    for i=0,playerCount - 1 do
        local info = {}
        local hid = herodata.form[tostring(i)]
        if not hid or hid == "" then
        else
            local hero = herodata.heroes[hid]
            local heroConfig = herodata:getHeroConfig(hero.heroId, hero.wake)
            info.fame = fame
            info.id = hero.heroId
            info.resId = hero.heroId
            info.level = hero.level
            info.name = heroConfig.name
            info.rank = herodata:fixRank(heroConfig.rank, hero.wake)
            local addBuff = {}
            info.attr, addBuff = herodata:getHeroAttrsAndAddByHeroUId(hid)
            info.range = heroConfig.range
            if extraBuff then
                for k,v in pairs(extraBuff) do
                    if addBuff[k] then
                        addBuff[k] = addBuff[k] + v / 100
                    else
                        addBuff[k] = v / 100
                    end
                end
            end
            for k,v in pairs(addBuff) do
                if info.attr[k] then
                    info.attr[k] = math.floor(info.attr[k] * (1 + v))
                end
            end
            local skills = {}
            local buffSkills = {}
            local fieldSkills = {}

            local heroSkills = skilldata:getHeroSkills(hid)
            for j=0,3 do
                local dic = heroSkills[tostring(j)]
                if dic then
                    local skillId = dic.skillId
                    local level = dic.level
                    _fixSkillData(skillId, level, hero.heroId, skills, buffSkills, fieldSkills)
                end
            end

            info.skills = skills
            info.buffSkills = buffSkills
            info.fieldSkills = fieldSkills

            for skillId,skill in pairs(info.skills) do
                if skill.skillType == 2 then
                    skill.per = skill.per + 0.01 * getPer(info.attr["atk"], ConfigureStorage.thresholdConfig["atk"])
                elseif skill.skillType == 3 then
                    skill.per = skill.per + 0.01 * getPer(info.attr["mp"], ConfigureStorage.thresholdConfig["mp"])
                end
            end
            info.attr["criPercent"] = getPer(info.attr["cri"], ConfigureStorage.thresholdConfig["cri"]) * 0.01
            info.attr["dodgePercent"] = getPer(info.attr["dod"], ConfigureStorage.thresholdConfig["dod"]) * 0.01
            info.attr["hitPercent"] = getPer(info.attr["hit"], ConfigureStorage.thresholdConfig["dod"]) * 0.01
            info.attr["resiPercent"] = getPer(info.attr["resi"], ConfigureStorage.thresholdConfig["cri"]) * 0.01
            info.attr["parryPercent"] = getPer(info.attr["parry"], ConfigureStorage.thresholdConfig["parry"]) * 0.01
            info.attr["counterPercent"] = getPer(info.attr["cnt"], ConfigureStorage.thresholdConfig["parry"]) * 0.01

            -- 霸气技能
            local haki = hero.aggress or {kind = 1, layer = 1, base = 0, pre = 0}
            local hSkill = {}
            local kind = haki.kind
            for i = 1, kind - 1 do
                local key = string.format("aggskill_%06d", i)
                local level = 1
                hSkill[key] = level
                if i == 7 then
                    -- 拥有指枪，增加暴击率
                    local conf = ConfigureStorage.aggress_skill[key]
                    info.attr["criPercent"] = info.attr["criPercent"] + conf["param" .. level][1]
                end
            end
            info.hSkill = hSkill
            table.insert(array, info)
        end
    end
    return array
end

function battledata:getEliteBattleInfo(stageId)
    local array = {}
    local npcDic = ConfigureStorage.eliteStageNPC[stageId]
    local level = npcDic.lv
    for i,dic in ipairs(npcDic.elitenpc) do
        local npcId = dic.elitenpc_id
        local npcName = dic.elitenpc_name
        local npcRank = dic.elitenpc_rank
        local position = dic.position
        for i,x in ipairs(position) do
            local info = {}
            info.x = x
            info.id = npcId
            info.level = level * 3
            info.fame = 0
            info.name = npcName
            info.rank = npcRank
            local npc = ConfigureStorage.eliteNPC[npcId]
            info.range = npc.range
            info.resId = npc.animation
            info.attr = deepcopy(npc.attr)
            if not info.attr["cri"] then
                info.attr["cri"] = 0
            end
            if not info.attr["dod"] then
                info.attr["dod"] = 0
            end
            if not info.attr["hit"] then
                info.attr["hit"] = 0
            end
            if not info.attr["resi"] then
                info.attr["resi"] = 0
            end
            if not info.attr["parry"] then
                info.attr["parry"] = 0
            end
            if not info.attr["cnt"] then
                info.attr["cnt"] = 0
            end

            local skills = {}
            local buffSkills = {}
            local fieldSkills = {}
            if npc.skill then
                for i,dic in ipairs(npc.skill) do
                    local skillId = dic.id
                    local skillLv = dic.lv
                    local skill = skilldata:getSkill(skillId, skillLv, heroId)
                    if skill.skillType == 5 then
                        for k,v in pairs(skill.attr) do
                            if attr[k] then
                                info.attr[k] = info.attr[k] + v
                            else
                                info.attr[k] = v
                            end
                        end
                    end
                    _fixSkillData(skillId, skillLv, npcId, skills, buffSkills, fieldSkills)
                end
            end
            info.skills = skills
            info.buffSkills = buffSkills
            info.fieldSkills = fieldSkills
            for skillId,skill in pairs(info.skills) do
                if skill.skillType == 2 then
                    skill.per = skill.per + 0.01 * getPer(info.attr["atk"], ConfigureStorage.thresholdConfig["atk"])
                elseif skill.skillType == 3 then
                    skill.per = skill.per + 0.01 * getPer(info.attr["mp"], ConfigureStorage.thresholdConfig["mp"])
                end
            end
            info.attr["criPercent"] = getPer(info.attr["cri"], ConfigureStorage.thresholdConfig["cri"]) * 0.01
            info.attr["dodgePercent"] = getPer(info.attr["dod"], ConfigureStorage.thresholdConfig["dod"]) * 0.01
            info.attr["hitPercent"] = getPer(info.attr["hit"], ConfigureStorage.thresholdConfig["dod"]) * 0.01
            info.attr["resiPercent"] = getPer(info.attr["resi"], ConfigureStorage.thresholdConfig["cri"]) * 0.01
            info.attr["parryPercent"] = getPer(info.attr["parry"], ConfigureStorage.thresholdConfig["parry"]) * 0.01
            info.attr["counterPercent"] = getPer(info.attr["cnt"], ConfigureStorage.thresholdConfig["parry"]) * 0.01

            local aggskill = npc.aggskill
            if aggskill and table.getTableCount(aggskill) then
                info.hSkill = deepcopy(aggskill)
            end

            table.insert(array, info)
        end
    end
    local function sortFun( a, b )
        return a.x < b.x
    end
    table.sort(array, sortFun)
    return array
end

function battledata:getStageBattleInfo(stageId)
    local array = {}
    local npcDic = ConfigureStorage.stageNpc[stageId]
    local level = npcDic.lv
    for i,dic in ipairs(npcDic.npc) do
        local npcId = dic.npc_id
        local npcName = dic.npc_name
        local npcRank = dic.npc_rank
        local position = dic.position
        for i,x in ipairs(position) do
            local info = {}
            info.x = x
            info.id = npcId
            info.level = level * 3
            info.fame = 0
            info.name = npcName
            info.rank = npcRank
            local npc = ConfigureStorage.npcList[npcId]
            info.range = npc.range
            info.resId = npc.animation
            info.attr = deepcopy(npc.attr)
            if not info.attr["cri"] then
                info.attr["cri"] = 0
            end
            if not info.attr["dod"] then
                info.attr["dod"] = 0
            end
            if not info.attr["hit"] then
                info.attr["hit"] = 0
            end
            if not info.attr["resi"] then
                info.attr["resi"] = 0
            end
            if not info.attr["parry"] then
                info.attr["parry"] = 0
            end
            if not info.attr["cnt"] then
                info.attr["cnt"] = 0
            end

            local skills = {}
            local buffSkills = {}
            local fieldSkills = {}
            if npc.skill then
                for i,dic in ipairs(npc.skill) do
                    local skillId = dic.id
                    local skillLv = dic.lv
                    local skill = skilldata:getSkill(skillId, skillLv, heroId)
                    if skill.skillType == 5 then
                        for k,v in pairs(skill.attr) do
                            if attr[k] then
                                info.attr[k] = info.attr[k] + v
                            else
                                info.attr[k] = v
                            end
                        end
                    end
                    _fixSkillData(skillId, skillLv, npcId, skills, buffSkills, fieldSkills)
                end
            end
            info.skills = skills
            info.buffSkills = buffSkills
            info.fieldSkills = fieldSkills
            for skillId,skill in pairs(info.skills) do
                if skill.skillType == 2 then
                    skill.per = skill.per + 0.01 * getPer(info.attr["atk"], ConfigureStorage.thresholdConfig["atk"])
                elseif skill.skillType == 3 then
                    skill.per = skill.per + 0.01 * getPer(info.attr["mp"], ConfigureStorage.thresholdConfig["mp"])
                end
            end
            info.attr["criPercent"] = getPer(info.attr["cri"], ConfigureStorage.thresholdConfig["cri"]) * 0.01
            info.attr["dodgePercent"] = getPer(info.attr["dod"], ConfigureStorage.thresholdConfig["dod"]) * 0.01
            info.attr["hitPercent"] = getPer(info.attr["hit"], ConfigureStorage.thresholdConfig["dod"]) * 0.01
            info.attr["resiPercent"] = getPer(info.attr["resi"], ConfigureStorage.thresholdConfig["cri"]) * 0.01
            info.attr["parryPercent"] = getPer(info.attr["parry"], ConfigureStorage.thresholdConfig["parry"]) * 0.01
            info.attr["counterPercent"] = getPer(info.attr["cnt"], ConfigureStorage.thresholdConfig["parry"]) * 0.01


            local aggskill = npc.aggskill
            if aggskill and table.getTableCount(aggskill) then
                info.hSkill = deepcopy(aggskill)
            end

            table.insert(array, info)
        end
    end
    local function sortFun( a, b )
        return a.x < b.x
    end
    table.sort(array, sortFun)
    return array
end
-- 获得海军支部boss信息
function battledata:getMarineBossBattleInfo( bossId )
    local array = {}
    local npcDic = ConfigureStorage.nsnpcgroup[bossId]
    local level = npcDic.level
    for i,dic in ipairs(npcDic.npc) do
        local npcId = dic.npc_id
        local npcName = dic.npc_name
        local npcRank = dic.npc_rank
        local npcAwake = dic.npc_wake
        local position = dic.position
        for i,x in ipairs(position) do
            local info = {}
            info.x = x
            info.id = npcId
            info.level = level * 3
            info.fame = 0
            info.name = npcName
            info.rank = npcRank
            local npc = ConfigureStorage.npcList[npcId]
            info.range = npc.range
            info.resId = npc.animation
            info.attr = deepcopy(npc.attr)
            if not info.attr["cri"] then
                info.attr["cri"] = 0
            end
            if not info.attr["dod"] then
                info.attr["dod"] = 0
            end
            if not info.attr["hit"] then
                info.attr["hit"] = 0
            end
            if not info.attr["resi"] then
                info.attr["resi"] = 0
            end
            if not info.attr["parry"] then
                info.attr["parry"] = 0
            end
            if not info.attr["cnt"] then
                info.attr["cnt"] = 0
            end

            local skills = {}
            local buffSkills = {}
            local fieldSkills = {}
            if npc.skill then
                for i,dic in ipairs(npc.skill) do
                    local skillId = dic.id
                    local skillLv = dic.lv
                    local skill = skilldata:getSkill(skillId, skillLv)
                    if skill.skillType == 5 then
                        for k,v in pairs(skill.attr) do
                            if attr[k] then
                                info.attr[k] = info.attr[k] + v
                            else
                                info.attr[k] = v
                            end
                        end
                    end
                    _fixSkillData(skillId, skillLv, npcId, skills, buffSkills, fieldSkills)
                end
            end
            info.skills = skills
            info.buffSkills = buffSkills
            info.fieldSkills = fieldSkills
            for skillId,skill in pairs(info.skills) do
                if skill.skillType == 2 then
                    skill.per = skill.per + 0.01 * getPer(info.attr["atk"], ConfigureStorage.thresholdConfig["atk"])
                elseif skill.skillType == 3 then
                    skill.per = skill.per + 0.01 * getPer(info.attr["mp"], ConfigureStorage.thresholdConfig["mp"])
                end
            end
            info.attr["criPercent"] = getPer(info.attr["cri"], ConfigureStorage.thresholdConfig["cri"]) * 0.01
            info.attr["dodgePercent"] = getPer(info.attr["dod"], ConfigureStorage.thresholdConfig["dod"]) * 0.01
            info.attr["hitPercent"] = getPer(info.attr["hit"], ConfigureStorage.thresholdConfig["dod"]) * 0.01
            info.attr["resiPercent"] = getPer(info.attr["resi"], ConfigureStorage.thresholdConfig["cri"]) * 0.01
            info.attr["parryPercent"] = getPer(info.attr["parry"], ConfigureStorage.thresholdConfig["parry"]) * 0.01
            info.attr["counterPercent"] = getPer(info.attr["cnt"], ConfigureStorage.thresholdConfig["parry"]) * 0.01
            table.insert(array, info)
        end
    end
    local function sortFun( a, b )
        return a.x < b.x
    end
    table.sort(array, sortFun)
    return array
end

function battledata:readJsonPlayer(path)
    local file = io.open(path)
    local data = file:read("*a")
    file:flush()
    file:close()
    local jsonData = json.decode(data)
    playerBattleData:fromDic(jsonData)
    return battledata:getPVPBattleInfo()
end

-- 读取测试战斗数据
function battledata:readJson()
    local file = io.open(CONF_PATH.."battleInfo.json")
    local data = file:read("*a")
    file:flush()
    file:close()
    local jsonData = json.decode(data)
    local array = {}
    for i,dic in ipairs(jsonData) do
        local info = {}
        local heroId = dic.id
        local conf = herodata:getHeroConfig(heroId, dic.wake)
        info.id = heroId
        info.level = dic.level
        info.name = conf.name
        info.fame = 0
        if dic.fame then
            info.fame = dic.fame
        end
        info.rank = herodata:fixRank(conf.rank, dic.wake)
        info.attr = deepcopy(conf.attr)
        for k,v in pairs(conf.grow) do
            if info.attr[k] then
                info.attr[k] = math.floor(info.attr[k] + v * (dic.level - 1))
            else
                info.attr[k] = math.floor(v * (dic.level - 1))
            end
        end
        for k,v in pairs(dic.attrFix) do
            if info.attr[k] then
                info.attr[k] = info.attr[k] + v
            else
                info.attr[k] = v
            end
        end
        -- 装备
        if dic.equips then
            for equipId,eDic in pairs(dic.equips) do
                local level = eDic.level
                local refineLevel = 0
                if eDic.stage then
                    refineLevel = eDic.stage
                end
                local equipConfig = equipdata:getEquipConfig(equipId)
                if equipConfig.initial and type(equipConfig.initial) == "table" then
                    for k,v in pairs(equipConfig.initial) do
                        local value = 0
                        if equipConfig.refine then
                            value = v + math.floor((equipConfig.updateEffect + equipConfig.refine * refineLevel) * (level - 1))
                        else
                            value = v + math.floor(equipConfig.updateEffect * (level - 1))
                        end
                        if info.attr[k] then
                            info.attr[k] = info.attr[k] + value
                        else
                            info.attr[k] = value
                        end
                    end
                end
            end
        end
        -- TODO 真气
        -- TODO 缘分
        local addAttr = {} -- 缘分附加属性百分比
        -- 技能
        local skills = {}
        local buffSkills = {}
        local fieldSkills = {}
        if dic.skills then
            for skillId,level in pairs(dic.skills) do
                local skill = skilldata:getSkill(skillId, level, heroId)
                if skill.skillType == 5 then
                    for k,v in pairs(skill.attr) do
                        if attr[k] then
                            info.attr[k] = info.attr[k] + v
                        else
                            info.attr[k] = v
                        end
                    end
                end
                _fixSkillData(skillId, level, heroId, skills, buffSkills, fieldSkills)
            end
        end
        -- 属性加成
        for k,v in pairs(addAttr) do
            if attr[k] then
                attr[k] = math.floor(attr[k] * (1 + v))
            end
        end
        info.skills = skills
        info.buffSkills = buffSkills
        info.fieldSkills = fieldSkills

        for skillId,skill in pairs(info.skills) do
            if skill.skillType == 2 then
                skill.per = skill.per + 0.01 * getPer(info.attr["atk"], ConfigureStorage.thresholdConfig["atk"])
            elseif skill.skillType == 3 then
                skill.per = skill.per + 0.01 * getPer(info.attr["mp"], ConfigureStorage.thresholdConfig["mp"])
            end
        end
        info.attr["criPercent"] = getPer(info.attr["cri"], ConfigureStorage.thresholdConfig["cri"]) * 0.01
        info.attr["dodgePercent"] = getPer(info.attr["dod"], ConfigureStorage.thresholdConfig["dod"]) * 0.01
        info.attr["hitPercent"] = getPer(info.attr["hit"], ConfigureStorage.thresholdConfig["dod"]) * 0.01
        info.attr["resiPercent"] = getPer(info.attr["resi"], ConfigureStorage.thresholdConfig["cri"]) * 0.01
        info.attr["parryPercent"] = getPer(info.attr["parry"], ConfigureStorage.thresholdConfig["parry"]) * 0.01
        info.attr["counterPercent"] = getPer(info.attr["cnt"], ConfigureStorage.thresholdConfig["parry"]) * 0.01
        table.insert(array, info)
    end
    return array
end

-- 转换后端返回的战斗数据
function battledata:convertBattleInfo(infoDic)
    local battleInfo = {}
    for i=0,table.getTableCount(infoDic) - 1 do
        local dic = deepcopy(infoDic[tostring(i)])
        local info = {}
        info.id = dic.id
        info.resId = dic.resId
        info.level = dic.level
        info.name = dic.name
        info.rank = herodata:fixRank(dic.rank, dic.wake)
        info.range = dic.range
        info.attr = dic.attr
        info.skills = {}
        info.buffSkills = {}
        info.fieldSkills = {}
        if dic.skills then
            info.skills = dic.skills
        end
        if dic.buffSkills then
            for k,skill in pairs(dic.buffSkills) do
                table.insert(info.buffSkills, skill)
            end
        end
        if dic.fieldSkills then
            info.fieldSkills = dic.fieldSkills
        end
        table.insert(battleInfo, info)
    end
    return battleInfo
end


function battledata:getPVPBattleInfo(extraBuff)
    local array = {}
    local fame = playerBattleData:getAllFame()
    for i=0, table.getTableCount(playerBattleData.form) - 1 do
        local info = {}
        local hid = playerBattleData.form[tostring(i)]
        if not hid or hid == "" then
        else
            local hero = playerBattleData.heroes[hid]
            local heroConfig = herodata:getHeroConfig(hero.heroId, hero.wake)
            info.fame = fame
            info.id = hero.heroId
            info.resId = hero.heroId
            info.level = hero.level
            info.name = heroConfig.name
            info.rank = herodata:fixRank(heroConfig.rank, hero.wake)
            local addBuff = {}
            info.attr, addBuff = playerBattleData:getHeroAttrsByHeroUId(hid)
            if extraBuff then
                for k,v in pairs(extraBuff) do
                    if addBuff[k] then
                        addBuff[k] = addBuff[k] + v / 100
                    else
                        addBuff[k] = v / 100
                    end
                end
            end
            if playerBattleData.extraBuff then
                for k,v in pairs(playerBattleData.extraBuff) do
                    if addBuff[k] then
                        addBuff[k] = addBuff[k] + v / 100
                    else
                        addBuff[k] = v / 100
                    end
                end
            end
            for k,v in pairs(addBuff) do
                if info.attr[k] then
                    info.attr[k] = math.floor(info.attr[k] * (1 + v))
                end
            end

            info.range = heroConfig.range

            local skills = {}
            local buffSkills = {}
            local fieldSkills = {}

            local heroSkills = playerBattleData:getHeroSkills(hid)
            for j=0,3 do
                local dic = heroSkills[tostring(j)]
                if dic then
                    local skillId = dic.skillId
                    local level = dic.level
                    _fixSkillData(skillId, level, hero.heroId, skills, buffSkills, fieldSkills)
                end
            end

            info.skills = skills
            info.buffSkills = buffSkills
            info.fieldSkills = fieldSkills

            for skillId,skill in pairs(info.skills) do
                if skill.skillType == 2 then
                    skill.per = skill.per + 0.01 * getPer(info.attr["atk"], ConfigureStorage.thresholdConfig["atk"])
                elseif skill.skillType == 3 then
                    skill.per = skill.per + 0.01 * getPer(info.attr["mp"], ConfigureStorage.thresholdConfig["mp"])
                end
            end
            info.attr["criPercent"] = getPer(info.attr["cri"], ConfigureStorage.thresholdConfig["cri"]) * 0.01
            info.attr["dodgePercent"] = getPer(info.attr["dod"], ConfigureStorage.thresholdConfig["dod"]) * 0.01
            info.attr["hitPercent"] = getPer(info.attr["hit"], ConfigureStorage.thresholdConfig["dod"]) * 0.01
            info.attr["resiPercent"] = getPer(info.attr["resi"], ConfigureStorage.thresholdConfig["cri"]) * 0.01
            info.attr["parryPercent"] = getPer(info.attr["parry"], ConfigureStorage.thresholdConfig["parry"]) * 0.01
            info.attr["counterPercent"] = getPer(info.attr["cnt"], ConfigureStorage.thresholdConfig["parry"]) * 0.01

            -- 霸气技能
            local haki = hero.aggress or {kind = 1, layer = 1, base = 0, pre = 0}
            local hSkill = {}
            for i = 1, haki.kind - 1 do
                local key = string.format("aggskill_%06d", i)
                local level = 1
                hSkill[key] = level
                if i == 7 then
                    -- 拥有指枪，增加暴击率
                    local conf = ConfigureStorage.aggress_skill[key]
                    info.attr["criPercent"] = info.attr["criPercent"] + conf["param" .. level][1]
                end
            end
            info.hSkill = hSkill
            table.insert(array, info)
        end
    end
    return array
end

function battledata:getVeiledSeaBattleInfo(stage, bossId, buff)
    local array = {}
    local stageConf = ConfigureStorage.SeaMiStage[tostring(stage)]
    local groupConf = ConfigureStorage.SeaMiBossGroup[bossId]
    local enemys
    local rank = 1
    if stage % 5 == 0 then
        -- boss
        enemys = groupConf.boss.group
        rank = 4
    else
        -- normal
        enemys = groupConf.mob.group
        rank = 3
    end
    for i=1,stageConf.num do
        local info = {}
        local heroId = enemys[i]
        local npcDic = ConfigureStorage.SeaMiNpcAttr[heroId]
        info.fame = 0
        info.id = heroId
        info.resId = npcDic.animation
        info.level = stageConf.npclevel
        info.name = npcDic.name
        info.rank = rank
        info.attr = {
            ["atk"] = npcDic.attr.atk + npcDic.grow.atk * (stageConf.npclevel - 1),
            ["def"] = npcDic.attr.def + npcDic.grow.def * (stageConf.npclevel - 1),
            ["mp"] = npcDic.attr.mp + npcDic.grow.mp * (stageConf.npclevel - 1),
            ["hp"] = npcDic.attr.hp + npcDic.grow.hp * (stageConf.npclevel - 1),
            ["dod"] = 0,
            ["hit"] = 0,
            ["resi"] = 0,
            ["cri"] = 0,
            ["parry"] = 0,
            ["cnt"] = 0,
        }
        local addAttr = deepcopy(buff)
        -- 计算技能中的buff技能
        local skillId = npcDic.skill
        local skills = {}
        local buffSkills = {}
        local fieldSkills = {}
        if skillId and skillId ~= "" then
            local level = npcDic.skilllv
            local skill = skilldata:getSkill(skillId, level, heroId)
            if skill.skillType == 2 or skill.skillType == 3 then
            -- 非buff技能
                skills[skillId] = skill
            elseif skill.skillType == 4 then
                -- 战场buff
                fieldSkills[skillId] = skill
            else
                table.insert(buffSkills, skill)
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
                        if info.attr[k] then
                            info.attr[k] = info.attr[k] + v
                        else
                            info.attr[k] = v
                        end
                    end
                end
            end 
        end
        for k,v in pairs(addAttr) do
            if info.attr[k] then
                info.attr[k] = math.floor(info.attr[k] * (1 + v))
            end
        end
        info.skills = skills
        info.buffSkills = buffSkills
        info.fieldSkills = fieldSkills
        for skillId,skill in pairs(info.skills) do
            if skill.skillType == 2 then
                skill.per = skill.per + 0.01 * getPer(info.attr["atk"], ConfigureStorage.thresholdConfig["atk"])
            elseif skill.skillType == 3 then
                skill.per = skill.per + 0.01 * getPer(info.attr["mp"], ConfigureStorage.thresholdConfig["mp"])
            end
        end
        info.attr["criPercent"] = getPer(info.attr["cri"], ConfigureStorage.thresholdConfig["cri"]) * 0.01
        info.attr["dodgePercent"] = getPer(info.attr["dod"], ConfigureStorage.thresholdConfig["dod"]) * 0.01
        info.attr["hitPercent"] = getPer(info.attr["hit"], ConfigureStorage.thresholdConfig["dod"]) * 0.01
        info.attr["resiPercent"] = getPer(info.attr["resi"], ConfigureStorage.thresholdConfig["cri"]) * 0.01
        info.attr["parryPercent"] = getPer(info.attr["parry"], ConfigureStorage.thresholdConfig["parry"]) * 0.01
        info.attr["counterPercent"] = getPer(info.attr["cnt"], ConfigureStorage.thresholdConfig["parry"]) * 0.01
        table.insert(array, info)
    end
    return array
end


function battledata:getBossBattleInfo(bossId, level, hpMax, hp)
    local bossAttr = ConfigureStorage.bossAttr[bossId]
    local fame = 0
    local array = {}
    for i=0,7 do
        local info = {}
        local conf
        if i == 0 then
            conf = bossAttr.npc[1]
        else
            conf = bossAttr.npc[2]
        end
        info.fame = fame
        info.id = conf.ID
        info.resId = conf.ID
        info.level = level
        info.name = conf.name
        info.rank = conf.rank
        info.attr = {
            ["atk"] = 0,
            ["def"] = 0,
            ["mp"] = 0,
            ["hp"] = hp,
            ["dod"] = 0,
            ["hit"] = 0,
            ["resi"] = 0,
            ["cri"] = 0,
            ["parry"] = 0,
            ["cnt"] = 0,
            ["hpMax"] = hpMax,
        }
        info.range = 0
        local skills = {}
        local buffSkills = {}
        local fieldSkills = {}
        _fixSkillData(bossAttr.skill, 1, heroId, skills, buffSkills, fieldSkills)
        info.skills = skills
        info.buffSkills = buffSkills
        info.fieldSkills = fieldSkills

        for skillId,skill in pairs(info.skills) do
            if skill.skillType == 2 then
                skill.per = skill.per + 0.01 * getPer(info.attr["atk"], ConfigureStorage.thresholdConfig["atk"])
            elseif skill.skillType == 3 then
                skill.per = skill.per + 0.01 * getPer(info.attr["mp"], ConfigureStorage.thresholdConfig["mp"])
            end
        end
        info.attr["criPercent"] = getPer(info.attr["cri"], ConfigureStorage.thresholdConfig["cri"]) * 0.01
        info.attr["dodgePercent"] = getPer(info.attr["dod"], ConfigureStorage.thresholdConfig["dod"]) * 0.01
        info.attr["hitPercent"] = getPer(info.attr["hit"], ConfigureStorage.thresholdConfig["dod"]) * 0.01
        info.attr["resiPercent"] = getPer(info.attr["resi"], ConfigureStorage.thresholdConfig["cri"]) * 0.01
        info.attr["parryPercent"] = getPer(info.attr["parry"], ConfigureStorage.thresholdConfig["parry"]) * 0.01
        info.attr["counterPercent"] = getPer(info.attr["cnt"], ConfigureStorage.thresholdConfig["parry"]) * 0.01
        table.insert(array, info)
    end
    return array
end


-- 联盟跨服竞速战 
--(boss阶段)
function battledata:getRacingBattleBossInfo(bossId, level, hpMax, hp)
    local bossAttr = ConfigureStorage.bossAttr[bossId]
    local fame = 0
    local array = {}
    for i=0,7 do
        local info = {}
        local conf
        if i == 0 then
            conf = bossAttr.npc[1]
        else
            conf = bossAttr.npc[2]
        end
        info.fame = fame
        info.id = conf.ID
        info.resId = conf.ID
        info.level = level
        info.name = conf.name
        info.rank = conf.rank
        info.attr = {
            ["atk"] = 0,
            ["def"] = 0,
            ["mp"] = 0,
            ["hp"] = hp,
            ["dod"] = 0,
            ["hit"] = 0,
            ["resi"] = 0,
            ["cri"] = 0,
            ["parry"] = 0,
            ["cnt"] = 0,
            ["hpMax"] = hpMax,
        }
        info.range = 0
        local skills = {}
        local buffSkills = {}
        local fieldSkills = {}
        _fixSkillData(bossAttr.skill, 1, heroId, skills, buffSkills, fieldSkills)
        info.skills = skills
        info.buffSkills = buffSkills
        info.fieldSkills = fieldSkills

        for skillId,skill in pairs(info.skills) do
            if skill.skillType == 2 then
                skill.per = skill.per + 0.01 * getPer(info.attr["atk"], ConfigureStorage.thresholdConfig["atk"])
            elseif skill.skillType == 3 then
                skill.per = skill.per + 0.01 * getPer(info.attr["mp"], ConfigureStorage.thresholdConfig["mp"])
            end
        end
        info.attr["criPercent"] = getPer(info.attr["cri"], ConfigureStorage.thresholdConfig["cri"]) * 0.01
        info.attr["dodgePercent"] = getPer(info.attr["dod"], ConfigureStorage.thresholdConfig["dod"]) * 0.01
        info.attr["hitPercent"] = getPer(info.attr["hit"], ConfigureStorage.thresholdConfig["dod"]) * 0.01
        info.attr["resiPercent"] = getPer(info.attr["resi"], ConfigureStorage.thresholdConfig["cri"]) * 0.01
        info.attr["parryPercent"] = getPer(info.attr["parry"], ConfigureStorage.thresholdConfig["parry"]) * 0.01
        info.attr["counterPercent"] = getPer(info.attr["cnt"], ConfigureStorage.thresholdConfig["parry"]) * 0.01
        table.insert(array, info)
    end
    return array
end

-- 普通数据 (水手战、boss战)  类似于起航的战斗模式
function battledata:getRacingBattleInfo(step , lv)
    local array = {}
    -- 通过给定的当前阶段step ，随机产生一个boss组   只传step1 、step2
    local randomRange
    local stageId
    if step == "step1" then
        randomRange = RandomManager.randomRange(0, 2)
        stageId = ConfigureStorage.leagueBoss[1].npcgroup[randomRange + 1]
    else
        randomRange = RandomManager.randomRange(0, 4)
        stageId = ConfigureStorage.leagueBoss[2].npcgroup[randomRange + 1]
    end
    local npcDic = ConfigureStorage.lbnpcgroup[stageId]
    -- for i=1 , getMyTableCount(npcDic.lbnpc) do
    --     PrintTable(ConfigureStorage.lbnpc[npcDic.lbnpc[i]]) -- 通过 npc ID 获得此NPC的数据 
    -- end
    local level = lv
    for key , value in ipairs(npcDic.lbnpc) do
        local dic = ConfigureStorage.lbnpc[value]
        local npcId = dic.heroId
        local npcName = dic.name
        local npcRank = dic.rank
        local position = key
        local info = {}
        info.x = position
        info.id = npcId
        info.level = level
        info.fame = 0
        info.name = npcName
        info.rank = npcRank
        info.range = 0
        info.resId = dic.heroId
        info.attr = deepcopy(dic.attr)
        for k,v in pairs(dic.grow) do
            info.attr[k] = info.attr[k] or 0
            info.attr[k] = info.attr[k] + v * (level - 1)
        end
        if not info.attr["cri"] then
            info.attr["cri"] = 0
        end
        if not info.attr["dod"] then
            info.attr["dod"] = 0
        end
        if not info.attr["hit"] then
            info.attr["hit"] = 0
        end
        if not info.attr["resi"] then
            info.attr["resi"] = 0
        end
        if not info.attr["parry"] then
            info.attr["parry"] = 0
        end
        if not info.attr["cnt"] then
            info.attr["cnt"] = 0
        end

        local skills = {}
        local buffSkills = {}
        local fieldSkills = {}
        if dic and dic.skill then
            local skillId = dic.skill
            local level = 1
            _fixSkillData(skillId, level, heroId, skills, buffSkills, fieldSkills)
        end

        info.skills = skills
        info.buffSkills = buffSkills
        info.fieldSkills = fieldSkills

        info.attr["criPercent"] = getPer(info.attr["cri"], ConfigureStorage.thresholdConfig["cri"]) * 0.01
        info.attr["dodgePercent"] = getPer(info.attr["dod"], ConfigureStorage.thresholdConfig["dod"]) * 0.01
        info.attr["hitPercent"] = getPer(info.attr["hit"], ConfigureStorage.thresholdConfig["dod"]) * 0.01
        info.attr["resiPercent"] = getPer(info.attr["resi"], ConfigureStorage.thresholdConfig["cri"]) * 0.01
        info.attr["parryPercent"] = getPer(info.attr["parry"], ConfigureStorage.thresholdConfig["parry"]) * 0.01
        info.attr["counterPercent"] = getPer(info.attr["cnt"], ConfigureStorage.thresholdConfig["parry"]) * 0.01
        table.insert(array, info)
    end
    local function sortFun( a, b )
        return a.x < b.x
    end
    table.sort(array, sortFun)
    return array
end

function battledata:getHakiBattleInfo(kind, layer)
    local array = {}
    local npcDic = ConfigureStorage.aggress_npclist[string.format("npclist_%d_%d", kind, layer)]
    local info = {}
    info.id = npcDic.animation
    local heroConfig = herodata:getHeroConfig(info.id)
    info.level = 100
    info.fame = 0
    info.name = heroConfig.name
    info.rank = heroConfig.rank
    info.range = npcDic.range
    info.resId = npcDic.animation
    info.attr = deepcopy(npcDic.attr)
    local skills = {}
    local buffSkills = {}
    local fieldSkills = {}
    if npcDic.skill then
        for i,dic in ipairs(npcDic.skill) do
            local skillId = dic.id
            local skillLv = dic.lv
            local skill = skilldata:getSkill(skillId, skillLv, heroId)
            if skill.skillType == 5 then
                for k,v in pairs(skill.attr) do
                    if attr[k] then
                        info.attr[k] = info.attr[k] + v
                    else
                        info.attr[k] = v
                    end
                end
            end
            _fixSkillData(skillId, skillLv, npcId, skills, buffSkills, fieldSkills)
        end
    end
    info.skills = skills
    info.buffSkills = buffSkills
    info.fieldSkills = fieldSkills
    for skillId,skill in pairs(info.skills) do
        if skill.skillType == 2 then
            skill.per = skill.per + 0.01 * getPer(info.attr["atk"], ConfigureStorage.thresholdConfig["atk"])
        elseif skill.skillType == 3 then
            skill.per = skill.per + 0.01 * getPer(info.attr["mp"], ConfigureStorage.thresholdConfig["mp"])
        end
    end
    info.attr["criPercent"] = getPer(info.attr["cri"], ConfigureStorage.thresholdConfig["cri"]) * 0.01
    info.attr["dodgePercent"] = getPer(info.attr["dod"], ConfigureStorage.thresholdConfig["dod"]) * 0.01
    info.attr["hitPercent"] = getPer(info.attr["hit"], ConfigureStorage.thresholdConfig["dod"]) * 0.01
    info.attr["resiPercent"] = getPer(info.attr["resi"], ConfigureStorage.thresholdConfig["cri"]) * 0.01
    info.attr["parryPercent"] = getPer(info.attr["parry"], ConfigureStorage.thresholdConfig["parry"]) * 0.01
    info.attr["counterPercent"] = getPer(info.attr["cnt"], ConfigureStorage.thresholdConfig["parry"]) * 0.01
    table.insert(array, info)
    return array
end

function battledata:getPlayerBattleInfoByHid(hid)
    local fame = titleData:getAllFame()
    local array = {}
    local info = {}
    local hero = herodata.heroes[hid]
    local heroConfig = herodata:getHeroConfig(hero.heroId, hero.awake)
    info.fame = fame
    info.id = hero.heroId
    info.resId = hero.heroId
    info.level = hero.level
    info.name = heroConfig.name
    info.rank = heroConfig.rank
    info.rank = herodata:fixRank(info.rank, hero.wake)
    local addBuff = {}
    info.attr, addBuff = herodata:getHeroAttrsAndAddByHeroUId(hid)
    info.range = heroConfig.range
    if extraBuff then
        for k,v in pairs(extraBuff) do
            if addBuff[k] then
                addBuff[k] = addBuff[k] + v / 100
            else
                addBuff[k] = v / 100
            end
        end
    end
    for k,v in pairs(addBuff) do
        if info.attr[k] then
            info.attr[k] = math.floor(info.attr[k] * (1 + v))
        end
    end
    local skills = {}
    local buffSkills = {}
    local fieldSkills = {}

    local heroSkills = skilldata:getHeroSkills(hid)
    for j=0,3 do
        local dic = heroSkills[tostring(j)]
        if dic then
            local skillId = dic.skillId
            local level = dic.level
            _fixSkillData(skillId, level, hero.heroId, skills, buffSkills, fieldSkills)
        end
    end

    info.skills = skills
    info.buffSkills = buffSkills
    info.fieldSkills = fieldSkills

    for skillId,skill in pairs(info.skills) do
        if skill.skillType == 2 then
            skill.per = skill.per + 0.01 * getPer(info.attr["atk"], ConfigureStorage.thresholdConfig["atk"])
        elseif skill.skillType == 3 then
            skill.per = skill.per + 0.01 * getPer(info.attr["mp"], ConfigureStorage.thresholdConfig["mp"])
        end
    end
    info.attr["criPercent"] = getPer(info.attr["cri"], ConfigureStorage.thresholdConfig["cri"]) * 0.01
    info.attr["dodgePercent"] = getPer(info.attr["dod"], ConfigureStorage.thresholdConfig["dod"]) * 0.01
    info.attr["hitPercent"] = getPer(info.attr["hit"], ConfigureStorage.thresholdConfig["dod"]) * 0.01
    info.attr["resiPercent"] = getPer(info.attr["resi"], ConfigureStorage.thresholdConfig["cri"]) * 0.01
    info.attr["parryPercent"] = getPer(info.attr["parry"], ConfigureStorage.thresholdConfig["parry"]) * 0.01
    info.attr["counterPercent"] = getPer(info.attr["cnt"], ConfigureStorage.thresholdConfig["parry"]) * 0.01
    table.insert(array, info)
    return array
end
