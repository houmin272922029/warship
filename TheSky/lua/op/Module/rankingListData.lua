rankingListData = {
    
    playerLevelRankingList = nil,   --船长等级排行榜  
    arenaRankingList       = nil,   --决斗排行榜  
    bossDamageRankingList  = nil,   --恶魔谷屠戮排行榜 
    seaMistRankingList     = nil,   --迷雾之海排行榜 
    leagueLevelRankingList = nil,   --公会等级排行榜

    playerLevelRankingList_PlayersRank   = nil,   --船长等级排行榜 玩家所在的排行
    arenaRankingList_PlayersRank         = nil,   --决斗排行榜   玩家所在的排行
    bossDamageRankingList_PlayersRank    = nil,   --恶魔谷屠戮排行榜   玩家所在的排行
    seaMistRankingList_PlayersRank       = nil,   --迷雾之海排行榜  玩家所在的排行
    leagueLevelRankingList_PlayersRank   = nil,   --公会等级排行榜 玩家所在的排行

    bossDamageRankingList_PlayersDamage  = nil,
    seaMistRankingList_PlayersStage      = nil,
    leagueLevelRankingList_PlayersLeagueInfo = nil,
    
} 

-- 写入数据



-- 船长排行榜
function rankingListData:WritePlayerLevelData_fromDic(dic)
    if not dic then
        return
    end
    
    --rankingListData.playerLevelRankingList = dic.rankingList

    local  function getMyDescription()
        local temp = {}
        for i = 0 ,getMyTableCount(dic.rankingList) do
            table.insert(temp, dic.rankingList[tostring(i)])
        end
        return temp
    end
    rankingListData.playerLevelRankingList = getMyDescription()
   
    print("##lsf count ", getMyTableCount(dic.rankingList) , #rankingListData.playerLevelRankingList)
    print("##lsf PrintTable 11 playerLevel RankingList: ")
    PrintTable(rankingListData.playerLevelRankingList)

    rankingListData.playerLevelRankingList_PlayersRank = dic.playerRank
    
    --print("&&lsf playerLevelRankingList_PlayersRank : ", rankingListData.playerLevelRankingList_PlayersRank  )
end


--决斗
function rankingListData:WriteArenaData_fromDic(dic)
    if not dic then
        return
    end

    local  function getMyDescription()
        local temp = {}
        for i = 0 ,getMyTableCount(dic.rankingList) do
            table.insert(temp, dic.rankingList[tostring(i)])
        end
        return temp
    end
    rankingListData.arenaRankingList = getMyDescription()

    print("##lsf PrintTable 22 arena RankingList: ")
    PrintTable(rankingListData.arenaRankingList)
    rankingListData.arenaRankingList_PlayersRank = dic.playerRank
    
end

--boss 恶魔谷屠戮排行榜
function rankingListData:WriteBossDamage_fromDic(dic)
    if not dic then
        return
    end

    local  function getMyDescription()
        local temp = {}
        for i = 0 ,getMyTableCount(dic.rankingList) do
            table.insert(temp, dic.rankingList[tostring(i)])
        end
        return temp
    end
    rankingListData.bossDamageRankingList = getMyDescription()

    print("##lsf PrintTable 33 bossDamage RankingList: ")
    PrintTable(rankingListData.bossDamageRankingList)

    rankingListData.bossDamageRankingList_PlayersRank = dic.playerInfo.rank
    rankingListData.bossDamageRankingList_PlayersDamage = dic.playerInfo.damage
    --print("&&lsf bossDamageRankingList_PlayersDamage : ", rankingListData.bossDamageRankingList_PlayersDamage  )
end


-- 迷雾之海排行榜
function rankingListData:WriteSeaMistData_fromDic(dic)
    if not dic then
        return
    end

    local  function getMyDescription()
        local temp = {}
        for i = 0 ,getMyTableCount(dic.rankingList) do
            table.insert(temp, dic.rankingList[tostring(i)])
        end
        return temp
    end
    rankingListData.seaMistRankingList = getMyDescription()

    print("##lsf PrintTable 44 seaMist RankingList: ")
    PrintTable(rankingListData.seaMistRankingList)

    rankingListData.seaMistRankingList_PlayersRank = dic.playerInfo.rank
    rankingListData.seaMistRankingList_PlayersStage = dic.playerInfo.stage

    --print("&&lsf seaMistRankingList_PlayersStage : ", rankingListData.seaMistRankingList_PlayersStage  )
end



-- 联盟排行榜
function rankingListData:WriteLeagueLevelData_fromDic(dic)
    if not dic then
        return
    end

    local  function getMyDescription()
        local temp = {}
        for i = 0 ,getMyTableCount(dic.rankingList) do
            table.insert(temp, dic.rankingList[tostring(i)])
        end
        return temp
    end
    rankingListData.leagueLevelRankingList = getMyDescription()

    print("##lsf PrintTable 55 leagueLevel RankingList: ")
    PrintTable(rankingListData.leagueLevelRankingList)

    rankingListData.leagueLevelRankingList_PlayersRank = dic.playerInfo.playerRank
    rankingListData.leagueLevelRankingList_PlayersLeagueInfo = dic.playerInfo
    
    print("&&lsf leagueLevelRankingList_PlayersRank : ", rankingListData.leagueLevelRankingList_PlayersRank  )
end




--总排行榜
function rankingListData:WriteInAllData_fromDic(dic)
 
    -- 船长排行榜
    rankingListData:WritePlayerLevelData_fromDic(dic.playerLevelRankingList)
    --决斗
    rankingListData:WriteArenaData_fromDic(dic.arenaRankingList)
    --boss 恶魔谷屠戮排行榜
    rankingListData:WriteBossDamage_fromDic(dic.bossDamageRankingList)
    -- 迷雾之海排行榜
    rankingListData:WriteSeaMistData_fromDic(dic.seaMistRankingList)
    -- 联盟排行榜
    rankingListData:WriteLeagueLevelData_fromDic(dic.leagueLevelRankingList)

end





