SIDE_LEFT = "left"
SIDE_RIGHT = "right"
RESULT_LOSE = "lose"
RESULT_WIN = "win"

-- 战斗模式
BattleMode = {
    stage = 1,
    newWorld = 2,
    chapter = 3,
    arena = 4,
    opAni = 5, -- 开场动画
    boss = 6, -- 恶魔谷
    marineBoss = 7, -- 海军支部boss
    unionBattle = 8, -- 盟战
    worldwar = 9, -- 海战
    veiledSea = 10, -- 迷雾之海
    wwRob = 11, -- 劫镖
    wwRobVideo = 12, -- 劫镖录像
    SSA = 13, -- 跨服决斗
    SSAVideo = 14, -- 跨服决斗录像
    racingBattle = 15, -- 联盟跨服竞速战普通
    racingBattleBoss = 16, -- 联盟跨服竞速战boss
    hakiFight = 17,
}

BattleField = {
    soldiers = {}, -- 所有的士兵信息
    soldierCount = {}, -- {"left":0,"right":0}
    first = SIDE_LEFT, -- 先手
    round = 0,
    result = nil,
    endFlag = false,
    finishFlag = false,
    layout = {},
    mode = nil,
    leftName = nil,
    rightName = nil,
    damage = {}, -- {"left":0,"right":0}
}


function initBattleField()
    BattleField.soldiers = {}
    BattleField.layout = {}
    BattleField.soldierCount = {}
    BattleField.soldierCount["left"] = 0
    BattleField.soldierCount["right"] = 0
    BattleField.round = 0
    BattleField.first = SIDE_LEFT
    BattleField.leftCount = 1
    BattleField.rightCount = 1
    BattleField.endFlag = false
    BattleField.finishFlag = false
    BattleField.dead = {left = {}, right = {}}
    BattleField.damage = {left = 0, right = 0}
end

function BattleField.getSoldier(side, x)
    local soldier = BattleField.layout[side.."."..x]
    if soldier then
        return soldier
    end
    return nil
end

function BattleField.clearSoldier(side, x)
    BattleField.layout[side.."."..x] = nil
end

function BattleField.setSoldier()
    BattleField.count = {}
    BattleField.count.left = 0
    BattleField.count.right = 0
    BattleField.layout = {}
    for i,soldier in ipairs(BattleField.soldiers) do
        if not soldier.isDead then
            BattleField.count[soldier.side] = BattleField.count[soldier.side] + 1
            soldier.x = BattleField.count[soldier.side]
            BattleField.layout[soldier.side.."."..soldier.x] = soldier
        end
    end
end

function BattleField.removeSoldier(soldier)
    BattleField.soldierCount[soldier.side] = BattleField.soldierCount[soldier.side] - 1
    if BattleField.soldierCount[soldier.side] == 0 then
        BattleField.finishFlag = true
        BattleField.result = soldier.side == SIDE_LEFT and RESULT_LOSE or RESULT_WIN
    end
    BattleField.dead[soldier.side][soldier.soldierId] = BattleField.round
    BattleField.clearSoldier(soldier.side, soldier.x)
    local removeIndex = 0
    for i,s in ipairs(BattleField.soldiers) do
        if s.sid == soldier.sid then
            removeIndex = i
            break
        end
    end
    table.remove(BattleField.soldiers, removeIndex)
end

local function addSoldier(soldier)
    table.insert(BattleField.soldiers, soldier)
    BattleField.soldierCount[soldier.side] = BattleField.soldierCount[soldier.side] + 1
end

local function startPhase()
    BattleLog:addLog("init", {})
    BattleField.setSoldier()
    for i,soldier in ipairs(BattleField.soldiers) do
        BattleLog:appendLog(Soldier:display(soldier))
    end
end

local function addTeam(battleInfo, side)
    for i,soldierData in ipairs(battleInfo) do
        local soldier = Soldier:createWithData(soldierData, BattleField)
        soldier.side = side
        soldier.sid = string.format("%s.%d", side, i)
        addSoldier(soldier)
    end
end

local function computeFirst()
    local left = 0
    local right = 0
    for i,soldier in ipairs(BattleField.soldiers) do
        if soldier.fame then
            if soldier.side == SIDE_LEFT then
                left = soldier.fame
            else
                right = soldier.fame
            end
        end
    end
    BattleField.first = left >= right and SIDE_LEFT or SIDE_RIGHT
    BattleLog:addLog("fame")
    local log = {}
    log["left"] = left
    log["right"] = right
    log["first"] = BattleField.first
    BattleLog:appendLog(log)
