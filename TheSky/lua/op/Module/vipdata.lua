vipdata = {
    vipScore = 0,
    vipItems = {},
    vipDailyItems = {},
    firstCashAward1 = {},
    firstCashAward2 = {},
}

--重置用户数据
function vipdata:resetAllData()
    vipdata.vipScore = 0
    vipdata.vipItems = {}
    vipDailyItems = {}
    vipdata.firstCashAward1 = {}
    vipdata.firstCashAward2 = {}
end

-- 获得到下一级vip所需的人民币数量，这个方法只用于中文地区
function vipdata:getVipRMB(  )
    local rate = ConfigureStorage.vipConfig[5].score / ConfigureStorage.vipConfig[5].cash
    -- local maxVip = #ConfigureStorage.vipConfig - 1
    for i,v in ipairs(ConfigureStorage.vipConfig) do
        if vipdata.vipScore / rate < v.cash then -- and i < maxVip then
            return ConfigureStorage.vipConfig[i].cash - vipdata.vipScore / rate
        end
    end
    return -1                                                          
end

-- 获得下一级vip所需的充值金币数量
function vipdata:getNextVipNeedGold()
    for i,v in ipairs(ConfigureStorage.vipConfig) do
        if vipdata.vipScore < v.score then
            return v.score - vipdata.vipScore
        end
    end
    return -1  
end

-- 获得vip等级
function vipdata:getVipLevel()
    for i,v in ipairs(ConfigureStorage.vipConfig) do
        if vipdata.vipScore < v.score then
            return i - 1 - 1        -- i从1开始
        end
    end
    return #ConfigureStorage.vipConfig - 1
end

function vipdata:getVipNextLevel()
    local vipLevel = vipdata:getVipLevel()
    return math.min(vipLevel + 1, table.getTableCount(ConfigureStorage.vipConfig) - 1)
end

-- 获取到下一级VIP需要的完整积分
function vipdata:getNextVipScore()
    local dic = ConfigureStorage.vipConfig[vipdata:getVipNextLevel() + 1]
    if not dic then
        -- 满级了
        dic = ConfigureStorage.vipConfig[vipdata:getVipLevel() + 1]
    end
    return dic.score
end

-- 获得好友上限
function vipdata:getFriendLimitByVipLevel( vipLevel )
    for i,v in ipairs(ConfigureStorage.vipConfig) do
        if i == vipLevel then
            print("好友上线",vipLevel,v.friend)
            return v.friend 
        end
    end
    return 0
end

-- 获得关注上限
function vipdata:getAttentionLimitByVipLevel( vipLevel )
    for i,v in ipairs(ConfigureStorage.vipConfig) do
        if i == vipLevel then
            return v.attention 
        end
    end
    return 0
end

-- 获取开启连闯需要的vip等级
function vipdata:getVipRaidsLevel()
    for i,v in ipairs(ConfigureStorage.vipConfig) do
        if v.raids == 1 then
            return i - 1
        end
    end
    return #ConfigureStorage.vipConfig
end

-- 获取清除战斗次数需要的vip等级
function vipdata:getVipFightingLevel()
    for i,v in ipairs(ConfigureStorage.vipConfig) do
        if v.fighting == 1 then
            return i - 1
        end
    end
    return #ConfigureStorage.vipConfig
end

-- 获取清除连闯cd需要的vip等级
function vipdata:getVipRaidsCDLevel()
    for i,v in ipairs(ConfigureStorage.vipConfig) do
        if v.raidsCD == 1 then
            return i - 1
        end
    end
    return #ConfigureStorage.vipConfig
end

-- 获取10连开箱子需要的vip等级
function vipdata:getBox10Level()
    for i,v in ipairs(ConfigureStorage.vipConfig) do
        if v.box10 == 1 then
            return i - 1
        end
    end
    return #ConfigureStorage.vipConfig
end

-- 获得vip等级可以增加的对歌数
function vipdata:getCanAddSingCount( vipLevel )
    print(vipLevel)
    return ConfigureStorage.vipConfig[tonumber(vipLevel + 1)].sound
end

-- 获得可恢复体力次数
function vipdata:recoverStrengthTimes(vipLevel)
    return ConfigureStorage.vipConfig[vipLevel + 1].energy
end

-- 获得可恢复精力次数
function vipdata:recoverEnergyTimes(vipLevel)
    return ConfigureStorage.vipConfig[vipLevel + 1].vitality
end

-- 获得下一VIP阶段可恢复体力次数
function vipdata:getNextRecoverStrengthLevel()
    local level = vipdata:getVipLevel()
    local count = vipdata:recoverStrengthTimes(level)
    for i,v in ipairs(ConfigureStorage.vipConfig) do
        if v.energy > count then
            level = i
            count = v.energy
            break
        end
    end
    return level, count
end

-- 获得下一VIP阶段可恢复精力次数
function vipdata:getNextRecoverEnergyLevel()
    local level = vipdata:getVipLevel()
    local count = vipdata:recoverEnergyTimes(level)
    for i,v in ipairs(ConfigureStorage.vipConfig) do
        if v.vitality > count then
            level = i
            count = v.vitality
            break
        end
    end
    return level, count
end
-- 获得首充的key值
function vipdata:getFirstRechargeKey(  )
    local array = ConfigureStorage.firstCashAward1
    local retKey = 0
    for k,v in pairs(array) do
        if tonumber(k) >= tonumber(retKey) then
            retKey = k
        end
    end
    return retKey
