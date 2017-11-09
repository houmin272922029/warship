-- 用户数据缓存

continueLoginRewardData = {
    data = {},
}

-- 得到是否显示登陆奖励
function continueLoginRewardData:isPopup()
	if continueLoginRewardData.data.getFlag == nil then
		return false
	end 
	return (continueLoginRewardData.data.getFlag == 1) and true or false
end

-- 得到没有获得的奖励索引数组
function continueLoginRewardData:getUnObtainIndexArr()
	local retArr = {}
	local tempObtainArr = continueLoginRewardData:getObtain()
	for k,v in pairs(continueLoginRewardData.data.display) do
		if not table.ContainsObject(tempObtainArr, k) then
			table.insert(retArr, k)
		end 
	end
	return retArr
end

-- 得到获得的奖励个数
function continueLoginRewardData:getObtainCount()
	return table.getTableCount(continueLoginRewardData.data)
end

-- 得到获得的奖励信息
function continueLoginRewardData:getObtain()
	local retArr = {}
	for k,v in pairs(continueLoginRewardData.data.obtain) do
		table.insert(retArr, string.format("%d", v))
	end

    return retArr
end

-- 得到某个卡牌上的信息
-- 参数：index key
function continueLoginRewardData:getDisplayInfoByIndex( indexKey )
	return continueLoginRewardData.data.display[indexKey]
end

-- 获得9个卡片中的信息
function continueLoginRewardData:getAllCardData()
    return deepcopy(continueLoginRewardData.data.display)
end

--重置顶部滚动信息
function continueLoginRewardData:resetAllData()
    continueLoginRewardData.data = {}
end