end

local function computeOrder()
    local order = {}
    local nextSide = BattleField.first
    for i=1, 8 do
        local soldier = BattleField.getSoldier(nextSide, i)
        nextSide = nextSide == SIDE_LEFT and SIDE_RIGHT or SIDE_LEFT
        if soldier and not soldier.isDead then
            table.insert(order, soldier)
        end
    end
    nextSide = BattleField.first == SIDE_LEFT and SIDE_RIGHT or SIDE_LEFT
    for i=1, 8 do
        local soldier = BattleField.getSoldier(nextSide, i)
        nextSide = nextSide == SIDE_LEFT and SIDE_RIGHT or SIDE_LEFT
        if soldier and not soldier.isDead then
            table.insert(order, soldier)
        end
    end
    local ids = {}
    for i,v in ipairs(order) do
        table.insert(ids, v.sid)
    end
    return order
end

local function attackPhase()
    local order = computeOrder()
    if #order == 0 then
        BattleField.endFlag = true
        return
    end
    for i,soldier in ipairs(order) do
        Soldier:attack(soldier)
    end
end

local function endPhase()
    BattleLog:addLog("end", {})
end

local function buffPhase()
    local buff = {{}, {}, {}}
    for i,soldier in ipairs(BattleField.soldiers) do
        for j,skill in ipairs(soldier.buffSkill) do
            table.insert(buff[j], {soldier, skill})
        end
    end
    for i=1,3 do
        if table.getTableCount(buff[i]) > 0 then
            BattleLog:addLog("buff", {})
            for j,dic in ipairs(buff[i]) do
                local s = dic[1]
                local skill = dic[2]
                local log = {}
                log["from"] = {["side"] = s.side, ["x"] = s.x}
                log["sid"] = s.sid
                log["skill"] = skill.skillId
                log["skillName"] = skill.skillName
                log["param"] = {}
                for k,v in pairs(skill.attr) do
                    log["param"][k] = v
                end
                BattleLog:appendLog(log)
            end
        end
    end
end

-- 修正双方属性，发动战场buff技能
local function fixFieldAttr()
    local buffs = {}
    for i,soldier in ipairs(BattleField.soldiers) do
        if soldier.fieldSkill and table.getTableCount(soldier.fieldSkill) > 0 then
            for skillId,skill in pairs(soldier.fieldSkill) do
                skill.sid = soldier.sid
                skill.side = soldier.side
                skill.x = soldier.x
                table.insert(buffs, skill)
            end
        end
    end
    if BattleField.mode == BattleMode.boss or BattleField.mode == BattleMode.racingBattleBoss then
        return
    end
    for i,skill in ipairs(buffs) do
        BattleLog:addLog("fieldBuff", {})
        local fromLog = {}
        fromLog["from"] = {["side"] = skill.side, ["x"] = skill.x}
        fromLog["sid"] = skill.sid
        fromLog["skill"] = skill.skillId
        fromLog["skillName"] = skill.skillName
        BattleLog:appendLog(fromLog)
        for k,v in pairs(skill.attr) do
            local toLog = {}
            -- v < 0 对方减属性 or v > 0 己方加属性
            for i,s in ipairs(BattleField.soldiers) do
                if (v < 0 and s.side ~= skill.side) or (v > 0 and s.side == skill.side) then
                    s.attr[k] = math.floor(s.attr[k] * (1 + v))
                    s.baseAttr[k] = math.floor(s.baseAttr[k] * (1 + v))
                    toLog["to"] = {["side"] = s.side, ["x"] = s.x}
                    toLog["sid"] = s.sid
                    toLog["skill"] = skill.skillId
                    toLog["skillName"] = skill.skillName
                    toLog["param"] = {[k] = v}
                    BattleLog:appendLog(deepcopy(toLog))
                end
            end
        end
    end
end

-- 战斗开始前，输出站位
local function _layout()
    BattleLog:addLog("layout", {})
    BattleField.setSoldier()
    for i,soldier in ipairs(BattleField.soldiers) do
        BattleLog:appendLog(Soldier:layout(soldier))
    end
    BattleLog:addLog("count", {})
    BattleLog:appendLog(BattleField.count)
end


