-- 招募信息缓存

recruitData = {
    recruit = {},
    allCardsInfo = {},
    cdTimes = {},
    tempCDTimer = {},
    times = {},
    heros = {},
    lastTime = {}
}
-- 根据位置判断是否是首刷
function recruitData:isFirstRefreshByTag( tag )
    if recruitData.recruit and recruitData.recruit ~= {} and recruitData.recruit ~= "" then
        if recruitData.recruit.times and recruitData.recruit.times[tostring(tag)] then
            if tonumber(recruitData.recruit.times[tostring(tag)]["gold"]) ~= 0 then
                return false
            end
        end
    end
    return true
end

--登陆时初始化cd时间
function recruitData:setAllCardCDTime(  )
    if recruitData.recruit and recruitData.recruit ~= {} and recruitData.recruit ~= "" then
        local retArray = {}
        local freeRecruitCDTime = ConfigureStorage.freeRecruitCDTime
        for i=1,3 do
            if recruitData.recruit.lastTime and recruitData.recruit.lastTime[string.format("%d",i)] then
                local cdTime = math.abs(userdata.loginTime - recruitData.recruit.lastTime[tostring(i)])
                if cdTime >= freeRecruitCDTime[string.format("%d",i)] then
                    cdTime = 0
                else
                    cdTime = freeRecruitCDTime[string.format("%d",i)] - cdTime
                end
                retArray[i] = cdTime
            else
                retArray[i] = 0
            end
        end
        recruitData.cdTimes = retArray
    else
        recruitData.cdTimes = { 0,0,0 }
    end
end
--获得所有的cd时间
function recruitData:getAllCardCDTime()

	return recruitData.cdTimes
end
--获得所有招募卡片的信息
function recruitData:getAllRecruitCardInfo(  )
    recruitData:setAllCardCDTime()
	local freeRecruitCDTime = recruitData.cdTimes
	local freeRecruitTimes = ConfigureStorage.freeRecruitTimes
	local recruitPay = ConfigureStorage.recruitPay
	local recruitPayFirst = ConfigureStorage.recruitPayFirst
	for i=1,3 do
		local card = {}
		card["freeRecruitCDTime"] = freeRecruitCDTime[i]
		card["freeRecruitTimes"] = freeRecruitTimes[string.format("%d",i)]
		card["recruitPay"] = recruitPay[string.format("%d",i)]
		card["recruitPayFirst"] = recruitPayFirst[string.format("%d",i)]
		recruitData.allCardsInfo[i] = card
	end
    return recruitData.allCardsInfo
end

-- 根据位置获得招募所需金币
function recruitData:getRecruitPriceByTag( tag )
    return ConfigureStorage.recruitPay[tostring(tag)]
end

-- 返回可以招募的索引数组
function recruitData:getCanFreeRecruitArray(  )
    local retArray = {}
    local cardInfo = recruitData:getAllRecruitCardInfo()
    for i=1,3 do
        retArray[i] = cardInfo[i].freeRecruitCDTime == 0 and 1 or 0    --为1可以免费招募
        if recruitData.recruit and recruitData.recruit ~= {} and recruitData.recruit ~= "" then
            if i == 1 then      -- 百万悬赏显示略微不同
                if recruitData.recruit.times and recruitData.recruit.times[string.format("%d",i)] then
                    if cardInfo[i].freeRecruitTimes == recruitData.recruit.times[string.format("%d",i)]["dayFree"] then
                        retArray[i] = 0
                    end
                end
            end
        end
    end
    return retArray
end

-- 返回是否存在可以免费招募的选项
function recruitData:isHaveCanFreeRecruitItem(  )
    local freeRecruitArray = recruitData:getCanFreeRecruitArray(  )
    -- print("免费可以招募的数组")
    -- PrintTable(freeRecruitArray)
    for i=1,getMyTableCount(freeRecruitArray) do
        if freeRecruitArray[i] == 1 then
            return true
        end
    end
    return false
end

-- 刷将送魂
function recruitData:getActivityBonus(index)
    if index == 1 then
        return nil
    end
    local key = index == 2 and "100recruitSendSoul" or "300recruitSendSoul"
    if not recruitData.recruit.activitySoul or not recruitData.recruit.activitySoul[key] then
        return nil
    end
    local conf = recruitData.recruit.activitySoul[key]
    if not conf.expect or table.getTableCount(conf.expect) == 0 then
        return nil
    end
    local ret = {}
    for k,v in pairs(conf.expect) do
        if not table.ContainsObject(ret, v.hero) then
            ret[#ret + 1] = v.hero
        end
    end
    return ret
end

-- 刷将送魂
function recruitData:getActivityBonusAndResult(index)
    if index == 1 then
        return nil
    end
    local key = index == 2 and "100recruitSendSoul" or "300recruitSendSoul"
    if not recruitData.recruit.activitySoul or not recruitData.recruit.activitySoul[key] then
        return nil
    end
    local conf = recruitData.recruit.activitySoul[key]
    if not conf.expect or table.getTableCount(conf.expect) == 0 then
        return nil
    end
    local ret = {}
    for k,v in pairs(conf.expect) do
        if not table.ContainsObject(ret, v.hero) then
            ret[#ret + 1] = v.hero
        end
    end
    for k,v in pairs(conf.result) do
        if not table.ContainsObject(ret, v.hero) then
            ret[#ret + 1] = v.hero
        end
    end
    local function sortFun(a, b)
        local confA = herodata:getHeroConfig(a)
        local confB = herodata:getHeroConfig(b)
        if confA.rank == confB.rank then
            return a > b
        end
        return confA.rank > confB.rank
    end
    table.sort(ret, sortFun)
    return ret
end

-- 刷将列表
function recruitData:getRecruitHeroes(index)
    local conf = ConfigureStorage.recruit[tostring(index)]
    local array = {}
    for k, dic in pairs(conf) do
        for heroId, weight in pairs(dic) do
            local hero = deepcopy(herodata:getHeroConfig(heroId))
            array[#array + 1] = hero
        end
    end
    local function sortFun(a, b)
        if a.rank == b.rank then
            return a.heroId > b.heroId
        end 
        return a.rank > b.rank
    end
    table.sort(array, sortFun)
    return array
end

--重置用户数据
function recruitData:resetAllData()
    recruitData.allCardsInfo = {}
    recruitData.cdTimes = {}
    recruitData.tempCDTimer = {}
    recruitData.times = {}
    recruitData.heros = {}
    recruitData.lastTime = {}
end

