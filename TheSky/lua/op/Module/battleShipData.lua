battleShipData = {
	attrFix = {},
}

--得到船升一个等级需要的经验
function battleShipData:getNeedEXPByShipLevel(level)
	return ConfigureStorage.warship[level + 1]["exp"]
end
--得到一个英雄可以提供的经验
function battleShipData:heroCanGetEXPById(uniqueid)
	local hero = herodata:getHeroInfoByHeroUId(uniqueid) 
	local rank = hero.rank
	return ConfigureStorage.warship_exp[string.format("%s",rank)].hero
end

-- 是否可以开启战舰
function battleShipData:ifCanOpenBattleShip( )
	if userdata.level >= ConfigureStorage.levelOpen["warship"]["level"] then
		return true
	end
	return false
end

-- 返回能开启的个数
function battleShipData:canOpenNum()
	local ATTR_KEY = {
		"cnt", "parry", "cri", "resi", "hit", "dod", "atk", "def", "mp", "hp", 
	}
	for i,v in ipairs(ATTR_KEY) do
		if userdata.level >= ConfigureStorage.levelOpen["warship_" .. v].level then
			return 11 - i
		end
	end
	return 0
end

--得到船的类型
function battleShipData:getShipNameByType(_type)
	return ConfigureStorage.levelOpen["warship_" .. _type].name
end

--根据类型等到某一级别增加属性值
function battleShipData:getAttrByTypeAndLevel(attrType, level)
	local attr = 0
	if ConfigureStorage.warship[level + 1][attrType] then
		attr = ConfigureStorage.warship[level + 1][attrType]
	end
	return attr
end

--由类型得到每一条cell的信息
function battleShipData:getBattleShipInfoByType(attrType)
	local retArr = {}
	local allShipData = battleShipData.attrFix
	local attrNow = allShipData[attrType]
	retArr["level"] = attrNow.level      --等级
	retArr["expNow"] = attrNow.expNow			--现在拥有经验
	retArr["expNeed"] = ConfigureStorage.warship[attrNow.level + 1]["exp"] 		--升一级需要经验
	retArr["attr"] = battleShipData:getAttrByTypeAndLevel(attrType, attrNow.level)			--当前增加属性值
	return retArr
end

function battleShipData:getAllBattleShipInfo(  )
	local allShipData = battleShipData.attrFix
end

function battleShipData:resetAllData()
    battleShipData.attrFix = {}
end