local function engage()
    -- RandomManager.cursor = RandomManager.randomRange(0, 999)
    -- 双方加buff
    _layout() -- 输出站位
    fixFieldAttr() -- 修正属性，场地buff动画
    buffPhase() -- 加buff动画
    computeFirst()
    for i=1,2 do
        if BattleField.finishFlag then
            break
        end
        -- 前两回合打
        BattleField.round = BattleField.round + 1
        startPhase()
        BattleLog:addLog("round", BattleField.round)
        BattleField.endFlag = false
        for i=1,5 do
            -- 每回合打5轮，直到没有配对
            if BattleField.endFlag then
                break
            end
            attackPhase()
        end
        endPhase()
        BattleField.first = BattleField.first == SIDE_LEFT and SIDE_RIGHT or SIDE_LEFT
    end
    if not BattleField.finishFlag then
        -- 第3回合比内力
        BattleField.finishFlag = true

        BattleField.round = BattleField.round + 1
        BattleLog:addLog("round", BattleField.round)

        local leftHP = 0
        local rightHP = 0
        local leftInt = 0
        local rightInt = 0

        for i,soldier in ipairs(BattleField.soldiers) do
            if soldier and not soldier.isDead then
                if soldier.side == SIDE_LEFT then
                    leftHP = leftHP + soldier.attr.hp
                    leftInt = leftInt + soldier.attr.mp
                else
                    rightHP = rightHP + soldier.attr.hp
                    rightInt = rightInt + soldier.attr.mp
                end
            end
        end

        BattleField.result = rightInt + rightHP > leftHP + leftInt and RESULT_LOSE or RESULT_WIN
        local win
        if leftHP + leftInt == rightInt + rightHP then
            win = BattleField.first
        else
            win = leftHP + leftInt > rightInt + rightHP and SIDE_LEFT or SIDE_RIGHT
        end 
        BattleLog:addLog("force", {})
        local log = {["leftHP"] =  leftHP, ["leftInt"] = leftInt, ["rightHP"] = rightHP, ["rightInt"] = rightInt, ["win"] = win}
        BattleLog:appendLog(log)
    end
    BattleLog:addLog("finish", BattleField.result)
end

local function bossEngage()
    _layout() -- 输出站位
    fixFieldAttr() -- 修正属性，场地buff动画
    -- buffPhase() -- 加buff动画
    startPhase()
    -- 我方先出手
    local function _attackPhase()
        for i=1, BattleField.soldierCount.left do
            local soldier = BattleField.getSoldier(SIDE_LEFT, i)
            Soldier:attack(soldier)
        end
    end
    _attackPhase()
    -- boss出手
    local function _bossAttack()
        local boss = BattleField.getSoldier(SIDE_RIGHT, 1)
        BattleLog:addLog("attack", {})
        local log = {}
        local skill
        for sid,s in pairs(boss.skill) do
            skill = s
            break
        end
        log["range"] = skill.range
        log["skill"] = {["id"] = skill.skillId, ["rank"] = skill.skillRank}
        log["action"] = "attack"
        log["from"] = {["side"] = boss.side, ["x"] = boss.x}
        log["sid"] = boss.sid
        BattleLog:appendLog(deepcopy(log))
        for i=1,BattleField.soldierCount.left do
            local soldier = BattleField.getSoldier(SIDE_LEFT, i)
            local aLog = {
                ["effect"] = {["hp"] = -999999},
                ["attackType"] = "hit",
                ["hpMax"] = soldier.baseAttr["hp"],
                ["hp"] = soldier.attr["hp"],
                ["action"] = "attacked",
                ["from"] = {["side"] = soldier.side, ["x"] = soldier.x},
                ["sid"] = soldier.sid
            }
            BattleLog:appendLog(deepcopy(aLog))

            local sideCount = soldier.battleField.soldierCount[soldier.side]
            sideCount = sideCount - 1
            local dLog = {
                ["type"] = "overkill",
                ["id"] = soldier.soldierId,
                ["action"] = "die",
                ["from"] = {["side"] = soldier.side, ["x"] = soldier.x},
                ["sid"] = soldier.sid
            }
            if sideCount == 0 then
                dLog["lastOne"] = 1
            end
            BattleLog:appendLog(deepcopy(dLog))
            soldier.battleField.removeSoldier(soldier)
        end
    end
    _bossAttack()
    BattleLog:addLog("finish", BattleField.result)
    BattleField.round = 2
end

