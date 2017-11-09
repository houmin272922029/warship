marineBranchData = {
	huntTratherData = {}
}

function marineBranchData:getConfig(id)
	if ConfigureStorage.Gspot[id] then
		return deepcopy(ConfigureStorage.Gspot[id])
	end
	return nil
end

-- 海军支部是否开启
function marineBranchData:isMarineOpen(index)
	local spotId = index ~= nil and string.format("spot_%02d", index) or "spot_01"
	local lowLevel = ConfigureStorage.Gspot[spotId]["nsunlock"]
	local count = string.sub(lowLevel,7,8)
	if not storydata:getMarineId(tonumber(count)) then
		return false
	end
	local currentLevel = string.sub(storydata.record,7,8)
	return currentLevel > count
end

-- 获得海军支部数据
function marineBranchData:getMarineData( )
	local retArray = {}
	if marineBranchData.huntTratherData then
		for k,v in pairs(marineBranchData.huntTratherData) do
			table.insert(retArray,v)
		end
	end
	local function sorFun( a,b )
		return a.sort < b.sort
	end
	table.sort( retArray,sorFun )
	return retArray
end
-- 根据支部岛屿id更新数据
function marineBranchData:updateSpotDataByIdAndDic( id,dic )
	if id and dic then
		marineBranchData.huntTratherData[id] = dic
	end
end
-- 判断boos关卡是否开启  如果是true就是开启了本关
function marineBranchData:isOpenBossLevel( dic )
	return dic.score <= dic.obtainedScore
end
-- 设置海军支部数据
function marineBranchData:setMarineData( dic )
	marineBranchData.huntTratherData = dic
end
--  获取npc的信息
function marineBranchData:getNpcInfoByNpcId( npcId )
	local npcContent
	if ConfigureStorage.nsnpcgroup[npcId] then
		npcContent = ConfigureStorage.nsnpcgroup[npcId]
	end
	return npcContent
end
-- 获得boss关卡的信息
function marineBranchData:getMarineBossInfo( dic )
	local bossData = dic.boss
	for i=4,1,-1 do
		if bossData["boss_"..i]["isOpen"] ~= 0 then
			bossData["boss_"..i]["rank"] = i
			bossData["boss_"..i]["bossInfo"] = marineBranchData:getNpcInfoByNpcId( bossData["boss_"..i]["npcGroupId"] )
			return bossData["boss_"..i]
		end
	end
	bossData["boss_1"]["bossInfo"] = marineBranchData:getNpcInfoByNpcId( bossData["boss_1"]["npcGroupId"] )
	bossData["boss_1"]["rank"] = 1
	return bossData["boss_1"]
end
-- 充值所有信息
function marineBranchData:resetAllData(  )
	marineBranchData.huntTratherData = {}
end

-- 得到小关卡配置
function marineBranchData:getGateConfigById( groupId )
	local retArray = {}
	for k,v in pairs(ConfigureStorage.nsnpcgroup) do
		if k == groupId then
			return v
		end
	end
	return nil
end

function marineBranchData:getSbossLimit(  )
	if ConfigureStorage.nsbossfree then
		return ConfigureStorage.nsbossfree[1].free
	end
	return 0
end

function marineBranchData:getCanChallengeTimes(  )
	return marineBranchData:getSbossLimit(  ) + ConfigureStorage.vipConfig[userdata:getVipLevel() + 1].nsBoss
end

-- 海军支部 所有的奖励 --林绍峰
function marineBranchData:getTotalReward()
	if ConfigureStorage.Gspot then
		-- PrintTable(ConfigureStorage.Gspot)
		local totalReward = {}
		for k,v in pairs(ConfigureStorage.Gspot) do
			rewards = table.allKey( v.nsaward[1] ) -- 每个海军支部的boss奖励
			for i,v in ipairs(rewards) do
				table.insert(totalReward,v)  -- 一个个插入总奖励表中
			end
			-- PrintTable(rewards)
		end
		totalReward = table.removeRepeat(totalReward) --去除重复数据
		--PrintTable(totalReward)
		return totalReward
	else
		return nil
	end

end






