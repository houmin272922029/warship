Soldier = class("Soldier", function()
    local _soldier = {}
    return _soldier
end)

Soldier.soldierId = nil
Soldier.name = nil
Soldier.battleField = {}
Soldier.x = 0
Soldier.attr = {}
Soldier.baseAttr = {}
Soldier.level = 0
Soldier.skill = {}
Soldier.isDead = false
Soldier.sid = 0
Soldier.range = nil
Soldier.buffSkill = {}
Soldier.fieldSkill = {}
Soldier.resId = nil
local debug = false

local HAKI_SKILL = {
    "aggskill_000001",
    "aggskill_000002",
    "aggskill_000003",
    "aggskill_000004",
    "aggskill_000005",
    "aggskill_000006",
    "aggskill_000007",
    "aggskill_000008",
}

function Soldier:layout(soldier)
    local log = {}
    log["x"] = soldier.x
    log["side"] = soldier.side
    log["name"] = soldier.name
    log["rank"] = soldier.rank
    log["level"] = soldier.level
    log["id"] = soldier.soldierId
    log["resId"] = soldier.resId
    log["sid"] = soldier.sid
    return log
end

function Soldier:display(soldier)
    local log = Soldier:layout(soldier)
    log["baseHp"] = soldier.baseAttr["hp"]
    log["hp"] = soldier.attr["hp"]
    log["skill"] = soldier.skill
    log["range"] = soldier.range
    log["attr"] = soldier.baseAttr
    return log
end

function Soldier:gemRollLog( forStr )
    -- body
    -- return
    -- local info = RandomManager.getLastRollInfo()
    -- local log = {["action"] = "roll", ["info"] = info, ["for"] = forStr, ["seed"] = RandomManager.cursor}
    -- BattleLog:appendLog(log)
end

function Soldier:gemLog(soldier, action, params)
    -- body
    local log = {}
    log["action"] = action
    log["from"] = {["side"] = soldier.side, ["x"] = soldier.x}
    log["sid"] = soldier.sid
    for k,v in pairs(params) do
        log[k] = v
    end
    BattleLog:appendLog(log)
end