end
-- 判断是否在首充活动
function vipdata:isFirstRecharge(  )
    if not vipdata.firstCashAward1 then
        return true
    else
        local rechageTime = vipdata:getFirstRechargeKey(  )
        if not vipdata.firstCashAward1[tostring(rechageTime)] then
            return true
        end
    end
    return false
end

-- 如果是首充，返回首充的阶段
function vipdata:returnRchargePhase( )
    local rechageTime = vipdata:getFirstRechargeKey(  ) 
    if vipdata.firstCashAward1[tostring(rechageTime)].flag == 1 then
        -- 还没领金币
        return 1
    else
        if vipdata.firstCashAward2[tostring(rechageTime)].flag == 1 then
            -- 还没领item
            return 2 
        else
            -- 都领完了
            if dailyData:havaRefoundAwardActive() then
                -- 有充值返利活动
                return 3
            else 
                -- 没有充值返利活动
                return 4
            end
        end
    end
end

-- 获取vip特权
function vipdata:getVipDesp(vipLevel)
    local dic = ConfigureStorage.vipdesp[tostring(vipLevel)]
    local str = ""
    for i=1,table.getTableCount(dic) do
        if i > 1 then
            str = string.format("%s\r\n", str)
        end
        str = string.format("%s%s", str, dic["desp"..i])
    end
    return str
end

function vipdata:getVipAward(vipLevel)
    local awards = ConfigureStorage.vipaward[tostring(vipLevel)].award
    local array = {}
    for i=1,4 do
        local dic = awards[tostring(i)]
        table.insert(array, dic)
    end
    return array
end

-- 获得vip每日礼包奖励
function vipdata:getVipDayGiftAward(vipLevel)
    local awards = ConfigureStorage.vip_perday[tostring(vipLevel)].award
    local array = {}
    for i=1,4 do
        local dic = awards[tostring(i)]
        table.insert(array, dic)
    end
    return array
end

-- 是否有可领的奖励
function vipdata:bHaveAward()
    local vipLevel = vipdata:getVipLevel()
    if vipLevel == 0 then
        return false
    elseif not vipdata.vipItems then
        return true
    end

    for i=1,vipLevel do
        if not vipdata.vipItems[tostring(i)] or tonumber(vipdata.vipItems[tostring(i)]) ~= 1 then
            return true
        end
    end
    return false
end

-- 获取可领奖的页码
function vipdata:getAwardPage()
    local vipLevel = vipdata:getVipLevel()
    if vipLevel == 0 or not vipdata.vipItems then
        return 0
    end
    for i=1,vipLevel do
        if not vipdata.vipItems[tostring(i)] or tonumber(vipdata.vipItems[tostring(i)]) ~= 1 then
            return i - 1
        end
    end
    return math.min(vipLevel, table.getTableCount(ConfigureStorage.vipaward) - 1)
end

-- VIP礼包个数
function vipdata:getVipRewardCount()
    local vipLevel = vipdata:getVipLevel()
    if vipLevel == 0 then
        return 0
    elseif not vipdata.vipItems then
        return vipLevel
    end
    local count = 0
    for i=1,vipLevel do
        if not vipdata.vipItems[tostring(i)] or tonumber(vipdata.vipItems[tostring(i)]) ~= 1 then
            count = count + 1
        end
    end
    return count
end


-- 获取海战跳过需要的vip等级
function vipdata:getVipWWLevel()
    for i,v in ipairs(ConfigureStorage.vipConfig) do
        if v.camp == 1 then
            return i - 1
        end
    end
    return #ConfigureStorage.vipConfig
end

-- 获取炼影拼命炼十次需要的vip等级
function vipdata:getVipPinMingTenLevel()
    for i,v in ipairs(ConfigureStorage.vipConfig) do
        if v.shadowEx10 == 1 then
            return i - 1
        end
    end
    return #ConfigureStorage.vipConfig
end

-- 获取炼影拼命炼三十次需要的vip等级
function vipdata:getVipPinMingThirtyLevel()
    for i,v in ipairs(ConfigureStorage.vipConfig) do
        if v.shadowEx30 == 1 then
            return i - 1
        end
    end
    return #ConfigureStorage.vipConfig
end

-- 获取迷雾之海额外挑战次数
function vipdata:getVipSeaVeiledExtraLevel(vipLevel)
    for i,v in ipairs(ConfigureStorage.vipConfig) do
        if i == vipLevel then
            return v.smExtra 
        end
    end
    return 0
end

-- 获取迷雾之海复活次数
function vipdata:getVipSeaVeiledChungeLevel(vipLevel)
    for i,v in ipairs(ConfigureStorage.vipConfig) do
        if i == vipLevel then
            return v.smChunge 
        end
    end
    return 0
end

-- 获取迷雾之海自动挑战等级
function vipdata:getVipAutoLevel()
    for i,v in ipairs(ConfigureStorage.vipConfig) do
        if v.smFast == 1 then
            return i - 1
        end
    end
    return #ConfigureStorage.vipConfig
end

-- 获得蓝波球可制作次数
function vipdata:recoverRecoverAddWithGoldTimes(vipLevel)
    return ConfigureStorage.vipConfig[vipLevel + 1].item_006
end


-- 获得下一级VIP 以及此阶段可制作蓝波球次数
function vipdata:getNextRecoverAddWithGold()
    local level = vipdata:getVipLevel()
    local count = vipdata:recoverRecoverAddWithGoldTimes(level)
    for i,v in ipairs(ConfigureStorage.vipConfig) do
        if v.item_006 > count then
            level = i
            count = v.item_006
            break
        end
    end
    return level, count
end
