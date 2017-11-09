-- 用户数据缓存

heroSoulData = {
    souls = {},
}

-- 添加一个将魂
function heroSoulData:addHeroSoulByDic( dic )
    for key,value in pairs(dic) do
        if heroSoulData.souls[key] then
            heroSoulData.souls[key] = heroSoulData.souls[key] + value
        else
            heroSoulData.souls[key] = value
        end
    end
end

-- 减少魂魄
-- 参数：soulId - 魂魄id  amount - 减少的数目
function heroSoulData:reduceSoul(soulId, amount)
    print(soulId, amount)
    if heroSoulData.souls[soulId] and heroSoulData.souls[soulId] >= amount then
        heroSoulData.souls[soulId] = heroSoulData.souls[soulId] - amount
    end 
    if heroSoulData.souls[soulId] == 0 then
        heroSoulData.souls[soulId] = nil
    end 
end 

-- 返回所有的魂魄信息
function heroSoulData:getAllSoulsInfo(isBattleShip)
    local souls = {}
    for k,v in pairs(heroSoulData.souls) do
        if v > 0 then 
            local soul = {}
            soul.id = k
            soul.amount = v
            soul.name = ConfigureStorage.heroConfig[k].name
            soul.rank = ConfigureStorage.heroConfig[k].rank
            if herodata:isHeroById(soul.id) then 
                soul.state = "break"          -- 当前是突破状态
                local heroInfo = herodata:getHeroInfoById(soul.id)
                if heroInfo then
                    if soul.amount >= heroSoulData:getBreakNeedSoulCount(soul.rank, heroInfo["break"], heroInfo["wake"]) then
                        soul.canBreak = 1    -- 可突破
                        soul.sortFlag = 0      -- 用于排序，数字越小，排位越靠前
                        soul["break"] = heroInfo["break"]   
                    else
                        soul.canBreak = 0
                        soul.breCount = heroSoulData:getBreakNeedSoulCount(soul.rank, heroInfo["break"], heroInfo["wake"]) - soul.amount    -- 突破所需魂魄数
                        soul.sortFlag = 3 
                        soul["break"] = heroInfo["break"]
                    end
                end
            else
                soul.state = "recruit"           -- 当前是招募状态
                if soul.amount >= tonumber(ConfigureStorage.heroRecuit[string.format("%d", soul.rank)].hero) then
                    soul.canRecruit = 1      -- 可招募
                    soul.sortFlag = 1
                else
                    soul.canRecruit = 0
                    soul.recCount = ConfigureStorage.heroRecuit[string.format("%d", soul.rank)].hero - soul.amount    -- 招募所需魂魄数
                    soul.sortFlag = 2
                end
            end
            table.insert(souls, soul)
        end
    end
    local function sortFun(a, b)
        if a.sortFlag == b.sortFlag then
            if a.rank == b.rank then
                return a.amount > b.amount
            end 
            return a.rank > b.rank
        end 
        return a.sortFlag < b.sortFlag
    end
    local function shipSortFun( a,b )
        if a.rank == b.rank then
            if a.amount == b.amount then
                return string.sub(a.id,9,11) > string.sub(b.id,9,11)
            end
            return a.amount < b.amount
        end
        return a.rank < b.rank 
    end
    if isBattleShip ~= nil then
        table.sort( souls, shipSortFun )
    else
        table.sort( souls, sortFun )
    end
    return souls
end

--得到一个魂魄可以提供的经验
function heroSoulData:soulCanGetEXPById( uniqueid )
    local rank = ConfigureStorage.heroConfig[uniqueid].rank
    print("执行了这里",ConfigureStorage.warship_exp[string.format("%s",rank)].soul,rank)
    return ConfigureStorage.warship_exp[string.format("%s",rank)].soul
end

-- 获得拥有某个英雄的魂魄数
function heroSoulData:getSoulCountByHeroId( heroId )
    if heroSoulData.souls[heroId] then
        return heroSoulData.souls[heroId]
    end
    return 0
end

-- 获得某个英雄突破所需的魂魄
function heroSoulData:getBreakNeedSoulCount(rank, curBreak, awake)
    local conf = ConfigureStorage.heroRecuit
    if awake then
        if rank == 3 then
            if awake == 1 then
                rank = 5
            elseif awake == 2 then
                rank = 6
            end
        elseif rank == 4 then
            if awake == 2 then
                rank = 7
            end
        end
    end
    if conf[tostring(rank)] == nil then
        return 0 
    end 
    if curBreak >= #conf[string.format("%d", rank)]["break"] then
        -- 已突破到顶级
        return 1000000
    end 

    return tonumber(conf[string.format("%d", rank)]["break"][curBreak+1])
end

--获得某个品阶的英雄突破可获得的潜能点
function heroSoulData:getBreakedPointByRank(rank)
    local conf = ConfigureStorage.heroRecuit
    if conf[tostring(rank)] == nil then
        return 0 
    end 
    return conf[tostring(rank)].breakcapacity
end

--重置魂魄数据
function heroSoulData:resetAllData()
    heroSoulData.souls = {}
end