-- boss战特殊处理
function BattleField:bossFight(bossId, level, hpMax, hp, buff)
    local bossBattleInfo = battledata:getBossBattleInfo(bossId, level, hpMax, hp)
    BattleField.mode = BattleMode.boss
    initBattleField()
    addTeam(battledata:getPlayerBattleInfo(nil, buff), SIDE_LEFT)
    addTeam(bossBattleInfo, SIDE_RIGHT)
    BattleLog:clearLogs()
    bossEngage()
    -- BattleLog:getJson()
    BattleLog.convertAnimationLogs()
end

function BattleField:fight(left, right)
    initBattleField()
    addTeam(left, SIDE_LEFT)
    addTeam(right, SIDE_RIGHT)
    BattleLog:clearLogs()
    engage()
    BattleLog:getJson()
    BattleLog.convertAnimationLogs()
end

function BattleField:stageFight(stageId)
    BattleField.mode = BattleMode.stage
    runtimeCache.stageId = stageId
    BattleField:fight(battledata:getPlayerBattleInfo(), battledata:getStageBattleInfo(stageId))
end

function BattleField:eliteFight(stageId)
    BattleField.mode = BattleMode.stage
    runtimeCache.stageId = stageId
    BattleField:fight(battledata:getPlayerBattleInfo(), battledata:getEliteBattleInfo(stageId))
end

function BattleField:marineBossFight(bossId)
    BattleField.mode = BattleMode.marineBoss
    BattleField:fight(battledata:getPlayerBattleInfo(), battledata:getMarineBossBattleInfo(bossId))
end

function BattleField:newWorldFight(playerCount, buff, npcBattleInfo)
    BattleField.mode = BattleMode.newWorld
    BattleField:fight(battledata:getPlayerBattleInfo(playerCount, buff), battledata:convertBattleInfo(npcBattleInfo))
end

function BattleField:hakiFight(hid, kind, layer)
    BattleField.mode = BattleMode.hakiFight
    BattleField:fight(battledata:getPlayerBattleInfoByHid(hid), battledata:getHakiBattleInfo(kind, layer))
end

function BattleField:chapterFight()
    BattleField.mode = BattleMode.chapter
    BattleField:fight(battledata:getPlayerBattleInfo(), battledata:getPVPBattleInfo())
end

function BattleField:arenaFight()
    BattleField.mode = BattleMode.arena
    BattleField:fight(battledata:getPlayerBattleInfo(), battledata:getPVPBattleInfo())
end

function BattleField:unionBattle(buff)
    BattleField.mode = BattleMode.unionBattle
    BattleField:fight(battledata:getPlayerBattleInfo(nil, buff), battledata:getPVPBattleInfo())
end

function BattleField:OPAniFight()
    BattleField.mode = BattleMode.opAni
    BattleLog.logs = readJsonFileStr("opAni")
    BattleField.leftName = HLNSLocalizedString("opAni.leftName")
    BattleField.rightName = HLNSLocalizedString("opAni.rightName")
end

function BattleField:wwRobFight()
    BattleField.mode = BattleMode.wwRob
    BattleField:fight(battledata:getPlayerBattleInfo(), battledata:getPVPBattleInfo())
end

function BattleField:SSAFight(buff, oppoBuff)
    BattleField.mode = BattleMode.SSA
    local left = {}
    local attrKey = {"atk", "def", "mp", "hp", "cri", "dod", "hit", "resi", "parry", "cnt"}
    if buff then
        for i,k in ipairs(attrKey) do
            left[k] = buff
        end
    end
    BattleField:fight(battledata:getPlayerBattleInfo(nil, left), battledata:getPVPBattleInfo(oppoBuff))
end

-- 跨服联盟竞速战
function BattleField:racingBattleFight(npcBattleInfo, buff)
    BattleField.mode = BattleMode.racingBattle
    local left = {}
    local attrKey = {"atk", "def", "mp", "hp", "cri", "dod", "hit", "resi", "parry", "cnt"}
    if buff then
        for i,k in ipairs(attrKey) do
            left[k] = buff
        end
    end
    BattleField:fight(battledata:getPlayerBattleInfo(nil, left), npcBattleInfo)
end


-- 跨服联盟竞速战 boss
function BattleField:racingBattleBossFight(bossId, level, hpMax, hp, buff)
    
    local bossBattleInfo = battledata:getBossBattleInfo(bossId, level, hpMax, hp)
    BattleField.mode = BattleMode.racingBattleBoss
    initBattleField()
    addTeam(battledata:getPlayerBattleInfo(nil, buff), SIDE_LEFT)
    addTeam(bossBattleInfo, SIDE_RIGHT)
    BattleLog:clearLogs()
    bossEngage()
    -- BattleLog:getJson()
    BattleLog.convertAnimationLogs()