local function skillJudge(soldier, isParry)
    if isParry then
        return "skill_999999"
    end
    -- local skillIds = {}
    -- local per = {}
    -- for skillId,skill in pairs(soldier.skill) do
    --     table.insert(skillIds, skillId)
    --     table.insert(per, skill.per * 100)
    -- end
    -- table.insert(skillIds, "skill_999999") -- 普通攻击
    -- table.insert(per, 100)
    -- local key = RandomManager.tableProb(skillIds, per)
    -- Soldier:gemRollLog("skillJudge")
    local array = {}
    for skillId,skill in pairs(soldier.skill) do
        table.insert(array, skillId)
    end
    local function sortId(a, b)
        return a < b
    end
    table.sort(array, sortId)
    local skills = {}
    for i,skillId in ipairs(array) do
        local skill = soldier.skill[skillId]
        if BattleField.mode == BattleMode.boss or BattleField.mode == BattleMode.racingBattleBoss then
            table.insert(skills, skill)
        else
            -- 检查是否有月步效果
            local per = skill.per
            if soldier.battleField.round == 1 and soldier.hSkill[HAKI_SKILL[3]] then
                local level = soldier.hSkill[HAKI_SKILL[3]]
                local param = ConfigureStorage.aggress_skill[HAKI_SKILL[3]]["param" .. level]
                per = per + param[1]
            end
            local isWork = RandomManager.percent(per * 10000)
            Soldier:gemRollLog("skillJudge_" .. skillId)
            if isWork then
                table.insert(skills, skill)
            end
        end
    end
    if table.getTableCount(skills) <= 0 then
        return "skill_999999" -- 未发动技能
    end

    -- 发动技能后月步失效
    soldier.hSkill[HAKI_SKILL[3]] = nil

    if BattleField.mode == BattleMode.boss or BattleField.mode == BattleMode.racingBattleBoss then
        return skills[RandomManager.fakeRandomRange(1, #skills)].skillId
    else
        local function sortFun(a, b)
            return a.attr.atk > b.attr.atk 
        end
        table.sort( skills, sortFun )
        return skills[1].skillId
    end
end

local function attackJudge( soldier, enemy, isParry )
    -- body
    local addPercent = 0
    -- if soldier.level > enemy.level + 3 then
    --     local levelDiff = soldier.level - enemy.level - 3
    --     addPercent = math.min(levelDiff * 3, 24)
    -- end
    local criPercent = math.max(soldier.attr["criPercent"] + addPercent - enemy.attr["resiPercent"], 0)
    addPercent = 0
    -- if soldier.level + 3 < enemy.level then
    --     local levelDiff = enemy.level - soldier.level - 3
    --     addPercent = math.min(levelDiff * 3, 24)
    -- end
    local dodgePercent = math.max(enemy.attr["dodgePercent"] + addPercent - soldier.attr["hitPercent"], 0)
    addPercent = 0
    if BattleField.mode == BattleMode.boss or BattleField.mode == BattleMode.racingBattleBoss then
        local key = RandomManager.tableProb({"cri", "hit"}, {criPercent, 1})
        Soldier:gemRollLog("attackJudge")
        return key
    else
        if isParry then
            local key = RandomManager.tableProb({"cri", "dod", "hit"}, {criPercent, dodgePercent, 1})
            Soldier:gemRollLog("attackJudge")
            return key
        else
            local parryPercent = math.max(enemy.attr["parryPercent"] + addPercent - soldier.attr["counterPercent"], 0)
            local key = RandomManager.tableProb({"cri", "dod", "eof", "hit"}, {criPercent, dodgePercent, parryPercent, 1})
            Soldier:gemRollLog("attackJudge = " .. key)
            return key
        end
    end
end

local function computeSkillDamage(soldier, skill)
    if not skill then
        -- 普通攻击
        return soldier.attr.atk
    else
        return math.floor(soldier.attr.atk + skill.attr.atk * soldier.attr.mp / 100)
    end
end

local function dealHp(soldier, damage)
    local hp = soldier.attr["hp"]
    local hpMax = soldier.baseAttr["hp"]

    hp = hp - damage
    if hp <= 0 and soldier.undead > 0 then
        -- 触发霸王
        Soldier:gemLog(soldier, "undead", {hp = soldier.undeadHp, hpMax = hpMax, seed = RandomManager.cursor})
        soldier.undead = soldier.undead - 1
        hp = soldier.undeadHp
    end

    if hp > 0 then
        soldier.attr["hp"] = hp
    else
        if BattleField.mode == BattleMode.racingBattleBoss then
            hp = 1
            soldier.isDead = false
            return
        end
        soldier.isDead = true
        local sideCount = soldier.battleField.soldierCount[soldier.side]
        sideCount = sideCount - 1
        local log = {
            ["id"] = soldier.soldierId,
        }
        if sideCount == 0 then
            log["lastOne"] = 1
        end
        Soldier:gemLog(soldier, "die", log)
        soldier.battleField.removeSoldier(soldier)
    end

    return hp > 0 and damage or 0 -- 死亡不触发铁块反伤
end

local function takeDamage(attacker, soldier, damage, attackType, skill, isParry)
    local hp = soldier.attr["hp"]
    local hpMax = soldier.baseAttr["hp"]
    -- 检查攻击者是否有武装技能
    if attacker.hSkill[HAKI_SKILL[1]] then
        local level = attacker.hSkill[HAKI_SKILL[1]]
        local param = ConfigureStorage.aggress_skill[HAKI_SKILL[1]]["param" .. level]
        if hp / hpMax <= param[1] then
            -- 武装技能发动
            damage = math.floor(damage * (1 + param[2]))
        end
    end
    -- 如果是奥义攻击 检查被攻击者是否有见闻效果
    local dec = false
    if damage > 0 and skill and soldier.hSkill[HAKI_SKILL[2]] then
        local level = soldier.hSkill[HAKI_SKILL[2]]
        local param = ConfigureStorage.aggress_skill[HAKI_SKILL[2]]["param" .. level]
        damage = math.max(math.floor(damage * (1 - param[1])), 1)
        dec = true
    end

    -- 检查是否有纸绘技能，并且此次攻击后是否达到触发加防
    local up = false
    if soldier.hSkill[HAKI_SKILL[6]] then
        local level = soldier.hSkill[HAKI_SKILL[6]]
        local param = ConfigureStorage.aggress_skill[HAKI_SKILL[6]]["param" .. level]
        if hp / hpMax > param[1] and hp > damage and (hp - damage) / hpMax <= param[1] then
            up = true
        end
    end

    local log = {
        ["effect"] = {["hp"] = -damage},
        ["attackType"] = attackType,
        ["hpMax"] = soldier.baseAttr["hp"],
        ["hp"] = soldier.attr["hp"],
        ["damage_dec"] = dec and 1 or 0, -- 1-播放减伤动画
        ["def_up"] = up and 1 or 0, -- 1-播放防御增加动画
        ["seed"] = RandomManager.cursor
    }
    Soldier:gemLog(soldier, "attacked", log)

    damage = dealHp(soldier, damage)

    local back = 0
    if damage > 0 and not isParry and soldier.hSkill[HAKI_SKILL[4]] then
        -- 这次伤害不是格挡的反击 检查是否有铁块效果
        local level = soldier.hSkill[HAKI_SKILL[4]]
        local param = ConfigureStorage.aggress_skill[HAKI_SKILL[4]]["param" .. level]
        local isWork
        if not skill or skill.skillType == 3 then
            isWork = RandomManager.percent(param[1] * 10000)
        else
            isWork = RandomManager.percent(param[2] * 10000)
        end
        Soldier:gemRollLog("rebound")
        if debug then
            isWork = true
        end
        if isWork then
            -- 反伤
            back = math.max(math.floor(damage * param[3]), 1)
            Soldier:gemLog(soldier, "aggskill_000004", {})
        end
    end
    return back
end

local function getAllEnemy(soldier)
    local enemys = {}
    for i,s in ipairs(soldier.battleField.soldiers) do
        if soldier.side ~= s.side and not s.isDead then
            table.insert(enemys, s)
        end
    end
    return enemys
end

local function soldierDef(soldier)
    local def = soldier.attr.def
    local hp = soldier.attr["hp"]
    local hpMax = soldier.baseAttr["hp"]
    -- 检查是否有纸绘
    if soldier.hSkill[HAKI_SKILL[6]] then
        local level = soldier.hSkill[HAKI_SKILL[6]]
        local param = ConfigureStorage.aggress_skill[HAKI_SKILL[6]]["param" .. level]
        if hp / hpMax <= param[1] then
            def = math.floor(def * (1 + param[2]))
        end
    end
    return def
end

local function oneStrike(soldier, isParry, combo)
    if soldier.isDead then
        return
    end
    local enemySide = soldier.side == SIDE_LEFT and SIDE_RIGHT or SIDE_LEFT
    local enemy = soldier.battleField.getSoldier(enemySide, soldier.x)
    if not enemy or enemy.isDead then
        return
    end
    if combo then
        combo = combo - 1
        BattleLog:addLog("combo", {})
        Soldier:gemLog(soldier, "combo", {})
    end
    BattleLog:addLog("attack", {})
    local log = {}
    local skillId = skillJudge(soldier, isParry)
    local skill = soldier.skill[skillId]
    if not skill then
        log["range"] = soldier.range
    else
        log["range"] = skill.range
        log["skill"] = {["id"] = skillId, ["rank"] = skill.skillRank}
    end
    if isParry then
        log["isCounter"] = 1
    end
    Soldier:gemLog(soldier, "attack", log)
    local back = 0
    if not skill or skill.skillType == 3 then
        -- 普通攻击或者单体技能
        local enemy = soldier.battleField.getSoldier(enemySide, soldier.x)
        local attackType = attackJudge(soldier, enemy, isParry)
        if attackType == "dod" then
            Soldier:gemLog(enemy, "attacked", {["attackType"] = "dodge"})
        elseif attackType == "eof" then
            -- 招架

            local damage = math.floor(computeSkillDamage(soldier, skill))
            damage = math.max(math.floor((damage - soldierDef(enemy) - enemy.attr.atk) * (RandomManager.fakeRandomRange(0, 10) - 5 + 100) * 0.01), 0)

            takeDamage(soldier, enemy, damage, "parry", skill, true)

            if soldier.battleField.getSoldier(soldier.side, enemy.x) then
                oneStrike(enemy, true)
            end
        else
            local damage = math.floor(computeSkillDamage(soldier, skill))
            damage = math.max(math.floor((damage - soldierDef(enemy)) * (RandomManager.fakeRandomRange(0, 10) - 5 + 100) * 0.01), 1)
            if isParry then
                -- 招架发动40%-70%普通伤害
                damage = math.max(math.floor(damage * RandomManager.fakeRandomRange(40, 60) * 0.01), 1)
            end
            if attackType == "cri" then
                local mul = RandomManager.fakeRandomRange(13, 25)
                damage = math.floor(damage * mul * 0.1)
            end
            BattleField.damage[soldier.side] = BattleField.damage[soldier.side] + damage
            if BattleField.mode ~= BattleMode.boss or BattleField.mode ~= BattleMode.racingBattleBoss then
                back = back + takeDamage(soldier, enemy, damage, attackType, skill, isParry)
            end
        end
    else
        -- 全体攻击, 无法招架
        local enemys = getAllEnemy(soldier)
        if #enemys == 0 then
            return
        end
        for i,enemy in ipairs(enemys) do
            local attackType = attackJudge(soldier, enemy, true)
            if attackType == "dod" then
                Soldier:gemLog(enemy, "attacked", {["attackType"] = "dodge"})
            else
                local damage = math.floor(computeSkillDamage(soldier, skill))
                local dis = math.abs(soldier.x - enemy.x)
                if dis == 1 then
                    damage = math.floor(damage * 0.7)
                elseif dis == 2 then
                    damage = math.floor(damage * 0.6)
                elseif dis == 3 then
                    damage = math.floor(damage * 0.5)
                elseif dis == 4 then
                    damage = math.floor(damage * 0.4)
                elseif dis == 5 then
                    damage = math.floor(damage * 0.33)
                elseif dis == 6 then
                    damage = math.floor(damage * 0.26)
                elseif dis == 7 then
                    damage = math.floor(damage * 0.21)
                end
                damage = math.max(math.floor((damage - soldierDef(enemy)) * (RandomManager.fakeRandomRange(0, 10) - 5 + 100) * 0.01), 1)
                if attackType == "cri" then
                    local mul = RandomManager.fakeRandomRange(13, 25)
                    damage = math.floor(damage * mul * 0.1)
                end
                BattleField.damage[soldier.side] = BattleField.damage[soldier.side] + damage
                if BattleField.mode ~= BattleMode.boss or BattleField.mode ~= BattleMode.racingBattleBoss then
                    back = back + takeDamage(soldier, enemy, damage, attackType, skill, isParry)
                end
            end
        end
    end

    -- 如果有反伤
    if back > 0 then
        local log = {
            ["effect"] = {["hp"] = -back},
            ["attackType"] = "hit",
            ["hpMax"] = soldier.baseAttr["hp"],
            ["hp"] = soldier.attr["hp"],
        }
        Soldier:gemLog(soldier, "rebound", log)
        dealHp(soldier, back)
    end
    if soldier.isDead then
        return
    end
    if isParry then
        return
    end
    -- 检查是否发动岚脚
    if combo then
        -- 已经发动了岚脚
        if combo > 0 then
            oneStrike(soldier, false, combo)
        end
    elseif soldier.hSkill[HAKI_SKILL[5]] then
        local level = soldier.hSkill[HAKI_SKILL[5]]
        local param = ConfigureStorage.aggress_skill[HAKI_SKILL[5]]["param" .. level]
        local isWork = RandomManager.percent(param[1] * 10000)
        Soldier:gemRollLog("combo")
        if debug then
            isWork = true
        end
        if isWork then
            oneStrike(soldier, false, param[2])
        end
    end
end

function Soldier:attack(soldier)
    if soldier.isDead then
        return
    end
    local enemySide = soldier.side == SIDE_LEFT and SIDE_RIGHT or SIDE_LEFT
    local enemy = soldier.battleField.getSoldier(enemySide, soldier.x)
    if not enemy or enemy.isDead then
        return
    end
    oneStrike(soldier, false)
end


function Soldier:initWithSoldierData(soldier, soldierData, battleField )
    -- body
    -- PrintTable(soldierData)
    soldier.attr = {}
    soldier.buff = {}
    soldier.baseAttr = {}

    soldier.battleField = battleField
    soldier.soldierId = soldierData["id"]
    soldier.name = soldierData["name"]
    soldier.level = soldierData["level"]
    soldier.rank = soldierData["rank"]

    soldier.skill = soldierData["skills"]
    soldier.buffSkill = soldierData["buffSkills"]
    soldier.fieldSkill = soldierData["fieldSkills"]
    soldier.hSkill = soldierData["hSkill"] or {}
    if debug then
        soldier.hSkill = {
            aggskill_000001 = 1,
            aggskill_000002 = 1,
            aggskill_000003 = 1,
            aggskill_000004 = 1,
            aggskill_000005 = 1,
            aggskill_000006 = 1,
            aggskill_000007 = 1,
            aggskill_000008 = 1,  
        }
    end
    -- 初始化霸王次数
    soldier.undead = 0
    if soldier.hSkill[HAKI_SKILL[8]] then
        local level = soldier.hSkill[HAKI_SKILL[8]]
        local param = ConfigureStorage.aggress_skill[HAKI_SKILL[8]]["param" .. level]
        soldier.undead = param[1]
        soldier.undeadHp = param[2]
    end

    soldier.attr = soldierData["attr"]
    soldier.baseAttr = deepcopy(soldierData["attr"])
    if soldier.baseAttr["hpMax"] then
        soldier.baseAttr["hp"] = soldier.baseAttr["hpMax"]
    end
    soldier.isDead = false
    soldier.range = soldierData["range"]
    soldier.resId = soldierData["resId"]
    soldier.fame = soldierData["fame"]
end

function Soldier:createWithData( soldierData, battleField )
    -- body
    local soldier = Soldier.new()
    self:initWithSoldierData(soldier, soldierData, battleField)
    return soldier
end