end

function BattleField:SSAVideo(enemy, player)
    BattleField.mode = BattleMode.SSAVideo
    runtimeCache.bVideo = true
    playerBattleData:fromDic(enemy)
    local left = battledata:getPVPBattleInfo()
    playerBattleData:fromDic(player)
    local right = battledata:getPVPBattleInfo()
    BattleField:fight(left, right)
end

function BattleField:wwRobFightVideo(enemy, player)
    BattleField.mode = BattleMode.wwRobVideo
    runtimeCache.bVideo = true
    playerBattleData:fromDic(enemy)
    local left = battledata:getPVPBattleInfo()
    playerBattleData:fromDic(player)
    local right = battledata:getPVPBattleInfo()
    BattleField:fight(left, right)
end

--[[
    bossBuff -- 关卡敌人获得的buff
    buff -- 自己复活获得的buff
]]
function BattleField:veiledSeaFight(stage, bossId, bossBuff, buff)
    BattleField.mode = BattleMode.veiledSea
    --PrintTable(buff)
    BattleField:fight(battledata:getPlayerBattleInfo(nil, buff), battledata:getVeiledSeaBattleInfo(stage, bossId, bossBuff))
end

-- buff是全属性添加，这里需要转换一下
-- 海战计算
function BattleField:worldwarFight(oppoBattleInfo, buff, oppoBuff)
    BattleField.mode = BattleMode.worldwar
    local left = {}
    local right = {}
    local attrKey = {"atk", "def", "mp", "hp", "cri", "dod", "hit", "resi", "parry", "cnt"}
    if buff then
        for i,k in ipairs(attrKey) do
            left[k] = buff
        end
    end
    if oppoBuff then
        for i,k in ipairs(attrKey) do
            right[k] = oppoBuff
        end
    end
    BattleField:fight(battledata:getPlayerBattleInfo(nil, left), battledata:getPVPBattleInfo(right))
end

-- 获取跳过类型 1、不能跳过， 2、15秒以后跳过， 3、随时跳过
function BattleField:getSkipType()
    if runtimeCache.bVideo then
        return 3
    end
    if BattleField.mode == BattleMode.stage then
        local star = 0
        if stageMode == STAGE_MODE.NOR then
            star = storydata:getStageStar(runtimeCache.stageId)
        elseif stageMode == STAGE_MODE.ELITE then
            star = elitedata:getStageStar(runtimeCache.stageId)
        end
        if star == 0 then
            return 1
        else
            return 3 --lsf 一星即可跳过
        end
    elseif BattleField.mode == BattleMode.newWorld then
        return runtimeCache.newWorldSkip
    elseif BattleField.mode == BattleMode.opAni then
        return 1
    elseif BattleField.mode == BattleMode.worldwar then
        return vipdata:getVipLevel() >= vipdata:getVipWWLevel() and 3 or 2
    elseif BattleField.mode == BattleMode.SSA then
        return 3
    else
        return 2
    end
end

-- 返回战斗背景序号
function BattleField:getFightBg()
    if BattleField.mode == BattleMode.stage then
        local config
        if stageMode == STAGE_MODE.NOR then
            config = storydata:getSmallStage(runtimeCache.stageId)
        elseif stageMode == STAGE_MODE.ELITE then
            config = elitedata:getSmallStage(runtimeCache.stageId)
        end
        return config.bg == nil and 1 or config.bg
    elseif BattleField.mode == BattleMode.opAni then
        return 2
    elseif BattleField.mode == BattleMode.boss then
        if bossdata.thisBoss.key and ConfigureStorage.bossAttr[bossdata.thisBoss.key] and ConfigureStorage.bossAttr[bossdata.thisBoss.key].bg then
            return ConfigureStorage.bossAttr[bossdata.thisBoss.key].bg
        else
            return 6
        end
    elseif BattleField.mode == BattleMode.racingBattleBoss then
        if bossdata.thisBoss.key and ConfigureStorage.bossAttr[bossdata.thisBoss.key] and ConfigureStorage.bossAttr[bossdata.thisBoss.key].bg then
            return ConfigureStorage.bossAttr[bossdata.thisBoss.key].bg
        else
            return 6
        end
    else
        return RandomManager.randomRange(1, 6)
    end
end



